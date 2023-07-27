defmodule FoodOrderWeb.OrderLive.OrderLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.OrdersFixtures

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

  describe "Show" do
    setup [:create_order, :register_and_log_in_user]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, ~p"/orders/#{order}")

      assert html =~ "Show Order"
      assert html =~ order.address
    end

    test "updates order within modal", %{conn: conn, order: order} do
      {:ok, show_live, _html} = live(conn, ~p"/orders/#{order}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(show_live, ~p"/orders/#{order}/show/edit")

      assert show_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#order-form", order: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/orders/#{order}")

      html = render(show_live)
      assert html =~ "Order updated successfully"
      assert html =~ "some updated address"
    end
  end
end
