import Foundation
import PromiseKit

protocol SessionAccessible: class {
  func one() -> Promise<Session>
}

class FakeSessionRepository: SessionAccessible {
  static let shared = FakeSessionRepository()
  
  func one() -> Promise<Session> {
    let fileManager = FileManager.default
    let urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "Question Resources")!
    let questionSets = urls
      .map { url -> QuestionSet in
        let setOffset = url.lastPathComponent.hashValue
        let questionDirectories = try! fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        
        let questions = questionDirectories
          .sorted { Int($0.lastPathComponent)! < Int($1.lastPathComponent)! }
          .map { directoryURL -> Question in
          let questionOffset = Int(directoryURL.lastPathComponent)!
          let contents = try! fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
          
          let options = contents
            .filter { $0.lastPathComponent.hasPrefix("Option") }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
            .map { Question.Option(id: Int(arc4random()),
                                   content: FormattedContent(data: try! String(contentsOf: $0),
                                                             mimeType: .HTML(withMathJax: true))) }
          let question = Question(id: setOffset + questionOffset,
                                  content: FormattedContent(data: try! String(contentsOf: contents.first { $0.lastPathComponent == "Question.html" }!),
                                                            mimeType: .HTML(withMathJax: true)),
                                  options: options)
          
          return question
        }
        
        let questionSet = QuestionSet(id: url.hashValue, name: url.lastPathComponent, questions: questions)
        
        return questionSet
    }
    
    return Promise.value(Session(questionSets: questionSets))
  }
}
