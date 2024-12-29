import React from 'react';
import RestaurantCard from './RestaurantCard';
import type { Restaurant } from '../types/restaurant';

interface Props {
  restaurants: Restaurant[];
}

export default function RestaurantGrid({ restaurants }: Props) {
  if (restaurants.length === 0) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">No restaurants found.</p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {restaurants.map((restaurant) => (
        <RestaurantCard key={restaurant.id} restaurant={restaurant} />
      ))}
    </div>
  );
}