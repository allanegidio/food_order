defmodule FoodOrderWeb.Admin.OrderLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.OrdersFixtures

  @create_attrs %{
    address: "some address",
    phone_number: "some phone_number",
    total_price: 42,
    total_quantity: 42
  }
  @update_attrs %{
    address: "some updated address",
    phone_number: "some updated phone_number",
    total_price: 43,
    total_quantity: 43
  }
  @invalid_attrs %{address: nil, phone_number: nil, total_price: nil, total_quantity: nil}

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:create_order, :register_and_log_in_admin]

    test "lists all orders", %{conn: conn, order: order} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/orders")

      assert html =~ "Listing Orders"
      assert html =~ order.address
    end

    test "saves new order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/orders")

      assert index_live |> element("a", "New Order") |> render_click() =~
               "New Order"

      assert_patch(index_live, ~p"/orders/new")

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#order-form", order: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/orders")

      html = render(index_live)
      assert html =~ "Order created successfully"
      assert html =~ "some address"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/orders")

      assert index_live |> element("#orders-#{order.id} a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(index_live, ~p"/orders/#{order}/edit")

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#order-form", order: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/orders")

      html = render(index_live)
      assert html =~ "Order updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/orders")

      assert index_live |> element("#orders-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#orders-#{order.id}")
    end
  end
end