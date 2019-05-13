package laya.d3.resource.models {
	import laya.d3.core.GeometryElement;
	import laya.d3.core.SkinnedMeshRenderer;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>SubMesh</code> 类用于创建子网格数据模板。
	 */
	public class SubMesh extends GeometryElement {
		/** @private */
		private static var _uniqueIDCounter:int = 0;
		/**@private */
		private static var _type:int = _typeCounter++;
		
		/** @private */
		public var _mesh:Mesh;
		
		/** @private */
		public var _boneIndicesList:Vector.<Uint16Array>;
		/** @private */
		public var _subIndexBufferStart:Vector.<int>;
		/** @private */
		public var _subIndexBufferCount:Vector.<int>;
		/** @private */
		public var _skinAnimationDatas:Vector.<Float32Array>;
		
		/** @private */
		public var _indexInMesh:int;
		
		/** @private */
		public var _vertexStart:int;
		/** @private */
		public var _indexStart:int;
		/** @private */
		public var _indexCount:int;
		/** @private */
		public var _indices:Uint16Array;
		/**@private [只读]*/
		public var _vertexBuffer:VertexBuffer3D;
		/**@private [只读]*/
		public var _indexBuffer:IndexBuffer3D;
		
		/** @private */
		public var _id:int;
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 * @param	mesh  网格数据模板。
		 */
		public function SubMesh(mesh:Mesh) {
			_id = ++_uniqueIDCounter;
			_mesh = mesh;
			_boneIndicesList = new Vector.<Uint16Array>();
			_subIndexBufferStart = new Vector.<int>();
			_subIndexBufferCount = new Vector.<int>();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return _type;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			_mesh._bufferState.bind();
			var skinnedDatas:Vector.<Vector.<Float32Array>> = (state.renderElement.render as SkinnedMeshRenderer)._skinnedData;
			if (skinnedDatas) {
				var subSkinnedDatas:Vector.<Float32Array> = skinnedDatas[_indexInMesh];
				var boneIndicesListCount:int = _boneIndicesList.length;
				for (var i:int = 0; i < boneIndicesListCount; i++) {
					state.shader.uploadCustomUniform(SkinnedMeshSprite3D.BONES, subSkinnedDatas[i]);
					LayaGL.instance.drawElements(WebGLContext.TRIANGLES, _subIndexBufferCount[i], WebGLContext.UNSIGNED_SHORT, _subIndexBufferStart[i] * 2);
				}
			} else {
				LayaGL.instance.drawElements(WebGLContext.TRIANGLES, _indexCount, WebGLContext.UNSIGNED_SHORT, _indexStart * 2);
			}
			Stat.trianglesFaces += _indexCount / 3;
			Stat.renderBatches++;
		}
		
		/**
		 * @private
		 */
		public function getIndices():Uint16Array {
			return _indices;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			if (_destroyed)
				return;
			super.destroy();
			_indexBuffer.destroy();
			_indexBuffer = null;
			_mesh = null;
			_boneIndicesList = null;
			_subIndexBufferStart = null;
			_subIndexBufferCount = null;
			_skinAnimationDatas = null;
		
		}
	}
}