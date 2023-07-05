defmodule FoodOrderWeb.PageLive do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Products
  alias FoodOrderWeb.PageLive.ProductItem

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page: 1)
      |> assign(per_page: 5)
      |> list_product()

    {:ok, socket}
  end

  def handle_event("load_more_products", _params, socket) do
    socket =
      socket
      |> update(:page, &(&1 + 1))
      |> list_product()

    {:noreply, socket}
  end

  defp list_product(socket) do
    page = socket.assigns.page
    per_page = socket.assigns.per_page

    paginate = %{page: page, per_page: per_page}
    sort = %{sort_by: :updated_at, sort_order: :desc}
    products = Products.list_products(sort: sort, paginate: paginate)

    assign(socket, products: products)
  end
end
