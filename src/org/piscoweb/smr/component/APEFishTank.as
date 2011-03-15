package org.piscoweb.smr.component
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import org.cove.ape.Vector;
	import org.cove.ape.VectorForce;
	
	public class APEFishTank extends Canvas implements IFishTank
	{
		private var sprite:APEFishTankSprite;
		
		public static const GAP:int = 1;
		
		public function APEFishTank()
		{
		}
		
		public function start():void
		{
//			trace('started: width: '+this.width);
			sprite = new APEFishTankSprite();
			var uiref:UIComponent = new UIComponent();
			uiref.width = this.width;
			uiref.height = this.height;
			this.addChild(uiref);
			uiref.addChild(sprite);
//			trace('uiref width: '+uiref.width);
			sprite.addBounds(this.width, this.height);
		}
		
		public function addParticle(particle:APEOrganismParticle):void
		{
			particle.inWater = true;
			particle.onUpdate = onOrgUpdate;
			sprite.addParticle(particle);
//			trace('particle added');	
		}
		
		public function removeParticle(particle:APEOrganismParticle):void
		{
			particle.inWater = false;
			sprite.removeParticle(particle);
//			trace('particle removed');
		}
		
		private function onOrgUpdate(particle:APEOrganismParticle):void
		{
	
			if(particle.position.x < (particle.displayObject.width * -1 - GAP) || particle.position.x > this.width + GAP){
				this.outOfBounds(particle);
			}
		}
		
		private function outOfBounds(particle:APEOrganismParticle):void
		{
			var position:Vector;
			if(particle.px > 0){
				// went out the right side
				position = new Vector(particle.displayObject.width*-1 - GAP, particle.py);
			}else{
				// went out the left side
				position = new Vector(this.width+GAP, particle.py);
			}
			var velocity:Vector = particle.velocity;
			particle.position = position;
			particle.velocity = velocity;
		}
		
		public function pause():void
		{
			sprite.pause();
		}
		
		public function resume():void
		{
			sprite.resume();
		}
		
		public function waitThenCall(func:Function, frames:int):void
		{
			this.sprite.waitThenCall(func, frames);
		}
		
	}
}