//
//  NeumorphicStyle.swift
//  ideal-goggles
//
//  Created by m1_air on 6/16/24.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct NeumorphicButton<S: Shape>: ButtonStyle {
    var shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(15)
            .background(Background(isPressed: configuration.isPressed, shape: shape))
    }
}
struct Background<S: Shape>: View {
    var isPressed: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isPressed {
                shape
                    .fill(Color.offWhite)
                    .overlay(
                        shape
                            .stroke(Color.gray, lineWidth: 3)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(shape.fill(LinearGradient(Color.black.opacity(0.8), Color.clear)))
                    )
                    .overlay(
                        shape
                            .stroke(Color.white, lineWidth: 3)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(shape.fill(LinearGradient(Color.clear, Color.black.opacity(0.8))))
                    )
            } else {
                shape
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.8), radius: 10, x: -5, y: -5)
            }
        }
    }
}

extension View {
    func NeumorphicStyle() -> some View {
        self.padding(30)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}

extension View {
    func NeumorphicStyleBlk() -> some View {
        self.padding(30)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}



extension View {
    func NeumorphicPressedStyle() -> some View {
        self.padding(30)
            .frame(maxWidth: .infinity)
            .background(Color.offWhite)
            .cornerRadius(20)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
    }
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

