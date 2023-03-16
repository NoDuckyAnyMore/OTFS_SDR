% function PSWave = OTFS_SigGen()
%% OTFS parameters%%%%%%%%%%
% number of symbol delay
N = 16; %8
% numebr of symbol used for data
Nd = 22;
% number of subcarriers doppler
M = 128;  %30
% numebr of subcarriers used for data
Mz = ceil(0.0666*M);
% Mz = 2;
Md = 100;
Nzp = 50;

%---- Channel Coding ----
channelCoding = 'LTE';
% channelCoding = 'None';

% size of constellation
M_mod = 4;
M_bits = log2(M_mod);
% average energy per data symbol
eng_sqrt = (M_mod==2)+(M_mod~=2)*sqrt((M_mod-1)/6*(2^2));
% number of symbols per frame
N_syms_perfram = N*Md;
% number of bits per frame
N_bits_perfram = N_syms_perfram*M_bits;

SNR_dB = 20;
SNR = 10.^(SNR_dB/10);
noise_var_sqrt = sqrt(1./SNR);
sigma_2 = abs(eng_sqrt*noise_var_sqrt).^2;
np = 8;
mp = 8;

RolloffFactor = 0.5;
RaisedCosineFilterSpan = 10;
UpsamplingFactor = 5;
DecimationFactor = 5;


% Parameter for LTE Channel Coder
turboDecodingNumIterations = 8;
codeRate = 0.5;  % Coding rate of source data bits over transmition redundant data bits
codedTransportBlockSize = N_bits_perfram * codeRate;
crcBitLength = 24;  % defined in 3GPP TS36.2xx
maxCodeBlockSize = 6144;  % defined in 3GPP TS36.2xx
numCodeBlockSegments = ceil((codedTransportBlockSize - crcBitLength) / maxCodeBlockSize);
if numCodeBlockSegments > 1
    tbs = codedTransportBlockSize-crcBitLength*(numCodeBlockSegments+1);  % CRC24A + CRC24B*numSegments
else
    tbs = codedTransportBlockSize-crcBitLength;  % CRC24A only
end

% Parameters for Scrambler
rnti = hex2dec('003D');
cellId = 0;
frameNo  = 0; % radio frame
codeword = 0;

% LTE Channel Coder
hChannelCoder = LteChannelCoder( ...
    'TurboDecodingNumIterations', turboDecodingNumIterations, ...
    'ModOrder', M_mod, ...
    'NumLayers', 1, ...
    'OutputLength', N_bits_perfram, ...
    'LinkDirection', 'Downlink', ...
    'RedundancyVersion', 0, ...
    'TBS', tbs);

% Scrambler
hScrambler = LteScrambler(rnti, cellId, frameNo, codeword);

%% Message input bits generation%%%%%
Message = 'Hello world'; % message in string
MessageLength = length(Message)+5; %saving position
MessageBitsLength = MessageLength*7; % 7bits per char
switch channelCoding
    case 'None'
        MessageNum = floor(N_bits_perfram/MessageBitsLength);
    case 'LTE'
        MessageNum = floor(tbs/MessageBitsLength);
end

Mest = zeros(MessageNum*MessageLength,1);
for i = 0:MessageNum -1 % add number after string message
    Mest(i * MessageLength + (1 : MessageLength)) = sprintf('%s %03d\n', Message, i);
end
MessageBits = de2bi(Mest,7,'left-msb'); % 336 in 352 bitstream
switch channelCoding
    case 'None'
        UncodedBits = MessageBits(:);
        txScrampledBits = MessageBits(:);
    case 'LTE'
        pad = zeros(tbs-length(MessageBits(:)),1);
        UncodedBits = [MessageBits(:);pad];
        % Channel Encoding
        txCodedBits = hChannelCoder.encode(UncodedBits);
        % Scrambler
        txScrampledBits = hScrambler.scramble(txCodedBits);
end



pad = zeros(N_bits_perfram-length(txScrampledBits(:)),1); %add zero pad to DD grid
TxBitStream = [txScrampledBits(:);pad];


% % Rx testing
% RxBitStream = TxBitStream;
% RxMessageBits = RxBitStream(1:length(MessageBits(:)));
% RxMessage = char(int8(bi2de(reshape(RxMessageBits,[],7),'left-msb')))';


% data_info_bit = randi([0,1],N_bits_perfram,1);
data_info_bit = TxBitStream;
length(data_info_bit(:));
data_temp = bi2de(reshape(data_info_bit,N_syms_perfram,M_bits)); % reshape the bitstream for 4QAM modulation
% x = qammod(data_temp,M_mod,'gray');  % 4QAM modulation
x = qammod(data_info_bit,M_mod,'InputType','bit','UnitAveragePower',true);  % 4QAM modulation
x = reshape(x,N,Md); % reshape the modulated data to DD grid
xz = zeros(N,Mz);
length(x(:));
pilot = zeros(N,M-Md-Mz);
pilot(np,mp) = 10+10i;% set pilot value and position
x = [xz,x,pilot]; %add pilot to DD grid

%% OTFS modulation%%%%
s = OTFS_modulation(N,M,x);
% s = awgn(s,SNR_dB);


%% pulse shaping
TransmitterFilter = comm.RaisedCosineTransmitFilter( ...
    'RolloffFactor',                RolloffFactor, ...
    'FilterSpanInSymbols',          RaisedCosineFilterSpan, ...
    'OutputSamplesPerSymbol',       UpsamplingFactor);

ps = TransmitterFilter(s);


RxFilter = comm.RaisedCosineReceiveFilter( ...
    'RolloffFactor',            RolloffFactor, ...
    'FilterSpanInSymbols',      RaisedCosineFilterSpan, ...
    'InputSamplesPerSymbol',    UpsamplingFactor, ...
    'DecimationFactor',         DecimationFactor);
prs = RxFilter(ps);

%% Signal design
preamble = zadoffChuSeq(25,193); % use zedoffchu sequence as preamble
zp = zeros(Nzp,1); % zp between frame

% s = s/max(abs(s));
% TxWave = [preamble;s;s;s;s];
% TxWave = [preamble;zp;s;zp;s;zp;s;zp;s;zp]; % origin IQ data
TxWave = [preamble;zp;s;s;]; % origin IQ data
% TxWave = [preamble;zp;s;zp;s;zp];
% PSWave = TransmitterFilter(TxWave); % after pulse shaping IQ data
PSWave = TxWave;
PSWave = TransmitterFilter(PSWave);
PSWave = PSWave/max(abs(PSWave)); % normalization





