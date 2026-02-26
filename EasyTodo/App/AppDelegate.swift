import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: QuickInputPanel?
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private var controlWasPressed = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupPanel()
        registerGlobalShortcut()
        requestAccessibilityIfNeeded()
    }

    // MARK: - Panel

    private func setupPanel() {
        let inputView = QuickInputView(
            onSubmit: { [weak self] title in
                TodoStore.shared.add(title: title)
                self?.dismissPanel()
            },
            onDismiss: { [weak self] in
                self?.dismissPanel()
            }
        )

        let hostingView = NSHostingView(rootView: inputView)
        panel = QuickInputPanel(contentView: hostingView)
    }

    private func dismissPanel() {
        panel?.dismiss()
        // Return focus to the previously active app
        NSApp.hide(nil)
    }

    func toggleFloatingPanel() {
        panel?.toggle()
    }

    // MARK: - Global Shortcut

    private func registerGlobalShortcut() {
        // Monitor for single Control key press (press and release without other keys)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.handleFlagsChanged(event)
        }

        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.handleFlagsChanged(event)
            return event
        }
    }

    private func handleFlagsChanged(_ event: NSEvent) {
        let controlPressed = event.modifierFlags.contains(.control)
        let onlyControl = event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .control

        if onlyControl && !controlWasPressed {
            // Control just pressed alone
            controlWasPressed = true
        } else if !controlPressed && controlWasPressed {
            // Control released — trigger toggle
            controlWasPressed = false
            DispatchQueue.main.async { [weak self] in
                self?.toggleFloatingPanel()
            }
        } else if !onlyControl {
            // Another modifier was added, cancel
            controlWasPressed = false
        }
    }

    // MARK: - Accessibility

    private func requestAccessibilityIfNeeded() {
        // Check silently first — only prompt if not yet trusted
        let isTrusted = AXIsProcessTrusted()
        if !isTrusted {
            // Prompt once
            AXIsProcessTrustedWithOptions(
                [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
            )
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            NSApp.activate(ignoringOtherApps: true)
        }
        return true
    }
}
