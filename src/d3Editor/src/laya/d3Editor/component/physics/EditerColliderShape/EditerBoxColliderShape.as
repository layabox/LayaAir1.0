package laya.d3Editor.component.physics.EditerColliderShape {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3Editor.shape.BoxShapeLine3D;
	
	/**
	 * 盒子
	 * @author wzy
	 */
	public class EditerBoxColliderShape extends Sprite3D {
		
		private var _center:Vector3;
		
		private var _size:Vector3;
		
		private var _boxShapeLine:BoxShapeLine3D;
		
		public function get center():Vector3 {
			return _center;
		}
		
		public function set center(value:Vector3):void {
			_center = value;
			_center.cloneTo(_boxShapeLine.transform.localPosition);
			_boxShapeLine.transform.localPosition = _boxShapeLine.transform.localPosition;
		}
		
		public function get size():Vector3 {
			return _size;
		}
		
		public function set size(value:Vector3):void {
			_size = value;
			_boxShapeLine.long = value.x;
			_boxShapeLine.height = value.y;
			_boxShapeLine.width = value.z;
		}
		
		override public function _parse(data:Object):void {
			if (data.center){
				center.fromArray(data.center);
				center = center;
			}
			if (data.size){
				size.fromArray(data.size);
				size = size;
			}
		}
		
		public function EditerBoxColliderShape() {
			_center = new Vector3(0, 0, 0);
			_size = new Vector3(1, 1, 1);
			_boxShapeLine = addChild(new BoxShapeLine3D(_size.x, _size.y, _size.z)) as BoxShapeLine3D;
		}
	
	}

}