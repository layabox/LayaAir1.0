package laya.webgl.canvas.save {
	import laya.webgl.canvas.WebGLContext2D;
	public interface ISaveData {
		function isSaveMark():Boolean;
		function restore(context:WebGLContext2D):void;
	}
}