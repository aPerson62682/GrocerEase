import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = CartViewModel()

    @Query(sort: \CartItem.item.name)
    private var cartItems: [CartItem]

    var body: some View {
        List {
            Section("Items") {
                ForEach(cartItems) { cartItem in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(cartItem.item.name)
                                .font(.headline)
                            Text(cartItem.item.price, format: .currency(code: "CAD"))
                                .font(.caption)
                        }
                        Spacer()
                        Stepper(value: Binding(
                            get: { cartItem.quantity },
                            set: { newVal in
                                viewModel.updateQuantity(cartItem, quantity: newVal, context: context)
                            }
                        ), in: 1...99) {
                            Text("Qty: \(cartItem.quantity)")
                        }
                        .frame(maxWidth: 150)

                        Text(cartItem.subtotal, format: .currency(code: "CAD"))
                            .font(.subheadline)
                    }
                }
                .onDelete { offsets in
                    viewModel.removeItems(at: offsets, from: cartItems, context: context)
                }
            }

            Section("Summary") {
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text(viewModel.subtotal(for: cartItems), format: .currency(code: "CAD"))
                }
                HStack {
                    Text("Tax (\(Int(viewModel.taxRate * 100))%)")
                    Spacer()
                    Text(viewModel.taxes(for: cartItems), format: .currency(code: "CAD"))
                }
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.total(for: cartItems), format: .currency(code: "CAD"))
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Cart")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !cartItems.isEmpty {
                    Button("Clear") {
                        viewModel.clearCart(items: cartItems, context: context)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CartView()
    }
    .modelContainer(for: [Category.self, GroceryItem.self, CartItem.self])
}
