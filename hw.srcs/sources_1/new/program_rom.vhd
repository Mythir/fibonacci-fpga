library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
 
entity program_rom is
-- Generic: compile time constants
generic(
    ADDRESS_WIDTH: natural := 4;
    DATA_WIDTH: natural := 16
);
-- Port: inputs en outputs
port(
    clk: in std_logic;
    reset: in std_logic;

    out_valid: out std_logic;
    out_ready: in std_logic;

    in_valid: in std_logic;
    in_ready: out std_logic;

    address: in std_logic_vector((ADDRESS_WIDTH - 1) downto 0);

    data_out: out std_logic_vector ((DATA_WIDTH - 1) downto 0)
);
end program_rom;

architecture arch of program_rom is
    --Todo: rom_type

    --Todo: memory

    -- Todo: input register
begin
    --Todo: handshake

    --Todo: uitlezen mem

    process(clk) is
    begin
    --Todo: reset, handshake out, handshake in
    end process;
 
end arch;
