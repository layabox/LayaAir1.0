package laya.d3.core {
	import laya.d3.component.Component3D;
	import laya.d3.core.render.RenderState;
	import laya.display.Node;
	import laya.utils.ClassUtils;
	
	/**
	 * <code>ComponentNode</code> 类用于实现组件精灵,该类为抽象类。
	 */
	public class ComponentNode extends Node {
		/** @private */
		protected var _componentsMap:Array;
		/** @private */
		protected var _typeComponentsIndices:Vector.<Vector.<int>>;
		/** @private */
		protected var _components:Vector.<Component3D>;
		
		/**
		 * 创建一个 <code>ComponentNode</code> 实例。
		 */
		public function ComponentNode() {
			_componentsMap = [];
			_typeComponentsIndices = new Vector.<Vector.<int>>();
			_components = new Vector.<Component3D>();
		}
		
		/**
		 * @private
		 */
		protected function _addComponent(type:*):Component3D {
			var typeComponentIndex:Vector.<int>;
			var index:int = _componentsMap.indexOf(type);
			if (index === -1) {
				typeComponentIndex = new Vector.<int>();
				_componentsMap.push(type);
				_typeComponentsIndices.push(typeComponentIndex);
			} else {
				typeComponentIndex = _typeComponentsIndices[index];
				if (_components[typeComponentIndex[0]].isSingleton)
					throw new Error("无法单实例创建" + type + "组件" + "，" + type + "组件已存在！");
			}
			
			var component:Component3D = ClassUtils.getInstance(type);
			typeComponentIndex.push(_components.length);
			_components.push(component);
			component._initialize(this);
			return component;
		}
		
		/**
		 * @private
		 */
		protected function _removeComponent(mapIndex:int, index:int):void {
			var componentIndices:Vector.<int> = _typeComponentsIndices[mapIndex];
			var componentIndex:int = componentIndices[index];
			var component:Component3D = _components[componentIndex];
			
			_components.splice(componentIndex, 1);
			componentIndices.splice(index, 1);
			(componentIndices.length === 0) && (_typeComponentsIndices.splice(mapIndex, 1), _componentsMap.splice(mapIndex, 1));
			
			for (var i:int = 0, n:int = _componentsMap.length; i < n; i++) {
				componentIndices = _typeComponentsIndices[i];
				for (var j:int = componentIndices.length - 1; j >= 0; j--) {
					var oldComponentIndex:int = componentIndices[j];
					if (oldComponentIndex > componentIndex)
						componentIndices[j] = --oldComponentIndex;
					else
						break;
				}
			}
			
			component._destroy();
		}
		
		/**
		 * @private
		 */
		protected function _getComponentByType(type:*, typeIndex:int = 0):Component3D {
			var mapIndex:int = _componentsMap.indexOf(type);
			if (mapIndex === -1)
				return null;
			return _components[_typeComponentsIndices[mapIndex][typeIndex]];
		}
		
		/**
		 * @private
		 */
		protected function _getComponentsByType(type:*, components:Vector.<Component3D>):void {
			var index:int = _componentsMap.indexOf(type);
			if (index === -1) {
				components.length = 0;
				return;
			}
			
			var typeComponents:Vector.<int> = _typeComponentsIndices[index];
			var count:int = typeComponents.length;
			components.length = count;
			for (var i:int = 0; i < count; i++)
				components[i] = _components[typeComponents[i]];
		}
		
		/**
		 * @private
		 */
		protected function _getComponentByIndex(index:int):Component3D {
			return _components[index];
		}
		
		/**
		 * @private
		 */
		protected function _removeComponentByType(type:*, typeIndex:int = 0):void {
			var mapIndex:int = _componentsMap.indexOf(type);
			if (mapIndex === -1)
				return;
			_removeComponent(mapIndex, typeIndex);
		}
		
		/**
		 * @private
		 */
		protected function _removeComponentsByType(type:*):void {
			var mapIndex:int = _componentsMap.indexOf(type);
			if (mapIndex === -1)
				return;
			var componentIndices:Vector.<int> = _typeComponentsIndices[mapIndex];
			for (var i:int = 0, n:int = componentIndices.length; i < n; componentIndices.length < n ? n-- : i++)
				_removeComponent(mapIndex, i);
		}
		
		/**
		 * @private
		 */
		protected function _removeAllComponent():void {
			for (var i:int = 0, n:int = _componentsMap.length; i < n; _componentsMap.length < n ? n-- : i++)
				_removeComponentsByType(_componentsMap[i]);
		}
		
		/**
		 * @private
		 */
		protected function _updateComponents(state:RenderState):void {
			for (var i:int = 0, n:int = _components.length; i < n; i++) {
				var component:Component3D = _components[i];
				(!component.started) && (component._start(state), component.started = true);
				(component.enable) && (component._update(state));
			}
		}
		
		/**
		 * @private
		 */
		protected function _lateUpdateComponents(state:RenderState):void {
			for (var i:int = 0; i < _components.length; i++) {
				var component:Component3D = _components[i];
				(!component.started) && (component._start(state), component.started = true);
				(component.enable) && (component._lateUpdate(state));
			}
		}
		
		/**
		 * @private
		 */
		public function _preRenderUpdateComponents(state:RenderState):void {
			for (var i:int = 0; i < _components.length; i++) {
				var component:Component3D = _components[i];
				(!component.started) && (component._start(state), component.started = true);
				(component.enable) && (component._preRenderUpdate(state));
			}
		}
		
		/**
		 * @private
		 */
		public function _postRenderUpdateComponents(state:RenderState):void {
			for (var i:int = 0; i < _components.length; i++) {
				var component:Component3D = _components[i];
				(!component.started) && (component._start(state), component.started = true);
				(component.enable) && (component._postRenderUpdate(state));
			}
		}
	
	}

}