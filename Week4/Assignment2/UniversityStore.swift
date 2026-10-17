import Foundation
import Combine

final class UniversityStore: ObservableObject {
    @Published var students: [Student] = [
        Student(studentID: "ST1", name: "Mia Tran", gpa: 8.7),
        Student(studentID: "ST2", name: "Nam Pham", gpa: 7.4),
        Student(studentID: "ST3", name: "Linh Nguyen", gpa: 9.1),
        Student(studentID: "ST4", name: "An Le", gpa: 6.8),
        Student(studentID: "ST5", name: "Minh Vo", gpa: 8.1)
    ]

    @Published var teachers: [Teacher] = [
        Teacher(id: "TCH1", name: "Dr. Bao Tran", subjectIDs: ["SUB1", "SUB4"], className: "Class 1A"),
        Teacher(id: "TCH2", name: "Ms. Lan Nguyen", subjectIDs: ["SUB2", "SUB5"], className: "Class 1B"),
        Teacher(id: "TCH3", name: "Mr. Quang Le", subjectIDs: ["SUB3", "SUB5"], className: "Class 2A"),
        Teacher(id: "TCH4", name: "Ms. My Pham", subjectIDs: ["SUB4"], className: "Class 2B"),
        Teacher(id: "TCH5", name: "Dr. Son Vo", subjectIDs: ["SUB1", "SUB2", "SUB3"], className: "Class 3A")
    ]

    @Published var subjects: [Subject] = [
        Subject(id: "SUB1", name: "Calculus", credit: 3),
        Subject(id: "SUB2", name: "Physics", credit: 3),
        Subject(id: "SUB3", name: "Philosophy", credit: 2),
        Subject(id: "SUB4", name: "Programming", credit: 3),
        Subject(id: "SUB5", name: "English", credit: 2)
    ]

    @Published var studentSubjects: [StudentSubject] = [
        StudentSubject(idStudent: "ST1", idSubject: "SUB1", mark: 86),
        StudentSubject(idStudent: "ST1", idSubject: "SUB2", mark: 78),
        StudentSubject(idStudent: "ST1", idSubject: "SUB4", mark: 91),
        StudentSubject(idStudent: "ST2", idSubject: "SUB2", mark: 42),
        StudentSubject(idStudent: "ST2", idSubject: "SUB3", mark: 65),
        StudentSubject(idStudent: "ST2", idSubject: "SUB5", mark: 48),
        StudentSubject(idStudent: "ST3", idSubject: "SUB1", mark: 95),
        StudentSubject(idStudent: "ST3", idSubject: "SUB4", mark: 97),
        StudentSubject(idStudent: "ST3", idSubject: "SUB5", mark: 88),
        StudentSubject(idStudent: "ST4", idSubject: "SUB1", mark: 36),
        StudentSubject(idStudent: "ST4", idSubject: "SUB2", mark: 49),
        StudentSubject(idStudent: "ST4", idSubject: "SUB3", mark: 57),
        StudentSubject(idStudent: "ST5", idSubject: "SUB2", mark: 73),
        StudentSubject(idStudent: "ST5", idSubject: "SUB4", mark: 81),
        StudentSubject(idStudent: "ST5", idSubject: "SUB5", mark: 92)
    ]

    func subjectName(for id: String) -> String {
        subjects.first(where: { $0.id == id })?.name ?? "Unknown subject"
    }

    func learningSubjects(for studentID: String) -> [Subject] {
        let ids = Set(studentSubjects.filter { $0.idStudent == studentID }.map(\.idSubject))
        return subjects.filter { ids.contains($0.id) }
    }

    func assignedSubjectIDs(for studentID: String) -> Set<String> {
        Set(studentSubjects.filter { $0.idStudent == studentID }.map(\.idSubject))
    }

    func mark(for studentID: String, subjectID: String) -> Double? {
        studentSubjects.first(where: { $0.idStudent == studentID && $0.idSubject == subjectID })?.mark ?? nil
    }

    func saveStudent(_ student: Student, selectedSubjectIDs: Set<String>, marks: [String: Double]) {
        if let index = students.firstIndex(where: { $0.studentID == student.studentID }) {
            students[index].name = student.name
            students[index].gpa = student.gpa
        } else {
            students.append(student)
        }

        studentSubjects.removeAll { $0.idStudent == student.studentID }
        for subjectID in selectedSubjectIDs.sorted() {
            studentSubjects.append(StudentSubject(
                idStudent: student.studentID,
                idSubject: subjectID,
                mark: marks[subjectID]
            ))
        }
    }

    func saveTeacher(_ teacher: Teacher) {
        if let index = teachers.firstIndex(where: { $0.id == teacher.id }) {
            teachers[index] = teacher
        } else {
            teachers.append(teacher)
        }
    }

    func saveSubject(_ subject: Subject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
        } else {
            subjects.append(subject)
        }
    }

    func identifierExists(_ section: DirectorySection, id: String) -> Bool {
        switch section {
        case .students: return students.contains { $0.studentID == id }
        case .teachers: return teachers.contains { $0.id == id }
        case .subjects: return subjects.contains { $0.id == id }
        }
    }

    func passedStudents(for subject: Subject) -> [Student] {
        let passedIDs = Set(studentSubjects.compactMap { record -> String? in
            guard record.idSubject == subject.id, let mark = record.mark, mark >= 50 else { return nil }
            return record.idStudent
        })
        return students.filter { passedIDs.contains($0.studentID) }
    }

    func failedStudents(for subject: Subject) -> [Student] {
        let failedIDs = Set(studentSubjects.compactMap { record -> String? in
            guard record.idSubject == subject.id, let mark = record.mark, mark < 50 else { return nil }
            return record.idStudent
        })
        return students.filter { failedIDs.contains($0.studentID) }
    }

    func students(matching query: StatisticsQuery) -> [Student] {
        guard query.condition == .gpa else { return [] }
        return students.filter { student in
            switch query.comparison {
            case .above: return student.gpa > query.threshold
            case .below: return student.gpa < query.threshold
            case .equal: return abs(student.gpa - query.threshold) < 0.0001
            }
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
