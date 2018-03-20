package laya.webgl.shapes
{
	public class EarcutNode
	{
		public var i:*;
		public var x:*;
		public var y:*;
		public var prev:*;
		public var next:*;
		public var z:*;
		public var prevZ:*;
		public var nextZ:*;
		public var steiner:*;
		public function EarcutNode(i:*, x:*, y:*)
		{
			// vertice index in coordinates array
			this.i = i;

			// vertex coordinates
			this.x = x;
			this.y = y;

			// previous and next vertice nodes in a polygon ring
			this.prev = null;
			this.next = null;

			// z-order curve value
			this.z = null;

			// previous and next nodes in z-order
			this.prevZ = null;
			this.nextZ = null;

			// indicates whether this is a steiner point
			this.steiner = false;
		}
	}
}

