library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library xil_defaultlib;
use xil_defaultlib.reg_bank;
use xil_defaultlib.opcodes.all;
 
entity exec is
generic(
    DATA_WIDTH: natural := 16
);
port(
    clk: in std_logic;
    reset: in std_logic;
    
    in_instruction: in std_logic_vector(DATA_WIDTH-1 downto 0);
    in_valid: in std_logic;
    in_ready: out std_logic;
    
    out_data: out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_valid: out std_logic;
    out_ready: in std_logic
);
end exec;
 
architecture arch of exec is
    component reg_bank is
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
    end component;
 
    component alu is
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
    end component;


    signal reg_fetch_data_1: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal reg_fetch_data_2: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal reg_write: std_logic;
    
    signal input_register: std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal opcode: std_logic_vector(OPCODE_WIDTH - 1 downto 0);
    signal input_reg_address_1: std_logic_vector(REG_ADDRESS_WIDTH - 1 downto 0);
    signal input_reg_address_2: std_logic_vector(REG_ADDRESS_WIDTH - 1 downto 0);
    signal input_reg_address_3: std_logic_vector(REG_ADDRESS_WIDTH - 1 downto 0);
    signal immediate: std_logic_vector(IMMEDIATE_WIDTH - 1 downto 0);
    
    signal alu_in_1: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal alu_in_2: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal alu_out: std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal bus_out: std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal in_ready_sig: std_logic;

begin
    reg_bank_inst: reg_bank
    generic map(
        address_length => REG_ADDRESS_WIDTH,
        data_length => DATA_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        address_fetch_1 => input_reg_address_1,
        data_out_1 => reg_fetch_data_1,
        
        address_fetch_2 => input_reg_address_2,
        data_out_2 => reg_fetch_data_2,
        
        address_store => input_reg_address_3,
        data_in => bus_out,
        write => reg_write
    );
 
    alu_inst: alu
    generic map(
        OPCODE_WIDTH => OPCODE_WIDTH,
        DATA_WIDTH => DATA_WIDTH
    )
    port map(    
        opcode => opcode,
        
        data_in_1 => alu_in_1,
        data_in_2 => alu_in_2,
        data_out => alu_out
    );
    
    -- Split up instruction
    opcode <= input_register(15 downto 12);             --xxxx 0000 0000 0000
    OP1 <= input_register(11 downto 8);                 --0000 xxxx 0000 0000
    OP2 <= input_register(7 downto 4);                  --0000 0000 xxxx 0000
    OP3 <= input_register(3 downto 0);                  --0000 0000 0000 xxxx
    
    -- Backpressure pipeline
    in_ready_sig <= out_ready;
    in_ready <= in_ready_sig;
    
    -- ALU input process
    alu_in_1 <= reg_fetch_data_1;
    process(reg_fetch_data_2, opcode, immediate) is
    begin
        case opcode is
            when OP_ADDI =>
                alu_in_2 <= "000000000000" & immediate;
            when others =>
                alu_in_2 <= reg_fetch_data_2;
        end case;
    end process;
    
    -- Bus out process
    out_data <= bus_out;
    process(alu_out, opcode, reg_fetch_data_1) is
    begin
        case opcode is
            when OP_ADDI | OP_ADD =>
                bus_out <= alu_out;
                reg_write <= '1';
                out_valid <= '0';
            when OP_STORE =>
                bus_out <= reg_fetch_data_1;
                reg_write <= '0';
                out_valid <= '1';
            when others =>
                bus_out <= (others => '0');
                reg_write <= '0';
                out_valid <= '0';
        end case;
    end process;

    -- Input process
    process(clk) is
    begin
        if rising_edge(clk) then
            if reset='1' then
                input_register <= (others => '0');
            elsif in_ready_sig='1' and in_valid = '1' then
                input_register <= in_instruction;
            else
                -- Insert NOP instruction if pipeline stalls
                input_register <= (others => '0');
            end if;
        end if;
    end process;
end arch;
