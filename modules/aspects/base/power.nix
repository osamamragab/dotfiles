{
  den.aspects.base = {
    nixos = {
      services.upower = {
        enable = true;
        usePercentageForPolicy = true;
        allowRiskyCriticalPowerAction = false;
        percentageLow = 20;
        percentageCritical = 10;
        percentageAction = 5;
        timeLow = 1200;
        timeCritical = 300;
        timeAction = 120;
        criticalPowerAction = "HybridSleep";
      };

      services.power-profiles-daemon.enable = true;
    };
  };
}
