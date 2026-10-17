import SwiftUI

struct StatisticsResultView: View {
    let query: StatisticsQuery
    @EnvironmentObject private var store: UniversityStore

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .firstTextBaseline) {
                Text(resultTitle)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.universityInk)
                Spacer()
                TagPill(text: resultCountLabel, tint: resultTint, background: resultSoft)
            }

            switch query.condition {
            case .gpa:
                let matches = store.students(matching: query)
                if matches.isEmpty {
                    emptyResult("No students match this GPA rule.")
                } else {
                    ForEach(matches) { student in
                        UniversityCard(padding: 15) {
                            HStack(spacing: 12) {
                                initialsBadge(student.name)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(student.name)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color.universityInk)
                                    Text(student.studentID)
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundStyle(Color.universityMuted)
                                }
                                Spacer()
                                TagPill(text: String(format: "GPA %.1f", student.gpa), tint: resultTint, background: resultSoft)
                            }
                        }
                    }
                }
            case .passed, .failed:
                ForEach(store.subjects) { subject in
                    let names = query.condition == .passed
                        ? store.passedStudents(for: subject)
                        : store.failedStudents(for: subject)
                    UniversityCard(padding: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .center, spacing: 9) {
                                Image(systemName: "books.vertical.fill")
                                    .foregroundStyle(resultTint)
                                    .frame(width: 37, height: 37)
                                    .background(resultSoft, in: RoundedRectangle(cornerRadius: 12))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(subject.name)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color.universityInk)
                                    Text("\(subject.id)  ·  \(subject.credit) credits")
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                        .foregroundStyle(Color.universityMuted)
                                }
                                Spacer()
                                TagPill(text: "\(names.count) students", tint: resultTint, background: resultSoft)
                            }
                            Divider().overlay(Color.universityLine)
                            if names.isEmpty {
                                Text("No graded students in this group yet.")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.universityMuted)
                            } else {
                                ForEach(names) { student in
                                    HStack(spacing: 8) {
                                        Circle().fill(resultTint).frame(width: 6, height: 6)
                                        Text(student.name)
                                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.universityInk)
                                        Spacer()
                                        Text(student.studentID)
                                            .font(.system(size: 11, weight: .medium, design: .rounded))
                                            .foregroundStyle(Color.universityMuted)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 10)
    }

    private var resultTitle: String {
        switch query.condition {
        case .gpa: return "Matching students"
        case .passed: return "Passed by subject"
        case .failed: return "Failed by subject"
        }
    }

    private var resultTint: Color {
        switch query.condition {
        case .gpa: return .universityBlue
        case .passed: return .universityTeal
        case .failed: return .universityRed
        }
    }

    private var resultSoft: Color {
        switch query.condition {
        case .gpa: return .universityBlueSoft
        case .passed: return .universityTealSoft
        case .failed: return .universityRedSoft
        }
    }

    private var resultCountLabel: String {
        switch query.condition {
        case .gpa:
            return "\(store.students(matching: query).count) found"
        case .passed:
            return "Mark ≥ 50"
        case .failed:
            return "Mark < 50"
        }
    }

    private func emptyResult(_ message: String) -> some View {
        UniversityCard {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.universityMuted)
                Text(message)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.universityMuted)
            }
        }
    }

    private func initialsBadge(_ name: String) -> some View {
        Text(name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined())
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(Color.universityBlue)
            .frame(width: 43, height: 43)
            .background(Color.universityBlueSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
