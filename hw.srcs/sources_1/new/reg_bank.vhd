library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
 
entity reg_bank is
generic(
    address_length: natural := 4;
    data_length: natural := 16
);
port(
    clk: in std_logic;
    reset: in std_logic;
    
    address_fetch_1: in std_logic_vector((address_length - 1) downto 0);
    data_out_1: out std_logic_vector ((data_length - 1) downto 0);
    
    address_fetch_2: in std_logic_vector((address_length - 1) downto 0);
    data_out_2: out std_logic_vector ((data_length - 1) downto 0);
    
    address_store: in std_logic_vector((address_length - 1) downto 0);
    data_in: in std_logic_vector ((data_length - 1) downto 0);
    write: in std_logic
);
end reg_bank;
 
architecture arch of reg_bank is
    constant reg_max_index: integer := (2**(address_length) -1);
    type reg_type is array (0 to reg_max_index) of std_logic_vector((data_length - 1) downto 0);
    
    signal reg: reg_type;
begin

data_out_1 <= reg(conv_integer(unsigned(address_fetch_1)));
data_out_2 <= reg(conv_integer(unsigned(address_fetch_2)));
    
process(clk) is
begin
    if rising_edge(clk) then
        if reset = '1' then
            for index in 0 to reg_max_index loop 
                reg(index) <= (others => '0');
            end loop;
        elsif write = '1' then
            reg(conv_integer(unsigned(address_store))) <= data_in;
        end if;
    end if;
end process;
 
end arch;