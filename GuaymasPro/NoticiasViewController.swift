//
//  TableViewController.swift
//  Guaymas
//
//  Created by Jhonatan Laguna on 23/02/16.
//  Copyright © 2016 Lagunajs. All rights reserved.
//


/**
 *Controlador de la vista que contiene la lista de noticias
 *Se controla la información de las celdas
 *Se controla la cantidad de celdas
 *Se controla la cantidad de secciones
 *Se controla la conexión a la siguiente vista
 *Creamos conexión a un WebService
 */

import UIKit

class NoticiasViewController: UITableViewController{
    
    
    
    /**
     *Arreglo que recibe objetos Noticia
     */
    var arregloNoticias = [Noticia]()
    var imageCache = [String: UIImage]() //imagenes descargadas
    var imagenArray = [UIImage]()
    
    /**
     *Funcion que nos indica cuando la vista esta cargada
     *En esta función llamamos todo lo que queremos que se ejecute al entrar en la pantalla
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Noticias Cargadas") //Imprimimos en consola para comprobar que la visa fue cargada
        
        //Verificamos que el dispositivo tenga internet
        if(NetworkUtility.isConnectedToNetwork()){
            llamarWebService() //Mandamos llamar la función que crea la conexión al WebService
        }else{
            let alert = UIAlertView()
            alert.title = "Alerta"
            alert.message = "Error de conexion"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    /**
     *Metodo que nos indica un error en memoria
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     *Metodos para controlar la tabla en la que desplegamos las noticias
     */
    //Este metodo es obligatorio y su función es llenar las celdas
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("noticiaCell") as UITableViewCell! //Cramos una celda para reutilizarla
        //Se reutiliza con el identificador
        let tituloLabel = cell.viewWithTag(2) as! UILabel  //Label que mostrara el titulo y se define con el tag 2 que asignamos en el storyboard
        let noticia = arregloNoticias[indexPath.row]  //Obtenemos una noticia por cada celda
        let titulo = noticia.titulo //Obtenemos el titulo de la noticia
        
        tituloLabel.text = titulo  //Mostramos el titulo recortado en el label
        
        let imagen = cell.viewWithTag(3) as! UIImageView //Obtenemos el ImageView
        
        /*
         >>>>>>>>>>>>>>>>>>>>>>>>INICIA: Carga de la imagen <<<<<<<<<<<<<<<<<<<<<<<<<<<<
         */
        if let img = self.imageCache[noticia.titulo]{ //revisamos si la imagen ya ha sido descargada
            imagen.image = img //si ya se encuentra en cache se utiliza
        }
        else{ //de lo contrario se descarga
            let request = NSMutableURLRequest(URL: NSURL(string: noticia.urlImagen)!) //Creamos el Request y asignamos la URL
            let session = NSURLSession.sharedSession() //Creamos la Session
            request.HTTPMethod = "GET" //Especificamos el method a utilizar
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in //Creamos la tarea
                dispatch_async(dispatch_get_main_queue(), { // lo corremos en el hilo principal
                    let img = UIImage(data: data!) //Convertimos el data en UIImage
                    
                    self.imagenArray.append(img!)
                    
                    
                    self.imageCache[noticia.titulo] = img //guardamos la imagen en cache
                    imagen.image = img //cargamos la imagen en el imageview
                })
            }) //Asignamos la imagen a su imageview correspondiente
            
            task.resume() //Ejecutamos la tarea
        }
        /*
         >>>>>>>>>>>>>>>>>>>>>>>> TERMINA: Carga de la imagen <<<<<<<<<<<<<<<<<<<<<<<<<<<<
         */
        

        
        return cell
    }
    
    //Metodo Obligatorio que define el número de celdas en la tabla
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloNoticias.count  //El número de celdas dependerá del tamaño del arreglo
    }
    
    //Metodo No obligatorio que define el número de secciones en la tabla
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1  //En este caso solo necesitamos una seccion
    }
    
    
    
    
    
    /**
     *Metodo para llenar la siguiente vista conforme la celda seleccionada
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let detailScene = segue.destinationViewController as? NextNoticiasViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedNoticia = arregloNoticias[indexPath.row]
            
            let selectedImage = imagenArray[indexPath.row]
            
            detailScene!.currentNoticia = selectedNoticia
            detailScene!.currentImagen = selectedImage
        }
    }
    
    
    /**
     *Funcion que creamos para conectarnos con el WebService
     */
    func llamarWebService(){
        let request = NSMutableURLRequest(URL: NSURL(string: "http://guaymas.gob.mx/api/get_posts/?count=10&page")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in //Creamos la tarea
            let json = JSON(data: data!)
            for i in 0 ..< 10 { //Recorremos el arreglo de noticias
                let titulo = json["posts"][i]["title"].string   //Accedemos al JSON y obtenemos el titulo en String
                let content = json["posts"][i]["content"].string?.stringByDecodingHTMLEntities()?.stringByDecodingHTMLEscapeCharacters() //Accedemos al JSON y obtenemos la descripcion en String
                let date = json["posts"][i]["date"].string  //Accedemos al JSON y obtenemos la fecha en String
                var url = json["posts"][i]["attachments"][0]["images"]["custom-size"]["url"].string //obtenemos la url de la imagen
                //Calidades disponibles: full: 750x497, medium: 250x156, large: 700x464, small: 120x80, custom-size: 700x200, thumbnail: 150x150.
                if url == nil{url = "http://i.imgur.com/Xco2rc3.png"}
                let nuevaNoticia = Noticia(titulo: titulo!, descripcion: content!, fecha: date!, urlImagen: url!) //Creamos un objeto noticia
                self.arregloNoticias.append(nuevaNoticia) //Agregamos ese objeto noticia en nuestro arreglo
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData() //Recargamos la tabla
            })
        })
        
        task.resume()
        
    }
    
}