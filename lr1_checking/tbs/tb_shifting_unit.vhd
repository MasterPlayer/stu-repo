
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


    use ieee.std_logic_textio.all;
    use std.textio.all;


library UNISIM;
    use UNISIM.VComponents.all;

entity tb_shifting_unit is
end tb_shifting_unit;

architecture Behavioral of tb_shifting_unit is
    

    -- ����������� ���������� ������� �� ������� �����.
    component shifting_unit
        port(
            CLK                 : in std_logic;
            -- ���� ������
            DATA_INPUT          : in std_logic_vector ( 15 downto 0 );
            -- ���� ������: ������ ����������
            DATA_INPUT_VALID    : in std_logic ;
            -- ����� ������ : 
            DATA_OUTPUT         : out std_logic_vector ( 15 downto 0 );
            -- ������ ���������� �������� ������
            DATA_OUTPUT_VALID   : out std_logic 
        );
    end component;

    -- ���������� ������, ������� ����� �������� ������ �� ���� ����������. 
    -- ��� ��� ��������� ���� �����, ������ ���������� ��������� ���������(������ ��� ����)
    signal  CLK                 :   std_logic                          := '0'              ;
    signal  DATA_INPUT          :   std_logic_vector ( 15 downto 0 )   := (others => '0')  ;
    signal  DATA_INPUT_VALID    :   std_logic                          := '0'              ;
    signal  DATA_OUTPUT         :   std_logic_vector ( 15 downto 0 )                      ;
    signal  DATA_OUTPUT_VALID   :   std_logic                                             ;

    constant CLK_PERIOD : time := 10 ns;

    signal  i : integer := 0;

    constant C_FILE_NAME        :           string  := "D:/ads_src.txt";
    file fptr                   :           text                                        ;

begin

    CLK <= not CLK after CLK_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    shifting_unit_inst : shifting_unit
        port map (
            CLK                 =>  CLK                         ,
            -- ���� ������
            DATA_INPUT          =>  DATA_INPUT                  ,
            -- ���� ������: ������ ����������
            DATA_INPUT_VALID    =>  DATA_INPUT_VALID            ,
            -- ����� ������ : 
            DATA_OUTPUT         =>  DATA_OUTPUT                 ,
            -- ������ ���������� �������� ������
            DATA_OUTPUT_VALID   =>  DATA_OUTPUT_VALID            
        );

        -- ��� �������� ��� ������ ������� �������� �� �������� 
        -- ����� ������� ��������� ��������� �� ��������
        -- ������ ������ ���������� 
--    input_data_processing : process(CLK)
--    begin
--        if CLK'event AND CLK = '1' then 
--            if i = 1000 then 
--                DATA_INPUT <= conv_std_logic_vector (32767, DATA_INPUT'length); DATA_INPUT_VALID <= '1';
----            elsif i = 1001 then 
----                DATA_INPUT <= conv_std_logic_vector (10000, DATA_INPUT'length); DATA_INPUT_VALID <= '1';

--            else
--                DATA_INPUT <= (others => '0'); DATA_INPUT_VALID <= '0';                
--            end if;
--        end if;
--    end process;

    -- ����� ������� ������ ������ �� �����. � ���� � ��������� ��� �������� �����������
    data_read_processing : process
        variable fstatus    : file_open_status;
        variable file_line  : line ;
        variable var_data : integer;
    begin
            DATA_INPUT_VALID <= '0';
            wait for 1000 ns; 
            file_open(fstatus, fptr, C_FILE_NAME, read_mode);
            while(not endfile(fptr)) loop
                wait until CLK = '1';
                readline(fptr, file_line);
                read(file_line, var_data);
                DATA_INPUT <= conv_std_logic_vector(var_data, 16);
                DATA_INPUT_VALID <= '1';
            end loop ;
    end process;



    -- ����� ������� ������ ������ � ����
    write_process : process(CLK)
        file test_vector      : text open write_mode is "D:/xilinx_dst.txt";
        variable row          : line;
    begin
        if CLK'event AND CLK = '1' then
            if DATA_OUTPUT_VALID = '1' then
                write(row, conv_integer(SXT(DATA_OUTPUT, 32)), left, 0);
                writeline(test_vector, row);    
            end if;
        end if;
    end process;



end Behavioral;
