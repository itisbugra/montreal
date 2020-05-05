import Foundation

struct FormattedContent {
    enum MimeType {
        case PlainText
        case HTML(withMathJax: Bool = false)
        case Markdown
    }
    
    var data: String
    var mimeType: MimeType
}
