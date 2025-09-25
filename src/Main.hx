class Main {
    // en lo que encuentro una solucion para hacer que ModifierProcessor pueda ser usado directamente
    // se usara refleccion para los testeos (probablemente use una implementacion parcial, y en 
    // la macro remplazar/agregar los fields necesarios a la clase en vez de crearla directamente en macro)
    static function main() {
        var a = 16;

        var cls = Type.resolveClass("modifiers.ModifierProcessor");
        a = Reflect.callMethod(cls, Reflect.field(cls, "run"), [a]);
        trace(a);
    }
}