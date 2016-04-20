//
//  Directorio.swift
//  Guaymas
//
//  Created by Saul Urias on 14/03/16.
//  Copyright © 2016 SaulUrias. All rights reserved.
//

import Foundation
struct Directorio {
    let nombre: String
    let telefono: String
    let direccion: String
    let pagina: String
    
    /**
     *Inicializador o constructor de la clase Directorio
     */
    init(nombre: String, telefono: String, direccion: String, pagina: String){
        self.nombre = nombre
        self.telefono = telefono
        self.direccion = direccion
        self.pagina = pagina
    }
}