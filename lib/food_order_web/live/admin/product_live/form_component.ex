defmodule FoodOrderWeb.Admin.ProductLive.FormComponent do
  use FoodOrderWeb, :live_component

  alias FoodOrder.Products
  alias FoodOrder.Products.Product

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)
      |> allow_upload(:image_url,
        accept: [".jpeg", ".jpg", ".png"],
        max_entries: 5,
        max_file_size: 1
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def handle_event("cancel", %{"image" => image}, socket) do
    {:noreply, cancel_upload(socket, :image_url, image)}
  end

  def error_to_string(:too_large), do: "Too large"

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:price]} label="Price" />
        <.input
          field={@form[:size]}
          type="select"
          label="Size"
          prompt="Choose a value"
          options={Product.size_values()}
        />
        <.input field={@form[:description]} type="text" label="Description" />
        <.live_file_input upload={@uploads.image_url} />

        <div :for={entry <- @uploads.image_url.entries} class="flex items-center justify-between">
          <figure>
            <.live_img_preview entry={entry} class="w-16 h-16" />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>

          <p :for={err <- upload_errors(@uploads.image_url, entry)} class="text-red-500">
            <%= error_to_string(err) %>
          </p>

          <button phx-click="cancel" phx-target={@myself} phx-value-image={entry.ref}>
            <Heroicons.x_mark outline class="h-5 w-5 text-red-500 stroke-current" />
          </button>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
