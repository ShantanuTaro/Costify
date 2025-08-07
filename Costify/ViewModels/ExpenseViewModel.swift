// ExpenseViewModel.swift
// Costify
//
// Created by Shantanu Taro on 06/08/25.
//

import Foundation
import CoreData
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchExpenses()
    }
    
    func fetchExpenses() {
        let request = Expense.fetchRequest() as! NSFetchRequest<Expense>
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
        do {
            expenses = try context.fetch(request)
        } catch {
            expenses = []
            print("Failed to fetch expenses: \(error)")
        }
    }
    
    func addExpense(title: String, amount: Double, category: String, date: Date, note: String?) {
        let exp = Expense(context: context)
        exp.id = UUID()
        exp.title = title
        exp.amount = amount
        exp.category = category
        exp.date = date
        exp.note = note
        
        save()
        fetchExpenses()
    }
    
    func deleteExpense(_ expense: Expense) {
        context.delete(expense)
        save()
        fetchExpenses()
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // MARK: - Data Helpers
    
    func filterExpensesByRange(days: Int?) -> [Expense] {
        guard let days = days else { return expenses }
        let now = Date()
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -days + 1, to: now) else { return [] }
        return expenses.filter { $0.date >= startDate && $0.date <= now }
    }
    
    func sumByCategory(range days: Int? = nil) -> [String: Double] {
        let filteredExpenses = filterExpensesByRange(days: days)
        var result: [String: Double] = [:]
        for exp in filteredExpenses {
            result[exp.category, default: 0] += exp.amount
        }
        return result
    }
    
    func totalSpent(range days: Int? = nil) -> Double {
        let filteredExpenses = filterExpensesByRange(days: days)
        return filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    func avgSpent(range days: Int) -> Double {
        guard days > 0 else { return 0 }
        let total = totalSpent(range: days)
        return total / Double(days)
    }
    
    func expensesInRange(days: Int) -> [Expense] {
        filterExpensesByRange(days: days)
    }
    
    // Add to ExpenseViewModel.swift
    func updateExpense(_ expense: Expense, title: String, amount: Double, category: String, date: Date, note: String?) {
        expense.title = title
        expense.amount = amount
        expense.category = category
        expense.date = date
        expense.note = note
        save()
        fetchExpenses()
    }

}
