import UIKit

class SignUpNavigationController: UINavigationController {
  weak var signInViewController: SignInViewController!
  @IBAction func unwindToSignUpNavigationControllerWithSuccess(_ unwindSegue: UIStoryboardSegue) {
    self.dismiss(animated: true) {
      self.signInViewController.showMainMenu(sender: unwindSegue.source)
    }
  }
  
  @IBAction func unwindToSignUpNavigationControllerWithoutAction(_ unwindSegue: UIStoryboardSegue) {
    self.dismiss(animated: true)
  }
}
