/*
  # Fix orders table configuration
  
  1. Changes
    - Drop and recreate orders table with correct structure
    - Enable RLS and create proper policies
    - Add trigger for order status tracking
  
  2. Security
    - Enable RLS
    - Allow authenticated users to create orders
    - Allow users to view their own orders
*/

-- Drop dependent tables first
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS order_records CASCADE;
DROP TABLE IF EXISTS orders CASCADE;

-- Create orders table
CREATE TABLE orders (
  order_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid NOT NULL REFERENCES auth.users(id),
  delivery_name text NOT NULL,
  delivery_phone text NOT NULL,
  delivery_address text NOT NULL,
  total_amount decimal(10, 2) NOT NULL,
  status order_status DEFAULT 'pending',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create order_items table
CREATE TABLE order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  dish_id uuid NOT NULL REFERENCES dishes(dish_id),
  quantity integer NOT NULL CHECK (quantity > 0),
  price_at_time decimal(10, 2) NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create order_records table
CREATE TABLE order_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  status order_status NOT NULL,
  note text,
  change_time timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_records ENABLE ROW LEVEL SECURITY;

-- Create policies for orders
CREATE POLICY "Users can view their own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

CREATE POLICY "Users can create orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

-- Create policies for order_items
CREATE POLICY "Users can view their order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

CREATE POLICY "Users can create order items"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

-- Create policies for order_records
CREATE POLICY "Users can view their order records"
  ON order_records FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.order_id = order_records.order_id
      AND orders.customer_id = auth.uid()
    )
  );

-- Create trigger for updated_at
CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create trigger for initial order record
CREATE OR REPLACE FUNCTION create_initial_order_record()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO order_records (order_id, status, note)
  VALUES (NEW.order_id, NEW.status, 'Order created');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_order_record
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION create_initial_order_record();