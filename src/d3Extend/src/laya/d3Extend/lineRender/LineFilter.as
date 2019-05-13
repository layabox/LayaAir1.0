package laya.d3Extend.lineRender {
	import laya.d3.core.BufferState;
	import laya.d3.core.Camera;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.resource.Context;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author
	 */
	public class LineFilter extends GeometryElement {
		/**@private */
		private static var _type:int = _typeCounter++;
		
		public var _camera:Camera;
		public var width:Number = 0.001;
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _vertices:Float32Array;
		private var _verticesIndex:int = 0;
		private var _everyAddVerticeCount:int = 0;
		private var _maxVertexCount:int = 1000;
		private const _floatCountPerVertices:int = 9;
		
		private var positionCount:int = 0;
		private var _firstPosition:Vector3 = new Vector3();
		private var _delVector3:Vector3 = new Vector3();
		private var _lastPosition:Vector3 = new Vector3();
		private var _pointAtoBVector3:Vector3 = new Vector3();
		
		public var color:Vector4 = new Vector4(1, 0, 0, 1);
		
		private var _pointe:Float32Array;
		private var _pointAtoBVector3e:Float32Array;
		private var _colore:Float32Array;
		
		public function LineFilter() {
			_vertices = new Float32Array(_maxVertexCount * _floatCountPerVertices);
			_vertexBuffer = new VertexBuffer3D(LineVertex.vertexDeclaration.vertexStride * _maxVertexCount, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer.vertexDeclaration = LineVertex.vertexDeclaration;
			
			var bufferState:BufferState = new BufferState();
			bufferState.bind();
			bufferState.applyVertexBuffer(_vertexBuffer);
			bufferState.unBind();
			_applyBufferState(bufferState);
		}
		
		private function _addLineByFirstPosition(firstPosition:Vector3, secondPosition:Vector3):void {
			Vector3.subtract(secondPosition, firstPosition, _delVector3);
			Vector3.cross(_delVector3, _camera.transform.forward, _pointAtoBVector3);
			Vector3.normalize(_pointAtoBVector3, _pointAtoBVector3);
			Vector3.scale(_pointAtoBVector3, width / 2, _pointAtoBVector3);
			
			_updateVerticesByPosition(firstPosition);
			
			firstPosition.cloneTo(_lastPosition);
		}
		
		private function _addLineByNextPosition(position:Vector3):void {
			
			Vector3.subtract(position, _lastPosition, _delVector3);
			Vector3.cross(_delVector3, _camera.transform.forward, _pointAtoBVector3);
			Vector3.normalize(_pointAtoBVector3, _pointAtoBVector3);
			Vector3.scale(_pointAtoBVector3, width / 2, _pointAtoBVector3);
			
			_updateVerticesByPosition(position);
			position.cloneTo(_lastPosition);
		}
		
		public function _updateVerticesByPosition(position:Vector3):void {
			
			_everyAddVerticeCount = 0;
			_pointe = position.elements;
			_pointAtoBVector3e = _pointAtoBVector3.elements;
			_colore = color.elements;
			
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _pointe[0] - _pointAtoBVector3e[0];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _pointe[1] - _pointAtoBVector3e[1];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _pointe[2] - _pointAtoBVector3e[2];
			
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[0];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[1];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[2];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[3];
			
			_vertices[_verticesIndex + _everyAddVerticeCount++] = 0;
			_vertices[_verticesIndex + _everyAddVerticeCount++] = 0;
			
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _pointe[0] + _pointAtoBVector3e[0];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _pointe[1] + _pointAtoBVector3e[1];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _pointe[2] + _pointAtoBVector3e[2];
			
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[0];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[1];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[2];
			_vertices[_verticesIndex + _everyAddVerticeCount++] = _colore[3];
			
			_vertices[_verticesIndex + _everyAddVerticeCount++] = 0;
			_vertices[_verticesIndex + _everyAddVerticeCount++] = 0;
			
			_vertexBuffer.setData(_vertices, _verticesIndex, _verticesIndex, _everyAddVerticeCount);
			_verticesIndex += _everyAddVerticeCount;
		
		}
		
		public function addDataForVertexBuffer(position:Vector3):void {
			
			positionCount++;
			
			if (positionCount == 1) {
				position.cloneTo(_firstPosition);
			} else if (positionCount == 2) {
				_addLineByFirstPosition(_firstPosition, position);
				_addLineByNextPosition(position);
			} else {
				_addLineByNextPosition(position);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return _type;
		}
		
		public function _update(state:Context):void {
			//_camera = state.camera;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _prepareRender(state:RenderContext3D):Boolean {
			//_setVertexBuffer(_vertexBuffer);
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			WebGL.mainContext.drawArrays(WebGLContext.TRIANGLE_STRIP, 0, _verticesIndex / _floatCountPerVertices);
			Stat.renderBatches++;
		}
	
	}

}