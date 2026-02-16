// ==========================================
// 1. Config
// ==========================================

// Logo SVG (Debe estar en la misma carpeta que este archivo)
logo_file = "govern.svg";

// Text
string = "L-37";
// Font size.
font_size = 14;
// Logo size.
logo_size = 14;
//Font family.
font_name = "Adwaita Sans";
style = "Bold Italic";//[Regular,Bold, Italic, Bold Italic]

font_text = str(font_name, ":style=", style);

// -- Margin and spaces

// Left margin.
left_margin = 8;
// Space between logo and text.
logo_text_space = 10;
// Right margin.
right_margin = 8;       

// -- Grosores

// Plate thickness.
thicknessPlate = 3;
//Heigh of the layer (logo, text, stroke).
heightLayer = 2; 
//Stroke thickness.
thicknessStroke = 2; 

// -- Keychain geometry.

// Width
ly = 20;
// Radius points.
r = 4;
// External radius keychain.
r_ext_key = 5;
// Internal radius keychain.
r_int_key = 3; 
$fn = 100;

// ==========================================
// 2. Automated calcs (NOT TOUCH)
// ==========================================
// Calculate width of text (number chars * size * correction factor) 
ancho_texto_estimado = len(string) * font_size * 0.65;

// Total length of the body (lx)
lx = left_margin + logo_size + logo_text_space + ancho_texto_estimado + right_margin;

// Basic Coordinates.
x0 = r_ext_key;
x1 = r_ext_key + lx;
y0 = ly/2;
y1 = -ly/2;

// Text position.
pos_x_texto = x0 + left_margin + logo_size + logo_text_space;

// Keychain body points.
POINT_A = [[x0, y0], [x1, y0], [x0, y1], [x1, y1]];
POINT_B = [
    [x0 + thicknessStroke, y0 - thicknessStroke],
    [x1 - thicknessStroke, y0 - thicknessStroke],
    [x0 + thicknessStroke, y1 + thicknessStroke],
    [x1 - thicknessStroke, y1 + thicknessStroke]
];

// ==========================================
// 3. Render
// ==========================================

// -- LOGO --
translate([x0 + left_margin + logo_size/2, 0, thicknessPlate])
linear_extrude(height = heightLayer) {
    // Redimensiona el SVG automáticamente al tamaño deseado
    resize([logo_size, 0], auto=true)
        import(logo_file, center=true);
};

// -- TEXT --
translate([pos_x_texto, 0, thicknessPlate])
    linear_extrude(height = heightLayer)
    text(string, font = font_text, size=font_size, spacing=0.9, halign = "left", valign = "center");

// -- Keychain ring --
difference(){
    cylinder(r = r_ext_key, h = thicknessPlate);
    cylinder(r = r_int_key, h = thicknessPlate*4, center = true);
}

// -- Keychain plate --
difference(){
    hull() {
        for (pos = POINT_A) translate(pos) cylinder(r = r, h = thicknessPlate + heightLayer);
    }
    // Decorative hole (the upper "emptying").
    translate([0, 0, thicknessPlate])
    hull() {
        for (pos = POINT_B) translate([pos[0], pos[1], 0]) cylinder(r = r, h = heightLayer + 1);
    }    
}