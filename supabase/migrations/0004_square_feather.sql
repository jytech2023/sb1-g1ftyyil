/*
  # Add more Hawi Hawaiian BBQ dishes

  1. New Data
    - Add additional menu items from Hawi Hawaiian BBQ's menu
    - Categories include:
      - Plate Lunches
      - Mix Plates
      - Noodles
      - Sides
      - Beverages
*/

-- Insert additional Hawi Hawaiian BBQ dishes
INSERT INTO dishes (dish_name, price, description, picture, flags, restaurant_manager_id)
VALUES 
  -- Plate Lunches
  (
    'BBQ Short Ribs',
    17.99,
    'Marinated beef short ribs grilled to perfection',
    'https://images.unsplash.com/photo-1544025162-d76694265947',
    '{"category": "plate_lunch", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Chicken Katsu',
    15.99,
    'Breaded chicken cutlet served with katsu sauce',
    'https://images.unsplash.com/photo-1604579278540-db35e3c1dd69',
    '{"category": "plate_lunch", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Teriyaki Chicken',
    15.99,
    'Grilled chicken with our house teriyaki sauce',
    'https://images.unsplash.com/photo-1546069901-d5bfd2cbfb1f',
    '{"category": "plate_lunch", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  
  -- Mix Plates
  (
    'Chicken Katsu & BBQ Chicken',
    18.99,
    'Combination of our popular Chicken Katsu and BBQ Chicken',
    'https://images.unsplash.com/photo-1567337710282-00832b415979',
    '{"category": "mix_plate", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'BBQ Short Ribs & BBQ Chicken',
    19.99,
    'Best of both worlds with our BBQ Short Ribs and BBQ Chicken',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
    '{"category": "mix_plate", "serving": "1", "includes": ["steamed rice", "macaroni salad"]}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),

  -- Noodles
  (
    'Chicken Saimin',
    12.99,
    'Hawaiian noodle soup with char siu, green onions, and fish cake',
    'https://images.unsplash.com/photo-1569718212165-3a8278d5f624',
    '{"category": "noodles", "serving": "1"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Beef Chow Fun',
    14.99,
    'Stir-fried wide rice noodles with beef and vegetables',
    'https://images.unsplash.com/photo-1552611052-33e04de081de',
    '{"category": "noodles", "serving": "1"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),

  -- Sides
  (
    'BBQ Chicken (side)',
    8.99,
    'Side portion of our famous BBQ Chicken',
    'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b',
    '{"category": "side", "serving": "1"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Spam Musubi',
    3.99,
    'Grilled Spam on rice wrapped in nori',
    'https://images.unsplash.com/photo-1553621042-f6e147245754',
    '{"category": "side", "serving": "1"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),

  -- Beverages
  (
    'Hawaiian Sun Fruit Punch',
    2.99,
    'Classic Hawaiian fruit punch',
    'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd',
    '{"category": "beverage", "serving": "1", "size": "can"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  ),
  (
    'Passion Orange Drink',
    2.99,
    'Refreshing passion orange flavored drink',
    'https://images.unsplash.com/photo-1544145945-f90425340c7e',
    '{"category": "beverage", "serving": "1", "size": "can"}',
    'e7d9f012-c8a1-4b5d-9e3f-2d8b4c6a5f1e'
  );