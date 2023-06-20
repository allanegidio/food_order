defmodule FoodOrderWeb.PageLive.PageLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest

  test "load main hero html", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=hero]")
    assert has_element?(view, "[data-role=hero-cta]")
    assert has_element?(view, "[data-role=hero-img]")

    assert view |> element("[data-role=hero-cta] > h6") |> render() =~ "Make your order"
    assert view |> element("[data-role=hero-cta] > h1") |> render() =~ "Right now!"
    assert view |> element("[data-role=hero-cta] > button") |> render() =~ "Order now"
  end

  test "load products list", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=product-section]")
    assert has_element?(view, "[data-role=product-list]")

    assert view |> element("[data-role=product-section] > h1") |> render() =~ "All foods"
  end

  test "load products items", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=product-item][data-id=1]")
    assert has_element?(view, "[data-role=product-item][data-id=1] > img")

    assert has_element?(view, "[data-role=product-item-details][data-id=1] > h2", "Product Name")
    assert has_element?(view, "[data-role=product-item-details][data-id=1] > span", "small")
    assert has_element?(view, "[data-role=product-item-details][data-id=1] > div > span", "$10")

    assert view
           |> element("[data-role=product-item-details][data-id=1] > div > button")
           |> render() =~ "add"
  end
end
