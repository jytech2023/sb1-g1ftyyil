import { useState, useEffect } from 'react';
import { getCustomerOrders } from '../services/orderService';
import type { OrderWithDetails } from '../types/order';

export function useOrders() {
  const [orders, setOrders] = useState<OrderWithDetails[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadOrders() {
      try {
        const data = await getCustomerOrders();
        setOrders(data);
      } catch (err) {
        setError('Failed to load orders');
      } finally {
        setLoading(false);
      }
    }

    loadOrders();
  }, []);

  return { orders, loading, error };
}