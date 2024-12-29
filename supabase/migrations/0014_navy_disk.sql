/*
  # Fix Order Tables Permissions

  1. Changes
    - Add missing RLS policies for order_items
    - Update orders table policies
    - Grant necessary permissions

  2. Security
    - Enable public access for authenticated users
    - Maintain data integrity with proper checks
*/

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can create their own orders" ON orders;
DROP POLICY IF EXISTS "Anyone can view orders by ID" ON orders;
DROP POLICY IF EXISTS "Anyone can view order items by order ID" ON order_items;
DROP POLICY IF EXISTS "Users can create order items for their orders" ON order_items;

-- Create new policies for orders
CREATE POLICY "Enable all operations for authenticated users"
  ON orders
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (auth.uid() = customer_id);

-- Create new policies for order_items
CREATE POLICY "Enable all operations for authenticated users"
  ON order_items
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

-- Ensure RLS is enabled
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;