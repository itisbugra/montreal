import UIKit

class QuestionSet: Equatable {
  let id: Int
  let name: String
  let questions: [Question]
  
  static func == (lhs: QuestionSet, rhs: QuestionSet) -> Bool {
    return lhs.id == rhs.id
  }
  
  init(id: Int, name: String, questions: [Question]) {
    self.id = id
    self.name = name
    self.questions = questions
  }
}
