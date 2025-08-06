//
//  ExpenseViewModel.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
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
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
        do {
            expenses = try context.fetch(request)
        } catch {
            expenses = []
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
            print("Error saving expense: \(error)")
        }
    }
    
    // For chart support — grouped totals
    func sumByCategory() -> [String: Double] {
        var result: [String: Double] = [:]
        for exp in expenses {
            result[exp.category, default: 0] += exp.amount
        }
        return result
    }
    
    func totalSpent() -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}
