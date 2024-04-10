//
//  GameView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    private var gameScene: GameScene {
        get {
           return GameScene()
        }
    }
    
    private let leadersManager = LeadersManager()
    
    @State var gameOver = false
    @State var gameIdScoreAdded: String? = nil
    @State var objectivePlane: String? = nil
    @State var currentObjectiveCompleted: Int? = nil
    @State var score: Int? = nil
    
    var body: some View {
        VStack {
            if gameOver {
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 300, height: 150)
                    
                    Spacer()
                    
                    Text("GAME OVER")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Score: \(score ?? 0)")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                        .padding(.top)
                    
                    Text("Objective:")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                        .padding(.top)
                    
                    HStack {
                        Text("\(currentObjectiveCompleted ?? 0)")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        Image(objectivePlane!)
                            .resizable()
                            .frame(width: 42, height: 42)
                            .rotationEffect(.degrees(-45))
                    }
                    
                    Spacer()
                    
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Text("Finish")
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
                }
                .background(
                    Image("game_back_avia")
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                        .opacity(0.8)
                )
                .preferredColorScheme(.dark)
            } else {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_OVER"))) { notification in
                        if let currentObjectiveCompleted = notification.userInfo?["data"] as? Int {
                            if let gameId = notification.userInfo?["gameId"] as? String,
                               let objectivePlane = notification.userInfo?["planeId"] as? String,
                               let score = notification.userInfo?["score"] as? Int {
                                gameOver = true
                                self.objectivePlane = objectivePlane
                                self.currentObjectiveCompleted = currentObjectiveCompleted
                                self.gameIdScoreAdded = gameId
                                self.score = score
                                leadersManager.addScore(add: self.score!)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    GameView()
}
