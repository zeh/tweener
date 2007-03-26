/**
 * Tweener
 * Transition controller for movieclips, sounds, textfields and other objects
 *
 * @author		Zeh Fernando, Nate Chatellier, Arthur Debert
 * @version		1.22.41
 */

/*
Licensed under the MIT License

Copyright (c) 2007 Zeh Fernando, Nate Chatellier

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
*/

import caurina.transitions.Equations;
import caurina.transitions.AuxFunctions;
import caurina.transitions.SpecialPropertiesDefault;
import caurina.transitions.SpecialPropertyModifier;
import caurina.transitions.SpecialPropertySplitter;
import caurina.transitions.TweenListObj;

class caurina.transitions.Tweener {

	private static var _engineExists:Boolean = false;		// Whether or not the engine is currently running
	private static var _inited:Boolean = false;				// Whether or not the class has been initiated
	private static var _currentTime:Number;					// The current time. This is generic for all tweenings for a "time grid" based update

	private static var _tweenList:Array;						// List of active tweens

	private static var _timeScale:Number = 1;				// Time scale (default = 1)

	private static var _transitionList:Array;					// Array of "pre-fetched" transition functions
	private static var _specialPropertyList:Array;			// Array of special property modifiers
	private static var _specialPropertySplitterList:Array;	// Array of special property splitters


	/**
	 * There's no constructor.
	 */
	public function Tweener () {
		trace ("Tweener is an static class and should not be instantiated.")
	}


	// ==================================================================================================================================
	// TWEENING CONTROL functions -------------------------------------------------------------------------------------------------------

