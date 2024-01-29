library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package opcodes is
    constant OPCODE_WIDTH: integer := 4;
    constant REG_ADDRESS_WIDTH: integer := 4;
    constant IMMEDIATE_WIDTH: integer := 4;

    constant OP_ADD : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0001";
    constant OP_ADDI : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0010";
    constant OP_STORE : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0011";
end package opcodes;