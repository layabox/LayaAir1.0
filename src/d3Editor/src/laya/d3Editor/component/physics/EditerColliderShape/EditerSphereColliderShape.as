package laya.d3Editor.component.physics.EditerColliderShape {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3Editor.shape.SphereShapeLine3D;
	/**
	 * 球
	 * @author wzy
	 */
	public class EditerSphereColliderShape extends Sprite3D{
		
		private var _center:Vector3;
		
		private var _radius:Number;
		
		private var _sphereShapeLine:SphereShapeLine3D;
		
		public function get center():Vector3 {
			return _center;
		}
		
		public function set center(value:Vector3):void {
			_center = value;
			_center.cloneTo(_sphereShapeLine.transform.localPosition);
			_sphereShapeLine.transform.localPosition = _sphereShapeLine.transform.localPosition;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			_sphereShapeLine.radius = value;
		}
		
		override public function _parse(data:Object):void 
		{
			if (data.center){
				center.fromArray(data.center);
				center = center;
			}
			if (data.radius){
				radius = data.radius;
			}
		}
		
		public function EditerSphereColliderShape() {
			_center = new Vector3(0, 0, 0);
			_radius = 0.5;
			_sphereShapeLine = addChild(new SphereShapeLine3D(_radius)) as SphereShapeLine3D;
		}
		
		
	}

}