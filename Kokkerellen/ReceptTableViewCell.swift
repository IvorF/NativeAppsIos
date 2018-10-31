import UIKit

class ReceptTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var lblCategorie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with recept: Recept) {
        photo.image = UIImage(named: recept.image)
        lblTitel.text = recept.titel
        lblCategorie.text = recept.categorie.rawValue
    }

}
