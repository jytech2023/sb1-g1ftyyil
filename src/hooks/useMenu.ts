import { useState, useEffect } from 'react';
import { getMenuByRestaurantId } from '../services/menuService';
import type { MenuItem } from '../types/menu';

export function useMenu(restaurantId: string) {
  const [menu, setMenu] = useState<MenuItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadMenu() {
      try {
        const data = await getMenuByRestaurantId(restaurantId);
        setMenu(data);
      } catch (err) {
        setError('Failed to load menu');
      } finally {
        setLoading(false);
      }
    }

    loadMenu();
  }, [restaurantId]);

  return { menu, loading, error };
}