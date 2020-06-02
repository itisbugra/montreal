import UIKit

extension ContentEditorTableViewController {
  //  MARK: - Alerts
  
  enum PhotoSource {
    case photoLibrary
    case camera
    
    var sourceType: UIImagePickerController.SourceType {
      switch self {
      case .photoLibrary:
        return .photoLibrary
      case .camera:
        return .camera
      }
    }
  }
  
  func presentPhotoSourceAlert(animated: Bool,
                               completion: @escaping (PhotoSource?) -> Void) {
    let alertController = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
    let actions = [
      UIAlertAction(title: "Use Camera", style: .default) { _ in
        completion(.camera)
      },
      UIAlertAction(title: "Choose From Photo Library", style: .default) { _ in
        completion(.photoLibrary)
      },
      UIAlertAction(title: "Cancel", style: .cancel) { _ in
        completion(nil)
      },
    ]
    
    actions.forEach { alertController.addAction($0) }
    
    present(alertController,
            animated: animated,
            completion: nil)
  }
}
