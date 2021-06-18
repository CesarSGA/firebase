//
//  ChatsViewController.swift
//  Login
//
//

import UIKit
import Firebase
import GoogleSignIn

class ChatsViewController: UIViewController {
    
    // Arreglo de Chats
    var chats = [Message]()
    
    // Agregar la referencia a la Base de Datos Firestore
    let db = Firestore.firestore()
    
    @IBOutlet weak var mensajeTextField: UITextField!
    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Celda personalizada
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        chatsTableView.register(nib, forCellReuseIdentifier: "cellMessage")
        
        // Ocultar boton de regresar
        navigationItem.hidesBackButton = true
        
        // Obtenemos todos los chats en Firebase
        cargarMensajes()
        
        // Almacenar los datos del usuario logueado para el UserDefaults
        if let email = Auth.auth().currentUser?.email {
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
            defaults.synchronize()
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        // Cerrar sesion con Google
        GIDSignIn.sharedInstance().signOut()
        
        // Eliminar los datos de la sesion
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print("Error al cerrar sesion: \(error.localizedDescription)")
        }
    }
    
    @IBAction func sendMessageButton(_ sender: UIButton) {
        if let message = mensajeTextField.text, let remitente = Auth.auth().currentUser?.displayName {
            
            // Añadir datos a la base de datos
            db.collection("mensajes").addDocument(data: ["remitente": remitente, "mensaje": message, "fechaCreacion": String (Date().timeIntervalSince1970)]) { (error) in
                if let e = error {
                    print("Error al guardar en firestore \(e.localizedDescription)")
                } else {
                    // Restablecemos el TextField
                    self.mensajeTextField.text = ""
                }
            }
        }
    }
    
    func cargarMensajes() {
        db.collection("mensajes").order(by: "fechaCreacion").addSnapshotListener() { (querySnapshot, err) in
            // Vaciar arreglo de chats
            self.chats = []
            
            if let err = err {
                print("Error al obtener los chats: \(err.localizedDescription)")
            } else {
                if let snapshotDocumentos = querySnapshot?.documents {
                    for document in snapshotDocumentos {
                        // Crear mi objeto chat
                        let datos = document.data()
                        
                        // Obtener los parametros para mi obj Mensaje
                        guard let remitenteFS = datos["remitente"] as? String else { return }
                        guard let mensajeFS = datos["mensaje"] as? String else { return }
                        
                        // Creamos el objeto
                        let nuevoMessage = Message(remitente: remitenteFS, cuerpoMsj: mensajeFS)
                        
                        // Añadimos el mensaje al arreglo
                        self.chats.append(nuevoMessage)
                        
                        // Recargamos la tabla
                        DispatchQueue.main.async {
                            self.chatsTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

//MARK: Metodos UITableView
extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "cellMessage", for: indexPath) as! MessageTableViewCell
        cell.nombreTextLabel.text = chats[indexPath.row].remitente
        cell.mensajeTextLabel.text = chats[indexPath.row].cuerpoMsj
        
        return cell
    }
}
