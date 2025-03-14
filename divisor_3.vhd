library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- reset asíncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- salida de 2.5MHz (100MHz/40)
        f_div_1_25  : out std_logic;  -- salida de 1.25MHz (100MHz/80)
        f_div_500   : out std_logic   -- salida de 500KHz (100MHz/200)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
     -- Contador de módulo 4
     signal count40 : unsigned(5 downto 0) := (others => '0');
     -- Contador de módulo 2 (para dividir la señal de 2.5MHz a 1.25MHz)
     signal count2 : unsigned(1 downto 0) := (others => '0');
     -- Contador de módulo 5 (para dividir la señal de 2.5MHz a 500KHz)
     signal count5 : unsigned(2 downto 0) := (others => '0');

     signal pulse_div40 : std_logic;  -- pulso de 1 ciclo a 100MHz, cada vez que el contador de módulo 40 se resetea
begin
        
     -- Proceso del contador de módulo 4     
     process(clk, ena)
     begin
        if rising_edge (clk) then
            if (ena = '0') then
                count40 <= "000000";
                pulse_div40  <= '0';
            elsif (count40 /= "100111") then
                count40 <= count40 + 1;
                pulse_div40  <= '0';
            else 
                count40 <= "000000";
                pulse_div40  <= '1';
            end if; 
        end if; 
     end process;
     
     process(clk)
     begin
         if rising_edge (clk) then
            if (ena = '0') then
                count2 <= "00";
                count5 <= "000";
                
            elsif (pulse_div40 = '1') then
                count2 <= count2 + 1;
                count5 <= count5 + 1;
                
                f_div_1_25 <= '0';
                f_div_500 <= '0';
            elsif (count2 = "10") then
                f_div_1_25 <= '1';
            elsif (count5 = "101") then
                f_div_500 <= '1';
            end if;    
        end if; 
     end process;
 
        
     -- Genera un pulso (de 1 ciclo del reloj de 100MHz) cuando count40 = 0
     -- pulse_div4 <= 


     -- Asignaciones de salida: cada señal es un pulso de 1 ciclo de reloj
     f_div_2_5  <= pulse_div40;
     -- f_div_1_25  <= 
        -- fdiv_500 <= '0';
end Behavioral;