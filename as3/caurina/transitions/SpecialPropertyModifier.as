/**
 * SpecialPropertyModifier
 * A kind of a getter/setter for special properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */

package caurina.transitions {
	
	public class SpecialPropertyModifier {
	
		public var getValue:Function;
		public var setValue:Function;
		
		/**
		 * Builds a new modifier object.
		 * 
		 * @param		p_getFunction		Function	Reference to the function used to get the special property value
		 * @param		p_setFunction		Function	Reference to the function used to set the special property value
		 */
		public function SpecialPropertyModifier (p_getFunction:Function, p_setFunction:Function) {
			getValue = p_getFunction;
			setValue = p_setFunction;
		}
	
		/**
		 * Converts the instance to a string that can be used when trace()ing the object
		 */
		public function toString():String {
			var value:String = "";
			value += "[SpecialPropertyModifier ";
			value += "getValue:"+String(getValue); // .toString();
			value += ", ";
			value += "setValue:"+String(setValue); // .toString();
			value += "]";
			return value;
		}
	}
}