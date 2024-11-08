/*
Personas

De cada persona debe poder obtenerse: los recursos y si es o no destacado. 

En principio, corresponden estas definiciones:
- los recursos son las monedas que tiene una persona, inicialmente 20 para cualquier de ellas, pero puede ir variando con el tiempo.
- una persona es destacada si tiene entre 18 y 65 años o más de 30 de recursos. 

Además, a las personas le puede pasar : 
- ganar o gastar monedas, en una cantidad dada.
- cumplir años
*/

class Persona {
  var property recursos = 20;
  var property edad;

  method destacado() {
    return (edad >= 18 && edad <= 65) || recursos > 30;
  }

  method ganarMonedas(cantidad) {
    recursos += cantidad;
  }

  method gastarMonedas(cantidad) {
    recursos -= cantidad;
  }

  method cumplirAnios() {
    edad = edad+1;
  }

  method trabajar(){
    // No hace nada
  }
}

/*
Construcciones

Existen diferentes construcciones, de las cuales nos interesa averiguar su valor.
murallas: su valor depende de su longitud, a razón de 10 monedas por unidad de medida.
museo: su valor se calcula como su superficie cubierta multiplicada por su índice de importancia, que va de 1 a 5. 
*/

class Muralla {
  var property longitud;

  method valor() {
    return longitud * 10;
  }
}

class Museo {
  var property superficieCubierta;
  var property indiceImportancia;

  method valor() {
    return superficieCubierta * indiceImportancia;
  }
}

/*
Planetas

De cada planeta se conocen las personas que lo habitan. También se lleva el registro de las construcciones que se fueron efectuando en él.
 
Se tiene que poder obtener, para cada planeta
- la delegación diplomática, que está formada por todos los habitantes destacados y el habitante que tenga más recursos. Si llegara a coincidir que el habitante con más recursos fuera tambien destacado, mantiene su pertenencia a la delegación. 
- si es valioso: la condición es que el total del valor de todas las construcciones sea mayor a 100 monedas.
*/

class Planeta {
  var property habitantes = [];
  var property construcciones = [];

  method delegacionDiplomatica() {
    const destacados = habitantes.filter({h => h.destacado()});
    const masRico = habitantes.max({h => h.recursos()});
    if (!destacados.contains(masRico)) {
      destacados.add(masRico);
    }
    return destacados;
  }

  method esValioso() {
    return construcciones.sum({c => c.valor()}) > 100;
  }
}

/*
Además de las personas anteriores, existen algunas de ellas que tienen otras responsabilidades: productores y constructores. 

De cada productor se registran las técnicas que conoce (inicialmente todos saben "cultivo"). 
Los recursos de un productor es su cantidad de monedas, como para todas las personas, multiplicado por la cantidad de técnicas que conoce.
Un productor es destacado si cumple la condición común para todas las personas, o si conoce más de 5 técnicas.
 
Definir las siguientes acciones para los productores:
realizar una técnica durante una cantidad de tiempo: el efecto es ganar 3 monedas por cada unidad de tiempo, pero sólo en caso que conozca dicha técnica. P.ej. el efecto de realizar un cultivo durante un tiempo 5, es ganar 15 monedas. En caso que le pidan realizar an tarea que no conoce, pierde una unidad de sus recursos básicos.
aprender una técnica: hace que el productor conozca una nueva técnica.
trabajar durante una cantidad de tiempo en un planeta: implica realizar la última tecnica aprendida durante dicho tiempo, pero sólo en caso que sea el planeta en que vive el productor. 
*/

class Productor inherits Persona {
  var property tecnicas = ["cultivo"];

  override method recursos() {
    return recursos * tecnicas.size();
  }

  override method destacado() {
    return super() || tecnicas.size() > 5;
  }

  method realizarTecnica(tec, tiempo) {
    if (tecnicas.contains(tec)) {
      self.ganarMonedas(3 * tiempo);
    } else {
      self.gastarMonedas(1);
    }
  }

  method aprenderTecnica(tec) {
    tecnicas.add(tec);
  }

  method trabajar(planeta, tiempo) {
    if (planeta.habitantes().contains(self)) {
      self.realizarTecnica(tecnicas.last(), tiempo);
    }
  }
}

/*
De cada constructor se conoce la cantidad de construcciones realizadas y la región donde vive dentro del planeta. 
Los recursos de un constructor son sus monedas, como toda persona, más 10 monedas por cada construcción realizada.
Un constructor es destacado si realizó más de 5 construcciones, independientemente de su edad. 

Sus acciones son:
trabajar una determinada cantidad de tiempo en un planeta: Construye una construcción en el planeta dado, sin importar que sea el que vive. Además, gasta 5 monedas. (Lo que en definitiva es una inversión, porque sus recursos van a aumentar al tener una construcción más realizada) 
si vive en la montaña, construye una muralla. Su largo será igual a la mitad de las horas que trabaje.
si vive en la costa, construye un museo. Su superficie será igual a la cantidad de horas que trabaje y con nivel 1.
si vive en la llanura, depende: si no es destacado, construye una muralla (largo a la mitad de las horas que trabaje), pero si es destacado contruye un museo (la superficie será igual a la cantidad de horas que trabaje, pero con un nivel entre 1 y 5, proporcional a sus recursos)
agregar una nueva región y que lo que construya dependa de la inteligencia del constructor
*/

const regiones = ["montana", "costa", "llanura"];

class Constructor inherits Persona {
  var property construccionesRealizadas = 0;
  var property region;
  var property inteligencia; 

  override method recursos() {
    return recursos + 10 * construccionesRealizadas;
  }

  override method destacado() {
    return construccionesRealizadas > 5;
  }

  method trabajar(planeta, tiempo) {
    planeta.construcciones().add(self.construir(planeta, tiempo));
    self.gastarMonedas(5);
  }

  method construir(planeta, tiempo) {
    if (region == "montana") {
      return new Muralla(longitud = tiempo / 2);
    } else if (region == "costa") {
      return new Museo(superficieCubierta= tiempo, indiceImportancia= 1);
    } else if (region == "llanura") {
      if (self.destacado()) {
        const recursosMuseo = [5, recursos / 10].max();
        
        return new Museo(superficieCubierta= tiempo, indiceImportancia= recursosMuseo);
      } else {
        return new Muralla(longitud= tiempo / 2);
      }
    }
  }

  method agregarRegion(regionNueva) {
    regiones.add(regionNueva);
  }
}

/*
Para las personas que no son ni constructoras ni productoras, trabajar no les afecta ni altera el planeta.
*/

