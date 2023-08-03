defmodule FoodOrder.Orders.Handlers.HandleCreateOrder do
  alias FoodOrder.Orders
  alias FoodOrder.Carts
  alias FoodOrder.Orders.Events.NewOrder

  def execute(%{"current_user_id" => current_user_id} = params) do
    cart = Carts.get_cart(current_user_id)
    attrs = build_attrs(cart, params)

    case Orders.create_order(attrs) do
      {:ok, order} = result ->
        NewOrder.broadcast(result)
        Carts.delete(current_user_id)

        result

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp build_attrs(cart, params) do
    products = Enum.map(cart.items, &%{quantity: &1.qty, product_id: &1.item.id})

    %{
      phone_number: params["phone_number"],
      address: params["address"],
      user_id: params["current_user_id"],
      items: products,
      total_quantity: cart.total_items,
      total_price: cart.total_price.amount
    }
  end
end
