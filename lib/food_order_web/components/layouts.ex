defmodule FoodOrderWeb.Layouts do
  @moduledoc """
    Modules focused on manage all layouts of applications
  """

  use FoodOrderWeb, :html

  embed_templates "layouts/*"
end
