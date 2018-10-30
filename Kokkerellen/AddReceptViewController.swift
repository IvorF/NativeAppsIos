import UIKit

class AddReceptViewController: UIViewController {

    @IBOutlet weak var TxtTitel: UITextField!
    @IBOutlet weak var TxtIngredient: UITextField!
    @IBOutlet weak var TxtBeschrijving: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateSaveButtonState()
    }
    
    //controleren of alles velden zijn ingevuld\\
    func updateSaveButtonState() {
        let titeltext = TxtTitel.text ?? ""
        let ingredientText = TxtIngredient.text ?? ""
        let beschrijvingText = TxtBeschrijving.text ?? ""
        
        saveButton.isEnabled = !titeltext.isEmpty && !ingredientText.isEmpty && !beschrijvingText.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let titel = TxtTitel.text ?? ""
        let ingredient = TxtIngredient.text ?? ""
        let beschrijving = TxtBeschrijving.text ?? ""
        
        recept = Recept(titel: titel, ingredienten: ingredient, beschrijving: beschrijving)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
