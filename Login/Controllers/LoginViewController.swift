//
//  LoginViewController.swift
//  Login
//
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func login(_ sender: UIButton) {
        if let email = emailTextFiled.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.alertaMensaje(mjs: e.localizedDescription)
                } else {
                    // Navegar al siguiente ViewController
                    self.performSegue(withIdentifier: "SegueLogin", sender: self)
                }
            }
        }
    }
    
    func alertaMensaje(mjs: String){
        switch mjs {
        case "The password is invalid or the user does not have a password.":
            let alert = UIAlertController(title: "Error", message: "La contraseña no es válida o el usuario no tiene contraseña.", preferredStyle: .alert)
            
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
            
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            let alert = UIAlertController(title: "Error", message: "No hay ningún registro de usuario que corresponda a este correo. Es posible que el usuario haya sido eliminado.", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
        default:
            print("Login con exito")
        }
    }
}
