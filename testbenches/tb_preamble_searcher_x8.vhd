----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2019 11:11:55
-- Design Name: 
-- Module Name: tb_preamble_searcher_x8 - Behavioral
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
    use ieee.std_Logic_unsigned.all;
    use ieee.std_Logic_arith.all;


entity tb_preamble_searcher_x8 is
end tb_preamble_searcher_x8;

architecture Behavioral of tb_preamble_searcher_x8 is



    component preamble_det_x8 is
        port(
            CLK         :   in      std_logic   ;
            DATA_IN     :   in      std_logic   ;
            DATA_OUT    :   out     std_Logic   ;
            DVO_OUT     :   out     std_Logic   
        );
    end component;

    signal  CLK         :           std_logic  := '0' ;
    signal  DATA_IN     :           std_logic  := '0' ;
    signal  DATA_OUT    :           std_Logic   ;
    signal  DVO_OUT     :           std_Logic           ;


    component preamble_det_x8_long
        port (
            CLK         :   in      std_logic                           ;
            DATA_IN     :   in      std_logic                           ;
            --DATA_OUT    :   out     std_Logic                           ;
            DVO_OUT     :   out     std_Logic                           
        );
    end component;

    --signal  LONG_data_out    :          std_Logic                       ;
    signal  LONG_dvo_out     :          std_Logic                       ;

    component delay_reg_cfg
        generic(
            DELAY : integer := 10
        );
        port(
            CLK         :   in      std_Logic                       ;
            DATA_IN     :   in      std_logic                       ;
            DATA_OUT    :   out     std_logic 
        );
    end component;

    signal  UNPREAMBLED_DATA_OUT :           std_logic                       ;


    constant clk_period : time := 10 ns;

    signal i : integer := 0;

begin

    cLK <= not CLK after clk_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;


    preamble_det_x8_inst : preamble_det_x8
        port map (
            CLK         =>  CLK             ,
            DATA_IN     =>  DATA_IN         ,
            DATA_OUT    =>  DATA_OUT        ,
            DVO_OUT     =>  DVO_OUT          
        );


    data_in_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case i is 
                when 100 => DATA_IN <= '0';
                when 101 => DATA_IN <= '0';
                when 102 => DATA_IN <= '0';
                when 103 => DATA_IN <= '0';
                when 104 => DATA_IN <= '1'; --preamble
                when 105 => DATA_IN <= '0';--preamble
                when 106 => DATA_IN <= '1';--preamble
                when 107 => DATA_IN <= '0';--preamble
                when 108 => DATA_IN <= '1';--preamble
                when 109 => DATA_IN <= '0';--preamble
                when 110 => DATA_IN <= '1';--preamble
                when 111 => DATA_IN <= '0';--preamble

                when 112 => DATA_IN <= '1'; --sync word 
                when 113 => DATA_IN <= '1'; --sync word 
                when 114 => DATA_IN <= '0'; --sync word 
                when 115 => DATA_IN <= '0'; --sync word 
                when 116 => DATA_IN <= '1'; --sync word 
                when 117 => DATA_IN <= '1'; --sync word 
                when 118 => DATA_IN <= '0'; --sync word 
                when 119 => DATA_IN <= '0'; --sync word 

                when 120 => DATA_IN <= '0'; --code
                when 121 => DATA_IN <= '1'; --code
                when 122 => DATA_IN <= '1'; --code
                when 123 => DATA_IN <= '0'; --code
                when 124 => DATA_IN <= '1'; --code
                when 125 => DATA_IN <= '1'; --code
                when 126 => DATA_IN <= '1'; --code
                when 127 => DATA_IN <= '0'; --code
                
                when others =>  DATA_IN <= '0'; -- <= data_in;
            end case;
        end if;
    end process;

    --детектор преамбулы не содержит в своем составе выходного сигнала данных, так как дальше по тракту нам не нужна преамбула
    --, поэтому для данного случая сигнал DATA_OUT закомментирован
    -- здесь все что нам нужно - это задержать значение на столько, чтобы отрезать преамбулу и оставить 
    --оставшуюся часть данных для передачи ее на другой модуль для дальнейшего разбора 

    preamble_det_x8_long_inst : preamble_det_x8_long
        port map (
            CLK         =>  CLK                     ,
            DATA_IN     =>  DATA_IN                 ,
--            DATA_OUT    =>  LONG_DATA_OUT           ,
            DVO_OUT     =>  LONG_DVO_OUT             
        );

    delay_reg_cfg_inst : delay_reg_cfg
        generic map (
            DELAY =>  2
        )
        port map (
            CLK         =>  CLK                     ,
            DATA_IN     =>  DATA_IN                 ,
            DATA_OUT    =>  UNPREAMBLED_DATA_OUT
        );


end Behavioral;
