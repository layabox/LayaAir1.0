package laya.d3.core.render {
	import laya.d3.shader.Shader3D;
	
	/**
	 * @private
	 * <code>RenderQuene</code> 类用于实现渲染队列。
	 */
	public class RenderQueue {
		/** @private [只读]*/
		public var isTransparent:Boolean;
		/** @private */
		public var elements:Array;
		/** @private */
		public var lastTransparentRenderElement:RenderElement;
		/** @private */
		public var lastTransparentBatched:Boolean;
		
		/**
		 * 创建一个 <code>RenderQuene</code> 实例。
		 */
		public function RenderQueue(isTransparent:Boolean = false) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			this.isTransparent = isTransparent;
			elements = [];
		}
		
		/**
		 * @private
		 */
		private function _compare(left:RenderElement, right:RenderElement):int {
			var renderQueue:int = left.material.renderQueue - right.material.renderQueue;
			if (renderQueue === 0) {
				var sort:int = isTransparent ? right.render._distanceForSort - left.render._distanceForSort : left.render._distanceForSort - right.render._distanceForSort;
				return sort + right.render.sortingFudge - left.render.sortingFudge;
			} else {
				return renderQueue;
			}
		}
		
		/**
		 * @private
		 */
		private function _partitionRenderObject(left:int, right:int):int {
			var pivot:RenderElement = elements[Math.floor((right + left) / 2)];
			while (left <= right) {
				while (_compare(elements[left], pivot) < 0)
					left++;
				while (_compare(elements[right], pivot) > 0)
					right--;
				if (left < right) {
					var temp:RenderElement = elements[left];
					elements[left] = elements[right];
					elements[right] = temp;
					left++;
					right--;
				} else if (left === right) {
					left++;
					break;
				}
			}
			return left;
		}
		
		/**
		 * @private
		 */
		public function _quickSort(left:int, right:int):void {
			if (elements.length > 1) {
				var index:int = _partitionRenderObject(left, right);
				var leftIndex:int = index - 1;
				if (left < leftIndex)
					_quickSort(left, leftIndex);
				
				if (index < right)
					_quickSort(index, right);
			}
		}
		

		
		/**
		 * @private
		 */
		public function _render(context:RenderContext3D, isTarget:Boolean, customShader:Shader3D = null, replacementTag:String = null):void {
			for (var i:int = 0, n:int = elements.length; i < n; i++) 
				elements[i]._render(context, isTarget, customShader, replacementTag);
		}
		
		/**
		 * @private
		 */
		public function clear():void {
			elements.length = 0;
			lastTransparentRenderElement = null;
			lastTransparentBatched = false;
		}
	}
}