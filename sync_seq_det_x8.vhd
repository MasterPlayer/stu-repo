
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;


entity sync_seq_det_x8 is
    port(   
        CLK :in std_Logic ;
        DATA_IN : in std_logic ;
        DVI : in std_logic ;
        DVO : out std_Logic 
    );
end sync_seq_det_x8;



architecture Behavioral of sync_seq_det_x8 is

    type fsm is(
        IDLE_ST,
        SEARCH_SYNC_SEQ_ST,
        FINALIZE_ST 
    );

    signal  current_state : fsm := IDLE_ST;

    signal  word_cnt : std_logic_vector ( 2 downto 0 ) := (others => '0');
    
begin


    word_cnt_processing : process(CLK)
    begin
        if cLK'event AND CLK = '1' then 
            case current_state is
                when SEARCH_SYNC_SEQ_ST =>
                    word_cnt <= word_cnt + 1;
                
                when others =>
                    word_cnt <= (others => '0');
                    
            end case;
        end if;
    end process;


    current_state_processing : process(CLK)
    begin
        if cLK'event AND CLK = '1' then 
            case current_state is
                when IDLE_ST =>
                    if DVI = '1' then 
                        current_state <= SEARCH_SYNC_SEQ_ST;
                    else
                        current_state <= current_state;
                    end if;

                when SEARCH_SYNC_SEQ_ST =>
                    current_state <= current_state;

                when FINALIZE_ST =>
                    current_state <= current_state;
                when others =>
                    current_state <= current_state;
            end case;
        end if;
    end process;


end Behavioral;
