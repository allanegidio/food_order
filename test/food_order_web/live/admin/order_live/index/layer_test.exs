defmodule FoodOrderWeb.Admin.OrderLive.Index.LayerTest do
  use FoodOrderWeb.ConnCase

  alias FoodOrder.Orders
  alias FoodOrder.OrdersFixtures

  import Phoenix.LiveViewTest

  describe "side menu test" do
    setup [:register_and_log_in_admin]

    test "render main elements", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/orders")
      assert has_element?(view, "h3", "Not started")
    end

    test "change card to another layer", %{conn: conn, user: user} do
      order = OrdersFixtures.order_with_items_fixture(user)

      {:ok, view, _html} = live(conn, ~p"/admin/orders")

      assert has_element?(view, "#not_started>##{order.id}")
      refute has_element?(view, "#preparing>##{order.id}")

      view
      |> element("#not_started")
      |> render_hook("change_status", %{
        "new_status" => "preparing",
        "old_status" => "not_started",
        "order_id" => order.id
      })

      refute has_element?(view, "#not_started>##{order.id}")
      assert has_element?(view, "#preparing>##{order.id}")
    end

    test "change card to same layer", %{conn: conn, user: user} do
      order = OrdersFixtures.order_with_items_fixture(user)

      {:ok, view, _html} = live(conn, ~p"/admin/orders")

      assert has_element?(view, "#not_started>##{order.id}")
      refute has_element?(view, "#preparing>##{order.id}")

      view
      |> element("#not_started")
      |> render_hook("change_status", %{
        "new_status" => "not_started",
        "old_status" => "not_started",
        "order_id" => order.id
      })

      assert has_element?(view, "#not_started>##{order.id}")
      refute has_element?(view, "#preparing>##{order.id}")
    end

    test "send to another layer using the handle_info", %{conn: conn, user: user} do
      order = OrdersFixtures.order_with_items_fixture(user)

      {:ok, view, _html} = live(conn, ~p"/admin/orders")

      assert has_element?(view, "#not_started>##{order.id}")
      refute has_element?(view, "#received>##{order.id}")

      Orders.handle_update_order_status(order.id, "not_started", "received")

      assert has_element?(view, "#received>##{order.id}")
      refute has_element?(view, "#not_started>##{order.id}")
    end
  end
end
