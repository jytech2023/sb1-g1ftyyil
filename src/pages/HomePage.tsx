import React, { useEffect, useState } from 'react';
import RestaurantGrid from '../components/RestaurantGrid';
import { Building, Users, Clock4, DollarSign } from 'lucide-react';
import { getRestaurants } from '../services/restaurantService';
import type { Restaurant } from '../types/restaurant';
import LoadingSpinner from '../components/common/LoadingSpinner';
import ErrorMessage from '../components/common/ErrorMessage';

export default function HomePage() {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadRestaurants() {
      try {
        const data = await getRestaurants();
        setRestaurants(data);
      } catch (err) {
        setError('Failed to load restaurants');
      } finally {
        setLoading(false);
      }
    }

    loadRestaurants();
  }, []);

  return (
    <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Hero Section */}
      <div className="bg-orange-500 rounded-xl p-8 mb-8 text-white">
        <h1 className="text-4xl font-bold mb-4">Find Local Restaurants</h1>
        <p className="text-lg mb-6">Discover and order from the best restaurants in your area</p>
        
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-8">
          {[
            { icon: Building, text: 'Local Favorites' },
            { icon: Users, text: 'Customer Reviews' },
            { icon: Clock4, text: 'Real-time Updates' },
            { icon: DollarSign, text: 'Best Prices' },
          ].map((feature, index) => (
            <div key={index} className="flex items-center space-x-2 bg-white/10 p-3 rounded-lg">
              <feature.icon className="h-5 w-5" />
              <span>{feature.text}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Restaurant Grid */}
      {loading ? (
        <LoadingSpinner />
      ) : error ? (
        <ErrorMessage message={error} />
      ) : (
        <RestaurantGrid restaurants={restaurants} />
      )}
    </main>
  );
}