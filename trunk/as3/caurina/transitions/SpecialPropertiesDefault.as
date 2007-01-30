/**
 * SpecialPropertiesDefault
 * List of default special property modifiers for the Tweener class
 * The function names are strange/inverted because it makes for easier debugging (alphabetic order). They're only for internal use (on this class) anyways.
 *
 * @author		Zeh Fernando, Nate Chatellier
 * @version		1.0.1
 */

package caurina.transitions {

	import flash.geom.ColorTransform;

	public class SpecialPropertiesDefault {
	
		/**
		 * There's no constructor.
		 */
		public function SpecialPropertiesDefault () {
			trace ("SpecialProperties is a static class and should not be instantiated.")
		}
	
		/**
		 * Registers all the modifiers to the Tweener class, so the Tweener knows what to do with them.
		 */
		public static function init():void {
			Tweener.registerSpecialProperty("_frame", frame_get, frame_set);
			Tweener.registerSpecialProperty("_sound_volume", _sound_volume_get, _sound_volume_set);
			Tweener.registerSpecialProperty("_sound_pan", _sound_pan_get, _sound_pan_set);
			Tweener.registerSpecialProperty("_color_ra", _color_ra_get, _color_ra_set);
			Tweener.registerSpecialProperty("_color_rb", _color_rb_get, _color_rb_set);
			Tweener.registerSpecialProperty("_color_ga", _color_ga_get, _color_ga_set);
			Tweener.registerSpecialProperty("_color_gb", _color_gb_get, _color_gb_set);
			Tweener.registerSpecialProperty("_color_ba", _color_ba_get, _color_ba_set);
			Tweener.registerSpecialProperty("_color_bb", _color_bb_get, _color_bb_set);
			Tweener.registerSpecialProperty("_color_aa", _color_aa_get, _color_aa_set);
			Tweener.registerSpecialProperty("_color_ab", _color_ab_get, _color_ab_set);
		}
	
		// ==================================================================================================================================
		// PROPERTY MODIFICATION functions --------------------------------------------------------------------------------------------------
	
		// ----------------------------------------------------------------------------------------------------------------------------------
		// _frame
	
		/**
		 * Returns the current frame number from the movieclip timeline
		 *
		 * @param		p_obj				Object		MovieClip object
		 * @return							Number		The current frame
		 */
		public static function frame_get (p_obj:Object):Number {
			return p_obj.currentFrame;
		}
	
		/**
		 * Sets the timeline frame
		 *
		 * @param		p_obj				Object		MovieClip object
		 * @param		p_value				Number		New frame number
		 */
		public static function frame_set (p_obj:Object, p_value:Number):void {
			p_obj.gotoAndStop(Math.round(p_value));
		}
	
		
		// ----------------------------------------------------------------------------------------------------------------------------------
		// _sound_volume
	
		/**
		 * Returns the current sound volume
		 *
		 * @param		p_obj				Object		Sound object
		 * @return							Number		The current volume
		 */
		public static function _sound_volume_get (p_obj:Object):Number {
			return p_obj.getVolume();
		}
	
		/**
		 * Sets the sound volume
		 *
		 * @param		p_obj				Object		Sound object
		 * @param		p_value				Number		New volume
		 */
		public static function _sound_volume_set (p_obj:Object, p_value:Number):void {
			p_obj.setVolume(p_value);
		}
	
	
		// ----------------------------------------------------------------------------------------------------------------------------------
		// _sound_pan
	
		/**
		 * Returns the current sound pan
		 *
		 * @param		p_obj				Object		Sound object
		 * @return							Number		The current pan
		 */
		public static function _sound_pan_get (p_obj:Object):Number {
			return p_obj.getPan();
		}
	
		/**
		 * Sets the sound volume
		 *
		 * @param		p_obj				Object		Sound object
		 * @param		p_value				Number		New pan
		 */
		public static function _sound_pan_set (p_obj:Object, p_value:Number):void {
			p_obj.setPan(p_value);
		}
	
	
		// ----------------------------------------------------------------------------------------------------------------------------------
		// _color_*
	
		/**
		 * _color_ra
		 * RA component of the colorTransform object
		 */
		public static function _color_ra_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.redMultiplier * 100;
		}
		public static function _color_ra_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.redMultiplier = p_value / 100;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_rb
		 * RB component of the colorTransform object
		 */
		public static function _color_rb_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.redOffset;
		}
		public static function _color_rb_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.redOffset = p_value;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_ga
		 * GA component of the colorTransform object
		 */
		public static function _color_ga_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.greenMultiplier * 100;
		}
		public static function _color_ga_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.greenMultiplier = p_value / 100;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_gb
		 * GB component of the colorTransform object
		 */
		public static function _color_gb_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.greenOffset;
		}
		public static function _color_gb_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.greenOffset = p_value;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_ba
		 * BA component of the colorTransform object
		 */
		public static function _color_ba_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.blueMultiplier * 100;
		}
		public static function _color_ba_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.blueMultiplier = p_value / 100;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_bb
		 * BB component of the colorTransform object
		 */
		public static function _color_bb_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.blueOffset;
		}
		public static function _color_bb_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.blueOffset = p_value;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_aa
		 * AA component of the colorTransform object
		 */
		public static function _color_aa_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.alphaMultiplier * 100;
		}
		public static function _color_aa_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.alphaMultiplier = p_value / 100;
			p_obj.transform.colorTransform = tf;
		}
	
		/**
		 * _color_ab
		 * AB component of the colorTransform object
		 */
		public static function _color_ab_get (p_obj:Object):Number {
			return p_obj.transform.colorTransform.alphaOffset;
		}
		public static function _color_ab_set (p_obj:Object, p_value:Number):void {
			var tf:ColorTransform = p_obj.transform.colorTransform;
			tf.alphaOffset = p_value;
			p_obj.transform.colorTransform = tf;
		}
	}
}