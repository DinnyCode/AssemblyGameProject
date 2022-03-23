        ORG    $1000
        
**************
**************
**START GAME**
**************
**************
START:
    BSR SETUP
    BSR WELCOME
    BSR GAME_LOOP

*************************
*************************
**MAIN GAME SUBROUTINES**
*************************

**********************************
*DECLARE VARIABLES AND SETUP GAME*
**********************************
SETUP:
    *OUTPUT FOR SETTING UP GAME
    BSR CLEAR_SCREEN
    LEA SETUP_MSG, A1
    BSR PRINT_MSG_ALT
    BSR LOADING_OUTPUT  
    
    *INITIALIZING VARAIBLES
    
    *STARTING VARAIBLES
    MOVE.W #5, CARBON_AMOUNT            STARTING CARBON LEVEL
    MOVE.W #100, MONEY                  STARTING MONEY
    MOVE.W #0, TICK_COUNT               STARTING TICK
   
    *END GAME VARIABLES
    MOVE.W #5, TICK_DEADLINE          DEADLINE TO REDUCE CARBON

    *STRUCTURE STARTING COUNTS
    MOVE.W #0, TREE_COUNT               TOTAL NO. TREES
    MOVE.W #0, WINDMILL_COUNT           TOTAL NO. WINDMILLS
    MOVE.W #0, SOLAR_PANEL_COUNT        TOTAL NO. SOLAR PANELS
    
    *STRUCTURE COSTS
    MOVE.W #2, TREE_COST                COST OF TREE
    MOVE.W #5, WINDMILL_COST            COST OF WINDMILLS
    MOVE.W #10, SOLAR_PANEL_COST        COST OF SOLAR PANEL
    
    *REDUCTION VARIABLES
    MOVE.W #2, TREE_REDUCTION           REDUCTION VALUE OF TREES
    MOVE.W #5, WINDMILL_REDUCTION       REDUCTION VALUE OF WINDMILLS
    MOVE.W #10, SOLAR_PANEL_REDUCTION   REDUCTION VALUE OF SOLAR PANELS
    
    *CALCUALTION VARIABLES
    MOVE.W #0, CARON_REDUCTION          RATE CARBON REDUCES BY
    MOVE.W #0, CARBON_INCREASE_RATE     RATE CARBON INCREASES 
    MOVE.W #0, CARBON_COUNTER           COUNTER FOR CARBON PARTICLES REDUCED
    
    RTS

**************************************
*WELCOMES USER AND INTRODUCES TO GAME*
**************************************
WELCOME:
    LEA GAME_TITLE, A1                  TITLE SCREEN MESSAGE
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
       
    LEA WELCOME_MSG, A1                 INTRODUCTION TO GAME
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    RTS
    
****************
*MAIN GAME LOOP*
**************** 
GAME_LOOP:   
    BSR GAME_STATS                      OUTPUTS CURRENT STATS OF GAME
    BSR INPUT                           GO TO SHOP OR CONTINUE WITH GAME
    
    BSR UPDATE_TICK                     UPDATES TICK AFTER TURN IS MADE
        
    BSR CALCULATE_REDUCTION             CALCULATE REDUCTION VALUE
    BSR UPDATE_CARBON                   UPDATE CARBON VALUE AFTER BEING REDUCED
    BSR OUTPUT_CARBON                   OUTPUT UPDATED CARBON VALUE
    
    BSR WIN_STATUS                      CHECK IF PLAYER HAS WON OR LOST 

**********************
*OUPUTS STATS OF GAME*
**********************
GAME_STATS:
    *OUTPUT SUB ROUTINE MESSAGE
    LEA GAME_STATS_MSG, A1
    BSR PRINT_MSG
   
    *OUTPUT CARBON COUNT
    LEA UPDATE_CARBON_MSG, A1
    BSR PRINT_MSG_ALT
    LEA CARBON_AMOUNT, A1
    BSR PRINT_NUM
    
    *OUTPUT MONEY
    LEA MONEY_MSG, A1
    BSR PRINT_MSG_ALT
    LEA MONEY, A1
    BSR PRINT_NUM
    
    *OUTPUT TICK
    LEA TICK_MSG, A1
    BSR PRINT_MSG_ALT
    LEA TICK_COUNT, A1
    BSR PRINT_NUM

    *OUTPUT TICK DEADLINE
    LEA TICK_DEADLINE_1_MSG,A1
    BSR PRINT_MSG_ALT
    LEA TICK_DEADLINE, A1
    MOVE.W (A1),D1
    MOVE.B #3, D0
    TRAP #15
    LEA TICK_DEADLINE_2_MSG,A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT

    RTS

***************************************************
*PROMPTS USER FOR INPUT TO GO TO SHOP OR SKIP TURN*
***************************************************
INPUT:
    *PROMPT PLAYER FOR INPUT
    LEA INPUT_MSG, A1
    BSR PRINT_MSG
    
    BSR INPUT_PROMPT
    
    *GO TO SHOP IF PLAYER ENTERS 1
    CMP #1, D1
    BEQ SHOP
    
    *VALIDATION
    CMP #1, D1
    BGT INPUT_VALIDATION
    
    CMP #0, D1
    BLT INPUT_VALIDATION
    
    *RTS IF PLAYER ENTERS 0
    RTS
    
*******************************
*ALLOWS USER TO BUY STRUCTURES*
*******************************      
SHOP:   
    BSR CLEAR_SCREEN
    
    *OUTPUT ASCII ART
    LEA SHOP_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    *PROMPT USER FOR INPUT
    LEA SHOP_INPUT_MSG, A1
    BSR PRINT_MSG
    BSR INPUT_PROMPT
    
    *OPTION TO PLANT TREE
    CMP #1, D1
    BEQ PLANT_TREE
    
    *OPTION TO BUILD WINDMILL
    CMP #2, D1
    BEQ BUILD_WINDMILL
    
    *OPTION TO BUILD WINDMILL
    CMP #3, D1
    BEQ BUILD_SOLAR_PANEL
    
    *VALIDATION
    CMP #4, D1
    BGT SHOP_VALIDATION
    
    CMP #1, D1
    BLT SHOP_VALIDATION
    
    *RTS IF PLAYER ENTERS 4
    RTS
    
