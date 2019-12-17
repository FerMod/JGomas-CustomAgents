debug(5).

// Name of the manager
manager("Manager").

// Team of troop.
team("AXIS").
// Type of troop.
type("CLASS_FIELDOPS").

// Value of "closeness" to the Flag, when patrolling in defense
patrollingRadius(5).




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
//The agent aims the enemy with the lowest health.
+!get_agent_to_aim
<-  ?fovObjects(FOVObjects);
.length(FOVObjects, Length);

if (Length > 0 & not current_task(task(_,"TASK_GOTO_POSITION",_,_,_))) {
    +bucle(0);
    -+aimed("false");
    -friendly_fire;
	-+min(1000);
    while (not friendly_fire & bucle(X) & (X < Length)) {
        .nth(X, FOVObjects, Object);
        .nth(2, Object, Type);
        .nth(6, Object, pos(Ix,Y,Iz));
        if (Type >= 1000) {
            ?debug(Mode); if (Mode<=2) { .println("I found some object."); }
        } else {
            // Object may be an enemy
            .nth(1, Object, Team);
            ?my_formattedTeam(MyTeam);
            
            if (Team == 100) {  // Only if I'm AXIS
				?min(Min);
				.nth(5, Object, Health);
				if(Min>Health){
					-+attack(Ix,Y,Iz);
					-+aimed_agent(Object);
					-+aimed("true");
					-+state(standing);
					-+min(Health);
				}
            }else{
				//If the agent has an enemy in the point of view that is closer than 20 units, it doesn't shoot.
				.nth(4, Object, Dis);
				?current_task(task(_, _, _, PosObj, _));
				?my_position(MX,MY,MZ);
				.nth(6, Object, PosComp);
				!cosangle(pos(MX,MY,MZ), PosObj, PosComp);
				?cosangle(A);
				if(A > 0.95 & Dis < 20){
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
            update_destination(NewDestination);
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
+!perform_look_action.
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
 
//If the agent has no ammo, it returns to patrol and it looks for ammo packs.
+!perform_no_ammo_action <- 
  if(current_task(task(_,"TASK_ATTACK",_,_,_)))
  {
    ?objective(Ix,Y,Iz);
    -+patrol(Ix,Y,Iz);
    -+state(standing);
  }
  ?fovObjects(FOVObjects);
  .length(FOVObjects, Length);
  if (Length > 0 & not current_task(task(_,"TASK_GOTO_POSITION",_,_,_))) {
    +bucle(0);
    while (bucle(X) & (X < Length)) {
      .nth(X, FOVObjects, Object);
      .nth(2, Object, Type);
      .nth(6, Object, pos(Ix,Y,Iz));
      if (Type == 1001) {
        -+ammo(Ix,Y,Iz);
        -+state(standing);
      }
      -+bucle(X+1);
    }
  }
  -bucle(_);
.

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
 //At the beginning, the agent goes to patrol its patrolling position.
+!update_targets: first <- -first;
							-+tasks([]);
							?objective(X,Y,Z);
							!add_task(task(5200,"TASK_PATROLLING", M, pos(X, Y, Z), "")).
							
//If the agent has seen an ammo pack and it has no ammo, it goes to its position.
+!update_targets: ammo(Ix,Y,Iz) <- -ammo(_,_,_);
                   				   !add_task(task(5100,"TASK_GOTO_POSITION", M, pos(Ix, Y, Iz), "")).
				
//If the agent has seen an enemy, it attacks that enemy.
+!update_targets: attack(Ix,Y,Iz) <-   -attack(_,_,_);
									   ?tasks(T);
									   .delete(task(_, "TASK_ATTACK", _, _, _),T,NewTaskList);
									   +tasks(NewTaskList);
									   !add_task(task(5000,"TASK_ATTACK", M, pos(Ix, Y, Iz), "")).
						
//If the agent has no ammo, it returns to patrol its patrolling position.
+!update_targets: patrol(Ix,Y,Iz) <- -patrol(_,_,_);
									 ?tasks(T);
									 .delete(task(_, "TASK_ATTACK", _, _, _),T,NewTaskList);
									 -+tasks(NewTaskList).           
				   
+!update_targets.
  
  
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
<-  -+fieldopsAction(off).
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
       //If the agent has low ammo, it produces ammo packs.
       if (Ar <= At) {
          create_ammo_pack;
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) { 
         ?my_position(X, Y, Z);  
         .my_team("medic_AXIS", E2);
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
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

//We initialize the patrolling position of the agent.
+!init
   <- 	-+objective(135,0,205);
		-+my_ammo_threshold(50);
		+first. 

