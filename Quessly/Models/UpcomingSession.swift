import Foundation

public class UpcomingSession {
  var untouched: Bool
  var title: String
  var participantCount: UInt
  var timestamp: Date
  
  init(untouched: Bool,
       title: String,
       participantCount: UInt,
       timestamp: Date) {
    self.untouched = untouched
    self.title = title
    self.participantCount = participantCount
    self.timestamp = timestamp
  }
}
