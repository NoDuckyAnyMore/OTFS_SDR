% function [] = OTFS_SDR_Rx()
% clear system object
if exist('radio','var')
    release(radio);
    clear radio
end
OTFS_SigGen_V4
%% OTFS parameters%%%%%%%%%%
% set on SigGen
pilot = pilot(np,mp);
%% Search available SDR
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
% Baseband and RF configuration calibration need!!!
fo = -2.6e3;                     % Frequency offset
rfRxFreq           = 4e9 + fo;  % Nominal RF receive center frequency
bbRxFreq           = 20e3;     % Received baseband sine wave frequency

prmOTFSRx = configureOTFSRx(platform, rfRxFreq, bbRxFreq);


switch platform
    case {'B200','B210'}
        radio = comm.SDRuReceiver(...
            'Platform',         platform, ...
            'SerialNum',        address, ...
            'MasterClockRate',  prmOTFSRx.MasterClockRate, ...
            'CenterFrequency',  prmOTFSRx.RxCenterFrequency,...
            'Gain',             prmOTFSRx.Gain, ...
            'DecimationFactor', prmOTFSRx.DecimationFactor,...
            'SamplesPerFrame',  prmOTFSRx.FrameLength,...
            'OutputDataType',   prmOTFSRx.OutputDataType)
    case {'X300','X310','N300','N310','N320/N321'}
        radio = comm.SDRuReceiver(...
            'Platform',         platform, ...
            'IPAddress',        address, ...
            'MasterClockRate',  prmOTFSRx.MasterClockRate, ...
            'CenterFrequency',  prmOTFSRx.RxCenterFrequency,...
            'Gain',             prmOTFSRx.Gain, ...
            'DecimationFactor', prmOTFSRx.DecimationFactor,...
            'SamplesPerFrame',  prmOTFSRx.FrameLength,...
            'OutputDataType',   prmOTFSRx.OutputDataType)
    case {'N200/N210/USRP2'}
        radio = comm.SDRuReceiver(...
            'Platform',         platform, ...
            'IPAddress',        address, ...
            'CenterFrequency',  prmOTFSRx.RxCenterFrequency,...
            'Gain',             prmOTFSRx.Gain, ...
            'DecimationFactor', prmOTFSRx.DecimationFactor,...
            'SamplesPerFrame',  prmOTFSRx.FrameLength,...
            'OutputDataType',   prmOTFSRx.OutputDataType)
end


% Create preamble detector object
preamble = zadoffChuSeq(25,193);
thr = 0.4*sum(abs(preamble).^2);
prbdet = comm.PreambleDetector( ...
    Preamble=preamble, ...
    Threshold=thr, ...
    Detections='All');
% Create raised cosine receive filter
RolloffFactor = 0.5;
RaisedCosineFilterSpan = 10;
UpsamplingFactor = 5;
DecimationFactor = 5;
RxFilter = comm.RaisedCosineReceiveFilter( ...
    'RolloffFactor',            RolloffFactor, ...
    'FilterSpanInSymbols',      RaisedCosineFilterSpan, ...
    'InputSamplesPerSymbol',    UpsamplingFactor, ...
    'DecimationFactor',         DecimationFactor);
%% Stream Processing
radio.EnableBurstMode = true;
radio.NumFramesInBurst = 1;
% Check for the status of the USRP(R) radio
if radioFound
    validcount = 0;
    rxcount = 0;
    asynchronouscount = 0;
    txbits = 0;
    err_all_uncoded = 0;
    BerUncoded = 0;
    BerCoded = 0;
    dt = datestr(now,'yyyy_mm_dd HH_MM_SS ');
    folderName = [dt,'RxGain_',num2str(prmOTFSRx.Gain),'\'];
    mkdir(folderName)
    fileName = [folderName,'parameter.mat'];
    save(fileName,'M','N','prmOTFSRx','mp','np','M_mod','Md','Mz','pilot')

    while(1)
        [prxSig, len, overrun] = radio();
        if len > 0 % && overrun == 0
            rxSig = RxFilter(prxSig);
            % preamble detection
            AGCSig = rxSig;
            [idx,detmet] = prbdet(AGCSig);
            [detmetSort,i] = sort(detmet,'descend');
            [sorti,I] = sort(i(1:4),'ascend');
            beginPayload = sorti(1)+Nzp;
            % try to locate OTFS frame
            try
                rxs = AGCSig(beginPayload+1:beginPayload+length(s));
            catch
                disp('rx fail')
                continue
            end
            rxcount = rxcount + 1;
            % check validity of pilot
            [doppler,delay] = find(abs(y)==max(max(abs(y))));
            if delay>mp-2+Mz+Md && delay<mp+2+Mz+Md %if vaild
                % record original pulse shaped signal
                filename = [folderName,num2str(validcount),'RxValid.mat'];
                save(filename,'prxSig')
                % count valid receive frame
                validcount = validcount + 1;
                % display time domain signal preamble detection and receive
                % DD grid
                figure(1)
                subplot(311)
                plot(real(rxSig))
                title('RxSig')
                subplot(312)
                plot(detmet)
                title('PreambleDetection')
                subplot(313)
                h = bar3(abs(y));
                set(h,'edgecolor',[0.8, 0.8, 0.8])
                title('RxDD')
                view([8.141209983795346,25.828378185531555])
                set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.64])
                
                x_est = Fractional_Doppler_Decoder(M,N,y,pilot,np,Md,mp,Mz,Ncp);

              
                % calc ber
                xr = reshape(x_est(1:N,1+Mz:Md+Mz),N_syms_perfram,1);
                data_info_est = qamdemod(xr,M_mod,'OutputType','bit', ...
                    'UnitAveragePower',true,'NoiseVariance',1e-2); % QAM demodulation

                compare = xor(data_info_est,data_info_bit);
                compareU = zeros(length(compare)/M_bits,1);
                for idxc = 1:length(compareU)
                    compareU(idxc) = sum(compare(M_bits*idxc-1:M_bits*idxc+M_bits-2));
                end
                errmap = reshape(compareU,N,Md);
                errors = sum(compare);
                % err_vec(end+1) = errors;
                err_all_uncoded = errors + err_all_uncoded;
                txbits = txbits + N_bits_perfram;
                BerUncoded = err_all_uncoded/txbits;

                if isequal('LTE',channelCoding)
                    % Soft Detection
                    softBits =  qamdemod(xr,M_mod,'OutputType','approxllr', ...
                        'UnitAveragePower',true,'NoiseVariance',1e-2);
                    % Descrambling
                    rxDescrambledBits = hScrambler.descramble(softBits);
                    % Dechannel coding
                    [rxUncodedBits, blockError] = hChannelCoder.decode(rxDescrambledBits);
                    numBitErrors = sum(xor(UncodedBits, rxUncodedBits));
                    err_all_coded = numBitErrors + err_all_coded;
                    txBitsCoded = txBitsCoded + tbs;
                    BerCoded = err_all_coded/txBitsCoded;
                end
            else
                disp('sync fail')
                filename = [folderName,num2str(asynchronouscount),'RxFail.mat'];
                save(filename,'prxSig')
                asynchronouscount = asynchronouscount + 1;
            end
            disp(['Try to receive ',num2str(validcount),' frames ', num2str(100*asynchronouscount/rxcount),'% frames fail to sync, ','BerUncoded = ',num2str(BerUncoded),...
                'BerCoded = ',num2str(BerCoded)])
        end
    end
else
    warning(message('sdru:sysobjdemos:MainLoop'))
end



