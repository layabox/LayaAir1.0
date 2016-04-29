
	var _self=this;
	var _$this=this;
	
	_self.onmessage = function (event){
		var data=event.data;
		_self[data._call].call(_self,data.value,data);
	}
	
	_self.script=function(value,data){
		eval(value);
	}
	
	_self.farcall=function(name,value){
		postMessage({_call:name,value:value});
	}
