package;

import sys.io.File;
import sys.FileSystem;
import haxe.macro.Printer;
#if macro
import haxe.macro.Compiler;
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;

class ModifierMacro {
	static var ran:Bool = false;

	public static function init() {
		Compiler.include("modifiers.list");

		// on this part the comments are in spanish because this code is very complex to me ngl
		// and leaving the comments on my native leng may be better to still understand this on a future
		// (i tend to forget how my code works lmfao)
		Context.onAfterTyping((types) -> {
			if (ran)
				return;

			ran = true;

			// usada para guardar todos los valores por default de todos los mods.
			var defaultValues = new StringMap<Float>();
			var modifierFields:Array<Field> = [];
			var runExpr:ExprDef = EBlock([]);

			for (type in types) {
				switch (type) {
					case TClassDecl(c):
						var cls = c.get();

						var isMod = false;

						for (intf in cls.interfaces) {
							if (intf != null && intf.t.toString() == "IModifier") {
								isMod = true;
								Sys.println("Found a mod: " + cls.name);
							}
						}

						if (!isMod)
							continue;

						// aqui empieza la logica para recolectar el meta para los valores def
						var clsMeta = cls.meta.get();

						for (flag in cls.meta.get()) {
							if (flag.name == ":modifiers") {
								for (expr in flag.params) {
									switch (expr.expr) {
										case EObjectDecl(fields):
											for (obj in fields) {
												var k:String = obj.field;
												var v:Float = 0.;

												switch (obj.expr.expr) {
													case EConst(CFloat(f, _)):
														v = Std.parseFloat(f);
													case EConst(CInt(i, _)):
														v = Std.parseInt(i);
													case _:
														// nothing
												}

												var mfield:Field = {
													name: '__modifier__' + k,
													access: [APublic, AStatic],
													kind: FVar(macro :Float, macro $v{v}),
													pos: Context.makePosition({
														min: 0,
														max: 1,
														file: 'MACROF_' + k
													})
												};
												modifierFields.push(mfield);

												defaultValues.set(k, v);
											}
										case _:
											// nothing
									}
								}
							}
						}
						// para este punto ya guardamos todos los mods que se van a usar y sus valores default
						// aqui ahora, vamos a extraer la funcion apply
						var clsFields = cls.fields.get();

						for (field in clsFields) {
							if (field.name == "apply") {
								var rawExpr = field.expr();

								// Sys.println(rawExpr.expr);

								var expr = Context.getTypedExpr(field.expr());

								// aqui convertimos esto de una funcion anonima, a una con nombre
								switch (expr.expr) {
									case EFunction(kind, f):
										expr.expr.getParameters()[0] = FNamed(cls.name, true);
									case _:
										//
								}
								var assignExpr:Expr = {
									expr: EBinop(OpAssign, {
										expr: EConst(CIdent("value")),
										pos: Context.currentPos()
									}, {
										expr: ECall({
											expr: EConst(CIdent(cls.name)),
											pos: Context.currentPos()
										}, [
											{
												expr: EConst(CIdent("value")),
												pos: Context.currentPos()
											}
										]),
										pos: Context.currentPos()
									}),
									pos: Context.currentPos()
								};
								runExpr.getParameters()[0].push(expr);
								runExpr.getParameters()[0].push(assignExpr);
							}
						}

						cls.exclude();

					case _:
						//
				}
			}
			Sys.println("Default Mod Values: " + defaultValues);

			var returnExpr:Expr = {
				expr: EReturn({
					expr: EConst(CIdent("value")),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			};
			runExpr.getParameters()[0].push(returnExpr);

			// a este punto ya recolectamos todo lo necesario para hacer la clase, asi q a hacer la clase

			buildProcessorClass(modifierFields, runExpr);
		});
	}

	static function buildProcessorClass(fields:Array<Field>, fExpr:ExprDef) {
		var finalFields = fields.concat([
			{
				name: "run",
				access: [APublic, AStatic],
				pos: Context.makePosition({
					min: 0,
					max: 1,
					file: "ModifierMacro"
				}),
				kind: FFun({
					args: [
						{
							name: "value",
							type: macro :Float
						}
					],
					ret: macro :Float,
					expr: {
						expr: fExpr,
						pos: Context.makePosition({
							min: 0,
							max: 1,
							file: "MACROF_ModifierProcessor"
						}),
					}
				})
			}
		]);

		final t = {
			pack: ["modifiers"],
			name: "ModifierProcessor",
			pos: Context.currentPos(),
			kind: TDClass(null, null, false, false, false),
			fields: finalFields
		};

		var prntr = new Printer();
		File.saveContent(Sys.getCwd() + '_macro_gen\\Gen_ModifierProcessor.hx', prntr.printTypeDefinition(t));

		Context.defineModule("modifiers.ModifierProcessor", [t]);
	}
}
#end
