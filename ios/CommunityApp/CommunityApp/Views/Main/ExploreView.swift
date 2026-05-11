import SwiftUI
import MapKit

struct ExploreView: View {
  @StateObject private var viewModel = ExploreViewModel()
  @State private var showMapList = false

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        HStack {
          Text("Find Groups")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.gray900)

          Spacer()

          Button(action: { showMapList.toggle() }) {
            Image(systemName: showMapList ? "list.bullet" : "map")
              .font(.system(size: 18, weight: .semibold))
              .foregroundColor(.earth)
          }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)

        if showMapList {
          groupListView
        } else {
          groupMapView
        }
      }
      .background(Color.white)
    }
  }

  @ViewBuilder
  private var groupMapView: some View {
    ZStack(alignment: .bottomTrailing) {
      Map()
        .ignoresSafeArea()

      VStack(spacing: 12) {
        Spacer()

        NavigationLink(destination: CreateGroupView()) {
          HStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 16, weight: .semibold))

            Text("Start a Group")
              .font(.system(size: 14, weight: .semibold))
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 12)
          .background(Color.earth)
          .foregroundColor(.white)
          .cornerRadius(12)
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 20)
    }
  }

  @ViewBuilder
  private var groupListView: some View {
    ScrollView {
      VStack(spacing: 12) {
        if viewModel.groups.isEmpty {
          VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
              .font(.system(size: 40))
              .foregroundColor(.gray400)

            Text("No groups found nearby")
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.gray900)

            Text("Start exploring or create your own group")
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.gray600)
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 40)
        } else {
          ForEach(viewModel.groups) { group in
            NavigationLink(destination: GroupDetailView(group: group)) {
              GroupCard(group: group)
            }
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
    }
  }
}

struct GroupCard: View {
  let group: Group

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(group.name)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.gray900)

          HStack(spacing: 4) {
            Image(systemName: "person.3.fill")
              .font(.system(size: 12))
              .foregroundColor(.gray600)

            Text("\(group.memberCount)/\(group.maxMembers)")
              .font(.system(size: 13, weight: .medium))
              .foregroundColor(.gray600)
          }
        }

        Spacer()

        VStack(alignment: .trailing, spacing: 4) {
          Text(group.meetingDay)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.earth)

          Text(group.meetingTime)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.gray700)
        }
      }

      Text(group.meetingLocationName)
        .font(.system(size: 13, weight: .regular))
        .foregroundColor(.gray600)

      Divider()
        .padding(.vertical, 8)

      HStack(spacing: 6) {
        Image(systemName: "mappin.circle.fill")
          .font(.system(size: 12))
          .foregroundColor(.earth)

        Text("~2.3 mi away")
          .font(.system(size: 12, weight: .regular))
          .foregroundColor(.gray600)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(Color.gray50)
    .cornerRadius(12)
  }
}

@MainActor
class ExploreViewModel: ObservableObject {
  @Published var groups: [Group] = []
  @Published var isLoading = false

  init() {
    loadNearbyGroups()
  }

  func loadNearbyGroups() {
    self.groups = [
      Group(
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
        createdAt: Date().ISO8601Format(),
        memberCount: 5
      ),
    ]
  }
}

#Preview {
  ExploreView()
}
