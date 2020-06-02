import UIKit

class QuestionEditorViewController: UIViewController {
  
}

extension QuestionEditorViewController: UITableViewDataSource {
  //  MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Type", for: indexPath)
        
        return cell
      default:
        fatalError("Row not handled.")
      }
    default:
      fatalError("Section not handled.")
    }
  }
}

extension QuestionEditorViewController: UITableViewDelegate {
  //  MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    //    let pickerController = UIImagePickerController()
    //
    //    pickerController.delegate = self
    //    pickerController.allowsEditing = false
    //    pickerController.mediaTypes = ["public.image"]
    //    pickerController.sourceType = .camera
    //
    //    present(pickerController, animated: true, completion: nil)
  }
}
