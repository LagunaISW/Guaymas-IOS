//
//  Noticia.swift
//  Guaymas
//
//  Created by Saul Urias on 22/02/16.
//  Copyright © 2016 SaulUrias. All rights reserved.
//

/**
*Clase que contiene los atributos del objeto Noticia
*/

import Foundation

struct Noticia {
    let titulo: String
    let descripcion: String
    let fecha: String
    let urlImagen: String
    
/**
*Inicializador o constructor de la clase Noticia
*/
    init(titulo: String, descripcion: String, fecha: String, urlImagen: String){
        self.titulo = titulo
        self.descripcion = descripcion
        self.fecha = fecha
        self.urlImagen = urlImagen
    }
}