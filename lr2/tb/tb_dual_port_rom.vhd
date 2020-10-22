----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.10.2020 12:04:21
-- Design Name: 
-- Module Name: tb_dual_port_rom - Behavioral
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
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;


    use ieee.std_logic_textio.all;
    use std.textio.all;


entity tb_dual_port_rom is
end tb_dual_port_rom;



architecture Behavioral of tb_dual_port_rom is

    component dual_port_rom
        port(
            CLK     :   in      std_logic                                       ;
            RESET   :   in      std_logic                                       ;
            PHASE   :   in      std_logic_vector (  2 downto 0 )                ;
            SINE    :   out     std_logic_Vector ( 15 downto 0 ) 
        );
    end component;

    signal  CLK     :           std_logic                           := '0'              ;
    signal  RESET   :           std_logic                           := '0'              ;
    signal  PHASE   :           std_logic_vector (  2 downto 0 )    := (others => '0')  ;
    signal  SINE    :           std_logic_Vector ( 15 downto 0 )                        ;

    signal i : integer := 0;


begin
    
    CLK <= not CLK after 10 ns;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    RESET_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if i < 10 then 
                RESET <= '1';
            else
                RESET <= '0';
            end if;
        end if;
    end process;

    PHASE_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if RESET = '1' then 
                PHASE <= (others => '0') ;
            else
                PHASE <= PHASE + 1;
            end if;
        end if;
    end process;

    dual_port_rom_inst : dual_port_rom
        port map (
            CLK     =>  CLK                                                             ,
            RESET   =>  RESET                                                           ,
            PHASE   =>  PHASE                                                           ,
            SINE    =>  SINE                                                             
        );

    write_process : process(CLK)
        file test_vector      : text open write_mode is "D:/xilinx_dst.txt";
        variable row          : line;
    begin
        if CLK'event AND CLK = '1' then
            if RESET = '0' then
                write(row, conv_integer(SXT(SINE, 32)), left, 0);
                writeline(test_vector, row);    
            end if;
        end if;
    end process;


end Behavioral;
