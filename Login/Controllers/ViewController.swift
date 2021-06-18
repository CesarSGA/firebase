//
//  ViewController.swift
//  Login
//
//

import UIKit
import Firebase
import GoogleSignIn
import CLTypingLabel

class ViewController: UIViewController {
    
    @IBOutlet weak var mensajeBienvenidaLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Implementacion de texto
//        var indice = 0.0
//        for letra in tituloLabel {
//            Timer.scheduledTimer(withTimeInterval: 0.05 * indice, repeats: false) { (timer) in
//                self.mensajeBienvenidaLabel.text?.append(letra)
//            }
//            indice += 1
//        }
        
        // Implementacion de CLTypingLabel
        mensajeBienvenidaLabel.charInterval = 0.05
        mensajeBienvenidaLabel.text = "Hola bienvenido a la app oficial del Instituto Tecnologico de Morelia puedes iniciar sesion o registrarte con tu correo institucional."
        
        // Comprobacion de la sesion de usuario
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String {
            // Utilizar un segue de inicio hasta el Chat
            performSegue(withIdentifier: "logueado", sender: self)
            print(email)
        }
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func googleButton(_ sender: UIButton) {
        // Iniciar sesion
        GIDSignIn.sharedInstance().signIn()
    }
}

extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Si no hubo error y se obtuvo un usuario entonces
        if error == nil && user.authentication != nil {
            // Generar credencial con el token del usuario autenticado
            let credencial = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            // Iniciar sesion en Firebase con una credencial de Google
            Auth.auth().signIn(with: credencial) { (authResult, error) in
                // Si se obtuvo respuesta al iniciar sesion y no hubo error
                if let result = authResult, error == nil {
                    // Navegacion de vista inicial a la vista Chat
                    self.performSegue(withIdentifier: "logueado", sender: self)
                    print("Inicio sesion con Google")
                    print(result)
                } else {
                    print("Error al iniciar sesion con Google")
                }
            }
        }
    }
}
