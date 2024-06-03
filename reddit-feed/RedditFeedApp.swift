//
//  RedditFeedApp.swift
//  reddit-feed
//
//  Created by Sashko Potapov on 02.06.2024.
//

import SwiftUI
import Vision

@main
struct RedditFeedApp: App {
    let classifier: VNCoreMLModel = try! VNCoreMLModel(for: NSFWClassifier().model)
    
    var body: some Scene {
        WindowGroup {
            ContentView(classifier: classifier)
        }
    }
}
