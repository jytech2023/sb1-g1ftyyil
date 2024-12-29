import React from 'react';
import OrderStatusBadge from './OrderStatusBadge';
import OrderTimeline from './OrderTimeline';
import OrderDetails from './OrderDetails';
import OrderItems from './OrderItems';
import OrderShareCard from './OrderShareCard';
import { formatPacificTime } from '../../utils/dateUtils';
import type { Order } from '../../types/order';

interface Props {
  order: Order;
}

export default function OrderStatusCard({ order }: Props) {
  const formattedDate = formatPacificTime(order.created_at);

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-lg overflow-hidden">
        {/* Header */}
        <div className="p-6 border-b">
          <div className="flex justify-between items-start mb-4">
            <div>
              <h2 className="text-lg font-semibold">Order #{order.order_id.slice(0, 8)}</h2>
              <div className="text-sm text-gray-600 mt-1">
                {formattedDate} PT
              </div>
            </div>
            <OrderStatusBadge status={order.status} />
          </div>
        </div>

        {/* Order Timeline */}
        <div className="p-6 border-b bg-gray-50">
          <OrderTimeline status={order.status} statusHistory={order.statusHistory} />
        </div>

        {/* Order Details */}
        <div className="p-6 space-y-8">
          <OrderDetails order={order} />
          <OrderItems items={order.items} />
        </div>
      </div>

      {/* Share Card */}
      <OrderShareCard orderId={order.order_id} />
    </div>
  );
}