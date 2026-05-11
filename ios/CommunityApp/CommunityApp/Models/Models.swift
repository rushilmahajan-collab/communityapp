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
  var verificationStatus: VerificationStatus = .pending
  var quizResponses: [String: Any]?
}

enum VerificationStatus: String, Codable {
  case pending = "pending"
  case verified = "verified"
  case rejected = "rejected"
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
    text: "Why did you download this app?",
    type: .textOrVoice
  ),
  QuizQuestion(
    number: 2,
    text: "What does community mean to you?",
    type: .textOrVoice
  ),
  QuizQuestion(
    number: 3,
    text: "What kind of friend are you looking for?",
    type: .multipleChoice(["Someone to hang with", "Someone to grow with", "Someone to be real with", "All of the above"])
  ),
  QuizQuestion(
    number: 4,
    text: "How do you spend your weekends?",
    type: .textOrVoice
  ),
  QuizQuestion(
    number: 5,
    text: "What's something you're passionate about?",
    type: .textOrVoice
  ),
  QuizQuestion(
    number: 6,
    text: "Are you new to your city?",
    type: .multipleChoice(["Yes", "No", "Been here a while"])
  ),
  QuizQuestion(
    number: 7,
    text: "How often do you want to meet up?",
    type: .multipleChoice(["Weekly", "Biweekly", "Monthly"])
  ),
  QuizQuestion(
    number: 8,
    text: "What time of day works best?",
    type: .multipleChoice(["Mornings", "Afternoons", "Evenings", "Weekends"])
  ),
  QuizQuestion(
    number: 9,
    text: "What's one thing you wish more people knew about you?",
    type: .textOrVoice
  ),
  QuizQuestion(
    number: 10,
    text: "What does showing up mean to you?",
    type: .textOrVoice
  ),
]
