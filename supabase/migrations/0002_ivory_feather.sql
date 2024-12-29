/*
  # Add Sample Restaurant Data

  1. New Data
    - Restaurant manager users
    - Sample dishes for each restaurant
    
  2. Content
    - Three restaurants with different cuisines
    - Multiple dishes per restaurant with varied prices
    - Realistic menu items and descriptions
*/

-- Insert restaurant managers
INSERT INTO users (user_id, name, email, phone_number, role) VALUES
  ('d11b3c7a-b87c-4a63-b848-1b0d33e4f3e2', 'John Smith', 'john@gourmetgatherings.com', '+1234567890', 'restaurant_manager'),
  ('f892b344-d981-4a8b-8e31-1b2aa365f128', 'Lisa Chen', 'lisa@asianfusion.com', '+1234567891', 'restaurant_manager'),
  ('c5d8e293-4b1a-4c7d-9d4e-6f8a2b3c4d5e', 'Maria Santos', 'maria@mediterraneanfeast.com', '+1234567892', 'restaurant_manager');

-- Insert dishes for Gourmet Gatherings
INSERT INTO dishes (dish_name, price, description, picture, flags) VALUES
  ('Executive Lunch Box', 24.99, 'Premium sandwich, salad, fresh fruit, and gourmet cookie. Perfect for business meetings.', 'https://images.unsplash.com/photo-1521305916504-4a1121188589', '{"dietary": ["vegetarian_option"], "allergens": ["nuts"]}'),
  ('Artisanal Cheese Platter', 89.99, 'Selection of premium cheeses, dried fruits, nuts, and crackers. Serves 10-12.', 'https://images.unsplash.com/photo-1452195100486-9cc805987862', '{"dietary": ["vegetarian"], "serving": "10-12"}'),
  ('Corporate Breakfast Bundle', 199.99, 'Assorted pastries, fresh fruit, yogurt parfaits, and coffee service. Serves 20.', 'https://images.unsplash.com/photo-1513442542250-854d436a73f2', '{"dietary": ["vegetarian_option"], "serving": "20"}');

-- Insert dishes for Asian Fusion
INSERT INTO dishes (dish_name, price, description, picture, flags) VALUES
  ('Sushi Party Platter', 129.99, 'Premium selection of rolls including California, Spicy Tuna, and Dragon Roll. 60 pieces.', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', '{"dietary": ["seafood"], "pieces": 60}'),
  ('Dim Sum Collection', 89.99, 'Assorted dumplings, bao buns, and spring rolls. Serves 8-10.', 'https://images.unsplash.com/photo-1563245372-f21724e3856d', '{"dietary": ["contains_pork"], "serving": "8-10"}'),
  ('Asian Noodle Bar', 179.99, 'Build-your-own noodle station with various toppings and sauces. Serves 15.', 'https://images.unsplash.com/photo-1552611052-33e04de081de', '{"dietary": ["vegetarian_option"], "serving": "15"}');

-- Insert dishes for Mediterranean Feast
INSERT INTO dishes (dish_name, price, description, picture, flags) VALUES
  ('Mediterranean Mezze', 149.99, 'Hummus, baba ganoush, falafel, dolmas, and pita bread. Serves 15-20.', 'https://images.unsplash.com/photo-1542345812-d98b5cd6cf98', '{"dietary": ["vegan", "vegetarian"], "serving": "15-20"}'),
  ('Grilled Kebab Platter', 199.99, 'Assorted chicken, beef, and lamb kebabs with grilled vegetables. Serves 20.', 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143', '{"dietary": ["halal_option"], "serving": "20"}'),
  ('Greek Salad Bar', 129.99, 'Fresh Greek salad ingredients with feta cheese and dressings. Serves 15.', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', '{"dietary": ["vegetarian"], "serving": "15"}');