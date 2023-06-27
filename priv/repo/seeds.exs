# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FoodOrder.Repo.insert!(%FoodOrder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias FoodOrder.Accounts
alias FoodOrder.Products
alias FoodOrder.Products.Product

for _ <- 1..10,
    do:
      Products.create_product(%{
        description: "Some Description #{System.unique_integer([:positive])}",
        name: "Some Product #{System.unique_integer([:positive])}",
        price: System.unique_integer([:positive]),
        size: Enum.random(Product.size_values()),
        image_url: "product_#{Enum.random(1..5)}.jpeg"
      })

Accounts.register_user(%{
  email: "admin@domain.com",
  password: "admin@domain.com",
  role: "ADMIN"
})

Accounts.register_user(%{
  email: "user@domain.com",
  password: "user@domain.com",
  role: "USER"
})
