import React, { useState } from 'react';
import { QRCodeSVG } from 'qrcode.react';
import { Share2, Check, Copy } from 'lucide-react';

interface Props {
  orderId: string;
}

export default function OrderShareCard({ orderId }: Props) {
  const [copied, setCopied] = useState(false);
  const trackingUrl = `${window.location.origin}/track/${orderId}`;

  const handleCopyLink = async () => {
    try {
      await navigator.clipboard.writeText(trackingUrl);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
    }
  };

  return (
    <div className="bg-white p-6 rounded-lg shadow-md max-w-3xl mx-auto">
      <div className="flex items-center gap-2 mb-4">
        <Share2 className="h-5 w-5 text-gray-600 flex-shrink-0" />
        <h3 className="font-semibold text-lg">Share Order Status</h3>
      </div>

      <div className="flex flex-col md:flex-row items-center gap-6">
        <div className="flex-shrink-0">
          <QRCodeSVG 
            value={trackingUrl}
            size={128}
            level="H"
            includeMargin
          />
        </div>

        <div className="w-full max-w-xl space-y-4">
          <p className="text-sm text-gray-600">
            Scan this QR code or share the link below to track this order:
          </p>

          <div className="flex flex-col sm:flex-row gap-2">
            <div className="relative group flex-1 min-w-0">
              <div className="bg-gray-50 px-3 py-2 rounded border text-sm">
                <div className="truncate" title={trackingUrl}>
                  {trackingUrl}
                </div>
              </div>
              <div className="hidden group-hover:block absolute left-0 right-0 bottom-full mb-2 p-2 bg-gray-900 text-white text-xs rounded whitespace-normal break-all">
                {trackingUrl}
              </div>
            </div>
            <button
              onClick={handleCopyLink}
              className="flex-shrink-0 flex items-center justify-center gap-2 px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600 transition whitespace-nowrap"
            >
              {copied ? (
                <>
                  <Check className="h-4 w-4" />
                  <span>Copied!</span>
                </>
              ) : (
                <>
                  <Copy className="h-4 w-4" />
                  <span>Copy</span>
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}