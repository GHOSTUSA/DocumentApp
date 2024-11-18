//
//  DocumentTableViewController.swift
//  DocumentApp
//
//  Created by Ethan DAHI-GERMAIN on 11/18/24.
//

import UIKit

class DocumentTableViewController: UITableViewController {
    
    // Déclaration d'une variable pour stocker les documents chargés
    var documentListBundle: [DocumentFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Charger les fichiers dès que la vue est prête
        documentListBundle = listFileInBundle()
        
        // Optionnel : recharger la table si les données changent (par exemple, si tu ajoutes des documents dynamiquement)
        tableView.reloadData()
    }
    
    // Indique au Controller combien de sections il doit afficher
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Une seule section dans ce cas
    }
    
    // Indique au Controller combien de cellules il doit afficher
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListBundle.count // Retourne le nombre de documents à afficher
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Déqueue une cellule réutilisable (le "reuseIdentifier" est un identifiant unique pour chaque type de cellule)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        // Récupérer l'objet DocumentFile correspondant à la ligne dans le tableau
        let document = listFileInBundle()[indexPath.row]
        
        // Configurer le titre et la taille du document dans la cellule
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "\(document.size) Ko"
        
//        // Si l'image existe, on l'affiche dans l'imageView
//        if let imageName = document.imageName {
//            cell.imageView?.image = UIImage(named: imageName) // Assurez-vous que l'image est dans les ressources
//        } else {
//            // Image par défaut si aucune image n'est spécifiée
//            cell.imageView?.image = UIImage(named: "defaultImage")
//        }
        
        return cell
    }

        
    func listFileInBundle() -> [DocumentFile] {
        // initialisation du file manageur
        let fm = FileManager.default
        // chargement du chemin du bundle
        let path = Bundle.main.resourcePath!
        // on recupere les fichier
        let items = try! fm.contentsOfDirectory(atPath: path)
        // on initialise le tableau de DocumentFile
        var documentListBundle = [DocumentFile]()
        
        // pour chaque fichier trouvé
        for item in items {
            //si c'est une image et qu'il a le suffix DS_Store
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") || item.hasSuffix(".png") || item.hasSuffix(".jpeg") {
                //on set l'url
                let currentUrl = URL(fileURLWithPath: path + "/" + item)
                // on recupère ses infos
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                //on initialise le documentfile avec toute les infos nécéssaires
                let document = DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: item,
                    url: currentUrl,
                    type: resourcesValues.contentType!.description
                )
                // on ajoute le doc a la liste
                documentListBundle.append(document)
            }
        }
        
        // Vérifier le contenu de la liste
        print("Documents chargés : \(documentListBundle.count)")
        // on les return
        return documentListBundle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Vérifie si c'est la bonne segue
        if segue.identifier == "ShowDocumentSegue" {
            // Récupérer l'index de l'élément sélectionné
            if let indexPath = tableView.indexPathForSelectedRow {
                let document = documentListBundle[indexPath.row]  // Utiliser documentListBundle, pas une autre liste
                
                // Vérifier que la destination est le bon ViewController (ImageViewController)
                if let destinationVC = segue.destination as? ImageViewController {
                    
                    // Passer les données au ImageViewController
                    destinationVC.titleText = document.title  // Passer le titre
                    destinationVC.image = UIImage(named: document.imageName ?? "defaultImage") // Charger l'image
                }
            }
        }
    }
	


    


// Structure de données pour un document
struct DocumentFile {
    var title: String
    var size: Int
    var imageName: String?
    var url: URL
    var type: String
}




    //override func viewDidLoad() {
        //super.viewDidLoad()

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


