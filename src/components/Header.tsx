import React from 'react';
import Logo from './header/Logo';
import MobileMenu from './header/MobileMenu';
import NavigationLinks from './header/NavigationLinks';

export default function Header() {
  return (
    <header className="bg-white shadow-sm sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <nav className="flex justify-between items-center">
          <Logo />
          
          {/* Desktop Navigation */}
          <NavigationLinks className="hidden md:flex items-center space-x-6" />
          
          {/* Mobile Menu */}
          <MobileMenu />
        </nav>
      </div>
    </header>
  );
}