	/**
	 * Adds a new tweening
	 *
	 * @param		(first-n param)		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
	 * @param		(last param)		Object				Object containing the specified parameters in any order, as well as the properties that should be tweened and their values
	 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
	 * @param		.delay				Number				Delay time (defaults 0)
	 * @param		.useFrames			Boolean				Whether to use frames instead of seconds for time control (defaults false)
	 * @param		.transition			String/Function		Type of transition equation... (defaults to "easeoutexpo")
	 * @param		.onStart			Function			* Direct property, See the TweenListObj class
	 * @param		.onUpdate			Function			* Direct property, See the TweenListObj class
	 * @param		.onComplete			Function			* Direct property, See the TweenListObj class
	 * @param		.onOverwrite		Function			* Direct property, See the TweenListObj class
	 * @param		.onStartParams		Array				* Direct property, See the TweenListObj class
	 * @param		.onUpdateParams		Array				* Direct property, See the TweenListObj class
	 * @param		.onCompleteParams	Array				* Direct property, See the TweenListObj class
	 * @param		.onOverwriteParams	Array				* Direct property, See the TweenListObj class
	 * @param		.rounded			Boolean				* Direct property, See the TweenListObj class
	 * @param		.skipUpdates		Number				* Direct property, See the TweenListObj class
	 * @return							Boolean				TRUE if the tween was successfully added, FALSE if otherwise
	 */
	public static function addTween ():Boolean {
		if (arguments.length < 2 || arguments[0] == undefined) return false;

		var rScopes:Array = new Array(); // List of objects to tween
		var i:Number, j:Number, istr:String, jstr:String;

		if (arguments[0] instanceof Array) {
			// The first argument is an array
			for (i = 0; i<arguments[0].length; i++) rScopes.push(arguments[0][i]);
		} else {
			// The first argument(s) is(are) object(s)
			for (i = 0; i<arguments.length-1; i++) rScopes.push(arguments[i]);
		}
		// rScopes = arguments.concat().splice(1); // Alternate (should be tested for speed later)

		var p_obj:Object = arguments[arguments.length-1];

		// Creates the main engine if it isn't active
		if (!_inited) init();
		if (!_engineExists || _root.__tweener_controller__ == undefined) startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...

		// Creates a "safer", more strict tweening object
		var rTime:Number = (isNaN(p_obj.time) ? 0 : p_obj.time); // Real time
		var rDelay:Number = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay

		// Creates the property list; everything that isn't a hardcoded variable
		var rProperties:Array = new Array(); // array containing object { .name, .valueStart, .valueComplete }
		for (istr in p_obj) {
			if (istr != "time" && istr != "delay" && istr != "useFrames" && istr != "skipUpdates" && istr != "transition" && istr != "onStart" && istr != "onUpdate" && istr != "onComplete" && istr != "onOverwrite" && istr != "rounded" && istr != "onStartParams" && istr != "onUpdateParams" && istr != "onCompleteParams" && istr != "onOverwriteParams" && istr != "quickAdd") {
				// It's an additional pair, so adds
				if (_specialPropertySplitterList[istr] != undefined) {
					// Special property splitter
					var splitProperties:Array = _specialPropertySplitterList[istr].splitValues(p_obj[istr]);
					for (i = 0; i < splitProperties.length; i++) {
						rProperties.push({name:splitProperties[i].name, valueStart:undefined, valueComplete:splitProperties[i].value});
					}
				} else {
					// Regular property or special property, just add the property normally
					rProperties.push({name:istr, valueStart:undefined, valueComplete:p_obj[istr]});
				}
			}
		}

		var rTransition:Function; // Real transition

		if (typeof p_obj.transition == "string") {
			// String parameter, transition names
			var trans:String = p_obj.transition.toLowerCase();
			rTransition = _transitionList[trans];
		} else {
			// Proper transition function
			rTransition = p_obj.transition;
		}
		if (rTransition == undefined) rTransition = _transitionList["easeoutexpo"];

		var nProperties:Array;
		var nTween:TweenListObj;
		var myT:Number;

		for (i = 0; i < rScopes.length; i++) {
			// Makes a copy of the properties
			// TODO: isso pode deixar lento? tentar fazer uma coisa mais inteligente e mais rápida...
			nProperties = new Array();
			for (j = 0; j < rProperties.length; j++) {
				nProperties.push({name:rProperties[j].name, valueStart:rProperties[j].valueStart, valueComplete:rProperties[j].valueComplete});
			}

			nTween = new TweenListObj(
				/* scope			*/	rScopes[i],
				/* timeStart		*/	_currentTime + ((rDelay * 1000) / _timeScale),
				/* timeComplete		*/	_currentTime + (((rDelay * 1000) + (rTime * 1000)) / _timeScale),
				/* useFrames		*/	(p_obj.useFrames == true),
				/* transition		*/	rTransition
			);

			nTween.properties			=	nProperties;
			nTween.onStart				=	p_obj.onStart;
			nTween.onUpdate				=	p_obj.onUpdate;
			nTween.onComplete			=	p_obj.onComplete;
			nTween.onOverwrite			=	p_obj.onOverwrite;
			nTween.onStartParams		=	p_obj.onStartParams;
			nTween.onUpdateParams		=	p_obj.onUpdateParams;
			nTween.onCompleteParams		=	p_obj.onCompleteParams;
			nTween.onOverwriteParams	=	p_obj.onOverwriteParams;
			nTween.rounded				=	p_obj.rounded;
			nTween.skipUpdates			=	p_obj.skipUpdates;

			// Remove other tweenings that occur at the same time
			if (!p_obj.quickAdd) removeTweensByTime(nTween.scope, nTween.properties, nTween.timeStart, nTween.timeComplete);

			// And finally adds it to the list
			_tweenList.push(nTween);

			// Hack: immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
			if (rTime == 0 && rDelay == 0) {
				myT = _tweenList.length-1;
				updateTweenByIndex(myT);
				removeTweenByIndex(myT);
			}
		}

		return true;
	}

	// A "caller" is like this: [          |     |  | ||] got it? :)
	// this function is crap - should be fixed later/extend on addTween()

