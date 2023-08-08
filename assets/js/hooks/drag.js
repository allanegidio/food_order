import Sortable from 'sortablejs'

const Drag = {
    mounted() {
        const hook = this
        const selector = `#${this.el.id}`

        new Sortable(this.el, {
            group: 'shared',
            draggable: '.draggable',
            onEnd: function(event) {
                hook.pushEventTo(selector, "change_status", {
                    old_status: event.from.id,
                    new_status: event.to.id,
                    order_id: event.item.id
                })
            }
        })
    }
}

export default Drag