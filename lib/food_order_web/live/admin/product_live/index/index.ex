defmodule FoodOrderWeb.Admin.ProductLive.Index do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Products
  alias FoodOrder.Products.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    live_action = socket.assigns.live_action

    name = params["name"] || ""
    sort_by = (params["sort_by"] || "updated_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    paginate = %{page: page, per_page: per_page}

    sort = %{sort_by: sort_by, sort_order: sort_order}

    options =
      %{}
      |> Map.merge(sort)
      |> Map.merge(%{name: name})
      |> Map.merge(paginate)

    products = Products.list_products(name: name, sort: sort, paginate: paginate)
    total_products = Products.count_products()

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(is_loading: false)
      |> assign(options: options)
      |> assign(names: [])
      |> assign(total_products: total_products)

    {:noreply, stream(socket, :products, products, reset: true)}
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
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end

  @impl true
  def handle_event("filter_by_name", params, socket) do
    socket =
      socket
      |> assign(is_loading: true)
      |> update(:options, &Map.put(&1, :name, params["name"]))

    send(self(), {:filter_product, params})

    {:noreply, stream(socket, :products, [], reset: true)}
  end

  def handle_event("suggest", %{"name" => name}, socket) do
    names = Products.list_suggestions_names(name)

    socket = assign(socket, names: names)

    {:noreply, socket}
  end

  @impl true
  def handle_info({FoodOrderWeb.Admin.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info({:filter_product, params}, socket) do
    params = Map.new(params, fn {k, v} -> {String.to_atom(k), v} end)

    products = Products.list_products(params)

    socket = assign(socket, :is_loading, false)

    {:noreply, handle_stream_response(socket, params, :products, products)}
  end

  defp handle_stream_response(socket, params, :products, []) do
    socket = put_flash(socket, :error, "There is no product with #{params[:name]}")

    stream(socket, :products, [])
  end

  defp handle_stream_response(socket, _params, :products, collection) do
    stream(socket, :products, collection)
  end

  def search_by_name(assigns) do
    ~H"""
    <form phx-submit="filter_by_name" phx-change="suggest">
      <div class="relative">
        <span class="absolute inset-y-2 left-2">
          <Heroicons.magnifying_glass solid class="h-5 w-5 stroke-current" />
        </span>
        <input
          type="text"
          autocomplete="off"
          value={@name}
          name="name"
          list="names"
          placeholder="Search by name"
          class="pl-10 text-sm leading-tight  border rounded-md text-gray-900 border-gray-400 placeholder-gray-600 "
        />
      </div>
    </form>

    <datalist id="names">
      <option :for={name <- @names}><%= name %></option>
    </datalist>
    """
  end
end
