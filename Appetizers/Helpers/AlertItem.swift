//
//  AlertItem.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}


struct AlertContext {
    
    static let invalidURL = AlertItem(
        title: Text("URL Error"),
        message: Text("The URL provided was invalid."),
        dismissButton: .default(Text("OK"))
    )

    static let invalidResponse = AlertItem(
        title: Text("Server Error"),
        message: Text("Invalid response from the server."),
        dismissButton: .default(Text("OK"))
    )

    static let decodingFailed = AlertItem(
        title: Text("Decoding Error"),
        message: Text("Unable to process the data received from the server."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidData = AlertItem(
        title: Text("Data Error"),
        message: Text("No data was returned from the server."),
        dismissButton: .default(Text("OK"))
    )

    static let unknown = AlertItem(
        title: Text("Unknown Error"),
        message: Text("Something went wrong. Check Your Network Connection"),
        dismissButton: .default(Text("OK"))
    )
}
