import React, { useState } from 'react';
import { Menu, X } from 'lucide-react';
import NavigationLinks from './NavigationLinks';

export default function MobileMenu() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="md:hidden">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="p-2 text-gray-600 hover:text-gray-900"
      >
        {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
      </button>

      {isOpen && (
        <div className="absolute top-16 left-0 right-0 bg-white border-b shadow-lg p-4">
          <NavigationLinks className="flex flex-col space-y-4" />
        </div>
      )}
    </div>
  );
}