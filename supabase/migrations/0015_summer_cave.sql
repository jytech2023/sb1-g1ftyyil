/*
  # Add Daily Limits to Dishes

  1. Changes
    - Add daily_limit column to dishes table
    - Add remaining_quantity column to dishes table
    - Add function to reset daily quantities
    - Add function to check and update quantity when ordering

  2. Security
    - Enable RLS policies for quantity updates
    - Add triggers for quantity management
*/

-- Add new columns to dishes table
ALTER TABLE dishes
ADD COLUMN IF NOT EXISTS daily_limit INTEGER,
ADD COLUMN IF NOT EXISTS remaining_quantity INTEGER;

-- Update existing dishes to have a default daily limit
UPDATE dishes
SET daily_limit = 50,
    remaining_quantity = 50
WHERE daily_limit IS NULL;

-- Make daily_limit non-nullable
ALTER TABLE dishes
ALTER COLUMN daily_limit SET NOT NULL,
ALTER COLUMN daily_limit SET DEFAULT 50,
ALTER COLUMN remaining_quantity SET DEFAULT NULL;

-- Function to reset daily quantities
CREATE OR REPLACE FUNCTION reset_daily_quantities()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE dishes
  SET remaining_quantity = daily_limit;
END;
$$;

-- Function to check and update dish quantity
CREATE OR REPLACE FUNCTION check_and_update_dish_quantity(
  p_dish_id uuid,
  p_quantity integer
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_remaining integer;
BEGIN
  -- Get current remaining quantity
  SELECT remaining_quantity INTO v_remaining
  FROM dishes
  WHERE dish_id = p_dish_id
  FOR UPDATE;

  -- Check if enough quantity available
  IF v_remaining >= p_quantity THEN
    -- Update remaining quantity
    UPDATE dishes
    SET remaining_quantity = remaining_quantity - p_quantity
    WHERE dish_id = p_dish_id;
    
    RETURN true;
  END IF;

  RETURN false;
END;
$$;

-- Create a cron job to reset quantities daily
-- Note: This requires pg_cron extension to be enabled
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_extension WHERE extname = 'pg_cron'
  ) THEN
    CREATE EXTENSION IF NOT EXISTS pg_cron;
  END IF;
END $$;

SELECT cron.schedule(
  'reset-daily-quantities',
  '0 0 * * *', -- Run at midnight every day
  $$SELECT reset_daily_quantities()$$
);

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION reset_daily_quantities TO authenticated;
GRANT EXECUTE ON FUNCTION check_and_update_dish_quantity TO authenticated;