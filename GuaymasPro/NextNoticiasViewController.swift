//
//  NextNoticiasViewController.swift
//  Guaymas
//
//  Created by Jhonatan Laguna on 28/02/16.
//  Copyright © 2016 Lagunajs. All rights reserved.
//
/**
 *Controlador de la vista siguiente después de seleccionar una noticia
 */
import UIKit

class NextNoticiasViewController: UIViewController {
    
    var currentNoticia: Noticia? //Variable que contiene la noticia seleccionada
    var currentImagen: UIImage?
    
   // @IBOutlet weak var scrollViewNoticias: UIScrollView!
    @IBOutlet weak var tituloLabel: UILabel!  //Label en el cual mostraremos el titulo de la noticia
    @IBOutlet weak var descripcionNoticia: UILabel! //Label en el cual mostraremos la descripcion de la noticia
    @IBOutlet weak var imagenNoticia: UIImageView!
    @IBOutlet weak var fechaNoticia: UILabel!
    
    var imageCache = [String: UIImage]()
    
    /**
     *Funcion que nos indica cuando la vista esta cargada
     *En esta función llamamos todo lo que queremos que se ejecute al entrar en la pantalla
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tituloLabel.text = currentNoticia?.titulo  //Mostramos el titulo en el label
        tituloLabel.sizeToFit()
        
        
        fechaNoticia.text = currentNoticia?.fecha;
        descripcionNoticia.text = currentNoticia?.descripcion;
        descripcionNoticia.sizeToFit();
        
      
        if let img = imageCache[(currentNoticia?.titulo)!]{
            imagenNoticia.image = img
        }
        else{
            let request = NSMutableURLRequest(URL: NSURL(string: (currentNoticia?.urlImagen)!)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    let img = UIImage(data: data!)
                    
                    
                    self.imageCache[(self.currentNoticia?.titulo)!] = img
                    self.imagenNoticia.image = img
                    
                })
            })
            
            task.resume()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
    

