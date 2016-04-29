/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var path = require('path');
var fs = require('fs');
var electron = require('./utils/electron');
var wireProtocol_1 = require('./utils/wireProtocol');
var vscode_1 = require('vscode');
var VersionStatus = require('./utils/versionStatus');
var vscode_extension_telemetry_1 = require('vscode-extension-telemetry');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var TypeScriptServiceClient = (function () {
    function TypeScriptServiceClient(host) {
        var _this = this;
        this.host = host;
        this.pathSeparator = path.sep;
        var p = new Promise(function (resolve, reject) {
            _this._onReady = { promise: null, resolve: resolve, reject: reject };
        });
        this._onReady.promise = p;
        this.servicePromise = null;
        this.lastError = null;
        this.sequenceNumber = 0;
        this.exitRequested = false;
        this.firstStart = Date.now();
        this.numberRestarts = 0;
        this.requestQueue = [];
        this.pendingResponses = 0;
        this.callbacks = Object.create(null);
        this.tsdk = vscode_1.workspace.getConfiguration().get('typescript.tsdk', null);
        vscode_1.workspace.onDidChangeConfiguration(function () {
            var oldTask = _this.tsdk;
            _this.tsdk = vscode_1.workspace.getConfiguration().get('typescript.tsdk', null);
            if (_this.servicePromise === null && oldTask !== _this.tsdk) {
                _this.startService();
            }
        });
        if (this.packageInfo && this.packageInfo.aiKey) {
            this.telemetryReporter = new vscode_extension_telemetry_1.default(this.packageInfo.name, this.packageInfo.version, this.packageInfo.aiKey);
        }
        this.startService();
    }
    TypeScriptServiceClient.prototype.onReady = function () {
        return this._onReady.promise;
    };
    Object.defineProperty(TypeScriptServiceClient.prototype, "trace", {
        get: function () {
            return TypeScriptServiceClient.Trace;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(TypeScriptServiceClient.prototype, "packageInfo", {
        get: function () {
            if (this._packageInfo !== undefined) {
                return this._packageInfo;
            }
            var packagePath = path.join(__dirname, './../package.json');
            var extensionPackage = require(packagePath);
            if (extensionPackage) {
                this._packageInfo = {
                    name: extensionPackage.name,
                    version: extensionPackage.version,
                    aiKey: extensionPackage.aiKey
                };
            }
            else {
                this._packageInfo = null;
            }
            return this._packageInfo;
        },
        enumerable: true,
        configurable: true
    });
    TypeScriptServiceClient.prototype.logTelemetry = function (eventName, properties) {
        if (this.telemetryReporter) {
            this.telemetryReporter.sendTelemetryEvent(eventName, properties);
        }
    };
    TypeScriptServiceClient.prototype.service = function () {
        if (this.servicePromise) {
            return this.servicePromise;
        }
        if (this.lastError) {
            return Promise.reject(this.lastError);
        }
        this.startService();
        return this.servicePromise;
    };
    TypeScriptServiceClient.prototype.startService = function (resendModels) {
        var _this = this;
        if (resendModels === void 0) { resendModels = false; }
        var modulePath = path.join(__dirname, '..', 'server', 'typescript', 'lib', 'tsserver.js');
        if (this.tsdk) {
            if (path.isAbsolute(this.tsdk)) {
                modulePath = path.join(this.tsdk, 'tsserver.js');
            }
            else if (vscode_1.workspace.rootPath) {
                modulePath = path.join(vscode_1.workspace.rootPath, this.tsdk, 'tsserver.js');
            }
        }
        if (!fs.existsSync(modulePath)) {
            vscode_1.window.showErrorMessage(localize(0, null, path.dirname(modulePath)));
            return;
        }
        var label = this.getTypeScriptVersion(modulePath);
        var tooltip = modulePath;
        VersionStatus.enable(!!this.tsdk);
        VersionStatus.setInfo(label, tooltip);
        this.servicePromise = new Promise(function (resolve, reject) {
            try {
                var options = {
                    execArgv: [] //[`--debug-brk=5859`]
                };
                var value = process.env.TSS_DEBUG;
                if (value) {
                    var port = parseInt(value);
                    if (!isNaN(port)) {
                        options.execArgv = [("--debug=" + port)];
                    }
                }
                electron.fork(modulePath, [], options, function (err, childProcess) {
                    if (err) {
                        _this.lastError = err;
                        vscode_1.window.showErrorMessage(localize(1, null), err.message);
                        _this.logTelemetry('error', { message: err.message });
                        return;
                    }
                    _this.lastStart = Date.now();
                    childProcess.on('error', function (err) {
                        _this.lastError = err;
                        _this.serviceExited(false);
                    });
                    childProcess.on('exit', function (err) {
                        _this.serviceExited(true);
                    });
                    _this.reader = new wireProtocol_1.Reader(childProcess.stdout, function (msg) {
                        _this.dispatchMessage(msg);
                    });
                    _this._onReady.resolve();
                    resolve(childProcess);
                });
            }
            catch (error) {
                reject(error);
                _this._onReady.reject();
            }
        });
        this.serviceStarted(resendModels);
    };
    TypeScriptServiceClient.prototype.serviceStarted = function (resendModels) {
        if (resendModels) {
            this.host.populateService();
        }
    };
    TypeScriptServiceClient.prototype.getTypeScriptVersion = function (serverPath) {
        var custom = localize(2, null);
        var p = serverPath.split(path.sep);
        if (p.length <= 2) {
            return custom;
        }
        var p2 = p.slice(0, -2);
        var modulePath = p2.join(path.sep);
        var fileName = path.join(modulePath, 'package.json');
        if (!fs.existsSync(fileName)) {
            return custom;
        }
        var contents = fs.readFileSync(fileName).toString();
        var desc = null;
        try {
            desc = JSON.parse(contents);
        }
        catch (err) {
            return custom;
        }
        if (!desc.version) {
            return custom;
        }
        return desc.version;
    };
    TypeScriptServiceClient.prototype.serviceExited = function (restart) {
        var _this = this;
        this.servicePromise = null;
        Object.keys(this.callbacks).forEach(function (key) {
            _this.callbacks[parseInt(key)].e(new Error('Service died.'));
        });
        this.callbacks = Object.create(null);
        if (!this.exitRequested && restart) {
            var diff = Date.now() - this.lastStart;
            this.numberRestarts++;
            var startService = true;
            if (this.numberRestarts > 5) {
                if (diff < 60 * 1000 /* 1 Minutes */) {
                    vscode_1.window.showWarningMessage(localize(3, null));
                }
                else if (diff < 2 * 1000 /* 2 seconds */) {
                    startService = false;
                    vscode_1.window.showErrorMessage(localize(4, null));
                    this.logTelemetry('serviceExited');
                }
            }
            if (startService) {
                this.startService(true);
            }
        }
    };
    TypeScriptServiceClient.prototype.asAbsolutePath = function (resource) {
        if (resource.scheme !== 'file') {
            return null;
        }
        var result = resource.fsPath;
        // Both \ and / must be escaped in regular expressions
        return result ? result.replace(new RegExp('\\' + this.pathSeparator, 'g'), '/') : null;
    };
    TypeScriptServiceClient.prototype.asUrl = function (filepath) {
        return vscode_1.Uri.file(filepath);
    };
    TypeScriptServiceClient.prototype.execute = function (command, args, expectsResultOrToken, token) {
        var _this = this;
        var expectsResult = true;
        if (typeof expectsResultOrToken === 'boolean') {
            expectsResult = expectsResultOrToken;
        }
        else {
            token = expectsResultOrToken;
        }
        var request = {
            seq: this.sequenceNumber++,
            type: 'request',
            command: command,
            arguments: args
        };
        var requestInfo = {
            request: request,
            promise: null,
            callbacks: null
        };
        var result = null;
        if (expectsResult) {
            result = new Promise(function (resolve, reject) {
                requestInfo.callbacks = { c: resolve, e: reject, start: Date.now() };
                if (token) {
                    token.onCancellationRequested(function () {
                        _this.tryCancelRequest(request.seq);
                        var err = new Error('Canceled');
                        err.message = 'Canceled';
                        reject(err);
                    });
                }
            });
        }
        requestInfo.promise = result;
        this.requestQueue.push(requestInfo);
        this.sendNextRequests();
        return result;
    };
    TypeScriptServiceClient.prototype.sendNextRequests = function () {
        while (this.pendingResponses === 0 && this.requestQueue.length > 0) {
            this.sendRequest(this.requestQueue.shift());
        }
    };
    TypeScriptServiceClient.prototype.sendRequest = function (requestItem) {
        var _this = this;
        var serverRequest = requestItem.request;
        if (TypeScriptServiceClient.Trace) {
            console.log('TypeScript Service: sending request ' + serverRequest.command + '(' + serverRequest.seq + '). Response expected: ' + (requestItem.callbacks ? 'yes' : 'no') + '. Current queue length: ' + this.requestQueue.length);
        }
        if (requestItem.callbacks) {
            this.callbacks[serverRequest.seq] = requestItem.callbacks;
            this.pendingResponses++;
        }
        this.service().then(function (childProcess) {
            childProcess.stdin.write(JSON.stringify(serverRequest) + '\r\n', 'utf8');
        }).catch(function (err) {
            var callback = _this.callbacks[serverRequest.seq];
            if (callback) {
                callback.e(err);
                delete _this.callbacks[serverRequest.seq];
                _this.pendingResponses--;
            }
        });
    };
    TypeScriptServiceClient.prototype.tryCancelRequest = function (seq) {
        for (var i = 0; i < this.requestQueue.length; i++) {
            if (this.requestQueue[i].request.seq === seq) {
                this.requestQueue.splice(i, 1);
                if (TypeScriptServiceClient.Trace) {
                    console.log('TypeScript Service: canceled request with sequence number ' + seq);
                }
                return true;
            }
        }
        if (TypeScriptServiceClient.Trace) {
            console.log('TypeScript Service: tried to cancel request with sequence number ' + seq + '. But request got already delivered.');
        }
        return false;
    };
    TypeScriptServiceClient.prototype.dispatchMessage = function (message) {
        try {
            if (message.type === 'response') {
                var response = message;
                var p = this.callbacks[response.request_seq];
                if (p) {
                    if (TypeScriptServiceClient.Trace) {
                        console.log('TypeScript Service: request ' + response.command + '(' + response.request_seq + ') took ' + (Date.now() - p.start) + 'ms. Success: ' + response.success + ((!response.success) ? ('. Message: ' + response.message) : ''));
                    }
                    delete this.callbacks[response.request_seq];
                    this.pendingResponses--;
                    if (response.success) {
                        p.c(response);
                    }
                    else {
                        p.e(response);
                    }
                }
            }
            else if (message.type === 'event') {
                var event = message;
                if (event.event === 'syntaxDiag') {
                    this.host.syntaxDiagnosticsReceived(event);
                }
                if (event.event === 'semanticDiag') {
                    this.host.semanticDiagnosticsReceived(event);
                }
            }
            else {
                throw new Error('Unknown message type ' + message.type + ' recevied');
            }
        }
        finally {
            this.sendNextRequests();
        }
    };
    TypeScriptServiceClient.Trace = process.env.TSS_TRACE || false;
    return TypeScriptServiceClient;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TypeScriptServiceClient;
//# sourceMappingURL=typescriptServiceClient.js.map