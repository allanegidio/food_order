defmodule FoodOrder.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :total_price, :integer, default: 0
      add :total_quantity, :integer, default: 0
      add :status, :string, default: "not_started", null: false
      add :address, :string, null: false
      add :phone_number, :string, null: false
      add :user_id, references(:users, on_delete: :nilify_all, type: :binary_id, null: false)

      timestamps()
    end

    create index(:orders, [:user_id])
  end
end
