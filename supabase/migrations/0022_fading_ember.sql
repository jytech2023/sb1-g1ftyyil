/*
  # Fix Guest Orders

  1. Changes
    - Update RLS policies to allow guest orders (null customer_id)
    - Add policies for order items and records
    - Fix submit_order function to handle guest orders properly

  2. Security
    - Maintain RLS while allowing guest orders
    - Ensure data integrity for guest orders
*/

-- Update RLS policies for orders
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON orders;
DROP POLICY IF EXISTS "Anyone can create orders" ON orders;

CREATE POLICY "Allow guest and authenticated user orders"
  ON orders
  FOR ALL
  TO authenticated
  USING (true)  -- Allow reading all orders
  WITH CHECK (
    customer_id IS NULL OR  -- Allow guest orders
    customer_id = auth.uid() -- Allow authenticated user orders
  );

-- Update RLS policies for order_items
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON order_items;

CREATE POLICY "Allow all order items operations"
  ON order_items
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Update RLS policies for order_records
DROP POLICY IF EXISTS "Anyone can view order records" ON order_records;

CREATE POLICY "Allow all order records operations"
  ON order_records
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Update submit_order function to better handle guest orders
CREATE OR REPLACE FUNCTION submit_order(
  p_customer_id uuid,
  p_delivery_name text,
  p_delivery_phone text,
  p_delivery_address text,
  p_total_amount decimal,
  p_items jsonb
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_order_id uuid;
  v_item jsonb;
  v_available boolean;
BEGIN
  -- Create the order
  INSERT INTO orders (
    customer_id,      -- Can be NULL for guest orders
    delivery_name,
    delivery_phone,
    delivery_address,
    total_amount,
    status
  ) VALUES (
    p_customer_id,
    p_delivery_name,
    p_delivery_phone,
    p_delivery_address,
    p_total_amount,
    'pending'
  ) RETURNING order_id INTO v_order_id;

  -- Process each item
  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    -- Check and update dish quantity
    SELECT check_and_update_dish_quantity(
      (v_item->>'dish_id')::uuid,
      (v_item->>'quantity')::integer
    ) INTO v_available;

    IF NOT v_available THEN
      RAISE EXCEPTION 'Insufficient quantity for dish %', (v_item->>'dish_id');
    END IF;

    -- Insert order item
    INSERT INTO order_items (
      order_id,
      dish_id,
      quantity,
      price_at_time
    ) VALUES (
      v_order_id,
      (v_item->>'dish_id')::uuid,
      (v_item->>'quantity')::integer,
      (v_item->>'price')::decimal
    );
  END LOOP;

  RETURN v_order_id;
EXCEPTION
  WHEN OTHERS THEN
    -- Re-raise the error
    RAISE;
END;
$$;