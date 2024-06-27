//
//  DialView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/16/24.
//

import SwiftUI
import SwiftData
import MapKit
import UserNotifications

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
    let calendar = Calendar.current
   
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
                                    if(hour.date >= Date.now) {
                                        VStack{
                                            Image(systemName: hour.symbolName)
                                            
                                            let temp = notificationViewModel.notif.celcius ?
                                            hour.temperature.converted(to: .celsius).value :
                                            hour.temperature.converted(to: .fahrenheit).value
                                            notificationViewModel.notif.celcius ?
                                            Text(String("\(Int(temp))° C")) :
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
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("All set!")
                                } else if let error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    Toggle(isOn:
                            $notificationViewModel.notif.celcius
                           , label: {
                        notificationViewModel.notif.celcius ? Text("Celsius") : Text("Fahrenheit")
                    }).tint(.black)
                    ZStack {
                    Background(isPressed: false, shape: Circle()).frame(width: 300, height: 300)
                    GlowTile_Circular(ringColor: statusColor)
                        Dial(dialValue: $dialValue, celsius: $notificationViewModel.notif.celcius).onChange(of: dialValue, {
                        if (dialValue > 0 && dialValue <= 28) {
                            statusColor = Color.blue.opacity(0.8)
                        } else if (dialValue > 28 && dialValue <= 60) {
                            statusColor = Color.green.opacity(0.8)
                        } else if (dialValue > 60 && dialValue <= 82) {
                            statusColor = Color.orange.opacity(0.8)
                        } else if (dialValue > 82 && dialValue <= 120) {
                            statusColor = Color.red.opacity(0.8)
                        }
                    })
                        Button(action: {
                            let temp = weatherManager.hourlyForecast.first(where: { Int($0.temperature.converted(to: .fahrenheit).value) == Int((dialValue * 120)/100) && calendar.component(.hour, from: $0.date) >= calendar.component(.hour, from: Date.now)})
                            print("\(String(describing: temp?.date)) \(Int((temp?.temperature.converted(to: .fahrenheit).value)!))")
                            let content = UNMutableNotificationContent()
                            content.title = "Feed the cat"
                            content.subtitle = "It looks hungry"
                            content.sound = UNNotificationSound.default
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                            let save = NotificationData(id: UUID().uuidString, name: "", temp: dialValue, long: notificationViewModel.notif.long, lat: notificationViewModel.notif.lat, address: notificationViewModel.notif.address, celcius: notificationViewModel.notif.celcius, active: true, alert: false)
                            modelContext.insert(save)
                        }, label: {
                            
                            Image(systemName: "plus.circle.fill").tint(.white)
                                                    })
                        .padding(EdgeInsets(top: 115, leading: 0, bottom: 0, trailing: 0))
                }.padding()
                HStack{
                    Button(action: {
                        notifSheetList = true
                    }, label: {
                        Image(systemName: "list.bullet").tint(.black)
                    }).buttonStyle(NeumorphicButton(shape: RoundedRectangle(cornerRadius: 10)))
                    .sheet(isPresented: $notifSheetList, content: {
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
                                                notif.celcius ?
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
