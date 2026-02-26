import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    var onToggle: () -> Void
    var onDelete: () -> Void
    var onUpdate: (String) -> Void

    @State private var isEditing = false
    @State private var editText = ""
    @State private var isHovering = false
    @State private var checkScale: CGFloat = 1.0

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                    checkScale = 1.3
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        checkScale = 1.0
                    }
                }
                onToggle()
            } label: {
                ZStack {
                    Circle()
                        .stroke(item.isCompleted ? Color.clear : Color.black.opacity(0.15), lineWidth: 1.5)
                        .frame(width: 20, height: 20)

                    if item.isCompleted {
                        Circle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: 20, height: 20)
                            .transition(.scale.combined(with: .opacity))

                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .scaleEffect(checkScale)
                .contentShape(Circle().scale(1.5))
            }
            .buttonStyle(.plain)

            // Title / Edit
            if isEditing {
                TextField("", text: $editText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .onSubmit {
                        if !editText.trimmingCharacters(in: .whitespaces).isEmpty {
                            onUpdate(editText)
                        }
                        isEditing = false
                    }
                    .onExitCommand {
                        isEditing = false
                    }
            } else {
                Text(item.title)
                    .font(.system(size: 14))
                    .foregroundStyle(item.isCompleted ? Color.black.opacity(0.25) : .black.opacity(0.8))
                    .strikethrough(item.isCompleted, color: .black.opacity(0.15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 0)

            // Edit button (appears on hover)
            if isHovering && !isEditing {
                Button {
                    editText = item.title
                    isEditing = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.25))
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }

            // Delete button (appears on hover)
            Button {
                onDelete()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.black.opacity(0.25))
                    .frame(width: 20, height: 20)
                    .background(Color.black.opacity(0.04), in: Circle())
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .opacity(isHovering ? 1 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovering)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isHovering ? Color.black.opacity(0.025) : Color.clear)
        )
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .animation(.easeOut(duration: 0.15), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
