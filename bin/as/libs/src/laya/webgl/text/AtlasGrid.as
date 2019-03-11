package laya.webgl.text {
	import laya.maths.Point;
	
	// 注意长宽都不要超过256，一个是影响效率，一个是超出表达能力
	public class AtlasGrid {
		public var atlasID:int = 0;
		private var _width:uint = 0;
		private var _height:uint = 0;
		private var _texCount:uint = 0;
		private var _rowInfo:Uint8Array = null;		// 当前行的最大长度
		private var _cells:Uint8Array = null;		// 每个格子的信息。{type,w,h} 相当于一个距离场. type =0 表示空闲的。不为0的情况下填充的是宽高（有什么用呢）
		public var _used:Number = 0;				// 使用率
		
		// TODO type 是否有用
		
		//------------------------------------------------------------------------------
		public function AtlasGrid(width:uint = 0, height:uint = 0, id:uint = 0) {
			_cells = null;
			_rowInfo = null;
			atlasID = id;
			_init(width, height);
		}
		
		//------------------------------------------------------------------
		public function addRect(type:int, width:int, height:int, pt:Point):Boolean{
			//调用获得应该放在哪 返回值有三个。。bRet是否成功，nX x位置，nY y位置
			if ( !_get(width, height, pt))
				return false;
			//根据获得的x,y填充
			this._fill(pt.x, pt.y, width, height, type);
			this._texCount++;
			//返回是否成功，以及X位置和Y位置
			return true;
		}
		
		//------------------------------------------------------------------------------
		private function _release():void {
			_cells = null;
			_rowInfo = null;
		}
		
		//------------------------------------------------------------------------------
		private function _init(width:uint, height:uint):Boolean {
			_width = width;
			_height = height;
			_release();
			if (_width == 0) return false;
			_cells = new Uint8Array(_width * _height*3);
			_rowInfo = new Uint8Array(_height);
			_used = 0;
			_clear();
			return true;
		}
		
		//------------------------------------------------------------------
		private function _get(width:int, height:int, pt:Point):Boolean{
			if (width > _width || height >_height) {
				return false;
			}
			//定义返回的x,y的位置
			var rx:int = -1;
			var ry:int = -1;
			//为了效率先保存临时变量
			var nWidth:int = this._width;
			var nHeight:int = this._height;
			//定义一个变量为了指向 m_pCells
			var pCellBox:Uint8Array = this._cells;
			
			//遍历查找合适的位置  //TODO 下面的方法应该可以优化
			for (var y:int = 0; y < nHeight; y++) {
				//如果该行的空白数 小于 要放入的宽度返回
				if (this._rowInfo[y] < width) continue;
				for (var x:int = 0; x < nWidth; ) {
					
					var tm:int = (y * nWidth + x) * 3;
					
					if (pCellBox[tm] != 0 || pCellBox[tm+1] < width || pCellBox[tm+2] < height) {
						x += pCellBox[tm+1];
						continue;
					}
					rx = x;
					ry = y;
					// 检查当前宽度是否能完全放下，即x方向的每个位置都有足够的高度。
					for (var xx:int = 0; xx < width; xx++) {
						if (pCellBox[3*xx+tm+2] < height) {
							rx = -1;
							break;
						}
					}
					// 不行就x继续前进
					if (rx < 0) {
						x += pCellBox[tm+1];
						continue;
					}
					// 找到了
					pt.x = rx;
					pt.y = ry;
					return true;
				}
			}
			return false;
		}
		
		//------------------------------------------------------------------
		private function _fill(x:int, y:int, w:int, h:int, type:int):void {
			//定义一些临时变量
			var nWidth:int = _width;
			var nHeghit:int = _height;
			//代码检查
			_check((x + w) <= nWidth && (y + h) <= nHeghit);
			
			//填充
			for (var yy:int = y; yy < (h + y); ++yy) {
				_check(this._rowInfo[yy] >= w);
				_rowInfo[yy] -= w;
				for (var xx:int = 0; xx < w; xx++) {
					var tm:int = (x + yy * nWidth + xx) * 3;
					_check(_cells[tm] == 0);
					_cells[tm] = type;
					_cells[tm+1] = w;
					_cells[tm+2] = h;
				}
			}
			//调整我左方相邻空白格子的宽度连续信息描述
			if (x > 0) {
				for (yy = 0; yy < h; ++yy) {
					// TODO 下面应该可以优化
					var s:int = 0;
					for (xx = x - 1; xx >= 0; --xx, ++s) {
						if (_cells[((y + yy) * nWidth + xx)*3] != 0) break;
					}
					for (xx = s; xx > 0; --xx) {
						_cells[((y + yy) * nWidth + x - xx)*3+1] = xx;
						this._check(xx > 0);
					}
				}
			}
			//调整我上方相邻空白格子的高度连续信息描述
			if (y > 0) {
				for (xx = x; xx < (x + w); ++xx) {
					// TODO 下面应该可以优化
					s = 0;
					for (yy = y - 1; yy >= 0; --yy, s++) {
						if (this._cells[(xx + yy * nWidth)*3] != 0) break;
					}
					for (yy = s; yy > 0; --yy) {
						this._cells[(xx + (y - yy) * nWidth)*3+2] = yy;
						this._check(yy > 0);
					}
				}
			}
			
			_used += (w*h)/(_width*_height);
		}
		
		private function _check(ret:Boolean):void {
			if (ret == false) {
				trace("xtexMerger 错误啦");
			}
		}
		
		//------------------------------------------------------------------
		private function _clear():void {
			this._texCount = 0;
			for (var y:int = 0; y < this._height; y++) {
				this._rowInfo[y] = this._width;
			}
			for (var i:int = 0; i < this._height; i++) {
				for (var j:int = 0; j < this._width; j++) {
					var tm:int = (i * _width + j) * 3;
					this._cells[tm] = 0;
					this._cells[tm+1] = _width - j;
					this._cells[tm+2]= _width - i;
				}
			}
		}
		//------------------------------------------------------------------
	}
}
