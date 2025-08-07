//
//  EditExpenseView.swift
//  Costify
//
//  Created by Shantanu Taro on 07/08/25.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var vm: ExpenseViewModel
    @State var expense: Expense

    // Editable state variables
    @State private var title: String
    @State private var amount: String
    @State private var selectedCategory: Category
    @State private var date: Date
    @State private var note: String

    @State private var showDeleteAlert = false
    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    init(expense: Expense, vm: ExpenseViewModel) {
        self._expense = State(initialValue: expense)
        self.vm = vm
        _title = State(initialValue: expense.title)
        _amount = State(initialValue: String(expense.amount))
        _selectedCategory = State(initialValue: Category(rawValue: expense.category) ?? .other)
        _date = State(initialValue: expense.date)
        _note = State(initialValue: expense.note ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Expense").fontWeight(.semibold)) {
                    TextField("Title", text: $title)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onChange(of: amount) { oldValue, newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
                        }

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
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .disabled(title.isEmpty || Double(amount) == nil)
                    .foregroundColor(.blue)

                    Button("Delete Expense", role: .destructive) {
                        showDeleteAlert = true
                    }
                }
            }
            .alert(isPresented: $showValidationAlert) {
                Alert(title: Text("Invalid Input"), message: Text(validationMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Expense?"),
                    message: Text("Are you sure you want to delete this expense? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        vm.deleteExpense(expense)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Edit Expense")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveChanges() {
        guard !title.isEmpty else {
            validationMessage = "Please enter a title."
            showValidationAlert = true
            return
        }
        guard let amt = Double(amount), amt > 0 else {
            validationMessage = "Please enter a valid amount."
            showValidationAlert = true
            return
        }
        vm.updateExpense(expense, title: title, amount: amt, category: selectedCategory.rawValue, date: date, note: note.isEmpty ? nil : note)
        presentationMode.wrappedValue.dismiss()
    }
}
