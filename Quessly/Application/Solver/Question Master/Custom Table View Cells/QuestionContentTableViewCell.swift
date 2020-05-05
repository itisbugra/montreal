import UIKit
import WebKit
import NSLogger

class QuestionContentTableViewCell: UITableViewCell {
  static let identifier = "QuestionCustomContent"
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorEnclosureView: UIView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  var delegate: QuestionCustomContentTableViewCellDelegate? = nil
  var question: Question! {
    didSet {
      webView.loadHTMLString(HTML, baseURL: nil)
      reuseContentHeight()
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(question.content)
  }
  
  //  MARK: - UITableView cell reuse
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    webView.scrollView.backgroundColor = .clear
    webView.navigationDelegate = self
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    contentHeight = nil
    loading = true
  }
  
  //  MARK: - WKWebView render size caching
  
  private var webViewHeightConstraint: NSLayoutConstraint? = nil
  private var contentHeight: CGFloat? = nil {
    didSet {
      if let height = contentHeight {
        RenderSizeCache.shared.set(renderSize: height, forHTML: HTML)
        
        if let constraint = self.webViewHeightConstraint {
          constraint.constant = height
        } else {
          let constraint = self.webView.heightAnchor.constraint(equalToConstant: height)
          constraint.priority = .required
          
          self.webViewHeightConstraint = constraint
        }
        
        self.webViewHeightConstraint!.isActive = true
        
        delegate?.didFinishRenderingContent(self, height: height)
      }
    }
  }
  
  private func reuseContentHeight() {
    let height = RenderSizeCache.shared.renderSize(forHTML: HTML)
    
    if let height = height {
      Logger.shared.log(.view, .debug, "Reusing content height for content with hash value \(HTML.hashValue) as \(height).")
    } else {
      Logger.shared.log(.view, .debug, "Content height cache miss for content with hash value \(HTML.hashValue).")
    }
    
    contentHeight = height
  }
  
  //  MARK: - UI state
  
  private var loading = true {
    didSet {
      self.activityIndicatorEnclosureView.isHidden = !loading
      self.activityIndicatorEnclosureView.constraints.forEach { $0.isActive = loading }
      self.webView.isHidden = loading
      
      if loading, let constraint = self.webViewHeightConstraint {
        constraint.isActive = false
      }
    }
  }
}

extension QuestionContentTableViewCell: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
               didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("document.readyState") { (ready, error) in
      if self.contentHeight == nil {
        webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
          self.contentHeight = (height as! CGFloat) + 20.00
          
          Logger.shared.log(.view, .debug, "Question content for WKWebView has finished navigation with content length \(self.question.content.data.count) and calculated height \(self.contentHeight!).")
        }
      }
      
      self.loading = false
    }
  }
}

protocol QuestionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: QuestionContentTableViewCell, height: CGFloat)
}
