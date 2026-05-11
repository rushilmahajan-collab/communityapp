import SwiftUI
import MapKit

struct GroupDetailView: View {
  let group: Group
  @State private var showJoinRequest = false
  @State private var isMember = false

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        VStack(alignment: .leading, spacing: 16) {
          Text(group.name)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.gray900)

          if let description = group.description {
            Text(description)
              .font(.system(size: 16, weight: .regular))
              .foregroundColor(.gray700)
              .lineLimit(nil)
          }

          HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
              Text("Meeting")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray600)

              Text("\(group.meetingDay) at \(group.meetingTime)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray900)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
              Text("Members")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray600)

              Text("\(group.memberCount)/\(group.maxMembers)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray900)
            }
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(Color.gray50)
          .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)

        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
              .font(.system(size: 20))
              .foregroundColor(.earth)

            VStack(alignment: .leading, spacing: 4) {
              Text(group.meetingLocationName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray900)

              Text(group.meetingLocationAddress)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray600)
            }

            Spacer()
          }
        }
        .padding(.horizontal, 20)

        MapContainer()
          .frame(height: 200)
          .cornerRadius(12)
          .padding(.horizontal, 20)

        VStack(alignment: .leading, spacing: 12) {
          Text("Members")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.gray900)

          if let members = group.members, !members.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 12) {
                ForEach(members) { member in
                  VStack(spacing: 8) {
                    Circle()
                      .fill(Color.earth.opacity(0.1))
                      .frame(width: 60, height: 60)
                      .overlay(
                        Image(systemName: "person.fill")
                          .font(.system(size: 24))
                          .foregroundColor(.earth)
                      )

                    Text(member.firstName)
                      .font(.system(size: 12, weight: .semibold))
                      .foregroundColor(.gray900)
                  }
                }
              }
            }
          }
        }
        .padding(.horizontal, 20)

        if !isMember {
          Button(action: { showJoinRequest = true }) {
            Text("Request to Join")
              .font(.system(size: 16, weight: .semibold))
              .frame(maxWidth: .infinity)
              .padding(.vertical, 14)
              .background(Color.earth)
              .foregroundColor(.white)
              .cornerRadius(12)
          }
          .padding(.horizontal, 20)
        } else {
          NavigationLink(destination: GroupChatView(groupId: group.id)) {
            Text("Group Chat")
              .font(.system(size: 16, weight: .semibold))
              .frame(maxWidth: .infinity)
              .padding(.vertical, 14)
              .background(Color.earth)
              .foregroundColor(.white)
              .cornerRadius(12)
          }
          .padding(.horizontal, 20)
        }

        Spacer()
      }
    }
    .navigationTitle("Group")
    .navigationBarTitleDisplayMode(.inline)
    .alert("Join Request Sent", isPresented: $showJoinRequest) {
      Button("OK") { }
    } message: {
      Text("The group admin will review your request soon.")
    }
  }
}

struct MapContainer: View {
  var body: some View {
    ZStack {
      Color.gray100

      VStack {
        Spacer()

        HStack(spacing: 8) {
          Image(systemName: "mappin.circle.fill")
            .font(.system(size: 16))
            .foregroundColor(.earth)

          Text("Open in Maps")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.earth)
        }

        Spacer()
      }
    }
  }
}

#Preview {
  NavigationStack {
    GroupDetailView(
      group: Group(
        id: UUID().uuidString,
        name: "Downtown Coffee Crew",
        description: "Weekly morning coffee and real conversation",
        city: "Denver",
        neighborhood: "Downtown",
        latitude: 39.7392,
        longitude: -104.9903,
        meetingDay: "Thursday",
        meetingTime: "6:00 PM",
        meetingLocationName: "Corvus Coffee",
        meetingLocationAddress: "123 Main St",
        maxMembers: 8,
        isOpen: true,
        createdBy: UUID().uuidString,
        createdAt: Date().ISO8601Format()
      )
    )
  }
}
