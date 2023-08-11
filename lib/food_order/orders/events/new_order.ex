defmodule FoodOrder.Orders.Events.NewOrder do
  @moduledoc """
    A module pubsub to receive new orders events
  """

  alias Phoenix.PubSub

  @pubsub FoodOrder.PubSub
  @topic "new_order"

  def subscribe, do: PubSub.subscribe(@pubsub, @topic)

  def broadcast({:ok, order}) do
    PubSub.broadcast(@pubsub, @topic, {:new_order, order})
  end

  def broadcast({:error, _} = error), do: error
end
