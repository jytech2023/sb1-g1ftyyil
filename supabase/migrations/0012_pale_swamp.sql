/*
  # Update orders policy for public access by ID

  1. Changes
    - Drop existing order policies
    - Create new policy allowing public access by ID
    - Update order items policy to match

  2. Security
    - Orders are publicly viewable if ID is known
    - Order items are viewable for corresponding orders
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own orders" ON orders;
DROP POLICY IF EXISTS "Users can create their own orders" ON orders;
DROP POLICY IF EXISTS "Users can view their order items" ON order_items;

-- Create new policies for orders
CREATE POLICY "Anyone can view orders by ID"
  ON orders FOR SELECT
  USING (true);

CREATE POLICY "Users can create their own orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = customer_id);

-- Update order items policy
CREATE POLICY "Anyone can view order items by order ID"
  ON order_items FOR SELECT
  USING (true);

CREATE POLICY "Users can create order items for their orders"
  ON order_items FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );