java -classpath "lib\jade.jar;lib\jadeTools.jar;lib\Base64.jar;lib\http.jar;lib\iiop.jar;lib\beangenerator.jar;lib\jgomas.jar;lib\jason.jar;lib\JasonJGomas.jar;classes;." jade.Boot -container -host localhost "T1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(agents\default\jasonAgent_AXIS.asl);T2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(agents\default\jasonAgent_AXIS_MEDIC.asl);T3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(agents\default\jasonAgent_AXIS_FIELDOPS.asl);A1:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(agents\default\jasonAgent_ALLIED_FIELDOPS.asl);A2:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(agents\default\jasonAgent_ALLIED.asl);A3:es.upv.dsic.gti_ia.JasonJGomas.BasicTroopJasonArch(agents\default\jasonAgent_ALLIED_MEDIC.asl)"
