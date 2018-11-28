import UIKit
import RealmSwift

class ShowReceptTableViewController: UITableViewController {

    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblIngredienten: UILabel!
    @IBOutlet weak var lblBeschrijving: UILabel!
    @IBOutlet weak var btnFavorienten: UIButton!
    
    //toeveogen aan favorieten/verwijderen\\
    @IBAction func btnFavorietenClicked(_ sender: Any) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "titel = %@", recept.titel)
        let rec = realm.objects(Recept.self).filter(predicate).first
        
        
        if recept.favoriet {
            recept.favoriet = false
            btnFavorienten.setTitle("Voeg toe aan favorieten", for: .normal)
            
            try! realm.write {
                rec!.favoriet = false
            }
        } else {
            recept.favoriet = true
            btnFavorienten.setTitle("Verwijder uit favorieten", for: .normal)
            
            try! realm.write {
                rec!.favoriet = true
            }
        }
    }
    
    var recept: Recept!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //recept invoegen\\
        if let recept = recept {
            lblTitel.text = recept.titel
            
            for ingredient in recept.ingredienten {
                lblIngredienten.text = lblIngredienten.text! + "\n" + ingredient.titel
            }

            lblBeschrijving.text = "\n" + recept.beschrijving
            imgPhoto.image = UIImage(data: recept.image)
        }
    }

    //aantal secties\\
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //aantal rijen\\
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //hoogte cell\\
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //recept doorgeven bij edit\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //edit recept\\
        if segue.identifier == "editRecept" {
            let addReceptViewController = segue.destination as! AddReceptTableViewController
            
            addReceptViewController.recept = recept
        }
    }

}
