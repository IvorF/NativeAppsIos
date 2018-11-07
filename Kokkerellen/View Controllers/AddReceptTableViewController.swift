import UIKit

class AddReceptTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lblSave: UIBarButtonItem!
    @IBOutlet weak var txtNaam: UITextField!
    @IBOutlet weak var txtCategorie: UITextField!
    @IBOutlet weak var txtIngredienten: UITextField!
    @IBOutlet weak var txtOmschrijving: UITextField!
    
    var recept: Recept!
    
    var selectedCategorie: String!
    
    let categorie = [CategorieType.hoofdgerecht.rawValue, CategorieType.voorgerecht.rawValue, CategorieType.dessert.rawValue, CategorieType.soep.rawValue, CategorieType.overige.rawValue,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //savebutton\\
        updateSaveButtonState()
        
        //picker\\
        maakCategoriePicker()
        createToolbar()

    }
    
    //maak picker\\
    func maakCategoriePicker() {
        let categoriePicker = UIPickerView()
        txtCategorie.inputView = categoriePicker
        categoriePicker.delegate = self
    }
    
    //aantal componenten picker\\
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //aantal rijen picker\\
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorie.count
        
    }
    
    //inhoud picker\\
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorie[row]
    }
    
    //toolbar picker\\
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        txtCategorie.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //upvullen textfield\\
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategorie = categorie[row]
        txtCategorie.text = selectedCategorie
    }
    
    //controleren of alles velden zijn ingevuld\\
    func updateSaveButtonState() {
        let titeltext = txtNaam.text ?? ""
        let ingredientText = txtIngredienten.text ?? ""
        let beschrijvingText = txtOmschrijving.text ?? ""
        
        lblSave.isEnabled = !titeltext.isEmpty && !ingredientText.isEmpty && !beschrijvingText.isEmpty
        
        if lblSave.isEnabled {
            createRecipe();
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    
    //maken van recept\\
    private func createRecipe() {
        let titel = txtNaam.text ?? ""
        
        var ingredient: [String] = []
        
        ingredient.append(txtIngredienten.text ?? "")
        let beschrijving = txtOmschrijving.text ?? ""
        
        //////////////voorlopige vaste waarden\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        recept = Recept(titel: titel, ingredienten: ingredient, beschrijving: beschrijving, categorie: CategorieType.dessert, image: "1")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
