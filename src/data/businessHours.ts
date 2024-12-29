import type { BusinessHours } from '../types/restaurant';

export const hawiBusinessHours: BusinessHours[] = [
  {
    days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    open: '10:30',
    close: '21:00'
  },
  {
    days: ['Friday', 'Saturday'],
    open: '10:30',
    close: '21:30'
  },
  {
    days: ['Sunday'],
    open: '11:00',
    close: '21:00'
  }
];