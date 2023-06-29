defmodule FoodOrder.Repo.Migrations.AddUserRoles do
  use Ecto.Migration

  def change do
    query = "CREATE TYPE roles as ENUM('USER', 'MANAGER', 'ADMIN')"
    drop = "DROP TYPE roles"

    execute(query, drop)

    alter table(:users) do
      add :role, :roles, default: "USER", null: false
    end
  end
end
