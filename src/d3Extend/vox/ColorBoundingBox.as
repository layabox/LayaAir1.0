package laya.d3Extend.vox {
	/**
	 * 给 median cut 算法用的包围盒。
	 */
	public class ColorBoundingBox {
		private var minr:int = 255;
		private var ming:int = 255;
		private var minb:int = 255;
		private var maxr:int = 0;
		private var maxg:int = 0;
		private var maxb:int = 0;
		private var bc:Vector.<VoxelColor> = new Vector.<VoxelColor>();

		/**
		 * 
		 * @param	colors 颜色统计数组。w是颜色个数。由于需要排序，所以不方便直接用数组
		 */
		public function ColorBoundingBox(colors:Vector.<VoxelColor>):void{
			for (var i:int = 0, sz:int = colors.length; i < sz; i++) {
				var c:VoxelColor = colors[i];
				minr = Math.min(c.r, this.minr);
				ming = Math.min(c.g, this.ming);
				minb = Math.min(c.b, this.minb);

				maxr = Math.max(c.r, this.maxr);
				maxg = Math.max(c.g, this.maxg);
				maxb = Math.max(c.b, this.maxb);
				//bc.push({r: c.r, g: c.g, b: c.b, w: c.w});		
			}
			bc = colors;// 注意是直接引用。
		}

		/**
		 * 从数据中间二分
		 */
		public function split():Object{
			var dr:int = maxr - minr;
			var dg:int = maxg - ming;
			var db:int = maxb - minb;

			var dir:String = 'r';
			if( dg > dr ) {
				if( db > dg ) dir = 'b';
				else dir = 'g';
			}
			else {
				if( db > dr ) dir = 'b';
			}

			switch( dir ) {
				case 'r':{
					// sort the colors along r axis
					bc.sort( function(a:VoxelColor, b:VoxelColor):int {return a.r - b.r;} );
					break;
				}
				case 'g':{
					bc.sort( function(a:VoxelColor, b:VoxelColor):int {return a.g - b.g;} );
					break;
				}
				case 'b':{
					bc.sort( function(a:VoxelColor, b:VoxelColor):int {return a.b - b.b;} );
					break;
				}
			}

			// TODO 怎么没有处理颜色数量不够的情况
			var mid:int = this.bc.length/2;
			var lBox:ColorBoundingBox = new ColorBoundingBox(bc.slice(0, mid) as Vector.<VoxelColor>);
			var rBox:ColorBoundingBox = new ColorBoundingBox(bc.slice(mid) as Vector.<VoxelColor>);

			return {
				left: lBox,
				right: rBox
			}
		}

		/**
		 * 求box中颜色的平均数
		 * @param idx  当前所属的调色板索引,同时修改保存的对象的调色板索引可以省掉后面的颜色转调色板
		 */
		public function meanColor( idx:int, out:VoxelColor ):VoxelColor {
			var r:int = 0, g:int = 0, b:int = 0, wSum:int = 0;
			var colors:Array = this.bc as Array;
			for (var i:int = 0, len:int=colors.length; i < len; i++) {
				var o:VoxelColor = colors[i];
				var w:int = o.w;        // w是重复次数，或者这里放了多少个相同颜色
				r += o.r * w;
				g += o.g * w;
				b += o.b * w;
				wSum += w;
				if (o.obj) {
					o.obj[0] = idx;
				}
			}
			if (wSum === 0) {
				r = g = b = 0;
			}else{
				r /= wSum;
				g /= wSum;
				b /= wSum;
			}
			out.r = Math.round(r);
			out.g = Math.round(g);
			out.b = Math.round(b);
			return out;
		}
	}
}	