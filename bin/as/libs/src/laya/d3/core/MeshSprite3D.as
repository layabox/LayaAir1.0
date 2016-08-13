package laya.d3.core {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * <code>MeshSprite3D</code> 类用于创建网格。
	 */
	public class MeshSprite3D extends Sprite3D {
		/** @private */
		private var _renderObjects:Vector.<RenderObject>;
		/** @private 网格数据模板。*/
		private var _mesh:BaseMesh;
		/** @private */
		private var _materials:Vector.<Material>;
		
		/**
		 * 返回第一个实例材质,注意会拷贝对象。
		 * @return 第一个实例材质。
		 */
		public function get material():Material {
			if ((_materials && _materials[0])) {
				var instanceMaterial:Material = new Material();
				_materials[0].copy(instanceMaterial);
				_materials = _materials.slice();
				_materials[0] = instanceMaterial;
				return _materials[0];
			}
			return null;
		}
		
		/**
		 * 设置第一个实例材质。
		 * @param value 第一个实例材质。
		 */
		public function set material(value:Material):void {
			(_materials) || (_materials = new Vector.<Material>());
			_materials[0] = value;
		}
		
		/**
		 * 获取实例材质列表,注意会拷贝对象。
		 * @return 实例材质列表。
		 */
		public function get materials():Vector.<Material> {
			if (_materials) {
				var instanceMaterials:Vector.<Material> = new Vector.<Material>();
				for (var i:int = 0; i < _materials.length; i++) {
					var material:Material = new Material();
					_materials[i].copy(material);
					instanceMaterials.push(material);
				}
				_materials = instanceMaterials;
			}
			
			return _materials;
		}
		
		/**
		 * 设置实例材质列表。
		 * @param value 实例材质列表。
		 */
		public function set materials(value:Vector.<Material>):void {
			_materials = value;
		}
		
		/**
		 * 返回第一个材质。
		 * @return 第一个材质。
		 */
		public function get shadredMaterial():Material {
			return (_materials && _materials[0]) ? _materials[0] : null;
		}
		
		/**
		 * 设置第一个材质。
		 * @param value 第一个材质。
		 */
		public function set shadredMaterial(value:Material):void {
			(_materials) || (_materials = new Vector.<Material>());
			_materials[0] = value;
		}
		
		/**
		 * 获取材质列表。
		 * @return 材质列表。
		 */
		public function get shadredMaterials():Vector.<Material> {
			return _materials;
		}
		
		/**
		 * 设置材质列表。
		 * @param value 材质列表。
		 */
		public function set shadredMaterials(value:Vector.<Material>):void {
			_materials = value;
		}
		
		/**
		 * 获取子网格数据模板。
		 * @return  子网格数据模板。
		 */
		public function get mesh():BaseMesh {
			return _mesh;
		}
		
		/**
		 * 设置子网格数据模板。
		 * @param value 子网格数据模板。
		 */
		public function set mesh(value:BaseMesh):void {
			_mesh = value;
			event(Event.CHANGED);
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格。
		 * @param name 名字。
		 */
		public function MeshSprite3D(mesh:BaseMesh, name:String = null) {
			_renderObjects = new Vector.<RenderObject>();
			_mesh = mesh;
			if (mesh is Mesh)//TODO:待考虑。
				_materials = (mesh as Mesh).materials;
			
			super(name);
		}
		
		override public function _clearSelfRenderObjects():void {
			for (var i:int = 0, n:int = _renderObjects.length; i < n; i++) {
				var renderObj:RenderObject = _renderObjects[i];
				renderObj.renderQneue.deleteRenderObj(renderObj);
			}
			_renderObjects.length = 0;
		}
		
		/**
		 * @private
		 */
		public override function _update(state:RenderState):void {
			state.owner = this;
			var preTransformID:int = state.worldTransformModifyID;
			var canView:Boolean = state.renderClip.view(this) && active;
			(canView) && (_updateComponents(state));
			
			state.worldTransformModifyID += transform._worldTransformModifyID;
			transform.getWorldMatrix(state.worldTransformModifyID);
			
			if (canView) {
				var renderElementsCount:int = _mesh.getRenderElementsCount();
				for (var i:int = 0; i < renderElementsCount; i++) {
					var obj:RenderObject = _renderObjects[i];
					if (obj) {
						var material:Material = _materials[i];
						var renderQueue:RenderQueue = state.scene.getRenderQueue(material.renderQueue);
						if (obj.renderQneue != renderQueue) {
							obj.renderQneue.deleteRenderObj(obj);
							obj = _addRenderObject(state, i, material);
						}
					} else {
						obj = _addRenderObject(state, i, _materials[i]);
					}
					obj.tag.worldTransformModifyID = state.worldTransformModifyID;
				}
				_lateUpdateComponents(state);
			} else {
				_clearSelfRenderObjects();
			}
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
			state.worldTransformModifyID = preTransformID;
		}
		
		private function _addRenderObject(state:RenderState, index:int, material:Material):RenderObject {
			var renderObj:RenderObject = state.scene.getRenderObject(material.renderQueue);
			_renderObjects[index] = renderObj;
			
			var renderElement:IRenderable = _mesh.getRenderElement(index);
			renderObj.mainSortID = state.owner._getSortID(renderElement, material);//根据MeshID排序，处理同材质合并处理。
			renderObj.triangleCount = renderElement.triangleCount;
			renderObj.owner = state.owner;
			
			renderObj.renderElement = renderElement;
			renderObj.material = material;
			renderObj.tag || (renderObj.tag = new Object());
			renderObj.tag.worldTransformModifyID = state.worldTransformModifyID;
			return renderObj;
		}
	
	}
}