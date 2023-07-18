defmodule FoodOrder.Carts.Server.CartServer do
  @moduledoc """
    GenServer to maintain cart state
  """

  use GenServer

  alias FoodOrder.Carts.Core.HandleCarts

  @name :cart_server

  def start_link(_) do
    GenServer.start_link(__MODULE__, @name, name: @name)
  end

  def init(name) do
    :ets.new(name, [:set, :public, :named_table])

    {:ok, name}
  end

  def handle_cast({:create_cart, cart_id}, name) do
    case find_cart(name, cart_id) do
      {:error, []} ->
        cart = HandleCarts.create_cart(cart_id)
        :ets.insert(name, {cart_id, cart})

      {:ok, _} ->
        :ok
    end

    {:noreply, name}
  end

  def handle_cast({:add_product, cart_id, product}, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = HandleCarts.add_product(cart, product)

    :ets.insert(name, {cart_id, cart})

    {:noreply, name}
  end

  def handle_call({:get_cart, cart_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)

    {:reply, cart, name}
  end

  def handle_call({:remove_product, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)

    cart = HandleCarts.remove_product(cart, product_id)

    :ets.insert(name, {cart_id, cart})

    {:reply, cart, name}
  end

  def handle_call({:increment_product, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)

    cart = HandleCarts.increment_product(cart, product_id)

    :ets.insert(name, {cart_id, cart})

    {:reply, cart, name}
  end

  def handle_call({:decrement_product, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)

    cart = HandleCarts.decrement_product(cart, product_id)

    :ets.insert(name, {cart_id, cart})

    {:reply, cart, name}
  end

  defp find_cart(name, cart_id) do
    case :ets.lookup(name, cart_id) do
      [] -> {:error, []}
      [{_cart_id, value}] -> {:ok, value}
    end
  end
end
