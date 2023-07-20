defmodule FoodOrderWeb.CartLive.CartDetails.Item.CartItem do
  use FoodOrderWeb, :live_component

  alias FoodOrder.Carts

  def handle_event("dec", _params, socket) do
    product_id = socket.assigns.id
    cart_id = socket.assigns.cart_id

    cart = Carts.decrement_product(cart_id, product_id)

    send(self(), {:update, cart})

    {:noreply, socket}
  end

  def handle_event("inc", _params, socket) do
    product_id = socket.assigns.id
    cart_id = socket.assigns.cart_id

    cart = Carts.increment_product(cart_id, product_id)

    send(self(), {:update, cart})

    {:noreply, socket}
  end

  def handle_event("remove", _params, socket) do
    product_id = socket.assigns.id
    cart_id = socket.assigns.cart_id

    cart = Carts.remove_product(cart_id, product_id)

    send(self(), {:update, cart})

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div id={@id} data-role="item" class="flex items-center my-8 shadow-lg p-2 hover:bg-neutral-200">
      <img
        data-role="item-image"
        src={~p"/images/#{@item.item.image_url}"}
        class="h-16 w-16 rounded-full"
      />

      <div class="flex-1 ml-4">
        <h1><%= @item.item.name %></h1>
        <span><%= @item.item.size %></span>
      </div>

      <div class="flex-1" data-role="quantity">
        <div class="flex items-center">
          <button
            data-role="dec"
            data-id={@id}
            phx-click="dec"
            phx-target={@myself}
            class="p-1 m-2 rounded-full font-bold text-white bg-red-500"
          >
            -
          </button>
          <span data-role="items" data-id={@id}><%= @item.qty %> Item(s)</span>
          <button
            data-role="inc"
            data-id={@id}
            phx-click="inc"
            phx-target={@myself}
            class="p-1 m-2 rounded-full font-bold text-white bg-red-500"
          >
            +
          </button>
        </div>
      </div>

      <div class="flex flex-col" data-role="total-item">
        <span class="font-bold text-lg" data-role="price" data-id={@id}><%= @item.item.price %></span>
        <button
          class="mx-auto"
          phx-click="remove"
          data-role="remove"
          data-id={@id}
          phx-target={@myself}
        >
          <Heroicons.trash solid class="w-8 h-8 text-red-500" />
        </button>
      </div>
    </div>
    """
  end
end
