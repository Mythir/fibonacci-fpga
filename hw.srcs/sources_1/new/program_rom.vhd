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
    type rom_type is array(0 to (2**ADDRESS_WIDTH-1)) of std_logic_vector(DATA_WIDTH-1 downto 0);

    --Todo: memory
    constant mem: rom_type := (
        OP_STORE & R1 & "00000000",

        OP_ADDI & R1 & "0001" & R2, --[0,1]
        OP_STORE & R2 & "00000000",
        OP_ADD & R1 & R2 & R1, --[1,1]
        OP_STORE & R1 & "00000000",

        OP_ADD & R1 & R2 & R2, --[1,2]
        OP_STORE & R2 & "00000000",
        OP_ADD & R1 & R2 & R1, --[3,2]
        OP_STORE & R1 & "00000000",

        OP_ADD & R1 & R2 & R2,
        OP_STORE & R2 & "00000000",
        OP_ADD & R1 & R2 & R1,
        OP_STORE & R1 & "00000000",

        OP_ADD & R1 & R2 & R2,
        OP_STORE & R2 & "00000000",
        OP_ADD & R1 & R2 & R1

    )

    -- Todo: input register
    signal input_register: std_logic_vector(ADDRESS_WIDTH-1 downto 0);
begin
    --Todo: handshake
    in_ready <= out_ready;

    --Todo: uitlezen mem
    data_out <= mem(conv_integer(unsigned(input_register)));

    process(clk) is
    begin
    --Todo: reset, handshake out, handshake in
        if rising_edge(clk) then
            if reset = '1' then
                out_valid <='0';
            else
                if out_ready = '1' and out_valid = '1' then
                    out_valid <='0';
                end if;

                if in_ready = '1' and in_valid = '1' then
                    input_register <= address;
                    out_valid <= '1';
                end if;
        end if;
    end process;
 
end arch;
