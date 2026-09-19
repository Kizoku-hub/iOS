import SwiftUI

struct StudentProfileView: View {
    let name = "Tran Trung Kien"
    let studentID = "SESEIU24014"
    var age = 24
    var gpa: Double = 36.67
    let isStudent = true
    let motto = "Better me, a brighter tomorrow!"

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo.opacity(0.22), .cyan.opacity(0.12), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [.indigo, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 210)

                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.25))
                                .frame(width: 92, height: 92)

                            Image(systemName: "person.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(.white)
                        }

                        Text(name)
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        Text("Always learning, always growing")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.bottom, 18)
                }

                ScrollView {
                    VStack(spacing: 16) {
                        infoCard(
                            icon: "person.text.rectangle.fill",
                            title: "Student ID",
                            value: studentID
                        )

                        HStack(spacing: 12) {
                            infoCard(icon: "calendar", title: "Age", value: "\(age)")
                            infoCard(
                                icon: "chart.bar.fill",
                                title: "GPA",
                                value: String(format: "%.2f", gpa)
                            )
                        }

                        infoCard(
                            icon: isStudent ? "checkmark.seal.fill" : "xmark.seal.fill",
                            title: "Status",
                            value: isStudent ? "Student / Active" : "Inactive"
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Motto", systemImage: "quote.opening")
                                .font(.headline)

                            Text("\(motto)")
                                .font(.body.italic())
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                        Button {
                        } label: {
                            Label("Edit Profile", systemImage: "pencil")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }

                HStack {
                    tabItem(icon: "person.fill", title: "Profile", selected: true)
                    tabItem(icon: "book.fill", title: "Subjects", selected: false)
                    tabItem(icon: "gearshape.fill", title: "Settings", selected: false)
                }
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(.regularMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding()
        }
    }

    private func infoCard(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 34, height: 34)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.headline)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func tabItem(icon: String, title: String, selected: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
            Text(title)
                .font(.caption)
        }
        .foregroundStyle(selected ? .blue : .secondary)
        .frame(maxWidth: .infinity)
    }
}