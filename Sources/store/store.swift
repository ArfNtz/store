import Foundation

public class Store {
    
    private static let ENCODING = String.Encoding.utf8
    private static let INSTANCE_SEPARATOR = "\n".data(using: Store.ENCODING)!
    private var path: String

    public init(path: String) {
        self.path = path
    }

    // store an instance
    public func add<T:Codable> (object: T) throws {
        let into = self.path + String(describing: type(of: object))
        if !FileManager.default.fileExists(atPath: into) {
            FileManager.default.createFile(atPath: into, contents: nil)
        }
        guard let fh = FileHandle(forWritingAtPath: into) else { return }
        fh.seekToEndOfFile()
        fh.write(Store.INSTANCE_SEPARATOR)
        fh.write(try JSONEncoder().encode(object))
        fh.closeFile()
    }

    // retrieve the last instance of data
    public func get<T : Codable> (type: T.Type) -> T? {
        let from = self.path + String(describing: type)
        guard let fh = FileHandle(forReadingAtPath: from) else { return nil }
        var p = fh.seekToEndOfFile()
        var found_separator = false
        var data = Data()
        var d:Data
        while p > 0 && !found_separator {
            d = fh.readData(ofLength: 1)
//            print( String(data: d, encoding: Store.ENCODING) )
            if d.first != nil {
                if d == Store.INSTANCE_SEPARATOR {
                    found_separator = true
//                    print("FOUND ONE")
                } else {
                    data.insert(d.first!, at: 0)
//                    print( String(data: data, encoding: Store.ENCODING))
                }
            }
            p -= 1
            fh.seek(toFileOffset: p)
            d = fh.readData(ofLength: 1)
        }
        fh.closeFile()
//        print( String(data: data, encoding: Store.ENCODING))
        do {
            let m = try JSONDecoder().decode(T.self, from: data)
            return m
        } catch {
            return nil
        }
    }
}
