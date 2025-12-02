import Foundation
import SwiftData

final class CartViewModel: ObservableObject {
    let taxRate: Double = 0.15  // 15% example

    func subtotal(for items: [CartItem]) -> Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    func taxes(for items: [CartItem]) -> Double {
        subtotal(for: items) * taxRate
    }

    func total(for items: [CartItem]) -> Double {
        subtotal(for: items) + taxes(for: items)
    }

    func updateQuantity(
        _ cartItem: CartItem,
        quantity: Int,
        context: ModelContext
    ) {
        cartItem.quantity = max(1, quantity)
        try? context.save()
    }

    func removeItems(
        at offsets: IndexSet,
        from items: [CartItem],
        context: ModelContext
    ) {
        for index in offsets {
            context.delete(items[index])
        }
        try? context.save()
    }

    func clearCart(items: [CartItem], context: ModelContext) {
        for item in items {
            context.delete(item)
        }
        try? context.save()
    }
}
