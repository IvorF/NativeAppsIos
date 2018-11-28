import UIKit

class ShowReceptTableViewController: UITableViewController {

    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblIngredienten: UILabel!
    @IBOutlet weak var lblBeschrijving: UILabel!
    @IBOutlet weak var btnFavorienten: UIButton!
    
    //toeveogen aan favorieten/verwijderen\\
    @IBAction func btnFavorietenClicked(_ sender: Any) {
        if recept.favoriet {
            recept.favoriet = false
            btnFavorienten.setTitle("Voeg toe aan favorieten", for: .normal)
        } else {
            recept.favoriet = true
            btnFavorienten.setTitle("Verwijder uit favorieten", for: .normal)
        }
    }
    
    
    var recept: Recept!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //recept invoegen\\
        if let recept = recept {
            lblTitel.text = recept.titel
            

            lblIngredienten.text = recept.ingredienten
            
            
            lblBeschrijving.text = "\n" + recept.beschrijving
            imgPhoto.image = recept.image
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //hoogte cell\\
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //edit recept\\
        if segue.identifier == "editRecept" {
            let addReceptViewController = segue.destination as! AddReceptTableViewController
            
            addReceptViewController.recept = recept
        }
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
