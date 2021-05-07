import { useObserver } from 'mobx-react';
import React from 'react';
import './App.css';
import { NewProductForm } from './NewProductForm';
import { useProductsStore } from './ProductContext';
import { CartComponent } from './CartComponent';

function App() {
  const productsStore = useProductsStore();

  return useObserver(() => (
    <>
      <ul>
        {productsStore.products.map((product) => (
          <li
            onClick={() => productsStore.removeProduct(product.id)}
            key={product.id}
          >
            {product.description}
          </li>
        ))}
      </ul>
      <NewProductForm />
      <CartComponent />
    </>
  ));
}

export default App;
