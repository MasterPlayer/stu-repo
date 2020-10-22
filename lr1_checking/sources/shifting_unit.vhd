library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;
    
library UNISIM;
    use UNISIM.VComponents.all;

entity shifting_unit is
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
end shifting_unit;



architecture Behavioral of shifting_unit is
    
    -- ������� ��� ���������� �������� ������. �� ��������� ������ �� �� ����������� �������.
    -- ������ ������: shreg_X, ��� X - �������� �� ������� ����� �������� ������
    signal  shreg4      : std_logic_vector ( 15 downto 0 );
    signal  shreg5      : std_logic_vector ( 15 downto 0 );
    signal  shreg8      : std_logic_vector ( 15 downto 0 );
    signal  shreg9      : std_logic_vector ( 15 downto 0 );
    signal  shreg11     : std_logic_vector ( 15 downto 0 );
    signal  shreg14     : std_logic_vector ( 15 downto 0 );
    
    -- �������� ����� ����������� �������. 
    -- ��� ����� ������ ����� �������, 
    -- ������� ����� ������������ �� ���� ��������-�������
    -- �������� ����� ����������� ��� ���������� �������.
    -- ������ ������ ����� �������� ��� 
    -- sumXY : ��� X � Y - ������ �������� ������ ������� �����������
    -- ����� ���� ����� ���-�� ��������������� � ������� �����. 
    -- ������ ���� 
    signal  sum45      : std_logic_vector ( 15 downto 0 ):=  (others => '0');
    signal  sum89      : std_logic_vector ( 15 downto 0 ) := (others => '0');
    signal  sum1114    : std_logic_vector ( 15 downto 0 ) := (others => '0');
    signal  delayed_shreg14 : std_logic_vector ( 15 downto 0 ) := (others => '0');
    -- ������ ����:
    signal  sum45_89 : std_logic_vector ( 15 downto 0 ) := (others => '0');
    signal  sum1114_14 : std_logic_vector ( 15 downto 0 ) := (others => '0');
    -- ������ ����
    signal  result : std_logic_vector ( 15 downto 0 ) := (others => '0');
    
    
    -- �������� ������� ������� DVI ��� ���� ����� ��������� ��� �� ����� DVO
    signal  dvi_delay : std_logic_Vector ( 2 downto 0 ) := (others => '0');
begin

    -- ���������� �������� �� �����
    DATA_OUTPUT <= result;
    DATA_OUTPUT_VALID <= dvi_delay(2);
    

    --���������� ������� �������� ������� DATA_INPUT:
    -- ������ ������� �� ���� ������ ����������, ��� ��� ��� ������� ���������������� ����� �� �������� �������
    -- ��� �� ������� ���������� LUT, FF
    -- ����� ��������� ���������������. 
    -- ������� SXT - ������ ��������� ����������� � ������ ��������� ����, ��� �� ��������� ��� �����
    shreg4 <= SXT(DATA_INPUT(15 downto 4), shreg4'length);
    shreg5 <= SXT(DATA_INPUT(15 downto 5), shreg5'length);
    shreg8 <= SXT(DATA_INPUT(15 downto 8), shreg5'length);
    shreg9 <= SXT(DATA_INPUT(15 downto 9), shreg5'length);
    shreg11 <= SXT(DATA_INPUT(15 downto 11), shreg5'length);
    shreg14 <= SXT(DATA_INPUT(15 downto 14), shreg5'length);

    -- ����������:
    -- � ���� ������� �������� ��������� ������ ������ � ����� ��������. 
    -- ��� � �� ���������, �� ������ ������ ��� ������, �� ������ � ����������� ���� ��� ������, � ������� � �������. 
    

    -- *********************** ������ ���� *****************************
    -- ���������� �������: 
    sum45_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if DATA_INPUT_VALID = '1' then 
                sum45 <= shreg4 + shreg5;
            else
                sum45 <= sum45; --������ �� ������ � ��������. 
            end if;
        end if;
    end process;
    
    sum89_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
             if DATA_INPUT_VALID = '1' then 
                 sum89 <= shreg8 + shreg9;
             else
                sum89 <= sum89;
             end if;
        end if;
    end process;

    sum1114_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if DATA_INPUT_VALID = '1' then 
                sum1114 <= shreg11 + shreg14;
            else
                sum1114 <= sum1114;
            end if;
        end if;
    end process;
 
    delayed_shreg14_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if DATA_INPUT_VALID = '1' then 
                delayed_shreg14 <= shreg14;
            else
                delayed_shreg14 <= delayed_shreg14;
            end if;
        end if;
    end process;


    --********************* ������ ���� ************************
    sum45_89_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if dvi_delay(0) = '1' then 
                sum45_89 <= sum45 + sum89;
            else
                sum45_89 <= sum45_89;
            end if;
        end if;
    end process;

    sum1114_14_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if dvi_delay(0) = '1' then 
                sum1114_14 <= sum1114 + delayed_shreg14;
            else
                sum1114_14 <= sum1114_14;
            end if;
        end if;
    end process;

    --********************* ������ ���� **********************
    result_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if dvi_delay(1) = '1' then 
                result <= sum45_89 + sum1114_14;
            else
                result <= result;
            end if;
        end if;
    end process;

    -- ****************** �������� DVI_DELAY **********************

    dvi_delay_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            dvi_delay <= dvi_delay(1 downto 0) & DATA_INPUT_VALID;
        end if;
    end process;
    
end Behavioral;
