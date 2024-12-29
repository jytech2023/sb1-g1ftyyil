/*
  # Fix daily limit columns and data

  1. Changes
    - Ensure daily_limit and remaining_quantity columns exist with correct defaults
    - Update all existing dishes with proper values
    - Re-create functions with proper error handling
*/

-- First, ensure the columns exist with correct defaults
DO $$ 
BEGIN
    -- Check if daily_limit exists
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'dishes' AND column_name = 'daily_limit'
    ) THEN
        ALTER TABLE dishes ADD COLUMN daily_limit INTEGER DEFAULT 50 NOT NULL;
    END IF;

    -- Check if remaining_quantity exists
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'dishes' AND column_name = 'remaining_quantity'
    ) THEN
        ALTER TABLE dishes ADD COLUMN remaining_quantity INTEGER;
    END IF;
END $$;

-- Update all existing dishes to have proper values
UPDATE dishes
SET daily_limit = COALESCE(daily_limit, 50),
    remaining_quantity = COALESCE(remaining_quantity, daily_limit)
WHERE daily_limit IS NULL 
   OR remaining_quantity IS NULL;

-- Re-create the check function with better error handling
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
  v_daily_limit integer;
BEGIN
  -- Get current remaining quantity and daily limit
  SELECT remaining_quantity, daily_limit 
  INTO v_remaining, v_daily_limit
  FROM dishes
  WHERE dish_id = p_dish_id
  FOR UPDATE;

  -- Initialize remaining_quantity if null
  IF v_remaining IS NULL THEN
    v_remaining := v_daily_limit;
    
    UPDATE dishes
    SET remaining_quantity = v_daily_limit
    WHERE dish_id = p_dish_id;
  END IF;

  -- Check if enough quantity available
  IF v_remaining >= p_quantity THEN
    -- Update remaining quantity
    UPDATE dishes
    SET remaining_quantity = remaining_quantity - p_quantity
    WHERE dish_id = p_dish_id;
    
    RETURN true;
  END IF;

  RETURN false;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error in check_and_update_dish_quantity: %', SQLERRM;
    RETURN false;
END;
$$;