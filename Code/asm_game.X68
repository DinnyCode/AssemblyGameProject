
    ORG    $1000
START:
    BSR SETUP
    BSR WELCOME
    BRA GAME_LOOP


SETUP:
    *DECLARE VARIABLES
    RTS

WELCOME:
    LEA WELCOME, A1
    MOVE.B #14, D0
    TRAP #15
    RTS

INPUT:
    LEA INPUT, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #4, D0
    TRAP #15
    
    CMP #1, D1
    BEQ SHOP

OUTPUT_GAME_STATE:

GAME_LOOP:


SHOP:
    LEA SHOP, A1
    MOVE.B #14, D0
    TRAP #15
                 
    SIMHALT   


WELCOME DC.B 'TODO: WELCOME',0
GAME_STATE DC.B 'TODO: GAME_STATE',0
INPUT DC.B 'TODO: INPUT',0  
SHOP DC.B 'TODO: SHOP', 0       
    END    START        
*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
