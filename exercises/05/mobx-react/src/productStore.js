import { nanoid } from 'nanoid';

export function createProductStore() {
  return {
    products: [],
    addProduct(description) {
      this.products.push({
        description,
        id: nanoid(),
      });
    },
    removeProduct(id) {
      this.products = this.products.filter((product) => product.id !== id);
    },
  };
}
