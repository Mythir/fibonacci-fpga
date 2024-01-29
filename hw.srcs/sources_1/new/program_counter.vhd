----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2023 17:33:22
-- Design Name: 
-- Module Name: program_counter - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
generic(
    address_length: natural := 2
);
port(
    clk: in std_logic;
    reset: in std_logic;
    out_valid: out std_logic;
    out_ready: in std_logic;
    rom_address: out std_logic_vector((address_length - 1) downto 0)
);
end program_counter;

architecture Behavioral of program_counter is
    signal program_counter: std_logic_vector((address_length - 1) downto 0);
begin
    rom_address <= program_counter;
process(clk) is
begin
    if rising_edge(clk) then    
        if reset = '1' then
            out_valid <= '1';
            program_counter <= (others => '0');
        else
            if out_ready = '1' then
                if program_counter = "1111" then
                    out_valid <= '0';
                end if;
                program_counter <= std_logic_vector(unsigned(program_counter) + 1);
            end if;
        end if;
    end if;
end process;

end Behavioral;
