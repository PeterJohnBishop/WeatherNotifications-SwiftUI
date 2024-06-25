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
    @State private var notificationViewModel: NotificationView = NotificationView()
    @State private var weatherManager = WeatherManager()
    @State private var locationManager = LocationManager()
    @State var screenWidth: Double = 0.0;
    @State var screenHeight: Double = 0.0;
    @State var dialValue: CGFloat = 0.0;
    @State var notifSheetList: Bool = false
    @State var toggleC: Bool = false;
    @State var statusColor: Color = .gray.opacity(0.8)
    @State var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

   
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 12) {
                    Spacer().padding()

                            Image(systemName: weatherManager.icon)
                                .font(.largeTitle)
                                
                        
                    notificationViewModel.notif.celcius ?
                    Text("Currently, \(weatherManager.temperatureC) in").fontWeight(.regular) :
                    Text("Currently, \(weatherManager.temperatureF) in").fontWeight(.regular)
                    Text(notificationViewModel.notif.address).fontWeight(.ultraLight)
                    Spacer()
                    ScrollViewReader { value in
                        ScrollView(.horizontal) {
                            HStack(spacing: 30){
                                ForEach(weatherManager.hourlyForecast, id: \.date){
                                    hour in
                                    let calendar = Calendar.current
                                    
                                    VStack{
                                        Image(systemName: hour.symbolName)
                                        let temp = hour.temperature.converted(to: .fahrenheit).value
                                        Text(String("\(Int(temp))° F"))
                                        HStack{
                                            calendar.component(.hour, from: hour.date) == calendar.component(.hour, from: Date.now) ? Text(" Now").fontWeight(.bold) :
                                            calendar.component(.hour, from: hour.date) == 0 ?
                                            Text(String(describing: calendar.component(.hour, from: hour.date) + 12)).fontWeight(.light) :
                                            calendar.component(.hour, from: hour.date) <= 12 ?
                                            Text(String(describing: calendar.component(.hour, from: hour.date))) :
                                            Text(String(describing: calendar.component(.hour, from: hour.date) - 12))
                                            calendar.component(.hour, from: hour.date) == calendar.component(.hour, from: Date.now) ? Text("") :
                                            calendar.component(.hour, from: hour.date) < 12 ? Text("am") : Text("pm")
                                        }
                                        Text("\(String(describing: calendar.component(.month, from: hour.date))) / \(String(describing: calendar.component(.day, from: hour.date)))").fontWeight(.ultraLight)
                                    }
                                }
                            }
                        }.NeumorphicStyle()
                            
                    }
                        }
                        .onAppear {
                            let location = locationManager.requestLocation()
                            Task {
                                notificationViewModel.notif.lat = location.coordinate.latitude
                                notificationViewModel.notif.long = location.coordinate.longitude
                                notificationViewModel.reverseGeocoding()
                                await weatherManager.getWeather(lat: notificationViewModel.notif.lat,
                                                                long: notificationViewModel.notif.long)
                            }
                        }
                    ZStack {
                    Background(isPressed: false, shape: Circle()).frame(width: 300, height: 300)
                    GlowTile_Circular(ringColor: statusColor)
                        Dial(dialValue: $dialValue, celsius: $notificationViewModel.notif.celcius).onChange(of: dialValue, {
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
                HStack{
                    Button(action: {
                        let save = NotificationData(id: UUID().uuidString, name: "", temp: dialValue, long: notificationViewModel.notif.long, lat: notificationViewModel.notif.lat, address: notificationViewModel.notif.address, celcius: notificationViewModel.notif.celcius, active: true, alert: false)
                        modelContext.insert(save)
                    }, label: {
                        HStack{
                            Text("+")
                            Image(systemName: "bell.circle.fill")
                        }
                    }).buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 10)))
                        .padding()
                    Button(action: {
                        notifSheetList = true
                    }, label: {
                        Image(systemName: "list.bullet").tint(.black)
                    }).sheet(isPresented: $notifSheetList, content: {
                        VStack{
                            Button(action: {
                                notifSheetList = false
                            }, label: {
                                Image(systemName: "chevron.down").tint(.black)
                                    .padding()
                            })
                            ScrollView {
                                ForEach(allNotifs) { notif in
                                    VStack(alignment: .leading) {
                                        GroupBox(content: {
                                            HStack{
                                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                                    notif.active ?
                                                    Image(systemName: "bell.badge.fill").tint(.black) :
                                                    Image(systemName: "bell.slash.fill").tint(.black)
                                                })
                                                Text(notif.address).fontWeight(.ultraLight)
                                                Spacer()
                                            }
                                        }, label: {
                                            HStack{
                                                notificationViewModel.notif.celcius ?
                                                Text("Notify at \((notif.temp * 120)/100, specifier: "%.0f")° C") :
                                                Text("Notify at \((notif.temp * 120)/100, specifier: "%.0f")° F")
                                                Spacer()
                                                Button(action: {
                                                    modelContext.delete(notif)
                                                }, label: {
                                                    Image(systemName: "minus").tint(.black)
                                                })
                                            }
                                        })
                                    }.padding()
                                }
                            }
                        }
                    })
                }
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
