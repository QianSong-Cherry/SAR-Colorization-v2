function P = my_imrgb(R,G,B)
%
%   plot pauli sar image
%
R = log10(squeeze(R));
G = log10(squeeze(G));
B = log10(squeeze(B));

R(R>13) = 13; R(R<9) = 9;
G(G>12) = 12; G(G<8) = 8;
B(B>12) = 12; B(B<9) = 9;

R = uint16((R - 9)./4*65535);
G = uint16((G - 8)./4*65535);
B = uint16((B - 9)./3*65535);

P(:,:,1) = uint8( R/256 );
P(:,:,2) = uint8( G/256 );
P(:,:,3) = uint8( B/256 );

% figure;
imshow(P)