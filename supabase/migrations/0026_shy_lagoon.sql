/*
  # Remove total_amount from orders table
  
  1. Changes
    - Remove total_amount column from orders table
    - Update submit_order function to remove total_amount parameter
    - Add get_order_total function to calculate total from order items
  
  2. Security
    - Function permissions remain unchanged
    - RLS policies unaffected
*/

-- Create function to calculate order total
CREATE OR REPLACE FUNCTION get_order_total(p_order_id uuid)
RETURNS decimal
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT COALESCE(SUM(quantity * price_at_time), 0)
  FROM order_items
  WHERE order_id = p_order_id;
$$;

-- Update submit_order function to remove total_amount parameter
CREATE OR REPLACE FUNCTION submit_order(
  p_customer_id uuid,
  p_delivery_name text,
  p_delivery_phone text,
  p_delivery_address text,
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
  v_restaurant_id uuid;
  v_restaurant_address text;
BEGIN
  -- Get the restaurant ID and address from the first item
  SELECT r.id, r.address
  INTO v_restaurant_id, v_restaurant_address
  FROM restaurants r
  JOIN dishes d ON d.restaurant_id = r.id
  WHERE d.dish_id = (p_items->0->>'dish_id')::uuid;

  -- Create the order
  INSERT INTO orders (
    customer_id,
    delivery_name,
    delivery_phone,
    delivery_address,
    delivery_address_from,
    restaurant_id,
    status
  ) VALUES (
    p_customer_id,
    p_delivery_name,
    p_delivery_phone,
    p_delivery_address,
    v_restaurant_address,
    v_restaurant_id,
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
$$;

-- Drop total_amount column
ALTER TABLE orders DROP COLUMN IF EXISTS total_amount;

-- Grant execute permission on new function
GRANT EXECUTE ON FUNCTION get_order_total TO authenticated;