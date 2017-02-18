package laya.display {
	import laya.maths.Matrix;
	import laya.net.Loader;
	
	/**
	 * @private
	 */
	public class GraphicAnimation extends FrameAnimation {
		
		public var animationList:Array;
		public var animationDic:Object;
		/**
		 * @private
		 */
		protected var _nodeList:Array;
		/**
		 * @private
		 */
		protected var _nodeDefaultProps:Object;
		/**
		 * @private
		 */
		protected var _gList:Array;
		/**
		 * @private
		 */
		protected var _nodeIDAniDic:Object = {};
		
		/**
		 * @private
		 */
		protected static const _drawTextureCmd:Array = [["skin", null], ["x", 0], ["y", 0], ["width", 0], ["height", 0], ["pivotX", 0], ["pivotY", 0], ["scaleX", 1], ["scaleY", 1], ["rotation", 0], ["alpha", 1]];
		/**
		 * @private
		 */
		protected static var _temParam:Array = [];
		/**
		 * @private
		 */
		private static var _I:GraphicAnimation;
		
		public function GraphicAnimation() {
		
		}
		
		/**
		 * @private
		 */
		private function _parseNodeList(uiView:Object):void {
			if (!_nodeList) {
				_nodeList = [];
			}
			_nodeDefaultProps[uiView.compId] = uiView.props;
			if (uiView.compId)
				_nodeList.push(uiView.compId);
			var childs:Array = uiView.child;
			if (childs) {
				var i:int, len:int = childs.length;
				for (i = 0; i < len; i++) {
					_parseNodeList(childs[i]);
					
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _calGraphicData(aniData:Object):void {
			this._setUp(null, aniData);
			_createGraphicData();
		}
		
		/**
		 * @private
		 */
		private function _createGraphicData():void {
			var gList:Array = [];
			var i:int, len:int = count;
			for (i = 0; i < len; i++) {
				
				gList.push(_createFrameGraphic(i));
			}
			_gList = gList;
		}
		
		/**
		 * @private
		 */
		protected function _createFrameGraphic(frame:int):* {
			var g:Graphics = new Graphics();
			var i:int, len:int = _nodeList.length;
			var tNode:int;
			for (i = 0; i < len; i++) {
				tNode = _nodeList[i];
				_addNodeGraphic(tNode, g, frame);
			}
			return g;
		}
		
		/**
		 * @private
		 */
		override protected function _calculateNodeKeyFrames(node:Object):void {
			super._calculateNodeKeyFrames(node);
			_nodeIDAniDic[node.target] = node;
		}
		
		/**
		 * @private
		 */
		protected function getNodeDataByID(nodeID:int):Object {
			return _nodeIDAniDic[nodeID];
		}
		
		/**
		 * @private
		 */
		protected function _getParams(obj:Object, params:Array, frame:int, obj2:Object):Array {
			var rst:Array = _temParam;
			rst.length = params.length;
			var i:int, len:int = params.length;
			for (i = 0; i < len; i++) {
				rst[i] = _getObjVar(obj, params[i][0], frame, params[i][1], obj2);
			}
			return rst;
		}
		
		/**
		 * @private
		 */
		private function _getObjVar(obj:Object, key:String, frame:int, noValue:*, obj2:Object):* {
			if (obj.hasOwnProperty(key)) {
				var vArr:Array = obj[key];
				if (frame >= vArr.length)
					frame = vArr.length - 1;
				return obj[key][frame];
			}
			if (obj2.hasOwnProperty(key)) {
				return obj2[key];
			}
			return noValue;
		}
		
		/**
		 * @private
		 */
		protected function _addNodeGraphic(nodeID:int, g:*, frame:int):void {
			var node:Object = getNodeDataByID(nodeID);
			if (!node)
				return;
			var frameData:Object = node.frames;
			var params:Array = _getParams(frameData, _drawTextureCmd, frame, _nodeDefaultProps[nodeID]);
			var url:String = params[0]; 
			if (!url)return;
			params[0] = _getTextureByUrl(url);
			if (!params[0]){
				trace("lost:", url);
				throw new Error("texture not loaded:"+url);
				return;
			}
			var m:Matrix;
			var px:Number = params[5], py:Number = params[6];
			if (px != 0 || py != 0) {
				m = m || new Matrix();
				m.translate(-px, -py);
			}
			
			var sx:Number = params[7], sy:Number = params[8];
			var rotate:Number = params[9];
			
			if (sx != 1 || sy != 1 || rotate != 0) {
				m = m || new Matrix();
				m.scale(sx, sy);
				m.rotate(rotate * 0.0174532922222222);
			}
			
			if (m) {
				m.translate(params[1], params[2]);
				params[1] = params[2] = 0;
				
			}
			
			g.drawTexture(params[0], params[1], params[2], params[3], params[4], m,params[10]);
		
		}
		
		/**
		 * @private
		 */
		protected function _getTextureByUrl(url:String):* {
			return Loader.getRes(url);
		}
		
		/**
		 * @private
		 */
		public function setAniData(uiView:Object):void {
			if (uiView.animations) {
				_nodeDefaultProps = { };
				if (_nodeList) _nodeList.length = 0;
				_parseNodeList(uiView);
				var aniDic:Object = {};
				var anilist:Array = [];
				var animations:Array = uiView.animations;
				var i:int, len:int = animations.length;
				var tAniO:Object;
				for (i = 0; i < len; i++) {
					tAniO = animations[i];
					if (!tAniO) continue;
					try
					{
						_calGraphicData(tAniO);
					}catch (e:*)
					{
						trace("parse animation fail:" + tAniO.name + ",empty animation created");
						_gList = [];
					}
					var frameO:Object = { };
					frameO.interval = 1000 / tAniO["frameRate"];
					frameO.frames = _gList;
					anilist.push(frameO);
					aniDic[tAniO.name] = frameO;
				}
				animationList = anilist;
				animationDic = aniDic;
			}
			_temParam.length=0;
			
		}
		/**
		 * @private
		 */
		protected function _clear():void
		{
			animationList=null;
			animationDic=null;
			_gList=null;
		}
		public static function parseAnimationData(aniData:Object):Object {
			if (!_I)
				_I = new GraphicAnimation();
			_I.setAniData(aniData);
			var rst:Object;
			rst = {};
			rst.animationList = _I.animationList;
			rst.animationDic = _I.animationDic;
			_I._clear();
			return rst;
		}	
	}
}