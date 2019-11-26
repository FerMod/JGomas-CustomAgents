@echo off 

set T1="T1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS.asl)"
set T2="T2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS.asl)"
set T3="T3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS.asl)"
set T4="T4:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_MEDIC.asl)"
set T5="T5:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_MEDIC.asl)"
set T6="T6:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_FIELDOPS.asl)"
set T7="T7:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_FIELDOPS.asl)"

set A1="A1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED.asl)"
set A2="A2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED.asl)"
set A3="A3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED.asl)"
set A4="A4:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_MEDIC.asl)"
set A5="A5:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_MEDIC.asl)"
set A6="A6:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_FIELDOPS.asl)"
set A7="A7:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_FIELDOPS.asl)"

java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "%T1%;%T2%;%T3%;%T4%;%T5%;%T6%;%T7%;%A1%;%A2%;%A3%;%A4%;%A5%;%A6%;%A7%"
