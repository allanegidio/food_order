defmodule FoodOrderWeb.CartLive.CartLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest

  test "load main elements when cart is empty", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/cart")

    assert has_element?(view, "[data-role=cart]")
    assert has_element?(view, "[data-role=cart] > div > h1", "Your cart is empty!")

    assert has_element?(
             view,
             "[data-role=cart] > div > p",
             "You probably haven't ordered a food yet."
           )

    assert has_element?(
             view,
             "[data-role=cart] > div > p",
             "To order an goood food, go to the main page."
           )

    assert has_element?(view, "[data-role=cart] > div > a", "Go back")
  end
end
