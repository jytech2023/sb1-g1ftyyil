/*
  # Initial Schema Setup

  1. New Tables
    - users
      - User accounts with roles (restaurant_manager, customer, driver)
    - orders
      - Order details including delivery and payment information
    - dishes
      - Menu items with pricing and availability
    - cart
      - Temporary storage for customer selections
    - order_records
      - Order history and status changes

  2. Security
    - Enable RLS on all tables
    - Add policies for proper data access control

  3. Enums
    - user_role
    - payment_status
    - order_status
*/

-- Create enum types
CREATE TYPE user_role AS ENUM ('restaurant_manager', 'customer', 'driver');
CREATE TYPE payment_status AS ENUM ('paid', 'unpaid', 'deposit');
CREATE TYPE order_status AS ENUM ('pending', 'preparing', 'ready', 'on_the_way', 'delivered', 'cancelled');

-- Create users table
CREATE TABLE users (
    user_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    role user_role NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create dishes table
CREATE TABLE dishes (
    dish_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    dish_name VARCHAR(255) NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    picture TEXT,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    flags JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create orders table
CREATE TABLE orders (
    order_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_manager_id uuid NOT NULL REFERENCES users(user_id),
    customer_id uuid NOT NULL REFERENCES users(user_id),
    driver_id uuid REFERENCES users(user_id),
    order_time TIMESTAMPTZ DEFAULT now(),
    delivery_address_from TEXT NOT NULL,
    delivery_address_to TEXT NOT NULL,
    delivery_cost DECIMAL(10, 2),
    contact_person_name VARCHAR(255) NOT NULL,
    contact_person_phone VARCHAR(15) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    payment_status payment_status DEFAULT 'unpaid',
    order_status order_status DEFAULT 'pending',
    notification_status BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create cart table
CREATE TABLE cart (
    cart_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id uuid NOT NULL REFERENCES users(user_id),
    dish_id uuid NOT NULL REFERENCES dishes(dish_id),
    quantity INT DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create order_records table
CREATE TABLE order_records (
    record_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid NOT NULL REFERENCES orders(order_id),
    dish_id uuid REFERENCES dishes(dish_id),
    quantity INT,
    price DECIMAL(10, 2),
    change_time TIMESTAMPTZ DEFAULT now(),
    status order_status NOT NULL,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE dishes ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_records ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies

-- Users policies
CREATE POLICY "Users can read own data" ON users
    FOR SELECT TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update own data" ON users
    FOR UPDATE TO authenticated
    USING (auth.uid() = user_id);

-- Dishes policies
CREATE POLICY "Anyone can view available dishes" ON dishes
    FOR SELECT TO authenticated
    USING (availability = true);

CREATE POLICY "Restaurant managers can manage dishes" ON dishes
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE user_id = auth.uid()
            AND role = 'restaurant_manager'
        )
    );

-- Cart policies
CREATE POLICY "Customers can manage own cart" ON cart
    FOR ALL TO authenticated
    USING (customer_id = auth.uid());

-- Orders policies
CREATE POLICY "Users can view own orders" ON orders
    FOR SELECT TO authenticated
    USING (
        customer_id = auth.uid() OR
        restaurant_manager_id = auth.uid() OR
        driver_id = auth.uid()
    );

CREATE POLICY "Customers can create orders" ON orders
    FOR INSERT TO authenticated
    WITH CHECK (customer_id = auth.uid());

-- Order records policies
CREATE POLICY "Users can view related order records" ON order_records
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM orders
            WHERE orders.order_id = order_records.order_id
            AND (
                orders.customer_id = auth.uid() OR
                orders.restaurant_manager_id = auth.uid() OR
                orders.driver_id = auth.uid()
            )
        )
    );

-- Create updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_dishes_updated_at
    BEFORE UPDATE ON dishes
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();