import SwiftUI

struct QuickInputView: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool
    var onSubmit: (String) -> Void
    var onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "plus")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.black.opacity(0.3))

            TextField("Quick add todo…", text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .focused($isFocused)
                .onSubmit {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        onSubmit(text)
                        text = ""
                    }
                }
                .onExitCommand {
                    text = ""
                    onDismiss()
                }

            if !text.isEmpty {
                Text("↩")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.black.opacity(0.2))
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(width: 480)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 20, y: 8)
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        .onAppear {
            isFocused = true
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: text.isEmpty)
        .preferredColorScheme(.light)
    }
}
