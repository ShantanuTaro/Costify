//
//  ExpenseListView.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//
import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        List {
            ForEach(vm.expenses) { exp in
                NavigationLink(destination: ExpenseDetailView(expense: exp, vm: vm)) {
                    HStack {
                        Image(systemName: Category(rawValue: exp.category)?.iconName ?? "questionmark")
                            .foregroundColor(Category(rawValue: exp.category)?.color ?? .gray)

                        VStack(alignment: .leading) {
                            Text(exp.title).bold()
                            Text(Category(rawValue: exp.category)?.rawValue ?? exp.category)
                                .font(.caption).foregroundColor(.gray)
                            Text(Self.dateFormatter.string(from: exp.date))
                                .font(.caption2).foregroundColor(.gray)
                        }
                        Spacer()
                        Text("₹\(exp.amount, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                }
            }.onDelete { indices in
                indices.forEach { i in
                    vm.deleteExpense(vm.expenses[i])
                }
            }
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        return fmt
    }()
}

