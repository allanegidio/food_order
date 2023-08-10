defmodule FoodOrderWeb.Customer.OrderLive.Index do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Orders
  alias FoodOrderWeb.Customer.OrderLive.Row

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    if connected?(socket),
      do: Orders.subscribe_update_user_orders(current_user.id)

    orders = Orders.list_orders_by_user_id(current_user.id)

    socket = assign(socket, orders: orders)

    {:ok, socket}
  end

  def handle_info({:updated_user_order, order}, socket) do
    send_update(Row, id: order.id, order_updated: order)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto pt-12">
      <table class="w-full table-auto bg-white">
        <thead>
          <th class="px-4 py-2 text-left">Orders</th>
          <th class="px-4 py-2 text-left">Address</th>
          <th class="px-4 py-2 text-left">Status</th>
          <th class="px-4 py-2 text-left">Time</th>
        </thead>
        <tbody>
          <.live_component :for={order <- @orders} module={Row} id={order.id} order={order} />
        </tbody>
      </table>
    </div>
    """
  end
end
