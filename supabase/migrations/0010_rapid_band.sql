/*
  # Update dishes table policies

  1. Changes
    - Add policy to allow public access to dishes table
    - Keep existing policies for management
  
  2. Security
    - Anyone can view available dishes
    - Restaurant managers can still manage their dishes
*/

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can view available dishes" ON dishes;
DROP POLICY IF EXISTS "Restaurant managers can manage dishes" ON dishes;

-- Create new policies
CREATE POLICY "Anyone can view available dishes"
ON dishes FOR SELECT
USING (true);

CREATE POLICY "Restaurant managers can manage dishes"
ON dishes
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE user_id = auth.uid()
    AND role = 'restaurant_manager'
  )
);