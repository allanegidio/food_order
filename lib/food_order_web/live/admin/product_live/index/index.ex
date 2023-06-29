defmodule FoodOrderWeb.Admin.ProductLive.Index do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Products
  alias FoodOrder.Products.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :products, Products.list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    live_action = socket.assigns.live_action
    name = params["name"] || ""

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(name: name)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({FoodOrderWeb.Admin.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end

  @impl true
  def handle_event("filter-by-name", params, socket) do
    products = Products.list_products(params)

    {:noreply, stream(socket, :products, products, reset: true)}
  end

  def search_by_name(assigns) do
    ~H"""
    <form phx-submit="filter-by-name">
      <div class="relative">
        <span class="absolute inset-y-2 left-2">
          <Heroicons.magnifying_glass solid class="h-5 w-5 stroke-current" />
        </span>
        <input
          type="text"
          autocomplete="off"
          value={@name}
          name="name"
          placeholder="Search by name"
          class="pl-10 text-sm leading-tight  border rounded-md text-gray-900 border-gray-400 placeholder-gray-600 "
        />
      </div>
    </form>
    """
  end
end
