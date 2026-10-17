import SwiftUI

struct StatisticsFilterView: View {
    let onSearch: (StatisticsQuery) -> Void

    @State private var target = "Students"
    @State private var condition: StatisticCondition = .gpa
    @State private var comparison: GPAComparison = .above
    @State private var thresholdText = "8"
    @State private var validationMessage: String?

    var body: some View {
        UniversityCard(padding: 20) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top, spacing: 11) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.universityBlue)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Find your results")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.universityInk)
                        Text("Pick one target and one condition.")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.universityMuted)
                    }
                }

                VStack(alignment: .leading, spacing: 9) {
                    SectionEyebrow(title: "Target")
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(Color.universityBlue)
                        Text(target)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.universityInk)
                        Spacer()
                        TagPill(text: "Only target for now", tint: .universityMuted, background: Color.universityCanvas)
                    }
                    .padding(13)
                    .background(Color.universityCanvas, in: RoundedRectangle(cornerRadius: 14))
                }

                VStack(alignment: .leading, spacing: 9) {
                    SectionEyebrow(title: "Condition")
                    HStack(spacing: 7) {
                        ForEach(StatisticCondition.allCases) { item in
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) { condition = item }
                            } label: {
                                Text(item.rawValue)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundStyle(condition == item ? .white : Color.universityMuted)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(condition == item ? Color.universityBlue : Color.universityCanvas,
                                                in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if condition == .gpa {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionEyebrow(title: "GPA rule")
                        HStack(spacing: 8) {
                            ForEach(GPAComparison.allCases) { item in
                                Button {
                                    comparison = item
                                } label: {
                                    Text(item.rawValue)
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundStyle(comparison == item ? Color.universityBlue : Color.universityMuted)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 11)
                                        .background(comparison == item ? Color.universityBlueSoft : Color.universityCanvas,
                                                    in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 11, style: .continuous)
                                                .stroke(comparison == item ? Color.universityBlue.opacity(0.25) : Color.clear, lineWidth: 1)
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("GPA value")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.universityMuted)
                                Text("Use a value from 0 to 10")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.universityMuted.opacity(0.9))
                            }
                            Spacer()
                            TextField("8", text: $thresholdText)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .frame(width: 84)
                                .padding(.vertical, 11)
                                .background(Color.universityCanvas, in: RoundedRectangle(cornerRadius: 13))
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: condition == .passed ? "checkmark.seal.fill" : "exclamationmark.circle.fill")
                            .foregroundStyle(condition == .passed ? Color.universityTeal : Color.universityRed)
                        Text("The result will group students by subject, so you can see who passed or failed each one.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.universityMuted)
                    }
                    .padding(12)
                    .background(Color.universityCanvas, in: RoundedRectangle(cornerRadius: 13))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if let validationMessage {
                    Text(validationMessage)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.universityRed)
                }

                Button(action: search) {
                    HStack(spacing: 9) {
                        Image(systemName: "magnifyingglass")
                        Text("OK · Show results")
                    }
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.universityInk, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func search() {
        guard condition == .passed || condition == .failed else {
            guard let value = Double(thresholdText), (0...10).contains(value) else {
                validationMessage = "Enter a GPA value from 0 to 10."
                return
            }
            validationMessage = nil
            onSearch(StatisticsQuery(condition: .gpa, comparison: comparison, threshold: value))
            return
        }
        validationMessage = nil
        onSearch(StatisticsQuery(condition: condition, comparison: comparison, threshold: 0))
    }
}
