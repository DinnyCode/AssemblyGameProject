    ORG    $1000
START:
    BSR SETUP
    BSR WELCOME
    BSR GAME_LOOP

**********************
*MAIN GAME SUBROUTINES
**********************
SETUP:
    *DECLARE VARIABLES AND SETUP GAME
    LEA SETUP_MSG, A1
    
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    *DECLARING VARAIBLES
    
    *STARTING VARAIBLES
    MOVE.W #100, CARBON_AMOUNT          STARTING CARBON LEVEL
    MOVE.W #100, MONEY                  STARTING MONEY
    MOVE.W #0, TICK_COUNT               STARTING TICK

    *END GAME VARIABLES
    MOVE.W #200, TICK_DEADLINE          DEADLINE TO REDUCE CARBON

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
    MOVE.W #10, SOLAR_PANEL_REDUCTION    REDUCTION VALUE OF SOLAR PANELS
    
    *CALCUALTION VARIABLES
    MOVE.W #0, CARON_REDUCTION          RATE CARBON REDUCES BY
    MOVE.W #0, CARBON_INCREASE_RATE     RATE CARBON INCREASES 

    RTS

WELCOME:
    *WELCOMES USER AND INTRODUCES TO GAME
    
    LEA GAME_TITLE, A1                  TITLE SCREEN MESSAGE
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
       
    LEA WELCOME_MSG, A1                 INTRODUCTION TO GAME
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    RTS
    
GAME_LOOP:
    *MAIN GAME LOOP
    LEA GAME_LOOP_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    BSR GAME_STATE
    BSR INPUT
    
    BSR CHECK_STATS
    BSR CALCULATE_REDUCTION
    BSR UPDATE_CARBON
    BSR UPDATE_TICK
    
    BSR WIN_STATUS

GAME_STATE:
    *OUPUTS STATE OF GAME
    LEA GAME_STATE_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    RTS
    
INPUT:
    *PROMPTS USER FOR INPUT TO GO TO SHOP OR SKIP TURN
    LEA INPUT_MSG, A1
    BSR PRINT_MSG
    
    BSR INPUT_PROMPT
    
    CMP #1, D1
    BEQ SHOP
    
    RTS
        
SHOP:
    *ALLOWS USER TO BUY STRUCTURES
    BSR CLEAR_SCREEN
    
    LEA SHOP_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    LEA SHOP_INPUT_MSG, A1
    BSR PRINT_MSG
    
    BSR INPUT_PROMPT
    
    CMP #1, D1
    BEQ PLANT_TREE
    
    CMP #2, D1
    BEQ BUILD_WINDMILL
    
    CMP #3, D1
    BEQ BUILD_SOLAR_PANEL
    
    CMP #4, D1
    
    RTS
    
PLANT_TREE:
    *PLANTS TREE STRUCTURE
    BSR CLEAR_SCREEN
    
    LEA TREE_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    LEA PLANT_TREE_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    ADD #1, TREE_COUNT                         ADDING TO TREE COUNT
    
    BSR LOCATION
    
    RTS
    
BUILD_WINDMILL:
    *BUILDS WINDMILL STRUCTURE 
    BSR CLEAR_SCREEN
    
    LEA WINDMILL_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    LEA BUILD_WINDMILL_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    ADD #1,(WINDMILL_COUNT)
    
    BSR LOCATION
    
    RTS

BUILD_SOLAR_PANEL:
    *BUILDS SOLAR PANEL STRUCTURE    
    BSR CLEAR_SCREEN
    
    LEA SOLAR_PANEL_ART, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    LEA BUILD_SOLAR_PANEL_MSG, A1
    BSR PRINT_MSG
    BSR CLEAR_PROMPT
    
    ADD #1,(SOLAR_PANEL_COUNT)
    
    BSR LOCATION
    
    RTS
    
