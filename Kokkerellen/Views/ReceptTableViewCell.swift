import UIKit

class ReceptTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var lblCategorie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //update view\\
    func update(with recept: Recept) {
        photo.image = UIImage(data: recept.image)
        lblTitel.text = recept.titel
        lblCategorie.text = recept.categorie.titel
    }

}
