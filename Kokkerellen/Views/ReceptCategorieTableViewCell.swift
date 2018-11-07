import UIKit

class ReceptCategorieTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblTitel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with categorie: Categorie) {
        imgPhoto.image = UIImage(named: categorie.image)
        lblTitel.text = categorie.titel
    }

}
