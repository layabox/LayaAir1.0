package laya.layagl 
{
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.display.Stage;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author ww
	 */
	public class QuickTestTool 
	{
		
		private static var showedDic:Object = { };
		private static var _rendertypeToStrDic:Object = {};
		private static var _typeToNameDic:Object = {};
		
		//TODO:coverage
		public static function getMCDName(type:int):String {
			return _typeToNameDic[type];
		}
		
		//TODO:coverage
		public static function showRenderTypeInfo(type:*,force:Boolean=false):void {
			if (!force&&showedDic[type])
				return;
			showedDic[type] = true;
			if (!_rendertypeToStrDic[type])
			{
				var arr:Array = [];
				var tType:int;
				tType = 1;
				while (tType <= type) {
					if (tType & type) {
						arr.push(getMCDName(tType & type));
					}
					tType = tType << 1;
				}
				_rendertypeToStrDic[type] = arr.join(",");
			}
			trace("cmd:",_rendertypeToStrDic[type]);

		}
		
		//TODO:coverage
		public static function __init__():void {
			
			_typeToNameDic[SpriteConst.ALPHA] = "ALPHA";
			_typeToNameDic[SpriteConst.TRANSFORM] = "TRANSFORM";
			_typeToNameDic[SpriteConst.TEXTURE] = "TEXTURE";
			_typeToNameDic[SpriteConst.GRAPHICS] = "GRAPHICS";
			_typeToNameDic[SpriteConst.ONECHILD] = "ONECHILD";
			_typeToNameDic[SpriteConst.CHILDS] ="CHILDS";
			_typeToNameDic[SpriteConst.TRANSFORM | SpriteConst.ALPHA] = "TRANSFORM|ALPHA";
			
			_typeToNameDic[SpriteConst.CANVAS] = "CANVAS";
			_typeToNameDic[SpriteConst.BLEND] = "BLEND";
			_typeToNameDic[SpriteConst.FILTERS] = "FILTERS";
			_typeToNameDic[SpriteConst.MASK] = "MASK";
			_typeToNameDic[SpriteConst.CLIP] ="CLIP";
			_typeToNameDic[SpriteConst.LAYAGL3D] = "LAYAGL3D";
		}
		public var _renderType:int;
		public var _repaint:int;
		public var _x:Number;
		public var _y:Number;
		//TODO:coverage
		public function QuickTestTool() 
		{
			
		}
		/**
		 * 更新、呈现显示对象。由系统调用。
		 * @param	context 渲染的上下文引用。
		 * @param	x X轴坐标。
		 * @param	y Y轴坐标。
		 */
		//TODO:coverage
		public function render(context:Context, x:Number, y:Number):void {
			Stat.spriteCount++;
			_addType(_renderType);
			showRenderTypeInfo(_renderType);
			//if (_renderType == (SpriteConst.IMAGE | SpriteConst.GRAPHICS | SpriteConst.CHILDS))
			//{
				//debugger;
			//}
			RenderSprite.renders[_renderType]._fun(this, context, x + _x, y + _y);
			_repaint = 0;
		}
		
		private static var _PreStageRender:Function;
		
		//TODO:coverage
		public function _stageRender(context:Context, x:Number, y:Number):void
		{
			_countStart();
			_PreStageRender.call(Laya.stage, context, x, y);
			_countEnd();
		}
		private static var _countDic:Object = { };
		
		//TODO:coverage
		private static function _countStart():void
		{
			var key:String;
			for (key in _countDic)
			{
				_countDic[key] = 0;
			}
		}
		private static var _i:int = 0;
		
		//TODO:coverage
		private static function _countEnd():void
		{
			_i++;
			if (_i > 60)
			{
				showCountInfo();
				_i = 0;
			}
		}
		
		//TODO:coverage
		private static function _addType(type:int):void
		{
			if (!_countDic[type])
			{
				_countDic[type] = 1;
			}else
			{
				_countDic[type] += 1;
			}
		}
		
		//TODO:coverage
		public static function showCountInfo():void
		{
			trace("===================");
			var key:String;
			for (key in _countDic)
			{
				trace("count:" + _countDic[key]);
				showRenderTypeInfo(key,true);
			}
		}
		
		//TODO:coverage
		public static function enableQuickTest():void
		{
			__init__();
			Sprite["prototype"]["render"] = QuickTestTool["prototype"]["render"];
			_PreStageRender = Stage["prototype"]["render"];
			Stage["prototype"]["render"] = QuickTestTool["prototype"]["_stageRender"];
		}
	}

}