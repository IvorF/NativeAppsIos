import Foundation

class Recept {
    var titel: String
    var ingredienten: [String]
    var beschrijving: String
    
    
    init(titel: String, ingredienten: [String], beschrijving: String) {
        self.titel = titel
        self.ingredienten = ingredienten
        self.beschrijving = beschrijving
    }
}
