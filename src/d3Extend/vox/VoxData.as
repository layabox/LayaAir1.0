package laya.d3Extend.vox {
	import adobe.utils.CustomActions;
	import laya.d3Extend.CubeInfo;
	import laya.utils.Byte;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VoxData {
		
		private var sizex:int;
		private var sizey:int;
		private var sizez:int;
		
		//将值传入根据x,y,z的值取值
		
		public var voxels:Vector.<int> = new Vector.<int>();
		public var count:int;
		
		public function VoxData(_voxels:Uint8Array, xsize:int, ysize:int, zsize:int, ColorPlane:int) {
			sizex = xsize;
			sizey = zsize;
			sizez = ysize;
	
			for (var j:int = 0; j < _voxels.length; j += 4) {
				voxels.push((_voxels[j] as int) - Math.round(sizex / 2));
				voxels.push((_voxels[j + 2] as int));
				voxels.push(sizez - (_voxels[j + 1] as int) - Math.round(sizez / 2));
				if (ColorPlane == 0)
					voxels.push(VoxFileData.turecolor[_voxels[j + 3] as int]);
				else
					voxels.push(VoxFileData.TextureColor[_voxels[j + 3] as int]);
			}
			count = voxels.length / 4;
		}
	}

}