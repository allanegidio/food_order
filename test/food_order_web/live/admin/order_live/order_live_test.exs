defmodule FoodOrderWeb.Admin.OrderLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.OrdersFixtures

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:create_order, :register_and_log_in_admin]

    test "lists all orders", %{conn: conn, order: order} do
      {:ok, index_live, html} = live(conn, ~p"/admin/orders")

      assert html =~ "Listing Orders"
      assert html =~ order.id

      assert has_element?(index_live, "#side-menu")
      assert has_element?(index_live, "[data-role=layers]")
      assert has_element?(index_live, "#not_started")
      assert has_element?(index_live, "#received")
      assert has_element?(index_live, "#preparing")
      assert has_element?(index_live, "#delivering")
      assert has_element?(index_live, "#delivered")
    end
  end
end
