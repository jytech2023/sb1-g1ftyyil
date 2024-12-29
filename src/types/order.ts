export type OrderStatus = 
  | 'pending'
  | 'preparing'
  | 'ready'
  | 'on_the_way'
  | 'delivered'
  | 'cancelled';

export interface OrderItem {
  id: string;
  dish_id: string;
  quantity: number;
  price_at_time: number;
  dish_name: string;
}

export interface OrderStatusRecord {
  id: string;
  status: OrderStatus;
  note?: string;
  change_time: string;
}

export interface Order {
  order_id: string;
  customer_id?: string | null;
  delivery_name: string;
  delivery_phone: string;
  delivery_address: string;
  contact_person_name: string;
  contact_person_phone: string;
  contact_person_address: string;
  status: OrderStatus;
  created_at: string;
  updated_at: string;
  items: OrderItem[];
  statusHistory: OrderStatusRecord[];
}