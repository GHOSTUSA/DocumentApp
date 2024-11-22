# 1-Environnement

## Exercice 1

 Targets - Ce sont les types de projet que nous avons, donc dans ce cas la une application IOS
 Les fichiers de base servent à la strucure global de l'application et de sont cycle de vie
 Le dossier assets contient les ressources du projet, images...
 Le story board permet de créer l'interface visuelle sans coder, en faisant des glissé déposé
 Le simulateur permet d'émuler des appareil apppel pour tester l'appli
 
## Exercice 2

cmd R permet de build l'application dans un émulateur
cmd shift o permet d'ouvrir un fichier rapidement
ctrl i
ctrl /

## Exercie 3

On peut chnager l'appareil dans la barre du haut
 
# 3-Délégation

## Exercie 1

Elle peut etre utiliser sans créer d'instance

# 4-Navigation

## Exercie 1

Le NavigationController gère une pile de vue et permet de naviguer entre elles et ajoute également une barre de navigation en haut de l'écran
La NavigationBar et NavigationController ne sont pas la même chose, NavigationController sert à naviger entre les pages alors que l'autre un juste un élement visuel

# 6-Ecran Detail

## Exercie 1

Un sergue permet de faire la transition entre 2 ecrans

## Exercice 2

c'est une règle qui définit la position, la taille et les relations entre les différents éléments d'interface dans une vue 

# 9-QLPreview

Utiliser un disclosureIndicator rend l'interface plus intuitive et permet de respecter les conventions de design d'Apple, et simplifie la gestion de la navigation dans l'application. Il aide à indiquer clairement à l'utilisateur qu'il peut interagir avec une cellule pour obtenir plus d'informations, tout en maintenant une interface propre et fonctionnelle.


# 10-Importation

Un #selector est une manière de référencer une méthode dans le code qui sera appelée en réponse à un événement. Le #selector est utilisé pour lier une méthode à un événement

.add est une valeur de l'énumération UIBarButtonSystemItem. Il est utilisé pour spécifier l'icône du bouton dans la barre de navigation

Le mot-clé @objc permet à cette méthode Swift d'être utilisée avec des mécanismes qui viennent de l'Objective-C, tels que les #selector et les gestionnaires d'événements. Sans cela, la méthode serait ignorée par ces mécanismes.

Pour les boutons :
let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDocuments))

navigationItem.rightBarButtonItems = [addButton, refreshButton]

La fonction defer est utilisée en Swift pour garantir que certains blocs de code seront exécutés avant que la fonction ou le scope actuel ne se termine, peu importe comment ce dernier est quitté 
