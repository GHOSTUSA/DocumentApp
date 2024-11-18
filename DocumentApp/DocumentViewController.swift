import UIKit

class ImageViewController: UIViewController {

    // Variables pour recevoir les données
    var image: UIImage?
    
    // Outlets pour l'affichage
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Mettre à jour l'interface avec les données reçues
        if let image = image {
            imageView.image = image
        }
    }
}
