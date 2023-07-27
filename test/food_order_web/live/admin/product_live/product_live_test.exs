defmodule FoodOrderWeb.Admin.ProductLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.ProductsFixtures

  @create_attrs %{
    description: "some description",
    name: "some name",
    price: 42,
    size: :small,
    image_url: "product_1.jpeg"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    price: 43,
    size: :medium
  }
  @invalid_attrs %{description: nil, name: nil, price: nil, size: nil}

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_products(_) do
    products =
      for _ <- 1..10, into: [] do
        product_fixture()
      end

    %{products: products}
  end

  describe "Index" do
    setup [:create_product, :register_and_log_in_admin]

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/products")

      assert html =~ "Listing Products"
      assert html =~ product.description
    end

    test "saves new product", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/products")

      assert index_live |> element("a", "New Product") |> render_click() =~
               "New Product"

      assert_patch(index_live, ~p"/admin/products/new")

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#product-form", product: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/products")

      html = render(index_live)
      assert html =~ "Product created successfully"
      assert html =~ "some description"
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/products")

      assert index_live |> element("#products-#{product.id} a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(index_live, ~p"/admin/products/#{product}/edit")

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#product-form", product: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/products")

      html = render(index_live)
      assert html =~ "Product updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/products")

      assert index_live |> element("#products-#{product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#products-#{product.id}")
    end
  end

  describe "Show" do
    setup [:create_product, :register_and_log_in_admin]

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/products/#{product}")

      assert html =~ "Show Product"
      assert html =~ product.description
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/products/#{product}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(show_live, ~p"/admin/products/#{product}/show/edit")

      assert show_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#product-form", product: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/products/#{product}")

      html = render(show_live)
      assert html =~ "Product updated successfully"
      assert html =~ "some updated description"
    end
  end

  describe "filter products" do
    setup [:create_products, :register_and_log_in_admin]

    test "search by name", %{conn: conn, products: products} do
      product_1 = Enum.at(products, 0)
      product_2 = Enum.at(products, 1)

      {:ok, view, _html} = live(conn, ~p"/admin/products")

      product_1_id = "#products-#{product_1.id}"
      product_2_id = "#products-#{product_2.id}"

      assert has_element?(view, product_1_id)
      assert has_element?(view, product_2_id)

      view
      |> form("[phx-submit=filter_by_name]", %{name: product_1.name})
      |> render_submit()

      assert has_element?(view, product_1_id)
      refute has_element?(view, product_2_id)
    end

    test "search by name without results", %{conn: conn, products: products} do
      product_1 = Enum.at(products, 0)
      product_2 = Enum.at(products, 1)

      {:ok, view, _html} = live(conn, ~p"/admin/products")

      product_1_id = "#products-#{product_1.id}"
      product_2_id = "#products-#{product_2.id}"

      assert has_element?(view, product_1_id)
      assert has_element?(view, product_2_id)

      view
      |> form("[phx-submit=filter_by_name]", %{name: "unknow name"})
      |> render_submit()

      refute has_element?(view, product_1_id)
      refute has_element?(view, product_2_id)

      html = render(view)
      assert html =~ "There is no product with unknow name"
    end

    test "search by name empty", %{conn: conn, products: products} do
      product_1 = Enum.at(products, 0)
      product_2 = Enum.at(products, 1)

      {:ok, view, _html} = live(conn, ~p"/admin/products")

      product_1_id = "#products-#{product_1.id}"
      product_2_id = "#products-#{product_2.id}"

      assert has_element?(view, product_1_id)
      assert has_element?(view, product_2_id)

      view
      |> form("[phx-submit=filter_by_name]", %{name: ""})
      |> render_submit()

      assert has_element?(view, product_1_id)
      assert has_element?(view, product_2_id)
    end

    test "suggest product names", %{conn: conn, products: products} do
      product_1 = Enum.at(products, 0)

      {:ok, view, _html} = live(conn, ~p"/admin/products")

      assert view |> element("#names") |> render() =~ ~s(<datalist id="names"></datalist>)

      view
      |> form("[phx-submit=filter_by_name]", %{name: product_1.name})
      |> render_change()

      assert view |> element("#names") |> render() =~ product_1.name
    end
  end

  describe "sort" do
    setup [:create_products, :register_and_log_in_admin]

    test "list all products sorted by name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/admin/products")

      view |> element("th > a", "Name") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&page=1&per_page=5&sort_by=name&sort_order=asc"
      )

      view |> element("th > a", "Name") |> render_click()

      assert_patched(
        view,
        ~p"/admin/products?name=&page=1&per_page=5&sort_by=name&sort_order=desc"
      )
    end
  end
end
