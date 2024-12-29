export interface MenuItem {
  dish_id: string;
  dish_name: string;
  description?: string;
  price: number;
  picture?: string;
  availability: boolean;
  daily_limit: number;
  remaining_quantity: number | null;
  flags?: {
    dietary?: string[];
    allergens?: string[];
    serving?: string;
    category?: string;
    includes?: string[];
  };
  restaurant_id: string;
}