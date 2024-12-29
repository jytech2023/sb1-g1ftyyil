import React from 'react';
import { useMenu } from '../../hooks/useMenu';
import MenuItem from './MenuItem';
import MenuSkeleton from './MenuSkeleton';
import ErrorMessage from '../common/ErrorMessage';

interface Props {
  restaurantId: string;
}

export default function MenuList({ restaurantId }: Props) {
  const { menu, loading, error } = useMenu(restaurantId);

  if (loading) return <MenuSkeleton />;
  if (error) return <ErrorMessage message={error} />;
  if (!menu?.length) return <ErrorMessage message="No menu items available" />;

  // Group menu items by category
  const menuByCategory = menu.reduce((acc, item) => {
    const category = item.flags?.category || 'Other';
    if (!acc[category]) {
      acc[category] = [];
    }
    acc[category].push(item);
    return acc;
  }, {} as Record<string, typeof menu>);

  return (
    <div className="space-y-12">
      <h2 className="text-2xl font-bold text-gray-900">Menu</h2>
      
      {Object.entries(menuByCategory).map(([category, items]) => (
        <div key={category} className="space-y-6">
          <h3 className="text-xl font-semibold text-gray-800 capitalize">
            {category.toLowerCase().replace('_', ' ')}
          </h3>
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {items.map((item) => (
              <MenuItem key={item.dish_id} item={item} />
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}