//
//  PerfilViewController.swift
//  Login
//
//

import UIKit
import Firebase

class PerfilViewController: UIViewController {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Cambiar el color Title NavegationController
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        
        // Volver redondo el ImageView
        self.imageUser.layer.masksToBounds = true
        self.imageUser.layer.cornerRadius = self.imageUser.bounds.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.createSpinnerView()
        self.loadDataUser()
    }

    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func loadDataUser() {
        let user = Auth.auth().currentUser
        if let user = user {
//                let email = user.email
            let name = user.displayName
            self.nameTextField.text = name
        }
    }
    
    @IBAction func changeImage(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func changeNameUserButton(_ sender: UIButton) {
        // Creaccion del Alert
        let alert = UIAlertController(title: "Modificar Nombre", message: nil, preferredStyle: .alert)
        // Creacion de Textfield
        alert.addTextField { (nameAlert) in
            nameAlert.placeholder = "Nombre"
        }
        // Creacion del Alert Aceptar y Cancelar
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let actionAlert = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            // Variables para almacenar el contacto
            guard let nameAlert = alert.textFields?.first?.text else { return }
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = nameAlert
                changeRequest.commitChanges { error in
                    if let error = error {
                      // An error happened.
                        print("Error: \(error.localizedDescription)")
                    } else {
                      // Profile updated.
                        print("Actualizacion Correcta")
                        self.viewWillAppear(true)
                    }
                }
            }
        }
        // Añadir Actions al Alert
        alert.addAction(actionAlert)
        alert.addAction(actionCancel)
    
        // Presentacion del alert
        present(alert, animated: true, completion: nil)
    }
}

extension PerfilViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: Metodos de los delegados para el PickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagen = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        imageUser.image = imagen
        picker.dismiss(animated: true, completion: nil)
    }
}
