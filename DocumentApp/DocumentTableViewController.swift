import UIKit
import QuickLook
import MobileCoreServices

class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource, UIDocumentPickerDelegate {
    
    var documentListBundle: [DocumentFile] = []  // Liste des fichiers dans le bundle
    var documentListApp: [DocumentFile] = []  // Liste des fichiers ajoutés par l'utilisateur
    var selectedDocument: DocumentFile?  // Variable pour garder la trace du document sélectionné
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Charger les fichiers dès que la vue est prête
        documentListBundle = listFilesInBundle()  // Charger les fichiers du bundle
        documentListApp = listFilesInDocumentsDirectory()  // Charger les fichiers du dossier Documents
        
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
    }
    
    func listFilesInBundle() -> [DocumentFile] {
        guard let bundlePath = Bundle.main.resourcePath else {
            return []
        }
        
        let fileManager = FileManager.default
        let items = try? fileManager.contentsOfDirectory(atPath: bundlePath)
        
        var documentList = [DocumentFile]()
        
        for item in items ?? [] {
            let currentUrl = URL(fileURLWithPath: bundlePath).appendingPathComponent(item)
            let resourcesValues = try? currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            
            guard let resourceValues = resourcesValues else {
                continue
            }
            
            let document = DocumentFile(
                title: resourceValues.name ?? item,
                size: resourceValues.fileSize ?? 0,
                imageName: item,
                url: currentUrl,
                type: resourceValues.contentType?.description ?? "Unknown"
            )
            
            documentList.append(document)
        }
        
        return documentList
    }
    
    // Fonction pour récupérer la liste des fichiers dans le répertoire "Documents" de l'application
    func listFilesInDocumentsDirectory() -> [DocumentFile] {
        // Récupérer l'URL du répertoire Documents dans l'espace de stockage de l'utilisateur.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Créer une instance de FileManager pour interagir avec le système de fichiers.
        let fileManager = FileManager.default
        
        // Récupérer la liste des fichiers dans le répertoire "Documents".
        let items = try? fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
        
        // Créer un tableau vide pour stocker les objets
        var documentList = [DocumentFile]()
        
        // Parcourir tous les fichiers récupérés
        for item in items ?? [] {
            // Construire l'URL complète du fichier
            let currentUrl = documentsDirectory.appendingPathComponent(item)
            
            // Récupérer les données
            let resourcesValues = try? currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            
            // Si on y arrive pas passer au fichier suivant dans la boucle.
            guard let resourceValues = resourcesValues else {
                continue
            }
            
            // Créer un objet `DocumentFile` en utilisant les données récupérées.
            let document = DocumentFile(
                title: resourceValues.name ?? item,
                size: resourceValues.fileSize ?? 0,
                imageName: item,
                url: currentUrl,
                type: resourceValues.contentType?.description ?? "Unknown"
            )
            
            // Ajouter l'objet à la liste des documents.
            documentList.append(document)
        }
        
        // Retourner la liste des fichiers
        return documentList
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListBundle.count + documentListApp.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        let document: DocumentFile
        if indexPath.row < documentListBundle.count {
            document = documentListBundle[indexPath.row]
        } else {
            document = documentListApp[indexPath.row - documentListBundle.count]
        }
        
        // Configuration de la cellule
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "\(document.size) Ko"
        
        // Choisir une image en fonction du type de document
        if let imageName = getImageName(forFileType: document.type) {
            cell.imageView?.image = UIImage(named: imageName)
        } else {
            cell.imageView?.image = UIImage(named: "defaultImage")  // Image par défaut
        }
        
        return cell
    }
    
    func getImageName(forFileType fileType: String) -> String? {
        switch fileType {
        case "com.adobe.pdf":   // Type MIME pour PDF
            return "pdfIcon"
        case "public.text":     // Type MIME pour fichier texte
            return "textIcon"
        case "public.image":    // Type MIME pour image
            return "imageIcon"
        default:
            return nil
        }
    }

    // Méthode appelée lors de la sélection d'un document
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document: DocumentFile
        if indexPath.row < documentListBundle.count {
            document = documentListBundle[indexPath.row]
        } else {
            document = documentListApp[indexPath.row - documentListBundle.count]
        }
        
        selectedDocument = document  // Enregistrer le document sélectionné
        instantiateQLPreviewController(withUrl: document.url)
    }
    
    // Fonction pour instancier et afficher un QLPreviewController
    func instantiateQLPreviewController(withUrl url: URL) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = 0
        navigationController?.pushViewController(previewController, animated: true)
    }
    
    // MARK: - QLPreviewControllerDataSource
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let document = selectedDocument else {
            fatalError("Aucun document sélectionné.")
        }
        return document.url as QLPreviewItem
    }
    
    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image, .plainText, .text], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    // UIDocumentPickerDelegate - Lorsque l'utilisateur choisit un fichier
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Récupérer le fichier sélectionné
        if let selectedFileURL = urls.first {
            copyFileToDocumentsDirectory(fromUrl: selectedFileURL)
            
            let fileName = selectedFileURL.lastPathComponent
            let resourcesValues = try? selectedFileURL.resourceValues(forKeys: [.contentTypeKey, .fileSizeKey])
            let fileSize = resourcesValues?.fileSize ?? 0
            let fileType = resourcesValues?.contentType?.description ?? "Unknown"
            
            let document = DocumentFile(
                title: fileName,
                size: fileSize,
                imageName: fileName,
                url: selectedFileURL,
                type: fileType
            )
            
            documentListApp.append(document)
            tableView.reloadData()
        }
    }
    
    // UIDocumentPickerDelegate - Si l'utilisateur annule l'opération
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("L'utilisateur a annulé le choix du document.")
    }
    
    // Copie le fichier dans le répertoire Documents de l'application
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print("Erreur lors de la copie du fichier: \(error)")
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



