@echo off

set T1="T1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_POSITION.asl)"
set T2="T2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_SCARED.asl)"
set T3="T3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_SCARED2.asl)"

set A1="A1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_CRAZY.asl)"
set A2="A2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_FOLLOW.asl)"

java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "%T1%;%T2%;%T3%;%A1%;%A2%"