LOCATION:
    *ALLOWS USER TO CHOOSE WHERE TO BUILD STRUCTURE
    LEA LOCATION_MSG, A1
    BSR PRINT_MSG
        
    BSR CLEAR_PROMPT
    
    BSR UPDATE_INV
    
    RTS
    
UPDATE_INV:
    *UPDATES INVENTORY OF USER
    LEA UPDATE_INV_MSG, A1
    BSR PRINT_MSG
    
    
    *TREE COUNT OUTPUT
    LEA UPDATE_TREE_MSG, A1
    BSR PRINT_MSG_ALT
    
    LEA TREE_COUNT, A1
    BSR PRINT_NUM
    
    *WINDMILL COUNT OUTPUT
    
    *SOLAR PANEL COUNT OUTPUT
    
    BSR CLEAR_PROMPT
    
    RTS

CHECK_STATS:
    *CHECKS CURRENT STATS & VALUES OF GAME
    LEA CHECK_STATS_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    RTS

CALCULATE_REDUCTION:
    *CALCULATE CARBON REDUCTION AMOUNT
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
    
    *SOLAR PANEL REDUCTION
    
    *TOTAL REDUCTION
    
    BSR CLEAR_PROMPT
    
    RTS

UPDATE_CARBON:
    *UPDATES CARON AMOUNT
    
    *REDUCTION OF CARBON
    LEA CARBON_AMOUNT, A7
    MOVE.W (A7),D7

    SUB D6, D7
    
    *OUTPUT NEW CARBON AMOUNT
    LEA UPDATE_CARBON_MSG, A1
    BSR PRINT_MSG_ALT
    
    MOVE.W D7,D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA NEW_LINE, A1
    MOVE.B #13, D0
    TRAP #15
    
    BSR CLEAR_PROMPT
    
    RTS

UPDATE_TICK:
    *UPDATES TICK FOR TURN PASSED
    LEA UPDATE_TICK_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    RTS

WIN_STATUS
    *CHECKS IF WIN OR LOSS STATUS HAS BEEN MET
    LEA WIN_STATUS_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT

    *CHECK WIN STATUS(CMP RELEVANT VALS)
    
    *IF WIN CRITERIA MET
    *BRA VICTORY
    
    *IF LOSS CRITERIA MET*
    *BRA LOSS
    
    *OTHERWISE CHECK EVENT STATUS
    BSR EVENT_STATUS
    
EVENT_STATUS:
    LEA EVENT_STATUS_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    *IF COMPARISONS COME BACK TRUE, GO TO RELEVANT SR
    
    *ELSE
    BSR GAME_LOOP


*******************
*EVENT SUB ROUTINES
*******************
    
*************************
*END OF GAME SUB ROUTINES
*************************
    
VICTORY:
    *USER HAS WON GAME
    LEA VICTORY_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR FINAL_STATS

LOSS:
    *USER HAS LOST GAME
    LEA LOSS_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR FINAL_STATS

FINAL_STATS:
    *OUTPUTS FINAL STATS OF USER
    LEA FINAL_STATS_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR REPLAY
    
REPLAY: 
    *PROMPTS USER TO REPLAY OR EXIT GAME
    LEA REPLAY_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
    
    BSR INPUT_PROMPT
    
    CMP #1, D1
    BEQ START
    
    BSR EXIT
    
********************
*FORMATTING AND
*OUTPUT SUB ROUTINES
********************
INPUT_PROMPT:
    LEA INPUT_SYMBOL, A1
    MOVE.L #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    RTS

CLEAR_SCREEN:
    MOVE #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    
    MOVE.W #0, D1
    
    RTS

CLEAR_PROMPT:
    *SR TO CLEAR SCREEN
    
    LEA CONTINUE_MSG,A1
    MOVE.B #13,D0
    TRAP #15

    MOVE.B #5, D0
    TRAP #15


    MOVE #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    
    MOVE.W #0, D1
    
    RTS
    
PRINT_MSG:
    MOVE.B #13, D0
    TRAP #15
    
    RTS
    
