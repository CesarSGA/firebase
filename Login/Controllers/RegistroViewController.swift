//
//  RegistroViewController.swift
//  Login
//
//

import UIKit
import Firebase

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Registro(_ sender: UIButton) {
        if let email = correoTextField.text, let password = passwordTextField.text, let userName = nombreTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    print("User created!")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = userName
                    changeRequest?.commitChanges { error in
                    }
                }
                if let e = error {
                    self.alertaMensaje(mjs: e.localizedDescription)
                } else {
                    // Navegar al siguiente ViewController
                    self.performSegue(withIdentifier: "SegueRegistro", sender: self)
                }
            }
        }
    }
    
    func alertaMensaje(mjs: String){
        switch mjs {
        case "The password must be 6 characters long or more.":
            let alert = UIAlertController(title: "Error", message: "La contraseña debe tener 6 caracteres o más.", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
            
        case "The email address is badly formatted.":
            let alert = UIAlertController(title: "Error", message: "La dirección de correo electrónico está mal formateada.", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
            
        case "The email address is already in use by another account.":
            let alert = UIAlertController(title: "Error", message: "La dirección de correo electrónico ya está siendo utilizada por otra cuenta.", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
        default:
            print("Registro con exito")
        }
    }
}
