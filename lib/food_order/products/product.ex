defmodule FoodOrder.Products.Product do
  @moduledoc """
    Ecto schema from products
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @size_values [:small, :medium, :large]

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, Money.Ecto.Amount.Type
    field :size, Ecto.Enum, values: @size_values, default: :small, null: false
    field :image_url, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :size, :description, :image_url])
    |> validate_required([:name, :price, :size, :description, :image_url])
  end

  def size_values, do: @size_values
end
