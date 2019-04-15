package laya.d3Extend.vox {
	import laya.utils.Byte;
	/**
	 * ...
	 * @author ...
	 */
	public class VoxFileChunkChild {
		
		//VoxFileSize
		public var Sizename:String;
		public var SizechunkContent:int = 0;
		public var SizechunkNums:int = 0;
		public var Sizex:int = 0;
		public var Sizey:int = 0;
		public var Sizez:int = 0;
		//VoxFileXYZI
		public var XYZIname:String;
		public var XYZIchunkContent:int = 0;
		public var XYZIchunkNums:int = 0;
		public var XYZIvoxels:VoxData;
		
		
		
		public function VoxFileChunkChild() {
			
		}
		
	}

}