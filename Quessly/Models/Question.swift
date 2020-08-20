import Foundation

class Question: Equatable {
  class Option: Equatable, Hashable {
    var id: Int
    var content: FormattedContent
    
    init(id: Int, content: FormattedContent) {
      self.id = id
      self.content = content
    }
    
    static func == (lhs: Option, rhs: Option) -> Bool {
      return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }
  
  enum State {
    enum ConsolidationResult {
      /// No option was not marked by the user.
      case notMarked(correctOption: Question.Option)
      
      /// Answer consolidated as correct.
      case correct(answered: Question.Option)
      
      /// Answer consolidated as incorrect.
      case incorrect(answered: Question.Option, correctOption: Question.Option)
    }
    
    /// The question is unseen by the user.
    case unseen
    
    /// The question seen by the user, might have some marked options.
    case marked(options: [Question.Option])
    
    /// The question is answered by the user.
    case answered(option: Question.Option)
    
    /// The question is consolidated.
    case consolidated(result: ConsolidationResult)
  }
  
  var id: Int
  var content: FormattedContent
  var options: [Option]
  var state = State.unseen
  
  init(id: Int, content: FormattedContent, options: [Option]) {
    self.id = id
    self.content = content
    self.options = options
  }
  
  static func == (lhs: Question, rhs: Question) -> Bool {
    return lhs.id == rhs.id
  }
}
