//
//  BlogView.swift
//  Avia Game
//
//  Created by Anton on 7/4/24.
//

import SwiftUI

struct BlogView: View {
    
    @StateObject var blogManager = BlogManager()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                     Text("Blog")
                         .foregroundColor(.white)
                         .font(.system(size: 32, weight: .bold))
                     
                     Spacer()
                 }
                 .padding()
                
                if blogManager.loadedBlog {
                    ScrollView {
                        ForEach(blogManager.blog, id: \.id) { blogItem in
                            NavigationLink(destination: BlogDetailsView(blogItem: blogItem)) {
                                VStack {
                                    AsyncImage(url: URL(string: blogItem.image)) { image in
                                        image
                                            .resizable()
                                            .frame(height: 250)
                                            .cornerRadius(12)
                                    } placeholder: {
                                        VStack {
                                            ProgressView()
                                        }
                                        .frame(height: 250)
                                    }
                                    
                                    Text(blogItem.title)
                                      .foregroundColor(.white)
                                      .font(.system(size: 20, weight: .bold))
                                }
                                .padding()
                            }
                        }
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            .onAppear {
                blogManager.obtainBlogItems()
            }
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
    BlogView()
}
