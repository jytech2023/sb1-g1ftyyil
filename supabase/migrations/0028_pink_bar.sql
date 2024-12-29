/*
  # Update orders table and policies

  1. Changes
    - Add contact person fields to orders table
    - Update order items policies to allow unrestricted inserts

  2. Security
    - Maintains RLS on all tables
    - Allows authenticated users to insert order items without restrictions
*/

-- Add contact person fields to orders table
ALTER TABLE orders
ADD COLUMN IF NOT EXISTS contact_person_name text,
ADD COLUMN IF NOT EXISTS contact_person_phone text,
ADD COLUMN IF NOT EXISTS contact_person_address text;

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can insert order items" ON order_items;
DROP POLICY IF EXISTS "Anyone can view order items" ON order_items;

-- Create new policies for order items
CREATE POLICY "Anyone can insert order items"
  ON order_items
  FOR INSERT
  TO authenticated
  WITH CHECK (true);  -- Allow any authenticated user to insert

CREATE POLICY "Anyone can view order items"
  ON order_items
  FOR SELECT
  TO authenticated
  USING (true);  -- Allow any authenticated user to view

-- Update submit_order function to include contact person details
CREATE OR REPLACE FUNCTION submit_order(
  p_customer_id uuid,
  p_delivery_name text,
  p_delivery_phone text,
  p_delivery_address text,
  p_contact_person_name text,
  p_contact_person_phone text,
  p_contact_person_address text,
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
    contact_person_name,
    contact_person_phone,
    contact_person_address,
    status
  ) VALUES (
    p_customer_id,
    p_delivery_name,
    p_delivery_phone,
    p_delivery_address,
    v_restaurant_address,
    v_restaurant_id,
    p_contact_person_name,
    p_contact_person_phone,
    p_contact_person_address,
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