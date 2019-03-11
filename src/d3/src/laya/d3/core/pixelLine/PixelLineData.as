package laya.d3.core.pixelLine 
{
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	/**
	 * <code>PixelLineData</code> 类用于表示线数据。
	 */
	public class PixelLineData 
	{
		public var startPosition:Vector3 = new Vector3();
		
		public var endPosition:Vector3 = new Vector3();
		
		public var startColor:Color = new Color();
		
		public var endColor:Color = new Color();
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:PixelLineData):void {
			startPosition.cloneTo(destObject.startPosition);
			endPosition.cloneTo(destObject.endPosition);
			startColor.cloneTo(destObject.startColor);
			endColor.cloneTo(destObject.endColor);
		}
	}
}