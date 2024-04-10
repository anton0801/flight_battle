//
//  SettingsView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI
import FirebaseAuth
import StoreKit

struct SettingsView: View {
    
//    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var authManager: AuthManager
    
    @State var pushNotifications = true
    @State var soundsEnabled = true
    
    @State var changeUserNameAlert = false
    
    @State var userNameInput = ""
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if authManager.userName != nil {
                HStack {
                    Text(authManager.userName ?? "")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button {
                        changeUserNameAlert = true
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 21, height: 21)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .fill(.red)
                            )
                    }
                    .padding(.leading, 2)
                }
            } else {
                NavigationLink(destination: AuthView()
                    .environmentObject(authManager)) {
                        HStack {
                            Image("user")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(24)
                            
                            Text("Log In")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .medium))
                                .padding(.leading, 2)
                        }
                }
            }
            
            Spacer()
            
            VStack {
                VStack {
                    HStack {
                        Text("Push notifications")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle(isOn: $pushNotifications, label: {
                            EmptyView()
                        })
                        .onChange(of: pushNotifications) { _ in
                            UserDefaults.standard.set(pushNotifications, forKey: "push_notifications")
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                        .fill(.gray)
                        .frame(height: 0.5)
                        .padding([.top, .bottom])
                    
                    Text("Sounds")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Sounds")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle(isOn: $soundsEnabled, label: {
                            EmptyView()
                        })
                        .onChange(of: soundsEnabled) { _ in
                            UserDefaults.standard.set(soundsEnabled, forKey: "sounds_enabled")
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                        .fill(.gray)
                        .frame(height: 0.5)
                        .padding([.top, .bottom])
                    
                    if authManager.userName != nil {
                        Text("Account")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Button {
                                authManager.logOut()
                            } label: {
                                Text("Log Out")
                                    .font(.system(size: 18, weight: .bold))
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
                            
                            Button {
                                authManager.deleteAccount()
                            } label: {
                                Text("Delete")
                                    .font(.system(size: 18, weight: .bold))
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
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.black)
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white)
            )
            .padding()
            
            
            Spacer()
            
            HStack {
                Button {
                    // requestReview()
                    let scenes = UIApplication.shared.connectedScenes
                    if let windowScene = scenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                } label: {
                    Text("Rate App")
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
                
                Button {
                    let AV = UIActivityViewController(activityItems: ["https://apps.apple.com/ru/app/big-win-game/id6479698862"], applicationActivities: nil)
                        let activeScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                        let rootViewController = (activeScene?.windows ?? []).first(where: { $0.isKeyWindow })?.rootViewController
                        // for iPad. if condition is optional.
                        if UIDevice.current.userInterfaceIdiom == .pad{
                            AV.popoverPresentationController?.sourceView = rootViewController?.view
                            AV.popoverPresentationController?.sourceRect = .zero
                        }
                        rootViewController?.present(AV, animated: true, completion: nil)
                } label: {
                    Text("Share App")
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
            .alert("Change your username", isPresented: $changeUserNameAlert) {
                TextField("Enter your new username", text: $userNameInput)
                Button {
                    authManager.updateUserName(newUserName: userNameInput)
                } label: {
                    Text("Ok")
                }
            } message: {
                Text("Enter your new username and in few seconds it will update")
            }
        }
        .onAppear {
            pushNotifications = UserDefaults.standard.bool(forKey: "push_notifications")
            soundsEnabled = UserDefaults.standard.bool(forKey: "sounds_enabled")
        }
        .background(
            Image("game_back")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthManager())
}
