defmodule FoodOrder.Orders.Handlers.HandleUpdateOrderStatus do
  alias FoodOrder.Orders.Events.UpdateOrder
  alias FoodOrder.Orders

  def execute(order_id, old_status, new_status) do
    order = Orders.get_order!(order_id)

    case Orders.update_order_status(order, new_status) do
      {:ok, _updated_order} = result ->
        UpdateOrder.broadcast_admin(result, old_status)
        UpdateOrder.broadcast_user(result)
        UpdateOrder.broadcast_order(result)

        result

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
