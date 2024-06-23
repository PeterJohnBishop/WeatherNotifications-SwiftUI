//
//  DialView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/16/24.
//

import SwiftUI
import SwiftData
import MapKit

struct DialView: View {
    @Query var allNotifs: [NotificationData]
    @Environment(\.modelContext) var modelContext
    @State private var viewModel: NotificationView = NotificationView()
    @State var screenWidth: Double = 0.0;
    @State var screenHeight: Double = 0.0;
    @State var dialValue: CGFloat = 0.0;
    @State var unlock: Bool = false;
    @State var unlockSuccess: Bool = false;
    @State var statusColor: Color = .gray.opacity(0.8)
    @State var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

   
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
//                    let alarm = AlarmData(id: UUID().uuidString, temp: dialValue, long: 0.0, lat: 0.0, address: "", celcius: false, active: true, alert: false)
//                    modelContext.insert(alarm)
                    let notification = NotificationData(id: UUID().uuidString, name: "myAlarm", temp: dialValue, long: 0.0, lat: 0.0, address: "123 LoFi Lane, Denver, CO 80207", celcius: false, active: true, alert: false)
                    modelContext.insert(notification)
                }, label: {
                    HStack{
                        Text("+")
                        Image(systemName: "bell.circle.fill")
                    }
                }).buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 10)))
                    .padding()
                Spacer()
                ScrollView {
                    ForEach(allNotifs) { notif in
                        VStack(alignment: .leading) {
                            GroupBox(content: {
                                HStack{
                                    Text("Denver, CO")
                                    Spacer()
                                    Button(action: {
                                        modelContext.delete(notif)
                                    }, label: {
                                            Image(systemName: "trash.fill").tint(.red)
                                            
                                    }).frame(width: 30)
                                }
                            }, label: {
                                Text("\((notif.temp * 120)/100, specifier: "%.0f") °F")
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

#Preview {
    DialView()
}
