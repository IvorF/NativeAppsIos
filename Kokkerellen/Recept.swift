import Foundation

class Recept {
    var titel: String
    var ingredienten: [String]
    var beschrijving: String
    var categorie: CategorieType
    var image: String
    
    init(titel: String, ingredienten: [String], beschrijving: String, categorie: CategorieType, image: String) {
        self.titel = titel
        self.ingredienten = ingredienten
        self.beschrijving = beschrijving
        self.categorie = categorie
        self.image = image
    }
}
