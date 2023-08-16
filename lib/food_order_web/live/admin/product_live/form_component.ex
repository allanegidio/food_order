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
        max_entries: 3
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
    {[image_url | _], []} = uploaded_entries(socket, :image_url)
    image_url = ~p"/uploads/#{get_file_name(image_url)}"
    product_params = Map.put(product_params, "image_url", image_url)

    save_product(socket, socket.assigns.action, product_params)
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image_url, ref)}
  end

  def error_to_string(:too_large), do: "Too large"

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        build_image_url(socket)

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
        build_image_url(socket)

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

  defp get_file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  defp build_image_url(socket) do
    consume_uploaded_entries(socket, :image_url, fn %{path: path}, entry ->
      file_name = get_file_name(entry)
      dest = Path.join("priv/static/uploads", file_name)
      {:ok, File.cp!(path, dest)}
    end)
  end

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

        <div class="container" phx-drop-target={@uploads.image_url.ref}>
          <.live_file_input upload={@uploads.image_url} /> or drag and drop
        </div>

        <div>
          Add up to <%= @uploads.image_url.max_entries %> photos
          (max <%= trunc(@uploads.image_url.max_file_size / 1_000_000) %> mb each)
        </div>

        <article
          :for={entry <- @uploads.image_url.entries}
          class="flex items-center justify-between"
          id={entry.ref}
        >
          <figure class="bg-orange-100 flex flex-col items-center justify-between rounded-md p-4">
            <.live_img_preview entry={entry} class="w-16 h-16" />
            <figcaption class="text-red-800"><%= entry.client_name %></figcaption>
          </figure>

          <div class="flex flex-col w-full items-center p-8">
            <p
              :for={err <- upload_errors(@uploads.image_url, entry)}
              class="text-red-500 flex flex-col"
            >
              <%= error_to_string(err) %>
            </p>
            <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
          </div>

          <button phx-click="cancel" phx-target={@myself} phx-value-ref={entry.ref}>
            <Heroicons.x_mark outline class="h-5 w-5 text-red-500 stroke-current" />
          </button>
        </article>

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
