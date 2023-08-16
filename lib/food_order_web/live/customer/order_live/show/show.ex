defmodule FoodOrderWeb.Customer.OrderLive.Show do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Orders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket) do
      Orders.subscribe_update_order(id)
    end

    order = Orders.get_order!(id)
    list_status = Orders.list_status()

    socket =
      socket
      |> assign(list_status: list_status)
      |> assign(page_title: "Show Order")
      |> assign(order: order)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:updated_order, order}, socket) do
    socket = assign(socket, order: order)

    {:noreply, socket}
  end

  def get_icon(%{status: :not_started} = assigns) do
    ~H"""
    <Heroicons.face_frown outline class="h-10 w-10 stroke-current" />
    """
  end

  def get_icon(%{status: :received} = assigns) do
    ~H"""
    <Heroicons.receipt_percent outline class="h-10 w-10 stroke-current" />
    """
  end

  def get_icon(%{status: :preparing} = assigns) do
    ~H"""
    <Heroicons.building_storefront outline class="h-10 w-10 stroke-current" />
    """
  end

  def get_icon(%{status: :delivering} = assigns) do
    ~H"""
    <Heroicons.truck outline class="h-10 w-10 stroke-current" />
    """
  end

  def get_icon(%{status: :delivered} = assigns) do
    ~H"""
    <Heroicons.face_smile outline class="h-10 w-10 stroke-current" />
    """
  end
end
