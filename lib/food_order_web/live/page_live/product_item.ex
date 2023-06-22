defmodule FoodOrderWeb.PageLive.ProductItem do
  use FoodOrderWeb, :live_component

  def product_info(assigns) do
    ~H"""
    <img src={~p"/images/#{@product.image_url}"} class="h-40 mb-4 mx-auto" />

    <div class="text-center" data-role="product-item-details" data-id={@product.id}>
      <h2 class="mb-4 text-lg"><%= @product.name %></h2>
      <span class="bg-neutral-200 py-1 px-4 rounded-full uppercase text-xs">
        <%= @product.size %>
      </span>
      <div class="mt-6 flex items-center justify-around">
        <span class="font-bold text-lg"><%= @product.price %></span>
        <button class="py-1 px-6 border-2 border-red-500 text-red-500 rounded-full transition hover:bg-red-500 hover:text-neutral-100">
          <span>+</span>
          <span>add</span>
        </button>
      </div>
    </div>
    """
  end
end
