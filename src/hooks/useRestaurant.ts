import { useState, useEffect } from 'react';
import { getRestaurantByHandle } from '../services/restaurantService';
import type { Restaurant } from '../types/restaurant';

export function useRestaurant(handle: string | undefined) {
  const [restaurant, setRestaurant] = useState<Restaurant | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadRestaurant() {
      if (!handle) {
        setError('Restaurant handle is required');
        setLoading(false);
        return;
      }

      try {
        const data = await getRestaurantByHandle(handle);
        setRestaurant(data);
      } catch (err) {
        setError('Failed to load restaurant');
      } finally {
        setLoading(false);
      }
    }

    loadRestaurant();
  }, [handle]);

  return { restaurant, loading, error };
}