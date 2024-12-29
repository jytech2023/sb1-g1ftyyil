import React from 'react';
import { Link } from 'react-router-dom';
import CartIcon from './CartIcon';
import { useCart } from '../../contexts/CartContext';

export default function CartButton() {
  const { state } = useCart();
  const itemCount = state.items.reduce((sum, item) => sum + item.quantity, 0);

  return (
    <Link 
      to="/cart" 
      className="flex items-center space-x-2 bg-orange-500 text-white px-3 py-2 md:px-4 md:py-2 rounded-lg hover:bg-orange-600 transition text-sm md:text-base"
    >
      <CartIcon />
      <span className="hidden md:inline">Order</span>
      <span>({itemCount})</span>
      {state.total > 0 && (
        <span className="hidden md:inline ml-2">${state.total.toFixed(2)}</span>
      )}
    </Link>
  );
}