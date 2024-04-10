//
//  RegisterView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var authManager: AuthManager
    
    @State private var nameInput = ""
    @State private var emailInput = ""
    @State private var passwordInput = ""
    
    @State private var alertShow = false
    @State private var alertMessage = ""
    
    @State private var authLoadingResult = false
    
    var body: some View {
        VStack {
            if authLoadingResult {
                ProgressView()
            } else {
                VStack {
                    HStack {
                        Text("Register Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.leading)
                    
                    VStack {
                        TextField("", text: $nameInput)
                            .keyboardType(.emailAddress)
                            .padding(10)
                            .placeholder(when: emailInput.isEmpty, placeholder: {
                                Text("Username")
                                    .foregroundColor(.white)
                                    .padding()
                            })
                            .foregroundColor(.white)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.white)
                            )
                        
                        Spacer().frame(height: 12)
                        
                        TextField("", text: $emailInput)
                            .keyboardType(.emailAddress)
                            .padding(10)
                            .placeholder(when: emailInput.isEmpty, placeholder: {
                                Text("Email")
                                    .foregroundColor(.white)
                                    .padding()
                            })
                            .foregroundColor(.white)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.white)
                            )
                        
                        Spacer().frame(height: 12)
                        
                        SecureField("", text: $passwordInput)
                            .keyboardType(.emailAddress)
                            .padding(10)
                            .placeholder(when: passwordInput.isEmpty, placeholder: {
                                Text("Password")
                                    .foregroundColor(.white)
                                    .padding()
                            })
                            .foregroundColor(.white)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.white)
                            )
                        
                        Spacer().frame(height: 24)
                        
                        Button {
                            withAnimation {
                                authLoadingResult = true
                            }
                            authManager.register(email: emailInput, password: passwordInput, name: nameInput) { authState in
                                withAnimation {
                                    authLoadingResult = false
                                }
                                if case .failure(let string) = authState {
                                    alertShow = true
                                    alertMessage = string
                                } else {
                                    presMode.wrappedValue.dismiss()
                                    presMode.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            Text("Sign in")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.red)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(.white)
                                )
                                .shadow(radius: 10)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(
            Image("game_back")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $alertShow) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }
}

#Preview {
    RegisterView()
}
