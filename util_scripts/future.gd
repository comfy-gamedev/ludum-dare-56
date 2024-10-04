@tool
class_name Future
extends RefCounted
## An async wrapper which allows awaiting multiple signals at once.
##
## Usage:
## ```
## var results = await Future.all_signals([some_signal, another_signal]).done
## var some_signal_result = results[0]
## var another_signal_result = results[1]
## ```

## Emitted when all signals have been emitted.
##
## [param results]: an array containing the results of the signals
## in the same order as they were provided.
signal done(results: Array)

var _results: Array = []

var _remaining: int

## Creates a Future which awaits all the given signals.
static func all_signals(signals: Array[Signal]) -> Future:
	var f := Future.new()
	f._results.resize(signals.size())
	f._remaining = signals.size()
	for i: int in signals.size():
		var s := signals[i]
		var c := func _all_signals_call():
			f._results[i] = await s
			assert(f._remaining > 0)
			f._remaining -= 1
			if f._remaining <= 0:
				f.done.emit(f._results)
		c.call()
	return f
