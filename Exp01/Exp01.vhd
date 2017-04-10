LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Mapear os sinais de entrada e saida para os pinos fisicos da placa
ENTITY Exp01 IS
	PORT(	reset				: IN STD_LOGIC; -- Usar SW0
			clock48MHz		: IN STD_LOGIC; -- Usar clock da placa
			-- Mapear para pinos do LCD
			LCD_RS, LCD_E	: OUT	STD_LOGIC;
			LCD_RW, LCD_ON	: OUT STD_LOGIC;
			DATA				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			clock				: IN STD_LOGIC -- Usar pushbutton Key0
			);
END Exp01;

ARCHITECTURE exec OF Exp01 IS
COMPONENT LCD_Display
	GENERIC(NumHexDig: Integer:= 11);
	PORT(	reset, clk_48Mhz	: IN	STD_LOGIC;
			HexDisplayData		: IN  STD_LOGIC_VECTOR((NumHexDig*4)-1 DOWNTO 0);
			LCD_RS, LCD_E		: OUT	STD_LOGIC;
			LCD_RW				: OUT STD_LOGIC;
			DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

COMPONENT Ifetch
	PORT(	reset			: in STD_LOGIC;
			clock			: in STD_LOGIC;
			PC_out		: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			Instruction : out STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;
SIGNAL DataInstr 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PCAddr		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LCD_Data 	: STD_LOGIC_VECTOR(43 DOWNTO 0);
BEGIN
	LCD_ON <= '1';
	LCD_Data <= "0000" & PCAddr & DataInstr;
	-- O componente LCD_Display mostra 11 digitios hexadecimais, 44 bits
	-- Mapeie os 10 bits do PC concatenados com os 32 bits da instrucao
	-- Concatene bits 0 a esquerda para completar
	lcd: LCD_Display
	PORT MAP(	reset				=> reset,
					clk_48Mhz		=> clock48MHz,
					HexDisplayData	=> LCD_Data,
					LCD_RS			=> LCD_RS,
					LCD_E				=> LCD_E,
					LCD_RW			=> LCD_RW,
					DATA_BUS			=> DATA);
	
	IFT: Ifetch
	PORT MAP( reset => reset,
				 clock => clock,
				 PC_out => PCAddr,
				 Instruction => DataInstr);

END exec;