@echo off

set T1="T1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS.asl)"
set T2="T2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS.asl)"
set T3="T3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS.asl)"
set TF1="TF1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_FIELDOPS.asl)"
set TF2="TF2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_FIELDOPS.asl)"
set TM1="TM1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_MEDIC.asl)"
set TM2="TM2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_AXIS_FIELDOPS.asl)"

set A1="A1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED.asl)"
set A2="A2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED.asl)"
set A3="A3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED.asl)"
set AF1="AF1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_FIELDOPS.asl)"
set AF2="AF2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_FIELDOPS.asl)"
set AM1="AM1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_MEDIC.asl)"
set AM2="AM2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(%1\jasonAgent_ALLIED_MEDIC.asl)"

java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "%T1%;%T2%;%T3%;%TF1%;%TF2%;%TM1%;%TM2%;%A1%;%A2%;%A3%;%AF1%;%AF2%;%AM1%;%AM2%"