**********************
*PLANT TREE STRUCTURE*
**********************
PLANT_TREE:
    *PLANTS TREE STRUCTURE
    BSR CLEAR_SCREEN
    
    *OUTPUT ASCII ART
    LEA TREE_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    *ADDS TO TREE COUNT
    ADD #1, TREE_COUNT 
    
    *SUBTRACTING COST OF TREE
    LEA TREE_COST, A3
    MOVE.W (A3),D4
    SUB D4, MONEY  
 
    *OUTPUT MESSAGE    
    LEA PLANT_TREE_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    RTS
**************************
*BUILD WINDMILL STRUCTURE*
**************************
BUILD_WINDMILL:
    BSR CLEAR_SCREEN
    
    *OUTPUT ASCII ART
    LEA WINDMILL_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    *ADDS TO WINDMILL COUNT
    ADD #1, WINDMILL_COUNT   
    
    *SUBTRACTING COST OF WINDMILL
    LEA WINDMILL_COST, A3
    MOVE.W (A3),D4
    SUB D4, MONEY   
    
    *OUTPUT MESSAGE 
    LEA BUILD_WINDMILL_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    RTS
    
******************************
*BUILDS SOLAR PANEL STRUCTURE*
******************************
BUILD_SOLAR_PANEL: 
    BSR CLEAR_SCREEN
    
    *OUTPUT ASCII ART
    LEA SOLAR_PANEL_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    *ADDS TO SOLAR PANEL COUNT
    ADD #1, SOLAR_PANEL_COUNT    
    
    *SUBTRACTING COST OF SOLAR PANEL
    LEA SOLAR_PANEL_COST, A3
    MOVE.W (A3),D4
    SUB D4, MONEY
    
    *OUTPUT MESSAGE 
    LEA BUILD_SOLAR_PANEL_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    RTS
    
*****************************
*OUTPUTS INVENTORY OF PLAYER*
*****************************
INVENTORY:
    *OUTPUT MESSAGE
    LEA INVENTORY_MSG, A1
    BSR PRINT_MSG
    
    *TREE COUNT OUTPUT
    LEA UPDATE_TREE_MSG, A1
    BSR PRINT_MSG_ALT
    LEA TREE_COUNT, A1
    BSR PRINT_NUM
    
    *WINDMILL COUNT OUTPUT
    LEA UPDATE_WINDMILL_MSG, A1
    BSR PRINT_MSG_ALT 
    LEA WINDMILL_COUNT, A1
    BSR PRINT_NUM

    *SOLAR PANEL COUNT OUTPUT
    LEA UPDATE_SOLAR_PANEL_MSG , A1
    BSR PRINT_MSG_ALT 
    LEA SOLAR_PANEL_COUNT, A1
    BSR PRINT_NUM
    
    *MONEY OUTPUT
    LEA MONEY_MSG, A1
    BSR PRINT_MSG_ALT
    LEA MONEY, A1
    BSR PRINT_NUM
    
    BSR CLEAR_PROMPT
    
    RTS
    
******************************
*UPDATES TICK FOR TURN PASSED* 
******************************
UPDATE_TICK:
    BSR CLEAR_SCREEN
    
    *UPDATING TICK
    ADD #1, TICK_COUNT
    
    *UPDATING TICK DEADLINE
    SUB #1, TICK_DEADLINE
    
    *OUTPUTTING TICK UPDATED MESSAGE
    LEA UPDATE_TICK_MSG, A1
    BSR PRINT_MSG
    
    *OUTPUTTING CURRENT TICK 
    LEA TICK_COUNT_MSG, A1
    BSR PRINT_MSG_ALT
    LEA TICK_COUNT, A1
    BSR PRINT_NUM
    
    BSR CLEAR_PROMPT
    
    RTS
    
***********************************
*CALCULATE CARBON REDUCTION AMOUNT*
***********************************
CALCULATE_REDUCTION:
    *RESETTING REDUCTION TO ZERO
    MOVE.W #0, D6
    
    *OUTPUT MESSAGE
    LEA CALCULATE_REDUCTION_MSG, A1
    BSR PRINT_MSG
    
    *TREE REDUCTION
    LEA TREE_COUNT, A4
    LEA TREE_REDUCTION, A5
    MOVE.W (A4),D4
    MOVE.W (A5),D5
    MULU D4,D5
      
    ADD D5, D6                  ADDING TO TOTAL REDUCTION
    
    *WINDMILL REDUCTION
    LEA WINDMILL_COUNT, A4
    LEA WINDMILL_REDUCTION, A5
    MOVE.W (A4),D4
    MOVE.W (A5),D5
    MULU D4,D5
    
    ADD D5, D6                  ADDING TO TOTAL REDUCTION

    *SOLAR PANEL REDUCTION
    LEA SOLAR_PANEL_COUNT, A4
    LEA SOLAR_PANEL_REDUCTION, A5
    MOVE.W (A4),D4
    MOVE.W (A5),D5
    MULU D4,D5
    
    ADD D5, D6                  ADDING TO TOTAL REDUCTION
    
    *OUTPUTTING CARBON REDUCTION
    MOVE D6, (CARON_REDUCTION)
    LEA CARBON_REDUCTION_AMOUNT_MSG, A1
    BSR PRINT_MSG_ALT
    LEA CARON_REDUCTION, A1
    BSR PRINT_NUM
    
    BSR CLEAR_PROMPT
    
    RTS
    
**********************
*UPDATES CARON AMOUNT*
**********************
UPDATE_CARBON:
    *SUBTRACT CARBON_REDUCTION VALUE FROM CARBON_AMOUNT
    SUB D6, CARBON_AMOUNT
    
    *ADD TO CARBON COUNTER 
    ADD #1, CARBON_COUNTER
    
    *VALIDATION FOR WHEN VALUE GOES BELOW '0'
    CMP #0, CARBON_AMOUNT
    BLE CARBON_VALIDATION
    
    RTS

******************************
*OUTPUTS UPDATED CARBON VALUE*
******************************
OUTPUT_CARBON:
    *OUTPUT NEW CARBON AMOUNT
    LEA UPDATE_CARBON_MSG, A1
    BSR PRINT_MSG_ALT
    LEA CARBON_AMOUNT, A1
    BSR PRINT_NUM
    
    BSR CLEAR_PROMPT
    
    RTS

