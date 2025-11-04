library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Lab5fsm is
  Port (
    S3, S2, S1, S0      : in  STD_LOGIC;  
    bag_present         : in  STD_LOGIC;  
    suspicious_item     : in  STD_LOGIC;  
    next_S3, next_S2, next_S1, next_S0 : out STD_LOGIC;  
    load_next_bag      : out STD_LOGIC;  
    xray_enable        : out STD_LOGIC;
    redirect_bag       : out STD_LOGIC;
    unload_bag         : out STD_LOGIC
  );
end Lab5fsm;

architecture Combinational of Lab5fsm is
  signal state_vec : STD_LOGIC_VECTOR(3 downto 0);
  constant Idle_state   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  constant Load1_state  : STD_LOGIC_VECTOR(3 downto 0) := "0001";
  constant Load2_state  : STD_LOGIC_VECTOR(3 downto 0) := "0010";
  constant Load3_state  : STD_LOGIC_VECTOR(3 downto 0) := "0011";
  constant Xray1_state  : STD_LOGIC_VECTOR(3 downto 0) := "0100";
  constant Xray2_state  : STD_LOGIC_VECTOR(3 downto 0) := "0101";
  constant Unload1_state: STD_LOGIC_VECTOR(3 downto 0) := "0110";
  constant Unload2_state: STD_LOGIC_VECTOR(3 downto 0) := "0111";
  constant Unload3_state: STD_LOGIC_VECTOR(3 downto 0) := "1000";
begin
  state_vec <= S3 & S2 & S1 & S0;

  load_next_bag <= '1' when (state_vec = Load1_state or state_vec = Load2_state or state_vec = Load3_state) 
                   else '0';
  xray_enable   <= '1' when (state_vec = Xray1_state or state_vec = Xray2_state) else '0';
  unload_bag    <= '1' when (state_vec = Unload1_state or state_vec = Unload2_state or state_vec = Unload3_state) 
                   else '0';
  redirect_bag  <= '1' when ((state_vec = Xray1_state or state_vec = Xray2_state) 
                              and suspicious_item = '1') else '0';
  next_state: process(state_vec, bag_present, suspicious_item) is 
  begin
    if (state_vec = Idle_state) then
      if bag_present = '0' then                      
        next_S3 <= Load1_state(3);
        next_S2 <= Load1_state(2);
        next_S1 <= Load1_state(1);
        next_S0 <= Load1_state(0);
      else                                      
        next_S3 <= Idle_state(3);
        next_S2 <= Idle_state(2);
        next_S1 <= Idle_state(1);
        next_S0 <= Idle_state(0);
      end if;
    elsif (state_vec = Load1_state) then
      next_S3 <= Load2_state(3); next_S2 <= Load2_state(2);
      next_S1 <= Load2_state(1); next_S0 <= Load2_state(0);
    elsif (state_vec = Load2_state) then
      next_S3 <= Load3_state(3); next_S2 <= Load3_state(2);
      next_S1 <= Load3_state(1); next_S0 <= Load3_state(0);
    elsif (state_vec = Load3_state) then
      next_S3 <= Xray1_state(3); next_S2 <= Xray1_state(2);
      next_S1 <= Xray1_state(1); next_S0 <= Xray1_state(0);
    elsif (state_vec = Xray1_state) then 
      if suspicious_item = '1' then
        next_S3 <= Unload1_state(3); next_S2 <= Unload1_state(2);
        next_S1 <= Unload1_state(1); next_S0 <= Unload1_state(0);
      else
        next_S3 <= Xray2_state(3); next_S2 <= Xray2_state(2);
        next_S1 <= Xray2_state(1); next_S0 <= Xray2_state(0);
      end if;
    elsif (state_vec = Xray2_state) then
      next_S3 <= Unload1_state(3); next_S2 <= Unload1_state(2);
      next_S1 <= Unload1_state(1); next_S0 <= Unload1_state(0);
    elsif (state_vec = Unload1_state) then
      next_S3 <= Unload2_state(3); next_S2 <= Unload2_state(2);
      next_S1 <= Unload2_state(1); next_S0 <= Unload2_state(0);
    elsif (state_vec = Unload2_state) then
      next_S3 <= Unload3_state(3); next_S2 <= Unload3_state(2);
      next_S1 <= Unload3_state(1); next_S0 <= Unload3_state(0);
    elsif (state_vec = Unload3_state) then
      if bag_present = '1' then
        next_S3 <= Unload3_state(3); next_S2 <= Unload3_state(2);
        next_S1 <= Unload3_state(1); next_S0 <= Unload3_state(0);
      else 
        next_S3 <= Idle_state(3); next_S2 <= Idle_state(2);
        next_S1 <= Idle_state(1); next_S0 <= Idle_state(0);
      end if;
    else 
      next_S3 <= Idle_state(3); next_S2 <= Idle_state(2);
      next_S1 <= Idle_state(1); next_S0 <= Idle_state(0);
    end if;
  end process next_state;

end architecture;