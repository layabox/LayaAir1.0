 package laya.webgl.resource {
	 /**
	  * 包含了很多字符的一个texture。
	  * 由于字体的对比比较费劲，因此一个page只是一个字体的
	  * TODO 这个加到资源中，占用内存算到资源里
	  */
	 import laya.maths.Point;
	 import laya.renders.Render;
	 import laya.layagl.LayaGL;
	 import laya.resource.Resource;
	 import laya.webgl.WebGL;
	 import laya.webgl.WebGLContext;
	 import laya.webgl.canvas.WebGLContext2D;
	 public class CharPageTexture extends Resource {
		//假装自己是一个Texture对象
		public var texture:CharInternalTexture;
		
		 public var _source:*;
		 //格子的使用状态。使用的为1
		 private var _used:Uint8Array ;			
		 private var _startFindPos:int = 0;		//维护一个可能为空的位置，避免每次从头找
		 //private var _mgr:CharPages;
		 private var _texW:int = 0;
		 private var _texH:int = 0;
		 private var _gridNum:int = 0;
		 /**
		  * charMaps 最多有16个，表示在与basesize的距离。每个元素是一个Object,里面保存了具体的ChareRenderInfo信息，key是 str+color+bold
		  */
		 public var charMaps:Vector.<Map> = ([] as Vector.<Map>);		
		 public var ArrCharRenderInfo:Vector.<CharRenderInfo> = new Vector.<CharRenderInfo>();		//保存在这里比较方便
		 //public var charMap:*= { };				//本页保存的文字信息
		 public var _score:int = 0;				//本帧使用的文字的个数
		 public var _scoreTick:int = 0;			//_score是哪一帧计算的
		 public var __destroyed:Boolean = false;	//父类有，但是private
		 public var _discardTm:Number = 0;			//释放的时间。超过一定时间会被真正删除
		 public var genID:int = 0; 				// 这个对象会重新利用，为了能让引用他的人知道自己引用的是否有效，加个id
		/**
		 * 找一个空余的格子。
		 * @return
		 */
		public function findAGrid():CharRenderInfo {
			//var gridNum:int = _mgr._gridNum;
			for ( var i:int = _startFindPos; i < _gridNum; i++) {
				if (_used[i] == 0){
					_startFindPos = i + 1;
					_used[i] = 1;
					var ri:CharRenderInfo = ArrCharRenderInfo[i] = new CharRenderInfo();
					ri.tex = this;
					ri.pos=i;
					return ri;
				}
			}
			return null;
		}
		 
		//TODO:coverage
		private function removeGrid(pos:int):void {
			if(ArrCharRenderInfo[pos]){
				// 设成删除，这样使用这个的人就能判断出失效
				ArrCharRenderInfo[pos].deleted = true;
			}
			_used[pos] = 0;
			if (pos < _startFindPos)
				_startFindPos = pos;
		}
		
		/**
		 * 把tm之前使用的都去掉。
		 * @param	tm
		 * @return
		 */
		//TODO:coverage
		public function removeOld(tm:int):int {
			var num:int = 0;
			var charMap:Map= null;
			for (var i:int = 0, sz:int = charMaps.length; i < sz; i++) {
				charMap = charMaps[i];
				if (!charMap) continue;
				var me:CharPageTexture = this;
				charMap.forEach(function(v:CharRenderInfo, k:String, m:Map):void { 
					if (v) {
						if (v.touchTick < tm) {
							console.log('remove char ' + k);
							me.removeGrid(v.pos);
							__JS__('m.delete(k);');
							num++;
						}
					}
				} );
			}
			return num;
		}	
		 
		 public function CharPageTexture(textureW:int, textureH:int, gridNum:int) {
			 super();
			 //_mgr = mgr;
			 _texW = textureW;
			 _texH = textureH;
			 _gridNum = gridNum;
			 texture = new CharInternalTexture(this);
			 setGridNum(gridNum);
			 lock = true;
			 // _used 后面有人请求的时候再处理
		 }
		 
		 public function reset():void {
			_discardTm = Laya.stage.getFrameTm();
			_startFindPos = 0;
			charMaps = ([] as Vector.<Map>);
			_score = 0;
			_scoreTick = 0;
			__destroyed = true;		//表示已经失效了，CharBook中使用的时候，会根据这个来判断是会否还能使用缓存的数据。
			ArrCharRenderInfo.forEach(function(v:CharRenderInfo):void{v.deleted=true;});
		 }
		 
		 public function setGridNum(gridNum:int):void {
			 _gridNum = gridNum;
			if (!_used || _used.length != _gridNum) {
				_used = new Uint8Array(gridNum);//以后再考虑换成每个bit表示
			}else {
				if ((_used as Object).fill) (_used as Object).fill(0);
				else {
					for (var i:int = 0; i < _used.length; i++) _used[i] = 0;
				}
			}	
		 }
		 
		 public function recreateResource():void {
			if (_source)
				return;
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			texture.bitmap._glTexture = _source;
			
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTex);
			//gl.bindTexture(WebGLContext.TEXTURE_2D, glTex);
			//var sz:int = _width * _height * 4;
			//分配显存。
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _texW, _texH, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, null);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);	//不能用点采样，否则旋转的时候，非常难看
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			
			//TODO 预乘alpha
		 }
		 
		 
		/**
		 * 
		 * @param	data
		 * @param	x			拷贝位置。
		 * @param	y
		 */
		 public function addChar(data:ImageData, x:int, y:int):void {
			 if (CharBook.isWan1Wan) {
				 addCharCanvas(data , x, y);
				return; 
			 }
			!_source && recreateResource();
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true);
			var dt:* = data.data;
			if ( __JS__('data.data instanceof Uint8ClampedArray') ) 
				dt = new Uint8Array(dt.buffer);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, x, y, data.width, data.height, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, dt);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false);
		 }
		 
		 /**
		  * 玩一玩不支持 getImageData
		  * @param	canv
		  * @param	x
		  * @param	y
		  */
		 public function addCharCanvas(canv:Object, x:int, y:int):void {
			!_source && recreateResource();
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, x, y, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, canv);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false);
		 }
		 
		 //TODO:coverage
		override public function destroy():void {		
			console.log('destroy CharPageTexture');
			__destroyed = true;
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			_source && gl.deleteTexture(_source);
			_source = null;
			ArrCharRenderInfo.forEach(function(v:CharRenderInfo):void{v.deleted=true;});
		}

		public function touchRect(ri:CharRenderInfo, curloop:int):void {
			if(_scoreTick!=curloop){	// 新的一帧，新的得分
				_score = 0;					
				_scoreTick = curloop;
			}
			_score++;
		}
		
		/**
		 * 打印调试相关的关键信息
		 */
		public function printDebugInfo(detail:Boolean = false ):void {
			console.log('。得分:', _score, ', 算分时间:', _scoreTick, ',格子数:', _gridNum);
			//所有的字符
			var gridw:int = Math.sqrt(_gridNum);
			var num:int = 0;
			for (var i:int = 0, sz:int = charMaps.length; i < sz; i++) {
				var charMap:Map = charMaps[i];
				if (!charMap) continue;
				var me:CharPageTexture = this;
				var data:String = '';
				if (detail) {
					console.log('   与基本大小差'+i+'的map信息:');
				}
				charMap.forEach(function(v:CharRenderInfo, k:String, m:Map):void { 
					if (v) {
						if (detail) {
							console.log(
							'      key:', k, 
							//' 颜色:', ,
							//' 缩放:','unk',
							' 位置:', (v.pos / gridw) | 0, (v.pos % gridw) | 0, 
							' 宽高:', v.bmpWidth, v.bmpHeight, 
							' 是否删除:', v.deleted, 
							' touch时间:',v.touchTick);
						}else
							data+=k;
					}
				} );
				if(!detail)
					console.log('data[',i,']:',data);
			}
		}
	 }
 } 