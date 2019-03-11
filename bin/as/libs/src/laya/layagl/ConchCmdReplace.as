package laya.layagl 
{
	import laya.layagl.cmdNative.ClipRectCmdNative;
	import laya.layagl.cmdNative.DrawRectCmdNative;
	import laya.layagl.cmdNative.DrawTextureCmdNative;
	import laya.layagl.cmdNative.DrawImageCmdNative;
	import laya.layagl.cmdNative.FillTextCmdNative;
	import laya.layagl.cmdNative.RestoreCmdNative;
	import laya.layagl.cmdNative.SaveCmdNative;
	import laya.layagl.cmdNative.RotateCmdNative;
	import laya.layagl.cmdNative.ScaleCmdNative;
	import laya.layagl.cmdNative.TransformCmdNative;
	import laya.layagl.cmdNative.TranslateCmdNative;
	import laya.layagl.cmdNative.AlphaCmdNative;
	import laya.layagl.cmdNative.DrawPolyCmdNative;
	import laya.layagl.cmdNative.DrawLineCmdNative;
	import laya.layagl.cmdNative.DrawLinesCmdNative;
	import laya.layagl.cmdNative.DrawTexturesCmdNative;
	import laya.layagl.cmdNative.DrawCircleCmdNative;
	import laya.layagl.cmdNative.DrawCurvesCmdNative;
	import laya.layagl.cmdNative.DrawPathCmdNative;
	import laya.layagl.cmdNative.DrawPieCmdNative;
	import laya.layagl.cmdNative.DrawTrianglesCmdNative;
	import laya.layagl.cmdNative.DrawCanvasCmdNative;
	import laya.layagl.cmdNative.DrawParticleCmdNative;
	import laya.layagl.cmdNative.FillBorderTextCmdNative;
	import laya.layagl.cmdNative.FillWordsCmdNative;
	import laya.layagl.cmdNative.FillBorderWordsCmdNative;
	/**
	 * ...
	 * @author ww
	 */
	public class ConchCmdReplace 
	{
		
		public function ConchCmdReplace() 
		{
			
		}
		
		//TODO:coverage
		public static function __init__():void
		{
			var cmdO:*= __JS__("laya.display.cmd");
			var cmdONative:*= __JS__("laya.layagl.cmdNative");
			var key:String;
			for (key in cmdO)
			{
				if (cmdONative[key + "Native"])
				{
					cmdO[key].create = cmdONative[key + "Native"].create;
				}
			}
		}
		
	}

}