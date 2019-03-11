package laya.webgl.submit {
	import laya.webgl.canvas.WebGLContext2D;
	public interface ISubmit {
		function renderSubmit():int;
		function getRenderType():int;
		function releaseRender():void;
		function reUse(context:WebGLContext2D, pos:int):int;
	}
}