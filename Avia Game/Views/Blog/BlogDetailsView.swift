//
//  BlogDetailsView.swift
//  Avia Game
//
//  Created by Anton on 10/4/24.
//

import SwiftUI

struct BlogDetailsView: View {
    
    var blogItem: BlogItem
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text(blogItem.title)
                             .foregroundColor(.white)
                             .font(.system(size: 32, weight: .bold))
                         
                         Spacer()
                     }
                    
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
                    
                    Text(blogItem.text)
                         .foregroundColor(.white)
                         .font(.system(size: 20, weight: .medium))
                         .multilineTextAlignment(.leading)
                         .padding(.top)
                }
                .padding()
            }
        }
        .background(
            Image("game_back")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
    }
}

#Preview {
    BlogDetailsView(blogItem: BlogItem(title: "Test", text: "Test", image: "https://img.freepik.com/free-photo/people-making-hands-heart-shape-silhouette-sunset_53876-15987.jpg?size=626&ext=jpg&ga=GA1.1.1700460183.1712707200&semt=sph"))
}
