/*
  # Add image column to restaurants table

  1. Changes
    - Add image column to restaurants table
    - Update existing restaurant records with images
*/

-- Add image column
ALTER TABLE restaurants
ADD COLUMN IF NOT EXISTS image text;

-- Update existing restaurants with images
UPDATE restaurants
SET image = CASE
  WHEN name = 'Hawi Hawaiian BBQ' THEN 'https://images.unsplash.com/photo-1534604973900-c43ab4c2e0ab?auto=format&fit=crop&w=800&q=80'
  WHEN name = 'test 1' THEN 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80'
  WHEN name = 'chan e' THEN 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80'
  WHEN name = 'simon2' THEN 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=800&q=80'
  ELSE 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80'
END
WHERE image IS NULL;