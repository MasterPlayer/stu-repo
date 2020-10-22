
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

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
    input_data_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if i = 1000 then 
                DATA_INPUT <= conv_std_logic_vector (32767, DATA_INPUT'length); DATA_INPUT_VALID <= '1';
--            elsif i = 1001 then 
--                DATA_INPUT <= conv_std_logic_vector (10000, DATA_INPUT'length); DATA_INPUT_VALID <= '1';

            else
                DATA_INPUT <= (others => '0'); DATA_INPUT_VALID <= '0';                
            end if;
        end if;
    end process;




end Behavioral;
