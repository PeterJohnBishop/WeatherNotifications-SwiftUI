//
//  ListUserDataView.swift
//  ideal-goggles
//
//  Created by m1_air on 6/16/24.
//

import SwiftUI
import SwiftData

struct ListUserDataView: View {
    
    @Query var users: [UserData]
    @Environment(\.modelContext) var modelContext
    
    func addSamples() {
        let Peter = UserData(id: UUID().uuidString, name: "Peter", email: "pjb.den@gmail.com", password: "Sunshine81385")
        let Christine = UserData(id: UUID().uuidString, name: "Christine", email: "christinelunde8788@gmail.com", password: "Pi$tine8788!")
        modelContext.insert(Peter)
        modelContext.insert(Christine)
    }

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                    }
                }
            }
            .navigationTitle("All Users")
            .toolbar {
                Button("Add Samples", action: addSamples)
            }
            
        }
    }
}

#Preview {
    ListUserDataView()
}
