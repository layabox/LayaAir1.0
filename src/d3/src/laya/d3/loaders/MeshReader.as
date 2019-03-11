package laya.d3.loaders {
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.utils.Byte;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MeshReader {
		
		public function MeshReader() {
		}
		
		public static function read(data:ArrayBuffer, mesh:Mesh, subMeshes:Vector.<SubMesh>):void {
			var readData:Byte = new Byte(data);
			readData.pos = 0;
			var version:String = readData.readUTFString();
			switch (version) {
			case "LAYAMODEL:0301": 
			case "LAYAMODEL:0400": 
			case "LAYAMODEL:0401": 
				LoadModelV04.parse(readData, version, mesh, subMeshes);
				break;
			case "LAYAMODEL:05": 
			case "LAYAMODEL:COMPRESSION_05": 
				LoadModelV05.parse(readData, version, mesh, subMeshes);
				break;
			default: 
				throw new Error("MeshReader: unknown mesh version.");
			}
			mesh._setSubMeshes(subMeshes);
		}
	}
}