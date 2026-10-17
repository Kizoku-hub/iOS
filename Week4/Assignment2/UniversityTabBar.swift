import SwiftUI

struct UniversityTabBar: View {
    @Binding var selectedTab: UniversityTab

    var body: some View {
        HStack(spacing: 10) {
            ForEach(UniversityTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selectedTab = tab }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.symbol)
                            .font(.system(size: 15, weight: .semibold))
                        Text(tab.title)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(selectedTab == tab ? Color.white : Color.universityMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color.universityBlue)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.universityLine, lineWidth: 1)
        }
        .shadow(color: Color.universityInk.opacity(0.06), radius: 14, x: 0, y: -3)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color.universityCanvas)
    }
}
