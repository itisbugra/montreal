import UIKit

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
  
  let question = Question(id: 1,
                          content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Question", withExtension: "html")!),
                                                    mimeType: .HTML(withMathJax: true)),
                          options: [
                            Question.Option(id: 1,
                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option1", withExtension: "html")!),
                                                                      mimeType: .HTML(withMathJax: true))),
                            Question.Option(id: 2,
                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option2", withExtension: "html")!),
                                                                      mimeType: .HTML(withMathJax: true))),
                            Question.Option(id: 3,
                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option3", withExtension: "html")!),
                                                                      mimeType: .HTML(withMathJax: true))),
                            Question.Option(id: 4,
                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option4", withExtension: "html")!),
                                                                      mimeType: .HTML(withMathJax: true))),
                            Question.Option(id: 5,
                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option5", withExtension: "html")!),
                                                                      mimeType: .HTML(withMathJax: true)))])
  
//  let question = Question(id: 1,
//                          content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Question", withExtension: "html")!),
//                                                    mimeType: .HTML(withMathJax: true)),
//                          options: [
//                            Question.Option(id: 1,
//                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option1", withExtension: "html")!),
//                                                                      mimeType: .HTML(withMathJax: true))),
//                            Question.Option(id: 2,
//                                            content: FormattedContent(data: try! String(contentsOf: Bundle.main.url(forResource: "Option2", withExtension: "html")!),
//                                                                      mimeType: .HTML(withMathJax: true))),
//                            Question.Option(id: 3,
//                                            content: FormattedContent(data: "Phasellus a sagittis diam, ut porttitor libero. Suspendisse quis tincidunt felis. Maecenas sit amet accumsan lacus. Nam ornare, urna vitae dapibus aliquet, ipsum sem ultrices nulla, ut elementum odio dolor ac purus. Curabitur sit amet lobortis metus. Proin venenatis, neque eget ultricies tristique, tortor risus lacinia sem, at faucibus libero est et odio. Donec fermentum ligula auctor, vestibulum ante in, ornare ante. Curabitur pulvinar urna et sapien interdum, vitae viverra ex bibendum. Quisque magna ipsum, luctus in aliquam id, placerat in sem. Etiam consectetur est et lorem auctor, et vestibulum felis vestibulum. Nunc feugiat justo ultricies lectus pharetra, id sodales quam consequat. Phasellus vitae justo vitae tellus ullamcorper mollis eget quis arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tempus elementum venenatis. Sed lacinia, mi in malesuada tempor, nisl nibh ornare turpis, nec pulvinar mauris lectus et lorem. Nullam bibendum porta metus vitae pulvinar.",
//                                                                      mimeType: .PlainText)),
//                            Question.Option(id: 4,
//                                            content: FormattedContent(data: "Phasellus a sagittis diam, ut porttitor libero. Suspendisse quis tincidunt felis. Maecenas sit amet accumsan lacus. Nam ornare, urna vitae dapibus aliquet, ipsum sem ultrices nulla, ut elementum odio dolor ac purus. Curabitur sit amet lobortis metus. Proin venenatis, neque eget ultricies tristique, tortor risus lacinia sem, at faucibus libero est et odio. Donec fermentum ligula auctor, vestibulum ante in, ornare ante. Curabitur pulvinar urna et sapien interdum, vitae viverra ex bibendum. Quisque magna ipsum, luctus in aliquam id, placerat in sem. Etiam consectetur est et lorem auctor, et vestibulum felis vestibulum. Nunc feugiat justo ultricies lectus pharetra, id sodales quam consequat. Phasellus vitae justo vitae tellus ullamcorper mollis eget quis arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tempus elementum venenatis. Sed lacinia, mi in malesuada tempor, nisl nibh ornare turpis, nec pulvinar mauris lectus et lorem. Nullam bibendum porta metus vitae pulvinar.",
//                                                                      mimeType: .PlainText)),
//                            Question.Option(id: 5,
//                                            content: FormattedContent(data: "Phasellus a sagittis diam, ut porttitor libero. Suspendisse quis tincidunt felis. Maecenas sit amet accumsan lacus. Nam ornare, urna vitae dapibus aliquet, ipsum sem ultrices nulla, ut elementum odio dolor ac purus. Curabitur sit amet lobortis metus. Proin venenatis, neque eget ultricies tristique, tortor risus lacinia sem, at faucibus libero est et odio. Donec fermentum ligula auctor, vestibulum ante in, ornare ante. Curabitur pulvinar urna et sapien interdum, vitae viverra ex bibendum. Quisque magna ipsum, luctus in aliquam id, placerat in sem. Etiam consectetur est et lorem auctor, et vestibulum felis vestibulum. Nunc feugiat justo ultricies lectus pharetra, id sodales quam consequat. Phasellus vitae justo vitae tellus ullamcorper mollis eget quis arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tempus elementum venenatis. Sed lacinia, mi in malesuada tempor, nisl nibh ornare turpis, nec pulvinar mauris lectus et lorem. Nullam bibendum porta metus vitae pulvinar. Phasellus a sagittis diam, ut porttitor libero. Suspendisse quis tincidunt felis. Maecenas sit amet accumsan lacus. Nam ornare, urna vitae dapibus aliquet, ipsum sem ultrices nulla, ut elementum odio dolor ac purus. Curabitur sit amet lobortis metus. Proin venenatis, neque eget ultricies tristique, tortor risus lacinia sem, at faucibus libero est et odio. Donec fermentum ligula auctor, vestibulum ante in, ornare ante. Curabitur pulvinar urna et sapien interdum, vitae viverra ex bibendum. Quisque magna ipsum, luctus in aliquam id, placerat in sem. Etiam consectetur est et lorem auctor, et vestibulum felis vestibulum. Nunc feugiat justo ultricies lectus pharetra, id sodales quam consequat. Phasellus vitae justo vitae tellus ullamcorper mollis eget quis arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tempus elementum venenatis. Sed lacinia, mi in malesuada tempor, nisl nibh ornare turpis, nec pulvinar mauris lectus et lorem. Nullam bibendum porta metus vitae pulvinar.",
//                                                                      mimeType: .PlainText))])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.hidesBackButton = true
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
      return 2
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    case "showUpcomingSessionDetail":
      let viewController = segue.destination as! UpcomingSessionTableViewController
      
      viewController.delegate = self
    case "showQuestion":
      let viewController = segue.destination as! QuestionMasterTableViewController
      
      viewController.question = question
    default:
      break
    }
  }
  
  @IBAction func unwindToMainMenuTableViewController(segue: UIStoryboardSegue) {
    //  Empty implementation
  }
}

extension MainMenuTableViewController : UpcomingSessionDetailTableViewControllerDelegate {
  func willDismiss(_ upcomingSessionTableViewController: UpcomingSessionTableViewController) {
    for cell in tableView.visibleCells {
      cell.setSelected(false, animated: true)
    }
    
    tableView.reloadData()
  }
}
