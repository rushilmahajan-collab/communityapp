import SwiftUI

struct EditProfileView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var authManager: AuthManager
  @State private var neighborhood = ""
  @State private var city = ""

  var body: some View {
    NavigationStack {
      Form {
        Section("Personal") {
          HStack {
            Text("First Name")
            Spacer()
            Text(authManager.currentUser?.firstName ?? "")
              .foregroundColor(.gray600)
          }

          HStack {
            Text("City")
            Spacer()
            Text(authManager.currentUser?.city ?? "")
              .foregroundColor(.gray600)
          }
        }

        Section("Neighborhood") {
          TextField("Neighborhood (optional)", text: $neighborhood)
        }

        Section {
          Button(action: {
            dismiss()
          }) {
            Text("Save Changes")
              .frame(maxWidth: .infinity)
              .foregroundColor(.white)
          }
          .listRowBackground(Color.earth)
        }
      }
      .navigationTitle("Edit Profile")
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
  EditProfileView()
    .environmentObject(AuthManager())
}
