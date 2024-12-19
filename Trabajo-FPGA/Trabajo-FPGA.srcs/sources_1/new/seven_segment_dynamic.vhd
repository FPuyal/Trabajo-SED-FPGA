library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_dynamic is
    Port (
        clk       : in  STD_LOGIC;         -- Reloj del sistema
        sign      : in  STD_LOGIC;         -- Signo del número (1 = -, 0 = +)
        state_in    : in  STD_LOGIC_VECTOR(3 downto 0);       -- display x o y 
        centenas  : in  STD_LOGIC_VECTOR(3 downto 0); -- Centenas
        decenas   : in  STD_LOGIC_VECTOR(3 downto 0); -- Decenas
        unidades  : in  STD_LOGIC_VECTOR(3 downto 0); -- Unidades
        decimas   : in  STD_LOGIC_VECTOR(3 downto 0); -- Décimas
        an        : out STD_LOGIC_VECTOR(7 downto 0); -- Control de ánodos
        segments  : out STD_LOGIC_VECTOR(7 downto 0)  -- Segmentos (CA-CG, DP)
    );
end seven_segment_dynamic;

architecture Behavioral of seven_segment_dynamic is
    -- Señales internas
    signal refresh_counter : unsigned(19 downto 0) := (others => '0'); -- Contador para multiplexación
    signal current_display : STD_LOGIC_VECTOR(2 downto 0) := "000";    -- Display activo
    signal segment_output  : STD_LOGIC_VECTOR(6 downto 0);             -- Salida de segmentos
    signal dp_output       : STD_LOGIC := '1';                        -- Control del punto decimal

    -- Señales de conexión a los decoders
    signal decoded_centena : STD_LOGIC_VECTOR(6 downto 0);
    signal decoded_decena  : STD_LOGIC_VECTOR(6 downto 0);
    signal decoded_unidad  : STD_LOGIC_VECTOR(6 downto 0);
    signal decoded_decima  : STD_LOGIC_VECTOR(6 downto 0);
    signal decoded_estado  : STD_LOGIC_VECTOR(6 downto 0);

    -- Componente: decoder
    component decoder
        Port (
            bin_in  : in  STD_LOGIC_VECTOR(3 downto 0);
            seg_out : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
begin
    -- Instancias de los decoders
    decoder_centena_inst: decoder
        port map (
            bin_in  => centenas,
            seg_out => decoded_centena
        );

    decoder_decena_inst: decoder
        port map (
            bin_in  => decenas,
            seg_out => decoded_decena
        );

    decoder_unidad_inst: decoder
        port map (
            bin_in  => unidades,
            seg_out => decoded_unidad
        );

    decoder_decima_inst: decoder
        port map (
            bin_in  => decimas,
            seg_out => decoded_decima
        );
        
     decoder_estado_inst: decoder
        port map (
            bin_in  => state_in,
            seg_out => decoded_estado
        );
    -- Proceso para multiplexación
    process(clk)
    begin
        if rising_edge(clk) then
            -- Incrementa el contador de multiplexación
            refresh_counter <= refresh_counter + 1;

            -- Cambia de display cada cierto tiempo
            if refresh_counter = 1000000 then  -- Ajusta el valor de multiplexación
                current_display <= std_logic_vector(unsigned(current_display) + 1);
                if current_display = "100" then
                    current_display <= "000"; -- Reinicia al primer display
                end if;
                refresh_counter <= (others => '0'); -- Reinicia el contador
            end if;
        end if;
    end process;

    -- Decodificación y control de los displays
    process(current_display, sign, decoded_centena, decoded_decena, decoded_unidad, decoded_decima)
    begin
        -- Asignación a los displays
        case current_display is
            when "000" => -- Display A5: Signo
                an <= "11011111"; -- Activar A5 (lógica inversa: 0 activa el display)
                if sign = '1' then
                    segment_output <= "1111110"; -- Muestra "-"
                else
                    segment_output <= "1111111"; -- Apagado
                end if;
                dp_output <= '1'; -- Punto decimal apagado

            when "001" => -- Display A4: Centenas
                an <= "11101111"; -- Activar A4
                segment_output <= decoded_centena;
                dp_output <= '1'; -- Punto decimal apagado

            when "010" => -- Display A3: Decenas
                an <= "11110111"; -- Activar A3
                segment_output <= decoded_decena;
                dp_output <= '1'; -- Punto decimal apagado

            when "011" => -- Display A2: Unidades
                an <= "11111011"; -- Activar A2
                segment_output <= decoded_unidad;
                dp_output <= '1'; -- Punto decimal activo

            when "100" => -- Display A1: Décimas
                an <= "11111101"; -- Activar A3
                segment_output <= decoded_decima;
                dp_output <= '1'; -- Punto decimal apagado
                
            when "101" => -- Display estado: X o Y
                an <= "01111111";
                segment_output <= decoded_estado;
                dp_output <= '1'; -- Punto decimal apagado

            when others =>
                an <= "11111111"; -- Apagar todos los displays
                segment_output <= "1111111"; -- Apagar segmentos
                dp_output <= '1'; -- Apagar punto decimal
        end case;
    end process;

    -- Conecta segmentos al puerto de salida
    segments <= segment_output & dp_output;

end Behavioral;




