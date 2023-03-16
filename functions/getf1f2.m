function [f1, f2] = getf1f2(K)
%GETF1F2 Turbo code internal interleaver parameters look-up for f1 and f2.
%
%   [F1, F2] = getf1f2(BLKLEN) returns the f1 and f2 parameter values for
%   a specified block length, BLKLEN, to be used in the turbo code internal
%   interleaver.
%
%   See also helperLTEIntrlvrIndices.

%   Reference:
%   3GPP TS 36.212 v9.0.0, "3rd Generation partnershiop project;
%   Technical specification group radio access network; Evolved Universal
%   Terrestrial Radio Acess (E-UTRA); Multiplexing and channel coding
%   (release 9)", 2009-12.

%   Copyright 2010-2020 The MathWorks, Inc.

%#codegen
% Allowed values of K
validK = [40:8:512 528:16:1024 1056:32:2048 2112:64:6144];
assert(ismember(K, validK), 'comm:getf1f2:InvalidBlkLen', ...
      ['Invalid block length specified. The block length must be one',...
       ' out of [40:8:512 528:16:1024 1056:32:2048 2112:64:6144] values.']); 

% Interleaver parameters
%   Refer to Table 5.1.3-3 of the reference
f1 = 1; f2 = 1; % dummy values
switch K
    case 40
        f1 = 3; f2 = 10;
    case 48
        f1 = 7; f2 = 12;
    case 56
        f1 = 19; f2 = 42;
    case 64
        f1 = 7; f2 = 16;
    case 72
        f1 = 7; f2 = 18;
    case 80
        f1 = 11; f2 = 20;
    case 88
        f1 = 5; f2 = 22;
    case 96
        f1 = 11; f2 = 24;
    case 104
        f1 = 7; f2 = 26;
    case 112
        f1 = 41; f2 = 84;
    case 120
        f1 = 103; f2 = 90;
    case 128
        f1 = 15; f2 = 32;
    case 136
        f1 = 9; f2 = 34;
    case 144
        f1 = 17; f2 = 108;
    case 152
        f1 = 9; f2 = 38;
    case 160
        f1 = 21; f2 = 120;
    case 168
        f1 = 101; f2 = 84;
    case 176
        f1 = 21; f2 = 44;
    case 184
        f1 = 57; f2 = 46;
    case 192
        f1 = 23; f2 = 48;
    case 200
        f1 = 13; f2 = 50;
    case 208
        f1 = 27; f2 = 52;
    case 216
        f1 = 11; f2 = 36;
    case 224
        f1 = 27; f2 = 56;
    case 232
        f1 = 85; f2 = 58;
    case 240
        f1 = 29; f2 = 60;
    case 248
        f1 = 33; f2 = 62;
    case 256
        f1 = 15; f2 = 32;
    case 264
        f1 = 17; f2 = 198;
    case 272
        f1 = 33; f2 = 68;
    case 280
        f1 = 103; f2 = 210;
    case 288
        f1 = 19; f2 = 36;
    case 296
        f1 = 19; f2 = 74;
    case 304
        f1 = 37; f2 = 76;
    case 312
        f1 = 19; f2 = 78;
    case 320
        f1 = 21; f2 = 120;
    case 328
        f1 = 21; f2 = 82;
    case 336
        f1 = 115; f2 = 84;
    case 344
        f1 = 193; f2 = 86;
    case 352
        f1 = 21; f2 = 44;
    case 360
        f1 = 133; f2 = 90;
    case 368
        f1 = 81; f2 = 46;
    case 376
        f1 = 45; f2 = 94;
    case 384
        f1 = 23; f2 = 48;
    case 392
        f1 = 243; f2 = 98;
    case 400
        f1 = 151; f2 = 40;
    case 408
        f1 = 155; f2 = 102;
    case 416
        f1 = 25; f2 = 52;
    case 424
        f1 = 51; f2 = 106;
    case 432
        f1 = 47; f2 = 72;
    case 440
        f1 = 91; f2 = 110;
    case 448
        f1 = 29; f2 = 168;
    case 456
        f1 = 29; f2 = 114;
    case 464
        f1 = 247; f2 = 58;
    case 472
        f1 = 29; f2 = 118;
    case 480
        f1 = 89; f2 = 180;
    case 488
        f1 = 91; f2 = 122;
    case 496
        f1 = 157; f2 = 62;
    case 504
        f1 = 55; f2 = 84;
    case 512
        f1 = 31; f2 = 64;
    case 528
        f1 = 17; f2 = 66;
    case 544
        f1 = 35; f2 = 68;
    case 560
        f1 = 227; f2 = 420;
    case 576
        f1 = 65; f2 = 96;
    case 592
        f1 = 19; f2 = 74;
    case 608
        f1 = 37; f2 = 76;
    case 624
        f1 = 41; f2 = 234;
    case 640
        f1 = 39; f2 = 80;
    case 656
        f1 = 185; f2 = 82;
    case 672
        f1 = 43; f2 = 252;
    case 688
        f1 = 21; f2 = 86;
    case 704
        f1 = 155; f2 = 44;
    case 720
        f1 = 79; f2 = 120;
    case 736
        f1 = 139; f2 = 92;
    case 752
        f1 = 23; f2 = 94;
    case 768
        f1 = 217; f2 = 48;
    case 784
        f1 = 25; f2 = 98;
    case 800
        f1 = 17; f2 = 80;
    case 816
        f1 = 127; f2 = 102;
    case 832
        f1 = 25; f2 = 52;
    case 848
        f1 = 239; f2 = 106;
    case 864
        f1 = 17; f2 = 48;
    case 880
        f1 = 137; f2 = 110;
    case 896
        f1 = 215; f2 = 112;
    case 912
        f1 = 29; f2 = 114;
    case 928
        f1 = 15; f2 = 58;
    case 944
        f1 = 147; f2 = 118;
    case 960
        f1 = 29; f2 = 60;
    case 976
        f1 = 59; f2 = 122;
    case 992
        f1 = 65; f2 = 124;
    case 1008
        f1 = 55; f2 = 84;
    case 1024
        f1 = 31; f2 = 64;
    case 1056
        f1 = 17; f2 = 66;
    case 1088
        f1 = 171; f2 = 204;
    case 1120
        f1 = 67; f2 = 140;
    case 1152
        f1 = 35; f2 = 72;
    case 1184
        f1 = 19; f2 = 74;
    case 1216
        f1 = 39; f2 = 76;
    case 1248
        f1 = 19; f2 = 78;
    case 1280
        f1 = 199; f2 = 240;
    case 1312
        f1 = 21; f2 = 82;
    case 1344
        f1 = 211; f2 = 252;
    case 1376
        f1 = 21; f2 = 86;
    case 1408
        f1 = 43; f2 = 88;
    case 1440
        f1 = 149; f2 = 60;
    case 1472
        f1 = 45; f2 = 92;
    case 1504
        f1 = 49; f2 = 846;
    case 1536
        f1 = 71; f2 = 48;
    case 1568
        f1 = 13; f2 = 28;
    case 1600
        f1 = 17; f2 = 80;
    case 1632
        f1 = 25; f2 = 102;
    case 1664
        f1 = 183; f2 = 104;
    case 1696
        f1 = 55; f2 = 954;
    case 1728
        f1 = 127; f2 = 96;
    case 1760
        f1 = 27; f2 = 110;
    case 1792
        f1 = 29; f2 = 112;
    case 1824
        f1 = 29; f2 = 114;
    case 1856
        f1 = 57; f2 = 116;
    case 1888
        f1 = 45; f2 = 354;
    case 1920
        f1 = 31; f2 = 120;
    case 1952
        f1 = 59; f2 = 610;
    case 1984
        f1 = 185; f2 = 124;
    case 2016
        f1 = 113; f2 = 420;
    case 2048
        f1 = 31; f2 = 64;
    case 2112
        f1 = 17; f2 = 66;
    case 2176
        f1 = 171; f2 = 136;
    case 2240
        f1 = 209; f2 = 420;
    case 2304
        f1 = 253; f2 = 216;
    case 2368
        f1 = 367; f2 = 444;
    case 2432
        f1 = 265; f2 = 456;
    case 2496
        f1 = 181; f2 = 468;
    case 2560
        f1 = 39; f2 = 80;
    case 2624
        f1 = 27; f2 = 164;
    case 2688
        f1 = 127; f2 = 504;
    case 2752
        f1 = 143; f2 = 172;
    case 2816
        f1 = 43; f2 = 88;
    case 2880
        f1 = 29; f2 = 300;
    case 2944
        f1 = 45; f2 = 92;
    case 3008
        f1 = 157; f2 = 188;
    case 3072
        f1 = 47; f2 = 96;
    case 3136
        f1 = 13; f2 = 28;
    case 3200
        f1 = 111; f2 = 240;
    case 3264
        f1 = 443; f2 = 204;
    case 3328
        f1 = 51; f2 = 104;
    case 3392
        f1 = 51; f2 = 212;
    case 3456
        f1 = 451; f2 = 192;
    case 3520
        f1 = 257; f2 = 220;
    case 3584
        f1 = 57; f2 = 336;
    case 3648
        f1 = 313; f2 = 228;
    case 3712
        f1 = 271; f2 = 232;
    case 3776
        f1 = 179; f2 = 236;
    case 3840
        f1 = 331; f2 = 120;
    case 3904
        f1 = 363; f2 = 244;
    case 3968
        f1 = 375; f2 = 248;
    case 4032
        f1 = 127; f2 = 168;
    case 4096
        f1 = 31; f2 = 64;
    case 4160
        f1 = 33; f2 = 130;
    case 4224
        f1 = 43; f2 = 264;
    case 4288
        f1 = 33; f2 = 134;
    case 4352
        f1 = 477; f2 = 408;
    case 4416
        f1 = 35; f2 = 138;
    case 4480
        f1 = 233; f2 = 280;
    case 4544
        f1 = 357; f2 = 142;
    case 4608
        f1 = 337; f2 = 480;
    case 4672
        f1 = 37; f2 = 146;
    case 4736
        f1 = 71; f2 = 444;
    case 4800
        f1 = 71; f2 = 120;
    case 4864
        f1 = 37; f2 = 152;
    case 4928
        f1 = 39; f2 = 462;
    case 4992
        f1 = 127; f2 = 234;
    case 5056
        f1 = 39; f2 = 158;
    case 5120
        f1 = 39; f2 = 80;
    case 5184
        f1 = 31; f2 = 96;
    case 5248
        f1 = 113; f2 = 902;
    case 5312
        f1 = 41; f2 = 166;
    case 5376
        f1 = 251; f2 = 336;
    case 5440
        f1 = 43; f2 = 170;
    case 5504
        f1 = 21; f2 = 86;
    case 5568
        f1 = 43; f2 = 174;
    case 5632
        f1 = 45; f2 = 176;
    case 5696
        f1 = 45; f2 = 178;
    case 5760
        f1 = 161; f2 = 120;
    case 5824
        f1 = 89; f2 = 182;
    case 5888
        f1 = 323; f2 = 184;
    case 5952
        f1 = 47; f2 = 186;
    case 6016
        f1 = 23; f2 = 94;
    case 6080
        f1 = 47; f2 = 190;
    case 6144
        f1 = 263; f2 = 480;
end

% [EOF]
