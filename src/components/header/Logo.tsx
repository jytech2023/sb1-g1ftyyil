import React from 'react';
import { Link } from 'react-router-dom';
import { Building2 } from 'lucide-react';

export default function Logo() {
  return (
    <Link to="/" className="flex items-center space-x-2">
      <Building2 className="h-8 w-8 text-orange-500" />
      <h1 className="text-xl md:text-2xl font-bold text-gray-900">CaterCorp</h1>
    </Link>
  );
}