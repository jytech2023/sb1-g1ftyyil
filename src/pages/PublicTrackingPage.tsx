import React from 'react';
import { useParams } from 'react-router-dom';
import OrderStatusCard from '../components/orders/OrderStatusCard';
import LoadingSpinner from '../components/common/LoadingSpinner';
import ErrorMessage from '../components/common/ErrorMessage';
import { useOrder } from '../hooks/useOrder';

export default function PublicTrackingPage() {
  const { orderId } = useParams();
  const { order, loading, error } = useOrder(orderId);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!order) return <ErrorMessage message="Order not found" />;

  return (
    <div className="max-w-3xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">Track Your Order</h1>
      <OrderStatusCard order={order} />
    </div>
  );
}