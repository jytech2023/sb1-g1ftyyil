/*
  # Update order items policies

  1. Changes
    - Add new policy to allow anyone to insert new order items
    - Keep existing policies for consistency

  2. Security
    - Maintains RLS on order_items table
    - Allows authenticated users to insert new order items without restrictions
*/

-- Drop existing insert policy if it exists
DROP POLICY IF EXISTS "Anyone can create order items" ON order_items;

-- Create new policy for inserting order items
CREATE POLICY "Anyone can insert order items"
  ON order_items
  FOR INSERT
  TO authenticated
  WITH CHECK (true);  -- Allow any authenticated user to insert

-- Keep existing select policy
DROP POLICY IF EXISTS "Anyone can view order items" ON order_items;
CREATE POLICY "Anyone can view order items"
  ON order_items
  FOR SELECT
  TO authenticated
  USING (true);