library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity pedsub is
    PORT (ped: in  std_logic_vector(15 DOWNTO 0); -- pedestal values input 
          sample_data : in std_logic_vector(15 DOWNTO 0); -- data collected
          psr : OUT std_logic_vector(15 DOWNTO 0); --pedsub results
          p_done : OUT STD_LOGIC ; --done signal
          base_addr : OUT std_logic_vector(7 downto 0) ; -- base address
          fine_time : IN std_logic_vector(7 downto 0); -- sample number when trigger arrives    
          starting_sample_number : IN std_logic_vector(7 downto 0);
          bank : IN std_logic;
          mem_done : IN std_logic; -- signal that data finished written to memory
          addra: IN std_logic_vector(11 downto 0);
          clk : IN STD_LOGIC ) ; -- clock
end pedsub;

architecture Behavioral of pedsub is

    constant num_samples: integer := 256;
    constant num_channels: integer := 16;
    SIGNAL result: signed(15 downto 0);
    SIGNAL ped_sample_idx: std_logic_vector(7 downto 0);
    SIGNAL temp: signed(7 downto 0);
    SIGNAL psamp_idx: signed(7 downto 0);
    
    type all_data is ARRAY(0 to 12299) of std_logic_vector(15 downto 0);
    SIGNAL datavals : all_data;
    
    COMPONENT blk_mem_gen_0
    PORT (addra: IN std_logic_vector(11 downto 0);
          clka: IN std_logic;
          dina: IN std_logic_vector(15 downto 0);
          douta: OUT std_logic_vector(15 downto 0);
          ena: IN std_logic;
          wea: in std_logic_vector(0 downto 0));
    END COMPONENT;
    
begin       
    
    myram: blk_mem_gen_0
    PORT MAP (clka => clk,
              addra => addra,
              dina => "0000000000000000",
              douta => sample_data,
              ena => mem_done,
              wea => "0");
             
    readData: process(clk, mem_done)
    begin
    
    IF (clk = '1' AND clk'event) then
        ped_sample_idx <= "00000001";
    end if;
        
    end process;        
    
    writeprocess:process(clk)
    variable i: integer := 0;
    variable j: integer := 0;
    
    begin
    
    base_addr <= starting_sample_number;
    
    IF (clk = '1' AND clk'event) THEN
        IF i < num_samples THEN
            IF j < num_channels THEN
                result <= signed(sample_data) - signed(ped);
                j := j + 1; 
            ELSIF j = num_channels - 1 THEN
                psamp_idx <= signed(ped_sample_idx) + "1";
                IF psamp_idx = num_samples THEN 
                    psamp_idx <= "00000000";
                end IF;    
            end IF ;
            i := i + 1;    
        end IF ;        
    end IF;
    end process;

    psr <= std_logic_vector(result);
    
end Behavioral;
