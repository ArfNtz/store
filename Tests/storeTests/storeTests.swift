import XCTest
@testable import store

final class storeTests: XCTestCase {

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    
    func testExample() throws {
      // a model object
      class Memo : Codable {
          var content: String
          init(content: String) {
              self.content = content
          }
      }
      let content_file = "/home/fepineuse/fe/prg/store/textFile"
      // let content_file = "/Users/papa/fe/prg/store/textFile"
      let content = try String(contentsOf: URL(fileURLWithPath: content_file), encoding: .utf8)
      let m = Memo(content: content)

      // store the model
      let s = Store(path: "/home/fepineuse/fe/prg/store/")
      // let s = Store(path: "/Users/papa/fe/prg/store/")
      try s.add(object: m)

      // retrieve the last instance
      let m2 = s.get(type: Memo.self)

      XCTAssert(m2 != nil)
      if m2 != nil { print (m2!.content) }
    }

    
    static var allTests = [
        ("testExample", testExample),
    ]
}
