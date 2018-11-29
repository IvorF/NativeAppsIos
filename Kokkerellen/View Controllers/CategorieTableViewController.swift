import UIKit
import RealmSwift

class CategorieTableViewController: UITableViewController {
    var categorie: [Categorie] = []
    var recepten: [Recept]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categorie = removeDuplicates(array: Array(try! Realm().objects(Categorie.self)))
        
        recepten = Array(try! Realm().objects(Recept.self))
        
        //refreshcontrol\\
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = ref

        //edit button\\
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //refresh on appear\\
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    //refresh data tableview\\
    @objc private func refreshData() {
        categorie = removeDuplicates(array: Array(try! Realm().objects(Categorie.self)))
        recepten = Array(try! Realm().objects(Recept.self))
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //diplicate verwijderen\\
    func removeDuplicates(array: [Categorie]) -> [Categorie] {
        var encountered = Set<String>()
        var result: [Categorie] = []
        for value in array {
            if encountered.contains(value.titel) {
                //Do not add a duplicate element\\
            }
            else {
                //Add value to the set\\
                encountered.insert(value.titel)
                //Append the value\\
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
        //dialog met titel en message\\
        let alertController = UIAlertController(title: "Welke categorie wilt u toeveogen?", message: "Vul een categorie in", preferredStyle: .alert)
        
        //the confirm action taking the inputs\\
        let confirmAction = UIAlertAction(title: "Voeg toe", style: .default) { (_) in
            
            //getting the input values from user\\
            let categorie = alertController.textFields?[0].text

            self.categorie.append(Categorie(cat: categorie!))
            self.tableView.reloadData()
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(Categorie(cat: categorie!))
            }
            
            //refresh\\
            self.refreshData()
        }
        
        //the cancel action doing nothing\\
        let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box\\
        alertController.addTextField { (textField) in
            
        }
        
        //adding the action to dialogbox\\
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box\\
        self.present(alertController, animated: true, completion: nil)
    }
    
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

}
