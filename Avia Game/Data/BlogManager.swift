//
//  BlogManager.swift
//  Avia Game
//
//  Created by Anton on 8/4/24.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class BlogManager: ObservableObject {
    
    @Published var blog: [BlogItem] = []
    @Published var loadedBlog = false
    
    func obtainBlogItems() {
        let ref = Database.database().reference().child("blog")
        ref.observeSingleEvent(of: .value) { snap in
            for child in snap.children {
                guard let snap = child as? DataSnapshot,
                      let blogItemDict = snap.value as? [String: Any],
                      let title = blogItemDict["title"] as? String,
                      let text = blogItemDict["text"] as? String,
                      let imageUrl = blogItemDict["imageUrl"] as? String else {
                        print("Error: Unable to extract required data from snapshot.")
                        continue
                }
                self.blog.append(BlogItem(title: title, text: text, image: imageUrl))
            }
            self.loadedBlog = true
            print(self.blog)
        }
    }
    
}
