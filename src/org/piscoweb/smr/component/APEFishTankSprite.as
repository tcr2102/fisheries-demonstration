package org.piscoweb.smr.component
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.cove.ape.*;
	public class APEFishTankSprite extends Sprite
	{
		private var callback:Function;
		private var callbackTimer:int = 0;
		private var callonframe:int;
		public var defaultGroup:Group;
		private var paused:Boolean = false;
		public function APEFishTankSprite()
		{
			addEventListener(Event.ENTER_FRAME, run);
			APEngine.init(1/4);
			APEngine.container = this;
			APEngine.constraintCycles = 0.5;
			APEngine.damping = 0.98;
			
			defaultGroup = new Group();
			defaultGroup.collideInternal = true;
			
			
			APEngine.addGroup(defaultGroup);
//			APEngine.addForce(new VectorForce(false, 0, 0));
		}
		
		private function run(event:Event):void
		{
//			if(!this.paused){
				APEngine.step();
				APEngine.paint();
//			}
		}
		
		public function addBounds(width:int, height:int):void
		{
			//x, y, width, height
			var top:RectangleParticle = new RectangleParticle(width/2, 0, width * 3, 20, 0, true, 10, 0.2, 0);
			var bottom:RectangleParticle = new RectangleParticle(width/2, height, width * 3, 3, 0, true, 10, 0.2, 0);
			bottom.setDisplay(new Sprite());
			top.setDisplay(new Sprite());
			defaultGroup.addParticle(top);
			defaultGroup.addParticle(bottom);			
		}
		
		public function addParticle(particle:APEOrganismParticle):void
		{
			defaultGroup.addParticle(particle);
//			trace('particle added to defaultGroup');
//			trace(particle.position, particle.velocity);
			
		}
		
		public function removeParticle(particle:APEOrganismParticle):void
		{
			defaultGroup.removeParticle(particle);
//			trace('particle removed from defaultGroup');
		}
		
		public function pause():void
		{
			this.removeEventListener(Event.ENTER_FRAME, run);	
//			this.paused = true;
		}
		
		public function resume():void
		{
			this.addEventListener(Event.ENTER_FRAME, run);
		}
		
		public function waitThenCall(callback:Function, frames:int):void
		{
			this.callbackTimer = 0;
			this.callback = callback;
			this.callonframe = frames;
			this.addEventListener(Event.ENTER_FRAME, handleWait);
		}
		
		private function handleWait(e:Event):void
		{
			if(this.callonframe <= this.callbackTimer){
				this.callback();
				this.removeEventListener(Event.ENTER_FRAME, this.handleWait);
			}else{
				this.callbackTimer += 1;
			}
		}
		
	}
}