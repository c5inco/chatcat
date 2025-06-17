//
//  AppState.swift
//  chatcat
//
//  Created by Chris Sinco on 6/16/25.
//

import AppKit
import Combine

class AppState: ObservableObject {
    
    // MARK: - Published Properties for SwiftUI
    @Published var activationCount: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    
    @Published var targetBundleID: String = "" {
        didSet {
            // When the target app changes, reset everything and save.
            if oldValue != targetBundleID {
                activationCount = 0
                stopTimer() // Stop timer for the old app
                elapsedTime = 0
                saveState()
            }
        }
    }

    // MARK: - Private Timer Properties
    private var timer: Timer?
    private var activationDate: Date?

    init() {
        // Load the saved state when the app starts.
        loadState()
        
        // Set up observers to listen for app activation and deactivation.
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        notificationCenter.addObserver(
            self,
            selector: #selector(appDidActivate),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil // We want to be notified about *any* application.
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(appDidDeactivate),
            name: NSWorkspace.didDeactivateApplicationNotification,
            object: nil // Listen for when apps lose focus.
        )
    }

    // MARK: - Notification Handlers
    
    /// This function is called every time a new application becomes active.
    @objc func appDidActivate(notification: Notification) {
        guard let activatedApp = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        // If the activated app is our target, start tracking.
        if activatedApp.bundleIdentifier?.lowercased() == targetBundleID.lowercased() {
            // It's a match! Increment the counter and start the timer.
            DispatchQueue.main.async {
                if self.activationDate == nil { // Prevents incrementing if already active
                    self.activationCount += 1
                    self.saveState()
                    self.startTimer()
                }
            }
        }
    }
    
    /// This function is called every time an application becomes inactive.
    @objc func appDidDeactivate(notification: Notification) {
        guard let deactivatedApp = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        // If the deactivated app was our target, stop the timer.
        if deactivatedApp.bundleIdentifier?.lowercased() == targetBundleID.lowercased() {
            DispatchQueue.main.async {
                self.stopTimer()
            }
        }
    }
    
    // MARK: - Timer Logic
    
    /// Starts the session timer.
    private func startTimer() {
        // Ensure we don't start multiple timers.
        timer?.invalidate()
        
        activationDate = Date()
        elapsedTime = 0 // Reset for the new session
        
        // Create a timer that fires every second to update the UI.
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    /// Stops the session timer and cleans up.
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        activationDate = nil
        // We leave `elapsedTime` as is to show the final duration of the session.
    }
    
    /// Calculates the time since the app was activated.
    @objc private func updateElapsedTime() {
        guard let activationDate = activationDate else { return }
        DispatchQueue.main.async {
            self.elapsedTime = Date().timeIntervalSince(activationDate)
        }
    }

    // MARK: - State Persistence
    
    /// Saves the current state (count and target app) to UserDefaults.
    func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(activationCount, forKey: "activationCount")
        defaults.set(targetBundleID, forKey: "targetBundleID")
    }

    /// Loads the state from UserDefaults.
    func loadState() {
        let defaults = UserDefaults.standard
        self.activationCount = defaults.integer(forKey: "activationCount")
        self.targetBundleID = defaults.string(forKey: "targetBundleID") ?? ""
    }
    
    /// Resets the activation counter to zero.
    func resetCount() {
        self.activationCount = 0
        saveState()
    }
}
