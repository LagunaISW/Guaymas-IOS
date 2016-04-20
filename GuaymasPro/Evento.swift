//
//  File.swift
//  Guaymas
//
//  Created by Oscar Dena on 13/03/16.
//  Copyright © 2016 SaulUrias. All rights reserved.
//

import Foundation

struct Evento {
    let tituloEvento: String
    let descripcionEvento: String
    let fechaEvento: String
    let lugarEvento: String
    let horaEvento: String
    let organizadorEvento: String
    let contactoEvento: String
    let urlImagenEvento: String
    
    /**
     *Inicializador o constructor de la clase Noticia
     */
    init(titulo: String, descripcion: String, fecha: String, lugar: String, hora: String, organizador: String, contacto: String, urlImagen: String){
        
        self.tituloEvento = titulo
        self.descripcionEvento = descripcion
        self.fechaEvento = fecha
        self.lugarEvento = lugar
        self.horaEvento = hora
        self.organizadorEvento = organizador
        self.contactoEvento = contacto
        self.urlImagenEvento = urlImagen
    }
}