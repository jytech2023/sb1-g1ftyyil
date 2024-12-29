import React from 'react';
import { LucideIcon } from 'lucide-react';
import { formatPacificTime } from '../../utils/dateUtils';
import type { OrderStatusRecord } from '../../types/order';

interface Props {
  icon: LucideIcon;
  label: string;
  isActive: boolean;
  record?: OrderStatusRecord;
}

export default function TimelineStep({ icon: Icon, label, isActive, record }: Props) {
  return (
    <div className="flex flex-col items-center">
      <div className={`
        w-10 h-10 rounded-full flex items-center justify-center 
        ${isActive ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-400'}
        relative z-10
      `}>
        <Icon className="h-5 w-5" />
      </div>
      <span className={`
        text-xs mt-2 font-medium
        ${isActive ? 'text-orange-500' : 'text-gray-500'}
      `}>
        {label}
      </span>
      {record && (
        <span className="text-xs text-gray-500 mt-1">
          {formatPacificTime(record.change_time)} PT
        </span>
      )}
    </div>
  );
}