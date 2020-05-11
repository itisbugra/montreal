import UIKit

class SessionQuestionsOverviewCollectionViewController: UICollectionViewController {
  var session: Session!
  private var listingFilter: ListingFilter?
  
  var titleView: SessionQuestionsOverviewNavigationBarTitleView!
  
  //  MARK: - Domain data structures
  
  enum ListingFilter {
    case marked
    case unseen
  }
  
  //  MARK: - UIViewController lifecycle
  
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
    toolbarItems = [UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTapped(_:)))]
    
    titleView.startAnimating()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController!.setToolbarHidden(true, animated: true)
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return session.questionSets.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return session.questionSets[section].questions.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionContentCollectionViewCell.identifier, for: indexPath) as! QuestionContentCollectionViewCell
    
    cell.question = session.questionSets[indexPath.section].questions[indexPath.row]
    
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
      
      headerView.questionSet = session.questionSets[indexPath.section]
      
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
      
      viewController.question = session.questionSets[indexPath.section].questions[indexPath.row]
    default:
      break
    }
  }
  
  //  MARK: - Toolbar actions
  
  @objc func filterButtonTapped(_ toolbarItem: UIBarButtonItem) {
    presentFilterAlert(currentFilter: listingFilter,
                       animated: true) { filter in
      self.listingFilter = filter
    }
  }
}

extension SessionQuestionsOverviewCollectionViewController: UICollectionViewDelegateFlowLayout {
  //  MARK: - UICollectionViewFlowLayoutDelegate
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = UIScreen.main.bounds.size.width
    
    return CGSize(width: width / 3.00, height: width / 3.00)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return section != (numberOfSections(in: collectionView) - 1) ? CGSize.zero : CGSize(width: 50, height: 150)
  }
}

extension SessionQuestionsOverviewCollectionViewController: SessionQuestionsOverviewNavigationBarTitleViewDelegate {
  //  MARK: - SessionQuestionsOverviewNavigationBarTitleViewDelegate
  
  func titleViewSelected(_ titleView: SessionQuestionsOverviewNavigationBarTitleView) {
    performSegue(withIdentifier: "showSessionInformation", sender: titleView)
  }
}
