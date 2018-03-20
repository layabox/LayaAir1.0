package PathFinding.libs
{
	
	/**
	 * ...
	 * @author dongketao
	 */
	public class Heap
	{
		public var heapFunction:HeapFunction = new HeapFunction();
		
		public var cmp:Function;
		public var nodes:Array;
		
		public function Heap(cmp:Function = null)
		{
			this.cmp = cmp != null ? cmp : heapFunction.defaultCmp;
			this.nodes = [];
		}
		
		public function push(x:Object):Object
		{
			return heapFunction.heappush(this.nodes, x, this.cmp);
		}
		
		public function pop():Object
		{
			return heapFunction.heappop(this.nodes, this.cmp);
		}
		
		public function peek():Object
		{
			return this.nodes[0];
		}
		
		public function contains(x:Object):Boolean
		{
			return this.nodes.indexOf(x) !== -1;
		}
		
		public function replace(x:Object):Object
		{
			return heapFunction.heapreplace(this.nodes, x, this.cmp);
		}
		
		public function pushpop(x:Object):Object
		{
			return heapFunction.heappushpop(this.nodes, x, this.cmp);
		}
		
		public function heapify():Object
		{
			return heapFunction.heapify(this.nodes, this.cmp);
		}
		
		public function updateItem(x:Object):Object
		{
			return heapFunction.updateItem(this.nodes, x, this.cmp);
		}
		
		public function clear():Object
		{
			return this.nodes = [];
		}
		
		public function empty():Boolean
		{
			return this.nodes.length === 0;
		}
		
		public function size():int
		{
			return this.nodes.length;
		}
		
		public function clone():Heap
		{
			var heap:Heap = new Heap();
			heap.nodes = this.nodes.slice(0);
			return heap;
		}
		
		public function toArray():Object
		{
			return this.nodes.slice(0);
		}
	}

}