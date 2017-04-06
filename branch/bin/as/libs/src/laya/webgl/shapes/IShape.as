package laya.webgl.shapes
{
	import laya.maths.Matrix;
	import laya.webgl.utils.Buffer2D;

	public interface IShape
	{
		function getData(ib:Buffer2D, vb:Buffer2D, start:int):void;
		function rebuild(points:Array):void;
		function setMatrix(mat:Matrix):void;
		function needUpdate(mat:Matrix):Boolean;
	}
}