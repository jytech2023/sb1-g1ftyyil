import React from 'react';
import { useParams } from 'react-router-dom';
import { MapPin, Phone, Globe, Clock } from 'lucide-react';
import MenuList from '../components/menu/MenuList';
import { useRestaurant } from '../hooks/useRestaurant';
import LoadingSpinner from '../components/common/LoadingSpinner';
import ErrorMessage from '../components/common/ErrorMessage';

export default function RestaurantPage() {
  const { handle } = useParams();
  const { restaurant, loading, error } = useRestaurant(handle);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!restaurant) return <ErrorMessage message="Restaurant not found" />;

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="relative h-64 md:h-96">
        <img 
          src={restaurant.image} 
          alt={restaurant.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-16 relative">
        <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">{restaurant.name}</h1>
          
          <div className="grid md:grid-cols-2 gap-4 text-gray-600">
            {restaurant.address && (
              <div className="flex items-start space-x-2">
                <MapPin className="h-5 w-5 mt-0.5 flex-shrink-0" />
                <span>{restaurant.address}</span>
              </div>
            )}
            
            {restaurant.phone && (
              <div className="flex items-center space-x-2">
                <Phone className="h-5 w-5 flex-shrink-0" />
                <span>{restaurant.phone}</span>
              </div>
            )}
            
            {restaurant.website && (
              <div className="flex items-center space-x-2">
                <Globe className="h-5 w-5 flex-shrink-0" />
                <a 
                  href={restaurant.website}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-orange-600 hover:text-orange-700"
                >
                  Visit Website
                </a>
              </div>
            )}
          </div>
        </div>

        <MenuList restaurantId={restaurant.id} />
      </div>
    </div>
  );
}