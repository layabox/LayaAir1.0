package laya.d3.core.trail {
	import laya.d3.core.FloatKeyframe;
	import laya.d3.core.Gradient;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.math.Color;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	import laya.net.Loader;
	
	/**
	 * <code>TrailSprite3D</code> 类用于创建拖尾渲染精灵。
	 */
	public class TrailSprite3D extends RenderableSprite3D {
		
		public static var CURTIME:int=Shader3D.propertyNameToID("u_CurTime");
		public static var LIFETIME:int=Shader3D.propertyNameToID("u_LifeTime");
		public static var WIDTHCURVE:int=Shader3D.propertyNameToID("u_WidthCurve");
		public static var WIDTHCURVEKEYLENGTH:int=Shader3D.propertyNameToID("u_WidthCurveKeyLength");
		public static var GRADIENTCOLORKEY:int=Shader3D.propertyNameToID("u_GradientColorkey");
		public static var GRADIENTALPHAKEY:int=Shader3D.propertyNameToID("u_GradientAlphakey");
		
		public static var SHADERDEFINE_GRADIENTMODE_BLEND:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(RenderableSprite3D.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_GRADIENTMODE_BLEND = shaderDefines.registerDefine("GRADIENTMODE_BLEND");
		}
		
		/** @private */
		private var _geometryFilter:TrailFilter;
		
		/**
		 * 获取Trail过滤器。
		 * @return  Trail过滤器。
		 */
		public function get trailFilter():TrailFilter {
			return _geometryFilter as TrailFilter;
		}
		
		/**
		 * 获取Trail渲染器。
		 * @return  Trail渲染器。
		 */
		public function get trailRenderer():TrailRenderer {
			return _render as TrailRenderer;
		}
		
		public function TrailSprite3D() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(name);
			_render = new TrailRenderer(this);
			_geometryFilter = new TrailFilter(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			super._parse(data);
			var render:TrailRenderer = _render as TrailRenderer;
			var filter:TrailFilter = _geometryFilter as TrailFilter;
			var i:int, j:int;
			var materials:Array = data.materials;
			if (materials) {
				var sharedMaterials:Vector.<BaseMaterial> = render.sharedMaterials;
				var materialCount:int = materials.length;
				sharedMaterials.length = materialCount;
				for (i = 0; i < materialCount; i++)
					sharedMaterials[i] = Loader.getRes(materials[i].path);
				render.sharedMaterials = sharedMaterials;
			}
			filter.time = data.time;
			filter.minVertexDistance = data.minVertexDistance;
			filter.widthMultiplier = data.widthMultiplier;
			filter.textureMode = data.textureMode;
			(data.alignment != null) && (filter.alignment = data.alignment);
			//widthCurve
			var widthCurve:Vector.<FloatKeyframe> = new Vector.<FloatKeyframe>();
			var widthCurveData:Array = data.widthCurve;
			for (i = 0, j = widthCurveData.length; i < j; i++) {
				var trailkeyframe:FloatKeyframe = new FloatKeyframe();
				trailkeyframe.time = widthCurveData[i].time;
				trailkeyframe.inTangent = widthCurveData[i].inTangent;
				trailkeyframe.outTangent = widthCurveData[i].outTangent;
				trailkeyframe.value = widthCurveData[i].value;
				widthCurve.push(trailkeyframe);
			}
			filter.widthCurve = widthCurve;
			//colorGradient
			var colorGradientData:Object = data.colorGradient;
			var colorKeys:Array = colorGradientData.colorKeys;
			var alphaKeys:Array = colorGradientData.alphaKeys;
			var colorGradient:Gradient = new Gradient(colorKeys.length, alphaKeys.length);
			colorGradient.mode = colorGradientData.mode;
			
			for (i = 0, j = colorKeys.length; i < j; i++) {
				var colorKey:Object = colorKeys[i];
				colorGradient.addColorRGB(colorKey.time, new Color(colorKey.value[0], colorKey.value[1], colorKey.value[2], 1.0));
			}
			
			for (i = 0, j = alphaKeys.length; i < j; i++) {
				var alphaKey:Object = alphaKeys[i];
				colorGradient.addColorAlpha(alphaKey.time, alphaKey.value);
			}
			filter.colorGradient = colorGradient;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			super._onActive();
			_transform.position.cloneTo(_geometryFilter._lastPosition);//激活时需要重置上次位置
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var i:int, j:int;
			var destTrailSprite3D:TrailSprite3D = destObject as TrailSprite3D;
			
			var destTrailFilter:TrailFilter = destTrailSprite3D.trailFilter;
			destTrailFilter.time = trailFilter.time;
			destTrailFilter.minVertexDistance = trailFilter.minVertexDistance;
			destTrailFilter.widthMultiplier = trailFilter.widthMultiplier;
			destTrailFilter.textureMode = trailFilter.textureMode;
			
			var widthCurveData:Vector.<FloatKeyframe> = trailFilter.widthCurve;
			var widthCurve:Vector.<FloatKeyframe> = new Vector.<FloatKeyframe>();
			for (i = 0, j = widthCurveData.length; i < j; i++) {
				var keyFrame:FloatKeyframe = new FloatKeyframe();
				widthCurveData[i].cloneTo(keyFrame);
				widthCurve.push(keyFrame);
			}
			destTrailFilter.widthCurve = widthCurve;
			
			var destColorGradient:Gradient = new Gradient(trailFilter.colorGradient.maxColorRGBKeysCount, trailFilter.colorGradient.maxColorAlphaKeysCount);
			trailFilter.colorGradient.cloneTo(destColorGradient);
			destTrailFilter.colorGradient = destColorGradient;
			
			var destTrailRender:TrailRenderer = destTrailSprite3D.trailRenderer;
			destTrailRender.sharedMaterial = trailRenderer.sharedMaterial;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			(_geometryFilter as TrailFilter).destroy();
			_geometryFilter = null;
		}
	}
}