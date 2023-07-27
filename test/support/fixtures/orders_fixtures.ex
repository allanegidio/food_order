defmodule FoodOrder.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodOrder.Orders` context.
  """

  alias FoodOrder.AccountsFixtures

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
end
