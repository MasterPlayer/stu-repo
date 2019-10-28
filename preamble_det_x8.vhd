library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity preamble_det_x8 is
    port(
        CLK : in std_logic ;
        DATA_IN : in std_logic ;
        DATA_OUT : out std_Logic ;
        DVO_OUT : out std_Logic 
    );
end preamble_det_x8;



architecture Behavioral of preamble_det_x8 is

    signal  delay_data_reg : std_logic_vector ( 7 downto 0 ) := (others => '0');
    constant C_PREAMBLE : std_logic_vector ( 7 downto 0 ) := "10101010";
    signal  dvo_out_reg : std_logic  := '0';

begin

    DVO_OUT <= dvo_out_reg;
    DATA_OUT <= delay_data_reg(7);
    delay_data_reg_processing : process(CLK)
    begin
        if cLK'event AND CLK = '1' then 
            delay_data_reg(7 downto 0 ) <= delay_data_reg(6 downto 0 ) & DATA_IN;
        end if;
    end process;


    dvo_out_reg_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if delay_data_reg = C_PREAMBLE then 
                dvo_out_reg <= '1';
            else
                dvo_out_reg <= '0';
            end if;
        end if;
    end  process;




end Behavioral;
