import Foundation

/// The three types shown as large cards on the Information screen.
enum DirectorySection: String, CaseIterable, Identifiable, Hashable {
    case students
    case teachers
    case subjects

    var id: String { rawValue }

    var title: String {
        switch self {
        case .students: return "Students"
        case .teachers: return "Teachers"
        case .subjects: return "Subjects"
        }
    }

    var subtitle: String {
        switch self {
        case .students: return "Student details, GPA and semester subjects"
        case .teachers: return "Teacher details and subjects they can teach"
        case .subjects: return "Subject details and credit values"
        }
    }

    var symbol: String {
        switch self {
        case .students: return "person.2.fill"
        case .teachers: return "person.crop.square.fill"
        case .subjects: return "books.vertical.fill"
        }
    }
}

struct Student: Identifiable, Hashable {
    /// Immutable after creation. `id` is a read-only alias used by SwiftUI.
    let studentID: String
    var id: String { studentID }
    var name: String
    var gpa: Double
}

struct Teacher: Identifiable, Hashable {
    /// Immutable after creation.
    let id: String
    var name: String
    /// IDs of subjects this teacher is able to teach.
    var subjectIDs: [String]
    var className: String
}

struct Subject: Identifiable, Hashable {
    /// Immutable after creation.
    let id: String
    var name: String
    var credit: Int
}

struct StudentSubject: Identifiable, Hashable {
    /// The relationship links one student and one subject. These IDs are immutable.
    let idStudent: String
    let idSubject: String
    /// Marks are on a 0–100 scale; nil means the mark has not been entered yet.
    var mark: Double?

    var id: String { "\(idStudent)-\(idSubject)" }
}

enum UniversityTab: String, CaseIterable, Identifiable {
    case information
    case statistics

    var id: String { rawValue }
    var title: String { self == .information ? "Information" : "Statistics" }
    var symbol: String { self == .information ? "square.grid.2x2.fill" : "chart.bar.fill" }
}

enum StatisticCondition: String, CaseIterable, Identifiable {
    case gpa = "GPA"
    case passed = "Passed"
    case failed = "Failed"

    var id: String { rawValue }
}

enum GPAComparison: String, CaseIterable, Identifiable {
    case above = "Above"
    case below = "Below"
    case equal = "Equal"

    var id: String { rawValue }
}

struct StatisticsQuery: Identifiable {
    let id = UUID()
    let condition: StatisticCondition
    let comparison: GPAComparison
    let threshold: Double
}
