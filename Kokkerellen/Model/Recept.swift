import Foundation
import RealmSwift

class Recept : Object/*: NSObject, NSCoding*/ {
    @objc dynamic var titel: String = ""
    var ingredienten = List<Ingredient>()
    @objc dynamic var beschrijving: String = ""
    var categorie: Categorie!
    @objc dynamic var image: Data!
    @objc dynamic var favoriet: Bool = false
    
    //url archief\\
//    static var archiveURL: URL {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
//        let result = documentsDirectory.appendingPathComponent("recepten")
//        return result
//    }
    
//    convenience init(titel: String, beschrijving: String, image: UIImage, favoriet: Bool) {
//        self.init()
//        self.titel = titel
//        self.beschrijving = beschrijving
//        self.image = image
//        self.favoriet = favoriet
//    }
    
//    struct PropertyKeys {
//        static let titel = "titel"
//        static let ingredienten = "ingredienten"
//        static let beschrijving = "beschrijving"
//        static let categorie = "categorie"
//        static let image = "image"
//        static let favoriet = "favoriet"
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard
//            let titel = aDecoder.decodeObject(forKey: PropertyKeys.titel) as? String,
//            let ingredienten = aDecoder.decodeObject(forKey: PropertyKeys.ingredienten) as? [String],
//            let beschrijving = aDecoder.decodeObject(forKey: PropertyKeys.beschrijving) as? String,
//            let categorie = aDecoder.decodeObject(forKey: PropertyKeys.categorie) as? String,
//            let image = aDecoder.decodeObject(forKey: PropertyKeys.image) as? String,
//            let favoriet = aDecoder.decodeObject(forKey: PropertyKeys.favoriet) as? Bool
//            else { return nil }
//        self.init(titel: titel, ingredienten: ingredienten, beschrijving: beschrijving, categorie: categorie, image: image, favoriet: favoriet)
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(titel, forKey: PropertyKeys.titel)
//        aCoder.encode(ingredienten, forKey: PropertyKeys.ingredienten)
//        aCoder.encode(beschrijving, forKey: PropertyKeys.beschrijving)
//        aCoder.encode(categorie, forKey: PropertyKeys.categorie)
//        aCoder.encode(image, forKey: PropertyKeys.image)
//        aCoder.encode(favoriet, forKey: PropertyKeys.favoriet)
//    }
//    
//    static func saveToFile(recepten: [Recept]) {
//        NSKeyedArchiver.archiveRootObject(recepten, toFile: Recept.archiveURL.path)
//    }
//    
//    static func loadFromFile() -> [Recept]? {
//        let result = NSKeyedUnarchiver.unarchiveObject(withFile: Recept.archiveURL.path) as? [Recept]
//        return result
//    }
    
//    static func loadSampleRecepten() -> [Recept] {
//        let recepten: [Recept] = [
//            Recept(titel: "Eieren met spek", ingredienten: ["3 eieren"], beschrijving: "Zet de pan op het vuur, gooi de eieren in de pan. Zet het vuur zo hoog mogelijk tot de eieren klaar zijn. Smakelijk!", categorie: .overige, image: "4", favoriet: false),
//            Recept(titel: "Boterham met kaas", ingredienten: ["1 boterham", "1 schel kaas"], beschrijving: "Pak het schelletje kaas en leg dit op de boterham. Plooi de boterham in 2. Smakelijk!", categorie: .hoofdgerecht, image: "3", favoriet: false),
//            Recept(titel: "Eieren met spek 2", ingredienten: ["3 eieren"], beschrijving: "Zet de pan op het vuur, gooi de eieren in de pan. Zet het vuur zo hoog mogelijk tot de eieren klaar zijn. Smakelijk!", categorie: .hoofdgerecht, image: "4", favoriet: false),
//            Recept(titel: "TomatenSoep", ingredienten: ["tomaten","water"], beschrijving: "kiep alles bij elkaar en laat 7 uur koken. Smakelijk!", categorie: .soep, image: "2", favoriet: false),
//            Recept(titel: "Boterham met kaas, salami en groenten", ingredienten: ["1 boterham", "1 schel kaas"], beschrijving: "Pak het schelletje kaas en leg dit op de boterham. Plooi de boterham in 2. Smakelijk!", categorie: .hoofdgerecht, image: "3", favoriet: true)]
//
//        return recepten
//    }
}
