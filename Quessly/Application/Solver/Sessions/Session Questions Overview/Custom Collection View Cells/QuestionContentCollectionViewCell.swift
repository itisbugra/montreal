import UIKit
import WebKit

class QuestionContentCollectionViewCell: UICollectionViewCell {
  static let identifier = "QuestionContent"
  static let messageHandler = "contentResizingMessageHandler"
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  //  MARK: - Internal cell state
  
  private var preparedForReuse = false
  
  //  MARK: - Data handling
  
  var question: Question! {
    didSet {
      webView.loadHTMLString(HTML, baseURL: Renderer.additionalResourcesURL)
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
    webView.configuration.userContentController.add(self,
                                                    name: QuestionContentCollectionViewCell.messageHandler)
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    webView.configuration.userContentController.removeScriptMessageHandler(forName: QuestionContentCollectionViewCell.messageHandler)
    loading = true
    preparedForReuse = true
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
    if preparedForReuse {
      self.loading = false
    }
  }
}

extension QuestionContentCollectionViewCell: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
    guard message.name == QuestionContentCollectionViewCell.messageHandler else {
      return
    }
    
    loading = false
  }
}
