object pepita {
	var energia = 100

	method estaCansada() = energia < 20

	method volar(metros) {
		energia = energia - metros * 10
	}

	method comer(comida) {
		energia += comida.energia()
	}
}

object alpiste {
	method energia() = 5
}

object manzana {
  var llegoAMadurez = false
	var madurez = 0
	
  // Inicialmente la manzana otorga 50 calorías.
  // La maduración se da de a saltos de 10%, hasta llegar al 100% de maduración en el que la manzana otorga 100 calorías.
	method energia() {
    if (madurez <= 0 && llegoAMadurez) {
      return 0
    }
		return 50 + (madurez / 10) * 5
	}
	
  // Modelamos la maduración de la manzana como un porcentaje, de 0 a 100, y queremos que la manzana entienda un mensaje "madurar", que primero la hace madurar y, pasado cierto tiempo, pudrirse.
  // Luego, la manzana comienza a pudrirse, y cada vez que recibe el mensaje "madurar" debe perder 20 calorías.
  // En ningún caso la manzana podrida puede otorgar menos de 0 calorías.
	method madurar() {
    if (llegoAMadurez) {
      if (madurez > 0) {
        madurez = madurez - 40
      } else {
        madurez = 0
      }
    } else {
      madurez = madurez + 10
      if (madurez >= 100) {
        llegoAMadurez = true
      }
    }
  }
}