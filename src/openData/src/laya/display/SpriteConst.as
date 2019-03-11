package laya.display 
{
	/**
	 * @private
	 */
	public class SpriteConst 
	{
		public static const POSRENDERTYPE:int = 0;
		public static const POSBUFFERBEGIN:int = 1;
		public static const POSBUFFEREND:int = 2;
		public static const POSFRAMECOUNT:int = 3;
		public static const POSREPAINT:int = 4;
		public static const POSVISIBLE_NATIVE:int = 5;
		public static const POSX:int = 6;
		public static const POSY:int = 7;
		public static const POSPIVOTX:int = 8;
		public static const POSPIVOTY:int = 9;
		public static const POSSCALEX:int = 10;
		public static const POSSCALEY:int = 11;
		public static const POSSKEWX:int = 12;
		public static const POSSKEWY:int = 13;
		public static const POSROTATION:int = 14;
		public static const POSTRANSFORM_FLAG:int = 15;
		public static const POSMATRIX:int = 16;
		public static const POSCOLOR:int = 22;
		public static const POSGRAPICS:int = 23;
		public static const POSSIM_TEXTURE_ID:int = 24;
		public static const POSSIM_TEXTURE_DATA:int = 25;
		public static const POSLAYAGL3D:int = 26;
		public static const POSCUSTOM:int = 27;
		public static const POSCLIP:int = 28;
		public static const POSCLIP_NEG_POS:int = 32;
		public static const POSCOLORFILTER_COLOR:int = 34;
		public static const POSCOLORFILTER_ALPHA:int = 50;
		public static const POSCALLBACK_OBJ_ID:int = 54;
		public static const POSCUSTOM_CALLBACK_FUN_ID:int = 55;
		public static const POSCANVAS_CALLBACK_FUN_ID:int = 56;//canvas开始前的回调JS函数ID
		public static const POSCANVAS_CALLBACK_END_FUN_ID:int = 57;//canvas结束后的回调JS函数ID
		public static const POSCANVAS_BEGIN_CMD_ID:int = 58;//canvas开始前的cmd的id
		public static const POSCANVAS_END_CMD_ID:int = 59;//canvas结束后的cmd的id
		public static const POSCANVAS_DRAW_TARGET_CMD_ID:int = 60;//canvas结束后drawTarget的cmd的id
		public static const POSCANVAS_DRAW_TARGET_PARAM_ID:int = 61;//canvas结束后drawTarget的参数id
		public static const POSLAYA3D_FUN_ID:int = 62;//3D的回调函数
		public static const POSCACHE_CANVAS_SKIP_PAINT_FLAG:int = 63;//cacheCanvas跳过自己渲染的标志
		public static const POSFILTER_BEGIN_CMD_ID:int = 64;//filter开始前的回调JS函数ID
		public static const POSFILTER_CALLBACK_FUN_ID:int = 65;//filter开始前的回调JS函数ID
		public static const POSFILTER_END_CMD_ID:int = 66;//filter开始前的回调JS函数ID
		public static const POSFILTER_END_CALLBACK_FUN_ID:int = 67;//filter开始前的回调JS函数ID
		public static const POSGRAPHICS_CALLBACK_FUN_ID:int = 68;//particle的回调函数
		public static const POSMASK_CALLBACK_FUN_ID:int = 69;//mask回调JS的函数ID
		public static const POSMASK_CMD_ID:int = 70;//mask的cmdID
		public static const POSBLEND_SRC:int = 71;//blendsrc
		public static const POSBLEND_DEST:int = 72;//blenddest
		public static const POSSIM_RECT_FILL_CMD:int = 73;
		public static const POSSIM_RECT_FILL_DATA:int = 74;
		public static const POSSIM_RECT_STROKE_CMD:int = 75;
		public static const POSSIM_RECT_STROKE_DATA:int = 76;
		public static const POSSIZE:int = 77;
		
		/** @private */
		public static const ALPHA:int = 0x01;
		/** @private */
		public static const TRANSFORM:int = 0x02;
		/** @private */
		public static const BLEND:int = 0x04;
		/** @private */
		public static const CANVAS:int = 0x08;
		/** @private */
		public static const FILTERS:int = 0x10;
		/** @private */
		public static const MASK:int = 0x20;
		/** @private */
		public static const CLIP:int = 0x40;
		/** @private */
		public static const STYLE:int = 0x80;
		/** @private */
		public static const TEXTURE:int = 0x100;
		/** @private */
		public static const GRAPHICS:int = 0x200;
		/** @private */
		public static const LAYAGL3D:int = 0x400;
		/** @private */
		public static const CUSTOM:int = 0x800;
		/** @private */
		public static const ONECHILD:int = 0x1000;
		/** @private */
		public static const CHILDS:int = 0x2000;
		
		
		/** @private */
		public static const REPAINT_NONE:int = 0;
		/** @private */
		public static const REPAINT_NODE:int = 0x01;
		/** @private */
		public static const REPAINT_CACHE:int = 0x02;
		/** @private */
		public static const REPAINT_ALL:int = 0x03;
	}

}