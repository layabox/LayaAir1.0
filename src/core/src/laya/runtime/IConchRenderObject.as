package laya.runtime 
{
	
	/**
	 * @private
	 * @author hugao
	 */
	public interface IConchRenderObject 
	{
		function drawSubmesh( submesh:*, drawType:int, renderMode:int, offset:int, count:int ):void;
		function matrix( matrix:Float32Array):void;
		function boundingBox( min:Float32Array,max:Float32Array):void;
	}
	
}