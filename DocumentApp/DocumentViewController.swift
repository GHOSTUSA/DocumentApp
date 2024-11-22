import UIKit

class DocumentViewController: UIViewController {
    
    
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Vérifier que imageName n'est pas nil
        if let imageName = imageName {
            // 2. Afficher l'image dans l'ImageView
          
        } else {
            // Si imageName est nil, afficher une image par défaut ou gérer l'erreur
          
        }
    }
}
