debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_MEDIC").




{ include("jgomas.asl") }

+!going_to(X,Y,Z,AUX_X,AUX_Z,M)
    <-
    -+state(standing);
    -goto(_,_,_);
    check_position(pos(X+AUX_X, Y, Z+AUX_Z));
    ?position(P);
    if (not position(invalid)){
      //.println("POSITION valid");
      !add_task(task(2500, "TASK_GOTO_POSITION", M, pos(X+AUX_X, Y, Z+AUX_Z), ""));
    } else {
      .println("POSITION INvalid");
      -+position(valid);
      !add_task(task(2500, "TASK_GOTO_POSITION", M, pos(X, Y, Z), ""));
    }
    .

+cff(X, Y, Z)[source(M)]
    <-
        //.println("Rececived message from ", M);
        !distance(pos(X, Y, Z));
        ?agent_name(A);
        ?objective(ObjectiveX, ObjectiveY, ObjectiveZ);
        !distance(pos(ObjectiveX, ObjectiveY, ObjectiveZ));
        ?distance(D);
        if (D < 10){
          if (A == "A1"){
            +original_name("A1extra");
          }
          if (A == "A2"){
            +original_name("A2extra");
          }
          -+agent_name("A6");
        } else {
          ?original_name(Ad);
          -+agent_name(Ad);
        }
        if (A == "A1"){
          //.println("ALPHA going up!");
          !going_to(X,Y,Z,5,-5,M);
        }
        if (A == "A2"){
          //.println("ALPHA going up!");
          !going_to(X,Y,Z,5,5,M);
        }
        if (A == "A3"){
          //.println("ALPHA going up!");
          !going_to(X,Y,Z,0,-5,M);
        }
        if (A == "A4"){
          //.println("BRAVO going front!");
          !going_to(X,Y,Z,5,0,M);
        }
        if (A == "A5"){
          //.println("GAMMA going down!");
          !going_to(X,Y,Z,0,5,M);
        }
        if (A == "A6"){
          //.println("DELTA going behind!");
          !going_to(X,Y,Z,-5,0,M);
        }
        if (A == "A1extra"){
          //.println("ALPHA going up!");
          !going_to(X,Y,Z,-5,5,M);
        }
        if (A == "A2extra"){
          //.println("ALPHA going up!");
          !going_to(X,Y,Z,-5,-5,M);
        }
        .

// Plans


/*******************************
*
* Actions definitions
*
*******************************/

/////////////////////////////////
//  GET AGENT TO AIM 
/////////////////////////////////  
/**
 * Calculates if there is an enemy at sight.
 *
 * This plan scans the list <tt> m_FOVObjects</tt> (objects in the Field
 * Of View of the agent) looking for an enemy. If an enemy agent is found, a
 * value of aimed("true") is returned. Note that there is no criterion (proximity, etc.) for the
 * enemy found. Otherwise, the return value is aimed("false")
 *
 * <em> It's very useful to overload this plan. </em>
 * 
 */
+!get_agent_to_aim
<-  ?debug(Mode); if (Mode<=2) { .println("Looking for agents to aim."); }
?fovObjects(FOVObjects);
.length(FOVObjects, Length);

?debug(Mode); if (Mode<=1) { .println("El numero de objetos es:", Length); }
	?objective(ObjectiveX, ObjectiveY, ObjectiveZ);
    !distance(pos(ObjectiveX, ObjectiveY, ObjectiveZ));
    ?distance(D);
    .random(T);
    /*if (D < 20*T){
    	.wait(50000);
    }*/
/*
if (Length > 0) {
    +bucle(0);
    
    -+aimed("false");
    
    while (aimed("false") & bucle(X) & (X < Length)) {
        
        //.println("En el bucle, y X vale:", X);
        
        .nth(X, FOVObjects, Object);
        // Object structure
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        .nth(2, Object, Type);
        
        ?debug(Mode); if (Mode<=2) { .println("Objeto Analizado: ", Object); }
        
        if (Type > 1000) {
            ?debug(Mode); if (Mode<=2) { .println("I found some object."); }
        } else {
            // Object may be an enemy
            .nth(1, Object, Team);
            ?my_formattedTeam(MyTeam);
            
            if (Team == 200) {  // Only if I'm ALLIED
				        .nth(6, Object, Position);
                //!can_shoot(Position);
                ?debug(Mode); if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
                +aimed_agent(Object);
                -+aimed("true");
                
            }
            
        }
        
        -+bucle(X+1);
        
    }
    
   
}

-bucle(_)
*/
.

