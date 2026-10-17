import SwiftUI

struct ClassListView: View {
    let section: DirectorySection
    @EnvironmentObject private var store: UniversityStore
    @State private var showingAddSheet = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(section.title)
                            .font(.system(size: 29, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.universityInk)
                        Text(section.subtitle)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.universityMuted)
                    }
                    Spacer()
                    TagPill(text: "\(count) total", tint: .universityBlue)
                }
                .padding(.top, 10)
                .padding(.bottom, 3)

                switch section {
                case .students:
                    ForEach(store.students) { student in
                        NavigationLink {
                            EditInformationView(section: .students, existingID: student.studentID)
                        } label: {
                            StudentListCard(student: student)
                        }
                        .buttonStyle(.plain)
                    }
                case .teachers:
                    ForEach(store.teachers) { teacher in
                        NavigationLink {
                            EditInformationView(section: .teachers, existingID: teacher.id)
                        } label: {
                            TeacherListCard(teacher: teacher)
                        }
                        .buttonStyle(.plain)
                    }
                case .subjects:
                    ForEach(store.subjects) { subject in
                        NavigationLink {
                            EditInformationView(section: .subjects, existingID: subject.id)
                        } label: {
                            SubjectListCard(subject: subject)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 22)
        }
        .background(Color.universityCanvas)
        .navigationTitle(section.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAddSheet = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.universityBlue)
                }
                .accessibilityLabel("Add \(section.title.dropLast())")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                EditInformationView(section: section, existingID: nil)
            }
            .environmentObject(store)
            .presentationDetents([.large])
        }
    }

    private var count: Int {
        switch section {
        case .students: return store.students.count
        case .teachers: return store.teachers.count
        case .subjects: return store.subjects.count
        }
    }
}

private struct StudentListCard: View {
    @EnvironmentObject private var store: UniversityStore
    let student: Student

    var body: some View {
        UniversityCard(padding: 16) {
            HStack(alignment: .top, spacing: 13) {
                ZStack {
                    RoundedRectangle(cornerRadius: 17, style: .continuous).fill(Color.universityBlueSoft)
                    Text(initials(student.name))
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.universityBlue)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 8) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(student.name)
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.universityInk)
                            Text(student.studentID)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.universityMuted)
                        }
                        Spacer(minLength: 4)
                        TagPill(text: String(format: "GPA %.1f", student.gpa),
                                tint: student.gpa >= 8 ? .universityTeal : .universityOrange,
                                background: student.gpa >= 8 ? .universityTealSoft : .universityOrangeSoft)
                    }
                    let names = store.learningSubjects(for: student.studentID).map(\.name)
                    Text("Learning subjects: \(names.isEmpty ? "Not assigned yet" : names.joined(separator: ", "))")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.universityMuted.opacity(0.7))
                    .padding(.top, 5)
            }
        }
    }

    private func initials(_ name: String) -> String {
        name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
    }
}

private struct TeacherListCard: View {
    @EnvironmentObject private var store: UniversityStore
    let teacher: Teacher

    var body: some View {
        UniversityCard(padding: 16) {
            HStack(alignment: .top, spacing: 13) {
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.universityTeal)
                    .frame(width: 52, height: 52)
                    .background(Color.universityTealSoft, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                VStack(alignment: .leading, spacing: 6) {
                    Text(teacher.name)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.universityInk)
                    Text("\(teacher.id)  ·  \(teacher.className)")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                    Text("Can teach: \(teacher.subjectIDs.map { store.subjectName(for: $0) }.joined(separator: ", "))")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.universityMuted.opacity(0.7))
                    .padding(.top, 5)
            }
        }
    }
}

private struct SubjectListCard: View {
    let subject: Subject

    var body: some View {
        UniversityCard(padding: 16) {
            HStack(spacing: 13) {
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(Color.universityOrange)
                    .frame(width: 52, height: 52)
                    .background(Color.universityOrangeSoft, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                VStack(alignment: .leading, spacing: 5) {
                    Text(subject.name)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.universityInk)
                    Text(subject.id)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                }
                Spacer()
                TagPill(text: "\(subject.credit) credits", tint: .universityOrange, background: .universityOrangeSoft)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.universityMuted.opacity(0.7))
            }
        }
    }
}
