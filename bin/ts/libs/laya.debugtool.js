
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Box=laya.ui.Box,Browser=laya.utils.Browser,Button=laya.ui.Button,Byte=laya.utils.Byte,CSSStyle=laya.display.css.CSSStyle;
	var Component=laya.ui.Component,Event=laya.events.Event,EventDispatcher=laya.events.EventDispatcher,Filter=laya.filters.Filter;
	var GrahamScan=laya.maths.GrahamScan,Graphics=laya.display.Graphics,HTMLCanvas=laya.resource.HTMLCanvas,Handler=laya.utils.Handler;
	var Image=laya.ui.Image,Input=laya.display.Input,Label=laya.ui.Label,List=laya.ui.List,Loader=laya.net.Loader;
	var LoaderManager=laya.net.LoaderManager,LocalStorage=laya.net.LocalStorage,MathUtil=laya.maths.MathUtil;
	var Matrix=laya.maths.Matrix,Node=laya.display.Node,Point=laya.maths.Point,Pool=laya.utils.Pool,Rectangle=laya.maths.Rectangle;
	var Render=laya.renders.Render,RenderContext=laya.renders.RenderContext,RenderSprite=laya.renders.RenderSprite;
	var RunDriver=laya.utils.RunDriver,Sprite=laya.display.Sprite,Stage=laya.display.Stage,Stat=laya.utils.Stat;
	var Style=laya.display.css.Style,Text=laya.display.Text,TextInput=laya.ui.TextInput,Texture=laya.resource.Texture;
	var Tree=laya.ui.Tree,UIEvent=laya.ui.UIEvent,Utils=laya.utils.Utils,View=laya.ui.View;
	//class laya.debug.data.Base64AtlasManager
	var Base64AtlasManager=(function(){
		function Base64AtlasManager(){}
		__class(Base64AtlasManager,'laya.debug.data.Base64AtlasManager');
		Base64AtlasManager.replaceRes=function(uiO){
			Base64AtlasManager.base64.replaceRes(uiO);
		}

		__static(Base64AtlasManager,
		['dataO',function(){return this.dataO={"comp/button1.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGIAAABRCAYAAAApS3MNAAABSUlEQVR4Xu3a0QmFMADFUJ1JXM0h3moPZ6qg4AoNeLqAIenFn65jjLE40w2sQkxvcAMI0eggRKSDEEJUDEQ4/COEiBiIYFiEEBEDEQyLECJiIIJhEUJEDEQwLEKIiIEIhkUIETEQwbAIISIGIhgWIUTEQATDIoSIGIhgWIQQEQMRDIsQImIggnEvYvv9IzjfxDiP/XlgJsTcCyDEXP/v14UQImIggmERQkQMRDAsQoiIgQiGRQgRMRDBsAghIgYiGBYhRMRABMMihIgYiGBYhBARAxEMixAiYiCCYRFCRAxEMCxCiIiBCMa7iAjPpzG8fY3kF0KIiIEIhkUIETEQwbAIISIGIhgWIUTEQATDIoSIGIhgWIQQEQMRDIsQImIggmERQkQMRDAsQoiIgQiGRQgRMRDBsAghIgYiGBYhRMRABMMihIgYiGBcGJiOHTRZjZAAAAAASUVORK5CYII=","comp/line2.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAECAYAAACOXx+WAAAAG0lEQVQYV2NkoDJgpLJ5DIxtra3/qWko1V0IAJvgApS1libIAAAAAElFTkSuQmCC","view/create.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAkCAYAAAC9itu8AAAAdElEQVQ4T2NkwAIWLFjwH5t4QkICIyM2CXQxmAHka/j///9mXDYxMjL6YtgwBDUg+w8crIT8MBQ0oEca55JvWNPS9xgu4tISzADyNfz///8MnrRkgmHDENSALWng9fRQ0DA40xLecglbWhpqGoZCMUNKUQkANAHAJVkE5XwAAAAASUVORK5CYII=","view/rendertime.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAkCAYAAAC9itu8AAABeUlEQVQ4T+2Uv0tCURSAvyNdcwiXBlsaaomWFgeHlqAtCPsDJHwIiUtDSxERtErtmQ6CjkHo4FpDBQ0tbVFR0BYE0eQvOnFF7T17QlOTd3m88873OD8+rtA9uVzOBIPBlIisAwvd8B1QajQahXQ63bIx6QHFYrEEJHrv7qeqZhzHOfYA+Xw+Yow5B+YHoGwymdxW1QAQEFWNAk8i8uEDuZM3gUcLZIEJYNcNqWrVcZyd7p9t8jLwYIFTYBx47UHlcjmcSCQ+B5JtpU0LnAFj3br7kE+yTalb4BCYczVqoT3AjteW4T73FlgFNgY+1IGQz4hPLGCAI2DGbweu2Auw1Vmcqk4C+8DsEOgZOBCR9/6mVdU2vgIsAdOuIVwANRFpezatuahpTYVSop1m+y6pasm8NQqSvvW61KwslkSHuCRkgvErr0taiUXaal1Sr0siWRO/9HfpF+RN9nfpB/qqmrXrv7mktVhYVm5GLo1cct9LI5e8d84/3UvfAgdlKH0EO7MAAAAASUVORK5CYII=","view/cache.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAAkCAYAAABSSLCCAAAAcElEQVQ4T2NcsGDB/4SEBEYGBgYGYtmMxCpENhhsA6mA8f///5tHNTEwkBcQpIYcSD15kUtWigi51vR/jVYdOGUQy2YkViGywWSnvTOkhiAonkY1gZIRqSEHTntkRe4g10RWQIyWe5Bgo2O5R7dkBADztyP+yFzirAAAAABJRU5ErkJggg==","comp/clip_selectBox.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAAAoCAYAAAAIeF9DAAAAsElEQVRoQ+3ZQQ0AMQzEwAuqEgh/Sj2pKObhIrBsrfLonHPu12MMTEGYFg+kIFaPgmA9ClIQzQDG0w0pCGYAw2khBcEMYDgtpCCYAQynhRQEM4DhtJCCYAYwnBZSEMwAhtNCCoIZwHBmd/tTh6IUBIrx/tRbiFWkIFaPFoL1KEhBNAMYTzekIJgBDKeFFAQzgOG0kIJgBjCcFlIQzACG00IKghnAcFpIQTADGE4LwYL8U/BE1dCJ3PsAAAAASUVORK5CYII=","comp/label.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAASCAYAAACQCxruAAAAmElEQVRoQ+3aMQqAQBBDUef+hx4Zq1mrbPnhWylECHmghVZ397OOqqp97TlugdNzgEXFIaaFuwROt0LmBEay5aXb920+FjIpMJItLy1wvhUyKTCSLS8tcL4VMikwki0vLXC+FTIpMJItLy1wvhUyKTCSLS89wPP1Qeh8M0zy+84gMMbruqjA15OxbtjAu7mPa5bj0fb/A8cLgD4n/wQKNiIAAAAASUVORK5CYII=","comp/clip_tree_arrow.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAQCAYAAAArij59AAAAwUlEQVQoU5WRPRKCMBCFWUt6vYQeB06RUDpoBbFDa7yDwm30FGi9dHnOMiQDBgvT5c3b7+0PRVEUlVV9A3NmzL6T//SRfMz5CgCdtVafjlmzaHAigAbM2tE8YVo1pf0yvABoc9D3wACgBbMKIgD4qqDJsqqlMV8VGL5n/88geCJKlijSMBXFZUNx/CSi9WwX1r7R99thzKKqkxXRbMUWSE2u2sEwHsxHCbrMVSq6N4xRD9HAvJstylEkarhurlqnfQC58YP5+CvQNwAAAABJRU5ErkJggg==","view/bg_panel.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAMUlEQVRYR+3QQREAAAjDMGZk/l2CDD6pgl7SduexGCBAgAABAgQIECBAgAABAgS+BQ4oyStBhXcy5AAAAABJRU5ErkJggg==","view/bg_top.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAMUlEQVRYR+3QQREAAAjDMKZp/rWBDD6pgl7SduexGCBAgAABAgQIECBAgAABAgS+BQ6WyDMhXMLeQgAAAABJRU5ErkJggg==","view/clickselect.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAqCAYAAACDdWrxAAACfElEQVRIS8WVO2iTYRSGn5OWqpMOurg0VRBdVVCsg7GgDjpZECyirl4GEYfSgBlaB5VSpApdxCJIoeKgg7dKC21ALahIiyiKKUjxAiI4qCH1lRP/hPhfAnHpGZPv+c4573nP95ukO/xHmINmtq8RtswsPiipB/gAPAFem5nCbcSWKukIsD84/A2YBh4DL8ysWLkk0qOkDcD5GLF+Ac+Ap35ZHGjAdWB5gtJvgZFYVSWdBHaFwBlg1Mw8K0ngFiAbAm+a2XBij/6HpBbgBrAEmAVeAZ1AFU40QDCWrcBZL0/S4Vq4HtgB7DWzU5XyauDBMhhWz70ryVVdb2ZuhGpI2g1MODjfiMFrxZk3s9WNwJ6snHFxQUlXgXfAPeC5mf2O2Y5oqZLcMceCw1+AseCSSTP7mSiOpM3A7RixfvgYgAd+WUQcSSnfPWBlgtIvgf5YVSVdBA6GQF/mS2bmWcvbERmHJF+payFw0MzO1TWApKXBViwL3h5/Pk4AVTjRAMFY9njJXl6wLccrcD3wAHDUzBwuRw18JtbkbkFJruomM7sf2o4u4Jals/mFRgxeFcfBQm97UyOwM+WMiwums/k3QnMps+HWpuLIRC5TCrcRW2pbT35MRiY4XDRsVmiU5uJQIZfxb0k5Ij229eQPySJ287MLGO8Rd1M0XY6AO3LjzYVSy3fAH+VICL4a6o9VtTWbnzbYGKI+IrtQ6Ns2EFuq/5jOTnWD9f4DikeFvvbqhyg2Yzo3voJSy2fAjfEJMYPRQQ2caAAfC7AW2WkvrzU79dCwnRW4Hjgg6JrrbV9VKbkKw1Csyd2Ca7on1y2krHOub3t16//2n79SarbsH7BKtfejoCjmAAAAAElFTkSuQmCC","view/resize.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAqCAYAAACDdWrxAAABeUlEQVRIS+2UvUpdURCFvxXRKJpIEBURsVAIiiBoaaGCjY2VLyH4MBaCPoWlnQlpI6SxsQmkURQL5eK/6JK57iuRnMPZtxAkuOFUhzWz96xvjcg8tluAT5LOQqJMHba/AgPAD0nOEtruAOaB6Lon6U+ucAoYTLe7Bb5XCm1/BCaAXqAVOAHyOkYn27PA5/TGWmXHxvBeT2i7TVIM4MUp7ZhGPlY3V/pVKUxEjAIjyac74LIAjK70PwCoyfYXYDJwyqDoHtiRdFOfql0naBgIrILF/ZIi1yH6h1XbYXCPpKOq7s34GEX7JB00m445YBzYlPSQ1dF2N7CaWN2W9DNXuJxAj1uGVeuVQtvh32LyuR34DexWCv+CfAXoBzYkHb8Boe1OSRcFkBdfNY18IQiUtFUpTJjNAPEFHVfAaQFyjZ3zNBzbQ8BSWkZViEbk1uIpjXR8AKbT7jwEvpVUqEk6L0pHLN5hSWWxeq7XjI/v6Sgz0vZ7Ov7DdDwCkcb1m86tSukAAAAASUVORK5CYII=","view/clickanalyse.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAqCAYAAACDdWrxAAAC7UlEQVRIS5WWT2hUZxTFfyfGFolkoUVKrHQiEaX+IfgHa54UQzUqpWYhLbQU6ULNwgYXuog6yiiTgK2LgtAu6yqbFkpRBEURQzJEBN200NqKkxoDLnQhFUrizJU7vje8SSbzZr7FwDy+c75z7z3nfU80uMxMDin9JC0zewvYAHwIrAH65wWaWQuwOdy8CVgUHnBd0sUKoJktBbYC24B1QHMVNeck3ZWZrYhtXpUg/3/gS0kzDnT2/cDqpFqBUUnnK5pjZutDgo01Tr0g6XbVrprZypBgO9AUU/EK+ErSyzLQzC5XkTkCfBR7fl/Smeh/qasOlPRp9DAkOgp8H5P9o6SriUAnMrOzgNdswNeSntcL9IYNAQ8kHYuXU5Y6u8ZIupldAO5I+nkOsNb8wjk/ljTZKFCSvMbSMrPSiOpNx9uAz3UP4IbfWSsdrcDH4eZuYHF46LCk47PT8S6wG9gbJmRhlfoPSLrhJvdERJs7E+S73dZKmnagsx8JB50UEHdY3+x0dIUEO2qcekTSr/OlY21I4N5dEJMwA6yX9CKejqkqGn8DemPPb0v6YrZXpyS1xYbsRD3AtZjsk5IuJQKdyMyGAa/ZnbNR0tN6gd6wXwAP8SfV0jGnxki6mV1xyf4ubdTkPue/Jf3TEJCMNZFRMQLtyNwqvaTrSkdHZry1MFM8bLLPgY5U8/SyeYHvncotb5b1A/t8c2QGg3sT2WBLBbD95PiGogr9Ej0Gbap8r4ZJ5kR+MPhW7WdGd5npEFaa15IE+YWW5uklf2S6/1N7OnfasG+Ad5KiAfyVzwYfVDQnlc71YTaA8Ntrvtq/y2eDgapdTZ0a60UMhjdvmcCgWDClJge7npSBqfRYYY5M6U/M/NqO1mQ+G7xf4VUH5rNBOXtviLQfzH0afizop0fZroOJQCdKpcfyUKrZFhTpfDgU/F4nMNcH9gPwLJ8Nls3xarUaI+mp9NhTg5GJbPBZQyb3OReayP17rutmHPga1PpCOk+zrlEAAAAASUVORK5CYII=","view/res.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAoCAYAAAD6xArmAAADwUlEQVRIS+3WT2gcdRQH8O/b2SwNC7l4MAEPvbilUkoPOUmLjSDrZn4hxYKH/kGwyB4tQogiu/N+GymyoWguhVBQKKkHQTHsW9fUQwqKp4AgtMXkInhILl4CkoTdmSe/6XZp2pntLli8uMedt9/3mze/33yW8Jw+9Jxy0TeYmV8FcFVVTxPRiwA6AP5U1TvZbHapUqn8nrawxGBVJWvtNVWdJ6K05h1V/dhaW08KT/wRM1sAVQCRqn5JRLdyudw9Iora7faJKIrKqnrBNSWiahAEC0+GHwpm5utEdD+KopsuBMDbzPxt0oqstRdV9Za7lslkzlar1Z8erzsUHATBJhG93C34fmJi4ly5XG6nzTEIgjoRzanqkrX2amowM98F8Fq3wK34PWb+Ii14cXExv7e3V6hWq78+axQrANwt/kVEl5j5h0G2IzMfUdWCtfa3R/VPzvhTAG8AOM/MfwwYehTANwB+ZOYPE4ODIDhJRJvMvD9IqLW2GEXRbSJ6AcBtZr6UGPzoS2Y+lc/nt+bm5v5Oa2CtvaKqywC8bs06M7+eGszMn7nTBqDOzPNpwcvLyyPb29vfAZh2Naq6Za0tpAbXarUzURS53eGKL1trv0oKZ+a3AHytqplMJlOOoui4tfaDvqOw1lZUtabubBOtqOqN0dHRB/v7++62XwHwDoB33dkAUGPmoO92e/yitXZeVT8BkE1acbdpPQiCj4hIBw52hQsLC8c6nc77AN4E8FK3yQ4R/Qzgc2b+Je0ZDPU+fjiZp1eXFD5U8CB7u+/DGybgXxnFMA3/m1GISGwegNMAeuYBuON53lKpVBrePBG5RkTuSPc1b2ZmZnDzRKRnHoDYvIODg3u5XM69/E8AKAO40G1aNcb0N6/ZbF5X1fsAbjpInXnGmETzGo3GRdew+0DPGmPSzRORTQA988bHx89NTk6mmtdoNGLziGjJ9/1085rN5l1VPWSeMSbVvLW1tXwYhoXp6en+5olIbB6A2Dzf9wcyb319/cju7m5hdnY22TwRic3zPO98qVQayLxWq3U0DMPYPGNMsnmrq6snx8bGNqempgYyT0SKzjoAsXnGmP7mNZvNU9lsdqtYLKaaJyJXABwyzxiTbp6IxOYRUd33/VTzNjY2RnZ2dnrmAdgyxqSbJyJnAMTmEdFl3/cTzROR2DzHk6qWiei4Maa/eSJScZY99FRXPM+7MTIy8iAMQ6/dbsfmEVHPPGPM4OaJiBtDqnmuqfuL4Pv+8Oa1Wq1jYRg+ZR6A2DxjzP/mPRupfwAf56Q4urCh6QAAAABJRU5ErkJggg==","view/tab_panel.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAABICAYAAADyMAW8AAAAcUlEQVRYR+3WsQ3AMAhE0TCMeyTvP1tShRQo7lxYegxA8fUPLuac97VhwuKXKhTlFxRQ9GPDClawYvGEDwxIZu7pFRZXr4ACinY1ghWsYMX/NxWQr22edyvGGHt6hcV1NqGAon8QVrCCFYteISDnBuQB3xJuQcDkEngAAAAASUVORK5CYII=","view/btn_close.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAqCAYAAACz+XvQAAACmUlEQVRIS7WWS0/bUBCFz7mJmyZxENm06mNVoVZC7LqGn9FNqy55/BSWSEhs2/4uuqFVoA150JLKJvGdaiIH2TfXNoKQpeP5PHPO3GMTK/5xxTwsAUWkBeBZ+qAByb/Zh4pIA8CL9NqY5Dj7vw9YA/ABwDsAfwB8ITnUIhF5CuATgNcAfgH4RnJSCkwLl6AA/lXBtLZQQxFxoTr6q6LOFl2WmuJAtcY7ZuXIixsczfRyTlPfhpSN7BpwBeBtFdQLFJE2gI8AXi7GBBBl3Fdnv5L87XbpWxuFfQbw3NXM0dQLLdrDIH3ylGTiLLYB8CS9lpCc3tmU+xzL1Z9lEXl/n06KavjowCiK1uM4fqMd1Ov1s3a7fZntZjabtSeTiQYHgiC4aLVavZwpbofT6TQYDAaH1tod3bMwDHc7nc5PLZrNZmG/3z8WkS1jzGm32z1oNBqjUqD+6YM2m81xFWyeNkUaulAAlyKyWdTZbdqUmZKFakEVrLRDV7P5zY6m3rQp6tA1AMC5tXY7he51Op0fdwbGcdwdDodHWc2MMdcL9wGM1tbW9sMw/L6UNm6HChuNRifW2g1XM0dTL3TJZS1KkkTDFbVaLQqCIJcm6k0URRpxuvg39Xo9rtzDh5zt1Z/lXq+32rR5dKC1dt0YM08bAGd65BxN1ZB52ojIBcl82rgdWmsDkocAdgDoW22X5DxtSIZJkhyT3AJwCuCAZD5tfCP7oMaYcRVs/tAiDT1QHX2zqLPbtCkzxYFqjXfM3GKXAR3NtC6nqTccioAeA84BbCuU5B4Af9r4gCLSBXCU1UxErjPuj0Rk3xiznDYuMIWdANhwNXM09UKXXNai9LtQ9y4yxuS/XUijr9L0lXBDMp82j370HhJdWvsftiHJYFPSIqEAAAAASUVORK5CYII=","comp/combobox.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFsAAABCCAYAAAA476rKAAACfElEQVR4Xu3bMYsTURQF4PMmExgIWkgEU5hskyJYxGYKY5VS7NzCylL8Bftj3NbKQjuxTBWbaUwhKdIYLCJotlACA5m8kQTZZZkkeN9dbuNJOXPPu/DN5ZHkMa7dbpfgx0TAEdvEedeE2HbWxDa0JjaxLQUMe3HPJrahQECrNE3RarUOJheLBbIsq9znZAdgJ0mC4XCIer1eSa/Xa4xGI+R5TuwA272RTqeDfr9fuTeZTDCfz/dmONkK/cFggGazebnCcrnEeDw+uCKxFdiNRmO3nURRBO/9bvtYrVbEVpgejXa7XfR6PUynU8xms6O1nGzlU3DO7fbu7V5dlsf/0yO2ElsSJ7ZES1lLbCWgJE5siZaylthKQEmc2BItZS2xlYCSOLElWspaYisBJXFiS7SUtcRWAkrixJZoKWuJrQSUxIkt0VLWElsJKIkTW6L1t5an6wFooRGerofKBeZ4uh4IFxrj6XqoXECOp+sBaJoIT9c1esIsT9eFYFbl/J5tJc13agyliU1sWwHDbtyziW0oYNiKk22JfXJ6xnfXjcDdFttnb43a/b9tovQ5iG30/IltBL1tQ2xiGwoYtuJkE9tQILBV/ugl4rh2MF1sPJJP59fuc7IDsTe37mHz8Bki+MoKHhFqn9+j9vs7sQN9K7G89xRx837levHzG5Lph8p1TrZK3iF//ApxdLVI4YFk/BpA9Uc5sVXYwObOCfyDJ3AoUcIh+vIRtYuve1clthJ7G8/7p4hv30Xx6weSybuDKxL7BrARxcjTF0iyN4AviH0Tpto1ONlaQUGe2AIsbSmxtYKCPLEFWNpSYmsFBXliC7C0pZfY2oWY/zeBP8uaLni/AFTVAAAAAElFTkSuQmCC","comp/textinput.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFsAAAAWCAYAAACv8OArAAAAZElEQVRYR+3UQQkAMAwEwcZI/LtsoSL2NTGwMByZ3b3HJQIDO3H+EdidNezQGjbsUiBs+dmwQ4EwZdmwQ4EwZdmwQ4EwZdmwQ4EwZdmwQ4EwZdmwQ4EwZdmwQ4EwZdmwQ4Ew9QBe0R29X9x+dwAAAABJRU5ErkJggg==","comp/vscroll.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAhCAYAAAA/F0BXAAAAOklEQVRIS2N8+OzVf2YWFgYmJiYGcgHjqCEYQTcaJpipaTRMRsOEmDJmNJ2MppPRdEJMCIymE2JCCQAYonwDuu2VMAAAAABJRU5ErkJggg==","comp/vscroll$down.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAzCAYAAABxCePHAAAC/klEQVRIS+2WS0wTURSG/zszBcrLFVvjio0LiAqRRDAmGpRodFE1MQQQkOKGqBujRo3ExLjB4MaKgDzUaGQhvoJGYwAjYoioERcuDGxYEIwPkBY6nWvObXuLnXZaSklYOIu5M/fxzZn/nvPPsInJKa5qGhRFQaIH+w8xSbcymtTd+gBFYXAdyjM9sf7ORxgGR0t5/j9jpkhq2t5B0xQwBrgqNsnJ9V0j4BzQdQNtNYXWkKz0NDiaXkBTFTCFoaWmCHVtQ+AGh+4z0HNiO2bmPNYQGiXQvkuPoaqqiIgi8Pl8eHBqtwlA86MKS6Cy8z1gjIFzjqcXHBEBlpBgRNuOd+HVlYqogJiQIChcg/BtW5k8SaSSkxPJ5PRPTttHfkI7kcghIpn8NYfp33NLXp+TnYG1OWvA3ox9499nPSjdkCsgHJxOIjc43VMrugL9dEUD4Oj/PA4CsUfDX/jOjbmisHTDCCzi4t4QgLDrQF+qTYOmqhgYGw9BvLpv0ZNjQwieaU9b7ZCDriFhSt3VBSZNartHA6aUJ7SK+jqO5n5pSp1HiqSw1e3Di0ypwBpiU1XsudwnTanraDEqrg2GmZLbGkJh2jQVZY29JlPqPe03JX/uxLE7Nk3DjjP3pCn1Ne7HrNsjdYoLQsmWYtNQ3NCBgeZKzLrn/foEoogbQgvSUmz4454P7VQikGhpHzGSZdVOUqqYTGli6gemZ9yJ+0lSTalk/TrxtQOYaBnESbTinokev4UG+p+9/xoyJQKQn8x7vf7JjEFZ1FJBBvuC12RINIdAwtkIQuksnxgHhKBUZ6scQtLSNyiWJpav47z9STjbjfJ8k5iVN0eEs911bhZjUTWpbR+RztZ6uFBERNCq1rfS2e43lFhDsjPscDS9lM7W4dyCquuvpbM9PFkq0iHm7mSl2yP+bj05uxdeXZe5FHOL6Xdr17nQ79bziwew4NXFqwUTMiaEtKBPwtZjnRi8WgXPglfqsyQITc60pwpAeNpH1GRZtRM0pWVVcTJM6S+dYaRsIf025wAAAABJRU5ErkJggg==","comp/vscroll$bar.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAA/CAYAAAAGyyO8AAABYElEQVRYR+2Wv0sDMRTH30tarCg6dRWnQnFT6OiqoP+tk+Cig+AiHayDiNSlg+jgD47K1US+Lwm5s4o/mkElN1xy73KfcF/efTi+Ht3Y0X1Btw8FffdoLy3QSnuZ+HhwZe+exrS13hGGJYsTWSszN0rJ1zHDDbJ0eDYkgHjv5Nxub3TIGEsTY/xDVq6NAN7MfW2u2aCG1nQ0GEZIOXmp7Pw5BPDF+VaGIGQfbM6k0ng5kw8/wF/eJzP5JInZkjg2CSS8zk6vCys7Wb8r5qqsncAP+pdR1Lu9rvgVT4uYg+3F+PCtAzjzu/taKdKKBSS2/wkEMBg/Q+rB50zqzZb7ZPoD/GeZ1HySxGxJHJsEEl5nc22VmCFalpFJTjLKNUtFxlDfP72IogYAP8PPZekWM5OqjErFWpjjbxprABJRA/JYjOOOX4Bgo6bWGYKsfMg5k+lmy5n8uUxm8kkSs6Vw7Cstibc9Fv5vWQAAAABJRU5ErkJggg==","comp/vscroll$up.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAzCAYAAABxCePHAAADF0lEQVRIS92WTUhUURTHz31vPv0KKmkXrtxUGNomkCANLdCUpEatJFuIClIEFRl9kGH0BYWQElLpotGKEJXAtKQooYUFpi1axLQZMCyyZJqv926cM2/uTM288emoUHfx3v16v3fuuef+72Hume/c7/cBAwaLKWaLBZjLPc0Zk0CSJGBs4SDOObDP7i9ckuXkIbLJRJDFFrJk2SGNvZNwy7ExoZEJLWnqfQ+4SlUFaHNs0gXpQhq6x0GWGe0Y7oCicGivyYsLigup7XgFJlkCJjFwNm2HqrZR4CqHoKLC3fr8GFAMpPLqEJhMoZjpay6Bnx4vpKfYoLx1kCwKBlXoOV78BygGsudCH1nwtNVBgHBBUFFzL1n0+Gx5YghOxhINiAbFG1uZODESxf+bJShKrulv8HUusp1G/IBz1qTZIGvdamBjU584Aopzs+lbDhwfFFgc2/imLq0fazgAHF5MumBtuh3YwJsPfGdeNqgY1qqqfcSprRLgr7rWZzWbwCTL8HLKFYEEgkrUn+eHIDzNbltBSG33O+jcnxNZmrYcw5Yc7hoXotRenRPyz0IgBzrGYkTp9qEtxiEV10eEKD08Wgh7bzwTonSvIV/soK5jd53rE6I0eGY3/PL5wWYxQ+nFgShRKqK6LqTwhJNEafRKNQHCcWK3WmDHqR5NlMoSQzAWUV+9vkBMsKXYLCSbs3Oe+SGqqupGrIL3h3YclifYkjo7yZ7izIzUUGrhnvXAzA+PURkR8xCwPnMVsCUVpW0bsiCUKOH9S0980JvaLJSQUTal9Q+9/RgRJQSgnvgCgdBkxkCKektSpC9cR0HCOQgiZUMI3njijwYg+COzLP9rkLr7E3Dn4Gbhp7BPDC+n0TkhlK2zJpccuSBIfVdsutVdt9U4pLbjtVC2B0cKYN/N50LZHh0rFGGguztV14aFsvWfLiVhSrVboaSlXyjbk/NlBNKFVLT0k7INX3KAx+sXfkBlKzjpJItGLlcmhmSkptAB83h9MTuCICxBRUkMwUmY5+uFPY7LmJ7GW05SZycsSos9xUsmSr8BfgGeWI6+BgEAAAAASUVORK5CYII=","comp/button.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABFCAYAAAAPWmvdAAABA0lEQVR4Xu3ZMRGDUBRFwXwfKSgxFhfRgAbUxEakkCEO3qmX+p9m5w7NW9v7cz18I4EFbeT1fwxtbgYtmEGDVgRC458GLQiExNKgBYGQWBq0IBASS4MWBEJiadCCQEgsDVoQCImlQQsCIbE0aEEgJJZW0Pbj64Q3hFvQhmL3CQ8atLlAKCwNWhAIiaVBCwIhsTRoQSAklgYtCITE0qAFgZBYGrQgEBJLgxYEQmJp0IJASCwNWhAIiaUVtOfrdMIbwi1oQ7H7hAcN2lwgFJYGLQiExNKgBYGQWBq0IBASS4MWBEJiadCCQEgsDVoQCImlQQsCIbE0aEEgJJYGLQiExNIC2g/MxaMp6CSauwAAAABJRU5ErkJggg==","view/bg_tool.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAMklEQVRYR+3QQREAAAjDMCYG/DsEGXxSBb2ke7YeiwECBAgQIECAAAECBAgQIEDgW+AAAeIuAVS/mngAAAAASUVORK5CYII=","comp/minBtn.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAA8CAYAAAB1odqiAAAArUlEQVRYR+3X0QmAMAwE0GQN19B9nM193CmiIH7ZXOAoRc/fpjl8jVDdOj/eOc8USBcXqUjLAtDQRMSOdHb3JatTYCZUXodIy10bGxTI1Lx6/YA0Ima6W2tKFcjmdpGKtCow7NBAdxozy+804Gfx/cDqbLzWDzs0ekNY4B9nOMEehMKTVIEEyKeFSKmc18+MppRtipJuYPCa1SkwEyqvo6Tlxm8bFEijvBt9n/QA/fOPydLHcUIAAAAASUVORK5CYII=","view/zoom_out.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAoCAYAAAD6xArmAAACy0lEQVRIS92WQU8TQRTH/28oQkj0CL0QOMAJQkz4DkS6A+GA+A00Hrhj0uy8NiTwEdBPAOrB0Fnq3U8g6gkOSjxUjpCQCu08M5u2qaVAt7YmOqfNZPa3b9/+Z35L6NOgPnHx98Gbm5sTlUplA0AGQBpACcBBKpXazmaz3+5607YVM/MjEXlNRPdbASJyTkRrzPz+Nvg1MDNPAvgI4AGA10qpvHPuSCk17ZwLAazV4HPM/PUmeDvwSwBPAbxl5sf+RmYWZo7XMvOehwPYYebnScAnAMaVUrNhGH5pBefz+Rnn3GcAJ8w8kQT8E8A9AEMA/HXrqM9fMrO/bjvataJvFdd7/IaZfS9/67ExZpeIngB4xczPklQ8KSKHPmoispdKpXKjo6PHp6enU5VKxXhoV6moVXhnjpVS5wDOwjD81K7qG7e033lXV1cviMjvvDEAP0TkYHBwcKtarT4UkXcALolo1RhTaIV3dVYYY9aIyOfZDw9fMcYUm+FdgWvtYgCmBisrpRbCMPxQh3cNbgM3zJzvCdhDcrncuojMA8gy8/eegTvO8U0Lk87/UY9ve9h/BI6iyJ+1GyLScB4RHQDYDoKgO+dFURSfFQCuOQ9A7LwgCJI5r1gsTlar1YbznHP5crl8NDw8PK2Uip3n4QMDA3OLi4udO89a23Ce1jp2nrVWtNbxh7bWxs4jop0gCDp3XhRFJyIy7pybXV5ejp3XDN7f359RSsXO01p37jxrbey8i4uLoZGRkWvOa5q/1Fp37rx+VtxwntY6dl5zK6Io2hWR2Hla686dV0vFoY+aP8xFJJdOp49LpdIUEZkaNHkqfIWd5JiIzkXkLAiCZM7zO09EYueJyBgRxc4joi0ADeeJyOrS0lJvnBdFkf8xbDhPKbWSyWR647xCocC+53XnAVjQWvfGeS1wo7XunfOstesA5pVS2Uwm8w877xeHf444cscwYAAAAABJRU5ErkJggg==","view/refresh2.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAA/CAYAAAAPIIPGAAAEIElEQVRYR+2XTUhjVxTH/+fGpBrGT/xoBQdFFMMQLNLNbLooLbaFzqKMUhCSZwsuhGG6KCNd6DuRLgqzmGVxUd8LUrpoYWZTKO1yNi2F1oVtceEHflSLqNEav8bklPuqgsl75sUPSsucTQj33v895+R/7y+XcA1B16CJ/6GoYRiDItKfzWZjExMTv5/XtoLlx2Kxm0qp1wH0AHgTwC4RfWRZ1mdewp6ig4ODN9Lp9CMieh+AchH41Lbtj92EXUUHBgaCh4eH3wJ4zSObGSLqtSzrZ9+ihmF8CODR8YIflFL3MplMNxF9IiJWIBC4Pz4+/ldR5RuG8QuAlwGsAWi3bTsVj8dvAWhOJpPfFPK2a/mGYewDeAHAV7Zt9+aK9PX1VYRCoVcApNxa4CX6J4B6AE9t2341V9QwjO8AvAFg27btytxxL9EvAbynJxNRj2VZX58sjMfjd4joyT9D9NiyrHf9iup+/gggBCALQPfxVwARAO8cWywD4LZt2z/5EtWT+vv774rIBIBSlx/mmT5dyWTyC9+WOpkYi8XalVIPRKQbwItEpHv9PRE9tCzrt6IsVcgyhcYLnv1CAkWXfxFBxzEXXXipq+8imz7P9CJdO3+N754y86A+vYFAIDY8PHw58DHzTQB54DNNs3jwMfONY6R4go+Z/YNvbGwsuLKyci74APQys3/wMfMZ8InIPaVUt4g44AuHw/eHhoaKAx8znwEfM6dGR0dviUizaZoXA59pmvtE5ICPmfPAx8wVABzwubXA1VLM7IBPRJ4mEok88DHzKfiY2R/4mPkUfCLSk0gkTsHHzHdE5Immnog8TiQS/sDHzK7gE5EIEZ2CTyl1e2RkxD/4TNO8S0Su4BORZ0qpftM0iwefaZrtAB4QkQM+AA74ADxk5ufgc78CfV99xdy61yMajUbfAvA5gJeKycZj7gqADygajf5xRYIn+6xoUbmCDM9I/LuidXV1qK2txdzcHPb39ZPAOwpmGgqFUFFRgerqauczm81iaWkJa2v64eLhU6+eKqXQ1NTkZOcWq6urWF5edh1zzZSI0NbWhvLyctdFBwcHmJ2dxe7urn/R+vp6J0sd6XQaCwsLqKysRGNjI9bX17G4uIhMRr8jiig/EokgHA7j6OgIU1NTjkBZWRl0f7e2tgo60LX8rq4u/UjC5uamU2ZuBAIBZ1O9mVsLXEU7OztRUlKCnZ0dTE9P54nqfmsnaNHJycm8cVfRlpYW1NTUOJN1pjrjk6iqqkJra6vzNZVKYWZmxp+oLq2jo8NpgQ7dx729PZSWlkKL6hARpwr9Q+aGp/m12Zubm6H9mhtacH5+HhsbG/4tdTJTZ9bQ0OD0LxgMOm7Y3t6GNv55R7XgMS3oH5cJ/y3Rq775V3X5bx8zSv8DuWzoa2vgb5tumbHGlerDAAAAAElFTkSuQmCC","view/settings2.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAA/CAYAAAAPIIPGAAAD2ElEQVRYR+1Xz08bRxT+ZjAGYQoH4rS9IBJBQJEsUC8VKNdQtamUE0fLayqhKHeOaGbFkT8gFVLZtXzk1qqKSs4NUg8RXCIQVoOQ2jRFHHCwBRj2VW+zttY/14BXVaPOyR7NfPN9771536xACEOEgImPDHRhYaHv/Pz8kEMVjUbjq6urxVZhayo/lUo9chzndTabfWMYxkMAGx7QrG3bL5LJ5B0p5f1MJvNz7QENQdPp9LdE9CMAZrcHYAaoxJ8AvARwD8AtAI9t2/7JD9wQdH5+/q7jOLzx04DqeCelnFlbW/s9EJQXGIbxq8eQ//4mhPieiJjlEwBf8qQQYtOyLFZRNeqYJpPJWCQSeUBEzz3JrwqFwvT6+vo575ybm4vGYrFNAF8AICnlbKlU2sxms4Uych2oYRh5AJ9UFggxb1mW5aeSTqfTRLTmm3tv2/bAVUCfWpb1zA9qGAaHwD/XGjQU+WVGHU0Ug4ZSUjXFnwMwXVP8nP1RAPG2i5/Z+q9pKpWaFUL8wvNE9FUmk9m48jWtLWavofztNZTb124oN2neH1mTvmoo/pcfHDGtdZ9nLbw4rrW+nvGZpvlISvl6aWnpjWmaD4nINT4hxKxS6sXy8vIdx3HuK6XaMz6ttWt8QohDInKNTwjhJtWzlJdCiHtEdEtK+VgpFWx8Wuu7RMQbWxofEb0TQsxordszPq11Q+MjoidCCNf4AGxqrYONb2VlJVYsFh84jvPck/yKW5/W2jU+rXWUwdj4OBQcYzbCxcXF5sanlMoLIaqMTylVZXymaVYZHxG9N02zufE1AH2qlKoyPqUUh6AyFwgaivzyVehoorxkdL6k/MUPIEdE0/7i5zcUGx8Rxdsufmbrv6ZKqSrjM01z48rXtLbFeA3FNT4At6/dUIJ7V/MV/6HOn0gkvgbwA4DPbyLZ2/sWwHcikUj82SHAMqe3DMrv+I6Ofw9USonJyUlXzfb2NhzHaamsKdPBwUGcnp7i7OwMAwMDGBsbc4H29vaQz+fR09OD3t5eHB8f1x3QEJQBR0dHcXFx4QL39/dXbTw5OXEBI5EIcrlcHXBDUGYxPj6O7u7uljJLpRJ2d3ddNf7RVD6DlhkWCgUcHrof0YjH44jFYu5vnt/Z2QmWz0lhsHIMi8Wiu/HDF6T7mMDExAT6+vjR8iHGHA5/8uqYTk1Noaurq3L6/v4+jo6OqtgMDQ1hZGSkMnd5eYmtra3K/0DQg4ODivTyLg7B8PBw+6ChyC8f39FEMWgoJRVK8TPbjl/T2mruWEO5SYMNo/P/xaDfeB712U3YeXv/ALDwD+TbY8Dbd9BBAAAAAElFTkSuQmCC","view/setting.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAkCAYAAAC9itu8AAACAklEQVQ4T5XUS4iOcRTH8c9xCeVeiiiXhSJRJFIusRO2lEtZKFlgY6GxZDUrk2TFwii22JJLlERRLKRQJmXBkHIb8+hM/2d6ememed93957n93v+55zf9/mHll9VVTNxopTPR8T3piTyT1VVs7AL9zEd+4roOn5gK25HxLfacAjL8A8TWw6ta28jorc2LMLhIu7Ds2Jah4XlRVci4mNUVTUDadiLFF/G5GL4iyOYjxsYMnQ1BDfxujk0VmJPecFAO4bV2Nk05Bqzz3Za6ut86JJDx2vN4Hbj3hjBbcOt4eCaQZXUj5daT4pGoNFimI1zpdYVEf2jsTQX+5MX5NaOFdFFJHzJ2bWI+FJv6SRWYACTWliqa68ioqc2LMWpwtJ7PCymzVhSWOqOiHeZdPachqNIcXdBJV/2B6cLa5cwZLjQYOkqnuNsOeEM1uJgE43xDBsaH9QQfJ21VNBoHfpBaWHLiKGLoeO1ZnAHkpcxgkvOeoeDa0FjTnNLEfF1PJamYkcR3YmIX6OxNA35Kb7BFKwvoqf4jeV4GRE/azQ2Yh4GMaGFpbr2OSKe1Ibse1MRJ84fimkxMqc0Pc55MrjsOYvZRoofNW6/vPUSwEQ+2+tPQ14h9fX4Ap+aQ2MB1pQTB9sx5K24qmnorKWCRvtDF0PHa+0suBaW0ry91O5mus3n/wHmQwUTIH+tVgAAAABJRU5ErkJggg==","view/refresh.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAkCAYAAAC9itu8AAACiElEQVQ4T4WVS4iPYRTGf4/7/X6XcivXcktEUhTKQkqyYCOKjWyUhezFThbIlJ3LYrIRkoWGUhhhTMko4zJujYRpxgxHj9737/P3zfh239c57/uc5/zO+UQ3T0QsBRYCtZI+5jBVx0fEcGA6MA+YCXQCVyXddWwlISL6ARuARcXvhQPrJF3/nRARvYHtwLRuFLYCFyW15ITl6XTHvwIuJzlrgHrgiqSOiqSI2ANMAL4BxyW1R8RYYKSkp8Vb8w2HgD7AE0kXSozoD0wC2nPCAWAw0CyppiRhBzAD6MgJW4D5KdDFNeSkiJgFbEvONeYE698N2K0ArPsDMAZwguN+AmeKfZgLbAb6llj7A7gk6eFfnY6I0cDKpNc1tQFNwG1JvvFPp0sKXQ2sAGokveuJpVHAHGBJ4ul76vLNapbs9dYk6R8oU7driyztA2Z3w5L1n5LUnBPWptMd/xw4l+RscsHAeeNSZMloTAG+AIcltUXERPdB0qMylk4klu5LOlni2ABgqm3Oko4BQ4Fnko6WJOxPzlXg2wV4hv2czuOYhmsBsDf1rD7fYP0HkyyzZN0twHjACZmlI0WWFgM7e2DprKQ71SyNA9YDBnFYcq0RuOZ5/h9LdsVS6yV97YmlgYDn2X3wjUa7QdKLapY8015ePrWMJVtembhewLI0YWU4eZvck/Q525pXo4M/AY+TLMP40u+SuooseVjsitm/IakzItz5QcXhKSZsBCyrpdjlwuZwfSO8mLOkdYAHqFXSrRKWvErtXFdOcJcnp0AX96ZwuldQ5uxtTrD+VUmWWXqfujwk8eQ4f68rsuRG+d/gZVb9eIk9kPS6miXvIv91rNc12TXPc5MkTyO/AFhJCujHqZlCAAAAAElFTkSuQmCC","comp/checkbox.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAqCAYAAACDdWrxAAABbUlEQVRIS+2TP0gCURzHv88GRYsrExyOo5cEQVEtWdQQpE4N0R+HxmirXXCrKYigqMF2IRqCQByaLJqNIFpyUIzu4rIwpExODy88ITD/cJ603Rsf7/OGz+/zI5TSEAE20cZRgBMySKni8XrbwICrWAwG2ESZIadFS53J0R25brCyHZNud1vbcRuPV7fDAOu9GXJatNSZHN2R6wb/PfJCrxOZCR8Gbk6hWc6Xg8PrcgBETMIVPdIGSjYG/NoOSHcfkLqDK3qsBSRIrgRAuBF1quUPEUPhYGMwb2dhywrqQ3F0Dt++jSokJMBdhmDO52pB2WwFP7OK8rgH9os99IgppNf3QWwMFP4RNHKALrmoflIj53l6CaWpRcBkgiIkYHl6gDTrh5JJg57v/kJ1YOUixw7jfWELxMpAKUmAXAR7tg3LZ7am3IbjKDBOvPiDqkUmcoj+9H1d7k3nmHdweBubB70ON9wRzQH8pVVQb+Q/zZAEfpwDCU4AAAAASUVORK5CYII=","comp/btn_close.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAA8CAYAAAB1odqiAAAE6UlEQVRYR+3Y30+bVRgH8G/T0t/0Jy0USrIsC0E2GMKAVYcRpmSbEzIGZhqyxCxeceGVF3pjvJl/wYyJWZYY4hZBFnBuBBUW2ewYAxlsSMiyLKH8aEt/0vZtSxvM+562We15C6jlxr53zfO8z+ec5z2nOTmCk598tY19fAQs+Hlvz76QX1zpAwd+1NMNXzieU1QtFeKbvn4CXvqgC95wLKegRirC1e8GCPjh+53wMnRwedkG54aLG4yhSI/ycnPawHaKJ5M1MhGuXR8k4MX3OnjBx3NPcLX3DPfepSu3odfrYC4r5X7bVlbhcrnT4kdrjlA7xYLffj9EwJ6udnhCW9TEJ08XUgWTqE6n5XLdbk9G7MjhKmodrbwAfQPDBLxw7h1ecH3dDq/Xm1GYrZqceXIgGo0GJSXFvOCNmz8RsLv9NNyhKO+icTqc8Pl8acDLyWyr1Wo1DEYDbw2dXIz+4TsE7DzbBneQH2SruDZc8Pv9GSiLqVQq6Iv0WVe5TiHG4K1RAnaceguuYCTrCx63G4FAgAoqlUpodbqs7+sVEgyN/ELAs20t2Ajwgz6vF6FgMGtL5QoF1BoNL1qklODW6DgBT518gxcM+P1gQqFdLRqZXA6lSkVFWXDk198I2NZyAs7NMDXR7XRmYBKZjMuNMEzmljHQF46hUIrR8XsEbG228IJ+T/rGFkskkMoVHBgOBRGNRNI2vkpL/5YsODZhJeCbJ47D4WeoM4wyDLai5PsWiCUQJ2aXTN4pnswzqmS4e+8BAZstDbxg1qW3hyALTlinCPh6Uz1C0Rg2w/S/tz3UpaYWSgsgF4twf3IagvOXr297PR5YGuv+bd2s71sfzkCj1ULQe+3u9vraGlg0lw+LlZhMEIzUNu7vmYYFmz/9LJeTS9We+PIymaGl6wLizo2cokJDEawDNxLg+W7EHTkGjUWw/tBPwOMdnYg7nNQZep4/Q2B9jYspS0zQHjyUlrdTPJksNBrwYGiQgE3vtiNup4O2SSuOzk5y7z2ubYKyuBiaAwe5394XzxGw29Pi5iYLdeDCYgMmfxxOgKfPIG53UBNt049SBVNo4g864HRmxMz1x3hAIybv3CZg49ttiK/bqYneFRuCLldGYTY5OfPkQBR6PTRl6cfIVEtLivHw51ECNrS2Ir62zrtKfWtrCHo8acDLyWyrFVot1CYTbw2hqQRTY2MJsLk5K8hW8TkcCPp8GSiHqdVQG41ZtxUHTkwQ8NhrFsRXyUrke3wuF0L+TSooVxVCrc9+iBKWmvDodysB65saEFtZ5cX8Hi+YQDBrS2VKBVRa/jONqKwU05NTBKyrexWxlRUquOnfBBNidrVoZHIZClWF1DqisjLMzPxBwNraasRsdHDD6c7ApDIJVzTMRDJiRQb6EUNkLsPs7DwBa6qrELPZqCNzu/1pG1siEUOhkHK5wWAYkUg0La7T0U9tIrMZc/MLBKw+XImtZTrIMBFEouQkIBEXQJaYXXJ0O8WTeQXlZsw/XSRg1SsVvGDWpbuHIAsu/LlEwMrKCsQDAcQ93j2U2H2qUKuBUKnE4uISBF9f/Hj7wJwVhyordl/hH2Q+W1zCixoLOdNUj98Ei+byYbH5lnPkmJhL6O+18/c0/1m38/c0qVbm72nYVuTvadgu5O9pUtsif0+Tv6dhF8P/657mLz4NfQVdLmZiAAAAAElFTkSuQmCC","comp/textarea.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFsAAAAXCAYAAABkrDOOAAAA4klEQVRoQ+3ZvQrCMBiF4e9rU+sPOErRqxDRe/KG9Fp0EAc3VzuIg1ML4uDmlkaaquDenMUTyJoDD+8W3ZyKlaoshSeogHOy1m1euOmoI1EU+auqQUf/8XHnnBzLp3jsWdaVJEnEGEPsADXU2Ifro8Gej/uSpqnHruvmaVegqirZX+4N9mIy8Nh13XEct7vE18RaK7vzjdiIFoiNUH5vEJvYQAHgFMsmNlAAOMWyiQ0UAE6xbGIDBYBTLJvYQAHgFMsmNlAAOMWyiQ0UAE79lM2fmrDy358a/q6Hhf68ng175QueKdEXxUGVVwAAAABJRU5ErkJggg==","view/re.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAoCAYAAAD6xArmAAACpklEQVRIS+WWPUgcQRiG3+8O70QEUwTB1EJgsTGdRRrhOMjOtEtSRbBIBMFKuCtkZleES2uRQoWQJggKKW7Of7GyTRvBLkVShhS73OXMfWGOU85Es7uXs0m2XeZh+OZ95xnCHX10R1ykBvu+P5fP59+VSqVvf9pUarBS6jWAR0Q0rbWOboP3BCaiOQAHAKTW+vtN8L8BW96W4zjPPM/78Ss8FlypVEYajYbHzALAJIAHALJdoDWl1Esi4m74rWBmpiAI5pk5AHAvJj0VrXU5Fmyhvu+/AfA8YRxfaa1LsWDf92eZeSMJlJnXtdYvEo1Ca30G4GEH/ImI1lqt1nE+nz9vNBrLnVTY39uO4zxNdHgrKytjzWbzs13FzKfDw8PFxcXF8HL3Nscd8BEAN3HcgiCYbLVaHyyIiGaUUm+7R9JzQZRSo0T0BUCGmRd831/tBttK53K5zXK5/DV1pZVSG0Q0C2BXa/0kySEmKojWeoiZD4hoKpvNTiwtLX1MC7+1IFrrQWZeJaJxx3EKN5186lF0LwiC4DEz31dKvU+z69i7Ig0stnm9wv4zsDGm7bxCodBf5xlj2s5j5mkpZf+c1wHPEdFBGIbS87z+OO8S3EnAVhRFvTnv8PBwpF6ve0QkiGiSmX9znuu66ZxXq9XmAcQ6j5krUspkzqvVaqmcJ4SId54xxl6ZiZwHYN113WTOq1arZ0R05TwAa5lM5rher5/ncrllAPYl1HZeFEXJnLe3tzd2cXHRdh6A04GBgWKxWLxyXlcqjqIochPHbWdn58p5AGaEENec13NB9vf3R5vNZtt5RLTguu4159lKA9gUQqR3njHGHpx9tOxKKfvnvGq1OmQrC2AKwIQQon/OOzk5GQzD0I5hPIqi/jvPGNN2npTyH3feTzoJOzgswwlqAAAAAElFTkSuQmCC","view/search.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAqCAYAAABcOxDuAAABX0lEQVRIS+3VsUrEQBAG4H9HiDZiJQg+gJVaiKAoWClYXWeZ7D6CtbWFr5Ai2ayQxkLQRgsLGwtBUQsRC6sDCxHxEIvIZSRwxRGSu83pNUe23c0H+89kR2AISwzBxAiinuctCSH2AawD+AFwRkR7QRC85CO0ur5SaoOZzwGM54A3IlrJw1aolPIewEJJUY+01jvde31RKeUMgNceXdLSWk9VQl3XnSWiZhnKzF9RFE1WQrPDUsonAHNFsBDiJAzDRmXUdd1tIjoFMJaDW0KI1TAMH61RpdQ0Mx8z8zMzHxLRAYBlAG0Al2ma7hpjHqxbqgNeAJgHcKW1XutEMeE4Ttv3/axXC1dh9XPgbZqmW8aYd9t3ohCVUt4BWARwkyTJZhzHH7Zgdq4MvQbw7ThOw/f9zypgKVoVsS7UX+C+v+kgeI0Oklrvb0Yw03rwlZW8Hnz14OvqjXrw1e/pPyfwCww91CttlMG7AAAAAElFTkSuQmCC","view/save.png":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAoCAYAAAD6xArmAAAA1klEQVRIS+2VzQ3DIAyFwxwdoMMAA/VQ8ZByyEBhmA7QOVxxKLIaOcIoSZUfrlifHw/wM91Ky6zE7SZgANTaDEDhzYJ5odSMC7nA5U7+b4X2dVQr3ic4hHCTlMcY33xPZUUGcwBvdEJwjcfGGIQQ4rd2qenWA3hyAUuABwCP31NtN+i1v02qP4DicRybM885J2ceB/NCyUupfuLxBS4WbmKF9rNUv4p9gq21d0l5SunF91RWZDAH8EYnBNd4nDPPWitnXst0I6Leez+feVowEQ3e+wNk3ge7C/Qp3GfwkgAAAABJRU5ErkJggg=="};},'base64',function(){return this.base64=new Base64Atlas(Base64AtlasManager.dataO);}
		]);
		return Base64AtlasManager;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-24 下午3:00:38
	*/
	//class laya.debug.DebugTool
	var DebugTool=(function(){
		function DebugTool(){}
		__class(DebugTool,'laya.debug.DebugTool');
		__getset(1,DebugTool,'isThisShow',function(){
			return false;
		});

		__getset(1,DebugTool,'target',function(){
			return DebugTool._target;
			},function(v){
			DebugTool._target=v;
		});

		/**
		*设置是否显示帧率信息
		*@param value 是否显示true|false
		*/
		__getset(1,DebugTool,'showStatu',null,function(value){
			if (value){
				Stat.show();
			}
			else{
				Stat.hide();
				DebugTool.clearDebugLayer();
			}
		});

		/**
		*是否自动显示点击对象的边框
		*@param value
		*/
		__getset(1,DebugTool,'showBound',function(){
			return DebugTool._showBound;
			},function(value){
			DebugTool._showBound=value;
			if (!DebugTool._showBound){
				DebugTool.clearDebugLayer();
			}
		});

		DebugTool.getMenuShowEvent=function(){
			if (Browser.onMobile){
				return /*laya.events.Event.DOUBLE_CLICK*/"doubleclick";
				}else{
				return /*laya.events.Event.RIGHT_CLICK*/"rightclick";
			}
		}

		DebugTool.init=function(cacheAnalyseEnable,loaderAnalyseEnable,createAnalyseEnable,renderAnalyseEnable){
			(cacheAnalyseEnable===void 0)&& (cacheAnalyseEnable=true);
			(loaderAnalyseEnable===void 0)&& (loaderAnalyseEnable=true);
			(createAnalyseEnable===void 0)&& (createAnalyseEnable=true);
			(renderAnalyseEnable===void 0)&& (renderAnalyseEnable=true);
			DebugTool.enableCacheAnalyse=cacheAnalyseEnable;
			if (DebugTool.enableCacheAnalyse){
				RenderSpriteHook.init();
			}
			if (renderAnalyseEnable){
				SpriteRenderHook.init();
			}
			DebugTool.enableNodeCreateAnalyse=createAnalyseEnable;
			if (DebugTool.enableNodeCreateAnalyse){
				ClassCreateHook.I.hookClass(Node);
			}
			if (loaderAnalyseEnable){
				LoaderHook.init();
			}
			DisplayHook.initMe();
			NodeInfoPanel.init();
			if (!DebugTool.debugLayer){
				DebugTool.debugLayer=DebugInfoLayer.I.graphicLayer;
				DebugTool.debugLayer.mouseEnabled=false;
				DebugTool.debugLayer.mouseThrough=true;
				DebugTool.showStatu=true;
				Laya.stage.on(/*laya.events.Event.KEY_DOWN*/"keydown",null,DebugTool.keyHandler);
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.IMAGE*/0x01]="IMAGE";
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.ALPHA*/0x02]="ALPHA";
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.TRANSFORM*/0x04]="TRANSFORM";
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.CANVAS*/0x08]="CANVAS";
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.GRAPHICS*/0x100]="GRAPHICS";
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.CUSTOM*/0x200]="CUSTOM";
				DebugTool.cmdToTypeO[ /*laya.renders.RenderSprite.CHILDS*/0x800]="CHILDS";
				DebugExport.export();
			}
		}

		DebugTool.dTrace=function(str){
			if (DebugTool._traceFun !=null){
				DebugTool._traceFun(str);
			}
			console.log(str);
		}

		DebugTool.keyHandler=function(e){
			var key;
			key=String.fromCharCode(e.keyCode);
			if (!e.altKey)
				return;
			switch (e.keyCode){
				case 38:
					DebugTool.showParent();
					break ;
				case 40:
					DebugTool.showChild();
					break ;
				case 37:
					DebugTool.showBrother(DebugTool.target,1);
					break ;
				case 39:
					DebugTool.showBrother(DebugTool.target,-1);
					break ;
				}
			DebugTool.dealCMDKey(key);
		}

		DebugTool.dealCMDKey=function(key){
			switch (key){
				case "上":
					DebugTool.showParent();
					break ;
				case "下":
					DebugTool.showChild();
					break ;
				case "左":
					DebugTool.showBrother(DebugTool.target,1);
					break ;
				case "右":
					DebugTool.showBrother(DebugTool.target,-1);
					break ;
				case "B":
					DebugTool.showAllBrother();
					break ;
				case "C":
					DebugTool.showAllChild();
					break ;
				case "E":
					DebugTool.traceDisMouseEnable();
					break ;
				case "S":
					DebugTool.traceDisSizeChain();
					break ;
				case "D":
					DisControlTool.downDis(DebugTool.target);
					break ;
				case "U":
					DisControlTool.upDis(DebugTool.target);
					break ;
				case "N":
					DebugTool.getNodeInfo();
					break ;
				case "M":
					DebugTool.showAllUnderMosue();
					break ;
				case "I":
					break ;
				case "O":
					ObjectCreateView.I.show();
					break ;
				case "L":
					DisController.I.switchType();
					break ;
				case "Q":
					DebugTool.showNodeInfo();
					break ;
				case "F":
					DebugTool.showToolPanel();
					break ;
				case "P":
					DebugTool.showToolFilter();
					break ;
				case "V":
					DebugTool.selectNodeUnderMouse();
					break ;
				case "A":
					if (NodeToolView.I.target){
						MouseEventAnalyser.analyseNode(NodeToolView.I.target);
					}
					break ;
				case "K":
					NodeUtils.traceStage();
					break ;
				case "T":
					DebugTool.switchNodeTree();
					break ;
				case "R":
					RenderCostRankView.I.show();
					break ;
				case "X":
					NodeTree.I.fresh();
					break ;
				case "mCMD":
					DebugTool.traceCMD();
					break ;
				case "allCMD":
					DebugTool.traceCMDR();
					break ;
				}
		}

		DebugTool.switchNodeTree=function(){
			ToolPanel.I.switchShow(/*laya.debug.view.nodeInfo.ToolPanel.Tree*/"Tree");
		}

		DebugTool.analyseMouseHit=function(){
			if (DebugTool.target)
				MouseEventAnalyser.analyseNode(DebugTool.target);
		}

		DebugTool.selectNodeUnderMouse=function(){
			DisplayHook.instance.selectDisUnderMouse();
			DebugTool.showDisBound();
			return;
		}

		DebugTool.showToolPanel=function(){
			ToolPanel.I.switchShow(/*laya.debug.view.nodeInfo.ToolPanel.Find*/"Find");
		}

		DebugTool.showToolFilter=function(){
			ToolPanel.I.switchShow(/*laya.debug.view.nodeInfo.ToolPanel.Filter*/"Filter");
		}

		DebugTool.showNodeInfo=function(){
			if (NodeInfoPanel.I.isWorkState){
				NodeInfoPanel.I.recoverNodes();
			}
			else{
				NodeInfoPanel.I.showDisInfo(DebugTool.target);
			}
		}

		DebugTool.switchDisController=function(){
			if (DisController.I.target){
				DisController.I.target=null;
			}
			else{
				if (DebugTool.target){
					DisController.I.target=DebugTool.target;
				}
			}
		}

		DebugTool.showParent=function(sprite){
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			}
			DebugTool.target=sprite.parent;
			DebugTool.autoWork();
		}

		DebugTool.showChild=function(sprite){
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			}
			if (sprite.numChildren > 0){
				DebugTool.target=sprite.getChildAt(0);
				DebugTool.autoWork();
			}
		}

		DebugTool.showAllChild=function(sprite){
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			}
			DebugTool.selectedNodes=DisControlTool.getAllChild(sprite);
			DebugTool.showSelected();
		}

		DebugTool.showAllUnderMosue=function(){
			DebugTool.selectedNodes=DisControlTool.getObjectsUnderGlobalPoint(Laya.stage);
			DebugTool.showSelected();
		}

		DebugTool.showParentChain=function(sprite){
			if (!sprite)
				return;
			DebugTool.selectedNodes=[];
			var tar;
			tar=sprite.parent;
			while (tar){
				DebugTool.selectedNodes.push(tar);
				tar=tar.parent;
			}
			DebugTool.showSelected();
		}

		DebugTool.showAllBrother=function(sprite){
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			}
			if (!sprite.parent)
				return;
			DebugTool.selectedNodes=DisControlTool.getAllChild(sprite.parent);
			DebugTool.showSelected();
		}

		DebugTool.showBrother=function(sprite,dID){
			(dID===void 0)&& (dID=1);
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			};
			var p;
			p=sprite.parent;
			if (!p)
				return;
			var n=0;
			n=p.getChildIndex(sprite);
			n+=dID;
			if (n < 0)
				n+=p.numChildren;
			if (n >=p.numChildren)
				n-=p.numChildren;
			DebugTool.target=p.getChildAt(n);
			DebugTool.autoWork();
		}

		DebugTool.clearDebugLayer=function(){
			if (DebugTool.debugLayer.graphics)
				DebugTool.debugLayer.graphics.clear();
		}

		DebugTool.showSelected=function(){
			if (!DebugTool.autoShowSelected)
				return;
			if (!DebugTool.selectedNodes || DebugTool.selectedNodes.length < 1)
				return;
			console.log("selected:");
			console.log(DebugTool.selectedNodes);
			var i=0;
			var len=0;
			len=DebugTool.selectedNodes.length;
			DebugTool.clearDebugLayer();
			for (i=0;i < len;i++){
				DebugTool.showDisBound(DebugTool.selectedNodes[i],false);
			}
		}

		DebugTool.getClassCreateInfo=function(className){
			return RunProfile.getRunInfo(className);
		}

		DebugTool.autoWork=function(){
			if (!DebugTool.isThisShow)
				return;
			if (DebugTool.showBound)
				DebugTool.showDisBound();
			if (DebugTool.autoTraceSpriteInfo && DebugTool.target){
				TraceTool.traceSpriteInfo(DebugTool.target,DebugTool.autoTraceBounds,DebugTool.autoTraceSize,DebugTool.autoTraceTree);
			}
			if (!DebugTool.target)
				return;
			if (DebugTool.autoTraceCMD){
				DebugTool.traceCMD();
			}
			if (DebugTool.autoTraceCMDR){
				DebugTool.traceCMDR();
			}
			if (DebugTool.autoTraceEnable){
				DebugTool.traceDisMouseEnable(DebugTool.target);
			}
		}

		DebugTool.traceDisMouseEnable=function(tar){
			console.log("traceDisMouseEnable:");
			if (!tar)
				tar=DebugTool.target;
			if (!tar){
				console.log("no targetAvalible");
				return null;
			};
			var strArr;
			strArr=["TraceDisMouseEnable"];
			DebugTool.selectedNodes=[];
			while (tar){
				strArr.push(ClassTool.getNodeClassAndName(tar)+":"+tar.mouseEnabled+" hitFirst:"+tar.hitTestPrior);
				DebugTool.selectedNodes.push(tar);
				tar=tar.parent;
			}
			DebugTool.showSelected();
			return strArr.join("\n");
		}

		DebugTool.traceDisSizeChain=function(tar){
			console.log("traceDisSizeChain:");
			if (!tar)
				tar=DebugTool.target;
			if (!tar){
				console.log("no targetAvalible");
				return null;
			}
			DebugTool.selectedNodes=[];
			var strArr;
			strArr=["traceDisSizeChain"];
			while (tar){
				DebugTool.dTrace(TraceTool.getClassName(tar)+":");
				strArr.push(ClassTool.getNodeClassAndName(tar)+":");
				strArr.push("Size: x:"+tar.x+" y:"+tar.y+" w:"+tar.width+" h:"+tar.height+" scaleX:"+tar.scaleX+" scaleY:"+tar.scaleY);
				TraceTool.traceSize(tar);
				DebugTool.selectedNodes.push(tar);
				tar=tar.parent;
			}
			DebugTool.showSelected();
			return strArr.join("\n");
		}

		DebugTool.showDisBound=function(sprite,clearPre,color){
			(clearPre===void 0)&& (clearPre=true);
			(color===void 0)&& (color="#ff0000");
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			}
			if (clearPre)
				DebugTool.clearDebugLayer();
			var pointList;
			pointList=sprite._getBoundPointsM(true);
			if (!pointList || pointList.length < 1)
				return;
			pointList=GrahamScan.pListToPointList(pointList,true);
			WalkTools.walkArr(pointList,sprite.localToGlobal,sprite);
			pointList=GrahamScan.pointListToPlist(pointList);
			DebugTool._disBoundRec=Rectangle._getWrapRec(pointList,DebugTool._disBoundRec);
			DebugTool.debugLayer.graphics.drawRect(DebugTool._disBoundRec.x,DebugTool._disBoundRec.y,DebugTool._disBoundRec.width,DebugTool._disBoundRec.height,null,color);
			DebugInfoLayer.I.setTop();
		}

		DebugTool.getNodeInfo=function(){
			DebugTool.counter.reset();
			WalkTools.walkTarget(Laya.stage,DebugTool.addNodeInfo);
			console.log("node info:");
			DebugTool.counter.traceSelf();
			return DebugTool.counter.data;
		}

		DebugTool.findByClass=function(className){
			DebugTool._classList=[];
			DebugTool._tFindClass=className;
			WalkTools.walkTarget(Laya.stage,DebugTool.addClassNode);
			DebugTool.selectedNodes=DebugTool._classList;
			DebugTool.showSelected();
			return DebugTool._classList;
		}

		DebugTool.addClassNode=function(node){
			var type;
			type=node["constructor"].name;
			if (type==DebugTool._tFindClass){
				DebugTool._classList.push(node);
			}
		}

		DebugTool.traceCMD=function(sprite){
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return null;
			}
			console.log("self CMDs:");
			console.log(sprite.graphics.cmds);
			var renderSprite;
			renderSprite=RenderSprite.renders[sprite._renderType];
			console.log("renderSprite:",renderSprite);
			DebugTool._rSpList.length=0;
			while (renderSprite && renderSprite["_sign"] > 0){
				DebugTool._rSpList.push(DebugTool.cmdToTypeO[renderSprite["_sign"]]);
				renderSprite=renderSprite._next;
			}
			console.log("fun:",DebugTool._rSpList.join(","));
			DebugTool.counter.reset();
			DebugTool.addCMDs(sprite.graphics.cmds);
			DebugTool.counter.traceSelf();
			return DebugTool.counter.data;
		}

		DebugTool.addCMDs=function(cmds){
			WalkTools.walkArr(cmds,DebugTool.addCMD);
		}

		DebugTool.addCMD=function(cmd){
			DebugTool.counter.add(cmd.callee);
		}

		DebugTool.traceCMDR=function(sprite){
			if (!sprite)
				sprite=DebugTool.target;
			if (!sprite){
				console.log("no targetAvalible");
				return 0;
			}
			DebugTool.counter.reset();
			WalkTools.walkTarget(sprite,DebugTool.getCMdCount);
			console.log("cmds include children");
			DebugTool.counter.traceSelf();
			return DebugTool.counter.data;
		}

		DebugTool.getCMdCount=function(target){
			if (!target)
				return 0;
			if (! (target instanceof laya.display.Sprite ))
				return 0;
			if (!target.graphics.cmds)
				return 0;
			DebugTool.addCMDs(target.graphics.cmds);
			var rst=target.graphics.cmds.length;
			return rst;
		}

		DebugTool.addNodeInfo=function(node){
			var type;
			type=node["constructor"].name;
			DebugTool.counter.add(type);
		}

		DebugTool.find=function(filter,ifShowSelected){
			(ifShowSelected===void 0)&& (ifShowSelected=true);
			var rst;
			rst=DebugTool.findTarget(Laya.stage,filter);
			DebugTool.selectedNodes=rst;
			if (DebugTool.selectedNodes){
				DebugTool.target=DebugTool.selectedNodes[0];
			}
			if (ifShowSelected)
				DebugTool.showSelected();
			return rst;
		}

		DebugTool.findByName=function(name){
			DebugTool.nameFilter.name=name;
			return DebugTool.find(DebugTool.nameFilter);
		}

		DebugTool.findNameStartWith=function(startStr){
			DebugTool.nameFilter.name=DebugTool.getStartWithFun(startStr);
			return DebugTool.find(DebugTool.nameFilter);
		}

		DebugTool.findNameHas=function(hasStr,showSelected){
			(showSelected===void 0)&& (showSelected=true);
			DebugTool.nameFilter.name=DebugTool.getHasFun(hasStr);
			return DebugTool.find(DebugTool.nameFilter,showSelected);
		}

		DebugTool.getStartWithFun=function(startStr){
			var rst=function (str){
				if (!str)
					return false;
				if (str.indexOf(startStr)==0)
					return true;
				return false;
			};
			return rst;
		}

		DebugTool.getHasFun=function(hasStr){
			var rst=function (str){
				if (!str)
					return false;
				if (str.indexOf(hasStr)>=0)
					return true;
				return false;
			};
			return rst;
		}

		DebugTool.findTarget=function(target,filter){
			var rst=[];
			if (DebugTool.isFit(target,filter))
				rst.push(target);
			var i=0;
			var len=0;
			var tChild;
			len=target.numChildren;
			for (i=0;i < len;i++){
				tChild=target.getChildAt(i);
				if ((tChild instanceof laya.display.Sprite )){
					rst=rst.concat(DebugTool.findTarget(tChild,filter));
				}
			}
			return rst;
		}

		DebugTool.findClassHas=function(target,str){
			var rst=[];
			if (ClassTool.getClassName(target).indexOf(str)>=0)
				rst.push(target);
			var i=0;
			var len=0;
			var tChild;
			len=target.numChildren;
			for (i=0;i < len;i++){
				tChild=target.getChildAt(i);
				if ((tChild instanceof laya.display.Sprite )){
					rst=rst.concat(DebugTool.findClassHas(tChild,str));
				}
			}
			return rst;
		}

		DebugTool.isFit=function(tar,filter){
			if (!tar)
				return false;
			if (!filter)
				return true;
			if ((typeof filter=='function')){
				return (filter)(tar);
			};
			var key;
			for (key in filter){
				if ((typeof (filter[key])=='function')){
					if (!filter[key](tar[key]))
						return false;
				}
				else{
					if (tar[key] !=filter[key])
						return false;
				}
			}
			return true;
		}

		DebugTool.log=function(__args){
			var args=arguments;
			var arr;
			arr=DTrace.getArgArr(args);
			if (DebugTool._logFun!=null){
				DebugTool._logFun(arr.join(" "));
			}
		}

		DebugTool.enableCacheAnalyse=false;
		DebugTool.enableNodeCreateAnalyse=true;
		DebugTool._traceFun=null
		DebugTool.debugLayer=null
		DebugTool._target=null
		DebugTool.selectedNodes=[];
		DebugTool.autoShowSelected=true;
		DebugTool._showBound=true;
		DebugTool._disBoundRec=null
		DebugTool.autoTraceEnable=false;
		DebugTool.autoTraceBounds=false;
		DebugTool.autoTraceSize=false;
		DebugTool.autoTraceTree=true;
		DebugTool.autoTraceCMD=true;
		DebugTool.autoTraceCMDR=false;
		DebugTool.autoTraceSpriteInfo=true;
		DebugTool._classList=null
		DebugTool._tFindClass=null
		DebugTool._rSpList=[];
		DebugTool._logFun=null
		__static(DebugTool,
		['text',function(){return this.text=new Stat();},'cmdToTypeO',function(){return this.cmdToTypeO={
		};},'counter',function(){return this.counter=new CountTool();},'nameFilter',function(){return this.nameFilter={"name":"name"};}

		]);
		return DebugTool;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.Base64Atlas
	var Base64Atlas=(function(){
		function Base64Atlas(data,idKey){
			this.data=null;
			this.replaceO=null;
			this.idKey=null;
			this._loadedHandler=null;
			this.data=data;
			if (!idKey)idKey=Math.random()+"key";
			this.idKey=idKey;
			this.init();
		}

		__class(Base64Atlas,'laya.debug.tools.Base64Atlas');
		var __proto=Base64Atlas.prototype;
		//preLoad();
		__proto.init=function(){
			this.replaceO={};
			var key;
			for (key in this.data){
				this.replaceO[key]=this.idKey+"/"+key;
			}
		}

		__proto.getAdptUrl=function(url){
			return this.replaceO[url];
		}

		__proto.preLoad=function(completeHandler){
			this._loadedHandler=completeHandler;
			Laya.loader.load(Base64ImageTool.getPreloads(this.data),new Handler(this,this.preloadEnd));
		}

		__proto.preloadEnd=function(){
			var key;
			for (key in this.data){
				var tx;
				tx=Laya.loader.getRes(this.data[key]);
				Loader.cacheRes(this.replaceO[key],tx);
			}
			if (this._loadedHandler){
				this._loadedHandler.run();
			}
		}

		__proto.replaceRes=function(uiObj){
			ObjectTools.replaceValue(uiObj,this.replaceO);
		}

		return Base64Atlas;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.Base64ImageTool
	var Base64ImageTool=(function(){
		function Base64ImageTool(){}
		__class(Base64ImageTool,'laya.debug.tools.Base64ImageTool');
		Base64ImageTool.getCanvasPic=function(img){
			img=img.bitmap;
			var canvas=Browser.createElement("canvas");
			var ctx=canvas.getContext('2d');
			canvas.height=img.height;
			canvas.width=img.width;
			ctx.drawImage(img.source,0,0);
			return canvas;
		}

		Base64ImageTool.getBase64Pic=function(img){
			return Base64ImageTool.getCanvasPic(img).toDataURL("image/png");
		}

		Base64ImageTool.getPreloads=function(base64Data){
			var rst;
			rst=[];
			var key;
			for (key in base64Data){
				rst.push({url:base64Data[key],type:/*laya.net.Loader.IMAGE*/"image" });
			}
			return rst;
		}

		return Base64ImageTool;
	})()


	/**
	*base64编码解码类
	*@author ww
	*/
	//class laya.debug.tools.Base64Tool
	var Base64Tool=(function(){
		function Base64Tool(){}
		__class(Base64Tool,'laya.debug.tools.Base64Tool');
		Base64Tool.init=function(){
			if (Base64Tool.lookup)
				return;
			Base64Tool.lookup=new Uint8Array(256)
			for (var i=0;i < Base64Tool.chars.length;i++){
				Base64Tool.lookup[Base64Tool.chars.charCodeAt(i)]=i;
			}
		}

		Base64Tool.encode=function(arraybuffer){
			var bytes=new Uint8Array(arraybuffer),i=0,len=bytes.length,base64="";
			for (i=0;i < len;i+=3){
				base64+=Base64Tool.chars[bytes[i] >> 2];
				base64+=Base64Tool.chars[((bytes[i] & 3)<< 4)| (bytes[i+1] >> 4)];
				base64+=Base64Tool.chars[((bytes[i+1] & 15)<< 2)| (bytes[i+2] >> 6)];
				base64+=Base64Tool.chars[bytes[i+2] & 63];
			}
			if ((len % 3)===2){
				base64=base64.substring(0,base64.length-1)+"=";
			}
			else if (len % 3===1){
				base64=base64.substring(0,base64.length-2)+"==";
			}
			return base64;
		}

		Base64Tool.encodeStr=function(str){
			var byte;
			byte=new Byte();
			byte.writeUTFString(str);
			return Base64Tool.encodeByte(byte);
		}

		Base64Tool.encodeByte=function(byte,start,end){
			(start===void 0)&& (start=0);
			(end===void 0)&& (end=-1);
			if (end < 0){
				end=byte.length;
			}
			return Base64Tool.encode(byte.buffer.slice(start,end));
		}

		Base64Tool.decodeToByte=function(base64){
			return new Byte(Base64Tool.decode(base64));
		}

		Base64Tool.decode=function(base64){
			Base64Tool.init();
			var bufferLength=base64.length *0.75,len=base64.length,i=0,p=0,encoded1=0,encoded2=0,encoded3=0,encoded4=0;
			if (base64[base64.length-1]==="="){
				bufferLength--;
				if (base64[base64.length-2]==="="){
					bufferLength--;
				}
			};
			var arraybuffer=new ArrayBuffer(bufferLength),bytes=new Uint8Array(arraybuffer);
			for (i=0;i < len;i+=4){
				encoded1=Base64Tool.lookup[base64.charCodeAt(i)];
				encoded2=Base64Tool.lookup[base64.charCodeAt(i+1)];
				encoded3=Base64Tool.lookup[base64.charCodeAt(i+2)];
				encoded4=Base64Tool.lookup[base64.charCodeAt(i+3)];
				bytes[p++]=(encoded1 << 2)| (encoded2 >> 4);
				bytes[p++]=((encoded2 & 15)<< 4)| (encoded3 >> 2);
				bytes[p++]=((encoded3 & 3)<< 6)| (encoded4 & 63);
			}
			return arraybuffer;
		}

		Base64Tool.chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		Base64Tool.lookup=null;
		return Base64Tool;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.CacheAnalyser
	var CacheAnalyser=(function(){
		function CacheAnalyser(){}
		__class(CacheAnalyser,'laya.debug.tools.CacheAnalyser');
		var __proto=CacheAnalyser.prototype;
		__proto.renderCanvas=function(sprite,time){
			(time===void 0)&& (time=0);
		}

		__proto.reCacheCanvas=function(sprite,time){
			(time===void 0)&& (time=0);
			if (DebugInfoLayer.I.isDebugItem(sprite))return;
			var info;
			info=CacheAnalyser.getNodeInfoByNode(sprite);
			info.addCount(time);
			CacheAnalyser.counter.addTime(sprite,time);
			if (!info.parent){
				DebugInfoLayer.I.nodeRecInfoLayer.addChild(info);
			}
		}

		CacheAnalyser.getNodeInfoByNode=function(node){
			IDTools.idObj(node);
			var key=0;
			key=IDTools.getObjID(node);
			if (!CacheAnalyser._nodeInfoDic[key]){
				CacheAnalyser._nodeInfoDic[key]=new ReCacheRecInfo();
			}
			(CacheAnalyser._nodeInfoDic [key]).setTarget(node);
			return CacheAnalyser._nodeInfoDic[key];
		}

		CacheAnalyser._nodeInfoDic={};
		__static(CacheAnalyser,
		['counter',function(){return this.counter=new ObjTimeCountTool();},'I',function(){return this.I=new CacheAnalyser();}
		]);
		return CacheAnalyser;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.CanvasTools
	var CanvasTools=(function(){
		function CanvasTools(){}
		__class(CanvasTools,'laya.debug.tools.CanvasTools');
		CanvasTools.createCanvas=function(width,height){
			var rst=new HTMLCanvas("2D");
			rst.getContext('2d');
			rst.size(width,height);
			return rst;
		}

		CanvasTools.renderSpriteToCanvas=function(sprite,canvas,offsetX,offsetY){
			RenderSprite.renders[sprite._renderType]._fun(sprite,canvas.context,offsetX,offsetY);
		}

		CanvasTools.getImageDataFromCanvas=function(canvas,x,y,width,height){
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			if (width <=0)
				width=canvas.width;
			if (height <=0)
				height=canvas.height;
			var imgdata=canvas.context.getImageData(x,y,width,height);
			return imgdata;
		}

		CanvasTools.getImageDataFromCanvasByRec=function(canvas,rec){
			var imgdata=canvas.context.getImageData(rec.x,rec.y,rec.width,rec.height);
			return imgdata;
		}

		CanvasTools.getDifferCount=function(imageData1,imageData2){
			var data1=imageData1.data;
			var data2=imageData2.data;
			var differCount=0;
			differCount=0;
			CanvasTools.walkImageData(imageData1,myWalkFun);
			return differCount;
			function myWalkFun (i,j,tarPos,data){
				if (!CanvasTools.isPoinSame(tarPos,data1,data2))differCount++;
			}
		}

		CanvasTools.getDifferRate=function(imageData1,imageData2){
			return CanvasTools.getDifferCount(imageData1,imageData2)/(imageData1.width *imageData1.height);
		}

		CanvasTools.getCanvasDisRec=function(canvas){
			var rst;
			rst=new Rectangle;
			var imgdata;
			imgdata=CanvasTools.getImageDataFromCanvas(canvas,0,0);
			var maxX=0;
			var minX=0;
			var maxY=0;
			var minY=0;
			maxX=maxY=0;
			minX=imgdata.width;
			minY=imgdata.height;
			var i=0,iLen=0;
			var j=0,jLen=0;
			iLen=imgdata.width;
			jLen=imgdata.height;
			var data;
			data=imgdata.data;
			var tarPos=0;
			for (j=0;j < jLen;j++){
				for (i=0;i < iLen;i++){
					if (!CanvasTools.isEmptyPoint(data,tarPos)){
						if (minX > i)
							minX=i;
						if (maxX < i)
							maxX=i;
						if (minY > j)
							minY=j;
						if (maxY < j)
							maxY=j;
					}
					tarPos+=4;
				}
			}
			rst.setTo(minX,minY,maxX-minX+1,maxY-minY+1);
			return rst;
		}

		CanvasTools.fillCanvasRec=function(canvas,rec,color){
			var ctx=canvas.context;
			ctx.fillStyle=color;
			ctx.fillRect(rec.x,rec.y,rec.width,rec.height);
		}

		CanvasTools.isEmptyPoint=function(data,pos){
			if (data[pos]==0 && data[pos+1]==0 && data[pos+2]==0 && data[pos+3]==0){
				return true;
			}
			else{
				return false;
			}
		}

		CanvasTools.isPoinSame=function(pos,data1,data2){
			if (data1[pos]==data2[pos] && data1[pos+1]==data2[pos+1] && data1[pos+2]==data2[pos+2] && data1[pos+3]==data2[pos+3]){
				return true;
			}
			else{
				return false;
			}
		}

		CanvasTools.walkImageData=function(imgdata,walkFun){
			var i=0,iLen=0;
			var j=0,jLen=0;
			iLen=imgdata.width;
			jLen=imgdata.height;
			var tarPos=0;
			var data=imgdata.data;
			for (i=0;i < iLen;i++){
				for (j=0;j < jLen;j++){
					walkFun(i,j,tarPos,data);
					tarPos+=4;
				}
			}
		}

		CanvasTools.getSpriteByCanvas=function(canvas){
			var rst;
			rst=new Sprite();
			rst.graphics.drawTexture(new Texture(canvas),0,0,canvas.width,canvas.height);
			return rst;
		}

		CanvasTools.renderSpritesToCanvas=function(canvas,sprites,offx,offy,startIndex){
			(offx===void 0)&& (offx=0);
			(offy===void 0)&& (offy=0);
			(startIndex===void 0)&& (startIndex=0);
			var i=0,len=0;
			len=sprites.length;
			for (i=startIndex;i < len;i++){
				CanvasTools.renderSpriteToCanvas(sprites[i],canvas,offx,offy);
			}
		}

		CanvasTools.clearCanvas=function(canvas){
			var preWidth=NaN;
			var preHeight=NaN;
			preWidth=canvas.width;
			preHeight=canvas.height;
			canvas.size(preWidth+1,preHeight);
			canvas.size(preWidth,preHeight);
		}

		return CanvasTools;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-23 下午2:24:04
	*/
	//class laya.debug.tools.ClassTool
	var ClassTool=(function(){
		function ClassTool(){}
		__class(ClassTool,'laya.debug.tools.ClassTool');
		ClassTool.defineProperty=function(obj,name,des){
			/*__JS__ */Object.defineProperty(obj,name,des);;
		}

		ClassTool.getOwnPropertyDescriptor=function(obj,name){
			var rst;
			/*__JS__ */rst=Object.getOwnPropertyDescriptor(obj,name);;
			return rst;
		}

		ClassTool.getOwnPropertyNames=function(obj){
			var rst;
			/*__JS__ */rst=Object.getOwnPropertyNames(obj);;
			return rst;
		}

		ClassTool.getClassName=function(tar){
			if ((typeof tar=='function'))return tar.name;
			return tar["constructor"].name;
		}

		ClassTool.getNodeClassAndName=function(tar){
			if (!tar)return "null";
			var rst;
			if (tar.name){
				rst=ClassTool.getClassName(tar)+"("+tar.name+")";
				}else{
				rst=ClassTool.getClassName(tar);
			}
			return rst;
		}

		ClassTool.getClassNameByClz=function(clz){
			return clz["name"];
		}

		ClassTool.getClassByName=function(className){
			var rst;
			rst=/*__JS__ */eval(className);
			return rst;
		}

		ClassTool.createObjByName=function(className){
			var clz;
			clz=ClassTool.getClassByName(className);
			return new clz();
		}

		return ClassTool;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.ColorTool
	var ColorTool=(function(){
		function ColorTool(){
			this.red=NaN;
			this.green=NaN;
			this.blue=NaN;
		}

		__class(ColorTool,'laya.debug.tools.ColorTool');
		ColorTool.toHexColor=function(color){
			if (color < 0 || isNaN(color))
				return null;
			var str=color.toString(16);
			while (str.length < 6)
			str="0"+str;
			return "#"+str;
		}

		ColorTool.getRGBByRGBStr=function(str){
			str.charAt(0)=='#' && (str=str.substr(1));
			var color=/*__JS__ */parseInt(str,16);
			var flag=(str.length==8);
			var _color;
			_color=[((0x00FF0000 & color)>> 16),((0x0000FF00 & color)>> 8),(0x000000FF & color)];
			return _color;
		}

		ColorTool.getColorBit=function(value){
			var rst;
			rst=Math.floor(value).toString(16);
			rst=rst.length > 1 ? rst :"0"+rst;
			return rst;
		}

		ColorTool.getRGBStr=function(rgb){
			return "#"+ColorTool.getColorBit(rgb[0])+ColorTool.getColorBit(rgb[1])+ColorTool.getColorBit(rgb[2]);
		}

		ColorTool.traseHSB=function(hsb){
			console.log("hsb:",hsb[0],hsb[1],hsb[2]);
		}

		ColorTool.rgb2hsb=function(rgbR,rgbG,rgbB){
			var rgb=[rgbR,rgbG,rgbB];
			rgb.sort(MathTools.sortNumSmallFirst);
			var max=rgb[2];
			var min=rgb[0];
			var hsbB=max / 255.0;
			var hsbS=max==0 ? 0 :(max-min)/ max;
			var hsbH=0;
			if(max==min){
				hsbH=1;
			}
			else
			if (rgbR==0 && rgbG==0&&rgbB==0){
			}else
			if (max==rgbR && rgbG >=rgbB){
				hsbH=(rgbG-rgbB)*60 / (max-min)+0;
			}
			else if (max==rgbR && rgbG < rgbB){
				hsbH=(rgbG-rgbB)*60 / (max-min)+360;
			}
			else if (max==rgbG){
				hsbH=(rgbB-rgbR)*60 / (max-min)+120;
			}
			else if (max==rgbB){
				hsbH=(rgbR-rgbG)*60 / (max-min)+240;
			}
			return [hsbH,hsbS,hsbB];
		}

		ColorTool.hsb2rgb=function(h,s,v){
			var r=0,g=0,b=0;
			var i=Math.floor((h / 60)% 6);
			var f=(h / 60)-i;
			var p=v *(1-s);
			var q=v *(1-f *s);
			var t=v *(1-(1-f)*s);
			switch (i){
				case 0:
					r=v;
					g=t;
					b=p;
					break ;
				case 1:
					r=q;
					g=v;
					b=p;
					break ;
				case 2:
					r=p;
					g=v;
					b=t;
					break ;
				case 3:
					r=p;
					g=q;
					b=v;
					break ;
				case 4:
					r=t;
					g=p;
					b=v;
					break ;
				case 5:
					r=v;
					g=p;
					b=q;
					break ;
				default :
					break ;
				}
			return [Math.floor(r *255.0),Math.floor(g *255.0),Math.floor(b *255.0)];
		}

		return ColorTool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-29 下午12:53:31
	*/
	//class laya.debug.tools.CommonTools
	var CommonTools=(function(){
		function CommonTools(){}
		__class(CommonTools,'laya.debug.tools.CommonTools');
		CommonTools.bind=function(fun,scope){
			var rst;
			/*__JS__ */rst=fun.bind(scope);
			return rst;
		}

		CommonTools.insertP=function(tar,x,y,scaleX,scaleY,rotation){
			var nSp;
			nSp=new Sprite();
			tar.parent.addChild(nSp);
			nSp.x=x;
			nSp.y=y;
			nSp.scaleX=scaleX;
			nSp.scaleY=scaleY;
			nSp.rotation=rotation;
			nSp.addChild(tar);
			CommonTools.count++;
			nSp.name="insertP:"+CommonTools.count;
		}

		CommonTools.insertChild=function(tar,x,y,scaleX,scaleY,rotation,color){
			(color===void 0)&& (color="#ff00ff");
			var nSp;
			nSp=new Sprite();
			tar.addChild(nSp);
			nSp.x=x;
			nSp.y=y;
			nSp.scaleX=scaleX;
			nSp.scaleY=scaleY;
			nSp.rotation=rotation;
			nSp.graphics.drawRect(0,0,20,20,color);
			nSp.name="child:"+tar.numChildren;
			return nSp;
		}

		CommonTools.count=0;
		return CommonTools;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-24 下午6:37:56
	*/
	//class laya.debug.tools.CountTool
	var CountTool=(function(){
		function CountTool(){
			this.data={};
			this.preO={};
			this.changeO={};
			this.count=0;
		}

		__class(CountTool,'laya.debug.tools.CountTool');
		var __proto=CountTool.prototype;
		__proto.reset=function(){
			this.data={};
			this.count=0;
		}

		__proto.add=function(name,num){
			(num===void 0)&& (num=1);
			this.count++;
			if(!this.data.hasOwnProperty(name)){
				this.data[name]=0;
			}
			this.data[name]=this.data[name]+num;
		}

		__proto.getKeyCount=function(key){
			if(!this.data.hasOwnProperty(key)){
				this.data[key]=0;
			}
			return this.data[key];
		}

		__proto.getKeyChange=function(key){
			if (!this.changeO[key])return 0;
			return this.changeO[key];
		}

		__proto.record=function(){
			var key;
			for (key in this.changeO){
				this.changeO[key]=0;
			}
			for (key in this.data){
				if (!this.preO[key])this.preO[key]=0;
				this.changeO[key]=this.data[key]-this.preO[key];
				this.preO[key]=this.data[key]
			}
		}

		__proto.getCount=function(dataO){
			var rst=0;
			var key;
			for (key in dataO){
				rst+=dataO[key];
			}
			return rst;
		}

		__proto.traceSelf=function(dataO){
			if (!dataO)dataO=this.data;
			var tCount=0;
			tCount=this.getCount(dataO);
			console.log("total:"+tCount);
			return "total:"+tCount+"\n"+TraceTool.traceObj(dataO);
		}

		__proto.traceSelfR=function(dataO){
			if (!dataO)dataO=this.data;
			var tCount=0;
			tCount=this.getCount(dataO);
			console.log("total:"+tCount);
			return "total:"+tCount+"\n"+TraceTool.traceObjR(dataO);
		}

		return CountTool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-31 下午3:35:16
	*/
	//class laya.debug.tools.DebugExport
	var DebugExport=(function(){
		function DebugExport(){}
		__class(DebugExport,'laya.debug.tools.DebugExport');
		DebugExport.export=function(){
			var _window;
			/*__JS__ */_window=window;;
			var key;
			for(key in DebugExport._exportsDic){
				_window[key]=DebugExport._exportsDic[key];
			}
		}

		__static(DebugExport,
		['_exportsDic',function(){return this._exportsDic={
				"DebugTool":DebugTool,
				"Watcher":Watcher
		};}

		]);
		return DebugExport;
	})()


	/**
	*本类用于显示对象值变化过程
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-23 上午10:41:50
	*/
	//class laya.debug.tools.DifferTool
	var DifferTool=(function(){
		function DifferTool(sign,autoTrace){
			this.autoTrace=true;
			this.sign="";
			this.obj=null;
			(sign===void 0)&& (sign="");
			(autoTrace===void 0)&& (autoTrace=true);
			this.sign=sign;
			this.autoTrace=autoTrace;
		}

		__class(DifferTool,'laya.debug.tools.DifferTool');
		var __proto=DifferTool.prototype;
		__proto.update=function(data,msg){
			if(msg){
				console.log(msg);
			};
			var tObj=ObjectTools.copyObj(data);
			if(!this.obj)this.obj={};
			var rst;
			rst=ObjectTools.differ(this.obj,tObj);
			this.obj=tObj;
			if(this.autoTrace){
				console.log(this.sign+" differ:");
				ObjectTools.traceDifferObj(rst);
			}
			return rst;
		}

		DifferTool.differ=function(sign,data,msg){
			if(!DifferTool._differO[sign])DifferTool._differO[sign]=new DifferTool(sign,true);
			var tDiffer;
			tDiffer=DifferTool._differO[sign];
			return tDiffer.update(data,msg);
		}

		DifferTool._differO={};
		return DifferTool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2016-1-14 下午4:32:47
	*/
	//class laya.debug.tools.DisController
	var DisController=(function(){
		function DisController(){
			this.arrowAxis=null;
			this._target=null;
			this.recInfo=null;
			DisController.init();
			this.arrowAxis=new Axis();
			this.arrowAxis.mouseEnabled=true;
		}

		__class(DisController,'laya.debug.tools.DisController');
		var __proto=DisController.prototype;
		__proto.switchType=function(){
			this.arrowAxis.switchType();
		}

		__proto.updateMe=function(){
			if(!this._target)return;
			this.recInfo=RecInfo.getGlobalRecInfo(this._target,0,0,1,0,0,1);
			console.log("rotation:",this.recInfo.rotation);
			console.log("pos:",this.recInfo.x,this.recInfo.y);
			console.log("scale:",this.recInfo.width,this.recInfo.height);
			this.arrowAxis.x=this.recInfo.x;
			this.arrowAxis.y=this.recInfo.y;
			this.arrowAxis.rotation=this.recInfo.rotation;
			this.arrowAxis.yAxis.rotation=this.recInfo.rotationV-this.recInfo.rotation;
		}

		__getset(0,__proto,'target',function(){
			return this._target;
			},function(target){
			this._target=target;
			if(target){
				DisController._container.addChild(this.arrowAxis);
				Laya.timer.loop(100,this,this.updateMe);
				}else{
				this.arrowAxis.removeSelf();
				Laya.timer.clear(this,this.updateMe);
			}
			this.arrowAxis.target=target;
			this.updateMe();
		});

		__getset(0,__proto,'type',function(){
			return this.arrowAxis.type;
			},function(lenType){
			this.arrowAxis.type=lenType;
		});

		DisController.init=function(){
			if (DisController._container){
				DisControlTool.setTop(DisController._container);
				return;
			};
			DisController._container=new Sprite();
			DisController._container.mouseEnabled=true;
			Laya.stage.addChild(DisController._container);
		}

		DisController._container=null
		__static(DisController,
		['I',function(){return this.I=new DisController();}
		]);
		return DisController;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-25 下午7:19:44
	*/
	//class laya.debug.tools.DisControlTool
	var DisControlTool=(function(){
		function DisControlTool(){}
		__class(DisControlTool,'laya.debug.tools.DisControlTool');
		DisControlTool.getObjectsUnderPoint=function(sprite,x,y,rst,filterFun){
			rst=rst?rst:[];
			if(filterFun!=null&&!filterFun(sprite))return rst;
			if (sprite.getBounds().contains(x,y)){
				rst.push(sprite);
				var tS;
				var tempP=new Point();
				tempP.setTo(x,y);
				tempP=sprite.fromParentPoint(tempP);
				x=tempP.x;
				y=tempP.y;
				for (var i=sprite._childs.length-1;i >-1;i--){
					var child=sprite._childs[i];
					if((child instanceof laya.display.Sprite ))
						DisControlTool.getObjectsUnderPoint(child,x,y,rst,filterFun);
				}
			}
			return rst;
		}

		DisControlTool.getObjectsUnderGlobalPoint=function(sprite,filterFun){
			var point=new Point();
			point.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			if(sprite.parent)
				point=(sprite.parent).globalToLocal(point);
			return DisControlTool.getObjectsUnderPoint(sprite,point.x,point.y,null,filterFun);
		}

		DisControlTool.findFirstObjectsUnderGlobalPoint=function(){
			var disList;
			disList=DisControlTool.getObjectsUnderGlobalPoint(Laya.stage);
			if (!disList)return null;
			var i=0,len=0;
			var tDis;
			len=disList.length;
			for (i=len-1;i>=0;i--){
				tDis=disList[i];
				if (tDis && tDis.numChildren < 1){
					return tDis;
				}
			}
			return tDis;
		}

		DisControlTool.visibleAndEnableObjFun=function(tar){
			return tar.visible&&tar.mouseEnabled;
		}

		DisControlTool.visibleObjFun=function(tar){
			return tar.visible;
		}

		DisControlTool.getMousePoint=function(sprite){
			var point=new Point();
			point.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			point=sprite.globalToLocal(point);
			return point;
		}

		DisControlTool.isChildE=function(parent,child){
			if (!parent)return false;
			while (child){
				if (child.parent==parent)return true;
				child=child.parent;
			}
			return false;
		}

		DisControlTool.isInTree=function(pNode,child){
			return pNode==child || DisControlTool.isChildE(pNode,child);
		}

		DisControlTool.setTop=function(tar){
			if(tar&&tar.parent){
				var tParent;
				tParent=tar.parent;
				tParent.setChildIndex(tar,tParent.numChildren-1);
			}
		}

		DisControlTool.clearItemRelativeInfo=function(item){
			var Nan="NaN";
			item.getLayout().left=Nan;
			item.getLayout().right=Nan;
			item.getLayout().top=Nan;
			item.getLayout().bottom=Nan;
		}

		DisControlTool.swap=function(tarA,tarB){
			if (tarA==tarB)return;
			var iA=0;
			iA=tarA.parent.getChildIndex(tarA);
			var iB=0;
			iB=tarB.parent.getChildIndex(tarB);
			var bP;
			bP=tarB.parent;
			tarA.parent.addChildAt(tarB,iA);
			bP.addChildAt(tarA,iB);
		}

		DisControlTool.insertToTarParent=function(tarA,tars,after){
			(after===void 0)&& (after=false);
			var tIndex=0;
			var parent;
			if(!tarA)return;
			parent=tarA.parent;
			if(!parent)return;
			tIndex=parent.getChildIndex(tarA);
			if(after)tIndex++;
			DisControlTool.insertToParent(parent,tars,tIndex);
		}

		DisControlTool.insertToParent=function(parent,tars,index){
			(index===void 0)&& (index=-1);
			if(!parent)return;
			if(index<0)index=parent.numChildren;
			var i=0,len=0;
			len=tars.length;
			for(i=0;i<len;i++){
				DisControlTool.transParent(tars[i],parent);
				parent.addChildAt(tars[i],index);
			}
		}

		DisControlTool.transParent=function(tar,newParent){
			if(!tar||!newParent)return;
			if(!tar.parent)return;
			var preParent;
			preParent=tar.parent;
			var pos;
			pos=new Point(tar.x,tar.y);
			pos=preParent.localToGlobal(pos);
			pos=newParent.globalToLocal(pos);
			tar.pos(pos.x,pos.y);
		}

		DisControlTool.transPoint=function(nowParent,tarParent,point){
			point=nowParent.localToGlobal(point);
			point=tarParent.globalToLocal(point);
			return point;
		}

		DisControlTool.removeItems=function(itemList){
			var i=0,len=0;
			len=itemList.length;
			for (i=0;i < len;i++){
				(itemList [i]).removeSelf();
			}
		}

		DisControlTool.addItems=function(itemList,parent){
			var i=0,len=0;
			len=itemList.length;
			for (i=0;i < len;i++){
				parent.addChild(itemList[i]);
			}
		}

		DisControlTool.getAllChild=function(tar){
			if(!tar)return [];
			var i=0;
			var len=0;
			var rst=[];
			len=tar.numChildren;
			for(i=0;i<len;i++){
				rst.push(tar.getChildAt(i));
			}
			return rst;
		}

		DisControlTool.upDis=function(child){
			if(child&&child.parent){
				var tParent;
				tParent=child.parent;
				var newIndex=0;
				newIndex=tParent.getChildIndex(child)+1;
				if(newIndex>=tParent.numChildren){
					newIndex=tParent.numChildren-1;
				}
				console.log("setChildIndex:"+newIndex);
				tParent.setChildIndex(child,newIndex);
			}
		}

		DisControlTool.downDis=function(child){
			if(child&&child.parent){
				var tParent;
				tParent=child.parent;
				var newIndex=0;
				newIndex=tParent.getChildIndex(child)-1;
				if(newIndex<0)newIndex=0;
				console.log("setChildIndex:"+newIndex);
				tParent.setChildIndex(child,newIndex);
			}
		}

		DisControlTool.setResizeAbleEx=function(node){
			var clickItem;
			clickItem=node.getChildByName("resizeBtn");
			if (clickItem){
				SimpleResizer.setResizeAble(clickItem,node);
			}
		}

		DisControlTool.setResizeAble=function(node){
			node.on(/*laya.events.Event.CLICK*/"click",null,DisControlTool.resizeHandler,[node]);
		}

		DisControlTool.resizeHandler=function(tar){
			DisResizer.setUp(tar);
		}

		DisControlTool.setDragingItem=function(dragBar,tar){
			dragBar.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",null,DisControlTool.dragingHandler,[tar]);
			tar.on(/*laya.events.Event.DRAG_END*/"dragend",null,DisControlTool.dragingEnd,[tar]);
		}

		DisControlTool.dragingHandler=function(tar){
			if (tar){
				tar.startDrag();
			}
		}

		DisControlTool.dragingEnd=function(tar){
			DisControlTool.intFyDisPos(tar);
			console.log(tar.x,tar.y);
		}

		DisControlTool.showToStage=function(dis,offX,offY){
			(offX===void 0)&& (offX=0);
			(offY===void 0)&& (offY=0);
			var rec=dis.getBounds();
			dis.x=Laya.stage.mouseX+offX;
			dis.y=Laya.stage.mouseY+offY;
			if (dis.x+rec.width > Laya.stage.width){
				dis.x-=rec.width+offX;
			}
			if (dis.y+rec.height > Laya.stage.height){
				dis.y-=rec.height+offY;
			}
			DisControlTool.intFyDisPos(dis);
		}

		DisControlTool.intFyDisPos=function(dis){
			if (!dis)return;
			dis.x=Math.round(dis.x);
			dis.y=Math.round(dis.y);
		}

		DisControlTool.showOnly=function(disList,showItem){
			var i=0,len=0;
			len=disList.length;
			for (i=0;i < len;i++){
				disList[i].visible=disList[i]==showItem;
			}
		}

		DisControlTool.showOnlyByIndex=function(disList,index){
			DisControlTool.showOnly(disList,disList[index]);
		}

		DisControlTool.addOnly=function(disList,showItem,parent){
			var i=0,len=0;
			len=disList.length;
			for (i=0;i < len;i++){
				if (disList[i] !=showItem){
					disList[i].removeSelf();
					}else{
					parent.addChild(disList[i]);
				}
			}
		}

		DisControlTool.addOnlyByIndex=function(disList,index,parent){
			DisControlTool.addOnly(disList,disList[index],parent);
		}

		__static(DisControlTool,
		['tempP',function(){return this.tempP=new Point();}
		]);
		return DisControlTool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-24 下午4:20:25
	*/
	//class laya.debug.tools.DisEditor
	var DisEditor=(function(){
		function DisEditor(){
			this.tar=null;
			this.rec=new Sprite();
			this.rootContainer=new Sprite();
		}

		__class(DisEditor,'laya.debug.tools.DisEditor');
		var __proto=DisEditor.prototype;
		__proto.setTarget=function(target){
			this.tar=target;
			var g;
			g=this.rec.graphics;
			g.clear();
			var bounds;
			bounds=this.tar.getSelfBounds();
			g.drawRect(bounds.x,bounds.y,bounds.width,bounds.height,null,"#00ff00");
			this.createSameDisChain();
			Laya.stage.addChild(this.rootContainer);
		}

		__proto.createSameDisChain=function(){
			var tParent;
			var cpParent;
			var preTar;
			preTar=this.rec;
			tParent=this.tar;
			while(tParent&&tParent!=Laya.stage){
				cpParent=new Sprite();
				cpParent.addChild(preTar);
				cpParent.x=tParent.x;
				cpParent.y=tParent.y;
				cpParent.scaleX=tParent.scaleX;
				cpParent.scaleY=tParent.scaleY;
				cpParent.rotation=tParent.rotation;
				cpParent.scrollRect=tParent.scrollRect;
				preTar=cpParent;
				tParent=tParent.parent;
			}
			this.rootContainer.removeChildren();
			this.rootContainer.addChild(preTar);
		}

		return DisEditor;
	})()


	/**
	*调试拾取显示对象类
	*@author ww
	*/
	//class laya.debug.tools.DisplayHook
	var DisplayHook=(function(){
		function DisplayHook(){
			this.mouseX=NaN;
			this.mouseY=NaN;
			this._stage=null;
			this._target=null;
			this.isGetting=false;
			this._matrix=new Matrix();
			this._point=new Point();
			this._rect=new Rectangle();
			this._event=Event.EMPTY;
			this._stage=Laya.stage;
			this.init(Render.context.canvas);
		}

		__class(DisplayHook,'laya.debug.tools.DisplayHook');
		var __proto=DisplayHook.prototype;
		__proto.init=function(canvas){
			var _$this=this;
			if (Browser.window.navigator.msPointerEnabled){
				canvas.style['-ms-content-zooming']='none';
				canvas.style['-ms-touch-action']='none';
			};
			var _this=this;
			Browser.document.addEventListener('mousedown',function(e){
				_$this._event._stoped=false;
				DisplayHook.isFirst=true;
				_this.check(_this._stage,e.offsetX,e.offsetY,_this.onMouseDown,true,false);
			},true);
			Browser.document.addEventListener('touchstart',function(e){
				_$this._event._stoped=false;
				DisplayHook.isFirst=true;
				var touches=e.changedTouches;
				for (var i=0,n=touches.length;i < n;i++){
					var touch=touches[i];
					initEvent(touch,e);
					_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown,true,false);
				}
			},true);
			function initEvent (e,event){
				_this._event._stoped=false;
				_this._event.nativeEvent=event || e;
				_this._target=null;
				if (e.offsetX){
					_this.mouseX=e.offsetX;
					_this.mouseY=e.offsetY;
					}else {
					_this.mouseX=e.clientX-Laya.stage.offset.x;
					_this.mouseY=e.clientY-Laya.stage.offset.y;
				}
			}
		}

		__proto.onMouseMove=function(ele,hit){
			this.sendEvent(ele,/*laya.events.Event.MOUSE_MOVE*/"mousemove");
			return;
			if (hit && ele !=this._stage && ele!==this._target){
				if (this._target){
					if (this._target.$_MOUSEOVER){
						this._target.$_MOUSEOVER=false;
						this._target.event(/*laya.events.Event.MOUSE_OUT*/"mouseout");
					}
				}
				this._target=ele;
				if (!ele.$_MOUSEOVER){
					ele.$_MOUSEOVER=true;
					this.sendEvent(ele,/*laya.events.Event.MOUSE_OVER*/"mouseover");
				}
				}else if (!hit && this._target && ele===this._target){
				this._target=null;
				if (ele.$_MOUSEOVER){
					ele.$_MOUSEOVER=false;
					this.sendEvent(ele,/*laya.events.Event.MOUSE_OUT*/"mouseout");
				}
			}
		}

		__proto.onMouseUp=function(ele,hit){
			hit && this.sendEvent(ele,/*laya.events.Event.MOUSE_UP*/"mouseup");
		}

		__proto.onMouseDown=function(ele,hit){
			if (hit){
				ele.$_MOUSEDOWN=true;
				this.sendEvent(ele,/*laya.events.Event.MOUSE_DOWN*/"mousedown");
			}
		}

		__proto.sendEvent=function(ele,type){
			if (!this._event._stoped){
				ele.event(type,this._event.setTo(type,ele,ele));
				if (type===/*laya.events.Event.MOUSE_UP*/"mouseup" && ele.$_MOUSEDOWN){
					ele.$_MOUSEDOWN=false;
					ele.event(/*laya.events.Event.CLICK*/"click",this._event.setTo(/*laya.events.Event.CLICK*/"click",ele,ele));
				}
			}
		}

		__proto.selectDisUnderMouse=function(){
			DisplayHook.isFirst=true;
			this.check(Laya.stage,Laya.stage.mouseX,Laya.stage.mouseY,null,true,false);
			SelectInfosView.I.setSelectTarget(DebugTool.target);
		}

		__proto.getDisUnderMouse=function(){
			this.isGetting=true;
			DisplayHook.isFirst=true;
			DebugTool.target=null;
			this.check(Laya.stage,Laya.stage.mouseX,Laya.stage.mouseY,null,true,false);
			this.isGetting=false;
			return DebugTool.target;
		}

		__proto.check=function(sp,mouseX,mouseY,callBack,hitTest,mouseEnable){
			if(sp==DebugTool.debugLayer)return false;
			if (this.isGetting && sp==DebugInfoLayer.I)return false;
			if (!sp.visible || sp.getSelfBounds().width<=0)return false;
			var isHit=false;
			mouseEnable=true
			if (mouseEnable){
				var graphicHit=false;
				if (hitTest){
					this._rect=sp.getBounds();
					isHit=this._rect.contains(mouseX,mouseY);
					this._point.setTo(mouseX,mouseY);
					sp.fromParentPoint(this._point);
					mouseX=this._point.x;
					mouseY=this._point.y;
				}
				if (isHit){
					var flag=false;
					for (var i=sp._childs.length-1;i >-1;i--){
						var child=sp._childs[i];
						(flag=this.check(child,mouseX,mouseY,callBack,hitTest,true));
						if (flag)break ;
					}
					graphicHit=sp.getGraphicBounds().contains(mouseX,mouseY);
					isHit=flag||graphicHit;
					if(isHit&&!flag&&DisplayHook.isFirst){
						DisplayHook.isFirst=false;
						if(! ((sp instanceof laya.debug.tools.debugUI.DButton ))){
							DebugTool.target=sp;
							if (!this.isGetting){
								DebugTool.autoWork();
								Notice.notify("ItemClicked",sp);
							}
						}
					}
				}
			}
			return isHit;
		}

		DisplayHook.initMe=function(){
			if(!DisplayHook.instance){
				DisplayHook.instance=new DisplayHook();
			}
		}

		DisplayHook.ITEM_CLICKED="ItemClicked";
		DisplayHook.instance=null
		DisplayHook.isFirst=false;
		return DisplayHook;
	})()


	/**
	*简单的显示对象对象池
	*从父容器上移除时即被视为可被重用
	*@author ww
	*@version 1.0
	*
	*@created 2015-11-13 下午8:05:13
	*/
	//class laya.debug.tools.DisPool
	var DisPool=(function(){
		function DisPool(){}
		__class(DisPool,'laya.debug.tools.DisPool');
		DisPool.getDis=function(clz){
			var clzName;
			clzName=ClassTool.getClassNameByClz(clz);
			if(!DisPool._objDic[clzName]){
				DisPool._objDic[clzName]=[];
			};
			var disList;
			disList=DisPool._objDic[clzName];
			var i=0,len=0;
			len=disList.length;
			for(i=0;i<len;i++){
				if(!disList[i].parent){
					return disList[i];
				}
			}
			disList.push(new clz());
			return disList[disList.length-1];
		}

		DisPool._objDic={};
		return DisPool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-28 上午10:39:47
	*/
	//class laya.debug.tools.DTrace
	var DTrace=(function(){
		function DTrace(){}
		__class(DTrace,'laya.debug.tools.DTrace');
		DTrace.getArgArr=function(arg){
			var rst;
			rst=[];
			var i=0,len=arg.length;
			for(i=0;i<len;i++){
				rst.push(arg[i]);
			}
			return rst;
		}

		DTrace.dTrace=function(__arg){
			var arg=arguments;
			arg=DTrace.getArgArr(arg);
			arg.push(TraceTool.getCallLoc(2));
			/*__JS__ */console.log.apply(console,arg);
			var str;
			str=arg.join(" ");
		}

		DTrace.timeStart=function(sign){
			/*__JS__ */console.time(sign);;
		}

		DTrace.timeEnd=function(sign){
			/*__JS__ */console.timeEnd(sign);;
		}

		DTrace.traceTable=function(data){
			/*__JS__ */console.table(data);;
		}

		return DTrace;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.enginehook.ClassCreateHook
	var ClassCreateHook=(function(){
		function ClassCreateHook(){
			this.createInfo={};
		}

		__class(ClassCreateHook,'laya.debug.tools.enginehook.ClassCreateHook');
		var __proto=ClassCreateHook.prototype;
		__proto.hookClass=function(clz){
			var _$this=this;
			var createFun=function (sp){
				_$this.classCreated(sp,clz);
			}
			FunHook.hook(clz,"call",createFun);
		}

		__proto.classCreated=function(clz,oClass){
			var key;
			key=ClassTool.getNodeClassAndName(clz);
			var depth=0;
			var tClz;
			tClz=clz;
			while (tClz && tClz !=oClass){
				tClz=tClz.__super;
				depth++;
			}
			if (!ClassCreateHook.I.createInfo[key]){
				ClassCreateHook.I.createInfo[key]=0;
			}
			ClassCreateHook.I.createInfo[key]=ClassCreateHook.I.createInfo[key]+1;
			RunProfile.run(key,depth+6);
		}

		__proto.getClassCreateInfo=function(clz){
			var key;
			key=ClassTool.getClassName(clz);
			return RunProfile.getRunInfo(key);
		}

		__static(ClassCreateHook,
		['I',function(){return this.I=new ClassCreateHook();}
		]);
		return ClassCreateHook;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.enginehook.FunctionTimeHook
	var FunctionTimeHook=(function(){
		function FunctionTimeHook(){}
		__class(FunctionTimeHook,'laya.debug.tools.enginehook.FunctionTimeHook');
		FunctionTimeHook.hookFun=function(obj,funName){
			if (!obj)return;
			if (obj.timeHooked)return;
			var myKey;
			FunctionTimeHook.HookID++;
			myKey=ClassTool.getNodeClassAndName(obj)+"."+funName+"():"+FunctionTimeHook.HookID;
			var timePreFun=function (__args){
				var args=arguments;
				FunctionTimeHook.funBegin(myKey);
			};
			var timeEndFun=function (__args){
				var args=arguments;
				FunctionTimeHook.funEnd(myKey);
			}
			obj.timeHooked=true;
			FunHook.hook(obj,funName,timePreFun,timeEndFun);
		}

		FunctionTimeHook.funBegin=function(funKey){
			FunctionTimeHook.funPre[funKey]=Browser.now();
		}

		FunctionTimeHook.funEnd=function(funKey){
			if (!FunctionTimeHook.funPre[funKey])FunctionTimeHook.funPre[funKey]=0;
			FunctionTimeHook.counter.add(funKey,Browser.now()-FunctionTimeHook.funPre[funKey]);
		}

		FunctionTimeHook.fresh=function(){
			FunctionTimeHook.funEnd("TotalSign");
			FunctionTimeHook.counter.record();
			FunctionTimeHook.funBegin("TotalSign");
		}

		FunctionTimeHook.HookID=1;
		FunctionTimeHook.funPre={};
		FunctionTimeHook.TotalSign="TotalSign";
		__static(FunctionTimeHook,
		['counter',function(){return this.counter=new CountTool();}
		]);
		return FunctionTimeHook;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.enginehook.RenderSpriteHook
	var RenderSpriteHook=(function(){
		function RenderSpriteHook(){
			//this._next=null;
			//this._fun=null;
			//this._oldCanvas=null;
		}

		__class(RenderSpriteHook,'laya.debug.tools.enginehook.RenderSpriteHook');
		var __proto=RenderSpriteHook.prototype;
		__proto.createRenderSprite=function(type,next){
			var rst;
			rst=new RenderSprite(type,next);
			if (type==/*laya.renders.RenderSprite.CANVAS*/0x08){
				rst["_oldCanvas"]=rst._fun;
				rst._fun=RenderSpriteHook.I._canvas;
			}
			return rst;
		}

		__proto._canvas=function(sprite,context,x,y){
			if (!SpriteRenderForVisibleAnalyse.allowRendering)return;
			var _cacheCanvas=sprite._$P.cacheCanvas;
			var _next=this._next;
			if (!_cacheCanvas||SpriteRenderForVisibleAnalyse.isVisibleTesting){
				_next._fun.call(_next,sprite,context,x,y);
				return;
			};
			var preTime;
			preTime=Browser.now();
			var tx=_cacheCanvas.ctx;
			var _repaint=sprite._needRepaint()|| (!tx);
			this._oldCanvas(sprite,context,x,y);
			if (_repaint){
				CacheAnalyser.I.reCacheCanvas(sprite,Browser.now()-preTime);
				}else{
				CacheAnalyser.I.renderCanvas(sprite,Browser.now()-preTime);
			}
		}

		RenderSpriteHook.init=function(){
			RenderSpriteHook.I=new RenderSpriteHook();
			RunDriver.createRenderSprite=RenderSpriteHook.I.createRenderSprite;
		}

		RenderSpriteHook.IMAGE=0x01;
		RenderSpriteHook.FILTERS=0x02;
		RenderSpriteHook.ALPHA=0x04;
		RenderSpriteHook.TRANSFORM=0x08;
		RenderSpriteHook.CANVAS=0x10;
		RenderSpriteHook.BLEND=0x20;
		RenderSpriteHook.CLIP=0x40;
		RenderSpriteHook.STYLE=0x80;
		RenderSpriteHook.GRAPHICS=0x100;
		RenderSpriteHook.CUSTOM=0x200;
		RenderSpriteHook.ENABLERENDERMERGE=0x400;
		RenderSpriteHook.CHILDS=0x800;
		RenderSpriteHook.INIT=0x11111;
		RenderSpriteHook.renders=[];
		RenderSpriteHook.I=null
		return RenderSpriteHook;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse
	var SpriteRenderForVisibleAnalyse=(function(){
		function SpriteRenderForVisibleAnalyse(){
			this._repaint=1;
			this._renderType=1;
			this._x=0;
			this._y=0;
			this.target=null;
			this.isTargetRenderd=false;
			this.preFun=null;
			this._next=null;
			this.pgraphic=RenderSprite["prototype"]["_graphics"];
			this.pimage=RenderSprite["prototype"]["_image"];
			this.pimage2=RenderSprite["prototype"]["_image2"];
		}

		__class(SpriteRenderForVisibleAnalyse,'laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse');
		var __proto=SpriteRenderForVisibleAnalyse.prototype;
		__proto.setRenderHook=function(){
			Sprite["prototype"]["render"]=SpriteRenderForVisibleAnalyse.I.render;
		}

		/**
		*更新、呈现显示对象。
		*@param context 渲染的上下文引用。
		*@param x X轴坐标。
		*@param y Y轴坐标。
		*/
		__proto.render=function(context,x,y){
			var me;
			me=this;
			if (DebugInfoLayer.I.isDebugItem(me))return;
			if (me==laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.I.target){
				laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.allowRendering=true;
				laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.I.isTargetRenderd=true;
				CanvasTools.clearCanvas(SpriteRenderForVisibleAnalyse.mainCanvas);
			}
			RenderSprite.renders[this._renderType]._fun(this,context,x+this._x,y+this._y);
			if (me==laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.I.target){
				SpriteRenderForVisibleAnalyse.tarRec=CanvasTools.getCanvasDisRec(laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.mainCanvas);
				console.log("rec",SpriteRenderForVisibleAnalyse.tarRec.toString());
				if (SpriteRenderForVisibleAnalyse.tarRec.width >0&& SpriteRenderForVisibleAnalyse.tarRec.height > 0){
					SpriteRenderForVisibleAnalyse.isTarRecOK=true;
					SpriteRenderForVisibleAnalyse.preImageData=CanvasTools.getImageDataFromCanvasByRec(SpriteRenderForVisibleAnalyse.mainCanvas,SpriteRenderForVisibleAnalyse.tarRec);
					SpriteRenderForVisibleAnalyse.tarImageData=CanvasTools.getImageDataFromCanvasByRec(SpriteRenderForVisibleAnalyse.mainCanvas,SpriteRenderForVisibleAnalyse.tarRec);
					}else{
					console.log("tarRec Not OK:",SpriteRenderForVisibleAnalyse.tarRec);
				}
				}else{
				if (SpriteRenderForVisibleAnalyse.isTarRecOK){
					SpriteRenderForVisibleAnalyse.tImageData=CanvasTools.getImageDataFromCanvasByRec(SpriteRenderForVisibleAnalyse.mainCanvas,SpriteRenderForVisibleAnalyse.tarRec);
					var dRate=NaN;
					dRate=CanvasTools.getDifferRate(SpriteRenderForVisibleAnalyse.preImageData,SpriteRenderForVisibleAnalyse.tImageData);
					SpriteRenderForVisibleAnalyse.preImageData=SpriteRenderForVisibleAnalyse.tImageData;
					if (dRate > 0){
						VisibleAnalyser.addCoverNode(me,dRate);
					}
				}
			}
		}

		__proto.analyseNode=function(node){
			VisibleAnalyser.resetCoverList();
			if (Sprite["prototype"]["render"] !=SpriteRenderForVisibleAnalyse.I.render){
				this.preFun=Sprite["prototype"]["render"];
			}
			this.target=node;
			Sprite["prototype"]["render"]=this.render;
			if (!SpriteRenderForVisibleAnalyse.tarCanvas)
				SpriteRenderForVisibleAnalyse.tarCanvas=CanvasTools.createCanvas(Laya.stage.width,Laya.stage.height);
			if (!SpriteRenderForVisibleAnalyse.mainCanvas)
				SpriteRenderForVisibleAnalyse.mainCanvas=CanvasTools.createCanvas(Laya.stage.width,Laya.stage.height);
			this.isTargetRenderd=false;
			SpriteRenderForVisibleAnalyse.isVisibleTesting=true;
			SpriteRenderForVisibleAnalyse.allowRendering=false;
			CanvasTools.clearCanvas(SpriteRenderForVisibleAnalyse.mainCanvas);
			CanvasTools.clearCanvas(SpriteRenderForVisibleAnalyse.tarCanvas);
			SpriteRenderForVisibleAnalyse.isTarRecOK=false;
			var ctx=new RenderContext(SpriteRenderForVisibleAnalyse.mainCanvas.width,SpriteRenderForVisibleAnalyse.mainCanvas.height,SpriteRenderForVisibleAnalyse.mainCanvas);
			SpriteRenderForVisibleAnalyse.mainCanvas=ctx.canvas;
			this.render.call(Laya.stage,ctx,0,0);
			if (!SpriteRenderForVisibleAnalyse.isTarRecOK){
				SpriteRenderForVisibleAnalyse.coverRate=0;
				}else{
				SpriteRenderForVisibleAnalyse.coverRate=CanvasTools.getDifferRate(SpriteRenderForVisibleAnalyse.preImageData,SpriteRenderForVisibleAnalyse.tarImageData);
			}
			VisibleAnalyser.coverRate=SpriteRenderForVisibleAnalyse.coverRate;
			VisibleAnalyser.isTarRecOK=SpriteRenderForVisibleAnalyse.isTarRecOK;
			console.log("coverRate:",SpriteRenderForVisibleAnalyse.coverRate);
			this.isTargetRenderd=false;
			SpriteRenderForVisibleAnalyse.isVisibleTesting=false;
			SpriteRenderForVisibleAnalyse.allowRendering=true;
			Sprite["prototype"]["render"]=this.preFun;
		}

		__proto.noRenderMode=function(){
			return;
			RenderSprite["prototype"]["_graphics"]=this.m_graphics;
			RenderSprite["prototype"]["_image"]=this.m_image;
			RenderSprite["prototype"]["_image2"]=this.m_image2;
		}

		__proto.normalMode=function(){
			RenderSprite["prototype"]["_graphics"]=this.pgraphic;
			RenderSprite["prototype"]["_image"]=this.pimage;
			RenderSprite["prototype"]["_image2"]=this.pimage2;
		}

		__proto.inits=function(){
			this.noRenderMode();
		}

		__proto.m_graphics=function(sprite,context,x,y){
			if (laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.allowRendering){
				var tf=sprite._style._tf;
				sprite._graphics && sprite._graphics._render(sprite,context,x-tf.translateX,y-tf.translateY);
			};
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
		}

		__proto.m_image=function(sprite,context,x,y){
			if (laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.allowRendering){
				var style=sprite._style;
				context.ctx.drawTexture2(x,y,style._tf.translateX,style._tf.translateY,sprite.transform,style.alpha,style.blendMode,sprite._graphics._one);
			}
		}

		__proto.m_image2=function(sprite,context,x,y){
			if (laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse.allowRendering){
				var tf=sprite._style._tf;
				context.ctx.drawTexture2(x,y,tf.translateX,tf.translateY,sprite.transform,1,null,sprite._graphics._one);
			}
		}

		SpriteRenderForVisibleAnalyse.tarCanvas=null
		SpriteRenderForVisibleAnalyse.mainCanvas=null
		SpriteRenderForVisibleAnalyse.preImageData=null
		SpriteRenderForVisibleAnalyse.tImageData=null
		SpriteRenderForVisibleAnalyse.tarImageData=null
		SpriteRenderForVisibleAnalyse.tarRec=null
		SpriteRenderForVisibleAnalyse.isTarRecOK=false;
		SpriteRenderForVisibleAnalyse.isVisibleTesting=false;
		SpriteRenderForVisibleAnalyse.allowRendering=true;
		SpriteRenderForVisibleAnalyse.coverRate=NaN
		__static(SpriteRenderForVisibleAnalyse,
		['I',function(){return this.I=new SpriteRenderForVisibleAnalyse();}
		]);
		return SpriteRenderForVisibleAnalyse;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.enginehook.SpriteRenderHook
	var SpriteRenderHook=(function(){
		function SpriteRenderHook(){
			this._repaint=1;
			this._renderType=1;
			this._x=0;
			this._y=0;
		}

		__class(SpriteRenderHook,'laya.debug.tools.enginehook.SpriteRenderHook');
		var __proto=SpriteRenderHook.prototype;
		/**
		*更新、呈现显示对象。
		*@param context 渲染的上下文引用。
		*@param x X轴坐标。
		*@param y Y轴坐标。
		*/
		__proto.render=function(context,x,y){
			var preTime=0;
			preTime=Browser.now();
			Stat.spriteCount++;
			RenderSprite.renders[this._renderType]._fun(this,context,x+this._x,y+this._y);
			this._repaint=0;
			RenderAnalyser.I.render(this,Browser.now()-preTime);
		}

		SpriteRenderHook.init=function(){
			SpriteRenderHook.I=new SpriteRenderHook();
			SpriteRenderHook.setRenderHook();
		}

		SpriteRenderHook.setRenderHook=function(){
			Sprite["prototype"]["render"]=SpriteRenderHook.I.render;
		}

		SpriteRenderHook.I=null
		return SpriteRenderHook;
	})()


	/**
	*本类调用原生observe接口，仅支持部分浏览器，chrome有效
	*变化输出为异步方式,所以无法跟踪到是什么函数导致变化
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-26 上午9:35:45
	*/
	//class laya.debug.tools.exp.Observer
	var Observer=(function(){
		function Observer(){}
		__class(Observer,'laya.debug.tools.exp.Observer');
		Observer.observe=function(obj,callBack){
			/*__JS__ */Object.observe(obj,callBack);
		}

		Observer.unobserve=function(obj,callBack){
			/*__JS__ */Object.unobserve(obj,callBack);
		}

		Observer.observeDiffer=function(obj,sign,msg){
			(msg===void 0)&& (msg="obDiffer");
			var differFun=function (){
				DifferTool.differ(sign,obj,msg);
			}
			Observer.observe(obj,differFun);
		}

		return Observer;
	})()


	/**
	*本类调用原生watch接口，仅火狐有效
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-26 上午9:48:18
	*/
	//class laya.debug.tools.exp.Watch
	var Watch=(function(){
		function Watch(){}
		__class(Watch,'laya.debug.tools.exp.Watch');
		Watch.watch=function(obj,name,callBack){
			/*__JS__ */obj.watch(name,callBack);
		}

		Watch.unwatch=function(obj,name,callBack){
			/*__JS__ */obj.unwatch(name,callBack);
		}

		return Watch;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-30 下午1:06:56
	*/
	//class laya.debug.tools.FilterTool
	var FilterTool=(function(){
		function FilterTool(){}
		__class(FilterTool,'laya.debug.tools.FilterTool');
		FilterTool.getArrByFilter=function(arr,filterFun){
			var i=0,len=arr.length;
			var rst=[];
			for(i=0;i<len;i++){
				if(filterFun(arr[i]))rst.push(arr[i]);
			}
			return rst;
		}

		FilterTool.getArr=function(arr,sign,value){
			var i=0,len=arr.length;
			var rst=[];
			for(i=0;i<len;i++){
				if(arr[i][sign]==value)rst.push(arr[i]);
			}
			return rst;
		}

		return FilterTool;
	})()


	/**
	*本类用于在对象的函数上挂钩子
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-23 下午1:13:13
	*/
	//class laya.debug.tools.hook.FunHook
	var FunHook=(function(){
		function FunHook(){}
		__class(FunHook,'laya.debug.tools.hook.FunHook');
		FunHook.hook=function(obj,funName,preFun,aftFun){
			FunHook.hookFuns(obj,funName,[preFun,obj[funName],aftFun],1);
		}

		FunHook.hookAllFun=function(obj){
			var key;
			var arr;
			arr=ClassTool.getOwnPropertyNames(obj);
			for(key in arr){
				key=arr[key];
				if (FunHook.special[key])continue ;
				console.log("try hook:",key);
				if((typeof (obj[key])=='function')){
					console.log("hook:",key);
					FunHook.hookFuns(obj,key,[FunHook.getTraceMsg("call:"+key),obj[key]],1);
				}
			}
			if(obj["__proto__"]){
				FunHook.hookAllFun(obj["__proto__"]);
				}else{
				console.log("end:",obj);
			}
		}

		FunHook.getTraceMsg=function(msg){
			var rst;
			rst=function (){
				console.log(msg);
			}
			return rst;
		}

		FunHook.hookFuns=function(obj,funName,funList,rstI){
			(rstI===void 0)&& (rstI=-1);
			var _preFun=obj[funName];
			var newFun;
			newFun=function (__args){
				var args=arguments;
				var rst;
				var i=0;
				var len=0;
				len=funList.length;
				for(i=0;i<len;i++){
					if(!funList[i])continue ;
					if(i==rstI){
						rst=funList[i].apply(this,args);
						}else{
						funList[i].apply(this,args);
					}
				}
				return rst;
			};
			newFun["pre"]=_preFun;
			obj[funName]=newFun;
		}

		FunHook.removeHook=function(obj,funName){
			if(obj[funName].pre!=null){
				obj[funName]=obj[funName].pre;
			}
		}

		FunHook.debugHere=function(){
			/*__JS__ */debugger;;
		}

		FunHook.traceLoc=function(level,msg){
			(level===void 0)&& (level=0);
			(msg===void 0)&& (msg="");
			console.log(msg,"fun loc:",TraceTool.getCallLoc(3+level));
		}

		FunHook.getLocFun=function(level,msg){
			(level===void 0)&& (level=0);
			(msg===void 0)&& (msg="");
			level+=1;
			var rst;
			rst=function (){
				FunHook.traceLoc(level,msg);
			}
			return rst;
		}

		__static(FunHook,
		['special',function(){return this.special={
				"length":true,
				"name":true,
				"arguments":true,
				"caller":true,
				"prototype":true,
				"is":true,
				"isExtensible":true,
				"isFrozen":true,
				"isSealed":true,
				"preventExtensions":true,
				"seal":true,
				"unobserve":true,
				"apply":true,
				"call":true,
				"bind":true,
				"freeze":true,
				"unobserve":true
		};}

		]);
		return FunHook;
	})()


	/**
	*本类用于监控对象 set get 函数的调用
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-23 下午2:52:48
	*/
	//class laya.debug.tools.hook.VarHook
	var VarHook=(function(){
		function VarHook(){}
		__class(VarHook,'laya.debug.tools.hook.VarHook');
		VarHook.hookVar=function(obj,name,setHook,getHook){
			if(!setHook)setHook=[];
			if(!getHook)getHook=[];
			var preO=obj;
			var preValue=obj[name];
			var des;
			des=ClassTool.getOwnPropertyDescriptor(obj,name);
			var ndes={};
			var mSet=function (value){
				console.log("var hook set "+name+":",value);
				preValue=value;
			};
			var mGet=function (){
				console.log("var hook get"+name+":",preValue);
				return preValue;
			}
			if(des){
				ndes.set=mSet;
				ndes.get=mGet;
				ndes.enumerable=des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes,"set",setHook);
				FunHook.hookFuns(ndes,"get",getHook,getHook.length-1);
				ClassTool.defineProperty(obj,name,ndes);
				return;
			}
			while(!des&&obj["__proto__"]){
				obj=obj["__proto__"];
				des=ClassTool.getOwnPropertyDescriptor(obj,name);
			}
			if (des){
				ndes.set=des.set?des.set:mSet;
				ndes.get=des.get?des.get:mGet;
				ndes.enumerable=des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes,"set",setHook);
				FunHook.hookFuns(ndes,"get",getHook,getHook.length-1);
				ClassTool.defineProperty(preO,name,ndes);
			}
			if(!des){
				console.log("get des fail add directly");
				ndes.set=mSet;
				ndes.get=mGet;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes,"set",setHook);
				FunHook.hookFuns(ndes,"get",getHook,getHook.length-1);
				ClassTool.defineProperty(obj,name,ndes);
			}
		}

		VarHook.getLocFun=function(msg,level){
			(msg===void 0)&& (msg="");
			(level===void 0)&& (level=0);
			level+=1;
			var rst;
			rst=function (){
				FunHook.traceLoc(level,msg);
			}
			return rst;
		}

		return VarHook;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-29 上午9:45:33
	*/
	//class laya.debug.tools.IDTools
	var IDTools=(function(){
		function IDTools(){
			this.tID=1;
		}

		__class(IDTools,'laya.debug.tools.IDTools');
		var __proto=IDTools.prototype;
		__proto.getID=function(){
			return this.tID++;
		}

		IDTools.getAID=function(){
			return IDTools._ID.getID();
		}

		IDTools.idObjE=function(obj,sign){
			(sign===void 0)&& (sign="default");
			if (obj["_M_id_"])return obj;
			if(!sign){
				sign="default";
			}
			if(!IDTools._idDic[sign]){
				IDTools._idDic[sign]=new IDTools();
			}
			obj["_M_id_"]=IDTools._idDic[sign].getAID();
			return obj;
		}

		IDTools.setObjID=function(obj,id){
			obj["_M_id_"]=id;
			return obj;
		}

		IDTools.idObj=function(obj){
			if (obj["_M_id_"])return obj;
			obj["_M_id_"]=IDTools.getAID();
			return obj;
		}

		IDTools.getObjID=function(obj){
			if(!obj)return-1;
			return obj["_M_id_"];
		}

		IDTools.idSign="_M_id_";
		__static(IDTools,
		['_ID',function(){return this._ID=new IDTools();},'_idDic',function(){return this._idDic={"default":new IDTools()};}
		]);
		return IDTools;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-11-27 上午9:58:59
	*/
	//class laya.debug.tools.JsonTool
	var JsonTool=(function(){
		function JsonTool(){}
		__class(JsonTool,'laya.debug.tools.JsonTool');
		JsonTool.getJsonString=function(obj,singleLine,split,depth,Width){
			(singleLine===void 0)&& (singleLine=true);
			(split===void 0)&& (split="\n");
			(depth===void 0)&& (depth=0);
			(Width===void 0)&& (Width=4);
			var preStr="";
			preStr=JsonTool.getEmptyStr(depth*Width);
			var rst;
			var keyValues;
			keyValues={};
			var tKey;
			var tValue;
			var type;
			var keys;
			keys=[];
			for(tKey in obj){
				keys.push(tKey);
				tValue=obj[tKey];
				if(JsonTool.singleLineKey[tKey]){
					keyValues[tKey]=JsonTool.getValueStr(tValue,true,split,depth+1,Width);
					}else{
					keyValues[tKey]=JsonTool.getValueStr(tValue,singleLine,split,depth+1,Width);
				}
			};
			var i=0,len=0;
			len=keys.length;
			keys.sort();
			keys=keys.reverse();
			var keyPreStr;
			keyPreStr=JsonTool.getEmptyStr((depth+1)*Width);
			if(singleLine){
				split="";
				preStr="";
				keyPreStr="";
			};
			var keyValueStrArr;
			keyValueStrArr=[];
			for(i=0;i<len;i++){
				tKey=keys[i];
				keyValueStrArr.push(keyPreStr+JsonTool.wrapValue(tKey)+":"+keyValues[tKey]);
			}
			rst="{"+split+keyValueStrArr.join(","+split)+split+preStr+"}";
			return rst;
		}

		JsonTool.wrapValue=function(value,wraper){
			(wraper===void 0)&& (wraper="\"");
			return wraper+value+wraper;
		}

		JsonTool.getArrStr=function(arr,singleLine,split,depth,Width){
			(singleLine===void 0)&& (singleLine=true);
			(split===void 0)&& (split="\n");
			(depth===void 0)&& (depth=0);
			(Width===void 0)&& (Width=4);
			var rst;
			var i=0,len=0;
			len=arr.length;
			var valueStrArr;
			valueStrArr=[];
			for(i=0;i<len;i++){
				valueStrArr.push(JsonTool.getValueStr(arr[i],singleLine,split,depth+1,Width));
			};
			var preStr="";
			preStr=JsonTool.getEmptyStr((depth+1)*Width);
			if(singleLine){
				split="";
				preStr="";
			}
			rst="["+split+preStr+valueStrArr.join(","+split+preStr)+"]";
			return rst;
		}

		JsonTool.getValueStr=function(tValue,singleLine,split,depth,Width){
			(singleLine===void 0)&& (singleLine=true);
			(split===void 0)&& (split="\n");
			(depth===void 0)&& (depth=0);
			(Width===void 0)&& (Width=0);
			var rst;
			if((typeof tValue=='string')){
				rst="\""+tValue+"\"";
				}else if(tValue==null){
				rst="null";
				}else if((typeof tValue=='number')|| ((typeof tValue=='number')&& Math.floor(tValue)==tValue)|| (typeof tValue=='boolean')){
				rst=tValue;
				}else if((tValue instanceof Array)){
				rst=JsonTool.getArrStr(tValue,singleLine,split,depth,Width);
				}else if((typeof tValue=='object')){
				rst=JsonTool.getJsonString(tValue,singleLine,split,depth,Width);
				}else{
				rst=tValue;
			}
			return rst;
		}

		JsonTool.getEmptyStr=function(width){
			if(!JsonTool.emptyDic.hasOwnProperty(width)){
				var i=0;
				var len=0;
				len=width;
				var rst;
				rst="";
				for(i=0;i<len;i++){
					rst+=" ";
				}
				JsonTool.emptyDic[width]=rst;
			}
			return JsonTool.emptyDic[width];
		}

		JsonTool.emptyDic={};
		__static(JsonTool,
		['singleLineKey',function(){return this.singleLineKey={
				"props":true
		};}

		]);
		return JsonTool;
	})()


	/**
	*本类用于操作html对象
	*@author ww
	*/
	//class laya.debug.tools.JSTools
	var JSTools=(function(){
		function JSTools(){}
		__class(JSTools,'laya.debug.tools.JSTools');
		JSTools.showToBody=function(el,x,y){
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			Browser.document.body.appendChild(el);
			var style;
			style=el.style;
			style.position="absolute";
			style.top=y+"px";
			style.left=x+"px";
		}

		JSTools.showToParent=function(el,x,y,parent){
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			parent.appendChild(el);
			var style;
			style=el.style;
			style.position="absolute";
			style.top=y+"px";
			style.left=x+"px";
		}

		JSTools.addToBody=function(el){
			Browser.document.body.appendChild(el);
		}

		JSTools.setPos=function(el,x,y){
			var style;
			style=el.style;
			style.top=y+"px";
			style.left=x+"px";
		}

		JSTools.setSize=function(el,width,height){
			var style;
			style=el.style;
			style.width=width+"px";
			style.height=height+"px";
		}

		JSTools.setTransform=function(el,mat){
			var style;
			style=el.style;
			style.transformOrigin=style.webkitTransformOrigin=style.msTransformOrigin=style.mozTransformOrigin=style.oTransformOrigin="0px 0px 0px";
			style.transform=style.webkitTransform=style.msTransform=style.mozTransform=style.oTransform="matrix("+mat.toString()+")";
		}

		JSTools.noMouseEvent=function(el){
			var style;
			style=el.style;
			style["pointer-events"]="none";
		}

		JSTools.setMouseEnable=function(el,enable){
			var style;
			style=el.style;
			style["pointer-events"]=enable?"auto":"none";
		}

		JSTools.setZIndex=function(el,zIndex){
			var style;
			style=el.style;
			style["z-index"]=zIndex;
		}

		JSTools.showAboveSprite=function(el,sprite,dx,dy){
			(dx===void 0)&& (dx=0);
			(dy===void 0)&& (dy=0);
			var pos;
			pos=new Point();
			pos=sprite.localToGlobal(pos);
			pos.x+=dx;
			pos.y+=dy;
			pos.x+=Laya.stage.offset.x;
			pos.y+=Laya.stage.offset.y;
			JSTools.showToBody(el,pos.x,pos.y);
		}

		JSTools.removeElement=function(el){
			Browser.removeElement(el);
		}

		JSTools.isElementInDom=function(el){
			return el && el.parentNode;
		}

		JSTools.getImageSpriteByFile=function(file,width,height){
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			var reader;
			/*__JS__ */reader=new FileReader();;
			reader.readAsDataURL(file);
			var sprite;
			sprite=new Sprite();
			reader.onload=function (e){
				var txt;
				txt=new Texture();
				txt.load(reader.result);
				sprite.graphics.drawTexture(txt,0,0,width,height);
			}
			return sprite;
		}

		JSTools.getPixelRatio=function(){
			if (JSTools._pixelRatio > 0)return JSTools._pixelRatio;
			var canvas=Browser.createElement("canvas");
			var context=canvas.getContext('2d');
			var devicePixelRatio=Browser.window.devicePixelRatio || 1;
			var backingStoreRatio=context.webkitBackingStorePixelRatio ||
			context.mozBackingStorePixelRatio ||
			context.msBackingStorePixelRatio ||
			context.oBackingStorePixelRatio ||
			context.backingStorePixelRatio || 1;
			var ratio=devicePixelRatio / backingStoreRatio;
			console.log("pixelRatioc:",ratio);
			JSTools._pixelRatio=ratio;
			return ratio;
		}

		JSTools._pixelRatio=-1;
		return JSTools;
	})()


	/**
	*布局工具类,目前只支持水平方向布局
	*@author ww
	*/
	//class laya.debug.tools.layout.Layouter
	var Layouter=(function(){
		function Layouter(){
			this.data=null;
			this._items=null;
			this.layoutFun=null;
			this._sX=0;
			this._width=0;
		}

		__class(Layouter,'laya.debug.tools.layout.Layouter');
		var __proto=Layouter.prototype;
		__proto.layout=function(){
			this.layoutFun(this._width,this._items,this.data,this._sX);
		}

		/**
		*重新布局
		*
		*/
		__proto.changed=function(){
			Laya.timer.callLater(this,this.layout);
		}

		/**
		*根据当前的对象状态计算位置大小
		*
		*/
		__proto.calSize=function(){
			var i=0,len=0;
			var tItem;
			tItem=this.items[0];
			this._sX=tItem.x;
			var maxX=NaN;
			maxX=this._sX+tItem.width;
			len=this.items.length;
			for (i=1;i < len;i++){
				tItem=this.items[i];
				if (this._sX > tItem.x){
					this._sX=tItem.x;
				}
				if (maxX < tItem.x+tItem.width){
					maxX=tItem.x+tItem.width;
				}
			}
			this._width=maxX-this._sX;
		}

		__getset(0,__proto,'items',function(){
			return this._items;
			},function(arr){
			this._items=arr;
			this.calSize();
		});

		__getset(0,__proto,'x',function(){
			return this._sX;
			},function(v){
			this._sX=v;
			this.changed();
		});

		__getset(0,__proto,'width',function(){
			return this._width;
			},function(v){
			this._width=v;
			this.changed();
		});

		return Layouter;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.layout.LayoutFuns
	var LayoutFuns=(function(){
		function LayoutFuns(){}
		__class(LayoutFuns,'laya.debug.tools.layout.LayoutFuns');
		LayoutFuns.sameWidth=function(totalWidth,items,data,sX){
			(sX===void 0)&& (sX=0);
			var dWidth=0;
			if (data && data.dWidth)
				dWidth=data.dWidth;
			var perWidth=NaN;
			perWidth=(totalWidth-(items.length-1)*dWidth)/ items.length;
			var tItem;
			var i=0,len=0;
			var tX=NaN;
			tX=sX;
			len=items.length;
			for (i=0;i < len;i++){
				tItem=items[i];
				tItem.x=tX;
				tItem.width=perWidth;
				tX+=dWidth+perWidth;
			}
		}

		LayoutFuns.getSameWidthLayout=function(items,dWidth){
			var data;
			data={};
			data.dWidth=dWidth;
			return LayoutFuns.getLayouter(items,data,laya.debug.tools.layout.LayoutFuns.sameWidth);
		}

		LayoutFuns.getLayouter=function(items,data,fun){
			var layouter;
			layouter=new Layouter();
			layouter.items=items;
			layouter.data=data;
			layouter.layoutFun=fun;
			return layouter;
		}

		LayoutFuns.sameDis=function(totalWidth,items,data,sX){
			(sX===void 0)&& (sX=0);
			var dWidth=NaN;
			dWidth=totalWidth;
			var tItem;
			var i=0,len=0;
			len=items.length;
			LayoutFuns.prepareForLayoutWidth(totalWidth,items);
			for (i=0;i < len;i++){
				tItem=items[i];
				dWidth-=tItem.width;
			}
			if (items.length > 1)
				dWidth=dWidth / (items.length-1);
			var tX=NaN;
			tX=sX;
			len=items.length;
			for (i=0;i < len;i++){
				tItem=items[i];
				tItem.x=tX;
				tX+=dWidth+tItem.width;
			}
		}

		LayoutFuns.getSameDisLayout=function(items,rateSame){
			(rateSame===void 0)&& (rateSame=false);
			var data;
			data={};
			if (rateSame){
				var i=0,len=0;
				len=items.length;
				var tItem;
				var totalWidth=NaN;
				totalWidth=0;
				for (i=0;i < len;i++){
					tItem=items[i];
					totalWidth+=tItem.width;
				}
				totalWidth=tItem.x+tItem.width;
				for (i=0;i < len;i++){
					tItem=items[i];
					LayoutFuns.setItemRate(tItem,tItem.width / totalWidth);
				}
			}
			return LayoutFuns.getLayouter(items,data,laya.debug.tools.layout.LayoutFuns.sameDis);
		}

		LayoutFuns.fullFill=function(totalWidth,items,data,sX){
			(sX===void 0)&& (sX=0);
			var dL=0,dR=0;
			if (data){
				if (data.dL)
					dL=data.dL;
				if (data.dR)
					dR=data.dR;
			};
			var item;
			var i=0,len=0;
			len=items.length;
			for (i=0;i < len;i++){
				item=items[i];
				item.x=sX+dL;
				item.width=totalWidth-dL-dR;
			}
		}

		LayoutFuns.getFullFillLayout=function(items,dL,dR){
			(dL===void 0)&& (dL=0);
			(dR===void 0)&& (dR=0);
			var data;
			data={};
			data.dL=dL;
			data.dR=dR;
			return LayoutFuns.getLayouter(items,data,laya.debug.tools.layout.LayoutFuns.fullFill);
		}

		LayoutFuns.fixPos=function(totalWidth,items,data,sX){
			(sX===void 0)&& (sX=0);
			var dLen=0;
			var poss=[];
			var isRate=false;
			if (data){
				if (data.dLen)
					dLen=data.dLen;
				if (data.poss)
					poss=data.poss;
				if (data.isRate)
					isRate=data.isRate;
			};
			var item;
			var i=0,len=0;
			len=poss.length;
			var tX=NaN;
			tX=sX;
			var tValue=NaN;
			var preItem;
			preItem=null;
			for (i=0;i < len;i++){
				item=items[i];
				tValue=sX+poss[i];
				if (isRate){
					tValue=sX+poss[i] *totalWidth;
				}
				item.x=tValue;
				if (preItem){
					preItem.width=item.x-dLen-preItem.x;
				}
				preItem=item;
			};
			var lastItem;
			lastItem=items[items.length-1];
			lastItem.width=sX+totalWidth-dLen-lastItem.x;
		}

		LayoutFuns.getFixPos=function(items,dLen,isRate,poss){
			(dLen===void 0)&& (dLen=0);
			(isRate===void 0)&& (isRate=false);
			var data;
			data={};
			var layout;
			layout=LayoutFuns.getLayouter(items,data,LayoutFuns.fixPos);
			var i=0,len=0;
			var sX=NaN;
			var totalWidth=NaN;
			sX=layout.x;
			totalWidth=layout.width;
			if (!poss){
				poss=[];
				len=items.length;
				var tValue=NaN;
				for (i=0;i < len;i++){
					tValue=items[i].x-sX;
					if (isRate){
						tValue=tValue / totalWidth;
					}
					else{
					}
					poss.push(tValue);
				}
			}
			data.dLen=dLen;
			data.poss=poss;
			data.isRate=isRate;
			return layout;
		}

		LayoutFuns.clearItemsRelativeInfo=function(items){
			var i=0,len=0;
			len=items.length;
			for (i=0;i < len;i++){
				LayoutFuns.clearItemRelativeInfo(items[i]);
			}
		}

		LayoutFuns.clearItemRelativeInfo=function(item){
			var Nan="NaN";
			item.getLayout().left=Nan;
			item.getLayout().right=Nan;
		}

		LayoutFuns.prepareForLayoutWidth=function(totalWidth,items){
			var i=0,len=0;
			len=items.length;
			for (i=0;i < len;i++){
				LayoutFuns.prepareItemForLayoutWidth(totalWidth,items[i]);
			}
		}

		LayoutFuns.getSumWidth=function(items){
			var sum=NaN;
			sum=0;
			var i=0,len=0;
			len=items.length;
			for (i=0;i < len;i++){
				sum+=items[i].width;
			}
			return sum;
		}

		LayoutFuns.prepareItemForLayoutWidth=function(totalWidth,item){
			if (LayoutFuns.getItemRate(item)> 0){
				item.width=totalWidth *LayoutFuns.getItemRate(item);
			}
		}

		LayoutFuns.setItemRate=function(item,rate){
			item["layoutRate"]=rate;
		}

		LayoutFuns.getItemRate=function(item){
			return item["layoutRate"] ? item["layoutRate"] :-1;
		}

		LayoutFuns.setItemFreeSize=function(item,free){
			(free===void 0)&& (free=true);
			item["layoutFreeSize"]=free;
		}

		LayoutFuns.isItemFreeSize=function(item){
			return item["layoutFreeSize"];
		}

		LayoutFuns.lockedDis=function(totalWidth,items,data,sX){
			(sX===void 0)&& (sX=0);
			var dists;
			dists=data.dists;
			var sumDis=NaN;
			sumDis=data.sumDis;
			var sumWidth=NaN;
			var i=0,len=0;
			var tItem;
			var preItem;
			LayoutFuns.prepareForLayoutWidth(totalWidth,items);
			sumWidth=LayoutFuns.getSumWidth(items);
			var dWidth=NaN;
			dWidth=totalWidth-sumDis-sumWidth;
			var freeItem;
			freeItem=LayoutFuns.getFreeItem(items);
			if(freeItem){
				freeItem.width+=dWidth;
			}
			preItem=items[0];
			preItem.x=sX;
			len=items.length;
			for(i=1;i<len;i++){
				tItem=items[i];
				tItem.x=preItem.x+preItem.width+dists[i-1];
				preItem=tItem;
			}
		}

		LayoutFuns.getFreeItem=function(items){
			var i=0,len=0;
			len=items.length;
			for (i=0;i < len;i++){
				if(LayoutFuns.isItemFreeSize(items[i])){
					return items[i];
				}
			}
			return null;
		}

		LayoutFuns.getLockedDis=function(items){
			var data;
			data={};
			var dists;
			var i=0,len=0;
			var tItem;
			var preItem;
			var sumDis=NaN;
			sumDis=0;
			var tDis=NaN;
			preItem=items[0];
			dists=[];
			len=items.length;
			for(i=1;i<len;i++){
				tItem=items[i];
				tDis=tItem.x-preItem.x-preItem.width;
				dists.push(tDis);
				sumDis+=tDis;
				preItem=tItem;
			}
			data.dists=dists;
			data.sumDis=sumDis;
			return LayoutFuns.getLayouter(items,data,laya.debug.tools.layout.LayoutFuns.lockedDis);
		}

		LayoutFuns.RateSign="layoutRate";
		LayoutFuns.FreeSizeSign="layoutFreeSize";
		return LayoutFuns;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-11-9 下午3:26:01
	*/
	//class laya.debug.tools.LayoutTools
	var LayoutTools=(function(){
		function LayoutTools(){}
		__class(LayoutTools,'laya.debug.tools.LayoutTools');
		LayoutTools.layoutToXCount=function(items,xCount,dx,dY,sx,sy){
			(xCount===void 0)&& (xCount=1);
			(dx===void 0)&& (dx=0);
			(dY===void 0)&& (dY=0);
			(sx===void 0)&& (sx=0);
			(sy===void 0)&& (sy=0);
			var tX=NaN,tY=NaN;
			var tItem;
			var i=0,len=0;
			var tCount=0;
			var maxHeight=0;
			tCount=0;
			maxHeight=0;
			tX=sx;
			tY=sy;
			len=items.length;
			for (i=0;i < len;i++){
				tItem=items[i];
				tItem.x=tX;
				tItem.y=tY;
				if (tItem.height > maxHeight){
					maxHeight=tItem.height;
				}
				tCount++;
				if (tCount >=xCount){
					tCount=tCount % xCount;
					tItem.y+=maxHeight+dY;
					maxHeight=0;
					}else{
					tX+=tItem.width+dx;
				}
			}
		}

		LayoutTools.layoutToWidth=function(items,width,dX,dY,sx,sy){
			var tX=NaN,tY=NaN;
			var tItem;
			var i=0,len=0;
			tX=sx;
			tY=sy;
			len=items.length;
			for(i=0;i<len;i++){
				tItem=items[i];
				if(tX+tItem.width+dX>width){
					tX=sx;
					tY+=dY+tItem.height;
					}else{
				}
				tItem.x=tX;
				tItem.y=tY;
				tX+=dX+tItem.width;
			}
		}

		return LayoutTools;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.MathTools
	var MathTools=(function(){
		function MathTools(){}
		__class(MathTools,'laya.debug.tools.MathTools');
		MathTools.sortBigFirst=function(a,b){
			if (a==b)
				return 0;
			return b > a ? 1 :-1;
		}

		MathTools.sortSmallFirst=function(a,b){
			if (a==b)
				return 0;
			return b > a ?-1 :1;
		}

		MathTools.sortNumBigFirst=function(a,b){
			return parseFloat(b)-parseFloat(a);
		}

		MathTools.sortNumSmallFirst=function(a,b){
			return parseFloat(a)-parseFloat(b);
		}

		MathTools.sortByKey=function(key,bigFirst,forceNum){
			(bigFirst===void 0)&& (bigFirst=false);
			(forceNum===void 0)&& (forceNum=true);
			var _sortFun;
			if (bigFirst){
				_sortFun=forceNum ? MathTools.sortNumBigFirst :MathTools.sortBigFirst;
				}else {
				_sortFun=forceNum ? MathTools.sortNumSmallFirst :MathTools.sortSmallFirst;
			}
			return function (a,b){
				return _sortFun(a[key],b[key]);
			};
		}

		return MathTools;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.MouseEventAnalyser
	var MouseEventAnalyser=(function(){
		function MouseEventAnalyser(){}
		__class(MouseEventAnalyser,'laya.debug.tools.MouseEventAnalyser');
		MouseEventAnalyser.analyseNode=function(node){
			DebugTool.showDisBound(node,true);
			var _node;
			_node=node;
			ObjectTools.clearObj(MouseEventAnalyser.infoO);
			ObjectTools.clearObj(MouseEventAnalyser.nodeO);
			ObjectTools.clearObj(MouseEventAnalyser.hitO);
			var nodeList;
			nodeList=[];
			while (node){
				IDTools.idObj(node);
				MouseEventAnalyser.nodeO[IDTools.getObjID(node)]=node;
				nodeList.push(node);
				node=node.parent;
			}
			MouseEventAnalyser.check(Laya.stage,Laya.stage.mouseX,Laya.stage.mouseY,null);
			var canStr;
			if (MouseEventAnalyser.hitO[IDTools.getObjID(_node)]){
				console.log("can hit");
				canStr="can hit";
			}
			else{
				console.log("can't hit");
				canStr="can't hit";
			};
			var i=0,len=0;
			nodeList=nodeList.reverse();
			len=nodeList.length;
			var rstTxts;
			rstTxts=["[分析对象]:"+ClassTool.getNodeClassAndName(_node)+":"+canStr];
			for (i=0;i < len;i++){
				node=nodeList[i];
				if (MouseEventAnalyser.hitO[IDTools.getObjID(node)]){
					console.log("can hit:",ClassTool.getNodeClassAndName(node));
					console.log("原因:",MouseEventAnalyser.infoO[IDTools.getObjID(node)]);
					rstTxts.push("can hit:"+" "+ClassTool.getNodeClassAndName(node));
					rstTxts.push("原因:"+" "+MouseEventAnalyser.infoO[IDTools.getObjID(node)]);
				}
				else{
					console.log("can't hit:"+ClassTool.getNodeClassAndName(node));
					console.log("原因:",MouseEventAnalyser.infoO[IDTools.getObjID(node)] ? MouseEventAnalyser.infoO[IDTools.getObjID(node)] :"鼠标事件在父级已停止派发");
					rstTxts.push("can't hit:"+" "+ClassTool.getNodeClassAndName(node));
					rstTxts.push("原因:"+" "+(MouseEventAnalyser.infoO[IDTools.getObjID(node)] ? MouseEventAnalyser.infoO[IDTools.getObjID(node)] :"鼠标事件在父级已停止派发"));
				}
			};
			var rstStr;
			rstStr=rstTxts.join("\n");
			ToolPanel.I.showTxtInfo(rstStr);
		}

		MouseEventAnalyser.check=function(sp,mouseX,mouseY,callBack){
			IDTools.idObj(sp);
			var isInAnlyseChain=false;
			isInAnlyseChain=MouseEventAnalyser.nodeO[IDTools.getObjID(sp)];
			var transform=sp.transform || MouseEventAnalyser._matrix;
			var pivotX=sp.pivotX;
			var pivotY=sp.pivotY;
			if (pivotX===0 && pivotY===0){
				transform.setTranslate(sp.x,sp.y);
			}
			else{
				if (transform===MouseEventAnalyser._matrix){
					transform.setTranslate(sp.x-pivotX,sp.y-pivotY);
				}
				else{
					var cos=transform.cos;
					var sin=transform.sin;
					transform.setTranslate(sp.x-(pivotX *cos-pivotY *sin)*sp.scaleX,sp.y-(pivotX *sin+pivotY *cos)*sp.scaleY);
				}
			}
			transform.invertTransformPoint(MouseEventAnalyser._point.setTo(mouseX,mouseY));
			transform.setTranslate(0,0);
			mouseX=MouseEventAnalyser._point.x;
			mouseY=MouseEventAnalyser._point.y;
			var scrollRect=sp.scrollRect;
			if (scrollRect){
				MouseEventAnalyser._rect.setTo(0,0,scrollRect.width,scrollRect.height);
				var isHit=MouseEventAnalyser._rect.contains(mouseX,mouseY);
				if (!isHit){
					if (isInAnlyseChain){
						MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="scrollRect没有包含鼠标"+MouseEventAnalyser._rect.toString()+":"+mouseX+","+mouseY;
					}
					return false;
				}
			};
			var i=0,len=0;
			var cList;
			cList=sp._childs;
			len=cList.length;
			var child;
			var childInChain;
			childInChain=null;
			for (i=0;i < len;i++){
				child=cList[i];
				IDTools.idObj(child);
				if (MouseEventAnalyser.nodeO[IDTools.getObjID(child)]){
					childInChain=child;
					break ;
				}
			};
			var coverByOthers=false;
			coverByOthers=childInChain ? true :false;
			var flag=false;
			if (sp.hitTestPrior && !sp.mouseThrough && !MouseEventAnalyser.hitTest(sp,mouseX,mouseY)){
				MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="hitTestPrior=true，宽高区域不包含鼠标:"+":"+mouseX+","+mouseY+" size:"+sp.width+","+sp.height;
				return false;
			}
			for (i=sp._childs.length-1;i >-1;i--){
				child=sp._childs[i];
				if (child==childInChain){
					if (!childInChain.mouseEnabled){
						MouseEventAnalyser.infoO[IDTools.getObjID(childInChain)]="mouseEnabled=false";
					}
					if (!childInChain.visible){
						MouseEventAnalyser.infoO[IDTools.getObjID(childInChain)]="visible=false";
					}
					coverByOthers=false;
				}
				if (child.mouseEnabled && child.visible){
					flag=MouseEventAnalyser.check(child,mouseX+(scrollRect ? scrollRect.x :0),mouseY+(scrollRect ? scrollRect.y :0),callBack);
					if (flag){
						MouseEventAnalyser.hitO[IDTools.getObjID(sp)]=true;
						MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="子对象被击中";
						if (child==childInChain){
							MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="子对象被击中,"+"击中对象在分析链中";
						}
						else{
							MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="子对象被击中,"+"击中对象不在分析链中";
							if (coverByOthers){
								MouseEventAnalyser.infoO[IDTools.getObjID(childInChain)]="被兄弟节点挡住,兄弟节点信息:"+ClassTool.getNodeClassAndName(child)+","+child.getBounds().toString();
								DebugTool.showDisBound(child,false,"#ffff00");
							}
						}
						return true;
					}
					else{
						if (child==childInChain){
							coverByOthers=false;
						}
					}
				}
			};
			var mHitRect=new Rectangle();
			var graphicHit=false;
			graphicHit=sp.getGraphicBounds().contains(mouseX,mouseY);
			if (sp.width > 0 && sp.height > 0){
				var hitRect=MouseEventAnalyser._rect;
				if (!sp.mouseThrough){
					if (sp.hitArea)
						hitRect=sp.hitArea;
					else
					hitRect.setTo(0,0,sp.width,sp.height);
					mHitRect.copyFrom(hitRect);
					isHit=hitRect.contains(mouseX,mouseY);
				}
				else{
					isHit=graphicHit;
					mHitRect.copyFrom(sp.getGraphicBounds());
				}
				if (isHit){
					MouseEventAnalyser.hitO[IDTools.getObjID(sp)]=true;
				}
				}else{
			}
			if (!isHit){
				if (graphicHit){
					MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="子对象未包含鼠标，实际绘图区域包含鼠标，设置的宽高区域不包含鼠标:"+":"+mouseX+","+mouseY+" hitRec:"+mHitRect.toString()+" graphicBounds:"+sp.getGraphicBounds().toString()+"，设置mouseThrough=true或将宽高设置到实际绘图区域可解决问题";
					}else{
					MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="子对象未包含鼠标，实际绘图区域不包含鼠标，设置的宽高区域不包含鼠标:"+":"+mouseX+","+mouseY+" hitRec:"+mHitRect.toString()+" graphicBounds:"+sp.getGraphicBounds().toString();
				}
			}
			else{
				MouseEventAnalyser.infoO[IDTools.getObjID(sp)]="自身区域被击中";
			}
			return isHit;
		}

		MouseEventAnalyser.hitTest=function(sp,mouseX,mouseY){
			var isHit=false;
			if (sp.width > 0 && sp.height > 0 || sp.mouseThrough || sp.hitArea){
				var hitRect=MouseEventAnalyser._rect;
				if (!sp.mouseThrough){
					if (sp.hitArea)hitRect=sp.hitArea;
					else hitRect.setTo(0,0,sp.width,sp.height);
					isHit=hitRect.contains(mouseX,mouseY);
					}else {
					isHit=sp.getGraphicBounds().contains(mouseX,mouseY);
				}
			}
			return isHit;
		}

		MouseEventAnalyser.infoO={};
		MouseEventAnalyser.nodeO={};
		MouseEventAnalyser.hitO={};
		__static(MouseEventAnalyser,
		['_matrix',function(){return this._matrix=new Matrix();},'_point',function(){return this._point=new Point();},'_rect',function(){return this._rect=new Rectangle();}
		]);
		return MouseEventAnalyser;
	})()


	/**
	*本类提供obj相关的一些操作
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-21 下午2:03:36
	*/
	//class laya.debug.tools.ObjectTools
	var ObjectTools=(function(){
		function ObjectTools(){}
		__class(ObjectTools,'laya.debug.tools.ObjectTools');
		ObjectTools.getFlatKey=function(tKey,aKey){
			if(tKey=="")return aKey;
			return tKey+ObjectTools.sign+aKey;
		}

		ObjectTools.flatObj=function(obj,rst,tKey){
			(tKey===void 0)&& (tKey="");
			rst=rst?rst:{};
			var key;
			var tValue;
			for(key in obj){
				if((typeof (obj[key])=='object')){
					ObjectTools.flatObj(obj[key],rst,ObjectTools.getFlatKey(tKey,key));
					}else{
					tValue=obj[key];
					rst[ObjectTools.getFlatKey(tKey,key)]=obj[key];
				}
			}
			return rst;
		}

		ObjectTools.recoverObj=function(obj){
			var rst={};
			var tKey;
			for(tKey in obj){
				ObjectTools.setKeyValue(rst,tKey,obj[tKey]);
			}
			return rst;
		}

		ObjectTools.differ=function(objA,objB){
			var tKey;
			var valueA;
			var valueB;
			objA=ObjectTools.flatObj(objA);
			objB=ObjectTools.flatObj(objB);
			var rst={};
			for(tKey in objA){
				if(!objB.hasOwnProperty(tKey)){
					rst[tKey]="被删除";
				}
			}
			for(tKey in objB){
				if(objB[tKey]!=objA[tKey]){
					rst[tKey]={"pre":objA[tKey],"now":objB[tKey]};
				}
			}
			return rst;
		}

		ObjectTools.traceDifferObj=function(obj){
			var key;
			var tO;
			for(key in obj){
				if((typeof (obj[key])=='string')){
					console.log(key+":",obj[key]);
					}else{
					tO=obj[key];
					console.log(key+":","now:",tO["now"],"pre:",tO["pre"]);
				}
			}
		}

		ObjectTools.setKeyValue=function(obj,flatKey,value){
			if(flatKey.indexOf(ObjectTools.sign)>=0){
				var keys=flatKey.split(ObjectTools.sign);
				var tKey;
				while(keys.length>1){
					tKey=keys.shift();
					if(!obj[tKey]){
						obj[tKey]={};
						console.log("addKeyObj:",tKey);
					}
					obj=obj[tKey];
					if(!obj){
						console.log("wrong flatKey:",flatKey);
						return;
					}
				}
				obj[keys.shift()]=value;
				}else{
				obj[flatKey]=value;
			}
		}

		ObjectTools.clearObj=function(obj){
			var key;
			for (key in obj){
				delete obj[key];
			}
		}

		ObjectTools.copyObj=function(obj){
			if((obj instanceof Array))return ObjectTools.copyArr(obj);
			var rst={};
			var key;
			for(key in obj){
				if(((obj[key])instanceof Array)){
					rst[key]=ObjectTools.copyArr(obj[key]);
				}
				else
				if((typeof (obj[key])=='object')){
					rst[key]=ObjectTools.copyObj(obj[key]);
					}else{
					rst[key]=obj[key];
				}
			}
			return rst;
		}

		ObjectTools.copyArr=function(arr){
			var rst;
			rst=[];
			var i=0,len=0;
			len=arr.length;
			for(i=0;i<len;i++){
				rst.push(ObjectTools.copyObj(arr[i]));
			}
			return rst;
		}

		ObjectTools.concatArr=function(src,a){
			if (!a)return src;
			if (!src)return a;
			var i=0,len=a.length;
			for (i=0;i < len;i++){
				src.push(a[i]);
			}
			return src;
		}

		ObjectTools.clearArr=function(arr){
			if (!arr)return arr;
			arr.length=0;
			return arr;
		}

		ObjectTools.setValueArr=function(src,v){
			src || (src=[]);
			src.length=0;
			return ObjectTools.concatArr(src,v);
		}

		ObjectTools.getFrom=function(rst,src,count){
			var i=0;
			for (i=0;i < count;i++){
				rst.push(src[i]);
			}
			return rst;
		}

		ObjectTools.getFromR=function(rst,src,count){
			var i=0;
			for (i=0;i < count;i++){
				rst.push(src.pop());
			}
			return rst;
		}

		ObjectTools.enableDisplayTree=function(dis){
			while (dis){
				dis.mouseEnabled=true;
				dis=dis.parent;
			}
		}

		ObjectTools.getJsonString=function(obj){
			var rst;
			/*__JS__ */rst=JSON.stringify(obj);
			return rst;
		}

		ObjectTools.getObj=function(jsonStr){
			var rst;
			/*__JS__ */rst=JSON.parse(jsonStr);
			return rst;
		}

		ObjectTools.getKeyArr=function(obj){
			var rst;
			var key;
			rst=[];
			for(key in obj){
				rst.push(key);
			}
			return rst;
		}

		ObjectTools.hasKeys=function(obj,keys){
			var i=0,len=0;
			len=keys.length;
			for(i=0;i<len;i++){
				if(!obj.hasOwnProperty(keys[i]))return false;
			}
			return true;
		}

		ObjectTools.copyValueByArr=function(tar,src,keys){
			var i=0,len=keys.length;
			for(i=0;i<len;i++){
				if(!(src[keys[i]]===null))
					tar[keys[i]]=src[keys[i]];
			}
		}

		ObjectTools.insertValue=function(tar,src){
			var key;
			for (key in src){
				tar[key]=src[key];
			}
		}

		ObjectTools.replaceValue=function(obj,replaceO){
			var key;
			for(key in obj){
				if(replaceO.hasOwnProperty(obj[key])){
					obj[key]=replaceO[obj[key]];
				}
				if((typeof (obj[key])=='object')){
					ObjectTools.replaceValue(obj[key],replaceO);
				}
			}
		}

		ObjectTools.setKeyValues=function(items,key,value){
			var i=0,len=0;
			len=items.length;
			for(i=0;i<len;i++){
				items[i][key]=value;
			}
		}

		ObjectTools.findItemPos=function(items,sign,value){
			var i=0,len=0;
			len=items.length;
			for(i=0;i<len;i++){
				if(items[i][sign]==value){
					return i;
				}
			}
			return-1;
		}

		ObjectTools.setObjValue=function(obj,key,value){
			obj[key]=value;
			return obj;
		}

		ObjectTools.setAutoTypeValue=function(obj,key,value){
			if(obj.hasOwnProperty(key)){
				if(ObjectTools.isNumber(obj[key])){
					obj[key]=parseFloat(value);
					}else{
					obj[key]=value;
				}
				}else{
				obj[key]=value;
			}
			return obj;
		}

		ObjectTools.getAutoValue=function(value){
			if (parseFloat(value)==value)return parseFloat(value);
			return value;
		}

		ObjectTools.isNumber=function(value){
			return (parseFloat(value)==value);
		}

		ObjectTools.isNaN=function(value){
			return value.toString()=="NaN";
		}

		ObjectTools.getStrTypedValue=function(value){
			if(value=="false"){
				return false;
			}else
			if(value=="true"){
				return true;
			}else
			if(value=="null"){
				return null;
			}else
			if(value=="undefined"){
				return null;
				}else{
				return ObjectTools.getAutoValue(value);
			}
		}

		ObjectTools.createKeyValueDic=function(dataList,keySign){
			var rst;
			rst={};
			var i=0,len=0;
			len=dataList.length;
			var tItem;
			var tKey;
			for(i=0;i<len;i++){
				tItem=dataList[i];
				tKey=tItem[keySign];
				rst[tKey]=tItem;
			}
			return rst;
		}

		ObjectTools.sign="_";
		return ObjectTools;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.ObjTimeCountTool
	var ObjTimeCountTool=(function(){
		function ObjTimeCountTool(){
			this.timeDic={};
			this.resultDic={};
			this.countDic={};
			this.resultCountDic={};
			this.nodeDic={};
			this.resultNodeDic={};
		}

		__class(ObjTimeCountTool,'laya.debug.tools.ObjTimeCountTool');
		var __proto=ObjTimeCountTool.prototype;
		__proto.addTime=function(sprite,time){
			IDTools.idObj(sprite);
			var key=0;
			key=IDTools.getObjID(sprite);
			if (!this.timeDic.hasOwnProperty(key)){
				this.timeDic[key]=0;
			}
			this.timeDic[key]=this.timeDic[key]+time;
			if (!this.countDic.hasOwnProperty(key)){
				this.countDic[key]=0;
			}
			this.countDic[key]=this.countDic[key]+1;
			this.nodeDic[key]=sprite;
		}

		__proto.getTime=function(sprite){
			IDTools.idObj(sprite);
			var key=0;
			key=IDTools.getObjID(sprite);
			if (!this.resultDic[key])return 0;
			return this.resultDic[key];
		}

		__proto.getCount=function(sprite){
			IDTools.idObj(sprite);
			var key=0;
			key=IDTools.getObjID(sprite);
			return this.resultCountDic[key];
		}

		__proto.reset=function(){
			var key;
			for (key in this.timeDic){
				this.timeDic[key]=0;
				this.countDic[key]=0;
			}
			ObjectTools.clearObj(this.nodeDic);
		}

		__proto.updates=function(){
			ObjectTools.clearObj(this.resultDic);
			ObjectTools.insertValue(this.resultDic,this.timeDic);
			ObjectTools.clearObj(this.resultCountDic);
			ObjectTools.insertValue(this.resultCountDic,this.countDic);
			ObjectTools.insertValue(this.resultNodeDic,this.nodeDic);
			this.reset();
		}

		return ObjTimeCountTool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-23 下午12:00:48
	*/
	//class laya.debug.tools.RecInfo
	var RecInfo=(function(){
		function RecInfo(){
			this.oX=0;
			this.oY=0;
			this.hX=1;
			this.hY=0;
			this.vX=0;
			this.vY=1;
		}

		__class(RecInfo,'laya.debug.tools.RecInfo');
		var __proto=RecInfo.prototype;
		__proto.initByPoints=function(oPoint,ePoint,vPoint){
			this.oX=oPoint.x;
			this.oY=oPoint.y;
			this.hX=ePoint.x;
			this.hY=ePoint.y;
			this.vX=vPoint.x;
			this.vY=vPoint.y;
		}

		__getset(0,__proto,'rotationRad',function(){
			var dx=this.hX-this.oX;
			var dy=this.hY-this.oY;
			return Math.atan2(dy,dx);
		});

		__getset(0,__proto,'x',function(){
			return this.oX;
		});

		__getset(0,__proto,'y',function(){
			return this.oY;
		});

		__getset(0,__proto,'rotationRadV',function(){
			var dx=this.vX-this.oX;
			var dy=this.vY-this.oY;
			return Math.atan2(dy,dx);
		});

		__getset(0,__proto,'width',function(){
			return Math.sqrt((this.hX-this.oX)*(this.hX-this.oX)+(this.hY-this.oY)*(this.hY-this.oY));
		});

		__getset(0,__proto,'height',function(){
			return Math.sqrt((this.vX-this.oX)*(this.vX-this.oX)+(this.vY-this.oY)*(this.vY-this.oY));
		});

		__getset(0,__proto,'rotation',function(){
			return this.rotationRad/Math.PI*180;
		});

		__getset(0,__proto,'rotationV',function(){
			return this.rotationRadV/Math.PI*180;
		});

		RecInfo.createByPoints=function(oPoint,ePoint,vPoint){
			var rst;
			rst=new RecInfo();
			rst.initByPoints(oPoint,ePoint,vPoint);
			return rst;
		}

		RecInfo.getGlobalPoints=function(sprite,x,y){
			return sprite.localToGlobal(new Point(x,y));
		}

		RecInfo.getGlobalRecInfo=function(sprite,x0,y0,x1,y1,x2,y2){
			(x0===void 0)&& (x0=0);
			(y0===void 0)&& (y0=0);
			(x1===void 0)&& (x1=1);
			(y1===void 0)&& (y1=0);
			(x2===void 0)&& (x2=0);
			(y2===void 0)&& (y2=1);
			return RecInfo.createByPoints(RecInfo.getGlobalPoints(sprite,x0,y0),RecInfo.getGlobalPoints(sprite,x1,y1),RecInfo.getGlobalPoints(sprite,x2,y2));
		}

		return RecInfo;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.RenderAnalyser
	var RenderAnalyser=(function(){
		function RenderAnalyser(){
			this.timeDic={};
			this.resultDic={};
			this.countDic={};
			this.resultCountDic={};
			this.nodeDic={};
			this.isWorking=false;
			this.working=true;
		}

		__class(RenderAnalyser,'laya.debug.tools.RenderAnalyser');
		var __proto=RenderAnalyser.prototype;
		__proto.render=function(sprite,time){
			this.addTime(sprite,time);
		}

		__proto.addTime=function(sprite,time){
			IDTools.idObj(sprite);
			var key=0;
			key=IDTools.getObjID(sprite);
			if (!this.timeDic.hasOwnProperty(key)){
				this.timeDic[key]=0;
			}
			this.timeDic[key]=this.timeDic[key]+time;
			if (!this.countDic.hasOwnProperty(key)){
				this.countDic[key]=0;
			}
			this.countDic[key]=this.countDic[key]+1;
			this.nodeDic[key]=sprite;
		}

		__proto.getTime=function(sprite){
			IDTools.idObj(sprite);
			var key=0;
			key=IDTools.getObjID(sprite);
			if (!this.resultDic[key])return 0;
			return this.resultDic[key];
		}

		__proto.getCount=function(sprite){
			IDTools.idObj(sprite);
			var key=0;
			key=IDTools.getObjID(sprite);
			return this.resultCountDic[key];
		}

		__proto.reset=function(){
			var key;
			for (key in this.timeDic){
				this.timeDic[key]=0;
				this.countDic[key]=0;
			}
			ObjectTools.clearObj(this.nodeDic);
		}

		__proto.updates=function(){
			ObjectTools.clearObj(this.resultDic);
			ObjectTools.insertValue(this.resultDic,this.timeDic);
			ObjectTools.clearObj(this.resultCountDic);
			ObjectTools.insertValue(this.resultCountDic,this.countDic);
			this.reset();
		}

		__getset(0,__proto,'working',null,function(v){
			this.isWorking=v;
			if (v){
				Laya.timer.loop(NodeConsts.RenderCostMaxTime,this,this.updates);
				}else{
				Laya.timer.clear(this,this.updates);
			}
		});

		__static(RenderAnalyser,
		['I',function(){return this.I=new RenderAnalyser();}
		]);
		return RenderAnalyser;
	})()


	/**
	*本类用于调整对象的宽高以及坐标
	*@author ww
	*/
	//class laya.debug.tools.resizer.DisResizer
	var DisResizer=(function(){
		function DisResizer(){}
		__class(DisResizer,'laya.debug.tools.resizer.DisResizer');
		DisResizer.init=function(){
			if (DisResizer._up)return;
			DisResizer._up=new AutoFillRec("T");
			DisResizer._up.height=2;
			DisResizer._up.type=0;
			DisResizer._down=new AutoFillRec("T");
			DisResizer._down.height=2;
			DisResizer._down.type=0;
			DisResizer._left=new AutoFillRec("R");
			DisResizer._left.width=2;
			DisResizer._left.type=1;
			DisResizer._right=new AutoFillRec("R");
			DisResizer._right.width=2;
			DisResizer._right.type=1;
			DisResizer._barList=[DisResizer._up,DisResizer._down,DisResizer._left,DisResizer._right];
			DisResizer.addEvent();
		}

		DisResizer.stageDown=function(e){
			var target;
			target=e.target;
			if (DisResizer._tar && DisControlTool.isInTree(DisResizer._tar,target)){
				return;
			}
			DisResizer.clear();
		}

		DisResizer.clear=function(){
			DisResizer._tar=null;
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",null,DisResizer.stageDown);
			DisControlTool.removeItems(DisResizer._barList);
			DisResizer.clearDragEvents();
		}

		DisResizer.addEvent=function(){
			var i=0,len=0;
			var tBar;
			len=DisResizer._barList.length;
			for (i=0;i < len;i++){
				tBar=DisResizer._barList[i];
				tBar.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",null,DisResizer.barDown);
			}
		}

		DisResizer.barDown=function(e){
			DisResizer.clearDragEvents();
			DisResizer.tBar=e.target;
			if (!DisResizer.tBar)return;
			var area;
			area=new Rectangle();
			if (DisResizer.tBar.type==0){
				area.x=DisResizer.tBar.x;
				area.width=0;
				area.y=DisResizer.tBar.y-200;
				area.height=400;
				}else{
				area.x=DisResizer.tBar.x-200;
				area.width=400;
				area.y=0;
				area.height=0;
			};
			var option;
			option={};
			option.area=area;
			DisResizer.tBar.record();
			DisResizer.tBar.startDrag(area);
			DisResizer.tBar.on(/*laya.events.Event.DRAG_MOVE*/"dragmove",null,DisResizer.draging);
			DisResizer.tBar.on(/*laya.events.Event.DRAG_END*/"dragend",null,DisResizer.dragEnd);
		}

		DisResizer.draging=function(e){
			console.log("draging");
			if (!DisResizer.tBar)return;
			if (!DisResizer._tar)return;
			switch(DisResizer.tBar){
				case DisResizer._left:
					DisResizer._tar.x+=DisResizer.tBar.getDx();
					DisResizer._tar.width-=DisResizer.tBar.getDx();
					DisResizer._up.width-=DisResizer.tBar.getDx();
					DisResizer._down.width-=DisResizer.tBar.getDx();
					DisResizer._right.x-=DisResizer.tBar.getDx();
					DisResizer.tBar.x-=DisResizer.tBar.getDx();
					break ;
				case DisResizer._right:
					DisResizer._tar.width+=DisResizer.tBar.getDx();
					DisResizer._up.width+=DisResizer.tBar.getDx();
					DisResizer._down.width+=DisResizer.tBar.getDx();
					break ;
				case DisResizer._up:
					DisResizer._tar.y+=DisResizer.tBar.getDy();
					DisResizer._tar.height-=DisResizer.tBar.getDy();
					DisResizer._right.height-=DisResizer.tBar.getDy();
					DisResizer._left.height-=DisResizer.tBar.getDy();
					DisResizer._down.y-=DisResizer.tBar.getDy();
					DisResizer.tBar.y-=DisResizer.tBar.getDy();
					break ;
				case DisResizer._down:
					DisResizer._tar.height+=DisResizer.tBar.getDy();
					DisResizer._right.height+=DisResizer.tBar.getDy();
					DisResizer._left.height+=DisResizer.tBar.getDy();
					break ;
				}
			DisResizer.tBar.record();
		}

		DisResizer.dragEnd=function(e){
			console.log("dragEnd");
			DisResizer.clearDragEvents();
			DisResizer.updates();
		}

		DisResizer.clearDragEvents=function(){
			if (!DisResizer.tBar)return;
			DisResizer.tBar.off(/*laya.events.Event.DRAG_MOVE*/"dragmove",null,DisResizer.draging);
			DisResizer.tBar.off(/*laya.events.Event.DRAG_END*/"dragend",null,DisResizer.dragEnd);
		}

		DisResizer.setUp=function(dis,force){
			(force===void 0)&& (force=false);
			if (force && dis==DisResizer._tar){
				return;
			};
			DisControlTool.removeItems(DisResizer._barList);
			if (DisResizer._tar==dis){
				DisResizer._tar=null;
				DisResizer.clearDragEvents();
				if(!force)
					return;
			}
			DisResizer._tar=dis;
			DisResizer.updates();
			DisControlTool.addItems(DisResizer._barList,dis);
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",null,DisResizer.stageDown);
			Laya.stage.on(/*laya.events.Event.MOUSE_UP*/"mouseup",null,DisResizer.stageDown);
		}

		DisResizer.updates=function(){
			var dis;
			dis=DisResizer._tar;
			if(!dis)return;
			var bounds;
			bounds=new Rectangle(0,0,dis.width,dis.height);
			DisResizer._up.x=bounds.x;
			DisResizer._up.y=bounds.y;
			DisResizer._up.width=bounds.width;
			DisResizer._down.x=bounds.x;
			DisResizer._down.y=bounds.y+bounds.height-2;
			DisResizer._down.width=bounds.width;
			DisResizer._left.x=bounds.x;
			DisResizer._left.y=bounds.y;
			DisResizer._left.height=bounds.height;
			DisResizer._right.x=bounds.x+bounds.width-2;
			DisResizer._right.y=bounds.y;
			DisResizer._right.height=bounds.height;
		}

		DisResizer.Side=2;
		DisResizer.Vertical=1;
		DisResizer.Horizon=0;
		DisResizer._up=null
		DisResizer._down=null
		DisResizer._left=null
		DisResizer._right=null
		DisResizer._barList=null
		DisResizer._tar=null
		DisResizer.barWidth=2;
		DisResizer.useGetBounds=false;
		DisResizer.tBar=null
		return DisResizer;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.resizer.SimpleResizer
	var SimpleResizer=(function(){
		function SimpleResizer(){}
		__class(SimpleResizer,'laya.debug.tools.resizer.SimpleResizer');
		SimpleResizer.setResizeAble=function(clickItem,tar,minWidth,minHeight){
			(minWidth===void 0)&& (minWidth=150);
			(minHeight===void 0)&& (minHeight=150);
			clickItem.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",null,SimpleResizer.onMouseDown,[tar,minWidth,minHeight]);
		}

		SimpleResizer.onMouseDown=function(tar,minWidth,minHeight,e){
			SimpleResizer.clearEvents();
			if (!tar)return;
			SimpleResizer.preMousePoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			SimpleResizer.preTarSize.setTo(tar.width,tar.height);
			SimpleResizer.preScale.setTo(1,1);
			var rTar;
			rTar=tar;
			while (rTar&&rTar!=Laya.stage){
				SimpleResizer.preScale.x *=rTar.scaleX;
				SimpleResizer.preScale.y *=rTar.scaleY;
				rTar=rTar.parent;
			}
			Laya.stage.on(/*laya.events.Event.MOUSE_UP*/"mouseup",null,SimpleResizer.onMouseMoveEnd);
			Laya.timer.loop(100,null,SimpleResizer.onMouseMoving,[tar,minWidth,minHeight]);
		}

		SimpleResizer.onMouseMoving=function(tar,minWidth,minHeight,e){
			var tWidth=(Laya.stage.mouseX-SimpleResizer.preMousePoint.x)/ SimpleResizer.preScale.x+SimpleResizer.preTarSize.x;
			var tHeight=(Laya.stage.mouseY-SimpleResizer.preMousePoint.y)/SimpleResizer.preScale.y+SimpleResizer.preTarSize.y;
			tar.width=tWidth > minWidth?tWidth:minWidth;
			tar.height=tHeight>minHeight?tHeight:minHeight;
		}

		SimpleResizer.onMouseMoveEnd=function(e){
			SimpleResizer.clearEvents();
		}

		SimpleResizer.clearEvents=function(){
			Laya.timer.clear(null,SimpleResizer.onMouseMoving);
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",null,SimpleResizer.onMouseMoveEnd);
		}

		__static(SimpleResizer,
		['preMousePoint',function(){return this.preMousePoint=new Point();},'preTarSize',function(){return this.preTarSize=new Point();},'preScale',function(){return this.preScale=new Point();}
		]);
		return SimpleResizer;
	})()


	/**
	*类实例创建分析工具
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-25 下午3:31:46
	*/
	//class laya.debug.tools.RunProfile
	var RunProfile=(function(){
		function RunProfile(){}
		__class(RunProfile,'laya.debug.tools.RunProfile');
		RunProfile.run=function(funName,callLen){
			(callLen===void 0)&& (callLen=3);
			var tCount;
			if(!RunProfile.infoDic.hasOwnProperty(funName)){
				RunProfile.infoDic[funName]=new CountTool();
			}
			tCount=RunProfile.infoDic[funName];
			var msg;
			msg=TraceTool.getCallLoc(callLen)+"\n"+TraceTool.getCallStack(1,callLen-3);
			tCount.add(msg);
			if(RunProfile._runShowDic[funName]){
				console.log("Create:"+funName);
				console.log(msg);
			}
		}

		RunProfile.showClassCreate=function(funName){
			RunProfile._runShowDic[funName]=true;
		}

		RunProfile.hideClassCreate=function(funName){
			RunProfile._runShowDic[funName]=false;
		}

		RunProfile.getRunInfo=function(funName){
			var rst;
			rst=RunProfile.infoDic[funName];
			if(rst){
			}
			return RunProfile.infoDic[funName];
		}

		RunProfile.runTest=function(fun,count,sign){
			(sign===void 0)&& (sign="runTest");
			DTrace.timeStart(sign);
			var i=0;
			for(i=0;i<count;i++){
				fun();
			}
			DTrace.timeEnd(sign);
		}

		RunProfile.infoDic={};
		RunProfile._runShowDic={};
		return RunProfile;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2016-6-24 下午6:07:30
	*/
	//class laya.debug.tools.SingleTool
	var SingleTool=(function(){
		function SingleTool(){
			this._objDic={};
		}

		__class(SingleTool,'laya.debug.tools.SingleTool');
		var __proto=SingleTool.prototype;
		__proto.getArr=function(sign){
			var dic;
			dic=this.getTypeDic("Array");
			if(!dic[sign])dic[sign]=[];
			return dic[sign];
		}

		__proto.getObject=function(sign){
			var dic;
			dic=this.getTypeDic("Object");
			if(!dic[sign])dic[sign]={};
			return dic[sign];
		}

		__proto.getByClass=function(sign,clzSign,clz){
			var dic;
			dic=this.getTypeDic(clzSign);
			if(!dic[sign])dic[sign]=new clz();
			return dic[sign];
		}

		__proto.getTypeDic=function(type){
			if(!this._objDic[type])this._objDic[type]={};
			return this._objDic[type];
		}

		__static(SingleTool,
		['I',function(){return this.I=new SingleTool();}
		]);
		return SingleTool;
	})()


	/**
	*一些字符串操作函数
	*@author ww
	*
	*/
	//class laya.debug.tools.StringTool
	var StringTool=(function(){
		function StringTool(){}
		__class(StringTool,'laya.debug.tools.StringTool');
		StringTool.toUpCase=function(str){
			return str.toUpperCase();
		}

		StringTool.toLowCase=function(str){
			return str.toLowerCase();
		}

		StringTool.toUpHead=function(str){
			var rst;
			if(str.length<=1)return str.toUpperCase();
			rst=str.charAt(0).toUpperCase()+str.substr(1);
			return rst;
		}

		StringTool.toLowHead=function(str){
			var rst;
			if(str.length<=1)return str.toLowerCase();
			rst=str.charAt(0).toLowerCase()+str.substr(1);
			return rst;
		}

		StringTool.packageToFolderPath=function(packageName){
			var rst;
			rst=packageName.replace(".","/");
			return rst;
		}

		StringTool.insert=function(str,iStr,index){
			return str.substring(0,index)+iStr+str.substr(index);
		}

		StringTool.insertAfter=function(str,iStr,tarStr,isLast){
			(isLast===void 0)&& (isLast=false);
			var i=0;
			if(isLast){
				i=str.lastIndexOf(tarStr);
				}else{
				i=str.indexOf(tarStr);
			}
			if(i>=0){
				return StringTool.insert(str,iStr,i+tarStr.length);
			}
			return str;
		}

		StringTool.insertBefore=function(str,iStr,tarStr,isLast){
			(isLast===void 0)&& (isLast=false);
			var i=0;
			if(isLast){
				i=str.lastIndexOf(tarStr);
				}else{
				i=str.indexOf(tarStr);
			}
			if(i>=0){
				return StringTool.insert(str,iStr,i);
			}
			return str;
		}

		StringTool.insertParamToFun=function(funStr,params){
			var oldParam;
			oldParam=StringTool.getParamArr(funStr);
			var inserStr;
			inserStr=params.join(",");
			if(oldParam.length>0){
				inserStr=","+inserStr;
			}
			return StringTool.insertBefore(funStr,inserStr,")",true);
		}

		StringTool.trim=function(str,vList){
			if(!vList){
				vList=[" ","\r","\n","\t",String.fromCharCode(65279)];
			};
			var rst;
			var i=0;
			var len=0;
			rst=str;
			len=vList.length;
			for(i=0;i<len;i++){
				rst=StringTool.getReplace(rst,vList[i],"");
			}
			return rst;
		}

		StringTool.isEmpty=function(str){
			if(str.length<1)return true;
			return StringTool.emptyStrDic.hasOwnProperty(str);
		}

		StringTool.trimLeft=function(str){
			var i=0;
			i=0;
			var len=0;
			len=str.length;
			while(StringTool.isEmpty(str.charAt(i))&&i<len){
				i++;
			}
			if(i<len){
				return str.substr(i);
			}
			return "";
		}

		StringTool.trimRight=function(str){
			var i=0;
			i=str.length-1;
			while(StringTool.isEmpty(str.charAt(i))&&i>=0){
				i--;
			};
			var rst;
			rst=str.substring(0,i)
			if(i>=0){
				return str.substring(0,i+1);
			}
			return "";
		}

		StringTool.trimSide=function(str){
			var rst;
			rst=StringTool.trimLeft(str);
			rst=StringTool.trimRight(rst);
			return rst;
		}

		StringTool.isOkFileName=function(fileName){
			if(laya.debug.tools.StringTool.trimSide(fileName)=="")return false;
			var i=0,len=0;
			len=fileName.length;
			for(i=0;i<len;i++){
				if(StringTool.specialChars[fileName.charAt(i)])return false;
			}
			return true;
		}

		StringTool.trimButEmpty=function(str){
			return StringTool.trim(str,["\r","\n","\t"]);
		}

		StringTool.removeEmptyStr=function(strArr){
			var i=0;
			i=strArr.length-1;
			var str;
			for(i=i;i>=0;i--){
				str=strArr[i];
				str=laya.debug.tools.StringTool.trimSide(str);
				if(StringTool.isEmpty(str)){
					strArr.splice(i,1);
					}else{
					strArr[i]=str;
				}
			}
			return strArr;
		}

		StringTool.ifNoAddToTail=function(str,sign){
			if(str.indexOf(sign)>=0){
				return str;
			}
			return str+sign;
		}

		StringTool.trimEmptyLine=function(str){
			var i=0;
			var len=0;
			var tLines;
			var tLine;
			tLines=str.split("\n");
			for(i=tLines.length-1;i>=0;i--){
				tLine=tLines[i];
				if(StringTool.isEmptyLine(tLine)){
					tLines.splice(i,1);
				}
			}
			return tLines.join("\n");
		}

		StringTool.isEmptyLine=function(str){
			str=laya.debug.tools.StringTool.trim(str);
			if(str=="")return true;
			return false;
		}

		StringTool.removeCommentLine=function(lines){
			var rst;
			rst=[];
			var i=0;
			var tLine;
			var adptLine;
			i=0;
			var len=0;
			var index=0;
			len=lines.length;
			while(i<len){
				adptLine=tLine=lines[i];
				index=tLine.indexOf("/**");
				if(index>=0){
					adptLine=tLine.substring(0,index-1);
					StringTool.addIfNotEmpty(rst,adptLine);
					while(i<len){
						tLine=lines[i];
						index=tLine.indexOf("*/");
						if(index>=0){
							adptLine=tLine.substring(index+2);
							StringTool.addIfNotEmpty(rst,adptLine);
							break ;
						}
						i++;
					}
					}else if(tLine.indexOf("//")>=0){
					if(laya.debug.tools.StringTool.trim(tLine).indexOf("//")==0){
						}else{
						StringTool.addIfNotEmpty(rst,adptLine);
					}
					}else{
					StringTool.addIfNotEmpty(rst,adptLine);
				}
				i++;
			}
			return rst;
		}

		StringTool.addIfNotEmpty=function(arr,str){
			if(!str)return;
			var tStr;
			tStr=StringTool.trim(str);
			if(tStr!=""){
				arr.push(str);
			}
		}

		StringTool.trimExt=function(str,vars){
			var rst;
			rst=StringTool.trim(str);
			var i=0;
			var len=0;
			len=vars.length;
			for(i=0;i<len;i++){
				rst=StringTool.getReplace(rst,vars[i],"");
			}
			return rst;
		}

		StringTool.getBetween=function(str,left,right,ifMax){
			(ifMax===void 0)&& (ifMax=false);
			if(!str)return "";
			if(!left)return "";
			if(!right)return "";
			var lId=0;
			var rId=0;
			lId=str.indexOf(left);
			if(lId<0)return"";
			if(ifMax){
				rId=str.lastIndexOf(right);
				if(rId<lId)return "";
				}else{
				rId=str.indexOf(right,lId);
			}
			if(rId<0)return "";
			return str.substring(lId+left.length,rId);
		}

		StringTool.getSplitLine=function(line,split){
			(split===void 0)&& (split=" ");
			return line.split(split);
		}

		StringTool.getLeft=function(str,sign){
			var i=0;
			i=str.indexOf(sign);
			return str.substr(0,i);
		}

		StringTool.getRight=function(str,sign){
			var i=0;
			i=str.indexOf(sign);
			return str.substr(i+1);
		}

		StringTool.delelteItem=function(arr){
			while (arr.length>0){
				if(arr[0]==""){
					arr.shift();
					}else{
					break ;
				}
			}
		}

		StringTool.getWords=function(line){
			var rst=StringTool.getSplitLine(line);
			StringTool.delelteItem(rst);
			return rst;
		}

		StringTool.getLinesI=function(startLine,endLine,lines){
			var i=0;
			var rst=[];
			for(i=startLine;i<=endLine;i++){
				rst.push(lines[i]);
			}
			return rst;
		}

		StringTool.structfy=function(str,inWidth,removeEmpty){
			(inWidth===void 0)&& (inWidth=4);
			(removeEmpty===void 0)&& (removeEmpty=true);
			if(removeEmpty){
				str=laya.debug.tools.StringTool.trimEmptyLine(str);
			};
			var lines;
			var tIn=0;
			tIn=0;
			var tInStr;
			tInStr=StringTool.getEmptyStr(0);
			lines=str.split("\n");
			var i=0;
			var len=0;
			var tLineStr;
			len=lines.length;
			for(i=0;i<len;i++){
				tLineStr=lines[i];
				tLineStr=laya.debug.tools.StringTool.trimLeft(tLineStr);
				tLineStr=laya.debug.tools.StringTool.trimRight(tLineStr);
				tIn+=StringTool.getPariCount(tLineStr);
				if(tLineStr.indexOf("}")>=0){
					tInStr=StringTool.getEmptyStr(tIn*inWidth);
				}
				tLineStr=tInStr+tLineStr;
				lines[i]=tLineStr;
				tInStr=StringTool.getEmptyStr(tIn*inWidth);
			}
			return lines.join("\n");
		}

		StringTool.getEmptyStr=function(width){
			if(!StringTool.emptyDic.hasOwnProperty(width)){
				var i=0;
				var len=0;
				len=width;
				var rst;
				rst="";
				for(i=0;i<len;i++){
					rst+=" ";
				}
				StringTool.emptyDic[width]=rst;
			}
			return StringTool.emptyDic[width];
		}

		StringTool.getPariCount=function(str,inChar,outChar){
			(inChar===void 0)&& (inChar="{");
			(outChar===void 0)&& (outChar="}");
			var varDic;
			varDic={};
			varDic[inChar]=1;
			varDic[outChar]=-1;
			var i=0;
			var len=0;
			var tChar;
			len=str.length;
			var rst=0;
			rst=0;
			for(i=0;i<len;i++){
				tChar=str.charAt(i);
				if(varDic.hasOwnProperty(tChar)){
					rst+=varDic[tChar];
				}
			}
			return rst;
		}

		StringTool.readInt=function(str,startI){
			(startI===void 0)&& (startI=0);
			var rst=NaN;
			rst=0;
			var tNum=0;
			var tC;
			var i=0;
			var isBegin=false;
			isBegin=false;
			var len=0;
			len=str.length;
			for(i=startI;i<len;i++){
				tC=str.charAt(i);
				if(Number(tC)>0||tC=="0"){
					rst=10*rst+Number(tC);
					if(rst>0)isBegin=true;
					}else{
					if(isBegin)return rst;
				}
			}
			return rst;
		}

		StringTool.getReplace=function(str,oStr,nStr){
			if(!str)return "";
			var rst;
			rst=str.replace(new RegExp(oStr,"g"),nStr);
			return rst;
		}

		StringTool.getWordCount=function(str,findWord){
			var rg=new RegExp(findWord,"g")
			return str.match(rg).length;
		}

		StringTool.getResolvePath=function(path,basePath){
			if(StringTool.isAbsPath(path)){
				return path;
			};
			var tSign;
			tSign="\\";
			if(basePath.indexOf("/")>=0){
				tSign="/";
			}
			if(basePath.charAt(basePath.length-1)==tSign){
				basePath=basePath.substr(0,basePath.length-1);
			};
			var parentSign;
			parentSign=".."+tSign;
			var tISign;
			tISign="."+tSign;
			var pCount=0;
			pCount=StringTool.getWordCount(path,parentSign);
			path=laya.debug.tools.StringTool.getReplace(path,parentSign,"");
			path=laya.debug.tools.StringTool.getReplace(path,tISign,"");
			var i=0;
			var len=0;
			len=pCount;
			var iPos=0;
			for(i=0;i<len;i++){
				basePath=StringTool.removeLastSign(path,tSign);
			}
			return basePath+tSign+path;
		}

		StringTool.isAbsPath=function(path){
			if(path.indexOf(":")>=0)return true;
			return false;
		}

		StringTool.removeLastSign=function(str,sign){
			var iPos=0;
			iPos=str.lastIndexOf(sign);
			str=str.substring(0,iPos);
			return str;
		}

		StringTool.getParamArr=function(str){
			var paramStr;
			paramStr=laya.debug.tools.StringTool.getBetween(str,"(",")",true);
			if(StringTool.trim(paramStr).length<1)return [];
			return paramStr.split(",");
		}

		StringTool.copyStr=function(str){
			return str.substring();
		}

		StringTool.ArrayToString=function(arr){
			var rst;
			rst="[{items}]".replace(new RegExp("\\{items\\}","g"),StringTool.getArrayItems(arr));
			return rst;
		}

		StringTool.getArrayItems=function(arr){
			var rst;
			if(arr.length<1)return "";
			rst=StringTool.parseItem(arr[0]);
			var i=0;
			var len=0;
			len=arr.length;
			for(i=1;i<len;i++){
				rst+=","+StringTool.parseItem(arr[i]);
			}
			return rst;
		}

		StringTool.parseItem=function(item){
			var rst;
			rst="\""+item+"\"";
			return "";
		}

		StringTool.emptyDic={};
		__static(StringTool,
		['emptyStrDic',function(){return this.emptyStrDic={
				" ":true,
				"\r":true,
				"\n":true,
				"\t":true
		};},'specialChars',function(){return this.specialChars={"*":true,"&":true,"%":true,"#":true,"?":true};}

		]);
		return StringTool;
	})()


	/**
	*全局时间速率控制类
	*@author ww
	*/
	//class laya.debug.tools.TimerControlTool
	var TimerControlTool=(function(){
		function TimerControlTool(){}
		__class(TimerControlTool,'laya.debug.tools.TimerControlTool');
		TimerControlTool.now=function(){
			if (TimerControlTool._timeRate !=1)return TimerControlTool.getRatedNow();
			return Date.now();
		}

		TimerControlTool.getRatedNow=function(){
			var dTime=NaN;
			dTime=TimerControlTool.getNow()-TimerControlTool._startTime;
			return dTime *TimerControlTool._timeRate+TimerControlTool._startTime;
		}

		TimerControlTool.getNow=function(){
			return Date.now();
		}

		TimerControlTool.setTimeRate=function(rate){
			if (TimerControlTool._browerNow==null)TimerControlTool._browerNow=Browser["now"];
			TimerControlTool._startTime=TimerControlTool.getNow();
			TimerControlTool._timeRate=rate;
			if (rate !=1){
				Browser["now"]=TimerControlTool.now;
				}else{
				if(TimerControlTool._browerNow!=null)
					Browser["now"]=TimerControlTool._browerNow;
			}
		}

		TimerControlTool.recoverRate=function(){
			TimerControlTool.setTimeRate(1);
		}

		TimerControlTool._startTime=NaN
		TimerControlTool._timeRate=1;
		TimerControlTool._browerNow=null
		return TimerControlTool;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.TimeTool
	var TimeTool=(function(){
		function TimeTool(){}
		__class(TimeTool,'laya.debug.tools.TimeTool');
		TimeTool.getTime=function(sign,update){
			(update===void 0)&& (update=true);
			if (!TimeTool.timeDic[sign]){
				TimeTool.timeDic[sign]=0;
			};
			var tTime=NaN;
			tTime=Browser.now();
			var rst=NaN;
			rst=tTime-TimeTool.timeDic[sign];
			TimeTool.timeDic[sign]=tTime;
			return rst;
		}

		TimeTool.timeDic={};
		return TimeTool;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-25 上午10:48:54
	*/
	//class laya.debug.tools.TraceTool
	var TraceTool=(function(){
		function TraceTool(){}
		__class(TraceTool,'laya.debug.tools.TraceTool');
		TraceTool.closeAllLog=function(){
			var logFun;
			logFun=TraceTool.emptyLog;
			Browser.window.console.log=logFun;
		}

		TraceTool.emptyLog=function(){}
		TraceTool.traceObj=function(obj){
			TraceTool.tempArr.length=0;
			var key;
			for(key in obj){
				TraceTool.tempArr.push(key+":"+obj[key]);
			};
			var rst;
			rst=TraceTool.tempArr.join("\n");
			console.log(rst);
			return rst;
		}

		TraceTool.traceObjR=function(obj){
			TraceTool.tempArr.length=0;
			var key;
			for(key in obj){
				TraceTool.tempArr.push(obj[key]+":"+key);
			};
			var rst;
			rst=TraceTool.tempArr.join("\n");
			console.log(rst);
			return rst;
		}

		TraceTool.traceSize=function(tar){
			DebugTool.dTrace("Size: x:"+tar.x+" y:"+tar.y+" w:"+tar.width+" h:"+tar.height+" scaleX:"+tar.scaleX+" scaleY:"+tar.scaleY);
		}

		TraceTool.traceSplit=function(msg){
			console.log("---------------------"+msg+"---------------------------");
		}

		TraceTool.group=function(gName){
			/*__JS__ */console.group(gName);;
		}

		TraceTool.groupEnd=function(){
			/*__JS__ */console.groupEnd();;
		}

		TraceTool.getCallStack=function(life,s){
			(life===void 0)&& (life=1);
			(s===void 0)&& (s=1);
			var caller;
			caller=TraceTool.getCallStack;
			caller=caller.caller.caller;
			var msg;
			msg="";
			while(caller&&life>0){
				if(s<=0){
					msg+=caller+"<-";
					life--;
					}else{
				}
				caller=caller.caller;
				s--;
			}
			return msg;
		}

		TraceTool.getCallLoc=function(index){
			(index===void 0)&& (index=2);
			var loc;
			try {
				TraceTool.Erroer.i++;
				}catch (e){
				var arr;
				arr=e.stack.replace(/Error\n/).split(/\n/);
				if (arr[index]){
					loc=arr[index].replace(/^\s+|\s+$/,"");
					}else{
					loc="unknow";
				}
			}
			return loc;
		}

		TraceTool.traceCallStack=function(){
			var loc;
			try {
				TraceTool.Erroer.i++;
				}catch (e){
				loc=e.stack;
			}
			console.log(loc);
			return loc;
		}

		TraceTool.getPlaceHolder=function(len){
			if(!TraceTool.holderDic.hasOwnProperty(len)){
				var rst;
				rst="";
				var i=0;
				for(i=0;i<len;i++){
					rst+="-";
				}
				TraceTool.holderDic[len]=rst;
			}
			return TraceTool.holderDic[len];
		}

		TraceTool.traceTree=function(tar,depth,isFirst){
			(depth===void 0)&& (depth=0);
			(isFirst===void 0)&& (isFirst=true);
			if(isFirst){
				console.log("traceTree");
			}
			if(!tar)return;
			var i=0;
			var len=0;
			if(tar.numChildren<1){
				console.log(tar);
				return;
			}
			TraceTool.group(tar);
			len=tar.numChildren;
			depth++;
			for(i=0;i<len;i++){
				TraceTool.traceTree(tar.getChildAt(i),depth,false);
			}
			TraceTool.groupEnd();
		}

		TraceTool.getClassName=function(tar){
			return tar["constructor"].name;
		}

		TraceTool.traceSpriteInfo=function(tar,showBounds,showSize,showTree){
			(showBounds===void 0)&& (showBounds=true);
			(showSize===void 0)&& (showSize=true);
			(showTree===void 0)&& (showTree=true);
			if(!((tar instanceof laya.display.Sprite ))){
				console.log("not Sprite");
				return;
			};
			if(!tar){
				console.log("null Sprite");
				return;
			};
			TraceTool.traceSplit("traceSpriteInfo");
			DebugTool.dTrace(laya.debug.tools.TraceTool.getClassName(tar)+":"+tar.name);
			if(showTree){
				TraceTool.traceTree(tar);
				}else{
				console.log(tar);
			}
			if(showSize){
				TraceTool.traceSize(tar);
			}
			if(showBounds){
				console.log("bounds:"+tar.getBounds());
			}
		}

		TraceTool.tempArr=[];
		TraceTool.Erroer=null;
		TraceTool.holderDic={};
		return TraceTool;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.UVTools
	var UVTools=(function(){
		function UVTools(){}
		__class(UVTools,'laya.debug.tools.UVTools');
		UVTools.getUVByRec=function(x,y,width,height){
			return [x,y,x+width,y,x+width,y+height,x,y+height];
		}

		UVTools.getRecFromUV=function(uv){
			var rst;
			rst=new Rectangle(uv[0],uv[1],uv[2]-uv[0],uv[5]-uv[1]);
			return rst;
		}

		UVTools.isUVRight=function(uv){
			if(uv[0]!=uv[6])return false;
			if(uv[1]!=uv[3])return false;
			if(uv[2]!=uv[4])return false;
			if(uv[5]!=uv[7])return false;
			return true;
		}

		UVTools.getTextureRec=function(texture){
			var rst;
			rst=UVTools.getRecFromUV(texture.uv);
			rst.x*=texture.bitmap.width;
			rst.y*=texture.bitmap.height;
			rst.width*=texture.bitmap.width;
			rst.height*=texture.bitmap.height;
			return rst;
		}

		return UVTools;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-30 下午5:12:53
	*/
	//class laya.debug.tools.ValueChanger
	var ValueChanger=(function(){
		function ValueChanger(){
			this.target=null;
			this.key=null;
			this._tValue=NaN;
			this.preValue=0;
		}

		__class(ValueChanger,'laya.debug.tools.ValueChanger');
		var __proto=ValueChanger.prototype;
		__proto.record=function(){
			this.preValue=this.value;
		}

		__proto.showValueByAdd=function(addValue){
			this.value=this.preValue+addValue;
		}

		__proto.showValueByScale=function(scale){
			this.value=this.preValue *scale;
		}

		__proto.recover=function(){
			this.value=this.preValue;
		}

		__proto.dispose=function(){
			this.target=null;
		}

		__getset(0,__proto,'value',function(){
			if(this.target){
				this._tValue=this.target[this.key];
			}
			return this._tValue;
			},function(nValue){
			this._tValue=nValue;
			if(this.target){
				this.target[this.key]=nValue;
			}
		});

		__getset(0,__proto,'dValue',function(){
			return this.value-this.preValue;
		});

		__getset(0,__proto,'scaleValue',function(){
			return this.value/this.preValue;
		});

		ValueChanger.create=function(target,key){
			var rst;
			rst=new ValueChanger();
			rst.target=target;
			rst.key=key;
			return rst;
		}

		return ValueChanger;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.VisibleAnalyser
	var VisibleAnalyser=(function(){
		function VisibleAnalyser(){}
		__class(VisibleAnalyser,'laya.debug.tools.VisibleAnalyser');
		VisibleAnalyser.analyseTarget=function(node){
			var isInstage=false;
			isInstage=node.displayedInStage;
			var gRec;
			gRec=NodeUtils.getGRec(node);
			var stageRec=new Rectangle();
			stageRec.setTo(0,0,Laya.stage.width,Laya.stage.height);
			var isInVisibleRec=false;
			var visibleRec;
			visibleRec=stageRec.intersection(gRec);
			if (visibleRec.width > 0 && visibleRec.height > 0){
				isInVisibleRec=true;
			}
			else{
				isInVisibleRec=false;
			};
			var gAlpha=NaN;
			gAlpha=NodeUtils.getGAlpha(node);
			var gVisible=false;
			gVisible=NodeUtils.getGVisible(node);
			var msg;
			msg="";
			msg+="isInstage:"+isInstage+"\n";
			msg+="isInVisibleRec:"+isInVisibleRec+"\n";
			msg+="gVisible:"+gVisible+"\n";
			msg+="gAlpha:"+gAlpha+"\n";
			if (isInstage && isInVisibleRec && gVisible && gAlpha > 0){
				if (Render.isWebGL){
					VisibleAnalyser.anlyseRecVisible(node);
					}else{
					SpriteRenderForVisibleAnalyse.I.analyseNode(node);
				}
				msg+="coverRate:"+VisibleAnalyser.coverRate+"\n";
				if (VisibleAnalyser._coverList.length > 0){
					Laya.timer.once(1000,null,VisibleAnalyser.showListLater);
				}
			}
			console.log(msg);
			OutPutView.I.showTxt(msg);
		}

		VisibleAnalyser.showListLater=function(){
			NodeListPanelView.I.showList(VisibleAnalyser._coverList);
		}

		VisibleAnalyser.isCoverByBrother=function(node){
			var parent=node.parent;
			if (!parent)
				return;
			var _childs;
			_childs=parent._childs;
			var index=0;
			index=_childs.indexOf(node);
			if (index < 0)
				return;
			var i=0,len=0;
			var canvas;
			var rec;
			rec=parent.getSelfBounds();
			if (rec.width <=0 || rec.height <=0)
				return;
		}

		VisibleAnalyser.anlyseRecVisible=function(node){
			VisibleAnalyser.isNodeWalked=false;
			VisibleAnalyser._analyseTarget=node;
			if (!VisibleAnalyser.mainCanvas)
				VisibleAnalyser.mainCanvas=CanvasTools.createCanvas(Laya.stage.width,Laya.stage.height);
			CanvasTools.clearCanvas(VisibleAnalyser.mainCanvas);
			VisibleAnalyser.tColor=1;
			VisibleAnalyser.resetCoverList();
			WalkTools.walkTargetEX(Laya.stage,VisibleAnalyser.recVisibleWalker,null,VisibleAnalyser.filterFun);
			if (!VisibleAnalyser.isTarRecOK){
				VisibleAnalyser.coverRate=0;
			}
			else{
				VisibleAnalyser.coverRate=CanvasTools.getDifferRate(VisibleAnalyser.preImageData,VisibleAnalyser.tarImageData);
			}
			console.log("coverRate:",VisibleAnalyser.coverRate);
		}

		VisibleAnalyser.getRecArea=function(rec){
			return rec.width *rec.height;
		}

		VisibleAnalyser.addCoverNode=function(node,coverRate){
			var data;
			data={};
			data.path=node;
			data.label=ClassTool.getNodeClassAndName(node)+":"+coverRate;
			data.coverRate=coverRate;
			VisibleAnalyser._coverList.push(data);
			console.log("coverByNode:",node,coverRate);
		}

		VisibleAnalyser.resetCoverList=function(){
			VisibleAnalyser._coverList.length=0;
		}

		VisibleAnalyser.recVisibleWalker=function(node){
			if (node==VisibleAnalyser._analyseTarget){
				VisibleAnalyser.isNodeWalked=true;
				VisibleAnalyser.tarRec.copyFrom(NodeUtils.getGRec(node));
				console.log("tarRec:",VisibleAnalyser.tarRec.toString());
				if (VisibleAnalyser.tarRec.width > 0 && VisibleAnalyser.tarRec.height > 0){
					VisibleAnalyser.isTarRecOK=true;
					VisibleAnalyser.tColor++;
					CanvasTools.fillCanvasRec(VisibleAnalyser.mainCanvas,VisibleAnalyser.tarRec,ColorTool.toHexColor(VisibleAnalyser.tColor));
					VisibleAnalyser.preImageData=CanvasTools.getImageDataFromCanvasByRec(VisibleAnalyser.mainCanvas,VisibleAnalyser.tarRec);
					VisibleAnalyser.tarImageData=CanvasTools.getImageDataFromCanvasByRec(VisibleAnalyser.mainCanvas,VisibleAnalyser.tarRec);
				}
				else{
					console.log("tarRec Not OK:",VisibleAnalyser.tarRec);
				}
			}
			else{
				if (VisibleAnalyser.isTarRecOK){
					var tRec;
					tRec=NodeUtils.getGRec(node);
					VisibleAnalyser.interRec=VisibleAnalyser.tarRec.intersection(tRec,VisibleAnalyser.interRec);
					if (VisibleAnalyser.interRec && VisibleAnalyser.interRec.width > 0 && VisibleAnalyser.interRec.height > 0){
						VisibleAnalyser.tColor++;
						CanvasTools.fillCanvasRec(VisibleAnalyser.mainCanvas,tRec,ColorTool.toHexColor(VisibleAnalyser.tColor));
						VisibleAnalyser.tImageData=CanvasTools.getImageDataFromCanvasByRec(VisibleAnalyser.mainCanvas,VisibleAnalyser.tarRec);
						var dRate=NaN;
						dRate=CanvasTools.getDifferRate(VisibleAnalyser.preImageData,VisibleAnalyser.tImageData);
						VisibleAnalyser.preImageData=VisibleAnalyser.tImageData;
						VisibleAnalyser.addCoverNode(node,dRate);
					}
				}
			}
		}

		VisibleAnalyser.filterFun=function(node){
			if (node.visible==false)
				return false;
			if (node.alpha < 0)
				return false;
			if (DebugInfoLayer.I.isDebugItem(node))return false;
			return true;
		}

		VisibleAnalyser.isNodeWalked=false;
		VisibleAnalyser._analyseTarget=null
		VisibleAnalyser.isTarRecOK=false;
		VisibleAnalyser.mainCanvas=null
		VisibleAnalyser.preImageData=null
		VisibleAnalyser.tImageData=null
		VisibleAnalyser.tarImageData=null
		VisibleAnalyser.coverRate=NaN
		VisibleAnalyser.tColor=0;
		VisibleAnalyser._coverList=[];
		__static(VisibleAnalyser,
		['tarRec',function(){return this.tarRec=new Rectangle();},'interRec',function(){return this.interRec=new Rectangle();}
		]);
		return VisibleAnalyser;
	})()


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-24 下午6:15:01
	*/
	//class laya.debug.tools.WalkTools
	var WalkTools=(function(){
		function WalkTools(){}
		__class(WalkTools,'laya.debug.tools.WalkTools');
		WalkTools.walkTarget=function(target,fun,_this){
			fun.apply(_this,[target]);
			var i=0;
			var len=0;
			var tChild;
			len=target.numChildren;
			for(i=0;i<len;i++){
				tChild=target.getChildAt(i);
				WalkTools.walkTarget(tChild,fun,tChild);
			}
		}

		WalkTools.walkTargetEX=function(target,fun,_this,filterFun){
			if (filterFun !=null && !filterFun(target))return;
			fun.apply(_this,[target]);
			var i=0;
			var len=0;
			var tChild;
			var childs;
			childs=target._childs;
			len=childs.length;
			for(i=0;i<len;i++){
				tChild=childs[i];
				WalkTools.walkTarget(tChild,fun,tChild);
			}
		}

		WalkTools.walkChildren=function(target,fun,_this){
			if(!target||target.numChildren<1)return;
			WalkTools.walkArr(DisControlTool.getAllChild(target),fun,_this);
		}

		WalkTools.walkArr=function(arr,fun,_this){
			if(!arr)return;
			var i=0;
			var len=0;
			len=arr.length;
			for(i=0;i<len;i++){
				fun.apply(_this,[arr[i],i]);
			}
		}

		return WalkTools;
	})()


	/**
	*本类用于监控对象值变化
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-23 下午4:18:27
	*/
	//class laya.debug.tools.Watcher
	var Watcher=(function(){
		function Watcher(){}
		__class(Watcher,'laya.debug.tools.Watcher');
		Watcher.watch=function(obj,name,funs){
			VarHook.hookVar(obj,name,funs);
		}

		Watcher.traceChange=function(obj,name,sign){
			(sign===void 0)&& (sign="var changed:");
			VarHook.hookVar(obj,name,[Watcher.getTraceValueFun(name),VarHook.getLocFun(sign)]);
		}

		Watcher.debugChange=function(obj,name){
			VarHook.hookVar(obj,name,[VarHook.getLocFun("debug loc"),FunHook.debugHere]);
		}

		Watcher.differChange=function(obj,name,sign,msg){
			(msg===void 0)&& (msg="");
			VarHook.hookVar(obj,name,[Watcher.getDifferFun(obj,name,sign,msg)]);
		}

		Watcher.getDifferFun=function(obj,name,sign,msg){
			(msg===void 0)&& (msg="");
			var rst;
			rst=function (){
				DifferTool.differ(sign,obj[name],msg);
			}
			return rst;
		}

		Watcher.traceValue=function(value){
			console.log("value:",value);
		}

		Watcher.getTraceValueFun=function(name){
			var rst;
			rst=function (value){
				console.log("set "+name+" :",value);
			}
			return rst;
		}

		return Watcher;
	})()


	/**
	*XML转Object类
	*@author ww
	*
	*/
	//class laya.debug.tools.XML2Object
	var XML2Object=(function(){
		function XML2Object(){};
		__class(XML2Object,'laya.debug.tools.XML2Object');
		__getset(1,XML2Object,'arrays',function(){
			if(!XML2Object._arrays){
				XML2Object._arrays=[];
			}
			return XML2Object._arrays;
			},function(a){
			XML2Object._arrays=a;
		});

		XML2Object.parse=function(node,isFirst){
			(isFirst===void 0)&& (isFirst=true);
			var obj={};
			if(isFirst)
				obj.Name=node.localName;
			var numOfChilds=node.children.length;
			var childs=[];
			var children={};
			obj.c=children;
			obj.cList=childs;
			for(var i=0;i<numOfChilds;i++){
				var childNode=node.children[i];
				var childNodeName=childNode.localName;
				var value;
				var numOfAttributes
				value=XML2Object.parse(childNode,true);
				childs.push(value);
				if(children[childNodeName]){
					if(XML2Object.getTypeof(children[childNodeName])=="array"){
						children[childNodeName].push(value);
						}else {
						children[childNodeName]=[children[childNodeName],value];
					}
					}else if(XML2Object.isArray(childNodeName)){
					children[childNodeName]=[value];
					}else {
					children[childNodeName]=value;
				}
			}
			numOfAttributes=0;
			if(node.attributes){
				numOfAttributes=node.attributes.length;
				var prop={};
				obj.p=prop;
				for(i=0;i<numOfAttributes;i++){
					prop[node.attributes[i].name.toString()]=String(node.attributes[i].nodeValue);
				}
			}
			if(numOfChilds==0){
				if(numOfAttributes==0){
					obj="";
				}else {}
			}
			return obj;
		}

		XML2Object.getArr=function(v){
			if(!v)return [];
			if(XML2Object.getTypeof(v)=="array")return v;
			return [v];
		}

		XML2Object.isArray=function(nodeName){
			var numOfArrays=XML2Object._arrays ? XML2Object._arrays.length :0;
			for(var i=0;i<numOfArrays;i++){
				if(nodeName==XML2Object._arrays[i]){
					return true;
				}
			}
			return false;
		}

		XML2Object.getTypeof=function(o){
			if(typeof(o)=="object"){
				if(o.length==null){
					return "object";
					}else if(typeof(o.length)=="number"){
					return "array";
					}else {
					return "object";
				}
				}else {
				return typeof(o);
			}
		}

		XML2Object._arrays=null
		return XML2Object;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.menus.NodeMenu
	var NodeMenu=(function(){
		function NodeMenu(){
			this._tar=null;
			this._menu=null;
			this._shareBtns=[
			"信息面板",
			"边框",
			"进入节点",
			"树定位",
			"Enable链",
			"Size链",
			"节点工具",
			"可见分析",
			"输出到控制台"];
			this._menuItems=["隐藏节点"];
			this._menuHide=null;
			this._menuItemsHide=["显示节点"];
			this._menu1=null;
			this._menuItems1=["输出到控制台"];
		}

		__class(NodeMenu,'laya.debug.view.nodeInfo.menus.NodeMenu');
		var __proto=NodeMenu.prototype;
		__proto.showNodeMenu=function(node){
			if (!node._style){
				DebugTool.log("该节点已不存在，请刷新列表");
				return;
			}
			this._tar=node;
			if (!this._menu){
				this._menuItems=this._menuItems.concat(this._shareBtns);
				this._menu=ContextMenu.createMenuByArray(this._menuItems);
				this._menu.on(/*laya.events.Event.SELECT*/"select",this,this.onEmunSelect);
				this._menuItemsHide=this._menuItemsHide.concat(this._shareBtns);
				this._menuHide=ContextMenu.createMenuByArray(this._menuItemsHide);
				this._menuHide.on(/*laya.events.Event.SELECT*/"select",this,this.onEmunSelect);
			}
			if (node.visible){
				this._menu.show();
			}
			else{
				this._menuHide.show();
			}
		}

		__proto.nodeDoubleClick=function(node){
			NodeToolView.I.showByNode(node);
		}

		__proto.setNodeListDoubleClickAction=function(list){
			if (Browser.onMobile)return;
			list.on(/*laya.events.Event.DOUBLE_CLICK*/"doubleclick",this,this.onListDoubleClick,[list]);
		}

		__proto.onListDoubleClick=function(list){
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				laya.debug.view.nodeInfo.menus.NodeMenu.I.nodeDoubleClick(tarNode);
			}
		}

		__proto.setNodeListAction=function(list){
			list.on(DebugTool.getMenuShowEvent(),this,this.onListRightClick,[list]);
		}

		//setNodeListDoubleClickAction(list);
		__proto.onListRightClick=function(list){
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				laya.debug.view.nodeInfo.menus.NodeMenu.I.objRightClick(tarNode);
			}
		}

		__proto.objRightClick=function(obj){
			if ((obj instanceof laya.display.Sprite )){
				laya.debug.view.nodeInfo.menus.NodeMenu.I.showNodeMenu(obj);
			}
			else if ((typeof obj=='object')){
				laya.debug.view.nodeInfo.menus.NodeMenu.I.showObjectMenu(obj);
			}
		}

		__proto.showObjectMenu=function(obj){
			this._tar=obj;
			if (!this._menu1){
				this._menu1=ContextMenu.createMenuByArray(this._menuItems1);
				this._menu1.on(/*laya.events.Event.SELECT*/"select",this,this.onEmunSelect);
			}
			this._menu1.show();
		}

		__proto.onEmunSelect=function(e){
			var data=(e.target).data;
			if ((typeof data=='string')){
				var key;
				key=data;
				switch (key){
					case "信息面板":
						ObjectInfoView.showObject(this._tar);
						break ;
					case "边框":
						DebugTool.showDisBound(this._tar);
						break ;
					case "输出到控制台":
						console.log(this._tar);
						break ;
					case "树节点":
						ToolPanel.I.showNodeTree(this._tar);
						break ;
					case "进入节点":
						ToolPanel.I.showNodeTree(this._tar);
						break ;
					case "树定位":
						ToolPanel.I.showSelectInStage(this._tar);
						break ;
					case "Enable链":
						OutPutView.I.dTrace(DebugTool.traceDisMouseEnable(this._tar));
						SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
						break ;
					case "Size链":
						OutPutView.I.dTrace(DebugTool.traceDisSizeChain(this._tar));
						SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
						break ;
					case "节点工具":
						NodeToolView.I.showByNode(this._tar);
						break ;
					case "显示节点":
						this._tar.visible=true;
						break ;
					case "隐藏节点":
						this._tar.visible=false;
						break ;
					case "可见分析":
						if (this._tar){
							VisibleAnalyser.analyseTarget(this._tar);
						}
						break ;
					}
			}
		}

		__getset(1,NodeMenu,'I',function(){
			if (!NodeMenu._I)
				NodeMenu._I=new NodeMenu();
			return NodeMenu._I;
		});

		NodeMenu._I=null
		return NodeMenu;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.NodeConsts
	var NodeConsts=(function(){
		function NodeConsts(){}
		__class(NodeConsts,'laya.debug.view.nodeInfo.NodeConsts');
		NodeConsts.defaultFitlerStr="x,y,width,height,scaleX,scaleY,alpha,renderCost";
		NodeConsts.RenderCostMaxTime=3000;
		return NodeConsts;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.NodeUtils
	var NodeUtils=(function(){
		function NodeUtils(){}
		__class(NodeUtils,'laya.debug.view.nodeInfo.NodeUtils');
		NodeUtils.getFilterdTree=function(sprite,keys){
			if (!keys)
				keys=NodeUtils.defaultKeys;
			var me;
			me={};
			var key;
			var i=0,len=0;
			len=keys.length;
			for (i=0;i < len;i++){
				key=keys[i];
				me[key]=sprite[key];
			};
			var cList;
			var tChild;
			cList=sprite._childs;
			len=cList.length;
			var mClist;
			mClist=[];
			for (i=0;i < len;i++){
				tChild=cList[i];
				mClist.push(NodeUtils.getFilterdTree(tChild,keys));
			}
			me.childs=mClist;
			return me;
		}

		NodeUtils.getPropertyDesO=function(tValue,keys){
			if (!keys)
				keys=NodeUtils.defaultKeys;
			var rst={};
			if ((typeof tValue=='object')){
				rst.label=""+ClassTool.getNodeClassAndName(tValue);
			}
			else{
				rst.label=""+tValue;
			}
			rst.type="";
			rst.path=tValue;
			rst.childs=[];
			rst.isDirectory=false;
			var key;
			var i=0,len=0;
			var tChild;
			if ((tValue instanceof laya.display.Node )){
				rst.des=ClassTool.getNodeClassAndName(tValue);
				rst.isDirectory=true;
				len=keys.length;
				for (i=0;i < len;i++){
					key=keys[i];
					tChild=NodeUtils.getPropertyDesO(tValue[key],keys);
					if (tValue.hasOwnProperty(key)){
						tChild.label=""+key+":"+tChild.des;
					}
					else{
						tChild.label=""+key+":"+ObjectInfoView.getNodeValue(tValue,key);
					}
					rst.childs.push(tChild);
				}
				key="_childs";
				tChild=NodeUtils.getPropertyDesO(tValue[key],keys);
				tChild.label=""+key+":"+tChild.des;
				tChild.isChilds=true;
				rst.childs.push(tChild);
			}
			else if ((tValue instanceof Array)){
				rst.des="Array["+(tValue).length+"]";
				rst.isDirectory=true;
				var tList;
				tList=tValue;
				len=tList.length;
				for (i=0;i < len;i++){
					tChild=NodeUtils.getPropertyDesO(tList[i],keys);
					tChild.label=""+i+":"+tChild.des;
					rst.childs.push(tChild);
				}
			}
			else if ((typeof tValue=='object')){
				rst.des=ClassTool.getNodeClassAndName(tValue);
				rst.isDirectory=true;
				for (key in tValue){
					tChild=NodeUtils.getPropertyDesO(tValue[key],keys);
					tChild.label=""+key+":"+tChild.des;
					rst.childs.push(tChild);
				}
			}
			else{
				rst.des=""+tValue;
			}
			rst.hasChild=rst.childs.length > 0;
			return rst;
		}

		NodeUtils.adptShowKeys=function(keys){
			var i=0,len=0;
			len=keys.length;
			for (i=len-1;i >=0;i--){
				keys[i]=StringTool.trimSide(keys[i]);
				if (keys[i].length < 1){
					keys.splice(i,1);
				}
			}
			return keys;
		}

		NodeUtils.getNodeTreeData=function(sprite,keys){
			NodeUtils.adptShowKeys(keys);
			var treeO;
			treeO=NodeUtils.getPropertyDesO(sprite,keys);
			var treeArr;
			treeArr=[];
			NodeUtils.getTreeArr(treeO,treeArr);
			return treeArr;
		}

		NodeUtils.getTreeArr=function(treeO,arr,add){
			(add===void 0)&& (add=true);
			if (add)
				arr.push(treeO);
			var tArr=treeO.childs;
			var i=0,len=tArr.length;
			for (i=0;i < len;i++){
				if (!add){
					tArr[i].nodeParent=null;
				}
				else{
					tArr[i].nodeParent=treeO;
				}
				if (tArr[i].isDirectory){
					NodeUtils.getTreeArr(tArr[i],arr);
				}
				else{
					arr.push(tArr[i]);
				}
			}
		}

		NodeUtils.traceStage=function(){
			console.log(NodeUtils.getFilterdTree(Laya.stage,null));
			console.log("treeArr:",NodeUtils.getNodeTreeData(Laya.stage,null));
		}

		NodeUtils.getNodeCount=function(node){
			var rst=0;
			rst=1;
			var i=0,len=0;
			var cList;
			cList=node._childs;
			len=cList.length;
			for (i=0;i < len;i++){
				rst+=NodeUtils.getNodeCount(cList[i]);
			}
			return rst;
		}

		NodeUtils.getGVisible=function(node){
			while (node){
				if (!node.visible)return false;
				node=node.parent;
			}
			return true;
		}

		NodeUtils.getGAlpha=function(node){
			var rst=NaN;
			rst=1;
			while (node){
				rst *=node.alpha;
				node=node.parent;
			}
			return rst;
		}

		NodeUtils.getGPos=function(node){
			var point;
			point=new Point();
			node.localToGlobal(point);
			return point;
		}

		NodeUtils.getGRec=function(node){
			var pointList;
			pointList=node._getBoundPointsM(true);
			if (!pointList || pointList.length < 1)
				return Rectangle.TEMP.setTo(0,0,0,0);
			pointList=GrahamScan.pListToPointList(pointList,true);
			WalkTools.walkArr(pointList,node.localToGlobal,node);
			pointList=GrahamScan.pointListToPlist(pointList);
			var _disBoundRec;
			_disBoundRec=Rectangle._getWrapRec(pointList,_disBoundRec);
			return _disBoundRec;
		}

		NodeUtils.getGGraphicRec=function(node){
			var pointList;
			pointList=node.getGraphicBounds()._getBoundPoints();
			if (!pointList || pointList.length < 1)
				return Rectangle.TEMP.setTo(0,0,0,0);
			pointList=GrahamScan.pListToPointList(pointList,true);
			WalkTools.walkArr(pointList,node.localToGlobal,node);
			pointList=GrahamScan.pointListToPlist(pointList);
			var _disBoundRec;
			_disBoundRec=Rectangle._getWrapRec(pointList,_disBoundRec);
			return _disBoundRec;
		}

		NodeUtils.getNodeCmdCount=function(node){
			var rst=0;
			if (node.graphics){
				if (node.graphics.cmds){
					rst=node.graphics.cmds.length;
				}
				else{
					if (node.graphics._one){
						rst=1;
					}
					else{
						rst=0;
					}
				}
			}
			else{
				rst=0;
			}
			return rst;
		}

		NodeUtils.getNodeCmdTotalCount=function(node){
			var rst=0;
			var i=0,len=0;
			var cList;
			cList=node._childs;
			len=cList.length;
			rst=NodeUtils.getNodeCmdCount(node);
			for (i=0;i < len;i++){
				rst+=NodeUtils.getNodeCmdTotalCount(cList[i]);
			}
			return rst;
		}

		NodeUtils.getRenderNodeCount=function(node){
			if (node.cacheAs !="none")return 1;
			var rst=0;
			var i=0,len=0;
			var cList;
			cList=node._childs;
			len=cList.length;
			rst=1;
			for (i=0;i < len;i++){
				rst+=NodeUtils.getRenderNodeCount(cList[i]);
			}
			return rst;
		}

		NodeUtils.getReFreshRenderNodeCount=function(node){
			var rst=0;
			var i=0,len=0;
			var cList;
			cList=node._childs;
			len=cList.length;
			rst=1;
			for (i=0;i < len;i++){
				rst+=NodeUtils.getRenderNodeCount(cList[i]);
			}
			return rst;
		}

		NodeUtils.showCachedSpriteRecs=function(){
			NodeUtils.g=DebugInfoLayer.I.graphicLayer.graphics;
			NodeUtils.g.clear();
			WalkTools.walkTarget(Laya.stage,NodeUtils.drawCachedBounds,null);
		}

		NodeUtils.drawCachedBounds=function(sprite){
			if (sprite.cacheAs=="none")return;
			if (DebugInfoLayer.I.isDebugItem(sprite))return;
			var rec;
			rec=NodeUtils.getGRec(sprite);
			NodeUtils.g.drawRect(rec.x,rec.y,rec.width,rec.height,null,"#0000ff",2);
		}

		NodeUtils.g=null
		__static(NodeUtils,
		['defaultKeys',function(){return this.defaultKeys=["x","y","width","height"];}
		]);
		return NodeUtils;
	})()


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.StyleConsts
	var StyleConsts=(function(){
		function StyleConsts(){}
		__class(StyleConsts,'laya.debug.view.StyleConsts');
		StyleConsts.setViewScale=function(view){
			view.scaleX=view.scaleY=StyleConsts.PanelScale;
		}

		__static(StyleConsts,
		['PanelScale',function(){return this.PanelScale=Browser.onPC?1:Browser.pixelRatio;}
		]);
		return StyleConsts;
	})()


	/**
	*本类用于模块间消息传递
	*@author ww
	*/
	//class laya.debug.tools.Notice extends laya.events.EventDispatcher
	var Notice=(function(_super){
		function Notice(){
			Notice.__super.call(this);
		}

		__class(Notice,'laya.debug.tools.Notice',_super);
		Notice.notify=function(type,data){
			Notice.I.event(type,data);
		}

		Notice.listen=function(type,_scope,fun,args,cancelBefore){
			(cancelBefore===void 0)&& (cancelBefore=false);
			if(cancelBefore)Notice.cancel(type,_scope,fun);
			Notice.I.on(type,_scope,fun,args);
		}

		Notice.cancel=function(type,_scope,fun){
			Notice.I.off(type,_scope,fun);
		}

		__static(Notice,
		['I',function(){return this.I=new Notice();}
		]);
		return Notice;
	})(EventDispatcher)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.enginehook.LoaderHook extends laya.net.LoaderManager
	var LoaderHook=(function(_super){
		function LoaderHook(){
			LoaderHook.__super.call(this);
		}

		__class(LoaderHook,'laya.debug.tools.enginehook.LoaderHook',_super);
		var __proto=LoaderHook.prototype;
		__proto.checkUrls=function(url){
			var tarUrl;
			if ((typeof url=='string')){
				tarUrl=url;
				}else{
				tarUrl=url.url;
			}
			if (LoaderHook.preFails[tarUrl]){
				if (LoaderHook.enableFailDebugger){
					debugger;
				}
			}
		}

		__proto.chekUrlList=function(urls){
			var i=0,len=0;
			len=urls.length;
			for (i=0;i < len;i++){
				this.checkUrls(urls[i]);
			}
		}

		__proto.load=function(url,complete,progress,type,priority,cache){
			(priority===void 0)&& (priority=1);
			(cache===void 0)&& (cache=true);
			if ((url instanceof Array)){
				this.chekUrlList(url);
				}else{
				this.checkUrls(url);
			}
			return _super.prototype.load.call(this,url,complete,progress,type,priority,cache);
		}

		LoaderHook.init=function(){
			Laya.loader=new LoaderHook();
			Laya.loader.on(/*laya.events.Event.ERROR*/"error",null,LoaderHook.onFail);
			LoaderHook.preFails=LocalStorage.getJSON("LoadFailItems");
			if (!LoaderHook.preFails)LoaderHook.preFails={};
		}

		LoaderHook.onFail=function(failFile){
			OutPutView.I.dTrace("LoadFail:"+failFile);
			LoaderHook.nowFails[failFile]=true;
			LocalStorage.setJSON("LoadFailItems",LoaderHook.nowFails);
		}

		LoaderHook.resetFails=function(){
			LoaderHook.nowFails={};
			LocalStorage.setJSON("LoadFailItems",LoaderHook.nowFails);
		}

		LoaderHook.preFails={};
		LoaderHook.nowFails={};
		LoaderHook.enableFailDebugger=true;
		LoaderHook.FailSign="LoadFailItems";
		return LoaderHook;
	})(LoaderManager)


	/**
	*颜色选取类
	*@author ww
	*/
	//class laya.debug.tools.ColorSelector extends laya.display.Sprite
	var ColorSelector=(function(_super){
		function ColorSelector(){
			this.sideColor=null;
			this.mainColor=null;
			this.demoColor=null;
			this.posSp=null;
			this.hPos=null;
			this.container=null;
			this.isChanging=false;
			this.tColor=null;
			this.tH=NaN;
			ColorSelector.__super.call(this);
			this.container=this;
			this.createUI();
		}

		__class(ColorSelector,'laya.debug.tools.ColorSelector',_super);
		var __proto=ColorSelector.prototype;
		__proto.createUI=function(){
			this.sideColor=new Sprite();
			this.container.addChild(this.sideColor);
			this.posSp=new Sprite();
			this.posSp.pos(100,100);
			this.posSp.graphics.drawCircle(0,0,5,null,"#ff0000");
			this.posSp.graphics.drawCircle(0,0,6,null,"#ffff00");
			this.posSp.autoSize=true;
			this.posSp.cacheAsBitmap=true;
			this.sideColor.addChild(this.posSp);
			this.sideColor.pos(0,0);
			this.sideColor.size(150,150);
			this.sideColor.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.sideColorClick);
			var i=0;
			this.mainColor=new Sprite();
			var g;
			g=this.mainColor.graphics;
			var h=NaN;
			var s=NaN;
			var b=NaN;
			var rgb;
			for (i=0;i < 150;i++){
				rgb=ColorTool.hsb2rgb(i/150*360,1,1);
				g.drawLine(0,i,20,i,ColorTool.getRGBStr(rgb));
			}
			this.mainColor.pos(150+10,0);
			this.mainColor.size(20,i);
			this.mainColor.cacheAsBitmap=true;
			this.hPos=new Sprite();
			this.hPos.graphics.drawPie(0,0,10,-10,10,"#ff0000");
			this.hPos.x=this.mainColor.x+22;
			this.container.addChild(this.hPos);
			this.container.addChild(this.mainColor);
			this.mainColor.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.mainColorClick);
			this.demoColor=new Sprite();
			this.demoColor.pos(this.sideColor.x,this.sideColor.y+this.sideColor.height+10);
			this.demoColor.size(150,20);
			this.container.addChild(this.demoColor);
			this.setColorByRGBStr("#099599");
			this.posSp.on(/*laya.events.Event.DRAG_MOVE*/"dragmove",this,this.posDraging);
		}

		// posSp.on(Event.MOUSE_DOWN,this,posMouseDown);
		__proto.posMouseDown=function(e){}
		__proto.posDraging=function(){
			this.updatePosSpAndShowColor();
		}

		__proto.posDragEnd=function(){
			this.isChanging=false;
			this.updatePosSpAndShowColor();
		}

		__proto.setColorByRGBStr=function(rgbStr){
			var rgb;
			rgb=ColorTool.getRGBByRGBStr(rgbStr);
			this.setColor(rgb[0],rgb[1],rgb[2]);
		}

		__proto.setColor=function(red,green,blue,notice){
			(notice===void 0)&& (notice=true);
			var hsb;
			hsb=ColorTool.rgb2hsb(red,green,blue);
			var tRGB;
			tRGB=ColorTool.hsb2rgb(hsb[0],hsb[1],hsb[2]);
			this.setColorByHSB(hsb[0],hsb[1],hsb[2],notice);
		}

		__proto.setColorByHSB=function(h,s,b,notice){
			(notice===void 0)&& (notice=true);
			this.hPos.y=this.mainColor.y+h/360*150;
			this.posSp.x=s *150;
			this.posSp.y=(1-b)*150;
			this.updateSideColor(h,notice);
		}

		__proto.sideColorClick=function(e){
			this.isChanging=true;
			this.posSp.startDrag();
			this.updatePosSpAndShowColor();
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.sideColorMouseUp);
			Laya.stage.once(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.sideColorMouseUp);
		}

		__proto.sideColorMouseUp=function(e){
			this.isChanging=false;
			this.updatePosSpAndShowColor();
		}

		__proto.updatePosSpAndShowColor=function(){
			this.posSp.x=this.sideColor.mouseX;
			this.posSp.y=this.sideColor.mouseY;
			if(this.posSp.x<0)this.posSp.x=0;
			if(this.posSp.y<0)this.posSp.y=0;
			if(this.posSp.x>150)this.posSp.x=150;
			if(this.posSp.y>150)this.posSp.y=150;
			this.updateDemoColor();
		}

		__proto.updateDemoColor=function(notice){
			(notice===void 0)&& (notice=true);
			var h=NaN;
			var s=NaN;
			var b=NaN;
			h=this.tH;
			s=this.posSp.x / 150;
			b=1-this.posSp.y / 150;
			this.tColor=ColorTool.hsb2rgb(h,s,b);
			var g;
			g=this.demoColor.graphics;
			g.clear();
			g.drawRect(0,0,this.demoColor.width,this.demoColor.height,ColorTool.getRGBStr(this.tColor));
			if(this.isChanging)return;
			if(notice)
				this.event("ColorChanged",this);
		}

		__proto.mainColorClick=function(e){
			var yPos=NaN;
			yPos=this.mainColor.mouseY;
			this.hPos.y=yPos+this.mainColor.y;
			var h=NaN;
			h=yPos / 150 *360;
			this.updateSideColor(h);
		}

		__proto.updateSideColor=function(h,notice){
			(notice===void 0)&& (notice=true);
			this.tH=h;
			var s=NaN;
			var b=NaN;
			var g;
			g=this.sideColor.graphics;
			g.clear();
			this.sideColor.cacheAsBitmap=false;
			var rgb;
			rgb=ColorTool.hsb2rgb(h,1,1);
			var gradient=Browser.context.createLinearGradient(0,0,80,0);
			gradient.addColorStop(0,"white");
			gradient.addColorStop(1,ColorTool.getRGBStr(rgb));
			this.sideColor.graphics.drawRect(0,0,150,150,gradient);
			this.sideColor.graphics.loadImage("comp/colorpicker_overlay.png",0,0);
			this.sideColor.size(150,150);
			this.sideColor.cacheAsBitmap=true;
			this.updateDemoColor(notice);
		}

		ColorSelector.COLOR_CHANGED="ColorChanged";
		ColorSelector.COLOR_CLEARED="COLOR_CLEARED";
		ColorSelector.RecWidth=150;
		return ColorSelector;
	})(Sprite)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-30 下午1:59:34
	*/
	//class laya.debug.tools.comps.Arrow extends laya.display.Sprite
	var Arrow=(function(_super){
		function Arrow(){
			Arrow.__super.call(this);
			this.drawMe();
		}

		__class(Arrow,'laya.debug.tools.comps.Arrow',_super);
		var __proto=Arrow.prototype;
		__proto.drawMe=function(){
			var g;
			g=this.graphics;
			g.clear();
			g.drawLine(0,0,-1,-1,"#ff0000");
			g.drawLine(0,0,1,-1,"#ff0000");
		}

		return Arrow;
	})(Sprite)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-30 下午2:03:32
	*/
	//class laya.debug.tools.comps.ArrowLine extends laya.display.Sprite
	var ArrowLine=(function(_super){
		function ArrowLine(sign){
			this.lineLen=160;
			this.arrowLen=10;
			this.sign="Y";
			this._targetChanger=null;
			this._isMoving=false;
			this.lenControl=new Rect();
			this.rotationControl=new Rect();
			this.lenChanger=ValueChanger.create(this,"lineLen");
			this.lenControlXChanger=ValueChanger.create(this.lenControl,"x");
			(sign===void 0)&& (sign="X");
			ArrowLine.__super.call(this);
			this.sign=sign;
			this.addChild(this.lenControl);
			this.addChild(this.rotationControl);
			this.lenControl.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.controlMouseDown);
			this.drawMe();
		}

		__class(ArrowLine,'laya.debug.tools.comps.ArrowLine',_super);
		var __proto=ArrowLine.prototype;
		__proto.drawMe=function(){
			var g;
			g=this.graphics;
			g.clear();
			g.drawLine(0,0,this.lineLen,0,"#ffff00");
			g.drawLine(this.lineLen,0,this.lineLen-this.arrowLen,-this.arrowLen,"#ff0000");
			g.drawLine(this.lineLen,0,this.lineLen-this.arrowLen,this.arrowLen,"#ff0000");
			g.fillText(this.sign,50,-5,"","#ff0000","left");
			if(this._isMoving&&this._targetChanger){
				g.fillText(this._targetChanger.key+":"+this._targetChanger.value.toFixed(2),this.lineLen-15,-25,"","#ffff00","center");
			}
			this.lenControl.posTo(this.lineLen-15,0);
			this.rotationControl.posTo(this.lineLen+10,0);
			this.size(this.arrowLen,this.lineLen);
		}

		__proto.clearMoveEvents=function(){
			Laya.stage.off(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.stageMouseMove);
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.stageMouseUp);
		}

		__proto.controlMouseDown=function(e){
			this.clearMoveEvents();
			this.lenControlXChanger.record();
			this.lenChanger.record();
			if(this.targetChanger){
				this.targetChanger.record();
			}
			this._isMoving=true;
			Laya.stage.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.stageMouseMove);
			Laya.stage.on(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.stageMouseUp);
		}

		__proto.stageMouseMove=function(e){
			this.lenControlXChanger.value=this.mouseX;
			this.lenChanger.showValueByScale(this.lenControlXChanger.scaleValue);
			if(this.targetChanger){
				this.targetChanger.showValueByScale(this.lenControlXChanger.scaleValue);
			}
			this.drawMe();
		}

		__proto.stageMouseUp=function(e){
			this._isMoving=false;
			this.noticeChange();
			this.clearMoveEvents();
			this.lenControlXChanger.recover();
			this.lenChanger.recover();
			this.drawMe();
		}

		__proto.noticeChange=function(){
			var dLen=NaN;
			dLen=this.lenChanger.dValue;
			console.log("lenChange:",dLen);
		}

		__getset(0,__proto,'targetChanger',function(){
			return this._targetChanger;
			},function(changer){
			if(this._targetChanger){
				this._targetChanger.dispose();
			}
			this._targetChanger=changer;
		});

		return ArrowLine;
	})(Sprite)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.comps.AutoSizeRec extends laya.display.Sprite
	var AutoSizeRec=(function(_super){
		function AutoSizeRec(type){
			this.type=0;
			this._color="#ffffff";
			this.preX=NaN;
			this.preY=NaN;
			AutoSizeRec.__super.call(this,type);
		}

		__class(AutoSizeRec,'laya.debug.tools.comps.AutoSizeRec',_super);
		var __proto=AutoSizeRec.prototype;
		__proto.setColor=function(color){
			this._color=color;
			this.reRender();
		}

		__proto.changeSize=function(){
			this.reRender();
		}

		__proto.reRender=function(){
			var g=this.graphics;
			g.clear();
			g.drawRect(0,0,this.width,this.height,this._color);
		}

		__proto.record=function(){
			this.preX=this.x;
			this.preY=this.y;
		}

		__proto.getDx=function(){
			return this.x-this.preX;
		}

		__proto.getDy=function(){
			return this.y-this.preY;
		}

		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this.changeSize();
		});

		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this.changeSize();
		});

		return AutoSizeRec;
	})(Sprite)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-30 下午2:37:05
	*/
	//class laya.debug.tools.comps.Axis extends laya.display.Sprite
	var Axis=(function(_super){
		function Axis(){
			this._target=null;
			this._lenType=
			[
			["width","height"],
			["scaleX","scaleY"]];
			this._type=1;
			this.xAxis=new ArrowLine("X");
			this.yAxis=new ArrowLine("Y");
			this.controlBox=new Rect();
			this._point=new Point();
			this.oPoint=new Point();
			this.myRotationChanger=ValueChanger.create(this,"rotation");
			this.targetRotationChanger=ValueChanger.create(null,"rotation");
			this.stageMouseRotationChanger=new ValueChanger();
			Axis.__super.call(this);
			this.mouseEnabled=true;
			this.size(1,1);
			this.initMe();
			this.xAxis.rotationControl.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.controlMouseDown);
			this.yAxis.rotationControl.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.controlMouseDown);
			this.controlBox.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.controlBoxMouseDown);
			this.on(/*laya.events.Event.DRAG_MOVE*/"dragmove",this,this.dragging);
		}

		__class(Axis,'laya.debug.tools.comps.Axis',_super);
		var __proto=Axis.prototype;
		__proto.updateChanges=function(){
			if(this._target){
				var params;
				params=this._lenType[this._type];
				this.xAxis.targetChanger=ValueChanger.create(this._target,params[0]);
				this.yAxis.targetChanger=ValueChanger.create(this._target,params[1]);
			}
		}

		__proto.switchType=function(){
			this._type++;
			this._type=this._type%this._lenType.length;
			this.type=this._type;
		}

		__proto.controlBoxMouseDown=function(e){
			this.startDrag();
		}

		__proto.dragging=function(){
			if (this._target){
				this._point.setTo(this.x,this.y);
				DisControlTool.transPoint(this.parent,this._target.parent,this._point);
				this._target.pos(this._point.x,this._point.y);
			}
		}

		__proto.initMe=function(){
			this.addChild(this.xAxis);
			this.addChild(this.yAxis);
			this.yAxis.rotation=90;
			this.addChild(this.controlBox);
			this.controlBox.posTo(0,0);
		}

		__proto.clearMoveEvents=function(){
			Laya.stage.off(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.stageMouseMove);
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.stageMouseUp);
		}

		__proto.controlMouseDown=function(e){
			this.targetRotationChanger.target=this.target;
			this.clearMoveEvents();
			this.oPoint.setTo(0,0);
			this.myRotationChanger.record();
			this.oPoint=this.localToGlobal(this.oPoint);
			this.stageMouseRotationChanger.value=this.getStageMouseRatation();
			this.stageMouseRotationChanger.record();
			this.targetRotationChanger.record();
			Laya.stage.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.stageMouseMove);
			Laya.stage.on(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.stageMouseUp);
		}

		__proto.getStageMouseRatation=function(){
			return MathUtil.getRotation(this.oPoint.x,this.oPoint.y,Laya.stage.mouseX,Laya.stage.mouseY);
		}

		__proto.stageMouseMove=function(e){
			this.stageMouseRotationChanger.value=this.getStageMouseRatation();
			var dRotation=NaN;
			dRotation=-this.stageMouseRotationChanger.dValue;
			if(this.target){
				this.targetRotationChanger.showValueByAdd(dRotation);
				}else{
				this.myRotationChanger.showValueByAdd(dRotation);
			}
		}

		__proto.stageMouseUp=function(e){
			this.noticeChange();
			this.clearMoveEvents();
		}

		__proto.noticeChange=function(){
			console.log("rotate:",-this.stageMouseRotationChanger.dValue);
		}

		__getset(0,__proto,'target',function(){
			return this._target;
			},function(tar){
			this._target=tar;
			this.updateChanges();
		});

		__getset(0,__proto,'type',function(){
			return this._type;
			},function(lenType){
			this._type=lenType;
			this.updateChanges();
		});

		return Axis;
	})(Sprite)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-12-30 下午3:23:06
	*/
	//class laya.debug.tools.comps.Rect extends laya.display.Sprite
	var Rect=(function(_super){
		function Rect(){
			this.recWidth=10;
			Rect.__super.call(this);
			this.drawMe();
		}

		__class(Rect,'laya.debug.tools.comps.Rect',_super);
		var __proto=Rect.prototype;
		__proto.drawMe=function(){
			var g;
			g=this.graphics;
			g.clear();
			g.drawRect(0,0,this.recWidth,this.recWidth,"#22ff22");
			this.size(this.recWidth,this.recWidth);
		}

		__proto.posTo=function(x,y){
			this.x=x-this.recWidth*0.5;
			this.y=y-this.recWidth*0.5;
		}

		return Rect;
	})(Sprite)


	//class laya.debug.tools.DragBox extends laya.display.Sprite
	var DragBox=(function(_super){
		function DragBox(type){
			this._box=null;
			this._target=null;
			this._currDir=null;
			this._type=0;
			this.fixScale=NaN;
			DragBox.__super.call(this);
			this._left=this.drawBlock();
			this._right=this.drawBlock();
			this._top=this.drawBlock();
			this._bottom=this.drawBlock();
			this._topLeft=this.drawBlock();
			this._topRight=this.drawBlock();
			this._bottomLeft=this.drawBlock();
			this._bottomRight=this.drawBlock();
			this._lastPoint=new Point();
			this._type=type=3;
			this.addChild(this._box=this.drawBorder(0,0,0xff0000));
			if (type==1 || type==3){
				this.addChild(this._left);
				this.addChild(this._right);
			}
			if (type==2 || type==3){
				this.addChild(this._top);
				this.addChild(this._bottom);
			}
			if (type==3){
				this.addChild(this._topLeft);
				this.addChild(this._topRight);
				this.addChild(this._bottomLeft);
				this.addChild(this._bottomRight);
			}
			this.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onMouseDown);
			this.mouseThrough=true;
		}

		__class(DragBox,'laya.debug.tools.DragBox',_super);
		var __proto=DragBox.prototype;
		__proto.onMouseDown=function(e){
			this._currDir=e.target;
			if(e.nativeEvent.shiftKey){
				this.initFixScale();
			}
			if (this._currDir !=this){
				this._lastPoint.x=Laya.stage.mouseX;
				this._lastPoint.y=Laya.stage.mouseY;
				Laya.stage.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.onMouseMove);
				Laya.stage.on(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onMouseUp);
				e.stopPropagation();
			}
		}

		__proto.onMouseUp=function(e){
			Laya.stage.off(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.onMouseMove);
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onMouseUp);
		}

		__proto.initFixScale=function(){
			this.fixScale=this._target.height / this._target.width;
		}

		__proto.onMouseMove=function(e){
			var scale=1;
			var tx=(Laya.stage.mouseX-this._lastPoint.x)/ scale;
			var ty=(Laya.stage.mouseY-this._lastPoint.y)/ scale;
			var sameScale=false;
			var adptX=NaN;
			var adptY=NaN;
			if(e.nativeEvent.shiftKey){
				if(this.fixScale<0)this.initFixScale();
				adptY=tx *this.fixScale;
				adptX=ty/this.fixScale;
				sameScale=true;
				switch(this._currDir){
					case this._topLeft:
					case this._bottomLeft:
						this._currDir=this._left;
						break ;
					case this._topRight:
					case this._bottomRight:
						this._currDir=this._right;
						break ;
					}
			}
			if (tx !=0 || ty !=0){
				this._lastPoint.x+=tx *scale;
				this._lastPoint.y+=ty *scale;
				var tw=tx / this._target.scaleX;
				var th=ty / this._target.scaleY;
				if (this._currDir==this._left){
					this._target.x+=tx;
					this._target.width-=tw;
					if (sameScale){
						this._target.height=this._target.width*this.fixScale;
					}
					}else if (this._currDir==this._right){
					this._target.width+=tw;
					if (sameScale){
						this._target.height=this._target.width*this.fixScale;
					}
					}else if (this._currDir==this._top){
					this._target.y+=ty;
					this._target.height-=th;
					if (sameScale){
						this._target.width=this._target.height/this.fixScale;
					}
					}else if (this._currDir==this._bottom){
					this._target.height+=th;
					if (sameScale){
						this._target.width=this._target.height/this.fixScale;
					}
					}else if (this._currDir==this._topLeft){
					this._target.x+=tx;
					this._target.y+=ty;
					this._target.width-=tw;
					this._target.height-=th;
					}else if (this._currDir==this._topRight){
					this._target.y+=ty;
					this._target.width+=tw;
					this._target.height-=th;
					}else if (this._currDir==this._bottomLeft){
					this._target.x+=tx;
					this._target.width-=tw;
					this._target.height+=th;
					}else if (this._currDir==this._bottomRight){
					this._target.width+=tw;
					this._target.height+=th;
				}
				if (this._target.width < 1){
					this._target.width=1;
				}
				if (this._target.height < 1){
					this._target.height=1;
				}
				this._target.width=Math.round(this._target.width);
				this._target.x=Math.round(this._target.x);
				this._target.y=Math.round(this._target.y);
				this._target.height=Math.round(this._target.height);
				this.refresh();
			}
		}

		/**画矩形*/
		__proto.drawBorder=function(width,height,color,alpha){
			(alpha===void 0)&& (alpha=1);
			var box=new Sprite();
			var g=box.graphics;
			g.clear();
			g.drawRect(0,0,width,height,null,"#"+color);
			return box;
		}

		/**画矩形*/
		__proto.drawBlock=function(){
			var box=new Sprite();
			var g=box.graphics;
			g.clear();
			box.width=DragBox.BLOCK_WIDTH;
			box.height=DragBox.BLOCK_WIDTH;
			g.drawRect(-DragBox.BLOCK_WIDTH *0.5,-DragBox.BLOCK_WIDTH *0.5,DragBox.BLOCK_WIDTH,DragBox.BLOCK_WIDTH,"#ffffff","#ff0000",1);
			box.mouseEnabled=true;
			box.mouseThrough=true;
			return box;
		}

		/**设置对象*/
		__proto.setTarget=function(target){
			this._target=target;
			this.refresh();
		}

		__proto.refresh=function(){
			this.changePoint();
			this.changeSize();
		}

		__proto.changePoint=function(){
			var p=this._target.localToGlobal(new Point());
			var np=(this.parent).globalToLocal(p);
			this.x=np.x;
			this.y=np.y;
		}

		/**设置大小*/
		__proto.changeSize=function(){
			var width=this._target.width *this._target.scaleX;
			var height=this._target.height *this._target.scaleY;
			console.log("change size");
			this.rotation=this._target.rotation;
			if (this._box.width !=width || this._box.height !=height){
				this._box.graphics.clear();
				this._box.graphics.drawRect(0,0,Math.abs(width),Math.abs(height),null,"#ff0000");
				this._box.size(width,height);
				this.size(width,height);
				this._box.scaleX=Math.abs(this._box.scaleX)*(this._target.scaleX > 0 ? 1 :-1);
				this._box.scaleY=Math.abs(this._box.scaleY)*(this._target.scaleY > 0 ? 1 :-1);
				this._left.x=0;
				this._left.y=height *0.5;
				this._right.x=width;
				this._right.y=height *0.5;
				this._top.x=width *0.5;
				this._top.y=0;
				this._bottom.x=width *0.5;
				this._bottom.y=height;
				this._topLeft.x=this._topLeft.y=0;
				this._topRight.x=width;
				this._topRight.y=0;
				this._bottomLeft.x=0;
				this._bottomLeft.y=height;
				this._bottomRight.x=width;
				this._bottomRight.y=height;
			}
		}

		DragBox.BLOCK_WIDTH=6;
		return DragBox;
	})(Sprite)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.DebugInfoLayer extends laya.display.Sprite
	var DebugInfoLayer=(function(_super){
		function DebugInfoLayer(){
			this.nodeRecInfoLayer=null;
			this.lineLayer=null;
			this.txtLayer=null;
			this.popLayer=null;
			this.graphicLayer=null;
			DebugInfoLayer.__super.call(this);
			this.nodeRecInfoLayer=new Sprite();
			this.lineLayer=new Sprite();
			this.txtLayer=new Sprite();
			this.popLayer=new Sprite();
			this.graphicLayer=new Sprite();
			this.nodeRecInfoLayer.name="nodeRecInfoLayer";
			this.lineLayer.name="lineLayer";
			this.txtLayer.name="txtLayer";
			this.popLayer.name="popLayer";
			this.graphicLayer.name="graphicLayer";
			this.addChild(this.lineLayer);
			this.addChild(this.nodeRecInfoLayer);
			this.addChild(this.txtLayer);
			this.addChild(this.popLayer);
			this.addChild(this.graphicLayer);
			DebugInfoLayer.I=this;
			Laya.stage.on(/*laya.events.Event.DOUBLE_CLICK*/"doubleclick",this,this.setTop);
		}

		__class(DebugInfoLayer,'laya.debug.view.nodeInfo.DebugInfoLayer',_super);
		var __proto=DebugInfoLayer.prototype;
		__proto.setTop=function(){
			DisControlTool.setTop(this);
		}

		__proto.isDebugItem=function(sprite){
			return DisControlTool.isInTree(this,sprite);
		}

		DebugInfoLayer.I=null
		return DebugInfoLayer;
	})(Sprite)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.NodeInfoPanel extends laya.display.Sprite
	var NodeInfoPanel=(function(_super){
		function NodeInfoPanel(){
			this._stateDic={};
			this.isWorkState=false;
			NodeInfoPanel.__super.call(this);
		}

		__class(NodeInfoPanel,'laya.debug.view.nodeInfo.NodeInfoPanel',_super);
		var __proto=NodeInfoPanel.prototype;
		__proto.showDisInfo=function(node){
			this.recoverNodes();
			NodeInfosItem.showDisInfos(node);
			this.showOnly(node);
			this.isWorkState=true;
		}

		__proto.showOnly=function(node){
			if (!node)
				return;
			this.hideBrothers(node);
			this.showOnly(node.parent);
		}

		__proto.recoverNodes=function(){
			NodeInfosItem.hideAllInfos();
			var key;
			var data;
			var tTar;
			for (key in this._stateDic){
				data=this._stateDic[key];
				tTar=data["target"];
				if (tTar){
					try{
						tTar.visible=data.visible;
						}catch (e){
					}
				}
			}
			this.isWorkState=false;
		}

		__proto.hideOtherChain=function(node){
			if (!node)
				return;
			while (node){
				this.hideBrothers(node);
				node=node.parent;
			}
		}

		__proto.hideChilds=function(node){
			if (!node)
				return;
			var i=0,len=0;
			var cList;
			cList=node._childs;
			len=cList.length;
			var tChild;
			for (i=0;i < len;i++){
				tChild=cList[i];
				if (tChild==NodeInfosItem.NodeInfoContainer)continue ;
				this.saveNodeInfo(tChild);
				tChild.visible=false;
			}
		}

		__proto.hideBrothers=function(node){
			if (!node)
				return;
			var p;
			p=node.parent;
			if (!p)
				return;
			var i=0,len=0;
			var cList;
			cList=p._childs;
			len=cList.length;
			var tChild;
			for (i=0;i < len;i++){
				tChild=cList[i];
				if (tChild==NodeInfosItem.NodeInfoContainer)continue ;
				if (tChild !=node){
					this.saveNodeInfo(tChild);
					tChild.visible=false;
				}
			}
		}

		__proto.saveNodeInfo=function(node){
			IDTools.idObj(node);
			if(this._stateDic.hasOwnProperty(IDTools.getObjID(node)))return;
			var data;
			data={};
			data.target=node;
			data.visible=node.visible;
			this._stateDic[IDTools.getObjID(node)]=data;
		}

		__proto.recoverNodeInfo=function(node){
			IDTools.idObj(node);
			if (this._stateDic.hasOwnProperty(IDTools.getObjID(node))){
				var data;
				data=this._stateDic[IDTools.getObjID(node)];
				node["visible"]=data.visible;
			}
		}

		NodeInfoPanel.init=function(){
			if (!NodeInfoPanel.I){
				NodeInfoPanel.I=new NodeInfoPanel();
				NodeInfosItem.init();
				ToolPanel.init();
			}
		}

		NodeInfoPanel.I=null
		return NodeInfoPanel;
	})(Sprite)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.NodeInfosItem extends laya.display.Sprite
	var NodeInfosItem=(function(_super){
		function NodeInfosItem(){
			this._infoTxt=null;
			this._tar=null;
			NodeInfosItem.__super.call(this);
			this._infoTxt=new Text();
			this._infoTxt.color="#ff0000";
			this._infoTxt.bgColor="#00ff00";
			this._infoTxt.fontSize=12;
		}

		__class(NodeInfosItem,'laya.debug.view.nodeInfo.NodeInfosItem',_super);
		var __proto=NodeInfosItem.prototype;
		__proto.removeSelf=function(){
			this._infoTxt.removeSelf();
			return laya.display.Node.prototype.removeSelf.call(this);
		}

		__proto.showToUI=function(){
			NodeInfosItem.NodeInfoContainer.nodeRecInfoLayer.addChild(this);
			this._infoTxt.removeSelf();
			NodeInfosItem.NodeInfoContainer.txtLayer.addChild(this._infoTxt);
			this.findOkPos();
		}

		__proto.randomAPos=function(r){
			this._infoTxt.x=this.x+Laya.stage.width*Math.random();
			this._infoTxt.y=this.y+r *Math.random();
		}

		__proto.findOkPos=function(){
			var len=0;
			len=20;
			this.randomAPos(len);
			return;
			var count=0;
			count=1;
			while (!this.isPosOk()){
				count++;
				if (count >=500){
					len+=10;
					count=0;
				}
				this.randomAPos(len);
			}
		}

		__proto.isPosOk=function(){
			var tParent;
			tParent=NodeInfosItem.NodeInfoContainer.nodeRecInfoLayer;
			var i=0,len=0;
			var cList;
			cList=tParent._childs;
			len=cList.length;
			var tChild;
			var mRec;
			mRec=this._infoTxt.getBounds();
			if (mRec.x < 0)return false;
			if (mRec.y < 0)return false;
			if (mRec.right > Laya.stage.width)return false;
			for (i=0;i < len;i++){
				tChild=cList[i];
				if (tChild==this._infoTxt)continue ;
				if (mRec.intersects(tChild.getBounds()))return false;
			}
			return true;
		}

		__proto.showInfo=function(node){
			this._tar=node;
			if (!node)return;
			NodeInfosItem._txts.length=0;
			var i=0,len=0;
			var tKey;
			len=NodeInfosItem.showValues.length;
			if (node.name){
				NodeInfosItem._txts.push(ClassTool.getClassName(node)+"("+node.name+")");
				}else{
				NodeInfosItem._txts.push(ClassTool.getClassName(node));
			}
			for (i=0;i < len;i++){
				tKey=NodeInfosItem.showValues[i];
				NodeInfosItem._txts.push(tKey+":"+NodeInfosItem.getNodeValue(node,tKey));
			}
			this._infoTxt.text=NodeInfosItem._txts.join("\n");
			this.graphics.clear();
			var pointList;
			pointList=node._getBoundPointsM(true);
			if(!pointList||pointList.length<1)return;
			pointList=GrahamScan.pListToPointList(pointList,true);
			WalkTools.walkArr(pointList,node.localToGlobal,node);
			pointList=GrahamScan.pointListToPlist(pointList);
			NodeInfosItem._disBoundRec=Rectangle._getWrapRec(pointList,NodeInfosItem._disBoundRec);
			this.graphics.drawRect(0,0,NodeInfosItem._disBoundRec.width,NodeInfosItem._disBoundRec.height,null,"#00ffff");
			this.pos(NodeInfosItem._disBoundRec.x,NodeInfosItem._disBoundRec.y);
		}

		__proto.fresh=function(){
			this.showInfo(this._tar);
		}

		__proto.clearMe=function(){
			this._tar=null;
		}

		__proto.recover=function(){
			Pool.recover("NodeInfosItem",this);
		}

		NodeInfosItem.init=function(){
			if (!NodeInfosItem.NodeInfoContainer){
				NodeInfosItem.NodeInfoContainer=new DebugInfoLayer();
				Laya.stage.addChild(NodeInfosItem.NodeInfoContainer);
			}
		}

		NodeInfosItem.getNodeInfoByNode=function(node){
			IDTools.idObj(node);
			var key=0;
			key=IDTools.getObjID(node);
			if (!NodeInfosItem._nodeInfoDic[key]){
				NodeInfosItem._nodeInfoDic[key]=new NodeInfosItem();
			}
			return NodeInfosItem._nodeInfoDic[key];
		}

		NodeInfosItem.hideAllInfos=function(){
			var key;
			var tInfo;
			for (key in NodeInfosItem._nodeInfoDic){
				tInfo=NodeInfosItem._nodeInfoDic[key];
				tInfo.removeSelf();
			}
			NodeInfosItem.clearRelations();
		}

		NodeInfosItem.showNodeInfo=function(node){
			var nodeInfo;
			nodeInfo=NodeInfosItem.getNodeInfoByNode(node);
			nodeInfo.showInfo(node);
			nodeInfo.showToUI();
		}

		NodeInfosItem.showDisInfos=function(node){
			var _node;
			_node=node;
			if (!node)
				return;
			while (node){
				NodeInfosItem.showNodeInfo(node);
				node=node.parent;
			}
			DisControlTool.setTop(NodeInfosItem.NodeInfoContainer);
			NodeInfosItem.apdtTxtInfoPoss(_node);
			NodeInfosItem.updateRelations();
		}

		NodeInfosItem.apdtTxtInfoPoss=function(node){
			var disList;
			disList=[];
			while (node){
				disList.push(node);
				node=node.parent;
			};
			var i=0,len=0;
			var tInfo;
			var tTxt;
			len=disList.length;
			var xPos=NaN;
			xPos=Laya.stage.width-150;
			var heightLen=0;
			heightLen=100;
			node=disList[0];
			if (node){
				tInfo=NodeInfosItem.getNodeInfoByNode(node);
				if (tInfo){
					tTxt=tInfo._infoTxt;
					xPos=Laya.stage.width-tTxt.width-10;
					heightLen=tTxt.height+10;
				}
			}
			disList=disList.reverse();
			for (i=0;i < len;i++){
				node=disList[i];
				tInfo=NodeInfosItem.getNodeInfoByNode(node);
				if (tInfo){
					tTxt=tInfo._infoTxt;
					tTxt.pos(xPos,heightLen *i);
				}
			}
		}

		NodeInfosItem.clearRelations=function(){
			var g;
			g=NodeInfosItem.NodeInfoContainer.lineLayer.graphics;
			g.clear();
		}

		NodeInfosItem.updateRelations=function(){
			var g;
			g=NodeInfosItem.NodeInfoContainer.lineLayer.graphics;
			g.clear();
			var key;
			var tInfo;
			for (key in NodeInfosItem._nodeInfoDic){
				tInfo=NodeInfosItem._nodeInfoDic[key];
				if (tInfo.parent){
					g.drawLine(tInfo.x,tInfo.y,tInfo._infoTxt.x,tInfo._infoTxt.y,"#0000ff");
				}
			}
		}

		NodeInfosItem.getNodeValue=function(node,key){
			var rst;
			NodeInfosItem._nodePoint.setTo(0,0);
			switch(key){
				case "x":
					rst=node["x"]+" (g:"+node.localToGlobal(NodeInfosItem._nodePoint).x+")"
					break ;
				case "y":
					rst=node["y"]+" (g:"+node.localToGlobal(NodeInfosItem._nodePoint).y+")"
					break ;
				default :
					rst=node[key];
				}
			return rst;
		}

		NodeInfosItem.NodeInfoContainer=null
		NodeInfosItem._nodeInfoDic={};
		NodeInfosItem._txts=[];
		__static(NodeInfosItem,
		['showValues',function(){return this.showValues=["x","y","scaleX","scaleY","width","height","visible","mouseEnabled"];},'_disBoundRec',function(){return this._disBoundRec=new Rectangle();},'_nodePoint',function(){return this._nodePoint=new Point();}
		]);
		return NodeInfosItem;
	})(Sprite)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.recinfos.NodeRecInfo extends laya.display.Sprite
	var NodeRecInfo=(function(_super){
		function NodeRecInfo(){
			this.txt=null;
			this._tar=null;
			this.recColor="#00ffff";
			NodeRecInfo.__super.call(this);
			this.txt=new Text();
			this.txt.color="#ff0000";
			this.txt.bgColor="#00ff00";
			this.txt.fontSize=12;
			this.addChild(this.txt);
		}

		__class(NodeRecInfo,'laya.debug.view.nodeInfo.recinfos.NodeRecInfo',_super);
		var __proto=NodeRecInfo.prototype;
		__proto.setInfo=function(str){
			this.txt.text=str;
		}

		__proto.setTarget=function(tar){
			this._tar=tar;
		}

		__proto.showInfo=function(node){
			this._tar=node;
			if (!node)return;
			if(!node._$P)return;
			this.graphics.clear();
			var pointList;
			pointList=node._getBoundPointsM(true);
			if(!pointList||pointList.length<1)return;
			pointList=GrahamScan.pListToPointList(pointList,true);
			WalkTools.walkArr(pointList,node.localToGlobal,node);
			pointList=GrahamScan.pointListToPlist(pointList);
			NodeRecInfo._disBoundRec=Rectangle._getWrapRec(pointList,NodeRecInfo._disBoundRec);
			this.graphics.drawRect(0,0,NodeRecInfo._disBoundRec.width,NodeRecInfo._disBoundRec.height,null,this.recColor,2);
			this.pos(NodeRecInfo._disBoundRec.x,NodeRecInfo._disBoundRec.y);
		}

		__proto.fresh=function(){
			this.showInfo(this._tar);
		}

		__proto.clearMe=function(){
			this._tar=null;
		}

		__static(NodeRecInfo,
		['_disBoundRec',function(){return this._disBoundRec=new Rectangle();}
		]);
		return NodeRecInfo;
	})(Sprite)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.ToolPanel extends laya.display.Sprite
	var ToolPanel=(function(_super){
		function ToolPanel(){
			ToolPanel.__super.call(this);
			Base64AtlasManager.base64.preLoad(Handler.create(this,this.showToolBar));
			ContextMenu.init();
			DisResizer.init();
			var tipManager;
			tipManager=new TipManagerForDebug();
		}

		__class(ToolPanel,'laya.debug.view.nodeInfo.ToolPanel',_super);
		var __proto=ToolPanel.prototype;
		//Laya.timer.once(1000,this,showToolBar);
		__proto.showToolBar=function(){
			DebugPanelView.I.show();
		}

		__proto.createViews=function(){
			ToolPanel.typeClassDic["Find"]=FindView;
			ToolPanel.typeClassDic["Filter"]=FilterView;
			ToolPanel.typeClassDic["TxtInfo"]=TxtInfoView;
			ToolPanel.typeClassDic["Tree"]=NodeTreeView;
		}

		__proto.switchShow=function(type){
			var view;
			view=this.getView(type);
			if (view){
				view.switchShow();
			}
		}

		__proto.getView=function(type){
			var view;
			view=ToolPanel.viewDic[type];
			if (!view && ToolPanel.typeClassDic[type]){
				view=ToolPanel.viewDic[type]=new ToolPanel.typeClassDic[type]();
			}
			return view;
		}

		__proto.showTxtInfo=function(txt){
			OutPutView.I.showTxt(txt);
		}

		__proto.showNodeTree=function(node){
			NodeTree.I.setDis(node);
			DebugPanelView.I.switchToTree();
		}

		__proto.showSelectInStage=function(node){
			NodeTree.I.showSelectInStage(node);
			DebugPanelView.I.switchToTree();
		}

		__proto.showSelectItems=function(selectList){
			DebugPanelView.I.swichToSelect();
			SelectInfosView.I.setSelectList(selectList);
		}

		ToolPanel.init=function(){
			if (!ToolPanel.I)ToolPanel.I=new ToolPanel();
		}

		ToolPanel.I=null
		ToolPanel.viewDic={};
		ToolPanel.Find="Find";
		ToolPanel.Filter="Filter";
		ToolPanel.TxtInfo="TxtInfo";
		ToolPanel.Tree="Tree";
		__static(ToolPanel,
		['typeClassDic',function(){return this.typeClassDic={
		};}

		]);
		return ToolPanel;
	})(Sprite)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-9-29 上午11:17:35
	*/
	//class laya.debug.tools.debugUI.DButton extends laya.display.Text
	var DButton=(function(_super){
		function DButton(){
			DButton.__super.call(this);
			this.bgColor="#ffff00";
			this.wordWrap=false;
			this.mouseEnabled=true;
		}

		__class(DButton,'laya.debug.tools.debugUI.DButton',_super);
		return DButton;
	})(Text)


	/**
	*自动根据大小填充自己全部区域的显示对象
	*@author ww
	*/
	//class laya.debug.tools.resizer.AutoFillRec extends laya.ui.Component
	var AutoFillRec=(function(_super){
		function AutoFillRec(type){
			this.type=0;
			this.preX=NaN;
			this.preY=NaN;
			AutoFillRec.__super.call(this);
		}

		__class(AutoFillRec,'laya.debug.tools.resizer.AutoFillRec',_super);
		var __proto=AutoFillRec.prototype;
		//super(type);
		__proto.changeSize=function(){
			_super.prototype.changeSize.call(this);
			var g=this.graphics;
			g.clear();
			g.drawRect(0,0,this.width,this.height,"#33c5f5");
		}

		__proto.record=function(){
			this.preX=this.x;
			this.preY=this.y;
		}

		__proto.getDx=function(){
			return this.x-this.preX;
		}

		__proto.getDy=function(){
			return this.y-this.preY;
		}

		return AutoFillRec;
	})(Component)


	/**鼠标提示管理类*/
	//class laya.debug.tools.TipManagerForDebug extends laya.ui.Component
	var TipManagerForDebug=(function(_super){
		function TipManagerForDebug(){
			this._tipBox=null;
			this._tipText=null;
			this._defaultTipHandler=null;
			TipManagerForDebug.__super.call(this);
			this._tipBox=new Component();
			this._tipBox.addChild(this._tipText=new Text());
			this._tipText.x=this._tipText.y=5;
			this._tipText.color=TipManagerForDebug.tipTextColor;
			this._defaultTipHandler=this.showDefaultTip;
			Laya.stage.on(/*laya.ui.UIEvent.SHOW_TIP*/"showtip",this,this.onStageShowTip);
			Laya.stage.on(/*laya.ui.UIEvent.HIDE_TIP*/"hidetip",this,this.onStageHideTip);
		}

		__class(TipManagerForDebug,'laya.debug.tools.TipManagerForDebug',_super);
		var __proto=TipManagerForDebug.prototype;
		__proto.onStageHideTip=function(e){
			Laya.timer.clear(this,this.showTip);
			this.closeAll();
			this.removeSelf();
		}

		__proto.onStageShowTip=function(data){
			Laya.timer.once(TipManagerForDebug.tipDelay,this,this.showTip,[data],true);
		}

		__proto.showTip=function(tip){
			if ((typeof tip=='string')){
				var text=String(tip);
				if (Boolean(text)){
					this._defaultTipHandler(text);
				}
				}else if ((tip instanceof laya.utils.Handler )){
				(tip).run();
				}else if ((typeof tip=='function')){
				(tip).apply();
			}
			if (true){
				Laya.stage.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.onStageMouseMove);
				Laya.stage.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onStageMouseDown);
			}
			this.onStageMouseMove(null);
		}

		__proto.onStageMouseDown=function(e){
			this.closeAll();
		}

		__proto.onStageMouseMove=function(e){
			this.showToStage(this,TipManagerForDebug.offsetX,TipManagerForDebug.offsetY);
		}

		__proto.showToStage=function(dis,offX,offY){
			(offX===void 0)&& (offX=0);
			(offY===void 0)&& (offY=0);
			var rec=dis.getBounds();
			dis.x=Laya.stage.mouseX+offX;
			dis.y=Laya.stage.mouseY+offY;
			if (dis.x+rec.width > Laya.stage.width){
				dis.x-=rec.width+offX;
			}
			if (dis.y+rec.height > Laya.stage.height){
				dis.y-=rec.height+offY;
			}
		}

		/**关闭所有鼠标提示*/
		__proto.closeAll=function(){
			Laya.timer.clear(this,this.showTip);
			Laya.stage.off(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.onStageMouseMove);
			Laya.stage.off(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onStageMouseDown);
			this.removeChildren();
		}

		__proto.showDisTip=function(tip){
			this.addChild(tip);
			this.showToStage(this);
			Laya.stage.addChild(this);
		}

		__proto.showDefaultTip=function(text){
			this._tipText.text=text;
			var g=this._tipBox.graphics;
			g.clear();
			g.drawRect(0,0,this._tipText.width+10,this._tipText.height+10,TipManagerForDebug.tipBackColor);
			this.addChild(this._tipBox);
			this.showToStage(this);
			Laya.stage.addChild(this);
		}

		/**默认鼠标提示函数*/
		__getset(0,__proto,'defaultTipHandler',function(){
			return this._defaultTipHandler;
			},function(value){
			this._defaultTipHandler=value;
		});

		TipManagerForDebug.offsetX=10;
		TipManagerForDebug.offsetY=15;
		TipManagerForDebug.tipTextColor="#ffffff";
		TipManagerForDebug.tipBackColor="#111111";
		TipManagerForDebug.tipDelay=200;
		return TipManagerForDebug;
	})(Component)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.UIViewBase extends laya.ui.Component
	var UIViewBase=(function(_super){
		function UIViewBase(){
			this.minHandler=null;
			this.maxHandler=null;
			this.isFirstShow=true;
			this.dis=null;
			UIViewBase.__super.call(this);
			this.dis=this;
			this.minHandler=new Handler(this,this.close);
			this.maxHandler=new Handler(this,this.show);
			this.createPanel();
			if (this.dis){
				this.dis.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.bringToTop);
				this.dis.cacheAsBitmap=true;
			}
		}

		__class(UIViewBase,'laya.debug.view.nodeInfo.views.UIViewBase',_super);
		var __proto=UIViewBase.prototype;
		__proto.show=function(){
			DebugInfoLayer.I.setTop();
			DebugInfoLayer.I.popLayer.addChild(this.dis);
			if (this.isFirstShow){
				this.firstShowFun();
				this.isFirstShow=false;
			}
		}

		__proto.firstShowFun=function(){
			this.dis.x=(Laya.stage.width-this.dis.width)*0.5;
			this.dis.y=(Laya.stage.height-this.dis.height)*0.5;
			DisControlTool.intFyDisPos(this.dis);
		}

		__proto.bringToTop=function(){
			DisControlTool.setTop(this.dis);
		}

		__proto.switchShow=function(){
			if (this.dis.parent){
				this.close();
				}else{
				this.show();
			}
		}

		__proto.close=function(){
			this.dis.removeSelf();
		}

		__proto.createPanel=function(){}
		__proto.getInput=function(){
			var input;
			input=new DInput();
			input.size(200,30);
			input.fontSize=30;
			return input;
		}

		__proto.getButton=function(){
			var btn;
			btn=new DButton();
			btn.size(40,30);
			btn.fontSize=30;
			return btn;
		}

		return UIViewBase;
	})(Component)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.recinfos.ReCacheRecInfo extends laya.debug.view.nodeInfo.recinfos.NodeRecInfo
	var ReCacheRecInfo=(function(_super){
		function ReCacheRecInfo(){
			this.isWorking=false;
			this.count=0;
			this.mTime=0;
			ReCacheRecInfo.__super.call(this);
			this.txt.fontSize=12;
		}

		__class(ReCacheRecInfo,'laya.debug.view.nodeInfo.recinfos.ReCacheRecInfo',_super);
		var __proto=ReCacheRecInfo.prototype;
		__proto.addCount=function(time){
			(time===void 0)&& (time=0);
			this.count++;
			this.mTime+=time;
			if (!this.isWorking){
				this.working=true;
			}
		}

		__proto.updates=function(){
			if (!this._tar["displayedInStage"]){
				this.working=false;
				this.removeSelf();
			}
			this.txt.text=ClassTool.getNodeClassAndName(this._tar)+"\n"+"reCache:"+this.count+"\ntime:"+this.mTime;
			if (this.count > 0){
				this.fresh();
				Laya.timer.clear(this,this.removeSelfLater);
				}else{
				this.working=false;
				Laya.timer.once(3000,this,this.removeSelfLater);
			}
			this.count=0;
			this.mTime=0;
		}

		__proto.removeSelfLater=function(){
			this.working=false;
			this.removeSelf();
		}

		__getset(0,__proto,'working',null,function(v){
			this.isWorking=v;
			if (v){
				Laya.timer.loop(1000,this,this.updates);
				}else{
				Laya.timer.clear(this,this.updates);
			}
		});

		ReCacheRecInfo.showTime=3000;
		return ReCacheRecInfo;
	})(NodeRecInfo)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.tools.debugUI.DInput extends laya.display.Input
	var DInput=(function(_super){
		function DInput(){
			DInput.__super.call(this);
			this.bgColor="#11ff00";
		}

		__class(DInput,'laya.debug.tools.debugUI.DInput',_super);
		return DInput;
	})(Input)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2015-10-24 下午2:58:37
	*/
	//class laya.debug.uicomps.ContextMenu extends laya.ui.Box
	var ContextMenu=(function(_super){
		function ContextMenu(){
			this._tY=0;
			ContextMenu.__super.call(this);
			StyleConsts.setViewScale(this);
		}

		__class(ContextMenu,'laya.debug.uicomps.ContextMenu',_super);
		var __proto=ContextMenu.prototype;
		__proto.addItem=function(item){
			this.addChild(item);
			item.y=this._tY;
			this._tY+=item.height;
			item.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onClick);
		}

		__proto.onClick=function(e){
			this.event(/*laya.events.Event.SELECT*/"select",e);
			this.removeSelf();
		}

		__proto.show=function(posX,posY){
			(posX===void 0)&& (posX=-999);
			(posY===void 0)&& (posY=-999);
			Laya.timer.once(100,this,ContextMenu.showMenu,[this,posX,posY]);
		}

		ContextMenu.init=function(){
			Laya.stage.on(/*laya.events.Event.CLICK*/"click",null,ContextMenu.cleanMenu);
		}

		ContextMenu.cleanMenu=function(e){
			var i=0;
			var len=0;
			len=ContextMenu._menuList.length;
			for(i=0;i<len;i++){
				if(ContextMenu._menuList[i]){
					ContextMenu._menuList[i].removeSelf();
				}
			}
			ContextMenu._menuList.length=0;
		}

		ContextMenu.showMenu=function(menu,posX,posY){
			(posX===void 0)&& (posX=-999);
			(posY===void 0)&& (posY=-999);
			ContextMenu.cleanMenu();
			ContextMenu.adptMenu(menu);
			Laya.stage.addChild(menu);
			DisControlTool.showToStage(menu);
			if (posX !=-999 && posY !=-999){
				menu.pos(posX,posY);
			}
			ContextMenu._menuList.push(menu);
		}

		ContextMenu.createMenu=function(__args){
			var args=arguments;
			return ContextMenu.createMenuByArray(args);
		}

		ContextMenu.createMenuByArray=function(args){
			var menu=new ContextMenu();
			var separatorBefore=false;
			var item;
			for (var i=0,n=args.length;i < n;i++){
				var obj=args[i];
				var info={};
				if ((typeof obj=='string')){
					info.label=obj;
					}else {
					info=obj;
				}
				if (info.label !=""){
					item=new ContextMenuItem(info.label,separatorBefore);
					item.data=obj;
					menu.addItem(item);
					separatorBefore=false;
					}else {
					item=new ContextMenuItem("",separatorBefore);
					item.data=obj;
					menu.addItem(item);
					separatorBefore=true;
				}
			}
			return menu;
		}

		ContextMenu.adptMenu=function(menu){
			var tWidth=80;
			var maxWidth=80;
			var i=0,len=menu.numChildren;
			for (i=0;i < len;i++){
				tWidth=(menu.getChildAt(i)).width;
				if (maxWidth < tWidth){
					maxWidth=tWidth;
				}
			}
			for (i=0;i < len;i++){
				(menu.getChildAt(i)).width=maxWidth;
			}
		}

		ContextMenu._menuList=[];
		return ContextMenu;
	})(Box)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.uicomps.ContextMenuItem extends laya.ui.Button
	var ContextMenuItem=(function(_super){
		function ContextMenuItem(txt,isSeparator){
			this.data=null;
			this.img=null;
			ContextMenuItem.__super.call(this);
			if(!this.img)this.img=new Image();
			if(txt!=""){
				this.label=txt;
				this.name=txt;
				}else{
				this.label="------";
				this.height=5;
				this.mouseEnabled=false;
				this.img.skin=Base64AtlasManager.base64.getAdptUrl("comp/line2.png");
				this.img.sizeGrid="0,2,0,2";
				this.addChild(this.img);
			}
			this.labelColors="#000000,#000000,#000000,#000000";
			this._text.x=10;
			this._text.padding=[-2,0,0,0];
			this._text.align="left";
			this._text.wordWrap=false;
			this._text.typeset();
			this.width=this._text.width+25;
			this.sizeGrid="3,3,3,3";
			this.skin=Base64AtlasManager.base64.getAdptUrl("comp/button1.png");
		}

		__class(ContextMenuItem,'laya.debug.uicomps.ContextMenuItem',_super);
		var __proto=ContextMenuItem.prototype;
		__getset(0,__proto,'width',_super.prototype._$get_width,function(v){
			_super.prototype._$set_width.call(this,v);
			this.img.width=this.width;
			this.img.x=0;
		});

		return ContextMenuItem;
	})(Button)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.CacheRankView extends laya.debug.view.nodeInfo.views.UIViewBase
	var CacheRankView=(function(_super){
		function CacheRankView(){
			this.view=null;
			CacheRankView.__super.call(this);
		}

		__class(CacheRankView,'laya.debug.view.nodeInfo.views.CacheRankView',_super);
		var __proto=CacheRankView.prototype;
		__proto.createPanel=function(){
			this.view=new Rank();
			this.view.top=this.view.bottom=this.view.left=this.view.right=0;
			this.addChild(this.view);
			NodeMenu.I.setNodeListAction(this.view.itemList);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.freshBtn.on(/*laya.events.Event.CLICK*/"click",this,this.fresh);
			this.view.itemList.scrollBar.hide=true;
			this.view.autoUpdate.on(/*laya.events.Event.CHANGE*/"change",this,this.onAutoUpdateChange);
			this.dis=this;
			this.view.itemList.array=[];
			this.onAutoUpdateChange();
			this.fresh();
		}

		__proto.onRightClick=function(){
			var list;
			list=this.view.itemList;
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
			}
		}

		__proto.onAutoUpdateChange=function(){
			this.autoUpdate=this.view.autoUpdate.selected;
		}

		__proto.fresh=function(){
			CacheAnalyser.counter.updates();
			this.view.title.text="ReCache排行";
			if (!DebugTool.enableCacheAnalyse){
				this.view.title.text="ReCache排行(未开启)";
				this.view.title.toolTip="DebugTool.init(true)可开启该功能";
			};
			var nodeDic;
			nodeDic=CacheAnalyser.counter.resultNodeDic;
			var key;
			var tNode;
			var tData;
			var dataList;
			dataList=[];
			for (key in nodeDic){
				tNode=nodeDic[key];
				if (CacheRankView.filterDebugNodes && DisControlTool.isInTree(DebugInfoLayer.I,tNode))continue ;
				if (CacheAnalyser.counter.getCount(tNode)<=0)continue ;
				tData={};
				tData.time=CacheAnalyser.counter.getCount(tNode);
				tData.path=tNode;
				tData.label=ClassTool.getNodeClassAndName(tNode)+":"+tData.time;
				dataList.push(tData);
			}
			dataList.sort(MathTools.sortByKey("time",true,true));
			this.view.itemList.array=dataList;
		}

		__getset(0,__proto,'autoUpdate',null,function(v){
			Laya.timer.clear(this,this.fresh);
			if (v){
				this.fresh();
				Laya.timer.loop(NodeConsts.RenderCostMaxTime,this,this.fresh);
			}
		});

		__getset(1,CacheRankView,'I',function(){
			if (!CacheRankView._I)
				CacheRankView._I=new CacheRankView();
			return CacheRankView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		CacheRankView._I=null
		CacheRankView.filterDebugNodes=true;
		return CacheRankView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.DebugPanelView extends laya.debug.view.nodeInfo.views.UIViewBase
	var DebugPanelView=(function(_super){
		function DebugPanelView(){
			this.view=null;
			this.dragIcon=null;
			this.tSelectTar=null;
			this._selectTip=new Sprite();
			DebugPanelView.__super.call(this);
			this._selectTip.setBounds(new Rectangle(0,0,0,0));
		}

		__class(DebugPanelView,'laya.debug.view.nodeInfo.views.DebugPanelView',_super);
		var __proto=DebugPanelView.prototype;
		__proto.createPanel=function(){
			this.view=new DebugPanel();
			this.dis=this.view;
			this.view.minBtn.minHandler=this.minHandler;
			this.view.minBtn.maxHandler=this.maxHandler;
			this.view.minBtn.tar=this.view;
			DisControlTool.setDragingItem(this.view.bg,this.view);
			DisControlTool.setDragingItem(this.view.tab,this.view);
			DisControlTool.setDragingItem(this.view.clearBtn,this.view);
			this.clickSelectChange();
			this.view.selectWhenClick.on(/*laya.events.Event.CHANGE*/"change",this,this.clickSelectChange);
			Notice.listen(/*laya.debug.tools.DisplayHook.ITEM_CLICKED*/"ItemClicked",this,this.itemClicked);
			StyleConsts.setViewScale(this.view);
			this.dragIcon=this.view.dragIcon;
			this.dragIcon.removeSelf();
			this.view.mouseAnalyseBtn.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.mouseAnalyserMouseDown);
			this.dragIcon.on(/*laya.events.Event.DRAG_END*/"dragend",this,this.mouseAnalyserDragEnd);
			this.view.clearBtn.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.clearBtnClick);
		}

		__proto.clearBtnClick=function(){
			DebugTool.clearDebugLayer();
		}

		__proto.mouseAnalyserMouseDown=function(){
			var gPos=DebugPanelView.tempPos;
			gPos.setTo(0,0);
			gPos=this.view.mouseAnalyseBtn.localToGlobal(gPos);
			this.dragIcon.pos(gPos.x,gPos.y);
			this.dragIcon.mouseEnabled=false;
			Laya.stage.addChild(this.dragIcon);
			this.dragIcon.startDrag();
		}

		__proto.mouseAnalyserDragEnd=function(){
			this.dragIcon.removeSelf();
			this.selectTarget(DisplayHook.instance.getDisUnderMouse());
			NodeToolView.I.showByNode(DisplayHook.instance.getDisUnderMouse(),false);
		}

		//}
		__proto.switchToTree=function(){
			this.view.tab.selectedIndex=0;
		}

		__proto.swichToSelect=function(){
			this.view.tab.selectedIndex=1;
		}

		__proto.itemClicked=function(tar){
			if (!DebugPanelView.isClickSelectState)return;
			if (DebugPanelView.ignoreDebugTool){
				if (DebugInfoLayer.I.isDebugItem(tar))return;
			}
			if ((tar instanceof laya.debug.uicomps.ContextMenuItem )|| (tar.parent instanceof laya.debug.uicomps.ContextMenuItem )){
				return;
			}
			ToolPanel.I.showSelectInStage(tar);
			NodeToolView.I.showByNode(tar,false);
			this.view.selectWhenClick.selected=false;
			DebugTool.showDisBound(tar);
			this.clickSelectChange();
		}

		__proto.selectTarget=function(tar){
			if (!tar)return;
			ToolPanel.I.showSelectInStage(tar);
			DebugTool.showDisBound(tar);
		}

		__proto.clickSelectChange=function(){
			DebugPanelView.isClickSelectState=this.view.selectWhenClick.selected;
			if (!Browser.onPC)return;
			this.tSelectTar=null;
			this.clearSelectTip();
			if (DebugPanelView.isClickSelectState){
				Laya.timer.loop(200,this,this.updateSelectTar,null,true);
				}else{
				Laya.timer.clear(this,this.updateSelectTar);
			}
		}

		__proto.clearSelectTip=function(){
			this._selectTip.removeSelf();
		}

		__proto.updateSelectTar=function(){
			this.clearSelectTip();
			this.tSelectTar=DisplayHook.instance.getDisUnderMouse();
			if (!this.tSelectTar){
				return;
			}
			if (DebugInfoLayer.I.isDebugItem(this.tSelectTar))return;
			var g;
			g=this._selectTip.graphics;
			g.clear();
			var rec;
			rec=NodeUtils.getGRec(this.tSelectTar);
			DebugInfoLayer.I.popLayer.addChild(this._selectTip);
			g.drawRect(0,0,rec.width,rec.height,null,"#00ffff",2);
			this._selectTip.pos(rec.x,rec.y);
		}

		__getset(1,DebugPanelView,'I',function(){
			if (!DebugPanelView._I)DebugPanelView._I=new DebugPanelView();
			return DebugPanelView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		DebugPanelView._I=null
		DebugPanelView.ignoreDebugTool=true;
		DebugPanelView.isClickSelectState=false;
		__static(DebugPanelView,
		['tempPos',function(){return this.tempPos=new Point();}
		]);
		return DebugPanelView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.FilterView extends laya.debug.view.nodeInfo.views.UIViewBase
	var FilterView=(function(_super){
		function FilterView(){
			this.input=null;
			FilterView.__super.call(this);
		}

		__class(FilterView,'laya.debug.view.nodeInfo.views.FilterView',_super);
		var __proto=FilterView.prototype;
		__proto.createPanel=function(){
			this.input=new Input();
			this.input.size(400,500);
			this.input.multiline=true;
			this.input.bgColor="#ff00ff";
			this.input.fontSize=24;
			this.addChild(this.input);
		}

		__proto.show=function(){
			this.input.text=NodeInfosItem.showValues.join("\n");
			_super.prototype.show.call(this);
		}

		__proto.close=function(){
			_super.prototype.close.call(this);
			NodeInfosItem.showValues=this.input.text.split("\n");
		}

		return FilterView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.FindSmallView extends laya.debug.view.nodeInfo.views.UIViewBase
	var FindSmallView=(function(_super){
		function FindSmallView(){
			this.view=null;
			FindSmallView.__super.call(this);
		}

		__class(FindSmallView,'laya.debug.view.nodeInfo.views.FindSmallView',_super);
		var __proto=FindSmallView.prototype;
		__proto.createPanel=function(){
			this.view=new FindNodeSmall();
			StyleConsts.setViewScale(this.view);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			this.view.typeSelect.selectedIndex=1;
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.findBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onFind);
			this.dis=this.view;
		}

		__proto.onFind=function(){
			var key;
			key=this.view.findTxt.text;
			key=StringTool.trimSide(key);
			var nodeList;
			if (this.view.typeSelect.selectedIndex==0){
				nodeList=DebugTool.findNameHas(key,false);
				}else{
				nodeList=DebugTool.findClassHas(Laya.stage,key);
			}
			ToolPanel.I.showSelectItems(nodeList);
			this.close();
		}

		__getset(1,FindSmallView,'I',function(){
			if (!FindSmallView._I)FindSmallView._I=new FindSmallView();
			return FindSmallView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		FindSmallView._I=null
		return FindSmallView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.FindView extends laya.debug.view.nodeInfo.views.UIViewBase
	var FindView=(function(_super){
		function FindView(){
			this.view=null;
			FindView.__super.call(this);
		}

		__class(FindView,'laya.debug.view.nodeInfo.views.FindView',_super);
		var __proto=FindView.prototype;
		__proto.createPanel=function(){
			this.view=new FindNode();
			DisControlTool.setDragingItem(this.view.bg,this.view);
			this.view.result.scrollBar.hide=true;
			this.view.result.array=[];
			this.view.typeSelect.selectedIndex=1;
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.findBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onFind);
			NodeMenu.I.setNodeListAction(this.view.result);
			this.dis=this.view;
		}

		__proto.onRightClick=function(){
			var list;
			list=this.view.result;
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
			}
		}

		//}
		__proto.onFind=function(){
			var key;
			key=this.view.findTxt.text;
			key=StringTool.trimSide(key);
			var nodeList;
			if (this.view.typeSelect.selectedIndex==0){
				nodeList=DebugTool.findNameHas(key,false);
				}else{
				nodeList=DebugTool.findClassHas(Laya.stage,key);
			}
			this.showFindResult(nodeList);
		}

		__proto.showFindResult=function(nodeList){
			if (!nodeList)return;
			var i=0,len=0;
			len=nodeList.length;
			var showList;
			showList=[];
			var tData;
			var tSprite;
			for (i=0;i < len;i++){
				tSprite=nodeList[i];
				tData={};
				tData.label=ClassTool.getNodeClassAndName(tSprite);
				tData.path=tSprite;
				showList.push(tData);
			}
			this.view.result.array=showList;
		}

		__getset(1,FindView,'I',function(){
			if (!FindView._I)FindView._I=new FindView();
			return FindView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		FindView._I=null
		return FindView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.NodeListPanelView extends laya.debug.view.nodeInfo.views.UIViewBase
	var NodeListPanelView=(function(_super){
		function NodeListPanelView(){
			this.view=null;
			NodeListPanelView.__super.call(this);
		}

		__class(NodeListPanelView,'laya.debug.view.nodeInfo.views.NodeListPanelView',_super);
		var __proto=NodeListPanelView.prototype;
		__proto.createPanel=function(){
			this.view=new NodeListPanel();
			this.addChild(this.view);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			NodeMenu.I.setNodeListAction(this.view.itemList);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.itemList.scrollBar.hide=true;
			this.dis=this;
			this.view.itemList.array=[];
		}

		//fresh();
		__proto.showList=function(list){
			this.view.itemList.array=list;
			this.show();
		}

		__getset(1,NodeListPanelView,'I',function(){
			if (!NodeListPanelView._I)
				NodeListPanelView._I=new NodeListPanelView();
			return NodeListPanelView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		NodeListPanelView._I=null
		NodeListPanelView.filterDebugNodes=true;
		return NodeListPanelView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.NodeToolView extends laya.debug.view.nodeInfo.views.UIViewBase
	var NodeToolView=(function(_super){
		function NodeToolView(){
			this.view=null;
			this.dragIcon=null;
			this._tar=null;
			NodeToolView.__super.call(this);
		}

		__class(NodeToolView,'laya.debug.view.nodeInfo.views.NodeToolView',_super);
		var __proto=NodeToolView.prototype;
		__proto.show=function(){
			this.showByNode();
		}

		__proto.createPanel=function(){
			this.view=new NodeTool();
			this.addChild(this.view);
			this.view.on(/*laya.events.Event.CLICK*/"click",this,this.onBtnClick);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onCloseBtn);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			this.dis=this.view;
			this.view.freshBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onFreshBtn);
			this.dragIcon=this.view.dragIcon;
			this.dragIcon.removeSelf();
			this.dragIcon.on(/*laya.events.Event.DRAG_END*/"dragend",this,this.mouseAnalyserDragEnd);
			this.view.mouseAnalyseBtn.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.mouseAnalyserMouseDown);
		}

		__proto.mouseAnalyserMouseDown=function(){
			var gPos=NodeToolView.tempPos;
			gPos.setTo(0,0);
			gPos=this.view.mouseAnalyseBtn.localToGlobal(gPos);
			this.dragIcon.pos(gPos.x,gPos.y);
			this.dragIcon.mouseEnabled=false;
			Laya.stage.addChild(this.dragIcon);
			this.dragIcon.startDrag();
		}

		__proto.mouseAnalyserDragEnd=function(){
			this.dragIcon.removeSelf();
			if (laya.debug.view.nodeInfo.views.NodeToolView.I.target){
				MouseEventAnalyser.analyseNode(laya.debug.view.nodeInfo.views.NodeToolView.I.target);
			}
		}

		__proto.onFreshBtn=function(){
			if (!this._tar)return;
			this._tar.reCache();
			this._tar.repaint();
		}

		__proto.onCloseBtn=function(){
			this.close();
		}

		__proto.onBtnClick=function(e){
			if (!this._tar)return;
			var tar;
			tar=e.target;
			console.log("onBtnClick:",tar);
			var txt;
			txt=(tar).label;
			switch(txt){
				case "父链":
					DebugTool.showParentChain(this._tar);
					SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
					break ;
				case "子":
					DebugTool.showAllChild(this._tar);
					SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
					break ;
				case "兄弟":
					DebugTool.showAllBrother(this._tar);
					SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
					break ;
				case "Enable链":
					OutPutView.I.dTrace(DebugTool.traceDisMouseEnable(this._tar));
					SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
					break ;
				case "Size链":
					OutPutView.I.dTrace(DebugTool.traceDisSizeChain(this._tar));
					SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
					break ;
				case "隐藏旁支":
					NodeInfoPanel.I.recoverNodes();
					NodeInfoPanel.I.hideOtherChain(this._tar);
					break ;
				case "隐藏兄弟":
					NodeInfoPanel.I.recoverNodes();
					NodeInfoPanel.I.hideBrothers(this._tar);
					break ;
				case "隐藏子":
					NodeInfoPanel.I.recoverNodes();
					NodeInfoPanel.I.hideChilds(this._tar);
					break ;
				case "恢复":
					NodeInfoPanel.I.recoverNodes();
					break ;
				case "节点树定位":
					ToolPanel.I.showSelectInStage(this._tar);
					break ;
				case "显示边框":
					DebugTool.showDisBound(this._tar);
					break ;
				case "输出到控制台":
					console.log(this._tar);
					break ;
				case "显示切换":
					this._tar.visible=!this._tar.visible;
					break ;
				}
		}

		__proto.showByNode=function(node,ifShow){
			(ifShow===void 0)&& (ifShow=true);
			if (!node)node=Laya.stage;
			if(ifShow)
				_super.prototype.show.call(this);
			this._tar=node;
			this.fresh();
		}

		__proto.fresh=function(){
			if (!this._tar)return;
			this.view.tarTxt.text=ClassTool.getNodeClassAndName(this._tar);
		}

		__getset(0,__proto,'target',function(){
			return this._tar;
		});

		__getset(1,NodeToolView,'I',function(){
			if (!NodeToolView._I)NodeToolView._I=new NodeToolView();
			return NodeToolView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		NodeToolView._I=null
		__static(NodeToolView,
		['tempPos',function(){return this.tempPos=new Point();}
		]);
		return NodeToolView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.NodeTreeSettingView extends laya.debug.view.nodeInfo.views.UIViewBase
	var NodeTreeSettingView=(function(_super){
		function NodeTreeSettingView(){
			this.view=null;
			this._handler=null;
			NodeTreeSettingView.__super.call(this);
		}

		__class(NodeTreeSettingView,'laya.debug.view.nodeInfo.views.NodeTreeSettingView',_super);
		var __proto=NodeTreeSettingView.prototype;
		__proto.createPanel=function(){
			_super.prototype.createPanel.call(this);
			this.view=new NodeTreeSetting();
			StyleConsts.setViewScale(this.view);
			this.addChild(this.view);
			this.inits();
			this.dis=this.view;
		}

		__proto.show=function(){
			_super.prototype.show.call(this);
		}

		__proto.showSetting=function(filters,callBack,tar){
			if ((tar instanceof laya.display.Node )){
				this.view.showTxt.text=NodeConsts.defaultFitlerStr.split(",").join("\n");
				}else{
				this.view.showTxt.text=filters.join("\n");
			}
			this._handler=callBack;
			this.show();
		}

		__proto.inits=function(){
			this.view.okBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onOkBtn);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onCloseBtn);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			this.dis=this.view;
		}

		__proto.onCloseBtn=function(){
			this.close();
		}

		__proto.onOkBtn=function(){
			this.close();
			var showArr;
			showArr=this.view.showTxt.text.split("\n");
			if (this._handler){
				this._handler.runWith([showArr]);
				this._handler=null
			}
		}

		__getset(1,NodeTreeSettingView,'I',function(){
			if (!NodeTreeSettingView._I)NodeTreeSettingView._I=new NodeTreeSettingView();
			return NodeTreeSettingView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		NodeTreeSettingView._I=null
		return NodeTreeSettingView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.NodeTreeView extends laya.debug.view.nodeInfo.views.UIViewBase
	var NodeTreeView=(function(_super){
		function NodeTreeView(){
			this.nodeTree=null;
			NodeTreeView.__super.call(this);
		}

		__class(NodeTreeView,'laya.debug.view.nodeInfo.views.NodeTreeView',_super);
		var __proto=NodeTreeView.prototype;
		__proto.show=function(){
			this.showByNode();
		}

		__proto.showByNode=function(node){
			if (!node)node=Laya.stage;
			this.nodeTree.setDis(node);
		}

		//super.show();
		__proto.createPanel=function(){
			_super.prototype.createPanel.call(this);
			if (!this.nodeTree)this.nodeTree=new NodeTree();
			this.dis=null;
			var view;
			view=this.nodeTree;
			view.top=view.bottom=view.left=view.right=0;
			this.addChild(view);
			this.showByNode(Laya.stage);
		}

		__proto.showSelectInStage=function(node){
			this.showByNode(Laya.stage);
			this.nodeTree.selectByNode(node);
		}

		return NodeTreeView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.ObjectCreateView extends laya.debug.view.nodeInfo.views.UIViewBase
	var ObjectCreateView=(function(_super){
		function ObjectCreateView(){
			this.view=null;
			this._menu=null;
			this._menuItems=["统计详情","增量详情"];
			this._tSelectKey=null;
			this.preInfo={};
			ObjectCreateView.__super.call(this);
			ObjectCreateView._I=this;
		}

		__class(ObjectCreateView,'laya.debug.view.nodeInfo.views.ObjectCreateView',_super);
		var __proto=ObjectCreateView.prototype;
		__proto.createPanel=function(){
			this.view=new ObjectCreate();
			this.view.top=this.view.bottom=this.view.left=this.view.right=0;
			this.addChild(this.view);
			this.view.itemList.on(DebugTool.getMenuShowEvent(),this,this.onRightClick);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.freshBtn.on(/*laya.events.Event.CLICK*/"click",this,this.fresh);
			this.view.itemList.scrollBar.hide=true;
			this._menu=ContextMenu.createMenuByArray(this._menuItems);
			this._menu.on(/*laya.events.Event.SELECT*/"select",this,this.onEmunSelect);
			this.fresh();
		}

		__proto.onEmunSelect=function(e){
			if (!this._tSelectKey)return;
			var data=(e.target).data;
			if ((typeof data=='string')){
				var key;
				key=data;
				var count;
				switch (key){
					case "统计详情":
						count=RunProfile.getRunInfo(this._tSelectKey);
						if (count){
							OutPutView.I.showTxt(this._tSelectKey+" createInfo:\n"+count.traceSelfR());
						}
						break ;
					case "增量详情":
						count=RunProfile.getRunInfo(this._tSelectKey);
						if (count){
							OutPutView.I.showTxt(this._tSelectKey+" createInfo:\n"+count.traceSelfR(count.changeO));
						}
						break ;
					}
			}
		}

		__proto.onRightClick=function(){
			var list;
			list=this.view.itemList;
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				this._tSelectKey=tarNode;
				if (this._tSelectKey){
					this._menu.show();
				}
			}
		}

		__proto.show=function(){
			this.fresh();
		}

		__proto.fresh=function(){
			var dataO;
			dataO=ClassCreateHook.I.createInfo;
			var key;
			var dataList;
			dataList=[];
			var tData;
			var count;
			for (key in dataO){
				if (!this.preInfo[key])
					this.preInfo[key]=0;
				tData={};
				tData.path=key;
				tData.count=dataO[key];
				tData.add=dataO[key]-this.preInfo[key];
				if (tData.add > 0){
					tData.label=key+":"+dataO[key]+" +"+tData.add;
				}
				else{
					tData.label=key+":"+dataO[key];
				}
				count=RunProfile.getRunInfo(key);
				if (count){
					count.record();
				}
				tData.rank=tData.add *1000+tData.count;
				this.preInfo[key]=dataO[key];
				dataList.push(tData);
			}
			dataList.sort(MathTools.sortByKey("rank",true,true));
			this.view.itemList.array=dataList;
		}

		__getset(1,ObjectCreateView,'I',function(){
			if (!ObjectCreateView._I)
				ObjectCreateView._I=new ObjectCreateView();
			return ObjectCreateView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		ObjectCreateView._I=null
		return ObjectCreateView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.ObjectInfoView extends laya.debug.view.nodeInfo.views.UIViewBase
	var ObjectInfoView=(function(_super){
		function ObjectInfoView(){
			this.view=null;
			this.showKeys=["x","y","width","height","renderCost"];
			this._closeSettingHandler=null;
			this._tar=null;
			ObjectInfoView.__super.call(this);
		}

		__class(ObjectInfoView,'laya.debug.view.nodeInfo.views.ObjectInfoView',_super);
		var __proto=ObjectInfoView.prototype;
		__proto.createPanel=function(){
			_super.prototype.createPanel.call(this);
			this.view=new ObjectInfo();
			StyleConsts.setViewScale(this.view);
			this.addChild(this.view);
			this.inits();
		}

		__proto.inits=function(){
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.settingBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onSettingBtn);
			this.view.autoUpdate.on(/*laya.events.Event.CHANGE*/"change",this,this.onAutoUpdateChange);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			DisControlTool.setResizeAbleEx(this.view);
			this._closeSettingHandler=new Handler(this,this.closeSetting);
			this.dis=this.view;
		}

		__proto.onAutoUpdateChange=function(){
			this.autoUpdate=this.view.autoUpdate.selected;
		}

		__proto.onSettingBtn=function(){
			NodeTreeSettingView.I.showSetting(this.showKeys,this._closeSettingHandler,this._tar);
		}

		__proto.reset=function(){
			this.showKeys=["x","y","width","height","renderCost"];
		}

		__proto.closeSetting=function(newKeys){
			this.showKeys=newKeys;
			this.fresh();
		}

		__proto.showObjectInfo=function(obj){
			this._tar=obj;
			this.fresh();
			this.show();
			this.onAutoUpdateChange();
		}

		__proto.fresh=function(){
			if (!this._tar){
				this.view.showTxt.text="";
				this.view.title.text="未选中对象";
			}
			else{
				this.view.title.text=ClassTool.getNodeClassAndName(this._tar);
				this.view.showTxt.text=ObjectInfoView.getObjValueStr(this._tar,this.showKeys,false);
			}
		}

		__proto.freshKeyInfos=function(){
			this.fresh();
		}

		__proto.close=function(){
			_super.prototype.close.call(this);
			this.autoUpdate=false;
			Pool.recover("ObjectInfoView",this);
		}

		__proto.show=function(){
			_super.prototype.show.call(this);
		}

		__getset(0,__proto,'autoUpdate',null,function(v){
			Laya.timer.clear(this,this.freshKeyInfos);
			if (v){
				Laya.timer.loop(2000,this,this.freshKeyInfos);
			}
		});

		ObjectInfoView.getObjValueStr=function(obj,keys,withTitle){
			(withTitle===void 0)&& (withTitle=true);
			var i=0,len=0;
			var tKey;
			ObjectInfoView._txts.length=0;
			len=keys.length;
			if (withTitle){
				if (obj.name){
					ObjectInfoView._txts.push(ClassTool.getClassName(obj)+"("+obj.name+")");
				}
				else{
					ObjectInfoView._txts.push(ClassTool.getClassName(obj));
				}
			}
			for (i=0;i < len;i++){
				tKey=keys[i];
				ObjectInfoView._txts.push(tKey+":"+ObjectInfoView.getNodeValue(obj,tKey));
			}
			return ObjectInfoView._txts.join("\n");
		}

		ObjectInfoView.getNodeValue=function(node,key){
			var rst;
			if ((node instanceof laya.display.Sprite )){
				var tNode;
				tNode=node;
				switch (key){
					case "gRec":
						rst=NodeUtils.getGRec(tNode).toString();
						break ;
					case "gAlpha":
						rst=NodeUtils.getGAlpha(tNode)+"";
						break ;
					case "cmdCount":
						rst=NodeUtils.getNodeCmdCount(tNode)+"";
						break ;
					case "cmdAll":
						rst=NodeUtils.getNodeCmdTotalCount(tNode)+"";
						break ;
					case "nodeAll":
						rst=""+NodeUtils.getNodeCount(tNode);
						break ;
					case "nodeRender":
						rst=""+NodeUtils.getRenderNodeCount(tNode);
						break ;
					case "nodeReCache":
						rst=""+NodeUtils.getReFreshRenderNodeCount(tNode);
						break ;
					case "renderCost":
						rst=""+RenderAnalyser.I.getTime(tNode);
						break ;
					case "renderCount":
						rst=""+RenderAnalyser.I.getCount(tNode);
						break ;
					default :
						rst=node[key]+"";
					}
			}
			else{
				rst=node[key]+"";
			}
			return rst;
		}

		ObjectInfoView.showObject=function(obj){
			var infoView;
			infoView=Pool.getItemByClass("ObjectInfoView",ObjectInfoView);
			infoView.reset();
			infoView.showObjectInfo(obj);
		}

		ObjectInfoView._txts=[];
		return ObjectInfoView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.OutPutView extends laya.debug.view.nodeInfo.views.UIViewBase
	var OutPutView=(function(_super){
		function OutPutView(){
			this.view=null;
			OutPutView.__super.call(this);
			DebugTool._logFun=OutPutView.log;
		}

		__class(OutPutView,'laya.debug.view.nodeInfo.views.OutPutView',_super);
		var __proto=OutPutView.prototype;
		__proto.createPanel=function(){
			this.view=new OutPut();
			DisControlTool.setDragingItem(this.view.txt,this.view);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			StyleConsts.setViewScale(this.view);
			this.view.txt.textField.overflow=Text.SCROLL;
			this.view.txt.textField.wordWrap=true;
			this.view.on(/*laya.events.Event.MOUSE_WHEEL*/"mousewheel",this,this.mouseWheel);
			this.view.txt.text="";
			DisControlTool.setResizeAbleEx(this.view);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.clearBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onClearBtn);
			this.dis=this.view;
		}

		__proto.onClearBtn=function(){
			this.clearText();
		}

		__proto.mouseWheel=function(e){
			this.view.txt.textField.scrollY-=e.delta*10;
		}

		__proto.showTxt=function(str){
			this.view.txt.text=str;
			this.show();
			this.view.txt.textField.scrollY=this.view.txt.textField.maxScrollY;
		}

		__proto.clearText=function(){
			this.view.txt.text="";
		}

		__proto.dTrace=function(__arg){
			var arg=arguments;
			if (this.view.txt.textField.scrollY > 1000){
				this.view.txt.text="";
			};
			var str;
			var i=0,len=0;
			len=arg.length;
			str=arg[0];
			for (i=1;i < len;i++){
				str+=" "+arg[i];
			}
			this.addStr(str);
		}

		__proto.addStr=function(str){
			this.view.txt.text+="\n"+str;
			this.show();
			this.view.txt.textField.scrollY=this.view.txt.textField.maxScrollY;
		}

		__getset(1,OutPutView,'I',function(){
			if (!OutPutView._I)OutPutView._I=new OutPutView();
			return OutPutView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		OutPutView.log=function(str){
			OutPutView.I.addStr(str);
		}

		OutPutView._I=null
		return OutPutView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.RenderCostRankView extends laya.debug.view.nodeInfo.views.UIViewBase
	var RenderCostRankView=(function(_super){
		function RenderCostRankView(){
			this.view=null;
			RenderCostRankView.__super.call(this);
		}

		__class(RenderCostRankView,'laya.debug.view.nodeInfo.views.RenderCostRankView',_super);
		var __proto=RenderCostRankView.prototype;
		__proto.createPanel=function(){
			this.view=new Rank();
			this.view.top=this.view.bottom=this.view.left=this.view.right=0;
			this.addChild(this.view);
			NodeMenu.I.setNodeListAction(this.view.itemList);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.freshBtn.on(/*laya.events.Event.CLICK*/"click",this,this.fresh);
			this.view.itemList.scrollBar.hide=true;
			this.view.autoUpdate.on(/*laya.events.Event.CHANGE*/"change",this,this.onAutoUpdateChange);
			this.dis=this;
			this.view.itemList.array=[];
			this.onAutoUpdateChange();
			this.fresh();
			Laya.timer.once(5000,this,this.fresh);
		}

		__proto.onRightClick=function(){
			var list;
			list=this.view.itemList;
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
			}
		}

		__proto.onAutoUpdateChange=function(){
			this.autoUpdate=this.view.autoUpdate.selected;
		}

		__proto.fresh=function(){
			this.view.title.text="渲染用时排行("+NodeConsts.RenderCostMaxTime+"ms)";
			var nodeDic;
			nodeDic=RenderAnalyser.I.nodeDic;
			var key;
			var tNode;
			var tData;
			var dataList;
			dataList=[];
			for (key in nodeDic){
				tNode=nodeDic[key];
				if (RenderCostRankView.filterDebugNodes && DisControlTool.isInTree(DebugInfoLayer.I,tNode))continue ;
				if (RenderAnalyser.I.getTime(tNode)<=0)continue ;
				tData={};
				tData.time=RenderAnalyser.I.getTime(tNode);
				if (RenderCostRankView.filterDebugNodes && tNode==Laya.stage){
					tData.time-=RenderAnalyser.I.getTime(DebugInfoLayer.I);
				}
				tData.path=tNode;
				tData.label=ClassTool.getNodeClassAndName(tNode)+":"+tData.time;
				dataList.push(tData);
			}
			dataList.sort(MathTools.sortByKey("time",true,true));
			this.view.itemList.array=dataList;
		}

		__getset(0,__proto,'autoUpdate',null,function(v){
			Laya.timer.clear(this,this.fresh);
			if (v){
				this.fresh();
				Laya.timer.loop(NodeConsts.RenderCostMaxTime,this,this.fresh);
			}
		});

		__getset(1,RenderCostRankView,'I',function(){
			if (!RenderCostRankView._I)
				RenderCostRankView._I=new RenderCostRankView();
			return RenderCostRankView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		RenderCostRankView._I=null
		RenderCostRankView.filterDebugNodes=true;
		return RenderCostRankView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.SelectInfosView extends laya.debug.view.nodeInfo.views.UIViewBase
	var SelectInfosView=(function(_super){
		function SelectInfosView(){
			this.showKeys=[];
			this.view=null;
			this.fliterTxt=null;
			this.itemList=null;
			SelectInfosView.__super.call(this);
			SelectInfosView._I=this;
			this.setSelectList(null);
		}

		__class(SelectInfosView,'laya.debug.view.nodeInfo.views.SelectInfosView',_super);
		var __proto=SelectInfosView.prototype;
		__proto.createPanel=function(){
			this.view=new SelectInfos();
			this.addChild(this.view);
			this.view.top=this.view.bottom=this.view.left=this.view.right=0;
			NodeMenu.I.setNodeListAction(this.view.selectList);
			this.view.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.close);
			this.view.selectList.scrollBar.hide=true;
			this.dis=null;
			this.view.findBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onFindBtn);
			this.fliterTxt=this.view.fliterTxt;
			this.view.fliterTxt.on(/*laya.events.Event.ENTER*/"enter",this,this.onFliterTxtChange);
			this.view.fliterTxt.on(/*laya.events.Event.BLUR*/"blur",this,this.onFliterTxtChange);
		}

		__proto.onFliterTxtChange=function(e){
			var key;
			key=this.fliterTxt.text;
			if (key==""){
				if (this.showKeys.length !=0){
					this.showKeys.length=0;
					this.fresh();
				}
			}else
			if (key !=this.showKeys.join(",")){
				this.showKeys=key.split(",");
				this.fresh();
			}
		}

		__proto.onFindBtn=function(){
			FindSmallView.I.show();
		}

		__proto.onRightClick=function(){
			var list;
			list=this.view.selectList;
			if (list.selectedItem){
				var tarNode;
				tarNode=list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
			}
		}

		//}
		__proto.setSelectTarget=function(node){
			if (!node)return;
			this.setSelectList([node]);
		}

		__proto.setSelectList=function(list){
			this.itemList=list;
			this.fresh();
		}

		//show();
		__proto.fresh=function(){
			var list;
			list=this.itemList;
			if (!list || list.length < 1){
				this.view.selectList.array=[];
				return;
			};
			var i=0,len=0;
			var tDis;
			var tData;
			len=list.length;
			var disList;
			disList=[];
			for (i=0;i < len;i++){
				tDis=list[i];
				tData={};
				tData.label=this.getLabelTxt(tDis);
				tData.path=tDis;
				disList.push(tData);
			}
			this.view.selectList.array=disList;
		}

		__proto.getLabelTxt=function(item){
			var rst;
			rst=ClassTool.getNodeClassAndName(item);
			var i=0,len=0;
			len=this.showKeys.length;
			for (i=0;i < len;i++){
				rst+=","+ObjectInfoView.getNodeValue(item,this.showKeys[i]);
			}
			return rst;
		}

		__getset(1,SelectInfosView,'I',function(){
			if (!SelectInfosView._I)SelectInfosView._I=new SelectInfosView();
			return SelectInfosView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		SelectInfosView._I=null
		return SelectInfosView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.ToolBarView extends laya.debug.view.nodeInfo.views.UIViewBase
	var ToolBarView=(function(_super){
		function ToolBarView(){
			this.view=null;
			ToolBarView.__super.call(this);
		}

		__class(ToolBarView,'laya.debug.view.nodeInfo.views.ToolBarView',_super);
		var __proto=ToolBarView.prototype;
		__proto.createPanel=function(){
			this.view=new ToolBar();
			this.addChild(this.view);
			DisControlTool.setDragingItem(this.view.bg,this.view);
			this.view.on(/*laya.events.Event.CLICK*/"click",this,this.onBtnClick);
			this.view.minBtn.minHandler=this.minHandler;
			this.view.minBtn.maxHandler=this.maxHandler;
			this.view.minBtn.tar=this.view;
			this.clickSelectChange();
			this.view.selectWhenClick.on(/*laya.events.Event.CHANGE*/"change",this,this.clickSelectChange);
			Notice.listen(/*laya.debug.tools.DisplayHook.ITEM_CLICKED*/"ItemClicked",this,this.itemClicked);
			this.dis=this.view;
		}

		__proto.itemClicked=function(tar){
			if (!ToolBarView.isClickSelectState)return;
			if (DisControlTool.isInTree(this.view.selectWhenClick,tar))return;
			if (ToolBarView.ignoreDebugTool){
				if (DebugInfoLayer.I.isDebugItem(tar))return;
			}
		}

		__proto.clickSelectChange=function(){
			ToolBarView.isClickSelectState=this.view.selectWhenClick.selected;
		}

		__proto.firstShowFun=function(){
			this.dis.x=Laya.stage.width-this.dis.width-20;
			this.dis.y=5;
		}

		__proto.onBtnClick=function(e){
			switch(e.target){
				case this.view.treeBtn:
					ToolPanel.I.switchShow(/*laya.debug.view.nodeInfo.ToolPanel.Tree*/"Tree");
					break ;
				case this.view.findBtn:
					ToolPanel.I.switchShow(/*laya.debug.view.nodeInfo.ToolPanel.Find*/"Find");
					break ;
				case this.view.clearBtn:
					DebugTool.clearDebugLayer();
					break ;
				case this.view.rankBtn:
					RenderCostRankView.I.show();
					break ;
				case this.view.nodeRankBtn:
					ObjectCreateView.I.show();
					break ;
				case this.view.cacheBtn:
					NodeUtils.showCachedSpriteRecs();
					break ;
				}
		}

		__getset(1,ToolBarView,'I',function(){
			if (!ToolBarView._I)ToolBarView._I=new ToolBarView();
			return ToolBarView._I;
		},laya.debug.view.nodeInfo.views.UIViewBase._$SET_I);

		ToolBarView._I=null
		ToolBarView.ignoreDebugTool=true;
		ToolBarView.isClickSelectState=false;
		return ToolBarView;
	})(UIViewBase)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.views.TxtInfoView extends laya.debug.view.nodeInfo.views.UIViewBase
	var TxtInfoView=(function(_super){
		function TxtInfoView(){
			this.input=null;
			this.btn=null;
			TxtInfoView.__super.call(this);
		}

		__class(TxtInfoView,'laya.debug.view.nodeInfo.views.TxtInfoView',_super);
		var __proto=TxtInfoView.prototype;
		__proto.createPanel=function(){
			this.input=new Input();
			this.input.size(200,400);
			this.input.multiline=true;
			this.input.bgColor="#ff00ff";
			this.input.fontSize=12;
			this.input.wordWrap=true;
			this.addChild(this.input);
			this.btn=this.getButton();
			this.btn.text="关闭";
			this.btn.size(50,20);
			this.btn.align="center";
			this.btn.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onCloseBtn);
			this.btn.pos(5,this.input.height+5);
			this.addChild(this.btn);
		}

		__proto.showInfo=function(txt){
			this.input.text=txt;
			this.show();
		}

		__proto.show=function(){
			DebugInfoLayer.I.setTop();
			DebugInfoLayer.I.popLayer.addChild(this);
			this.x=(Laya.stage.width-this.width);
			this.y=0;
		}

		__proto.onCloseBtn=function(){
			this.close();
		}

		return TxtInfoView;
	})(UIViewBase)


	//class laya.debug.ui.debugui.CodeUsedResUI extends laya.ui.View
	var CodeUsedResUI=(function(_super){
		function CodeUsedResUI(){
			this.tab=null;
			CodeUsedResUI.__super.call(this);
		}

		__class(CodeUsedResUI,'laya.debug.ui.debugui.CodeUsedResUI',_super);
		var __proto=CodeUsedResUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(CodeUsedResUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(CodeUsedResUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":359,"y":91,"skin":"comp/button1.png"},"type":"Image"},{"props":{"x":309,"y":283,"skin":"comp/line2.png"},"type":"Image"},{"type":"Tab","child":[{"props":{"skin":"view/create.png","label":"  对象创建","width":70,"height":17,"name":"item0"},"type":"CheckBox"},{"props":{"x":70,"skin":"view/rendertime.png","label":"渲染用时","width":70,"height":19,"name":"item1"},"type":"CheckBox"},{"props":{"x":140,"skin":"view/cache.png","label":"Cache","width":70,"height":16,"name":"item2"},"type":"CheckBox"}],"props":{"x":76,"y":210,"selectedIndex":0,"var":"tab"}}],"props":{"width":600,"height":400,"base64pic":true}};}
		]);
		return CodeUsedResUI;
	})(View)


	//class laya.debug.ui.debugui.comps.ListItemUI extends laya.ui.View
	var ListItemUI=(function(_super){
		function ListItemUI(){
			ListItemUI.__super.call(this);
		}

		__class(ListItemUI,'laya.debug.ui.debugui.comps.ListItemUI',_super);
		var __proto=ListItemUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(ListItemUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(ListItemUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"base64pic":true,"width":244,"height":19},"child":[{"type":"Clip","props":{"y":-1,"skin":"comp/clip_selectBox.png","clipY":2,"height":19,"name":"selectBox","left":2,"right":2,"x":0}},{"type":"Label","props":{"x":25,"text":"render","color":"#dcea36","width":77,"height":17,"name":"label","y":2,"fontSize":12}},{"type":"Clip","props":{"skin":"comp/clip_tree_arrow.png","clipY":2,"name":"arrow","x":8,"y":4,"mouseEnabled":false}}]};}
		]);
		return ListItemUI;
	})(View)


	//class laya.debug.ui.debugui.comps.RankListItemUI extends laya.ui.View
	var RankListItemUI=(function(_super){
		function RankListItemUI(){
			RankListItemUI.__super.call(this);
		}

		__class(RankListItemUI,'laya.debug.ui.debugui.comps.RankListItemUI',_super);
		var __proto=RankListItemUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(RankListItemUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(RankListItemUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"y":-1,"skin":"comp/clip_selectBox.png","clipY":2,"height":19,"name":"selectBox","left":0,"right":0,"x":0},"type":"Clip"},{"props":{"text":"render","color":"#a0a0a0","height":15,"name":"label","y":2,"left":11,"right":5,"fontSize":12,"x":11,"width":163},"type":"Label"}],"props":{"width":179,"height":19}};}
		]);
		return RankListItemUI;
	})(View)


	//class laya.debug.ui.debugui.DebugPanelUI extends laya.ui.View
	var DebugPanelUI=(function(_super){
		function DebugPanelUI(){
			this.bg=null;
			this.minBtn=null;
			this.treePanel=null;
			this.selectWhenClick=null;
			this.profilePanel=null;
			this.resizeBtn=null;
			this.mouseAnalyseBtn=null;
			this.dragIcon=null;
			this.clearBtn=null;
			this.selectPanel=null;
			this.tab=null;
			DebugPanelUI.__super.call(this);
		}

		__class(DebugPanelUI,'laya.debug.ui.debugui.DebugPanelUI',_super);
		var __proto=DebugPanelUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(DebugPanelUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.view.nodeInfo.nodetree.MinBtnComp"]=MinBtnComp;
			View.viewClassMap["laya.debug.view.nodeInfo.views.NodeTreeView"]=NodeTreeView;
			View.viewClassMap["laya.debug.view.nodeInfo.nodetree.Profile"]=Profile;
			View.viewClassMap["laya.debug.view.nodeInfo.views.SelectInfosView"]=SelectInfosView;
		}

		__static(DebugPanelUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"base64pic":true,"width":260,"height":400},"child":[{"type":"Image","props":{"x":205,"y":254,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Image","props":{"y":0,"skin":"view/bg_top.png","left":0,"right":0}},{"type":"MinBtnComp","props":{"y":-3,"var":"minBtn","runtime":"laya.debug.view.nodeInfo.nodetree.MinBtnComp","right":-3,"x":207}},{"type":"NodeTree","props":{"left":0,"right":0,"top":32,"bottom":0,"name":"节点树","var":"treePanel","runtime":"laya.debug.view.nodeInfo.views.NodeTreeView"}},{"type":"CheckBox","props":{"x":8,"y":9,"skin":"view/clickselect.png","toolTip":"点击选取","var":"selectWhenClick","mouseEnabled":true,"width":14,"height":14}},{"type":"Profile","props":{"name":"性能","top":32,"right":0,"left":0,"bottom":0,"var":"profilePanel","runtime":"laya.debug.view.nodeInfo.nodetree.Profile"}},{"type":"Button","props":{"x":169,"y":247,"skin":"view/resize.png","right":2,"bottom":2,"name":"resizeBtn","var":"resizeBtn","stateNum":3}},{"type":"Clip","props":{"y":9,"skin":"view/clickanalyse.png","var":"mouseAnalyseBtn","toolTip":"拖动选取","left":33,"x":33,"clipY":3}},{"type":"Clip","props":{"y":0,"skin":"view/clickanalyse.png","var":"dragIcon","x":33,"clipY":3}},{"type":"Button","props":{"y":7,"skin":"view/res.png","stateNum":2,"toolTip":"清除边框","var":"clearBtn","right":34,"x":184}},{"type":"SelectInfos","props":{"top":32,"left":0,"right":0,"bottom":0,"name":"选中","var":"selectPanel","runtime":"laya.debug.view.nodeInfo.views.SelectInfosView"}},{"type":"Tab","props":{"x":59,"y":0,"name":"tab","var":"tab","selectedIndex":0},"child":[{"type":"Button","props":{"skin":"view/tab_panel.png","label":"节点","width":42,"height":32,"name":"item0","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":42,"skin":"view/tab_panel.png","label":"查询","width":42,"height":32,"name":"item1","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":84,"skin":"view/tab_panel.png","label":"性能","width":42,"height":32,"name":"item2","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}}]}]};}
		]);
		return DebugPanelUI;
	})(View)


	//class laya.debug.ui.debugui.FindNodeSmallUI extends laya.ui.View
	var FindNodeSmallUI=(function(_super){
		function FindNodeSmallUI(){
			this.bg=null;
			this.closeBtn=null;
			this.title=null;
			this.typeSelect=null;
			this.findTxt=null;
			this.findBtn=null;
			FindNodeSmallUI.__super.call(this);
		}

		__class(FindNodeSmallUI,'laya.debug.ui.debugui.FindNodeSmallUI',_super);
		var __proto=FindNodeSmallUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(FindNodeSmallUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(FindNodeSmallUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":185,"y":234,"skin":"view/bg_tool.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg"},"type":"Image"},{"props":{"x":185,"y":15,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2},"type":"Button"},{"props":{"x":6,"y":4,"text":"查找对象","width":67,"height":20,"color":"#288edf","var":"title"},"type":"Label"},{"props":{"x":60,"y":81,"skin":"comp/combobox.png","labels":"name,class","width":63,"height":21,"var":"typeSelect","sizeGrid":"5,35,5,5","labelColors":"#a0a0a0,#fffff,#ffffff#fffff"},"type":"ComboBox"},{"props":{"x":27,"y":83,"text":"类型","width":27,"height":20,"color":"#288edf","align":"right"},"type":"Label"},{"props":{"x":7,"y":40,"text":"包含内容","width":47,"height":20,"color":"#288edf","align":"right"},"type":"Label"},{"props":{"x":60,"y":37,"skin":"comp/textinput.png","text":"Sprite","width":164,"height":22,"var":"findTxt","sizeGrid":"5,5,5,5","color":"#a0a0a0"},"type":"TextInput"},{"props":{"x":158,"y":79,"skin":"comp/button.png","label":"查找","width":65,"height":23,"var":"findBtn","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"},"type":"Button"}],"props":{"base64pic":true,"width":233,"height":120}};}
		]);
		return FindNodeSmallUI;
	})(View)


	//class laya.debug.ui.debugui.FindNodeUI extends laya.ui.View
	var FindNodeUI=(function(_super){
		function FindNodeUI(){
			this.bg=null;
			this.closeBtn=null;
			this.title=null;
			this.typeSelect=null;
			this.findTxt=null;
			this.result=null;
			this.findBtn=null;
			FindNodeUI.__super.call(this);
		}

		__class(FindNodeUI,'laya.debug.ui.debugui.FindNodeUI',_super);
		var __proto=FindNodeUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(FindNodeUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.uicomps.RankListItem"]=RankListItem;
		}

		__static(FindNodeUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":185,"y":234,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":185,"y":15,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2},"type":"Button"},{"props":{"x":6,"y":4,"text":"查找对象","width":67,"height":20,"color":"#88ef19","var":"title"},"type":"Label"},{"props":{"x":52,"y":75,"skin":"comp/combobox.png","labels":"name,class","width":63,"height":21,"var":"typeSelect","sizeGrid":"5,35,5,5","labelColors":"#a0a0a0,#fffff,#ffffff#fffff"},"type":"ComboBox"},{"props":{"x":10,"y":77,"text":"类型","width":27,"height":20,"color":"#88ef19","align":"right"},"type":"Label"},{"props":{"x":7,"y":34,"text":"包含内容","width":47,"height":20,"color":"#88ef19","align":"right"},"type":"Label"},{"props":{"x":59,"y":31,"skin":"comp/textinput.png","text":"Sprite","width":131,"height":22,"var":"findTxt","sizeGrid":"5,5,5,5","color":"#a0a0a0"},"type":"TextInput"},{"type":"List","child":[{"type":"RankListItem","props":{"y":30,"left":5,"right":5,"name":"render","x":30,"runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"x":6,"y":106,"width":188,"height":180,"vScrollBarSkin":"comp/vscroll.png","var":"result"}},{"props":{"x":125,"y":73,"skin":"comp/button.png","label":"查找","width":65,"height":23,"var":"findBtn","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"},"type":"Button"}],"props":{"width":200,"height":300,"base64pic":true}};}
		]);
		return FindNodeUI;
	})(View)


	//class laya.debug.ui.debugui.MinBtnCompUI extends laya.ui.View
	var MinBtnCompUI=(function(_super){
		function MinBtnCompUI(){
			this.minBtn=null;
			this.maxUI=null;
			this.bg=null;
			this.maxBtn=null;
			MinBtnCompUI.__super.call(this);
		}

		__class(MinBtnCompUI,'laya.debug.ui.debugui.MinBtnCompUI',_super);
		var __proto=MinBtnCompUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(MinBtnCompUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(MinBtnCompUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":7,"y":8,"skin":"comp/minBtn.png","stateNum":"3","var":"minBtn","width":22,"height":20,"toolTip":"最小化"},"type":"Button"},{"type":"Box","child":[{"props":{"x":0,"y":0,"skin":"view/bg_panel.png","var":"bg","width":36,"height":36,"sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":6,"y":8,"skin":"view/zoom_out.png","stateNum":"2","var":"maxBtn"},"type":"Button"}],"props":{"var":"maxUI"}}],"props":{"width":36,"height":36,"base64pic":true}};}
		]);
		return MinBtnCompUI;
	})(View)


	//class laya.debug.ui.debugui.NodeListPanelUI extends laya.ui.View
	var NodeListPanelUI=(function(_super){
		function NodeListPanelUI(){
			this.bg=null;
			this.closeBtn=null;
			this.title=null;
			this.itemList=null;
			NodeListPanelUI.__super.call(this);
		}

		__class(NodeListPanelUI,'laya.debug.ui.debugui.NodeListPanelUI',_super);
		var __proto=NodeListPanelUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(NodeListPanelUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.uicomps.RankListItem"]=RankListItem;
		}

		__static(NodeListPanelUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":235,"y":284,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":204,"y":32,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2,"visible":true},"type":"Button"},{"props":{"x":10,"y":6,"text":"节点信息","width":147,"height":16,"color":"#288edf","var":"title"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"itemList","left":2,"right":2,"top":26,"bottom":0,"repeatX":1,"x":20}}],"props":{"width":200,"height":300}};}
		]);
		return NodeListPanelUI;
	})(View)


	//class laya.debug.ui.debugui.NodeToolUI extends laya.ui.View
	var NodeToolUI=(function(_super){
		function NodeToolUI(){
			this.bg=null;
			this.closeBtn=null;
			this.tarTxt=null;
			this.freshBtn=null;
			this.mouseAnalyseBtn=null;
			this.dragIcon=null;
			NodeToolUI.__super.call(this);
		}

		__class(NodeToolUI,'laya.debug.ui.debugui.NodeToolUI',_super);
		var __proto=NodeToolUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(NodeToolUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(NodeToolUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"base64pic":true,"width":200,"height":341},"child":[{"type":"Image","props":{"x":195,"y":244,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Label","props":{"x":9,"y":5,"text":"当前选中对象","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":195,"y":25,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2}},{"type":"Label","props":{"x":10,"y":25,"text":"当前对象","width":67,"height":16,"color":"#a0a0a0","var":"tarTxt"}},{"type":"Button","props":{"x":15,"y":65,"skin":"comp/button.png","label":"父链","width":39,"height":23,"mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":66,"y":65,"skin":"comp/button.png","label":"子","width":35,"height":23,"mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":112,"y":65,"skin":"comp/button.png","label":"兄弟","width":49,"height":23,"mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":13,"y":117,"skin":"comp/button.png","label":"Enable链","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":100,"y":117,"skin":"comp/button.png","label":"Size链","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Label","props":{"x":14,"y":97,"text":"节点链信息","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Label","props":{"x":15,"y":45,"text":"对象选取","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Label","props":{"x":16,"y":145,"text":"节点显示","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":13,"y":164,"skin":"comp/button.png","label":"隐藏旁支","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":100,"y":164,"skin":"comp/button.png","label":"隐藏兄弟","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":13,"y":197,"skin":"comp/button.png","label":"隐藏子","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":99,"y":197,"skin":"comp/button.png","label":"恢复","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Label","props":{"x":15,"y":228,"text":"其他","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":12,"y":247,"skin":"comp/button.png","label":"节点树定位","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":99,"y":247,"skin":"comp/button.png","label":"显示边框","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Label","props":{"x":12,"y":315,"text":"Alt+A分析鼠标能否够点中对象","width":173,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":156,"y":1,"skin":"view/refresh2.png","var":"freshBtn","left":156,"toolTip":"recache节点"}},{"type":"Button","props":{"x":12,"y":279,"skin":"comp/button.png","label":"输出到控制台","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":99,"y":279,"skin":"comp/button.png","label":"显示切换","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Clip","props":{"y":44,"skin":"view/clickanalyse.png","var":"mouseAnalyseBtn","toolTip":"拖动到对象上方判断是否能够点中","left":84,"x":84,"clipY":3}},{"type":"Clip","props":{"y":35,"skin":"view/clickanalyse.png","var":"dragIcon","x":94,"clipY":3}}]};}
		]);
		return NodeToolUI;
	})(View)


	//class laya.debug.ui.debugui.NodeTreeSettingUI extends laya.ui.View
	var NodeTreeSettingUI=(function(_super){
		function NodeTreeSettingUI(){
			this.bg=null;
			this.showTxt=null;
			this.okBtn=null;
			this.closeBtn=null;
			NodeTreeSettingUI.__super.call(this);
		}

		__class(NodeTreeSettingUI,'laya.debug.ui.debugui.NodeTreeSettingUI',_super);
		var __proto=NodeTreeSettingUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(NodeTreeSettingUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(NodeTreeSettingUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":0,"y":0,"skin":"view/bg_panel.png","left":0,"top":0,"bottom":0,"right":0,"var":"bg","width":200,"height":300,"sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":9,"y":7,"text":"要显示的属性","width":76,"height":16,"color":"#ffffff","align":"left"},"type":"Label"},{"props":{"x":6,"y":29,"skin":"comp/textinput.png","text":"x\\ny\\nwidth\\nheight","width":188,"height":230,"multiline":true,"var":"showTxt","color":"#a0a0a0","sizeGrid":"5,5,5,5"},"type":"TextInput"},{"props":{"x":57,"y":269,"skin":"comp/button.png","label":"确定","var":"okBtn","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"},"type":"Button"},{"props":{"x":175,"y":5,"skin":"view/btn_close.png","var":"closeBtn"},"type":"Button"}],"props":{"base64pic":true,"width":200,"height":300}};}
		]);
		return NodeTreeSettingUI;
	})(View)


	//class laya.debug.ui.debugui.NodeTreeUI extends laya.ui.View
	var NodeTreeUI=(function(_super){
		function NodeTreeUI(){
			this.nodeTree=null;
			this.controlBar=null;
			this.settingBtn=null;
			this.freshBtn=null;
			this.fliterTxt=null;
			this.closeBtn=null;
			this.ifShowProps=null;
			NodeTreeUI.__super.call(this);
		}

		__class(NodeTreeUI,'laya.debug.ui.debugui.NodeTreeUI',_super);
		var __proto=NodeTreeUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(NodeTreeUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.uicomps.TreeListItem"]=TreeListItem;
		}

		__static(NodeTreeUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"width":200,"height":260,"base64pic":true},"child":[{"type":"Image","props":{"x":-22,"y":-47,"skin":"view/bg_panel.png","width":211,"height":206,"left":0,"right":0,"top":0,"bottom":0,"sizeGrid":"5,5,5,5"}},{"props":{"y":0,"skin":"view/bg_tool.png","left":0,"right":0},"type":"Image"},{"type":"Tree","props":{"x":0,"scrollBarSkin":"comp/vscroll.png","width":195,"height":229,"var":"nodeTree","left":0,"right":0,"top":38,"bottom":20},"child":[{"type":"ListItem","props":{"y":0,"name":"render","left":0,"right":0,"runtime":"laya.debug.uicomps.TreeListItem"}}]},{"type":"Box","props":{"x":3,"y":5,"var":"controlBar","left":3,"right":3,"top":5,"height":23},"child":[{"type":"Button","props":{"x":6,"skin":"view/setting.png","stateNum":3,"var":"settingBtn","toolTip":"设置显示的属性","y":6}},{"type":"Button","props":{"y":6,"skin":"view/refresh.png","var":"freshBtn","left":30,"toolTip":"刷新数据"}},{"type":"TextInput","props":{"y":0,"skin":"view/bg_top.png","height":22,"var":"fliterTxt","left":53,"right":0,"color":"#a0a0a0"}},{"type":"Button","props":{"x":172,"y":2,"skin":"view/btn_close.png","var":"closeBtn","right":1,"visible":false}}]},{"props":{"y":243,"skin":"comp/checkbox.png","label":"显示属性","var":"ifShowProps","bottom":3,"selected":true,"visible":true,"x":2,"width":70,"height":14,"labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"},"type":"CheckBox"}]};}
		]);
		return NodeTreeUI;
	})(View)


	//class laya.debug.ui.debugui.ObjectCreateUI extends laya.ui.View
	var ObjectCreateUI=(function(_super){
		function ObjectCreateUI(){
			this.bg=null;
			this.closeBtn=null;
			this.itemList=null;
			this.freshBtn=null;
			ObjectCreateUI.__super.call(this);
		}

		__class(ObjectCreateUI,'laya.debug.ui.debugui.ObjectCreateUI',_super);
		var __proto=ObjectCreateUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(ObjectCreateUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.uicomps.RankListItem"]=RankListItem;
		}

		__static(ObjectCreateUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":215,"y":264,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":184,"y":12,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2,"visible":false},"type":"Button"},{"props":{"x":11,"y":5,"text":"对象创建统计","width":83,"height":16,"color":"#288edf"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"y":0,"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"itemList","top":26,"bottom":5,"left":5,"right":5,"repeatX":1}},{"props":{"y":1,"skin":"view/refresh2.png","var":"freshBtn","toolTip":"刷新数据","right":1,"x":178},"type":"Button"}],"props":{"width":200,"height":300,"base64pic":true}};}
		]);
		return ObjectCreateUI;
	})(View)


	//class laya.debug.ui.debugui.ObjectInfoUI extends laya.ui.View
	var ObjectInfoUI=(function(_super){
		function ObjectInfoUI(){
			this.bg=null;
			this.title=null;
			this.showTxt=null;
			this.closeBtn=null;
			this.autoUpdate=null;
			this.settingBtn=null;
			ObjectInfoUI.__super.call(this);
		}

		__class(ObjectInfoUI,'laya.debug.ui.debugui.ObjectInfoUI',_super);
		var __proto=ObjectInfoUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(ObjectInfoUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(ObjectInfoUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":-1,"y":0,"skin":"view/bg_panel.png","left":-1,"right":1,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":7,"y":5,"text":"对象类型","width":67,"height":20,"color":"#ffffff","var":"title","left":7,"right":6},"type":"Label"},{"props":{"x":2,"skin":"comp/textinput.png","text":"属性内容","width":196,"height":228,"left":2,"right":2,"var":"showTxt","top":25,"bottom":20,"editable":false,"multiline":true,"sizeGrid":"5,5,5,5","color":"#a0a0a0"},"type":"TextArea"},{"props":{"x":178,"y":4,"skin":"view/btn_close.png","var":"closeBtn","top":4,"right":2},"type":"Button"},{"props":{"skin":"comp/checkbox.png","label":"自动刷新属性","var":"autoUpdate","bottom":2,"x":3,"labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"},"type":"CheckBox"},{"props":{"x":164,"skin":"view/setting.png","stateNum":"3","var":"settingBtn","y":6,"top":6,"right":24,"toolTip":"设置显示属性"},"type":"Button"},{"props":{"x":179,"y":257,"skin":"view/resize.png","right":2,"bottom":2,"name":"resizeBtn","stateNum":3},"type":"Button"}],"props":{"base64pic":true,"width":200,"height":200}};}
		]);
		return ObjectInfoUI;
	})(View)


	//class laya.debug.ui.debugui.OutPutUI extends laya.ui.View
	var OutPutUI=(function(_super){
		function OutPutUI(){
			this.bg=null;
			this.txt=null;
			this.closeBtn=null;
			this.clearBtn=null;
			OutPutUI.__super.call(this);
		}

		__class(OutPutUI,'laya.debug.ui.debugui.OutPutUI',_super);
		var __proto=OutPutUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(OutPutUI.uiView);
		}

		__proto.viewMapRegists=function(){}
		__static(OutPutUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"width":300,"height":200,"base64pic":true},"child":[{"type":"Image","props":{"x":205,"y":254,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Label","props":{"skin":"comp/textarea.png","text":"TextArea","color":"#a0a0a0","var":"txt","left":5,"right":5,"top":22,"bottom":5,"mouseEnabled":true,"sizeGrid":"3,3,3,3"}},{"type":"Button","props":{"x":185,"y":15,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2}},{"props":{"x":253,"y":1,"skin":"view/re.png","stateNum":"2","var":"clearBtn","right":25},"type":"Button"},{"props":{"x":169,"y":247,"skin":"view/resize.png","right":2,"bottom":2,"name":"resizeBtn","stateNum":3},"type":"Button"}]};}
		]);
		return OutPutUI;
	})(View)


	//class laya.debug.ui.debugui.ProfileUI extends laya.ui.View
	var ProfileUI=(function(_super){
		function ProfileUI(){
			this.renderPanel=null;
			this.createPanel=null;
			this.cachePanel=null;
			this.tab=null;
			ProfileUI.__super.call(this);
		}

		__class(ProfileUI,'laya.debug.ui.debugui.ProfileUI',_super);
		var __proto=ProfileUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(ProfileUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.view.nodeInfo.views.RenderCostRankView"]=RenderCostRankView;
			View.viewClassMap["laya.debug.view.nodeInfo.views.ObjectCreateView"]=ObjectCreateView;
			View.viewClassMap["laya.debug.view.nodeInfo.views.CacheRankView"]=CacheRankView;
		}

		__static(ProfileUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"base64pic":true,"width":260,"height":329},"child":[{"props":{"y":0,"skin":"view/bg_tool.png","left":0,"right":0},"type":"Image"},{"type":"Rank","props":{"name":"渲染用时","left":0,"right":0,"top":29,"bottom":0,"runtime":"laya.debug.view.nodeInfo.views.RenderCostRankView","var":"renderPanel"}},{"type":"ObjectCreate","props":{"name":"对象创建统计","runtime":"laya.debug.view.nodeInfo.views.ObjectCreateView","top":29,"left":0,"right":0,"bottom":0,"var":"createPanel"}},{"type":"Rank","props":{"name":"cache用时","left":0,"right":0,"top":29,"bottom":0,"runtime":"laya.debug.view.nodeInfo.views.CacheRankView","var":"cachePanel","x":10}},{"type":"Tab","child":[{"props":{"skin":"view/create.png","label":"  对象创建","width":70,"height":17,"name":"item0","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff"},"type":"CheckBox"},{"props":{"x":77,"skin":"view/rendertime.png","label":" 渲染用时","width":70,"height":19,"name":"item1","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","y":0},"type":"CheckBox"},{"props":{"x":154,"skin":"view/cache.png","label":" Cache","width":70,"height":16,"name":"item2","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","y":0},"type":"CheckBox"}],"props":{"x":7,"y":9,"selectedIndex":0,"var":"tab","width":191,"height":19}}]};}
		]);
		return ProfileUI;
	})(View)


	//class laya.debug.ui.debugui.RankUI extends laya.ui.View
	var RankUI=(function(_super){
		function RankUI(){
			this.bg=null;
			this.closeBtn=null;
			this.title=null;
			this.itemList=null;
			this.autoUpdate=null;
			this.freshBtn=null;
			RankUI.__super.call(this);
		}

		__class(RankUI,'laya.debug.ui.debugui.RankUI',_super);
		var __proto=RankUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(RankUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.uicomps.RankListItem"]=RankListItem;
		}

		__static(RankUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":225,"y":274,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":194,"y":22,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2,"visible":false},"type":"Button"},{"props":{"x":8,"y":5,"text":"渲染用时表(3000ms)","width":109,"height":16,"color":"#288edf","var":"title"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"itemList","left":2,"right":2,"top":26,"bottom":25,"repeatX":1,"x":10,"y":10}},{"props":{"skin":"comp/checkbox.png","label":"自动刷新属性","var":"autoUpdate","bottom":3,"selected":false,"visible":true,"left":2,"labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"},"type":"CheckBox"},{"props":{"y":1,"skin":"view/refresh2.png","var":"freshBtn","toolTip":"刷新数据","right":1},"type":"Button"}],"props":{"width":200,"height":300}};}
		]);
		return RankUI;
	})(View)


	//class laya.debug.ui.debugui.SelectInfosUI extends laya.ui.View
	var SelectInfosUI=(function(_super){
		function SelectInfosUI(){
			this.bg=null;
			this.closeBtn=null;
			this.selectList=null;
			this.findBtn=null;
			this.fliterTxt=null;
			SelectInfosUI.__super.call(this);
		}

		__class(SelectInfosUI,'laya.debug.ui.debugui.SelectInfosUI',_super);
		var __proto=SelectInfosUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(SelectInfosUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.uicomps.RankListItem"]=RankListItem;
		}

		__static(SelectInfosUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":205,"y":254,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"skin":"view/btn_close.png","var":"closeBtn","top":32,"visible":false,"right":2},"type":"Button"},{"props":{"x":7,"y":36,"text":"当前选中列表","width":83,"height":16,"color":"#288edf"},"type":"Label"},{"type":"List","child":[{"type":"RankListItem","props":{"left":5,"right":5,"name":"render","runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"vScrollBarSkin":"comp/vscroll.png","var":"selectList","left":5,"right":5,"top":56,"bottom":25,"repeatX":1,"x":20}},{"props":{"x":6,"text":"Alt+V选取鼠标下的对象","width":189,"height":16,"color":"#a0a0a0","bottom":3},"type":"Label"},{"type":"Image","props":{"y":0,"skin":"view/bg_tool.png","left":0,"right":0}},{"type":"Clip","props":{"y":6,"skin":"view/search.png","clipY":2,"var":"findBtn","right":5,"toolTip":"查找","x":174}},{"type":"TextInput","props":{"y":6,"skin":"view/bg_top.png","height":22,"var":"fliterTxt","left":8,"right":45,"color":"#a0a0a0","x":8,"width":147}}],"props":{"width":200,"height":300,"base64pic":true}};}
		]);
		return SelectInfosUI;
	})(View)


	//class laya.debug.ui.debugui.ToolBarUI extends laya.ui.View
	var ToolBarUI=(function(_super){
		function ToolBarUI(){
			this.bg=null;
			this.treeBtn=null;
			this.findBtn=null;
			this.minBtn=null;
			this.selectWhenClick=null;
			this.clearBtn=null;
			this.rankBtn=null;
			this.nodeRankBtn=null;
			this.cacheBtn=null;
			ToolBarUI.__super.call(this);
		}

		__class(ToolBarUI,'laya.debug.ui.debugui.ToolBarUI',_super);
		var __proto=ToolBarUI.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(ToolBarUI.uiView);
		}

		__proto.viewMapRegists=function(){
			View.viewClassMap["laya.debug.view.nodeInfo.nodetree.MinBtnComp"]=MinBtnComp;
		}

		__static(ToolBarUI,
		['uiView',function(){return this.uiView={"type":"View","props":{"base64pic":true,"width":250,"height":30},"child":[{"type":"Image","props":{"x":195,"y":244,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Button","props":{"x":2,"y":6,"skin":"view/save.png","stateNum":2,"var":"treeBtn","toolTip":"节点树"}},{"type":"Button","props":{"x":25,"y":6,"skin":"view/save.png","stateNum":2,"var":"findBtn","toolTip":"查找面板"}},{"type":"MinBtnComp","props":{"x":218,"y":-3,"var":"minBtn","runtime":"laya.debug.view.nodeInfo.nodetree.MinBtnComp"}},{"type":"CheckBox","props":{"x":124,"y":8,"skin":"comp/checkbox.png","label":"点击选取","var":"selectWhenClick","labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"}},{"type":"Button","props":{"x":193,"y":5,"skin":"view/res.png","stateNum":2,"toolTip":"清除边框","var":"clearBtn"}},{"type":"Button","props":{"x":49,"y":6,"skin":"view/save.png","stateNum":2,"var":"rankBtn","toolTip":"渲染用时排行"}},{"type":"Button","props":{"x":72,"y":6,"skin":"view/save.png","stateNum":2,"var":"nodeRankBtn","toolTip":"创建对象排行"}},{"type":"Button","props":{"x":94,"y":6,"skin":"view/save.png","stateNum":2,"var":"cacheBtn","toolTip":"cache对象"}}]};}
		]);
		return ToolBarUI;
	})(View)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2016-7-6 上午9:42:46
	*/
	//class laya.debug.uicomps.ListBase extends laya.ui.List
	var ListBase=(function(_super){
		function ListBase(){
			ListBase.__super.call(this);
		}

		__class(ListBase,'laya.debug.uicomps.ListBase',_super);
		var __proto=ListBase.prototype;
		__getset(0,__proto,'selectedIndex',_super.prototype._$get_selectedIndex,function(value){
			if (this._selectedIndex !=value){
				this._selectedIndex=value;
				this.changeSelectStatus();
				this.event(/*laya.events.Event.CHANGE*/"change");
				this.selectHandler && this.selectHandler.runWith(value);
			}
			if (this.selectEnable && this._scrollBar){
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				if (value < this._startIndex || (value+numX > this._startIndex+this.repeatX *this.repeatY)){
					this.scrollTo(value);
				}
			}
		});

		return ListBase;
	})(List)


	/**
	*
	*@author ww
	*@version 1.0
	*
	*@created 2016-7-6 上午9:49:47
	*/
	//class laya.debug.uicomps.TreeBase extends laya.ui.Tree
	var TreeBase=(function(_super){
		function TreeBase(){
			TreeBase.__super.call(this);
		}

		__class(TreeBase,'laya.debug.uicomps.TreeBase',_super);
		var __proto=TreeBase.prototype;
		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._list=new ListBase());
			this._list.renderHandler=Handler.create(this,this.renderItem,null,false);
			this._list.repeatX=1;
			this._list.on(/*laya.events.Event.CHANGE*/"change",this,this.onListChange);
		}

		return TreeBase;
	})(Tree)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.uicomps.RankListItem extends laya.debug.ui.debugui.comps.RankListItemUI
	var RankListItem=(function(_super){
		function RankListItem(){
			RankListItem.__super.call(this);
			Base64AtlasManager.replaceRes(RankListItemUI.uiView);
			this.createView(RankListItemUI.uiView);
		}

		__class(RankListItem,'laya.debug.uicomps.RankListItem',_super);
		var __proto=RankListItem.prototype;
		__proto.createChildren=function(){}
		return RankListItem;
	})(RankListItemUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.uicomps.TreeListItem extends laya.debug.ui.debugui.comps.ListItemUI
	var TreeListItem=(function(_super){
		function TreeListItem(){
			TreeListItem.__super.call(this);
			Base64AtlasManager.replaceRes(ListItemUI.uiView);
			this.createView(ListItemUI.uiView);
		}

		__class(TreeListItem,'laya.debug.uicomps.TreeListItem',_super);
		var __proto=TreeListItem.prototype;
		__proto.createChildren=function(){}
		return TreeListItem;
	})(ListItemUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.DebugPanel extends laya.debug.ui.debugui.DebugPanelUI
	var DebugPanel=(function(_super){
		function DebugPanel(){
			this.views=null;
			DebugPanel.__super.call(this);
			this.msRec=new Rectangle();
			Base64AtlasManager.replaceRes(DebugPanelUI.uiView);
			this.createView(DebugPanelUI.uiView);
			DisControlTool.setResizeAbleEx(this);
			this.views=[this.treePanel,this.selectPanel,this.profilePanel];
			this.tab.selectedIndex=0;
			this.tabChange();
			this.tab.on(/*laya.events.Event.CHANGE*/"change",this,this.tabChange);
			this.changeSize();
		}

		__class(DebugPanel,'laya.debug.view.nodeInfo.nodetree.DebugPanel',_super);
		var __proto=DebugPanel.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		__proto.tabChange=function(){
			DisControlTool.addOnlyByIndex(this.views,this.tab.selectedIndex,this);
			DisControlTool.setTop(this.resizeBtn);
		}

		__proto.changeSize=function(){
			if (this.width < 245){
				this.width=245;
			}
			if (this.height < 100){
				this.height=200;
			}
			laya.ui.Component.prototype.changeSize.call(this);
			this.msRec.setTo(0,0,this.width,this.height);
			this.scrollRect=this.msRec;
		}

		return DebugPanel;
	})(DebugPanelUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.FindNode extends laya.debug.ui.debugui.FindNodeUI
	var FindNode=(function(_super){
		function FindNode(){
			FindNode.__super.call(this);
			Base64AtlasManager.replaceRes(FindNodeUI.uiView);
			this.createView(FindNodeUI.uiView);
		}

		__class(FindNode,'laya.debug.view.nodeInfo.nodetree.FindNode',_super);
		var __proto=FindNode.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		return FindNode;
	})(FindNodeUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.FindNodeSmall extends laya.debug.ui.debugui.FindNodeSmallUI
	var FindNodeSmall=(function(_super){
		function FindNodeSmall(){
			FindNodeSmall.__super.call(this);
			Base64AtlasManager.replaceRes(FindNodeSmallUI.uiView);
			this.createView(FindNodeSmallUI.uiView);
		}

		__class(FindNodeSmall,'laya.debug.view.nodeInfo.nodetree.FindNodeSmall',_super);
		var __proto=FindNodeSmall.prototype;
		__proto.createChildren=function(){}
		return FindNodeSmall;
	})(FindNodeSmallUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.MinBtnComp extends laya.debug.ui.debugui.MinBtnCompUI
	var MinBtnComp=(function(_super){
		function MinBtnComp(){
			this.tar=null;
			this.minHandler=null;
			this.maxHandler=null;
			this.prePos=new Point();
			MinBtnComp.__super.call(this);
			Base64AtlasManager.replaceRes(MinBtnCompUI.uiView);
			this.createView(MinBtnCompUI.uiView);
			this.init();
		}

		__class(MinBtnComp,'laya.debug.view.nodeInfo.nodetree.MinBtnComp',_super);
		var __proto=MinBtnComp.prototype;
		__proto.createChildren=function(){}
		__proto.init=function(){
			this.minBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onMinBtn);
			this.maxBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onMaxBtn);
			this.minState=false;
			this.maxUI.removeSelf();
			DisControlTool.setDragingItem(this.bg,this.maxUI);
		}

		__proto.onMaxBtn=function(){
			this.maxUI.removeSelf();
			if (this.maxHandler){
				this.maxHandler.run();
			}
			if (this.tar){
				this.tar.x+=this.maxUI.x-this.prePos.x;
				this.tar.y+=this.maxUI.y-this.prePos.y;
			}
		}

		__proto.onMinBtn=function(){
			if (!this.displayedInStage)return;
			var tPos;
			tPos=Point.TEMP;
			tPos.setTo(0,0);
			tPos=this.localToGlobal(tPos);
			tPos=DebugInfoLayer.I.popLayer.globalToLocal(tPos);
			this.maxUI.pos(tPos.x,tPos.y);
			DebugInfoLayer.I.popLayer.addChild(this.maxUI);
			if (this.tar){
				this.prePos.setTo(tPos.x,tPos.y);
			}
			if (this.minHandler){
				this.minHandler.run();
			}
		}

		__getset(0,__proto,'minState',null,function(v){
		});

		return MinBtnComp;
	})(MinBtnCompUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.NodeListPanel extends laya.debug.ui.debugui.NodeListPanelUI
	var NodeListPanel=(function(_super){
		function NodeListPanel(){
			NodeListPanel.__super.call(this);
			Base64AtlasManager.replaceRes(NodeListPanelUI.uiView);
			this.createView(NodeListPanelUI.uiView);
		}

		__class(NodeListPanel,'laya.debug.view.nodeInfo.nodetree.NodeListPanel',_super);
		var __proto=NodeListPanel.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		return NodeListPanel;
	})(NodeListPanelUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.NodeTool extends laya.debug.ui.debugui.NodeToolUI
	var NodeTool=(function(_super){
		function NodeTool(){
			NodeTool.__super.call(this);
			Base64AtlasManager.replaceRes(NodeToolUI.uiView);
			this.createView(NodeToolUI.uiView);
		}

		__class(NodeTool,'laya.debug.view.nodeInfo.nodetree.NodeTool',_super);
		var __proto=NodeTool.prototype;
		__proto.createChildren=function(){}
		return NodeTool;
	})(NodeToolUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.NodeTree extends laya.debug.ui.debugui.NodeTreeUI
	var NodeTree=(function(_super){
		function NodeTree(){
			this.showProps=false;
			this._closeSettingHandler=null;
			this._tar=null;
			NodeTree.__super.call(this);
			Base64AtlasManager.replaceRes(NodeTreeUI.uiView);
			View.regComponent("Tree",TreeBase);
			this.createView(NodeTreeUI.uiView);
			View.regComponent("Tree",Tree);
			this.inits();
			NodeTree.I=this;
		}

		__class(NodeTree,'laya.debug.view.nodeInfo.nodetree.NodeTree',_super);
		var __proto=NodeTree.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		__proto.inits=function(){
			this.nodeTree.list.scrollBar.hide=true;
			this.nodeTree.list.selectEnable=true;
			this.settingBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onSettingBtn);
			this.freshBtn.on(/*laya.events.Event.CLICK*/"click",this,this.fresh);
			this.closeBtn.on(/*laya.events.Event.CLICK*/"click",this,this.onCloseBtn);
			this.fliterTxt.on(/*laya.events.Event.ENTER*/"enter",this,this.onFliterTxtChange);
			this.fliterTxt.on(/*laya.events.Event.BLUR*/"blur",this,this.onFliterTxtChange);
			NodeMenu.I.setNodeListAction(this.nodeTree.list);
			this.nodeTree.list.on(/*laya.events.Event.CLICK*/"click",this,this.onListClick,[this.nodeTree.list]);
			this.nodeTree.renderHandler=new Handler(this,this.treeRender);
			this._closeSettingHandler=new Handler(this,this.closeSetting);
			this.onIfShowPropsChange();
			this.ifShowProps.on(/*laya.events.Event.CHANGE*/"change",this,this.onIfShowPropsChange);
		}

		__proto.onIfShowPropsChange=function(){
			this.showProps=this.ifShowProps.selected;
			this.fresh();
		}

		__proto.onListClick=function(list){
			if (list.selectedItem){
				if (list.selectedItem.isDirectory){
					list.selectedItem.isOpen=!list.selectedItem.isOpen;
					this.nodeTree.fresh();
				}
			}
		}

		//}
		__proto.onFindBtn=function(){
			FindSmallView.I.show();
		}

		__proto.onCloseBtn=function(){
			this.removeSelf();
		}

		__proto.onTreeDoubleClick=function(e){
			if (this.nodeTree.selectedItem){
				var tarNode;
				tarNode=this.nodeTree.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
			}
		}

		//}
		__proto.onTreeRightMouseDown=function(e){
			if (this.nodeTree.selectedItem){
				var tarNode;
				tarNode=this.nodeTree.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
			}
		}

		//}
		__proto.onSettingBtn=function(){
			NodeTreeSettingView.I.showSetting(NodeTree.showKeys,this._closeSettingHandler,this._tar);
		}

		__proto.closeSetting=function(newKeys){
			NodeTree.showKeys=newKeys;
			this.fresh();
		}

		__proto.onFliterTxtChange=function(e){
			var key;
			key=this.fliterTxt.text;
			if (key=="")return;
			if (key !=NodeTree.showKeys.join(",")){
				NodeTree.showKeys=key.split(",");
				this.fresh();
			}
			return;
			this.selecteByFile(key);
		}

		__proto.selecteByFile=function(key){
			var arr;
			arr=this.nodeTree.source;
			var rsts;
			rsts=DebugTool.findNameHas(key,false);
			if (rsts && rsts.length > 0){
				var tar;
				tar=rsts[0];
				this.parseOpen(arr,tar);
			}
		}

		__proto.showSelectInStage=function(node){
			this.setDis(Laya.stage);
			this.selectByNode(node);
		}

		__proto.selectByNode=function(node){
			if (!node)return;
			var arr;
			arr=this.nodeTree.source;
			this.parseOpen(arr,node);
		}

		__proto.showNodeList=function(nodeList){
			if (!nodeList)return;
			var i=0,len=0;
			len=nodeList.length;
			var showList;
			showList=[];
			var tData;
			var tSprite;
			for (i=0;i < len;i++){
				tSprite=nodeList[i];
				tData={};
				tData.label=ClassTool.getNodeClassAndName(tSprite);
				tData.path=tSprite;
				showList.push(tData);
			}
			this.nodeTree.array=showList;
		}

		__proto.parseOpen=function(tree,node){
			if (tree.length < 1)return;
			if (!node)return;
			var i=0,len=0;
			len=tree.length;
			var tItem;
			for(i=0;i<len;i++){
				tItem=tree[i];
				if(tItem.path==node){
					var sItem;
					sItem=tItem;
					while (tItem){
						tItem.isOpen=true;
						this.nodeTree.fresh();
						tItem=tItem.nodeParent;
					}
					this.nodeTree.selectedItem=sItem;
					return;
				}
			}
		}

		/**
		*@private
		*获取数据源中指定键名的值。
		*/
		__proto.getFilterSource=function(array,result,key){
			key=key.toLocaleLowerCase();
			var item;
			/*for each*/for(var $each_item in array){
				item=array[$each_item];
				if (item.isDirectory && String(item.label).toLowerCase().indexOf(key)>-1){
					item.x=0;
					result.push(item);
				}
				if (item.child && item.child.length > 0){
					this.getFilterSource(item.child,result,key);
				}
			}
		}

		__proto.onControlDown=function(){
			this.startDrag();
		}

		__proto.setDis=function(sprite){
			this._tar=sprite;
			this.fresh();
		}

		__proto.fresh=function(){
			var preTar;
			if (this.nodeTree.selectedItem){
				var tItem;
				tItem=this.nodeTree.selectedItem;
				while (tItem && (! (tItem.path instanceof laya.display.Sprite ))){
					tItem=tItem.nodeParent;
				}
				if (tItem && tItem.path){
					preTar=tItem.path;
				}
			}
			if (!this._tar){
				this.nodeTree.array=[];
				}else{
				this.nodeTree.array=NodeUtils.getNodeTreeData(this._tar,this.showProps?NodeTree.showKeys:NodeTree.emptyShowKey);
			}
			if (preTar){
				this.selectByNode(preTar);
			}
		}

		__proto.treeRender=function(cell,index){
			var item=cell.dataSource;
			if (item){
				var isDirectory=item.child || item.isDirectory;
				var label=cell.getChildByName("label");
				if ((item.path instanceof laya.display.Node )){
					label.color="#09a4f6";
					}else{
					if (item.isChilds){
						label.color="#00ff11";
						}else{
						label.color="#838bc5";
					}
				}
			}
		}

		NodeTree.I=null
		NodeTree.emptyShowKey=[];
		__static(NodeTree,
		['showKeys',function(){return this.showKeys=["x","y","width","height","renderCost"];}
		]);
		return NodeTree;
	})(NodeTreeUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.NodeTreeSetting extends laya.debug.ui.debugui.NodeTreeSettingUI
	var NodeTreeSetting=(function(_super){
		function NodeTreeSetting(){
			NodeTreeSetting.__super.call(this);
			Base64AtlasManager.replaceRes(NodeTreeSettingUI.uiView);
			this.createView(NodeTreeSettingUI.uiView);
		}

		__class(NodeTreeSetting,'laya.debug.view.nodeInfo.nodetree.NodeTreeSetting',_super);
		var __proto=NodeTreeSetting.prototype;
		//inits();
		__proto.createChildren=function(){}
		return NodeTreeSetting;
	})(NodeTreeSettingUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.ObjectCreate extends laya.debug.ui.debugui.ObjectCreateUI
	var ObjectCreate=(function(_super){
		function ObjectCreate(){
			ObjectCreate.__super.call(this);
			Base64AtlasManager.replaceRes(ObjectCreateUI.uiView);
			this.createView(ObjectCreateUI.uiView);
		}

		__class(ObjectCreate,'laya.debug.view.nodeInfo.nodetree.ObjectCreate',_super);
		var __proto=ObjectCreate.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		return ObjectCreate;
	})(ObjectCreateUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.ObjectInfo extends laya.debug.ui.debugui.ObjectInfoUI
	var ObjectInfo=(function(_super){
		function ObjectInfo(){
			ObjectInfo.__super.call(this);
			Base64AtlasManager.replaceRes(ObjectInfoUI.uiView);
			this.createView(ObjectInfoUI.uiView);
		}

		__class(ObjectInfo,'laya.debug.view.nodeInfo.nodetree.ObjectInfo',_super);
		var __proto=ObjectInfo.prototype;
		__proto.createChildren=function(){}
		return ObjectInfo;
	})(ObjectInfoUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.OutPut extends laya.debug.ui.debugui.OutPutUI
	var OutPut=(function(_super){
		function OutPut(){
			OutPut.__super.call(this);
			Base64AtlasManager.replaceRes(OutPutUI.uiView);
			this.createView(OutPutUI.uiView);
		}

		__class(OutPut,'laya.debug.view.nodeInfo.nodetree.OutPut',_super);
		var __proto=OutPut.prototype;
		__proto.createChildren=function(){}
		return OutPut;
	})(OutPutUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.Profile extends laya.debug.ui.debugui.ProfileUI
	var Profile=(function(_super){
		function Profile(){
			this.views=null;
			Profile.__super.call(this);
			Base64AtlasManager.replaceRes(ProfileUI.uiView);
			this.createView(ProfileUI.uiView);
			this.views=[this.createPanel,this.renderPanel,this.cachePanel];
			this.tab.selectedIndex=0;
			this.tabChange();
			this.tab.on(/*laya.events.Event.CHANGE*/"change",this,this.tabChange);
		}

		__class(Profile,'laya.debug.view.nodeInfo.nodetree.Profile',_super);
		var __proto=Profile.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		__proto.tabChange=function(){
			DisControlTool.addOnlyByIndex(this.views,this.tab.selectedIndex,this);
		}

		return Profile;
	})(ProfileUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.Rank extends laya.debug.ui.debugui.RankUI
	var Rank=(function(_super){
		function Rank(){
			Rank.__super.call(this);
			Base64AtlasManager.replaceRes(RankUI.uiView);
			this.createView(RankUI.uiView);
		}

		__class(Rank,'laya.debug.view.nodeInfo.nodetree.Rank',_super);
		var __proto=Rank.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		return Rank;
	})(RankUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.SelectInfos extends laya.debug.ui.debugui.SelectInfosUI
	var SelectInfos=(function(_super){
		function SelectInfos(){
			SelectInfos.__super.call(this);
			Base64AtlasManager.replaceRes(SelectInfosUI.uiView);
			this.createView(SelectInfosUI.uiView);
		}

		__class(SelectInfos,'laya.debug.view.nodeInfo.nodetree.SelectInfos',_super);
		var __proto=SelectInfos.prototype;
		__proto.createChildren=function(){
			this.viewMapRegists();
		}

		return SelectInfos;
	})(SelectInfosUI)


	/**
	*...
	*@author ww
	*/
	//class laya.debug.view.nodeInfo.nodetree.ToolBar extends laya.debug.ui.debugui.ToolBarUI
	var ToolBar=(function(_super){
		function ToolBar(){
			ToolBar.__super.call(this);
			Base64AtlasManager.replaceRes(ToolBarUI.uiView);
			this.createView(ToolBarUI.uiView);
		}

		__class(ToolBar,'laya.debug.view.nodeInfo.nodetree.ToolBar',_super);
		var __proto=ToolBar.prototype;
		__proto.createChildren=function(){}
		return ToolBar;
	})(ToolBarUI)



})(window,document,Laya);
