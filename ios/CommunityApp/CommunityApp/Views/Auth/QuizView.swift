import SwiftUI

struct QuizView: View {
  @EnvironmentObject var authManager: AuthManager
  let firstName: String
  let email: String
  let password: String
  let city: String

  @State private var currentQuestion = 0
  @State private var selectedAnswers: [Int: String] = [:]
  @State private var isLoading = false

  let questions = [
    ("What brought you here?", [
      "I'm new to the city and need my people",
      "I have friends but want a deeper community",
      "I'm tired of surface-level friendships",
      "I just want to get off my couch and do something real"
    ]),
    ("What does your social life look like right now?", [
      "Pretty empty — I'm starting from scratch",
      "I have people but something's missing",
      "It's good but I want more",
      "I mostly hang out alone and I'm ready to change that"
    ]),
    ("What kind of group sounds like home to you?", [
      "Active — hiking, sports, outdoor stuff",
      "Chill — dinners, coffee, good conversations",
      "Growth-focused — goals, accountability, pushing each other",
      "A mix of everything"
    ]),
    ("What matters most in a friend?", [
      "They show up when it counts",
      "They keep it real, no fake stuff",
      "They're fun to be around",
      "They challenge me to be better"
    ]),
    ("How often do you want to meet up?", [
      "Every week",
      "Every other week",
      "A couple times a month",
      "I'm flexible"
    ]),
    ("What time works best for you?", [
      "Weekday mornings",
      "Weekday evenings",
      "Weekends",
      "I'm flexible"
    ]),
    ("What's your vibe?", [
      "Laid back and go with the flow",
      "High energy and always down for something",
      "Quiet but intentional",
      "Depends on the day honestly"
    ]),
    ("What are you hoping to find here?", [
      "A tight group of real friends",
      "People to do life with",
      "A sense of belonging",
      "All of the above"
    ]),
    ("How do you feel about meeting new people?", [
      "I love it, I'm an open book",
      "A little nervous but I'm ready",
      "It takes me a minute to open up",
      "Honestly terrified but I'm here anyway"
    ]),
    ("Are you ready to show up?", [
      "All in, let's go",
      "Nervous but committed",
      "I need a little push",
      "Just looking around for now"
    ])
  ]

  var body: some View {
    VStack(spacing: 24) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Question \(currentQuestion + 1) of \(questions.count)")
          .font(.system(size: 12, weight: .semibold))
          .foregroundColor(.gray600)
          .textCase(.uppercase)

        Text(questions[currentQuestion].0)
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.gray900)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 12) {
        ForEach(0..<questions[currentQuestion].1.count, id: \.self) { index in
          Button(action: {
            selectedAnswers[currentQuestion] = questions[currentQuestion].1[index]
          }) {
            HStack {
              VStack(alignment: .leading, spacing: 4) {
                Text(questions[currentQuestion].1[index])
                  .font(.system(size: 15, weight: .regular))
                  .foregroundColor(.gray900)
                  .lineLimit(nil)
                  .multilineTextAlignment(.leading)
              }
              Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(selectedAnswers[currentQuestion] == questions[currentQuestion].1[index] ? Color.earth.opacity(0.1) : Color.white)
            .border(selectedAnswers[currentQuestion] == questions[currentQuestion].1[index] ? Color.earth : Color.gray200, width: 1)
            .cornerRadius(8)
          }
        }
      }

      Spacer()

      HStack(spacing: 12) {
        if currentQuestion > 0 {
          Button(action: { currentQuestion -= 1 }) {
            Text("Back")
              .font(.system(size: 16, weight: .semibold))
              .frame(maxWidth: .infinity)
              .padding(.vertical, 14)
              .background(Color.white)
              .foregroundColor(.earth)
              .cornerRadius(12)
              .border(Color.earth, width: 1)
          }
        }

        Button(action: {
          if currentQuestion < questions.count - 1 {
            currentQuestion += 1
          } else {
            submitQuiz()
          }
        }) {
          Text(currentQuestion == questions.count - 1 ? "Complete" : "Next")
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.earth)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(selectedAnswers[currentQuestion] == nil || isLoading)
        .opacity((selectedAnswers[currentQuestion] == nil || isLoading) ? 0.5 : 1.0)
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 40)
  }

  private func submitQuiz() {
    isLoading = true

    Task {
      await authManager.register(
        firstName: firstName,
        email: email,
        password: password,
        city: city
      )

      if authManager.isLoggedIn {
        // Save quiz responses
        let responses = selectedAnswers
        await authManager.saveQuizResponses(responses)
      }

      isLoading = false
    }
  }
}

#Preview {
  NavigationStack {
    QuizView(firstName: "John", email: "john@example.com", password: "password", city: "Denver")
      .environmentObject(AuthManager())
  }
}
