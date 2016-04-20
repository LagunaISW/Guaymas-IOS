//
//  NextDirectorioViewController.swift
//  Guaymas
//
//  Created by Saul Urias on 14/03/16.
//  Copyright © 2016 SaulUrias. All rights reserved.
//

import UIKit

class NextDirectorioViewController: UIViewController {

    var currentDirectorio: Directorio? //Variable que contiene la noticia seleccionada

    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var numeroLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tituloLabel.text = currentDirectorio?.nombre
   //     tituloLabel.sizeToFit()
        
        numeroLabel.text = currentDirectorio?.telefono
     //   numeroLabel.sizeToFit()
        
        direccionLabel.text = currentDirectorio?.direccion
       // direccionLabel.sizeToFit()
        
        webLabel.text = currentDirectorio?.pagina
      //  webLabel.sizeToFit()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
