defmodule FoodOrderWeb.PageLive.PageLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest

  alias FoodOrder.ProductsFixtures

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
    product = ProductsFixtures.product_fixture()

    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "[data-role=product-item][data-id=#{product.id}]")
    assert has_element?(view, "[data-role=product-item][data-id=#{product.id}] > img")

    assert has_element?(
             view,
             "[data-role=product-item-details][data-id=#{product.id}] > h2",
             product.name
           )

    assert has_element?(
             view,
             "[data-role=product-item-details][data-id=#{product.id}] > span",
             Atom.to_string(product.size)
           )

    assert has_element?(
             view,
             "[data-role=product-item-details][data-id=#{product.id}] > div > span",
             Money.to_string(product.price)
           )

    assert view
           |> element("[data-role=product-item-details][data-id=#{product.id}] > div > button")
           |> render() =~ "add"
  end
end
