
+!modd(Num,Div)
<-
    Res = Num - Div * (Num / Div);
    .println("---- ResMod: ", Res);
    -+modd(Res);
.

// https://introcs.cs.princeton.edu/java/13flow/Sin.java
+!sinn(X)
<-
    // Convert x to an angle between -2 PI and 2 PI
    //X = X % (2 * math.pi);
    .println("---- X1: ", X);
    !modd(X,2 * math.pi);
    .println("---- Mod ");
    ?modd(X);
    .println("---- X2: ", X);

    // Compute the Taylor series approximation
    Term = 1.0; // ith term = x^i / i!
    Sum = 0.0; // sum of first i terms in taylor series

    I = 1;
    //for (int i = 1; term != 0.0; i++) 
    while(not (Term == 0.0)) {
        Term = Term * (ModX/I);
        !modd(I,4);
        ?modd(ModResult);
        if (ModResult == 1) {
            Sum = Sum + Term;
        }
        if (ModResult == 3) {
            Sum = Sum - Term;
        }
        I = I + 1;
        .println("---- I: ", I);
        .println("---- Sum: ", Sum);
    }
    -+sinn(Sum);
.

// https://www.quora.com/How-do-you-convert-sin-to-cos
+!coss(X)
<-
    !sinn(X + math.pi);
    ?sinn(Res);
    -+coss(Res);
.
