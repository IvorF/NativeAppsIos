import UIKit

class ReceptenTableViewController: UITableViewController {
    
    var recepten: [Recept] = [
        Recept(titel: "Eieren met spek", ingredienten: ["3 eieren"], beschrijving: "Zet de pan op het vuur, gooi de eieren in de pan. Zet het vuur zo hoog mogelijk tot de eieren klaar zijn. Smakelijk!"),
        Recept(titel: "Boterham met kaas", ingredienten: ["1 boterham", "1 schel kaas"], beschrijving: "Pak het schelletje kaas en leg dit op de boterham. Plooi de boterham in 2. Smakelijk!"),
        Recept(titel: "Eieren met spek 2", ingredienten: ["3 eieren"], beschrijving: "Zet de pan op het vuur, gooi de eieren in de pan. Zet het vuur zo hoog mogelijk tot de eieren klaar zijn. Smakelijk!"),
        Recept(titel: "Boterham met kaas 2", ingredienten: ["1 boterham", "1 schel kaas"], beschrijving: "Pak het schelletje kaas en leg dit op de boterham. Plooi de boterham in 2. Smakelijk!")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //edit button navigation bar\\
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //unwind segue, als save opslaan\\
    @IBAction func unwindToReceptTableViewWithSegue(segue: UIStoryboardSegue) {
        
    }
    
    //prepare segue\\
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecept" {
            let indexPath = tableView.indexPathForSelectedRow!
            let recept = recepten[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let showReceptViewController = navController.topViewController as! ShowReceptViewController
            
            showReceptViewController.recept = recept
        }
    }

    // MARK: - Table view data source

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptCell", for: indexPath)
        
        let recept = recepten[indexPath.row]
        
        cell.textLabel?.text = recept.titel
        cell.detailTextLabel?.text = recept.beschrijving

        return cell
    }
    
    //selecteren van een rij en titel printen\\
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recept = recepten[indexPath.row]
        print(recept.titel)
    }
    
    //verplaatsen van recepten naar andere cell\\
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedRecept = recepten.remove(at: fromIndexPath.row)
        recepten.insert(movedRecept, at: to.row)
        tableView.reloadData()
    }
    
    //verwijderen van recepten\\
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recepten.remove(at: indexPath.row)
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
