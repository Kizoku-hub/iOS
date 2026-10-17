import SwiftUI

struct StatisticsView: View {
    @State private var submittedQuery: StatisticsQuery?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                StatisticsFilterView { query in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        submittedQuery = query
                    }
                }
                if let submittedQuery {
                    StatisticsResultView(query: submittedQuery)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    UniversityCard {
                        HStack(spacing: 13) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.universityBlue)
                                .frame(width: 49, height: 49)
                                .background(Color.universityBlueSoft, in: RoundedRectangle(cornerRadius: 16))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Your results will show here")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.universityInk)
                                Text("Choose a condition above, then tap OK to search.")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.universityMuted)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
            .padding(.bottom, 22)
        }
        .background(Color.universityCanvas)
        .toolbar(.hidden, for: .navigationBar)
    }
}
