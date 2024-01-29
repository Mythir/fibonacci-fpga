library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
 
entity program_rom is
generic(
    address_length: natural := 2;
    data_length: natural := 16
);
port(
    clk: in std_logic;
    reset: in std_logic;
    out_valid: out std_logic;
    out_ready: in std_logic;
    in_valid: in std_logic;
    in_ready: out std_logic;
    address: in std_logic_vector((address_length - 1) downto 0);
    data_out: out std_logic_vector ((data_length - 1) downto 0)
);
end program_rom;
 
architecture arch of program_rom is
    type rom_type is array (0 to (2**(address_length) -1)) of std_logic_vector((data_length - 1) downto 0);
    
    -- set the data on each adress to some value)
    constant mem: rom_type:=
    (
        "0100110001100001",
        "0111001001110011",
        "0000000000000000",
        "0000000000000000"
    );
    
    signal out_reg_full: std_logic;
begin

    out_valid <= out_reg_full;
    in_ready <= out_ready;
    
process(clk) is
    variable consumed: boolean;
begin
    if rising_edge(clk) then
        if reset = '1' then
            out_reg_full <= '0';
        else
            if out_ready = '1' and out_reg_full = '1' then
                consumed := true;
            else
                consumed := false;
            end if;
            
            if in_valid = '1' and (consumed or out_reg_full = '0') then
                data_out <= mem(conv_integer(unsigned(address)));
                out_reg_full <= '1';
            elsif consumed then
                out_reg_full <= '0';
            end if;
        end if;
    end if;
end process;
 
end arch;
