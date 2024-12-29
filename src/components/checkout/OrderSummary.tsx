import React from 'react';
import { Receipt } from 'lucide-react';
import type { MenuItem } from '../../types/menu';

interface Props {
  items: (MenuItem & { quantity: number })[];
  total: number;
}

export default function OrderSummary({ items, total }: Props) {
  return (
    <div className="bg-gray-50 p-6 rounded-lg">
      <div className="flex items-center gap-2 mb-4">
        <Receipt className="h-5 w-5 text-gray-600" />
        <h3 className="font-semibold text-lg">Order Summary</h3>
      </div>

      <div className="space-y-3 mb-4">
        {items.map(item => (
          <div key={item.dish_id} className="flex justify-between text-sm">
            <span>{item.quantity}x {item.dish_name}</span>
            <span>${(item.price * item.quantity).toFixed(2)}</span>
          </div>
        ))}
      </div>

      <div className="border-t pt-3">
        <div className="flex justify-between font-semibold">
          <span>Total (Cash on Delivery)</span>
          <span>${total.toFixed(2)}</span>
        </div>
      </div>
    </div>
  );
}