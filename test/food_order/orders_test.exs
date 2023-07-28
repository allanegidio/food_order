defmodule FoodOrder.OrdersTest do
  use FoodOrder.DataCase

  alias FoodOrder.AccountsFixtures
  alias FoodOrder.Orders
  alias FoodOrder.Orders.StatusOrders
  alias FoodOrder.ProductsFixtures

  import FoodOrder.OrdersFixtures

  describe "orders" do
    alias FoodOrder.Orders.Order

    @invalid_attrs %{address: nil, phone_number: nil, total_price: nil, total_quantity: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert order in Orders.list_orders()
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      user = AccountsFixtures.user_fixture()
      product_1 = ProductsFixtures.product_fixture()
      product_2 = ProductsFixtures.product_fixture()

      order_items = [
        %{product_id: product_1.id, quantity: 2},
        %{product_id: product_2.id, quantity: 1}
      ]

      valid_attrs = %{
        address: "some address",
        phone_number: "some phone_number",
        total_price: 42,
        total_quantity: 42,
        user_id: user.id,
        order_items: order_items
      }

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.address == "some address"
      assert order.phone_number == "some phone_number"
      assert order.total_price == 42
      assert order.total_quantity == 42
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()

      update_attrs = %{
        address: "some updated address",
        phone_number: "some updated phone_number",
        total_price: 43,
        total_quantity: 43
      }

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.address == "some updated address"
      assert order.phone_number == "some updated phone_number"
      assert order.total_price == 43
      assert order.total_quantity == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()

      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end

  describe "Subscribe pubsub" do
    test "subscribe to receive new events of new order" do
      Orders.subscribe_new_orders()

      assert {:messages, []} == Process.info(self(), :messages)
    end

    test "receive new order message" do
      Orders.subscribe_new_orders()

      assert {:messages, []} == Process.info(self(), :messages)

      order = order_fixture()

      Orders.broadcast_new_order({:ok, order})

      assert {:messages, [{:new_order, order}]} == Process.info(self(), :messages)
    end

    @tag :esse
    test "receive new order error message" do
      Orders.subscribe_new_orders()

      assert {:messages, []} == Process.info(self(), :messages)

      order = order_fixture()

      Orders.broadcast_new_order({:error, order})

      assert {:messages, []} == Process.info(self(), :messages)
    end
  end

  describe "all status orders" do
    test "get all status orders" do
      assert %StatusOrders{
               all: 10,
               delivered: 0,
               delivering: 0,
               not_started: 10,
               preparing: 0,
               received: 0
             } == Orders.get_all_status_orders()
    end
  end
end
