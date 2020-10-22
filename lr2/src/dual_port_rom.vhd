library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.ALL;
    use ieee.std_logic_arith.all;

Library xpm;
    use xpm.vcomponents.all;

library UNISIM;
    use UNISIM.VComponents.all;

entity dual_port_rom is
    port(
        CLK     :   in      std_logic                                       ;
        RESET   :   in      std_logic                                       ;
        PHASE   :   in      std_logic_vector (  2 downto 0 )                ;
        SINE    :   out     std_logic_Vector ( 15 downto 0 ) 
    );
end dual_port_rom;



architecture Behavioral of dual_port_rom is

        

    type ROM is array(0 to 7) of std_logic_vector(15 downto 0);
    -- параметризация памяти. 
    -- К сожалению только hexadecimal 
    signal sin_table : ROM :=(
        x"0000", x"5a93",
        x"7ffe", x"5a4c",
        x"ff9b", x"a525",
        x"8001", x"a5fb"
    );

    --type ROM is array(0 to 7) of integer;
    ------ параметризация памяти. 
    ------ можно задавать через десятичную систему.  
    --signal sin_table : ROM :=(
    --    0,1,2,3,4,5,6,7
    --);


    signal  sine_reg : std_logic_Vector ( 15 downto 0 ) := (others => '0');


begin

    --SINE <= conv_std_logic_Vector ( sin_table(conv_integer(unsigned(PHASE))), 16);
    SINE <= sine_reg;


    sine_reg_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            sine_reg <= sin_table(conv_integer(unsigned(PHASE)));
        end if;
    end process;

end Behavioral;
