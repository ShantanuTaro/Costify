//
//  ExpenseDetailView.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//
import SwiftUI

struct ExpenseDetailView: View {
    var expense: Expense
    @ObservedObject var vm: ExpenseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Category(rawValue: expense.category)?.iconName ?? "questionmark")
                .resizable().frame(width: 48, height: 48)
                .foregroundColor(Category(rawValue: expense.category)?.color ?? .gray)
            
            Text(expense.title).font(.largeTitle).bold()
            Text("₹\(expense.amount, specifier: "%.2f")")
                .font(.title).foregroundColor(.red)
            Text(Category(rawValue: expense.category)?.rawValue ?? expense.category)
                .font(.headline)
            Text(Self.dateFormatter.string(from: expense.date))
                .font(.subheadline).foregroundColor(.gray)
            
            if let note = expense.note, !note.isEmpty {
                Text("Note: \(note)")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(role: .destructive) {
                vm.deleteExpense(expense)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Delete Expense", systemImage: "trash")
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
        .navigationTitle("Expense Detail")
    }
    
    static let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        return fmt
    }()
}
