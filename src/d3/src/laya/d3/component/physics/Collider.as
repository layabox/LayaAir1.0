package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Ray;
	import laya.d3.utils.RaycastHit;
	
	/**
	 * <code>Collider</code> 类用于创建碰撞器的父类，抽象类，不允许实例。
	 */
	public class Collider extends Component3D {
		
		public function Collider() {
		}
		
		public function raycast(ray:Ray, maxDistance:Number, hitInfo:RaycastHit):Boolean {
			throw new Error("Must override it.");
		}
	
	}

}