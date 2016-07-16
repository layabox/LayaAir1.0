package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer2D;

	public interface IShape
	{
		function getData(ib:Buffer2D,vb:Buffer2D,start:int):void;
		
	}
}