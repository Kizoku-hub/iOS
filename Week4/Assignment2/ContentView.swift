import SwiftUI

struct ContentView: View {
    @StateObject private var store = UniversityStore()
    @State private var selectedTab: UniversityTab = .information

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .information:
                        ClassCatalogView()
                    case .statistics:
                        StatisticsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                UniversityTabBar(selectedTab: $selectedTab)
            }
            .background(Color.universityCanvas.ignoresSafeArea())
        }
        .environmentObject(store)
        .tint(.universityBlue)
    }
}
