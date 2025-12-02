import Foundation
import SwiftData

/// Central place for CRUD on SwiftData models
final class GroceryRepository {

    func addItem(
        name: String,
        price: Double,
        category: Category?,
        context: ModelContext
    ) {
        let item = GroceryItem(name: name, price: price, category: category)
        context.insert(item)
        try? context.save()
    }

    func updateItem(
        _ item: GroceryItem,
        name: String,
        price: Double,
        category: Category?,
        context: ModelContext
    ) {
        item.name = name
        item.price = price
        item.category = category
        try? context.save()
    }

    func delete(items: [GroceryItem], context: ModelContext) {
        for item in items {
            context.delete(item)
        }
        try? context.save()
    }

    func toggleFavorite(
        _ item: GroceryItem,
        context: ModelContext
    ) {
        item.isFavorite.toggle()
        try? context.save()
    }

    func addToCart(
        item: GroceryItem,
        context: ModelContext
    ) {
        // if exists, +1; else create
        let descriptor = FetchDescriptor<CartItem>()
        if let existing = (try? context.fetch(descriptor))?.first(where: { $0.item == item }) {
            existing.quantity += 1
        } else {
            let cartItem = CartItem(item: item, quantity: 1)
            context.insert(cartItem)
        }
        try? context.save()
    }
}
