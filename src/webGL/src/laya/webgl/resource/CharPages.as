package laya.webgl.resource { 
	import laya.renders.Render;
	import laya.utils.Stat;
	/**
	 * 管理若干张CharPageTexture
	 * 里面的字体属于相同字体，相同大小
	 * 清理方式：
	 * 	每隔一段时间检查一下是否能合并，一旦发现可以省出一整张贴图，就开始清理
	 */
	public class CharPages {
		public static var charRender:ICharRender = null;
		//private static var canvas:*= null;// HTMLCanvasElement;
		//private static var ctx:*= null;
		private var pages:Array=[];// CharPageTexture
		public var fontFamily:String;
		public var _slotW:int = 0;	//格子的大小
		public var _gridW:int = 0;		//以格子为单位的宽
		public var _gridNum:int = 0; 	//每页有多少个格子。 注意是每页
		public var _textureWidth:int = CharBook.textureWidth;//对应的贴图的大小。为了避免浪费可能会比这个小
		//public var _textureHeight:int = 1024;//
		private var _baseSize:int = 0;		//0~15=0， 16~31=1，...
		private var _lastSz:int = 0;
		
		private var _spaceWidthMap:Array = [];	//空格宽度的缓存。CharRenderInfo类型。主要用了 width
		
		private var _minScoreID:int = -1;		//得分最小的page
		private var _selectedSizeIdx:int = 0;	//限制到1~16内
		public var margin_left:int;				//有的字体会超出边界，所以加一个外围保护
		public var margin_top:int;
		public var margin_bottom:int;
		public var margin_right:int;
		public var gcCnt:int = 0;			// 每次释放某张贴图了，就加1
		/**
		 * 
		 * @param	fontFamily 字体
		 * @param	bmpDataSize	  能存储的数据的大小。实际大小，可能是缩放后的。
		 * @param	marginSz	  保护边的大小。没有缩放。这个在ctx中会受到scale的影响
		 */
		public function  CharPages(fontFamily:String, bmpDataSize:int, marginSz:int):void {
			this.fontFamily = fontFamily;
			margin_top = 		//上面也有的话，stroke的下面会被裁掉。
			margin_left =  		 //左边和上边不用保护，如果这个也超出边界了，就不知道怎么办了。 不对，左边不做margin的话，stroke的左边会少一些
			margin_right =  margin_bottom = marginSz;
			_baseSize = Math.floor(bmpDataSize / CharBook.gridSize) * CharBook.gridSize;
			_selectedSizeIdx = (bmpDataSize-_baseSize)|0;
			_slotW = Math.ceil(bmpDataSize / CharBook.gridSize) * CharBook.gridSize
			_gridW = Math.floor(_textureWidth / _slotW);	//由于不能整除会空出一部分
			if (_gridW <= 0) {
				console.error("文字太大,需要修改texture大小");
				debugger;
				_gridW = 1;//最少一个，保证以后即使不正确也不崩溃
			}
			_gridNum = _gridW * _gridW;
			//if(CharBook.minTextureWidth)
			//	_textureWidth = _slotW * _gridW;
				
			console.log('gridInfo:slotW=' + _slotW+',gridw='+_gridW+',gridNum='+_gridNum+',textureW='+_textureWidth);
		}
		
		public static function getBmpSize(fonstsize:int):Number {
			//return fonstsize * 2;//考虑到左右扩展，左边扩展一半，右边扩展一半
			return fonstsize * 1.5;
		}
		
		public function getWidth(str:String):Number {
			return charRender.getWidth(CharBook._curFont, str);
		}
		
		/**
		 * pages最多有16个元素，代表不同的大小的文字（偏离basesize）这个函数表示选择哪个大小
		 * @param	sz
		 * @param extsz 扩展后的大小。
		 */
		public function selectSize(sz:int, extsz:int):void {
			_selectedSizeIdx = (extsz - _baseSize)|0;	
			//为了效率这里不直接设置ctx的font
		}
		
		/**
		 * 返回空格的宽度。通过底层获得，所以这里用了缓存。
		 * @param	touch
		 * @return
		 */
		public function getSpaceChar(touch:Boolean):CharRenderInfo {
			if ( _spaceWidthMap[_selectedSizeIdx]){
				return _spaceWidthMap[_selectedSizeIdx];
			}
			var ret:CharRenderInfo = new CharRenderInfo();
			_spaceWidthMap[_selectedSizeIdx] = ret;
			ret.width = getWidth(' ');
			ret.isSpace = true;
			return ret;
		}
		
		/**
		 * 添加一个文字到texture
		 * @param	str
		 * @param   bold   是否加粗
		 * @param   touch 是否touch,如果保存起来以后再处理就设置为false
		 * @param   scalekey 可能有缩放
		 * @return
		 */
		public function getChar(str:String, lineWidth:int, fontsize:int, color:String, strokeColor:String, bold:Boolean, touch:Boolean, scalekey:String):CharRenderInfo {
			if (str === ' ')
				return getSpaceChar(touch);
			var key:String = (lineWidth > 0?(str + '_'+lineWidth+strokeColor):str);
			var ret:CharRenderInfo;
			key += color;
			bold && (key += 'B');
			scalekey && (key += scalekey);
			for (var i:int = 0, sz:int = pages.length; i < sz; i++) {
				var cp:CharPageTexture = pages[i];
				//var cpmap:* = cp.charMap;
				var cpmap:Map = cp.charMaps[_selectedSizeIdx];
				if (cpmap) {
					ret = cpmap.get(key);
					if ( ret ) {
						touch && ret.touch();
						return ret;
					}
				}
			}
			//trace('addkey ' + key);
			/*
			var ret:CharRenderInfo = charMap[str];
			if (ret) {
				ret.touch();
				return ret;
			}
			
			ret = charMap[str] = new CharRenderInfo();			//TODO new
			*/
			ret = _getASlot();
			if (!ret) 
				return null;
			//ret.tex.charMap[key] = ret;
			var charmaps:Map = ret.tex.charMaps[_selectedSizeIdx];
			(!charmaps) && (charmaps = ret.tex.charMaps[_selectedSizeIdx] = new Map());
			charmaps.set(key, ret);
			
			touch && ret.touch();
			ret.height = fontsize;
			//注意：getCharBmp里用measureText来测量宽度，这个宽度与getCharBmp得到的文字像素可能不一致，因为bmp是带margin的。
			var bmp:ImageData = getCharBmp(str, CharBook._curFont, lineWidth, color, strokeColor, ret);
			//拷贝到贴图上
			var cy:int = Math.floor(ret.pos / _gridW);
			var cx:int = ret.pos % _gridW;
			var _curX:int = cx * _slotW;
			var _curY:int = cy * _slotW;			
			var texW:int = _textureWidth;
			var minx:Number = _curX / texW;
			var miny:Number = _curY / texW;
			var maxx:Number = (_curX + bmp.width) / texW;
			var maxy:Number = (_curY + bmp.height) / texW;
			var uv:Array = ret.uv;
			uv[0] = minx;	uv[1] = miny;
			uv[2] = maxx; uv[3] = miny;
			uv[4] = maxx; uv[5] = maxy;
			uv[6] = minx; uv[7] = maxy;			
			
			ret.tex.addChar(bmp, _curX, _curY);
			return ret;
		}
		
		/**
		 * 从所有的page中找一个空格子
		 * 如果没有地方了，就创建一个新的charpageTexture
		 */
		private function _getASlot():CharRenderInfo {
			var sz:int = pages.length;
			var cp:CharPageTexture ;
			var ret:CharRenderInfo;
			var pos:int;
			for ( var i:int = 0; i < sz; i++) {
				cp = pages[i];
				ret = cp.findAGrid();
				if ( ret ) {
					return ret;
				}
			}
			cp =  CharBook.trash.getAPage(_gridNum);
			pages.push(cp);
			ret = cp.findAGrid();
			if (!ret){
				console.error( "_getASlot error!");
			}
			return ret;
		}
		
		/**
		 * 渲染完成后再做
		 * 同时找到最不常用的
		 * @return
		 */
		//TODO:coverage
		public function getAllPageScore():int {
			var i:int = 0, sz:int = pages.length;
			var curTick:int = Stat.loopCount;
			var score:int = 0;
			var minScore:int = 10000;
			for (; i < sz; i++) {
				var cp:CharPageTexture = pages[i];
				if (cp._scoreTick == curTick) {
					score+= cp._score;
				}else {
					cp._score = 0;
				}
				if (cp._score < minScore) {
					minScore = cp._score;
					_minScoreID = i;
				}
			}
			return score;
		}
		
		//TODO:coverage
		public function removeLRU():Boolean {
			var freed:int  = _gridNum * pages.length - getAllPageScore();//全部使用的-本帧使用的
			if (freed>=_gridNum) {
				//先去掉一个page
				if (_minScoreID >= 0) {
					var cp:CharPageTexture = pages[_minScoreID];
					console.log('remove fontpage: delpageid='+_minScoreID+', total='+pages.length+',gcCnt:'+(gcCnt+1));
					var used:int = cp._score;	//要释放的page中还有多少在使用。下面要从其他page中空出这么多
					cp.printDebugInfo();
					CharBook.trash.discardPage(cp);
					//cp.destroy();
					pages[_minScoreID] = pages[pages.length - 1];
					pages.pop();
					
					//从前面清理出used个数
					var curloop:int = Stat.loopCount;
					var i:int = 0, sz:int = pages.length;
					for(; i < sz && used > 0;i++ ) {
						cp = pages[i];
						console.log('clean page '+i);
						//先简单的去掉不是本帧的
						var cleaned:int = cp.removeOld(curloop);
						used -= cleaned;
					}
				}
				gcCnt++;
				return true;
			}
			return false;
		}
		
		/**
		 *TODO stroke 
		 * @param	char
		 * @param	font
		 * @param	size  返回宽高
		 * @return
		 */
		//TODO:coverage
		public function getCharBmp( char:String, font:String, lineWidth:int, colStr:String, strokeColStr:String, size:CharRenderInfo):ImageData {
			return charRender.getCharBmp(char, font, lineWidth, colStr, strokeColStr, size,margin_left,margin_top,margin_right,margin_bottom);
		}
		
		// for debug
		public function printPagesInfo():void {
			console.log( '拥有页数: ', pages.length);
			console.log('基本大小:', _baseSize);
			console.log('格子宽度:', _slotW);
			console.log('每行格子数:', _gridW);
			console.log('贴图大小:', _textureWidth);
			console.log('    边界:', margin_left, margin_top);
			console.log('得分最少页:', _minScoreID);
			console.log('  GC次数:', gcCnt);
			console.log(' -------页信息-------');
			pages.forEach(function(cp:CharPageTexture):void {
				cp.printDebugInfo(true);
			}
			);
			console.log(' -----页信息结束-------');
		}
	}
}