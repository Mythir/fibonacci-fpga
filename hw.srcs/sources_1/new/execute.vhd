
 
entity execute is
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
end execute;
 
architecture arch of execute is

 
end arch;
