package laya.d3.resource.tempelet {
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.glitter.GlitterSetting;
	import laya.d3.core.glitter.SplineCurvePositionVelocity;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexGlitter;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.ShaderDefines3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * @private
	 * <code>GlitterTemplet</code> 类用于创建闪光数据模板。
	 */
	public class GlitterTemplet extends EventDispatcher implements IRenderable {
		private var _tempVector0:Vector3 = new Vector3();
		private var _tempVector1:Vector3 = new Vector3();
		private var _tempVector2:Vector3 = new Vector3();
		private var _tempVector3:Vector3 = new Vector3();
		
		private const _floatCountPerVertex:int = 6;//顶点结构为Position(3个float)+UV(2个float)+Time(1个float)
		
		private var _owner:Glitter;
		public var _albedo:Vector4 = new Vector4(1.0, 1.0, 1.0, 1.0);
		private var _vertices:Float32Array;
		private var _vertexBuffer:VertexBuffer3D;
		
		private var _firstActiveElement:int;
		private var _firstNewElement:int;
		private var _firstFreeElement:int;
		private var _firstRetiredElement:int;
		public var _currentTime:Number;
		private var _drawCounter:int;
		
		private var scLeft:SplineCurvePositionVelocity;
		private var scRight:SplineCurvePositionVelocity;
		
		private var _numPositionMode:int;
		private var _posModeLastPosition0:Vector3 = new Vector3();
		private var _posModeLastPosition1:Vector3 = new Vector3();
		private var _posModePosition0:Vector3 = new Vector3();
		private var _posModePosition1:Vector3 = new Vector3();
		
		private var _numPositionVelocityMode:int;
		private var _posVelModePosition0:Vector3 = new Vector3();
		private var _posVelModeVelocity0:Vector3 = new Vector3();
		private var _posVelModePosition1:Vector3 = new Vector3();
		private var _posVelModeVelocity1:Vector3 = new Vector3();
		
		private var _lastTime:Number;
		
		private var _needPatch:Boolean;
		private var _lastPatchAddPos0:Vector3;
		private var _lastPatchAddPos1:Vector3;
		private var _lastPatchAddTime:Number;
		
		public var setting:GlitterSetting;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {//TODO:是否应改成BufferTrigleCount，或者只取有用数据
			var drawVertexCount:int;
			if (_firstActiveElement < _firstFreeElement) {
				drawVertexCount = (_firstFreeElement - _firstActiveElement) * 2 - 2;
			} else {
				drawVertexCount = (setting.maxSegments - _firstActiveElement) * 2 - 2;
				drawVertexCount += _firstFreeElement * 2 - 2;
			}
			return drawVertexCount;
		}
		
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return null;
		}
		
		public function GlitterTemplet(owner:Glitter, setting:GlitterSetting) {
			_owner = owner;
			_lastTime = 0
			
			_lastPatchAddPos0 = new Vector3();
			_lastPatchAddPos1 = new Vector3();
			scLeft = new SplineCurvePositionVelocity();//插值器
			scRight = new SplineCurvePositionVelocity();//插值器
			
			_firstActiveElement = 0;
			_firstNewElement = 0;
			_firstFreeElement = 0;
			_firstRetiredElement = 0;
			_currentTime = 0;
			_drawCounter = 0;
			
			_needPatch = false;
			
			this.setting = setting;
			_initialize();
			_loadContent();
			_owner.on(Event.ENABLED_CHANGED, this, _onEnableChanged);
		}
		
		/**
		 * @private
		 */
		private function _initialize():void {
			_vertices = new Float32Array(setting.maxSegments * _floatCountPerVertex * 2);
		}
		/**
		 * @private
		 */
		private function _loadContent():void {
			_vertexBuffer = VertexBuffer3D.create(VertexGlitter.vertexDeclaration, setting.maxSegments * 2, WebGLContext.DYNAMIC_DRAW);
		}
		
		public function _onEnableChanged(enable:Boolean):void {
			if (!enable) {
				_numPositionMode = 0;
				_numPositionVelocityMode = 0;
				
				_firstActiveElement = 0;
				_firstNewElement = 0;
				_firstFreeElement = 0;
				_firstRetiredElement = 0;
				_currentTime = 0;
				_drawCounter = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _updateTextureCoordinates():void {
			if (_firstActiveElement < _firstFreeElement) {
				_updateSubTextureCoordinates(_firstActiveElement, (_firstFreeElement - _firstActiveElement) * 2);
			} else {
				_updateSubTextureCoordinates(_firstActiveElement, (setting.maxSegments - _firstActiveElement) * 2);
				if (_firstFreeElement > 0)
					_updateSubTextureCoordinates(0, _firstFreeElement * 2);
			}
		}
		
		/**
		 * @private
		 */
		private function _updateSubTextureCoordinates(start:int, count:int):void {
			var startOffset:int = start * 2;
			for (var i:int = 0; i < count; i += 2) {
				var vertexOffset:int = startOffset + i;
				var upVertexOffset:int = vertexOffset * _floatCountPerVertex;
				var downVertexOffset:int = (vertexOffset + 1) * _floatCountPerVertex;
				_vertices[upVertexOffset + 3] = _vertices[downVertexOffset + 3] = (_vertices[upVertexOffset + 5] - _currentTime) / setting.lifeTime;//更新uv.x
			}
		}
		
		/**
		 * @private
		 */
		private function _retireActiveGlitter():void {
			var particleDuration:Number = setting.lifeTime;
			
			var _floatCountOneSegement:int = _floatCountPerVertex * 2;
			while (_firstActiveElement != _firstNewElement) {
				var index:int = _firstActiveElement * _floatCountOneSegement + 5;//5为Time
				var particleAge:Number = _currentTime - _vertices[index];
				
				if (particleAge < particleDuration)
					break;
				
				_vertices[index] = _drawCounter;
				
				_firstActiveElement++;
				
				if (_firstActiveElement >= setting.maxSegments)
					_firstActiveElement = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _freeRetiredGlitter():void {
			var _floatCountOneSegement:int = _floatCountPerVertex * 2;
			while (_firstRetiredElement != _firstActiveElement) {
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountOneSegement + 5];//5为Time
				
				if (age < 3)//GPU从不滞后于CPU两帧，出于显卡驱动BUG等安全因素考虑滞后三帧
					break;
				
				_firstRetiredElement++;
				
				if (_firstRetiredElement >= setting.maxSegments)
					_firstRetiredElement = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _calcVelocity(left:Vector3, right:Vector3, out:Vector3):void {
			Vector3.subtract(left, right, out);
			Vector3.scale(out, 0.5, out);
		}
		
		/**
		 * @private
		 */
		private function _addNewGlitterSegementToVertexBuffer():void//通常只更新（_firstNewParticle - _firstActiveParticle）,但因为动态修改了UV数据所以更新（_firstFreeParticle - _firstActiveParticle）
		{
			var start:int;
			if (_firstActiveElement < _firstFreeElement) {// 如果新增加的粒子在Buffer中是连续的区域，只upload一次
				start = _firstActiveElement * 2 * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices, start, start, (_firstFreeElement - _firstActiveElement) * 2 * _floatCountPerVertex);
			} else {	//如果新增粒子区域超过Buffer末尾则循环到开头，需upload两次
				
				start = _firstActiveElement * 2 * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices, start, start, (setting.maxSegments - _firstActiveElement) * 2 * _floatCountPerVertex);
				if (_firstFreeElement > 0) {
					_vertexBuffer.setData(_vertices, 0, 0, _firstFreeElement * 2 * _floatCountPerVertex);
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		/**
		 * @private
		 */
		private function _addGlitter(position0:Vector3, position1:Vector3, time:Number):void//由于循环队列判断算法，当下一个freeParticle等于retiredParticle时不添加例子，意味循环队列中永远有一个空位。（由于此判断算法快速、简单，所以放弃了使循环队列饱和的复杂算法（需判断freeParticle在retiredParticle前、后两种情况并不同处理））
		{
			if (_needPatch)//由于绘制基元TRIANGLE_STRIP,不能中断，所以如果超出Buffer上限，从零绘制需要补上次的顶点，通常TRIANGLE则不需要
			{
				_needPatch = false;
				_addGlitter(_lastPatchAddPos0, _lastPatchAddPos1, _lastPatchAddTime);
			}
			
			var nextFreeParticle:int = _firstFreeElement + 1;
			if (nextFreeParticle >= setting.maxSegments) {
				nextFreeParticle = 0;
				position0.cloneTo(_lastPatchAddPos0);
				position1.cloneTo(_lastPatchAddPos1);
				_lastPatchAddTime = time;
				_needPatch = true;
			}
			
			if (nextFreeParticle === _firstRetiredElement)//刀光不同于粒子，不能中断。
				throw new Error("GlitterTemplet:current segement count have large than maxSegments,please adjust the  value of maxSegments or add Glitter Vertex Frequency.");
			
			var position0e:Float32Array = position0.elements;
			var position1e:Float32Array = position1.elements;
			var j:int;
			//position0
			var positionIndex:int = _firstFreeElement * _floatCountPerVertex * 2;
			for (j = 0; j < 3; j++)
				_vertices[positionIndex + j] = position0e[j];
			
			_vertices[positionIndex + 3] = 0.0;//uv.x,临时赋0,最后统一调整
			_vertices[positionIndex + 4] = 0.0;//uv.y
			_vertices[positionIndex + 5] = time;
			
			//position1
			var nextPositionIndex:int = positionIndex + _floatCountPerVertex;
			for (j = 0; j < 3; j++)
				_vertices[nextPositionIndex + j] = position1e[j];
			
			_vertices[nextPositionIndex + 3] = 0.0;//uv.x,临时赋0,最后统一调整
			_vertices[nextPositionIndex + 4] = 1.0;//uv.y
			_vertices[nextPositionIndex + 5] = time;
			
			_firstFreeElement = nextFreeParticle;
		}
		
		/**
		 * @private
		 * 更新闪光。
		 * @param	elapsedTime 间隔时间
		 */
		public function _update(elapsedTime:int):void {
			_currentTime += elapsedTime / 1000;
			_retireActiveGlitter();
			_freeRetiredGlitter();
			
			if (_firstActiveElement == _firstFreeElement)
				_currentTime = 0;
			
			if (_firstRetiredElement == _firstActiveElement)
				_drawCounter = 0;
			
			_updateTextureCoordinates();//实时更新纹理坐标
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			//设备丢失时,貌似WebGL不会丢失
			//  todo  setData  here!
			if (_firstNewElement != _firstFreeElement) {
				_addNewGlitterSegementToVertexBuffer();
			}
			
			_drawCounter++;
			if (_firstActiveElement != _firstFreeElement) {
				_vertexBuffer.bindWithIndexBuffer(null);
				return true;
			}
			return false;
		}
		
		/**
		 * @private
		 * 渲染闪光。
		 * @param	state 相关渲染状态
		 */
		public function _render(state:RenderState):void {
			var drawVertexCount:int;
			var glContext:WebGLContext = WebGL.mainContext;
			if (_firstActiveElement < _firstFreeElement) {
				drawVertexCount = (_firstFreeElement - _firstActiveElement) * 2;
				glContext.drawArrays(WebGLContext.TRIANGLE_STRIP, _firstActiveElement * 2, drawVertexCount);
				Stat.trianglesFaces += drawVertexCount - 2;
				Stat.drawCall++;
			} else {
				drawVertexCount = (setting.maxSegments - _firstActiveElement) * 2;
				glContext.drawArrays(WebGLContext.TRIANGLE_STRIP, _firstActiveElement * 2, drawVertexCount);
				Stat.trianglesFaces += drawVertexCount - 2;
				Stat.drawCall++;
				if (_firstFreeElement > 0) {
					drawVertexCount = _firstFreeElement * 2;
					glContext.drawArrays(WebGLContext.TRIANGLE_STRIP, 0, drawVertexCount);
					Stat.trianglesFaces += drawVertexCount - 2;
					Stat.drawCall++;
				}
			}
			
		}
		
		/**
		 * 通过位置添加刀光。
		 * @param position0 位置0。
		 * @param position1 位置1。
		 */
		public function addVertexPosition(position0:Vector3, position1:Vector3):void {
			if (_owner.enable) {
				if (_numPositionMode < 2) {
					if (_numPositionMode === 0) {
						position0.cloneTo(_posModeLastPosition0);
						position1.cloneTo(_posModeLastPosition1);
					} else {
						position0.cloneTo(_posModePosition0);
						position1.cloneTo(_posModePosition1);
					}
					_numPositionMode++;
				} else {
					var v0:Vector3 = _tempVector2;
					_calcVelocity(position0, _posModeLastPosition0, v0);
					var v1:Vector3 = _tempVector3;
					_calcVelocity(position1, _posModeLastPosition1, v1);
					addVertexPositionVelocity(_posModePosition0, v0, _posModePosition1, v1);
					
					_posModePosition0.cloneTo(_posModeLastPosition0);
					_posModePosition1.cloneTo(_posModeLastPosition1);
					position0.cloneTo(_posModePosition0);
					position1.cloneTo(_posModePosition1);
				}
			}
		}
		
		/**
		 * 通过位置和速度添加刀光。
		 * @param position0 位置0。
		 * @param velocity0 速度0。
		 * @param position1 位置1。
		 * @param velocity1 速度1。
		 */
		public function addVertexPositionVelocity(position0:Vector3, velocity0:Vector3, position1:Vector3, velocity1:Vector3):void {
			if (_owner.enable) {
				if (_numPositionVelocityMode === 0) {
					_numPositionVelocityMode++;
				} else {
					var d:Vector3 = _tempVector0;
					Vector3.subtract(position0, _posVelModePosition0, d);
					var distance0:Number = Vector3.scalarLength(d);
					
					Vector3.subtract(position1, _posVelModePosition1, d);
					var distance1:Number = Vector3.scalarLength(d);
					
					var slerpCount:int = 0;
					var minSegmentDistance:Number = setting.minSegmentDistance;
					if (distance0 < minSegmentDistance && distance1 < minSegmentDistance)
						return;
					slerpCount = 1 + Math.floor(Math.max(distance0, distance1) / setting.minInterpDistance);
					
					if (slerpCount === 1) {
						_addGlitter(position0, position1, _currentTime);
					} else {
						slerpCount = Math.min(slerpCount, setting.maxSlerpCount);//最大插值,可取消
						
						scLeft.Init(_posVelModePosition0, _posVelModeVelocity0, position0, velocity0);
						scRight.Init(_posVelModePosition1, _posVelModeVelocity1, position1, velocity1);
						
						var segment:Number = 1.0 / slerpCount;
						var addSegment:Number = segment;
						
						var timeOffset:Number = _currentTime - _lastTime;
						for (var i:int = 1; i <= slerpCount; i++) {
							var pos0:Vector3 = _tempVector0;
							scLeft.Slerp(addSegment, pos0);
							var pos1:Vector3 = _tempVector1;
							scRight.Slerp(addSegment, pos1);
							var time:Number = _lastTime + timeOffset * i / slerpCount;
							_addGlitter(pos0, pos1, time);
							addSegment += segment;
						}
					}
				}
				
				_lastTime = _currentTime;
				position0.cloneTo(_posVelModePosition0);
				velocity0.cloneTo(_posVelModeVelocity0);
				position1.cloneTo(_posVelModePosition1);
				velocity1.cloneTo(_posVelModeVelocity1);
			}
		}
		
		public function dispose():void {
			_owner.off(Event.ENABLED_CHANGED, this, _onEnableChanged);
		}
	
	}
}