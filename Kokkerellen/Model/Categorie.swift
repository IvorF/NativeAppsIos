import Foundation
import RealmSwift

class Categorie: Object {
    @objc dynamic var titel: String = ""
    
    convenience init(cat: String) {
        self.init()
        self.titel = cat
    }
}
