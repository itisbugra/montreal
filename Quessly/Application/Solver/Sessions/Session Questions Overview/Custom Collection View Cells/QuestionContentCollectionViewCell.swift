import UIKit
import WebKit

class QuestionContentCollectionViewCell: UICollectionViewCell {
  static let identifier = "QuestionContent"
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  //  MARK: - Data handling
  
  var question: Question! {
    didSet {
      webView.loadHTMLString(HTML, baseURL: nil)
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(question.content)
  }
  
  //  MARK: - UICollectionView cell reuse
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    webView.navigationDelegate = self
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    loading = true
  }
  
  //  MARK: - Cell state management
  
  private var loading = true {
    didSet {
      if loading {
        activityIndicatorView.startAnimating()
      } else {
        activityIndicatorView.stopAnimating()
      }
      
      webView.isHidden = loading
    }
  }
  
  override var isSelected: Bool {
    didSet {
      webView.backgroundColor = isSelected ? .secondarySystemBackground : .clear
    }
  }
}

extension QuestionContentCollectionViewCell: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
               didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("document.readyState") { (ready, error) in
      self.loading = false
    }
  }
}
