package laya.d3.physics {
	import laya.components.Component;
	import laya.d3.math.Vector3;
	import laya.d3.physics.shape.ColliderShape;
	import laya.d3.utils.Physics3DUtils;
	import laya.d3.utils.Utils3D;
	
	/**
	 * <code>CharacterController</code> 类用于创建角色控制器。
	 */
	public class CharacterController extends PhysicsComponent {
		/** @private */
		private static var _nativeTempVector30:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		
		/* UP轴_X轴。*/
		public static const UPAXIS_X:int = 0;
		/* UP轴_Y轴。*/
		public static const UPAXIS_Y:int = 1;
		/* UP轴_Z轴。*/
		public static const UPAXIS_Z:int = 2;
		
		/** @private */
		private var _stepHeight:Number;
		/** @private */
		private var _upAxis:Vector3 = new Vector3(0, 1, 0);
		/**@private */
		private var _maxSlope:Number = 45.0;
		/**@private */
		private var _jumpSpeed:Number = 10.0;
		/**@private */
		private var _fallSpeed:Number = 55.0;
		/** @private */
		private var _gravity:Vector3 = new Vector3(0, -9.8 * 3, 0);
		
		/**@private */
		public var _nativeKinematicCharacter:*;
		
		/**
		 * 获取角色降落速度。
		 * @return 角色降落速度。
		 */
		public function get fallSpeed():Number {
			return _fallSpeed;
		}
		
		/**
		 * 设置角色降落速度。
		 * @param value 角色降落速度。
		 */
		public function set fallSpeed(value:Number):void {
			_fallSpeed = value;
			_nativeKinematicCharacter.setFallSpeed(value);
		}
		
		/**
		 * 获取角色跳跃速度。
		 * @return 角色跳跃速度。
		 */
		public function get jumpSpeed():Number {
			return _jumpSpeed;
		}
		
		/**
		 * 设置角色跳跃速度。
		 * @param value 角色跳跃速度。
		 */
		public function set jumpSpeed(value:Number):void {
			_jumpSpeed = value;
			_nativeKinematicCharacter.setJumpSpeed(value);
		}
		
		/**
		 * 获取重力。
		 * @return 重力。
		 */
		public function get gravity():Vector3 {
			return _gravity;
		}
		
		/**
		 * 设置重力。
		 * @param value 重力。
		 */
		public function set gravity(value:Vector3):void {
			_gravity = value;
			var nativeGravity:* = _nativeTempVector30;
			nativeGravity.setValue(-value.x, value.y, value.z);
			_nativeKinematicCharacter.setGravity(nativeGravity);
		}
		
		/**
		 * 获取最大坡度。
		 * @return 最大坡度。
		 */
		public function get maxSlope():Number {
			return _maxSlope;
		}
		
		/**
		 * 设置最大坡度。
		 * @param value 最大坡度。
		 */
		public function set maxSlope(value:Number):void {
			_maxSlope = value;
			_nativeKinematicCharacter.setMaxSlope((value / 180) * Math.PI);
		}
		
		/**
		 * 获取角色是否在地表。
		 */
		public function get isGrounded():Boolean {
			return _nativeKinematicCharacter.onGround();
		}
		
		/**
		 * 获取角色行走的脚步高度，表示可跨越的最大高度。
		 * @return 脚步高度。
		 */
		public function get stepHeight():Number {
			return _stepHeight;
		}
		
		/**
		 * 设置角色行走的脚步高度，表示可跨越的最大高度。
		 * @param value 脚步高度。
		 */
		public function set stepHeight(value:Number):void {
			_stepHeight = value;
			_constructCharacter();
		}
		
		/**
		 * 获取角色的Up轴。
		 * @return 角色的Up轴。
		 */
		public function get upAxis():Vector3 {
			return _upAxis;
		}
		
		/**
		 * 设置角色的Up轴。
		 * @return 角色的Up轴。
		 */
		public function set upAxis(value:Vector3):void {
			_upAxis = value;
			_constructCharacter();
		}
		
		/**
		 * 创建一个 <code>CharacterController</code> 实例。
		 * @param stepheight 角色脚步高度。
		 * @param upAxis 角色Up轴
		 * @param collisionGroup 所属碰撞组。
		 * @param canCollideWith 可产生碰撞的碰撞组。
		 */
		public function CharacterController(stepheight:Number = 0.1, upAxis:Vector3 = null, collisionGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_DEFAULTFILTER, canCollideWith:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_stepHeight = stepheight;
			(upAxis) && (_upAxis = upAxis);
			super(collisionGroup, canCollideWith);
		}
		
		/**
		 * @private
		 */
		private function _constructCharacter():void {
			var physics3D:* = Laya3D._physics3D;
			if (_nativeKinematicCharacter)
				physics3D.destroy(_nativeKinematicCharacter);
			
			var nativeUpAxis:* = _nativeTempVector30;
			nativeUpAxis.setValue(_upAxis.x, _upAxis.y, _upAxis.z);
			_nativeKinematicCharacter = new physics3D.btKinematicCharacterController(_nativeColliderObject, _colliderShape._nativeShape, _stepHeight, nativeUpAxis);
			fallSpeed = _fallSpeed;
			maxSlope = _maxSlope;
			jumpSpeed = _jumpSpeed;
			gravity = _gravity;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onShapeChange(colShape:ColliderShape):void {
			super._onShapeChange(colShape);
			_constructCharacter();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			var physics3D:* = Laya3D._physics3D;
			var ghostObject:* = new physics3D.btPairCachingGhostObject();
			ghostObject.setUserIndex(id);
			ghostObject.setCollisionFlags(COLLISIONFLAGS_CHARACTER_OBJECT);
			_nativeColliderObject = ghostObject;
			
			if (_colliderShape)
				_constructCharacter();
			
			super._onAdded();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addToSimulation():void {
			_simulation._characters.push(this);
			_simulation._addCharacter(this, _collisionGroup, _canCollideWith);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _removeFromSimulation():void {
			_simulation._removeCharacter(this);
			var characters:Vector.<CharacterController> = _simulation._characters;
			characters.splice(characters.indexOf(this), 1);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component):void {
			super._cloneTo(dest);
			var destCharacterController:CharacterController = dest as CharacterController;
			destCharacterController.stepHeight = _stepHeight;
			destCharacterController.upAxis = _upAxis;
			destCharacterController.maxSlope = _maxSlope;
			destCharacterController.jumpSpeed = _jumpSpeed;
			destCharacterController.fallSpeed = _fallSpeed;
			destCharacterController.gravity = _gravity;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			Laya3D._physics3D.destroy(_nativeKinematicCharacter);
			super._onDestroy();
			_nativeKinematicCharacter = null;
		}
		
		/**
		 * 通过指定移动向量移动角色。
		 * @param	movement 移动向量。
		 */
		public function move(movement:Vector3):void {
			var nativeMovement:* = _nativeVector30;
			nativeMovement.setValue(-movement.x, movement.y, movement.z);
			_nativeKinematicCharacter.setWalkDirection(nativeMovement);
		}
		
		/**
		 * 跳跃。
		 * @param velocity 跳跃速度。
		 */
		public function jump(velocity:Vector3 = null):void {
			if (velocity) {
				var nativeVelocity:* = _nativeVector30;
				Utils3D._convertToBulletVec3(velocity, nativeVelocity, true);
				_nativeKinematicCharacter.jump(nativeVelocity);
			} else {
				_nativeKinematicCharacter.jump();
			}
		}
	}
}