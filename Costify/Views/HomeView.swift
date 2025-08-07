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
    
    @State private var selectedRange: Int = 7
    private let ranges: [(label: String, days: Int)] = [
        ("Today", 1),
        ("7 Days", 7),
        ("14 Days", 14),
        ("30 Days", 30),
        ("1 Year", 365)
    ]

    // For editing
    @State private var selectedExpense: Expense?
    @State private var showingEditSheet = false

    // MARK: - Init
    init() {
        let ctx = PersistenceController.shared.container.viewContext
        _vm = StateObject(wrappedValue: ExpenseViewModel(context: ctx))
    }
    // MARK: - Computed Properties for View
    private var chartCategories: [String: Double] {
        vm.sumByCategory(range: selectedRange)
    }
    private var total: Double {
        vm.totalSpent(range: selectedRange)
    }
    private var perDay: Double {
        vm.avgSpent(range: selectedRange)
    }
    private var expensesInRange: [Expense] {
        vm.expensesInRange(days: selectedRange)
    }
    private var sortedCategories: [Category] {
        Category.allCases.sorted { $0.rawValue < $1.rawValue }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    chartSection
                    totalAndAverageSection
                    categoryLegendSection
                    rangeSelectorSection
                    Divider().padding(.vertical, 1)
                    addExpenseButtonSection
                    expensesListSection
                }
                .padding(.horizontal)
                .navigationBarTitle("Costify", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { SidebarMenuView() }
                }
            }
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .onAppear { vm.fetchExpenses() }
            // 👇 Sheet for editing an expense
            .sheet(item: $selectedExpense) { exp in
                EditExpenseView(expense: exp, vm: vm) // (see code below)
            }
        }
    }

    // MARK: - Sections as Computed Views
    private var chartSection: some View { /* ... as before ... */ /* unchanged */
        // (Leave as is, you don't need to edit this part)
        ZStack {
            let categoryColorMapping = Dictionary(uniqueKeysWithValues: Category.allCases.map { ($0.rawValue, $0.color) })
            PieChartView(categories: chartCategories, colorMapping: categoryColorMapping)
                .frame(height: 240)
                .padding(.top)
            if total > 0 {
                VStack(spacing: 4) {
                    Text("\(labelForRange(selectedRange))")
                        .font(.body)
                        .foregroundColor(.gray)
                    Text("₹\(total, specifier: "%.2f")")
                        .font(.system(size: 28, weight: .bold))
                        .fontWeight(.light)
                        .foregroundColor(.primary)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "chart.pie.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray.opacity(0.25))
                    Text("No expenses yet")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding(.top, 4)
                }
            }
        }
    }
    private var totalAndAverageSection: some View { /* ... as before ... */
        VStack(spacing: 4) {
            Text("Last \(labelForRange(selectedRange))")
                .font(.subheadline)
                .foregroundColor(.gray)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.primary)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
    private var categoryLegendSection: some View { /* ... as before ... */
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(sortedCategories) { cat in
                    let amount = chartCategories[cat.rawValue, default: 0]
                    HStack(spacing: 5) {
                        Image(systemName: cat.iconName)
                            .foregroundColor(cat.color)
                        Text(cat.rawValue)
                            .font(.caption)
                            .foregroundColor(.primary)
                        Text("₹\(amount, specifier: "%.2f")")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(cat.color.opacity(0.18))
                    .cornerRadius(13)
                }
            }
            .padding(.vertical, 1)
        }
    }
    private var rangeSelectorSection: some View { /* ... as before ... */
        HStack(spacing: 6) {
            ForEach(ranges, id: \.days) { option in
                Button {
                    selectedRange = option.days
                } label: {
                    Text(option.label)
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(selectedRange == option.days ? Color.red : Color.clear)
                        .foregroundColor(selectedRange == option.days ? Color.white : Color.orange)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.red, lineWidth: selectedRange == option.days ? 0 : 1)
                        )
                        .cornerRadius(20)
                }
            }
        }
        .padding(.top, 4)
    }
    private var addExpenseButtonSection: some View { /* ... as before ... */
        NavigationLink(destination: AddExpenseView(vm: vm)) {
            Label("Add Expense", systemImage: "plus.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(16)
                .padding(.horizontal, 14)
        }
        .padding(.top, 12)
    }
    // 👇 --- MAIN CHANGES HERE: Change every expense row to tap for edit ---
    private var expensesListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Expenses")
                .font(.headline)
                .padding(.bottom, 2)
            if expensesInRange.isEmpty {
                Text("No expenses yet for this period.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(expensesInRange) { exp in
                    Button {
                        selectedExpense = exp
                    } label: {
                        let category = Category(rawValue: exp.category)
                        HStack {
                            Image(systemName: category?.iconName ?? "questionmark")
                                .foregroundColor(category?.color ?? .gray)
                                .padding(8)
                                .background((category?.color ?? .gray).opacity(0.09))
                                .cornerRadius(8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(exp.title).font(.body).bold()
                                Text(category?.rawValue ?? exp.category)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(Self.dateFormatter.string(from: exp.date))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("₹\(exp.amount, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    // Helper for date labels
    private func labelForRange(_ range: Int) -> String {
        switch range {
        case 1: return "Today"
        case 7: return "Last 7 Days"
        case 14: return "Last 14 Days"
        case 30: return "Last 30 Days"
        case 365: return "Last 1 Year"
        default: return "Custom"
        }
    }

    static let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        return fmt
    }()
}

#Preview {
    HomeView()
}
