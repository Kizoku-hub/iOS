import SwiftUI

struct ClassCatalogView: View {
    @EnvironmentObject private var store: UniversityStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("University")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.universityInk)
                    Text("Your semester, all in one place.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                }
                .padding(.top, 18)

                VStack(alignment: .leading, spacing: 13) {
                    SectionEyebrow(title: "Information")
                    ForEach(DirectorySection.allCases) { section in
                        NavigationLink {
                            ClassListView(section: section)
                        } label: {
                            ClassCategoryCard(
                                section: section,
                                count: count(for: section)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.universityOrange)
                    Text("Tip: open a student to edit their semester subjects and marks.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityMuted)
                }
                .padding(.horizontal, 3)
                .padding(.bottom, 14)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.universityCanvas)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func count(for section: DirectorySection) -> Int {
        switch section {
        case .students: return store.students.count
        case .teachers: return store.teachers.count
        case .subjects: return store.subjects.count
        }
    }
}

private struct ClassCategoryCard: View {
    let section: DirectorySection
    let count: Int

    private var accent: Color {
        switch section {
        case .students: return .universityBlue
        case .teachers: return .universityTeal
        case .subjects: return .universityOrange
        }
    }

    private var accentSoft: Color {
        switch section {
        case .students: return .universityBlueSoft
        case .teachers: return .universityTealSoft
        case .subjects: return .universityOrangeSoft
        }
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: section.symbol)
                .font(.system(size: 23, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 58, height: 58)
                .background(accentSoft, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(section.title)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.universityInk)
                Text(section.subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.universityMuted)
                    .fixedSize(horizontal: false, vertical: true)
                Text("\(count) items")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(accent)
                    .padding(.top, 3)
            }
            Spacer(minLength: 4)
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.universityMuted.opacity(0.8))
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 23, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 23, style: .continuous)
                .stroke(Color.universityLine, lineWidth: 1)
        }
        .shadow(color: Color.universityInk.opacity(0.035), radius: 12, x: 0, y: 5)
    }
}
