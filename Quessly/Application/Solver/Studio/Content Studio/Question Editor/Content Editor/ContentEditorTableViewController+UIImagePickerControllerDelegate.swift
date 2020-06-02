import Mantis

extension ContentEditorTableViewController: UIImagePickerControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else {
      return
    }
    
    picker.dismiss(animated: true) {
      let cropViewController = Mantis.cropViewController(image: image)
      
      cropViewController.delegate = self
      cropViewController.modalPresentationStyle = .fullScreen
      
      self.present(cropViewController, animated: true, completion: nil)
    }
  }
}
