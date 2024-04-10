//
//  AuthView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI

struct AuthView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var authManager: AuthManager
    
    @State private var emailInput = ""
    @State private var passwordInput = ""
    
    @State private var alertShow = false
    @State private var alertMessage = ""
    
    @State private var authLoadingResult = false
    
    var body: some View {
        NavigationView {
            VStack {
                if authLoadingResult {
                    ProgressView()
                } else {
                    VStack {
                        HStack {
                            Text("Welcome")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.leading)
                        
                        VStack {
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
                                authManager.auth(email: emailInput, password: passwordInput) { authState in
                                    withAnimation {
                                        authLoadingResult = false
                                    }
                                    if case .failure(let string) = authState {
                                        alertShow = true
                                        alertMessage = string
                                    } else {
                                        presMode.wrappedValue.dismiss()
                                    }
                                }
                            } label: {
                                Text("Log in")
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
                            
                            NavigationLink(destination: RegisterView()
                                .environmentObject(authManager)) {
                                    HStack {
                                        Text("Not have account?")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .medium))
                                        Text("Register now!")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .bold))
                                            .underline()
                                    }
                                    .padding()
                                }
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .fill(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: 1)
                                Text("or")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(8)
                                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .fill(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: 1)
                            }
                            
                            Button {
                                withAnimation {
                                    authLoadingResult = true
                                }
                                authManager.anonymouslyLogIn { state in
                                    withAnimation {
                                        authLoadingResult = false
                                    }
                                    if case .failure(let string) = state {
                                        alertShow = true
                                        alertMessage = string
                                    } else {
                                        presMode.wrappedValue.dismiss()
                                    }
                                }
                            } label: {
                                Text("Anonymously")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.gray)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
}
