import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    var icon: String      // e.g. "🥦", "🍞"

    @Relationship(deleteRule: .cascade, inverse: \GroceryItem.category)
    var items: [GroceryItem] = []

    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}
