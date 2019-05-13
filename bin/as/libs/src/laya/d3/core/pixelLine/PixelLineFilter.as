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
		private var _minUpdate:int = Number.MAX_VALUE;
		/** @private */
		private var _maxUpdate:int = Number.MIN_VALUE;
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
			_vertices[offset + 0] = startPosition.x;
			_vertices[offset + 1] = startPosition.y;
			_vertices[offset + 2] = startPosition.z;
			
			_vertices[offset + 3] = startColor.r;
			_vertices[offset + 4] = startColor.g;
			_vertices[offset + 5] = startColor.b;
			_vertices[offset + 6] = startColor.a;
			
			_vertices[offset + 7] = endPosition.x;
			_vertices[offset + 8] = endPosition.y;
			_vertices[offset + 9] = endPosition.z;
			
			_vertices[offset + 10] = endColor.r;
			_vertices[offset + 11] = endColor.g;
			_vertices[offset + 12] = endColor.b;
			_vertices[offset + 13] = endColor.a;
			_minUpdate = Math.min(_minUpdate, offset);
			_maxUpdate = Math.max(_maxUpdate, offset + _floatCountPerVertices * 2);
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
			_vertices.set(rightPartVertices, offset);
			_minUpdate = offset;
			_maxUpdate = offset + _floatCountPerVertices * 2;
			_lineCount--;
		}
		
		/**
		 * @private
		 */
		public function _updateLineData(index:int, startPosition:Vector3, endPosition:Vector3, startColor:Color, endColor:Color):void {
			var floatCount:int = _floatCountPerVertices * 2;
			var offset:int = index * floatCount;
			_updateLineVertices(offset, startPosition, endPosition, startColor, endColor);
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
		}
		
		/**
		 * 获取线段数据
		 * @return 线段数据。
		 */
		public function _getLineData(index:int, out:PixelLineData):void {
			var startPosition:Vector3 = out.startPosition;
			var startColor:Color = out.startColor;
			var endPosition:Vector3 = out.endPosition;
			var endColor:Color = out.endColor;
			
			var vertices:Float32Array = _vertices;
			var offset:int = index * _floatCountPerVertices * 2;
			
			startPosition.x = vertices[offset + 0];
			startPosition.y = vertices[offset + 1];
			startPosition.z = vertices[offset + 2];
			startColor.r = vertices[offset + 3];
			startColor.g = vertices[offset + 4];
			startColor.b = vertices[offset + 5];
			startColor.a = vertices[offset + 6];
			
			endPosition.x = vertices[offset + 7];
			endPosition.y = vertices[offset + 8];
			endPosition.z = vertices[offset + 9];
			endColor.r = vertices[offset + 10];
			endColor.g = vertices[offset + 11];
			endColor.b = vertices[offset + 12];
			endColor.a = vertices[offset + 13];
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
			if (_minUpdate !== Number.MAX_VALUE && _maxUpdate !== Number.MIN_VALUE) {
				_vertexBuffer.setData(_vertices, _minUpdate, _minUpdate, _maxUpdate - _minUpdate);
				_minUpdate = Number.MAX_VALUE;
				_maxUpdate = Number.MIN_VALUE;
			}
			
			if (_lineCount > 0) {
				_bufferState.bind();
				LayaGL.instance.drawArrays(WebGLContext.LINES, 0, _lineCount * 2);
				Stat.renderBatches++;
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