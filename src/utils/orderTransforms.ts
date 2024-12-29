import type { Order, OrderItem, OrderStatusRecord } from '../types/order';

interface RawOrderData {
  order_id: string;
  customer_id: string | null;
  delivery_name: string | null;
  delivery_phone: string | null;
  delivery_address: string | null;
  delivery_address_from: string | null;
  restaurant_id: string;
  status: Order['status'];
  contact_person_name: string | null;
  contact_person_phone: string | null;
  contact_person_address: string | null;
  created_at: string;
  updated_at: string;
  order_items: Array<{
    dish_id: string;
    quantity: number;
    price_at_time: number;
    dishes: {
      dish_name: string;
    };
  }>;
  order_records?: Array<{
    status: Order['status'];
    note?: string;
    change_time: string;
  }>;
}

export function formatDeliveryAddress(name: string | null, address: string | null): string | null {
  if (!name || !address) return null;
  return `${name}\n${address}`;
}

export function transformOrderData(data: RawOrderData): Order {
  const items: OrderItem[] = data.order_items.map(item => ({
    dish_id: item.dish_id,
    quantity: item.quantity,
    price: item.price_at_time,
    dish_name: item.dishes.dish_name
  }));

  const statusHistory: OrderStatusRecord[] = (data.order_records || []).map(record => ({
    status: record.status,
    note: record.note,
    change_time: record.change_time
  }));

  return {
    order_id: data.order_id,
    customer_id: data.customer_id,
    delivery_name: data.delivery_name,
    delivery_phone: data.delivery_phone,
    delivery_address: data.delivery_address,
    delivery_address_to: formatDeliveryAddress(data.delivery_name, data.delivery_address),
    delivery_address_from: data.delivery_address_from,
    restaurant_id: data.restaurant_id,
    status: data.status,
    contact_person_name: data.contact_person_name,
    contact_person_phone: data.contact_person_phone,
    contact_person_address: data.contact_person_address,
    items,
    statusHistory,
    created_at: data.created_at,
    updated_at: data.updated_at
  };
}