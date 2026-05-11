import SwiftUI

struct CreateGroupView: View {
  @Environment(\.dismiss) var dismiss
  @State private var name = ""
  @State private var description = ""
  @State private var meetingDay = "Monday"
  @State private var meetingTime = "6:00 PM"
  @State private var location = ""
  @State private var address = ""
  @State private var maxMembers = 8

  let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  var body: some View {
    NavigationStack {
      Form {
        Section("Group Details") {
          TextField("Group name", text: $name)
          TextField("Description", text: $description, axis: .vertical)
            .lineLimit(3, reservesSpace: true)
        }

        Section("Meeting Details") {
          Picker("Day", selection: $meetingDay) {
            ForEach(days, id: \.self) { day in
              Text(day).tag(day)
            }
          }

          TextField("Time", text: $meetingTime)
        }

        Section("Location") {
          TextField("Location name (e.g., Corvus Coffee)", text: $location)
          TextField("Address", text: $address)
        }

        Section("Max Members") {
          Stepper(
            "Up to \(maxMembers) people",
            value: $maxMembers,
            in: 3...20
          )
        }

        Section {
          Button(action: {
            dismiss()
          }) {
            Text("Create Group")
              .frame(maxWidth: .infinity)
              .foregroundColor(.white)
          }
          .listRowBackground(Color.earth)
        }
      }
      .navigationTitle("Create Group")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  CreateGroupView()
}
