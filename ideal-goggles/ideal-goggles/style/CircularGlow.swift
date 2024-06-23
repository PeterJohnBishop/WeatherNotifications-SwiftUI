//
//  CircularGlow.swift
//  ideal-goggles
//
//  Created by m1_air on 6/22/24.
//

import Foundation
import SwiftUI

struct GlowTile_Circular: View {
    
    @State var rotation: CGFloat = 0.0
    var ringColor: Color
        
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 270, height: 270)
                .foregroundColor(Color(.black))
                .shadow(color: .white.opacity(0.2), radius: 10)
            Circle()
                .frame(width: 270, height: 270)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), ringColor]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask(Circle()
                    .stroke(lineWidth: 15)
                    .frame(width: 275, height: 275)
                    
                )
        }.onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        
    }
}
