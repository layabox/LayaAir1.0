package laya.d3Extend.Cube 
{
	import laya.d3.math.Color;
	import laya.d3.math.Vector4;
	import laya.d3Extend.vox.VoxFileData;
	import test.Interaction_Hold;
	/**
	 * <code>PlaneInfo</code> 类用于存储合并CubeInfo之后的面
	 */
	public class PlaneInfo 
	{
		//考虑到xyz每次只会有用到其中两个
		public var p1:int;
		public var p2:int;
		public var width:int;
		public var height:int;
		public var colorIndex:int;
		public var isCover:Boolean;

		public function PlaneInfo(p1:int,p2:int,width:int,height:int,colorIndex:int) {
			this.p1 = p1;
			this.p2 = p2;
			this.width = width;
			this.height = height;
			this.colorIndex = colorIndex;
			this.isCover = false;
		}
		public function setValue(p1:int, p2:int, width:int,height:int,colorIndex:int):void {
			this.p1 = p1;
			this.p2 = p2;
			this.width = width;
			this.height = height;
			this.colorIndex = colorIndex;
		}
		public function setP12(p1:int, p2:int):void {
			this.p1 = p1;
			this.p2 = p2;
		}
		public function addWidth(value:int):void{
			this.width += value;
		}
		public function addHeight(value:int):void {
			this.height += value;
		}
	
		public function getKey():String{
			return this.p1 + "," + this.p2 ;
		}
		public function getIndex():int {
			var index:int = p1 + p2 * 3200;
			return index;
		}
	}
}