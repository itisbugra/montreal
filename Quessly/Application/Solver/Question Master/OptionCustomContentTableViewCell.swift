import UIKit
import WebKit

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
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(option.content)
  }
  
  private var loadingCompleted = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    webView.scrollView.backgroundColor = .clear
    webView.navigationDelegate = self
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
}

extension OptionContentTableViewCell: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if loadingCompleted {
      return
    }
    
    webView.evaluateJavaScript("document.readyState") { (ready, error) in
      if ready != nil {
        webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
          let calculatedHeight = (height as! CGFloat) + 24.00
          
          print("[WKWebView rendering]", self.option.content.data.count, calculatedHeight)
          
          let constraint = webView.heightAnchor.constraint(equalToConstant: calculatedHeight)
          constraint.priority = .required
          constraint.isActive = true
          
          self.activityIndicatorEnclosureView.removeFromSuperview()
          self.enumeratorLabel.alpha = 1.00
          self.webView.alpha = 1.00
          self.delegate?.didRenderContent(self, height: calculatedHeight)
          
          self.loadingCompleted = true
        }
      }
    }
  }
}

protocol OptionCustomContentTableViewCellDelegate {
  func didRenderContent(_ cell: OptionContentTableViewCell, height: CGFloat)
}
