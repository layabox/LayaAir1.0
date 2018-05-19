package laya.d3.core.trail {
	
	import laya.d3.core.GeometryFilter;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.trail.module.Gradient;
	import laya.d3.core.trail.module.GradientMode;
	import laya.d3.core.trail.module.TextureMode;
	import laya.d3.core.trail.module.TrailKeyFrame;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines;
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrailFilter extends GeometryFilter {
		
		public var _owner:TrailSprite3D;
		private var _trailRenderElements:Vector.<TrailRenderElement>;
		
		private var _minVertexDistance:Number;
		private var _widthMultiplier:Number;
		private var _time:Number;
		private var _widthCurve:Vector.<TrailKeyFrame>;
		private var _colorGradient:Gradient;
		private var _textureMode:int;
		
		public var _curtime:Number = 0;
		public var _curSubTrailFinishPosition:Vector3 = new Vector3();
		public var _curSubTrailFinishDirection:Vector3 = new Vector3();
		public var _curSubTrailFinishCurTime:Number = 0;
		public var _curSubTrailFinished:Boolean = false;
		public var _hasLifeSubTrail:Boolean = false;
		
		public var _trailTotalLength:Number = 0;
		public var _trailSupplementLength:Number = 0;
		public var _trailDeadLength:Number = 0;
		
		public var _isStart:Boolean = false;
		private var _trailRenderElementIndex:int;
		
		/**
		 * 获取淡出时间。
		 * @return  淡出时间。
		 */
		public function get time():Number {
			return _time;
		}
		
		/**
		 * 设置淡出时间。
		 * @param value 淡出时间。
		 */
		public function set time(value:Number):void {
			_time = value;
			_owner._render._setShaderValueNumber(TrailSprite3D.LIFETIME, value);
		}
		
		/**
		 * 获取新旧顶点之间最小距离。
		 * @return  新旧顶点之间最小距离。
		 */
		public function get minVertexDistance():Number {
			return _minVertexDistance;
		}
		
		/**
		 * 设置新旧顶点之间最小距离。
		 * @param value 新旧顶点之间最小距离。
		 */
		public function set minVertexDistance(value:Number):void {
			_minVertexDistance = value;
		}
		
		/**
		 * 获取宽度倍数。
		 * @return  宽度倍数。
		 */
		public function get widthMultiplier():Number {
			return _widthMultiplier;
		}
		
		/**
		 * 设置宽度倍数。
		 * @param value 宽度倍数。
		 */
		public function set widthMultiplier(value:Number):void {
			_widthMultiplier = value;
		}
		
		/**
		 * 获取宽度曲线。
		 * @return  宽度曲线。
		 */
		public function get widthCurve():Vector.<TrailKeyFrame> {
			return _widthCurve;
		}
		
		/**
		 * 设置宽度曲线。
		 * @param value 宽度曲线。
		 */
		public function set widthCurve(value:Vector.<TrailKeyFrame>):void {
			_widthCurve = value;
			var widthCurveFloatArray:Float32Array = new Float32Array(value.length * 4);
			var i:int, j:int, index:int = 0;
			for (i = 0, j = value.length; i < j; i++ ){
				widthCurveFloatArray[index++] = value[i].time;
				widthCurveFloatArray[index++] = value[i].inTangent;
				widthCurveFloatArray[index++] = value[i].outTangent;
				widthCurveFloatArray[index++] = value[i].value;
			}
			_owner._render._setShaderValueBuffer(TrailSprite3D.WIDTHCURVE, widthCurveFloatArray);
			_owner._render._setShaderValueInt(TrailSprite3D.WIDTHCURVEKEYLENGTH, value.length);
		}
		
		/**
		 * 获取颜色梯度。
		 * @return  颜色梯度。
		 */
		public function get colorGradient():Gradient {
			return _colorGradient;
		}
		
		/**
		 * 设置颜色梯度。
		 * @param value 颜色梯度。
		 */
		public function set colorGradient(value:Gradient):void {
			
			_colorGradient = value;
			_owner._render._setShaderValueBuffer(TrailSprite3D.GRADIENTCOLORKEY, value._colorKeyData);
			_owner._render._setShaderValueBuffer(TrailSprite3D.GRADIENTALPHAKEY, value._alphaKeyData);
			if (value.mode == GradientMode.Blend){
				_owner._render._addShaderDefine(TrailSprite3D.SHADERDEFINE_GRADIENTMODE_BLEND);
			}
			else{
				_owner._render._removeShaderDefine(TrailSprite3D.SHADERDEFINE_GRADIENTMODE_BLEND);
			}
		}
		
		/**
		 * 获取纹理模式。
		 * @return  纹理模式。
		 */
		public function get textureMode():int {
			return _textureMode;
		}
		
		/**
		 * 设置纹理模式。
		 * @param value 纹理模式。
		 */
		public function set textureMode(value:int):void {
			_textureMode = value;
		}
		
		public function TrailFilter(owner:TrailSprite3D) {
			
			_owner = owner;
			
			_trailRenderElements = new Vector.<TrailRenderElement>();
			
			addRenderElement();
		}
		
		public function getRenderElementsCount():int {
			return _trailRenderElements.length;
		}
		
		public function addRenderElement():int {
			
			for (var i:int = 0; i < _trailRenderElements.length; i++ ){
				if (_trailRenderElements[i]._isDead == true){
					_trailRenderElements[i].reActivate();
					return i;
				}
			}
			
			var _trailRenderElement:TrailRenderElement = new TrailRenderElement(this);
			_trailRenderElements.push(_trailRenderElement);
			return _trailRenderElements.length - 1;
		}
		
		public function getRenderElement(index:int):IRenderable {
			return _trailRenderElements[index];
		}
		
		public function _update(state:RenderState):void {
			
			_curtime += state.elapsedTime / 1000;
			_owner._render._setShaderValueNumber(TrailSprite3D.CURTIME, _curtime);
			
			if (_curSubTrailFinished) {
				_curSubTrailFinished = false;
				_trailRenderElementIndex = addRenderElement();
				event(Event.TRAIL_FILTER_CHANGE, [_trailRenderElementIndex, _trailRenderElements[_trailRenderElementIndex]]);
			}
		}
		
		public function reset():void{
			
			for (var i:int = 0; i < _trailRenderElements.length; i++ ){
				_trailRenderElements[i].reActivate();
			}
			_isStart = false;
			_hasLifeSubTrail = false;
			_curSubTrailFinished = false;
			_curSubTrailFinishCurTime = 0;
			_trailTotalLength = 0;
			_trailSupplementLength = 0;
			_trailDeadLength = 0;
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			for (var i:int = 0; i < _trailRenderElements.length; i++ ){
				_trailRenderElements[i]._destroy();
			}
			_trailRenderElements = null;
			_widthCurve = null;
			_colorGradient = null;
			_curSubTrailFinishPosition = null;
			_curSubTrailFinishDirection = null;
		}
	}
}