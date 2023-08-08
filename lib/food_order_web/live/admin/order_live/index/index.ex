defmodule FoodOrderWeb.Admin.OrderLive.Index do
  use FoodOrderWeb, :live_view

  alias FoodOrder.Orders
  alias FoodOrder.Orders.Order

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

  def handle_info({:updated_admin_order, %{status: new_status}, old_status}, socket) do
    send_update(Layer, id: old_status)
    send_update(Layer, id: Atom.to_string(new_status))
    send_update(SideMenu, id: "side-menu")

    {:noreply, socket}
  end

  def handle_info({:new_order, %{status: status}}, socket) do
    send_update(Layer, id: Atom.to_string(status))
    send_update(SideMenu, id: "side-menu")

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Orders.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_info({FoodOrderWeb.OrderLive.FormComponent, {:saved, order}}, socket) do
    {:noreply, stream_insert(socket, :orders, order)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = Orders.get_order!(id)
    {:ok, _} = Orders.delete_order(order)

    {:noreply, stream_delete(socket, :orders, order)}
  end
end
