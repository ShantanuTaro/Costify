// AddExpenseView.swift
// Costify
//
// Created by Shantanu Taro on 06/08/25.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ExpenseViewModel

    @State private var title = ""
    @State private var amount = ""
    @State private var selectedCategory: Category = .transport
    @State private var date = Date()
    @State private var note = ""

    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
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
            
            Button("Add Expense") {
                vm.addExpense(
                    title: title,
                    amount: Double(amount) ?? 0,
                    category: selectedCategory.rawValue,
                    date: date,
                    note: note.isEmpty ? nil : note
                )
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(title.isEmpty || Double(amount) == nil)
        }
        .navigationTitle("Add Expense")
    }
}
