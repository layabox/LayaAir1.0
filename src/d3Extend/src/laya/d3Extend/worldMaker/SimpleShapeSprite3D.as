package laya.d3Extend.worldMaker {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Vector4;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleShapeSprite3D extends RenderableSprite3D {
		public var _simpleShapeMesh:SimpleShapeFilter;
		private var  _editor:SimpleShapeEditor = null;

		public function SimpleShapeSprite3D(props:Object) {
			super(null);
			_render = new SimpleShapeRenderer(this);
			_simpleShapeMesh = new SimpleShapeFilter(props && props.isEditor);

			var renderElement:RenderElement = new RenderElement();
			_render._renderElements.push(renderElement);			
			_render._defineDatas.add(MeshSprite3D.SHADERDEFINE_COLOR);
			
			renderElement.setTransform(_transform);
			renderElement.render = _render;
			
			var mat:BlinnPhongMaterial = _render.sharedMaterial as BlinnPhongMaterial;
			mat || (mat = new BlinnPhongMaterial());
			mat.albedoColor = new Vector4(1.0, 0.0, 0.0, 1.0);
			renderElement.material = mat;
			
			renderElement.setGeometry(_simpleShapeMesh);
			
			for (var k:String in props) {
				this[k] = props[k];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			
		}
		
		public function onSelect():void {
			_editor.onSelect();
		}
		
		public function onUnselect():void {
			_editor.onUnselect();
			_editor = null;
		}
		
		public function getEditor(cam:Camera):SimpleShapeEditor {
			if(!_editor){
				_editor = new SimpleShapeEditor(this, cam);
			}
			return _editor;
		}
	}
}