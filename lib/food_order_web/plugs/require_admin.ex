defmodule FoodOrderWeb.RequireAdmin do
  @moduledoc """
    This module is a plug to verify if user logged in is an Admin user.
  """
  use FoodOrderWeb, :verified_routes

  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    current_user = socket.assigns.current_user

    if current_user.role == :ADMIN do
      {:cont, socket}
    else
      {:halt,
       socket
       |> Phoenix.LiveView.put_flash(:error, "You must be admin to access this page!")
       |> Phoenix.LiveView.redirect(to: ~p"/")}
    end
  end
end
