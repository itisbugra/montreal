import UIKit
import WebKit
import NSLogger

class MathJaxSmokeTestViewController: UIViewController {
  @IBOutlet weak var webView: WKWebView!
  weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    
    defer {
      self.activityIndicator = activityIndicator
    }
    
    let contentURL = Bundle.main.url(forResource: "smoke-test", withExtension: "html")!
    let request = URLRequest(url: contentURL)
    
    webView.navigationDelegate = self
    webView.load(request)
    
    Logger.shared.log(.view, .info, "Loading local URL on web view with MathJax content.", contentURL.description)
  }
}

extension MathJaxSmokeTestViewController : WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    assert(webView == self.webView)
    
    activityIndicator.stopAnimating()
    
    Logger.shared.log(.view, .info, "URL loaded on web view with MathJax content.")
  }
}
