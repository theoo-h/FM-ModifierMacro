package modifiers.list;

@:modifiers({
    tipsyMod: 2
})
class MyOtherMod implements IModifier
{
    public function apply(value:Float):Float
    {
        final theTipsy = untyped __modifier__tipsyMod;

        return theTipsy + value;
    }
}