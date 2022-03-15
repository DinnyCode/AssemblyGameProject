    ORG    $1000
START:
    BSR TEST
    BSR SETUP
    BSR WELCOME
    BRA GAME_LOOP

SETUP:
    *DECLARE VARIABLES AND SETUP GAME
    LEA SETUP_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    *DECLARING VARAIBLES
    
    *STARTING VARAIBLES
    MOVE.B #100, CARBON_AMOUNT          STARTING CARBON LEVEL
    MOVE.B #100, MONEY                  STARTING MONEY
    MOVE.B #0, TICK_COUNT               STARTING TICK

    *END GAME VARIABLES
    MOVE.B #200, TICK_DEADLINE          DEADLINE TO REDUCE CARBON

    *STRUCTURE STARTING COUNTS
    MOVE.B #0, TREE_COUNT               TOTAL NO. TREES
    MOVE.B #0, WINDMILL_COUNT           TOTAL NO. WINDMILLS
    MOVE.B #0, SOLAR_PANEL_COUNT        TOTAL NO. SOLAR PANELS
    
    *STRUCTURE COSTS
    MOVE.B #2, TREE_COST                COST OF TREE
    MOVE.B #5, WINDMILL_COST            COST OF WINDMILLS
    MOVE.B #10, SOLAR_PANEL_COST        COST OF SOLAR PANEL
    
    *REDUCTION VARIABLES
    MOVE.B #0, TREE_REDUCTION           REDUCTION VALUE OF TREES
    MOVE.B #0, WINDMILL_REDUCTION       REDUCTION VALUE OF WINDMILLS
    MOVE.B #0, SOLAR_PANEL_REDUCTION    REDUCTION VALUE OF SOLAR PANELS
    
    *CALCUALTION VARIABLES
    MOVE.B #0, CARON_REDUCTION          RATE CARBON REDUCES BY
    MOVE.B #0, CARBON_INCREASE_RATE     RATE CARBON INCREASES 

    RTS

WELCOME:
    *WELCOMES USER AND INTRODUCES TO GAME
    LEA GAME_TITLE, A1
    MOVE.B #13, D0
    TRAP #15
       
    LEA WELCOME_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS
    
GAME_LOOP:
    *MAIN GAME LOOP
    LEA GAME_LOOP_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BSR GAME_STATE
    BSR INPUT
    
    BSR CHECK_STATS
    BSR CALCULATE_REDUCTION
    BSR UPDATE_CARBON
    BSR UPDATE_TICK
    
    BRA WIN_STATUS

GAME_STATE:
    *OUPUTS STATE OF GAME
    LEA GAME_STATE_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS
    
INPUT:
    *PROMPTS USER FOR INPUT TO GO TO SHOP OR SKIP TURN
    LEA INPUT_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    CMP #1, D1
    BEQ SHOP
    
    RTS
        
SHOP:
    *ALLOWS UER TO BUY STRUCTURES
    LEA SHOP_INPUT_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
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
    LEA PLANT_TREE_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    ADD #1, D5 
    BSR LOCATION
    
BUILD_WINDMILL:
    *BUILDS WINDMILL STRUCTURE 
    LEA BUILD_WINDMILL_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BSR LOCATION

BUILD_SOLAR_PANEL:
    *BUILDS SOLAR PANEL STRUCTURE
    LEA BUILD_SOLAR_PANEL_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BSR LOCATION
    
LOCATION:
    *ALLOWS USER TO CHOOSE WHERE TO BUILD STRUCTURE
    LEA LOCATION_MSG, A1
    MOVE.B #13, D0
    TRAP #15
        
    BRA UPDATE_INV
    
UPDATE_INV:
    *UPDATES INVENTORY OF USER
    LEA UPDATE_INV_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    LEA UPDATE_TREE_MSG, A1
    MOVE.B #14, D0
    TRAP #15
    
    *trap 6 or 3
    MOVE.B D5, D1
    MOVE.B #3, D0
    TRAP #15
    
    MOVE.B D1, D5
    
    RTS


