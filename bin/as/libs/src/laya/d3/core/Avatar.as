package laya.d3.core {
	import laya.d3.animation.AnimationClip;
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.component.Animator;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.resource.Resource;
	import laya.utils.Stat;
	
	/**
	 * <code>Avatar</code> 类用于创建Avatar。
	 */
	public class Avatar extends Resource implements IClone {
		/**
		 * 加载Avatar文件。
		 * @param url Avatar文件。
		 */
		public static function load(url:String):Avatar {
			return Laya.loader.create(url, null, null, Avatar);
		}
		
		/**@private */
		private var _rootNode:AnimationNode;
		/**@private	*/
		private var _nodeMap:Object;
		/**@private	*/
		private var _nodes:Vector.<AnimationNode>;
		
		/**
		 * @private
		 * 创建一个 <code>Avatar</code> 实例。
		 */
		public function Avatar() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
		}
		
		/**
		 * @private
		 */
		private function _initCloneAvatar(destNode:AnimationNode, destAvatar:Avatar):void {
			destAvatar._nodeMap[destNode.name] = destNode;
			destAvatar._nodes.push(destNode);
			
			for (var i:int = 0, n:int = destNode.getChildCount(); i < n; i++)
				_initCloneAvatar(destNode.getChildByIndex(i), destAvatar);
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
			_nodes.push(node);
			_nodeMap[name] = node;
			
			var customProps:Object = nodaData.customProps;
			var transform:AnimationTransform3D = node._transform;
			
			var localPosition:Vector3 = transform.localPosition;
			var posE:Float32Array = localPosition.elements;
			var posData:Array = customProps.translate;
			posE[0] = posData[0];
			posE[1] = posData[1];
			posE[2] = posData[2];
			transform.localPosition = localPosition;
			
			var localRotation:Quaternion = transform.localRotation;
			var rotE:Float32Array = localRotation.elements;
			var rotData:Array = customProps.rotation;
			rotE[0] = rotData[0];
			rotE[1] = rotData[1];
			rotE[2] = rotData[2];
			rotE[3] = rotData[3];
			transform.localRotation = localRotation;
			
			var localScale:Vector3 = transform.localScale;
			var scaE:Float32Array = localScale.elements;
			var scaData:Array = customProps.scale;
			scaE[0] = scaData[0];
			scaE[1] = scaData[1];
			scaE[2] = scaData[2];
			transform.localScale = localScale;
			
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
			_nodeMap = {};
			_nodes = new Vector.<AnimationNode>();
			_rootNode = new AnimationNode();
			_parseNode(data, _rootNode);
			_endLoaded();
		}
		
		/**
		 * 克隆数据到Avatr。
		 * @param	destObject 克隆源。
		 */
		public function _cloneDatasToAnimator(destAnimator:Animator):void {
			var destRoot:AnimationNode = _rootNode.clone();
			var nodeCount:int = _nodes.length;
			var avatarNodes:Vector.<AnimationNode> = new Vector.<AnimationNode>();
			destAnimator._avatarRootNode = destRoot;
			destAnimator._avatarNodeMap = {};
			destAnimator._avatarNodes = avatarNodes;
			_initCloneToAnimator(destRoot, destAnimator);
			for (var i:int = 0, n:int = avatarNodes.length; i < n; i++) {
				var avatarNode:AnimationNode = avatarNodes[i];
				if (avatarNode._parent)
					avatarNode._transform._setWorldMatrixAndUpdate(new Matrix4x4());
				else
					avatarNode._transform._setWorldMatrixNoUpdate(null);
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destAvatar:Avatar = destObject as Avatar;
			var destRoot:AnimationNode = _rootNode.clone();
			destAvatar._rootNode = destRoot;
			destAvatar._nodeMap = {};
			var destNodes:Vector.<AnimationNode> = new Vector.<AnimationNode>();//TODO:预先知道长度。
			destAvatar._nodes = destNodes;
			_initCloneAvatar(destRoot, destAvatar);
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