function prmOTFSRx = configureOTFSRx(platform, rfRxFreq, bbRxFreq)
% OTFS RX prm configuraiton

switch platform
  case {'B200','B210'}
    prmOTFSRx.MasterClockRate = 20e6;  %Hz
    prmOTFSRx.Fs = 200e3; % sps
  case {'X300','X310'}
    prmOTFSRx.MasterClockRate = 200e6; %Hz
    prmOTFSRx.Fs = 10e6; % sps 200e3
  case {'N200/N210/USRP2'}
    prmOTFSRx.MasterClockRate = 100e6; %Hz
    prmOTFSRx.Fs = 200e3; % sps
  case {'N300','N310'}
    prmOTFSRx.MasterClockRate = 153.6e6; %Hz
    prmOTFSRx.Fs = 200e3; % sps
  case {'N320/N321'}
    prmOTFSRx.MasterClockRate = 200e6; %Hz
    prmOTFSRx.Fs = 200e3; % sps
  otherwise
    error(message('sdru:examples:UnsupportedPlatform', ...
      platform))
end

% SDRu Receiver System obje
prmOTFSRx.RxCenterFrequency = rfRxFreq; 
prmOTFSRx.Gain              = 20;
prmOTFSRx.DecimationFactor  = ...
  prmOTFSRx.MasterClockRate/prmOTFSRx.Fs;

prmOTFSRx.FrameLength       = 10*5000;   %Set Rx frame length here
prmOTFSRx.TotalFrames       = 1000;
prmOTFSRx.RxSineFrequency   = bbRxFreq; 
prmOTFSRx.OutputDataType    = 'double'; 


% EOF
