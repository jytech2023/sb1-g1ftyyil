/*
  # Update orders table schema

  1. Changes
    - Drop existing cart table if exists
    - Create orders table with enhanced fields
    - Add RLS policies with existence checks
    
  2. Security
    - Enable RLS on orders table
    - Add policies for customers to manage their orders
*/

-- Drop existing cart table
DROP TABLE IF EXISTS cart;

-- Create orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES auth.users(id),
  dish_id uuid NOT NULL REFERENCES dishes(dish_id),
  quantity INT DEFAULT 1,
  status TEXT NOT NULL DEFAULT 'pending',
  order_date TIMESTAMPTZ DEFAULT now(),
  total_amount DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Customers can view their own orders" ON orders;
    DROP POLICY IF EXISTS "Customers can create orders" ON orders;
    DROP POLICY IF EXISTS "Customers can update their own orders" ON orders;
EXCEPTION
    WHEN undefined_object THEN
        NULL;
END $$;

-- Create new policies
CREATE POLICY "Customers can view their own orders"
  ON orders
  FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

CREATE POLICY "Customers can create orders"
  ON orders
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = customer_id);

CREATE POLICY "Customers can update their own orders"
  ON orders
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id);

-- Add trigger for updated_at if it doesn't exist
DO $$ 
BEGIN
    DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
    
    CREATE TRIGGER update_orders_updated_at
        BEFORE UPDATE ON orders
        FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();
EXCEPTION
    WHEN undefined_object THEN
        NULL;
END $$;