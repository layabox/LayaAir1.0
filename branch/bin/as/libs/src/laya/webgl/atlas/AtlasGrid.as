package laya.webgl.atlas {
	
	public class AtlasGrid {
		public var _atlasID:int = 0;
		private var _width:uint = 0;
		private var _height:uint = 0;
		private var _texCount:uint = 0;
		private var _failSize:TexMergeTexSize = new TexMergeTexSize();
		private var _rowInfo:Vector.<TexRowInfo> = null;
		private var _cells:Uint8Array = null;
		
		//------------------------------------------------------------------------------
		public function AtlasGrid(width:uint = 0, height:uint = 0, atlasID:uint = 0) {
			_cells = null;
			_rowInfo = null;
			_init(width, height);
			_atlasID = atlasID;
		}
		
		//------------------------------------------------------------------------------
		public function getAltasID():int {
			return _atlasID;
		}
		
		//------------------------------------------------------------------------------
		public function setAltasID(atlasID:int):void {
			if (atlasID >= 0) {
				_atlasID = atlasID;
			}
		}
		
		//------------------------------------------------------------------
		public function addTex(type:int, width:int, height:int):MergeFillInfo {
			//调用获得应该放在哪 返回值有三个。。bRet是否成功，nX x位置，nY y位置
			var result:MergeFillInfo = this._get(width, height);
			//判断如果没有找到合适的位置，则直接返回失败
			if (result.ret == false) {
				return result;
			}
			//根据获得的x,y填充
			this._fill(result.x, result.y, width, height, type);
			this._texCount++;
			//返回是否成功，以及X位置和Y位置
			return result;
		}
		
		//------------------------------------------------------------------------------
		private function _release():void {
			if (_cells != null) {
				_cells.length = 0;
				_cells = null;
			}
			if (_rowInfo) {
				_rowInfo.length = 0;
				_rowInfo = null;
			}
		}
		
		//------------------------------------------------------------------------------
		private function _init(width:uint, height:uint):Boolean {
			_width = width;
			_height = height;
			_release();
			if (_width == 0) return false;
			_cells = new Uint8Array(_width * _height*3);
			_rowInfo = new Vector.<TexRowInfo>(_height);
			for (var i:uint = 0; i < _height; i++) {
				_rowInfo[i] = new TexRowInfo();
			}
			_clear();
			return true;
		}
		
		//------------------------------------------------------------------
		private function _get(width:int, height:int):MergeFillInfo {
			var pFillInfo:MergeFillInfo = new MergeFillInfo();
			if (width >= _failSize.width && height >= _failSize.height) {
				return pFillInfo;
			}
			//定义返回的x,y的位置
			var rx:int = -1;
			var ry:int = -1;
			//为了效率先保存临时变量
			var nWidth:int = this._width;
			var nHeight:int = this._height;
			//定义一个变量为了指向 m_pCells
			var pCellBox:Uint8Array = this._cells;
			
			//遍历查找合适的位置
			for (var y:int = 0; y < nHeight; y++) {
				//如果该行的空白数 小于 要放入的宽度返回
				if (this._rowInfo[y].spaceCount < width) continue;
				for (var x:int = 0; x < nWidth; ) {
					
					var tm:int = (y * nWidth + x) * 3;
					
					if (pCellBox[tm] != 0 || pCellBox[tm+1] < width || pCellBox[tm+2] < height) {
						x += pCellBox[tm+1];
						continue;
					}
					rx = x;
					ry = y;
					for (var xx:int = 0; xx < width; xx++) {
						if (pCellBox[3*xx+tm+2] < height) {
							rx = -1;
							break;
						}
					}
					if (rx < 0) {
						x += pCellBox[tm+1];
						continue;
					}
					pFillInfo.ret = true;
					pFillInfo.x = rx;
					pFillInfo.y = ry;
					return pFillInfo;
				}
			}
			return pFillInfo;
		}
		
		//------------------------------------------------------------------
		private function _fill(x:int, y:int, w:int, h:int, type:int):void {
			//定义一些临时变量
			var nWidth:int = this._width;
			var nHeghit:int = this._height;
			//代码检查
			this._check((x + w) <= nWidth && (y + h) <= nHeghit);
			
			//填充
			for (var yy:int = y; yy < (h + y); ++yy) {
				this._check(this._rowInfo[yy].spaceCount >= w);
				this._rowInfo[yy].spaceCount -= w;
				for (var xx:int = 0; xx < w; xx++) {
					var tm:int = (x + yy * nWidth + xx) * 3;
					this._check(_cells[tm] == 0);
					_cells[tm] = type;
					_cells[tm+1] = w;
					_cells[tm+2] = h;
				}
			}
			//调整我左方相邻空白格子的宽度连续信息描述
			if (x > 0) {
				for (yy = 0; yy < h; ++yy) {
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
				this._rowInfo[y].spaceCount = this._width;
			}
			for (var i:int = 0; i < this._height; i++) {
				for (var j:int = 0; j < this._width; j++) {
					var tm:int = (i * _width + j) * 3;
					this._cells[tm] = 0;
					this._cells[tm+1] = _width - j;
					this._cells[tm+2]= _width - i;
				}
			}
			_failSize.width = _width + 1;
			_failSize.height = _height + 1;
		}
		//------------------------------------------------------------------
	}
}

//------------------------------------------------------------------------------
class TexRowInfo {
	public var spaceCount:uint;			//此行总空白数
}

//------------------------------------------------------------------------------
class TexMergeTexSize {
	public var width:uint;
	public var height:uint;
}
//------------------------------------------------------------------------------