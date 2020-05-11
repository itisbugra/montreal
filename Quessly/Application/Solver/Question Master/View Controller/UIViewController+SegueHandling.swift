import UIKit

extension QuestionMasterTableViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    switch segue.identifier {
    case "showQuestionDetail":
      let viewController = segue.destination as! QuestionDetailTableViewController
      
      viewController.delegate = self
    default:
      break
    }
  }
}
