import UIKit

class PushNotificationConsentViewController: UIViewController {
  @IBAction func didSelectPromptButton(_ sender: UIButton) {
    UserNotificationCenterManager.shared.requestAuthorization { _ in
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func didSelectDismissButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
