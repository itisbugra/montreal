import UIKit
import WebKit
import NSLogger

class OptionContentTableViewCell: UITableViewCell {
  static let identifier = "OptionCustomContent"
  
  @IBOutlet weak var enumeratorLabel: UILabel!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorEnclosureView: UIView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  var delegate: OptionCustomContentTableViewCellDelegate? = nil
  var option: Question.Option! {
    didSet {
      webView.loadHTMLString(HTML, baseURL: nil)
      reuseContentHeight()
    }
  }
  
  private var activityIndicatorEnclosureViewHeightConstraint: NSLayoutConstraint? = nil
  private var webViewHeightConstraint: NSLayoutConstraint? = nil
  
  private var loading = false {
    didSet {
      //  If value is not changed, return from the method
      if oldValue == loading {
        return
      }
      
      if loading {
        //  Activate the constraint for the activity indicator enclosure view
        activityIndicatorEnclosureViewHeightConstraint =
          activityIndicatorEnclosureView.heightAnchor.constraint(equalToConstant: 108)
        activityIndicatorEnclosureViewHeightConstraint!.priority = .required
        activityIndicatorEnclosureViewHeightConstraint!.isActive = true
        
        //  Remove the constraint for the web view if exists
        if let constraint = webViewHeightConstraint {
          webView.removeConstraint(constraint)
        }
      } else {
        activityIndicatorEnclosureView.removeConstraint(activityIndicatorEnclosureViewHeightConstraint!)
      }
      
      //  Set hidden properties of the subviews appropriately
      activityIndicatorEnclosureView.isHidden = !loading
      enumeratorLabel.isHidden = loading
      webView.isHidden = loading
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(option.content)
  }
  
  //  MARK: - UITableView cell reuse
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    webView.scrollView.backgroundColor = .clear
    webView.navigationDelegate = self
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
    
    loading = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    contentHeight = nil
    loading = true
  }
  
  //  MARK: - WKWebView render size caching
  
  private var contentHeight: CGFloat? = nil {
    didSet {
      if let height = contentHeight {
        RenderSizeCache.shared.set(renderSize: height, forHTML: HTML)
        
        //  Setup the constraint of the web view
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: height)
        webViewHeightConstraint!.priority = .required
        webViewHeightConstraint!.isActive = true
        
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
  
  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    guard let height = contentHeight else {
      return CGSize(width: targetSize.width, height: 128)
    }

    return CGSize(width: targetSize.width, height: height + 20)
  }
}

extension OptionContentTableViewCell: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
               didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("document.readyState") { (ready, error) in
      if self.contentHeight == nil {
        webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
          self.contentHeight = (height as! CGFloat) + 36.00
          
          Logger.shared.log(.view, .debug, "Option content for WKWebView has finished navigation with content length \(self.option.content.data.count) and calculated height \(self.contentHeight!).")
        }
      }
      
      self.loading = false
    }
  }
}

protocol OptionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: OptionContentTableViewCell, height: CGFloat)
}
