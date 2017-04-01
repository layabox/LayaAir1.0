package laya.display {
	import laya.maths.Matrix;
	import laya.net.Loader;
	import laya.resource.Texture;
	
	/**
	 * @private
	 */
	public class GraphicAnimation extends FrameAnimation {
		
		public function GraphicAnimation() {
		
		}
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
		protected static const _drawTextureCmd:Array = [["skin", null], ["x", 0], ["y", 0], ["width", 0], ["height", 0], ["pivotX", 0], ["pivotY", 0], ["scaleX", 1], ["scaleY", 1], ["rotation", 0], ["alpha", 1], ["skewX", 0], ["skewY", 0], ["anchorX", 0], ["anchorY", 0]];
		/**
		 * @private
		 */
		protected static var _temParam:Array = [];
		/**
		 * @private
		 */
		private static var _I:GraphicAnimation;
		
		private var _rootNode:Object;
		
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
		
		private static var _rootMatrix:Matrix;
		
		/**
		 * @private
		 */
		protected function _createFrameGraphic(frame:int):* {
			var g:Graphics = new Graphics();
			if (!_rootMatrix)
				_rootMatrix = new Matrix();
			//_updateNodeGraphic(_rootNode, frame, _rootMatrix, g);
			_updateNodeGraphic2(_rootNode, frame, g);
			return g;
		}
		protected var _nodeGDic:Object;
		
		protected function _updateNodeGraphic(node:Object, frame:int, parentTransfrom:Matrix, g:Graphics, alpha:Number = 1):void {
			var tNodeG:GraphicNode;
			tNodeG = _nodeGDic[node.compId] = _getNodeGraphicData(node.compId, frame, _nodeGDic[node.compId]);
			if (!tNodeG.resultTransform)
				tNodeG.resultTransform = new Matrix();
			var tResultTransform:Matrix;
			tResultTransform = tNodeG.resultTransform;
			Matrix.mul(tNodeG.transform, parentTransfrom, tResultTransform);
			var tTex:Texture;
			if (tNodeG.skin) {
				tTex = Loader.getRes(tNodeG.skin);
				if (tTex) {
					if (tResultTransform._checkTransform())
					{
						g.drawTexture(tTex, 0, 0, tNodeG.width, tNodeG.height, tResultTransform, tNodeG.alpha * alpha);
					    tNodeG.resultTransform = null;
					}else
					{
						g.drawTexture(tTex, tResultTransform.tx, tResultTransform.ty, tNodeG.width, tNodeG.height, null, tNodeG.alpha * alpha);
					}		
				}
			}
			var childs:Array;
			childs = node.child;
			if (!childs)
				return;
			var i:int, len:int;
			len = childs.length;
			for (i = 0; i < len; i++) {
				_updateNodeGraphic(childs[i], frame, tResultTransform, g, tNodeG.alpha * alpha);
			}
		
		}
		
		protected function _updateNoChilds(tNodeG:GraphicNode, g:Graphics):void
		{
			var tTex:Texture;
			if (!tNodeG.skin || !(tTex = Loader.getRes(tNodeG.skin))) return;
			var tTransform:Matrix = tNodeG.transform;
			tTransform._checkTransform();
			var onlyTranslate:Boolean;
			onlyTranslate = !tTransform.bTransform;
			if (!onlyTranslate)
			{
				g.drawTexture(tTex, 0, 0, tNodeG.width, tNodeG.height,tTransform.clone(),tNodeG.alpha);
			}else
			{
				g.drawTexture(tTex, tTransform.tx, tTransform.ty, tNodeG.width, tNodeG.height, null,tNodeG.alpha);
			}
		}
		protected function _updateNodeGraphic2(node:Object, frame:int, g:Graphics):void {
			var tNodeG:GraphicNode;
			tNodeG = _nodeGDic[node.compId] = _getNodeGraphicData(node.compId, frame, _nodeGDic[node.compId]);
			if (!node.child)
			{
				_updateNoChilds(tNodeG, g);
				return;
			}
			var tTransform:Matrix = tNodeG.transform;
			tTransform._checkTransform();
			var onlyTranslate:Boolean;
			onlyTranslate = !tTransform.bTransform;
			var hasTrans:Boolean;
			hasTrans = onlyTranslate && (tTransform.tx != 0 || tTransform.ty != 0);
			var ifSave:Boolean;
			ifSave = (tTransform.bTransform) || tNodeG.alpha != 1;
			if (ifSave) {
				g.save();
			}
			if (tNodeG.alpha != 1) {
				g.alpha(tNodeG.alpha);
			}	
			if (!onlyTranslate) {
				g.transform(tTransform.clone());
			}
			else if (hasTrans) {
				g.translate(tTransform.tx, tTransform.ty);
			}
						
			var childs:Array;
			childs = node.child;
			var tTex:Texture;
			if (tNodeG.skin) {
				tTex = Loader.getRes(tNodeG.skin);
				if (tTex) {
					g.drawTexture(tTex, 0, 0, tNodeG.width, tNodeG.height);
				}
			}
			
			if (childs) {			
				var i:int, len:int;
				len = childs.length;
				for (i = 0; i < len; i++) {
					_updateNodeGraphic2(childs[i], frame, g);
				}
			}
			
			if (ifSave) {
				g.restore();
			}
			else {
				if (!onlyTranslate) {
					g.transform(tTransform.clone().invert());
				}
				else if (hasTrans) {
					g.translate(-tTransform.tx, -tTransform.ty);
				}	
			}
		
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
		
		protected function _getNodeGraphicData(nodeID:int, frame:int, rst:GraphicNode):GraphicNode {
			if (!rst)
				rst = new GraphicNode();
			if (!rst.transform) {
				rst.transform = new Matrix();
			}
			else {
				rst.transform.identity();
			}
			
			var node:Object = getNodeDataByID(nodeID);
			if (!node)
				return rst;
			var frameData:Object = node.frames;
			var params:Array = _getParams(frameData, _drawTextureCmd, frame, _nodeDefaultProps[nodeID]);
			var url:String = params[0];
			var width:Number, height:Number;
			var px:Number = params[5], py:Number = params[6];
			var aX:Number = params[13], aY:Number = params[14];
			var sx:Number = params[7], sy:Number = params[8];
			var rotate:Number = params[9];
			var skewX:Number = params[11], skewY:Number = params[12]
			width = params[3];
			height = params[4];
			var tex:Texture;
			rst.skin = url;
			if (url) {
				tex = _getTextureByUrl(url);
				if (tex) {
					if (!width)
						width = tex.width;
					if (!height)
						height = tex.height;
				}
				else {
					trace("lost skin:", url);
				}
			}
			rst.width = width;
			rst.height = height;
			rst.alpha = params[10];
			
			var m:Matrix;
			
			m = rst.transform;
			if (aX != 0) {
				px = aX * width;
			}
			if (aY != 0) {
				py = aY * height;
			}
			if (px != 0 || py != 0) {
				m.translate(-px, -py);
			}
			var tm:Matrix = null;
			if (rotate || sx !== 1 || sy !== 1 || skewX || skewY) {
				tm = _tempMt;
				tm.identity();
				tm.bTransform = true;
				var skx:Number = (rotate - skewX) * 0.0174532922222222; //laya.CONST.PI180;
				var sky:Number = (rotate + skewY) * 0.0174532922222222;
				var cx:Number = Math.cos(sky);
				var ssx:Number = Math.sin(sky);
				var cy:Number = Math.sin(skx);
				var ssy:Number = Math.cos(skx);
				tm.a = sx * cx;
				tm.b = sx * ssx;
				tm.c = -sy * cy;
				tm.d = sy * ssy;
				tm.tx = tm.ty = 0;
			}
			if (tm) {
				m = Matrix.mul(m, tm, m);
			}
			
			m.translate(params[1], params[2]);
			
			return rst;
		}
		private static var _tempMt:Matrix = new Matrix();
			
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
				_nodeDefaultProps = {};
				_nodeGDic = {};
				if (_nodeList)
					_nodeList.length = 0;
				_rootNode = uiView;
				_parseNodeList(uiView);
				var aniDic:Object = {};
				var anilist:Array = [];
				var animations:Array = uiView.animations;
				var i:int, len:int = animations.length;
				var tAniO:Object;
				for (i = 0; i < len; i++) {
					tAniO = animations[i];
					if (!tAniO)
						continue;
					try {
						_calGraphicData(tAniO);
					}
					catch (e:*) {
						trace("parse animation fail:" + tAniO.name + ",empty animation created");
						_gList = [];
					}
					var frameO:Object = {};
					frameO.interval = 1000 / tAniO["frameRate"];
					frameO.frames = _gList;
					anilist.push(frameO);
					aniDic[tAniO.name] = frameO;
				}
				animationList = anilist;
				animationDic = aniDic;
			}
			_temParam.length = 0;
		
		}
		
		/**
		 * @private
		 */
		protected function _clear():void {
			animationList = null;
			animationDic = null;
			_gList = null;
			_nodeGDic = null;
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
import laya.maths.Matrix;

class GraphicNode {
	public var skin:String;
	public var transform:Matrix;
	public var resultTransform:Matrix;
	public var width:Number;
	public var height:Number;
	public var alpha:Number = 1;
}