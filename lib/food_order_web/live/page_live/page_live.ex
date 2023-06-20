defmodule FoodOrderWeb.PageLive do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Products
  alias FoodOrderWeb.PageLive.ProductItem

  def mount(_params, _session, socket) do
    products = Products.list_products()

    socket = assign(socket, products: products)

    {:ok, socket}
  end
end
