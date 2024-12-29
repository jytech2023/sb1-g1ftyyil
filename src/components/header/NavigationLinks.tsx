import React from 'react';
import { Link } from 'react-router-dom';
import { ClipboardList } from 'lucide-react';
import CartButton from '../cart/CartButton';

interface Props {
  className?: string;
}

export default function NavigationLinks({ className = "" }: Props) {
  return (
    <div className={className}>
      <Link 
        to="/orders" 
        className="flex items-center space-x-2 text-gray-600 hover:text-gray-900"
      >
        <ClipboardList className="h-5 w-5" />
        <span>Orders</span>
      </Link>
      <CartButton />
    </div>
  );
}