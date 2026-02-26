import SwiftUI

struct MenuBarView: View {
    @State private var store = TodoStore.shared
    @Environment(\.openWindow) private var openWindow

    private var recentItems: [TodoItem] {
        Array(store.items.filter { !$0.isCompleted }.prefix(5))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                openWindow(id: "main")
                NSApp.activate(ignoringOtherApps: true)
            } label: {
                Label("Open EasyTodo", systemImage: "macwindow")
            }
            .keyboardShortcut("o")

            Divider()

            if recentItems.isEmpty {
                Text("No todos yet")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 2)
            } else {
                ForEach(recentItems) { item in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.black.opacity(0.12))
                            .frame(width: 5, height: 5)
                        Text(item.title)
                            .lineLimit(1)
                    }
                    .font(.system(size: 12))
                    .padding(.vertical, 1)
                }
            }

            Divider()

            Button("Quit EasyTodo") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .frame(width: 200)
    }
}
