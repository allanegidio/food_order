defmodule FoodOrder.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodOrder.Orders` context.
  """

  alias FoodOrder.ProductsFixtures
  alias FoodOrder.AccountsFixtures
  alias FoodOrder.ProductsFixtures

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    {:ok, order} =
      attrs
      |> Enum.into(%{
        address: "some address",
        phone_number: "some phone_number",
        total_price: 42,
        total_quantity: 42,
        user_id: user.id
      })
      |> FoodOrder.Orders.create_order()

    order
  end

  @doc """
  Generate a order.
  """
  def order_with_items_fixture(user \\ nil, attrs \\ %{}) do
    user = user || AccountsFixtures.user_fixture()

    product_1 = ProductsFixtures.product_fixture()
    product_2 = ProductsFixtures.product_fixture()
    product_3 = ProductsFixtures.product_fixture()

    {:ok, order} =
      attrs
      |> Enum.into(%{
        address: "some address",
        phone_number: "some phone_number",
        total_price: 42,
        total_quantity: 42,
        user_id: user.id,
        order_items: [
          %{
            product_id: product_1.id,
            quantity: 1
          },
          %{
            product_id: product_2.id,
            quantity: 2
          },
          %{
            product_id: product_3.id,
            quantity: 3
          }
        ]
      })
      |> FoodOrder.Orders.create_order()

    order
  end
end
