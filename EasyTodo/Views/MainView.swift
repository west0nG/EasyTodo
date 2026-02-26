import SwiftUI

struct MainView: View {
    @State private var store = TodoStore.shared
    @State private var newTodoTitle = ""
    @State private var inputFocused = false
    @FocusState private var isTextFieldFocused: Bool

    private var pendingItems: [TodoItem] {
        store.items.filter { !$0.isCompleted }
    }

    private var completedItems: [TodoItem] {
        store.items.filter { $0.isCompleted }
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Todos")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)

                    Spacer()

                    Text("\(pendingItems.count)")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.04), in: Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Input bar
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(isTextFieldFocused ? Color.black : .secondary)
                        .animation(.easeOut(duration: 0.2), value: isTextFieldFocused)

                    TextField("Add a new todo…", text: $newTodoTitle)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14))
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                store.add(title: newTodoTitle)
                            }
                            newTodoTitle = ""
                        }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.03), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isTextFieldFocused ? Color.black.opacity(0.12) : Color.clear, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .animation(.easeOut(duration: 0.2), value: isTextFieldFocused)

                // List
                if store.items.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "checklist")
                            .font(.system(size: 32, weight: .light))
                            .foregroundStyle(Color.black.opacity(0.15))
                        Text("No todos yet")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                        Text("Type above, or press Control to quick-add")
                            .font(.system(size: 12))
                            .foregroundStyle(.quaternary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            if !pendingItems.isEmpty {
                                ForEach(pendingItems) { item in
                                    TodoRowView(
                                        item: item,
                                        onToggle: {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                store.toggleComplete(item)
                                            }
                                        },
                                        onDelete: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                store.delete(item)
                                            }
                                        },
                                        onUpdate: { store.update(item, title: $0) }
                                    )
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.9).combined(with: .opacity).combined(with: .offset(y: -8)),
                                        removal: .scale(scale: 0.85).combined(with: .opacity)
                                    ))
                                }
                            }

                            if !completedItems.isEmpty {
                                HStack {
                                    Text("Completed")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundStyle(.quaternary)
                                    Rectangle()
                                        .fill(Color.black.opacity(0.04))
                                        .frame(height: 0.5)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 4)

                                ForEach(completedItems) { item in
                                    TodoRowView(
                                        item: item,
                                        onToggle: {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                store.toggleComplete(item)
                                            }
                                        },
                                        onDelete: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                store.delete(item)
                                            }
                                        },
                                        onUpdate: { store.update(item, title: $0) }
                                    )
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                                        removal: .scale(scale: 0.85).combined(with: .opacity)
                                    ))
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
        .frame(minWidth: 360, idealWidth: 400, minHeight: 400, idealHeight: 560)
    }
}
