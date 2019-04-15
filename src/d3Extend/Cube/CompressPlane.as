package laya.d3Extend.Cube 
{
	import laya.d3.math.Color;
	import laya.d3.math.Vector4;
	import laya.d3Extend.vox.VoxFileData;
	import test.Interaction_Hold;
	/**
	 * <code>CompressPlane</code> 类用于压缩存储PlaneInfo
	 */
	public class CompressPlane 
	{
		public var startX:int;
		public var startY:int;
		public var startZ:int; 
		public var vecPlaneInfo:Vector.<PlaneInfo>;
		
		public function CompressPlane(startX:int,startY:int,startZ:int) {
			this.startX = startX;
			this.startY = startY;
			this.startZ = startZ;
			vecPlaneInfo = new Vector.<PlaneInfo>;
		}
		public function setValue(startX:int,startY:int,startZ:int,vecPane:Vector.<PlaneInfo>):void {
			this.startX = startX;
			this.startY = startY;
			this.startZ = startZ;
			vecPlaneInfo = vecPane;
		}
		public function getKey():String{
			return startX + "," + startY + "," + startZ;
		}
		
	}
   
}



























