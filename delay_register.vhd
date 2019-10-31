----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 11:00:31
-- Design Name: 
-- Module Name: delay_register - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity delay_register is
	port(
		CLK 		: 	in 		std_Logic 	;
		RESET 		: 	in 		std_logic 	;
		DATA_IN 	: 	in 		std_logic 	;
		DATA_OUT 	: 	out 	std_Logic
	);
end delay_register;


architecture Behavioral of delay_register is

	signal 	delay_reg : std_logic_vector ( 3 downto 0 ) := (others => '0');
    -- другие варианты описаний
	--signal 	delay_reg : std_logic_vector ( 3 downto 0 ) := "0000";
	--signal 	delay_reg : std_logic_vector ( 3 downto 0 ) := x"0";
	--signal 	delay_reg : std_logic_vector ( 3 downto 0 );

begin

	delay_reg_processing : process(CLK)
	begin
		if CLK'event AND CLK = '1' then
			if RESET = '1' then 
				delay_reg <= "0000";
			else
				delay_reg( 3 downto 0 ) <= delay_reg( 2 downto 0 ) & DATA_IN;
			end if;
		end if;
	end process;

	DATA_OUT <= delay_reg( 3 );

end Behavioral;
