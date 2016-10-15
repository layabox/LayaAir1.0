package PathFinding.core
{
	
	/**
	 * ...
	 * @author dongketao
	 */
	public class Node
	{
		public var x:int;
		public var y:int;
		public var g:int;
		public var f:int;
		public var h:int;
		public var by:int;
		public var parent:Node;
		public var opened:* = null;
		public var closed:* = null;
		public var tested:* = null;
		public var retainCount:* = null;
		public var walkable:Boolean;
		
		public function Node(x:int, y:int, walkable:Boolean = true)
		{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
	
	}

}