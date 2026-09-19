import SwiftUI

struct ContentView: View {
  let studentName = "Tran Trung Kien"
  let studentID = "SESEIU24014"
  var age = 24
  var gpa = 36.67
  let isStudent = true
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [
          Color.blue.opacity(0.15),
          Color.white,
          Color.green.opacity(0.15)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      VStack {
        ZStack {
          Circle()
            .fill(Color.white.opacity(0.8))
            .frame(width: 130, height: 130)
          Image(systemName: "graduationcap.fill")
            .font(.system(size: 65))
            .foregroundStyle(.blue)
          }
          .padding(.top, 20)
      
        VStack(spacing: 12) {
          Text("🎓").font(.system(size: 60))
          Text("Student Profile")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.blue)
          StudentRow(
            icon: "person.fill",
            title: "Name",
            value: studentName
          )
          StudentRow(
            icon: "person.text.rectangle.fill",
            title: "Student ID",
            value: studentID
          )
          StudentRow(
            icon: "calendar",
            title: "Age",
            value: "\(age)"
          )
          StudentRow(
            icon: "chart.bar.fill",
            title: "GPA",
            value: String(format: "%.2f", gpa
          )
          StudentRow(
            icon: "checkmark.circle.fill",
            title: "Student",
            value: isStudent.description,
            valueColor: Color.green
          )
        }
        .padding(25)
        .background(
          Color.white.opacity(0.9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(
          color: .black.opacity(0.1),
          radius: 15,
          y: 8
        )
        .padding(.horizontal, 25)
        Spacer()
      }
    }
  }
}
