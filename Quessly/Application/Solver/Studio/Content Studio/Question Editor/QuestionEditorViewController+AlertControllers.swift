import UIKit

extension QuestionEditorViewController {
  //  MARK: - Alerts
  
  func presentDiscardChangesAlert(animated: Bool,
                                  completion: @escaping (Bool) -> Void) {
    let alertController = UIAlertController(title: nil,
                                            message: "Are you sure you want to discard this new question?",
                                            preferredStyle: .actionSheet)
    let actions = [
      UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
        completion(true)
      },
      UIAlertAction(title: "Keep Editing", style: .cancel) { _ in
        completion(false)
      }
    ]
    
    actions.forEach { alertController.addAction($0) }
    
    present(alertController,
            animated: true,
            completion: nil)
  }
}
