defmodule FoodOrder.Carts do
  @moduledoc """
    Interface to communicate with genserver requests
  """

  @name :cart_server

  def create(cart_id) do
    GenServer.cast(@name, {:create_cart, cart_id})
  end

  def add_product(cart_id, product) do
    GenServer.cast(@name, {:add_product, cart_id, product})
  end

  def remove_product(cart_id, product_id) do
    GenServer.call(@name, {:remove_product, cart_id, product_id})
  end

  def get_cart(cart_id) do
    GenServer.call(@name, {:get_cart, cart_id})
  end

  def increment_product(cart_id, product_id) do
    GenServer.call(@name, {:increment_product, cart_id, product_id})
  end

  def decrement_product(cart_id, product_id) do
    GenServer.call(@name, {:decrement_product, cart_id, product_id})
  end
end
