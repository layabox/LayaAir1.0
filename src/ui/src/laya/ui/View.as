package laya.ui {
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.ui.Box;
	import laya.ui.Button;
	import laya.ui.CheckBox;
	import laya.ui.Component;
	import laya.ui.IItem;
	import laya.ui.IRender;
	import laya.ui.Image;
	import laya.ui.Label;
	import laya.ui.ProgressBar;
	import laya.ui.Radio;
	import laya.ui.RadioGroup;
	import laya.ui.Tab;
	import laya.utils.ClassUtils;
	
	/**
	 * <code>View</code> 是一个视图类。
	 * @internal <p><code>View</code></p>
	 */
	public class View extends Box {
		
		/**
		 * 存储UI配置数据(用于加载模式)。
		 */
		public static var uiMap:Object = {};
		/**
		 * UI类映射。
		 */
		public static var uiClassMap:Object = {"ViewStack": ViewStack, "LinkButton": Button, "TextArea": TextArea, "ColorPicker": ColorPicker, "Box": Box, "Button": Button, "CheckBox": CheckBox, "Clip": Clip, "ComboBox": ComboBox, "Component": Component, "HScrollBar": HScrollBar, "HSlider": HSlider, "Image": Image, "Label": Label, "List": List, "Panel": Panel, "ProgressBar": ProgressBar, "Radio": Radio, "RadioGroup": RadioGroup, "ScrollBar": ScrollBar, "Slider": Slider, "Tab": Tab, "TextInput": TextInput, "View": View, "VScrollBar": VScrollBar, "VSlider": VSlider, "Tree": Tree, "HBox": HBox, "VBox": VBox, "Sprite": Sprite, "Animation": Animation, "Text": Text};
		/**
		 * @private
		 * UI视图类映射。
		 */
		protected static var viewClassMap:Object = {};
		_regs()
		
		/**
		 * @private
		 * 向ClassUtils注册ui类
		 */
		private static function _regs():void {
			var key:String;
			for (key in uiClassMap) {
				ClassUtils.regClass(key, uiClassMap[key]);
			}
		}
		
		public function View() {
			if (_width > 0 && !mouseThrough) hitTestPrior = true;
		}
		
		/**@private */
		public var _idMap:Object;
		/**@private */
		public var _aniList:Array;
		
		/**
		 * @private
		 * 通过视图数据创建视图。
		 * @param uiView 视图数据信息。
		 */
		protected function createView(uiView:Object):void {
			if (uiView.animations && !this._idMap) this._idMap = {};
			createComp(uiView, this, this);
			
			if (uiView.animations) {
				var anilist:Array = [];
				var animations:Array = uiView.animations;
				var i:int, len:int = animations.length;
				var tAni:FrameClip;
				var tAniO:Object;
				for (i = 0; i < len; i++) {
					tAni = new FrameClip();
					tAniO = animations[i];
					tAni._setUp(_idMap, tAniO);
					/*[IF-FLASH-BEGIN]*/
					if (this.hasOwnProperty(tAniO.name)) {
						this[tAniO.name] = tAni;
					}
					/*[IF-FLASH-END]*/
					//[IF-JS]this[tAniO.name] = tAni;
					tAni._setControlNode(this);
					switch (tAniO.action) {
					case 1: 
						tAni.play(0, false);
						break;
					case 2: 
						tAni.play(0, true);
						break;
					}
					anilist.push(tAni);
				}
				_aniList = anilist;
			}
		}
		
		/**
		 * @private
		 * 装载UI视图。用于加载模式。
		 * @param path UI资源地址。
		 */
		protected function loadUI(path:String):void {
			var uiView:Object = uiMap[path];
			uiView && createView(uiView);
		}
		
		/**
		 * 根据UI数据实例化组件。
		 * @param uiView UI数据。
		 * @param comp 组件本体，如果为空，会新创建一个。
		 * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
		 * @return 一个 Component 对象。
		 */
		public static function createComp(uiView:Object, comp:* = null, view:View = null):* {
			comp = comp || getCompInstance(uiView);
			if (!comp) {
				trace("can not create:" + uiView.type);
				return null;
			}
			var child:Array = uiView.child;
			if (child) {
				for (var i:int = 0, n:int = child.length; i < n; i++) {
					var node:Object = child[i];
					if (comp.hasOwnProperty("itemRender") && (node.props.name == "render" || node.props.renderType === "render")) {
						IRender(comp).itemRender = node;
					} else if (node.type == "Graphic") {
						ClassUtils.addGraphicsToSprite(node, comp);
					} else if (ClassUtils.isDrawType(node.type)) {
						ClassUtils.addGraphicToSprite(node, comp, true);
					} else {
						var tChild:* = createComp(node, null, view);
						if (node.type == "Script") {
							tChild["owner"] = comp;
						} else if (node.props.renderType == "mask" || node.props.name == "mask") {
							comp.mask = tChild;
						} else {
							tChild is Sprite && comp.addChild(tChild);
						}
					}
				}
			}
			
			var props:Object = uiView.props;
			for (var prop:String in props) {
				var value:String = props[prop];
				setCompValue(comp, prop, value, view);
			}
			
			if (comp is IItem) IItem(comp).initItems();
			if (uiView.compId && view && view._idMap) {
				view._idMap[uiView.compId] = comp;
			}
			
			return comp;
		}
		
		/**
		 * @private
		 * 设置组件的属性值。
		 * @param comp 组件实例。
		 * @param prop 属性名称。
		 * @param value 属性值。
		 * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
		 */
		private static function setCompValue(comp:*, prop:String, value:String, view:View = null):void {
			if (prop === "var" && view) {
				view[value] = comp;
			} 
			//[IF-SCRIPT]else if (prop==="x" || prop==="y" || prop==="width" || prop === "height" || comp[prop] is Number) {
			//[IF-SCRIPT]	comp[prop] = parseFloat(value);
			//[IF-SCRIPT]}
			else {
				/*[IF-FLASH]*/
				if (comp.hasOwnProperty(prop))
					comp[prop] = (value === "true" ? true : (value === "false" ? false : value))
			}
		}
		
		/**
		 * @private
		 * 通过组建UI数据，获取组件实例。
		 * @param json UI数据。
		 * @return Component 对象。
		 */
		protected static function getCompInstance(json:Object):* {
			var runtime:String = json.props ? json.props.runtime : "";
			var compClass:Class;
			//[IF-SCRIPT]compClass = runtime ? (viewClassMap[runtime] || uiClassMap[runtime]|| Laya["__classmap"][runtime]) : uiClassMap[json.type];
			/*[IF-FLASH]*/
			compClass = runtime ? (viewClassMap[runtime] || uiClassMap[runtime]) : uiClassMap[json.type];
			return compClass ? new compClass() : null;
		}
		
		/**
		 * 注册组件类映射。
		 * <p>用于扩展组件及修改组件对应关系。</p>
		 * @param key 组件类的关键字。
		 * @param compClass 组件类对象。
		 */
		public static function regComponent(key:String, compClass:Class):void {
			uiClassMap[key] = compClass;
			ClassUtils.regClass(key, compClass);
		}
		
		/**
		 * 注册UI视图类的逻辑处理类。
		 * @internal 注册runtime解析。
		 * @param key UI视图类的关键字。
		 * @param compClass UI视图类对应的逻辑处理类。
		 */
		public static function regViewRuntime(key:String, compClass:Class):void {
			viewClassMap[key] = compClass;
		}
	}
}