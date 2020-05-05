import UIKit
import Down
import Mustache
import NSLogger

class FormattedContentRenderer {
  static let shared = FormattedContentRenderer()
  static let template: Template = {
    return try! Template(named: "WKWrapper",
                         bundle: Bundle.main,
                         templateExtension: "html",
                         encoding: .utf8)
  }()
  
  private func render(data: String, enableMathJax: Bool = false) -> String {
    let template = FormattedContentRenderer.template
    let renderingParameters = ["content": data, "mathJaxEnabled": enableMathJax] as [String : Any]
    
    Logger.shared.log(.service, .info, "Rendering formatted content \(renderingParameters.description.hashValue).")
    
    return try! template.render(renderingParameters)
  }
  
  func renderHTMLString(_ content: FormattedContent) -> String {
    switch content.mimeType {
    case .PlainText:
      let embed = "<p>\(content.data)</p>"
      
      return render(data: embed)
    case .HTML(let withMathJax):
      let embed = content.data
      
      return render(data: embed, enableMathJax: withMathJax)
    case .Markdown:
      let down = Down(markdownString: content.data)
      let embed = try! down.toHTML()
      
      return render(data: embed)
    }
  }
}
