// Category.swift
// Costify
//
// Created by Shantanu Taro on 06/08/25.
//
import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case transport = "Transport"
    case foodAndDrinks = "Food & Drinks"
    case shopping = "Shopping"
    case healthcare = "Healthcare"
    case electronics = "Electronics"
    case utilities = "Utilities"
    case rent = "Rent"
    case travel = "Travel"
    case entertainment = "Entertainment"
    case education = "Education"
    case groceries = "Groceries"
    case gifts = "Gifts"
    case personalCare = "Personal Care"
    case pets = "Pets"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .transport:      return .red
        case .foodAndDrinks:  return .yellow
        case .shopping:       return .orange
        case .healthcare:     return .mint
        case .electronics:    return .blue
        case .utilities:      return .teal
        case .rent:           return .purple
        case .travel:         return .pink
        case .entertainment:  return .indigo
        case .education:      return .brown
        case .groceries:      return .green
        case .gifts:          return .cyan
        case .personalCare:   return Color(red: 1.0, green: 0, blue: 1.0)
        case .pets:           return .gray
        case .other:          return .secondary
        }
    }
    
    var iconName: String {
        switch self {
        case .transport:      return "car.fill"
        case .foodAndDrinks:  return "fork.knife"
        case .shopping:       return "bag.fill"
        case .healthcare:     return "cross.case.fill"
        case .electronics:    return "desktopcomputer"
        case .utilities:      return "lightbulb.fill"
        case .rent:           return "house.fill"
        case .travel:         return "airplane"
        case .entertainment:  return "film.fill"
        case .education:      return "book.closed.fill"
        case .groceries:      return "cart.fill"
        case .gifts:          return "gift.fill"
        case .personalCare:   return "scissors"
        case .pets:           return "pawprint.fill"
        case .other:          return "questionmark.circle"
        }
    }
}

