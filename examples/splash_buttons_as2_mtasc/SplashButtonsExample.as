import caurina.transitions.Tweener;

class SplashButtonsExample {
	function SplashButtonsExample(scope:MovieClip) {
		// "Fun" button
		scope.b1.onRollOver = function() {
			Tweener.addTween(this, {_xscale:170, _yscale:170, time:1, transition:"easeoutelastic"});
		};

		scope.b1.onRollOut = scope.b1.onReleaseOutside = function() {
			Tweener.addTween(this, {_xscale:100, _yscale:100, time:1, transition:"easeoutelastic"});
		};

		// "Polite" button

		scope.b2.onRollOver = function() {
			Tweener.addTween(this, {_xscale:120, _yscale:120, _rotation:10, time:1});
		};

		scope.b2.onRollOut = scope.b2.onReleaseOutside = function() {
			Tweener.addTween(this, {_xscale:100, _yscale:100, _rotation:0, time:1});
		};

		// "Shy" button

		scope.b3._alpha = 20;
		scope.b3.blendMode = "layer";

		scope.b3.onRollOver = function() {
			Tweener.addTween(this, {_alpha:100, time:1});
		};

		scope.b3.onRollOut = scope.b3.onReleaseOutside = function() {
			Tweener.addTween(this, {_alpha:20, time:1});
		};


		// "Trippy" button

		scope.b4.onRollOver = function() {
			Tweener.addTween(this.inner, {_color:Math.floor(Math.random() * 0xffffff), time:0.25, delay:0, transition:"linear"});
			Tweener.addTween(this.inner, {_color:Math.floor(Math.random() * 0xffffff), time:0.25, delay:0.25, transition:"linear"});
			Tweener.addTween(this.inner, {_color:Math.floor(Math.random() * 0xffffff), time:0.25, delay:0.5, transition:"linear"});
			Tweener.addTween(this.inner, {_color:Math.floor(Math.random() * 0xffffff), time:0.25, delay:0.75, transition:"linear"});
		//	Tweener.addTween(this, {_xscale:150, _yscale:150, _rotation:370, time:1, transition:"easeinquad"});
			Tweener.addTween(this, {_rotation:370, time:1, transition:"easeinoutquad"});
			Tweener.addTween(this, {_xscale:150, _yscale:50, time:0.33, delay:0, transition:"easeinoutquad"});
			Tweener.addTween(this, {_xscale:50, _yscale:150, time:0.33, delay:0.33, transition:"easeinoutquad"});
			Tweener.addTween(this, {_xscale:150, _yscale:150, time:0.34, delay:0.66, transition:"easeinoutquad"});
		};

		scope.b4.onRollOut = scope.b4.onReleaseOutside = function() {
			Tweener.addTween(this, {_xscale:100, _yscale:100, _rotation:-360, time:1, transition:"easeoutquad"});
			Tweener.addTween(this.inner, {_color:null, time:1, transition:"linear"});
		};

	}
}