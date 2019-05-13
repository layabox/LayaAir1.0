package laya.d3.core {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.webgl.BufferStateBase;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>BufferState</code> 类用于实现渲染所需的Buffer状态集合。
	 */
	public class BufferState extends BufferStateBase {
		
		/**
		 * 创建一个 <code>BufferState</code> 实例。
		 */
		public function BufferState() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 * vertexBuffer的vertexDeclaration不能为空,该函数比较消耗性能，建议初始化时使用。
		 */
		public function applyVertexBuffer(vertexBuffer:VertexBuffer3D):void {//TODO:动态合并是否需要使用对象池机制
			if (_curBindedBufferState === this) {
				var gl:* = LayaGL.instance;
				var verDec:VertexDeclaration = vertexBuffer.vertexDeclaration;
				var valueData:Array = null;
				if (Render.supportWebGLPlusRendering)
					valueData = verDec._shaderValues._nativeArray;
				else
					valueData = verDec._shaderValues.getData();
				vertexBuffer.bind();
				for (var k:String in valueData) {
					var loc:int = parseInt(k);
					var attribute:Array = valueData[k];
					gl.enableVertexAttribArray(loc);
					gl.vertexAttribPointer(loc, attribute[0], attribute[1], !!attribute[2], attribute[3], attribute[4]);
				}
			} else {
				throw "BufferState: must call bind() function first.";
			}
		}
		
		/**
		 * @private
		 * vertexBuffers中的vertexDeclaration不能为空,该函数比较消耗性能，建议初始化时使用。
		 */
		public function applyVertexBuffers(vertexBuffers:Vector.<VertexBuffer3D>):void {
			if (_curBindedBufferState === this) {
				var gl:* = LayaGL.instance;
				for (var i:int = 0, n:int = vertexBuffers.length; i < n; i++) {
					var verBuf:VertexBuffer3D = vertexBuffers[i];
					var verDec:VertexDeclaration = verBuf.vertexDeclaration;
					var valueData:Array = null;
					if (Render.supportWebGLPlusRendering)
						valueData = verDec._shaderValues._nativeArray;
					else
						valueData = verDec._shaderValues.getData();
					verBuf.bind();
					for (var k:String in valueData) {
						var loc:int = parseInt(k);
						var attribute:Array = valueData[k];
						gl.enableVertexAttribArray(loc);
						gl.vertexAttribPointer(loc, attribute[0], attribute[1], !!attribute[2], attribute[3], attribute[4]);
					}
				}
			} else {
				throw "BufferState: must call bind() function first.";
			}
		}
		
		/**
		 * @private
		 */
		public function applyInstanceVertexBuffer(vertexBuffer:VertexBuffer3D):void {//TODO:动态合并是否需要使用对象池机制
			if (WebGLContext._angleInstancedArrays) {//判断是否支持Instance
				if (_curBindedBufferState === this) {
					var gl:* = LayaGL.instance;
					var verDec:VertexDeclaration = vertexBuffer.vertexDeclaration;
					var valueData:Array = null;
					if (Render.supportWebGLPlusRendering)
						valueData = verDec._shaderValues._nativeArray;
					else
						valueData = verDec._shaderValues.getData();
					vertexBuffer.bind();
					for (var k:String in valueData) {
						var loc:int = parseInt(k);
						var attribute:Array = valueData[k];
						gl.enableVertexAttribArray(loc);
						gl.vertexAttribPointer(loc, attribute[0], attribute[1], !!attribute[2], attribute[3], attribute[4]);
						WebGLContext._angleInstancedArrays.vertexAttribDivisorANGLE(loc, 1);
					}
				} else {
					throw "BufferState: must call bind() function first.";
				}
			}
		}
		
		/**
		 * @private
		 */
		public function applyIndexBuffer(indexBuffer:IndexBuffer3D):void {
			if (_curBindedBufferState === this) {
				if (_bindedIndexBuffer !== indexBuffer) {
					indexBuffer._bindForVAO();//TODO:可和vao合并bind
					_bindedIndexBuffer = indexBuffer;
				}
			} else {
				throw "BufferState: must call bind() function first.";
			}
		}
	}

}