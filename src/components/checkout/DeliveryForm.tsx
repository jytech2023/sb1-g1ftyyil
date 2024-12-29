import React, { useState } from 'react';
import { MapPin, Phone, User } from 'lucide-react';

interface DeliveryDetails {
  name?: string;
  phone?: string;
  address?: string;
  contactName: string;
  contactPhone: string;
  contactAddress: string;
}

interface Props {
  onSubmit: (details: DeliveryDetails) => void;
  isSubmitting?: boolean;
}

export default function DeliveryForm({ onSubmit, isSubmitting = false }: Props) {
  const [details, setDetails] = useState<DeliveryDetails>({
    name: '',
    phone: '',
    address: '',
    contactName: '',
    contactPhone: '',
    contactAddress: ''
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(details);
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-8">
      {/* Required Contact Person Details */}
      <div className="bg-white p-6 rounded-lg shadow-sm border space-y-4">
        <h3 className="text-lg font-semibold text-gray-900">Contact Person</h3>
        <p className="text-sm text-gray-600 mb-4">
          Please provide your contact information for order confirmation and updates.
        </p>
        
        <div className="space-y-4">
          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
              <User className="h-4 w-4" />
              Name
              <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              required
              value={details.contactName}
              onChange={e => setDetails(prev => ({ ...prev, contactName: e.target.value }))}
              className="w-full px-3 py-2 border rounded-md focus:ring-1 focus:ring-orange-500 focus:border-orange-500"
              placeholder="Your name"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
              <Phone className="h-4 w-4" />
              Phone
              <span className="text-red-500">*</span>
            </label>
            <input
              type="tel"
              required
              value={details.contactPhone}
              onChange={e => setDetails(prev => ({ ...prev, contactPhone: e.target.value }))}
              className="w-full px-3 py-2 border rounded-md focus:ring-1 focus:ring-orange-500 focus:border-orange-500"
              placeholder="Your phone number"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
              <MapPin className="h-4 w-4" />
              Address
              <span className="text-red-500">*</span>
            </label>
            <textarea
              required
              value={details.contactAddress}
              onChange={e => setDetails(prev => ({ ...prev, contactAddress: e.target.value }))}
              className="w-full px-3 py-2 border rounded-md focus:ring-1 focus:ring-orange-500 focus:border-orange-500"
              rows={3}
              placeholder="Your address"
            />
          </div>
        </div>
      </div>

      {/* Optional Delivery Details */}
      <div className="bg-white p-6 rounded-lg shadow-sm border space-y-4">
        <h3 className="text-lg font-semibold text-gray-900">Delivery Information</h3>
        <p className="text-sm text-gray-600 mb-4">
          Optional: Fill this section if the delivery details are different from your contact information.
          If left blank, the restaurant will use your contact information for delivery.
        </p>

        <div className="space-y-4">
          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
              <User className="h-4 w-4" />
              Recipient Name
            </label>
            <input
              type="text"
              value={details.name || ''}
              onChange={e => setDetails(prev => ({ ...prev, name: e.target.value }))}
              className="w-full px-3 py-2 border rounded-md focus:ring-1 focus:ring-orange-500 focus:border-orange-500"
              placeholder="Delivery recipient name (optional)"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
              <Phone className="h-4 w-4" />
              Phone Number
            </label>
            <input
              type="tel"
              value={details.phone || ''}
              onChange={e => setDetails(prev => ({ ...prev, phone: e.target.value }))}
              className="w-full px-3 py-2 border rounded-md focus:ring-1 focus:ring-orange-500 focus:border-orange-500"
              placeholder="Delivery contact number (optional)"
            />
          </div>

          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
              <MapPin className="h-4 w-4" />
              Delivery Address
            </label>
            <textarea
              value={details.address || ''}
              onChange={e => setDetails(prev => ({ ...prev, address: e.target.value }))}
              className="w-full px-3 py-2 border rounded-md focus:ring-1 focus:ring-orange-500 focus:border-orange-500"
              rows={3}
              placeholder="Delivery address (optional)"
            />
          </div>
        </div>
      </div>

      <button
        type="submit"
        disabled={isSubmitting}
        className={`w-full bg-orange-500 text-white py-3 rounded-lg transition
          ${isSubmitting ? 'opacity-75 cursor-not-allowed' : 'hover:bg-orange-600'}`}
      >
        {isSubmitting ? 'Placing Order...' : 'Place Order'}
      </button>
    </form>
  );
}