	/**
	 * Adds a new *caller* tweening
	 *
	 * @param		(first-n param)		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
	 * @param		(last param)		Object				Object containing the specified parameters in any order, as well as the properties that should be tweened and their values
	 * @param		.time				Number				Time in seconds or frames for the tweening to take (defaults 2)
	 * @param		.delay				Number				Delay time (defaults 0)
	 * @param		.count				Number				Number of times this caller should be called
	 * @param		.transition			String/Function		Type of transition equation... (defaults to "easeoutexpo")
	 * @param		.onStart			Function			Event called when tween starts
	 * @param		.onUpdate			Function			Event called when tween updates
	 * @param		.onComplete			Function			Event called when tween ends
	 * @param		.waitFrames			Boolean				Whether to wait (or not) one frame for each call
	 * @return							Boolean				TRUE if the tween was successfully added, FALSE if otherwise
	 */
	public static function addCaller ():Boolean {
		if (arguments.length < 2 || arguments[0] == undefined) return false;

		var rScopes:Array = new Array(); // List of objects to tween
		var i:Number, j:Number;

		if (arguments[0] instanceof Array) {
			// The first argument is an array
			for (i = 0; i<arguments[0].length; i++) rScopes.push(arguments[0][i]);
		} else {
			// The first argument(s) is(are) object(s)
			for (i = 0; i<arguments.length-1; i++) rScopes.push(arguments[i]);
		}
		// rScopes = arguments.concat().splice(1); // Alternate (should be tested for speed later)

		var p_obj:Object = arguments[arguments.length-1];

		// Creates the main engine if it isn't active
		if (!_inited) init();
		if (!_engineExists || _root.__tweener_controller__ == undefined) startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...

		// Creates a "safer", more strict tweening object
		var rTime:Number = (isNaN(p_obj.time) ? 0 : p_obj.time); // Real time
		var rDelay:Number = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay

		var rTransition:Function; // Real transition
		if (typeof p_obj.transition == "string") {
			// String parameter, transition names
			var trans:String = p_obj.transition.toLowerCase();
			rTransition = _transitionList[trans];
		} else {
			// Proper transition function
			rTransition = p_obj.transition;
		}
		if (rTransition == undefined) rTransition = _transitionList["easeoutexpo"];

		var nTween:TweenListObj;
		var myT:Number;
		for (i = 0; i < rScopes.length; i++) {

			nTween = new TweenListObj(
				/* scope			*/	rScopes[i],
				/* timeStart		*/	_currentTime + ((rDelay * 1000) / _timeScale),
				/* timeComplete		*/	_currentTime + (((rDelay * 1000) + (rTime * 1000)) / _timeScale),
				/* useFrames		*/	(p_obj.useFrames == true),
				/* transition		*/	rTransition
			);

			nTween.properties			=	undefined;
			nTween.onStart				=	p_obj.onStart;
			nTween.onUpdate				=	p_obj.onUpdate;
			nTween.onComplete			=	p_obj.onComplete;
			nTween.onOverwrite			=	p_obj.onOverwrite;
			nTween.onStartParams		=	p_obj.onStartParams;
			nTween.onUpdateParams		=	p_obj.onUpdateParams;
			nTween.onCompleteParams		=	p_obj.onCompleteParams;
			nTween.onOverwriteParams	=	p_obj.onOverwriteParams;
			nTween.isCaller				=	true;
			nTween.count				=	p_obj.count;
			nTween.waitFrames			=	p_obj.waitFrames;

			// Remove other tweenings that occur at the same time
			//removeTweensByTime(nTween.scope, nTween.properties, nTween.timeStart, nTween.timeComplete);

			// And finally adds it to the list
			_tweenList.push(nTween);

			// Hack: immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
			// TODO: tá errado? precisa faezr todas as atualizacoes.. sem remover direto?
			if (rTime == 0 && rDelay == 0) {
				myT = _tweenList.length-1;
				updateTweenByIndex(myT);
				removeTweenByIndex(myT);
			}
		}

		return true;
	}

