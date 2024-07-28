//
//  LoginView.swift
//  MRDeltaMary
//
//  Created by Zhifu Xie on 7/28/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var navigateToMain = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Log In")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }

                Button(action: {
                    logIn()
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
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
        .navigationTitle("Log In")
    }

    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showingError = true
            } else {
                navigateToMain = true
            }
        }
    }
}
