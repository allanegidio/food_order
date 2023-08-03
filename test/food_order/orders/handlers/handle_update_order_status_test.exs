defmodule FoodOrder.Orders.Handlers.HandleUpdateOrderStatusTest do
  use FoodOrder.DataCase

  alias FoodOrder.OrdersFixtures
  alias FoodOrder.AccountsFixtures
  alias FoodOrder.ProductsFixtures
  alias FoodOrder.Orders.Handlers.HandleUpdateOrderStatus

  @tag :esse
  test "return orders by user id" do
    order = OrdersFixtures.order_with_items_fixture()

    assert {:ok, order_updated} =
             HandleUpdateOrderStatus.execute(order.id, order.status, :delivered)

    refute order.status == order_updated.status
  end
end
