/**
 * The tween list object. Stores all of the properties and information that pertain to individual tweens.
 *
 * @author		Nate Chatellier, Zeh Fernando
 * @version		1.0.2
 */

class zeh.easing.TweenListObj {
	
	private var _scope				:Object;	// Object affected by this tweening
	private var _properties			:Array;		// List of objects that control this tweening
		// name						:String		// Name of the property being tweened
		// valueStart				:Number		// Initial value of the property
		// valueComplete			:Number		// The value the property should have when completed
	private var _timeStart			:Number;	// Time when this tweening should start
	private var _timeComplete		:Number;	// Time when this tweening should end
	private var _useFrames			:Boolean;	// Whether or not to use frames instead of time
	private var _transition			:Function;	// Equation to control the transition animation
	private var _onStart			:Function;	// Function to be executed on the object when the tween starts (once)
	private var _onUpdate			:Function;	// Function to be executed on the object when the tween updates (several times)
	private var _onComplete			:Function;	// Function to be executed on the object when the tween completes (once)
	private var _onOverwrite		:Function;	// Function to be executed on the object when the tween is overwritten
	private var _onStartParams		:Array;		// Array of parameters to be passed for the event
	private var _onUpdateParams		:Array;		// Array of parameters to be passed for the event
	private var _onCompleteParams	:Array;		// Array of parameters to be passed for the event
	private var _onOverwriteParams	:Array;		// Array of parameters to be passed for the event
	private var _rounded			:Boolean;	// Use rounded values when updating
	private var _isPaused			:Boolean;	// Whether or not this tween is paused
	private var _timePaused			:Number;	// Time when this tween was paused
	private var _isCaller			:Boolean;	// Whether or not this tween is a "caller" tween
	private var _count				:Number;	// Number of times this caller should be called
	private var _timesCalled		:Number;	// How many times the caller has already been called ("caller" tweens only)
	private var _waitFrames			:Boolean;	// Whether or not this caller should wait at least one frame for each call execution ("caller" tweens only)
	private var _skipUpdates		:Number;	// How many updates should be skipped (default = 0; 1 = update-skip-update-skip...)
	private var _updatesSkipped		:Number;	// How many updates have already been skipped

	// ==================================================================================================================================
	// CONSTRUCTOR function -------------------------------------------------------------------------------------------------------------

	/**
	 * Initializes the basic TweenListObj.
	 * 
	 * @param	p_scope				Object		Object affected by this tweening
	 * @param	p_timeStart			Number		Time when this tweening should start
	 * @param	p_timeComplete		Number		Time when this tweening should end
	 * @param	p_useFrames			Boolean		Whether or not to use frames instead of time
	 * @param	p_transition		Function	Equation to control the transition animation
	 */
	function TweenListObj(p_scope:Object, p_timeStart:Number, p_timeComplete:Number, p_useFrames:Boolean, p_transition:Function) {
		_scope			=	p_scope;
		_timeStart		=	p_timeStart;
		_timeComplete	=	p_timeComplete;
		_useFrames		=	p_useFrames;
		_transition		=	p_transition;

		// Other default information
		_isPaused		=	false;
		_timePaused		=	undefined;
		_isCaller		=	false;
		_updatesSkipped	=	0;
		_timesCalled	=	0;
		_skipUpdates 	= 	0;
	}


	// ==================================================================================================================================
	// GETTER/SETTER functions ----------------------------------------------------------------------------------------------------------

	public function get scope()				:Object		{ return _scope; }
	public function get properties()		:Array		{ return _properties; }
	public function get timeStart()			:Number		{ return _timeStart; }
	public function get timeComplete()		:Number		{ return _timeComplete; }
	public function get useFrames()			:Boolean	{ return _useFrames; }
	public function get transition()		:Function	{ return _transition; }
	public function get onStart()			:Function	{ return _onStart; }
	public function get onUpdate()			:Function	{ return _onUpdate; }
	public function get onComplete()		:Function	{ return _onComplete; }
	public function get onOverwrite()		:Function	{ return _onOverwrite; }
	public function get onStartParams()		:Array		{ return _onStartParams; }
	public function get onUpdateParams()	:Array		{ return _onUpdateParams; }
	public function get onCompleteParams()	:Array		{ return _onCompleteParams; }
	public function get onOverwriteParams()	:Array		{ return _onOverwriteParams; }
	public function get rounded()			:Boolean	{ return _rounded; }
	public function get isPaused()			:Boolean	{ return _isPaused; }
	public function get timePaused()		:Number		{ return _timePaused; }
	public function get isCaller()			:Boolean	{ return _isCaller; }
	public function get count()				:Number		{ return _count; }
	public function get timesCalled()		:Number		{ return _timesCalled; }
	public function get waitFrames()		:Boolean	{ return _waitFrames; }
	public function get skipUpdates()		:Number		{ return _skipUpdates; }
	public function get updatesSkipped()	:Number		{ return _updatesSkipped; }
	
