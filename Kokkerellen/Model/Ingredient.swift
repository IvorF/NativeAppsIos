import Foundation
import RealmSwift

class Ingredient: Object {
    @objc dynamic var titel: String = ""
    
    convenience init(titel: String) {
        self.init()
        self.titel = titel
    }
}
