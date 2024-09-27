object cartaPikachu {
  method valor() = 10
  
  method revalorizar() {
    
  }
}

object cartaYugiOh {
  var antiguedad = 100
  
  method valor() = antiguedad * 7
  
  method revalorizar() {
    antiguedad += 1
  }
}

object anchoDeEspadas {
  method valor() = 700
  
  method revalorizar() {
    
  }
}

object luisLuis {
  const cartas = []
  var property dinero = 0
  
  method conseguirCarta(unaCarta) {
    cartas.add(unaCarta)
  }
  
  method tieneCarta(unaCarta) = cartas.contains(unaCarta)
  
  method vender() {
    dinero += cartas.first().valor()
    cartas.remove(cartas.first())
  }
  
  method cuantasCartas() = cartas.size()
  
  method cotizacion() = cartas.sum({ c => c.valor() })
  
  method tieneAlgunaCartaMuyValiosa() = cartas.any({ c => c.valor() > 500 })
  
  method lasCartasMuyValiosas() = cartas.filter({ c => c.valor() > 500 })
  
  method listaDeValores() = cartas.map({ c => c.valor() })
  
  method cartaMasValiosa() = cartas.max({ c => c.valor() })

  method visitarExperto() {
    cartas.forEach({ c => c.revalorizar() })
  }
}