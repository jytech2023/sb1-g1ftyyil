import React from 'react';
import type { OrderItem } from '../../types/order';

interface Props {
  items: OrderItem[];
}

export default function OrderItems({ items }: Props) {
  const total = items.reduce((sum, item) => sum + (item.price_at_time * item.quantity), 0);

  return (
    <div>
      <h3 className="font-semibold mb-4">Order Items</h3>
      <div className="space-y-2">
        {items.map((item) => (
          <div key={item.id} className="flex justify-between text-sm">
            <span>{item.quantity}x {item.dish_name}</span>
            <span className="text-gray-600">${(item.price_at_time * item.quantity).toFixed(2)}</span>
          </div>
        ))}
        <div className="border-t pt-2 mt-4">
          <div className="flex justify-between font-semibold">
            <span>Total</span>
            <span>${total.toFixed(2)}</span>
          </div>
        </div>
      </div>
    </div>
  );
}