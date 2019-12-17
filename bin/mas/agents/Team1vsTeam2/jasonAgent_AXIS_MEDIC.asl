debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("AXIS").
// Type of troop.
type("CLASS_MEDIC").

// Value of "closeness" to the Flag, when patrolling in defense
patrollingRadius(64).




{ include("jgomas.asl") }


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
          
                    if (Team == 100) {  // Only if I'm AXIS
				
 					    ?debug(Mode); if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
					    +aimed_agent(Object);
                        -+aimed("true");

                        .nth(6, Object, Pos);
                        .my_team("AXIS", E1);
                        //.println("Mi equipo intendencia: ", E1 );
                        .concat("follow_any_enemy(", Pos,")", Content1);
                        .send_msg_with_conversation_id(E1, tell, Content1, "CFA");

                    }
                    
                }
             
                -+bucle(X+1);
                
            }
                     
        }

     -bucle(_).

        

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

+follow_any_enemy(pos(X,Y,Z))[source(_)] : nothing2do
    <-
        /* !lookAt(X,Y,Z); */
        /* .my_name(AgentName); */
        /* !add_task(task(5001, "TASK_GOTO_POSITION", AgentName, pos(X,Y,Z), "")); */
        !lookAtPosNow(pos(X,Y,Z));
        -nothing2do;
        .
      
        
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
    <-  // Aimed agents have the following format:
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        ?aimed_agent(AimedAgent);
        ?debug(Mode); if (Mode<=1) { .println("AimedAgent ", AimedAgent); }
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam); }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 100) {
        
            .nth(6, AimedAgent, NewDestination);
            ?debug(Mode); if (Mode<=1) { .println("NUEVO DESTINO MARCADO: ", NewDestination); }
            //update_destination(NewDestination);
        }
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
/**  You can change initial priorities if you want to change the behaviour of each agent  **/
+!setup_priorities
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 2000);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE",1000);
        +task_priority("TASK_ATTACK", 1000);
        +task_priority("TASK_RUN_AWAY", 1500);
        +task_priority("TASK_GOTO_POSITION", 750);
        +task_priority("TASK_PATROLLING", 500);
        +task_priority("TASK_WALKING_PATH", 750).   



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
    if (positioned) {
        -positioned;
        +stay;
        .println("HOLLOOOOOLOLOLO");
        !lookAt(0,0,256);
    }
    if (not stay) {
        +positioned;
    }
    else {
        !attack;
        ?tasks(Tasks);
        .length(Tasks, TaskListLength);
        if (TaskListLength == 0) {
            +nothing2do;
        }

    }
    .
	
	
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
       
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(X, Y, Z);
          
         .my_team("fieldops_AXIS", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= 70) { 
          ?my_position(X, Y, Z);
          
         .my_team("medic_AXIS", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
       .
       
/////////////////////////////////
//  ANSWER_ACTION_CFM_OR_CFA
/////////////////////////////////


    
+cfm_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
      /* !posicionarse; */
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
    -+tasks([]);

    !posicionarse;
    .

/**
* Cada soldado va a su posición al inicio del juego.
* - Va hacia su posición (según la táctica)
* - Rota hasta apuntar la direción por dónde vengan los enemigos.
*/
+!posicionarse
    <-
    -positioned;
    -stay;
    .my_name(AgentName);
    .concat("", AgentName, "", StrName);

    if (StrName == "T6"){
        !add_task(task(4002, "TASK_GOTO_POSITION", AgentName, pos(240,0,235), ""));
    }
    else {
        if (StrName == "T7") {
            !add_task(task(4002, "TASK_GOTO_POSITION", AgentName, pos(240,0,236), ""));
        }
    }
    .

+!lookAt (X, Y, Z)
    <-
    ?my_position(MyX, MyY, MyZ);
    VX = X - MyX;
    VY = Y - MyY;
    VZ = Z - MyZ;

    Dist = math.sqrt(VX**2 + VY**2 + VZ**2);

    NormVX = VX/Dist;
    NormVY = VY/Dist;
    NormVZ = VZ/Dist;

    ObjPos1 = pos(MyX - NormVX/6, MyY - NormVY/6, MyZ - NormVZ/6);
    ObjPos2 = pos(MyX + NormVX/6, MyY + NormVY/6, MyZ + NormVZ/6);

	.my_name(MyName);
    NewTask1 = task(4000, "TASK_GOTO_POSITION", MyName, ObjPos1,"");
    NewTask2 = task(3999, "TASK_GOTO_POSITION", MyName, ObjPos1,"");
	!add_task(NewTask1);
	!add_task(NewTask2);

    /* -+state(standing); */
    /* -goto(_,_,_); */
    .

+!lookAtPosNow (pos(X, Y, Z))
    <-
    ?my_position(MyX, MyY, MyZ);
    VX = X - MyX;
    VY = Y - MyY;
    VZ = Z - MyZ;

    Dist = math.sqrt(VX**2 + VY**2 + VZ**2);

    NormVX = VX/Dist;
    NormVY = VY/Dist;
    NormVZ = VZ/Dist;

    .println(NormVX, " ", NormVY, " ", NormVZ);
    /* ObjPos1 = pos(MyX - NormVX/6, MyY - NormVY/6, MyZ - NormVZ/6); */
    ObjPos2 = pos(MyX + NormVX*3, MyY + NormVY*3, MyZ + NormVZ*3);

	.my_name(MyName);
    /* NewTask1 = task(4000, "TASK_GOTO_POSITION", MyName, ObjPos1,""); */
    NewTask2 = task(3999, "TASK_GOTO_POSITION", MyName, ObjPos2,"");
	/* !add_task(NewTask1); */
	!add_task(NewTask2);

    -+state(standing);
    -goto(_,_,_);
    .


+!attack
    <-
    .my_name(MyName);
    ?my_position(X, Y, Z);
    if(not initialized_time_stay) {
        .time_in_millis(FirstCurrentTime_stay);

        +last_time_move_stay(FirstCurrentTime_stay);
        +last_time_look_stay(FirstCurrentTime_stay);

        +initialized_time_stay;

    }
    // Need to look?
    .time_in_millis(CurrentTime_stay);
    ?last_time_look_stay(LastTimeLook_stay);
    DiferentialLookTime_stay = CurrentTime_stay - LastTimeLook_stay;

    if (DiferentialLookTime_stay > 500) {
        -+last_time_look_stay(CurrentTime_stay);

        // Look around.
        !look;

        !perform_look_action;

        !get_agent_to_aim;

        if ((aimed(Ag)) & (Ag=="true")) {
            // Save current destination.
            ?current_destination(OldDestination);

            !perform_aim_action;

            ?debug(Mode); if (Mode<=2) { .println("VOY A DISPARAR!!!"); }
            // Shot.
            !!shot(0);

            // Continue to previous destination.

            update_destination(OldDestination);

            -+last_time_move_stay(CurrentTime_stay);

            // ya no tengo objetivo
            -+aimed("false");

        }; // End of if (aimed_agent)



    }; // Endo of if (DiferentialTime > 500)
    .
