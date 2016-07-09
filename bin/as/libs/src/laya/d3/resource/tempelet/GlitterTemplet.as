package laya.d3.resource.tempelet {
	import laya.d3.core.glitter.GlitterSettings;
	import laya.d3.core.glitter.SplineCurvePositionVelocity;
	import laya.d3.core.render.IRender;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexGlitter;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines3D;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.ValusArray;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * @private
	 * <code>GlitterTemplet</code> 类用于创建闪光数据模板。
	 */
	public class GlitterTemplet implements IRender {
		
		private var _tempVector0:Vector3 = new Vector3();
		private var _tempVector1:Vector3 = new Vector3();
		private var _tempVector2:Vector3 = new Vector3();
		private var _tempVector3:Vector3 = new Vector3();
		
		protected var texture:Texture;
		protected var _vertices:Float32Array;
		protected var _vertexBuffer:VertexBuffer3D;
		protected const _floatCountPerVertex:int = 6;//顶点结构为Position(3个float)+UV(2个float)+Time(1个float)
		
		protected var _firstActiveElement:int;
		protected var _firstNewElement:int;
		protected var _firstFreeElement:int;
		protected var _firstRetiredElement:int;
		protected var _currentTime:Number;
		protected var _drawCounter:int;
		
		protected var _posShaderValue:* = [3, WebGLContext.FLOAT, false, 24, 0];
		protected var _uvShaderValue:* = [2, WebGLContext.FLOAT, false, 24, 12];
		protected var _timeShaderValue:* = [1, WebGLContext.FLOAT, false, 24, 20];
		protected var _shaderValue:ValusArray = new ValusArray();
		protected var _sharderNameID:int;
		protected var _shader:Shader;
		
		protected var numPositionMode:int;
		private var posModeLastPosition0:Vector3 = new Vector3();
		private var posModeLastPosition1:Vector3 = new Vector3();
		private var posModePosition0:Vector3 = new Vector3();
		private var posModePosition1:Vector3 = new Vector3();
		
		protected var numPositionVelocityMode:int;
		private var posVelModePosition0:Vector3 = new Vector3();
		private var posVelModeVelocity0:Vector3 = new Vector3();
		private var posVelModePosition1:Vector3 = new Vector3();
		private var posVelModeVelocity1:Vector3 = new Vector3();
		
		protected var _lastTime:Number;
		protected var _needPatch:Boolean = false;
		protected var _lastAddPos0:Vector3 = new Vector3();
		protected var _lastAddPos1:Vector3 = new Vector3();
		protected var _lastAddTime:Number;
		protected var scLeft:SplineCurvePositionVelocity;
		protected var scRight:SplineCurvePositionVelocity;
		
		public var setting:GlitterSettings;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get VertexBufferCount():int {
			return 1;
		}
		
		public function getBakedVertexs(index:int = 0):Float32Array {
			return null;
		}
		
		public function getBakedIndices():* {
			return null;
		}
		
		public function getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function getIndexBuffer():IndexBuffer3D {
			return null;
		}
		
		public function GlitterTemplet(glitterSetting:GlitterSettings) {
			_currentTime = _lastTime = 0;
			setting = glitterSetting;
			initialize();
			loadShaderParams();
			loadContent();
			scLeft = new SplineCurvePositionVelocity();//插值器
			scRight = new SplineCurvePositionVelocity();//插值器
		}
		
		protected function initialize():void {
			_vertices = new Float32Array(setting.maxSegments * _floatCountPerVertex * 2);
		}
		
		protected function loadContent():void {
			_vertexBuffer = VertexBuffer3D.create(VertexGlitter.vertexDeclaration, setting.maxSegments * 2, WebGLContext.DYNAMIC_DRAW);
		}
		
		protected function loadShaderParams():void {
			_sharderNameID = Shader.nameKey.get("GLITTER");
			
			if (setting.texturePath)//预设纹理ShaderValue
			{
				_shaderValue.pushValue(Buffer.DIFFUSETEXTURE, null, -1);
				var _this:GlitterTemplet = this;
				Laya.loader.load(setting.texturePath, Handler.create(null, function(texture:Texture):void {
					(texture.bitmap as WebGLImage).enableMerageInAtlas = false;
					(texture.bitmap as WebGLImage).mipmap = true;
					_this.texture = texture;
				}));
			}
		}
		
		public function update(elapsedTime:int):void {
			_currentTime += elapsedTime / 1000;
			retireActiveGlitters();
			freeRetiredGlitters();
			
			if (_firstActiveElement == _firstFreeElement)
				_currentTime = 0;
			
			if (_firstRetiredElement == _firstActiveElement)
				_drawCounter = 0;
			
			updateTextureCoordinate();//实时更新纹理坐标
		}
		
		public function _render(state:RenderState):Boolean {
			if (texture && texture.loaded) {
				update(state.elapsedTime);
				
				//设备丢失时,貌似WebGL不会丢失.............................................................
				//  todo  setData  here!
				//...................................................................................
				
				if (_firstNewElement != _firstFreeElement) {
					addNewGlitterSegementToVertexBuffer();
				}
				
				if (_firstActiveElement != _firstFreeElement) {
					var gl:WebGLContext = WebGL.mainContext;
					_vertexBuffer.bindWithIndexBuffer(null);
					
					_shader = getShader(state);
					
					var presz:int = _shaderValue.length;
					
					_shaderValue.pushArray(state.shaderValue);
					_shaderValue.pushArray(_vertexBuffer.vertexDeclaration.shaderValues);
					
					//_shaderValue.pushValue(Buffer.POSITION0, _posShaderValue, -1);
					//_shaderValue.pushValue(Buffer.UV0, _uvShaderValue, -1);
					//_shaderValue.pushValue(Buffer.TIME, _timeShaderValue, -1);
					
					_shaderValue.pushValue(Buffer.UNICOLOR, setting.color.elements, -1);
					_shaderValue.pushValue(Buffer.MVPMATRIX, state.projectionViewMatrix.elements, -1);
					_shaderValue.pushValue(Buffer.DURATION, setting.lifeTime, -1);
					_shaderValue.pushValue(Buffer.LUMINANCE, 1.0, -1);
					
					//设置粒子的时间参数，可通过此参数停止粒子动画
					_shaderValue.pushValue(Buffer.CURRENTTIME, _currentTime, -1);
					
					_shaderValue.data[1][0] = texture.source;
					_shaderValue.data[1][1] = texture.bitmap.id;
					
					_shader.uploadArray(_shaderValue.data, _shaderValue.length, null);
					
					_shaderValue.length = presz;
					
					var drawVertexCount:int;
					if (_firstActiveElement < _firstFreeElement) {
						drawVertexCount = (_firstFreeElement - _firstActiveElement) * 2;
						WebGL.mainContext.drawArrays(WebGLContext.TRIANGLE_STRIP, _firstActiveElement * 2, drawVertexCount);
						Stat.trianglesFaces += drawVertexCount-2;
						Stat.drawCall++;
					} else {
						drawVertexCount =(setting.maxSegments - _firstActiveElement) * 2;
						WebGL.mainContext.drawArrays(WebGLContext.TRIANGLE_STRIP, _firstActiveElement * 2, drawVertexCount);
						Stat.trianglesFaces += drawVertexCount-2;
						Stat.drawCall++;
						if (_firstFreeElement > 0)
						{
							drawVertexCount =_firstFreeElement * 2;
							WebGL.mainContext.drawArrays(WebGLContext.TRIANGLE_STRIP, 0, drawVertexCount);
							Stat.trianglesFaces += drawVertexCount-2;
							Stat.drawCall++;
						}
					}
					
					
				}
				
				_drawCounter++;
			}
			
			return true;
		}
		
		public function addVertexPositionVelocity(position0:Vector3, velocity0:Vector3, position1:Vector3, velocity1:Vector3):void {
			if (numPositionVelocityMode === 0) {
				numPositionVelocityMode++;//直接跳过 
			} else {
				var d:Vector3 = new Vector3();
				Vector3.subtract(position0, posVelModePosition0, d);
				var distance0:Number = Vector3.scalarLength(d);
				
				Vector3.subtract(position1, posVelModePosition1, d);
				var distance1:Number = Vector3.scalarLength(d);
				
				var slerpCount:int = 0;
				if (distance0 < setting.minSegmentDistance && distance1 < setting.minSegmentDistance)
					return;
				slerpCount = 1 + Math.floor(Math.max(distance0, distance1) / setting.minInterpDistance);
				
				if (slerpCount === 1) {
					addGlitter(position0, position1, _currentTime);//push
				} else {
					slerpCount = Math.min(slerpCount, setting.maxSlerpCount);//最大插值,可取消
					
					scLeft.Init(posVelModePosition0, posVelModeVelocity0, position0, velocity0);
					scRight.Init(posVelModePosition1, posVelModeVelocity1, position1, velocity1);
					
					var segment:Number = 1.0 / slerpCount;
					var addSegment:Number = segment;
					
					for (var i:int = 1; i <= slerpCount; i++) {
						var pos0:Vector3 = _tempVector0;
						scLeft.Slerp(addSegment, pos0);
						var pos1:Vector3 = _tempVector1;
						scRight.Slerp(addSegment, pos1);
						var time:Number = _lastTime + (_currentTime - _lastTime) * i / slerpCount;
						addGlitter(pos0, pos1, time);//push
						addSegment += segment;
					}
				}
			}
			
			//记录顶点相关数据
			this._lastTime = _currentTime;
			position0.cloneTo(posVelModePosition0);
			velocity0.cloneTo(posVelModeVelocity0);
			position1.cloneTo(posVelModePosition1);
			velocity1.cloneTo(posVelModeVelocity1);
		}
		
		public function addVertexPosition(position0:Vector3, position1:Vector3):void {
			if (numPositionMode < 2) {
				if (numPositionMode === 0) {
					position0.cloneTo(posModeLastPosition0);
					position1.cloneTo(posModeLastPosition1);
				} else {
					position0.cloneTo(posModePosition0);
					position1.cloneTo(posModePosition1);
				}
				numPositionMode++;
			} else {
				var v0:Vector3 = _tempVector2;
				CalcVelocity(position0, posModeLastPosition0, v0);
				var v1:Vector3 = _tempVector3;
				CalcVelocity(position1, posModeLastPosition1, v1);
				addVertexPositionVelocity(posModePosition0, v0, posModePosition1, v1);
				
				//记录顶点相关数据
				posModePosition0.cloneTo(posModeLastPosition0);
				posModePosition1.cloneTo(posModeLastPosition1);
				position0.cloneTo(posModePosition0);
				position1.cloneTo(posModePosition1);
			}
		}
		
		public function addNewGlitterSegementToVertexBuffer():void//通常只更新（_firstNewParticle - _firstActiveParticle）,但因为动态修改了UV数据所以更新（_firstFreeParticle - _firstActiveParticle）
		{
			var start:int;
			if (_firstActiveElement < _firstFreeElement) {
				// 如果新增加的粒子在Buffer中是连续的区域，只upload一次
				start = _firstActiveElement * 2 * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices,start, start, (_firstFreeElement - _firstActiveElement) * 2 * _floatCountPerVertex);
			} else {
				//如果新增粒子区域超过Buffer末尾则循环到开头，需upload两次
				start = _firstActiveElement * 2 * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices,start, start,  (setting.maxSegments - _firstActiveElement) * 2 * _floatCountPerVertex);
				if (_firstFreeElement > 0) {
					_vertexBuffer.setData(_vertices,0, 0, _firstFreeElement * 2 * _floatCountPerVertex);
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		protected function updateTextureCoordinate():void {
			if (_firstActiveElement < _firstFreeElement) {
				updateTextureCoordinateData(_firstActiveElement, (_firstFreeElement - _firstActiveElement) * 2);
			} else {
				updateTextureCoordinateData(_firstActiveElement, (setting.maxSegments - _firstActiveElement) * 2);
				if (_firstFreeElement > 0)
					updateTextureCoordinateData(0, _firstFreeElement * 2);
			}
		}
		
		protected function updateTextureCoordinateData(start:int, count:int):void {
			for (var i:int = 0; i < count; i += 2) {
				var upVertexOffset:int = (start * 2 + i + 0) * _floatCountPerVertex;
				var downVertexOffset:int = (start * 2 + i + 1) * _floatCountPerVertex;
				_vertices[upVertexOffset + 3] = _vertices[downVertexOffset + 3] = (_vertices[upVertexOffset + 5] - _currentTime) / setting.lifeTime;//更新uv.x
			}
		}
		
		protected function retireActiveGlitters():void {
			var particleDuration:Number = setting.lifeTime;
			
			while (_firstActiveElement != _firstNewElement) {
				var index:int = _firstActiveElement * _floatCountPerVertex * 2 + 5;//5为Time
				var particleAge:Number = _currentTime - _vertices[index];
				
				if (particleAge < particleDuration)
					break;
				
				_vertices[index] = _drawCounter;
				
				_firstActiveElement++;
				
				if (_firstActiveElement >= setting.maxSegments)
					_firstActiveElement = 0;
			}
		}
		
		protected function freeRetiredGlitters():void {
			while (_firstRetiredElement != _firstActiveElement) {
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountPerVertex * 2 + 5];//5为Time,注意Numver到Int类型转换,JS中可忽略
				
				//GPU从不滞后于CPU两帧，出于显卡驱动BUG等安全因素考虑滞后三帧
				if (age < 3)
					break;
				
				_firstRetiredElement++;
				
				if (_firstRetiredElement >= setting.maxSegments)
					_firstRetiredElement = 0;
			}
		}
		
		protected function addGlitter(position0:Vector3, position1:Vector3, time:Number):void//由于循环队列判断算法，当下一个freeParticle等于retiredParticle时不添加例子，意味循环队列中永远有一个空位。（由于此判断算法快速、简单，所以放弃了使循环队列饱和的复杂算法（需判断freeParticle在retiredParticle前、后两种情况并不同处理））
		{
			
			if (_needPatch)//由于绘制基元TRIANGLE_STRIP,不能中断，所以如果超出Buffer上限，从零绘制需要补上次的顶点，通常TRIANGLE则不需要
			{
				_needPatch = false;
				addGlitter(_lastAddPos0, _lastAddPos1, _lastAddTime);
			}
			
			var nextFreeParticle:int = _firstFreeElement + 1;
			
			if (nextFreeParticle >= setting.maxSegments) {
				nextFreeParticle = 0;
				position0.cloneTo(_lastAddPos0);
				position1.cloneTo(_lastAddPos1);
				_lastAddTime = time;
				_needPatch = true;
			}
			
			if (nextFreeParticle === _firstRetiredElement)
				return;
			
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
		
		protected function CalcVelocity(left:Vector3, right:Vector3, out:Vector3):void {
			Vector3.subtract(left, right, out);
			Vector3.scale(out, 0.5, out);
		}
		
		protected function getShader(state:RenderState):Shader {
			var shaderDefs:ShaderDefines3D = state.shaderDefs;
			var preDef:int = shaderDefs._value;
			var nameID:Number = (shaderDefs._value | state.shadingMode) + _sharderNameID * Shader.SHADERNAME2ID;
			_shader = Shader.withCompile(_sharderNameID, state.shadingMode, state.shaderDefs.toNameDic(), nameID, null);
			shaderDefs._value = preDef;
			return _shader;
		}
	}
}