package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer;

	public interface IShape
	{
		function getData(ib:Buffer,vb:Buffer,start:int):void;
		
	}
}