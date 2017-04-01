module laya {
	import Stage = Laya.Stage;
	import Text = Laya.Text;
	import Browser = Laya.Browser;
	import WebGL = Laya.WebGL;

	export class Text_ComplexStyle {

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.createText();
		}

		private createText(): void {
			var txt: Text = new Text();
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

			txt.borderColor = "#00ff00"

			txt.x = (Laya.stage.width - txt.textWidth) / 2;
			txt.y = (Laya.stage.height - txt.textHeight) / 2;

			Laya.stage.addChild(txt);
		}
	}
}
new laya.Text_ComplexStyle();