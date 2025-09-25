class ModifierProcessor {
	public static var __modifier__drunkMod : Float = 10.;
	public static function run(value:Float):Float {
		inline function MyMod(value:StdTypes.Float):StdTypes.Float {
			final theDrunk:StdTypes.Float = __modifier__drunkMod;
			return theDrunk + value;
		};
		MyMod(value);
		return value;
	}
}