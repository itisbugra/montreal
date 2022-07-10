import UIKit

extension SignInViewController {
  func presentLoadingAlert(completion: (() -> Void)?) {
    let alertController = UIAlertController(title: NSLocalizedString("Signing you in...",
                                                                     comment: ""),
                                            message: nil,
                                            preferredStyle: .alert)
    
    alertController.addActivityIndicator()
    
    [UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
      
      self.dismiss(animated: true, completion: nil)
    }].forEach { alertController.addAction($0) }
    
    self.present(alertController, animated: true, completion: completion)
  }
}