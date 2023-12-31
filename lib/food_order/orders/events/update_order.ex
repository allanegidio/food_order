defmodule FoodOrder.Orders.Events.UpdateOrder do
  @moduledoc """
    A module responsible for have all events relate a update order
  """

  alias Phoenix.PubSub

  @pubsub FoodOrder.PubSub
  @topic_admin "update_admin_order"
  @topic_user "update_user_order"
  @topic_order "update_order"

  def subscribe_admin, do: PubSub.subscribe(@pubsub, @topic_admin)

  def broadcast_admin({:ok, order}, old_status) do
    PubSub.broadcast(@pubsub, @topic_admin, {:updated_admin_order, order, old_status})
  end

  def broadcast_admin({:error, _} = error), do: error

  def subscribe_user(user_id), do: PubSub.subscribe(@pubsub, @topic_user <> ":#{user_id}")

  def broadcast_user({:ok, order}) do
    PubSub.broadcast(@pubsub, @topic_user <> ":#{order.user_id}", {:updated_user_order, order})
  end

  def broadcast_user({:error, _} = error), do: error

  def subscribe_order(order_id), do: PubSub.subscribe(@pubsub, @topic_order <> ":#{order_id}")

  def broadcast_order({:ok, order}) do
    PubSub.broadcast(@pubsub, @topic_order <> ":#{order.id}", {:updated_order, order})
  end

  def broadcast_order({:error, _} = error), do: error
end
