defmodule FoodOrderWeb.Admin.OrderLive.Index do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Orders
  alias FoodOrderWeb.Admin.OrderLive.Index.SideMenu
  alias FoodOrderWeb.Admin.OrderLive.Index.Layer

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Orders.subscribe_update_admin_orders()
      Orders.subscribe_new_orders()
    end

    {:ok, stream(socket, :orders, Orders.list_orders())}
  end

  @impl true
  def handle_info({:updated_admin_order, %{status: new_status}, old_status}, socket) do
    send_update(Layer, id: old_status)
    send_update(Layer, id: Atom.to_string(new_status))
    send_update(SideMenu, id: "side-menu")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_order, %{status: status}}, socket) do
    send_update(Layer, id: Atom.to_string(status))
    send_update(SideMenu, id: "side-menu")

    {:noreply, socket}
  end
end
