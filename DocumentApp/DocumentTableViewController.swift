import UIKit
import QuickLook
import MobileCoreServices

class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource {
    
    // Déclaration d'une variable pour stocker les documents chargés
    var documentListBundle: [DocumentFile] = []  // Liste des fichiers dans le bundle
    var selectedDocumentIndex: Int?  // Variable pour garder la trace du document sélectionné
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Charger les fichiers dès que la vue est prête
        documentListBundle = listFilesInBundle()  // Charger les fichiers du bundle
        
        // Recharger la table si les données changent (ajout de nouveaux fichiers)
        tableView.reloadData()
    }
    
    // Récupère la liste des fichiers dans le bundle de l'application
    func listFilesInBundle() -> [DocumentFile] {
        // 1. Récupérer l'URL du répertoire bundle de l'application
        guard let bundlePath = Bundle.main.resourcePath else {
            return []
        }
        
        // 2. Initialiser FileManager pour interagir avec le système de fichiers
        let fileManager = FileManager.default
        
        // 3. Essayer de récupérer les fichiers dans le répertoire du bundle
        let items = try? fileManager.contentsOfDirectory(atPath: bundlePath)
        
        // 4. Initialiser un tableau pour stocker les documents trouvés
        var documentList = [DocumentFile]()
        
        // 5. Parcourir chaque fichier trouvé dans le bundle
        for item in items ?? [] {
            // 6. Créer l'URL complète du fichier en combinant le répertoire du bundle et le nom du fichier
            let currentUrl = URL(fileURLWithPath: bundlePath).appendingPathComponent(item)
            
            // 7. Récupérer les informations du fichier (nom, type, taille) via resourceValues
            let resourcesValues = try? currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            
            // Vérifier que les ressources sont bien récupérées
            guard let resourceValues = resourcesValues else {
                continue  // Si les ressources ne peuvent pas être récupérées, passer au fichier suivant
            }
            
            // 8. Créer un objet DocumentFile avec les informations récupérées
            let document = DocumentFile(
                title: resourceValues.name ?? item,  // Utiliser le nom du fichier ou le nom de l'élément si nécessaire
                size: resourceValues.fileSize ?? 0,  // Utiliser la taille du fichier ou 0 si la taille n'est pas disponible
                imageName: item,  // Utiliser le nom du fichier pour l'image (ou un type par défaut si nécessaire)
                url: currentUrl,  // URL complète du fichier
                type: resourceValues.contentType?.description ?? "Unknown"  // Type MIME du fichier (ou "Unknown" si non disponible)
            )
            
            // 9. Ajouter le document à la liste des documents
            documentList.append(document)
        }
        
        // 10. Retourner la liste des documents trouvés dans le bundle
        return documentList
    }

    // Indique au Controller combien de sections il doit afficher
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Indique au Controller combien de cellules il doit afficher
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListBundle.count  // Compter les fichiers dans le bundle
    }
    
    // Cellule configurée avec le document sélectionné
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        let document = documentListBundle[indexPath.row]
        
        // Configuration de la cellule
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "\(document.size) Ko"
        cell.imageView?.image = UIImage(named: document.imageName ?? "defaultImage")
        
        return cell
    }
    
    // Méthode appelée lors de la sélection d'un document
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Enregistrer l'index du document sélectionné
        selectedDocumentIndex = indexPath.row
        
        // Appeler la fonction pour instancier le QLPreviewController
        instantiateQLPreviewController()
    }
    
    // Fonction pour instancier et afficher un QLPreviewController
    func instantiateQLPreviewController() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        // Utiliser l'index du document sélectionné
        previewController.currentPreviewItemIndex = selectedDocumentIndex ?? 0
        
        navigationController?.pushViewController(previewController, animated: true)
    }
    
    // MARK: - QLPreviewControllerDataSource
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1  // Nous affichons un seul fichier à la fois
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        // Utiliser l'index du document sélectionné pour retourner le bon fichier
        return documentListBundle[selectedDocumentIndex ?? 0].url as QLPreviewItem
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


