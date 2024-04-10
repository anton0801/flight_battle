//
//  MenuView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("user")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .cornerRadius(24)
                    
                    if authManager.checkIfLoggedIn() {
                        Text(authManager.getUserName())
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .medium))
                            .padding(.leading, 2)
                    } else {
                        NavigationLink(destination: AuthView()
                            .environmentObject(authManager)) {
                            Text("Log In")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .medium))
                                .padding(.leading, 2)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .frame(width: 300, height: 150)
                
                Spacer()
                
                NavigationLink(destination: GameView()
                    .navigationBarBackButtonHidden(true)) {
                    Text("Play")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250)
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
                
                HStack {
                    NavigationLink(destination: LeaderBoardView()) {
                        Text("Leaders")
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
                    
                    NavigationLink(destination: BlogView()) {
                        Text("Blog")
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
                
                NavigationLink(destination: SettingsView()
                    .environmentObject(authManager)) {
                    Text("Settings")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250)
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
                
                Spacer()
            }
//            .background(
//                LinearGradient(gradient: Gradient(colors: [Color(hex: 0x08041D, opacity: 1), Color(hex: 0x070727, opacity: 1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                    .ignoresSafeArea()
//            )
            .background(
                Image("game_back")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuView()
        .environmentObject(AuthManager())
}
