defmodule FoodOrderWeb.Customer.OrderLive.Row do
  use FoodOrderWeb, :live_component

  def update(%{order_updated: order}, socket) do
    {:ok, assign(socket, order: order)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <tr id={@order.id}>
      <td class="px-4 py-2 border">
        <.link href={~p"/customer/orders/#{@order.id}"}><%= @order.id %></.link>
      </td>
      <td class="px-4 py-2 border">
        <%= @order.address %> - <%= @order.phone_number %>
      </td>
      <td class={[
        (@order.status != :delivered && "text-red-500") || "",
        "px-4 py-2 border uppercase"
      ]}>
        <%= Phoenix.Naming.humanize(@order.status) %>
      </td>
      <td class="px-4 py-2 border">
        <%= NaiveDateTime.to_string(@order.updated_at) %>
      </td>
    </tr>
    """
  end
end
