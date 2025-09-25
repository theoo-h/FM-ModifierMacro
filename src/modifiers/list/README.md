Para definir modifiers, en la clase de tu modifier agrega el metadata `@:modifiers`;
Este contendra un objeto/estructura declarando los modifiers y su valor por default,
el cual puede ser un `Int` o `Float`.

Al momento del calculo de tu modifier, debes de definir tu valor en una variable separada,
esto para evitar errores inesperados en la logica de tu modifier, la razon es:
Accedes a los modifiers usando `untyped`.
```haxe
// forma incorrecta
var mi_valor_interno = Math.sin(Math.PI / 2);

numero += untyped myModifier +  mi_valor_interno;

/**
 * En la linea de codigo de arriba en vez de declarar el mod como
 * una variable lo usas directo, y esto puede causar errores en algunos casos
 * por ejemplo, si `mi_valor_interno` no llegara a existir al momento del 
 * typing/parseado no adverteria del error, porque `mi_valor_interno` se
 * incluye en el el bloque de untyped, lo que hace que el checker no
 * cheque esa variable.
 * 
 * Asi que, el error aparecera hasta que ocurra la compilacion, y en
 * este punto pierdes la informacion exacta de donde esta el error,
 * lo que causario confusion.
*/

// forma correcta
var mi_valor_interno = Math.sin(Math.PI / 2);
var mi_valor = untyped myModifier;

numero += mi_valor + mi_valor_interno;

/**
 * Ahora aqui en el bloque superior, el bloque de untyped solo tiene `myModifier`
 * Por lo que el checker no checaria solamente esa variable.
 * 
 * Todo lo de mas se mantiene intacto, ahora si por casualidad no
 * existiera `mi_valor_interno` el parseador detectaria el error.
*/
```