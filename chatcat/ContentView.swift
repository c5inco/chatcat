//
//  ContentView.swift
//  chatcat
//
//  Created by Chris Sinco on 6/16/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(spacing: 15) {
            Text("App Activity Tracker")
                .font(.headline)

            // Section for configuring the tracked app
            VStack(alignment: .leading) {
                Text("Tracked App Bundle ID:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("e.g., com.apple.dt.Xcode", text: $appState.targetBundleID)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)
                
                Text("Find an app's ID via Terminal:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app")
                    .font(.system(.caption, design: .monospaced))
                    .padding(5)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(5)
            }

            Divider()

            // Section for displaying stats
            HStack(alignment: .top, spacing: 20) {
                VStack {
                    Text("Activations")
                        .font(.title2)
                    Text("\(appState.activationCount)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                VStack {
                    Text("Session Time")
                        .font(.title2)
                    Text(format(timeInterval: appState.elapsedTime))
                        .font(.system(size: 48, weight: .regular, design: .monospaced))
                        .foregroundColor(.accentColor)
                }
            }
            
            // A button to reset the count.
            Button("Reset Activation Count") {
                appState.resetCount()
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")

        }
        .padding()
        .frame(width: 400)
    }
    
    /// Helper function to format seconds into a HH:MM:SS string.
    private func format(timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        // Ensure it shows 00:00 for the start.
        return formatter.string(from: max(0, timeInterval)) ?? "00:00:00"
    }
}


#Preview {
    ContentView(appState: AppState())
}
