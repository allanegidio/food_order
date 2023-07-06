defmodule FoodOrderWeb.PaginateTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "paginante component" do
    setup [:register_and_log_in_admin]

    @tag :skip
    test "clicking next, preview, and page", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert has_element?(view, "#pages")

      open_browser(view)

      view
      |> element("[data-role=next]")
      |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&page=2&per_page=5&sort_by=updated_at&sort_order=desc"
      )

      view
      |> element("[data-role=previous]")
      |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&page=1&per_page=5&sort_by=updated_at&sort_order=desc"
      )

      view
      |> element("#pages > div > div > a", "2")
      |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&page=2&per_page=5&sort_by=updated_at&sort_order=desc"
      )
    end
  end

  describe "select per page" do
    setup [:register_and_log_in_admin]

    @tag :skip
    test "clicking to change to 20 per pages", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      view
      |> form("#select-per-page", %{"selected-per-page" => 20})
      |> render_change()

      assert_patched(
        view,
        ~p"/admin/products?name=&page=1&per_page=20&sort_by=updated_at&sort_order=desc"
      )
    end
  end
end
