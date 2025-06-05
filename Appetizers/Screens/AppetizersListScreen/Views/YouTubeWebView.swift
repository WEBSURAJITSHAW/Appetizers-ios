//
//  YouTubeWebView.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import SwiftUI
import WebKit

struct YouTubeWebView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let embedURLString = "https://www.youtube.com/embed/\(videoID)"
        if let url = URL(string: embedURLString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
