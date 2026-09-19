import SwiftUI

struct StudentCardView: View {
    let name = "Tran Trung Kien"
    let studentID = "SESEIU24014"
    var gpa = 36.67
    var status = "Active"

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.18), .purple.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Image(systemName: "person.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 82, height: 82)

                    VStack(alignment: .leading, spacing: 7) {
                        Text(name)
                            .font(.title2.bold())

                        Text("Student ID: \(studentID)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("GPA: \(gpa, specifier: "%.2f")")
                            .font(.subheadline.weight(.medium))
                    }

                    Spacer()
                }

                HStack {
                    Label("Student", systemImage: "graduationcap.fill")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(status)
                        .font(.caption.bold())
                        .foregroundStyle(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.green.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .padding(24)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 12, y: 6)
            .padding()
        }
    }
}