import UIKit
import Mantis

extension ContentEditorTableViewController: CropViewControllerDelegate {
  func cropViewControllerDidCrop(_ cropViewController: CropViewController,
                                 cropped: UIImage,
                                 transformation: Transformation) {
    cropViewController.dismiss(animated: true, completion: nil)
  }
  
  func cropViewControllerDidCancel(_ cropViewController: CropViewController,
                                   original: UIImage) {
    
  }
}
