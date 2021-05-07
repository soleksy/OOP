import React from 'react';
import { useProductsStore } from './ProductContext';

export const NewProductForm = () => {
  const [productDescription, setProductDescription] = React.useState('');
  const productsStore = useProductsStore();
  return (
    <>
      <input
        value={productDescription}
        onChange={(e) => setProductDescription(e.target.value)}
        type="text"
      />
      <button onClick={() => productsStore.addProduct(productDescription)}>
        Add Product
      </button>
    </>
  );
};