*******************************************************
*SETS CARBON AMOUNT TO 0 IF IT HAS BEEN REDUCED PAST 0*
*******************************************************
CARBON_VALIDATION:
    MOVE.W #0,CARBON_AMOUNT
    BSR OUTPUT_CARBON

*******************************************
*CHECKS IF WIN OR LOSS STATUS HAS BEEN MET*
*******************************************
WIN_STATUS
    *CHECK THAT TICK DEADLINE HAS NOT BEEN MET YET
    LEA TICK_DEADLINE, A7
    CMP #0, (A7)
    BLE LOSS

    *CHECK IF CARBON HAS BEEN REDUCED ENOUGH
    LEA CARBON_AMOUNT, A7
    CMP #0, (A7)
    BLE VICTORY
    
    *OTHERWISE CONTINUE
    BRA GAME_LOOP

*******************
*EVENT SUB ROUTINES
*******************

****************************    
****************************
**END OF GAME SUB ROUTINES**
****************************
****************************

****************
*PLAYER HAS WON*
****************
VICTORY:
    BSR CLEAR_PROMPT
    
    *OUTPUT VICTORY MESSAGE
    LEA VICTORY_ART, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    *OUTPUT VICTORY ASCII ART
    LEA TROPHY_ART, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR FINAL_STATS

*****************
*PLAYER HAS LOST*
*****************
LOSS:
    BSR CLEAR_PROMPT
    
    *OUTPUT LOSS MESSAGE
    LEA LOSS_ART, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    *OUTPUT LOSS ASCII ART
    LEA SAD_FACE_ART, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR FINAL_STATS

*****************************
*OUTPUTS FINAL STATS OF USER*
*****************************
FINAL_STATS:
    *OUTPUT MESSAGE
    LEA FINAL_STATS_MSG, A1
    BSR PRINT_MSG
   
    *OUTPUT FINAL CARBON COUNT
    LEA FINAL_STATS_CARBON_1, A1
    BSR PRINT_MSG_ALT
    LEA CARBON_COUNTER, A1
    BSR PRINT_NUM_ALT
    LEA FINAL_STATS_CARBON_2, A1
    BSR PRINT_MSG
    
    *OUTPUT FINAL MONEY
    LEA FINAL_STATS_MONEY, A1
    BSR PRINT_MSG_ALT
    LEA MONEY, A1
    BSR PRINT_NUM_ALT
    BSR FORMATTER
    
    *OUTPUT FINAL  TICK
    LEA FINAL_STATS_TICK_1, A1
    BSR PRINT_MSG_ALT
    LEA TICK_COUNT, A1
    BSR PRINT_NUM_ALT
    LEA FINAL_STATS_TICK_2, A1
    BSR PRINT_MSG

    *OUTPUT FINAL TICK DEADLINE
    LEA FINAL_STATS_DEADLINE_1,A1
    BSR PRINT_MSG_ALT
    LEA TICK_DEADLINE, A1
    MOVE.W (A1),D1
    MOVE.B #3, D0
    TRAP #15
    LEA FINAL_STATS_DEADLINE_2,A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR REPLAY
    
*************************************
*PROMPTS USER TO REPLAY OR EXIT GAME*
************************************* 
REPLAY: 
    *PROMPT PLAYER FOR INPUT
    LEA REPLAY_MSG, A1
    BSR PRINT_MSG
    
    BSR INPUT_PROMPT
    
    *PLAYER WANTS TO REPLAY GAME
    CMP #1, D1
    BEQ START
    
    *PLAYER WANTS TO EXIT GAME
    CMP #0, D1
    BEQ EXIT_GAME
    
    *VALIDATION
    CMP #1, D1
    BGT REPLAY_VALIDATION
    
    CMP #0, D1
    BLT REPLAY_VALIDATION
    
    *ELSE FOR VALIDATION
    BRA REPLAY
 
 
**************************************   
**************************************
**FORMATTING AND OUTPUT SUB ROUTINES**
**************************************
**************************************

******************************
*PRINTS SYMBOL USED FOR INPUT*
*AND TAKES USER INPUT        *
******************************
INPUT_PROMPT:
    LEA INPUT_SYMBOL, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    RTS

*********************************
*CLEARS SCREEN WITHOUT PROMPTING*
*********************************
CLEAR_SCREEN:
    MOVE #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    
    MOVE.W #0, D1
    
    RTS
    
******************************
*PROMPTS USER TO CLEAR SCREEN*
******************************
CLEAR_PROMPT:   
    LEA CONTINUE_MSG,A1
    MOVE.B #14,D0
    TRAP #15

    MOVE.B #5, D0
    TRAP #15


    MOVE #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    
    MOVE.W #0, D1
    
    RTS

*************************************
*PRINTS MESSAGE WITH CARRIAGE RETURN*
*************************************   
PRINT_MSG:
    MOVE.B #13, D0
    TRAP #15
    
    RTS
    
****************************************
*PRINTS MESSAGE WITHOUT CARRIAGE RETURN*
****************************************
PRINT_MSG_ALT:
    MOVE.B #14, D0
    TRAP #15
    
    RTS

***********************************
*PRINTS NUMBER WITH FORMATTER LINE*
***********************************
PRINT_NUM:
    MOVE.W (A1),D1
    MOVE.B #3, D0
    TRAP #15
    
    BSR FORMATTER
    
    RTS
    
**************************************
*PRINTS NUMBER WITHOUT FORMATTER LINE*
**************************************  
PRINT_NUM_ALT:
    MOVE.W (A1),D1
    MOVE.B #3, D0
    TRAP #15
    
    RTS

****************************
*PRINTS LINE FOR FORMATTING*
****************************   
FORMATTER:
    LEA FORMATTER_MSG,A1
    BSR PRINT_MSG
    RTS

***********************
*USED FOR LOADING TEXT*
***********************
LOADING_OUTPUT:
    LEA LOADING_SYMBOL, A1
    BSR PRINT_MSG_ALT
    
    BSR PRINT_MSG_ALT
    
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    RTS

********************
*OUTPUTS BLANK LINE*
********************  
NEW_LINE_OUTPUT:
    LEA NEW_LINE, A1
    BSR PRINT_MSG
    RTS
   
******************************* 
*******************************
**SUB ROUTINES FOR VALIDATION**
*******************************
*******************************

