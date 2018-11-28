import UIKit
import RealmSwift

class CategorieTableViewController: UITableViewController {
    var categorie: [Categorie] = []
    var recepten: [Recept]!
//    var categorie: [Categorie] = [
//        Categorie(cat: CategorieType.voorgerecht.rawValue),
//        Categorie(cat: CategorieType.hoofdgerecht.rawValue),
//        Categorie(cat: CategorieType.soep.rawValue),
//        Categorie(cat: CategorieType.dessert.rawValue),
//        Categorie(cat: CategorieType.overige.rawValue)
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categorie = removeDuplicates(array: Array(try! Realm().objects(Categorie.self)))
        
        recepten = Array(try! Realm().objects(Recept.self))
        
        //refreshcontrol\\
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = ref

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //edit button navigation bar\\
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //refresh data tableview\\
    @objc private func refreshData() {
        categorie = removeDuplicates(array: Array(try! Realm().objects(Categorie.self)))
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //diplicate verwijderen\\
    func removeDuplicates(array: [Categorie]) -> [Categorie] {
        var encountered = Set<String>()
        var result: [Categorie] = []
        for value in array {
            if encountered.contains(value.titel) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value.titel)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    //nieuwe categorie toevoegen
    @IBAction func addClicked(_ sender: Any) {
        showInputDialog()
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Welke categorie wilt u toeveogen?", message: "Vul een categorie in", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Voeg toe", style: .default) { (_) in
            
            //getting the input values from user
            let categorie = alertController.textFields?[0].text

            self.categorie.append(Categorie(cat: categorie!))
            self.tableView.reloadData()
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(Categorie(cat: categorie!))
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source
    //prepare segue voor categorie recept\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategorie" {
            let indexPath = tableView.indexPathForSelectedRow!
            let cat = categorie[indexPath.row]
            let receptenTableViewController = segue.destination as! ReceptenTableViewController
            
            receptenTableViewController.cat = cat
        }
    }

    //aantal secties\\
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //aantal cellen\\
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categorie.count
        } else {
            return 0
        }
    }

    //vullen van de cellen\\
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeue cell\\
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorieCell", for: indexPath) as! ReceptCategorieTableViewCell

        //fetch model object to display\\
        let cat = categorie[indexPath.row]
        
        // Configure cell\\
        cell.update(with: cat)
        cell.showsReorderControl = true

        //return cell\\
        return cell
    }
    
    //hoogte cell\\
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //verplaatsen van recepten naar andere cell\\
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedCategorie = categorie.remove(at: fromIndexPath.row)
        categorie.insert(movedCategorie, at: to.row)
        tableView.reloadData()
    }
    
    //delete knop wordt niet getoond\\
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
    
    //verwijderen van recepten\\
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var del:Bool = true
            
            for recept in recepten {
                print(recept.categorie.titel + "CAT: " + categorie[indexPath.row].titel)
                if recept.categorie.titel == categorie[indexPath.row].titel {
                    del = false
                }
            }
            
            if del {
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(categorie[indexPath.row])
                }
                
                categorie.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let alertController = UIAlertController(title: "Deze categorie kan niet verwijderd worden, deze bevat recepten.", message: "", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (_) in })
                
                self.present(alertController, animated: true, completion: nil)
                
            }
  
        }
    }

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
