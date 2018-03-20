package laya.d3.core {
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.component.Animator;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.resource.Resource;
	
	/**
	 * <code>Avatar</code> 类用于创建Avatar。
	 */
	public class Avatar extends Resource implements IClone {
		/**@private */
		public var _version:String;
		
		/**
		 * 加载Avatar文件。
		 * @param url Avatar文件。
		 */
		public static function load(url:String):Avatar {
			return Laya.loader.create(url, null, null, Avatar);
		}
		
		/**@private */
		private var _rootNode:AnimationNode;
		
		/**
		 * 创建一个 <code>Avatar</code> 实例。
		 */
		public function Avatar() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
		}
		
		/**
		 * @private
		 */
		private function _initCloneToAnimator(destNode:AnimationNode, destAnimator:Animator):void {
			destAnimator._avatarNodeMap[destNode.name] = destNode;
			destAnimator._avatarNodes.push(destNode);
			
			for (var i:int = 0, n:int = destNode.getChildCount(); i < n; i++)
				_initCloneToAnimator(destNode.getChildByIndex(i), destAnimator);
		}
		
		/**
		 * @private
		 */
		private function _parseNode(nodaData:Object, node:AnimationNode):void {
			var name:String = nodaData.props.name;
			node.name = name;
			
			if (node._parent) {//根节点无需设置数据
				var customProps:Object = nodaData.customProps;
				var transform:AnimationTransform3D = node.transform;
				transform._localRotationEuler = new Float32Array(3);
				transform.setLocalPosition(new Float32Array(customProps.translate));
				transform.setLocalRotation(new Float32Array(customProps.rotation));
				transform.setLocalScale(new Float32Array(customProps.scale));
				transform._setWorldMatrixAndUpdate(new Float32Array(16));
			}
			
			var childrenData:Array = nodaData.child;
			for (var i:int = 0, n:int = childrenData.length; i < n; i++) {
				var childData:Object = childrenData[i];
				var childBone:AnimationNode = new AnimationNode();
				node.addChild(childBone);
				_parseNode(childData, childBone);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			_rootNode = new AnimationNode();
			if (data.version) {
				_version = data.version;
				var rootNode:Object = data.rootNode;
				(rootNode) && (_parseNode(rootNode, _rootNode));
			} else {//兼容代码
				_parseNode(data, _rootNode);
			}
			_endLoaded();
		}
		
		/**
		 * 克隆数据到Avatr。
		 * @param	destObject 克隆源。
		 */
		public function _cloneDatasToAnimator(destAnimator:Animator):void {
			var destRoot:AnimationNode = _rootNode.clone();
			destRoot.transform._setWorldMatrixIgnoreUpdate(null);//根节点不需要更新
			var avatarNodes:Vector.<AnimationNode> = new Vector.<AnimationNode>();
			destAnimator._avatarNodeMap = {};
			destAnimator._avatarNodes = avatarNodes;
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
	}
}