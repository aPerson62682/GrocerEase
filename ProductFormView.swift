import SwiftUI
import SwiftData

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let existingItem: GroceryItem?
    let onSave: (_ name: String, _ price: Double, _ category: Category?) -> Void

    @Query(sort: \Category.name)
    private var categories: [Category]

    @State private var name: String = ""
    @State private var priceText: String = ""
    @State private var selectedCategory: Category?
    @State private var newCategoryName: String = ""
    @State private var newCategoryIcon: String = "🛒"

    init(existingItem: GroceryItem?, onSave: @escaping (String, Double, Category?) -> Void) {
        self.existingItem = existingItem
        self.onSave = onSave
        _name = State(initialValue: existingItem?.name ?? "")
        _priceText = State(initialValue: existingItem.map { String($0.price) } ?? "")
        _selectedCategory = State(initialValue: existingItem?.category)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Product") {
                    TextField("Name", text: $name)
                    TextField("Price (e.g. 3.99)", text: $priceText)
                        .keyboardType(.decimalPad)
                }

                Section("Category") {
                    Picker("Existing category", selection: $selectedCategory) {
                        Text("None").tag(Category?.none)
                        ForEach(categories) { category in
                            Text("\(category.icon) \(category.name)")
                                .tag(Category?.some(category))
                        }
                    }

                    Text("Or create a new one:")
                        .font(.caption)

                    TextField("Category name", text: $newCategoryName)
                    TextField("Emoji icon", text: $newCategoryIcon)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    Button("Add Category") {
                        guard !newCategoryName.isEmpty else { return }
                        let cat = Category(name: newCategoryName, icon: newCategoryIcon)
                        context.insert(cat)
                        try? context.save()
                        selectedCategory = cat
                        newCategoryName = ""
                    }
                }
            }
            .navigationTitle(existingItem == nil ? "New Product" : "Edit Product")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        guard !name.isEmpty,
              Double(priceText) != nil else { return false }
        return true
    }

    private func save() {
        guard let price = Double(priceText) else { return }
        onSave(name, price, selectedCategory)
        dismiss()
    }
}

#Preview {
    ProductFormView(existingItem: nil) { _,_,_ in }
        .modelContainer(for: [Category.self, GroceryItem.self, CartItem.self])
}