	/**
	 * Remove an specified tweening of a specified object the tweening list, if it conflicts with the given time
	 *
	 * @param		p_scope				Object						List of objects affected
	 * @param		p_properties		Array/Object 				List of properties affected - to be fixed (must use a class)
	 * @param		p_timeStart			Number						Time when the new tween starts
	 * @param		p_timeComplete		Number						Time when the new tween ends
	 * @return							Boolean						Whether or not it actually deleted something
	 */
	public static function removeTweensByTime (p_scope:Object, p_properties:Array, p_timeStart:Number, p_timeComplete:Number):Boolean {
		var removed:Boolean = false;

		var j:Number, k:Number, l:Number;
		var tl:Number = _tweenList.length;

		for (j = 0; j < tl; j++) {
			// ... _tweenList[j] != undefined && ...
			if (p_scope == _tweenList[j].scope && _tweenList[j].properties.length > 0) {
				// Same object. Now check properties..
				for (k = 0; k < _tweenList[j].properties.length; k++) {
					for (l = 0; l < p_properties.length; l++) {
						if (p_properties[l].name == _tweenList[j].properties[k].name) {
							// Same object, same property
							if (p_timeStart < _tweenList[j].timeComplete || (p_timeComplete > _tweenList[j].timeStart && p_timeStart < _tweenList[j].timeComplete)) {
								// The new one should overwrite the old one -- delete this property.
								if (_tweenList[j].onOverwrite != undefined) {
									try {
										_tweenList[j].onOverwrite.apply(_tweenList[j].scope, _tweenList[j].onOverwriteParams);
									} catch(e:Error) {
										//trace(e);
									}
								}
								_tweenList[j].properties.splice(k, 1);
								k--;
								removed = true;
								break;
							}
						}
					}
				}
				if (_tweenList[j].properties.length == 0) {
					removeTweenByIndex(j);
				}
			}
		}

		return removed;
	}

	/**
	 * Remove tweenings from a given object from the tweening list
	 *
	 * @param		p_tween				Object		Object that must have its tweens removed
	 * @param		(2nd-last params)	Object		Property(ies) that must be removed
	 * @return							Boolean		Whether or not it successfully removed this tweening
	 */
	public static function removeTweens (p_scope:Object):Boolean {
		// Create the property list
		var properties:Array = new Array();
		var i:Number;
		for (i = 1; i < arguments.length; i++) {
			if (typeof(arguments[i]) == "string" && !AuxFunctions.isInArray(arguments[i], properties)) properties.push(arguments[i]);
		}
		// Call the affect function on the specified properties
		return affectTweens(removeTweenByIndex, p_scope, properties);
	}

	/**
	 * Remove all tweenings from the engine
	 *
	 * @return							Boolean		Whether or not it successfully removed a tweening
	 */
	public static function removeAllTweens ():Boolean {
		var removed:Boolean = false;
		var i:Number;
		for (i = 0; i < _tweenList.length; i++) {
			removeTweenByIndex(i);
			removed = true;
		}
		return removed;
	}

	/**
	 * Pause tweenings from a given object
	 *
	 * @param		p_scope				Object		Object that must have its tweens paused
	 * @param		(2nd-last params)	Object		Property(ies) that must be paused
	 * @return							Boolean		Whether or not it successfully paused something
	 */
	public static function pauseTweens (p_scope:Object):Boolean {
		// Create the property list
		var properties:Array = new Array();
		var i:Number;
		for (i = 1; i < arguments.length; i++) {
			if (typeof(arguments[i]) == "string" && !AuxFunctions.isInArray(arguments[i], properties)) properties.push(arguments[i]);
		}
		// Call the affect function on the specified properties
		return affectTweens(pauseTweenByIndex, p_scope, properties);
	}

	/**
	 * Resume tweenings from a given object
	 *
	 * @param		p_scope				Object		Object that must have its tweens resumed
	 * @param		(2nd-last params)	Object		Property(ies) that must be resumed
	 * @return							Boolean		Whether or not it successfully resumed something
	 */
	public static function resumeTweens (p_scope:Object):Boolean {
		// Create the property list
		var properties:Array = new Array();
		var i:Number;
		for (i = 1; i < arguments.length; i++) {
			if (typeof(arguments[i]) == "string" && !AuxFunctions.isInArray(arguments[i], properties)) properties.push(arguments[i]);
		}
		// Call the affect function on the specified properties
		return affectTweens(resumeTweenByIndex, p_scope, properties);
	}

