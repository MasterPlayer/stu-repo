library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

entity sync_seq_det_x8 is
    port(   
        CLK         :   in      std_Logic                       ;
        DATA_IN     :   in      std_logic                       ;
        START       :   in      std_logic                       ;
        DVO         :   out     std_Logic                       
    );
end sync_seq_det_x8;



architecture Behavioral of sync_seq_det_x8 is

    type fsm is(
        IDLE_ST             ,
        SEARCH_SYNC_SEQ_ST  ,
        FINALIZE_ST          
    );

    signal  current_state : fsm := IDLE_ST;

    signal  word_cnt            :       std_logic_vector ( 2 downto 0 ) := (others => '0')  ;
    signal  shift_register      :       std_logic_vector ( 7 downto 0 ) := (others => '0')  ;
    constant C_SYNCWORD         :       std_logic_vector ( 7 downto 0 ) := "11001100"      ;
    signal  dvo_reg             :       std_Logic                       := '0'              ;

begin   
        
    DVO <= dvo_reg;

    dvo_reg_processing : process(CLK)
    begin
        if cLK'event AND CLK = '1' then 
            case current_state is 
                when FINALIZE_ST =>
                    if shift_register = C_SYNCWORD then 
                        dvo_reg <= '1';
                    else
                        dvo_reg <= '0';
                    end if;
                
                when others =>
                    dvo_reg <= '0';

            end case;
        end if;
    end process;

    shift_register_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            shift_register <= shift_register( 6 downto 0 ) & DATA_IN;
        end if;
    end process;

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
                    if START = '1' then 
                        current_state <= SEARCH_SYNC_SEQ_ST;
                    else
                        current_state <= current_state;
                    end if;

                when SEARCH_SYNC_SEQ_ST =>
                    if word_cnt = 7 then 
                        current_state <= FINALIZE_ST;
                    else
                        current_state <= current_state;
                    end if;

                when FINALIZE_ST =>
                    current_state <= IDLE_ST;

                when others =>
                    current_state <= current_state;
            end case;
        end if;
    end process;


end Behavioral;
