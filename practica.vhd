Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;

entity INSF_8BITS is 
    port(
        Datos : in STD_LOGIC_VECTOR(7 downto 0); --bus de datos
        Instrucciones : out STD_LOGIC_VECTOR(5 downto 0); --bus de instrucciones
        EXE : in STD_LOGIC; --control de instruccion

        HEX0 : out STD_LOGIC_VECTOR(6 downto 0); --Display de acumulador nibble 0
        HEX1 : out STD_LOGIC_VECTOR(6 downto 0); --Display de acumulador nibble 1
        HEX2 : out STD_LOGIC_VECTOR(6 downto 0); --Display de acumulador nibble 2
        HEX3 : out STD_LOGIC_VECTOR(6 downto 0); --Display de acumulador nibble 3

        HEX4 : out STD_LOGIC_VECTOR(6 downto 0); --Display de imstruccion nibble 4
        HEX5 : out STD_LOGIC_VECTOR(6 downto 0); --Display de instruccion nibble 5
        OS_CLK : in STD_LOGIC; --Reloj
        CLR : in STD_LOGIC; --Reset
    );
end entity INSF_8BITS;

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--   Declaracion de la arquitectura
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Architecture DATA of INSF_8BITS is
    signal AL : STD_LOGIC_VECTOR(7 downto 0);  -- Acumulador parte baja
    signal AH : STD_LOGIC_VECTOR(7 downto 0);  -- Acumulador parte alta
    signal Q : STD_LOGIC_VECTOR(7 downto 0);  -- Registro de salida
    signal CLK : STD_LOGIC; --Reloj
    signal CONT_CLK STD_LOGIC_VECTOR(26 downto 0); --Contador de reloj
    signal DisplayInst : STD_LOGIC_VECTOR(6 downto 0); --Display de instruccion
    signal DisplayValue : STD_LOGIC_VECTOR(6 downto 0);
    signal DisplayPosition : STD_LOGIC_VECTOR(6 downto 0);
    -- constantes de los 7 segmentos
    constant ZERO : STD_LOGIC_VECTOR(6 downto 0) := "1000000";
    constant ONE : STD_LOGIC_VECTOR(6 downto 0) := "1111001";
    constant TWO : STD_LOGIC_VECTOR(6 downto 0) := "0100100";
    constant THREE : STD_LOGIC_VECTOR(6 downto 0) := "0110000";
    constant FOUR : STD_LOGIC_VECTOR(6 downto 0) := "0011001";
    constant FIVE : STD_LOGIC_VECTOR(6 downto 0) := "0010010";
    constant SIX : STD_LOGIC_VECTOR(6 downto 0) := "0000010";
    constant SEVEN : STD_LOGIC_VECTOR(6 downto 0) := "1111000";
    constant EIGHT : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    constant NINE : STD_LOGIC_VECTOR(6 downto 0) := "0010000";
    constant A : STD_LOGIC_VECTOR(6 downto 0) := "0001000";
    constant B : STD_LOGIC_VECTOR(6 downto 0) := "0000011";
    constant C : STD_LOGIC_VECTOR(6 downto 0) := "1000110";
    constant D : STD_LOGIC_VECTOR(6 downto 0) := "0100001";
    constant E : STD_LOGIC_VECTOR(6 downto 0) := "0000110";
    constant F : STD_LOGIC_VECTOR(6 downto 0) := "0001110";
    constant OFF : STD_LOGIC_VECTOR(6 downto 0) := "1111111";
begin
    with instrucciones select --seleccion de instruccion
        Display <= (OFF & CERO) when "000000",
                   (OFF & UNO) when "000001",
                   (OFF & DOS) when "000010",
                   (OFF & TRES) when "000011",
                   (OFF & CUATRO) when "000100",
                   (OFF & CINCO) when "000101",
                   (OFF & SEIS) when "000110",
                   (OFF & SIETE) when "000111",
                   (OFF & OCHO) when "001000",
                   (OFF & NUEVE) when "001001",
                   (OFF & A) when "001010",
                    (OFF & B) when "001011",
                    (OFF & C) when "001100",
                    (OFF & D) when "001101",
                    (OFF & E) when "001110",
                    (OFF & F) when "001111",
                    (ONE & OFF) when "010000",
                    (ONE & ONE) when "010001",
                    (ONE & TWO) when "010010",
                    (ONE & THREE) when "010011",
                    (OFF & OFF) when others;

    divFrecuencia: process(OS_CLK,CLR)
    begin
        if (CLR = '0`) then
        CONT_CLK <= "000000000000000000000000000";
        elsif (OS_CLK'event and OS_CLK = '1') then
            CONT_CLK <= CONT_CLK + 1;
            if (CONT_CLK = "111101000010010000000000000") then
                CLK <= not CLK;
            end if;
        end if;
    end process divFrecuencia;
 
    contAnillo: process(CLR,CLK)
    begin
        if (CLR = '0') then
            Q <= "00000001";
        elsif (CLK'event and CLK = '1') then
            Q <= Q(6 downto 0) & Q(7);
        end if;
    end process contAnillo;



    bitPRocesor :process(Datos,EXE,instrucciones)
    begin
        if (EXE = '0') then --Ejecucion de instruccion
            case instrucciones is --seleccion de instruccion
                when "X00" => -- Instruccion de carga
                    --instrucciones <= "000000";
                when "X01" => --Almacenamiento
                    AL <= Datos; --Asignacion de datos a AL
                when "X02" =>  --Suma aritmetica
                    AL <= AL + Datos; --Suma de AL y Datos
                when "X03" => --Resta aritmetica
                    AL <= AL - Datos; --Resta de AL y Datos
                when "X04" => --Multiplicacion aritmetica
                    (AH&AL) <= AL * Datos; --Multiplicacion de AL y Datos
                when "X05" => -- AND logico
                    AL <= AL AND Datos; --AND logico de AL y Datos
                when "X06" => -- OR logico
                    AL <= AL OR Datos; --OR logico de AL y Datos
                when others =>
                    --instrucciones <= "000000";
            end case;
        end if;
    end process bitPRocesor;

end architecture DATA;