	/**
	 * Do some generic action on specific tweenings (pause, resume, remove, more?)
	 *
	 * @param		p_function			Function	Function to run on the tweenings that match
	 * @param		p_scope				Object		Object that must have its tweens affected by the function
	 * @param		p_properties		Array		Array of strings that must be affected
	 * @return							Boolean		Whether or not it successfully affected something
	 */
	private static function affectTweens (p_affectFunction:Function, p_scope:Object, p_properties:Array):Boolean {
		var affected:Boolean = false;
		var i:Number;

		if (!_tweenList) return false;

		for (i = 0; i < _tweenList.length; i++) {
			if (_tweenList[i].scope == p_scope) {
				if (p_properties.length == 0) {
					// Can affect everything
					p_affectFunction(i);
					affected = true;
				} else {
					// Must check whether this tween must have specific properties affected
					var affectedProperties:Array = new Array();
					var j:Number;
					var k:Number;
					for (j = 0; j < _tweenList[i].properties.length; j++) {
						for (k = 0; k < p_properties.length; k++) {
							if (_tweenList[i].properties[j].name == p_properties[k]) {
								affectedProperties.push(_tweenList[i].properties[j].name);
							}
						}
					}
					if (affectedProperties.length > 0) {
						// This tween has some properties that need to be affected
						if (_tweenList[i].properties.length == affectedProperties.length) {
							// The list of properties is the same as all properties, so affect it all
							p_affectFunction(i);
							affected = true;
						} else {
							// The properties are mixed, so split the tween and affect only certain specific properties
							var slicedTweenIndex:Number = splitTweens(i, affectedProperties);
							p_affectFunction(slicedTweenIndex);
							affected = true;
						}
					}
				}
			}
		}
		return affected;
	}

	/**
	 * Splits a tweening in two
	 *
	 * @param		p_tween				Number		Object that must have its tweens split
	 * @param		p_properties		Array		Array of strings containing the list of properties that must be separated
	 * @return							Number		The index number of the new tween
	 */
	public static function splitTweens (p_tween:Number, p_properties:Array):Number {
		// First, duplicates
		var originalTween:TweenListObj = _tweenList[p_tween];
		var newTween:TweenListObj = originalTween.clone(false);

		// Now, removes tweenings where needed
		var i:Number;

		// Removes the specified properties from the old one
		for (i = 0; i < originalTween.properties.length; i++) {
			if (AuxFunctions.isInArray(originalTween.properties[i].name, p_properties)) {
				originalTween.properties.splice(i, 1);
				i--;
			}
		}

		// Removes the unspecified properties from the new one
		for (i = 0; i < newTween.properties.length; i++) {
			if (!AuxFunctions.isInArray(newTween.properties[i].name, p_properties)) {
				newTween.properties.splice(i, 1);
				i--;
			}
		}

		// If there are empty property lists, a cleanup is done on the next updateTweens() cycle

		_tweenList.push(newTween);
		return (_tweenList.length - 1);
		
	}


	// ==================================================================================================================================
	// ENGINE functions -----------------------------------------------------------------------------------------------------------------

	/**
	 * Updates all existing tweenings
	 *
	 * @return							Boolean		FALSE if no update was made because there's no tweening (even delayed ones)
	 */
	private static function updateTweens ():Boolean {
		if (_tweenList.length == 0) return false;
		var i:Number;
		for (i = 0; i < _tweenList.length; i++) {
			// Looping throught each Tweening and updating the values accordingly
			if (!_tweenList[i].isPaused) {
				if (!updateTweenByIndex(i)) removeTweenByIndex(i);
				if (_tweenList[i] == null) {
					removeTweenByIndex(i, true);
					i--;
				}
			}
		}

		return true;
	}

	/**
	 * Remove an specific tweening from the tweening list
	 *
	 * @param		p_tween				Number		Index of the tween to be removed on the tweenings list
	 * @return							Boolean		Whether or not it successfully removed this tweening
	 */
	public static function removeTweenByIndex (p_tween:Number, p_finalRemoval:Boolean):Boolean {
		_tweenList[p_tween] = null;
		if (p_finalRemoval) _tweenList.splice(p_tween, 1);
		return true;
	}

	/**
	 * Pauses an specific tween
	 *
	 * @param		p_tween				Number		Index of the tween to be paused
	 * @return							Boolean		Whether or not it successfully paused this tweening
	 */
	public static function pauseTweenByIndex (p_tween:Number):Boolean {
		var tTweening:Object = _tweenList[p_tween];	// Shortcut to this tweening
		if (tTweening == null || tTweening.isPaused) return false;
		tTweening.timePaused = _currentTime;
		tTweening.isPaused = true;

		return true;
	}

