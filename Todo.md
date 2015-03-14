This list things that need to be done on Tweener.

Most stuff like bugs and decisions should be listed on the "issues" tab instead of here. This is just a basic list before it gets moved to a more serious issue. Some of this stuff has even been done already.

## Decisions ##

### Small stuff ###

  * onOverwrite: it indeed should have the property name as a parameter?

### Debug level ###

Add a debugLevel/setDebugLevel/etc for debugging purposes... As in
  1. LOG ERRORS: trace try..catch data2
  1. LOG WARNINGS: trace non-fatal warnings, such as the transition time normalization
  1. LOG INFORMATION: trace stuff like all updates/adds/completion


### Direct function tweening ###

```
Tweener.addFunctionTween(mymc.gotoAndStop, {startParams:1, endParams:10, time:1, ...});
Tweener.addFunctionTween(myObj.setPositionXY, {startParams:[0,0], endParams:[10,20], time:1, ...});
```

### Sequencing ###

> Sequences.Sequences.Sequences.Sequences.Sequences.Sequences.Sequences.Sequences.Sequences.Sequences.

  * + yoyo, circular, et al; http://livedocs.adobe.com/flash/8/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00004167.html
  * onUpdate must receive a parameter: 0-1 that indicates the ammount of tweening complete
  * parameter for looping: "yoyo" (similar to Tween.yoyo()), "circular"; [@see discussion list thread](http://lists.caurinauebi.com/pipermail/tweener-caurinauebi.com/2007-May/000048.html)
  * setDefault() method to set the default value for some properties - time, transition, delay, rounded, ...
  * "minimumFPS" or "enforceFPS", to use the enforced FPS some AS3 engines (like Flex's Tween one) uses? -> can have framerate per stage, as in "stage.frameRate = 30;".
  * speed optimizations when adding and updating tweenings - test with heavy.fla. must also benchmark additions on existing tweenings, and removal time
  * allow arrays as the transition parameter so it can use multi-equation transitions
  * onUpdate must be fired even if there's no property being tweened -> done? must test
  * debug\_setModifierKey() so timeScale can easily be changed when debugging (ie, SHIFT activates fast-forward)?
  * properly support .useFrames!
  * when restarting the movie twice in a roll with ctrl+enter from the flash IDE, problems arise because flash doesn't reset class variables. existing tweenings carry? check a better way of using `_`engineExists...
  * make a proper addCaller (beautify the existing one) - suggested by Paulo Afonso
  * addCaller doesn't work with several movieclips. calledTimes should be independent from scope... or call them all at the same time?
  * Some method for sequences; addTweenSeq? [@see discussion list thread](http://lists.caurinauebi.com/pipermail/tweener-caurinauebi.com/2007-May/000051.html)
  * .start and .complete events for special properties/modifiers, to allow more complex properties; [@see discussion list hread](http://lists.caurinauebi.com/pipermail/tweener-caurinauebi.com/2007-May/000057.html)
  * add endTween, skipTween (scrub?).. as suggested by Ephraim Tabackman
  * add onPause()
  * add onResume()
  * add onRemove()


### Decisions, decisions ###

  * add .scopes back, but making it some kind of special multi-tween in which variables are tied together?
  * TODO: make on`*`() events also respond to instances... use addListener?

## A lot of random stuff with no proper wiki format ##

http://livedocs.macromedia.com/labs/as3preview/langref/statements.html#try..catch..finally

http://www.kirupa.com/forum/showthread.php?p=1957523#post1957523