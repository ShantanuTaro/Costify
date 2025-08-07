//
//  AddExpenseView.swift
//  Costify
//
//  Created by Shantanu Taro on 07/08/25.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ExpenseViewModel

    // Form fields
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedCategory: Category = .transport
    @State private var date = Date()
    @State private var note = ""

    // Validation alert
    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details").fontWeight(.semibold)) {
                    TextField("Title", text: $title)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onChange(of: amount) { oldValue, newValue in
                            // Allow only valid decimal characters
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
                        }

                    // Custom category picker with colors and icons
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category").font(.caption).foregroundColor(.secondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(Category.allCases) { cat in
                                    CategoryChip(category: cat, isSelected: cat == selectedCategory)
                                        .onTapGesture {
                                            selectedCategory = cat
                                        }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.vertical, 4)

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding(.top, 8)

                    TextEditor(text: $note)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.top, 4)
                        .overlay(
                            // Placeholder text
                            Group {
                                if note.isEmpty {
                                    Text("Note (optional)")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 12)
                                        .font(.body)
                                        .allowsHitTesting(false)
                                }
                            }
                        )
                }

                Section {
                    Button(action: addExpense) {
                        HStack {
                            Spacer()
                            Text("Add Expense")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(title.isEmpty || Double(amount) == nil ? Color.gray : Color.orange)
                    .cornerRadius(16)
                    .disabled(title.isEmpty || Double(amount) == nil)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showValidationAlert) {
                Alert(title: Text("Invalid Input"), message: Text(validationMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addExpense() {
        guard !title.isEmpty else {
            validationMessage = "Please enter a title for the expense."
            showValidationAlert = true
            return
        }
        guard let amt = Double(amount), amt > 0 else {
            validationMessage = "Please enter a valid amount."
            showValidationAlert = true
            return
        }
        vm.addExpense(title: title, amount: amt, category: selectedCategory.rawValue, date: date, note: note.isEmpty ? nil : note)
        presentationMode.wrappedValue.dismiss()
    }
}

/// Category Chip View with icon and background color
struct CategoryChip: View {
    let category: Category
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: category.iconName)
                .foregroundColor(.white)
                .padding(6)
                .background(category.color)
                .clipShape(Circle())
            Text(category.rawValue)
                .foregroundColor(isSelected ? .orange : .primary)
                .fontWeight(isSelected ? .bold : .regular)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color.orange.opacity(0.2) : Color.gray.opacity(0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
