//
//  SignUpView.swift
//  MRDeltaMary
//
//  Created by Zhifu Xie on 7/28/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userName = ""
    @State private var isOrganization = false
    @State private var interestedInOysterRestoration = false
    @State private var interestedInPlantingTrees = false
    @State private var canSwim = false
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var navigateToMain = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }

                Section(header: Text("Profile Information")) {
                    TextField("User Name", text: $userName)
                    Toggle(isOn: $isOrganization) {
                        Text("Are you an organization?")
                    }
                    Toggle(isOn: $interestedInOysterRestoration) {
                        Text("Interested in Oyster Restoration")
                    }
                    Toggle(isOn: $interestedInPlantingTrees) {
                        Text("Interested in Planting Trees")
                    }
                    Toggle(isOn: $canSwim) {
                        Text("Can you swim?")
                    }
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Address", text: $address)
                }

                Button(action: {
                    checkIfEmailExists()
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }

            NavigationLink(destination: MainView(), isActive: $navigateToMain) {
                EmptyView()
            }
        }
        .navigationTitle("Sign Up")
    }

    func checkIfEmailExists() {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                errorMessage = error.localizedDescription
                showingError = true
                return
            }
            if let methods = methods, !methods.isEmpty {
                errorMessage = "The email address is already in use by another account."
                showingError = true
            } else {
                signUp()
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showingError = true
            } else {
                saveUserInfo()
                navigateToMain = true
            }
        }
    }

    func saveUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "email": email,
            "userName": userName,
            "isOrganization": isOrganization,
            "interestedInOysterRestoration": interestedInOysterRestoration,
            "interestedInPlantingTrees": interestedInPlantingTrees,
            "canSwim": canSwim,
            "phoneNumber": phoneNumber,
            "address": address
        ]) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}
