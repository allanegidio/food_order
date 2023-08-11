defmodule FoodOrderWeb.Customer.OrderLive.ShowTest do
  use FoodOrderWeb.ConnCase

  alias FoodOrder.OrdersFixtures

  import Phoenix.LiveViewTest

  describe "Show" do
    setup [:register_and_log_in_user]

    test "displays order", %{conn: conn, user: user} do
      order = OrdersFixtures.order_with_items_fixture(user)

      {:ok, show_live, html} = live(conn, ~p"/customer/orders/#{order.id}")

      assert html =~ "Order #{order.id}"
      assert html =~ "Order: #{order.id}"

      assert has_element?(show_live, "##{order.status}")
      assert has_element?(show_live, "##{order.status}>div>span", "Not started")
    end

    test "send to another layer using the handle_info using pid", %{conn: conn, user: user} do
      order = OrdersFixtures.order_with_items_fixture(user)

      {:ok, view, _html} = live(conn, ~p"/customer/orders/#{order.id}")

      assert view |> element("#not_started") |> render() =~ "text-red-500"
      refute view |> element("#received") |> render() =~ "text-red-500"

      order = Map.put(order, :status, :received)
      send(view.pid, {:updated_order, order})

      assert view |> element("#not_started") |> render() =~ "text-red-500"
      assert view |> element("#received") |> render() =~ "text-red-500"
    end
  end
end
