import wollok.game.*

object juego{
	
	method intro(){
	    game.boardGround("imagenes/fondo.jpg")
	    game.width(14)
	    game.height(8)
	    titulo.aparecer()
	    game.schedule(5000,{self.tutorial()})
	}
	
	method tutorial(){
	   titulo.desaparecer()
	   tutorial.aparecer()
	   keyboard.n().onPressDo{self.modoNormal()}
	   keyboard.r().onPressDo{self.modoRapido()}
	}
	
	method modoNormal(){
		//npcs
		tutorial.desaparecer()
		const zombie1 = new Npc(x = 3, y = 5)
		const zombie2 = new Npc(x = 6, y = 5)
		const zombie3 = new Npc(x = 9, y = 5)
		const zombie4 = new Npc(x= 12, y = 5)
		const zombie5 = new Npc(x = 3, y = 2)
		const zombie6 = new Npc(x = 6, y = 2)
		const zombie7 = new Npc(x = 9, y = 2)
		const zombie8 = new Npc(x= 12, y = 2)
		const zombies = [zombie1,zombie2,zombie3,zombie4,zombie5,zombie6,zombie7,zombie8]
		const humano1 = new Humano(x = 7, y = 5)
		
		//introduccion al juego
		player.aparecer()
		zombies.forEach{zom => zom.aparecer()}
		humano1.aparecer()
		
		//funcionamientos basicos
		game.whenCollideDo(player,{npc => npc.golpeado()})
		game.onTick(1500, "movimiento",{zombies.forEach{zom => zom.moverse()}})
	}
	
	method modoRapido(){
		tutorial.desaparecer()
		const zombie1 = new ZombiRapido(x = 13, y = 7)
		const zombie2 = new ZombiRapido(x = 11, y = 7)
		const zombie3 = new ZombiRapido(x = 9, y = 7)
		const zombie4 = new ZombiRapido(x= 12, y = 5)
		const zombie5 = new ZombiRapido(x = 10, y = 5)
		const zombie6 = new ZombiRapido(x = 8, y = 5)
		const zombies = [zombie1,zombie2,zombie3,zombie4,zombie5,zombie6]
		const humano1 = new Humano(x = 7, y = 5)
		
		//introduccion al juego
		player.aparecer()
		zombies.forEach{zom => zom.aparecer()}
		humano1.aparecer()
		
		//funcionamientos basicos
		game.whenCollideDo(player,{npc => npc.golpeado()})
		game.onTick(500, "movimiento",{zombies.forEach{zom => zom.moverse()}})
	}
}

object player{
	var property image = "imagenes/jug2.png"
	var property position = game.at(1,1)
	var vidas = 3
	var puntos = 0
	
	method aparecer(){
		game.addVisualCharacter(self)
	}
	method perderVida(){
		game.say(self,"ay")
		vidas = vidas - 1 
		self.finDelJuego()
	}
	
	method sumarVidas(){
		vidas = vidas + 1 
	}
	method sumarPuntos(){
		puntos= puntos + 1
		self.finDelJuego()
	}
	
	method finDelJuego(){
		if (vidas == 0 or puntos >= 100){
			game.stop()
		}
	}
}

class Npc{
	var property image = "imagenes/jugador.jpg"
	var property position = game.at(10,5) 
	var property x 
	var property y
	 	
	method aparecer(){
		position = game.at(x,y)
		game.schedule(500.randomUpTo(1500),{game.addVisual(self)})
	}
	method desaparecer(){
		game.removeVisual(self)
	}
	
	method objetivo(){
		if (position.x() == 0 and position.y() == 0){
		 player.perderVida()
		 self.golpeado()
		}
	}
	method moverse(){
		const direccion = game.at(0,0)
		const newX = position.x() - if (direccion.x() < position.x())  1 else  0
		const newY = position.y() - if (direccion.y() < position.y())  1 else  0
		position = game.at(newX,newY)
		self.objetivo()
	}

	method golpeado(){
		player.sumarPuntos()
		self.desaparecer()
		self.aparecer()
	}

}
class Humano{ 
	var property image = "imagenes/npc2.jpg"
	var property position = game.at(10,5) 
	var property x 
	var property y
	
	method desaparecer(){
		game.removeVisual(self)
		game.removeTickEvent("mov")
	}
	
	method moverse(){
		const direccion = game.at(0,0)
		const newX = position.x() - if (direccion.x() < position.x())  1 else  0
		const newY = position.y() - if (direccion.y() < position.y())  1 else  0
		position = game.at(newX,newY)
		self.objetivo()
	}
	
	method objetivo(){
		if (position.x() == 0 and position.y() == 0){
			self.desaparecer()
			player.sumarVidas()
		}
	}
	
	method aparecer(){
		position = game.at(x,y)
		game.schedule(1000.randomUpTo(10000),{game.addVisual(self)
			game.onTick(1500,"mov",{self.moverse()})
		})
		
	}
	method golpeado(){
		self.desaparecer()
		player.perderVida()
	}
}

class ZombiRapido inherits Npc{
	override method aparecer(){
		position = game.at(x,y)
		game.schedule(500,{game.addVisual(self)})
	}	
}
object titulo{
	var property image = ("imagenes/fondoInicio.jpg")
	var property position = game.at(0,0)
	
	method aparecer(){
		game.addVisual(self)
	}
	
	method desaparecer(){
		game.removeVisual(self)
	}
}

object tutorial{
	var property image = ("imagenes/tutorial.jpg")
	var property position = game.at(0,0)
	
	method aparecer(){
		game.addVisual(self)
	}
	
	method desaparecer(){
		game.removeVisual(self)
	}
	

}
