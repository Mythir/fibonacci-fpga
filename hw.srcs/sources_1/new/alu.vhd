library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.opcodes.all;
 
entity alu is
generic(
    OPCODE_WIDTH: natural := 4;
    DATA_WIDTH: natural := 16
);
port(    
    opcode: in std_logic_vector(OPCODE_WIDTH-1 downto 0);
    
    data_in_1: in std_logic_vector(DATA_WIDTH-1 downto 0);
    data_in_2: in std_logic_vector(DATA_WIDTH-1 downto 0);
    
    data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end alu;
 
architecture arch of alu is
begin
    
process(opcode, data_in_1, data_in_2) is
begin
    case opcode is
        when OP_ADDI | OP_ADD =>
            data_out <= std_logic_vector(signed(data_in_1) + signed(data_in_2));
        when others =>
            data_out <= (others => '0');
    end case;
end process;
 
end arch;