/*
+!can_shoot(pos(X,Y,Z))
  <- 
  .println("1");
  ?fovObjects(FOVObjects);
  .println("2");
  .length(FOVObjects, Length);
  .println("3");
  +bucle_fun(0);
  .println("4");
  ?my_position(Xpos, Ypos, Zpos);
  .println("5");
  +vec_enemy(X-Xpos,0,Z-Zpos);
  .println("6");
  ?vec_enemy(Xsol,Ysol,Zsol);
  .println("7");
  +vec_enemy_mod(sqrt(Xsol*Xsol+Zsol*Zsol));
  .println("8");
  ?vec_enemy_mod(k);
  .println(" <-------------------------------------------------------------", k);
  while (bucle_fun(X) & (X < Length)){
    .nth(X, FOVObjects, Object);
    .nth(1, Object, Team);
    if (Team == 100) {
      .nth(6, Object, Position_allied);

    }
    -+bucle(X+1);

  }
  .
*/
/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////
+look_response(FOVObjects)[source(M)]
    <-  //-waiting_look_response;
        .length(FOVObjects, Length);
        if (Length > 0) {
            ///?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
        };    
        -look_response(_)[source(M)];
        -+fovObjects(FOVObjects);
        //.//;
        !look.
      
        
/////////////////////////////////
//  PERFORM ACTIONS
/////////////////////////////////
/**
* Action to do when agent has an enemy at sight.
* 
* This plan is called when agent has looked and has found an enemy,
* calculating (in agreement to the enemy position) the new direction where
* is aiming.
*
*  It's very useful to overload this plan.
* 
*/
+!perform_aim_action
    /*<-  // Aimed agents have the following format:
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        
        ?aimed_agent(AimedAgent);
        ?debug(Mode); if (Mode<=1) { .println("AimedAgent ", AimedAgent); }
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);             }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 200) {
    
                .nth(6, AimedAgent, NewDestination);
                ?debug(Mode); if (Mode<=1) { .println("NUEVO DESTINO DEBERIA SER: ", NewDestination); }
          
            }
        */
 .

/**
* Action to do when the agent is looking at.
*
* This plan is called just after Look method has ended.
* 
* <em> It's very useful to overload this plan. </em>
* 
*/
+!perform_look_action .
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_LOOK_ACTION GOES HERE.") }. 

/**
* Action to do if this agent cannot shoot.
* 
* This plan is called when the agent try to shoot, but has no ammo. The
* agent will spit enemies out. :-)
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!perform_no_ammo_action . 
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_NO_AMMO_ACTION GOES HERE.") }.
    
/**
     * Action to do when an agent is being shot.
     * 
     * This plan is called every time this agent receives a messager from
     * agent Manager informing it is being shot.
     * 
     * <em> It's very useful to overload this plan. </em>
     * 
     */
+!perform_injury_action .
    ///<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_INJURY_ACTION GOES HERE.") }. 
        

/////////////////////////////////
//  SETUP PRIORITIES
/////////////////////////////////
/**  You can change initial priorities if you want to change the behaviour of each agent  **/+!setup_priorities
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 0);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE", 10);
        +task_priority("TASK_ATTACK", 0);
        +task_priority("TASK_RUN_AWAY", 0);
        +task_priority("TASK_GOTO_POSITION", 1500);
        +task_priority("TASK_PATROLLING", 0);
        +task_priority("TASK_WALKING_PATH", 0). 

/////////////////////////////////
//  UPDATE TARGETS
/////////////////////////////////
/**
 * Action to do when an agent is thinking about what to do.
 *
 * This plan is called at the beginning of the state "standing"
 * The user can add or eliminate targets adding or removing tasks or changing priorities
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
+!update_targets
	<-	?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR UPDATE_TARGETS GOES HERE.") };
  .my_name(MyName);
  ?my_position(X,Y,Z);
  -+state(standing);
  -goto(_,_,_).
	
	
	
/////////////////////////////////
//  CHECK MEDIC ACTION (ONLY MEDICS)
/////////////////////////////////
/**
 * Action to do when a medic agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkMedicAction
     <-  -+medicAction(on).
      // go to help
      
      
/////////////////////////////////
//  CHECK FIELDOPS ACTION (ONLY FIELDOPS)
/////////////////////////////////
/**
 * Action to do when a fieldops agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkAmmoAction
     <-  -+fieldopsAction(on).
      //  go to help



/////////////////////////////////
//  PERFORM_TRESHOLD_ACTION
/////////////////////////////////
/**
 * Action to do when an agent has a problem with its ammo or health.
 *
 * By default always calls for help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
+!performThresholdAction
       <-
       
       ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_TRESHOLD_ACTION GOES HERE.") }

       /*
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(X, Y, Z);
          
         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) {  
          ?my_position(X, Y, Z);
          
         .my_team("medic_ALLIED", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
       */
       .
       
/////////////////////////////////
//  ANSWER_ACTION_CFM_OR_CFA
/////////////////////////////////


    
+cfm_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
      -cfm_agree.  

+cfa_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_agree GOES HERE.")};
      -cfa_agree.  

+cfm_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_refuse GOES HERE.")};
      -cfm_refuse.  

+cfa_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_refuse GOES HERE.")};
      -cfa_refuse.  


/////////////////////////////////
//  Initialize variables
/////////////////////////////////

+!init
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR init GOES HERE.")};
   .my_name(MyName);
   .concat("",MyName,"", Content1);
   +agent_name(Content1);
   +original_name(Content1);
   -+state(standing);
   -goto(_,_,_).