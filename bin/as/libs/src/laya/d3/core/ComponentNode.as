package laya.d3.core {
	import laya.d3.component.Component3D;
	import laya.d3.component.Script;
	import laya.d3.core.render.RenderState;
	import laya.display.Node;
	import laya.utils.ClassUtils;
	
	/**
	 * @private
	 * <code>ComponentNode</code> 类用于实现组件精灵,该类为抽象类。
	 */
	public class ComponentNode extends Node {
		/** @private */
		protected var _componentsMap:Array;
		/** @private */
		protected var _typeComponentsIndices:Vector.<Vector.<int>>;
		/** @private */
		protected var _components:Vector.<Component3D>;
		
		/** @private */
		public var _scripts:Vector.<Script>;
		
		/**
		 * 创建一个 <code>ComponentNode</code> 实例。
		 */
		public function ComponentNode() {
			_componentsMap = [];
			_typeComponentsIndices = new Vector.<Vector.<int>>();
			_components = new Vector.<Component3D>();
			_scripts = new Vector.<Script>();
		}
		
		/**
		 * 添加指定类型组件。
		 * @param	type 组件类型。
		 * @return	组件。
		 */
		public function addComponent(type:*):Component3D {
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
			if (component is Script)
				_scripts.push(component);
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
			if (component is Script)
				_scripts.splice(_scripts.indexOf(component as Script), 1);
			
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
		 * 通过指定类型和类型索引获得组件。
		 * @param	type 组件类型。
		 * @param	typeIndex 类型索引。
		 * @return 组件。
		 */
		public function getComponentByType(type:*, typeIndex:int = 0):Component3D {
			var mapIndex:int = _componentsMap.indexOf(type);
			if (mapIndex === -1)
				return null;
			return _components[_typeComponentsIndices[mapIndex][typeIndex]];
		}
		
		/**
		 * 通过指定类型获得所有组件。
		 * @param	type 组件类型。
		 * @param	components 组件输出队列。
		 */
		public function getComponentsByType(type:*, components:Vector.<Component3D>):void {
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
		 * 通过指定索引获得组件。
		 * @param	index 索引。
		 * @return 组件。
		 */
		public function getComponentByIndex(index:int):Component3D {
			return _components[index];
		}
		
		/**
		 * 通过指定类型和类型索引移除组件。
		 * @param	type 组件类型。
		 * @param	typeIndex 类型索引。
		 */
		public function removeComponentByType(type:*, typeIndex:int = 0):void {
			var mapIndex:int = _componentsMap.indexOf(type);
			if (mapIndex === -1)
				return;
			_removeComponent(mapIndex, typeIndex);
		}
		
		/**
		 * 通过指定类型移除所有组件。
		 * @param	type 组件类型。
		 */
		public function removeComponentsByType(type:*):void {
			var mapIndex:int = _componentsMap.indexOf(type);
			if (mapIndex === -1)
				return;
			var componentIndices:Vector.<int> = _typeComponentsIndices[mapIndex];
			for (var i:int = 0, n:int = componentIndices.length; i < n; componentIndices.length < n ? n-- : i++)
				_removeComponent(mapIndex, i);
		}
		
		/**
		 * 移除全部组件。
		 */
		public function removeAllComponent():void {
			for (var i:int = 0, n:int = _componentsMap.length; i < n; _componentsMap.length < n ? n-- : i++)
				removeComponentsByType(_componentsMap[i]);
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