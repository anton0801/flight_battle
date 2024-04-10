//
//  AuthManager.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

enum AuthState {
    case none
    case success
    case failure(String)
}

class AuthManager: ObservableObject {
    
    @Published var authState: AuthState = AuthState.none
    @Published var userName: String? = UserDefaults.standard.string(forKey: "user_name")
    
    func checkIfLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "is_logged_in")
    }
    
    func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "user_name") ?? ""
    }
    
    func logOut() {
        userName = nil
        UserDefaults.standard.set(false, forKey: "is_logged_in")
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
          } else {
              self.logOut()
          }
        }
    }
    
    func updateUserName(newUserName: String) {
        guard !newUserName.isEmpty else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "")
        let userData: [String: Any] = [
            "name": newUserName
        ]
        ref.updateChildValues(userData)
        userName = newUserName
        UserDefaults.standard.set(newUserName, forKey: "user_name")
    }
    
    func anonymouslyLogIn(completion: @escaping (AuthState) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            do {
                guard let authResult = authResult else {
                    throw error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                }
                
                UserDefaults.standard.set(true, forKey: "is_logged_in")
                let ref = Database.database().reference().child("users").child(authResult.user.uid)
                
                let name = "userName_\( Int.random(in: 1000000..<5000000))"
                self.userName = name
                
                let userData: [String: Any] = [
                    "name": name,
                    "id": UUID().uuidString,
                    "score": 0
                ]
                ref.setValue(userData)
                
                UserDefaults.standard.set(name, forKey: "user_name")
                completion(.success)
            } catch let error as NSError {
                completion(.failure(error.localizedDescription))
            }
        }
    }
    
    func auth(email: String, password: String, completion: @escaping (AuthState) -> Void) {
        guard !email.isEmpty else {
            completion(.failure("Email is empty"))
            return
        }

        guard !password.isEmpty else {
            completion(.failure("Password is empty"))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            do {
                guard let authResult = authResult else {
                    throw error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                }
                
                UserDefaults.standard.set(true, forKey: "is_logged_in")
                let ref = Database.database().reference().child("users").child(authResult.user.uid)
                ref.observeSingleEvent(of: .value) { snap in
                    guard let userItemDict = snap.value as? [String: Any],
                          let userId = userItemDict["id"] as? String,
                          let name = userItemDict["name"] as? String,
                          let email = userItemDict["email"] as? String else {
                            completion(.failure("Error: Unable to extract required data from snapshot."))
                            return
                        }
                    self.userName = name
                    UserDefaults.standard.set(name, forKey: "user_name")
                    completion(.success)
                }
            } catch let error as NSError {
                let errorMessage = "Email or password is incorrect"
                completion(.failure(errorMessage))
            }
        }
    }
    
    func register(email: String, password: String, name: String, completion: @escaping (AuthState) -> Void) {
        guard !email.isEmpty else {
            completion(.failure("Email is empty"))
            return
        }

        guard !password.isEmpty else {
            completion(.failure("Password is empty"))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                print(error.localizedDescription)
                authState = .failure("Registration failed: \(error.localizedDescription)")
            } else {
                // Регистрация успешна
                authState = .success
                var name2 = name
                if name2.isEmpty {
                    name2 = "userName_\( Int.random(in: 1000000..<5000000))"
                }

                let ref = Database.database().reference().child("users").child(authResult?.user.uid ?? "")
                let userData: [String: Any] = [
                    "email": email,
                    "name": name2,
                    "id": UUID().uuidString,
                    "score": 0
                ]
                userName = name2
                UserDefaults.standard.set(name2, forKey: "user_name")
                UserDefaults.standard.set(true, forKey: "is_logged_in")
                ref.setValue(userData)
            }
        }
    }
    
}
