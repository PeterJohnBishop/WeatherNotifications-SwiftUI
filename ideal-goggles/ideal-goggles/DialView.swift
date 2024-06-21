//
//  DialView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/16/24.
//

import SwiftUI
import SwiftData

struct DialView: View {
    @Query var alarms: [AlarmData]
    @Environment(\.modelContext) var modelContext
    
    @State var screenWidth: Double = 0.0;
    @State var screenHeight: Double = 0.0;
    @State var dialValue: CGFloat = 0.0;
    @State var unlock: Bool = false;
    @State var unlockSuccess: Bool = false;
    @State var statusColor: Color = .gray.opacity(0.8)

   
    var body: some View {
        GeometryReader { geometry in
            VStack {
             
                Text("Select Temp F")
                ZStack {
                    Background(isPressed: false, shape: Circle()).frame(width: 300, height: 300)
                    GlowTile_Circular(ringColor: statusColor)
                    Dial(dialValue: $dialValue).onChange(of: dialValue, {
                        if (dialValue > 0 && dialValue < 10) {
                            statusColor = Color.white.opacity(0.8)
                        } else if (dialValue > 10 && dialValue < 32) {
                            statusColor = Color.blue.opacity(0.8)
                        } else if (dialValue > 32 && dialValue < 42) {
                            statusColor = Color.green.opacity(0.8)
                        } else if (dialValue > 42 && dialValue < 52) {
                            statusColor = Color.yellow.opacity(0.8)
                        } else if (dialValue > 52 && dialValue < 72) {
                            statusColor = Color.orange.opacity(0.8)
                        } else if (dialValue > 72 && dialValue < 92) {
                            statusColor = Color.pink.opacity(0.8)
                        } else if (dialValue > 92) {
                            statusColor = Color.red.opacity(0.8)
                        }
                    })
                }.padding()
                Button(action: {
                    let alarm = AlarmData(id: UUID().uuidString, temp: dialValue, celcius: false, active: true, alert: false)
                    modelContext.insert(alarm)
                }, label: {
                    HStack{
                        Text("+")
                        Image(systemName: "alarm.fill")
                    }
                }).buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 10)))
                    .padding()
                Spacer()
                ScrollView {
                    ForEach(alarms) { alarm in
                        VStack(alignment: .leading) {
                            GroupBox(content: {
                                HStack{
                                    Text("Denver, CO")
                                    Spacer()
                                    Button(action: {
                                        modelContext.delete(alarm)
                                    }, label: {
                                            Image(systemName: "trash.fill").tint(.red)
                                            
                                    }).frame(width: 30)
                                }
                            }, label: {
                                Text("\((alarm.temp * 120)/100, specifier: "%.0f") °F")
                            })
                        }.padding()
                        
                        
                    }
                }
                
//
            }
        }
        .onAppear {
            screenWidth = UIScreen.main.bounds.size.width
            screenHeight = UIScreen.main.bounds.size.height
        }
        .NeumorphicStyle()
        .ignoresSafeArea()
    }
}


struct Dial: View {
    
    private let initialTemperature: CGFloat = 0
    private let scale: CGFloat = 290
    private let indicatorLength: CGFloat = 5
    private let maxTemperature: CGFloat = 120
    private let stepSize: CGFloat = 0.5
    
    @State private var value: CGFloat = 0
    @Binding var dialValue: CGFloat
    
    private var innerScale: CGFloat {
        return scale - indicatorLength
    }
    
//    init(temperature: CGFloat, dialValue: Double) {
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
                Text("\(self.value * self.maxTemperature, specifier: "%.0f")")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Text("°F")
                    .foregroundColor(.white)

            }
        }
        .onAppear(perform: {
            self.value = self.initialTemperature / self.maxTemperature
        })
    }
}

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


#Preview {
    DialView()
}
