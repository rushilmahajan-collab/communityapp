import SwiftUI

struct MyGroupsView: View {
  @State private var groups: [Group] = []

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        Text("My Groups")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.gray900)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 20)
          .padding(.vertical, 16)

        if groups.isEmpty {
          VStack(spacing: 16) {
            Image(systemName: "person.3")
              .font(.system(size: 40))
              .foregroundColor(.gray400)

            Text("You haven't joined any groups yet")
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.gray900)

            Text("Explore to find groups or start your own"
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.gray600)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          ScrollView {
            VStack(spacing: 12) {
              ForEach(groups) { group in
                NavigationLink(destination: GroupDetailView(group: group)) {
                  GroupCard(group: group)
                }
              }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
          }
        }
      }
      .background(Color.white)
    }
  }
}

#Preview {
  MyGroupsView()
}
