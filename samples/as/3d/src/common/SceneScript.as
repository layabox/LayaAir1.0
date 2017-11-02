package common 
{
	import laya.d3.component.Script;
	import laya.d3.core.Camera;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.events.Event;
	import laya.webgl.WebGLContext;
	
	public class SceneScript extends Script 
	{
		private var originPosition:Vector3 = new Vector3(0, -1, 1);
		private var phasorSpriter3D:PhasorSpriter3D;
		private var _color:Vector4 = new Vector4(1, 0, 0, 1);
		private var point:Vector2 = new Vector2();
		private var camera:Camera;
		private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
		
		public function SceneScript() {
		
		}
		
		override public function _start(state:RenderState):void {
			
			super._start(state);
			
			phasorSpriter3D = new PhasorSpriter3D();
			camera = _owner.getChildByName("camera");
			
		}
		
		
		override public function _postRenderUpdate(state:RenderState):void {
			super._update(state);
			
			point.elements[0] = Laya.stage.mouseX;
            point.elements[1] = Laya.stage.mouseY;
            camera.viewportPointToRay(point, ray);
			
			phasorSpriter3D.begin(WebGLContext.LINES, camera);
            
            //绘出射线
            phasorSpriter3D.line(ray.origin, _color, originPosition, _color);
			
			phasorSpriter3D.end();
		}
		
	}
}