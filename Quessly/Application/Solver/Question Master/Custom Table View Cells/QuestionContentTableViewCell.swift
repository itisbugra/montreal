import UIKit
import WebKit
import NSLogger

class QuestionContentTableViewCell: UITableViewCell {
  static let identifier = "QuestionCustomContent"
  static let messageHandler = "contentResizingMessageHandler"
  
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
    
    webView.configuration.userContentController.add(self, name: QuestionContentTableViewCell.messageHandler)
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    webView.configuration.userContentController.removeScriptMessageHandler(forName: QuestionContentTableViewCell.messageHandler)
    contentHeight = nil
    loading = true
  }
  
  //  MARK: - WKWebView render size caching
  
  private var contentHeight: CGFloat? = nil {
    didSet {
      if let height = contentHeight {
        RenderSizeCache.shared.set(renderSize: height, forHTML: HTML)
        
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
      activityIndicatorEnclosureView.isHidden = !loading
      webView.isHidden = loading
    }
  }
}

extension QuestionContentTableViewCell: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
    guard
      message.name == QuestionContentTableViewCell.messageHandler,
      contentHeight == nil else {
      return
    }
    
    let body = message.body as! [String : CGFloat]
    
    contentHeight = body["scrollHeight"]
    loading = false
    
    Logger.shared.log(.view, .debug, "Question content for WKWebView has finished navigation with content length \(question.content.data.count) and calculated height \(contentHeight!).")
  }
}

protocol QuestionCustomContentTableViewCellDelegate {
  func didFinishRenderingContent(_ cell: QuestionContentTableViewCell, height: CGFloat)
}
