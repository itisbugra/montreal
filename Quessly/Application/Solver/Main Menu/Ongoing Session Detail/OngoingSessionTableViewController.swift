import UIKit

class OngoingSessionTableViewController: UITableViewController {
  //  MARK: - Internal data
  
  let session = try! FakeSessionRepository.shared.one(consolidated: false).wait()
  
  //  MARK: - Internal state
  
  var timers = [Timer]()
  var isDownloading = false
  var isSessionAvailable = false
  var shouldDownloadContentWhenAvailable = true
  
  //  MARK: - View controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //  TODO: Make this function call look alike below
    tableView.registerCenteredLabelTableViewCell()
    
    SessionTableViewCell.registerForReuse(in: tableView)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    timers.append(Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
      self.isSessionAvailable = true
      
      self.tableView.reloadSections(IndexSet(arrayLiteral: 0, 3), with: .automatic)
      
      if self.shouldDownloadContentWhenAvailable {
        self.startDownloading()
      }
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    timers.forEach { timer in
      timer.invalidate()
    }
  }
  
  //  MARK: - Segue handling
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let customSegue = segue as? MainMenuToOngoingSessionOverviewSegue {
      customSegue.session = session
    }
  }
  
  //  MARK: - Operations
  
  func startDownloading() {
    isDownloading = true
    
    presentSessionContentDownloadingAlert(animated: true)
    
    timers.append(Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
      self.isDownloading = false
      self.performSegue(withIdentifier: "exit", sender: self)
    })
  }
  
  //  MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 6
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 3
    case 2:
      return 1
    case 3:
      return 1
    case 4:
      return 1
    case 5:
      return 1
    default:
      fatalError("Row count cannot be supplied.")
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.identifier,
                                               for: indexPath) as! SessionTableViewCell
      
      if isSessionAvailable {
        if shouldDownloadContentWhenAvailable {
          cell.state = .loading
        } else {
          cell.state = .downloadPrompt
        }
      } else {
        cell.state = .loading
      }
      
      cell.session = session
      cell.downloadPromptDelegate = self
      cell.isEnabled = !isDownloading
      cell.isAnimating = true
      
      return cell
    case (1, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail", for: indexPath)
      
      cell.textLabel?.text = NSLocalizedString("Name", comment: "Name of the session.")
      cell.detailTextLabel?.text = session.name.localizedValue
      
      return cell
    case (1, 1):
      let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail", for: indexPath)
      
      cell.textLabel?.text = NSLocalizedString("Type", comment: "Type of the session.")
      cell.detailTextLabel?.text = "Marathon"
      cell.accessoryType = .detailButton
      
      return cell
    case (1, 2):
      let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail", for: indexPath)
      
      cell.textLabel?.text = NSLocalizedString("Duration", comment: "Name of the session.")
      cell.detailTextLabel?.text = ""
      
      return cell
    case (2, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail", for: indexPath)
      
      cell.textLabel?.text = NSLocalizedString("Content", comment: "Content of the session.")
      cell.detailTextLabel?.text = ""
      
      return cell
    case (3, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: PlainSwitchTableViewCell.identifier,
                                               for: indexPath) as! PlainSwitchTableViewCell
      
      cell.titleLabel.text = NSLocalizedString("Download When Available",
                                               comment: "Title of the cell asking for download.")
      cell.isEnabled = true
      cell.isOn = true
      cell.delegate = self
      
      return cell
    case (4, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: CenteredLabelTableViewCell.identifier,
                                               for: indexPath)
      
      cell.textLabel!.text = NSLocalizedString("Unenroll",
                                               comment: "Unenrolls from the session in session awaiting context.")
      cell.textLabel!.textColor = .systemRed
      
      return cell
    case (5, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: CenteredLabelTableViewCell.identifier,
                                               for: indexPath)
      
      cell.textLabel!.text = NSLocalizedString("Dismiss",
                                               comment: "Dismisses the session waiting context.")
      cell.textLabel!.textColor = .systemRed
      
      return cell
    default:
      fatalError("Cell cannot be supplied.")
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 80
    case 1:
      fallthrough
    case 2:
      fallthrough
    case 4:
      fallthrough
    case 5:
      return 44
    case 3:
      return isSessionAvailable ? 0 : 44
    default:
      fatalError("Row height cannot be supplied.")
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 1:
      return NSLocalizedString("Session Information",
                               comment: "Header of the section for the session information in session awaiting.")
    case 2:
      return NSLocalizedString("Session Content",
                               comment: "Header of the section for the session content in session awaiting.")
    case 3:
      if !isSessionAvailable {
        return NSLocalizedString("Downloadable content",
                                 comment: "Header of the section for download prompt in session awaiting.")
      }
      
      return nil
    default:
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    switch section {
    case 0:
      if isSessionAvailable {
        return NSLocalizedString("Tap download button to download the session contents and enter to the session.",
                                 comment: "Description for the download prompt.")
      }
      
      return NSLocalizedString("This session cannot be started by its administrator before the starting time.",
                               comment: "Description for the session awaiting indicator.")
    case 3:
      if !isSessionAvailable {
        return NSLocalizedString("When the session content is made available to the users, the downloading starts automatically if enabled. \n\nOtherwise, you might need to wait for a while in order to download the session content when it begins.",
                                 comment: "Description for the downloadable content setting.")
      }
      
      return nil
    case 4:
      if isSessionAvailable {
        return NSLocalizedString("Since session has become available to the users, if you unenroll from this session, you might not be able to join it again.", comment: "Section footer for the unenrolling from a started session.")
      }
      
      return nil
    default:
      return nil
    }
  }
  
  //  MARK: - Table view delegate methods
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch (indexPath.section, indexPath.row) {
    case (5, 0):
      dismiss(animated: true, completion: nil)
    default:
      break
    }
  }
}

extension OngoingSessionTableViewController: PlainSwitchTableViewCellDelegate {
  func plainSwitchTableViewCell(_ plainSwitchTableViewCell: PlainSwitchTableViewCell,
                                valueDidChange: Bool) {
    shouldDownloadContentWhenAvailable = valueDidChange
  }
}

extension OngoingSessionTableViewController: SessionTableViewCellDownloadPromptDelegate {
  func sessionTableViewCellReceivedDownloadAction(_ cell: SessionTableViewCell) {
    startDownloading()
  }
}
