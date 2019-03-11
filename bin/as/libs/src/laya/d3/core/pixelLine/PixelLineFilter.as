package laya.d3.core.pixelLine {
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>PixelLineFilter</code> 类用于线过滤器。
	 */
	public class PixelLineFilter extends GeometryElement {
		/** @private */
		private const _floatCountPerVertices:int = 7;
		
		/** @private */
		private var _owner:PixelLineSprite3D;
		/** @private */
		private var _vertexBuffer:VertexBuffer3D;
		/** @private */
		private var _vertices:Float32Array;
		
		/** @private */
		private var _bufferState:BufferState = new BufferState();
		
		/** @private */
		public var _maxLineCount:int = 0;
		/** @private */
		public var _lineCount:int = 0;
		
		public function PixelLineFilter(owner:PixelLineSprite3D, maxLineCount:int) {
			var pointCount:int = maxLineCount * 2;
			_owner = owner;
			_maxLineCount = maxLineCount;
			_vertices = new Float32Array(pointCount * _floatCountPerVertices);
			_vertexBuffer = new VertexBuffer3D(PixelLineVertex.vertexDeclaration.vertexStride * pointCount, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer.vertexDeclaration = PixelLineVertex.vertexDeclaration;
			
			_bufferState.bind();
			_bufferState.applyVertexBuffer(_vertexBuffer);
			_bufferState.unBind();
		}
		
		/** 
		 * @private 
		 */
		public function _resizeLineData(maxCount:int):void {
			var pointCount:int = maxCount * 2;
			var lastVertices:Float32Array = _vertices;
			
			_vertexBuffer.destroy();
			_maxLineCount = maxCount;
			
			var vertexCount:int = pointCount * _floatCountPerVertices;
			_vertices = new Float32Array(vertexCount);
			_vertexBuffer = new VertexBuffer3D(PixelLineVertex.vertexDeclaration.vertexStride * pointCount, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer.vertexDeclaration = PixelLineVertex.vertexDeclaration;
			
			if (vertexCount < lastVertices.length) {//取最小长度,拷贝旧数据
				_vertices.set(new Float32Array(lastVertices.buffer, 0, vertexCount));
				_vertexBuffer.setData(_vertices, 0, 0, vertexCount);
			} else {
				_vertices.set(lastVertices);
				_vertexBuffer.setData(_vertices, 0, 0, lastVertices.length);
			}
			
			_bufferState.bind();
			_bufferState.applyVertexBuffer(_vertexBuffer);
			_bufferState.unBind();
		}
		
		/**
		 * @private
		 */
		private function _updateLineVertices(offset:int, startPosition:Vector3, endPosition:Vector3, startColor:Color, endColor:Color):void {
			var startPositione:Float32Array = startPosition.elements;
			var endPositione:Float32Array = endPosition.elements;
			var startColore:Float32Array = startColor.elements;
			var endColore:Float32Array = endColor.elements;
			
			_vertices[offset + 0] = startPositione[0];
			_vertices[offset + 1] = startPositione[1];
			_vertices[offset + 2] = startPositione[2];
			
			_vertices[offset + 3] = startColore[0];
			_vertices[offset + 4] = startColore[1];
			_vertices[offset + 5] = startColore[2];
			_vertices[offset + 6] = startColore[3];
			
			_vertices[offset + 7] = endPositione[0];
			_vertices[offset + 8] = endPositione[1];
			_vertices[offset + 9] = endPositione[2];
			
			_vertices[offset + 10] = endColore[0];
			_vertices[offset + 11] = endColore[1];
			_vertices[offset + 12] = endColore[2];
			_vertices[offset + 13] = endColore[3];
		}
		
		/**
		 * @private
		 */
		public function _removeLineData(index:int):void {
			var floatCount:int = _floatCountPerVertices * 2;
			var nextIndex:int = index + 1;
			var offset:int = index * floatCount;
			var nextOffset:int = nextIndex * floatCount;
			var rightPartVertices:Float32Array = new Float32Array(_vertices.buffer, nextIndex * floatCount * 4, (_lineCount - nextIndex) * floatCount);
			_vertexBuffer.setData(rightPartVertices, offset);//必须在_vertices.set前执行,否则数据会被篡改
			_vertices.set(rightPartVertices, offset);
			_lineCount--;
		}
		
		/**
		 * @private
		 */
		public function _updateLineData(index:int, startPosition:Vector3, endPosition:Vector3, startColor:Color, endColor:Color):void {
			var floatCount:int = _floatCountPerVertices * 2;
			var offset:int = index * floatCount;
			_updateLineVertices(offset, startPosition, endPosition, startColor, endColor);
			_vertexBuffer.setData(_vertices, offset, offset, floatCount);
		}
		
		/**
		 * @private
		 */
		public function _updateLineDatas(index:int, data:Vector.<PixelLineData>):void {
			var floatCount:int = _floatCountPerVertices * 2;
			var offset:int = index * floatCount;
			var count:Number = data.length;
			for (var i:int = 0; i < count; i++) {
				var line:PixelLineData = data[i];
				_updateLineVertices((index + i) * floatCount, line.startPosition, line.endPosition, line.startColor, line.endColor);
			}
			_vertexBuffer.setData(_vertices, offset, offset, floatCount * count);
		}
		
		/**
		 * 获取线段数据
		 * @return 线段数据。
		 */
		public function _getLineData(index:int, out:PixelLineData):void {
			var startPosition:Float32Array = out.startPosition.elements;
			var startColor:Float32Array = out.startColor.elements;
			var endPosition:Float32Array = out.endPosition.elements;
			var endColor:Float32Array = out.endColor.elements;
			
			var vertices:Float32Array = _vertices;
			var offset:int = index * _floatCountPerVertices * 2;
			
			startPosition[0] = vertices[offset + 0];
			startPosition[1] = vertices[offset + 1];
			startPosition[2] = vertices[offset + 2];
			startColor[0] = vertices[offset + 0];
			startColor[1] = vertices[offset + 1];
			startColor[2] = vertices[offset + 2];
			startColor[3] = vertices[offset + 3];
			
			endPosition[0] = vertices[offset + 0];
			endPosition[1] = vertices[offset + 1];
			endPosition[2] = vertices[offset + 2];
			endColor[0] = vertices[offset + 0];
			endColor[1] = vertices[offset + 1];
			endColor[2] = vertices[offset + 2];
			endColor[3] = vertices[offset + 3];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _prepareRender(state:RenderContext3D):Boolean {
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			if (_lineCount > 0) {
				_bufferState.bind();
				LayaGL.instance.drawArrays(WebGLContext.LINES, 0, _lineCount * 2);
				Stat.renderBatch++;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			if (_destroyed)
				return;
			super.destroy();
			_bufferState.destroy();
			_vertexBuffer.destroy();
			_bufferState = null;
			_vertexBuffer = null;
			_vertices = null;
		}
	}
}