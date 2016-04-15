package laya.ani.swf {
	import laya.display.Sprite;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Byte;
	/**
	 * ...
	 * @author laya
	 */
	public class MovieClip extends Sprite {
		protected static var _ValueList:Array = /*[STATIC SAFE]*/ ["x", "y", "width", "height", "scaleX", "scaleY", "rotation", "alpha"];
		public var interval:int = 30;
		/**
		 * 数据起始位置
		 */
		protected var _start:int = 0;
		/**
		 * 当前位置
		 */
		protected var _Pos:int = 0;
		/**
		 * 数据
		 */
		protected var _data:Byte;
		/**
		 * 当前帧
		 */
		protected var _curIndex:int;
		protected var _playIndex:int;
		protected var _playing:Boolean;
		protected var _ended:Boolean = true;
		/**
		 * 总帧数
		 */
		protected var _frameCount:int;
		/**
		 * id_data起始位置表
		 */
		public var _ids:Object;
		/**
		 * id_实例表
		 */
		public var _idOfSprite:Array;
		/**
		 * 资源根目录
		 */
		public var basePath:String;
		
		public function MovieClip() {
			_ids = {};
			_idOfSprite = [];
			_reset();
			_playing = false;
		}
		
		public function get currentFrame():int {
			return _curIndex;
		}
		
		public function get totalFrames():int {
			return _frameCount;
		}
		
		public function update():void {
			if (!_data) return;
			if (!_playing)
				return;
			_playIndex++;
			_parse(_playIndex);
		}
		
		public function stop():void {
			_playing = false;
			Laya.timer.clear(this, update);
		}
		
		public function gotoStop(frame:int):void {
			play(frame);
			stop();
		}
		
		public function clear():void
		{
			_idOfSprite.length = 0;
			removeChildren();
			graphics = null;
		}
		
		public function play(frameIndex:int = -1):void {
			if (frameIndex != -1) {
				if (_curIndex > frameIndex)
					_reset();
				if (frameIndex != _curIndex)
					_parse(frameIndex);
			}
			_playing = true;
			//这里有问题吧》阿欢，如果已经在播如何办?
			Laya.timer.loop(this.interval, this, update, null, true);
		}
		
		private function _reset(rm:Boolean = true):void {
			if (rm && _curIndex != 1)
				this.removeChildren();
			_curIndex = -1;
			_playIndex = -1;
			_Pos = _start;
		}
		
		private function _parse(frameIndex:int):void {
			var curChild:Sprite = this;
			var mc:MovieClip, sp:Sprite, key:int, type:int, tPos:int, ttype:int, ifAdd:Boolean = false;
			var _idOfSprite:Array = this._idOfSprite, _data:Byte = this._data, eStr:String;
			if (_ended)
				_reset();
			_data.pos = _Pos;
			_ended = false;
			_playIndex = frameIndex;
			while ((_curIndex <= frameIndex) && (!_ended)) {
				type = _data.getUint16();
				switch (type) {
				case 12: //new MC
					key = _data.getUint16();
					tPos = _ids[_data.getUint16()];
					_Pos = _data.pos;
					_data.pos = tPos;
					if ((ttype = _data.getUint8()) == 0) {
						var pid:int = _data.getUint16();
						sp = _idOfSprite[key]
						if (!sp) {
							sp = _idOfSprite[key] = new Sprite();
							//								todo：优化方向
							//								sp.setSize(_data.getFloat32(),_data.getFloat32());
							//								var mat:Matrix=_data._getMatrix();
							//								sp.loadImage(basePath+pid+".png",mat);
							
							var spp:Sprite = new Sprite();
							spp.loadImage(basePath + pid + ".png");
							sp.addChild(spp);
							spp.size(_data.getFloat32(), _data.getFloat32());
							var mat:Matrix = _data._getMatrix();
							spp.x = mat.tx;
							spp.y = mat.ty;
							mat.tx = mat.ty = 0;
							spp.transform = mat;
								//								sp.name="n"+key;
						}
					} else if (ttype == 1) {
						mc = _idOfSprite[key]
						if (!mc) {
							_idOfSprite[key] = mc = new MovieClip();
							mc.interval = interval;
							mc._ids = _ids;
							mc._setData(_data, tPos);
							mc.basePath = basePath;
							mc.play(0);
								//								mc.name="n"+key;
						}
					}
					_data.pos = _Pos;
					break;
				case 3: //addChild
					(addChild(_idOfSprite[ /*key*/_data.getUint16()]) as Sprite).zOrder = _data.getUint16();
					ifAdd = true;
					break;
				case 4: //remove
					_idOfSprite[ /*key*/_data.getUint16()].removeSelf();
					break;
				case 5: //setValue
					_idOfSprite[_data.getUint16()][_ValueList[_data.getUint16()]] = (_data.getFloat32());
					break;
				case 6: //visible
					_idOfSprite[_data.getUint16()].visible = ( /*visible*/_data.getUint8() > 0);
					break;
				case 7: //SetTransform
					sp = _idOfSprite[ /*key*/_data.getUint16()]; //.transform=mt;
					var mt:Matrix = new Matrix(_data.getFloat32(), _data.getFloat32(), _data.getFloat32(), _data.getFloat32(), _data.getFloat32(), _data.getFloat32());
					sp.x = mt.tx;
					sp.y = mt.ty;
					mt.tx = mt.ty = 0;
					sp.transform = mt;
					break;
				case 8: //pos
					_idOfSprite[_data.getUint16()].setPos(_data.getFloat32(), _data.getFloat32());
					break;
				case 9: //size
					_idOfSprite[_data.getUint16()].setSize(_data.getFloat32(), _data.getFloat32());
					break;
				case 10: //alpha
					_idOfSprite[ /*key*/_data.getUint16()].alpha = /*alpha*/ _data.getFloat32();
					break;
				case 11: //scale
					_idOfSprite[_data.getUint16()].setScale(_data.getFloat32(), _data.getFloat32());
					break;
				case 98: //event		
					eStr = _data.getString();
					event(eStr);
					if (eStr == "stop")
						stop();
					break;
				case 99: //FrameBegin
					
					_curIndex = _data.getUint16();
					ifAdd && this.updateOrder();
					_playing && event(Event.ENTER_FRAME);
					break;
				case 100: //cmdEnd
					_frameCount = _curIndex + 1;
					_ended = true;
					event(Event.END);
					_reset(false);
					
					break;
				}
			}
			_Pos = _data.pos;
		}
		
		public function _setData(data:Byte, start:int):void {
			_data = data;
			_start = start + 3;
		}
		
		public function set skin(path:String):void
		{
			load(path);
		}
		public function load(url:String):void {
			url = URL.formatURL(url);
			
			basePath = url.replace(".swf", "/image/");
			var data:* = Loader.getRes(url);
			if (data) {
				initData(data);
			} else {
				var l:Loader = new Loader();
				l.once(Event.COMPLETE, null, function(data:*):void {
					initData(data);
				});
				l.once(Event.ERROR, null, function(err:String):void {
					//
				});
				l.load(url, Loader.BUFFER);
			}
		}
		
		private function initData(data:*):void {
			_data = new Byte(data);
			var i:int, len:int = _data.getUint16();
			for (i = 0; i < len; i++)
				_ids[_data.getInt16()] = _data.getInt32();
			interval = 1000 / _data.getUint16();
			_setData(_data, _ids[32767]);
			
			_reset();
			_ended = false;
			while (!_ended) _parse(++_playIndex);
			play(0);
			event(Event.LOADED);
		
		}
	}
}