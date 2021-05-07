import React from 'react';
import { useProductsStore } from './ProductContext';

export const CartComponent = () => {
  const store = useProductsStore();

  return (
    <ul>
      {store.products.map((product) => (
        <li key={product.description}>{product.description}</li>
      ))}
    </ul>
  );
};
