import SwiftUI

struct ContentView: View {
    let studentName = "Amacdialo"
    let studentID = "HEHEIU18367"
    var age = 24
    var gpa = 12.345678
    var isStudent: Bool = true
    var body: some View {
        VStack(spacing: 12) {
            Text("Student Profile").font(.largeTitle).bold()
            Text("Name: \(studentName)").font(.title)
            Text("Student ID: \(studentID)").font(.title)
            Text("Age: \(age)").font(.title)
            Text("GPA: \(gpa)").font(.title)
            Text("Student: \(isStudent ? "Yes" : "No")").font(.title)
        }
    }
}