*******************************
*OUTPUTS INVALID INPUT MESSAGE*
*******************************
VALIDATION:
    BSR CLEAR_SCREEN
    
    LEA INVALID_OPTION_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BSR CLEAR_PROMPT
    
    RTS
    
**********************************
*VALIDATION FOR INPUT SUB ROUTINE*
**********************************
INPUT_VALIDATION:
    BSR VALIDATION
    BRA INPUT

*********************************
*VALIDATION FOR SHOP SUB ROUTINE*
********************************* 
SHOP_VALIDATION:
    BSR VALIDATION
    BRA SHOP

***********************************
*VALIDATION FOR REPLAY SUB ROUTINE*
***********************************
REPLAY_VALIDATION:
    BSR VALIDATION
    BRA REPLAY


*****************
*****************
*****************
***END OF GAME***
*****************
*****************
*****************
EXIT_GAME:
    BSR CLEAR_SCREEN
    
    *OUTPUT EXIT ART
    LEA EXIT_ART,A1
    BSR PRINT_MSG
    
    *OUTPUT EXIT MESSAGE
    LEA EXIT_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    *END GAME
                    
    SIMHALT   
        
*******************
*PROGRAM VARIABLES*
*******************
    
*****************
*OUTPUT MESSAGES*
*****************


*WELCOME MESSAGES

SETUP_MSG DC.B 'Setting up game',0

WELCOME_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
            DC.B $0D,$0A
            DC.B ':::::::::::::::::::::::  Welcome  to  Carbon  Crusher!  ::::::::::::::::::::::::'
            DC.B $0D,$0A
            DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
            DC.B $0D,$0A
            DC.B '>Carbon emissions are rising in the world and we do not have much time left! :::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>We have to reduce the rate of carbon in order to save the planet! :::::::::::::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>That is where you come in crusher! It is up to you to save the planet! ::::::::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>You can purchase trees, windmill and solar panels in order to reduce carbon. ::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>These cost you money, which you have a limited amount of. Spend wisely! :::::::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>Different structures cost more but they are more effective at reducing carbon.:'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>Reduction is based on what structures you have and how many of them you have.::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>But be careful! You only have a limited amount of time before it is too late!::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>Each turn you take is one tick and each tick will reduce carbon levels. :::::::'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B ':------------------------------------------------------------------------------:'
            DC.B $0D,$0A
            DC.B '>And that is all crusher. Good luck out there and make sure to save the planet!:'
            DC.B $0D,$0A
            DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
            DC.B $0D,$0A
            DC.B '::::::::::::::::::::::::::::  Good  Luck  Crusher!  ::::::::::::::::::::::::::::'
            DC.B $0D,$0A
            DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

*GAME LOOP MESSAGES

GAME_STATS_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
               DC.B $0D,$0A
               DC.B ':::::::::::::::::::::::::::  Current  Game  Stats:  ::::::::::::::::::::::::::::',0

INPUT_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
          DC.B $0D,$0A
          DC.B ':::::::::::::::::::  Do  you  wish  to  go  to  the  shop?  ::::::::::::::::::::'
          DC.B $0D,$0A
          DC.B '................................................................................'
          DC.B $0D,$0A
          DC.B '::::::::::::::::::::::::::  1  -  Yes  |  0  -  No  ::::::::::::::::::::::::::::'
          DC.B $0D,$0A
          DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

GAME_LOOP_MSG DC.B 'Game Loop',0

CALCULATE_REDUCTION_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                        DC.B $0D,$0A
                        DC.B ':::::::::::::::::::::::  Carbon  Reduction  Calculation  :::::::::::::::::::::::'
                        DC.B $0D,$0A
                        DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

CARBON_REDUCTION_AMOUNT_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                            DC.B $0D,$0A
                            DC.B '::  Carbon  is  currently  being  reduced  by:  ',0
                           

UPDATE_CARBON_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                  DC.B $0D,$0A
                  DC.B '::  Current  Carbon Count:  ',0
                                 
*TICK MESSAGES

TICK_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
         DC.B $0D,$0A
         DC.B '::  Tick  no.:  ',0

UPDATE_TICK_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                DC.B $0D,$0A
                DC.B ':::::::::  You  have  made  your  turn  and  one  tick  has  passed!  ::::::::::',0

TICK_COUNT_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
               DC.B $0D,$0A
               DC.B ':: It  is  now  tick  no.:  ',0

TICK_DEADLINE_1_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                    DC.B $0D,$0A
                    DC.B '::  There  are  ',0

TICK_DEADLINE_2_MSG DC.B '  ticks  left  to  reduce  carbon  emissions!'
                    DC.B $0D,$0A
                    DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

*SHOP MESSAGES

SHOP_INPUT_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
               DC.B $0D,$0A
               DC.B ':::::::::::: Welcome to the shop!  What would you like to purchase? ::::::::::::'
               DC.B $0D,$0A
               DC.B ':...............................................................................'
               DC.B $0D,$0A
               DC.B ':::  1  -  Tree  |  2  -  Windmill  |  3  -  Solar  Panel  |  4  -  Cancel  ::::'
               DC.B $0D,$0A
               DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

PLANT_TREE_MSG  DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                DC.B $0D,$0A
                DC.B ':::::::::::::::::::::::  You  have  planted  a  tree!  :::::::::::::::::::::::::'
                DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

BUILD_WINDMILL_MSG  DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                    DC.B $0D,$0A
                    DC.B ':::::::::::::::::::::::  You  have  built  a windmill!  ::::::::::::::::::::::::'
                    DC.B $0D,$0A
                    DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

BUILD_SOLAR_PANEL_MSG   DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                        DC.B $0D,$0A
                        DC.B ':::::::::::::::::::::  You  have  built  a solar  panel!  ::::::::::::::::::::::'
                        DC.B $0D,$0A
                        DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

MONEY_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
          DC.B $0D,$0A
          DC.B 'Money: $',0

*INVENTORY MESSAGES

INVENTORY_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
              DC.B $0D,$0A
              DC.B '::::::::::::::::::::::::::::::  Inventory  Count  ::::::::::::::::::::::::::::::'
              DC.B $0D,$0A
              DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

UPDATE_TREE_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                DC.B $0D,$0A
                DC.B 'Total Trees: ',0

