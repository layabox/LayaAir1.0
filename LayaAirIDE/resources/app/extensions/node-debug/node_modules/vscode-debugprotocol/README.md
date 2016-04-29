# VS Code Debug Protocol

[![NPM Version](https://img.shields.io/npm/v/vscode-debugprotocol.svg)](https://npmjs.org/package/vscode-debugprotocol)
[![NPM Downloads](https://img.shields.io/npm/dm/vscode-debugprotocol.svg)](https://npmjs.org/package/vscode-debugprotocol)

This npm module contains declarations for the json-based Visual Studio Code debug protocol.

## History

* 1.7.x:
  * Adds optional `url` and `urlLabel` attributes to the error messages. The frontend will show this as a UI to open additional information in a browser.
  * Added option `default` attribute to the `exceptionBreakpointFilters` capability.
  * Adds optional attribute `allThreadsStopped` to the `StoppedEvent` to indicate that all threads are stopped (and not only the one mentioned in the event).

* 1.6.x:
  * A boolean `supportsConditionalBreakpoints` in `Capabilities` indicates whether the debug adapter supports conditional breakpoints.
  * Adds an optional `exceptionBreakpointFilters` capability that lists the filters available for the `setExceptionBreakpoints` request.
  * Adds an optional `restart` attribute to the `TerminatedEvent` which can be used to request a restart of the debug session.

* 1.5.x:
  * A boolean `supportsFunctionBreakpoints` in `Capabilities` indicates whether the debug adapter implements the function breakpoints.
  * Renamed `supportEvaluateForHovers` in `Capabilities` to `supportsEvaluateForHovers`.

* 1.4.x:
  * Made the `body` of the `InitializeResponse` optional (for backward compatibility).

* 1.3.x: Version introduces support for feature negotiation.
  * The `InitializeResponse` has now attributes for these features:
    * A boolean `supportsConfigurationDoneRequest` indicates whether the debug adapter implements the `ConfigurationDoneRequest`.
    * A boolean `supportEvaluateForHovers` indicates whether the debug adapter supports a side effect free `EvaluateRequest`.
  * Adds an optional `data` attribute to the `OutputEvent` and a `telemetry` category.
  * Adds a new context type `hover` to the `context` attribute of the `EvaluateArguments`.

* 1.2.x: Version adds a new request:
  * Introduces a `ConfigurationDoneRequest` that VS Code sends to indicate that the configuration of the debug session has finished and that debugging can start.

* 1.1.x: Version adds support for conditional breakpoints and breakpoints in virtual documents:
  * Type `Source` supports optional `origin` attribute to provide information that is shown in the debug UI.
  * Type `Source` supports an optional `adapterData` attribute that the VS Code debug UI will transparently persists for breakpoints.
  * Introduces type `SourceBreakpoint` that makes it possible to provide `column` and `condition` information when specifying a breakpoint.

* 1.0.1: Initial version of the debug protocol

## License

[MIT](https://github.com/Microsoft/vscode-languageserver-node/blob/master/License.txt)
