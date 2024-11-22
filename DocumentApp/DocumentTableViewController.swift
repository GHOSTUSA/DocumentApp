import UIKit
import QuickLook
import MobileCoreServices

class DocumentTableViewController: UITableViewController, UIDocumentPickerDelegate, QLPreviewControllerDataSource {
    
    var documentListBundle: [DocumentFile] = []  // Liste des fichiers dans le bundle
    var documentListApp: [DocumentFile] = []  // Liste des fichiers ajoutés par l'utilisateur
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Charger les fichiers dès que la vue est prête
        documentListBundle = listFilesInBundle()  // Fichiers du bundle
        documentListApp = listFilesInDocumentsDirectory()  // Fichiers de l'utilisateur
        
        // Recharger la table pour afficher les fichiers
        tableView.reloadData()
        
        // Ajouter un bouton pour ajouter un document
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
    }
    
    @objc func addDocument() {
        // Lancer le Document Picker avec uniquement les types de fichiers acceptés
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false  // Choix d'un seul fichier
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
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
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("L'utilisateur a annulé le choix du document.")
    }
    
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print("Erreur lors de la copie du fichier: \(error)")
        }
    }
    
    func listFilesInDocumentsDirectory() -> [DocumentFile] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        let items = try? fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
        
        var documentList = [DocumentFile]()
        for item in items ?? [] {
            let currentUrl = documentsDirectory.appendingPathComponent(item)
            let resourcesValues = try? currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            
            guard let resourceValues = resourcesValues else { continue }
            
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
    
    func listFilesInBundle() -> [DocumentFile] {
        let fileManager = FileManager.default
        guard let resourceURL = Bundle.main.resourceURL else { return [] }
        let items = try? fileManager.contentsOfDirectory(atPath: resourceURL.path)
        
        var documentList = [DocumentFile]()
        for item in items ?? [] {
            let currentUrl = resourceURL.appendingPathComponent(item)
            let resourcesValues = try? currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            
            guard let resourceValues = resourcesValues else { continue }
            
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
        
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "\(document.size) Ko"
        cell.imageView?.image = UIImage(named: document.imageName ?? "defaultImage")
        
        return cell
    }
    
    // Gestion de la sélection d'un document pour prévisualiser
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document: DocumentFile
        if indexPath.row < documentListBundle.count {
            document = documentListBundle[indexPath.row]
        } else {
            document = documentListApp[indexPath.row - documentListBundle.count]
        }
        
        instantiateQLPreviewController(withUrl: document.url)
    }

    func instantiateQLPreviewController(withUrl url: URL) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        // Log pour voir l'URL passée et celle recherchée
        print("URL passée pour la prévisualisation: \(url.absoluteString)")

        // Recherche de l'index de l'élément sélectionné dans documentListApp
        if let index = documentListApp.firstIndex(where: { $0.url.absoluteString == url.absoluteString }) {
            print("Document trouvé à l'index \(index) : \(documentListApp[index].title)")
            previewController.currentPreviewItemIndex = index
            navigationController?.pushViewController(previewController, animated: true)
        } else {
            print("Erreur : l'élément à prévisualiser n'a pas été trouvé.")
        }
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return documentListApp.count > 0 ? 1 : 0
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard index >= 0 && index < documentListApp.count else {
            fatalError("Index hors limites")
        }
        return documentListApp[index].url as QLPreviewItem
    }
}

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


