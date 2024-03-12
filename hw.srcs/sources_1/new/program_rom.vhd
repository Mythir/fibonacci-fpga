library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
 
entity program_rom is
generic(
    ADDRESS_WIDTH: natural := 2;
    DATA_WIDTH: natural := 16
);
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
    type rom_type is array (0 to (2**(ADDRESS_WIDTH) -1)) of std_logic_vector((DATA_WIDTH - 1) downto 0);
    
    -- set the data on each adress to some value)
    constant mem: rom_type:=
    (
        "0011000100000000",
        
        "0010000000010001",
        "0011000100000000",
        "0001000100000010",
        "0011001000000000",
        
        "0001000100100001",
        "0011000100000000",
        "0001000100100010",
        "0011001000000000",
        
        "0001000100100001",
        "0011000100000000",
        "0001000100100010",
        "0011001000000000",
        
        "0001000100100001",
        "0011000100000000",
        "0001000100100010"
    );
    
    signal input_register: std_logic_vector((ADDRESS_WIDTH - 1) downto 0);
    signal in_ready_sig: std_logic;
    signal out_valid_sig: std_logic;
begin
    
    out_valid <= out_valid_sig;
    in_ready <= in_ready_sig;
    
    in_ready_sig <= out_ready;
    data_out <= mem(conv_integer(unsigned(input_register)));
    
process(clk) is
    variable consumed: boolean;
begin
    if rising_edge(clk) then
        if reset='1' then
            input_register <= (others => '0');
            out_valid_sig <= '0';
        else
            if out_valid_sig='1' and out_ready='1' then
                out_valid_sig <= '0';
            end if;
            
            if in_ready_sig='1' and in_valid = '1' then
                input_register <= address;
                out_valid_sig <= '1';
            end if;
        end if;
    end if;
end process;
 
end arch;
