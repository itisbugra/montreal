import UIKit
import UserNotifications

/**
 Main menu of the application.
 */
class MainMenuTableViewController: UITableViewController {
  let upcomingSessions: [Session] = [
  ]
  
  let ongoingSessions = [
    Session(id: 0,
            name: LocalizedString(localized: "Physics 101", locale: .current),
            questionSets: [],
            contentAvailableAt: Date().addingTimeInterval(2000),
            startingAt: Date().addingTimeInterval(5000),
            endingAt: Date().addingTimeInterval(10000))
  ]
  
  //  MARK: - Internal data
  
  var session: Session!
  
  //  MARK: - View controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesBackButton = true
    clearsSelectionOnViewWillAppear = true
    
    SessionTableViewCell.registerForReuse(in: tableView)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return ongoingSessions.count
    case 1:
      return upcomingSessions.count
    case 2:
      return 6
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.identifier,
                                               for: indexPath) as! SessionTableViewCell
      
      cell.session = ongoingSessions[indexPath.row]
      cell.accessoryType = .disclosureIndicator
      
      return cell
    }
    
    if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.identifier,
                                               for: indexPath) as! SessionTableViewCell

//      cell.session = upcomingSessions[indexPath.row]
      cell.accessoryType = .disclosureIndicator

      return cell
    }
    
    if indexPath.section == 2 {
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
      
      if indexPath.row == 5 {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "Pseudo Push Notifications"
        
        return cell
      }
    }
    
    fatalError("Section not handled.")
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      fallthrough
    case 1:
      return 80
    case 2:
      return 44
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return NSLocalizedString("Ongoing live sessions", comment: "Header in the main menu.")
    case 1:
      return NSLocalizedString("Upcoming live sessions", comment: "Header in the main menu.")
    default:
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.section {
    case 0:
      performSegue(withIdentifier: "showOngoingSessionDetail", sender: self)
    case 1:
      performSegue(withIdentifier: "showUpcomingSessionDetail", sender: self)
    case 2:
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
      case 5:
        performSegue(withIdentifier: "showPseudoPushNotificationsTest", sender: self)
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
      
      viewController.question = session.questionSets![0].questions.first!
    case "showSessionQuestionsOverview":
      let viewController = segue.destination as! SessionQuestionsOverviewCollectionViewController
      
      viewController.session = session
    default:
      break
    }
  }
  
  @IBAction func unwindToMainMenuTableViewController(segue: MainMenuToNotificationConsentSegue) {
    
  }
  
  @IBAction func unwindToMainMenuToTriggerUserNotificationConsent(segue: UIStoryboardSegue) {
    DispatchQueue.main.async {
      self.performPushNotificationConsentSegueIfNeeded(animated: true)
    }
  }
  
  @IBAction func unwindToMainMenuToShowOngoingSessionOverview(segue: MainMenuToOngoingSessionOverviewSegue) {
    session = segue.session
    
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: "showSessionQuestionsOverview",
                        sender: segue.source)
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
  
  @IBAction func showProfile(_ sender: UIBarButtonItem) {
    self.navigationController!.pushViewController(UserProfileTableViewController(), animated: true)
  }
}
