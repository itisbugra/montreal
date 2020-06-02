import UserNotifications

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
}
