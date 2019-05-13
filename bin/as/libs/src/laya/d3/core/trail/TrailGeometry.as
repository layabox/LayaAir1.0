package laya.d3.core.trail {
	import laya.d3.core.BufferState;
	import laya.d3.core.Camera;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.TextureMode;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.MathUtils3D;
	import laya.d3.math.Vector3;
	import laya.layagl.LayaGL;
	import laya.resource.Resource;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>TrailGeometry</code> 类用于创建拖尾渲染单元。
	 */
	public class TrailGeometry extends GeometryElement {
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector31:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector32:Vector3 = new Vector3();
		
		/**@private */
		private static var _type:int = _typeCounter++;
		
		/**@private */
		private const _floatCountPerVertices1:int = 8;
		/**@private */
		private const _floatCountPerVertices2:int = 1;
		/**@private */
		private const _increaseSegementCount:int = 128;
		
		/**@private */
		private var _activeIndex:int = 0;
		/**@private */
		private var _endIndex:int = 0;
		/**@private */
		private var _needAddFirstVertex:Boolean = false;
		/**@private */
		private var _isTempEndVertex:Boolean = false;
		/**@private */
		private var _subBirthTime:Float32Array;
		/**@private */
		private var _subDistance:Float32Array;
		/**@private */
		private var _segementCount:int;
		/**@private */
		private var _vertices1:Float32Array;
		/**@private */
		private var _vertices2:Float32Array;
		/**@private */
		private var _vertexBuffer1:VertexBuffer3D;
		/**@private */
		private var _vertexBuffer2:VertexBuffer3D;
		/**@private */
		private var _lastFixedVertexPosition:Vector3 = new Vector3();
		/**@private */
		private var _owner:TrailFilter;
		/** @private */
		private var _bufferState:BufferState = new BufferState();
		
		public function TrailGeometry(owner:TrailFilter) {
			_owner = owner;
			;
			_resizeData(_increaseSegementCount, _bufferState);
		}
		
		/**
		 * @private
		 */
		private function _resizeData(segementCount:int, bufferState:BufferState):void {
			_segementCount = _increaseSegementCount;
			_subBirthTime = new Float32Array(segementCount);
			_subDistance = new Float32Array(segementCount);
			
			var vertexCount:int = segementCount * 2;
			var vertexDeclaration1:VertexDeclaration = VertexTrail.vertexDeclaration1;
			var vertexDeclaration2:VertexDeclaration = VertexTrail.vertexDeclaration2;
			var vertexBuffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();
			var vertexbuffer1Size:int = vertexCount * vertexDeclaration1.vertexStride;
			var vertexbuffer2Size:int = vertexCount * vertexDeclaration2.vertexStride;
			var memorySize:int = vertexbuffer1Size + vertexbuffer2Size;
			
			_vertices1 = new Float32Array(vertexCount * _floatCountPerVertices1);
			_vertexBuffer1 = new VertexBuffer3D(vertexbuffer1Size, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer1.vertexDeclaration = vertexDeclaration1;
			
			_vertices2 = new Float32Array(vertexCount * _floatCountPerVertices2);
			_vertexBuffer2 = new VertexBuffer3D(vertexbuffer2Size, WebGLContext.DYNAMIC_DRAW, false);
			_vertexBuffer2.vertexDeclaration = vertexDeclaration2;
			
			vertexBuffers.push(_vertexBuffer1);
			vertexBuffers.push(_vertexBuffer2);
			bufferState.bind();
			bufferState.applyVertexBuffers(vertexBuffers);
			bufferState.unBind();
			
			Resource._addMemory(memorySize, memorySize);
		}
		
		/**
		 * @private
		 */
		private function _resetData():void {
			var count:int = _endIndex - _activeIndex;
			if (count == _segementCount) {//当前count=_segementCount表示已满,需要扩充
				_vertexBuffer1.destroy();
				_vertexBuffer2.destroy();
				_segementCount += _increaseSegementCount;
				_resizeData(_segementCount, _bufferState);
			}
			
			_vertexBuffer1.setData(_vertices1, 0, _floatCountPerVertices1 * 2 * _activeIndex, _floatCountPerVertices1 * 2 * count);
			_vertexBuffer2.setData(_vertices2, 0, _floatCountPerVertices2 * 2 * _activeIndex, _floatCountPerVertices2 * 2 * count);
			var offset:int = _activeIndex * 4;
			var rightSubDistance:Float32Array = new Float32Array(_subDistance.buffer, offset, count);//修改距离数据
			var rightSubBirthTime:Float32Array = new Float32Array(_subBirthTime.buffer, offset, count);//修改出生时间数据
			_subDistance.set(rightSubDistance, 0);
			_subBirthTime.set(rightSubBirthTime, 0);
			_endIndex = count;
			_activeIndex = 0;
		}
		
		/**
		 * @private
		 * 更新Trail数据
		 */
		public function _updateTrail(camera:Camera, lastPosition:Vector3, position:Vector3):void {
			if (!Vector3.equals(lastPosition, position)) {//位置不变不产生分段
				if ((_endIndex - _activeIndex) === 0)
					_addTrailByFirstPosition(camera, position);//当前分段全部消失时,需要添加一个首分段
				else
					_addTrailByNextPosition(camera, position);
			}
		}
		
		/**
		 * @private
		 * 通过起始位置添加TrailRenderElement起始数据
		 */
		private function _addTrailByFirstPosition(camera:Camera, position:Vector3):void {
			(_endIndex === _segementCount) && (_resetData());
			_subDistance[_endIndex] = 0;
			_subBirthTime[_endIndex] = _owner._curtime;
			_endIndex++;
			position.cloneTo(_lastFixedVertexPosition);
			_needAddFirstVertex = true;
		}
		
		/**
		 * @private
		 * 通过位置更新TrailRenderElement数据
		 */
		private function _addTrailByNextPosition(camera:Camera, position:Vector3):void {
			var delVector3:Vector3 = _tempVector30;
			var pointAtoBVector3:Vector3 = _tempVector31;
			Vector3.subtract(position, _lastFixedVertexPosition, delVector3);
			var forward:Vector3 = _tempVector32;
			switch (_owner.alignment) {
			case TrailFilter.ALIGNMENT_VIEW: 
				camera.transform.getForward(forward);
				Vector3.cross(delVector3, forward, pointAtoBVector3);
				break;
			case TrailFilter.ALIGNMENT_TRANSFORM_Z: 
				_owner._owner.transform.getForward(forward);
				Vector3.cross(delVector3, forward, pointAtoBVector3);//实时更新模式需要和view一样根据当前forward重新计算
				break;
			}
			
			Vector3.normalize(pointAtoBVector3, pointAtoBVector3);
			Vector3.scale(pointAtoBVector3, _owner.widthMultiplier / 2, pointAtoBVector3);
			
			var delLength:Number = Vector3.scalarLength(delVector3);
			var tempEndIndex:int;
			var offset:Number;
			
			if (_needAddFirstVertex) {
				_updateVerticesByPositionData(position, pointAtoBVector3, _endIndex - 1);//延迟更新首分段数据
				_needAddFirstVertex = false;
			}
			
			if (delLength - _owner.minVertexDistance >= MathUtils3D.zeroTolerance) {//大于最小距离产生新分段
				if (_isTempEndVertex) {
					tempEndIndex = _endIndex - 1;
					offset = delLength - _subDistance[tempEndIndex];
					_updateVerticesByPosition(position, pointAtoBVector3, delLength, tempEndIndex);
					_owner._totalLength += offset;//不产生新分段要通过差值更新总距离
				} else {
					(_endIndex === _segementCount) && (_resetData());
					_updateVerticesByPosition(position, pointAtoBVector3, delLength, _endIndex);
					_owner._totalLength += delLength;
					_endIndex++;
				}
				position.cloneTo(_lastFixedVertexPosition);
				_isTempEndVertex = false;
			} else {
				if (_isTempEndVertex) {
					tempEndIndex = _endIndex - 1;
					offset = delLength - _subDistance[tempEndIndex];
					_updateVerticesByPosition(position, pointAtoBVector3, delLength, tempEndIndex);
					_owner._totalLength += offset;//不产生新分段要通过差值更新总距离
				} else {
					(_endIndex === _segementCount) && (_resetData());
					_updateVerticesByPosition(position, pointAtoBVector3, delLength, _endIndex);
					_owner._totalLength += delLength;
					_endIndex++;
				}
				_isTempEndVertex = true;
			}
		}
		
		/**
		 * @private
		 * 通过位置更新顶点数据
		 */
		private function _updateVerticesByPositionData(position:Vector3, pointAtoBVector3:Vector3, index:int):void {
			var vertexOffset:int = _floatCountPerVertices1 * 2 * index;
			
			var curtime:Number = _owner._curtime;
			_vertices1[vertexOffset] = position.x;
			_vertices1[vertexOffset + 1] = position.y;
			_vertices1[vertexOffset + 2] = position.z;
			_vertices1[vertexOffset + 3] = -pointAtoBVector3.x;
			_vertices1[vertexOffset + 4] = -pointAtoBVector3.y;
			_vertices1[vertexOffset + 5] = -pointAtoBVector3.z;
			_vertices1[vertexOffset + 6] = curtime;
			_vertices1[vertexOffset + 7] = 1.0;
			
			_vertices1[vertexOffset + 8] = position.x;
			_vertices1[vertexOffset + 9] = position.y;
			_vertices1[vertexOffset + 10] = position.z;
			_vertices1[vertexOffset + 11] = pointAtoBVector3.x;
			_vertices1[vertexOffset + 12] = pointAtoBVector3.y;
			_vertices1[vertexOffset + 13] = pointAtoBVector3.z;
			_vertices1[vertexOffset + 14] = curtime;
			_vertices1[vertexOffset + 15] = 0.0;
			
			var floatCount:int = _floatCountPerVertices1 * 2;
			_vertexBuffer1.setData(_vertices1, vertexOffset, vertexOffset, floatCount);
		}
		
		/**
		 * @private
		 * 通过位置更新顶点数据、距离、出生时间
		 */
		private function _updateVerticesByPosition(position:Vector3, pointAtoBVector3:Vector3, delDistance:Number, index:int):void {
			_updateVerticesByPositionData(position, pointAtoBVector3, index);
			_subDistance[index] = delDistance;
			_subBirthTime[index] = _owner._curtime;
		}
		
		/**
		 * @private
		 * 更新VertexBuffer2数据
		 */
		public function _updateVertexBufferUV():void {
			var vertexCount:int = _endIndex;
			var curLength:Number = 0;
			for (var i:int = _activeIndex, j:int = vertexCount; i < j; i++) {
				(i !== _activeIndex) && (curLength += _subDistance[i]);
				var uvX:Number;
				if (_owner.textureMode == TextureMode.Stretch)
					uvX = 1.0 - curLength / _owner._totalLength;
				else
					uvX = 1.0 - (_owner._totalLength - curLength);
				
				_vertices2[i * 2] = uvX;
				_vertices2[i * 2 + 1] = uvX;
			}
			var offset:int = _activeIndex * 2;
			_vertexBuffer2.setData(_vertices2, offset, offset, vertexCount * 2 - offset);
		}
		
		/**
		 * @private
		 */
		public function _updateDisappear():void {
			var count:int = _endIndex;
			for (var i:int = _activeIndex; i < count; i++) {
				if (_owner._curtime - _subBirthTime[i] >= _owner.time + MathUtils3D.zeroTolerance) {
					var nextIndex:int = i + 1;
					if (nextIndex !== count)
						_owner._totalLength -= _subDistance[nextIndex];//移除分段要减去下一分段到当前分段的距离
					
					if (_isTempEndVertex && (nextIndex === count - 1)) {//如果只剩最后一分段要将其转化为固定分段
						var offset:int = _floatCountPerVertices1 * i * 2;
						var fixedPos:Vector3 = _lastFixedVertexPosition;
						fixedPos.x = _vertices1[0];
						fixedPos.y = _vertices1[1];
						fixedPos.z = _vertices1[2];
						_isTempEndVertex = false;
					}
					_activeIndex++;
				} else {
					break;
				}
			}
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
		override public function _prepareRender(state:RenderContext3D):Boolean {
			return _endIndex - _activeIndex > 1;//当前分段为0或1时不渲染
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			_bufferState.bind();
			var start:int = _activeIndex * 2;
			var count:int = _endIndex * 2 - start;
			LayaGL.instance.drawArrays(WebGLContext.TRIANGLE_STRIP, start, count);
			Stat.renderBatches++;
			Stat.trianglesFaces += count - 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			var memorySize:int = _vertexBuffer1._byteLength + _vertexBuffer2._byteLength;
			Resource._addMemory(-memorySize, -memorySize);
			
			_bufferState.destroy();
			_vertexBuffer1.destroy();
			_vertexBuffer2.destroy();
			
			_bufferState = null;
			_vertices1 = null;
			_vertexBuffer1 = null;
			_vertices2 = null;
			_vertexBuffer2 = null;
			_subBirthTime = null;
			_subDistance = null;
			_lastFixedVertexPosition = null;
		}
	
	}
}