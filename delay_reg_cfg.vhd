library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

-- parametrized configurable length of delay register


entity delay_reg_cfg is
    generic(
        DELAY : integer := 10
    );
    port(
        CLK         :   in      std_Logic                       ;
        DATA_IN     :   in      std_logic                       ;
        DATA_OUT    :   out     std_logic 
    );
end delay_reg_cfg;



architecture Behavioral of delay_reg_cfg is

    signal  delay_register : std_logic_vector ( DELAY-1 downto 0 ) := (others => '0');

begin

    delay_register_processing : process(CLK)
    begin
        if CLK'event AND  CLK = '1' then 
            delay_register( DELAY-1 downto 0 ) <= delay_register(DELAY-2 downto 0) & DATA_IN;
        end if;
    end process;

    DATA_OUT <= delay_register(DELAY-1);


end Behavioral;
