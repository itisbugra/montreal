import UIKit

class QuestionEditorViewController: UIViewController {
  //  MARK: - Action selectors
  
  @IBAction func didPressCancel(_ sender: UIBarButtonItem) {
    presentDiscardChangesAlert(animated: true) { success in
      if success {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func didPressDone(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

extension QuestionEditorViewController: UITableViewDataSource {
  //  MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 1
    case 2:
      return 1
    default:
      fatalError("Section not handled")
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail",
                                                 for: indexPath)
        
        cell.textLabel?.text = "Type"
        cell.detailTextLabel?.text = "Multiple, mutual exclusive"
        
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail",
                                                 for: indexPath)
        
        cell.textLabel?.text = "Listing"
        cell.detailTextLabel?.text = "Private"
        
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail",
                                                 for: indexPath)
        
        cell.textLabel?.text = "Categorization"
        cell.detailTextLabel?.text = "none"
        
        return cell
      default:
        fatalError("Row not handled.")
      }
    case 1:
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Link",
                                                 for: indexPath)
        
        cell.textLabel?.text = "Add Question Content"
        
        return cell
      default:
        fatalError("Row not handled.")
      }
    case 2:
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Link",
                                                 for: indexPath)
        
        cell.textLabel?.text = "Add Option Content"
        
        return cell
      default:
        fatalError("Row not handled.")
      }
    default:
      fatalError("Section not handled.")
    }
  }
  
  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Configuration"
    case 1:
      return "Question Content"
    case 2:
      return "Options Content"
    default:
      return nil
    }
  }
}

extension QuestionEditorViewController: UITableViewDelegate {
  //  MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showQuestionContentEditor", sender: self)
  }
}
