function prmOTFSTx = configureOTFSTx(platform,rfTxFreq,bbTxFreq)
% Configure parameters for SDRu Frequency Calibration Transmitter example.


switch platform 
  case {'B200','B210'}
    prmOTFSTx.MasterClockRate = 20e6;  %Hz
    prmOTFSTx.Fs = 200e3; % sps
  case {'X300','X310'}
    prmOTFSTx.MasterClockRate = 200e6; %Hz
    prmOTFSTx.Fs = 200e3; % sps 200e3
  case {'N200/N210/USRP2'}
    prmOTFSTx.MasterClockRate = 100e6; %Hz
    prmOTFSTx.Fs = 200e3; % sps
  case {'N300','N310'}
    prmOTFSTx.MasterClockRate = 153.6e6; %Hz
    prmOTFSTx.Fs = 240e3; % sps
  case {'N320/N321'}
    prmOTFSTx.MasterClockRate = 200e6; %Hz
    prmOTFSTx.Fs = 200e3; % sps
  otherwise
    error(message('sdru:examples:UnsupportedPlatform', ...
      platform))
end

% SDRu Transmitter System object
prmOTFSTx.USRPInterpolationFactor = ...
  prmOTFSTx.MasterClockRate/prmOTFSTx.Fs; 

prmOTFSTx.USRPFrameLength         = 2306;     % samples
prmOTFSTx.USRPTxCenterFrequency   = rfTxFreq; % Hz
prmOTFSTx.USRPGain                = 25;       % dB
prmOTFSTx.TotalFrames             = 2000;     % frames

% Sine wave
prmOTFSTx.SineAmplitude           = 0.1;
prmOTFSTx.SineFrequency           = bbTxFreq; % 100Hz
prmOTFSTx.SineComplexOutput       = true;
prmOTFSTx.SineOutputDataType      = 'double';
prmOTFSTx.SineFrameLength         = 4000;
