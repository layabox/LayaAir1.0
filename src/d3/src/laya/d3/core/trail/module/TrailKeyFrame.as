package laya.d3.core.trail.module 
{
	
	public class TrailKeyFrame 
	{
		public var time:Number;
		public var inTangent:Number;
		public var outTangent:Number;
		public var value:Number;
		
		public function TrailKeyFrame(){
			
		}
		
		public function cloneTo(destObject:TrailKeyFrame):void {
			destObject.time = time;
			destObject.inTangent = inTangent;
			destObject.outTangent = outTangent;
			destObject.value = value;
		}
	}

}