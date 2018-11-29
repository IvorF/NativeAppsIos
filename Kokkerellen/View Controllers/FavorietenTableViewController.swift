import UIKit
import RealmSwift

class FavorietenTableViewController: UITableViewController {

    var recepten: [Recept] = []
    
    //refresh data tableview\\
    @objc private func refreshData() {
        recepten = Array(try! Realm().objects(Recept.self))
        filterRecept()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //recepten ophalen\\
        recepten = Array(try! Realm().objects(Recept.self))

        //refreshcontrol\\
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = ref
        
        //favorieten filteren\\
        filterRecept()
        
    }
    
    //refresh on appear\\
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    //unwind\\
    @IBAction func unwindToCategorieTableViewWithSegue(segue: UIStoryboardSegue) {
    }
    
    //verwijderen van recepten uit favorieten\\
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "titel = %@", recepten[indexPath.row].titel)
            let rec = realm.objects(Recept.self).filter(predicate).first
            
            try! realm.write {
                rec!.favoriet = false
            }
            
            recepten.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //filter recepten\\
    private func filterRecept() {
        recepten = recepten.filter( { recept -> Bool in
            recept.favoriet
        } )
        
    }

    //aantal secties\\
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //aantal cellen\\
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recepten.count
        } else {
            return 0
        }
    }

    //vullen van de cellen\\
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeue cell\\
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptCell", for: indexPath) as! ReceptTableViewCell
        
        //fetch model object to display\\
        let recept = recepten[indexPath.row]
        
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
    
    //prepare segue voor details recept\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //show recept\\
        if segue.identifier == "ShowRecept" {
            let indexPath = tableView.indexPathForSelectedRow!
            let recept = recepten[indexPath.row]
            
            let showReceptViewController = segue.destination as! ShowReceptTableViewController
            
            showReceptViewController.recept = recept
        }
    }

}
