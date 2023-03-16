if exist('radio','var') % clear system obj if exist
release (radio);
clear radio
end

connectedRadios = findsdru;
if strncmp(connectedRadios(1).Status, 'Success', 7)
  radioFound = true;
  platform = connectedRadios(1).Platform;
  switch connectedRadios(1).Platform
    case {'B200','B210'}
      address = connectedRadios(1).SerialNum;
    case {'N200/N210/USRP2','X300','X310','N300','N310','N320/N321'}
      address = connectedRadios(1).IPAddress;
  end
else
  radioFound = false;
  address = '192.168.10.2';
  platform = 'N200/N210/USRP2';
end

%% Initialization
% Set the properties of the sine wave source, the SDRu transmitter, and the
% spectrum analyzer System object.

bbTxFreq = 100;    % Transmitted baseband frequency
rfTxFreq = 4e9; % Nominal RF transmit center frequency

prmOTFSTx = configureOTFSTx(platform, rfTxFreq, bbTxFreq);

hSineSource = dsp.SineWave (...
    'Frequency',           prmOTFSTx.SineFrequency, ...
    'Amplitude',           prmOTFSTx.SineAmplitude,...
    'ComplexOutput',       prmOTFSTx.SineComplexOutput, ...
    'SampleRate',          prmOTFSTx.Fs, ...
    'SamplesPerFrame',     prmOTFSTx.SineFrameLength, ...
    'OutputDataType',      prmOTFSTx.SineOutputDataType);

% The host computer communicates with the USRP(R) radio using the SDRu
% transmitter System object. B200 and B210 series USRP(R) radios are
% addressed using a serial number while USRP2, N200, N210, X300 and X310
% radios are addressed using an IP address. The parameter structure,
% prmFreqCalibTx, sets the CenterFrequency, Gain, and InterpolationFactor
% arguments.

% Set up radio object to use the found radio
switch platform
  case {'B200','B210'}
    radio = comm.SDRuTransmitter( ...
      'Platform',             platform, ...
      'SerialNum',            address, ...
      'MasterClockRate',      prmOTFSTx.MasterClockRate, ...
      'CenterFrequency',      prmOTFSTx.USRPTxCenterFrequency, ...
      'Gain',                 prmOTFSTx.USRPGain,...
      'InterpolationFactor',  prmOTFSTx.USRPInterpolationFactor)
  case {'X300','X310','N300','N310','N320/N321'}
    radio = comm.SDRuTransmitter( ...
      'Platform',             platform, ...
      'IPAddress',            address, ...
      'MasterClockRate',      prmOTFSTx.MasterClockRate, ...
      'CenterFrequency',      prmOTFSTx.USRPTxCenterFrequency, ...
      'Gain',                 prmOTFSTx.USRPGain,...
      'InterpolationFactor',  prmOTFSTx.USRPInterpolationFactor)
  case {'N200/N210/USRP2'}
    radio = comm.SDRuTransmitter( ...
      'Platform',             platform, ...
      'IPAddress',            address, ...
      'CenterFrequency',      prmOTFSTx.USRPTxCenterFrequency, ...
      'Gain',                 prmOTFSTx.USRPGain,...
      'InterpolationFactor',  prmOTFSTx.USRPInterpolationFactor)
end


% Use dsp.SpectrumAnalyzer to display the spectrum of the transmitted
% signal.
% hSpectrumAnalyzer = dsp.SpectrumAnalyzer(...
%     'Name',                'Frequency of the Sine waveform sent out',...
%     'Title',               'Frequency of the Sine waveform sent out',...
%     'FrequencySpan',       'Full', ...
%     'SampleRate',           prmOTFSTx.Fs, ...
%     'YLimits',              [-70,30],...
%     'SpectralAverages',     50, ...
%     'FrequencySpan',        'Start and stop frequencies', ...
%     'StartFrequency',       -100e3, ...
%     'StopFrequency',        100e3,...
%     'Position',             figposition([50 30 30 40]));

%% Stream Processing
%  Loop until the example reaches the target number of frames.
txcout = 0;
underruncout = 0;
% Check for the status of the USRP(R) radio
% radio.EnableBurstMode = true;
% radio.NumFramesInBurst = 20;
if radioFound
%     for iFrame = 1: prmFreqCalibTx.TotalFrames
    while(1)

        txwave = OTFS_SigGen_V1();
%         underrun = radio(txwave);
        disp(['Transmitting ',num2str(txcout),' frames ',num2str(underruncout),' underruns detectd'])
%         if underrun == 1
%             underruncout = underruncout + 1;
%         end
        step(radio, txwave); % transmit to USRP(R) radio
        
        txcout = txcout + 1;
    end
    % Display the spectrum after the simulation.
%     step(hSpectrumAnalyzer, sinewave);
else
    warning(message('sdru:sysobjdemos:MainLoop'))
end

%% Release System Objects
release (hSineSource);
release (radio);
clear radio

