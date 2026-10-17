import SwiftUI

extension Color {
    static let universityInk = Color(red: 0.11, green: 0.17, blue: 0.28)
    static let universityMuted = Color(red: 0.42, green: 0.47, blue: 0.56)
    static let universityCanvas = Color(red: 0.96, green: 0.97, blue: 0.99)
    static let universityBlue = Color(red: 0.20, green: 0.43, blue: 0.91)
    static let universityBlueSoft = Color(red: 0.90, green: 0.94, blue: 1.00)
    static let universityTeal = Color(red: 0.11, green: 0.58, blue: 0.53)
    static let universityTealSoft = Color(red: 0.88, green: 0.97, blue: 0.94)
    static let universityOrange = Color(red: 0.93, green: 0.55, blue: 0.23)
    static let universityOrangeSoft = Color(red: 1.00, green: 0.94, blue: 0.87)
    static let universityRed = Color(red: 0.84, green: 0.28, blue: 0.33)
    static let universityRedSoft = Color(red: 1.00, green: 0.91, blue: 0.92)
    static let universityCard = Color.white
    static let universityLine = Color(red: 0.89, green: 0.91, blue: 0.94)
}

struct UniversityCard<Content: View>: View {
    var padding: CGFloat = 18
    let content: Content

    init(padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.universityCard)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.universityLine.opacity(0.8), lineWidth: 1)
            }
            .shadow(color: Color.universityInk.opacity(0.035), radius: 12, x: 0, y: 5)
    }
}

struct SectionEyebrow: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .tracking(1.2)
            .foregroundStyle(Color.universityMuted)
    }
}

struct TagPill: View {
    let text: String
    var tint: Color = .universityBlue
    var background: Color = .universityBlueSoft

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(background, in: Capsule())
    }
}
