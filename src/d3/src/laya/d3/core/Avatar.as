package laya.d3.core {
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.component.Animator;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Handler;
	
	/**
	 * <code>Avatar</code> 类用于创建Avatar。
	 */
	public class Avatar extends Resource implements IClone {
		
		/**
		 * @inheritDoc
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):Avatar {
			var avatar:Avatar = new Avatar();
			avatar._rootNode = new AnimationNode(new Float32Array(3), new Float32Array(4), new Float32Array(3), new Float32Array(16));//[NATIVE],需要优化
			if (Render.isConchApp)
				avatar._nativeNodeCount++;//[NATIVE]
			if (data.version) {
				var rootNode:Object = data.rootNode;
				(rootNode) && (avatar._parseNode(rootNode, avatar._rootNode));
			}
			return avatar;
		}
		
		/**
		 * 加载Avatar文件。
		 * @param url Avatar文件。
		 * @param complete 完成回掉。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.AVATAR);
		}
		
		/**@private */
		public var _rootNode:AnimationNode;
		
		/**@private [NATIVE]*/
		private var _nativeNodeCount:int = 0;
		/**@private [NATIVE]*/
		public var _nativeCurCloneCount:int = 0;
		
		/**
		 * 创建一个 <code>Avatar</code> 实例。
		 */
		public function Avatar() {
			super();
		}
		
		/**
		 * @private
		 */
		private function _initCloneToAnimator(destNode:AnimationNode, destAnimator:Animator):void {
			destAnimator._avatarNodeMap[destNode.name] = destNode;
			
			for (var i:int = 0, n:int = destNode.getChildCount(); i < n; i++)
				_initCloneToAnimator(destNode.getChildByIndex(i), destAnimator);
		}
		
		/**
		 * @private
		 */
		private function _parseNode(nodaData:Object, node:AnimationNode):void {
			var name:String = nodaData.props.name;
			node.name = name;
			var props:Object = nodaData.props;
			var transform:AnimationTransform3D = node.transform;
			var pos:Vector3 = transform.localPosition;
			var rot:Quaternion = transform.localRotation;
			var sca:Vector3 = transform.localScale;
			pos.fromArray(props.translate);
			rot.fromArray(props.rotation);
			sca.fromArray(props.scale);
			transform.localPosition = pos;
			transform.localRotation = rot;
			transform.localScale = sca;
			
			var childrenData:Array = nodaData.child;
			for (var j:int = 0, n:int = childrenData.length; j < n; j++) {
				var childData:Object = childrenData[j];
				var childBone:AnimationNode = new AnimationNode(new Float32Array(3), new Float32Array(4), new Float32Array(3), new Float32Array(16));//[NATIVE],需要优化
				node.addChild(childBone);
				if (Render.isConchApp)
					_nativeNodeCount++;//[NATIVE]
				_parseNode(childData, childBone);
			}
		}
		
		/**
		 * 克隆数据到Avatr。
		 * @param	destObject 克隆源。
		 */
		public function _cloneDatasToAnimator(destAnimator:Animator):void {
			var destRoot:AnimationNode;
			destRoot = _rootNode.clone();
			
			var transform:AnimationTransform3D = _rootNode.transform;
			var destTransform:AnimationTransform3D = destRoot.transform;
			
			var destPosition:Vector3 = destTransform.localPosition;
			var destRotation:Quaternion = destTransform.localRotation;
			var destScale:Vector3 = destTransform.localScale;
			transform.localPosition.cloneTo(destPosition);
			transform.localRotation.cloneTo(destRotation);
			transform.localScale.cloneTo(destScale);
			destTransform.localPosition = destPosition;//深拷贝
			destTransform.localRotation = destRotation;//深拷贝
			destTransform.localScale = destScale;//深拷贝
			
			destAnimator._avatarNodeMap = {};
			_initCloneToAnimator(destRoot, destAnimator);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destAvatar:Avatar = destObject as Avatar;
			var destRoot:AnimationNode = _rootNode.clone();
			destAvatar._rootNode = destRoot;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:Avatar = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
		
		/**
		 * @private [NATIVE]
		 */
		public function _cloneDatasToAnimatorNative(destAnimator:Animator):void {
			var animationNodeLocalPositions:Float32Array = new Float32Array(_nativeNodeCount * 3);
			var animationNodeLocalRotations:Float32Array = new Float32Array(_nativeNodeCount * 4);
			var animationNodeLocalScales:Float32Array = new Float32Array(_nativeNodeCount * 3);
			var animationNodeWorldMatrixs:Float32Array = new Float32Array(_nativeNodeCount * 16);
			var animationNodeParentIndices:Int16Array = new Int16Array(_nativeNodeCount);
			destAnimator._animationNodeLocalPositions = animationNodeLocalPositions;
			destAnimator._animationNodeLocalRotations = animationNodeLocalRotations;
			destAnimator._animationNodeLocalScales = animationNodeLocalScales;
			destAnimator._animationNodeWorldMatrixs = animationNodeWorldMatrixs;
			destAnimator._animationNodeParentIndices = animationNodeParentIndices;
			_nativeCurCloneCount = 0;
			var destRoot:AnimationNode = _rootNode._cloneNative(animationNodeLocalPositions, animationNodeLocalRotations, animationNodeLocalScales, animationNodeWorldMatrixs, animationNodeParentIndices, -1, this);
			
			var transform:AnimationTransform3D = _rootNode.transform;
			var destTransform:AnimationTransform3D = destRoot.transform;
			
			var destPosition:Vector3 = destTransform.localPosition;
			var destRotation:Quaternion = destTransform.localRotation;
			var destScale:Vector3 = destTransform.localScale;
			transform.localPosition.cloneTo(destPosition);
			transform.localRotation.cloneTo(destRotation);
			transform.localScale.cloneTo(destScale);
			destTransform.localPosition = destPosition;//深拷贝
			destTransform.localRotation = destRotation;//深拷贝
			destTransform.localScale = destScale;//深拷贝
			
			destAnimator._avatarNodeMap = {};
			_initCloneToAnimator(destRoot, destAnimator);
		}
	}
}