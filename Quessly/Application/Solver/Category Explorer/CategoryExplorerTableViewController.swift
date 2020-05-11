import UIKit
import PromiseKit

class CategoryExplorerTableViewController: UITableViewController {
  private let categoryRepository = FakeCategoryRepository.shared
  
  private(set) var categories: [Category]? = nil
  private(set) var history: [Category]? = nil
  private(set) var error: Error? = nil
  
  private(set) var filteredCategories: [Category]? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    navigationItem.searchController?.searchBar.placeholder = "Search categories"
    
    when(fulfilled: categoryRepository.all(), categoryRepository.history())
      .done { (all, history) in
        self.categories = all
        self.history = history
        
        self.tableView.reloadData()
      }
      .catch { self.error = $0 }
  }
  
  //  MARK: - UITableView data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return filteredCategories != nil ? 1 : 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let filteredCategories = filteredCategories {
      return filteredCategories.count
    }
    
    if let categories = categories, let history = history {
      switch section {
      case 0:
        return history.count
      case 1:
        return categories.count
      default:
        return 0
      }
    }
    
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "category")!
    
    if let filteredCategories = filteredCategories {
      cell.textLabel!.text = filteredCategories[indexPath.row].name
    } else {
      switch indexPath.section {
      case 0:
        cell.textLabel!.text = history![indexPath.row].name
      case 1:
        cell.textLabel!.text = categories![indexPath.row].name
      default:
        break
      }
    }
    
    return cell
  }
  
  //  MARK: - UITableView section handling
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if filteredCategories != nil {
      return "Search results"
    }
    
    switch section {
    case 0:
      return "History"
    case 1:
      return "Categories"
    default:
      return nil
    }
  }
}

extension CategoryExplorerTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    defer {
      tableView.reloadData()
    }
    
    guard let text = searchController.searchBar.text, !text.isEmpty else {
      filteredCategories = nil
      
      return
    }
    
    filteredCategories = categories!.filter { $0.name.contains(text) }
  }
}
