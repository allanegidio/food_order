defmodule FoodOrderWeb.Admin.OrderLive.Index.Layer do
  use FoodOrderWeb, :live_component

  alias FoodOrderWeb.Admin.OrderLive.Index.Layer.Card

  @status [:NOT_STARTED, :DELIVERED]

  def update(assigns, socket) do
    cards = [
      %{
        id: Ecto.UUID.generate(),
        status: @status |> Enum.shuffle() |> hd(),
        user: %{email: "admin@domain.com"},
        total_price: Money.new(10_000),
        total_quantity: 2,
        updated_at: NaiveDateTime.utc_now(),
        order_items: [
          %{
            id: Ecto.UUID.generate(),
            quantity: 10,
            product: %{
              name: "Produto Maroto",
              price: Money.new(200)
            }
          },
          %{
            id: Ecto.UUID.generate(),
            quantity: 100,
            product: %{
              name: "Produto Maroto 2",
              price: Money.new(500)
            }
          }
        ]
      }
    ]

    socket = socket |> assign(assigns) |> assign(cards: cards)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex-shrink-0 p-3 w-80 rounded-md m-2 bg-gray-100">
      <h3 class="text-sm font-medium uppercase text-gray-900">
        <%= Phoenix.Naming.humanize(@id) %>
      </h3>

      <ul class="mt-2" id={@id}>
        <.live_component :for={card <- @cards} module={Card} id={card.id} card={card} />
      </ul>
    </div>
    """
  end
end
