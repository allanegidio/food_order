defmodule FoodOrder.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodOrder.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: 42,
        size: :small,
        image_url: "product_#{Enum.random(1..5)}.jpeg"
      })
      |> FoodOrder.Products.create_product()

    product
  end
end
