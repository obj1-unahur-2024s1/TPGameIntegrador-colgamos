import wollok.game.*

object juego{
	
	method intro(){
	    game.boardGround("imagenes/fondo.jpg")
	    game.width(14)
	    game.height(7)
	    titulo.aparecer()
	    game.schedule(5000,{self.tutorial()})
	}

	method tutorial(){
	   titulo.desaparecer()
	   tutorial.aparecer()
	   keyboard.n().onPressDo{self.modoNormal()}
	   keyboard.r().onPressDo{self.modoZombiesMalos()}
	}
	
	method modoNormal(){
		//npcs
		tutorial.desaparecer()
		const zombie1 = new Zombie(x = 13, y = 6)
		const zombie2 = new Zombie(x = 13, y = 5)
		const zombie3 = new Zombie(x = 13, y = 4)
		const zombie4 = new Zombie(x = 13, y = 2)
		const zombie5 = new Zombie(x = 13, y = 3)
		const zombie6 = new Zombie(x = 13, y = 0)
		const zombie7 = new Zombie(x = 13, y = 1)
		const zombies = [zombie1,zombie2,zombie3,zombie4,zombie5,zombie6,zombie7]
		const humano1 = new Humano(x = 7, y = 5)
		
		//introduccion al juego
		player.aparecer()
		zombies.forEach{zom => zom.aparecer()}
		humano1.aparecer()
		
		//funcionamientos basicos
		game.whenCollideDo(player,{npc => npc.perderVida()})
	}
	
	method modoZombiesMalos(){
		tutorial.desaparecer()
		
		
		game.onTick(3000,"zombie",{new ZombieAgresivo(x= 12.randomUpTo(14), y= 0.randomUpTo(7)).aparecer()})
		
		//introduccion al juego
		player.aparecer()
		
		//funcionamientos basicos
		game.whenCollideDo(player,{npc => npc.perderVida()})
	}
	
	method aparecer(){}
	
	method desaparecer(){}
	
	method perderVida(){}
	
	method objetivo(){}
	
	method moverse(){}
	
	method sumarPuntos(){}
}

object player{
	var property image = "imagenes/Player-removebg-preview.png"
	var property position = game.at(1,3)
	var vidas = 3
	var puntos = 0
	
	method aparecer(){
		game.addVisualCharacter(self)
	}
	
	method desaparecer(){
		game.removeVisual(self)
	}
	
	method perderVida(){
		game.say(self,"ay")
		vidas = vidas - 1 
		self.objetivo()
	}
		
	method sumarPuntos(){
		puntos= puntos + 1
		self.objetivo()
	}
	
	method objetivo(){
		if (vidas == 0){
			derrota.aparecer()
			game.schedule(10000,game.stop())
		}else if(puntos == 100){
			victoria.aparecer()
			game.schedule(10000,game.stop())
		}
	}

    method moverse(){}
    
    method intro(){}
	
	method tutorial(){}
	
	method modoNormal(){}
	
	method modoZombiesMalos(){}
}

class Npc{
	var property image = "imagen"
	var property position = game.at(10,5) 
	var property x 
	var property y
	 	
	method aparecer(){
		position = game.at(x,y)
		game.schedule(500.randomUpTo(1500),{game.addVisual(self)})
	}
	
	method desaparecer(){
		game.removeVisual(self)
		self.aparecer()
	}
	
	method objetivo(){
		if (position.x() == 0 and position.y() == 3){
		 self.desaparecer()
		}
	}
	
	method moverse(){
		const newX = position.x() - if (0 < position.x())  1 else  0
		const newY = position.y() - if (0 == position.x() && position.y() >3)  1 else if  (0 == position.x() && position.y() <3) -1 else 0
		position = game.at(newX,newY)
		self.objetivo()
	}

	method perderVida(){
		self.desaparecer()
	}

    method sumarPuntos(){}

	method intro(){}
	
	method tutorial(){}
	
	method modoNormal(){}
	
	method modoZombiesMalos(){}
}
class Humano inherits Npc{ 
	
	 override method objetivo(){
		if (position.x() == 0 and position.y() == 3){
			self.desaparecer()
			game.removeTickEvent("moverse")
		}
	}
	
	 override method aparecer(){
	 	image = "imagenes/npc2-removebg-preview.png"
		position = game.at(x,y)
		game.schedule(1000.randomUpTo(10000),{game.addVisual(self)
			game.onTick(1500,"moverse",{self.moverse()})
		})
		
	}
	 
     override method perderVida(){
		self.desaparecer()
		player.perderVida()
		game.removeTickEvent("moverse")
	}
}

class Zombie inherits Npc{
	override method aparecer(){
		image = ("imagenes/Zombie-removebg-preview.png")
		position = game.at(x,y)
		game.schedule(1500,{game.addVisual(self)
			game.onTick(1500,"movimiento",{self.moverse()})
		})
		}
	
	override method objetivo(){
		if (position.x() == 0){
		  self.desaparecer()
		  player.perderVida()
		  game.removeTickEvent("movimiento")
		}
	}
	
	override method perderVida(){
		super()
		player.sumarPuntos()
		game.removeTickEvent("movimiento")
	}
}


class ZombieAgresivo inherits Npc {
	override method aparecer(){
	    image = ("imagenes/Zombie-removebg-preview.png")
		position = game.at(x,y)
		self.objetivo()
		game.schedule(1000,{game.addVisual(self)
			game.onTick(1000,"movimiento",{self.moverse()})
		})
		}
	
	override method moverse(){
		const direccion = player.position()
		const newY = position.y() - if ( position.y() < direccion.y()) -1 else 1
		const newX = position.x() - if (  position.x() < direccion.x()) - 1 else 1
		position = game.at(newX,newY)
	}
	
	override method objetivo(){
		game.onTick(1000,"puntos",{player.sumarPuntos()})
	}
	override method perderVida(){
		super()
		player.perderVida()
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
	
	method perderVida(){}
	
	method objetivo(){}
	
	method moverse(){}
	
	method sumarPuntos(){}
	
	method intro(){}
	
	method tutorial(){}
	
	method modoNormal(){}
	
	method modoZombiesMalos(){}
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
	
	method perderVida(){}
	
	method objetivo(){}
	
	method moverse(){}
	
	method sumarPuntos(){}
	
	method intro(){}
	
	method tutorial(){}
	
	method modoNormal(){}
	
	method modoZombiesMalos(){}

}

object victoria{
	var property image = ("imagenes/GameOverVic.jpg")
	var property position = game.at(0,0)
	
	method aparecer(){
		game.addVisual(self)
	}
	
	method desaparecer(){
		game.removeVisual(self)
	}
	
	method perderVida(){}
	
	method objetivo(){}
	
	method moverse(){}
	
	method sumarPuntos(){}
	
	method intro(){}
	
	method tutorial(){}
	
	method modoNormal(){}
	
	method modoZombiesMalos(){}
}

object derrota{
	var property image = ("imagenes/GameOver.jpg")
	var property position = game.at(0,0)
	
	method aparecer(){
		game.addVisual(self)
	}
	
	method desaparecer(){
		game.removeVisual(self)
	}
	
	method perderVida(){}
	
	method objetivo(){}
	
	method moverse(){}
	
	method sumarPuntos(){}
	
	method intro(){}
	
	method tutorial(){}
	
	method modoNormal(){}
	
	method modoZombiesMalos(){}
}
