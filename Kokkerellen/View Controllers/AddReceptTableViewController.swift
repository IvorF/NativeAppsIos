import UIKit
import RealmSwift

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
    
    //diplicate verwijderen\\
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    var oldRecept: Recept!
    var recept: Recept!
    
    var selectedCategorie: String!
    
    var categorie = ["<< Kies categorie >>"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //vul categorieen\\
        let cat = Array(try! Realm().objects(Categorie.self))
        for titel in cat {
            categorie.append(titel.titel)
        }
        
        //duplicaten verwijderen\\
        categorie = removeDuplicates(array: categorie)
        
        //savebutton\\
        updateSaveButtonState()
        
        //picker\\
        maakCategoriePicker()
        createToolbar()
        
        //edit recept\\
        if let recept = recept {
            oldRecept = recept
            txtNaam.text = recept.titel
            txtCategorie.text = recept.categorie.titel
            
            let rec = recept.ingredienten
            
            for recept in rec {
                txtIngredient.text = recept.titel + "\n"
            }
            
            txtOmschrijving.text = recept.beschrijving
            imgPhoto.image = UIImage(data: recept.image)
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
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    //recept doorgeven bij unwind\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        createRecipe()
    }
    
    //maken van recept\\
    private func createRecipe() {
        let titel = txtNaam.text ?? ""
        let ingredient = txtIngredient.text ?? ""
        let beschrijving = txtOmschrijving.text ?? ""
        let categorie = txtCategorie.text ?? ""
        let image = imgPhoto.image
        
        recept = Recept()
        recept.titel = titel
        recept.ingredienten.append(Ingredient(titel: ingredient))
        recept.beschrijving = beschrijving
        recept.categorie = Categorie(cat: categorie)
        if image != nil {
            recept.image = resizeImage(self.imgPhoto.image!, size: CGSize(width: 100, height: 100)).pngData()
        } else  {
            recept.image = UIImage(named: "1")!.pngData()
        }
    }
    
    //resize image\\
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

    //aantal secties\\
    override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }

    //aantal rijen\\
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

}
