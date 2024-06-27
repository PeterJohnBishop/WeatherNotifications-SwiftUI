//
//  Dial.swift
//  ideal-goggles
//
//  Created by m1_air on 6/22/24.
//

import Foundation
import SwiftUI

struct Dial: View {
    
    private let initialTemperature: CGFloat = 0
    private let scale: CGFloat = 290
    private let indicatorLength: CGFloat = 5
    private let maxTemperature: CGFloat = 120
    private let stepSize: CGFloat = 0.5
    
    @State private var value: CGFloat = 0
    @Binding var dialValue: CGFloat
    @Binding var celsius: Bool
    
    private var innerScale: CGFloat {
        return scale - indicatorLength
    }
//    
//    init(dialValue: Double) {
//        self.initialTemperature = temperature
//    }
    
    private func angle(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        var degrees = 90 + (radians * 180 / .pi)

        if degrees < 0 {
            degrees += 360
        }

        return degrees
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: self.innerScale, height: self.innerScale, alignment: .center)
                .rotationEffect(.degrees(-90))
                .gesture(
                DragGesture().onChanged() { value in
                let x: CGFloat = min(max(value.location.x, 0), self.innerScale)
                let y: CGFloat = min(max(value.location.y, 0), self.innerScale)
                let ending = CGPoint(x: x, y: y)
                let start = CGPoint(x: (self.innerScale) / 2, y: (self.innerScale) / 2)
                let angle = self.angle(between: start, ending: ending)
                self.value = CGFloat(Int(((angle / 360) * (self.maxTemperature / self.stepSize)))) / (self.maxTemperature / self.stepSize)
                    dialValue = self.value*100
                                    }
                
                                )
            Circle()
                .stroke(.gray.opacity(0.1), style: StrokeStyle(lineWidth: self.indicatorLength, lineCap: .butt, lineJoin: .miter, dash: [4]))
                .frame(width: 255, height: 255, alignment: .center)
            Circle()
                .trim(from: 0.0, to: self.value)
                .stroke(.white, style: StrokeStyle(lineWidth: self.indicatorLength, lineCap: .butt, lineJoin: .miter, dash: [4]))
                .rotationEffect(.degrees(-90))
                .frame(width: 250, height: 250, alignment: .center)
            VStack{
                Text("\(self.value * self.maxTemperature, specifier: "%.0f")°")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                celsius ?
                Text("Celsius")
                    .foregroundColor(.white) :
                Text("Fahrenheit")
                    .foregroundColor(.white)
            }
        }
        .onAppear(perform: {
            self.value = self.initialTemperature / self.maxTemperature
        })
    }
}
