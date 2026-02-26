import SwiftUI

@main
struct EasyTodoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Window("EasyTodo", id: "main") {
            MainView()
        }
        .defaultSize(width: 400, height: 560)
        .windowStyle(.hiddenTitleBar)

        MenuBarExtra("EasyTodo", systemImage: "checklist") {
            MenuBarView()
        }
    }
}
