//
//  Category.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    case transport = "Transport"
    case foodAndDrinks = "Food & Drinks"
    case shopping = "Shopping"
    case drugs = "Drugs"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var color: String {
        switch self {
        case .transport:      return "Red"
        case .foodAndDrinks:  return "Yellow"
        case .shopping:       return "Orange"
        case .drugs:          return "Gray"
        case .other:          return "Gray"
        }
    }
    
    var iconName: String {
        switch self {
        case .transport:      return "car.fill"
        case .foodAndDrinks:  return "fork.knife"
        case .shopping:       return "bag.fill"
        case .drugs:          return "pills.fill"
        case .other:          return "questionmark"
        }
    }
}
