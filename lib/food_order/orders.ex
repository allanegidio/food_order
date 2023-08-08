defmodule FoodOrder.Orders do
  @moduledoc """
  The Orders context.
  """

  alias FoodOrder.Repo
  alias FoodOrder.Orders.Order
  alias FoodOrder.Orders.OrderQuery
  alias FoodOrder.Orders.StatusOrders
  alias FoodOrder.Orders.Events.NewOrder
  alias FoodOrder.Orders.Events.UpdateOrder
  alias FoodOrder.Orders.Handlers.HandleCreateOrder

  import Ecto.Query, warn: false

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Returns the list of orders by user id.

  ## Examples

      iex> list_orders_by_user_id(user_id)
      [%Order{}, ...]

  """
  def list_orders_by_user_id(user_id) do
    query =
      from(
        o in Order,
        where: o.user_id == ^user_id,
        order_by: [desc: o.inserted_at]
      )

    Repo.all(query)
  end

  @doc """
  Returns the list of orders by status.

  ## Examples

      iex> list_orders_by_user_id(:not_started)
      [%Order{status: :not_started}, ...]

  """
  def list_orders_by_status(status) do
    query =
      from(
        o in Order,
        where: o.status == ^status,
        preload: [:user, order_items: [:product]]
      )

    Repo.all(query)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_status(%Order{} = order, status) do
    order
    |> Order.changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  @doc """
  Returns the all status orders.

  ## Examples

      iex> get_all_status_orders()
      %StatusOrders{not_started: 10, ...}

  """
  def get_all_status_orders() do
    not_started_query = OrderQuery.filter_by_status(Order, :not_started)
    received_query = OrderQuery.filter_by_status(Order, :received)
    preparing_query = OrderQuery.filter_by_status(Order, :preparing)
    delivering_query = OrderQuery.filter_by_status(Order, :delivering)
    delivered_query = OrderQuery.filter_by_status(Order, :delivered)

    %StatusOrders{
      all: Repo.aggregate(Order, :count, :id),
      not_started: Repo.aggregate(not_started_query, :count, :id),
      received: Repo.aggregate(received_query, :count, :id),
      preparing: Repo.aggregate(preparing_query, :count, :id),
      delivering: Repo.aggregate(delivering_query, :count, :id),
      delivered: Repo.aggregate(delivered_query, :count, :id)
    }
  end

  defdelegate create_cart_order(params), to: HandleCreateOrder, as: :execute

  @doc """
    Subscribes to new order pub messages
  """
  defdelegate subscribe_new_orders, to: NewOrder, as: :subscribe

  @doc """
    Broadcast new order to topic
  """
  defdelegate broadcast_new_order(new_order), to: NewOrder, as: :broadcast

  @doc """
    Subscribes to update admin order pub messages
  """
  defdelegate subscribe_update_admin_orders, to: UpdateOrder, as: :subscribe_admin

  @doc """
    Broadcast update admin order to topic
  """
  defdelegate broadcast_update_admin_order(updated_order, old_status),
    to: UpdateOrder,
    as: :broadcast_admin

  @doc """
    Subscribes to update user order pub messages
  """
  defdelegate subscribe_update_user_orders(user_id), to: UpdateOrder, as: :subscribe_user

  @doc """
    Broadcast update user order to topic
  """
  defdelegate broadcast_update_user_order(updated_order),
    to: UpdateOrder,
    as: :broadcast_user

  @doc """
    Subscribes to update order pub messages
  """
  defdelegate subscribe_update_order(order_id), to: UpdateOrder, as: :subscribe_order

  @doc """
    Broadcast update order to topic
  """
  defdelegate broadcast_update_order(updated_order),
    to: UpdateOrder,
    as: :broadcast_order
end
