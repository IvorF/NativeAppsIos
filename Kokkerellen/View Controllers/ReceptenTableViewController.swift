import UIKit

class ReceptenTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recepten: [Recept] = [
        Recept(titel: "Eieren met spek", ingredienten: ["3 eieren"], beschrijving: "Zet de pan op het vuur, gooi de eieren in de pan. Zet het vuur zo hoog mogelijk tot de eieren klaar zijn. Smakelijk!", categorie: .overige, image: "4"),
        Recept(titel: "Boterham met kaas", ingredienten: ["1 boterham", "1 schel kaas"], beschrijving: "Pak het schelletje kaas en leg dit op de boterham. Plooi de boterham in 2. Smakelijk!", categorie: .hoofdgerecht, image: "3"),
        Recept(titel: "Eieren met spek 2", ingredienten: ["3 eieren"], beschrijving: "Zet de pan op het vuur, gooi de eieren in de pan. Zet het vuur zo hoog mogelijk tot de eieren klaar zijn. Smakelijk!", categorie: .hoofdgerecht, image: "4"),
        Recept(titel: "TomatenSoep", ingredienten: ["tomaten","water"], beschrijving: "kiep alles bij elkaar en laat 7 uur koken. Smakelijk!", categorie: .soep, image: "2"),
        Recept(titel: "Boterham met kaas, salami en groenten", ingredienten: ["1 boterham", "1 schel kaas"], beschrijving: "Pak het schelletje kaas en leg dit op de boterham. Plooi de boterham in 2. Smakelijk!", categorie: .hoofdgerecht, image: "3")]
    
    var filteredRecepten: [Recept]!
    var cat: Categorie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterRecept()
        
        filteredRecepten = recepten
        
        setUpSearchBar()
        alterLayout()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
    }
    
    //filter recepten\\
    private func filterRecept() {
        guard (cat != nil) else { return }
        
        recepten = recepten.filter( { recept -> Bool in
            recept.categorie.rawValue.contains(cat.titel)
        } )
        
        print(recepten)
    }
    
    //searchbar\\
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { filteredRecepten = recepten;
            tableView.reloadData()
            return}
        filteredRecepten = recepten.filter( { recept -> Bool in
            recept.titel.lowercased().contains(searchText.lowercased())
        } )
        tableView.reloadData()
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
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: recepten.count, section: 0)
                recepten.append(recept)
                filteredRecepten = recepten;
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //prepare segue voor details recept\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecept" {
            let indexPath = tableView.indexPathForSelectedRow!
            let recept = filteredRecepten[indexPath.row]
            
            let showReceptViewController = segue.destination as! ShowReceptTableViewController
            
            showReceptViewController.recept = recept
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowRecept" {
//            let indexPath = tableView.indexPathForSelectedRow!
//            let recept = filteredRecepten[indexPath.row]
//            let showReceptViewController = segue.destination as! ShowReceptViewController
//
//            showReceptViewController.recept = recept
//        }
//    }
    
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
            filteredRecepten.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
