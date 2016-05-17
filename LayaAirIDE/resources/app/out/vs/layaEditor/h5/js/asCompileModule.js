function asCompileModule(player) {
    layaEditeVscode.clearOutput("Tasks");
    //layaEditeVscode.showOutput("Tasks", true);
    var iconv = require('iconv-lite');
    clearInterval(layaWaitComplete);
    var count = 0;
    var arcount = [".", "...", ".....", "......", "........"];
    var infoLaya = ["|", "/", "-", "\\", "|"]
    layaAndvscodeInfo.className = "task-statusbar-item-progress";
    layaWaitComplete = setInterval(function () {
        count++;
        count = count % 5;
        layaInfo.innerHTML = "开始编译:" + arcount[count];
        layaAndvscodeInfo.innerHTML = infoLaya[count]
    }, 50);
    var configPath = configuration.workspacePath + path.sep + ".actionScriptProperties";
    if (!fs.existsSync(configPath)) {
        configPath = ""
        var fileList = fs.readdirSync(configuration.workspacePath);
        for (var i = 0; i < fileList.length; i++) {
            if (fileList[i].indexOf(".as3proj") != -1) {
                var stat = fs.lstatSync(configuration.workspacePath + path.sep + fileList[i]);
                if (!stat.isDirectory()) {
                    configPath = configuration.workspacePath + path.sep + fileList[i];
                    break;
                }
            }
        }
    }
    if (!configPath) {
        return
    }
    var arg = configPath + ";iflash=false;windowshow=false;chromerun=false";
    var compileProcess = require('child_process').spawn;
    var pathFile = path.dirname(__dirname) + path.sep + "libs" + path.sep + "layajs" + path.sep + "layajs";
    var compileProcess = compileProcess(pathFile, [arg]);
    compileProcess.stdout.on('close', function () {
        handlerResult();
        layaInfo.innerHTML = "编译完成";
        layaAndvscodeInfo.className = "task-statusbar-item-progress hidden";
        clearInterval(layaWaitComplete);
    });
    var layaResult = "";
    var htmlPath;
    layaEditeVscode.clearOutput("Tasks");
    layaEditeVscode.append("Tasks", "开始编译...");
    var resultAS = "";
    var compileErrors = [];
    compileProcess.stdout.on('data', function (chunk) {
        var data = iconv.decode(chunk, 'GBK');
        layaResult += data;
    });
    function handlerResult() {
        layaEditeVscode.append("Tasks", "\n编译完成...");
        debugButton.style.pointerEvents = "";
        debugButton.style.backgroundColor = ""
        var resultArr = layaResult.split("\n");									//分割每条信息的子项;
        while (resultArr.length) {
            var info = resultArr.shift();
            info = info.split(",");
            handlerInfo(info);
        }
        ipc.send("layaDebugerWinMessage", player, htmlPath);

    }

    function handlerInfo(info) {
        if (info[0] == "MSG") {
            switch (info[1]) {
                case '1': //MSG
                    //ignore
                    break;
                case '2': //parse
                    break;
                case '3': //precompile
                    break;
                case '4': //start
                    break;
                case '5': //compile
                    break;
                case '6': //warning
                    console.log('warning ' + info);
                    break;
                case '7': //error
                    layaEditeVscode.showOutput("Tasks", true);
                    var err = "\n";
                    err += info[3];//文件；
                    err += " 第" + info[4] + "行";
                    err += " " + info[5].replace("This variable is not defined", "变量未定义") + "\n";
                    layaEditeVscode.append("Tasks", err);
                    break;
                case '8': //exclude
                    break;
                case '9': //compile end
                    break;
                case '10': //crashes
                    break;
                case '11': //save html
                    htmlPath = info[3];
                    break;
                case '12': //save js
                    break;
                case '13': //js
                    break;
                case '14': //exit
                    break;
            }
        }
    }

}
var UglifyJS = require('uglify-js');
function comprssJSModule() {
    document.getElementById("title_dialg").innerText = "JS压缩";
    document.getElementById("ouibounce-modal").style.zIndex = 10
    showDivPop(compressJS)
    var holder = document.getElementById('ouibounce-modal');
    holder.ondrop = function(e)
    {
        e.preventDefault();
        var file = e.dataTransfer.files[0];
        var r = fs.lstatSync(file.path)
        if(!r.isDirectory())
        {
            if(file.path.lastIndexOf(".js")!=-1)
            {
                layajsInputCompress.value = file.path;
                layajsOutputCompress.value = file.path.replace(".js",".mini.js");
            }

        }
    };
    showDiv("compressJS");
    layajsInputCompressBtn.onclick = function () {
        dialogLaya.showOpenDialog({
            properties: ["openFile", 'createDirectory'],
            filters: [{name: 'All Files', extensions: ['js']}]
        }, function (pathLaya) {
            if (pathLaya) {
                layajsInputCompress.value = pathLaya[0];
                layajsOutputCompress.value = pathLaya[0].replace(".js",".mini.js")
            }
        })
    }
    layajsOuputCompressBtn.onclick = function () {
        dialogLaya.showOpenDialog({properties: ["openDirectory", 'createDirectory']}, function (pathjs) {
            pathjs= pathjs[0];
            layajsOutputCompress.value = pathjs+path.sep+path.basename(layajsInputCompress.value).replace(".js",".mini.js")
        });
    }
    var loadingID
    layajsOKCompressBtn.onclick = function () {
        if (layajsInputCompress.value && layajsOutputCompress.value) {
            if (!fs.existsSync(layajsInputCompress.value))return
            compressJS.style.display = "none";
            showDialg(loadingCompress);
            var count = 1;
            loadingID = setInterval(showLoading, 20);
            setTimeout(function () {
                try{
                    var result = UglifyJS.minify([layajsInputCompress.value]);
                    fs.writeFile(layajsOutputCompress.value, result.code);
                }catch (e){
                    alert("压缩失败！"+ e.stack)
                }

            }, 10)
            function showLoading() {
                if (count > 99) {
                    clearInterval(loadingID);
                    compressJS.style.display = "block";
                    loadingCompress.style.display = "none"
                }
                DrowProcess("压缩中...", count += 2)
            }
        }

    }
    var myCanvas = document.getElementById("myCanvas");
    var myctx = myCanvas.getContext("2d");
    function DrowProcess(msg, process) {
        var W = myCanvas.width;
        var H = myCanvas.height;
        var text, text_w;
        myctx.clearRect(0, 0, W, H);
        myctx.beginPath();
        myctx.strokeStyle = "#494949";
        myctx.lineWidth = 10;
        myctx.arc(W / 2, H / 2, 60, 0, Math.PI * 2, false);
        myctx.stroke();
        var r = process / 100 * 2 * Math.PI;
        myctx.beginPath();
        myctx.strokeStyle = "lightgreen";
        myctx.lineWidth = 10;
        myctx.arc(W / 2, H / 2, 60, 0 - 90 * Math.PI / 180, r - Math.PI / 2, false);
        myctx.stroke();
        myctx.fillStyle = "#999999";
        myctx.font = "16px abc";
        text = msg + process + "%";
        text_w = myctx.measureText(text).width;
        myctx.fillText(text, W / 2 - text_w / 2, H / 2 + 8);
    }
}