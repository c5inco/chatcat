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
        VStack(alignment: .leading, spacing: 15) {
            // Section for configuring the tracked app
            VStack(alignment: .leading) {
                Text("Tracked App Bundle ID:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("e.g., com.apple.dt.Xcode", text: $appState.targetBundleID)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)
            }

            Divider()

            // Section for displaying stats
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Activations")
                        .font(.title3)
                    Text("\(appState.activationCount)")
                        .font(.system(size: 36, weight: .regular, design: .rounded))
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading) {
                    Text("Session Time")
                        .font(.title3)
                    Text(Self.format(timeInterval: appState.elapsedTime))
                        .font(.system(size: 36, weight: .regular, design: .monospaced))
                        .foregroundColor(.accentColor)
                }
            }
            
            Button("Reset") {
                appState.resetCount()
            }
        }
        .padding()
        .frame(width: 350)
    }
    
    /// Helper function to format seconds into a HH:MM:SS string.
    static func format(timeInterval: TimeInterval) -> String {
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
