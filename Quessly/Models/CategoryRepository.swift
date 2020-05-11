import UIKit
import Fakery
import PromiseKit

protocol CategoryAccessible {
  func all(favorite: Bool?) -> Promise<[Category]>
}

class FakeCategoryRepository: CategoryAccessible {
  static public let shared = FakeCategoryRepository()
  
  static private let count = 20
  static private let historyCount = 5
  
  let categories: [Category]
  
  init() {
    let faker = Faker()
    
    self.categories = (1...FakeCategoryRepository.count).map { Category(id: $0, parent: nil, name: faker.cat.breed(), description: nil) }
  }
  
  func all(favorite: Bool? = nil) -> Promise<[Category]> {
    return Promise.value(categories)
  }
  
  func history() -> Promise<[Category]> {
    return Promise.value(Array(categories.prefix(FakeCategoryRepository.historyCount)))
  }
}
