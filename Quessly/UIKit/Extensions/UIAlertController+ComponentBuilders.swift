import UIKit

extension UIAlertController {
  private struct StaticData {
    static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                         y: 0,
                                                                         width: 40,
                                                                         height: 40))
  }
  
  @discardableResult func addActivityIndicator(builder: ((UIActivityIndicatorView) -> Void)? = nil) -> UIActivityIndicatorView {
    let viewController = UIViewController()
    viewController.preferredContentSize = CGSize(width: 40, height: 40)
    
    StaticData.activityIndicator.startAnimating()
    
    viewController.view.addSubview(StaticData.activityIndicator)
    
    self.setValue(viewController, forKey: "contentViewController")
    
    builder?(StaticData.activityIndicator)
    
    return StaticData.activityIndicator
  }
  
  func dismissActivityIndicator() {
    StaticData.activityIndicator.stopAnimating()
    
    self.dismiss(animated: false)
  }
  
  @discardableResult func addTextField(builder: ((UITextField) -> Void)) -> UITextField {
    self.addTextField()
    
    let textField = self.textFields!.last!
    
    builder(textField)
    
    return textField
  }
}
