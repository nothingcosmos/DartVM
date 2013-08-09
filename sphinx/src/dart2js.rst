src
###############################################################################

dart/sdk/lib/_internal/compiler/implementation

speed up
===============================================================================

r20305 | ngeoffray@google.com | 2013-03-21 17:48:04 +0900 (木, 21  3月 2013) | 2 lines

New CL for https://codereview.chromium.org/12770009/, but this time treat intercepted calls uniformly. The
regression we had was because a call on an interceptor was not optimized anymore.
Review URL: https://codereview.chromium.org//12951006



r19838 | kasperl@google.com | 2013-03-12 14:59:39 +0900 (火, 12  3月 2013) | 57 lines

Get rid of old code for union/intersection in HType.

Introduce the concept of an empty type mask and use it to represent
both truly non-nullable empty masks (conflicting) and nullable
empty masks (null).

Here are the differences (old ==> new) between the output of the union
and intersection operations when running all our tests:


R=ngeoffray@google.com
Review URL: https://codereview.chromium.org//12764005

RichardとDeltaBlueが大幅にスコア上方したけど、Tracerで減少したパッチ。
===============================================================================
25272 - 25253
revertしていないので、bugだったっぽい。


===============================================================================
===============================================================================
===============================================================================
===============================================================================


sdk/lib/_internal/compiler
dart --output-type=dart
--output-type=js



dart2js
bashなんだけどオプションを指定可能
--enable-diagnostic-colors
--library-root=
--heap_growth_rate=512
--checked

