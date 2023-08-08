defmodule FoodOrderWeb.Admin.OrderLive.Index.Layer do
  use FoodOrderWeb, :live_component

  alias FoodOrder.Orders
  alias FoodOrderWeb.Admin.OrderLive.Index.Layer.Card

  def update(assigns, socket) do
    status = String.to_atom(assigns.id)
    orders = Orders.list_orders_by_status(status) |> IO.inspect()

    socket =
      socket
      |> assign(assigns)
      |> assign(cards: orders)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex-shrink-0 p-3 w-80 rounded-md m-2 bg-gray-100">
      <h3 class="text-sm font-medium uppercase text-gray-900">
        <%= Phoenix.Naming.humanize(@id) %>
      </h3>

      <ul class="mt-2" id={@id}>
        <.live_component :for={card <- @cards} module={Card} id={card.id} card={card} />
      </ul>
    </div>
    """
  end
end
