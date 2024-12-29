import React from 'react';
import { Clock } from 'lucide-react';
import type { BusinessHours as BusinessHoursType } from '../types/restaurant';

interface Props {
  hours: BusinessHoursType[];
}

export default function BusinessHours({ hours }: Props) {
  return (
    <div className="mt-4">
      <div className="flex items-center gap-2 mb-2">
        <Clock className="h-4 w-4 text-gray-500" />
        <h3 className="font-semibold text-gray-700">Business Hours</h3>
      </div>
      <div className="text-sm text-gray-600 space-y-1">
        {hours.map((schedule, index) => (
          <div key={index} className="flex justify-between">
            <span>{schedule.days.join(', ')}</span>
            <span>{schedule.open} - {schedule.close}</span>
          </div>
        ))}
      </div>
    </div>
  );
}