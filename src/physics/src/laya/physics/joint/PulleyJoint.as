package laya.physics.joint {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.physics.Physics;
	import laya.physics.RigidBody;
	
	/**
	 * 滑轮关节：它将两个物体接地(ground)并彼此连接，当一个物体上升，另一个物体就会下降
	 */
	public class PulleyJoint extends JointBase {
		/**@private */
		private static var _temp:*;
		/**[首次设置有效]关节的自身刚体*/
		public var selfBody:RigidBody;
		/**[首次设置有效]关节的连接刚体*/
		public var otherBody:RigidBody;
		/**[首次设置有效]自身刚体链接点，是相对于自身刚体的左上角位置偏移*/
		public var selfAnchor:Array = [0, 0];
		/**[首次设置有效]链接刚体链接点，是相对于otherBody的左上角位置偏移*/
		public var otherAnchor:Array = [0, 0];
		
		/**[首次设置有效]滑轮上与节点selfAnchor相连接的节点，是相对于自身刚体的左上角位置偏移*/
		public var selfGroundPoint:Array = [0, 0];
		/**[首次设置有效]滑轮上与节点otherAnchor相连接的节点，是相对于otherBody的左上角位置偏移*/
		public var otherGroundPoint:Array = [0, 0];
		/**[首次设置有效]两刚体移动距离比率*/
		public var ratio:Number = 1.5;
		/**[首次设置有效]两个刚体是否可以发生碰撞，默认为false*/
		public var collideConnected:Boolean = false;
		
		override protected function _createJoint():void {
			if (!_joint) {
				if (!otherBody) throw "otherBody can not be empty";
				selfBody ||= owner.getComponent(RigidBody);
				if (!selfBody) throw "selfBody can not be empty";
				
				var box2d:* = window.box2d;
				var def:* = _temp || (_temp = new box2d.b2PulleyJointDef());
				var posA:Point = Sprite(otherBody.owner).localToGlobal(Point.TEMP.setTo(otherAnchor[0], otherAnchor[1]), false, Physics.I.worldRoot);
				var anchorVecA:* = new box2d.b2Vec2(posA.x / Physics.PIXEL_RATIO, posA.y / Physics.PIXEL_RATIO);
				var posB:Point = Sprite(selfBody.owner).localToGlobal(Point.TEMP.setTo(selfAnchor[0], selfAnchor[1]), false, Physics.I.worldRoot);
				var anchorVecB:* = new box2d.b2Vec2(posB.x / Physics.PIXEL_RATIO, posB.y / Physics.PIXEL_RATIO);
				var groundA:Point = Sprite(otherBody.owner).localToGlobal(Point.TEMP.setTo(otherGroundPoint[0], otherGroundPoint[1]), false, Physics.I.worldRoot);
				var groundVecA:* = new box2d.b2Vec2(groundA.x / Physics.PIXEL_RATIO, groundA.y / Physics.PIXEL_RATIO);
				var groundB:Point = Sprite(selfBody.owner).localToGlobal(Point.TEMP.setTo(selfGroundPoint[0], selfGroundPoint[1]), false, Physics.I.worldRoot);
				var groundVecB:* = new box2d.b2Vec2(groundB.x / Physics.PIXEL_RATIO, groundB.y / Physics.PIXEL_RATIO);
				
				def.Initialize(otherBody.getBody(), selfBody.getBody(), groundVecA, groundVecB, anchorVecA, anchorVecB, ratio);
				def.collideConnected = collideConnected;
				_joint = Physics.I._createJoint(def);
			}
		}
	}
}