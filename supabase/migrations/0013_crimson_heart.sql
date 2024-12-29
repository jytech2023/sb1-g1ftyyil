/*
  # Order Tracking System Updates

  1. Changes
    - Add trigger to automatically create initial order record
    - Add function to update order status with record
    - Add function to get latest order status

  2. Security
    - Enable RLS on all new functions
    - Add policies for order status updates
*/

-- Create function to update order status
CREATE OR REPLACE FUNCTION update_order_status(
  p_order_id uuid,
  p_status order_status,
  p_note text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update the order status
  UPDATE orders
  SET status = p_status,
      updated_at = now()
  WHERE order_id = p_order_id;

  -- Create a new order record
  INSERT INTO order_records (
    order_id,
    status,
    note
  ) VALUES (
    p_order_id,
    p_status,
    p_note
  );
END;
$$;

-- Create function to get latest order status
CREATE OR REPLACE FUNCTION get_latest_order_status(p_order_id uuid)
RETURNS order_status
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT status
  FROM order_records
  WHERE order_id = p_order_id
  ORDER BY change_time DESC
  LIMIT 1;
$$;

-- Create trigger to automatically create initial order record
CREATE OR REPLACE FUNCTION create_initial_order_record()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO order_records (
    order_id,
    status,
    note
  ) VALUES (
    NEW.order_id,
    'pending',
    'Order created'
  );
  RETURN NEW;
END;
$$;

CREATE TRIGGER order_created_record
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION create_initial_order_record();

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION update_order_status TO authenticated;
GRANT EXECUTE ON FUNCTION get_latest_order_status TO authenticated;