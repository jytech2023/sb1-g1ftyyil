/*
  # Add restaurant_id to dishes table

  1. Changes
    - Add restaurant_id column to dishes table
    - Update existing dishes with restaurant_id based on restaurant handle
    - Add foreign key constraint

  2. Security
    - No changes to RLS policies needed
*/

-- Add restaurant_id column
ALTER TABLE dishes
ADD COLUMN restaurant_id uuid REFERENCES restaurants(id);

-- Update existing dishes with restaurant_id
UPDATE dishes d
SET restaurant_id = r.id
FROM restaurants r
WHERE r.handle = 'hawi'
AND d.dish_name IN (
  'Hawaiian BBQ Chicken',
  'Kalua Pork',
  'Loco Moco',
  'BBQ Mix',
  'Extra Rice',
  'Macaroni Salad',
  'BBQ Short Ribs',
  'Chicken Katsu',
  'Teriyaki Chicken',
  'Chicken Katsu & BBQ Chicken',
  'BBQ Short Ribs & BBQ Chicken',
  'Chicken Saimin',
  'Beef Chow Fun',
  'BBQ Chicken (side)',
  'Spam Musubi',
  'Hawaiian Sun Fruit Punch',
  'Passion Orange Drink'
);