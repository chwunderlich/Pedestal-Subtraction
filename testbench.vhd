library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is

    COMPONENT pedsub
    PORT(  i2c : in std_logic_vector(2 downto 0);
           bank: in  std_logic;
           fine_time: in std_logic_vector(7 downto 0);
           num_samples: in std_logic_vector(5 downto 0);
           psr: inout std_logic_vector(15 downto 0);
           starting_sample_number: in std_logic_vector(7 downto 0);
           sub_done: out std_logic;
           base_address: out std_logic_vector(7 downto 0);
           clk: in std_logic;
           ena: in std_logic;
           full: inout std_logic; 
           fifo_empty: inout std_logic;
           wr_en: inout std_logic;
           read_en: inout std_logic;
           data_in: inout std_logic_vector(15 downto 0)) ;
    END COMPONENT;      
    
    COMPONENT blk_mem_gen_0
    PORT (addra: in std_logic_vector(11 downto 0);
          clka: in std_logic;
          dina: in std_logic_vector(15 downto 0);
          douta: out std_logic_vector(15 downto 0);
          ena: in std_logic;
          wea: in std_logic_vector(0 downto 0));
    END COMPONENT;      
    
    COMPONENT fifo_generator_0
    PORT (full: out std_logic;
          din: in std_logic_vector(15 downto 0);
          wr_en: in std_logic;
          empty: out std_logic;
          dout: out std_logic_vector(15 downto 0);
          rd_en: in std_logic;
          clk: in std_logic;
          srst: in std_logic );  
    END COMPONENT;  
    
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL psr : std_logic_vector(15 DOWNTO 0);
    SIGNAL addra: std_logic_vector(11 downto 0);
    SIGNAL data_in: std_logic_vector(15 downto 0);
    SIGNAL full: std_logic := '0';
    SIGNAL fifo_empty: std_logic :='1';
    SIGNAL ena: std_logic := '0';
    SIGNAL bank: std_logic:= '0';
    SIGNAL i2c: std_logic_vector( 2 downto 0);
    SIGNAL num_samples: std_logic_vector(5 downto 0);
    SIGNAL starting_sample_number: std_logic_vector(7 downto 0);
    SIGNAL base_address: std_logic_vector(7 downto 0);
    SIGNAL sub_done: std_logic;
    SIGNAL fine_time: std_logic_vector(7 downto 0);
    SIGNAL wr_en: std_logic;
    SIGNAL read_en: std_logic;
    
begin

    clk <= not clk after 5 ns;
    
    uut: pedsub PORT MAP(
        clk => clk,
        i2c => i2c,
        bank => bank,
        num_samples => num_samples,
        starting_sample_number => starting_sample_number,
        sub_done => sub_done,
        base_address => base_address,
        ena => ena,
        full => full,
        fifo_empty => fifo_empty,
        data_in => douta,
        fine_time => fine_time,
        wr_en => wr_en,
        read_en => read_en,
        psr => psr );
        
    myram: blk_mem_gen_0
    PORT MAP (addra => addra,
              clka => clk,
              dina => "0000000000000000",
              douta => data_in,
              ena => ena,
              wea => "0" );
              
    myfifo: fifo_generator_0
    PORT MAP (full => full,
              din => psr,
              wr_en => wr_en,
              empty => fifo_empty,
              rd_en => read_en,
              clk => clk,
              srst => '0' );              
                   
    testProc: PROCESS
    begin
        wait until clk = '1';
        ena <= '1';
    end process;    
        
    
end Behavioral;
