package laya.qg.mini {
	import laya.display.Input;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.media.SoundManager;
	import laya.renders.Render;
	import laya.utils.Browser;
	
	/** @private **/
	public class MiniInput {
		public function MiniInput() {
		}
		
		private static function _createInputElement():void {
			Input['_initInput'](Input['area'] = Browser.createElement("textarea"));
			Input['_initInput'](Input['input'] = Browser.createElement("input"));
			
			Input['inputContainer'] = Browser.createElement("div");
			Input['inputContainer'].style.position = "absolute";
			Input['inputContainer'].style.zIndex = 1E5;
			Browser.container.appendChild(Input['inputContainer']);
			//[IF-SCRIPT] Input['inputContainer'].setPos = function(x:int, y:int):void { Input['inputContainer'].style.left = x + 'px'; Input['inputContainer'].style.top = y + 'px'; };
			
			Laya.stage.on("resize", null, _onStageResize);
			
			QGMiniAdapter.window.qg.onWindowResize && QGMiniAdapter.window.qg.onWindowResize(function(res:*):void {
				QGMiniAdapter.window.dispatchEvent && QGMiniAdapter.window.dispatchEvent("resize");
			});
			
			//替换声音
			SoundManager._soundClass = MiniSound;
			SoundManager._musicClass = MiniSound;
			
			//运行环境判断
			var model:String= QGMiniAdapter.systemInfo.model;
			var system:String = QGMiniAdapter.systemInfo.system;
			if(model && model.indexOf("iPhone") != -1)
			{
				Browser.onIPhone = true;
				Browser.onIOS = true;
				Browser.onIPad = true;
				Browser.onAndroid = false;
			}
			if(system && (system.indexOf("Android") != -1 || system.indexOf("Adr") != -1))
			{
				Browser.onAndroid = true;
				Browser.onIPhone = false;
				Browser.onIOS = false;
				Browser.onIPad = false;
			}
		}
		
		private static function _onStageResize():void {
			//var ts:Matrix = Laya.stage._canvasTransform.identity();
			//ts.scale((Browser.width / Render.canvas.width / Browser.pixelRatio), Browser.height / Render.canvas.height / Browser.pixelRatio);
		}
		
		public static function wxinputFocus(e:*):void {
			var _inputTarget:* = Input['inputElement'].target;
			if (_inputTarget && !_inputTarget.editable) {
				return;//非输入编辑模式
			}
			QGMiniAdapter.window.qg.offKeyboardConfirm();
			QGMiniAdapter.window.qg.offKeyboardInput();
			QGMiniAdapter.window.qg.showKeyboard({defaultValue: _inputTarget.text, maxLength: _inputTarget.maxChars, multiple: _inputTarget.multiline, confirmHold: true, confirmType: _inputTarget["confirmType"]||'done', success: function(res:*):void {
			}, fail: function(res:*):void {
			}});
			
			QGMiniAdapter.window.qg.onKeyboardConfirm(function(res:*):void {
				var str:String = res ? res.value : "";
				// 对输入字符进行限制
				if (_inputTarget._restrictPattern) {
					// 部分输入法兼容
					str = str.replace(/\u2006|\x27/g, "");
					if (_inputTarget._restrictPattern.test(str)) {
						str = str.replace(_inputTarget._restrictPattern, "");
					}
				}
				_inputTarget.text = str;
				_inputTarget.event(Event.INPUT);
				MiniInput.inputEnter();
				_inputTarget.event("confirm");
			})
			QGMiniAdapter.window.qg.onKeyboardInput(function(res:*):void {
				var str:String = res ? res.value : "";
				if (!_inputTarget.multiline) {
					if (str.indexOf("\n") != -1) {
						MiniInput.inputEnter();
						return;
					}
				}
				// 对输入字符进行限制
				if (_inputTarget._restrictPattern) {
					// 部分输入法兼容
					str = str.replace(/\u2006|\x27/g, "");
					if (_inputTarget._restrictPattern.test(str)) {
						str = str.replace(_inputTarget._restrictPattern, "");
					}
				}
				_inputTarget.text = str;
				_inputTarget.event(Event.INPUT);
			});
		}
		
		public static function inputEnter():void {
			Input['inputElement'].target.focus = false;
		}
		
		public static function wxinputblur():void {
			hideKeyboard();
		}
		
		public static function hideKeyboard():void {
			QGMiniAdapter.window.qg.offKeyboardConfirm();
			QGMiniAdapter.window.qg.offKeyboardInput();
			QGMiniAdapter.window.qg.hideKeyboard({success: function(res:*):void {
				console.log('隐藏键盘')
			}, fail: function(res:*):void {
				console.log("隐藏键盘出错:" + (res ? res.errMsg : ""));
			}});
		}
	}
}