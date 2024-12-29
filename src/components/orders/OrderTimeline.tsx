import React from 'react';
import { CheckCircle2, Clock, Package, Truck, Utensils } from 'lucide-react';
import TimelineStep from './TimelineStep';
import { formatPacificTime } from '../../utils/dateUtils';
import type { OrderStatus, OrderStatusRecord } from '../../types/order';

const TIMELINE_STEPS = [
  { key: 'pending', icon: Clock, label: 'Order Placed' },
  { key: 'preparing', icon: Utensils, label: 'Preparing' },
  { key: 'ready', icon: Package, label: 'Ready' },
  { key: 'on_the_way', icon: Truck, label: 'On the Way' },
  { key: 'delivered', icon: CheckCircle2, label: 'Delivered' }
] as const;

const STATUS_ORDER = {
  pending: 0,
  preparing: 1,
  ready: 2,
  on_the_way: 3,
  delivered: 4,
  cancelled: -1
} as const;

interface Props {
  status: OrderStatus;
  statusHistory?: OrderStatusRecord[];
}

export default function OrderTimeline({ status, statusHistory = [] }: Props) {
  const currentStep = STATUS_ORDER[status];

  if (status === 'cancelled') {
    return (
      <div className="mt-6">
        <div className="text-center text-red-600 font-medium mb-2">
          This order has been cancelled
        </div>
        {statusHistory.length > 0 && (
          <div className="text-sm text-gray-500 space-y-2">
            {statusHistory.map((record, index) => (
              <div key={index} className="flex justify-between items-center py-1">
                <span className="capitalize">{record.status.replace(/_/g, ' ')}</span>
                <span>{formatPacificTime(record.change_time)} PT</span>
                {record.note && <span className="text-gray-600">- {record.note}</span>}
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  return (
    <div className="mt-6">
      <div className="relative">
        <div className="absolute left-0 top-5 w-full h-0.5 bg-gray-200" />
        
        <div className="relative flex justify-between">
          {TIMELINE_STEPS.map((step, index) => {
            const record = statusHistory.find(r => r.status === step.key);
            const isActive = STATUS_ORDER[status] >= index;
            
            return (
              <TimelineStep
                key={step.key}
                icon={step.icon}
                label={step.label}
                isActive={isActive}
                record={record}
              />
            );
          })}
        </div>
      </div>

      {/* Status History */}
      {statusHistory.length > 0 && (
        <div className="mt-6 space-y-2 text-sm text-gray-600">
          <h4 className="font-medium text-gray-900">Status History</h4>
          {statusHistory.map((record, index) => (
            <div key={index} className="flex justify-between items-center">
              <div>
                <span className="font-medium capitalize">
                  {record.status.replace(/_/g, ' ')}
                </span>
                {record.note && (
                  <span className="ml-2 text-gray-500">- {record.note}</span>
                )}
              </div>
              <span className="text-gray-500">
                {formatPacificTime(record.change_time)} PT
              </span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}