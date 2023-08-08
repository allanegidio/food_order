defmodule FoodOrderWeb.Admin.OrderLive.Index.Layer do
  use FoodOrderWeb, :live_component

  alias FoodOrder.Orders
  alias FoodOrderWeb.Admin.OrderLive.Index.Layer.Card

  def update(assigns, socket) do
    status = String.to_atom(assigns.id)
    orders = Orders.list_orders_by_status(status)

    socket =
      socket
      |> assign(assigns)
      |> assign(cards: orders)

    {:ok, socket}
  end

  def handle_event(
        "change_status",
        %{"new_status" => new_status, "old_status" => old_status},
        socket
      )
      when new_status == old_status,
      do: {:noreply, socket}

  def handle_event("change_status", params, socket) do
    %{"new_status" => new_status, "old_status" => old_status, "order_id" => order_id} = params

    Orders.handle_update_order_status(order_id, old_status, new_status)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex-shrink-0 p-3 w-80 rounded-md m-2 bg-gray-100">
      <h3 class="text-sm font-medium uppercase text-gray-900">
        <%= Phoenix.Naming.humanize(@id) %>
      </h3>

      <ul class="mt-2" id={@id} phx-hook="Drag">
        <.live_component :for={card <- @cards} module={Card} id={card.id} card={card} />
      </ul>
    </div>
    """
  end
end
