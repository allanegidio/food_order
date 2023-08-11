defmodule FoodOrder.Orders.Handlers.HandleCreateOrderTest do
  use FoodOrder.DataCase

  alias FoodOrder.AccountsFixtures
  alias FoodOrder.Carts
  alias FoodOrder.Orders.Handlers.HandleCreateOrder
  alias FoodOrder.ProductsFixtures

  describe "Handle Create Order Tests" do
    test "execute/1" do
      product_1 = ProductsFixtures.product_fixture()
      product_2 = ProductsFixtures.product_fixture()
      user = AccountsFixtures.user_fixture()

      Carts.create(user.id)
      Carts.add_product(user.id, product_1)
      Carts.add_product(user.id, product_1)
      Carts.add_product(user.id, product_2)

      cart = Carts.get_cart(user.id)

      assert 3 == cart.total_items

      params = %{
        "address" => "Test Address, 123",
        "current_user_id" => user.id,
        "phone_number" => "11987651234"
      }

      {:ok, result} = HandleCreateOrder.execute(params)

      assert 3 == result.total_quantity
      assert user.id == result.user_id
    end

    test "error creating order" do
      user = AccountsFixtures.user_fixture()

      Carts.create(user.id)

      params = %{
        "address" => "123",
        "current_user_id" => user.id,
        "phone_number" => "123"
      }

      {:error, changeset} = HandleCreateOrder.execute(params)

      assert "must be greater than 0" in errors_on(changeset).total_quantity
    end
  end
end
