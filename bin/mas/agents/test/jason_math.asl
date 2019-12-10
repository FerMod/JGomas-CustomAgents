
// https://introcs.cs.princeton.edu/java/13flow/Sin.java
+!sinn(X)
<-
    // Convert x to an angle between -2 PI and 2 PI
    //X = X % (2 * math.pi);
    ModX = X mod (2 * math.pi);
    .println("---- ModX: ", ModX);

    // Compute the Taylor series approximation
    // Term = 1.0; // ith term = x^i / i!
    // Sum = 0.0; // sum of first i terms in taylor series

    //for (int i = 1; term != 0.0; i++)
    // I = 1;
    -+term(1);
    -+sum(0);
    -+auxI(1);
    while (term(Term) & (Term < 0 | Term > 0)) {
        ?auxI(I);
        ?term(Term);
        -+term(Term * (ModX/I));
        //Term = Term * (ModX/I);

        ?sum(Sum);
        if ((I mod 4) == 1) {
            -+sum(Sum + Term)
            //Sum = Sum + Term;
        }
        if ((I mod 4) == 3) {
            -+sum(Sum - Term)
            //Sum = Sum - Term;
        }

        -+auxI(I + 1);
        //I = I + 1;
        //.println("---- I: ", I);
        //.println("---- Sum: ", Sum);
    }
    -auxI(_);
    -term(_);
    ?sum(Result);
    .println("---- Sum: ", Sum);
    -+sinn(Result);
    -sum(Sum);
.

// https://www.quora.com/How-do-you-convert-sin-to-cos
+!coss(X)
<-
    !sinn(X + math.pi);
    ?sinn(Res);
    -+coss(Res);
.
