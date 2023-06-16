defmodule FoodOrder.Mailer do
  @moduledoc """
   Module of config Swoosh to use our app
  """

  use Swoosh.Mailer, otp_app: :food_order
end
