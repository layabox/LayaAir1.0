package laya.d3.resource.models {
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.shader.ShaderInstance;
	import laya.layagl.LayaGL;
	import laya.resource.IDispose;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>SubMesh</code> 类用于创建子网格数据模板。
	 */
	public class SubMesh extends GeometryElement {
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
		public var _bufferState:BufferState = new BufferState();
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 * @param	mesh  网格数据模板。
		 */
		public function SubMesh(mesh:Mesh) {
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
			_bufferState.bind();
			var skinAnimationDatas:Vector.<Float32Array> = (state.renderElement as SubMeshRenderElement).skinnedDatas;
			var boneIndicesListCount:int = _boneIndicesList.length;
			var shader:ShaderInstance = state.shader;
			for (var i:int = 0; i < boneIndicesListCount; i++) {
				(skinAnimationDatas) && (shader.uploadCustomUniform(SkinnedMeshSprite3D.BONES, skinAnimationDatas[i]));
				LayaGL.instance.drawElements(WebGLContext.TRIANGLES, _subIndexBufferCount[i], WebGLContext.UNSIGNED_SHORT, _subIndexBufferStart[i] * 2);
			}
			Stat.renderBatch++;
			Stat.trianglesFaces += _indexCount / 3;
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
			_bufferState.destroy();
			_indexBuffer.destroy();
			_bufferState = null;
			_indexBuffer = null;
			_mesh = null;
			_boneIndicesList = null;
			_subIndexBufferStart = null;
			_subIndexBufferCount = null;
			_skinAnimationDatas = null;
		
		}
	}
}