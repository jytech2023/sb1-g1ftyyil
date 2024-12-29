export interface Restaurant {
  id: string;
  name: string;
  website?: string;
  phone?: string;
  address?: string;
  handle: string;
  created_at: string;
  updated_at?: string;
  image?: string; // Add image field
}

export interface BusinessHours {
  open: string;
  close: string;
  days: string[];
}