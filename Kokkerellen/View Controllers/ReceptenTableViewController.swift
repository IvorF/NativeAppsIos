import UIKit
import RealmSwift

class ReceptenTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recepten: [Recept]!
    
    var filteredRecepten: [Recept]!
    var cat: Categorie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refreshcontrol\\
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = ref
        
        //opvullen recepten\\
        recepten = Array(try! Realm().objects(Recept.self))
        
        
        //tonen recepten van juiste categorie\\
        filterRecept()
        
        //zoeken op recept\\
        filteredRecepten = Array(recepten)
        setUpSearchBar()
        
        //placeholder zoekbalk\\
        alterLayout()
        
        //Realm databank pad\\
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    //refresh data tableview\\
    @objc private func refreshData() {
        recepten = Array(try! Realm().objects(Recept.self))
        filterRecept()
        filteredRecepten = Array(recepten)
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //filter recepten\\
    private func filterRecept() {
        guard (cat != nil) else { return }

        recepten = recepten.filter( { recept -> Bool in
            (recept.categorie.titel == cat.titel)
        } )

        print(recepten)
    }
    
    //searchbar\\
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { /*filteredRecepten = recepten;*/
            tableView.reloadData()
            return}
        filteredRecepten = recepten.filter( { recept -> Bool in
            recept.titel.lowercased().contains(searchText.lowercased())
        } )
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func alterLayout() {
        searchBar.placeholder = "Zoek naar een recept"
    }
    
    //unwind segue, als save opslaan\\
    @IBAction func unwindToReceptTableViewWithSegue(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as? AddReceptTableViewController
        
        if let recept = sourceViewController?.recept {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                recepten[selectedIndexPath.row] = recept
                filteredRecepten = recepten;
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                //update recept\\
                let oldRecept = sourceViewController?.oldRecept
                let realm = try! Realm()
                let predicate = NSPredicate(format: "titel = %@ AND beschrijving = %@ AND categorie = %@ AND image = %@", oldRecept!.titel, oldRecept!.beschrijving, oldRecept!.categorie, oldRecept!.image! as CVarArg)
                let rec = realm.objects(Recept.self).filter(predicate).first
                try! realm.write {
                    rec!.titel = recept.titel
                    rec!.beschrijving = recept.beschrijving
                    rec!.ingredienten = recept.ingredienten
                    rec!.categorie = recept.categorie
                    rec!.image = recept.image
                }
                
            } else {
                let newIndexPath = IndexPath(row: recepten.count, section: 0)
                recepten.append(recept)
                filteredRecepten = recepten;
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                //voeg recept toe in databank\\
                let realm = try! Realm()
                try! realm.write {
                    let recepten2 = recepten
                    for recept in recepten2! {
                        realm.add(recept)
                    }
                }
            }
        }
    }
    
    //refresh on appear\\
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    //prepare segue voor details recept\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //show recept\\
        if segue.identifier == "ShowRecept" {
            let indexPath = tableView.indexPathForSelectedRow!
            let recept = filteredRecepten[indexPath.row]
            
            let showReceptViewController = segue.destination as! ShowReceptTableViewController
            
            showReceptViewController.recept = recept
        }
    }
    
    //aantal secties\\
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //aantal cellen\\
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredRecepten.count
        } else {
            return 0
        }
    }
    
    //vullen van de cellen\\
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeue cell\\
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptCell", for: indexPath) as! ReceptTableViewCell
        
        //fetch model object to display\\
        let recept = filteredRecepten[indexPath.row]
        
        //cinfigure cell\\
        cell.update(with: recept)
        cell.showsReorderControl = true
        
        //return cell\\
        return cell
    }
    
    //hoogte cell\\
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //selecteren van een rij en titel printen\\
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recept = filteredRecepten[indexPath.row]
        print(recept.titel)
    }
    
    //verwijderen van recepten\\
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let realm = try! Realm()
            try! realm.write {
                realm.delete(recepten[indexPath.row])
            }
            
            filteredRecepten.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        refreshData()
    }
    
}
