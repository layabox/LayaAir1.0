package laya.d3.utils {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3.physics.PhysicsComponent;
	
	/**
	 * <code>Physics</code> 类用于简单物理检测。
	 */
	public class Physics3DUtils {
		public static const COLLISIONFILTERGROUP_DEFAULTFILTER:int = 0x1;
		
		public static const COLLISIONFILTERGROUP_STATICFILTER:int = 0x2;
		
		public static const COLLISIONFILTERGROUP_KINEMATICFILTER:int = 0x4;
		
		public static const COLLISIONFILTERGROUP_DEBRISFILTER:int = 0x8;
		
		public static const COLLISIONFILTERGROUP_SENSORTRIGGER:int = 0x10;
		
		public static const COLLISIONFILTERGROUP_CHARACTERFILTER:int = 0x20;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER1:int = 0x40;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER2:int = 0x80;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER3:int = 0x100;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER4:int = 0x200;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER5:int = 0x400;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER6:int = 0x800;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER7:int = 0x1000;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER8:int = 0x2000;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER9:int = 0x4000;
		
		public static const COLLISIONFILTERGROUP_CUSTOMFILTER10:int = 0x8000;
		
		public static const COLLISIONFILTERGROUP_ALLFILTER:int = -1;
		
		/**重力值。*/
		public static var gravity:Vector3 = new Vector3(0, -9.81, 0);
		
		/**
		 * 创建一个 <code>Physics</code> 实例。
		 */
		public function Physics3DUtils() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * 是否忽略两个碰撞器的碰撞检测。
		 * @param	collider1 碰撞器一。
		 * @param	collider2 碰撞器二。
		 * @param	ignore 是否忽略。
		 */
		public static function setColliderCollision(collider1:PhysicsComponent, collider2:PhysicsComponent, collsion:Boolean):void {
		}
		
		/**
		 * 获取是否忽略两个碰撞器的碰撞检测。
		 * @param	collider1 碰撞器一。
		 * @param	collider2 碰撞器二。
		 * @return	是否忽略。
		 */
		public static function getIColliderCollision(collider1:PhysicsComponent, collider2:PhysicsComponent):Boolean {
			//return collider1._ignoreCollisonMap[collider2.id] ? true : false;
			return false;
		}
	
	}
}
