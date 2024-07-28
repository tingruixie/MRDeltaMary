//
//  ProfileView.swift
//  MRDeltaMary
//
//  Created by Zhifu Xie on 7/28/24.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @State private var userName = ""
    @State private var isOrganization = false
    @State private var interestedInOysterRestoration = false
    @State private var interestedInPlantingTrees = false
    @State private var canSwim = false
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var email = ""

    var body: some View {
        VStack {
            if userName.isEmpty {
                Text("Loading...")
            } else {
                Form {
                    Section(header: Text("Account Information")) {
                        Text("Email: \(email)")
                    }
                    Section(header: Text("Profile Information")) {
                        Text("User Name: \(userName)")
                        Text("Organization: \(isOrganization ? "Yes" : "No")")
                        Text("Interested in Oyster Restoration: \(interestedInOysterRestoration ? "Yes" : "No")")
                        Text("Interested in Planting Trees: \(interestedInPlantingTrees ? "Yes" : "No")")
                        Text("Can Swim: \(canSwim ? "Yes" : "No")")
                        Text("Phone Number: \(phoneNumber)")
                        Text("Address: \(address)")
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear(perform: fetchUserInfo)
    }

    func fetchUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                email = data["email"] as? String ?? ""
                userName = data["userName"] as? String ?? ""
                isOrganization = data["isOrganization"] as? Bool ?? false
                interestedInOysterRestoration = data["interestedInOysterRestoration"] as? Bool ?? false
                interestedInPlantingTrees = data["interestedInPlantingTrees"] as? Bool ?? false
                canSwim = data["canSwim"] as? Bool ?? false
                phoneNumber = data["phoneNumber"] as? String ?? ""
                address = data["address"] as? String ?? ""
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