	/**
	 * Resumes an specific tween
	 *
	 * @param		p_tween				Number		Index of the tween to be resumed
	 * @return							Boolean		Whether or not it successfully resumed this tweening
	 */
	public static function resumeTweenByIndex (p_tween:Number):Boolean {
		var tTweening:Object = _tweenList[p_tween];	// Shortcut to this tweening
		if (tTweening == null || !tTweening.isPaused) return false;
		tTweening.timeStart += _currentTime - tTweening.timePaused;
		tTweening.timeComplete += _currentTime - tTweening.timePaused;
		tTweening.timePaused = undefined;
		tTweening.isPaused = false;

		return true;
	}

	/**
	 * Updates an specific tween
	 *
	 * @param		i					Number		Index (from the tween list) of the tween that should be updated
	 * @return							Boolean		FALSE if it's already finished and should be deleted, TRUE if otherwise
	 */
	private static function updateTweenByIndex (i:Number):Boolean {

		var tTweening:Object = _tweenList[i];	// Shortcut to this tweening

		if (tTweening == null || !tTweening.scope) return false;

		var isOver:Boolean = false;				// Whether or not it's over the update time
		var mustUpdate:Boolean;					// Whether or not it should be updated (skipped if false)

		var tProperty:Object;		// Property being checked

		var nv:Number;		// New value for each property

		var t:Number;		// current time (frames, seconds)
		var b:Number;		// beginning value
		var c:Number;		// change in value
		var d:Number; 		// duration (frames, seconds)

		var k:Number;		// Used in loops

		// Shortcut stuff for speed
		var tScope:Object;	// Current scope

		if (_currentTime >= tTweening.timeStart) {
			// Can already start

			tScope = tTweening.scope;

			if (tTweening.isCaller) {
				// It's a 'caller' tween
				do {
					t = ((tTweening.timeComplete - tTweening.timeStart)/tTweening.count) * (tTweening.timesCalled+1);
					b = tTweening.timeStart;
					c = tTweening.timeComplete - tTweening.timeStart;
					d = tTweening.timeComplete - tTweening.timeStart;
					nv = tTweening.transition(t, b, c, d);

					if (_currentTime >= nv) {
						if (tTweening.onUpdate != undefined) {
							try {
								tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
							} catch(e:Error) {
								//trace(e);
							}
						}

						tTweening.timesCalled++;
						if (tTweening.timesCalled >= tTweening.count) {
							isOver = true;
							break;
						}
						if (tTweening.waitFrames) break;
					}

				} while (_currentTime >= nv);
			} else {
				// It's a normal transition tween

				if (_currentTime >= tTweening.timeComplete) isOver = true;

				mustUpdate = tTweening.skipUpdates < 1 || tTweening.skipUpdates == undefined || tTweening.updatesSkipped >= tTweening.skipUpdates;

				if (tTweening.properties) {

					if (!tTweening.hasStarted) {
						// First update, read all default values (for proper filter tweening)
						if (tTweening.onStart != undefined) {
							try {
								tTweening.onStart.apply(tScope, tTweening.onStartParams);
							} catch(e:Error) {
								//trace(e);
							}
						}
						for (k = 0; k < tTweening.properties.length; k++) {
							var pv:Number = getPropertyValue (tScope, tTweening.properties[k].name);
							tTweening.properties[k].valueStart = isNaN(pv) ? tTweening.properties[k].valueComplete : pv;
						}
						mustUpdate = true;
						tTweening.hasStarted = true;
					}

					for (k = 0; k < tTweening.properties.length; k++) {
						tProperty = tTweening.properties[k];

						if (!isOver) {
							// Normal update
							if (mustUpdate) {
								// Does the update
								t = _currentTime - tTweening.timeStart;
								b = tProperty.valueStart;
								c = tProperty.valueComplete - tProperty.valueStart;
								d = tTweening.timeComplete - tTweening.timeStart;
								nv = tTweening.transition(t, b, c, d);
							} else {
								// Skip this update
								tTweening.updatesSkipped++;
							}
						} else {
							// Tweening time has finished, just set it to the final value
							nv = tProperty.valueComplete;
							mustUpdate = true;
						}

						if (mustUpdate) {
							if (tTweening.rounded) nv = Math.round(nv);
							setPropertyValue(tScope, tProperty.name, nv);
						}

					}
				}

				if (mustUpdate) {
					tTweening.updatesSkipped = 0;
					if (tTweening.onUpdate != undefined) {
						try {
							tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
						} catch(e:Error) {
							//trace(e);
						}
					}
				}
			}

			if (isOver && tTweening.onComplete != undefined) {
				try {
					tTweening.onComplete.apply(tScope, tTweening.onCompleteParams);
				} catch(e:Error) {
					//trace(e);
				}
			}

			return (!isOver);
		}

		// On delay, hasn't started, so returns true
		return (true);

	}

