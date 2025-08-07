//
//  PieChartView.swift
//  Costify
//
//  Created by Shantanu Taro on 07/08/25.
//

import SwiftUI

struct PieChartView: View {
    var categories: [String: Double]           // ["Transport": 100, ...]
    var colorMapping: [String: Color]          // ["Transport": .red, ...]

    private var total: Double {
        categories.values.reduce(0, +)
    }
    private var pieSegments: [(Double, Double, Color)] {
        let values = Array(categories.values)
        let keys = Array(categories.keys)
        let sum = values.reduce(0, +)
        var res: [(Double, Double, Color)] = []
        var start = -Double.pi/2
        for (i, value) in values.enumerated() {
            let fraction = sum > 0 ? value/sum : 0
            let end = start + 2*Double.pi*fraction
            let key = keys[i]
            let color = colorMapping[key] ?? .gray
            res.append((start, end, color))
            start = end
        }
        return res
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if total > 0 {
                    ForEach(0..<pieSegments.count, id: \.self) { i in
                        let seg = pieSegments[i]
                        Path { path in
                            path.addArc(center: CGPoint(x: geo.size.width/2, y: geo.size.height/2),
                                        radius: geo.size.width/2,
                                        startAngle: .radians(seg.0),
                                        endAngle: .radians(seg.1), clockwise: false)
                            path.addLine(to: CGPoint(x: geo.size.width/2, y: geo.size.height/2))
                        }.fill(seg.2)
                    }
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: geo.size.width * 0.80, height: geo.size.height * 0.80)

                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: geo.size.width * 0.20)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

