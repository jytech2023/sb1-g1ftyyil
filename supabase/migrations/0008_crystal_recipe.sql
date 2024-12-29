/*
  # Update Hawi Hawaiian BBQ dishes

  1. Changes
    - Update existing Hawi Hawaiian BBQ dishes to link them to the restaurant manager's user ID
    - This ensures the menu items are properly associated with the restaurant manager

  2. Security
    - No changes to RLS policies needed
    - Existing policies already handle access control
*/

-- Update Hawi Hawaiian BBQ dishes to link them to the restaurant manager's user ID
UPDATE dishes
SET restaurant_manager_id = (
  SELECT user_id 
  FROM users 
  WHERE email = 'manager@hawihawaiianbbq.com'
)
WHERE dish_name IN (
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