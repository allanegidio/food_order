defmodule FoodOrderWeb.HeaderComponent do
  use FoodOrderWeb, :html

  def menu(assigns) do
    ~H"""
    <nav class="flex items-center justify-between py-3 text-sm">
      <.link href={~p"/"} id="logo">
        <img src={~p"/images/logo.svg"} class="h-20 w-40" />
      </.link>
      <ul id="menu" class="flex items-center">
        <%= if @current_user do %>
          <li class="text-[0.8125rem] leading-6 text-zinc-900">
            <%= @current_user.email %>
          </li>
          <li class="ml-6">
            <.link
              href={~p"/admin/products"}
              class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
            >
              Admin Products
            </.link>
          </li>
          <li class="ml-6">
            Admin Orders
          </li>
          <li class="ml-6">
            My Orders
          </li>
          <li class="ml-6">
            <.link
              href={~p"/users/settings"}
              class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
            >
              Settings
            </.link>
          </li>
          <li class="ml-6">
            <.link
              href={~p"/users/log_out"}
              method="delete"
              class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
            >
              Log out
            </.link>
          </li>
          <li class="flex ml-6 p-4 bg-red-500 rounded-full text-neutral-100 transition hover:text-neutral-100 hover:bg-red-300 ">
            <a href={~p"/cart"} class="flex">
              <span>0</span>
              <Heroicons.shopping_cart solid class="h-5 w-5 stroke-current" />
            </a>
          </li>
        <% else %>
          <li>
            <.link
              href={~p"/users/register"}
              class="ml-6 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
            >
              Register
            </.link>
          </li>
          <li>
            <.link
              href={~p"/users/log_in"}
              class="ml-6 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
            >
              Log in
            </.link>
          </li>
        <% end %>
      </ul>
    </nav>
    """
  end
end
