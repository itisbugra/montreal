import UIKit
import WebKit

class QuestionContentCollectionViewCell: UICollectionViewCell {
  static let identifier = "QuestionContent"
  static let messageHandler = "contentResizingMessageHandler"
  
  @IBOutlet weak var webViewContainerView: UIView!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var tintView: UIView!
  @IBOutlet weak var accessoryImageView: UIImageView!
  
  //  MARK: - Internal cell state
  
  private var preparedForReuse = false
  
  //  MARK: - Data handling
  
  var question: Question! {
    didSet {
      reloadData()
      reloadCellState()
    }
  }
  
  private var HTML: String {
    let renderer = FormattedContentRenderer.shared
    
    return renderer.renderHTMLString(question.content)
  }
  
  //  MARK: - UICollectionView cell reuse
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    clipsToBounds = false
    contentView.clipsToBounds = false
    
    //  Configure the properties of the web view
    webView.navigationDelegate = self
    webView.configuration.userContentController.add(self,
                                                    name: QuestionContentCollectionViewCell.messageHandler)
    //  Configure the scroll view of the web view
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.scrollView.bounces = false
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    webViewContainerView.layer.shadowPath = nil
    webView.configuration.userContentController.removeScriptMessageHandler(forName: QuestionContentCollectionViewCell.messageHandler)
    loading = true
    preparedForReuse = true
    isSelected = false
  }
  
  //  MARK: - Cell state management
  
  private var loading = true {
    didSet {
      if loading {
        activityIndicatorView.startAnimating()
      } else {
        activityIndicatorView.stopAnimating()
        
        //  Draw the effects on the views
        drawShadowEffect()
      }
      
      webViewContainerView.isHidden = loading
      tintView.isHidden = loading
      accessoryImageView.isHidden = loading
    }
  }
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        webViewContainerView.layer.borderWidth = 2.00
        webViewContainerView.backgroundColor = .secondarySystemBackground
      } else {
        webViewContainerView.layer.borderWidth = .zero
        webViewContainerView.backgroundColor = .systemBackground
      }
    }
  }
  
  //  MARK: - Visual effects
  
  func drawShadowEffect() {
    let shadowRadius: CGFloat = 4.00
    webViewContainerView.layer.shadowRadius = shadowRadius
    webViewContainerView.layer.shadowOffset = CGSize(width: 0.00, height: 4.00)
    webViewContainerView.layer.shadowOpacity = 0.33
    
    let curveAmount: CGFloat = 4.50
    let width = webViewContainerView.frame.size.width
    let height = webViewContainerView.frame.size.height - 4.00
    let shadowPath = UIBezierPath()
    
    // The top left and right edges match our view, indented by the shadow radius
    shadowPath.move(to: CGPoint(x: shadowRadius, y: 0))
    shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: 0))
    
    // The bottom-right edge of our shadow should overshoot by the size of our curve
    shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: height + curveAmount))
    
    // The bottom-left edge also overshoots by the size of our curve, but is added with a curve back up towards the view
    shadowPath.addCurve(to: CGPoint(x: shadowRadius, y: height + curveAmount),
                        controlPoint1: CGPoint(x: width, y: height - shadowRadius),
                        controlPoint2: CGPoint(x: 0, y: height - shadowRadius))
    
    webViewContainerView.layer.shadowPath = shadowPath.cgPath
  }
  
  //  MARK: - Data management
  
  func reloadData() {
    webView.loadHTMLString(HTML, baseURL: Renderer.additionalResourcesURL)
  }
  
  func reloadCellState() {
    func retrieveImageViewConfiguration() -> (UIImage, UIColor)? {
      switch question.state {
      case .marked:
        return (UIImage(systemName: "questionmark.circle.fill")!, .systemOrange)
      case .answered:
        return (UIImage(systemName: "checkmark.circle.fill")!, .systemBlue)
      case .consolidated(result: .correct):
        return (UIImage(systemName: "checkmark.circle.fill")!, .systemGreen)
      case .consolidated(result: .incorrect):
        return (UIImage(systemName: "xmark.circle.fill")!, .systemRed)
      case .consolidated(result: .notMarked):
        return (UIImage(systemName: "minus.circle.fill")!, .systemYellow)
      default:
        return nil
      }
    }
    
    if let (image, color) = retrieveImageViewConfiguration() {
      tintView.backgroundColor = color
      accessoryImageView.image = image
      accessoryImageView.tintColor = color
      webViewContainerView.layer.borderColor = color.cgColor
    } else {
      tintView.backgroundColor = .clear
      accessoryImageView.image = nil
      webViewContainerView.layer.borderColor = UIColor.label.cgColor
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
