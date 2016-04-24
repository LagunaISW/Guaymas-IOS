//
//  ReportesViewController.swift
//  GuaymasPro
//
//  Created by Jhonatan Laguna on 22/04/16.
//  Copyright © 2016 Jhonatan Laguna. All rights reserved.
//


//url post appg6.guaymas.gob.mx/reporteciudadano/enviar_reporte.php

//Estructura del method
// medio = web, nombre, dir, colonia, tel, mail, asunto, lat, long, tipo, foto

import UIKit
import MediaPlayer
import MobileCoreServices

class ReportesViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    var myImage: UIImage!
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var dir: UITextField!
    @IBOutlet weak var colonia: UIPickerView!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var asunto: UITextField!
    @IBOutlet weak var camara: UIButton!
    @IBOutlet weak var mapa: UIButton!
    @IBOutlet weak var enviar: UIButton!
    
    @IBAction func tomarFoto(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.showsCameraControls = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImagePNGRepresentation(image)! as NSData
        
        //save in photo album
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ReportesViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        //save in documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        
        
        let filePath = (documentsPath! as NSString).stringByAppendingPathComponent("pic.png")
        imageData.writeToFile(filePath, atomically: true)
        
        myImage = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>){
        if(error != nil){
            print("ERROR IMAGE \(error.debugDescription)")
        }
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}