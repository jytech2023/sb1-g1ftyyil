export interface MenuItem {
  id: string;
  name: string;
  description: string;
  price: number;
  servings: number;
  category: 'appetizers' | 'main' | 'sides' | 'desserts' | 'beverages';
  dietaryInfo: string[];
  image: string;
}

export interface Restaurant {
  id: string;
  name: string;
  rating: number;
  cuisine: string;
  minOrder: number;
  deliveryFee: number;
  image: string;
  preparationTime: string;
  specialties: string[];
}

export interface CartItem extends MenuItem {
  quantity: number;
}