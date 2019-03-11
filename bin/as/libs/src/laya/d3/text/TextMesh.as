package laya.d3.text {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Color;
	
	/**
	 * <code>TextMesh</code> 类用于创建文本网格。
	 */
	public class TextMesh {
		/**@private */
		private static var _indexBuffer:IndexBuffer3D;
		
		/**@private */
		private var _vertices:Float32Array;
		/**@private */
		private var _vertexBuffer:VertexBuffer3D;
		/**@private */
		private var _text:String;
		/**@private */
		private var _fontSize:int;
		/**@private */
		private var _color:Color;
		
		/**
		 * 获取文本。
		 * @return 文本。
		 */
		public function get text():String {
			return _text;
		}
		
		/**
		 * 设置文本。
		 * @param value 文本。
		 */
		public function set text(value:String):void {
			_text = value;
		}
		
		/**
		 * 获取字体尺寸。
		 * @param  value 字体尺寸。
		 */
		public function get fontSize():int {
			return _fontSize;
		}
		
		/**
		 * 设置字体储存。
		 * @return 字体尺寸。
		 */
		public function set fontSize(value:int):void {
			_fontSize = value;
		}
		
		/**
		 * 获取颜色。
		 * @return 颜色。
		 */
		public function get color():Color {
			return _color;
		}
		
		/**
		 * 设置颜色。
		 * @param 颜色。
		 */
		public function set color(value:Color):void {
			_color = value;
		}
		
		/**
		 * 创建一个新的 <code>TextMesh</code> 实例。
		 */
		public function TextMesh() {
		
		}
		
		/**
		 * @private
		 */
		private function _createVertexBuffer(charCount:int):void {
			//var verDec:VertexDeclaration = vertexbu.vertexDeclaration;
			//var newVertices:Float32Array = new Float32Array(verticesCount * FLOATCOUNTPERVERTEX);
			//var newVertecBuffer:VertexBuffer3D = new VertexBuffer3D(verDec.vertexStride * verticesCount, WebGLContext.DYNAMIC_DRAW, false);
			//var bufferState:BufferState = new BufferState();
			//newVertecBuffer.vertexDeclaration = verDec;
			//
			//bufferState.bind();
			//bufferState.applyVertexBuffer(newVertecBuffer);
			//bufferState.applyIndexBuffer(_indexBuffer);
			//bufferState.unBind();
			//
			//_vertices.push(newVertices);
			//_vertexbuffers.push(newVertecBuffer);
			//_vertexUpdateFlag.push([2147483647/*int.MAX_VALUE*/, -2147483647/*int.MIN_VALUE*/]);//0:startUpdate,1:endUpdate
			//_bufferStates.push(bufferState);
		}
		
		/**
		 * @private
		 */
		private function _resizeVertexBuffer(charCount:int):void {
		
		}
		
		/**
		 * @private
		 */
		private function _addChar():void {
			//_vertexBuffer
		}
	
	}

}