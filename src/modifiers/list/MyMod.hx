package modifiers.list;

@:modifiers({
    drunkMod: 7.2
})
class MyMod implements IModifier
{
    public function apply(value:Float):Float
    {
        final theDrunk = untyped __modifier__drunkMod;

        return theDrunk + value;
    }
}