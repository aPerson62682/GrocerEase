import Foundation
import SwiftData

@Model
final class GroceryItem {
    var name: String
    var price: Double
    var isFavorite: Bool
    var category: Category?

    init(name: String,
         price: Double,
         isFavorite: Bool = false,
         category: Category? = nil) {
        self.name = name
        self.price = price
        self.isFavorite = isFavorite
        self.category = category
    }
}
