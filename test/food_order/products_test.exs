defmodule FoodOrder.ProductsTest do
  use FoodOrder.DataCase

  import FoodOrder.ProductsFixtures

  alias FoodOrder.Products
  alias FoodOrder.Products.Product

  describe "products" do
    @invalid_attrs %{description: nil, name: nil, price: nil, size: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert product in Products.list_products()
    end

    test "list_suggestions_names/1 returns products names based on given name" do
      product = product_fixture()

      assert "some name"
             |> Products.list_suggestions_names()
             |> Enum.any?(&String.contains?(&1, product.name))
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        price: 42,
        size: :small,
        image_url: "product_1.jpeg"
      }

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.price == %Money{amount: 42, currency: :USD}
      assert product.size == :small
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        price: 43,
        size: :medium
      }

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.price == %Money{amount: 43, currency: :USD}
      assert product.size == :medium
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "product filters" do
    setup :create_products

    test "list_products/1 returns all product filtered by name", %{products: products} do
      product = Enum.random(products)
      filters = [name: product.name]

      assert product in Products.list_products(filters)
    end

    test "list_products/1 returns all product sorted by name", %{products: products} do
      product =
        products
        |> Enum.sort_by(& &1.name, :asc)
        |> Enum.at(0)

      filters = [sort: %{sort_by: :name, sort_order: :asc}]

      result =
        filters
        |> Products.list_products()
        |> Enum.at(0)

      assert product == result
    end

    test "list_products/1 returns all product filtered and sorted by name", %{products: products} do
      product =
        products
        |> Enum.sort_by(& &1.name, :asc)
        |> Enum.at(0)

      filters = [name: product.name, sort: %{sort_by: :name, sort_order: :asc}]

      result =
        filters
        |> Products.list_products()
        |> Enum.at(0)

      assert product == result
    end
  end

  defp create_products(_) do
    products =
      for _ <- 1..10, into: [] do
        product_fixture()
      end

    %{products: products}
  end
end
