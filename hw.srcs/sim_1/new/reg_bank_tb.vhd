----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2024 15:18:47
-- Design Name: 
-- Module Name: reg_bank_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_bank_tb is
--  Port ( );
end reg_bank_tb;

architecture Behavioral of reg_bank_tb is
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

  constant clk_period             : time := 10 ns;
  constant REG_ADDRESS_WIDTH      : natural := 4;
  constant DATA_WIDTH             : natural := 16;  

  signal clk                      : std_logic;
  signal reset                    : std_logic;
  
  signal address_fetch_1          : std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
  signal address_fetch_2          : std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
  signal address_store            : std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
  
  signal data_in            : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal data_out1          : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal data_out2          : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal write              : std_logic;
begin


    reg_bank_inst: reg_bank
    generic map(
        address_length => REG_ADDRESS_WIDTH,
        data_length => DATA_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        address_fetch_1 => address_fetch_1,
        data_out_1 => data_out1,
        
        address_fetch_2 => address_fetch_2,
        data_out_2 => data_out2,
        
        address_store => address_store,
        data_in => data_in,
        write => write
    );
    
    test_p : process
    begin
        address_fetch_1 <= "0001";
        address_fetch_2 <= "0010";
        address_store <= "0001";
        data_in <= "1001110100110101";
        write <= '0';
        
        loop
          wait until rising_edge(clk);
          exit when reset = '0';
        end loop;
        
        wait for clk_period/4;
        write <= '1';
        
        loop
          wait until rising_edge(clk);
          exit when reset = '0';
        end loop;
        
        wait for clk_period/4;
        data_in <= (others => '0');
        write <= '0';
        address_fetch_2 <= "0001";
        
        wait;
    end process;

    clk_p : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    reset_p : process is
    begin
        reset <= '1';
        wait for 20 ns;
        wait until rising_edge(clk);
        reset <= '0';
        wait;
    end process;
end Behavioral;
