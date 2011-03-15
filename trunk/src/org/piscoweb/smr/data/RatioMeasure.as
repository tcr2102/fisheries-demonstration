package org.piscoweb.smr.data
{
	[Bindable]
	public class RatioMeasure
	{
		public var ratio:Number;
		public var name:String;
		
		public function RatioMeasure(ratio:Number, name:String)
		{
			this.ratio = Math.round(ratio * 100) / 100;
			this.name = name;
		}

	}
}