----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2024 15:45:34
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
    component top is
    port(
        clk: in std_logic;
        led0_r: out std_logic;
        led0_g: out std_logic;
        led0_b: out std_logic;
        led: out std_logic_vector(3 downto 0);
        tx: out std_logic;
        btn: in std_logic_vector(1 downto 0)
    );
    end component;

  constant clk_period             : time := 10 ns;

  signal clk                      : std_logic;
  signal led0_r                   : std_logic;
  signal led0_g                   : std_logic;
  signal led0_b                   : std_logic;
  signal led                      : std_logic_vector(3 downto 0);
  signal tx                       : std_logic;
  signal btn                      : std_logic_vector(1 downto 0);
  
begin

    top_inst: top
    port map(
        clk => clk,
        led0_r => led0_r,
        led0_g => led0_g,
        led0_b => led0_b,
        led => led,
        tx => tx,
        btn => btn
    );

    test_p : process
    begin        
        loop
          wait until rising_edge(clk);
          exit when btn = "11";
        end loop;
        
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
        btn <= "11";
        wait for 80 ns;
        wait until rising_edge(clk);
        btn <= "00";
        wait;
    end process;
end Behavioral;
