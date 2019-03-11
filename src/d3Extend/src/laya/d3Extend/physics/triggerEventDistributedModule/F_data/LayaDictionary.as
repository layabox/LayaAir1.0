package triggerEventDistributedModule.F_data {
public class LayaDictionary {
    public function LayaDictionary() {
    }

    private var _values:Array = [];
    private var _keys:Array = [];
    public function set values(value:Array):void {
        _values = value;
    }

    public function set keys(value:Array):void {
        _keys = value;
    }
    /**
     * 获取所有的子元素列表。
     */
    public function get values():Array {
        return _values;
    }

    /**
     * 获取所有的子元素键名列表。
     */
    public function get keys():Array {
        return _keys;
    }

    /**
     * 获取字典的长度
     */
    public function get length():Number {
        return _keys.length;
    }

    /**
     * 给指定的键名设置值。
     * @param    key 键名。
     * @param    value 值。
     */
    public function add(key:*, value:*):void {
        var index:int = indexOf(key);
        if (index >= 0) {
            _values[index] = value;
            return;
        }
        _keys.push(key);
        _values.push(value);
    }

    /**
     * 获取指定对象的键名索引。
     * @param    key 键名对象。
     * @return 键名索引。
     */
    public function indexOf(key:Object):int {
        var index:int = _keys.indexOf(key);
        if (index >= 0) return index;
        key = (key is String) ? Number(key) : ((key is Number) ? key.toString() : key);
        return _keys.indexOf(key);
    }

    /**
     * 返回指定键名的值。
     * @param    key 键名对象。
     * @return 指定键名的值。
     */
    public function get(key:*):* {
        var index:int = indexOf(key);
        return index < 0 ? null : _values[index];
    }

    public function insertAtOrAdd(positionKey:*, insertKey:*, insertValue:*):Number {
        var index:int = indexOf(positionKey);
        if (index >= 0) {
            this._keys.splice(index, 0, insertKey);
            this._values.splice(index, 0, insertValue);
            return positionKey;
        }
        else {
            _keys.push(insertKey);
            _values.push(insertValue);
            return _keys.length - 1
        }
    }

    /**
     * 在指定键后面添加新的键值（如果不存在，则在最后添加新键值）
     * @param positionKey：指定键
     * @param insertKey：要添加的新键
     * @param insertValue：要添加的新值
     * @return 返回添加的位置
     */
    public function insertBackOrAdd(positionKey:*, insertKey:*, insertValue:*):Number {
        var index:int = indexOf(positionKey);
        if (index >= 0) {
            this._keys.splice(index + 1, 0, insertKey);
            this._values.splice(index + 1, 0, insertValue);
            return positionKey;
        }
        else {
            _keys.push(insertKey);
            _values.push(insertValue);
            return _keys.length - 1
        }
    }

    /**
     * 移除指定键名的值。
     * @param    key 键名对象。
     * @return 是否成功移除。
     */
    public function remove(key:*):* {
        var index:int = indexOf(key);
        if (index >= 0) {
            var value:* = _values[index];
            _keys.splice(index, 1);
            _values.splice(index, 1);
            return value;
        }
        return null;
    }

    /**
     * 获取不含头尾的区间
     * @param starKey
     * @param endKey
     * @return
     */
    public function sliceWithoutHeadAndTail(starKey:*, endKey:*):Array {
        var starIndex:int = indexOf(starKey);
        var endIndex:int = indexOf(endKey);
        var arr:Array = [];
        if (starIndex >= 0 && endIndex - 1 >= starIndex + 1) {
            arr = _values.slice(starIndex+1, endIndex-1);
        }
        return arr;
    }

    /**
     * 获取起始点到最后的所有元素，不含起始点
     * @param starKey
     * @return
     */
    public function sliceToEndWithoutHead(starKey:*):Array {
        var starIndex:int = indexOf(starKey);
        var arr:Array = [];
        if (starIndex >= 0) {
            arr = _values.slice(starIndex+1);
        }
        return arr;
    }
    /**
     * 清除不含头尾的区间
     * @param starKey
     * @param endKey
     * @return
     */
    public function spliceWithoutHeadAndTail(starKey:*, endKey:*):Array {
        var starIndex:int = indexOf(starKey);
        var endIndex:int = indexOf(endKey);
        var arr:Array = [];
        if (starIndex >= 0 && endIndex - 1 >= starIndex + 1) {
            _keys.splice(starIndex+1, endIndex-1);
            arr = _values.splice(starIndex+1, endIndex-1);
        }
        return arr;
    }

    /**
     * 删除从起始点开始到最后的所有元素，不含起始点
     * @param starKey
     * @return
     */
    public function spliceToEndWithoutHead(starKey:*):Array {
        var starIndex:int = indexOf(starKey);
        var arr:Array = [];
        if (starIndex >= 0) {
            _keys.splice(starIndex+1);
            arr = _values.splice(starIndex+1);
        }
        return arr;
    }
    /**
     * 清除此对象的键名列表和键值列表。
     */
    public function clear():void {
        _values = [];
        _keys = [];
    }

    /**
     * 释放所有对象，即使有其他对象引用他们，也释放
     */
    public function release():void {
        _values.length = 0;
        _keys.length = 0;
    }
}
}
