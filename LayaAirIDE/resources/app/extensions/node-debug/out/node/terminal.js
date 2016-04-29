/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
"use strict";
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Path = require('path');
var FS = require('fs');
var CP = require('child_process');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var Terminal = (function () {
    function Terminal() {
    }
    Terminal.launchInTerminal = function (dir, args, envVars) {
        return this.terminalService().launchInTerminal(dir, args, envVars);
    };
    Terminal.killTree = function (processId) {
        return this.terminalService().killTree(processId);
    };
    /*
     * Is the given runtime executable on the PATH.
     */
    Terminal.isOnPath = function (program) {
        return this.terminalService().isOnPath(program);
    };
    Terminal.terminalService = function () {
        if (!this._terminalService) {
            if (process.platform === 'win32') {
                this._terminalService = new WindowsTerminalService();
            }
            else if (process.platform === 'darwin') {
                this._terminalService = new MacTerminalService();
            }
            else if (process.platform === 'linux') {
                this._terminalService = new LinuxTerminalService();
            }
            else {
                this._terminalService = new DefaultTerminalService();
            }
        }
        return this._terminalService;
    };
    return Terminal;
}());
exports.Terminal = Terminal;
var TerminalError = (function () {
    function TerminalError(message, linkId) {
        this.message = message;
        this.linkId = linkId;
    }
    return TerminalError;
}());
exports.TerminalError = TerminalError;
var DefaultTerminalService = (function () {
    function DefaultTerminalService() {
    }
    DefaultTerminalService.prototype.launchInTerminal = function (dir, args, envVars) {
        return new Promise(function (resolve, reject) {
            reject(new TerminalError(localize(0, null, process.platform)));
        });
    };
    DefaultTerminalService.prototype.killTree = function (pid) {
        // on linux and OS X we kill all direct and indirect child processes as well
        return new Promise(function (resolve, reject) {
            try {
                var cmd = Path.join(__dirname, './terminateProcess.sh');
                var result = CP.spawnSync(cmd, [pid.toString()]);
                if (result.error) {
                    reject(result.error);
                }
                else {
                    resolve();
                }
            }
            catch (err) {
                reject(err);
            }
        });
    };
    DefaultTerminalService.prototype.isOnPath = function (program) {
        try {
            if (!FS.existsSync(DefaultTerminalService.WHICH)) {
                CP.execSync(DefaultTerminalService.WHICH + " '" + program + "'");
            }
            return true;
        }
        catch (Exception) {
        }
        return false;
    };
    DefaultTerminalService.TERMINAL_TITLE = localize(1, null);
    DefaultTerminalService.WHICH = '/usr/bin/which';
    return DefaultTerminalService;
}());
var WindowsTerminalService = (function (_super) {
    __extends(WindowsTerminalService, _super);
    function WindowsTerminalService() {
        _super.apply(this, arguments);
    }
    WindowsTerminalService.prototype.launchInTerminal = function (dir, args, envVars) {
        return new Promise(function (resolve, reject) {
            var title = "\"" + dir + " - " + WindowsTerminalService.TERMINAL_TITLE + "\"";
            var command = "\"\"" + args.join('" "') + "\" & pause\""; // use '|' to only pause on non-zero exit code
            var cmdArgs = [
                '/c', 'start', title, '/wait',
                'cmd.exe', '/c', command
            ];
            // merge environment variables into a copy of the process.env
            var env = extendObject(extendObject({}, process.env), envVars);
            var options = {
                cwd: dir,
                env: env,
                windowsVerbatimArguments: true
            };
            var cmd = CP.spawn(WindowsTerminalService.CMD, cmdArgs, options);
            cmd.on('error', reject);
            resolve(cmd);
        });
    };
    WindowsTerminalService.prototype.killTree = function (pid) {
        // when killing a process in Windows its child processes are *not* killed but become root processes.
        // Therefore we use TASKKILL.EXE
        return new Promise(function (resolve, reject) {
            var cmd = "taskkill /F /T /PID " + pid;
            try {
                CP.execSync(cmd);
                resolve();
            }
            catch (err) {
                reject(err);
            }
        });
    };
    WindowsTerminalService.prototype.isOnPath = function (program) {
        try {
            CP.execSync(WindowsTerminalService.WHERE + " " + program);
            return true;
        }
        catch (Exception) {
        }
        return false;
    };
    WindowsTerminalService.CMD = 'cmd.exe';
    WindowsTerminalService.WHERE = 'where';
    return WindowsTerminalService;
}(DefaultTerminalService));
var LinuxTerminalService = (function (_super) {
    __extends(LinuxTerminalService, _super);
    function LinuxTerminalService() {
        _super.apply(this, arguments);
    }
    LinuxTerminalService.prototype.launchInTerminal = function (dir, args, envVars) {
        return new Promise(function (resolve, reject) {
            if (!FS.existsSync(LinuxTerminalService.LINUX_TERM)) {
                reject(new TerminalError(localize(2, null, LinuxTerminalService.LINUX_TERM), 20002));
                return;
            }
            var bashCommand = quote(args) + "; echo; read -p \"" + LinuxTerminalService.WAIT_MESSAGE + "\" -n1;";
            var termArgs = [
                '--title', ("\"" + LinuxTerminalService.TERMINAL_TITLE + "\""),
                '-x', 'bash', '-c',
                ("''" + bashCommand + "''") // wrapping argument in two sets of ' because node is so "friendly" that it removes one set...
            ];
            // merge environment variables into a copy of the process.env
            var env = extendObject(extendObject({}, process.env), envVars);
            var options = {
                cwd: dir,
                env: env
            };
            var cmd = CP.spawn(LinuxTerminalService.LINUX_TERM, termArgs, options);
            cmd.on('error', reject);
            cmd.on('exit', function (code) {
                if (code === 0) {
                    resolve(); // since cmd is not the terminal process but just a launcher, we do not pass it in the resolve to the caller
                }
                else {
                    reject(new TerminalError(localize(3, null, LinuxTerminalService.LINUX_TERM, code)));
                }
            });
        });
    };
    LinuxTerminalService.LINUX_TERM = '/usr/bin/gnome-terminal'; //private const string LINUX_TERM = "/usr/bin/x-terminal-emulator";
    LinuxTerminalService.WAIT_MESSAGE = localize(4, null);
    return LinuxTerminalService;
}(DefaultTerminalService));
var MacTerminalService = (function (_super) {
    __extends(MacTerminalService, _super);
    function MacTerminalService() {
        _super.apply(this, arguments);
    }
    MacTerminalService.prototype.launchInTerminal = function (dir, args, envVars) {
        return new Promise(function (resolve, reject) {
            // first fix the PATH so that 'runtimePath' can be found if installed with 'brew'
            // Utilities.FixPathOnOSX();
            // On OS X we do not launch the program directly but we launch an AppleScript that creates (or reuses) a Terminal window
            // and then launches the program inside that window.
            var osaArgs = [
                Path.join(__dirname, './terminalHelper.scpt'),
                '-t', MacTerminalService.TERMINAL_TITLE,
                '-w', dir,
            ];
            for (var _i = 0, args_1 = args; _i < args_1.length; _i++) {
                var a = args_1[_i];
                osaArgs.push('-pa');
                osaArgs.push(a);
            }
            if (envVars) {
                for (var key in envVars) {
                    osaArgs.push('-e');
                    osaArgs.push(key + '=' + envVars[key]);
                }
            }
            var stderr = '';
            var osa = CP.spawn(MacTerminalService.OSASCRIPT, osaArgs);
            osa.on('error', reject);
            osa.stderr.on('data', function (data) {
                stderr += data.toString();
            });
            osa.on('exit', function (code) {
                if (code === 0) {
                    resolve(); // since cmd is not the terminal process but just the osa tool, we do not pass it in the resolve to the caller
                }
                else {
                    if (stderr) {
                        reject(new TerminalError(stderr));
                    }
                    else {
                        reject(new TerminalError(localize(5, null, MacTerminalService.OSASCRIPT, code)));
                    }
                }
            });
        });
    };
    MacTerminalService.OSASCRIPT = '/usr/bin/osascript'; // osascript is the AppleScript interpreter on OS X
    return MacTerminalService;
}(DefaultTerminalService));
// ---- private utilities ----
/**
 * Quote args if necessary and combine into a space separated string.
 */
function quote(args) {
    var r = '';
    for (var _i = 0, args_2 = args; _i < args_2.length; _i++) {
        var a = args_2[_i];
        if (a.indexOf(' ') >= 0) {
            r += '"' + a + '"';
        }
        else {
            r += a;
        }
        r += ' ';
    }
    return r;
}
function extendObject(objectCopy, object) {
    for (var key in object) {
        if (object.hasOwnProperty(key)) {
            objectCopy[key] = object[key];
        }
    }
    return objectCopy;
}

//# sourceMappingURL=../../out/node/terminal.js.map
