//
//  LeaderBoardView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI

struct LeaderBoardView: View {
    
    @StateObject var leadersManager = LeadersManager()
    
    var body: some View {
        VStack {
            HStack {
                Text("Leaders")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
            }
            .padding()
            
            HStack {
                Text("Username")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Score")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding()
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.gray)
                .frame(height: 1)
                .padding([.leading, .trailing])
            
            if !leadersManager.loadedLeaders {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    VStack {
                        ForEach(leadersManager.leaders, id: \.id) { leader in
                            HStack {
                                Text(leader.name)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(leader.score)")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding([.leading, .trailing, .top])
                        }
                    }
                }
            }
        }
        .onAppear {
            leadersManager.loadLeaders()
        }
        .background(
            Image("game_back")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    LeaderBoardView()
}
