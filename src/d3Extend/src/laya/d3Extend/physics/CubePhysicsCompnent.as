package laya.d3Extend.physics {
		
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	/**
	 * ...
	 * @author ...
	 */
	public class CubePhysicsCompnent {
		
		/** @private 长方体类型碰撞器*/
		public static var TYPE_BOX:int = 0;
		/** @private 球类型碰撞器*/
		public static var TYPE_SPHERE:int = 1;
		/** @private 盒子类型*/
		public static var TYPE_CUBESPRIT3D:int = 2;
		
		
		/** @private 被挂脚本的精灵*/
		protected var _sprite3D:Sprite3D;
	
		/** @private 是否是主动检测物体*/
		private var isRigebody:Boolean = false;
		/** @private 类型包围盒*/
		public var type:int;
		
		/** @private 物体模型的模型矩阵*/
		protected var _localmatrix4x4:Matrix4x4;
		/** @private 物体模型的世界矩阵*/
		protected var _worldMatrix4x4:Matrix4x4;
		


		/**
		 * 构造函数 准备好数据
		 */
		public function CubePhysicsCompnent() 
		{
			
		}
	
		/**
		 * 静态函数
		 * @param 两个需要检测的碰撞物体
		 */
		public function isCollision(other:CubePhysicsCompnent):Boolean
		{
			
		}
		
		
	}
	

}