	public function set scope				(Scope:Object)				:Void	{ _scope = Scope; }
	public function set properties			(Properties:Array)			:Void	{ _properties = Properties; }
	public function set timeStart			(TimeStart:Number)			:Void	{ _timeStart = TimeStart; }
	public function set timeComplete		(TimeComplete:Number)		:Void	{ _timeComplete = TimeComplete; }
	public function set useFrames			(UseFrames:Boolean)			:Void	{ _useFrames = UseFrames; }
	public function set transition			(Transition:Function)		:Void	{ _transition = Transition; }
	public function set onStart				(OnStart:Function)			:Void	{ _onStart = OnStart; }
	public function set onUpdate			(OnUpdate:Function)			:Void	{ _onUpdate = OnUpdate; }
	public function set onComplete			(OnComplete:Function)		:Void	{ _onComplete = OnComplete; }
	public function set onOverwrite			(OnOverwrite:Function)		:Void	{ _onOverwrite = OnOverwrite; }
	public function set onStartParams		(OnStartParams:Array)		:Void	{ _onStartParams = OnStartParams; }
	public function set onUpdateParams		(OnUpdateParams:Array)		:Void	{ _onUpdateParams = OnUpdateParams; }
	public function set onCompleteParams	(OnCompleteParams:Array)	:Void	{ _onCompleteParams = OnCompleteParams; }
	public function set onOverwriteParams	(OnOverwriteParams:Array)	:Void	{ _onOverwriteParams = OnOverwriteParams; }
	public function set rounded				(Rounded:Boolean)			:Void	{ _rounded = Rounded; }
	public function set isPaused			(IsPaused:Boolean)			:Void	{ _isPaused = IsPaused; }
	public function set timePaused			(TimePaused:Number)			:Void	{ _timePaused = TimePaused; }
	public function set isCaller			(IsCaller:Boolean)			:Void	{ _isCaller = IsCaller; }
	public function set count				(Count:Number)				:Void	{ _count = Count; }
	public function set timesCalled			(TimesCalled:Number)		:Void	{ _timesCalled = TimesCalled; }
	public function set waitFrames			(WaitFrames:Boolean)		:Void	{ _waitFrames = WaitFrames; }
	public function set skipUpdates			(SkipUpdates:Number)		:Void	{ _skipUpdates = SkipUpdates; }
	public function set updatesSkipped		(UpdatesSkipped:Number)		:Void	{ _updatesSkipped = UpdatesSkipped; }


	// ==================================================================================================================================
	// OTHER functions ------------------------------------------------------------------------------------------------------------------

	/**
	 * Returns this object described as a String.
	 *
	 * @return 					String		The description of this object.
	 */
	public function toString():String {
		var returnStr:String = "\n[TweenListObj ";
		returnStr += "scope:" + String(scope);
		returnStr += ", properties:";
		for (var i:Number = 0; i < properties.length; i++) {
			if (i > 0) returnStr += ",";
			returnStr += "[name:"+properties[i].name;
			returnStr += ",valueStart:"+properties[i].valueStart;
			returnStr += ",valueComplete:"+properties[i].valueComplete;
			returnStr += "]";
		} // END FOR
		returnStr += ", timeStart:" + String(timeStart);
		returnStr += ", timeComplete:" + String(timeComplete);
		returnStr += ", useFrames:" + String(useFrames);
		returnStr += ", transition:" + String(transition);

		if (skipUpdates)		returnStr += ", skipUpdates:"		+ String(skipUpdates);
		if (updatesSkipped)		returnStr += ", updatesSkipped:"	+ String(updatesSkipped);
		if (onStart)			returnStr += ", onStart:"			+ String(onStart);
		if (onUpdate)			returnStr += ", onUpdate:"			+ String(onUpdate);
		if (onComplete)			returnStr += ", onComplete:"		+ String(onComplete);
		if (onOverwrite)		returnStr += ", onOverwrite:"		+ String(onOverwrite);

		if (onStartParams)		returnStr += ", onStartParams:"		+ String(onStartParams);
		if (onUpdateParams)		returnStr += ", onUpdateParams:"	+ String(onUpdateParams);
		if (onCompleteParams)	returnStr += ", onCompleteParams:"	+ String(onCompleteParams);
		if (onOverwriteParams)	returnStr += ", onOverwriteParams:"	+ String(onOverwriteParams);

		if (rounded)			returnStr += ", rounded:"			+ String(rounded);
		if (isPaused)			returnStr += ", isPaused:"			+ String(isPaused);
		if (timePaused)			returnStr += ", timePaused:"		+ String(timePaused);
		if (isCaller)			returnStr += ", isCaller:"			+ String(isCaller);
		if (count)				returnStr += ", count:"				+ String(count);
		if (timesCalled)		returnStr += ", timesCalled:"		+ String(timesCalled);
		if (waitFrames)			returnStr += ", waitFrames:"		+ String(waitFrames);
		
		returnStr += "]\n";
		return returnStr;
	}
	
}
