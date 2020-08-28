import UIKit

extension UIAlertController {
  private struct StaticData {
    static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                         y: 0,
                                                                         width: 40,
                                                                         height: 40))
  }
  
  func addActivityIndicator() {
    let viewController = UIViewController()
    viewController.preferredContentSize = CGSize(width: 40, height: 40)
    
    StaticData.activityIndicator.startAnimating()
    
    viewController.view.addSubview(StaticData.activityIndicator)
    
    self.setValue(viewController, forKey: "contentViewController")
  }
  
  func dismissActivityIndicator() {
    StaticData.activityIndicator.stopAnimating()
    
    self.dismiss(animated: false)
  }
}
