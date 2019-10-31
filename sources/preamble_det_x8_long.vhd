library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all; -- операции сравнения с int типом не будут работать если не подключить эти функции
    use ieee.std_logic_arith.all; -- операции сравнения с int типом не будут работать если не подключить эти функции


-- Помним что данный вариант достаточно просто заточить под свой вариант, 
-- Если просто добавить generic-параметр.
-- сигнал DV в данном случае будет генерироваться на несколько тактов, количество тактов будет определяться константой LEN_SYNC_COM
entity preamble_det_x8_long is
    port(
        CLK         :   in      std_logic                           ;
        DATA_IN     :   in      std_logic                           ;
        --DATA_OUT    :   out     std_Logic                           ;
        DVO_OUT     :   out     std_Logic                           
    );
end preamble_det_x8_long;



architecture preamble_det_x8_long_arch of preamble_det_x8_long is
    -- константа преамбулы. у каждого будет разная длина в зависимости от варианта
    constant C_PREAMBLE : std_logic_vector ( 7 downto 0 ) := "10101010";
    constant C_LEN_SYNC_COM : std_logic_Vector ( 7 downto 0 ) := conv_std_logic_Vector (16 , 8);
    -- регистр задержки
    signal  delay_data_reg : std_logic_vector ( 7 downto 0 ) := (others => '0');
    -- регистр валидности данных. 
    signal  dvo_out_reg : std_logic  := '0';

    -- 
    signal  sync_com_cnt : std_Logic_Vector ( 7 downto 0 ) := (others => '0');

begin

    DVO_OUT <= dvo_out_reg; -- назначение регистров на выходной порт
    --DATA_OUT <= delay_data_reg(7); -- назначение регистров на выходной порт

    -- просто сдвиговый регистр
    delay_data_reg_processing : process(CLK)
    begin
        if cLK'event AND CLK = '1' then 
            delay_data_reg(7 downto 0 ) <= delay_data_reg(6 downto 0 ) & DATA_IN;
        end if;
    end process;

    -- здесь на каждом такте происходит сравнение на константу преамбулы, и если она равна, то генерируется единица, дающая сигнал работы следующему блоку.
    dvo_out_reg_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if sync_com_cnt > 0 then 
                dvo_out_reg <= '1';
            else
                dvo_out_reg <= '0';
            end if;
        end if;
    end  process;

    sync_com_cnt_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then
            if sync_com_cnt = 0 then  
                if delay_data_reg = C_PREAMBLE then 
                    sync_com_cnt <= sync_com_cnt + 1;
                else
                    sync_com_cnt <= sync_com_cnt;
                end if;
            else
                if sync_com_cnt < C_LEN_SYNC_COM then 
                    sync_com_cnt <= sync_com_cnt + 1;
                else
                    sync_com_cnt <= (others => '0'); 
                end if;    
            end if;
        end if;
    end process;


end preamble_det_x8_long_arch;
