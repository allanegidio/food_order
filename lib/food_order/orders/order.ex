defmodule FoodOrder.Orders.Order do
  @moduledoc """
    Schema of Orders
  """

  use Ecto.Schema

  alias FoodOrder.Accounts.User
  alias FoodOrder.Orders.OrderItem

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @status_values [:not_started, :received, :preparing, :delivering, :delivered]

  schema "orders" do
    field(:address, :string)
    field(:phone_number, :string)
    field(:total_price, Money.Ecto.Amount.Type)
    field(:total_quantity, :integer)
    field(:status, Ecto.Enum, values: @status_values, default: :not_started, null: false)

    belongs_to(:user, User)
    has_many(:order_items, OrderItem)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_price, :total_quantity, :address, :phone_number, :status, :user_id])
    |> validate_required([:total_price, :total_quantity, :address, :phone_number, :user_id])
    |> validate_number(:total_quantity, greater_than: 0)
    |> cast_assoc(:order_items, with: &OrderItem.changeset/2)
  end
end
