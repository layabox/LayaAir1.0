package PathFinding.libs
{
	
	/**
	 * ...
	 * @author dongketao
	 */
	public class HeapFunction
	{
		
		public function HeapFunction()
		{
		
		}
		
		/*
		   Default comparison function to be used
		 */
		
		//defaultCmp = function(x, y) {
		//if (x < y) {
		//return -1;
		//}
		//if (x > y) {
		//return 1;
		//}
		//return 0;
		//};
		public var defaultCmp:Function = function(x:Number, y:Number):int
		{
			if (x < y)
			{
				return -1;
			}
			if (x > y)
			{
				return 1;
			}
			return 0;
		}
		
		/*
		   Insert item x in list a, and keep it sorted assuming a is sorted.
		
		   If x is already in a, insert it to the right of the rightmost x.
		
		   Optional args lo (default 0) and hi (default a.length) bound the slice
		   of a to be searched.
		 */
		
		//insort = function(a, x, lo, hi, cmp) {
		//var mid;
		//if (lo == null) {
		//lo = 0;
		//}
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//if (lo < 0) {
		//throw new Error('lo must be non-negative');
		//}
		//if (hi == null) {
		//hi = a.length;
		//}
		//while (lo < hi) {
		//mid = floor((lo + hi) / 2);
		//if (cmp(x, a[mid]) < 0) {
		//hi = mid;
		//} else {
		//lo = mid + 1;
		//}
		//}
		//return ([].splice.apply(a, [lo, lo - lo].concat(x)), x);
		//};
		public function insort(a:Object, x:Object, lo:* = null, hi:* = null, cmp:* = null):*
		{
			var mid:Number;
			if (lo == null)
			{
				lo = 0;
			}
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			if (lo < 0)
			{
				throw new Error('lo must be non-negative');
			}
			if (hi == null)
			{
				hi = a.length;
			}
			while (lo < hi)
			{
				mid = Math.floor((lo + hi) / 2);
				if (cmp(x, a[mid]) < 0)
				{
					hi = mid;
				}
				else
				{
					lo = mid + 1;
				}
			}
			return ([].splice.apply(a, [lo, lo - lo].concat(x)), x);
		}
		
		/*
		   Push item onto heap, maintaining the heap invariant.
		 */
		
		//heappush = function(array, item, cmp) {
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//array.push(item);
		//return _siftdown(array, 0, array.length - 1, cmp);
		//};
		public function heappush(array:Object, item:Object, cmp:Object):Object
		{
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			array.push(item);
			return _siftdown(array, 0, array.length - 1, cmp);
		}
		
		/*
		   Pop the smallest item off the heap, maintaining the heap invariant.
		 */
		//heappop = function(array, cmp) {
		//var lastelt, returnitem;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//lastelt = array.pop();
		//if (array.length) {
		//returnitem = array[0];
		//array[0] = lastelt;
		//_siftup(array, 0, cmp);
		//} else {
		//returnitem = lastelt;
		//}
		//return returnitem;
		//};
		public function heappop(array:Object, cmp:Object):Object
		{
			var lastelt:Object, returnitem:Object;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			lastelt = array.pop();
			if (array.length)
			{
				returnitem = array[0];
				array[0] = lastelt;
				_siftup(array, 0, cmp);
			}
			else
			{
				returnitem = lastelt;
			}
			return returnitem;
		}
		
		/*
		   Pop and return the current smallest value, and add the new item.
		
		   This is more efficient than heappop() followed by heappush(), and can be
		   more appropriate when using a fixed size heap. Note that the value
		   returned may be larger than item! That constrains reasonable use of
		   this routine unless written as part of a conditional replacement:
		   if item > array[0]
		   item = heapreplace(array, item)
		 */
		
		//heapreplace = function(array, item, cmp) {
		//var returnitem;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//returnitem = array[0];
		//array[0] = item;
		//_siftup(array, 0, cmp);
		//return returnitem;
		//};
		public function heapreplace(array:Object, item:Object, cmp:Object):Object
		{
			var returnitem:Object;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			returnitem = array[0];
			array[0] = item;
			_siftup(array, 0, cmp);
			return returnitem;
		}
		
		/*
		   Fast version of a heappush followed by a heappop.
		 */
		
		//heappushpop = function(array, item, cmp) {
		//var _ref;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//if (array.length && cmp(array[0], item) < 0) {
		//_ref = [array[0], item], item = _ref[0], array[0] = _ref[1];
		//_siftup(array, 0, cmp);
		//}
		//return item;
		//};
		public function heappushpop(array:Object, item:Object, cmp:Object):Object
		{
			var _ref:Object;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			if (array.length && cmp(array[0], item) < 0)
			{
				_ref = [array[0], item], item = _ref[0], array[0] = _ref[1];
				_siftup(array, 0, cmp);
			}
			return item;
		}
		
		/*
		   Transform list into a heap, in-place, in O(array.length) time.
		 */
		
		//heapify = function(array, cmp) {
		//var i, _i, _j, _len, _ref, _ref1, _results, _results1;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//_ref1 = (function() {
		//_results1 = [];
		//for (var _j = 0, _ref = floor(array.length / 2); 0 <= _ref ? _j < _ref : _j > _ref; 0 <= _ref ? _j++ : _j--){ _results1.push(_j); }
		//return _results1;
		//}).apply(this).reverse();
		//_results = [];
		//for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
		//i = _ref1[_i];
		//_results.push(_siftup(array, i, cmp));
		//}
		//return _results;
		//};
		public function heapify(array:Object, cmp:Object):Object
		{
			var i:int, _i:int, _j:int, _len:int, _ref:Object, _ref1:Object, _results:Object, _results1:Object;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			_ref1 = (function():Object
			{
				_results1 = [];
				for (_j = 0, _ref = Math.floor(array.length / 2); 0 <= _ref ? _j < _ref : _j > _ref; 0 <= _ref ? _j++ : _j--)
				{
					_results1.push(_j);
				}
				return _results1;
			}).apply(this).reverse();
			_results = [];
			for (_i = 0, _len = _ref1.length; _i < _len; _i++)
			{
				i = _ref1[_i];
				_results.push(_siftup(array, i, cmp));
			}
			return _results;
		}
		
		/*
		   Update the position of the given item in the heap.
		   This function should be called every time the item is being modified.
		 */
		
		//updateItem = function(array, item, cmp) {
		//var pos;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//pos = array.indexOf(item);
		//if (pos === -1) {
		//return;
		//}
		//_siftdown(array, 0, pos, cmp);
		//return _siftup(array, pos, cmp);
		//};
		public function updateItem(array:Object, item:Object, cmp:Object):Object
		{
			var pos:int;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			pos = array.indexOf(item);
			if (pos === -1)
			{
				return null;
			}
			_siftdown(array, 0, pos, cmp);
			return _siftup(array, pos, cmp);
		}
		
		/*
		   Find the n largest elements in a dataset.
		 */
		
		//nlargest = function(array, n, cmp) {
		//var elem, result, _i, _len, _ref;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//result = array.slice(0, n);
		//if (!result.length) {
		//return result;
		//}
		//heapify(result, cmp);
		//_ref = array.slice(n);
		//for (_i = 0, _len = _ref.length; _i < _len; _i++) {
		//elem = _ref[_i];
		//heappushpop(result, elem, cmp);
		//}
		//return result.sort(cmp).reverse();
		//};
		public function nlargest(array:Object, n:int, cmp:Object):Object
		{
			var elem:Object, result:Object, _i:int, _len:int, _ref:Object;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			result = array.slice(0, n);
			if (!result.length)
			{
				return result;
			}
			heapify(result, cmp);
			_ref = array.slice(n);
			for (_i = 0, _len = _ref.length; _i < _len; _i++)
			{
				elem = _ref[_i];
				heappushpop(result, elem, cmp);
			}
			return result.sort(cmp).reverse();
		}
		
		/*
		   Find the n smallest elements in a dataset.
		 */
		
		//nsmallest = function(array, n, cmp) {
		//var elem, i, los, result, _i, _j, _len, _ref, _ref1, _results;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//if (n * 10 <= array.length) {
		//result = array.slice(0, n).sort(cmp);
		//if (!result.length) {
		//return result;
		//}
		//los = result[result.length - 1];
		//_ref = array.slice(n);
		//for (_i = 0, _len = _ref.length; _i < _len; _i++) {
		//elem = _ref[_i];
		//if (cmp(elem, los) < 0) {
		//insort(result, elem, 0, null, cmp);
		//result.pop();
		//los = result[result.length - 1];
		//}
		//}
		//return result;
		//}
		//heapify(array, cmp);
		//_results = [];
		//for (i = _j = 0, _ref1 = min(n, array.length); 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
		//_results.push(heappop(array, cmp));
		//}
		//return _results;
		//};
		
		public function nsmallest(array:Object, n:int, cmp:Object):Object
		{
			var elem:Object, i:Object, los:Object, result:Object, _i:int, _j:int, _len:Object, _ref:Object, _ref1:Object, _results:Object;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			if (n * 10 <= array.length)
			{
				result = array.slice(0, n).sort(cmp);
				if (!result.length)
				{
					return result;
				}
				los = result[result.length - 1];
				_ref = array.slice(n);
				for (_i = 0, _len = _ref.length; _i < _len; _i++)
				{
					elem = _ref[_i];
					if (cmp(elem, los) < 0)
					{
						insort(result, elem, 0, null, cmp);
						result.pop();
						los = result[result.length - 1];
					}
				}
				return result;
			}
			heapify(array, cmp);
			_results = [];
			for (i = _j = 0, _ref1 = Math.min(n, array.length); 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j)
			{
				_results.push(heappop(array, cmp));
			}
			return _results;
		}
		
		//_siftdown = function(array, startpos, pos, cmp) {
		//var newitem, parent, parentpos;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//newitem = array[pos];
		//while (pos > startpos) {
		//parentpos = (pos - 1) >> 1;
		//parent = array[parentpos];
		//if (cmp(newitem, parent) < 0) {
		//array[pos] = parent;
		//pos = parentpos;
		//continue;
		//}
		//break;
		//}
		//return array[pos] = newitem;
		//};
		public function _siftdown(array:Object, startpos:int, pos:int, cmp:Object):Object
		{
			var newitem:Object, parent:Object, parentpos:int;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			newitem = array[pos];
			while (pos > startpos)
			{
				parentpos = (pos - 1) >> 1;
				parent = array[parentpos];
				if (cmp(newitem, parent) < 0)
				{
					array[pos] = parent;
					pos = parentpos;
					continue;
				}
				break;
			}
			return array[pos] = newitem;
		}
		
		//_siftup = function(array, pos, cmp) {
		//var childpos, endpos, newitem, rightpos, startpos;
		//if (cmp == null) {
		//cmp = defaultCmp;
		//}
		//endpos = array.length;
		//startpos = pos;
		//newitem = array[pos];
		//childpos = 2 * pos + 1;
		//while (childpos < endpos) {
		//rightpos = childpos + 1;
		//if (rightpos < endpos && !(cmp(array[childpos], array[rightpos]) < 0)) {
		//childpos = rightpos;
		//}
		//array[pos] = array[childpos];
		//pos = childpos;
		//childpos = 2 * pos + 1;
		//}
		//array[pos] = newitem;
		//return _siftdown(array, startpos, pos, cmp);
		//};
		public function _siftup(array:Object, pos:int, cmp:Object):Object
		{
			var childpos:int, endpos:int, newitem:Object, rightpos:int, startpos:int;
			if (cmp == null)
			{
				cmp = defaultCmp;
			}
			endpos = array.length;
			startpos = pos;
			newitem = array[pos];
			childpos = 2 * pos + 1;
			while (childpos < endpos)
			{
				rightpos = childpos + 1;
				if (rightpos < endpos && !(cmp(array[childpos], array[rightpos]) < 0))
				{
					childpos = rightpos;
				}
				array[pos] = array[childpos];
				pos = childpos;
				childpos = 2 * pos + 1;
			}
			array[pos] = newitem;
			return _siftdown(array, startpos, pos, cmp);
		}
	}

}