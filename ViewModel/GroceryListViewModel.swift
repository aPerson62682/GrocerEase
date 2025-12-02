import Foundation
import SwiftData

final class GroceryListViewModel: ObservableObject {
    private let repository = GroceryRepository()

    func toggleFavorite(item: GroceryItem, context: ModelContext) {
        repository.toggleFavorite(item, context: context)
    }

    func delete(at offsets: IndexSet, from items: [GroceryItem], context: ModelContext) {
        let toDelete = offsets.map { items[$0] }
        repository.delete(items: toDelete, context: context)
    }

    func addOrUpdateItem(
        existing: GroceryItem?,
        name: String,
        price: Double,
        category: Category?,
        context: ModelContext
    ) {
        if let existing {
            repository.updateItem(existing, name: name, price: price, category: category, context: context)
        } else {
            repository.addItem(name: name, price: price, category: category, context: context)
        }
    }

    func addToCart(item: GroceryItem, context: ModelContext) {
        repository.addToCart(item: item, context: context)
    }
}
