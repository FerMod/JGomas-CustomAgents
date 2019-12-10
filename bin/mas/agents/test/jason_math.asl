
// https://introcs.cs.princeton.edu/java/13flow/Sin.java
+!sinn(X)
<-
    // Convert x to an angle between -2 PI and 2 PI
    //X = X % (2 * math.pi);
    ModX = X mod (2 * math.pi);
    .println("---- ModX: ", ModX);

    // Compute the Taylor series approximation
    Term = 1.0; // ith term = x^i / i!
    Sum = 0.0; // sum of first i terms in taylor series

    //for (int i = 1; term != 0.0; i++)
    I = 1;
    while (not (Term == 0.0)) {
        Term = Term * (ModX/I);

        if ((I mod 4) == 1) {
            Sum = Sum + Term;
        }
        if ((I mod 4) == 3) {
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
