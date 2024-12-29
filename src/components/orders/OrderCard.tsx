import React from 'react';
import { Clock } from 'lucide-react';
import OrderStatusBadge from './OrderStatusBadge';
import OrderTimeline from './OrderTimeline';
import type { Order } from '../../types/order';

interface Props {
  order: Order;
}

export default function OrderCard({ order }: Props) {
  const formattedDate = new Date(order.created_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });

  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex justify-between items-start mb-4">
        <div>
          <h3 className="font-semibold text-lg">Order #{order.order_id.slice(0, 8)}</h3>
          <div className="flex items-center text-sm text-gray-600 mt-1">
            <Clock className="h-4 w-4 mr-1" />
            {formattedDate}
          </div>
        </div>
        <OrderStatusBadge status={order.status} />
      </div>

      <div className="border-t border-b py-4 my-4">
        <div className="space-y-2">
          {order.items.map((item) => (
            <div key={item.dish_id} className="flex justify-between text-sm">
              <span>{item.quantity}x {item.dish_name}</span>
              <span className="text-gray-600">${(item.price * item.quantity).toFixed(2)}</span>
            </div>
          ))}
        </div>
        <div className="flex justify-between font-semibold mt-4 pt-4 border-t">
          <span>Total</span>
          <span>${order.total_amount.toFixed(2)}</span>
        </div>
      </div>

      <div className="mt-4 space-y-2 text-sm text-gray-600">
        <p><strong>Delivery Name:</strong> {order.delivery_name}</p>
        <p><strong>Phone:</strong> {order.delivery_phone}</p>
        <p><strong>Address:</strong> {order.delivery_address}</p>
      </div>

      <OrderTimeline status={order.status} />
    </div>
  );
}