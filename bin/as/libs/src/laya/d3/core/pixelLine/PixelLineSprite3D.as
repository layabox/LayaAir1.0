package laya.d3.core.pixelLine {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>PixelLineSprite3D</code> 类用于像素线渲染精灵。
	 */
	public class PixelLineSprite3D extends RenderableSprite3D {
		/** @private */
		private var _geometryFilter:PixelLineFilter;
		
		/**
		 * 获取最大线数量
		 * @return  最大线数量。
		 */
		public function get maxLineCount():int {
			return _geometryFilter._maxLineCount;
		}
		
		/**
		 * 设置最大线数量
		 * @param	value 最大线数量。
		 */
		public function set maxLineCount(value:int):void {
			_geometryFilter._resizeLineData(value);
			_geometryFilter._lineCount = Math.min(_geometryFilter._lineCount, value);
		}
		
		/**
		 * 获取线数量。
		 * @return 线段数量。
		 */
		public function get lineCount():int {
			return _geometryFilter._lineCount;
		}
		
		/**
		 * 设置获取线数量。
		 * @param	value 线段数量。
		 */
		public function set lineCount(value:int):void {
			if (value > maxLineCount)
				throw "PixelLineSprite3D: lineCount can't large than maxLineCount";
			else
				_geometryFilter._lineCount = value;
		}
		
		/**
		 * 获取line渲染器。
		 * @return  line渲染器。
		 */
		public function get pixelLineRenderer():PixelLineRenderer {
			return _render as PixelLineRenderer;
		}
		
		/**
		 * 创建一个 <code>PixelLineSprite3D</code> 实例。
		 * @param maxCount 最大线段数量。
		 * @param name 名字。
		 */
		public function PixelLineSprite3D(maxCount:int = 2, name:String = null) {
			super(name);
			_geometryFilter = new PixelLineFilter(this, maxCount);
			_render = new PixelLineRenderer(this);
			_changeRenderObjects(_render as PixelLineRenderer, 0, PixelLineMaterial.defaultMaterial);
		}
		
		/**
		 * @inheritDoc
		 */
		public function _changeRenderObjects(sender:PixelLineRenderer, index:int, material:BaseMaterial):void {
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			(material) || (material = PixelLineMaterial.defaultMaterial);
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement.setTransform(_transform);
			renderElement.setGeometry(_geometryFilter);
			renderElement.render = _render;
			renderElement.material = material;
		}
		
		/**
		 * 增加一条线。
		 * @param	startPosition  初始点位置
		 * @param	endPosition	   结束点位置
		 * @param	startColor	   初始点颜色
		 * @param	endColor	   结束点颜色
		 */
		public function addLine(startPosition:Vector3, endPosition:Vector3, startColor:Color, endColor:Color):void {
			if (_geometryFilter._lineCount !== _geometryFilter._maxLineCount)
				_geometryFilter._updateLineData(_geometryFilter._lineCount++, startPosition, endPosition, startColor, endColor);
			else
				throw "PixelLineSprite3D: lineCount has equal with maxLineCount.";
		}
		
		/**
		 * 添加多条线段。
		 * @param	lines  线段数据
		 */
		public function addLines(lines:Vector.<PixelLineData>):void {
			var lineCount:int = _geometryFilter._lineCount;
			var addCount:int = lines.length;
			if (lineCount + addCount > _geometryFilter._maxLineCount) {
				throw "PixelLineSprite3D: lineCount plus lines count must less than maxLineCount.";
			} else {
				_geometryFilter._updateLineDatas(lineCount, lines);
				_geometryFilter._lineCount += addCount;
			}
		}
		
		/**
		 * 移除一条线段。
		 * @param index 索引。
		 */
		public function removeLine(index:int):void {
			if (index < _geometryFilter._lineCount)
				_geometryFilter._removeLineData(index);
			else
				throw "PixelLineSprite3D: index must less than lineCount.";
		}
		
		/**
		 * 更新线
		 * @param	index  		   索引
		 * @param	startPosition  初始点位置
		 * @param	endPosition	   结束点位置
		 * @param	startColor	   初始点颜色
		 * @param	endColor	   结束点颜色
		 */
		public function setLine(index:int, startPosition:Vector3, endPosition:Vector3, startColor:Color, endColor:Color):void {
			if (index < _geometryFilter._lineCount)
				_geometryFilter._updateLineData(index, startPosition, endPosition, startColor, endColor);
			else
				throw "PixelLineSprite3D: index must less than lineCount.";
		}
		
		/**
		 * 获取线段数据
		 * @param out 线段数据。
		 */
		public function getLine(index:int, out:PixelLineData):void {
			if (index < lineCount)
				_geometryFilter._getLineData(index, out);
			else
				throw "PixelLineSprite3D: index must less than lineCount.";
		}
		
		/**
		 * 清除所有线段。
		 */
		public function clear():void {
			_geometryFilter._lineCount = 0;
		}
	
	}
}