PRINT_MSG_ALT:
    MOVE.B #14, D0
    TRAP #15
    
    RTS
    
PRINT_NUM:
    MOVE.W (A1),D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA NEW_LINE, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS
        
INVALID_OPTION:
    *INVALID OPTION HAS BEEN ENTERED
    LEA INVALID_OPTION_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    *COMPARES VALUE IN CERTAIN REGISTER TO DETERMINE WHICH SUB ROUTINE TO RETURN TO 
        
TEST:
    *SUB ROUTINE FOR TESTING
    LEA TEST_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS

***************
*END OF PROGRAM
***************
EXIT:
    *EXITS GAME
    LEA EXIT_MSG, A1
    BSR PRINT_MSG
    
    BSR CLEAR_PROMPT
                    
    SIMHALT   
        
******************
*PROGRAM VARIABLES
******************
    
****************
*OUTPUT MESSAGES
****************

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

WINDMILL_ART DC.B 'TODO: WINDMILL ASCII ART',0

SOLAR_PANEL_ART DC.B 'TODO: SOLAR_PANEL ASCII ART',0

*WELCOME MESSAGES

SETUP_MSG DC.B 'Setting up game....',0

WELCOME_MSG DC.B 'TODO: WELCOME',0

*GAME LOOP MESSAGES

GAME_STATE_MSG DC.B 'TODO: GAME_STATE',0

INPUT_MSG DC.B 'Do you wish to go to the shop? (1 or 0)',0  

GAME_LOOP_MSG DC.B 'TODO: GAME_LOOP',0

CHECK_STATS_MSG DC.B 'TODO: CHECK_STATS',0

CALCULATE_REDUCTION_MSG DC.B 'Calculating Carbon Reduction',0

UPDATE_CARBON_MSG DC.B 'Current Carbon Count: ',0

UPDATE_TICK_MSG DC.B 'TODO: UPDATE_TICK',0

*SHOP MESSAGES

SHOP_INPUT_MSG DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'
               DC.B $0D,$0A
               DC.B '::: Welcome to the shop! What would you like to purchase? ::'
               DC.B $0D,$0A
               DC.B ':: 1 - Tree : 2 - Windmill : 3 - Solar Panel : 4 - Cancel ::'
               DC.B $0D,$0A
               DC.B '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',0

PLANT_TREE_MSG DC.B 'Tree has been planted!',0

BUILD_WINDMILL_MSG DC.B 'TODO: BUILD_WINDMILL',0

BUILD_SOLAR_PANEL_MSG DC.B 'TODO: BUILD_SOLAR_PANEL',0

LOCATION_MSG DC.B 'TODO: LOCATION',0

UPDATE_INV_MSG DC.B 'Inventory Count:',0

UPDATE_TREE_MSG DC.B 'Total Trees: ',0

*CHECK STATE MESSAGES

WIN_STATUS_MSG DC.B 'TODO: WIN_STATUS',0

EVENT_STATUS_MSG DC.B 'TODO: EVENT STATUS',0

*WIN/LOSS MESSAGES

VICTORY_MSG DC.B 'TODO: VICTORY',0

LOSS_MSG DC.B 'TODO: LOSS',0

*END GAME MESSAGES

FINAL_STATS_MSG DC.B 'TODO: FINAL_STATS',0

EXIT_MSG DC.B 'TODO: EXIT',0

REPLAY_MSG DC.B 'TODO: REPLAY',0

*FORMATTING MESSAGES

CONTINUE_MSG DC.B 'Press enter to continue: ',0

INVALID_OPTION_MSG DC.B 'TODO: INVALID_OPTION',0

TEST_MSG DC.B 'TEST STUFF',0

INPUT_SYMBOL DC.B '>> ',0

NEW_LINE DC.B $0D,$0A,0

****************
* GAME VARIABLES
****************

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

*OTHER VARIABLES


************
*END PROGRAM
************

    END    START        













*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