	/**
	 * Initiates the Tweener. Should only be ran once
	 */
	private static function init():Void {
		_inited = true;

		// Registers all default equations
		_transitionList = new Array();
		Equations.init();

		// Registers all default special properties
		_specialPropertyList = new Array();
		_specialPropertySplitterList = new Array();
		SpecialPropertiesDefault.init();
	}

	/**
	 * Adds a new function to the available transition list "shortcuts"
	 * 
	 * @param		p_name				String		Shorthand transition name
	 * @param		p_function			Function	The proper equation function
	 */
	public static function registerTransition(p_name:String, p_function:Function): Void {
		if (!_inited) init();
		_transitionList[p_name] = p_function;
	}

	/**
	 * Adds a new special property modifier to the available modifier list
	 * 
	 * @param		p_name				String		Name of the "special" property
	 * @param		p_getFunction		Function	Function that gets the value
	 * @param		p_setFunction		Function	Function that sets the value
	 * @param		p_parameters		Array		Additional parameters that should be passed to the function when executing (so the same function can apply to different special properties)
	 */
	public static function registerSpecialProperty(p_name:String, p_getFunction:Function, p_setFunction:Function, p_parameters:Array): Void {
		if (!_inited) init();
		var spm:SpecialPropertyModifier = new SpecialPropertyModifier(p_getFunction, p_setFunction, p_parameters);
		_specialPropertyList[p_name] = spm;
	}

	/**
	 * Adds a new special property splitter to the available splitter list
	 * 
	 * @param		p_name				String		Name of the "special" property splitter
	 * @param		p_splitFunction		Function	Function that splits the value
	 */
	public static function registerSpecialPropertySplitter(p_name:String, p_splitFunction:Function): Void {
		if (!_inited) init();
		var sps:SpecialPropertySplitter = new SpecialPropertySplitter(p_splitFunction);
		_specialPropertySplitterList[p_name] = sps;
	}

	/**
	 * Starts the Tweener class engine. It is supposed to be running every time a tween exists
	 */
	private static function startEngine():Void {
		_engineExists = true;
		_tweenList = new Array();

		var fmc:MovieClip = _root.createEmptyMovieClip("__tweener_controller__", 31338);
		fmc.onEnterFrame = function() {
			Tweener.onEnterFrame();
		};

		updateTime();
	}

	/**
	 * Stops the Tweener class engine
	 */
	private static function stopEngine():Void {
		_engineExists = false;
		_tweenList = null;
		_currentTime = 0;
		delete _root.__tweener_controller__.onEnterFrame;
		_root.__tweener_controller__.removeMovieClip();
	}

	/**
	 * Gets a property value from an object
	 *
	 * @param		p_obj				Object		Any given object
	 * @param		p_prop				String		The property name
	 * @return							Number		The value
	 */
	private static function getPropertyValue(p_obj:Object, p_prop:String):Number {
		if (_specialPropertyList[p_prop] != undefined) {
			// Special property
			return _specialPropertyList[p_prop].getValue(p_obj, _specialPropertyList[p_prop].parameters);
		} else {
			// Regular property
			return p_obj[p_prop];
		}
	}

