import UIKit

class AddReceptTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var lblSave: UIBarButtonItem!
    @IBOutlet weak var txtNaam: UITextField!
    @IBOutlet weak var txtCategorie: UITextField!
    @IBOutlet weak var txtIngredient: UITextView!
    @IBOutlet weak var txtOmschrijving: UITextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBAction func btnPhoto(_ sender: UIButton) {
        //imagepicker\\
        let image = UIImagePickerController()
        image.delegate = self
        
        image.allowsEditing = false
        
        //actionsheet\\
        let actionSheet = UIAlertController(title: "foto bron", message: "vanwaar wilt u een foto kiezen?", preferredStyle: .actionSheet)
        
        //knoppen\\
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                image.sourceType = .camera
                //present\\
                self.present(image, animated: true, completion: nil)
            } else {
                print("camera niet beschikbaar")
            }

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Foto's", style: .default, handler: { (action:UIAlertAction) in
            image.sourceType = .photoLibrary
            //present\\
            self.present(image, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Annuleren", style: .cancel, handler: nil))
        
        //present\\
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //UIImagePickerControllerDelegate Methodes\\
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgPhoto.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    var recept: Recept!
    
    var selectedCategorie: String!
    
    let categorie = ["<< Kies categorie >>", CategorieType.hoofdgerecht.rawValue, CategorieType.voorgerecht.rawValue, CategorieType.dessert.rawValue, CategorieType.soep.rawValue, CategorieType.overige.rawValue,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //savebutton\\
        updateSaveButtonState()
        
        //picker\\
        maakCategoriePicker()
        createToolbar()
        
        //edit recept\\
        if let recept = recept {
            txtNaam.text = recept.titel
            txtCategorie.text = recept.categorie.rawValue
            
            let rec = recept.ingredienten
            
            for recept in rec {
                txtIngredient.text = recept + "\n"
            }
            
            txtOmschrijving.text = recept.beschrijving
            imgPhoto.image = UIImage(named: recept.image)
        }
    }
    
    //controleren textview\\
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
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
        let ingredientText = txtIngredient.text ?? ""
        let beschrijvingText = txtOmschrijving.text ?? ""
        let categorieText = txtCategorie.text ?? ""
        
        lblSave.isEnabled = !titeltext.isEmpty && !beschrijvingText.isEmpty && !ingredientText.isEmpty && !categorieText.isEmpty && !(categorieText == "<< Kies categorie >>") ? true:false
        
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
        ingredient.append(txtIngredient.text ?? "")
        let beschrijving = txtOmschrijving.text ?? ""
        let categorie = txtCategorie.text ?? ""
        let image = imgPhoto.image
        
        //////////////voorlopige vaste waarden\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        recept = Recept(titel: titel, ingredienten: ingredient, beschrijving: beschrijving, categorie: CategorieType(rawValue: categorie) ?? CategorieType.hoofdgerecht, image: "1", favoriet: false)
        
    }

    //Table view data source\\
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
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

//ad done button textfield\\
/*extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}*/
