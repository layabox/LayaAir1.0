package laya.d3.animation {
	
	/**
	 * <code>KeyframeNodeList</code> 类用于创建KeyframeNode节点队列。
	 */
	public class KeyframeNodeList {
		/**@private */
		private var _nodes:Vector.<KeyframeNode> = new Vector.<KeyframeNode>();
		
		/**
		 *	获取节点个数。
		 * @return 节点个数。
		 */
		public function get count():int {
			return _nodes.length;
		}
		
		/**
		 * 设置节点个数。
		 * @param value 节点个数。
		 */
		public function set count(value:int):void {
			_nodes.length = value;
		}
		
		/**
		 * 创建一个 <code>KeyframeNodeList</code> 实例。
		 */
		public function KeyframeNodeList() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * 通过索引获取节点。
		 * @param	index 索引。
		 * @return 节点。
		 */
		public function getNodeByIndex(index:int):KeyframeNode {
			return _nodes[index];
		}
		
		/**
		 * 通过索引设置节点。
		 * @param	index 索引。
		 * @param 节点。
		 */
		public function setNodeByIndex(index:int, node:KeyframeNode):void {
			_nodes[index] = node;
		}
	
	}

}