CHECK_STATS:
    *CHECKS CURRENT STATS & VALUES OF GAME
    LEA CHECK_STATS_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS

CALCULATE_REDUCTION:
    *CALCULATE CARBON REDUCTION AMOUNT
    LEA CALCULATE_REDUCTION_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS

UPDATE_CARBON:
    *UPDATES CARON AMOUNT
    LEA UPDATE_CARBON_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS

UPDATE_TICK:
    *UPDATES TICK FOR TURN PASSED
    LEA UPDATE_TICK_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    RTS

WIN_STATUS
    *CHECKS IF WIN OR LOSS STATUS HAS BEEN MET
    LEA WIN_STATUS_MSG, A1
    MOVE.B #13, D0
    TRAP #15

    *CHECK WIN STATUS(CMP RELEVANT VALS)
    
    *IF WIN CRITERIA MET
    *BRA VICTORY
    
    *IF LOSS CRITERIA MET*
    *BRA LOSS
    
    *OTHERWISE CHECK EVENT STATUS
    BSR EVENT_STATUS
    
EVENT_STATUS:
    LEA EVENT_STATUS_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    *IF COMPARISONS COME BACK TRUE, GO TO RELEVANT SR
    
    *ELSE
    BRA GAME_LOOP


*******************
*EVENT SUB ROUTINES
*******************
    
*************************
*END OF GAME SUB ROUTINES
*************************
    
VICTORY:
    *USER HAS WON GAME
    LEA VICTORY_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BRA FINAL_STATS

LOSS:
    *USER HAS LOST GAME
    LEA LOSS_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BRA FINAL_STATS

FINAL_STATS:
    *OUTPUTS FINAL STATS OF USER
    LEA FINAL_STATS_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    BRA REPLAY
    
REPLAY: 
    *PROMPTS USER TO REPLAY OR EXIT GAME
    LEA REPLAY_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    CMP #1, D1
    BEQ START
    
    BRA EXIT
    
********************
*FORMATTING AND
*OUTPUT SUB ROUTINES
********************
INVALID_OPTION:
    *INVALID OPTION HAS BEEN ENTERED
    LEA INVALID_OPTION_MSG, A1
    MOVE.B #13, D0
    TRAP #15
    
    *COMPARES VALUE IN CERTAIN REGISTER TO DETERMINE WHICH SUB ROUTINE TO RETURN TO 

CLEAR_SCREEN:
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
    MOVE.B #13, D0
    TRAP #15
                    
    SIMHALT   
        
******************
*PROGRAM VARIABLES
******************
    
****************
*OUTPUT MESSAGES
****************
    
CRLF DC.B $0D,$0A,0

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

SETUP_MSG DC.B 'TODO: SETUP',0

WELCOME_MSG DC.B 'TODO: WELCOME',0

*GAME LOOP MESSAGES

GAME_STATE_MSG DC.B 'TODO: GAME_STATE',0

INPUT_MSG DC.B 'Do you wish to go to the shop? (1 or 0)',0  

GAME_LOOP_MSG DC.B 'TODO: GAME_LOOP',0

CHECK_STATS_MSG DC.B 'TODO: CHECK_STATS',0

CALCULATE_REDUCTION_MSG DC.B 'TODO: CALCULATE_REDUCTION',0

UPDATE_CARBON_MSG DC.B 'TODO: UPDATE_CARBON',0

UPDATE_TICK_MSG DC.B 'TODO: UPDATE_TICK',0

*SHOP MESSAGES

SHOP_INPUT_MSG DC.B 'Welcome to the shop! What would you like to purchase?'
               DC.B $0D,$0A
               DC.B '| 1 - Tree | 2 - Windmill | 3 - Solar Panel |',0

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

TEST_MSG DC.B 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ12',0

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
