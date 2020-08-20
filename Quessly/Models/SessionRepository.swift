import Foundation
import PromiseKit

protocol SessionAccessible: class {
  func one(consolidated: Bool) -> Promise<Session>
}

class FakeSessionRepository: SessionAccessible {
  static let shared = FakeSessionRepository()
  
  func one(consolidated: Bool) -> Promise<Session> {
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
            
            if consolidated {
              switch (arc4random() % 3) {
              case 0:
                question.state = .consolidated(result: .correct(answered: options.randomElement()!))
              case 1:
                question.state = .consolidated(result: .incorrect(answered: options.randomElement()!,
                                                                  correctOption: options.randomElement()!))
              case 2:
                question.state = .consolidated(result: .notMarked(correctOption: options.randomElement()!))
              default:
                break
              }
            } else {
              switch (arc4random() % 3) {
              case 0:
                question.state = .unseen
              case 1:
                question.state = .marked(options: [Question.Option]())
              case 2:
                question.state = .answered(option: options.randomElement()!)
              default:
                break
              }
            }
            
            return question
        }
        
        let questionSet = QuestionSet(id: url.hashValue, name: url.lastPathComponent, questions: questions)
        
        return questionSet
    }
    
    let session = Session(id: 1,
                          name: LocalizedString(localized: "Full Exam Coverage", locale: .current),
                          questionSets: questionSets,
                          contentAvailableAt: Date().addingTimeInterval(2000),
                          startingAt: Date().addingTimeInterval(5000),
                          endingAt: Date().addingTimeInterval(10000))
    
    return Promise.value(session)
  }
}