UPDATE_WINDMILL_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                    DC.B $0D,$0A
                    DC.B 'Total Windmills: ',0

UPDATE_SOLAR_PANEL_MSG  DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                        DC.B $0D,$0A
                        DC.B 'Total Solar Panels: ',0

*CHECK STATE MESSAGES

WIN_STATUS_MSG DC.B 'Checking Win Status',0

*WIN/LOSS MESSAGES

VICTORY_MSG DC.B 'Victory! You have reduced carbon emissions in time and saved the world!',0

LOSS_MSG DC.B 'Carbon emissions have not been reduced in time! You have lost!',0

*FINAL STATS MESSAGES
FINAL_STATS_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                DC.B $0D,$0A
                DC.B ':::::::::::::::  Here  are  your  final  stats  of  this  game  ::::::::::::::::'
                DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

FINAL_STATS_CARBON_1 DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                     DC.B $0D,$0A
                     DC.B '::  You  managed  to  crush:  ',0

FINAL_STATS_CARBON_2 DC.B '  carbon  particles '
                     DC.B $0D,$0A
                     DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

FINAL_STATS_MONEY DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                  DC.B $0D,$0A
                  DC.B '::  You  finished  with:  $',0

FINAL_STATS_TICK_1 DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                   DC.B $0D,$0A
                   DC.B '::  You  finished  the  game in: ',0

FINAL_STATS_TICK_2 DC.B '  ticks'
                   DC.B $0D,$0A
                   DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

FINAL_STATS_DEADLINE_1 DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
                       DC.B $0D,$0A
                       DC.B '::  You  had:  ',0

FINAL_STATS_DEADLINE_2 DC.B ' ticks  left  to  save  the  planet'
                       DC.B $0D,$0A
                       DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

*END GAME MESSAGES

REPLAY_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::  Would  you  like  to  replay  the  game?  ::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '................................................................................'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::  1  -  Yes  |  0  -  No  ::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0
           
EXIT_MSG    DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
            DC.B $0D,$0A
            DC.B ':::::::::::::::::  Thank  you  for  playing  Carbon  Crusher!  :::::::::::::::::'
            DC.B $0D,$0A
            DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

*FORMATTING MESSAGES

FORMATTER_MSG DC.B $0D,$0A
              DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

CONTINUE_MSG DC.B   $0D,$0A
             DC.B   '> Press  enter  to  continue ',0

INVALID_OPTION_MSG DC.B 'Invalid Option! Please try again!',0

LOADING_SYMBOL DC.B '.',0

INPUT_SYMBOL DC.B '>> ',0

MEMORY_PACKER_1 DC.B ':::::::::::::::::::::::::::::::',0

NEW_LINE DC.B $0D,$0A,0

MEMORY_PACKER_2 DC.B ':::::::::::::::::::::::::::::::',0

****************
*GAME VARIABLES*
****************

*MAIN GAME VALUES

CARBON_AMOUNT DS.W 1

MONEY DS.W 1

TICK_COUNT DS.W 1

TICK_DEADLINE DS.W 1

*STRUCTURE VARIABLES

TREE_COUNT DS.W 1

TREE_COST DS.W 1

WINDMILL_COUNT DS.W 1

WINDMILL_COST DS.W 1

SOLAR_PANEL_COUNT DS.W 1

SOLAR_PANEL_COST DS.W 1

*REDUCTION VARIABLES

TREE_REDUCTION DS.W 1

WINDMILL_REDUCTION DS.W 1
    
SOLAR_PANEL_REDUCTION DS.W 1

*CALCUALTION VARIABLES

CARON_REDUCTION DS.W 1

CARBON_INCREASE_RATE DS.W 1

CARBON_COUNTER DS.W 1

***********
*ASCII ART*
***********

*GAME START AND SETUP MESSAGES
GAME_TITLE DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::: ######::::: ###:::: ########:: ########::: #######:: ##::: ##:::::::::::::'
           DC.B $0D,$0A
           DC.B ':::: ##... ##::: ## ##::: ##.... ##: ##.... ##: ##.... ##: ###:: ##:::::::::::::'
           DC.B $0D,$0A
           DC.B ':::: ##:::..::: ##:. ##:: ##:::: ##: ##:::: ##: ##:::: ##: ####: ##:::::::::::::'
           DC.B $0D,$0A
           DC.B ':::: ##::::::: ##:::. ##: ########:: ########:: ##:::: ##: ## ## ##:::::::::::::'
           DC.B $0D,$0A
           DC.B ':::: ##::::::: #########: ##.. ##::: ##.... ##: ##:::: ##: ##. ####:::::::::::::'
           DC.B $0D,$0A
           DC.B ':::: ##::: ##: ##.... ##: ##::. ##:: ##:::: ##: ##:::: ##: ##:. ###:::::::::::::'
           DC.B $0D,$0A
           DC.B '::::. ######:: ##:::: ##: ##:::. ##: ########::. #######:: ##::. ##:::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::......:::..:::::..::..:::::..::........::::.......:::..::::..::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::: ######:: ########:: ##:::: ##:: ######:: ##:::: ##: ########: ########::::'
           DC.B $0D,$0A
           DC.B ':::: ##... ##: ##.... ##: ##:::: ##: ##... ##: ##:::: ##: ##.....:: ##.... ##:::'
           DC.B $0D,$0A
           DC.B ':::: ##:::..:: ##:::: ##: ##:::: ##: ##:::..:: ##:::: ##: ##::::::: ##:::: ##:::'
           DC.B $0D,$0A
           DC.B ':::: ##::::::: ########:: ##:::: ##:. ######:: #########: ######::: ########::::'
           DC.B $0D,$0A
           DC.B ':::: ##::::::: ##.. ##::: ##:::: ##::..... ##: ##.... ##: ##...:::: ##.. ##:::::'
           DC.B $0D,$0A
           DC.B ':::: ##::: ##: ##::. ##:: ##:::: ##: ##::: ##: ##:::: ##: ##::::::: ##::. ##::::'
           DC.B $0D,$0A
           DC.B '::::. ######:: ##:::. ##:. #######::. ######:: ##:::: ##: ########: ##:::. ##:::'
           DC.B $0D,$0A
           DC.B ':::::......:::..:::::..:::.......::::......:::..:::::..::........::..:::::..::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0           

