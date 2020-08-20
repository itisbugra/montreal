import UIKit

class SessionQuestionsOverviewCollectionViewController: UICollectionViewController {
  var session: Session!
  private var listingFilter: ListingFilter?

  private var hiddenQuestionSets = [QuestionSet]() {
    didSet {
      //  Check whether set is changed
      if oldValue == hiddenQuestionSets {
        return
      }
      
      defer {
        //  Reload toolbar items after reloading collection view
        reloadToolbarItems()
      }
      
      //  Check whether it is a single element insert or removal
      if abs(oldValue.count - hiddenQuestionSets.count) > 1 {
        collectionView.reloadData(animated: true)
      } else {
        //  Retrieve the added or removed question set
        let questionSet = oldValue.count < hiddenQuestionSets.count ? hiddenQuestionSets.last! : oldValue.last!
        
        //  Reload the corresponding section with animation
        collectionView.reloadSections(IndexSet(integer: session.questionSets!.firstIndex(of: questionSet)!))
      }
    }
  }
  
  //  MARK: - View configurations
  
  @IBOutlet weak var viewConfigurationBarButtonItem: UIBarButtonItem!
  
  enum ViewConfiguration: Equatable {
    case tile(columns: Int)
    case full
    
    var denominant: CGFloat {
      switch self {
      case .tile(let columns):
        return CGFloat(columns)
      case .full:
        return 1.00
      }
    }
  }

  /// List of the supported view configurations. Order affects the next view configuration when user requested.
  private var supportedViewConfigurations: [ViewConfiguration] = [.tile(columns: 3), .tile(columns: 2), .full]
  
  private func imageForViewConfiguration(_ viewConfiguration: ViewConfiguration) -> UIImage {
    switch viewConfiguration {
    case .tile(columns: 2):
      return UIImage(systemName: "rectangle.grid.2x2.fill")!
    case .tile(columns: 3):
      return UIImage(systemName: "rectangle.grid.3x2.fill")!
    case .full:
      return UIImage(systemName: "rectangle.grid.1x2.fill")!
    default:
      fatalError("Unsupported view configuration.")
    }
  }
  
  var viewConfiguration = ViewConfiguration.tile(columns: 3) {
    didSet {
      guard supportedViewConfigurations.contains(viewConfiguration) else {
        fatalError("Unsupported view configuration.")
      }
      
      viewConfigurationBarButtonItem.image = imageForViewConfiguration(nextViewConfiguration)
      collectionView.reloadData(animated: true)
    }
  }
  
  var previousViewConfiguration: ViewConfiguration {
    return supportedViewConfigurations[(supportedViewConfigurations.firstIndex(of: viewConfiguration)! - 1) % supportedViewConfigurations.count]
  }
  
  var nextViewConfiguration: ViewConfiguration {
    return supportedViewConfigurations[(supportedViewConfigurations.firstIndex(of: viewConfiguration)! + 1) % supportedViewConfigurations.count]
  }
  
  //  MARK: - Domain data structures
  
  enum ListingFilter {
    case marked
    case unseen
  }
  
  //  MARK: - UIViewController lifecycle
  
  var titleView: SessionQuestionsOverviewNavigationBarTitleView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    
    titleView = SessionQuestionsOverviewNavigationBarTitleView(frame: .zero)
    titleView.delegate = self
    
    navigationItem.titleView = titleView
    navigationItem.hidesBackButton = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController!.setToolbarHidden(false, animated: true)
    reloadToolbarItems()
    
    titleView.startAnimating()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController!.setToolbarHidden(true, animated: true)
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return session.questionSets!.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    let questionSet = session.questionSets![section]
    let isHidden = hiddenQuestionSets.contains(questionSet)
    