	/**
	 * Sets the value of an object property
	 *
	 * @param		p_obj				Object		Any given object
	 * @param		p_prop				String		The property name
	 * @param		p_value				Number		The new value
	 */
	private static function setPropertyValue(p_obj:Object, p_prop:String, p_value:Number): Void {
		if (_specialPropertyList[p_prop] != undefined) {
			// Special property
			_specialPropertyList[p_prop].setValue(p_obj, p_value, _specialPropertyList[p_prop].parameters);
		} else {
			// Regular property
			p_obj[p_prop] = p_value;
		}
	}

	/**
	 * Updates the time to enforce time grid-based updates
	 */
	public static function updateTime():Void {
		_currentTime = getTimer();
	}

	/**
	 * Ran once every frame. It's the main engine, updates all existing tweenings.
	 */
	public static function onEnterFrame():Void {
		updateTime();
		var hasUpdated:Boolean = false;
		hasUpdated = updateTweens();
		if (!hasUpdated) stopEngine();	// There's no tweening to update or wait, so it's better to stop the engine
	}

	/**
	 * Sets the new time scale.
	 *
	 * @param		p_time				Number		New time scale (0.5 = slow, 1 = normal, 2 = 2x fast forward, etc)
	 */
	public static function setTimeScale(p_time:Number):Void {
		var i:Number;

		if (isNaN(p_time)) p_time = 1;
		if (p_time < 0.00001) p_time = 0.00001;
		if (p_time != _timeScale) {
			// Multiplies all existing tween times accordingly
			for (i = 0; i<_tweenList.length; i++) {
				_tweenList[i].timeStart = _currentTime - ((_currentTime - _tweenList[i].timeStart) * _timeScale / p_time);
				_tweenList[i].timeComplete = _currentTime - ((_currentTime - _tweenList[i].timeComplete) * _timeScale / p_time);
				if (_tweenList[i].timePaused != undefined) _tweenList[i].timePaused = _currentTime - ((_currentTime - _tweenList[i].timePaused) * _timeScale / p_time);
			}
			// Sets the new timescale value (for new tweenings)
			_timeScale = p_time;
		}
	}


	// ==================================================================================================================================
	// AUXILIARY functions --------------------------------------------------------------------------------------------------------------

	/**
	 * Finds whether or not an object has any tweening
	 *
	 * @param		p_scope				Object		Target object
	 * @return							Boolean		Whether or not there's a tweening occuring on this object (paused, delayed, or active)
	 */
	public static function isTweening (p_scope:Object):Boolean {
        var i:Number;

        for (i = 0; i<_tweenList.length; i++) {
            if (_tweenList[i].scope == p_scope) {
                return true;
            }
        }
        return false;
    }

	/**
	 * Return an array containing a list of the properties being tweened for this object
	 *
	 * @param		p_scope				Object		Target object
	 * @return							Array		List of strings with properties being tweened (including delayed or paused)
	 */
	public static function getTweens (p_scope:Object):Array {
        var i:Number, j:Number;
        var tList:Array = new Array();

        for (i = 0; i<_tweenList.length; i++) {
            if (_tweenList[i].scope == p_scope) {
				for (j = 0; j<_tweenList[i].properties.length; j++) {
					tList.push(_tweenList[i].properties[j].name);
				}
            }
        }
		return tList;
    }

	/**
	 * Return the number of properties being tweened for this object
	 *
	 * @param		p_scope				Object		Target object
	 * @return							Number		Total count of properties being tweened (including delayed or paused)
	 */
	public static function getTweenCount (p_scope:Object):Number {
        var i:Number;
		var c:Number = 0;

        for (i = 0; i<_tweenList.length; i++) {
            if (_tweenList[i].scope == p_scope) {
				c += _tweenList[i].properties.length;
            }
        }
		return c;
    }


	// ==================================================================================================================================
	// DEBUG functions ------------------------------------------------------------------------------------------------------------------

	public static function debug_getList():String {
		var ttl:String = "";
		var i:Number, k:Number;
		for (i = 0; i<_tweenList.length; i++) {
			ttl += "["+i+"] ::\n";
			for (k = 0; k<_tweenList[i].properties.length; k++) {
				ttl += "  " + _tweenList[i].properties[k].name +" -> " + _tweenList[i].properties[k].valueComplete + "\n";
			}
		}
		return ttl;
	}
}