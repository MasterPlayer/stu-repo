library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_arith.all;


entity tb_delay_register is
end tb_delay_register;



architecture Behavioral of tb_delay_register is



	component delay_register
		port(
			CLK : in std_Logic;
			RESET : in std_logic ;
			DATA_IN : in std_logic;
			DATA_OUT : out std_Logic
		);
	end component;


	signal 	CLK :  std_Logic := '0' ;
	signal 	RESET :  std_logic := '1'  ;
	signal 	DATA_IN :  std_logic := '0' ;
	signal 	DATA_OUT :  std_Logic ;

	constant clk_period : time := 10 ns;

	signal 	i : integer := 0;

begin

	CLK <= not(CLK) after clk_period/2;

	i_process : process(CLK)
	begin
		if rising_edge(CLK) then
			i <= i + 1;
		end if;
	end process;



	delay_register_inst : delay_register
		port map(
			CLK => CLK ,
			RESET => RESET ,
			DATA_IN => DATA_IN ,
			DATA_OUT => DATA_OUT  
		);


	RESET_PROCESSING : PROCESS(clk)
	begin
		if CLK'event AND CLK = '1' then 
			if i < 100 then 
				reset <= '1';
			else
				reset <= '0';
			end if;
		end if;
	END PROCESS;	

	data_in_processing : process(CLK)
	begin
		if CLK'event aND CLK = '1' then 
			if i = 200 then 
				DATA_IN <= '1';
			elsif i = 201 then 
				DATA_IN <= '0';
			elsif i = 202 then 
				DATA_IN <= '1';
			else 
				DATA_IN <= '0';
			end if;
		end if;
	end process;



end Behavioral;
