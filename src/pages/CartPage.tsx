import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ArrowLeft } from 'lucide-react';
import { useCart } from '../contexts/CartContext';
import CartItemCard from '../components/cart/CartItemCard';
import DeliveryForm from '../components/checkout/DeliveryForm';
import OrderSummary from '../components/checkout/OrderSummary';
import { createOrder } from '../services/orderService';

export default function CartPage() {
  const { state, dispatch } = useCart();
  const [isCheckingOut, setIsCheckingOut] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();

  const handleCheckout = async (deliveryDetails: { 
    name: string; 
    phone: string; 
    address: string;
    contactName: string;
    contactPhone: string;
    contactAddress: string;
  }) => {
    try {
      setIsSubmitting(true);

      const orderData = {
        items: state.items.map(item => ({
          dish_id: item.dish_id,
          quantity: item.quantity,
          price: item.price
        })),
        delivery_name: deliveryDetails.name,
        delivery_phone: deliveryDetails.phone,
        delivery_address: deliveryDetails.address,
        contact_person_name: deliveryDetails.contactName,
        contact_person_phone: deliveryDetails.contactPhone,
        contact_person_address: deliveryDetails.contactAddress
      };

      const order = await createOrder(orderData);
      dispatch({ type: 'CLEAR_CART' });
      navigate(`/order/${order.order_id}`);
    } catch (error) {
      console.error('Failed to create order:', error);
      alert('Failed to create order. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  if (state.items.length === 0) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="text-center">
          <h2 className="text-2xl font-bold mb-4">Your cart is empty</h2>
          <Link 
            to="/"
            className="inline-flex items-center text-orange-500 hover:text-orange-600"
          >
            <ArrowLeft className="h-5 w-5 mr-2" />
            Continue Shopping
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Your Order</h1>
        <Link 
          to="/"
          className="text-orange-500 hover:text-orange-600 flex items-center"
        >
          <ArrowLeft className="h-5 w-5 mr-2" />
          Continue Shopping
        </Link>
      </div>

      {!isCheckingOut ? (
        <>
          <div className="space-y-4 mb-8">
            {state.items.map((item) => (
              <CartItemCard key={item.dish_id} item={item} />
            ))}
          </div>

          <div className="bg-white p-6 rounded-lg shadow">
            <div className="flex justify-between mb-4">
              <span className="font-semibold">Subtotal</span>
              <span>${state.total.toFixed(2)}</span>
            </div>
            <button 
              className="w-full bg-orange-500 text-white py-3 rounded-lg hover:bg-orange-600 transition"
              onClick={() => setIsCheckingOut(true)}
            >
              Proceed to Checkout
            </button>
          </div>
        </>
      ) : (
        <div className="grid md:grid-cols-2 gap-8">
          <div>
            <h2 className="text-xl font-semibold mb-4">Delivery Details</h2>
            <DeliveryForm 
              onSubmit={handleCheckout} 
              isSubmitting={isSubmitting}
            />
          </div>
          <div>
            <OrderSummary items={state.items} total={state.total} />
          </div>
        </div>
      )}
    </div>
  );
}