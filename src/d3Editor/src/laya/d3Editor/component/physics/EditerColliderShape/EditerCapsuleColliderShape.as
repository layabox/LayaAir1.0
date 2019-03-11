package laya.d3Editor.component.physics.EditerColliderShape {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3Editor.shape.CapsuleShapeLine3D;
	/**
	 * 胶囊
	 * @author wzy
	 */
	public class EditerCapsuleColliderShape extends Sprite3D{
		
		private var _center:Vector3;
		
		private var _radius:Number;
		
		private var _height:Number;
		
		private var _capsuleShapeLine:CapsuleShapeLine3D;
		
		public function get center():Vector3 {
			return _center;
		}
		
		public function set center(value:Vector3):void {
			_center = value;
			_center.cloneTo(_capsuleShapeLine.transform.localPosition);
			_capsuleShapeLine.transform.localPosition = _capsuleShapeLine.transform.localPosition;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			_capsuleShapeLine.radius = value;
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function set height(value:Number):void {
			_height = value;
			_capsuleShapeLine.height = value;
		}
		
		override public function _parse(data:Object):void {
			if (data.center){
				center.fromArray(data.center);
				center = center;
			}
			if (data.radius){
				radius = data.radius;
			}
			if (data.height){
				height = data.height;
			}
		}
		
		public function EditerCapsuleColliderShape() {
			_center = new Vector3(0, 0, 0);
			_radius = 0.5;
			_height = 2.0;
			_capsuleShapeLine = addChild(new CapsuleShapeLine3D(_radius,_height)) as CapsuleShapeLine3D;
		}
		
		
	}

}