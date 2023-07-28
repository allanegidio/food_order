defmodule FoodOrder.Orders.StatusOrders do
  defstruct all: nil,
            delivered: nil,
            delivering: nil,
            not_started: nil,
            preparing: nil,
            received: nil
end
