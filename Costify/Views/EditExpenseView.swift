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

    @State private var title: String
    @State private var amount: String
    @State private var selectedCategory: Category
    @State private var date: Date
    @State private var note: String

    @State private var showDeleteAlert = false

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
                Section(header: Text("Edit Expense")) {
                    TextField("Title", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Note", text: $note)
                }
                Section {
                    Button("Save Changes") {
                        if let amt = Double(amount) {
                            vm.updateExpense(expense, title: title, amount: amt, category: selectedCategory.rawValue, date: date, note: note)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(title.isEmpty || Double(amount) == nil)
                    .foregroundColor(.blue)
                    Button("Delete", role: .destructive) {
                        showDeleteAlert = true
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Delete Expense?"),
                              message: Text("Are you sure? This action cannot be undone."),
                              primaryButton: .destructive(Text("Delete")) {
                                  vm.deleteExpense(expense)
                                  presentationMode.wrappedValue.dismiss()
                              },
                              secondaryButton: .cancel())
                    }
                }
            }
            .navigationTitle("Edit Expense")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
