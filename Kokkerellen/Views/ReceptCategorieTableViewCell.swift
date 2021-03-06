import UIKit
import RealmSwift

class ReceptCategorieTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblTitel: UILabel!
    
    var recepten: [Recept]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with categorie: Categorie) {
        lblTitel.text = categorie.titel
        
        //opvullen recept\\
        recepten = Array(try! Realm().objects(Recept.self))
        
        recepten = recepten.filter( { recept -> Bool in
            (recept.categorie.titel == categorie.titel && recept.image != UIImage(named: "1")!.pngData())
        } )
        
        if recepten.isEmpty {
            imgPhoto.image = UIImage(named: "1")
        } else {
            imgPhoto.image = UIImage(data: (recepten.first?.image)!)
        }
    }

}
