defmodule FoodOrder.CartsTest do
  use FoodOrder.DataCase

  alias FoodOrder.Carts
  alias FoodOrder.Carts.Data.Cart
  alias FoodOrder.ProductsFixtures

  describe "create" do
    test "create cart" do
      assert Carts.create(123) == :ok
    end
  end

  describe "add product" do
    test "add product on cart" do
      product = ProductsFixtures.product_fixture()
      cart_id = Ecto.UUID.generate()

      Carts.create(cart_id)
      Carts.add_product(cart_id, product)

      assert %Cart{total_items: 1} = Carts.get_cart(cart_id)
    end

    test "increment same product on cart" do
      product = ProductsFixtures.product_fixture()
      cart_id = Ecto.UUID.generate()

      Carts.create(cart_id)
      Carts.add_product(cart_id, product)
      Carts.increment_product(cart_id, product.id)

      assert %Cart{total_items: 2} = Carts.get_cart(cart_id)
    end
  end

  describe "remove product" do
    test "remove product on cart" do
      cart_id = Ecto.UUID.generate()
      product_1 = ProductsFixtures.product_fixture()
      product_2 = ProductsFixtures.product_fixture()

      Carts.create(cart_id)
      Carts.add_product(cart_id, product_1)
      Carts.add_product(cart_id, product_2)

      assert %Cart{total_items: 2} = Carts.get_cart(cart_id)

      Carts.remove_product(cart_id, product_2.id)

      assert %Cart{total_items: 1} = Carts.get_cart(cart_id)
    end

    test "decrement product on cart" do
      product = ProductsFixtures.product_fixture()
      cart_id = Ecto.UUID.generate()

      Carts.create(cart_id)
      Carts.add_product(cart_id, product)
      Carts.add_product(cart_id, product)
      Carts.decrement_product(cart_id, product.id)

      assert %Cart{total_items: 1} = Carts.get_cart(cart_id)
    end
  end
end
