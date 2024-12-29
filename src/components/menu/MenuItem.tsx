import React from 'react';
import { PlusCircle, MinusCircle } from 'lucide-react';
import type { MenuItem as MenuItemType } from '../../types/menu';
import { useCart } from '../../contexts/CartContext';
import DailyLimitNotice from './DailyLimitNotice';

interface Props {
  item: MenuItemType;
}

export default function MenuItem({ item }: Props) {
  const { state, dispatch } = useCart();
  const cartItem = state.items.find(i => i.dish_id === item.dish_id);
  const defaultImage = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80';
  
  const isOutOfStock = item.remaining_quantity === 0;
  const remainingQuantity = item.remaining_quantity ?? item.daily_limit;
  const isNearLimit = remainingQuantity <= 5 && remainingQuantity > 0;
  
  return (
    <div className="bg-white rounded-lg shadow p-4 flex flex-col">
      <div className="relative h-48 mb-4">
        <img 
          src={item.picture || defaultImage} 
          alt={item.dish_name}
          className="w-full h-full object-cover rounded-md"
        />
        {isOutOfStock && (
          <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
            <span className="text-white font-bold text-lg">Sold Out</span>
          </div>
        )}
      </div>
      
      <h3 className="text-lg font-semibold mb-2">{item.dish_name}</h3>
      {item.description && (
        <p className="text-gray-600 text-sm flex-grow">{item.description}</p>
      )}
      
      <div className="mt-4 flex items-center justify-between">
        <div>
          <span className="text-lg font-bold">${item.price.toFixed(2)}</span>
          {!isOutOfStock && (
            <span className={`text-sm ml-2 ${
              isNearLimit ? 'text-orange-600 font-medium' : 'text-gray-500'
            }`}>
              ({remainingQuantity} left)
            </span>
          )}
        </div>
        
        {!isOutOfStock && (
          cartItem ? (
            <div className="flex items-center space-x-2">
              <button 
                onClick={() => dispatch({ 
                  type: 'UPDATE_QUANTITY', 
                  payload: { 
                    dishId: item.dish_id, 
                    quantity: Math.max(0, cartItem.quantity - 1) 
                  } 
                })}
                className="text-orange-500 hover:text-orange-600"
              >
                <MinusCircle className="h-6 w-6" />
              </button>
              <span className="font-semibold">{cartItem.quantity}</span>
              <button 
                onClick={() => {
                  if (cartItem.quantity < remainingQuantity) {
                    dispatch({ type: 'ADD_ITEM', payload: item });
                  }
                }}
                className={`text-orange-500 hover:text-orange-600 ${
                  cartItem.quantity >= remainingQuantity ? 'opacity-50 cursor-not-allowed' : ''
                }`}
                disabled={cartItem.quantity >= remainingQuantity}
              >
                <PlusCircle className="h-6 w-6" />
              </button>
            </div>
          ) : (
            <button 
              onClick={() => dispatch({ type: 'ADD_ITEM', payload: item })}
              className="flex items-center space-x-1 bg-orange-500 text-white px-3 py-2 rounded-lg hover:bg-orange-600 transition"
            >
              <PlusCircle className="h-5 w-5" />
              <span>Add to Order</span>
            </button>
          )
        )}
      </div>

      {item.flags?.category && (
        <span className="mt-2 inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-800">
          {item.flags.category}
        </span>
      )}

      {(isNearLimit || cartItem?.quantity === remainingQuantity) && (
        <DailyLimitNotice />
      )}
    </div>
  );
}