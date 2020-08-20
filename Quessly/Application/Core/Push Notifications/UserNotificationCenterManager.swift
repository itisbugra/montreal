import UserNotifications
import NSLogger

class UserNotificationCenterManager {
  static let shared = UserNotificationCenterManager()
  
  private let notificationCenter = UNUserNotificationCenter.current()
  
  func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
    notificationCenter.getNotificationSettings { settings in
      DispatchQueue.main.async {
        completion(settings.authorizationStatus)
      }
    }
  }
  
  func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
    notificationCenter.getNotificationSettings { settings in
      if settings.authorizationStatus == .notDetermined {
        self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
          guard error == nil else {
            fatalError("Error while requesting user notification authorization.")
          }
          
          DispatchQueue.main.async {
            completion?(success)
          }
        }
      }
    }
  }
  
  enum Reason {
    case sessionStart(session: Session)
  }
  
  func schedulePushNotification(for reason: Reason, after: TimeInterval) {
    let content = UNMutableNotificationContent()
    
    switch reason {
    case .sessionStart(let session):
      content.title = String(format: NSLocalizedString("Session is starting: %@", comment: "Title of the notification when session is about to start"), session.name.localizedValue)
      content.body = NSLocalizedString("Your session is about to start, tap to join in.", comment: "Body of the notification when session is about to start")
      content.sound = .default
    }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: after,
                                                    repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                        content: content,
                                        trigger: trigger)
    
    notificationCenter.add(request) { error in
      guard error == nil else {
        fatalError(error!.localizedDescription)
      }
      
      Logger.shared.log(.app, .verbose, "Push notification scheduled to be fired after \(after)[TimeInterval].")
    }
  }
}
