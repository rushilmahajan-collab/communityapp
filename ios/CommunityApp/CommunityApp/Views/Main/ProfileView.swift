import SwiftUI

struct ProfileView: View {
  @EnvironmentObject var authManager: AuthManager

  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        VStack(spacing: 16) {
          Circle()
            .fill(Color.earth.opacity(0.1))
            .frame(width: 80, height: 80)
            .overlay(
              Image(systemName: "person.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.earth)
            )

          VStack(spacing: 4) {
            Text(authManager.currentUser?.firstName ?? "")
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(.gray900)

            Text(authManager.currentUser?.city ?? "")
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.gray600)
          }
        }

        VStack(spacing: 12) {
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text("Verification Status")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray600)

              HStack(spacing: 6) {
                Circle()
                  .fill(
                    authManager.currentUser?.verificationStatus == .verified
                      ? Color.green
                      : Color.yellow
                  )
                  .frame(width: 8, height: 8)

                Text(
                  authManager.currentUser?.verificationStatus.rawValue.capitalized ?? "Pending"
                )
                  .font(.system(size: 14, weight: .medium))
                  .foregroundColor(.gray900)
              }
            }

            Spacer()
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(Color.gray50)
          .cornerRadius(8)
        }

        VStack(spacing: 12) {
          NavigationLink(destination: EditProfileView()) {
            HStack {
              Text("Edit Profile")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.earth)

              Spacer()

              Image(systemName: "chevron.right")
                .foregroundColor(.gray400)
            }
          }

          Divider()
            .padding(.horizontal, 0)

          Button(action: {
            authManager.logout()
          }) {
            HStack {
              Text("Sign Out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)

              Spacer()

              Image(systemName: "chevron.right")
                .foregroundColor(.gray400)
            }
          }
        }

        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 24)
      .navigationTitle("Profile")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  ProfileView()
    .environmentObject(AuthManager())
}
