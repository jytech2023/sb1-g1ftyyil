/*
  # Add daily limit functionality

  1. Changes
    - Add daily_limit and remaining_quantity columns to dishes table
    - Create functions for quantity management
    - Set up daily reset cron job
    - Update existing dishes with default values

  2. Security
    - Functions are SECURITY DEFINER to ensure proper access control
    - Granted execute permissions to authenticated users
*/

-- Enable the pg_cron extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Add new columns to dishes table if they don't exist
ALTER TABLE dishes
ADD COLUMN IF NOT EXISTS daily_limit INTEGER DEFAULT 50 NOT NULL,
ADD COLUMN IF NOT EXISTS remaining_quantity INTEGER;

-- Update existing dishes to have a default daily limit and remaining quantity
UPDATE dishes
SET daily_limit = 50,
    remaining_quantity = COALESCE(remaining_quantity, 50)
WHERE daily_limit IS NULL OR remaining_quantity IS NULL;

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

-- Drop existing cron job if it exists
SELECT cron.unschedule('reset-daily-quantities');

-- Create a new cron job to reset quantities daily
SELECT cron.schedule(
  'reset-daily-quantities',
  '0 0 * * *', -- Run at midnight every day
  $$SELECT reset_daily_quantities()$$
);

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION check_and_update_dish_quantity TO authenticated;
GRANT EXECUTE ON FUNCTION reset_daily_quantities TO authenticated;