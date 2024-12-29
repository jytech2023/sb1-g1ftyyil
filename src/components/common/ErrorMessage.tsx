import React from 'react';
import { AlertCircle } from 'lucide-react';

interface Props {
  message: string;
}

export default function ErrorMessage({ message }: Props) {
  return (
    <div className="flex items-center justify-center p-8">
      <div className="flex items-center space-x-2 text-red-600">
        <AlertCircle className="h-5 w-5" />
        <span>{message}</span>
      </div>
    </div>
  );
}