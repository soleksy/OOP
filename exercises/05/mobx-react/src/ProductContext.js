import React from 'react';
import { createProductStore } from './productStore';
import { useLocalStore } from 'mobx-react';

const ProductsContext = React.createContext(null);

export const ProductsProvider = ({ children }) => {
  const productsStore = useLocalStore(createProductStore);

  return (
    <ProductsContext.Provider value={productsStore}>
      {children}
    </ProductsContext.Provider>
  );
};

export const useProductsStore = () => React.useContext(ProductsContext);
