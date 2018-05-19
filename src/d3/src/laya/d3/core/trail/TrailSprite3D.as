package laya.d3.core.trail {
	import laya.d3.core.ComponentNode;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.trail.module.Color;
	import laya.d3.core.trail.module.Gradient;
	import laya.d3.core.trail.module.GradientAlphaKey;
	import laya.d3.core.trail.module.GradientColorKey;
	import laya.d3.core.trail.module.TrailKeyFrame;
	import laya.d3.shader.ShaderDefines;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrailSprite3D extends RenderableSprite3D {
		
		public static const CURTIME:int = 3;
		public static const LIFETIME:int = 4;
		public static const WIDTHCURVE:int = 5;
		public static const WIDTHCURVEKEYLENGTH:int = 6;
		public static const GRADIENTCOLORKEY:int = 7;
		public static const GRADIENTALPHAKEY:int = 8;
		
		public static var SHADERDEFINE_GRADIENTMODE_BLEND:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(RenderableSprite3D.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_GRADIENTMODE_BLEND = shaderDefines.registerDefine("GRADIENTMODE_BLEND");
		}
		
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
		public function get trailRender():TrailRenderer {
			return _render as TrailRenderer;
		}
		
		public function TrailSprite3D() {
			
			_geometryFilter = new TrailFilter(this);
			_render = new TrailRenderer(this);
			
			_changeRenderObjectsByMaterial(_render as TrailRenderer, 0, TrailMaterial.defaultMaterial);
			
			_render.on(Event.MATERIAL_CHANGED, this, _changeRenderObjectsByMaterial);
			_geometryFilter.on(Event.TRAIL_FILTER_CHANGE, this, _changeRenderObjectsByRenderElement);
		}
		
		public function _changeRenderObjectsByMaterial(sender:TrailRenderer, index:int, material:BaseMaterial):void {
			
			var renderElementsCount:int = (_geometryFilter as TrailFilter).getRenderElementsCount();
			_render._renderElements.length = renderElementsCount;
			for (var i:int = 0; i < renderElementsCount; i++){
				_changeRenderObjectByMaterial(i, material);
			}
		}
		
		private function _changeRenderObjectByMaterial(index:int, material:BaseMaterial):void {
			
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			(material) || (material = TrailMaterial.defaultMaterial);
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._sprite3D = this as TrailSprite3D;
			renderElement.renderObj = (_geometryFilter as TrailFilter).getRenderElement(index) as TrailRenderElement;
			renderElement._render = _render as TrailRenderer;
			renderElement._material = material as TrailMaterial;
		}
		
		public function _changeRenderObjectsByRenderElement(index:int, trailRenderElement:TrailRenderElement):void {
			
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._sprite3D = this as TrailSprite3D;
			renderElement.renderObj = trailRenderElement;
			renderElement._render = _render as TrailRenderer;
			renderElement._material = _render.sharedMaterial;
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_render);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render);
		}
		
		override public function _update(state:RenderState):void {
			super._update(state);
			(_geometryFilter as TrailFilter)._update(state);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, json:Object):void {
			var render:TrailRenderer = _render as TrailRenderer;
			var filter:TrailFilter = _geometryFilter as TrailFilter;
			var i:int, j:int;
			//material
			var materials:Array = customProps.materials;
			if (materials) {
				var sharedMaterials:Vector.<BaseMaterial> = render.sharedMaterials;
				var materialCount:int = materials.length;
				sharedMaterials.length = materialCount;
				for (i = 0; i < materialCount; i++)
					sharedMaterials[i] = Loader.getRes(innerResouMap[materials[i].path]);
				render.sharedMaterials = sharedMaterials;
			}
			var props:Object = json.props;
			filter.time = props.time;
			filter.minVertexDistance = props.minVertexDistance;
			filter.widthMultiplier = props.widthMultiplier;
			filter.textureMode = props.textureMode;
			//widthCurve
			var _widthCurve:Vector.<TrailKeyFrame> = new Vector.<TrailKeyFrame>();
			var widthCurve:Array = customProps.widthCurve;
			for (i = 0, j = widthCurve.length; i < j; i++ ){
				var trailkeyframe:TrailKeyFrame = new TrailKeyFrame();
				trailkeyframe.time = widthCurve[i].time;
				trailkeyframe.inTangent = widthCurve[i].inTangent;
				trailkeyframe.outTangent = widthCurve[i].outTangent;
				trailkeyframe.value = widthCurve[i].value;
				_widthCurve.push(trailkeyframe);
			}
			filter.widthCurve = _widthCurve;
			//colorGradient
			var colorGradientNode:Object = customProps.colorGradient;
			var _colorGradient:Gradient = new Gradient();
			_colorGradient.mode = colorGradientNode.mode;
			var colorKeys:Vector.<GradientColorKey> = new Vector.<GradientColorKey>();
			var colorKey:GradientColorKey;
			var _colorKeys:Array = colorGradientNode.colorKeys;
			var _colorKey:Object;
			for (i = 0, j = _colorKeys.length; i < j; i++ ){
				_colorKey = _colorKeys[i];
				colorKey = new GradientColorKey(new Color(_colorKey.value[0], _colorKey.value[1], _colorKey.value[2], 1.0), _colorKey.time);
				colorKeys.push(colorKey);
			}
			var alphaKeys:Vector.<GradientAlphaKey> = new Vector.<GradientAlphaKey>();
			var alphaKey:GradientAlphaKey;
			var _alphaKeys:Array = colorGradientNode.alphaKeys;
			var _alphaKey:Object;
			for (i = 0, j = _alphaKeys.length; i < j; i++ ){
				_alphaKey = _alphaKeys[i];
				alphaKey = new GradientAlphaKey(_alphaKey.value, _alphaKey.time);
				alphaKeys.push(alphaKey);
			}
			_colorGradient.setKeys(colorKeys, alphaKeys);
			filter.colorGradient = _colorGradient;
		}
		
		public function reset():void{
			trailFilter.reset();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			
			super.cloneTo(destObject);
			var i:int, j:int;
			var _trailSprite3D:TrailSprite3D = destObject as TrailSprite3D;
			
			var _trailFilter:TrailFilter = _trailSprite3D.trailFilter;
			
			_trailFilter.time = trailFilter.time;
			_trailFilter.minVertexDistance = trailFilter.minVertexDistance;
			_trailFilter.widthMultiplier = trailFilter.widthMultiplier;
			
			var widthCurve:Vector.<TrailKeyFrame> = trailFilter.widthCurve;
			var _widthCurve:Vector.<TrailKeyFrame> = new Vector.<TrailKeyFrame>();
			for (i = 0, j = widthCurve.length; i < j; i++){
				var _keyFrame:TrailKeyFrame = new TrailKeyFrame();
				widthCurve[i].cloneTo(_keyFrame);
				_widthCurve.push(_keyFrame);
			}
			_trailFilter.widthCurve = _widthCurve;
			
			var _colorGradient:Gradient = new Gradient();
			trailFilter.colorGradient.cloneTo(_colorGradient);
			_trailFilter.colorGradient = _colorGradient;
			
			_trailFilter.textureMode = trailFilter.textureMode;
			
			var _trailRender:TrailRenderer = _trailSprite3D.trailRender;
			_trailRender.sharedMaterial = trailRender.sharedMaterial;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			(_geometryFilter as TrailFilter)._destroy();
			_geometryFilter = null;
		}
	}
}