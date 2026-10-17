# University — SwiftUI student and semester manager

A small, card-based iOS practice app inspired by the simple list/result UI in the supplied iOS programming slides. It is deliberately kept approachable rather than adding production-style complexity.

## Screens

- **Information** — the University home screen has wide, single-column cards for Students, Teachers, and Subjects.
- **Class list** — tap a card to browse its objects. Student cards show the student ID, GPA, and “Learning subjects”. Teacher cards show their class and the subjects they can teach.
- **Edit / Add** — edit names and data, assign a student's semester subjects, and enter each subject mark. IDs are locked on edit; an ID is entered only when creating a new object.
- **Statistics** — choose the Student target and one condition: GPA, Passed, or Failed. GPA supports Above / Below / Equal and a value. The search runs only when **OK · Show results** is tapped. Passed/Failed results are grouped into subject cards with student names.

## Data model

- `Student`: `name`, immutable `studentID`, and `gpa`.
- `Teacher`: `name`, immutable `id`, `subjectIDs` (the subjects the teacher can teach), and `className`.
- `Subject`: `name`, immutable `id`, and `credit`.
- `StudentSubject`: immutable `idStudent`, immutable `idSubject`, and optional `mark`.

The `StudentSubject` model is intentionally not a separate home card. Each student starts with three enrolled subjects in the sample data, so the student's enrollment list is the main place to work with those links.

## Sample assumptions

- There are five sample students, teachers, and subjects, plus three subject enrollments for each sample student.
- GPA uses a **0–10** scale, because the requested GPA filter example is “above 8”.
- Subject marks use a **0–100** scale. Marks **50 or higher pass**; marks below 50 fail. An unentered mark is neither counted as passed nor failed.
- The sample data is static practice data. It does not generate random records or save data after the app is closed.

## Run in Xcode

1. Open `University.xcodeproj` on a Mac with Xcode.
2. Select the **University** app target and an iOS Simulator (iOS 16 or newer).
3. Press **Run**.

No third-party packages are used. The project is organized into small Swift files so each main screen and flow is easy to find.

## Files

- `UniversityApp.swift` — app entry point.
- `Models.swift` — `Student`, `Teacher`, `Subject`, `StudentSubject`, filter types.
- `UniversityStore.swift` — editable sample data and related lookup/update methods.
- `ContentView.swift` — main screen switch and overall alignment.
- `ClassCatalogView.swift` — University home screen and class cards.
- `ClassListView.swift` — list screen for Students, Teachers, or Subjects.
- `EditInformationView.swift` — shared add/edit form; identifiers cannot be edited after creation.
- `StatisticsView.swift` — statistics screen shell.
- `StatisticsFilterView.swift` — target/condition filter and explicit OK action.
- `StatisticsResultView.swift` — GPA, passed, and failed results.
- `UniversityTabBar.swift` — bottom Information / Statistics selector.
- `Theme.swift` — colors and card styles.
- `Mockups/` — UI preview images generated to match the app layout.
