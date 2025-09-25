class Main {
    static function main() {
        var a = 16;

        var cls = Type.resolveClass("modifiers.ModifierProcessor");
        a = Reflect.callMethod(cls, Reflect.field(cls, "run"), [a]);
        trace(a);
    }
}