package laya.d3.core.fileModel {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQuene;
	import laya.d3.core.render.RenderState;
	import laya.d3.loaders.LoadModel;
	import laya.d3.resource.tempelet.MeshTemplet;
	import laya.d3.resource.tempelet.SubMeshTemplet;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.Resource;
	import laya.utils.Stat;
	
	/**
	 * <code>Mesh</code> 类用于创建网格。
	 */
	public class Mesh extends Sprite3D {
		/** @private */
		private var _materials:Vector.<Material>;
		/** @private */
		private var _subMeshes:Vector.<SubMesh> = new Vector.<SubMesh>;
		/**@private 网格数据模板。*/
		private var _templet:MeshTemplet;
		/** @private */
		protected var _url:String;
		
		
		
		/**
		 * 获取子网格数据模板。
		 * @return  子网格数据模板。
		 */
		public function get templet():MeshTemplet {
			return _templet;
		}
		
		/**
		 * 获取URL地址。
		 * @return URL地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 获取材质列表。
		 * @return 材质列表。
		 */
		public function get materials():Vector.<Material> {
			return _materials;
		}
		
		/**
		 * 设置材质列表。
		 * @param value 材质列表。
		 */
		public function set materials(value:Vector.<Material>):void {
			_materials = value;
		}
		
		/**
		 * 创建一个 <code>Mesh</code> 实例。
		 */
		public function Mesh() {
		}
		
		/**
		 * @private
		 */
		private function _addSubMesh(subMesh:SubMesh):Mesh {
			subMesh._indexOfHost = _subMeshes.length;
			subMesh.mesh = this;
			_subMeshes.push(subMesh);
			return this;
		}
		
		/**
		 * @private
		 */
		private function _updateToRenderQuene(state:RenderState, materials:Vector.<Material>):void {
			var subMeshes:Vector.<SubMesh> = _subMeshes;
			if (subMeshes.length === 0)
				return;
			
			materials = materials || _templet.materials;
			for (var i:int = 0, n:int = subMeshes.length; i < n; i++) {
				var subMesh:SubMesh = subMeshes[i];
				var material:Material = subMesh.templet.getMaterial(materials);
				
				var o:RenderObject = _addToRenderQuene(state, material);
				o.sortID = material.id;//根据MeshID排序，处理同材质合并处理。
				o.owner = this;
				
				o.renderElement = subMesh;
				o.material = material;
				o.tag || (o.tag = new Object());
				o.tag.worldTransformModifyID = state.worldTransformModifyID;
			}
		}
		
		/**
		 * @private
		 */
		protected function _addToRenderQuene(state:RenderState, material:Material):RenderObject {
			var o:RenderObject;
			if (!material.transparent || (material.transparent && material.transparentMode === 0))
				o = material.cullFace ? state.scene.getRenderObject(RenderQuene.OPAQUE) : state.scene.getRenderObject(RenderQuene.OPAQUE_DOUBLEFACE);
			else if (material.transparent && material.transparentMode === 1) {
				if (material.transparentAddtive)
					o = material.cullFace ? state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_ADDTIVE_BLEND) : state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE);
				else
					o = material.cullFace ? state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_BLEND) : state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE);
			}
			return o;
		}
		
		/**
		 * @private
		 */
		protected function _praseSubMeshTemplet(subMeshTemplet:SubMeshTemplet):SubMesh {
			return new SubMesh(subMeshTemplet);
		}
		
		/**
		 * @private
		 */
		public override function _update(state:RenderState):void {
			state.owner = this;
			var preWorldTransformModifyID:int = state.worldTransformModifyID;
			state.worldTransformModifyID += transform._worldTransformModifyID;
			transform.getWorldMatrix(state.worldTransformModifyID);
			
			if (_templet && state.renderClip.view(this)) {
				_updateComponents(state);
				
				_updateToRenderQuene(state, _materials);
				
				_lateUpdateComponents(state);
				Stat.spriteCount++;
			}
			
			_childs.length && _updateChilds(state);
			state.worldTransformModifyID = preWorldTransformModifyID;
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public function load(url:String):void {
			_url = URL.formatURL(url);
			var i:int = 0;
			var _this:Mesh = this;
			var tem:MeshTemplet = Resource.meshCache[_url];
			if (!tem) {
				tem = Resource.meshCache[_url] = new MeshTemplet();
				_templet = tem;
				
				var loader:Loader = new Loader();
				loader.once(Event.COMPLETE, null, function(data:ArrayBuffer):void {
					new LoadModel(data, _this._templet, _this._url);
					
					for (i = 0; i < _this._templet.subMeshes.length; i++)
						_addSubMesh(_praseSubMeshTemplet(_this._templet.subMeshes[i]));
					
					_this.event(Event.LOADED, _this);
				});
				loader.load(_url, Loader.BUFFER);
			} else {
				_templet = tem;
				if (_templet.loaded) {
					this.event(Event.LOADED, this);
				} else {
					_templet.once(Event.LOADED, null, function(data:*):void {
						
						for (i = 0; i < _this._templet.subMeshes.length; i++)
							_addSubMesh(_praseSubMeshTemplet(_this._templet.subMeshes[i]));
						
						_this.event(Event.LOADED, _this);
					});
				}
			}
		}
	
	}
}