import SwiftUI

struct PlannerTask: Identifiable {
    let id = ID()
    var title: String
    var category: String
    var isCompleted: Bool
    var time: String
}

struct DailyPlannerView: View {
    @State private var tasks: [PlannerTask] = [
        PlannerTask(title: "Read chapter 2", category: "Study", isCompleted: false, time: "09:00"),
        PlannerTask(title: "Workout", category: "Health", isCompleted: false, time: "17:00"),
        PlannerTask(title: "Finish lab report", category: "Study", isCompleted: false, time: "20:00"),
        PlannerTask(title: "Call family", category: "Personal", isCompleted: false, time: "21:00")
    ]

    var completedCount: Int {
        tasks.filter(\.isCompleted).count
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint.opacity(0.18), .blue.opacity(0.10), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [.teal, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 170)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Good Morning,")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.9))

                        Text("My Daily Planner")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)

                        Text("Discipline today creates a brighter tomorrow.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))

                        Text("19 September 2026")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(22)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Tasks")
                            .font(.title2.bold())

                        Text("\(completedCount) of \(tasks.count) completed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        addTask()
                    } label: {
                        Label("Add Task", systemImage: "plus")
                            .font(.subheadline.bold())
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 20)
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($tasks) { $task in
                            taskRow(task: $task)
                        }
                    }
                    .padding()
                }

                HStack {
                    plannerTab(icon: "checklist", title: "Today", selected: true)
                    plannerTab(icon: "chart.bar.fill", title: "Stats", selected: false)
                    plannerTab(icon: "gearshape.fill", title: "Settings", selected: false)
                }
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(.regularMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding()
        }
    }

    private func taskRow(task: Binding<PlannerTask>) -> some View {
        HStack(spacing: 12) {
            Button {
                task.wrappedValue.isCompleted.toggle()
            } label: {
                Image(systemName: task.wrappedValue.isCompleted
                      ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.wrappedValue.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 5) {
                Text(task.wrappedValue.title)
                    .font(.headline)
                    .strikethrough(task.wrappedValue.isCompleted)

                HStack(spacing: 8) {
                    Text(task.wrappedValue.category)
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(categoryColor(task.wrappedValue.category).opacity(0.15))
                        .foregroundStyle(categoryColor(task.wrappedValue.category))
                        .clipShape(Capsule())

                    Label(task.wrappedValue.time, systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "Study":
            return .blue
        case "Health":
            return .green
        case "Personal":
            return .orange
        default:
            return .purple
        }
    }

    private func addTask() {
        tasks.append(
            PlannerTask(
                title: "New study task",
                category: "Study",
                isCompleted: false,
                time: "22:00"
            )
        )
    }

    private func plannerTab(icon: String, title: String, selected: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
            Text(title)
                .font(.caption)
        }
        .foregroundStyle(selected ? .blue : .secondary)
        .frame(maxWidth: .infinity)
    }
}