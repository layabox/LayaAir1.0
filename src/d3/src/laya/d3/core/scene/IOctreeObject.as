package laya.d3.core.scene {
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	
	/**
	 * @private
	 * <code>IOctreeObject</code> 类用于实现八叉树物体规范。
	 */
	public interface IOctreeObject {
		function _getOctreeNode():BoundsOctreeNode;
		function _setOctreeNode(value:BoundsOctreeNode):void;
		function _getIndexInMotionList():int;
		function _setIndexInMotionList(value:int):void;
		function get boundingSphere():BoundSphere;
		function get boundingBox():BoundBox;
	}
}