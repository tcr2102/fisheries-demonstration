package org.piscoweb.smr.data
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.controls.SWFLoader;
	import mx.core.Application;
	
	public class Organism extends EventDispatcher
	{
		/**
		 * Can be used for yada yada yada 
		 */		
		public var org_type:String;
		private var _swf_url:String;
		public var swf:DisplayObject;
		public var relativeSize:Number;
		public var relativeAbundance:Number;
		public var a:Number;
		public var b:Number;
		public var mass:Number;
		public var fixed:Boolean = false;
		public var genus:String;
		public var species:String;
		
		public var org_placement:String = "below";
		public var placement_horizon:Number = 0;
		public var horizon_angle:Number = 0;
		
		
		public static const MOUSE_OVER:String = 'mouseover';
		public static const MOUSE_OUT:String = 'mouseout';		
		
		public function Organism(json:Object)
		{
			var aURL:Array=new Array();
			var myURL:String = "";
			aURL = Application.application.stage.loaderInfo.url.split("/");
			for (var count:int = 0; count < (aURL.length - 1); count++) {
				myURL +=aURL[count] +"/"
			}
			
			this.org_type = json['org_type'];
			this.relativeSize = json['relative_size'];
			this.relativeAbundance = json['relative_abundance']
			if(json['a'] && json['b']){
				this.a = json['a'];
				this.b = json['b'];
			}
			this.swf_url =myURL+ json['swf'];
			this.mass = json['mass'];
			if(json['static']){
				this.fixed = json['static'];
			}
			this.genus = json['genus'];
			this.species = json['species'];
			if(json['org_placement'] != undefined) this.org_placement = json['org_placement'];
			if(json['placement_horizon'] != undefined) this.placement_horizon = Number(json['placement_horizon']);
			if(json['horizon_angle'] != undefined) this.horizon_angle = Number(json['horizon_angle']);
			
		}
		
		public function get name():String
		{
			return this.genus + " " + this.species;
		}
		
		public function set swf_url(url:String):void
		{
			_swf_url = url;
		}
		
		public function get swfLoader():SWFLoader
		{
			
			var loader:SWFLoader = new SWFLoader();
			loader.source = this.swf_url;
			loader.trustContent = true;
			return loader;
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			var event:Event = new Event(MOUSE_OVER);
			this.dispatchEvent(event);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			var event:Event = new Event(MOUSE_OUT);
			this.dispatchEvent(event);
		}
		
		public function get swf_url():String
		{
			return _swf_url;
		}

	}
}