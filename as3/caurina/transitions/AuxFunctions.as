/**
 * Generic, auxiliary functions
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */

package caurina.transitions {

	public class AuxFunctions {

		/**
		 * Gets the R (xx0000) bits from a number
		 *
		 * @param		p_num				Number		Color number (ie, 0xffff00)
		 * @return							Number		The R value
		 */
		public static function numberToR(p_num:Number):Number {
			// The initial & is meant to crop numbers bigger than 0xffffff
			return (p_num & 0xff0000) >> 16;
		}

		/**
		 * Gets the G (00xx00) bits from a number
		 *
		 * @param		p_num				Number		Color number (ie, 0xffff00)
		 * @return							Number		The G value
		 */
		public static function numberToG(p_num:Number):Number {
			return (p_num & 0xff00) >> 8;
		}

		/**
		 * Gets the B (0000xx) bits from a number
		 *
		 * @param		p_num				Number		Color number (ie, 0xffff00)
		 * @return							Number		The B value
		 */
		public static function numberToB(p_num:Number):Number {
			return (p_num & 0xff);
		}

		/**
		 * Checks whether a string is on an array
		 *
		 * @param		p_string			String		String to search for
		 * @param		p_array				Array		Array to be searched
		 * @return							Boolean		Whether the array contains the string or not
		 */
		public static function isInArray(p_string:String, p_array:Array):Boolean {
			var l:uint = p_array.length;
			for (var i:uint = 0; i < l; i++) {
				if (p_array[i] == p_string) return true;
			}
			return false;
		}
	}
}