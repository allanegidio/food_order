defmodule FoodOrderWeb.CartLive.CartDetails do
  alias FoodOrder.Carts
  use FoodOrderWeb, :live_component

  alias FoodOrder.Orders
  alias FoodOrderWeb.CartLive.CartDetails.Item.CartItem

  def handle_event("create_order", unsigned_params, socket) do
    case Orders.create_cart_order(unsigned_params) do
      {:ok, _order} ->
        socket =
          socket
          |> put_flash(:info, "Order created with Success")
          |> push_redirect(to: ~p"/customer/orders")

        {:noreply, socket}

      {:error, _changeset} ->
        socket =
          socket
          |> put_flash(:error, "Something went wrong, please verify your order")
          |> push_redirect(to: ~p"/cart")

        {:noreply, socket}
    end
  end
end
