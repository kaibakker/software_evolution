module Visualisation

import vis::Figure;
import vis::Render;
import vis::KeySym;
import util::Editors;

import Prelude;

public real threshold = 0.2;

public str placeholder = "Methode 1 \nMethode 2";

public void visualise(list[list[real]] matrix, list[loc] methodNames) {
	explanation = placeholder;
	
	colorMatrix = [ [
		box(fillColor(colorBox(matrix[x][y])),
		onMouseEnter(void () { explanation = "<xname> \n <yname>"; }),
		onMouseExit(void () { explanation = placeholder ; }),
		onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {			
			edit(methodNames[x], []);
			edit(methodNames[y], []);
			return true;
		})
		)
	| y <- [0..size(matrix[x])], str yname := "<methodNames[y]>" ] | x <- [0..size(matrix)], str xname := "<methodNames[x]>" ];
	
	textBox = text(str () { return explanation; } );
	
	render(grid([[textBox], [grid(colorMatrix)]] ));	
}




public Color colorBox(real similarity) {	
	if (similarity > threshold) {
		return color("White");
	} else if(similarity == 0.0) {
		return color("LightCoral");
	} else {
		return color("Turquoise", 1.0 - similarity);		
	}
}

test bool testColorBox1() =
	color("White") == colorBox(1.0);
test bool testColorBox3() =
	color("LightCoral") == colorBox(0.0);
	

