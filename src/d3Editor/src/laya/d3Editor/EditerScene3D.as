package laya.d3Editor {
	import laya.d3.core.scene.Scene3D;
	import laya.d3Editor.TransformSprite3D;
	import laya.d3.math.Vector4;
	
	/**
	 * ...
	 * @author
	 */
	public class EditerScene3D {
		
		private var _scene:Scene3D;
		private var _transformSprite3D:TransformSprite3D;
		
		public function get scene():Scene3D {
			return _scene;
		}
		
		public function get transformSprite3D():TransformSprite3D {
			return _transformSprite3D;
		}
		
		public function EditerScene3D(scene:Scene3D) {
			super();
			_scene = scene;
			_transformSprite3D = new TransformSprite3D();
			_scene.addChild(transformSprite3D);
		}
	
	}
}