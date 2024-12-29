import { supabase } from '../lib/supabase';
import type { Order, OrderItem } from '../types/order';

async function fetchOrderItems(orderId: string): Promise<OrderItem[]> {
  const { data, error } = await supabase
    .from('order_items')
    .select(`
      id,
      dish_id,
      quantity,
      price_at_time,
      dishes (
        dish_name
      )
    `)
    .eq('order_id', orderId);

  if (error) throw error;

  return data.map(item => ({
    id: item.id,
    dish_id: item.dish_id,
    quantity: item.quantity,
    price_at_time: item.price_at_time,
    dish_name: item.dishes.dish_name
  }));
}

async function fetchOrderStatusHistory(orderId: string) {
  const { data, error } = await supabase
    .from('order_records')
    .select('*')
    .eq('order_id', orderId)
    .order('change_time', { ascending: true });

  if (error) throw error;
  return data;
}

async function fetchOrderWithDetails(orderId: string): Promise<Order> {
  const [order, items, statusHistory] = await Promise.all([
    supabase
      .from('orders')
      .select('*')
      .eq('order_id', orderId)
      .single()
      .then(({ data, error }) => {
        if (error) throw error;
        if (!data) throw new Error('Order not found');
        return data;
      }),
    fetchOrderItems(orderId),
    fetchOrderStatusHistory(orderId)
  ]);

  return {
    ...order,
    items,
    statusHistory
  };
}

export async function getOrderById(orderId: string): Promise<Order> {
  try {
    return await fetchOrderWithDetails(orderId);
  } catch (error) {
    console.error('Error fetching order:', error);
    throw error;
  }
}

export async function getCustomerOrders(): Promise<Order[]> {
  try {
    // First, fetch all orders
    const { data: orders, error } = await supabase
      .from('orders')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    if (!orders?.length) return [];

    // Then fetch details for each order in parallel
    const ordersWithDetails = await Promise.all(
      orders.map(order => fetchOrderWithDetails(order.order_id))
    );

    return ordersWithDetails;
  } catch (error) {
    console.error('Error fetching customer orders:', error);
    throw error;
  }
}

export async function createOrder(orderData: {
  items: Array<{ dish_id: string; quantity: number; price: number }>;
  delivery_name?: string;
  delivery_phone?: string;
  delivery_address?: string;
  contact_person_name: string;
  contact_person_phone: string;
  contact_person_address: string;
}) {
  try {
    const { data, error } = await supabase.rpc('submit_order', {
      p_customer_id: null, // Guest order
      p_delivery_name: orderData.delivery_name || null,
      p_delivery_phone: orderData.delivery_phone || null,
      p_delivery_address: orderData.delivery_address || null,
      p_contact_person_name: orderData.contact_person_name,
      p_contact_person_phone: orderData.contact_person_phone,
      p_contact_person_address: orderData.contact_person_address,
      p_items: orderData.items
    });

    if (error) throw error;
    return getOrderById(data);
  } catch (error) {
    console.error('Error creating order:', error);
    throw error;
  }
}