object pepita {
  var energia = 100
  var position = game.at(1, 1)
  
  method estaCansada() = energia < 20
  
  method volar(metros) {
    energia -= metros * 10
  }
  
  method comer(comida) {
    energia += comida.energia()
  }
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method image() = "pepita.png"
}

object alpiste {
  var position = game.at(5, 5)
  
  method energia() = 5
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method image() = "alpiste.png"

  method reaccionar(alguien) {
    alguien.comer(self)
  }
}

object manzana {
  var llegoAMadurez = false
  var madurez = 0
  var position = game.at(3, 4)
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method image() {
    if (llegoAMadurez) {
      return "manzana.png"
    } else {
      return "manzanaVerde.png"
    }
  }
  
  // Inicialmente la manzana otorga 50 calorías.
  // La maduración se da de a saltos de 10%, hasta llegar al 100% de maduración en el que la manzana otorga 100 calorías.
  method energia() {
    if ((madurez <= 0) && llegoAMadurez) {
      return 0
    }
    return 50 + ((madurez / 10) * 5)
  }
  
  // Modelamos la maduración de la manzana como un porcentaje, de 0 a 100, y queremos que la manzana entienda un mensaje "madurar", que primero la hace madurar y, pasado cierto tiempo, pudrirse.
  // Luego, la manzana comienza a pudrirse, y cada vez que recibe el mensaje "madurar" debe perder 20 calorías.
  // En ningún caso la manzana podrida puede otorgar menos de 0 calorías.
  method madurar() {
    if (llegoAMadurez) {
      if (madurez > 0) {
        madurez -= 40
      } else {
        madurez = 0
      }
    } else {
      madurez += 10
      if (madurez >= 100) {
        llegoAMadurez = true
      }
    }
  }

  method reaccionar(alguien) {
    alguien.comer(self)
  }
}

object nido {
  var position = game.at(1.randomUpTo(10), 1.randomUpTo(10))
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method comer() {
    game.stop()
  }
  
  method image() = "nido.png"
  
  method reaccionar(alguien) {
    game.say(self, "ganaste!!")
    game.removeTickEvent("movimiento")
    game.schedule(2000, { game.stop() })
  }
}