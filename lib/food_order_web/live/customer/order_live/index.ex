defmodule FoodOrderWeb.Customer.OrderLive.Index do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Orders

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    if connected?(socket), do: Orders.subscribe_update_user_orders(current_user.id)

    orders = Orders.list_orders_by_user_id(current_user.id)

    socket = assign(socket, orders: orders)

    {:ok, socket}
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
          <tr :for={order <- @orders} id={order.id}>
            <td class="px-4 py-2 border">
              <.link href={~p"/customer/order-status/#{order.id}"}><%= order.id %></.link>
            </td>
            <td class="px-4 py-2 border">
              <%= order.address %> - <%= order.phone_number %>
            </td>
            <td class={[
              (order.status != :delivered && "text-red-500") || "",
              "px-4 py-2 border uppercase"
            ]}>
              <%= Phoenix.Naming.humanize(order.status) %>
            </td>
            <td class="px-4 py-2 border">
              <%= NaiveDateTime.to_string(order.updated_at) %>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
