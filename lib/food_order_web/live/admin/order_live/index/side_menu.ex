defmodule FoodOrderWeb.Admin.OrderLive.Index.SideMenu do
  use FoodOrderWeb, :live_component

  alias FoodOrder.Orders

  def update(assigns, socket) do
    all_status_orders = Orders.get_all_status_orders()

    socket =
      socket
      |> assign(assigns)
      |> assign(status_orders: all_status_orders)
      |> IO.inspect()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id={@id} class="w-80 px-8 py-4 border-r overflow-auto bg-gray-100">
      <nav class="mt-8">
        <h2 class="text-xs font-semibold uppercase text-gray-600">Orders</h2>

        <div class="flex flex-col gap-2">
          <a href="#" class="flex justify-between px-3 py-2 bg-gray-200 rounded-lg">
            <span class="text-sm font-medium text-gray-900">All</span>
            <span class="text-sm font-semibold text-gray-700"><%= @status_orders.all %></span>
          </a>

          <a href="#" class="flex justify-between px-3 py-2 bg-gray-200 rounded-lg">
            <span class="text-sm font-medium text-gray-900">Not Started</span>
            <span class="text-sm font-semibold text-gray-700"><%= @status_orders.not_started %></span>
          </a>

          <a href="#" class="flex justify-between px-3 py-2 bg-gray-200 rounded-lg">
            <span class="text-sm font-medium text-gray-900">Received</span>
            <span class="text-sm font-semibold text-gray-700"><%= @status_orders.received %></span>
          </a>

          <a href="#" class="flex justify-between px-3 py-2 bg-gray-200 rounded-lg">
            <span class="text-sm font-medium text-gray-900">Preparing</span>
            <span class="text-sm font-semibold text-gray-700"><%= @status_orders.preparing %></span>
          </a>

          <a href="#" class="flex justify-between px-3 py-2 bg-gray-200 rounded-lg">
            <span class="text-sm font-medium text-gray-900">Delivering</span>
            <span class="text-sm font-semibold text-gray-700"><%= @status_orders.delivering %></span>
          </a>

          <a href="#" class="flex justify-between px-3 py-2 bg-gray-200 rounded-lg">
            <span class="text-sm font-medium text-gray-900">Delivered</span>
            <span class="text-sm font-semibold text-gray-700"><%= @status_orders.delivered %></span>
          </a>
        </div>
      </nav>
    </div>
    """
  end
end
