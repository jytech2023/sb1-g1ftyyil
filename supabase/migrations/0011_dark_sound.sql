/*
  # Update orders schema with proper relationships

  1. Changes
    - Drop existing constraints and policies
    - Update orders table structure
    - Create order_items junction table
    - Add new RLS policies
    - Preserve existing order_records table

  2. Security
    - Enable RLS on all tables
    - Add appropriate policies
*/

-- First, drop dependent policies and constraints
DROP POLICY IF EXISTS "Users can view related order records" ON order_records;
ALTER TABLE order_records DROP CONSTRAINT IF EXISTS order_records_order_id_fkey;

-- Now we can safely modify the orders table
ALTER TABLE orders
DROP COLUMN IF EXISTS dish_id,
DROP COLUMN IF EXISTS quantity,
ADD COLUMN IF NOT EXISTS delivery_name TEXT,
ADD COLUMN IF NOT EXISTS delivery_phone TEXT,
ADD COLUMN IF NOT EXISTS delivery_address TEXT;

-- Create order_items junction table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  dish_id uuid NOT NULL REFERENCES dishes(dish_id),
  quantity INT NOT NULL CHECK (quantity > 0),
  price_at_time DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS on order_items
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Recreate the foreign key for order_records
ALTER TABLE order_records
ADD CONSTRAINT order_records_order_id_fkey 
FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE;

-- Create policies for orders
CREATE POLICY "Users can view their own orders"
  ON orders FOR SELECT
  USING (auth.uid() = customer_id);

CREATE POLICY "Users can create their own orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = customer_id);

-- Create policies for order_items
CREATE POLICY "Users can view their order items"
  ON order_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

CREATE POLICY "Users can create order items"
  ON order_items FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

-- Recreate the order_records policy
CREATE POLICY "Users can view related order records"
  ON order_records FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_records.order_id
      AND orders.customer_id = auth.uid()
    )
  );