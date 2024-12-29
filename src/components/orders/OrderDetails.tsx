import React from 'react';
import { MapPin, Phone, User } from 'lucide-react';
import type { Order } from '../../types/order';

interface Props {
  order: Order;
}

export default function OrderDetails({ order }: Props) {
  return (
    <div className="grid md:grid-cols-2 gap-6">
      {/* Contact Person */}
      <div>
        <h3 className="font-semibold mb-4">Contact Person</h3>
        <div className="space-y-3 text-sm">
          <div className="flex items-start gap-2">
            <User className="h-4 w-4 mt-1 text-gray-500" />
            <div>
              <p className="font-medium">{order.contact_person_name}</p>
              <p className="text-gray-600">{order.contact_person_phone}</p>
            </div>
          </div>
          <div className="flex items-start gap-2">
            <MapPin className="h-4 w-4 mt-1 text-gray-500" />
            <div>
              <p className="font-medium">Contact Address</p>
              <p className="text-gray-600">{order.contact_person_address}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Delivery Details */}
      {(order.delivery_name || order.delivery_phone || order.delivery_address) && (
        <div>
          <h3 className="font-semibold mb-4">Delivery Details</h3>
          <div className="space-y-3 text-sm">
            {(order.delivery_name || order.delivery_phone) && (
              <div className="flex items-start gap-2">
                <User className="h-4 w-4 mt-1 text-gray-500" />
                <div>
                  <p className="font-medium">{order.delivery_name || order.contact_person_name}</p>
                  <p className="text-gray-600">{order.delivery_phone || order.contact_person_phone}</p>
                </div>
              </div>
            )}
            {order.delivery_address && (
              <div className="flex items-start gap-2">
                <MapPin className="h-4 w-4 mt-1 text-gray-500" />
                <div>
                  <p className="font-medium">Delivery Address</p>
                  <p className="text-gray-600">{order.delivery_address}</p>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}