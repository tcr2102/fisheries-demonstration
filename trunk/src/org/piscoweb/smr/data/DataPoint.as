package org.piscoweb.smr.data
{
	import mx.collections.ArrayCollection;
	
	public class DataPoint
	{
		public var displayName:String;
		public var citation:String;
		public var density:Number = 1;
		public var biomass:Number = 1;
		public var size:Number = 1;
		public var richness:Number = 1;
		public var direct_link:String = "";
		public var organisms:ArrayCollection = new ArrayCollection();
		public var particles:Array = new Array();
		public var measures:ArrayCollection = new ArrayCollection();
		
		public static const NEG_COLOR:String = '#FF9096';
		public static const POS_COLOR:String = '#ABFFA9';
		
		public function DataPoint(json:Object)
		{
			this.displayName = json['display_name'];
			this.citation = json['citation'];
			var organisms:Array = json['organisms'];
			for(var i:int=0;i<organisms.length;i++){
				this.organisms.addItem(new Organism(json['organisms'][i]));
			}
			this.density = json['density'];
			this.size = json['size'];
			this.biomass = json['biomass'];
			this.richness = json['richness'];
			
			if(json['direct_link'] != undefined) this.direct_link = json['direct_link'];
			
			this.createMeasures();
		}
		
		public function getAdjustedSize():Number
		{
//			trace('biomass: '+this.biomass);
			if(this.size != 1.0){
//				trace('returning straight size');
				return size;
			}else{
				if(this.biomass != 1.0){
					if(!this.density){
						// hmm, split among density and size?
						return 1;
					}else{
						return Math.sqrt(this.biomass/this.density);
					}
				}else{
//					trace('biomass == 1');
					return 1;
				}
			}
		}
		
		public static function toPercent(ratio:Number, abs:Boolean=false):int
		{
			var percent:Number = (ratio - 1) * 100;
			percent = Math.round(percent);
			if(abs){
				percent = Math.abs(percent);
			}
			return percent;
		}
		
		public static function toVerb(ratio:Number, colorize:Boolean=false):String
		{
			var t:String;
			var color:String;
			if(ratio > 1){
				t = 'increased';
				color = POS_COLOR;
			}else{
				t = 'decreased';
				color = NEG_COLOR;
			}
			if(colorize){
				t = '<font color="'+color+'">'+t+'</font>';
			}
			return t;
		}
		
		public static function toAdjective(ratio:Number, colorize:Boolean=false):String
		{
			var t:String;
			var color:String;
			if(ratio > 1){
				t = 'greater';
				color = POS_COLOR;
			}else{
				t = 'less';
				color = NEG_COLOR;
			}
			if(colorize){
				t = '<font color="'+color+'">'+t+'</font>';
			}
			return t;
		}
		
		private function createMeasures():void
		{
			if(this.density != 1){
				this.measures.addItem(new RatioMeasure(this.density, 'more abundant'));
			}
			if (this.biomass != 1) {
				//trace(this.biomass +"got this measure "+new RatioMeasure(this.biomass, 'more biomass').ratio)
				this.measures.addItem(new RatioMeasure(this.biomass, 'more biomass'));
			}
			if(this.size != 1){
				this.measures.addItem(new RatioMeasure(this.size, 'larger'));
			}
			if(this.richness != 1){
				this.measures.addItem(new RatioMeasure(this.richness, 'more diverse'));
			}
		}

	}
}