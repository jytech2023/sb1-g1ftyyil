import React from 'react';

export default function MenuSkeleton() {
  // Create an array of 6 items for the skeleton
  const skeletonItems = Array(6).fill(null);

  return (
    <div className="space-y-12 animate-pulse">
      {/* Category Skeleton */}
      <div className="space-y-6">
        <div className="h-8 bg-gray-200 rounded w-48" />
        
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {skeletonItems.map((_, index) => (
            <div key={index} className="bg-white rounded-lg shadow p-4 flex flex-col">
              {/* Image skeleton */}
              <div className="relative h-48 mb-4 bg-gray-200 rounded-md" />
              
              {/* Title skeleton */}
              <div className="h-6 bg-gray-200 rounded w-3/4 mb-2" />
              
              {/* Description skeleton */}
              <div className="space-y-2 mb-4">
                <div className="h-4 bg-gray-200 rounded w-full" />
                <div className="h-4 bg-gray-200 rounded w-5/6" />
              </div>
              
              {/* Price and button skeleton */}
              <div className="mt-4 flex items-center justify-between">
                <div className="h-6 bg-gray-200 rounded w-20" />
                <div className="h-10 bg-gray-200 rounded w-32" />
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}