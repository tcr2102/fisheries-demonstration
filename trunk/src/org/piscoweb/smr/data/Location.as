package org.piscoweb.smr.data
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	import mx.core.Application;
	
	
	public class Location extends EventDispatcher
	{
		public static var BG_LOADED:String = 'background_loaded';
		public static const BG_FRAMERATE:int = 15;
		public var x:Number;
		public var y:Number;
		public var name:String;
		public var summary:String;
		public var metaAnalysisID:String;
		public var caseStudyUrl:String;
		private var _background_url:String;
		public var background:Image;
		public var dataPoints:ArrayCollection = new ArrayCollection();
		public var orgScale:Number = 1
		public var scaleAbundance:Number = 1;
		
		public function Location(json:Object)
		{
			var coords:Array = String(json['point']).split(',');
			this.x = coords[0];
			this.y = coords[1];
			this.name = json['name'];
			this.summary = json['summary'];
			this.metaAnalysisID = json['meta_analysis_id'];
			this.caseStudyUrl = json['case_study_url'];
			this.background_url = json['background']['swf'];
			var points:Array = json['data_points'];
			for(var i:int=0; i<points.length; i++){
				this.dataPoints.addItem(new DataPoint(points[i]));
			}
			if(json['org_scale'] && json['org_scale'] != ''){
//				throw('orgscale set');
				this.orgScale = json['org_scale'];
			}
		}
		
		
		public function set background_url(url:String):void
		{
			var aURL:Array=new Array();
			var myURL:String = "";
			aURL = Application.application.stage.loaderInfo.url.split("/");
			for (var count:int = 0; count < (aURL.length - 1); count++) {
				myURL +=aURL[count] +"/"
			}
			
			_background_url = myURL+url;
//			var pict:Loader = new Loader();
//			var urlr:URLRequest = new URLRequest(url);
//			pict.load(urlr);
//			this.background = pict;
			this.background = new Image();
			this.background.showBusyCursor = true;
			this.background.trustContent = true;
			this.background.load(myURL+url);
			this.background.loaderContext.checkPolicyFile = true;
			
//			this.background.trustContent = true;
//			trace(url);
			this.background.addEventListener(Event.COMPLETE, handleBgLoaded);
		}
		
		public function get background_url():String
		{
			return _background_url;
		}
		
		public function pauseBg():void
		{
			this.background.cacheAsBitmap = true;
			this.background.content.stage.frameRate = 5;
		}
		
		public function resumeBg():void
		{
			this.background.cacheAsBitmap = false;
			this.background.content.stage.frameRate = BG_FRAMERATE;
		}
		
		private function handleBgLoaded(event:Event):void
		{
//			this.background.content.stage.frameRate = 1;
//			c.pause();
			
//			trace('background loaded');
			this.dispatchEvent(new Event(Location.BG_LOADED));
		}

	}
}