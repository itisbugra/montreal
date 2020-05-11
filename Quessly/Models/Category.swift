import UIKit

class Category {
  let id: Int
  let parent: Category?
  let name: String
  let description: String?
  
  init(id: Int, parent: Category?, name: String, description: String?) {
    self.id = id
    self.parent = parent
    self.name = name
    self.description = description
  }
}
