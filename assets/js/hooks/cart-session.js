const CartSession = {
  mounted() {
    this.handleEvent("create_cart_session_id", map => {
      console.log(map)
      let {cartId: cartId} = map

      sessionStorage.setItem("cart_id", cartId)
    })
  }
}
export default CartSession