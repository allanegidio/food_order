defmodule FoodOrder.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :price, :integer
      add :size, :string, default: "small", null: false
      add :description, :text
      add :image_url, :string

      timestamps()
    end
  end
end
