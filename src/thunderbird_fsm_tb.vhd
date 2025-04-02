--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : thunderbird_fsm_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 03/2017
--| DESCRIPTION   : This file tests the thunderbird_fsm modules.
--|
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : thunderbird_fsm_enumerated.vhd, thunderbird_fsm_binary.vhd, 
--|				   or thunderbird_fsm_onehot.vhd
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
entity thunderbird_fsm_tb is
end thunderbird_fsm_tb;

architecture behavior of thunderbird_fsm_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component thunderbird_fsm
        port (
            i_clk      : in  std_logic;
            i_reset    : in  std_logic;
            i_left     : in  std_logic;
            i_right    : in  std_logic;
            o_lights_L : out std_logic_vector(2 downto 0);
            o_lights_R : out std_logic_vector(2 downto 0)
        );
    end component;

    -- Signals for the testbench
    signal i_clk      : std_logic := '0';
    signal i_reset    : std_logic := '0';
    signal i_left     : std_logic := '0';
    signal i_right    : std_logic := '0';
    signal o_lights_L : std_logic_vector(2 downto 0);
    signal o_lights_R : std_logic_vector(2 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: thunderbird_fsm port map (
        i_clk      => i_clk,
        i_reset    => i_reset,
        i_left     => i_left,
        i_right    => i_right,
        o_lights_L => o_lights_L,
        o_lights_R => o_lights_R
    );

    -- Clock process definition
    clk_process :process
    begin
        i_clk <= '0';
        wait for clk_period/2;
        i_clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process (test cases)
    stim_proc: process
    begin
        -- Reset the FSM
        i_reset <= '1';
        wait for 20 ns;
        i_reset <= '0';

        -- Test Case 1: Left turn transition from OFF state
        i_left <= '1';
        i_right <= '0';
        wait for 40 ns;  -- Wait for FSM to process the transition
        
        -- Test Case 2: Right turn transition from OFF state
        i_left <= '0';
        i_right <= '1';
        wait for 40 ns;  -- Wait for FSM to process the transition
        
        -- Test Case 3: Both left and right, which should turn ON state
        i_left <= '1';
        i_right <= '1';
        wait for 40 ns;
        
        -- Test Case 4: No input (OFF state)
        i_left <= '0';
        i_right <= '0';
        wait for 40 ns;
        
        -- Test Case 5: Left turn sequence L1 -> L2 -> L3 -> OFF
        i_left <= '1'; i_right <= '0'; -- L1
        wait for 40 ns;
        i_left <= '1'; i_right <= '0'; -- L2
        wait for 40 ns;
        i_left <= '1'; i_right <= '0'; -- L3
        wait for 40 ns;
        i_left <= '0'; i_right <= '0'; -- OFF
        wait for 40 ns;

        -- End of test
        wait;
    end process;

end behavior;
