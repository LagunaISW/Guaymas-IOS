//
//  EventosViewController.swift
//  Guaymas
//
//  Created by Oscar Dena on 13/03/16.
//  Copyright © 2016 SaulUrias. All rights reserved.
//

import UIKit

class EventosViewController: UITableViewController {
    
    var arregloEventos = [Evento]()
    var imageCache = [String: UIImage]() //imagenes descargadas
    var imagenArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Eventos Cargados")
        //Verificamos que el dispositivo tenga internet
        if(NetworkUtility.isConnectedToNetwork()){
            llamarWebService() //Mandamos llamar la función que crea la conexión al WebService
        }else{
            let alert = UIAlertController(title: "Error de conexion", message: "Revisar Internet", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                void in print("Ok Pressed")}
            
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arregloEventos.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventosCell") as UITableViewCell!

        
        let evento = arregloEventos.reverse()[indexPath.row]
        
        
        
        let imagen = cell.viewWithTag(4) as! UIImageView //Obtenemos el ImageView
       
        
        /*
        >>>>>>>>>>>>>>>>>>>>>>>>INICIA: Carga de la imagen <<<<<<<<<<<<<<<<<<<<<<<<<<<<
        */
        if let img = imageCache[evento.urlImagenEvento]{ //revisamos si la imagen ya ha sido descargada
            imagen.image = img //si ya se encuentra en cache se utiliza
        }
        else{ //de lo contrario se descarga
            print(evento.urlImagenEvento)
            let request = NSMutableURLRequest(URL: NSURL(string: evento.urlImagenEvento)!) //Creamos el Request y asignamos la URL
            let session = NSURLSession.sharedSession() //Creamos la Session
            request.HTTPMethod = "GET" //Especificamos el method a utilizar
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in //Creamos la tarea
                dispatch_async(dispatch_get_main_queue(), { // lo corremos en el hilo principal
                    let img = UIImage(data: data!) //Convertimos el data en UIImage
                    if img != nil {
                        self.imagenArray.append(img!)
                        self.imageCache[evento.urlImagenEvento] = img //guardamos la imagen en cache
                        imagen.image = img //cargamos la imagen en el imageview
                    }else{
                        self.imgRespaldo(imagen)
                    }
                    
                })
            }) //Asignamos la imagen a su imageview correspondiente
            
            task.resume() //Ejecutamos la tarea
        }
        /*
        >>>>>>>>>>>>>>>>>>>>>>>> TERMINA: Carga de la imagen <<<<<<<<<<<<<<<<<<<<<<<<<<<<
        */

        
        
        let tituloEvento = cell.viewWithTag(1) as! UILabel
        tituloEvento.text = evento.tituloEvento
        tituloEvento.sizeToFit()
        
        let fechaEvento = cell.viewWithTag(2) as! UILabel
        fechaEvento.text = evento.fechaEvento
        fechaEvento.sizeToFit()
        
        let lugarEvento = cell.viewWithTag(3) as! UILabel
        lugarEvento.text = evento.lugarEvento
        lugarEvento.sizeToFit()
        
        
        return cell //Regresamos la celda
    }
    
    
    
    /**
     *Funcion que creamos para conectarnos con el WebService
     */
    func llamarWebService(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://app.guaymas.gob.mx/peticiones.php?calendario=anteriores")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in //Creamos la tarea
            let json = JSON(data: data!)
            for i in 0 ..< json.count-1 { //Recorremos el arreglo de Eventos
                let tituloEvento = json[i]["nombre_evento"].string
                let descripcionEvento = json[i]["desc"].string
                let fechaEvento = json[i]["fecha"].string
                let lugarEvento = json[i]["lugar"].string
                let horaEvento = json[i]["hora"].string
                let organizadorEvento = json[i]["organiza"].string
                let contactoEvento = json[i]["contacto"].string
                let urlImagenEvento = json[i]["imagen"].string
                
                var urlImagen = "http://guaymas.gob.mx/wp-content/themes/aquiesguaymas/img/calendario/accion_civica_guaymas.jpg"
                
                if(urlImagenEvento != nil){
                    urlImagen =  "http://guaymas.gob.mx/wp-content/themes/aquiesguaymas/img/calendario/\(urlImagenEvento!)"
                }
                
                let nuevoEvento = Evento(titulo: tituloEvento!, descripcion: descripcionEvento!, fecha: fechaEvento!, lugar: lugarEvento!, hora: horaEvento!, organizador: organizadorEvento!, contacto: contactoEvento!, urlImagen: urlImagen)
                
                self.arregloEventos.append(nuevoEvento)
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData() //Recargamos la tabla
            })
        })
        
        task.resume()
        
    }
    
    func imgRespaldo(imagen: UIImageView){
        let urlImgRespaldo = "http://guaymas.gob.mx/wp-content/themes/aquiesguaymas/img/calendario/accion_civica_guaymas.jpg"
        if let img = imageCache[urlImgRespaldo]{
            imagen.image = img
        }
        else{
            let request = NSMutableURLRequest(URL: NSURL(string: urlImgRespaldo)!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    let img = UIImage(data: data!)
                    if img != nil {
                        self.imagenArray.append(img!)
                        self.imageCache[urlImgRespaldo] = img
                        imagen.image = img
                    }
                    
                })
            })
            
            task.resume()
        }
    }

}
