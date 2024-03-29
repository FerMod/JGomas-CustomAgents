debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_MEDIC").





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
	-friendly_fire;

    while (not friendly_fire & bucle(X) & (X < Length)) {

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

                ?debug(Mode); if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
                -+aimed_agent(Object);
                -+aimed("true");

            }else{
				//If the agent has an ally in the point of view, it doesn't shoot.
				.nth(4, Object, Dis);
				?current_task(task(_, _, _, PosObj, _));
				?my_position(MX,MY,MZ);
				.nth(6, Object, PosComp);
				!cosangle(pos(MX,MY,MZ), PosObj, PosComp);
				?cosangle(A);
				if((A > 0.9 & Dis < 25) | Dis < 3){
					-+aimed("false");
					-aimed_agent(_);
					+friendly_fire;
				}
			}
        }

        -+bucle(X+1);

    }


}

-bucle(_).

//Calculates the cosine between two vectors. It is used to verify if an agent is in the point of view.
+!cosangle(pos(X1,Y1,Z1), pos(X2,Y2,Z2), pos(X3,Y3,Z3)) <- X12 = X2-X1;
													   	   Y12 = Y2-Y1;
													       Z12 = Z2-Z1;
													       X13 = X3-X1;
													       Y13 = Y3-Y1;
													       Z13 = Z3-Z1;
													       ProdEsc = X12*X13+Y12*Y13+Z12*Z13;
													       ProdMod = math.sqrt(X12*X12+Y12*Y12+Z12*Z12)*math.sqrt(X13*X13+Y13*Y13+Z13*Z13);
													       Cosangle = ProdEsc/ProdMod;
													       -+cosangle(Cosangle).
/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////
+look_response(FOVObjects)[source(M)]
    <-  //-waiting_look_response;
        .length(FOVObjects, Length);
        if (Length > 0) {
            ?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
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
    <-  // Aimed agents have the following format:
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
 .

/**
* Action to do when the agent is looking at.
*
* This plan is called just after Look method has ended.
*
* <em> It's very useful to overload this plan. </em>
*
*/

//If the agent doesn't have the flag, it checks its current situation.
+!perform_look_action: not objectivePackTaken(on) <- !check_flanqueo;
													 !check_flag;
													 !check_medicine.


//If the agent has the flag, it sends messages to the other ALLIES to tell them its position.
+!perform_look_action <- !check_flanqueo;
						?my_position(X,Y,Z);
						.my_team("ALLIED", E1);
						.concat("goto(",X,",",Y,",",Z,")", Content1);
						.send_msg_with_conversation_id(E1, tell, Content1, "INT").



//The agent checks if it has arrived to the flanking position.
+!check_flanqueo: flanqueo <- ?my_position(X,Y,Z);
							  !distance(pos(X,Y,Z), pos(230,0,145));
							  ?distance(Dist);
							  if(Dist < 5){
							  		-flanqueo;
							  }.

+!check_flanqueo.

//The agent checks if it's near the position of the objective and there is no flag.
+!check_flag <- ?my_position(X,Y,Z);
				?objective(OX,OY,OZ);
				!distance(pos(X,Y,Z), pos(OX,OY,OZ));
				?distance(Dist);
				if(Dist < 1){
					-+objective(224, 0, 224);
				}.

//If the agent has low health, it checks if there is any medic pack in the FOV.
+!check_medicine <- ?my_health_threshold(Ht);
       				?my_health(Hr);
					if (Hr <= Ht & not current_task(task(_,"TASK_RUN_AWAY",_,_,_))){
                        ?fovObjects(Objects);
                        .length(Objects, Length);
                        -+count(0);
                        while(count(X) & X < Length){
                            .nth(X, Objects, Object);
                            .nth(4, Object, Dis);
                            .nth(2, Object, Type);
                            if(Type == 1001 & Dis < 17){
                                .nth(6, Object, Pos);
                                +medics(Pos);
                                -+state(standing);
                            }
                            -+count(X+1);
                        }
					}.

/**
* Action to do if this agent cannot shoot.
*
* This plan is called when the agent try to shoot, but has no ammo. The
* agent will spit enemies out. :-)
*
* <em> It's very useful to overload this plan. </em>
*
*/
+!perform_no_ammo_action.
/**
     * Action to do when an agent is being shot.
     *
     * This plan is called every time this agent receives a messager from
     * agent Manager informing it is being shot.
     *
     * <em> It's very useful to overload this plan. </em>
     *
     */
+!perform_injury_action
<-
    create_medic_pack;
.

/////////////////////////////////
//  SETUP PRIORITIES
/////////////////////////////////
/**  You can change initial priorities if you want to change the behaviour of each agent  **/
+!setup_priorities
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 5000);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE",1000);
        +task_priority("TASK_ATTACK", 1000);
        +task_priority("TASK_RUN_AWAY", 1500);
        +task_priority("TASK_GOTO_POSITION", 750);
        +task_priority("TASK_PATROLLING", 500);
        +task_priority("TASK_WALKING_PATH", 1750).



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

//If the agent has seen a medic pack and it has low health, it goes to the position of the medic pack.
+!update_targets: medics(X) <- -medics(_);
							  ?manager(M);
							  !add_task(task(4100, "TASK_RUN_AWAY", M, X, "")).

//If the agent has the "flanqueo" belief, it goes to the "flanking" position.
+!update_targets: flanqueo <- ?manager(M);
							  !add_task(task(4000, "TASK_GOTO_POSITION", M, pos(230,0,145), "")).

//Otherwise, it goes to the objective.
+!update_targets <- ?objective(X,Y,Z);
					?manager(M);
					!add_task(task(3500, "TASK_GET_OBJECTIVE", M, pos(X,Y,Z), "")).





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
     <- -+medicAction(on).
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
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);

       if (Ar <= At) {
          ?my_position(X, Y, Z);

         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");


       }

	   //If the agent has low health, it creates medic packs.
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       if (Hr <= Ht) {
          create_medic_pack;
       }.

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

//If the agent takes the flag and it's near the original position of the flag, it returns back to the "flanking" position.
+objectivePackTaken(on) <- ?my_position(X,Y,Z);
						   if(X>208 & Z>145){
						   		+flanqueo;
						   }
						   -+state(standing).

/////////////////////////////////
//  Manage communications
/////////////////////////////////

//If the agent receives a message from the agent that has the flag, it updates the position of the objective.
+goto(X,Y,Z)[source(A)] <-  -+objective(X,Y,Z);
							-+state(standing);
							-goto(X,Y,Z)[source(A)].

/////////////////////////////////
//  Initialize variables
/////////////////////////////////

//We initialize the agent with the "flanqueo" belief. The agent will flank the opponents.
+!init
<-
    -+my_health_threshold(70);
    +flanqueo;
.
