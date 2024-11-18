//
//  DocumentTableViewController.swift
//  DocumentApp
//
//  Created by Ethan DAHI-GERMAIN on 11/18/24.
//

import UIKit

class DocumentTableViewController: UITableViewController {
    
    // Structure des données des documents
    struct DocumentFile {
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String
    }

    // Données statiques à afficher dans la table
    static let testDocuments: [DocumentFile] = [
        DocumentFile(title: "Document 1", size: 100, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 2", size: 200, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 3", size: 300, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 4", size: 400, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 5", size: 500, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 6", size: 600, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 7", size: 700, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 8", size: 800, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 9", size: 900, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
        DocumentFile(title: "Document 10", size: 1000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain")
    ]
    
    // Indique au Controller combien de sections il doit afficher
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Une seule section dans ce cas
    }

    // Indique au Controller combien de cellules il doit afficher
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocumentTableViewController.testDocuments.count // Retourne le nombre de documents à afficher
    }
    
    // Indique au Controller comment remplir la cellule avec les données
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Déqueue une cellule réutilisable (le "reuseIdentifier" est un identifiant unique pour chaque type de cellule)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        // Récupérer l'objet DocumentFile pour cette ligne
        let document = DocumentTableViewController.testDocuments[indexPath.row]
        
        // Configurer le titre et la taille du document dans la cellule
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "\(document.size) Ko"
        
        // Si vous avez une image à afficher, utilisez imageName (par exemple, charger une image locale ou depuis une URL)
        if let imageName = document.imageName {
            // Exemple de chargement d'image (à adapter selon vos besoins)
            cell.imageView?.image = UIImage(named: imageName) // Assurez-vous que l'image existe dans les ressources
        } else {
            // Sinon, vous pouvez afficher une image par défaut
            cell.imageView?.image = UIImage(named: "defaultImage")
        }
        
        return cell
    }
    
    // Optionnel : Vous pouvez aussi implémenter cette méthode pour ajouter des actions lors de la sélection d'une cellule
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Action lors de la sélection d'une ligne
        let document = DocumentTableViewController.testDocuments[indexPath.row]
        print("Document sélectionné : \(document.title)")
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
