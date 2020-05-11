import UIKit

class QuestionSet {
  let name: String
  let questions: [Question]
  
  init(name: String, questions: [Question]) {
    self.name = name
    self.questions = questions
  }
}
