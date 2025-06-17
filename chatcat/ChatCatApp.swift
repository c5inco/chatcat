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
    @StateObject private var appState = AppState()

    var body: some Scene {
        MenuBarExtra {
            ContentView(appState: appState)
        } label: {
            Text(ContentView.format(timeInterval: appState.elapsedTime))
                .font(.system(.body, design: .monospaced))
        }
        .menuBarExtraStyle(.window) // Use a modern, window-based popover.
    }
}