*SHOP ART

SHOP_ART   DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
			DC.B $0D,$0A
			DC.B '::::::::::::##::::::::::::::::##:::::::::::::::::##::::::::::::::::##:::::::::::'
			DC.B $0D,$0A
			DC.B ':::::::: ########::::::::: ########:::::::::: ########::::::::: ########::::::::'
			DC.B $0D,$0A
			DC.B '::::::: ##. ##. ##::::::: ##. ##. ##:::::::: ##. ##. ##::::::: ##. ##. ##:::::::'
			DC.B $0D,$0A
			DC.B '::::::::##: ##:..:::::::: ##: ##:..::::::::::##: ##:..:::::::: ##: ##:..::::::::'
			DC.B $0D,$0A
			DC.B ':::::::. ########::::::::. ########:::::::::. ########::::::::. ########::::::::'
			DC.B $0D,$0A
			DC.B '::::::::... ##. ##::::::::... ##. ##:::::::::... ##. ##::::::::... ##. ##:::::::'
			DC.B $0D,$0A
			DC.B '::::::: ##: ##: ##::::::: ##: ##: ##:::::::: ##: ##: ##::::::: ##: ##: ##:::::::'
			DC.B $0D,$0A
			DC.B ':::::::. ########::::::::. ########:::::::::. ########::::::::. ########::::::::'
			DC.B $0D,$0A
			DC.B '::::::::....##..::::::::::....##..:::::::::::....##..::::::::::....##..:::::::::'
			DC.B $0D,$0A
			DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
			DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
			DC.B $0D,$0A
			DC.B '::::::::::::##::::::::::::::::##:::::::::::::::::##::::::::::::::::##:::::::::::'
			DC.B $0D,$0A
			DC.B ':::::::: ########::::::::: ########:::::::::: ########::::::::: ########::::::::'
			DC.B $0D,$0A
			DC.B '::::::: ##. ##. ##::::::: ##. ##. ##:::::::: ##. ##. ##::::::: ##. ##. ##:::::::'
			DC.B $0D,$0A
			DC.B '::::::::##: ##:..:::::::: ##: ##:..::::::::::##: ##:..:::::::: ##: ##:..::::::::'
			DC.B $0D,$0A
			DC.B ':::::::. ########::::::::. ########:::::::::. ########::::::::. ########::::::::'
			DC.B $0D,$0A
			DC.B '::::::::... ##. ##::::::::... ##. ##:::::::::... ##. ##::::::::... ##. ##:::::::'
			DC.B $0D,$0A
			DC.B '::::::: ##: ##: ##::::::: ##: ##: ##:::::::: ##: ##: ##::::::: ##: ##: ##:::::::'
			DC.B $0D,$0A
			DC.B ':::::::. ########::::::::. ########:::::::::. ########::::::::. ########::::::::'
			DC.B $0D,$0A
			DC.B '::::::::....##..::::::::::....##..:::::::::::....##..::::::::::....##..:::::::::'
			DC.B $0D,$0A
			DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0
			
*STRUCTURE ART

TREE_ART   DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::::::::::::.~::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::::::::::^!~~^^!J~?7:.:.^!!:::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::::::::7!7~!^77~^^^!7Y7!?~J?::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::::!~~!Y!^^^^^^^^^^^^^^^^^^7Y^~~::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::~!J7^~^^^^^^^^^^^^^^^^^^^^^^~~!J?:::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::7J7^^^^::^^^^^^^^^^^^^^^^::^~^^^7J?::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::~?!!J5~^^^^^^^^^^^^^^^^^^^^^^^~5?^^~!J7J^~::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::..~Y~^^^^^^^^?7~^^^:^^~~^^^^^!J??5?~^^^^:^~!?::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::~Y!~~^^^^^^^^^!?Y77J!7!Y?^^^^^^^~~~^^^^^::^^7J.:::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::~^J7^^??^^:^^^^^^^^^~!7!7!^^^^^^^^^^^^^^~~^^^^^?J^::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::?J~~^^^~?577~^^^^^^^^^^^:^^^^^^^^^^^^~^^^^^^^^^^^^~5^:::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::5!^^^^^~!?YYJ??~^^~^^^^^^^^^~^:^^^^^^^^^^^^^^^::~!J5!::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::~!?~~^^^^^^~~!!^^!5!^^^^^^^^^^^^!Y7^^^^^^!?~^^~!~YJ!?7^::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::Y7~^^^^^^^^^^^75JJ5?J7JGJ!~!Y?P!^^^^^^^?Y77JY7J~^!Y?::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::YJ?~~^^!?~~^~5J!~~YGYP5GPGP5!!^^^^^^!!^^^~!^^^^~J5.::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::..?Y??!!JY??P57??7PJY?55PPPPPJ!7?!?7P7^^^^^^~~!7J77::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::.^??J?7?775P7!Y5J7J5YB5GP?777????!^^~^~~^~JY:.::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::.!~~7YG5PY5~?55BPYP7!!??!~!!!~~!?J!!!::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::::::::GPYY7JJ55P5!!??Y~~7J7Y?!~7.::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::.5Y5?Y5JBB^:::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::5JY?J5!JB.::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::P75~P??P5:::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::::::.P~P!5?5G!:::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::B!GJY?P?~:::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::::::YG7PY~G5Y?:::::::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::::.^~5P?YJ5~?GYJY7^^:::::::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B ':::::::::::::::::::::::^~PGGYJYPJP5JYPGJ5PGYJ7^.::::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::~~^::.:^::..::::~^77~^~~7~.:::::::::::::::::::::::::::::::'
           DC.B $0D,$0A
           DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

WINDMILL_ART DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::_:::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::##::::::::::::::::##::::::::::::::::::_( )_:::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::##::::::::::::::##::::::::::::::::::(     )::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::##::::::::::::##:::::::::::_::::::(_______):::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::::##::::::::::##::::::::::_( )_::::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::##::::::::##::::::::::(     ):::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::::::##::::::##::::::::::(_______)::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::::##|--|##::::::::::::::::::_:::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::::::| ##==## |:::::::::::::::_( )_:::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::|___####___|:::::::::::::(     )::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::::|~~~~####~~~~|:::::::::::(_______):::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::===##==##===::::::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::::|..##....##..|:::::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::|..##......##..|::::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::::|..##........##..|:::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::|..##..........##..|::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::::|..##............##..|:::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::|..##..............##..|::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::(........................):::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::|...__..............__...|:::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::(..|__|............|__|..):::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::|........................|:::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::(...........__...........):::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::|..........|__|..........|:::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B ':::::::::::::::::::::::::::(__________|__|__________):::::::::::::::::::::::::::'		
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
             DC.B $0D,$0A
             DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0	

