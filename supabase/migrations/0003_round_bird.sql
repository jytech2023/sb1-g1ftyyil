/*
  # Add Hawi Hawaiian BBQ restaurant data

  1. Schema Changes
    - Add restaurant_manager_id column to dishes table
  2. New Data
    - Add restaurant manager
    - Add menu items
*/

-- Add restaurant_manager_id column to dishes table
ALTER TABLE dishes 
ADD COLUMN restaurant_manager_id uuid REFERENCES users(user_id);

-- Insert Hawi Hawaiian BBQ manager
INSERT INTO users (user_id, name, email, phone_number, role)
VALUES (
  'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e',
  'Hawi Hawaiian BBQ',
  'manager@hawihawaiianbbq.com',
  '(510) 796-3387',
  'restaurant_manager'
);

-- Insert Hawi Hawaiian BBQ dishes
INSERT INTO dishes (dish_name, price, description, picture, flags, restaurant_manager_id)
VALUES 
  (
    'Hawaiian BBQ Chicken',
    15.99,
    'Grilled boneless chicken marinated in our special Hawaiian BBQ sauce',
    'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b',
    '{"category": "plate_lunch", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Kalua Pork',
    15.99,
    'Traditional Hawaiian pulled pork',
    'https://images.unsplash.com/photo-1544025162-d76694265947',
    '{"category": "plate_lunch", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Loco Moco',
    16.99,
    'Hamburg steak topped with 2 eggs and brown gravy',
    'https://images.unsplash.com/photo-1580476262798-bddd9f4b7369',
    '{"category": "plate_lunch", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'BBQ Mix',
    18.99,
    'Hawaiian BBQ Chicken and BBQ Beef',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
    '{"category": "mix_plate", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Extra Rice',
    2.50,
    'Steamed white rice',
    'https://images.unsplash.com/photo-1516684732162-798a0062be99',
    '{"category": "side", "serving": "1"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Macaroni Salad',
    2.99,
    'Classic Hawaiian macaroni salad',
    'https://images.unsplash.com/photo-1595295333158-4742f28fbd85',
    '{"category": "side", "serving": "1"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  );