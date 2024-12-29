/*
  # Create restaurants table and add initial data

  1. New Tables
    - `restaurants` (if not exists)
      - `id` (uuid, primary key)
      - `name` (text)
      - `website` (text, optional)
      - `phone` (text, optional)
      - `address` (text, optional)
      - `handle` (text, unique)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `restaurants` table
    - Add policies for viewing and managing restaurants (if they don't exist)
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

-- Create policies if they don't exist
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'restaurants' 
    AND policyname = 'Anyone can view restaurants'
  ) THEN
    CREATE POLICY "Anyone can view restaurants"
      ON restaurants
      FOR SELECT
      TO authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'restaurants' 
    AND policyname = 'Restaurant managers can manage their restaurant'
  ) THEN
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
  END IF;
END $$;

-- Add trigger if it doesn't exist
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger 
    WHERE tgname = 'update_restaurants_updated_at'
  ) THEN
    CREATE TRIGGER update_restaurants_updated_at
      BEFORE UPDATE ON restaurants
      FOR EACH ROW
      EXECUTE PROCEDURE update_updated_at_column();
  END IF;
END $$;

-- Insert restaurant data if not exists
INSERT INTO restaurants (id, name, website, phone, address, handle, created_at) 
SELECT
  '3b9644d4-4cb7-4edc-84ba-c223abf366d5',
  'Hawi Hawaiian BBQ',
  'https://hawihawaiianbbqca.com/',
  '650-866-3328',
  '307 Grand Ave South San Francisco CA 94080',
  'hawi',
  '2024-11-11 17:46:00.744237+00'
WHERE NOT EXISTS (
  SELECT 1 FROM restaurants WHERE id = '3b9644d4-4cb7-4edc-84ba-c223abf366d5'
);

INSERT INTO restaurants (id, name, website, phone, address, handle, created_at) 
SELECT
  'b518dd86-c0e4-43c2-8805-5c8f031c7b30',
  'test 1',
  'www.google.com',
  '206-123-1234',
  '123 Main Street, Seattle, Wa, 98103',
  'seattlelin',
  '2024-12-07 02:58:16.003094+00'
WHERE NOT EXISTS (
  SELECT 1 FROM restaurants WHERE id = 'b518dd86-c0e4-43c2-8805-5c8f031c7b30'
);

INSERT INTO restaurants (id, name, website, phone, address, handle, created_at) 
SELECT
  'b61b47e5-6bff-4135-89c1-266dea8af2a5',
  'chan e',
  'www.chane.com',
  '012-345-678',
  '96 Albany Street, New York, USA',
  'chane',
  '2024-12-07 07:07:11.484363+00'
WHERE NOT EXISTS (
  SELECT 1 FROM restaurants WHERE id = 'b61b47e5-6bff-4135-89c1-266dea8af2a5'
);

INSERT INTO restaurants (id, name, website, phone, address, handle, created_at) 
SELECT
  'f3c89975-efa6-4b77-979f-c125f6d288bf',
  'simon2',
  null,
  null,
  null,
  'simon2',
  '2024-12-07 07:17:59.504788+00'
WHERE NOT EXISTS (
  SELECT 1 FROM restaurants WHERE id = 'f3c89975-efa6-4b77-979f-c125f6d288bf'
);