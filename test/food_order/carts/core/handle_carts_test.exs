defmodule FoodOrder.Carts.Core.HandleCartsTest do
  use FoodOrder.DataCase

  import FoodOrder.ProductsFixtures

  alias FoodOrder.Carts.Core.HandleCarts
  alias FoodOrder.Carts.Data.Cart

  @start_cart %Cart{
    id: 123,
    items: [],
    total_items: 0,
    total_price: %Money{amount: 0, currency: :USD}
  }

  describe "crud operations at cart" do
    test "should create a new cart" do
      assert @start_cart == HandleCarts.create_cart(123)
    end

    test "should add a product into cart" do
      product = product_fixture()

      cart = HandleCarts.add_product(@start_cart, product)

      assert [%{item: product, qty: 1}] == cart.items
      assert product.price == cart.total_price
      assert 1 == cart.total_items
    end

    test "should add two same product into cart" do
      product = product_fixture()
      total_price = Money.add(product.price, product.price)

      cart =
        @start_cart
        |> HandleCarts.add_product(product)
        |> HandleCarts.add_product(product)

      assert [%{item: product, qty: 2}] == cart.items
      assert total_price == cart.total_price
      assert 2 == cart.total_items
    end

    test "remove a product from cart" do
      product = product_fixture()
      product_2 = product_fixture()

      total_price =
        Money.new(0)
        |> Money.add(product.price)
        |> Money.add(product.price)
        |> Money.add(product_2.price)

      cart =
        @start_cart
        |> HandleCarts.add_product(product)
        |> HandleCarts.add_product(product)
        |> HandleCarts.add_product(product_2)

      assert total_price == cart.total_price
      assert [%{item: product, qty: 2}, %{item: product_2, qty: 1}] == cart.items

      cart = HandleCarts.remove_product(cart, product.id)

      assert 1 == cart.total_items
      assert product_2.price == cart.total_price
    end
  end

  describe "increment and decrease product on cart" do
    test "increment quantity of the same product on cart" do
      product = product_fixture()
      total_price = Money.multiply(product.price, 3)

      cart =
        @start_cart
        |> HandleCarts.add_product(product)
        |> HandleCarts.add_product(product)
        |> HandleCarts.increment_product(product.id)

      assert 3 == cart.total_items
      assert total_price == cart.total_price
    end

    test "decrement quantity of the same product on cart" do
      product = product_fixture()

      cart =
        @start_cart
        |> HandleCarts.add_product(product)
        |> HandleCarts.add_product(product)
        |> HandleCarts.decrement_product(product.id)

      assert 1 == cart.total_items
      assert product.price == cart.total_price
    end

    test "decrement quantity of the same product on cart until remove the product" do
      product = product_fixture()

      cart =
        @start_cart
        |> HandleCarts.add_product(product)
        |> HandleCarts.add_product(product)
        |> HandleCarts.decrement_product(product.id)
        |> HandleCarts.decrement_product(product.id)

      assert 0 == cart.total_items
      assert [] == cart.items
    end
  end
end
