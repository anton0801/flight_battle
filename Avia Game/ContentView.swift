//
//  ContentView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var authManager: AuthManager = AuthManager()
    
    var body: some View {
        VStack {
            MenuView()
                .environmentObject(authManager)
        }
    }
    
}

#Preview {
    ContentView()
}
