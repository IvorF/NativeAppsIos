import UIKit

class ShowReceptViewController: UIViewController {

    @IBOutlet weak var TxtTitel: UILabel!
    @IBOutlet weak var ImgFoto: UIImageView!
    @IBOutlet weak var txtIngredienten: UILabel!
    @IBOutlet weak var TxtBeschrijving: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let recept = recept {
            TxtTitel.text = recept.titel
            txtIngredienten.text = recept.ingredienten[0]
            TxtBeschrijving.text = recept.beschrijving
        }
    }
    
    var recept: Recept!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
