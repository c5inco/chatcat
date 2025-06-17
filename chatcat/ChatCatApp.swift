//
//  chatcatApp.swift
//  chatcat
//
//  Created by Chris Sinco on 6/16/25.
//

import SwiftUI
import AppKit
import Combine

@main
struct chatcapApp: App {
    // @StateObject ensures the AppState lives for the duration of the app.
    @StateObject private var appState = AppState()

    var body: some Scene {
        // MenuBarExtra is the API for creating menu bar items.
        MenuBarExtra {
            // This is the content of the popover when you click the menu bar item.
            ContentView(appState: appState)
        } label: {
            // This is what's displayed in the menu bar itself.
            // It shows the count and an icon.
            Label("\(appState.activationCount)", systemImage: "eye.fill")
        }
        .menuBarExtraStyle(.window) // Use a modern, window-based popover.
    }
}
