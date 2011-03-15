package org.piscoweb.smr.component
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	
	import org.cove.ape.CircleParticle;
	import org.cove.ape.Vector;
	import org.piscoweb.smr.data.DataPoint;
	import org.piscoweb.smr.data.Organism;

	public class APEOrganismParticle extends CircleParticle
	{
		public static const MOUSE_OVER:String = 'mouseoverparticle';
		public static const MOUSE_OUT:String = 'mouseoutparticle';
		public static const LOADED:String = 'loaded';
		public static const CLICK:String = 'orgclick';
		
		
		public static const ELASTICITY:Number = 0.4;
		public static const FRICTION:Number = 0;
		public static const DEFAULT_SIZE:int = 55;
		public static const LEFT:int = 0;
		public static const RIGHT:int = 1;
		
		public var alreadyLoaded:Boolean = false;
		public var dataPoint:DataPoint;
		public var displayObject:DisplayObject;
		public var loaded:Boolean = false;
//		private var loader:SWFLoader;
		private var image:Image;
		private var loader:Loader;
		public var displayBefore:Boolean;
		public var displayAfter:Boolean;
		public var inWater:Boolean = false;
		public var organism:Organism;
		public var displayObjectWidth:int;
		private var _direction:int;
		private var growCallback:Function;
		private var growEffect:Resize = new Resize();
		private var _x:int;
		private var _y:int;
		
		
		public var onUpdate:Function = function(org:APEOrganismParticle):void{
		}
		
		public function APEOrganismParticle(x:Number, y:Number, organism:Organism, sizeRatio:Number)
		{
			this.organism = organism;
			this.displayObjectWidth = APEOrganismParticle.DEFAULT_SIZE * sizeRatio * organism.relativeSize;
			super(
				x,
				y,
				this.displayObjectWidth * 0.4,
				organism.fixed,
				organism.mass,
				APEOrganismParticle.ELASTICITY, 
				APEOrganismParticle.FRICTION
			);
			
			this._direction = LEFT;
			this.loadSWF();
		}
		
		public function hide():void
		{
			this.displayObject.alpha = 0;
		}
		
		private function loadSWF():void
		{
//			this.loader = this.organism.swfLoader;
//			this.loader = new Loader();
//			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishLoadingSWF);
//			this.loader.load(new URLRequest(this.organism.swf_url));
			this.image = new Image();
			this.image.source = this.organism.swf_url;
//			this.image.load(this.organism.swf_url);
			this.image.trustContent = true;
			this.image.load();
			this.image.loaderContext.checkPolicyFile = true;
//			this.displayObject = this.image.content;
			this.image.addEventListener(Event.INIT, finishLoadingSWF);
		}
		
		private function finishLoadingSWF(e:Event):void
		{
//			trace('finishLoadingSWF');
//			this.displayObject = this.image.content;

			this.displayObject = new Sprite();
			Sprite(this.displayObject).addChild(this.image.content);
			this.setDisplay(this.displayObject);

			this.displayObject.width = this.displayObjectWidth;
			this.displayObject.scaleY = this.displayObject.scaleX;
			this.displayObject.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.displayObject.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.displayObject.addEventListener(MouseEvent.CLICK, onClick);
			this.loaded = true;
			this.dispatchEvent(new Event(LOADED));
			_x = this.displayObject.x;
			_y = this.displayObject.y;
//			trace(_x, _y);
		}
		
		private function updateOrientation(e:Event):void
		{
		
			if(this.velocity.x > 0){
				this.direction = RIGHT;
			}else{
				this.direction = LEFT;
			}
		}
		
		[Bindable]
		public function set direction(direction:int):void
		{
			if(displayObject !=null){
				if(direction == RIGHT && this._direction != RIGHT){
	//				trace(this.organism.name);
	//				trace('setting to RIGHT orientation');
					// if this is not there AFTER fish get off-center somehow
					// make sure always negative
					if(this.displayObject.scaleX < 0){
						var scale:Number = this.displayObject.scaleX
					}else{
						var scale:Number = this.displayObject.scaleX * -1
					}
					this.displayObject.scaleX = scale;
	//				trace('setting scaleX to: '+scale);
					var x:int = _x + this.displayObject.width;
	//				trace('setting x to: '+x);
					this.displayObject.x = x;
				}else if(direction == LEFT && this._direction != LEFT){
	//				trace(this.organism.name);
	//				trace('setting to LEFT orientation');
					// make sure always positive
					if(this.displayObject.scaleX > 0){
						var scale:Number = this.displayObject.scaleX
					}else{
						var scale:Number = this.displayObject.scaleX * -1
					}
	//				trace('setting scaleX to: '+scale);
					this.displayObject.scaleX = scale;
	//				trace('setting x to: '+_x);
					this.displayObject.x = _x;
				}
	//			trace('--------');
				this._direction = direction;
			}
		}
		
		public function get direction():int
		{
			return this._direction;
		}
		
		private function onClick(e:MouseEvent):void
		{
			var event:Event = new Event(CLICK);
			this.dispatchEvent(event);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
//			trace('onMouseOver');
			var event:Event = new Event(MOUSE_OVER);
			this.dispatchEvent(event);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			var event:Event = new Event(MOUSE_OUT);
			this.dispatchEvent(event);
		}
		
		public function changeSize(ratio:Number, animate:Boolean=false, callback:Function=null):void
		{
//			animate = true;
			if(animate){
				if(callback){
					this.growEffect.addEventListener(EffectEvent.EFFECT_END, callback);
				}
				var resizeTarget:UIComponent = new UIComponent();
				resizeTarget.addChild(this.displayObject);
				this.growEffect.target = this.displayObject;
				this.growEffect.widthTo = this.displayObject.width * ratio;
				this.growEffect.heightTo = this.displayObject.height * ratio;
				this.growEffect.play();
			}else{
				this.displayObject.width = this.displayObjectWidth * Math.sqrt(ratio);
				this.displayObject.scaleY = this.displayObject.scaleX;
			}
		}
		
		public function resetSize(animate:Boolean):void
		{
			
		}
		
		public override function update(dt2:Number):void
		{
			super.update(dt2);
			this.onUpdate(this);
			
		}
		
		public override function set velocity(v:Vector):void
		{
			super.velocity = v;
//			updateOrientation(new Event(''));
		}
		
	}
}