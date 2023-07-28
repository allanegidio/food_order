defmodule FoodOrder.Orders.OrderQuery do
  @moduledoc """
  This module contains queries for the FoodOrder.Orders.OrderQuery schema.
  """

  import Ecto.Query

  @doc """
  Filter only order by status
  """
  def filter_by_status(query, status) do
    from(
      o in query,
      where: o.status == ^status
    )
  end
end
