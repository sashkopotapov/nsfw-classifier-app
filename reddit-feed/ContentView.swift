//
//  ContentView.swift
//  reddit-feed
//
//  Created by Sashko Potapov on 02.06.2024.
//

import SwiftUI
import Vision

struct Post: Identifiable {
    var id = UUID()
    var username: String
    var subreddit: String
    var title: String
    var upvotes: Int
    var comments: Int
    var isPromoted: Bool
    var image: String
    var isExplicit: Bool = false
}

struct ContentView: View {
    let classifier: VNCoreMLModel
    
    @State var data: [Post] = testData
    
    var body: some View {
        NavigationView {
            List(data) { post in
                PostView(post: post)
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Color(uiColor: UIColor.secondarySystemBackground)
                    )
                    .listRowInsets(
                        EdgeInsets(
                            top: 5,
                            leading: 0,
                            bottom: 5,
                            trailing: 0
                        )
                    )
                    .onAppear {
                        let request = VNCoreMLRequest(model: classifier) { (request, error) in
                            if let results = request.results as? [VNClassificationObservation] {
                                self.handleClassificationResults(results, for: post.id)
                            }
                        }
                        
                        guard let image = UIImage(named: post.image),
                              let cgImage = image.cgImage
                        else {
                            return
                        }
                        
                        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            do {
                                try handler.perform([request])
                            } catch {
                                print("Failed to perform classification.\n\(error.localizedDescription)")
                            }
                        }
                    }
            }
            .listStyle(.plain)
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
    
    func handleClassificationResults(_ results: [VNClassificationObservation], for postID: Post.ID) {
        for classification in results {
            let confidence = classification.confidence
            let identifier = classification.identifier

            if identifier == "nsfw" && confidence > 0.95 {
                if let index = data.firstIndex(where: { $0.id == postID }) {
                    data[index].isExplicit = true
                }
            }
        }
    }
}

struct PostView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("r/\(post.subreddit)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(post.isPromoted ? "PROMOTED" : "")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Text(post.title)
                .font(.headline)
                .padding(.top, 2)
            
            if !post.image.isEmpty {
                ZStack(alignment: .center) {
                    Image(post.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.top, 5)
                        .blur(radius: post.isExplicit ? 10.0 : 0.0)
                    
                    if post.isExplicit {
                        Text("Potentially Explicit Content")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "arrow.up")
                    Text("\(post.upvotes)")
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "text.bubble")
                    Text("\(post.comments) comments")
                }
                
                Spacer()
                
                Image(systemName: "square.and.arrow.up")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.top, 5)
        }
        .padding()
        .background(Color(uiColor: UIColor.systemBackground))
    }
}

#Preview {
    ContentView(classifier: try! .init(for: .init()))
}

let testData = [
    Post(username: "u/redditads", subreddit: "Promoted", title: "Advertise with Promoted Posts in the official Reddit App", upvotes: 3200, comments: 126, isPromoted: true, image: "advert"),
        Post(username: "u/ezzif", subreddit: "pics", title: "I took 5 pictures with my drone to create this inception style picture.", upvotes: 7346, comments: 236, isPromoted: false, image: "drone"),
        Post(username: "u/catslover", subreddit: "aww", title: "Look at this cute kitten!", upvotes: 10450, comments: 653, isPromoted: false, image: "kitten"),
        Post(username: "u/gamingfan", subreddit: "gaming", title: "Top 10 tips for improving your gameplay", upvotes: 4532, comments: 234, isPromoted: false, image: "gaming"),
        Post(username: "u/travelbug", subreddit: "travel", title: "Beautiful sunset at the beach", upvotes: 8764, comments: 452, isPromoted: false, image: "sunset"),
        Post(username: "u/foodie", subreddit: "food", title: "The best homemade pizza recipe", upvotes: 5412, comments: 312, isPromoted: false, image: "pizza"),
        Post(username: "u/techgeek", subreddit: "technology", title: "Latest advancements in AI technology", upvotes: 3987, comments: 208, isPromoted: false, image: "ai"),
        Post(username: "u/beachbum", subreddit: "beach", title: "Check out my IG account for more content!", upvotes: 2754, comments: 876, isPromoted: false, image: "beach"),
        Post(username: "u/holidayfun", subreddit: "travel", title: "Subscribe to my IG for more beach photos!", upvotes: 3642, comments: 921, isPromoted: false, image: "travel")
]
