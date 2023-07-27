defmodule FoodOrder.OrdersTest do
  use FoodOrder.DataCase

  alias FoodOrder.AccountsFixtures
  alias FoodOrder.Orders

  describe "orders" do
    alias FoodOrder.Orders.Order

    import FoodOrder.OrdersFixtures

    @invalid_attrs %{address: nil, phone_number: nil, total_price: nil, total_quantity: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      user = AccountsFixtures.user_fixture()

      valid_attrs = %{
        address: "some address",
        phone_number: "some phone_number",
        total_price: 42,
        total_quantity: 42,
        user_id: user.id
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
end
