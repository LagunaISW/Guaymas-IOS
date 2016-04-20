//
//  DirectorioViewController.swift
//  Guaymas
//
//  Created by Saul Urias on 14/03/16.
//  Copyright © 2016 SaulUrias. All rights reserved.
//


import UIKit



class DirectorioViewController: UITableViewController {
    
    var arregloDirectorio = [Directorio]()
    
        override func viewDidLoad() {
        super.viewDidLoad()
       
         
        //Verificamos que el dispositivo tenga internet
        if(NetworkUtility.isConnectedToNetwork()){
            llamarWebService() //Mandamos llamar la función que crea la conexión al WebService
        }else{
            //Read the Data
            if let arregloDirectorio = NSUserDefaults.standardUserDefaults().objectForKey("telefonos"){
                let alert = UIAlertController(title: "Error de conexion", message: "Revisar Internet", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    void in print("Ok Pressed")}
                
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
            }
 
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("directorioCell") as UITableViewCell! //Cramos una celda para reutilizarla
        
        let directorio = arregloDirectorio[indexPath.row]
        
        let nombreLabel = cell.viewWithTag(1) as! UILabel
        nombreLabel.text = directorio.nombre
        nombreLabel.sizeToFit()
        
        let telefonoLabel = cell.viewWithTag(2) as! UILabel
        telefonoLabel.text = directorio.telefono
        telefonoLabel.sizeToFit()
        
        let direccionLabel = cell.viewWithTag(3) as! UILabel
        direccionLabel.text = directorio.direccion
        direccionLabel.sizeToFit()
        
        let paginaLabel = cell.viewWithTag(4) as! UILabel
        paginaLabel.text = directorio.pagina
        paginaLabel.sizeToFit()
        
        
        
        return cell
    }
    
    //Metodo Obligatorio que define el número de celdas en la tabla
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloDirectorio.count  //El número de celdas dependerá del tamaño del arreglo
    }
    
    //Metodo No obligatorio que define el número de secciones en la tabla
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1  //En este caso solo necesitamos una seccion
    }
    
    
    /**
     *Metodo para llenar la siguiente vista conforme la celda seleccionada
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let detailScene = segue.destinationViewController as? NextDirectorioViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedPhone = arregloDirectorio[indexPath.row]
            
            detailScene!.currentDirectorio = selectedPhone
        }
    }
  
    
    /**
     *Funcion que creamos para conectarnos con el WebService
     */
    func llamarWebService(){
  
        let err: NSError? = nil
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://app.guaymas.gob.mx/api2.php/dependencia")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        if err == nil {
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in //Creamos la tarea
                let json = JSON(data: data!)
                print(json.count)
                
                for i in 0 ..< json.count{
                    var nombre = json[i]["nombre"].string
                    var telefono = json[i]["telefono"].string
                    var direccion = json[i]["direccion"].string
                    var pagina = json[i]["web"].string
                    
                    if nombre == nil{nombre = "Nombre de dependencia no disponible"}
                    else if nombre == "" { nombre = "Nombre de dependencia no disponible"}
                    
                    if pagina == nil{pagina = "Página Web no disponible"}
                    else if pagina == "" { pagina = "Página Web no disponible"}
                    
                    if telefono == nil{telefono = "Telefono no disponible"}
                    else if telefono == "" { telefono = "Telefono no disponible"}
                    
                    if direccion == nil{direccion = "Dirección no disponible"}
                    else if direccion == "" { direccion = "Dirección no disponible"}
                    
                    let nuevoDirectorio = Directorio(nombre: nombre!, telefono: telefono!, direccion: direccion!, pagina: pagina!)
                    
                    self.arregloDirectorio.append(nuevoDirectorio)
                    
                }
                dispatch_async(dispatch_get_main_queue(), {
                    

                    self.tableView.reloadData() //Recargamos la tabla
                })
                NSUserDefaults.standardUserDefaults().setObject(self.arregloDirectorio as? AnyObject, forKey: "telefonos")
                NSUserDefaults.standardUserDefaults().synchronize()
            })
            task.resume()
        }else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Se generó un error"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        

        
        
    }
    }