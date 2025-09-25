package modifiers;
class ModifierProcessor {
	public static var __modifier__tipsyMod : Float = 2;
	public static var __modifier__drunkMod : Float = 7.2;
	public static function run(value:Float):Float {
		inline function MyOtherMod(value:StdTypes.Float):StdTypes.Float {
			final theTipsy:StdTypes.Float = __modifier__tipsyMod;
			return theTipsy + value;
		};
		value = MyOtherMod(value);
		inline function MyMod(value:StdTypes.Float):StdTypes.Float {
			final theDrunk:StdTypes.Float = __modifier__drunkMod;
			return theDrunk + value;
		};
		value = MyMod(value);
		return value;
	}
}