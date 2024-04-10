//
//  LeadersView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

class LeadersManager: ObservableObject {
    
    @Published var leaders: [UserModel] = []
    @Published var loadedLeaders = false
    
    func loadLeaders() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snap in
            for child in snap.children {
                guard let snap = child as? DataSnapshot,
                      let userItemDict = snap.value as? [String: Any],
                      let userId = userItemDict["id"] as? String,
                      let name = userItemDict["name"] as? String,
                      let score = userItemDict["score"] as? Int else {
                        print("Error: Unable to extract required data from snapshot.")
                        continue
                }
                self.leaders.append(UserModel(id: userId, name: name, score: score))
            }
            self.leaders = self.leaders.sorted { $0.score > $1.score }
            self.loadedLeaders = true
        }
    }
    
    func addScore(add score: Int) {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "")
        ref.observeSingleEvent(of: .value) { snap in
            guard let userItemDict = snap.value as? [String: Any],
                  let storedScore = userItemDict["score"] as? Int else {
                    return
                }
            let newScore = storedScore + score
            ref.updateChildValues(["score": newScore])
        }
    }
    
}
