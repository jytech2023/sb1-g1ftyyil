import React from 'react';
import { Link } from 'react-router-dom';
import { MapPin, Phone, Globe } from 'lucide-react';
import type { Restaurant } from '../types/restaurant';

interface Props {
  restaurant: Restaurant;
}

export default function RestaurantCard({ restaurant }: Props) {
  const imageUrl = restaurant.image || 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80';

  return (
    <Link 
      to={`/restaurant/${restaurant.handle}`} 
      className="block bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition"
    >
      <div className="relative h-48 overflow-hidden">
        <img 
          src={imageUrl} 
          alt={restaurant.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
        <h3 className="absolute bottom-4 left-4 text-xl font-semibold text-white">
          {restaurant.name}
        </h3>
      </div>
      
      <div className="p-4 space-y-2">
        {restaurant.address && (
          <div className="flex items-start space-x-2 text-gray-600">
            <MapPin className="h-5 w-5 mt-0.5 flex-shrink-0" />
            <span>{restaurant.address}</span>
          </div>
        )}
        
        {restaurant.phone && (
          <div className="flex items-center space-x-2 text-gray-600">
            <Phone className="h-5 w-5 flex-shrink-0" />
            <span>{restaurant.phone}</span>
          </div>
        )}
        
        {restaurant.website && (
          <div className="flex items-center space-x-2 text-gray-600">
            <Globe className="h-5 w-5 flex-shrink-0" />
            <span 
              className="text-orange-600 hover:text-orange-700 cursor-pointer"
              onClick={(e) => {
                e.preventDefault();
                window.open(restaurant.website, '_blank', 'noopener,noreferrer');
              }}
            >
              Visit Website
            </span>
          </div>
        )}
      </div>
    </Link>
  );
}