defmodule FoodOrderWeb.CartLive do
  use FoodOrderWeb, :live_view

  alias FoodOrderWeb.CartLive.CartDetails
  alias FoodOrder.Carts

  def mount(_params, _session, socket) do
    cart_id = socket.assigns.cart_id

    cart = Carts.get_cart(cart_id)

    {:ok, assign(socket, cart: cart)}
  end

  def handle_info({:update, cart}, socket) do
    {:noreply, assign(socket, cart: cart)}
  end

  def empty_cart(assigns) do
    ~H"""
    <div class="py-16 mx-auto text-center">
      <h1 class="text-3xl font-bold mb-2">Your cart is empty!</h1>
      <p class="text-neutral-500 text-lg mb-12">
        You probably haven't ordered a food yet.
        To order an goood food, go to the main page.
      </p>
      <Heroicons.shopping_bag solid class="w-20 h-20 mx-auto text-red-500" />
      <a
        href={~p"/"}
        class="inline-block px-6 py-2 mt-12 font-bold rounded-full bg-red-500 text-white "
      >
        Go back
      </a>
    </div>
    """
  end
end
