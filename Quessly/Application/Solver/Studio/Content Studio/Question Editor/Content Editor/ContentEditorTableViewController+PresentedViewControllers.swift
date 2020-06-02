import UIKit

extension ContentEditorTableViewController {
  func presentImagePickerController(photoSource: PhotoSource,
                                    animated: Bool,
                                    completion: (() -> Void)?) {
    let pickerController = UIImagePickerController()
    
    pickerController.delegate = self
    pickerController.allowsEditing = false
    pickerController.mediaTypes = ["public.image"]
    pickerController.sourceType = photoSource.sourceType
    
    present(pickerController,
            animated: animated,
            completion: completion)
  }
}
