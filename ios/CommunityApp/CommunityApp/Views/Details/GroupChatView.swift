import SwiftUI

struct GroupChatView: View {
  let groupId: String
  @State private var messages: [GroupMessage] = []
  @State private var newMessage = ""

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          Text("Keep it short. Save the real talk for in-person.")
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.gray600)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray50)
            .cornerRadius(8)

          ForEach(messages) { message in
            HStack(alignment: .top, spacing: 10) {
              Circle()
                .fill(Color.earth.opacity(0.1))
                .frame(width: 32, height: 32)
                .overlay(
                  Image(systemName: "person.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.earth)
                )

              VStack(alignment: .leading, spacing: 4) {
                Text(message.firstName)
                  .font(.system(size: 13, weight: .semibold))
                  .foregroundColor(.gray900)

                Text(message.messageText)
                  .font(.system(size: 14, weight: .regular))
                  .foregroundColor(.gray800)

                Text("2m ago")
                  .font(.system(size: 12, weight: .regular))
                  .foregroundColor(.gray500)
              }

              Spacer()
            }
            .padding(.horizontal, 16)
          }

          Spacer()
        }
        .padding(.vertical, 12)
      }

      Divider()

      HStack(spacing: 8) {
        TextField("Message", text: $newMessage)
          .font(.system(size: 14, weight: .regular))
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
          .background(Color.gray100)
          .cornerRadius(8)

        Button(action: {
          if !newMessage.isEmpty {
            newMessage = ""
          }
        }) {
          Image(systemName: "paperplane.fill")
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.earth)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .navigationTitle("Group Chat")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    GroupChatView(groupId: UUID().uuidString)
  }
}
