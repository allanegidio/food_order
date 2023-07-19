defmodule FoodOrderWeb.CartLive.CartDetails.Item.CartItem do
  use FoodOrderWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex items-center my-8 shadow-lg p-2 hover:bg-neutral-200">
      <img src={~p"/images/#{@item.item.image_url}"} class="h-16 w-16 rounded-full" />

      <div class="flex-1 ml-4">
        <h1><%= @item.item.name %></h1>
        <span><%= @item.item.size %></span>
      </div>

      <div class="flex-1">
        <div class="flex items-center">
          <button class="p-1 m-2 rounded-full font-bold text-white bg-red-500">-</button>
          <span><%= @item.qty %> Items(s)</span>
          <button class="p-1 m-2 rounded-full font-bold text-white bg-red-500">+</button>
        </div>
      </div>

      <div class="flex flex-col">
        <span class="font-bold text-lg"><%= @item.item.price %></span>
        <button class="mx-auto">
          <Heroicons.trash solid class="w-8 h-8 text-red-500" />
        </button>
      </div>
    </div>
    """
  end
end
