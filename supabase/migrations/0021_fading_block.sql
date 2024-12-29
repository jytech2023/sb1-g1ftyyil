/*
  # Make customer_id optional in orders table

  1. Changes
    - Make customer_id column optional in orders table
    - Update submit_order function to handle null customer_id
    - Update RLS policies to allow guest orders
*/

-- Make customer_id optional
ALTER TABLE orders
ALTER COLUMN customer_id DROP NOT NULL;

-- Update submit_order function to handle null customer_id
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
  -- Start transaction
  BEGIN
    -- Create the order
    INSERT INTO orders (
      customer_id,
      delivery_name,
      delivery_phone,
      delivery_address,
      total_amount,
      status
    ) VALUES (
      p_customer_id,  -- Can be NULL for guest orders
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
      RAISE;
  END;
END;
$$;

-- Update RLS policies for orders
DROP POLICY IF EXISTS "Users can view their own orders" ON orders;
DROP POLICY IF EXISTS "Users can create orders" ON orders;

CREATE POLICY "Users can view their orders"
  ON orders FOR SELECT
  TO authenticated
  USING (
    customer_id IS NULL OR  -- Allow viewing guest orders
    customer_id = auth.uid()
  );

CREATE POLICY "Anyone can create orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id IS NULL OR  -- Allow guest orders
    customer_id = auth.uid()
  );

-- Update RLS policies for order_items
DROP POLICY IF EXISTS "Users can view their order items" ON order_items;
DROP POLICY IF EXISTS "Users can create order items" ON order_items;

CREATE POLICY "Anyone can view order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Anyone can create order items"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Update RLS policies for order_records
DROP POLICY IF EXISTS "Users can view their order records" ON order_records;

CREATE POLICY "Anyone can view order records"
  ON order_records FOR SELECT
  TO authenticated
  USING (true);