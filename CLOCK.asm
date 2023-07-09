;--------------------------------------------------
; Programmme D'affichge de l'heure
;--------------------------------------------------
    TITLE AFFICHAGE HEURE 
;--------------------------------------------------
    ASSUME CS:CSEG, DS:CSEG, ES:CSEG
CSEG    SEGMENT
 
        ORG 100H
;*****prgramme principal
MAIN:

	MOV AH, 01h; Vérifier si une touche est enfoncée
    INT 16h;
    JNZ FIN; jump a la fin si touche pressé

	;Vider l'écran
	MOV AX, 0003 ; 
	MOV AH, 00 ; Fonction video
	MOV AL, 06 ; mode graphique (01, 02... 0B)
	INT 10h ; intéruption 
	
	
	MOV AH, 02 ; Fonction position du curseur
	MOV BH, 00 ; page 00 donc page actuelle
	MOV DX, 0219h ; Position XX ligne et XX colonne 
	INT 10h ; intéruption
	
	
	MOV AH, 09H ; Fontion afficher chaine de caractère
	MOV DX, OFFSET message ; affichage chaine de caractère
	INT 21H ; Intéruption

    ; Obtenir l'heure avec 2ch
    MOV AH, 2CH
    INT 21H
    
    ; Enregistrement dans les variable
    MOV heure, CH ; stocker CH de la variable Heure
    MOV minute, CL; stocker CL de la variable minute
    MOV seconde, DH; stocker DH de la variable seconde

    ; conversion heure
    MOV AH, 0 ; Mettre le registre AH à 0
    MOV AL, heure ; Stocker Heure dans AL
    MOV BH, 10 ; Mettre 10 dans BH
    DIV BH; Dviser AX par BH pour obtenir la valeur en décimale et placer le quotient dans AL et le reste dans AH (conversion decimale)
    ADD AX, 3030H ; on ajoute 30 en hexa a la partie poids fort de AX et 30 a la partie poid faible (conversion ASCII)
    MOV heure, AL; On récupère l'unité dans al vers heure (première valeur du résultat ascii)
    MOV heure+1, AL; on recupère la dizaine dans AL vers heure
    MOV heure, AH 
    MOV DL, heure+1; DL = print (dizaine)
    MOV AH, 2; afficher 
    INT 21H ; appel interuption DOS
    MOV DL, heure; DL = print (unité)
    MOV AH, 2 ; appel interuption afficher 
    INT 21H ; interuption DOS


	; affichage ':'
    MOV AH, 2 ; appel interuption afficher 
    MOV DL, ':' ; placer ":" dans le registre a afficher 
    INT 21H        

	; conversion minute (pas de commentaire car c'est le même fonctionnement que pour les heures)
	MOV AH, 0
    MOV AL, minute	
    MOV BH, 10		
    DIV BH         
    ADD AX, 3030H
    MOV minute, AL
    MOV minute+1, AL
    MOV minute, AH
    MOV DL, minute+1
    MOV AH, 2
    INT 21H  
    MOV DL, minute
    MOV AH, 2
    INT 21H       

	; affichage ':'
    MOV AH, 2
    MOV DL, ':'
    INT 21H     

	;conversion seconde (pas de commentaire car c'est le même fonctionnement que pour les heures)
	MOV AH, 0
    MOV AL, seconde	
    MOV BH, 10		
    DIV BH         
    ADD AX, 3030H
    MOV seconde, AL
    MOV seconde+1, AL
    MOV seconde, AH
    MOV DL, seconde+1
    MOV AH, 2
    INT 21H  
    MOV DL, seconde
    MOV AH, 2
    INT 21H     
	
	MOV AH, 02 ; Fonction position du curseur
	MOV BH, 00 ; page 00 donc page actuelle
	MOV DX, 0410h ; Position XX ligne et XX colonne 
	INT 10h ; intéruption
    MOV AH, 09H ; Fontion afficher chaine de caractère
	MOV DX, OFFSET message2 ; affichage chaine de caractère
	INT 21H ; Intéruption
	
    ; Boucle d'attente d'une seconde
    MOV AH, 86h    ; Fonction 0x86 (Wait)
    MOV CX, 10h  ; Valeur pour obtenir environ 1 seconde de délai
    INT 15h     ; Interruption 0x15 (System Services)
    
    
    
jmp MAIN

FIN:
    MOV AH, 4CH
		INT 20H ; interuption finir un programme
;****************zone de données
    heure DB 2 DUP(?)
    minute DB 2 DUP(?)
    seconde DB 2 DUP(?)
	message DB "Heure actuelle : $"
	message2 DB "Appuyez sur une touche pour fermer le programme$"
CSEG    ENDS
        END MAIN
;----------------------------------------fin
