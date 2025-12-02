import SwiftUI
import SwiftData

struct GroceryListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = GroceryListViewModel()

    @Query(sort: \GroceryItem.name)
    private var items: [GroceryItem]

    @State private var showAddItem = false
    @State private var itemToEdit: GroceryItem?

    var body: some View {
        List {
            ForEach(groupedItems.keys.sorted(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(groupedItems[key] ?? []) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.category?.icon ?? "")
                            }

                            Spacer()

                            Text(item.price, format: .currency(code: "CAD"))

                            Button {
                                viewModel.toggleFavorite(item: item, context: context)
                            } label: {
                                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                    .foregroundStyle(item.isFavorite ? .red : .gray)
                            }
                            .buttonStyle(.borderless)

                            Button {
                                viewModel.addToCart(item: item, context: context)
                            } label: {
                                Image(systemName: "cart.badge.plus")
                            }
                            .buttonStyle(.borderless)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            itemToEdit = item
                        }
                    }
                    .onDelete { offsets in
                        let itemsInSection = groupedItems[key] ?? []
                        let globalIndexes = offsets.compact_map { index in
                            items.firstIndex(of: itemsInSection[index])
                        }
                        viewModel.delete(at: IndexSet(globalIndexes), from: items, context: context)
                    }
                }
            }
        }
        .navigationTitle("GrocerEase")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                    CartView()
                } label: {
                    Label("Cart", systemImage: "cart")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddItem = true
                    itemToEdit = nil
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            ProductFormView(
                existingItem: nil,
                onSave: { name, price, category in
                    viewModel.addOrUpdateItem(
                        existing: nil,
                        name: name,
                        price: price,
                        category: category,
                        context: context
                    )
                }
            )
        }
        .sheet(item: $itemToEdit) { item in
            ProductFormView(
                existingItem: item,
                onSave: { name, price, category in
                    viewModel.addOrUpdateItem(
                        existing: item,
                        name: name,
                        price: price,
                        category: category,
                        context: context
                    )
                }
            )
        }
    }

    private var groupedItems: [String: [GroceryItem]] {
        Dictionary(grouping: items) { item in
            let icon = item.category?.icon ?? "🛒"
            let name = item.category?.name ?? "Other"
            return "\(icon) \(name)"
        }
    }
}

#Preview {
    NavigationStack {
        GroceryListView()
    }
}
