package laya.d3.extension.lineRender {
	import laya.d3.core.Camera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines;
	import laya.resource.Context;
	
	/**
	 * ...
	 * @author
	 */
	public class LineSprite3D extends RenderableSprite3D {
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(RenderableSprite3D.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
		}
		
		/** @private */
		private var _geometryFilter:LineFilter;
		
		/**
		 * 获取line过滤器。
		 * @return  line过滤器。
		 */
		public function get lineFilter():LineFilter {
			return _geometryFilter as LineFilter;
		}
		
		/**
		 * 获取line渲染器。
		 * @return  line渲染器。
		 */
		public function get lineRender():LineRenderer {
			return _render as LineRenderer;
		}
		
		public function LineSprite3D(camera:Camera,name:String=null) {
			_geometryFilter = new LineFilter();
			(_geometryFilter as LineFilter)._camera = camera;
			_render = new LineRenderer(this);
			
			_changeRenderObjects(_render as LineRenderer, 0, LineMaterial.defaultMaterial);
			super(name);
		}
		
		public function addPosition(position:Vector3):void {
			(_geometryFilter as LineFilter).addDataForVertexBuffer(position);
		}
		
		/**
		 * @inheritDoc
		 */
		public function _changeRenderObjects(sender:LineRenderer, index:int, material:BaseMaterial):void {
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			(material) || (material = LineMaterial.defaultMaterial);
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement.setTransform(_transform);
			renderElement.setGeometry(_geometryFilter);
			renderElement.render = _render;
			renderElement.material = material;
		}
		
		public function _update(state:Context):void {//TODO:
			//super._update(state);
			//(_geometryFilter as lineFilter)._update(state);
		}
	
	}

}