SOLAR_PANEL_ART DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':&57!!!!!!!!?J?777??JJYGGGGGBBB##&&&&&&:::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::&GY????????JYJ?7777777JJ?7!7777?J?777??JP&:::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::BY77777777?YJ?7!77777JYY??????JYJ?77777YB&::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::B??????????JJ?!!!!!!!7??77!7!77?J?7777!?Y#::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::&Y5P?7777777?JJY?777777?JJJ?77777?JJ?777!!?G&:::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::&GJ!!!77!7!7JJ?7!!!!!!?J?7!!!!!7?JJ????7?YB:::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::B5?????????YYYJ????77?JY?77!7!!7JJ?77777?P&::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::#57!!777777?JJ?7!!!7777JJ7777777?YYJ?????YB&:::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::&P?77777777?JY?7!7!!!!7?J?!!!!!!7?J?7777!75#:::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::::&BJ77!777777?YYJ????77?JYYJ??????YYYJ???77YG&::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::::::&?!!~~~~~~~~!?J7!!!!!!!7JJ?7777777??7!!!!!!JB::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::GPBY?777777777JYJ?777777?JYJ?77?77?JYJ7777!!?P&:::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::&P?!!!!!!!!!7JJ?7777777?JY?7777777?J?777777JB&::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::&G?~~~~~~~~~!?J?77777!!7?J?7!!!!!!7??7!!!!!75#::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::::::::::::::::BJ7~!!!!!!~!?J!!!!!!!!!7?7!!!!!!!7?777777!!P&::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::B~:?#################&#&&&&&&&&&&&&&&&&&::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::Y^.J::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::&~.?::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::&~.!::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::&7.~::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::::::::::::::::::&#^..&:::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::::::::::::::::::#&...B:::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B ':::::::::::::::::::::::::::::::::::::###::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
                DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0
                
*END GAME ART      
     
VICTORY_ART 
			    DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
			    DC.B $0D,$0A
				DC.B ':: ##:::: ##: ####:: ######:: ########:: #######:: ########:: ##::: ##: ####::::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##:. ##:: ##... ##:... ##..:: ##.... ##: ##.... ##:. ##: ##:: ####::::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##:: ##:: ##:::..::::: ##:::: ##:::: ##: ##:::: ##::. ####::: ####::::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##:: ##:: ##:::::::::: ##:::: ##:::: ##: ########::::. ##::::: ##:::::'
				DC.B $0D,$0A
				DC.B '::. ##:: ##::: ##:: ##:::::::::: ##:::: ##:::: ##: ##.. ##:::::: ##:::::..::::::'
				DC.B $0D,$0A
				DC.B ':::. ## ##:::: ##:: ##::: ##:::: ##:::: ##:::: ##: ##::. ##::::: ##:::: ####::::'
				DC.B $0D,$0A
				DC.B '::::. ###:::: ####:. ######::::: ##::::. #######:: ##:::. ##:::: ##:::: ####::::'
				DC.B $0D,$0A
				DC.B ':::::...:::::....:::......::::::..::::::.......:::..:::::..:::::..:::::....:::::'
				DC.B $0D,$0A
				DC.B '::::: ##::: ##:: #######:: ##:::: ##:::: ##::::: ##: ####: ##::: ##: ####:::::::'
				DC.B $0D,$0A
				DC.B ':::::. ##: ##:: ##.... ##: ##:::: ##:::: ##: ##: ##:. ##:: ###:: ##: ####:::::::'
				DC.B $0D,$0A
				DC.B '::::::. ####::: ##:::: ##: ##:::: ##:::: ##: ##: ##:: ##:: ####: ##: ####:::::::'
				DC.B $0D,$0A
				DC.B ':::::::. ##:::: ##:::: ##: ##:::: ##:::: ##: ##: ##:: ##:: ## ## ##:: ##::::::::'
				DC.B $0D,$0A
				DC.B ':::::::: ##:::: ##:::: ##: ##:::: ##:::: ##: ##: ##:: ##:: ##. ####::..:::::::::'
				DC.B $0D,$0A
				DC.B ':::::::: ##:::: ##:::: ##: ##:::: ##:::: ##: ##: ##:: ##:: ##:. ###: ####:::::::'
				DC.B $0D,$0A
				DC.B ':::::::: ##::::. #######::. #######:::::. ###. ###:: ####: ##::. ##: ####:::::::'
				DC.B $0D,$0A
				DC.B '::::::::..::::::.......::::.......:::::::...::...:::....::..::::..::....::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0	
				
TROPHY_ART
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::G5J??YGBBB##&&&&&##JJG:::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::#GBB&:#YJ?77JGBB##&&&&&&BB!75&:&###&::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::BJ:::::&5YJ?7JGBB##&&&&&&&G7JP::::::P&:::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::55::::::GYYJ7?PBB##&&&&&&&P7YB::::::PB:::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::B?::::::#YYY77PBB##&&&&&##5?5&::::::5#:::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::5Y::::::5YY7!5GB##&&&&&&BJJP::::::GB::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::P5:::::BYY?~JGB##&&&&&&57YB:::::GB:::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::#P#::::5YJ~7PGB##&&&&G!7Y::::&B&::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::&B&::&YJ!~YPGB#&&&#7~JB::&#&::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::&##&GY?^75PGB###J:75&&&:::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::&G5Y!^?5PGBB5:~YB&:::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::#J~~?YYY7^~G::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::::&Y~^~~^:?&:::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::::::#!???&:::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::Y!7G::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::5!?G::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::J7J5::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::::::B7JYJB&::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::&#GY??JYJ?YB&&:::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::B!!J7^^!?J7~^J5?J#:::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::7J?77JGBGB##^^~!!?:::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::#G5J?7777?JY5GB&::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0
				
