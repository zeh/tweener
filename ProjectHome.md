Tweener (caurina.transitions.Tweener) is a Class used to create tweenings and other transitions via ActionScript code for projects built on the Flash platform.

Three different official versions of Tweener are available for download:

  * ActionScript 2.0, for Flash 7+ and Flash Lite 2.0+
  * ActionScript 2.0, for Flash 8+
  * ActionSctipt 3.0, for Flash 9+

Tweener was maintained from june 2005 to june 2009. While it still works, it's not being maintained anymore, so no more updates will be released. There are many modern alternative [tweening engines](https://www.google.com/#q=tweening+engines+in+actionscript) available for download.

Ported versions or otherwise Tweener-inspired libraries are also available for other languages or platforms:

  * [haXe version](http://www.ralcr.com/caurina/) (ported by [Baluta Cristian](http://www.ralcr.com/))
  * [JavaScript version](http://tweener.ivank.net/) (ported by [Ivan Kuckir](http://www.ivank.net/cs/flash))
  * [JavaScript version](http://coderepos.org/share/wiki/JSTweener) (ported by [Yuichi Tateno](http://d.hatena.ne.jp/secondlife))
  * [vvvv version](http://code.google.com/p/tweener/downloads/list?q=label:Platform-vvvv) using nodes
  * [vvvv version](http://vvvv.svn.sourceforge.net/viewvc/vvvv/plugins/c%23/Value/TweenerShaper/trunk/) using a native C# dll (faster) (ported by by Rene Westhof)
  * [Python version](http://wiki.python-ogre.org/index.php/CodeSnippits_pyTweener) (ported by Benjamin Harling)
  * [C++ version](http://code.google.com/p/cpptweener/) (ported by [Wesley Marques](http://codevein.com/))
  * [claw::tween](http://libclaw.sourceforge.net/tweeners.html), an alternate C++ version and part of [libclaw](http://libclaw.sourceforge.net/) (ported by [Julien Jorge](http://julien.jorge.free.fr))

There are also some other libraries inspired by it:
  * [Artefact Animator](http://artefactanimator.codeplex.com/) for Silverlight/WPF (by [Jesse Graupmann](http://www.jessegraupmann.com/), among others)
  * [TweenC](http://www.tweenc.com/) for iOS/Objective-C (by John Giatropoulos)

In layman's terms, Tweener helps you move things around on the screen using only code, instead of the timeline.

The general idea of a tweening Class is that dynamic animation and transitions (created by code) are easier to maintain and control, and more stable than animation based on the regular Flash timeline, since you can control it by time rather than by frames.

Aimed both for designers and advanced developers, the Tweener syntax is created with **simplicity** of use in mind, while still allowing access to more advanced features. Because of this, it follows a 'one-line' design mentality when creating new tweenings, with no instancing required (as it's a static Class) and a set of optional parameters. Also, there are no initialization methods required by Tweener, other than the mandatory 'import' command.

Its fluid syntax allows it to be used to tween any numeric property of any object of any class, so it is not tied to specific properties of built-in Classes such as MovieClips or TextFields. This **flexibility** grants a wider control on how transitions are performed, and makes creating complex sequential transitions on any kind of object easier.

Small file overhead is also one of the main goals of Tweener - once included on SWF movies, Tweener currently takes 8.8kb (AS2 FL2), 9.2kb (AS2) or 10.4kb (AS3) of the total compiled file size. It can be compiled with the Flash IDE, MTASC, or Flex SDK (even with strict rules on), with no errors or warnings thrown during compilation.

Tweener is also the spiritual successor to [MC Tween](http://hosted.zeh.com.br/mctween). However, it follows ActionScript's more strict OOP rules, and gets rid of the fixed parameter order syntax imposed by MC Tween. As a result, code written with Tweener is a lot more readable even for developers not versed on the Class.

Development wise, **modularity** is one of the main aspects of Tweener. The code is built in a way that new features such as transitions and special tweenings can be added (or removed) easily: for example, properties that are only acessible through methods and functions can be tweened by creating and registering new special properties. Expanding the feature set of the original Class can be done on a per-project basis, with no change to the original files.

From this page, you can download [the latest stable (heavily tested) version](http://code.google.com/p/tweener/downloads/list) of Tweener, check out a few [examples with source](http://tweener.googlecode.com/svn/trunk/examples/), or [read the documentation](http://hosted.zeh.com.br/tweener/docs/).

If you prefer, you can also [get the very latest versions from Subversion](http://code.google.com/p/tweener/source), before they're considered stable and featured on the download list (the changelog is available [here](http://code.google.com/p/tweener/wiki/Changelog)). The repository can also be viewed [with a web browser](http://tweener.googlecode.com/svn/trunk/).