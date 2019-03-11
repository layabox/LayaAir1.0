package laya.d3Extend.vox {
	public class VoxelColor {
		public var r:int = 0;	// 0~255
		public var g:int = 0;
		public var b:int = 0;
		public var w:int = 0; 	// 这里表示重复次数
		public var obj:Object = null;
		
		public function VoxelColor(r:Number, g:Number, b:Number,o:Object){
			this.r=r;
			this.g=g;
			this.b = b;
			obj = o;
		}
		
		public function toInt():int{
			return (r<<16) | (g<<8) | (b);
		}		
	}
}	
