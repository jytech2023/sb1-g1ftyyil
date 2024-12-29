import React from 'react';
import { Trash2, MinusCircle, PlusCircle } from 'lucide-react';
import { useCart } from '../../contexts/CartContext';
import type { MenuItem } from '../../types/menu';

interface Props {
  item: MenuItem & { quantity: number };
}

export default function CartItemCard({ item }: Props) {
  const { dispatch } = useCart();
  const defaultImage = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80';

  return (
    <div className="flex items-center gap-4 bg-white p-4 rounded-lg shadow">
      <img 
        src={item.picture || defaultImage} 
        alt={item.dish_name}
        className="w-20 h-20 object-cover rounded"
      />
      
      <div className="flex-grow">
        <h3 className="font-semibold">{item.dish_name}</h3>
        <p className="text-gray-600">${item.price.toFixed(2)} each</p>
      </div>

      <div className="flex items-center gap-3">
        <button 
          onClick={() => dispatch({ 
            type: 'UPDATE_QUANTITY', 
            payload: { dishId: item.dish_id, quantity: Math.max(0, item.quantity - 1) }
          })}
          className="text-orange-500 hover:text-orange-600"
        >
          <MinusCircle className="h-6 w-6" />
        </button>
        <span className="font-semibold w-6 text-center">{item.quantity}</span>
        <button 
          onClick={() => dispatch({ type: 'ADD_ITEM', payload: item })}
          className="text-orange-500 hover:text-orange-600"
        >
          <PlusCircle className="h-6 w-6" />
        </button>
        <button 
          onClick={() => dispatch({ type: 'REMOVE_ITEM', payload: item.dish_id })}
          className="text-red-500 hover:text-red-600 ml-2"
        >
          <Trash2 className="h-5 w-5" />
        </button>
      </div>
    </div>
  );
}