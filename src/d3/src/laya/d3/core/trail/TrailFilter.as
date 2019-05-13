package laya.d3.core.trail {
	
	import laya.d3.core.Camera;
	import laya.d3.core.FloatKeyframe;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.Gradient;
	import laya.d3.core.GradientMode;
	import laya.d3.core.TextureMode;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>TrailFilter</code> 类用于创建拖尾过滤器。
	 */
	public class TrailFilter {
		/** 轨迹准线_面向摄像机。*/
		public static const ALIGNMENT_VIEW:int = 0;
		/** 轨迹准线_面向运动方向。*/
		public static const ALIGNMENT_TRANSFORM_Z:int = 1;
		
		/**@private */
		private var _minVertexDistance:Number;
		/**@private */
		private var _widthMultiplier:Number;
		/**@private */
		private var _time:Number;
		/**@private */
		private var _widthCurve:Vector.<FloatKeyframe>;
		/**@private */
		private var _colorGradient:Gradient;
		/**@private */
		private var _textureMode:int;
		/**@private */
		private var _trialGeometry:GeometryElement;
		/**@private 拖尾总长度*/
		public var _totalLength:Number = 0;
		
		public var _owner:TrailSprite3D;
		public var _lastPosition:Vector3 = new Vector3();
		
		public var _curtime:Number = 0;
		
		private var _trailRenderElementIndex:int;
		
		/**轨迹准线。*/
		public var alignment:int = ALIGNMENT_VIEW;
		
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
			_owner._render._shaderValues.setNumber(TrailSprite3D.LIFETIME, value);
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
		public function get widthCurve():Vector.<FloatKeyframe> {
			return _widthCurve;
		}
		
		/**
		 * 设置宽度曲线。
		 * @param value 宽度曲线。
		 */
		public function set widthCurve(value:Vector.<FloatKeyframe>):void {
			_widthCurve = value;
			var widthCurveFloatArray:Float32Array = new Float32Array(value.length * 4);
			var i:int, j:int, index:int = 0;
			for (i = 0, j = value.length; i < j; i++) {
				widthCurveFloatArray[index++] = value[i].time;
				widthCurveFloatArray[index++] = value[i].inTangent;
				widthCurveFloatArray[index++] = value[i].outTangent;
				widthCurveFloatArray[index++] = value[i].value;
			}
			_owner._render._shaderValues.setBuffer(TrailSprite3D.WIDTHCURVE, widthCurveFloatArray);
			_owner._render._shaderValues.setInt(TrailSprite3D.WIDTHCURVEKEYLENGTH, value.length);
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
			_owner._render._shaderValues.setBuffer(TrailSprite3D.GRADIENTCOLORKEY, value._rgbElements);
			_owner._render._shaderValues.setBuffer(TrailSprite3D.GRADIENTALPHAKEY, value._alphaElements);
			if (value.mode == GradientMode.Blend) {
				_owner._render._defineDatas.add(TrailSprite3D.SHADERDEFINE_GRADIENTMODE_BLEND);
			} else {
				_owner._render._defineDatas.remove(TrailSprite3D.SHADERDEFINE_GRADIENTMODE_BLEND);
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
			_initDefaultData();
			addRenderElement();
		}
		
		/**
		 * @private
		 */
		public function addRenderElement():void {
			var render:TrailRenderer = _owner._render as TrailRenderer;
			var elements:Vector.<RenderElement> = render._renderElements;
			var material:TrailMaterial = render.sharedMaterials[0] as TrailMaterial;
			(material) || (material = TrailMaterial.defaultMaterial);
			var element:RenderElement = new RenderElement();
			element.setTransform(_owner._transform);
			element.render = render;
			element.material = material;
			_trialGeometry = new TrailGeometry(this);
			element.setGeometry(_trialGeometry);
			elements.push(element);
		}
		
		/**
		 * @private
		 */
		public function _update(state:RenderContext3D):void {
			var render:BaseRender = _owner._render;
			_curtime += (state.scene as Scene3D).timer._delta / 1000;
			render._shaderValues.setNumber(TrailSprite3D.CURTIME, _curtime);
			
			var curPos:Vector3 = _owner.transform.position;
			var element:TrailGeometry = render._renderElements[0]._geometry as TrailGeometry;
			element._updateDisappear();
			element._updateTrail(state.camera as Camera, _lastPosition, curPos);
			element._updateVertexBufferUV();
			curPos.cloneTo(_lastPosition);
		}
		
		/**
		 * @private
		 */
		public function _initDefaultData():void {
			time = 5.0;
			minVertexDistance = 0.1;
			widthMultiplier = 1;
			textureMode = TextureMode.Stretch;
			
			var widthKeyFrames:Vector.<FloatKeyframe> = new Vector.<FloatKeyframe>();
			var widthKeyFrame1:FloatKeyframe = new FloatKeyframe();
			widthKeyFrame1.time = 0;
			widthKeyFrame1.inTangent = 0;
			widthKeyFrame1.outTangent = 0;
			widthKeyFrame1.value = 1;
			widthKeyFrames.push(widthKeyFrame1);
			var widthKeyFrame2:FloatKeyframe = new FloatKeyframe();
			widthKeyFrame2.time = 1;
			widthKeyFrame2.inTangent = 0;
			widthKeyFrame2.outTangent = 0;
			widthKeyFrame2.value = 1;
			widthKeyFrames.push(widthKeyFrame2);
			widthCurve = widthKeyFrames;
			
			var gradient:Gradient = new Gradient(2, 2);
			gradient.mode = GradientMode.Blend;
			gradient.addColorRGB(0, Color.WHITE);
			gradient.addColorRGB(1, Color.WHITE);
			gradient.addColorAlpha(0, 1);
			gradient.addColorAlpha(1, 1);
			colorGradient = gradient;
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			_trialGeometry.destroy();
			_trialGeometry = null;
			_widthCurve = null;
			_colorGradient = null;
		}
	}
}