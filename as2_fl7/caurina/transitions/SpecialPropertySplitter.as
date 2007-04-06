/**
 * SpecialPropertySplitter
 * A proxy setter for special properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */

class caurina.transitions.SpecialPropertySplitter {

	/**
	 * Builds a new group modifier object.
	 * 
	 * @param		p_splitFunction		Function	Reference to the function used to split a value 
	 */
	public function SpecialPropertySplitter (p_splitFunction:Function) {
		splitValues = p_splitFunction;
	}

	/**
	 * Empty shell for the function that receives the value (usually just a Number), and splits it in new property names and values
	 * Must return an array containing .name and .value
	 */
	public function splitValues(p_value:Object):Array {
		// This is rewritten
		return [];
	}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString():String {
		var value:String = "";
		value += "[SpecialPropertySplitter ";
		value += "splitValues:"+splitValues.toString();
		value += "]";
		return value;
	}


}
