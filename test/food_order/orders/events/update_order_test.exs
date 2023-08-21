defmodule FoodOrder.Orders.Events.UpdateOrderTest do
  use FoodOrder.DataCase

  alias FoodOrder.Orders.Events.UpdateOrder

  import FoodOrder.OrdersFixtures
  import FoodOrder.AccountsFixtures

  describe "PubSub Update Order" do
    test "subscribe_admin" do
      UpdateOrder.subscribe_admin()
      assert {:messages, []} == Process.info(self(), :messages)

      UpdateOrder.broadcast_admin({:ok, %{status: :preparing}}, :received)

      assert {:messages, [{:updated_admin_order, %{status: :preparing}, :received}]} ==
               Process.info(self(), :messages)
    end

    test "error broadcast subscribe_admin message" do
      UpdateOrder.subscribe_admin()
      assert {:messages, []} == Process.info(self(), :messages)

      UpdateOrder.broadcast_admin({:error, %{status: :preparing}})

      assert {:messages, []} = Process.info(self(), :messages)
    end

    test "subscribe_user" do
      user = user_fixture()

      UpdateOrder.subscribe_user(user.id)
      assert {:messages, []} == Process.info(self(), :messages)

      UpdateOrder.broadcast_user({:ok, %{status: :preparing, user_id: user.id}})

      assert {:messages, [{:updated_user_order, %{status: :preparing, user_id: user.id}}]} ==
               Process.info(self(), :messages)
    end

    test "error broadcast subscribe_user message" do
      user = user_fixture()

      UpdateOrder.subscribe_user(user.id)
      assert {:messages, []} == Process.info(self(), :messages)

      UpdateOrder.broadcast_user({:error, %{status: :preparing, user_id: user.id}})

      assert {:messages, []} = Process.info(self(), :messages)
    end

    test "subscribe_order" do
      order = order_fixture()

      UpdateOrder.subscribe_order(order.id)
      assert {:messages, []} == Process.info(self(), :messages)

      UpdateOrder.broadcast_order({:ok, %{status: :preparing, id: order.id}})

      assert {:messages, [{:updated_order, %{status: :preparing, id: order.id}}]} ==
               Process.info(self(), :messages)
    end

    test "error broadcast subscribe_order message" do
      order = order_fixture()

      UpdateOrder.subscribe_order(order.id)
      assert {:messages, []} == Process.info(self(), :messages)

      UpdateOrder.broadcast_order({:error, %{status: :preparing, id: order.id}})

      assert {:messages, []} = Process.info(self(), :messages)
    end
  end
end
