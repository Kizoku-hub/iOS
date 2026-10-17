import SwiftUI
import UIKit

struct EditInformationView: View {
    let section: DirectorySection
    let existingID: String?

    @EnvironmentObject private var store: UniversityStore
    @Environment(\.dismiss) private var dismiss

    @State private var identifier = ""
    @State private var name = ""
    @State private var gpaText = "8.0"
    @State private var creditText = "3"
    @State private var className = "Class 1A"
    @State private var selectedSubjectIDs: Set<String> = []
    @State private var marksText: [String: String] = [:]
    @State private var didLoad = false
    @State private var alertMessage: String?

    private var isEditing: Bool { existingID != nil }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(isEditing ? "Edit \(section.title.dropLast())" : "Add \(section.title.dropLast())")
                        .font(.system(size: 29, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.universityInk)
                    Text("Keep it simple. Your ID stays locked after creation.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                }
                .padding(.top, 14)

                UniversityCard {
                    VStack(alignment: .leading, spacing: 16) {
                        SectionEyebrow(title: "Basic information")
                        LabeledField(title: "ID", hint: idHint, text: $identifier, keyboard: .default, locked: isEditing)
                        LabeledField(title: "Name", hint: nameHint, text: $name, keyboard: .default)

                        switch section {
                        case .students:
                            LabeledField(title: "GPA (0–10)", hint: "e.g. 8.5", text: $gpaText, keyboard: .decimalPad)
                        case .teachers:
                            LabeledField(title: "Class", hint: "e.g. Class 1A", text: $className, keyboard: .default)
                        case .subjects:
                            LabeledField(title: "Credits", hint: "e.g. 3", text: $creditText, keyboard: .numberPad)
                        }
                    }
                }

                if section == .students {
                    UniversityCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .firstTextBaseline) {
                                SectionEyebrow(title: "Semester subjects")
                                Spacer()
                                TagPill(text: "\(selectedSubjectIDs.count) selected", tint: .universityBlue)
                            }
                            Text("Choose what this student must take, then enter a mark when available.")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.universityMuted)

                            if store.subjects.isEmpty {
                                Text("Add a subject first to assign it here.")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.universityMuted)
                            } else {
                                ForEach(store.subjects) { subject in
                                    VStack(alignment: .leading, spacing: 9) {
                                        Toggle(isOn: subjectSelection(subject.id)) {
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text(subject.name)
                                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                    .foregroundStyle(Color.universityInk)
                                                Text("\(subject.id)  ·  \(subject.credit) credits")
                                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                                    .foregroundStyle(Color.universityMuted)
                                            }
                                        }
                                        .tint(.universityBlue)

                                        if selectedSubjectIDs.contains(subject.id) {
                                            HStack {
                                                Text("Mark / 100")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    .foregroundStyle(Color.universityMuted)
                                                Spacer()
                                                TextField("Not graded", text: markText(subject.id))
                                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                    .keyboardType(.decimalPad)
                                                    .multilineTextAlignment(.trailing)
                                                    .padding(.horizontal, 11)
                                                    .padding(.vertical, 8)
                                                    .frame(width: 112)
                                                    .background(Color.universityCanvas, in: RoundedRectangle(cornerRadius: 11))
                                            }
                                            .padding(.leading, 4)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                    if subject.id != store.subjects.last?.id {
                                        Divider().overlay(Color.universityLine)
                                    }
                                }
                            }
                        }
                    }
                }

                if section == .teachers {
                    UniversityCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionEyebrow(title: "Subjects this teacher can teach")
                            ForEach(store.subjects) { subject in
                                Toggle(isOn: subjectSelection(subject.id)) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(subject.name)
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.universityInk)
                                        Text("\(subject.id)  ·  \(subject.credit) credits")
                                            .font(.system(size: 11, weight: .medium, design: .rounded))
                                            .foregroundStyle(Color.universityMuted)
                                    }
                                }
                                .tint(.universityTeal)
                            }
                        }
                    }
                }

                Button(action: save) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save changes")
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.universityBlue, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 18)
        }
        .background(Color.universityCanvas.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
                    .fontWeight(.medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .fontWeight(.bold)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadExistingInformation)
        .alert("One quick check", isPresented: Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )) {
            Button("OK", role: .cancel) { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
    }

    private var idHint: String {
        switch section {
        case .students: return "e.g. ST6"
        case .teachers: return "e.g. TCH6"
        case .subjects: return "e.g. SUB6"
        }
    }

    private var nameHint: String {
        switch section {
        case .students: return "Student name"
        case .teachers: return "Teacher name"
        case .subjects: return "Subject name"
        }
    }

    private func subjectSelection(_ subjectID: String) -> Binding<Bool> {
        Binding(
            get: { selectedSubjectIDs.contains(subjectID) },
            set: { isSelected in
                if isSelected {
                    selectedSubjectIDs.insert(subjectID)
                } else {
                    selectedSubjectIDs.remove(subjectID)
                    marksText[subjectID] = nil
                }
            }
        )
    }

    private func markText(_ subjectID: String) -> Binding<String> {
        Binding(
            get: { marksText[subjectID] ?? "" },
            set: { marksText[subjectID] = $0 }
        )
    }

    private func loadExistingInformation() {
        guard !didLoad else { return }
        didLoad = true
        guard let existingID else { return }

        switch section {
        case .students:
            guard let student = store.students.first(where: { $0.studentID == existingID }) else { return }
            identifier = student.studentID
            name = student.name
            gpaText = String(format: "%.1f", student.gpa)
            let records = store.studentSubjects.filter { $0.idStudent == existingID }
            selectedSubjectIDs = Set(records.map(\.idSubject))
            marksText = Dictionary(uniqueKeysWithValues: records.compactMap { record in
                guard let mark = record.mark else { return nil }
                return (record.idSubject, String(format: "%.0f", mark))
            })
        case .teachers:
            guard let teacher = store.teachers.first(where: { $0.id == existingID }) else { return }
            identifier = teacher.id
            name = teacher.name
            className = teacher.className
            selectedSubjectIDs = Set(teacher.subjectIDs)
        case .subjects:
            guard let subject = store.subjects.first(where: { $0.id == existingID }) else { return }
            identifier = subject.id
            name = subject.name
            creditText = String(subject.credit)
        }
    }

    private func save() {
        let cleanID = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanID.isEmpty, !cleanName.isEmpty else {
            alertMessage = "Please fill in both the ID and name."
            return
        }
        if !isEditing && store.identifierExists(section, id: cleanID) {
            alertMessage = "That ID is already in use. Please choose a different ID."
            return
        }

        switch section {
        case .students:
            guard let gpa = Double(gpaText), (0...10).contains(gpa) else {
                alertMessage = "GPA must be a number from 0 to 10."
                return
            }
            var parsedMarks: [String: Double] = [:]
            for subjectID in selectedSubjectIDs {
                let value = marksText[subjectID]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if value.isEmpty { continue }
                guard let mark = Double(value), (0...100).contains(mark) else {
                    alertMessage = "Each mark must be between 0 and 100, or left blank if it has not been graded."
                    return
                }
                parsedMarks[subjectID] = mark
            }
            store.saveStudent(
                Student(studentID: cleanID, name: cleanName, gpa: gpa),
                selectedSubjectIDs: selectedSubjectIDs,
                marks: parsedMarks
            )
        case .teachers:
            store.saveTeacher(Teacher(
                id: cleanID,
                name: cleanName,
                subjectIDs: selectedSubjectIDs.sorted(),
                className: className.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Unassigned" : className
            ))
        case .subjects:
            guard let credits = Int(creditText), credits > 0 else {
                alertMessage = "Credits must be a whole number greater than zero."
                return
            }
            store.saveSubject(Subject(id: cleanID, name: cleanName, credit: credits))
        }
        dismiss()
    }
}

private struct LabeledField: View {
    let title: String
    let hint: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var locked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.universityInk)
                if locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.universityMuted)
                }
            }
            TextField(hint, text: $text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .keyboardType(keyboard)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .disabled(locked)
                .padding(.horizontal, 13)
                .padding(.vertical, 12)
                .background(locked ? Color.universityCanvas : Color.white,
                            in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.universityLine, lineWidth: 1)
                }
                .foregroundStyle(locked ? Color.universityMuted : Color.universityInk)
        }
    }
}
