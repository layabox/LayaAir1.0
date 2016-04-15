/// <reference path="../../libs/LayaAir.d.ts" />
Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
var txt = new laya.display.Text();
//给文本的text属性赋值
txt.text = "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向Flash开发者提供HTML5开发技术方案！";
//设置宽度，高度自动匹配
txt.width = 400;
//自动换行
txt.wordWrap = true;
txt.align = "center";
txt.fontSize = 40;
txt.font = "Microsoft YaHei";
txt.color = "#ff0000";
txt.bold = true;
txt.leading = 5;
//设置描边属性
txt.stroke = 2;
txt.strokeColor = "#ffffff";
txt.borderColor = "#00ff00";
Laya.stage.addChild(txt);