    return isHidden ? .zero : questionSet.questions.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionContentCollectionViewCell.identifier, for: indexPath) as! QuestionContentCollectionViewCell
    
    cell.question = session.questionSets![indexPath.section].questions[indexPath.row]
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: SetOverviewHeaderCollectionReusableView.identifier,
                                                                       for: indexPath) as! SetOverviewHeaderCollectionReusableView
      let questionSet = session.questionSets![indexPath.section]
      
      headerView.questionSet = questionSet
      headerView.setExpansionState(expansionState: hiddenQuestionSets.contains(questionSet) ? .narrowed : .expanded,
                                   animated: true)
      headerView.delegate = self
      
      return headerView
    case UICollectionView.elementKindSectionFooter:
      let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: SessionOverviewFooterCollectionReusableView.identifier,
                                                                       for: indexPath)
      //  TODO: Magic for instantiating footer view
      
      return footerView
    default:
      fatalError("Unsupported kind of supplementary element.")
    }
  }
  
  //  MARK: - UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showQuestion", sender: self)
  }
  
  //  MARK: - Segue handling
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    switch segue.identifier {
    case "showQuestion":
      let viewController = segue.destination as! QuestionMasterTableViewController
      let indexPath = collectionView.indexPathsForSelectedItems!.first!
      
      viewController.question = session.questionSets![indexPath.section].questions[indexPath.row]
    default:
      break
    }
  }
  
  //  MARK: - Navigation bar item actions
  
  @IBAction func changeViewTapped(_ sender: UIBarButtonItem) {
    viewConfiguration = nextViewConfiguration
  }
  
  //  MARK: - Toolbar handling
  
  func reloadToolbarItems() {
    let expansionToolbarItem = hiddenQuestionSets.isEmpty ?
      UIBarButtonItem(title: NSLocalizedString("Shrink All", comment: "Bar button item."), style: .plain, target: self, action: #selector(shrinkAllButtonTapped(_:))) :
      UIBarButtonItem(title: NSLocalizedString("Expand All", comment: "Bar button item."), style: .plain, target: self, action: #selector(expandAllButtonTapped(_:)))
    
    toolbarItems = [
      UIBarButtonItem(title: NSLocalizedString("Filter", comment: "Bar button item."), style: .plain, target: self, action: #selector(filterButtonTapped(_:))),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      expansionToolbarItem
    ]
  }
  
  //  MARK: - Toolbar actions
  
  @objc func filterButtonTapped(_ toolbarItem: UIBarButtonItem) {
    presentFilterAlert(currentFilter: listingFilter,
                       animated: true) { filter in
      self.listingFilter = filter
    }
  }
  
  @objc func expandAllButtonTapped(_ toolbarItem: UIBarButtonItem) {
    hiddenQuestionSets = []
  }
  
  @objc func shrinkAllButtonTapped(_ toolbarItem: UIBarButtonItem) {
    hiddenQuestionSets = session.questionSets!
  }
}

extension SessionQuestionsOverviewCollectionViewController: UICollectionViewDelegateFlowLayout {
  //  MARK: - UICollectionViewFlowLayoutDelegate
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = UIScreen.main.bounds.size.width
    let length = width / viewConfiguration.denominant
    
    return CGSize(width: length, height: length)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForFooterInSection section: Int) -> CGSize {
    return section != (numberOfSections(in: collectionView) - 1) ? CGSize.zero : CGSize(width: 50, height: 150)
  }
}

extension SessionQuestionsOverviewCollectionViewController: SessionQuestionsOverviewNavigationBarTitleViewDelegate {
  //  MARK: - SessionQuestionsOverviewNavigationBarTitleViewDelegate
  
  func titleViewSelected(_ titleView: SessionQuestionsOverviewNavigationBarTitleView) {
    performSegue(withIdentifier: "showSessionInformation", sender: titleView)
  }
}

extension SessionQuestionsOverviewCollectionViewController: SetOverviewHeaderCollectionReusableViewDelegate {
  func sectionShouldChangeExpensionState(_ setOverviewHeaderCollectionReusableView: SetOverviewHeaderCollectionReusableView,
                                         currentState state: SetOverviewHeaderCollectionReusableView.ExpansionState) {
    let questionSet = setOverviewHeaderCollectionReusableView.questionSet!
    
    switch state {
    case .expanded:
      hiddenQuestionSets.append(questionSet)
    case .narrowed:
      hiddenQuestionSets.removeAll { $0 == questionSet }
    }
  }
}
