package laya.d3.resource.tempelet {
	import laya.d3.core.material.Material;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * @private
	 * <code>MeshTemplet</code> 类用于创建网格数据模板。
	 */
	public class MeshTemplet extends BaseMeshTemplet {
		
		private var _materials:Vector.<Material> = new Vector.<Material>;
		private var _subMeshes:Vector.<SubMeshTemplet> = new Vector.<SubMeshTemplet>();
		private var _vb:VertexBuffer3D;
		
		private var _saveToMergeRendering:Boolean;
		private var _mergeRenderingList:Array;
		
		private var _useFullBone:Boolean = true;
		private var _materialsMap:*;
		private var _url:String;
		private var _loaded:Boolean = false;
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
		public function MeshTemplet(... args) {
			_mergeRenderingList = [];
			_mergeRenderingList._length = 0;
			for (var i:int = 0, n:int = args.length; i < n; i++) add(args[i]);
			
			on(Event.LOADED, this, function(templet:MeshTemplet):void {
				_loaded = true;
			});
		}
		
		public function add(oneSubMesh:SubMeshTemplet):MeshTemplet {
			_subMeshes.push(oneSubMesh);
			return this;
		}
		
		public function regMaterials(name:String, materials:Vector.<Material>):void {
			_materialsMap || (_materialsMap = {});
			_materialsMap[name] = materials;
		}
		
		public function cloneActiveMaterials(materials:Vector.<Material>):Vector.<Material> {
			materials || (materials = new Vector.<Material>());
			materials.length = _materials.length;
			for (var i:int = 0, n:int = _materials.length; i < n; i++) {
				materials[i] || (materials[i] = new Material());
				_materials[i].copy(materials[i]);
			}
			return materials;
		}
		
		public function disableUseFullBone():void {
			_useFullBone = false;
		}
		
		public function getSubMesh(index:int):SubMeshTemplet {
			return _subMeshes[index];
		}
		
		public function get subMeshes():Vector.<SubMeshTemplet> {
			return _subMeshes;
		}
		
		public function set materials(value:Vector.<Material>):void {
			_materials = value;
		}
		
		public function get materials():Vector.<Material> {
			return _materials;
		}
		
		public function setShaderByName(name:String):void {
			_materials && _materials.forEach(function(o:Material):void {
				o.setShaderName(name);
			});
		}
		
		public function disableLight():void {
			_materials && _materials.forEach(function(o:Material):void {
				o.disableLight();
			});
		}
		
		public function remove(oneSubMesh:SubMeshTemplet):Boolean {
			var index:int = _subMeshes.indexOf(oneSubMesh);
			if (index < 0) return false;
			_subMeshes.splice(index, 1);
			return true;
		}
		
		public function clear():MeshTemplet {
			_subMeshes.length = 0;
			return this;
		}
		
		public function set vb(value:VertexBuffer3D):void {
			_vb = value;
		}
		
		public function get vb():VertexBuffer3D {
			return _vb;
		}
		
		override public function dispose():void 
		{
		
			_resourceManager.removeResource(this);
			super.dispose();
			_materials = null;
			_subMeshes = null;
			_vb = null;
		}
	}
}
