import UIKit
import WebKit
import NSLogger

class OptionContentTableViewCell: UITableViewCell {
  static let identifier = "OptionCustomContent"
  static let messageHandler = "contentResizingMessageHandler"
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorEnclosureView: UIView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var circleImageView: UIImageView!
  @IBOutlet weak var checkmarkImageView: UIImageView!
  @IBOutlet weak var questionMarkImageView: UIImageView!
  
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
      checkmarkImageView.isHidden = loading
      circleImageView.isHidden = loading
      questionMarkImageView.isHidden = loading
      webView.isHidden = loading
      
      webView.layoutIfNeeded()
      activityIndicatorEnclosureView.layoutIfNeeded()
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(option.content)
  }
  
  //  MARK: - UITableView cell reuse
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    webView.configuration.userContentController.add(self,
                                                    name: OptionContentTableViewCell.messageHandler)
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
    
    loading = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    webView.configuration.userContentController.removeScriptMessageHandler(forName: OptionContentTableViewCell.messageHandler)
    contentHeight = nil
    loading = true
  }
  
  //  MARK: - UITableView cell state
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      setMarked(false, animated: false)
    }
    
    UIView.animate(withDuration: animated ? 0.5 : 0.001) {
      self.circleImageView.alpha = selected ? 0 : 1
      self.questionMarkImageView.alpha = 0
      self.checkmarkImageView.alpha = selected ? 1 : 0
    }
  }
  
  func setMarked(_ marked: Bool, animated: Bool) {
    if marked {
      setSelected(false, animated: false)
    }
    
    UIView.animate(withDuration: animated ? 0.5 : 0.001) {
      self.circleImageView.alpha = marked ? 0 : 1
      self.questionMarkImageView.alpha = marked ? 1 : 0
      self.checkmarkImageView.alpha = 0
    }
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
        webView.layoutIfNeeded()
        
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

extension OptionContentTableViewCell: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
    guard
      message.name == OptionContentTableViewCell.messageHandler,
      contentHeight == nil else {
      return
    }
    
    let body = message.body as! [String : AnyObject]
    
    contentHeight = body["scrollHeight"] as! CGFloat + 30.00
    loading = false
    
    Logger.shared.log(.view, .debug, "Option content for WKWebView has finished navigation with content length \(option.content.data.count) and calculated height \(contentHeight!).")
  }
}

protocol OptionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: OptionContentTableViewCell, height: CGFloat)
}
