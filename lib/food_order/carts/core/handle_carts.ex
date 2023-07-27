defmodule FoodOrder.Carts.Core.HandleCarts do
  @moduledoc """
    Core functionality to handle cart operations
  """
  alias FoodOrder.Carts.Data.Cart

  def create_cart(id) do
    Cart.new(id)
  end

  def add_product(cart, product) do
    total_price = Money.add(cart.total_price, product.price)
    items = add_new_item(cart.items, product)

    %{
      cart
      | items: items,
        total_items: cart.total_items + 1,
        total_price: total_price
    }
  end

  defp add_new_item(items, item) do
    item_exists? = Enum.find(items, &(&1.item.id == item.id))

    if item_exists? == nil do
      items ++ [%{item: item, qty: 1}]
    else
      items
      |> Map.new(fn item -> {item.item.id, item} end)
      |> Map.update!(item.id, &%{&1 | qty: &1.qty + 1})
      |> Map.values()
    end
  end

  def remove_product(cart, product_id) do
    {items, item_removed} = Enum.reduce(cart.items, {[], nil}, &remove_item(&1, &2, product_id))

    total_price_removed = Money.multiply(item_removed.item.price, item_removed.qty)
    total_price = Money.subtract(cart.total_price, total_price_removed)

    %{
      cart
      | items: items,
        total_items: cart.total_items - item_removed.qty,
        total_price: total_price
    }
  end

  defp remove_item(item, acc, product_id) do
    {list, item_acc} = acc

    if item.item.id == product_id do
      {list, item}
    else
      {[item] ++ list, item_acc}
    end
  end

  def increment_product(%{items: items} = cart, product_id) do
    {items_updated, item_updated} =
      Enum.reduce(items, {[], nil}, &increment_product(&1, &2, product_id))

    total_price = Money.add(cart.total_price, item_updated.item.price)

    %{cart | items: items_updated, total_items: cart.total_items + 1, total_price: total_price}
  end

  defp increment_product(item_detail, acc, product_id) do
    {list, item} = acc

    if item_detail.item.id == product_id do
      updated_item = %{item_detail | qty: item_detail.qty + 1}
      {list ++ [updated_item], updated_item}
    else
      {[item_detail] ++ list, item}
    end
  end

  def decrement_product(%{items: items} = cart, product_id) do
    {items_updated, item_updated} =
      Enum.reduce(items, {[], nil}, &decrement_product(&1, &2, product_id))

    total_price = Money.subtract(cart.total_price, item_updated.item.price)

    %{cart | items: items_updated, total_items: cart.total_items - 1, total_price: total_price}
  end

  defp decrement_product(item_detail, acc, product_id) do
    {list, item} = acc

    if item_detail.item.id == product_id do
      updated_item = %{item_detail | qty: item_detail.qty - 1}

      if updated_item.qty == 0 do
        {list, updated_item}
      else
        {list ++ [updated_item], updated_item}
      end
    else
      {[item_detail] ++ list, item}
    end
  end
end
