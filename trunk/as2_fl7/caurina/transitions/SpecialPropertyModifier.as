/**
 * SpecialPropertyModifier
 * A kind of a getter/setter for special properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */

class caurina.transitions.SpecialPropertyModifier {

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
	 * Empty shell for the function that gets the value.
	 */
	public function getValue(p_obj:Object):Number {
		// This is rewritten
		return null;
	}
		
	/**
	 * Empty shell for the function that sets the value.
	 */
	public function setValue(p_obj:Object, p_value:Number):Void {
		// This is rewritten
	}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString():String {
		var value:String = "";
		value += "[SpecialPropertyModifier ";
		value += "getValue:"+getValue.toString();
		value += ", ";
		value += "setValue:"+setValue.toString();
		value += "]";
		return value;
	}


}
