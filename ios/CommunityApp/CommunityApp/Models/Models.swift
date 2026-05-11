import Foundation

struct User: Identifiable, Codable {
  let id: String
  let firstName: String
  let email: String
  let city: String
  var neighborhood: String?
  var profilePhotoURL: String?
  var latitude: Double = 0
  var longitude: Double = 0
  var quizResponses: [String: Any]?
}

struct Group: Identifiable, Codable {
  let id: String
  let name: String
  let description: String?
  let city: String
  let neighborhood: String?
  let latitude: Double
  let longitude: Double
  let meetingDay: String
  let meetingTime: String
  let meetingLocationName: String
  let meetingLocationAddress: String
  let maxMembers: Int
  let isOpen: Bool
  let createdBy: String
  let createdAt: String
  var members: [Member]?
  var memberCount: Int = 0
}

struct Member: Identifiable, Codable {
  let id: String
  let firstName: String
  let profilePhotoURL: String?
}

struct Hangout: Identifiable, Codable {
  let id: String
  let groupId: String
  let date: String
  let time: String
  let locationName: String
  let locationAddress: String
  let suggestedPrompts: [String]?
  let status: String
}

struct GroupMessage: Identifiable, Codable {
  let id: String
  let messageText: String
  let sentAt: String
  let firstName: String
  let profilePhotoURL: String?
}

struct CheckIn: Codable {
  let id: String
  let hangoutId: String
  let userId: String
  let attended: Bool
  let reflection: String?
}

struct QuizQuestion {
  let number: Int
  let text: String
  let type: QuestionType

  enum QuestionType {
    case textOrVoice
    case multipleChoice([String])
    case yesNo
    case frequency
    case timeOfDay
  }
}

let quizQuestions = [
  QuizQuestion(
    number: 1,
    text: "What brought you here?",
    type: .multipleChoice(["I'm new to the city and need my people", "I have friends but want a deeper community", "I'm tired of surface-level friendships", "I just want to get off my couch and do something real"])
  ),
  QuizQuestion(
    number: 2,
    text: "What does your social life look like right now?",
    type: .multipleChoice(["Pretty empty — I'm starting from scratch", "I have people but something's missing", "It's good but I want more", "I mostly hang out alone and I'm ready to change that"])
  ),
  QuizQuestion(
    number: 3,
    text: "What kind of group sounds like home to you?",
    type: .multipleChoice(["Active — hiking, sports, outdoor stuff", "Chill — dinners, coffee, good conversations", "Growth-focused — goals, accountability, pushing each other", "A mix of everything"])
  ),
  QuizQuestion(
    number: 4,
    text: "What matters most in a friend?",
    type: .multipleChoice(["They show up when it counts", "They keep it real, no fake stuff", "They're fun to be around", "They challenge me to be better"])
  ),
  QuizQuestion(
    number: 5,
    text: "How often do you want to meet up?",
    type: .multipleChoice(["Every week", "Every other week", "A couple times a month", "I'm flexible"])
  ),
  QuizQuestion(
    number: 6,
    text: "What time works best for you?",
    type: .multipleChoice(["Weekday mornings", "Weekday evenings", "Weekends", "I'm flexible"])
  ),
  QuizQuestion(
    number: 7,
    text: "What's your vibe?",
    type: .multipleChoice(["Laid back and go with the flow", "High energy and always down for something", "Quiet but intentional", "Depends on the day honestly"])
  ),
  QuizQuestion(
    number: 8,
    text: "What are you hoping to find here?",
    type: .multipleChoice(["A tight group of real friends", "People to do life with", "A sense of belonging", "All of the above"])
  ),
  QuizQuestion(
    number: 9,
    text: "How do you feel about meeting new people?",
    type: .multipleChoice(["I love it, I'm an open book", "A little nervous but I'm ready", "It takes me a minute to open up", "Honestly terrified but I'm here anyway"])
  ),
  QuizQuestion(
    number: 10,
    text: "Are you ready to show up?",
    type: .multipleChoice(["All in, let's go", "Nervous but committed", "I need a little push", "Just looking around for now"])
  ),
]
