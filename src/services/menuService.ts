import { supabase } from '../lib/supabase';
import type { MenuItem } from '../types/menu';

export async function getMenuByRestaurantId(restaurantId: string): Promise<MenuItem[]> {
  try {
    console.log('Fetching menu for restaurant:', restaurantId);

    const { data, error } = await supabase
      .from('dishes')
      .select(`
        dish_id,
        dish_name,
        description,
        price,
        picture,
        availability,
        daily_limit,
        remaining_quantity,
        flags,
        restaurant_id
      `)
      .eq('restaurant_id', restaurantId)
      .eq('availability', true)
      .order('dish_name');

    if (error) {
      console.error('Error fetching menu:', error);
      throw error;
    }

    if (!data) {
      console.log('No menu items found');
      return [];
    }

    console.log(`Found ${data.length} menu items`);
    return data;
  } catch (error) {
    console.error('Error in getMenuByRestaurantId:', error);
    throw error;
  }
}