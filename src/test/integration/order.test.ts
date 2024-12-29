import { describe, it, expect } from 'vitest';
import { createOrder, getOrderById } from '../../services/orderService';
import { getMenuByRestaurantId } from '../../services/menuService';
import { formatDeliveryAddress } from '../../utils/orderTransforms';

describe('Order Integration Tests', () => {
  const HAWI_RESTAURANT_ID = '3b9644d4-4cb7-4edc-84ba-c223abf366d5';
  const HAWI_ADDRESS = '307 Grand Ave South San Francisco CA 94080';

  it('should create a guest order successfully', async () => {
    try {
      // First, get some menu items to order
      const menu = await getMenuByRestaurantId(HAWI_RESTAURANT_ID);
      const itemToOrder = menu[0]; // Get first menu item

      const deliveryDetails = {
        name: 'Test Guest',
        phone: '123-456-7890',
        address: '123 Test St, Test City, TC 12345'
      };

      const contactDetails = {
        name: 'John Contact',
        phone: '555-0123',
        address: '456 Contact St, Test City, TC 12345'
      };

      // Prepare order data
      const orderData = {
        items: [{
          dish_id: itemToOrder.dish_id,
          quantity: 1,
          price: itemToOrder.price
        }],
        delivery_name: deliveryDetails.name,
        delivery_phone: deliveryDetails.phone,
        delivery_address: deliveryDetails.address,
        contact_person_name: contactDetails.name,
        contact_person_phone: contactDetails.phone,
        contact_person_address: contactDetails.address
      };

      // Create the order
      const order = await createOrder(orderData);

      // Verify order structure
      expect(order).toBeDefined();
      expect(order.order_id).toBeDefined();
      expect(order.customer_id).toBeNull(); // Should be null for guest order
      expect(order.delivery_name).toBe(deliveryDetails.name);
      expect(order.delivery_phone).toBe(deliveryDetails.phone);
      expect(order.delivery_address).toBe(deliveryDetails.address);
      expect(order.delivery_address_to).toBe(formatDeliveryAddress(deliveryDetails.name, deliveryDetails.address));
      expect(order.delivery_address_from).toBe(HAWI_ADDRESS);
      expect(order.restaurant_id).toBe(HAWI_RESTAURANT_ID);
      expect(order.status).toBe('pending');
      expect(order.contact_person_name).toBe(contactDetails.name);
      expect(order.contact_person_phone).toBe(contactDetails.phone);
      expect(order.contact_person_address).toBe(contactDetails.address);

      // Verify order items
      expect(order.items).toHaveLength(1);
      expect(order.items[0]).toMatchObject({
        dish_id: itemToOrder.dish_id,
        quantity: 1,
        price: itemToOrder.price,
        dish_name: itemToOrder.dish_name
      });

      // Verify order can be retrieved
      const retrievedOrder = await getOrderById(order.order_id);
      expect(retrievedOrder).toMatchObject(order);

      // Verify status history exists but don't check specific values
      expect(order.statusHistory).toBeDefined();
      expect(Array.isArray(order.statusHistory)).toBe(true);

    } catch (error) {
      console.error('Test failed:', error);
      throw error;
    }
  });
});