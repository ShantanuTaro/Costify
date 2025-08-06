//
//  PieChartView.swift
//  Costify
//
//  Created by Shantanu Taro on 06/08/25.
//

import SwiftUI

struct PieChartView: View {
    var categories: [String: Double]
    
    var body: some View {
        HStack {
            ForEach(categories.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(Category(rawValue: key)?.color ?? "gray"))
                    .frame(width: CGFloat(max(20, value / (categories.values.max() ?? 1) * 100)), height: 30)
                    .overlay(Text(key).foregroundColor(.white).font(.caption))
            }
        }
    }
}
