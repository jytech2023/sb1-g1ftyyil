import { supabase } from '../lib/supabase';
import type { Restaurant } from '../types/restaurant';

export async function getRestaurants(): Promise<Restaurant[]> {
  const { data, error } = await supabase
    .from('restaurants')
    .select('*')
    .order('name');

  if (error) {
    console.error('Error fetching restaurants:', error);
    throw error;
  }

  return data || [];
}

export async function getRestaurantByHandle(handle: string): Promise<Restaurant | null> {
  const { data, error } = await supabase
    .from('restaurants')
    .select('*')
    .eq('handle', handle)
    .single();

  if (error) {
    console.error('Error fetching restaurant:', error);
    throw error;
  }

  return data;
}