package laya.webgl.text {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.ColorUtils;
	import laya.utils.FontInfo;
	import laya.utils.HTMLChar;
	import laya.utils.Stat;
	import laya.utils.WordText;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.CharRenderInfo;
	import laya.webgl.resource.CharRender_Canvas;
	import laya.webgl.resource.CharRender_Native;
	import laya.webgl.resource.ICharRender;
	public class TextRender {
		//config
		public static var useOldCharBook:Boolean = false;
		public static var atlasWidth:int = 2048;
		public static var noAtlas:Boolean = false;				// 一串文字用独立贴图
		public static var forceSplitRender:Boolean = false;	    // 强制把一句话拆开渲染
		public static var forceWholeRender:Boolean = false; 	// 强制整句话渲染
		public static var scaleFontWithCtx:Boolean = true;		// 如果有缩放，则修改字体，以保证清晰度
		public static var standardFontSize:int = 32;			// 测量的时候使用的字体大小
		public static var destroyAtlasDt:int = 10;					// 回收图集贴图的时间
		public static var checkCleanTextureDt:int = 2000;		// 检查是否要真正删除纹理的时间。单位是ms
		public static var destroyUnusedTextureDt:int = 3000; 	// 长时间不用的纹理删除的时间。单位是ms
		public static var cleanMem:int = 100 * 1024 * 1024;		// 多大内存触发清理图集。这时候占用率低的图集会被清理
		public static var isWan1Wan:Boolean = false;
		public static var showLog:Boolean = false;
		public static var debugUV:Boolean = false;				// 文字纹理需要保护边。当像素没有对齐的时候，可能会采样到旁边的贴图。true则填充texture为白色，模拟干扰
		//config
		
		/**
		 * fontSizeInfo
		 * 记录每种字体的像素的大小。标准是32px的字体。由4个byte组成，分别表示[xdist,ydist,w,h]。 
		 * xdist,ydist 是像素起点到排版原点的距离，都是正的，表示实际数据往左和上偏多少，如果实际往右和下偏，则算作0，毕竟这个只是一个大概
		 * 例如 [Arial]=0x00002020, 表示宽高都是32
		 */
		private var fontSizeInfo:Object = { };	 
		public static var atlasWidth2:int = 2048 * 2048;
		private var charRender:ICharRender = null;
		private static var tmpRI:CharRenderInfo = new CharRenderInfo();
		private static var pixelBBX:Array = [0, 0, 0, 0];
		private var mapFont:Object = { };		// 把font名称映射到数字
		private var fontID:int = 0;
		
		private var mapColor:Array = [];		// 把color映射到数字
		private var colorID:int = 0;
		private var fontScaleX:Number = 1.0;						//临时缩放。
		private var fontScaleY:Number = 1.0;
		
		//private var charMaps:Object = {};	// 所有的都放到一起
		
		private var _curStrPos:int = 0;		//解开一个字符串的时候用的。表示当前解到什么位置了
		public static var textRenderInst:TextRender = null;	//debug
		
		public var textAtlases:Vector.<TextAtlas> = new Vector.<TextAtlas>();		// 所有的大图集
		private var isoTextures:Vector.<TextTexture> = new Vector.<TextTexture>();	// 所有的独立贴图
		
		private var bmpData32:Uint32Array;
		private static var imgdtRect:Array = [0, 0, 0, 0];
		
		// 当前字体的测量信息。
		private var lastFont:FontInfo = null;
		private var fontSizeW:int = 0;
		private var fontSizeH:int = 0;
		private var fontSizeOffX:int = 0;
		private var fontSizeOffY:int = 0;
		
		private var renderPerChar:Boolean = true;	// 是否是单个字符渲染。这个是结果，上面的是配置
		private var tmpAtlasPos:Point = new Point();
		private var textureMem:int = 0; 			// 当前贴图所占用的内存
		private var fontStr:String;					// 因为要去掉italic，所以自己保存一份
		public static var simClean:Boolean = false;				// 测试用。强制清理占用低的图集
		
		public function TextRender():void {
			var bugIOS:Boolean = false;//是否是有bug的ios版本
			//在微信下有时候不显示文字，所以采用canvas模式，现在测试微信好像都好了，所以去掉了。
			var miniadp:* = Laya['MiniAdpter'];
			if ( miniadp && miniadp.systemInfo && miniadp.systemInfo.system) {
				bugIOS = miniadp.systemInfo.system.toLowerCase() === 'ios 10.1.1';
			}
			if (Browser.onMiniGame /*&& !Browser.onAndroid*/ && !bugIOS ) isWan1Wan = true; //android 微信下 字边缘发黑，所以不用getImageData了
			if (Browser.onLimixiu) isWan1Wan = true;
			//isWan1Wan = true;
			charRender = Render.isConchApp ? (new CharRender_Native()) : (new CharRender_Canvas(atlasWidth,atlasWidth,scaleFontWithCtx,!isWan1Wan,false));			
			textRenderInst = this;
			Laya['textRender'] = this;
			atlasWidth2 = atlasWidth * atlasWidth;
			//TEST
			//forceSplitRender = true;
			//noAtlas = true;
			//forceWholeRender = true;
			//TEST
		}
		
		/**
		 * 设置当前字体，获得字体的大小信息。
		 * @param	font
		 */
		public function setFont(font:FontInfo):void {
			if (lastFont == font) return;
			lastFont = font;
			var fontsz:int = getFontSizeInfo(font._family);
			var offx:int = fontsz >> 24
			var offy:int = (fontsz >> 16) & 0xff;
			var fw:int = (fontsz >> 8) & 0xff;
			var fh:int = fontsz & 0xff;
			var k:Number = font._size / standardFontSize;
			fontSizeOffX = Math.ceil(offx * k);
			fontSizeOffY = Math.ceil(offy * k);
			fontSizeW = Math.ceil(fw * k);
			fontSizeH = Math.ceil(fh * k);
			fontStr = font._font.replace('italic', '');
		}
		
		/**
		 * 从string中取出一个完整的char，例如emoji的话要多个
		 * 会修改 _curStrPos
		 * TODO 由于各种文字中的组合写法，这个需要能扩展，以便支持泰文等
		 * @param	str
		 * @param	start	开始位置
		 */
		public function getNextChar(str:String):String {
			var len:int = str.length;
			var start:int = _curStrPos;
			if (start >= len)
				return null;
			
			var link:Boolean = false;	//如果是连接的话要再加一个完整字符
			var i:int = start;
			var state:int = 0; //0 初始化 1  正常 2 连续中
			for (; i < len; i++) {
				var c:int = str.charCodeAt(i);
				if ((c >>> 11) == 0x1b) { //可能是0b110110xx或者0b110111xx。 这都表示2个u16组成一个emoji
					if (state == 1) break;//新的字符了，要截断
					state = 1;	// 其他状态都转成正常读取字符状态，只是一次读两个
					i++;	//跨过一个。
				}
				else if (c === 0xfe0e || c === 0xfe0f) {	//样式控制字符
					// 继续。不改变状态
				}
				else if (c == 0x200d) {		//zero width joiner
					state = 2; 	// 继续
				}else {
					if (state == 0) state = 1;
					else if (state == 1) break;
					else if (state == 2) {
						// 继续
					}
				}
			}
			_curStrPos = i;
			return str.substring(start, i);
		}
		
		public function filltext(ctx:WebGLContext2D, data:String, x:Number, y:Number, fontStr:String, color:String, strokeColor:String, lineWidth:int, textAlign:String, underLine:int = 0):void {
			if (data.length <= 0)
				return;
			//以后保存到wordtext中
			var font:FontInfo = FontInfo.Parse(fontStr);
			
			var nTextAlign:int = 0;
			switch (textAlign) {
			case 'center': 
				nTextAlign = Context.ENUM_TEXTALIGN_CENTER;
				break;
			case 'right': 
				nTextAlign = Context.ENUM_TEXTALIGN_RIGHT;
				break;
			}
			_fast_filltext(ctx, data as WordText, null, x, y, font, color, strokeColor, lineWidth, nTextAlign, underLine);
		}
		
		public function fillWords(ctx:WebGLContext2D, data:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String, strokeColor:String, lineWidth:int):void {
			if (!data) return;
			if (data.length <= 0) return;
			var font:FontInfo = FontInfo.Parse(fontStr);
			_fast_filltext(ctx, null, data, x, y, font, color, strokeColor, lineWidth, 0, 0);
		}		
		
		public function _fast_filltext(ctx:WebGLContext2D, data:WordText, htmlchars:Vector.<HTMLChar>, x:Number, y:Number, font:FontInfo, color:String, strokeColor:String, lineWidth:int, textAlign:int, underLine:int = 0):void {
			if (data && data.length < 1) return;
			if (htmlchars && htmlchars.length < 1) return;
			if (lineWidth < 0) lineWidth = 0;
			setFont(font);
			fontScaleX = fontScaleY = 1.0;
			if (!Render.isConchApp && scaleFontWithCtx) {
				var sx:Number = 1;
				var sy:Number = 1;
				if (Render.isConchApp) {
					sx = ctx._curMat.getScaleX();
					sy = ctx._curMat.getScaleY();
				}else{
					sx = ctx.getMatScaleX();
					sy = ctx.getMatScaleY();
				}
				if (sx < 1e-4 || sy < 1e-1)
					return;
				if (sx > 1) fontScaleX = sx;
				if (sy > 1) fontScaleY = sy;
			}
			
			font._italic && (ctx._italicDeg = 13);
			//准备bmp
			//拷贝到texture上,得到一个gltexture和uv
			var wt:WordText = data as WordText;
			var isWT:Boolean = !htmlchars && (data is WordText);
			var str:String = data as String;
			var isHtmlChar:Boolean = !!htmlchars;
			/**
			 * sameTexData 
			 * WordText 中保存了一个数组，这个数组是根据贴图排序的，目的是为了能相同的贴图合并。
			 * 类型是 {ri:CharRenderInfo,stx:int,sty:int,...}[文字个数][贴图分组]
			 */
			var sameTexData:Array = isWT ? wt.pageChars : [];
			
			//总宽度，下面的对齐需要
			var strWidth:Number = 0;
			if (isWT) {
				str = wt._text;
				strWidth = wt.width;
				if (strWidth < 0) {
					strWidth = wt.width = charRender.getWidth(fontStr, str);	// 字符串长度是原始的。
				}
			} else {
				strWidth = str?charRender.getWidth(fontStr, str):0;
			}
			
			//水平对齐方式
			switch (textAlign) {
			case Context.ENUM_TEXTALIGN_CENTER: 
				x -= strWidth / 2;
				break;
			case Context.ENUM_TEXTALIGN_RIGHT: 
				x -= strWidth;
				break;
			}
			
			//检查保存的数据是否有的已经被释放了
			if (wt && sameTexData) {	// TODO 能利用lastGCCnt么
				//wt.lastGCCnt = _curPage.gcCnt;
				if (hasFreedText(sameTexData)) {
					sameTexData = wt.pageChars = [];
				}
			}			
			var ri:CharRenderInfo = null;
			var oneTex:Boolean = isWT || forceWholeRender;	// 如果能缓存的话，就用一张贴图
			var splitTex:Boolean = renderPerChar = (!isWT) || forceSplitRender || isHtmlChar || (isWT && wt.splitRender) ; 	// 拆分字符串渲染，这个优先级高
			if (!sameTexData || sameTexData.length < 1) {
				// 重新构建缓存的贴图信息
				// TODO 还是要ctx.scale么
				if ( splitTex ) {
					// 如果要拆分字符渲染
					var stx:int = 0;
					var sty:int = 0;
					
					_curStrPos = 0;
					var curstr:String;
					while(true){
						if (isHtmlChar) {
							var chc:HTMLChar = htmlchars[_curStrPos++];
							if(chc){
								curstr = chc.char;
								stx = chc.x;
								sty = chc.y;
							}else {
								curstr = null;
							}
						} else {
							curstr = getNextChar(str);
						}
						if (!curstr)
							break;
						ri = getCharRenderInfo(curstr, font, color, strokeColor, lineWidth, false);
						if (!ri) {
							// 没有分配到。。。
							break;
						}
						if (ri.isSpace) {	// 空格什么都不做
						} else {
							//分组保存
							var add:Array = sameTexData[ri.tex.id];
							if (!add) {
								sameTexData[ri.tex.id] = add = [];
							}
							//不能直接修改ri.bmpWidth, 否则会累积缩放，所以把缩放保存到独立的变量中
							if (Render.isConchApp){
								add.push( { ri: ri, x: stx, y: sty, w: ri.bmpWidth / fontScaleX, h: ri.bmpHeight / fontScaleY } );
							}else{
								add.push( { ri: ri, x: stx+1/fontScaleX, y: sty, w: (ri.bmpWidth-2) / fontScaleX, h: (ri.bmpHeight-1) / fontScaleY } );	// 为了避免边缘像素采样错误，内缩一个像素
							}
							stx += ri.width;	// TODO 缩放
						}
					}
					
				}else {
					// 如果要整句话渲染
					var isotex:Boolean = noAtlas || strWidth*fontScaleX > atlasWidth;	// 独立贴图还是大图集
					ri = getCharRenderInfo(str, font, color, strokeColor, lineWidth, isotex);
					// 整句渲染，则只有一个贴图
					if (Render.isConchApp){
						sameTexData[0] = [{ ri: ri, x: 0, y: 0, w: ri.bmpWidth / fontScaleX, h: ri.bmpHeight / fontScaleY }];
					}else{
						sameTexData[0] = [{ ri: ri, x: 1/fontScaleX, y: 0/fontScaleY, w: (ri.bmpWidth-2) / fontScaleX, h: (ri.bmpHeight-1) / fontScaleY }]; // 为了避免边缘像素采样错误，内缩一个像素
					}
				}
				
				//TODO getbmp 考虑margin 字体与标准字体的关系
			}
			
			_drawResortedWords(ctx, x, y, sameTexData);
			ctx._italicDeg = 0;
		}		
		
		/**
		 * 画出重新按照贴图顺序分组的文字。
		 * @param	samePagesData
		 * @param  startx 保存的数据是相对位置，所以需要加上这个偏移。用相对位置更灵活一些。
		 * @param y {int} 因为这个只能画在一行上所以没有必要保存y。所以这里再把y传进来
		 */
		protected function _drawResortedWords(ctx:WebGLContext2D, startx:int, starty:int, samePagesData:Array ):void {
			var isLastRender:Boolean = ctx._charSubmitCache && ctx._charSubmitCache._enbale;
			var mat:Matrix = ctx._curMat;
			for ( var id:String in samePagesData) {
				var pri:Array = samePagesData[id];
				var pisz:int = pri.length;  		if (pisz <= 0) continue;
				for (var j:int = 0; j < pisz; j++) {
					var riSaved:* = pri[j];
					var ri:CharRenderInfo = riSaved.ri;
					if (ri.isSpace) continue;
					ri.touch();
					ctx.drawTexAlign = true;
					//ctx._drawTextureM(ri.tex.texture as Texture, startx +riSaved.x -ri.orix / fontScaleX , starty + riSaved.y -ri.oriy / fontScaleY , riSaved.w, riSaved.h, null, 1.0, ri.uv);
					if (Render.isConchApp) {
						ctx._drawTextureM(ri.tex.texture as Texture, startx +riSaved.x -ri.orix , starty + riSaved.y -ri.oriy, riSaved.w, riSaved.h, null, 1.0, ri.uv);
					}else
						ctx._inner_drawTexture(ri.tex.texture as Texture, (ri.tex.texture as Texture).bitmap.id,
						startx +riSaved.x -ri.orix , starty + riSaved.y -ri.oriy, riSaved.w, riSaved.h, 
						mat, ri.uv, 1.0, isLastRender);
						
					if ((ctx as Object).touches) {
						(ctx as Object).touches.push(ri);
					}
				}
			}
			//不要影响别人
			//ctx._curSubmit._key.other = -1;
		}
		
		/**
		 * 检查 txts数组中有没有被释放的资源
		 * @param	txts {{ri:CharRenderInfo,...}[][]}
		 * @param	startid
		 * @return
		 */
		public function hasFreedText(txts:Array):Boolean {
			for (var i:String in txts) {
				var pri:* = txts[i];
				// TODO 能减少检测么
				for (var j:int = 0, pisz:int = pri.length; j < pisz; j++) {
					var riSaved:CharRenderInfo = (pri[j] as Object).ri;
					if (riSaved.deleted || riSaved.tex.__destroyed) {
						return true;
					}
				}
			}
			return false;
		}
				
		public function getCharRenderInfo(str:String, font:FontInfo, color:String, strokeColor:String, lineWidth:int, isoTexture:Boolean = false ):CharRenderInfo {
			var fid:* = mapFont[font._family];
			if (fid == undefined) {
				mapFont[font._family] = fid = fontID++;
			}
			/*
			var cid:int = mapColor[color];
			if (cid == undefined) {
				mapColor[color] = cid = colorID++;
			}
			var scid:int = mapColor[strokeColor];
			*/
			var key:String = str + '_' + fid + '_' +font._size + '_' + color;	
			if ( lineWidth > 0 )
				key += '_' + strokeColor + lineWidth;
			if ( font._bold)
				key += 'P';
			if (fontScaleX != 1 || fontScaleY != 1) {
				key += (fontScaleX*20|0) + '_' + (fontScaleY*20|0);	// 这个精度可以控制占用资源的大小，精度越高越能细分缩放。
			}
				
			var i:int = 0;
			// 遍历所有的大图集看是否存在
			var sz:int = textAtlases.length;
			var ri:CharRenderInfo = null;
			var atlas:TextAtlas = null;
			if(!isoTexture){
				for (i = 0; i < sz; i++) {
					 atlas = textAtlases[i];
					ri = atlas.charMaps[key]
					if (ri) {
						ri.touch();
						return ri;
					}
				}
			}
			// 没有找到，要创建一个
			ri = new CharRenderInfo();
			charRender.scale(fontScaleX, fontScaleY);
			ri.char = str;
			ri.height = font._size;
			var margin:int = font._size / 3 |0;	// 凑的。 注意这里不能乘以缩放，因为ctx会自动处理
			// 如果不存在，就要插入已有的，或者创建新的
			var imgdt:ImageData = null;
			// 先大约测量文字宽度 
			var w1:int = Math.ceil(charRender.getWidth(fontStr, str) * fontScaleX);
			if (w1 > charRender.canvasWidth) {
				charRender.canvasWidth = Math.min(2048, w1+ margin * 2);
			}
			if (isoTexture) {
				// 独立贴图
				imgdt = charRender.getCharBmp(str, fontStr, lineWidth, color, strokeColor, ri, margin, margin, margin, margin, null);
				// 这里可以直接
				var tex:TextTexture = TextTexture.getTextTexture(imgdt.width, imgdt.height);
				tex.addChar(imgdt, 0, 0, ri.uv);
				ri.tex = tex;
				ri.orix = margin ; // 这里是原始的，不需要乘scale,因为scale的会创建一个scale之前的rect
				ri.oriy = margin ;
				tex.ri = ri;
				isoTextures.push( tex );
			}else {
				// 大图集
				var len:int = str.length;
				if (len > 1) {
					// emoji或者组合的
				}					
				var lineExt:Number = lineWidth*1 ;	// 这里，包括下面的*2 都尽量用整数。否则在取整以后可能有有偏移。
				var fw:int = Math.ceil((fontSizeW+lineExt*2)*fontScaleX); 	//本来只要 lineWidth就行，但是这样安全一些
				var fh:int = Math.ceil((fontSizeH+lineExt*2)*fontScaleY);
				imgdtRect[0] = ((margin - fontSizeOffX-lineExt)*fontScaleX)|0;	// 本来要 lineWidth/2 但是这样一些尖角会有问题，所以大一点
				imgdtRect[1] = ((margin - fontSizeOffY-lineExt)*fontScaleY)|0;
				if ( renderPerChar||len==1) {
					// 单个字符的处理
					imgdtRect[2] = Math.max(w1, fw);
					imgdtRect[3] = Math.max(w1, fh);	// 高度也要取大的。 例如emoji
				}else {
					// 多个字符的处理
					imgdtRect[2] = -1;	// -1 表示宽度要测量
					imgdtRect[3] = fh; 	// TODO 如果被裁剪了，可以考虑把这个加大一点点
				}
				imgdt = charRender.getCharBmp(str, fontStr, lineWidth, color, strokeColor, ri, 
						margin, margin, margin, margin, imgdtRect);
				atlas = addBmpData(imgdt, ri);
				if (isWan1Wan) {
					// 这时候 imgdtRect 是不好使的，要自己设置
					ri.orix = margin;	// 不要乘缩放。要不后面也要除。
					ri.oriy = margin;
				}else {
					// 取下来的imagedata的原点在哪
					ri.orix = (fontSizeOffX+lineExt);	// 由于是相对于imagedata的，上面会根据包边调整左上角，所以原点也要相应反向调整
					ri.oriy = (fontSizeOffY+lineExt);
				}
				atlas.charMaps[key] = ri;
			}
			return ri;
		}
		
		/**
		 * 添加数据到大图集
		 * @param	w
		 * @param	h
		 * @return
		 */
		public function addBmpData(data:ImageData, ri:CharRenderInfo):TextAtlas {
			var w:int = data.width;
			var h:int = data.height;
			var sz:int = textAtlases.length;
			var atlas:TextAtlas = null;
			var find:Boolean = false;
			for (var i:int = 0; i < sz; i++) {
				atlas = textAtlases[i];
				find = atlas.getAEmpty(w, h, tmpAtlasPos);
				if (find) {
					break;
				}
			}
			if (!find) {
				// 创建一个新的
				atlas = new TextAtlas()
				textAtlases.push(atlas);
				find = atlas.getAEmpty(w, h, tmpAtlasPos);
				if (!find) {
					throw 'err1'; //TODO
				}
				// 清理旧的
				cleanAtlases();
			}
			if(find){
				atlas.texture.addChar(data, tmpAtlasPos.x, tmpAtlasPos.y, ri.uv);
				ri.tex = __JS__('atlas.texture');
			}
			return atlas;
		}
		
		public function GC(force:Boolean):void {
			var i:int = 0;
			var sz:int = textAtlases.length;
			var dt:int = 0;
			var destroyDt:int = destroyAtlasDt;	
			var totalUsedRate:Number = 0;	// 总使用率
			var totalUsedRateAtlas:Number = 0;
			
			//var minUsedRateID:int = -1;
			//var minUsedRate:Number = 1;
			var maxWasteRateID:int =-1;
			var maxWasteRate:Number = 0;
			var tex:TextTexture = null;
			var curatlas:TextAtlas = null;
			for (; i < sz; i++) {
				curatlas = textAtlases[i];
				tex = curatlas.texture;
				if (tex) {
					totalUsedRate+= tex.curUsedCovRate;
					totalUsedRateAtlas += tex.curUsedCovRateAtlas;
					var waste:Number = curatlas.usedRate-tex.curUsedCovRateAtlas; // 已经占用的图集和当前使用的图集的差
					if (maxWasteRate < waste) {
						maxWasteRate = waste;
						maxWasteRateID = i;
					}
					/*
					if (minUsedRate > tex.curUsedCovRate) {
						minUsedRate = tex.curUsedCovRate;
						minUsedRateID = i;
					}
					*/
				}
				dt = Stat.loopCount - curatlas.texture.lastTouchTm;
				if (dt > destroyDt) {
					showLog && console.log('TextRender GC delete atlas ' + tex?curatlas.texture.id:'unk');
					curatlas.destroy();
					textAtlases[i] = textAtlases[sz - 1];	// 把最后的拿过来冲掉
					sz--;
					i--;
				}
			}
			textAtlases.length = sz;
			
			// 独立贴图的清理 TODO 如果多的话，要不要分开处理
			sz = isoTextures.length;
			for (i = 0; i < sz; i++) {
				tex = isoTextures[i];
				dt = Stat.loopCount - tex.lastTouchTm;
				if ( dt > destroyUnusedTextureDt) {
					tex.ri.deleted = true;
					tex.ri.tex = null;
					tex.destroy();
					isoTextures[i] = isoTextures[sz - 1];
					sz--;
					i--;
				}
			}
			
			// 如果超出内存需要清理不常用
			var needGC:Boolean = textAtlases.length > 1 && textAtlases.length - totalUsedRateAtlas >= 2;	// 总量浪费了超过2张
			if ( atlasWidth * atlasWidth * 4 * textAtlases.length > cleanMem || needGC || simClean) {
				simClean = false;
				showLog && console.log('清理使用率低的贴图。总使用率:', totalUsedRateAtlas, ':', textAtlases.length, '最差贴图:' + maxWasteRateID);
				if(maxWasteRateID>=0){
					curatlas = textAtlases[maxWasteRateID];
					curatlas.destroy();
					textAtlases[maxWasteRateID] = textAtlases[textAtlases.length - 1];
					textAtlases.length = textAtlases.length - 1;
				}
			}
			
			TextTexture.clean();
		}
		
		/**
		 * 尝试清理大图集
		 */
		public function cleanAtlases():void {
			// TODO 根据覆盖率决定是否清理
		}
		
		public function getCharBmp(c:String):*{
			
		}
		
		/**
		 * 检查当前线是否存在数据
		 * @param	data
		 * @param	l
		 * @param	sx
		 * @param	ex
		 * @return
		 */
		private function checkBmpLine(data:ImageData, l:int, sx:int, ex:int):Boolean {
			if (bmpData32.buffer != data.data.buffer) {
				bmpData32 = new Uint32Array(data.data.buffer);
			}
			var stpos:int = data.width * l + sx;
			for (var x:int=sx ; x < ex; x++) {
				if (bmpData32[stpos++] != 0) return true;
			}
			return false;
		}
		
		/**
		 * 根据bmp数据和当前的包围盒，更新包围盒
		 * 由于选择的文字是连续的，所以可以用二分法
		 * @param	data
		 * @param	curbbx 	[l,t,r,b]
		 * @param   onlyH 不检查左右
		 */
		private function updateBbx(data:ImageData, curbbx:Array, onlyH:Boolean=false):void {
			var w:int = data.width;
			var h:int = data.height;
			var x:int = 0;
			// top
			var sy:int = curbbx[1];	//从t到0 sy表示有数据的行
			var ey:int = 0;
			var y:int = sy;
			if (checkBmpLine(data, sy, 0, w)) {
				// 如果当前行有数据，就要往上找
				while (true) {
					y = (sy + ey) / 2 | 0;	// 必须是int
					if (y + 1 >= sy) {// 
						// 找到了。严格来说还不知道这个是否有像素，不过这里要求不严格，可以认为有
						curbbx[1] = y;
						break;
					}
					if(checkBmpLine(data, y, 0, w)){
						//中间线有数据，搜索上半部分
						sy = y;
					}else {
						//中间线没有有数据，搜索下半部分
						ey = y;
					}
				}
			}
			// 下半部分
			if ( curbbx[3] > h) curbbx[3] = h;
			else{
				y = sy = curbbx[3];
				ey = h;
				if (checkBmpLine(data, sy, 0, w)) {
					while(true){
						y = (sy + ey) / 2 | 0;
						if (y - 1 <= sy) {
							curbbx[3] = y;
							break;
						}
						if (checkBmpLine(data, y, 0, w)) {
							sy = y;
						}else {
							ey = y;
						}
					}
				}
			}
			
			if (onlyH)
				return;
				
			// 左半部分
			var minx:int = curbbx[0];
			var stpos:int = w*curbbx[1]; //w*cy+0
			for (y = curbbx[1]; y < curbbx[3]; y++) {
				for ( x = 0; x < minx; x++) {
					if (bmpData32[stpos + x] != 0) {
						minx = x;
						break;
					}
				}
				stpos += w;
			}
			curbbx[0] = minx;
			// 右半部分
			var maxx:int = curbbx[2];
			stpos = w*curbbx[1]; //w*cy
			for (y = curbbx[1]; y < curbbx[3]; y++) {
				for ( x = maxx; x < w; x++) {
					if (bmpData32[stpos + x] != 0) {
						maxx = x;
						break;
					}
				}
				stpos += w;
			}
			curbbx[2] = maxx;
		}
		
		public function getFontSizeInfo(font:String):int {
			var finfo:* = fontSizeInfo[font];
			if (finfo != undefined)
				return finfo;
				
			var fontstr:String = 'bold ' + standardFontSize+'px ' + font;
			if (isWan1Wan) {
				// 这时候无法获得imagedata，只能采取保险测量
				fontSizeW = charRender.getWidth(fontstr, '有') * 1.5;
				fontSizeH = standardFontSize * 1.5;
				var szinfo:int = fontSizeW << 8 | fontSizeH;
				fontSizeInfo[font] = szinfo;
				return szinfo;
			}
			// bbx初始大小
			pixelBBX[0] = standardFontSize / 2;// 16;
			pixelBBX[1] = standardFontSize / 2;// 16;
			pixelBBX[2] = standardFontSize;// 32;
			pixelBBX[3] = standardFontSize;// 32;
			
			var orix:int = 16;		// 左边留白，也就是x原点的位置
			var oriy:int = 16;
			var marginr:int = 16;
			var marginb:int = 16;
			charRender.scale(1, 1);
			tmpRI.height = standardFontSize;
			var bmpdt:ImageData = charRender.getCharBmp('g', fontstr, 0, 'red', null, tmpRI, orix, oriy, marginr, marginb);
			// native 返回的是 textBitmap。 data直接是ArrayBuffer 
			if (Render.isConchApp) {
				//bmpdt.data.buffer = bmpdt.data;
				bmpdt.data =  new __JS__("Uint8ClampedArray(bmpdt.data)");
			}
			bmpData32 = new Uint32Array(bmpdt.data.buffer);
			//测量宽度是 tmpRI.width
			updateBbx(bmpdt, pixelBBX, false);
			bmpdt = charRender.getCharBmp('有', fontstr, 0, 'red', null, tmpRI, oriy, oriy, marginr, marginb);// '有'比'国'大
			if (Render.isConchApp) {
				//bmpdt.data.buffer = bmpdt.data;
				bmpdt.data = new __JS__("Uint8ClampedArray(bmpdt.data)");
			}
			bmpData32 = new Uint32Array(bmpdt.data.buffer);
			// 国字的宽度就用系统测量的，不再用像素检测
			if (pixelBBX[2] < orix+tmpRI.width)
				pixelBBX[2] = orix+tmpRI.width;
			updateBbx(bmpdt, pixelBBX,false);//TODO 改成 true
			// 原点在 16,16
			if (Render.isConchApp) {
				//runtime 的接口好像有问题，不认orix，oriy
				orix = 0;
				oriy = 0;
			}
			var xoff:int = Math.max( orix - pixelBBX[0], 0);
			var yoff:int = Math.max( oriy - pixelBBX[1], 0);
			var bbxw:int = pixelBBX[2] - pixelBBX[0];
			var bbxh:int = pixelBBX[3] - pixelBBX[1];
			var sizeinfo:int = xoff<<24 |yoff<<16 | bbxw << 8 | bbxh;
			fontSizeInfo[font] = sizeinfo;
			return sizeinfo;
		}
		
		public function printDbgInfo():void {
			console.log('图集个数:' + textAtlases.length + ',每个图集大小:' + atlasWidth + 'x' + atlasWidth,' 用canvas:', isWan1Wan);
			console.log('图集占用空间:' + (atlasWidth * atlasWidth * 4 / 1024 / 1024 * textAtlases.length) + 'M');
			console.log('缓存用到的字体:');
			for (var f:String in mapFont) {
				var fontsz:int = getFontSizeInfo(f);
				var offx:int = fontsz >> 24
				var offy:int = (fontsz >> 16) & 0xff;
				var fw:int = (fontsz >> 8) & 0xff;
				var fh:int = fontsz & 0xff;
				console.log('    ' + f,' off:',offx,offy,' size:',fw,fh);
			}
			var num:int = 0;
			console.log('缓存数据:');
			var totalUsedRate:Number = 0;	// 总使用率
			var totalUsedRateAtlas:Number = 0;
			textAtlases.forEach(function(a:TextAtlas):void { 
				var id:int = a.texture.id;
				var dt:int = Stat.loopCount - a.texture.lastTouchTm
				var dtstr:String = dt > 0?('' + dt + '帧以前'):'当前帧';
				totalUsedRate+= a.texture.curUsedCovRate;
				totalUsedRateAtlas += a.texture.curUsedCovRateAtlas;
				console.log('--图集(id:' + id + ',当前使用率:'+(a.texture.curUsedCovRate*1000|0)+'‰','当前图集使用率:',(a.texture.curUsedCovRateAtlas*100|0)+'%','图集使用率:',(a.usedRate*100|0),'%, 使用于:'+dtstr+')--:');
				for (var k:String in a.charMaps) {
					var ri:CharRenderInfo = a.charMaps[k];
					console.log('     off:',ri.orix,ri.oriy,' bmp宽高:', ri.bmpWidth, ri.bmpHeight, '无效:', ri.deleted, 'touchdt:', (Stat.loopCount-ri.touchTick), '位置:', ri.uv[0] * atlasWidth | 0, ri.uv[1] * atlasWidth | 0,
					'字符:',ri.char, 'key:', k );
					num++;
				}
			} );
			console.log('独立贴图文字('+isoTextures.length+'个):');
			isoTextures.forEach(function(tex:TextTexture):void { 
				console.log('    size:',tex._texW,tex._texH, 'touch间隔:',(Stat.loopCount-tex.lastTouchTm), 'char:', tex.ri.char);
			} );
			console.log('总缓存:', num, '总使用率:',totalUsedRate,'总当前图集使用率:',totalUsedRateAtlas);
			
		}
		
		// 在屏幕上显示某个大图集
		public function showAtlas(n:int, bgcolor:String, x:int, y:int, w:int, h:int):Sprite {
			if (!textAtlases[n]) {
				console.log('没有这个图集');
				return null;
			}
			
			var sp:Sprite = new Sprite();
			var texttex:TextTexture = textAtlases[n].texture;
			var texture:Object = { 
				width:atlasWidth,
				height:atlasWidth,
				sourceWidth:atlasWidth,
				sourceHeight:atlasWidth,
				offsetX:0,
				offsetY:0,
				getIsReady:function():Boolean { return true; },
				_addReference:function():void { },
				_removeReference:function():void{},
				_getSource:function():* {  return texttex._getSource(); },
				bitmap: { id:texttex.id },
				_uv:Texture.DEF_UV
			};
			(sp as Object).size = function(w:Number, h:Number):Sprite {
				this.width = w;
				this.height = h;
				sp.graphics.clear();
				sp.graphics.drawRect(0, 0, sp.width, sp.height, bgcolor);
				sp.graphics.drawTexture(texture as Texture, 0, 0, sp.width, sp.height);
				return this as Sprite;
			}
			sp.graphics.drawRect(0, 0, w, h, bgcolor);
			sp.graphics.drawTexture(texture as Texture, 0, 0, w, h);
			sp.pos(x, y);
			Laya.stage.addChild(sp);
			return sp;
		}
		
		/////// native ///////
		public function filltext_native(ctx:WebGLContext2D, data:String, htmlchars:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String, strokeColor:String, lineWidth:int, textAlign:String, underLine:int = 0):void {
			if (data && data.length <= 0) return;
			if (htmlchars && htmlchars.length < 1) return;			
			
			var font:FontInfo = FontInfo.Parse(fontStr);
			
			var nTextAlign:int = 0;
			switch (textAlign) {
			case 'center': 
				nTextAlign = Context.ENUM_TEXTALIGN_CENTER;
				break;
			case 'right': 
				nTextAlign = Context.ENUM_TEXTALIGN_RIGHT;
				break;
			}
			return _fast_filltext(ctx, data as WordText, htmlchars, x, y, font, color, strokeColor, lineWidth, nTextAlign, underLine);
		}
	}
}	