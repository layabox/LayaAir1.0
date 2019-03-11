package laya.d3Editor.component.physics.EditerColliderShape 
{
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.PrimitiveMesh;
	import laya.d3Editor.shape.MeshShapeLine3D;
	import laya.ide.managers.IDEAPIS;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author zyh
	 */
	public class EditerMeshColliderShape extends Sprite3D 
	{
		private var _center:Vector3;
		private var _mesh:String = '';
		private var _meshShapeLine3D:MeshShapeLine3D;
		public function EditerMeshColliderShape() 
		{
			_center = new Vector3(0, 0, 0);
		}
		
		public function get center():Vector3 {
			return _center;
		}
		
		public function set center(value:Vector3):void {
			_center = value;
			if (_meshShapeLine3D){
				_center.cloneTo(_meshShapeLine3D.transform.localPosition);
				_meshShapeLine3D.transform.localPosition = _meshShapeLine3D.transform.localPosition;
			}
		}
		
		public function get mesh():String 
		{
			return _mesh;
		}
		
		public function set mesh(value:String):void 
		{
			if (_mesh != value){
				_mesh = value;
				if (_meshShapeLine3D){
					_meshShapeLine3D.destroy();
					_meshShapeLine3D = null;
				}
				Mesh.load(IDEAPIS.assetsPath + '/' + value, Handler.create(this, onLoaded));
			}
		}
		
		private function onLoaded(e:Mesh):void 
		{
			var ibBufferData:Uint16Array = e._indexBuffer ? e._indexBuffer.getData() : (e as PrimitiveMesh)._primitveGeometry._indexBuffer.getData();
			_meshShapeLine3D = addChild(new MeshShapeLine3D(ibBufferData.length)) as MeshShapeLine3D;
			_meshShapeLine3D.mesh = _mesh;
			_center.cloneTo(_meshShapeLine3D.transform.localPosition);
			_meshShapeLine3D.transform.localPosition = _meshShapeLine3D.transform.localPosition;
		}
		
		override public function _parse(data:Object):void {
			if (data.center){
				center.fromArray(data.center);
				center = center;
			}
			if (data.mesh){
				mesh = data.mesh;
			}
		}
	}

}