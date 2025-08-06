//
//  HomeView.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//
import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var vm: ExpenseViewModel
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _vm = StateObject(wrappedValue: ExpenseViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // PieChart placeholder (you’ll need a package for a full chart!)
                PieChartView(categories: vm.sumByCategory())
                    .frame(height: 240)
                
                Text("Total Spent: ₹\(vm.totalSpent(), specifier: "%.2f")")
                    .font(.headline)
                HStack {
                    ForEach(Category.allCases) { cat in
                        HStack {
                            Image(systemName: cat.iconName)
                                .foregroundColor(Color(cat.color))
                            Text(cat.rawValue)
                                .foregroundColor(Color(cat.color))
                        }
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .font(.subheadline)
                
                NavigationLink("Add Expense", destination: AddExpenseView(vm: vm))
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                ExpenseListView(vm: vm)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SidebarMenuView()
                }
            }
        }
    }
}
