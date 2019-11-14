library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

entity cmd_processor_x8 is
    port(
        CLK         :   in      std_logic               ;
        DATA_IN     :   in      std_logic               ;
        START       :   in      std_logic               ;
        HAS_CMD     :   out     std_Logic                
    );
end cmd_processor_x8;


architecture cmd_processor_x8_arch of cmd_processor_x8 is

    type fsm is(
        IDLE_ST         ,
        SHIFT_CMD_ST    ,
        FINALIZE_ST 
    );

    constant C_COMMAND : std_logic_Vector ( 7 downto 0 ) := "01100110";

    signal  current_state : fsm := IDLE_ST;

    constant cmd_len : integer := 8; -- длина команды = 8

    signal  word_cnt : std_logic_Vector ( 2 downto 0 ) := (others => '0'); 

    signal  has_cmd_reg : std_logic := '0';

    signal  shift_reg : std_logic_vector ( 7 downto 0 ) := (others => '0');

begin

    HAS_CMD <= has_cmd_reg;

    current_state_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case current_state is

                when IDLE_ST =>
                    if START = '1' then 
                        current_state <= SHIFT_CMD_ST;
                    else
                        current_state <= current_state;
                    end if;

                when SHIFT_CMD_ST =>
                    if word_cnt = (cmd_len-1) then 
                        current_state <= FINALIZE_ST ;
                    else
                        current_state <= current_state;
                    end if;

                when FINALIZE_ST =>
                    current_state <= IDLE_ST;

            end case;
        end if;
    end process;


    word_cnt_processing : process(CLK)
    begin
        if CLK'event aND CLK = '1' then 
            case current_state is
                when SHIFT_CMD_ST => 
                    word_cnt <= word_cnt + 1;

                when others =>
                    word_cnt <= (others => '0');

            end case;
        end if;
    end process;

    has_cmd_reg_processing : process(CLK)
    begin
        if CLK'event aND CLK = '1' then 
            case current_state is 
                when FINALIZE_ST =>
                    if shift_reg = C_COMMAND then 
                        has_cmd_reg <= '1';
                    else
                        has_cmd_reg <= '0';
                    end if;

                when others => 
                    has_cmd_reg <= '0';
            end case ;
        end if;
    end process;

    shift_reg_processing : process(CLK)
    begin
        if cLK'event AND CLK = '1' then 
            shift_reg <= shift_reg(6 downto 0 ) & DATA_IN;
        end if;
    end process;

end cmd_processor_x8_arch;
