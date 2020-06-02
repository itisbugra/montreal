import UIKit
import UserNotifications

/**
 Main menu of the application.
 */
class MainMenuTableViewController: UITableViewController {
  let upcomingSessions = [
    UpcomingSession(untouched: true,
                    title: "Full Exam Coverage",
                    participantCount: 5172,
                    timestamp: Date()),
    UpcomingSession(untouched: false,
                    title: "Maths'o Round",
                    participantCount: 427,
                    timestamp: Date())
  ]
  
  let session = try! FakeSessionRepository.shared.one().wait()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesBackButton = true
    clearsSelectionOnViewWillAppear = true
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return upcomingSessions.count
    case 1:
      return 5
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingSession", for: indexPath) as! UpcomingSessionTableViewCell
      
      cell.upcomingSession = upcomingSessions[indexPath.row]
      cell.accessoryType = .disclosureIndicator
      
      return cell
    }
    
    if indexPath.section == 1 {
      if indexPath.row == 0 {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "Question"
        
        return cell
      }
      
      if indexPath.row == 1 {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "MathJax"
        
        return cell
      }
      
      if indexPath.row == 2 {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "Category Explorer"
        
        return cell
      }
      
      if indexPath.row == 3 {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "Session Overview"
        
        return cell
      }
      
      if indexPath.row == 4 {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "Content Studio"
        
        return cell
      }
    }
    
    fatalError("Section not handled.")
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 80
    case 1:
      return 44
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Upcoming live sessions"
    default:
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      performSegue(withIdentifier: "showUpcomingSessionDetail", sender: self)
    case 1:
      switch indexPath.row {
      case 0:
        performSegue(withIdentifier: "showQuestion", sender: self)
      case 1:
        performSegue(withIdentifier: "showMathJaxTest", sender: self)
      case 2:
        performSegue(withIdentifier: "showCategoryExplorer", sender: self)
      case 3:
        performSegue(withIdentifier: "showSessionQuestionsOverview", sender: self)
      case 4:
        performSegue(withIdentifier: "showContentStudio", sender: self)
      default:
        break
      }
    default:
      break
    }
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showQuestion":
      let viewController = segue.destination as! QuestionMasterTableViewController
      
      viewController.question = session.questionSets[0].questions.first!
    case "showSessionQuestionsOverview":
      let viewController = segue.destination as! SessionQuestionsOverviewCollectionViewController
      
      viewController.session = session
    default:
      break
    }
  }
  
  @IBAction func unwindToMainMenuTableViewController(segue: UIStoryboardSegue) {
    if let customSegue = segue as? MainMenuUnwindSegue {
      if customSegue.triggersUserNotificationConsent {
        performPushNotificationConsentSegueIfNeeded(animated: true)
      }
    }
  }
  
  //  MARK: - Consent handling
  
  func performPushNotificationConsentSegueIfNeeded(animated: Bool) {
    let userNotificationCenterManager = UserNotificationCenterManager.shared
    
    userNotificationCenterManager.getAuthorizationStatus { status in
      if status == .notDetermined {
        self.performSegue(withIdentifier: "showPushNotificationConsent",
                          sender: self)
      }
    }
  }
}
