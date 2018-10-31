import UIKit

class AddReceptViewController: UIViewController {
    
    var recept: Recept!
    
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
        
        if saveButton.isEnabled {
            createRecipe();
        }
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    //maken van recept\\
    private func createRecipe() {
        let titel = TxtTitel.text ?? ""
        
        var ingredient: [String] = []
        
        ingredient.append(TxtIngredient.text ?? "")
        let beschrijving = TxtBeschrijving.text ?? ""
        
        //////////////voorlopige vaste waarden\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        recept = Recept(titel: titel, ingredienten: ingredient, beschrijving: beschrijving, categorie: CategorieType.dessert, image: "4")
        
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
