import UIKit

class QuestionMasterTableViewController: UITableViewController {
  var clientConfiguration = ClientConfiguration.shared
  var question: Question!
  
  var eliminatedOptions = [Question.Option]()
  
  var visibleOptions: [(Int, Question.Option)] {
    return question
      .options
      .filter { !eliminatedOptions.contains($0) }
      .map { option in
        return (question.options.firstIndex(of: option)!, option)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 200
    
    let titleView = QuestionMasterNavigationBarTitleView(frame: CGRect.zero)
    titleView.contextLabel.text = "Lorem ipsum"
    titleView.identifierLabel.text = "#712374"
    
    navigationItem.titleView = titleView
    
    navigationController!.setToolbarHidden(false, animated: true)
    toolbarItems = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Skip", style: .plain, target: nil, action: nil)
    ]
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController!.setToolbarHidden(true, animated: true)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    RenderSizeCache.shared.flush()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return visibleOptions.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath.section == 0) {
      let cell = tableView.dequeueReusableCell(withIdentifier: QuestionContentTableViewCell.identifier, for: indexPath) as! QuestionContentTableViewCell
      cell.question = question
      cell.delegate = self
      
      return cell
    }
    
    if (indexPath.section == 1) {
      let cell = tableView.dequeueReusableCell(withIdentifier: OptionContentTableViewCell.identifier, for: indexPath) as! OptionContentTableViewCell
      let enumerationProvider = enumeration(for: clientConfiguration.optionEnumerationSet)
      let (order, option) = visibleOptions[indexPath.row]
      
      cell.option = option
      cell.enumeratorLabel.text = try! enumerationProvider.symbol(for: order)
      cell.delegate = self
      
      return cell
    }
    
    fatalError("Section not handled.")
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Question"
    case 1:
      return "Options"
    default:
      return nil
    }
  }
}
