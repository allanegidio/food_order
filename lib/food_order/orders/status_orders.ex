defmodule FoodOrder.Orders.StatusOrders do
  @moduledoc """
    A struct focused on have all status orders
  """

  defstruct all: nil,
            delivered: nil,
            delivering: nil,
            not_started: nil,
            preparing: nil,
            received: nil
end
