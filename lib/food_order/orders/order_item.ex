defmodule FoodOrder.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodOrder.Products.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_items" do
    field :quantity, :integer
    field :order_id, :binary_id

    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
