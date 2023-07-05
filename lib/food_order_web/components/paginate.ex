defmodule FoodOrderWeb.Paginate do
  @moduledoc """
   Component Paginate
  """

  use FoodOrderWeb, :live_component

  defp per_page(assigns) do
    ~H"""
    <div class="mr-3">
      <form id="select-per-page" phx-change="update_per_page" phx-target={@myself}>
        <select name="selected-per-page" class="pl-10 text-sm leading-tight border rounded-md">
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="20">20</option>
        </select>
      </form>
    </div>
    """
  end

  def handle_event("update_per_page", %{"selected-per-page" => selected_per_page}, socket) do
    options = Map.put(socket.assigns.options, :per_page, selected_per_page)

    {:noreply, push_patch(socket, to: ~p"/admin/products?#{options}")}
  end

  def render(assigns) do
    ~H"""
    <div id={@id} class="flex pr-4">
      <div>
        <.per_page myself={@myself} />
      </div>
      <div
        :if={@options.page > 1}
        class="h-8 w-8 mr-1 flex justify-center items center cursor-pointer"
      >
        <.link
          patch={~p"/admin/products?#{Map.update(@options, :page, @options.page, &(&1 - 1))}"}
          data-role="previous"
        >
          <Heroicons.backward solid class="h-6 w-6 text-red-500 stroke-current" />
        </.link>
      </div>

      <div class="flex h-8 font-medium">
        <div
          :for={current_page <- (@options.page - 2)..(@options.page + 2)}
          :if={current_page > 0}
          class={[
            (current_page == @options.page && "border-red-500") || "border-transparent",
            "w-8 md:flex justify-center items-center hidden leading-5 cursor-pointer transition
                duration-150 ease-in border-b-2 "
          ]}
        >
          <.link
            :if={current_page <= ceil(@total_products / @options.per_page)}
            patch={~p"/admin/products?#{Map.put(@options, :page, current_page)}"}
          >
            <%= current_page %>
          </.link>
        </div>
      </div>

      <div class="h-8 w-8 mr-1 flex justify-center items center cursor-pointer">
        <%= if (@options.page * @options.per_page) < @total_products do %>
          <.link
            :if={@options.page * @options.per_page < @total_products}
            patch={~p"/admin/products?#{Map.update(@options, :page, @options.page, &(&1 + 1))}"}
            data-role="next"
          >
            <Heroicons.forward solid class="h-6 w-6 text-red-500 stroke-current" />
          </.link>
        <% end %>
      </div>
    </div>
    """
  end
end
