import UIKit

public class Session {
  enum State {
    /// Session is currently awaiting.
    ///
    /// Wait until session content is available to fetch the content.
    case awaiting
    
    /// Session is not started yet, content has become available awaiting your download.
    ///
    /// Use [fetchContent:completion](x-source-tag://fetchContent:completion) to fetch the content.
    case contentAvailable
    
    /// Session is not started yet, but content is downloaded.
    case contentFetched
    
    /// Session is started, but you're not joined in.
    case started
    
    /// The user has been joined in to the session.
    case running
    
    /// The session has ended.
    case ended
  }
  
  /// Identifier of the session.
  var id: Int
  
  /// Name of the session.
  var name: LocalizedString
  
  /// An array of question sets contained in this session, if available.
  ///
  /// Use [fetchContent:completion](x-source-tag://fetchContent:completion) to fetch the content when
  /// it becomes available.
  var questionSets: [QuestionSet]? = nil
  
  /// The timestamp showing when the content of this session will be available at.
  var contentAvailableAt: Date
  
  /// The timestamp showing when the session starts at.
  var startingAt: Date
  
  /// The timestamp showing when the session was started.
  var startedAt: Date? = nil
  
  /// The timestamp showing when the session ends at.
  var endingAt: Date
  
  /// The number of participants of the session.
  var participantCount: UInt!
  
  /// Shows whether content is available.
  var isContentAvailable: Bool {
    return contentAvailableAt.timeIntervalSinceNow <= 0
  }
  
  /// Shows whether session has started.
  var isStarted: Bool {
    return startedAt != nil
  }
  
  /// Shows whether session has ended.
  var isEnded: Bool {
    return endingAt.timeIntervalSinceNow <= 0
  }
  
  /// Current state of the session.
  var state: State {
    if isEnded {
      return .ended
    }
    
    if isStarted {
      return .started
    }
    
    if isContentAvailable {
      if questionSets == nil {
        return .contentAvailable
      }
      
      return .contentFetched
    }
    
    return .awaiting
  }
  
  init(id: Int,
       name: LocalizedString,
       questionSets: [QuestionSet],
       contentAvailableAt: Date,
       startingAt: Date,
       endingAt: Date) {
    self.id = id
    self.name = name
    self.questionSets = questionSets
    self.contentAvailableAt = contentAvailableAt
    self.startingAt = startingAt
    self.endingAt = endingAt
  }
  
  /// Synchronizes the session information with the server.
  func synchronize(completion: ((Error?) -> Void)?) {
    
  }
  
  /// Fetches the content of the session, if available.
  func fetchContent(completion: ((Error?) -> Void)?) {
    
  }
}