LOSS_ART
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::: #######:: ##:::: ##::::::: ##::: ##:: #######::::: ####: ####: ####: ####:::'
				DC.B $0D,$0A
				DC.B ':: ##.... ##: ##:::: ##::::::: ###:: ##: ##.... ##:::: ####: ####: ####: ####:::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##: ##:::: ##::::::: ####: ##: ##:::: ##:::: ####: ####: ####: ####:::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##: #########::::::: ## ## ##: ##:::: ##::::: ##::: ##::: ##::: ##::::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##: ##.... ##::::::: ##. ####: ##:::: ##:::::..::::..::::..::::..:::::'
				DC.B $0D,$0A
				DC.B ':: ##:::: ##: ##:::: ##::::::: ##:. ###: ##:::: ##:::: ####: ####: ####: ####:::'
				DC.B $0D,$0A
				DC.B '::. #######:: ##:::: ##::::::: ##::. ##:. #######::::: ####: ####: ####: ####:::'
				DC.B $0D,$0A
				DC.B ':::.......:::..:::::..::::::::..::::..:::.......::::::....::....::....::....::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':: ##::: ##:: #######:: ##:::: ##:::: ##:::::::: #######::: ######:: ########:::'
				DC.B $0D,$0A
				DC.B '::. ##: ##:: ##.... ##: ##:::: ##:::: ##::::::: ##.... ##: ##... ##:... ##..::::'
				DC.B $0D,$0A
				DC.B ':::. ####::: ##:::: ##: ##:::: ##:::: ##::::::: ##:::: ##: ##:::..::::: ##::::::'
				DC.B $0D,$0A
				DC.B '::::. ##:::: ##:::: ##: ##:::: ##:::: ##::::::: ##:::: ##:. ######::::: ##::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: ##:::: ##: ##:::: ##:::: ##::::::: ##:::: ##::..... ##:::: ##::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: ##:::: ##: ##:::: ##:::: ##::::::: ##:::: ##: ##::: ##:::: ##::::::'
				DC.B $0D,$0A
				DC.B '::::: ##::::. #######::. #######::::: ########:. #######::. ######::::: ##::::::'
				DC.B $0D,$0A
				DC.B ':::::..::::::.......::::.......::::::........:::.......::::......::::::..:::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0
				
SAD_FACE_ART
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::::::&&&&:::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::&BPJ7~^::..::^~!?5B&:::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::#5!:  :~!?YY555YJ7~:  .~JB::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::P!  :7P#::::::::::::::#GJ^  ^Y&:::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::P^  7G::::::::::::::::::::::#J: .J&:::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::#!  ?#::::::::::::::::::::::::::&5: :P::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::G. ^B:::::&PJJ5#::::::::&PJJ5#:::::&7  J:::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::G. ~&:::::&~    .G::::::&^    .G::::::J  J::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::&^ :#::::::&:     P::::::#:     P:::::::!  G:::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::5  Y::::::::#Y7!?G::::::::#Y7!JB::::::::B. 7:::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::7  B::::::::::::::#BGGPGB#&::::::::::::::^ ^&::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::7  B::::::::::BY!:        .^7P&::::::::::^ :&::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::J  P::::::::G~  :!J5PPPPPY?~. .J&:::::::&: ~:::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::B. !:::::::J  ?B::::::::::::&P~ :G::::::5  Y:::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::J  Y:::::? ^#:::::::::::::::::5 .B::::B. ^&:::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::7  Y:::G ^&:::::::::::::::::::5 ~:::G: ^#::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::J  !B:BJB:::::::::::::::::::::55:&J  !#:::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::G~  7B::::::::::::::::::::::::&Y: :5:::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::P~  ~YB::::::::::::::::::#P!. :Y&::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::BJ^  :!YPB#&&&&&&#BGY7^  :7G:::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::#57~..  .......  .^!YB&:::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::&#BGP5YY5PPB#&::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0
                
EXIT_ART        
				DC.B ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':: ########: ##:::: ##:::: ###:::: ##::: ##: ##::: ##:: ######::::: ####:::::::'
				DC.B $0D,$0A
				DC.B '::... ##..:: ##:::: ##::: ## ##::: ###:: ##: ##:: ##:: ##... ##:::: ####:::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: ##:::: ##:: ##:. ##:: ####: ##: ##: ##::: ##:::..::::: ####:::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: #########: ##:::. ##: ## ## ##: #####::::. ######:::::: ##::::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: ##.... ##: #########: ##. ####: ##. ##::::..... ##:::::..:::::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: ##:::: ##: ##.... ##: ##:. ###: ##:. ##:: ##::: ##:::: ####:::::::'
				DC.B $0D,$0A
				DC.B '::::: ##:::: ##:::: ##: ##:::: ##: ##::. ##: ##::. ##:. ######::::: ####:::::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
				DC.B $0D,$0A
				DC.B ':::::..:::::..:::::..::..:::::..::..::::..::..::::..:::......::::::....::::::::'
				DC.B $0D,$0A
				DC.B '::: ######:::: #######::: #######:: ########:: ########:: ##::: ##: ########:::'
				DC.B $0D,$0A
				DC.B ':: ##... ##:: ##.... ##: ##.... ##: ##.... ##: ##.... ##:. ##: ##:: ##.....::::'
				DC.B $0D,$0A
				DC.B ':: ##:::..::: ##:::: ##: ##:::: ##: ##:::: ##: ##:::: ##::. ####::: ##:::::::::'
				DC.B $0D,$0A
				DC.B ':: ##:: ####: ##:::: ##: ##:::: ##: ##:::: ##: ########::::. ##:::: ######:::::'
				DC.B $0D,$0A
				DC.B ':: ##::: ##:: ##:::: ##: ##:::: ##: ##:::: ##: ##.... ##:::: ##:::: ##...::::::'
				DC.B $0D,$0A
				DC.B ':: ##::: ##:: ##:::: ##: ##:::: ##: ##:::: ##: ##:::: ##:::: ##:::: ##:::::::::'
				DC.B $0D,$0A
				DC.B '::. ######:::. #######::. #######:: ########:: ########::::: ##:::: ########:::'
				DC.B $0D,$0A
				DC.B ':::......:::::.......::::.......:::........:::........::::::..:::::........::::'
				DC.B $0D,$0A
				DC.B ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

*************
*END PROGRAM*
*************

    END    START        






















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
