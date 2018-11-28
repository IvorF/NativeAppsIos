import Foundation
import RealmSwift

class Recept : Object {
    @objc dynamic var titel: String = ""
    var ingredienten = List<Ingredient>()
    @objc dynamic var beschrijving: String = ""
    @objc dynamic var categorie: Categorie!
    @objc dynamic var image: Data!
    @objc dynamic var favoriet: Bool = false
}
