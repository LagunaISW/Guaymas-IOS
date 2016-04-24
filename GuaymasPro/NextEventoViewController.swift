//
//  NextEventoViewController.swift
//  GuaymasPro
//
//  Created by Jhonatan Laguna on 24/04/16.
//  Copyright © 2016 Jhonatan Laguna. All rights reserved.
//

import UIKit

class NextEventoViewController: UIViewController{
    
    var currentEvento: Evento?
    var currentImagen: UIImage?
    var imageCache = [String: UIImage]()

    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitulo.text = currentEvento?.tituloEvento
        labelFecha.text = currentEvento?.fechaEvento
        labelLugar.text = currentEvento?.lugarEvento

        
        if let img = imageCache[(currentEvento?.tituloEvento)!]{
            imageView.image = img
        }
        else{
            let request = NSMutableURLRequest(URL: NSURL(string: (currentEvento?.urlImagenEvento)!)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    let img = UIImage(data: data!)
                    
                    
                    self.imageCache[(self.currentEvento?.tituloEvento)!] = img
                    self.imageView.image = img
                    
                })
            })
            
            task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
