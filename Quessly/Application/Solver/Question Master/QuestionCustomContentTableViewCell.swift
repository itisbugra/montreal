import UIKit
import WebKit

class QuestionContentTableViewCell: UITableViewCell {
  static let identifier = "QuestionCustomContent"
  
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorEnclosureView: UIView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  var delegate: QuestionCustomContentTableViewCellDelegate? = nil
  var question: Question! {
    didSet {
      webView.loadHTMLString(HTML, baseURL: nil)
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(question.content)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    webView.scrollView.backgroundColor = .clear
    webView.navigationDelegate = self
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
}

extension QuestionContentTableViewCell: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("document.readyState") { (ready, error) in
      if ready != nil {
        webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
          let calculatedHeight = (height as! CGFloat) + 24.00
          
          let constraint = webView.heightAnchor.constraint(equalToConstant: calculatedHeight)
          constraint.priority = .required
          constraint.isActive = true
          
          self.activityIndicatorEnclosureView?.removeFromSuperview()
          self.webView?.alpha = 1.00
          self.delegate?.didRenderContent(self, height: calculatedHeight)
        }
      }
    }
  }
}

protocol QuestionCustomContentTableViewCellDelegate {
  func didRenderContent(_ cell: QuestionContentTableViewCell, height: CGFloat)
}
