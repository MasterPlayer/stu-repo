library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
    use UNISIM.VComponents.all;


-- Пример фазового аккумулятора на 4 бита. 

entity phase_acc is
    port(
        CLK             :   in      std_logic                               ;
        RESET           :   in      std_logic                               ;
        STEP            :   in      std_logic_vector ( 3 downto 0 )         ; -- Размер приращения к аккумулятору
        ENABLE          :   in      std_logic                               ;
        PHASE_ACC_OUT   :   out     std_logic_vector ( 3 downto 0 )         
    );
end phase_acc;



architecture phase_acc_arch of phase_acc is

    signal  phase_acc_reg : std_logic_Vector ( 3 downto 0 ) := (others => '0') ;

begin

    PHASE_ACC_OUT <= phase_acc_reg;

    phase_acc_reg_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if RESET = '1' then 
                phase_acc_reg <= (others => '0');
            else
                if ENABLE = '1' then 
                    phase_acc_reg <= phase_acc_reg + STEP;
                else
                    phase_acc_reg <= phase_acc_reg;
                end if;
            end if;
        end if;
    end process;

end phase_acc_arch;
