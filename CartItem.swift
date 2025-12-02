import Foundation
import SwiftData

@Model
final class CartItem {
    var item: GroceryItem
    var quantity: Int

    init(item: GroceryItem, quantity: Int = 1) {
        self.item = item
        self.quantity = quantity
    }

    var subtotal: Double {
        Double(quantity) * item.price
    }
}
