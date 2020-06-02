import UIKit

extension ContentEditorTableViewController {
  //  MARK: - Toolbars
  
  var toolbarInputAccessoryViewForContent: UIToolbar {
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.5)
    let toolbar = UIToolbar(frame: frame)
    
    toolbar.barStyle = .default
    toolbar.items = [
      UIBarButtonItem(image: UIImage(systemName: "camera"),
                      style: .plain,
                      target: self,
                      action: #selector(didPressCamera(_:))),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                      target: nil,
                      action: nil),
      UIBarButtonItem(barButtonSystemItem: .done,
                      target: self,
                      action: #selector(shouldResignFirstResponder(_:)))
    ]
    
    return toolbar
  }
}
