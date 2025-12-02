import SwiftUI
import SwiftData

@main
struct GrocerEaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Category.self,
            GroceryItem.self,
            CartItem.self
        ])
    }
}
