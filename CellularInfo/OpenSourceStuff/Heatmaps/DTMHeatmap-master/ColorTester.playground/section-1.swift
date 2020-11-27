import UIKit

// This number should be between 0 and 1
let kSBAlphaPivotX :CGFloat = 0.333;

// This number should be between 0 and MAX_ALPHA
let kSBAlphaPivotY :CGFloat = 0.5;

// This number should be between 0 and 1
let kSBMaxAlpha :CGFloat = 0.85;

func stdGetColor(aVal :CGFloat) -> (r :CGFloat, g :CGFloat, b :CGFloat, a :CGFloat) {
    var a :CGFloat = 1.0
    var r :CGFloat = 0.0
    var g :CGFloat = 0.0
    var b :CGFloat = 0.0
    
    let maxVal :CGFloat = 255;
    var value = aVal
    
    if (value > 1) {
        value = 1;
    }
    
    value = sqrt(value);
    
    if (value < kSBAlphaPivotY) {
        a = value * kSBAlphaPivotY / kSBAlphaPivotX;
    } else {
        a = kSBAlphaPivotY + ((kSBMaxAlpha - kSBAlphaPivotY) / (1 - kSBAlphaPivotX)) * (value - kSBAlphaPivotX);
    }
    
    //formula converts a number from 0 to 1.0 to an rgb color.
    //uses MATLAB/Octave colorbar code
    if (value <= 0) {
        r = 0
        g = 0
        b = 0
        a = 0
    } else if (value < 0.125) {
        r = 0;
        g = 0;
        b = 4 * (value + 0.125);
    } else if (value < 0.375) {
        r = 0;
        g = 4 * (value - 0.125);
        b = 1;
    } else if (value < 0.625) {
        r = 4 * (value - 0.375);
        g = 1;
        b = 1 - 4 * (value - 0.375);
    } else if (value < 0.875) {
        r = 1;
        g = 1 - 4 * (value - 0.625);
        b = 0;
    } else {
        r = max(1 - 4 * (value - 0.875), 0.5);
        g = 0;
        b = 0
    }
    
    let color = UIColor(red: r, green: g, blue: b, alpha: a)
    
    a *= maxVal;
    b *= a;
    g *= a;
    r *= a;
    
    return (r,g,b,a)
}

func diffGetColor(aVal :CGFloat) -> (r :CGFloat, g :CGFloat, b :CGFloat, a :CGFloat) {
    var a :CGFloat = 1.0
    var r :CGFloat = 0.0
    var g :CGFloat = 0.0
    var b :CGFloat = 0.0
    
    let maxVal :CGFloat = 255;
    
    let isNegative = aVal < 0;
    let value = sqrt(min(abs(aVal), 1));
    if (value < kSBAlphaPivotY) {
        a = value * kSBAlphaPivotY / kSBAlphaPivotX;
    } else {
        a = kSBAlphaPivotY + ((kSBMaxAlpha - kSBAlphaPivotY) / (1 - kSBAlphaPivotX)) * (value - kSBAlphaPivotX);
    }
    
    if (isNegative) {
        r = 0;
        if (value <= 0) {
            g = 0
            b = 0
            a = 0
        } else if (value < 0.125) {
            g = 0;
            b = 2 * (value + 0.125);
        } else if (value < 0.375) {
            b = 2 * (value + 0.125);
            g = 4 * (value - 0.125);
        } else if (value < 0.625) {
            b = 4 * (value - 0.375);
            g = 1;
        } else if (value < 0.875) {
            b = 1;
            g = 1 - 4 * (value - 0.625);
        } else {
            b = max(1 - 4 * (value - 0.875), 0.5);
            g = 0;
        }
    } else {
        b = 0;
        if (value <= 0) {
            g = 0
            r = 0
            a = 0
        } else if (value < 0.125) {
            g = value;
            r = (value);
        } else if (value < 0.375) {
            r = (value + 0.125);
            g = value;
        } else if (value < 0.625) {
            r = (value + 0.125);
            g = value;
        } else if (value < 0.875) {
            r = (value + 0.125);
            g = 1 - 4 * (value - 0.5);
        } else {
            g = 0;
            r = max(1 - 4 * (value - 0.875), 0.5);
        }
    }
    
    let color = UIColor(red: r, green: g, blue: b, alpha: a)
    
    a *= maxVal;
    b *= a;
    g *= a;
    r *= a;
    return (r,g,b,a)
}

for var i :CGFloat = 0; i < 1.0; i += 0.05 {
    stdGetColor(i)
}

for var i :CGFloat = -1.0; i < 1.0; i += 0.05 {
    diffGetColor(i)
}
