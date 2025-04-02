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

architecture testbench of thunderbird_fsm_tb is
    signal i_clk, i_reset, i_left, i_right: std_logic := '0';
    signal o_lights_L, o_lights_R: std_logic_vector(2 downto 0);
    constant clk_period: time := 10 ns;
    
    component thunderbird_fsm
        port (
            i_clk, i_reset  : in    std_logic;
            i_left, i_right : in    std_logic;
            o_lights_L      : out   std_logic_vector(2 downto 0);
            o_lights_R      : out   std_logic_vector(2 downto 0)
        );
    end component;
    
begin
    uut: thunderbird_fsm
    port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_left => i_left,
        i_right => i_right,
        o_lights_L => o_lights_L,
        o_lights_R => o_lights_R
    );
    
    process
    begin
        i_clk <= '0';
        wait for clk_period / 2;
        i_clk <= '1';
        wait for clk_period / 2;
    end process;
    
    process
    begin
        -- Reset the FSM
        i_reset <= '1';
        wait for 20 ns;
        i_reset <= '0';
        
        -- Test left turn signal
        i_left <= '1'; i_right <= '0';
        wait for 50 ns;
        i_left <= '0';
        
        -- Test right turn signal
        i_left <= '0'; i_right <= '1';
        wait for 50 ns;
        i_right <= '0';
        
        -- Test hazard lights
        i_left <= '1'; i_right <= '1';
        wait for 50 ns;
        i_left <= '0'; i_right <= '0';
        
        wait;
    end process;
end testbench;
