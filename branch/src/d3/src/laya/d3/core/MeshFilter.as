package laya.d3.core {
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.resource.models.BaseMesh;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.resource.IDestroy;
	
	/**更换sharedMesh时调度。
	 * @eventType Event.MESH_CHANGED
	 * */
	[Event(name = "meshchanged", type = "laya.events.Event")]
	/**异步几何体资源加载完成时调度。
	 * @eventType Event.LOADED
	 * */
	[Event(name = "loaded", type = "laya.events.Event")]
	
	/**
	 * <code>MeshFilter</code> 类用于创建网格过滤器。
	 */
	public class MeshFilter extends GeometryFilter {
		/** @private */
		private var _owner:MeshSprite3D;
		/** @private */
		private var _sharedMesh:BaseMesh;
		
		/**
		 * 获取共享网格。
		 * @return 共享网格。
		 */
		public function get sharedMesh():BaseMesh {
			return _sharedMesh;
		}
		
		/**
		 * 设置共享网格。
		 * @return  value 共享网格。
		 */
		public function set sharedMesh(value:BaseMesh):void {
			var oldMesh:BaseMesh = _sharedMesh;
			_sharedMesh = value;
			event(Event.MESH_CHANGED, [this, oldMesh, value]);
			
			if (!value.loaded) {
				_sharedMesh.once(Event.LOADED, this, _sharedMeshLoaded);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _isAsyncLoaded():Boolean {
			return _sharedMesh.loaded;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingSphere():BoundSphere {
			return _sharedMesh.boundingSphere;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingBox():BoundBox {
			return _sharedMesh.boundingBox;
		}
		
		/**
		 * 创建一个新的 <code>MeshFilter</code> 实例。
		 * @param owner 所属网格精灵。
		 */
		public function MeshFilter(owner:MeshSprite3D) {
			_owner = owner;
		}
		
		/**
		 * @private
		 */
		private function _sharedMeshLoaded():void {
			event(Event.LOADED);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _destroy():void {
			super._destroy();
			_owner = null;
			_sharedMesh = null;
		
		}
	
	}

}