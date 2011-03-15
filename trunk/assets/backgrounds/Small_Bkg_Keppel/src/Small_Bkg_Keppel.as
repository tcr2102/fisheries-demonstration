package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width="425", height="344", backgroundColor="#000000", frameRate="15")]
	public class Small_Bkg_Keppel extends Sprite
	{
		[Embed(source="../assets/small_bkg.jpg")]
		public static const Bg:Class;
		[Embed(source="../assets/caustics.png")]
		public static const Shadows:Class;
		
//		
		private var bg:Bitmap = new Bg();
		private var shadows:Bitmap = new Shadows();
//		private var caustics:Bitmap = new Caustics();
		private var rect:Rectangle = new Rectangle(0, 0, 425, 120);
		private var pt:Point = new Point(0,0);
		private var bmp:BitmapData = new flash.display.BitmapData(425,120,true,0x00000000);
		private var waterbmd:BitmapData = new flash.display.BitmapData(425,120,false,0x00000000);
		private var water:Bitmap;
		// Perlin noise variables, I encourage you to play around with these...
		private var baseX:Number = 30;
		private var baseY:Number = 30;    
		private var nOctaves:Number = 1; 
		private var randomSeed:Number = Math.random()*10;
		private var bStitch:Boolean = false;
		private var bFractalNoise:Boolean = true;
		private var nChannels:Number = 1;
		private var bGreyScale:Boolean= true;
		// Create the bitmapdata we are going to change with the perinNoise function        
	
		// Offset array for perlin function
		private var p1:Point = new Point(45, 34);
		private var p2:Point = new Point(50, 60);
		private var perlinOffset:Array = new Array(p1, p2);
		
		public function onEnterFrame(e:Event):void{

			
			//    change the values in the perlinOffset to animate each perlin layer
			this.perlinOffset[0].y-=2;
			this.perlinOffset[0].x-=2;
			this.perlinOffset[1].x+=1;
			this.perlinOffset[1].y+=1;
			//    apply perlin noise to our bitmapdata
			this.bmp.perlinNoise(this.baseX, this.baseY, this.nOctaves, this.randomSeed, this.bStitch, this.bFractalNoise, this.nChannels, this.bGreyScale, this.perlinOffset);
			//
			//    Uncomment the following line to see the generated perlin noise
			//_root.attachBitmap(bmp, 1, "auto", true);
			//
			//    Now use the bitmapdata in bmp as a base for the distortion
			var dmf:DisplacementMapFilter = new DisplacementMapFilter(this.bmp, new Point(0, 0), 1, 1, 20, 20, "color");
			//    and apply it to our pic (instance name sourcePic)
			this.water.filters = [dmf];
			this.shadows.filters = [dmf];
//			this.caustics.filters = [dmf];
		}
		
		public function Small_Bkg_Keppel()
		{
//			this.stage.scaleMode = 'noScale';
			this.addChild(bg);
			this.waterbmd.copyPixels(this.bg.bitmapData, rect, pt);
			this.water = new Bitmap(this.waterbmd);
			this.addChild(this.water);
			this.shadows.x = -5;
			this.shadows.y = 150;
			this.addChild(this.shadows);
			this.shadows.alpha = 0.7;
//			this.caustics.x = 0;
//			this.caustics.y = 225;
//			this.addChild(this.caustics);
//			this.caustics.alpha = 1;
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		public function pause():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		public function resume():void
		{
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
	}
}