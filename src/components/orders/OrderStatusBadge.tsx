import React from 'react';
import { Clock, Utensils, CheckCircle2, Truck, Package } from 'lucide-react';
import type { OrderStatus } from '../../types/order';

const STATUS_CONFIG: Record<OrderStatus, { icon: React.ElementType; label: string; color: string }> = {
  pending: { icon: Clock, label: 'Pending', color: 'bg-gray-100 text-gray-800' },
  preparing: { icon: Utensils, label: 'Preparing', color: 'bg-blue-100 text-blue-800' },
  ready: { icon: Package, label: 'Ready', color: 'bg-green-100 text-green-800' },
  delivering: { icon: Truck, label: 'On the Way', color: 'bg-yellow-100 text-yellow-800' },
  delivered: { icon: CheckCircle2, label: 'Delivered', color: 'bg-green-100 text-green-800' },
  cancelled: { icon: Clock, label: 'Cancelled', color: 'bg-red-100 text-red-800' }
};

interface Props {
  status: OrderStatus;
}

export default function OrderStatusBadge({ status }: Props) {
  const config = STATUS_CONFIG[status];
  const Icon = config.icon;

  return (
    <span className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-medium ${config.color}`}>
      <Icon className="h-4 w-4" />
      {config.label}
    </span>
  );
}