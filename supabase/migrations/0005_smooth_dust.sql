/*
  # Add restaurants table and data

  1. New Table
    - `restaurants`
      - `id` (uuid, primary key)
      - `name` (text)
      - `website` (text, nullable)
      - `phone` (text)
      - `address` (text)
      - `handle` (text, unique)
      - `created_at` (timestamp with timezone)

  2. Security
    - Enable RLS on restaurants table
    - Add policies for reading and managing restaurants
*/

-- Create restaurants table
CREATE TABLE IF NOT EXISTS restaurants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  website text,
  phone text,
  address text,
  handle text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can view restaurants"
  ON restaurants
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Restaurant managers can manage their restaurant"
  ON restaurants
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.user_id = auth.uid()
      AND users.role = 'restaurant_manager'
    )
  );

-- Add trigger for updated_at
CREATE TRIGGER update_restaurants_updated_at
  BEFORE UPDATE ON restaurants
  FOR EACH ROW
  EXECUTE PROCEDURE update_updated_at_column();

-- Insert restaurant data
INSERT INTO restaurants (id, name, website, phone, address, handle, created_at) 
VALUES 
  (
    '3b9644d4-4cb7-4edc-84ba-c223abf366d5',
    'Hawi Hawaiian BBQ',
    'https://hawihawaiianbbqca.com/',
    '650-866-3328',
    '307 Grand Ave South San Francisco CA 94080',
    'hawi',
    '2024-11-11 17:46:00.744237+00'
  ),
  (
    'b518dd86-c0e4-43c2-8805-5c8f031c7b30',
    'test 1',
    'www.google.com',
    '206-123-1234',
    '123 Main Street, Seattle, Wa, 98103',
    'seattlelin',
    '2024-12-07 02:58:16.003094+00'
  ),
  (
    'b61b47e5-6bff-4135-89c1-266dea8af2a5',
    'chan e',
    'www.chane.com',
    '012-345-678',
    '96 Albany Street, New York, USA',
    'chane',
    '2024-12-07 07:07:11.484363+00'
  ),
  (
    'f3c89975-efa6-4b77-979f-c125f6d288bf',
    'simon2',
    null,
    null,
    null,
    'simon2',
    '2024-12-07 07:17:59.504788+00'
  );