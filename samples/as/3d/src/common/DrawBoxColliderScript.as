package common 
{
	import laya.d3.component.Script;
	import laya.d3.component.physics.BoxCollider;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.OrientedBoundBox;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.webgl.WebGLContext;
	/**
	 * ...
	 * @author ...
	 */
	public class DrawBoxColliderScript extends Script
	{
		private var phasorSpriter3D:PhasorSpriter3D;
		private var _corners:Vector.<Vector3> = new Vector.<Vector3>();
		private var _color:Vector4 = new Vector4(1, 0, 0, 1);

		
		public function DrawBoxColliderScript() 
		{
			super();
			
			_corners[0] = new Vector3();
			_corners[1] = new Vector3();
			_corners[2] = new Vector3();
			_corners[3] = new Vector3();
			_corners[4] = new Vector3();
			_corners[5] = new Vector3();
			_corners[6] = new Vector3();
			_corners[7] = new Vector3();
			phasorSpriter3D = new PhasorSpriter3D();
		}
		
		public function _postRenderUpdate(state:RenderState):void {
			var obb:OrientedBoundBox = (_owner.getComponentByType(BoxCollider) as BoxCollider).boundBox;
			obb.getCorners(_corners);
			
			phasorSpriter3D.begin(WebGLContext.LINES, _owner.camera);
			phasorSpriter3D.line(_corners[0], _color, _corners[1], _color);
			phasorSpriter3D.line(_corners[1], _color, _corners[2], _color);
			phasorSpriter3D.line(_corners[2], _color, _corners[3], _color);
			phasorSpriter3D.line(_corners[3], _color, _corners[0], _color);
			
			phasorSpriter3D.line(_corners[4], _color, _corners[5], _color);
			phasorSpriter3D.line(_corners[5], _color, _corners[6], _color);
			phasorSpriter3D.line(_corners[6], _color, _corners[7], _color);
			phasorSpriter3D.line(_corners[7], _color, _corners[4], _color);
			
			phasorSpriter3D.line(_corners[0], _color, _corners[4], _color);
			phasorSpriter3D.line(_corners[1], _color, _corners[5], _color);
			phasorSpriter3D.line(_corners[2], _color, _corners[6], _color);
			phasorSpriter3D.line(_corners[3], _color, _corners[7], _color);
			
			phasorSpriter3D.end();
		}
		
	}

}