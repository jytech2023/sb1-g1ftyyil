import { describe, it, expect } from 'vitest';
import { getMenuByRestaurantId } from '../../services/menuService';

describe('Menu Integration Tests', () => {
  const HAWI_RESTAURANT_ID = '3b9644d4-4cb7-4edc-84ba-c223abf366d5';

  it('should fetch menu items for Hawi restaurant', async () => {
    try {
      const menu = await getMenuByRestaurantId(HAWI_RESTAURANT_ID);
      
      // Log response for debugging
      console.log('Fetched menu items:', menu.length);

      // Verify menu is not empty
      expect(menu).toBeDefined();
      expect(menu.length).toBeGreaterThan(0);

      // Verify menu item structure
      const firstItem = menu[0];
      expect(firstItem).toHaveProperty('dish_id');
      expect(firstItem).toHaveProperty('dish_name');
      expect(firstItem).toHaveProperty('price');
      expect(firstItem).toHaveProperty('availability');
      expect(firstItem).toHaveProperty('daily_limit');
      expect(firstItem).toHaveProperty('restaurant_id', HAWI_RESTAURANT_ID);

      // Log first item for debugging
      console.log('Sample menu item:', firstItem);

      // Verify all items belong to Hawi restaurant
      menu.forEach(item => {
        expect(item.restaurant_id).toBe(HAWI_RESTAURANT_ID);
      });

      // Verify specific menu items exist
      const menuItemNames = menu.map(item => item.dish_name);
      expect(menuItemNames).toContain('Hawaiian BBQ Chicken');
      expect(menuItemNames).toContain('Kalua Pork');
      expect(menuItemNames).toContain('Loco Moco');
    } catch (error) {
      console.error('Test failed:', error);
      throw error;
    }
  });
});