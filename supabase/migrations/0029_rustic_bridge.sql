-- Create function to convert timestamptz to Pacific time
CREATE OR REPLACE FUNCTION to_pacific_time(ts timestamptz)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT to_char(ts AT TIME ZONE 'America/Los_Angeles', 'YYYY-MM-DD HH24:MI:SS');
$$;

-- Create function to get current Pacific time
CREATE OR REPLACE FUNCTION current_pacific_time()
RETURNS timestamptz
LANGUAGE sql
STABLE
AS $$
  SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Los_Angeles';
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION to_pacific_time TO authenticated;
GRANT EXECUTE ON FUNCTION current_pacific_time TO authenticated;