package laya.webgl.shapes
{
	
	public class GeometryData
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var lineWidth:Number;
		public var lineColor:Number;
		public var lineAlpha:Number;
		public var fillColor:Number;
		public var fillAlpha:Number;
		public var shape:IShape;
		public var fill:Boolean;
		
		public function GeometryData(lineWidth:Number, lineColor:Number, lineAlpha:Number, fillColor:Number, fillAlpha:Number, fill:Boolean, shape:IShape)
		{
			this.lineWidth = lineWidth;
			this.lineColor = lineColor;
			this.lineAlpha = lineAlpha;
			this.fillColor = fillColor;
			this.fillAlpha = fillAlpha;
			this.shape = shape;
			this.fill = fill;
		}
		
		public function clone():GeometryData
		{
			return new GeometryData(lineWidth, lineColor, lineAlpha, fillColor, fillAlpha, fill, shape);
		}
		
		public function getIndexData():Uint16Array
		{
			return null;
		}
		
		public function getVertexData():Float32Array
		{
			return null;
		}
		
		public function destroy():void
		{
			this.shape = null;
		}
	}
}