library ieee;
use ieee.std_logic_1164.all;

entity SevenSegmentConstants is
end entity;

architecture Behavioral of SevenSegmentConstants is
    constant ZERO : std_logic_vector(6 downto 0) := "0000001";
    constant ONE : std_logic_vector(6 downto 0) := "1001111";
    constant TWO : std_logic_vector(6 downto 0) := "0010010";
    constant THREE : std_logic_vector(6 downto 0) := "0000110";
    constant FOUR : std_logic_vector(6 downto 0) := "1001100";
    constant FIVE : std_logic_vector(6 downto 0) := "0100100";
    constant SIX : std_logic_vector(6 downto 0) := "0100000";
    constant SEVEN : std_logic_vector(6 downto 0) := "0001111";
    constant EIGHT : std_logic_vector(6 downto 0) := "0000000";
    constant NINE : std_logic_vector(6 downto 0) := "0000100";
begin
end architecture;
