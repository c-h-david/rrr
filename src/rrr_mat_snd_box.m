%WARNING! 
%This open-source code uses the following proprietary software: 
%(Matlab R2019b)
%*******************************************************************************
%rrr_mat_snd_box.m
%*******************************************************************************

%Purpose:
%This sand box allows Matlab manipulation of some matrices that are used in
%RAPID.
%Author:
%Cedric H. David, 2020-2020


%*******************************************************************************
%Declaration of variables
%*******************************************************************************
clear all

rrr_con_csv='../output/San_Guad_JHM2/rapid_connect_San_Guad.csv';
rrr_bas_csv='../output/San_Guad_JHM2/riv_bas_id_San_Guad_hydroseq.csv';
rrr_msk_csv='../output/San_Guad_JHM2/k_San_Guad_2004_1.csv';
rrr_kfc_csv='../output/San_Guad_JHM2/kfac_San_Guad_1km_hour.csv';
rrr_msx_csv='../output/San_Guad_JHM2/x_San_Guad_2004_1.csv';
ZS_dtR=900;
ZS_dtM=86400;


%*******************************************************************************
%Read connectivity file
%*******************************************************************************
rrr_con_tbl=readmatrix(rrr_con_csv,'Delimiter',',');
IV_riv_tot_id=int32(rrr_con_tbl(:,1));
IV_down=int32(rrr_con_tbl(:,2));
IS_riv_tot=length(IV_riv_tot_id);


%*******************************************************************************
%Read k file
%*******************************************************************************
rrr_msk_tbl=readmatrix(rrr_msk_csv,'Delimiter',',');
ZV_k=rrr_msk_tbl(:,1);


%*******************************************************************************
%Read x file
%*******************************************************************************
rrr_msx_tbl=readmatrix(rrr_msx_csv,'Delimiter',',');
ZV_x=rrr_msx_tbl(:,1);


%*******************************************************************************
%Read kfac file
%*******************************************************************************
rrr_kfc_tbl=readmatrix(rrr_kfc_csv,'Delimiter',',');
ZV_kfc=rrr_kfc_tbl(:,1);
ZV_Lkm=ZV_kfc*1/3600;


%*******************************************************************************
%Read basin file
%*******************************************************************************
rrr_bas_tbl=readmatrix(rrr_bas_csv,'Delimiter',',');
IV_riv_bas_id=int32(rrr_bas_tbl(:,1));
IS_riv_bas=length(IV_riv_bas_id);


%*******************************************************************************
%Create hash tables
%*******************************************************************************
IM_hsh_tot=containers.Map('KeyType','int32','ValueType','int32');
for JS_riv_tot=1:IS_riv_tot
    IM_hsh_tot(IV_riv_tot_id(JS_riv_tot))=JS_riv_tot;
end

IM_hsh_bas=containers.Map('KeyType','int32','ValueType','int32');
for JS_riv_bas=1:IS_riv_bas
    IM_hsh_bas(IV_riv_bas_id(JS_riv_bas))=JS_riv_bas;
end


%*******************************************************************************
%Create connectivity matrix
%*******************************************************************************
ZM_Net=sparse(IS_riv_bas,IS_riv_bas);

for JS_riv_bas=1:IS_riv_bas
    if IV_down(IM_hsh_tot(IV_riv_bas_id(JS_riv_bas)))~=0
        ZM_Net(IM_hsh_bas(IV_down(IM_hsh_tot(IV_riv_bas_id(JS_riv_bas)))), ...
               JS_riv_bas)=1;
    end 
end


%*******************************************************************************
%Create parameter matrices
%*******************************************************************************
ZV_C1=zeros(IS_riv_bas,1);
ZV_C2=zeros(IS_riv_bas,1);
ZV_C3=zeros(IS_riv_bas,1);

for JS_riv_bas=1:IS_riv_bas
    ZS_k=ZV_k(IM_hsh_tot(IV_riv_bas_id(JS_riv_bas)));
    ZS_x=ZV_x(IM_hsh_tot(IV_riv_bas_id(JS_riv_bas)));
    ZS_den=ZS_k*(1-ZS_x)+ZS_dtR/2;
    ZV_C1(JS_riv_bas)=(ZS_dtR/2-ZS_k*ZS_x)/ZS_den;
    ZV_C2(JS_riv_bas)=(ZS_dtR/2+ZS_k*ZS_x)/ZS_den;
    ZV_C3(JS_riv_bas)=(-ZS_dtR/2+ZS_k*(1-ZS_x))/ZS_den;
end

ZM_C1=sparse(diag(ZV_C1));
ZM_C2=sparse(diag(ZV_C2));
ZM_C3=sparse(diag(ZV_C3));


%*******************************************************************************
%Create identity matrix
%*******************************************************************************
ZM_I=sparse(eye(IS_riv_bas));


%*******************************************************************************
%Muskingum operator and associated 0-1 matrix
%*******************************************************************************
ZM_Mus=(ZM_I-ZM_C1*ZM_Net)^-1;
ZM_inN=(ZM_I-ZM_Net)^-1;


%*******************************************************************************
%Full network observation operator (used for data assimilation)
%*******************************************************************************
IS_avg=ZS_dtM/ZS_dtR;
ZM_alp=ZM_Mus*(ZM_C3+ZM_C2*ZM_Net);
ZM_bet=ZM_Mus*(ZM_C1+ZM_C2);

%-------------------------------------------------------------------------------
%Using Equation (7) in Emery et al. (2020)
%-------------------------------------------------------------------------------
ZM_Ae1=sparse(IS_riv_bas,IS_riv_bas);
for JS_avg=0:IS_avg-1
    ZM_Ae1=ZM_Ae1+(IS_avg-JS_avg)/(IS_avg)*ZM_alp^JS_avg;
end
ZM_Ae1=ZM_Ae1*ZM_bet;

%-------------------------------------------------------------------------------
%With formula for summing the first terms in arithmetic-geometric sequence
%-------------------------------------------------------------------------------
ZM_Ae2=((IS_avg+1)/IS_avg*ZM_I ... 
                        -1/IS_avg*(ZM_I-ZM_alp)^-1*(ZM_I-ZM_alp^(IS_avg+1))) ...
      *(ZM_I-ZM_alp)^-1*ZM_bet;
  
%-------------------------------------------------------------------------------
%Charlotte's approximation
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%Potential approximations
%-------------------------------------------------------------------------------
ZM_At2=((IS_avg+1)/IS_avg*ZM_I ... 
                        -1/IS_avg*(ZM_I-ZM_alp)^-1*(ZM_I                  )) ...
      *(ZM_I-ZM_alp)^-1*ZM_bet;
  
ZM_At3=((IS_avg+1)/IS_avg*ZM_I ... 
                        -1/IS_avg*(ZM_I-ZM_alp)^-1*(    -ZM_alp^(IS_avg+1))) ...
      *(ZM_I-ZM_alp)^-1*ZM_bet;
  
ZM_At4=((IS_avg+1)/IS_avg*ZM_I ... 
                        -1/IS_avg*(ZM_alp^(IS_avg)                        )) ...
      *(ZM_I-ZM_alp)^-1*ZM_bet;
  
  
%*******************************************************************************
%Matrix of interest
%*******************************************************************************
ZM_plt=ZM_Ae2;


%*******************************************************************************
%Display image of matrix
%*******************************************************************************
ZM_Ful=full(log10(abs(ZM_plt)));
fig02=imshow(ZM_Ful);
colorbar
colormap jet
caxis([-17 -1])
set(fig02,'AlphaData',~full(ZM_plt)==0)


%*******************************************************************************
%Display one column of matrix
%*******************************************************************************

%-------------------------------------------------------------------------------
%Abscissa - Cumulative length downstream of the given river reach
%-------------------------------------------------------------------------------
IV_inN=find(ZM_inN(:,1));
IS_inN=length(IV_inN);
IV_Lkm=zeros(IS_inN,1);
for JS_inN=1:IS_inN
    IV_Lkm(JS_inN)=IM_hsh_tot(IV_riv_bas_id(IV_inN(JS_inN)));
end

ZV_cumLkm=zeros(IS_inN,1);
ZV_cumLkm=ZV_Lkm(IV_Lkm);
for JS_inN=2:IS_inN
    ZV_cumLkm(JS_inN)=ZV_cumLkm(JS_inN)+ZV_cumLkm(JS_inN-1);
end

%-------------------------------------------------------------------------------
%Ordinate - Matrix 
%-------------------------------------------------------------------------------
ZV_plt=ZM_plt(IV_inN,1);

%-------------------------------------------------------------------------------
%Plot
%-------------------------------------------------------------------------------
plot(ZV_cumLkm,ZV_plt);
axis([min(ZV_cumLkm) max(ZV_cumLkm) -2 2])


%*******************************************************************************
%Analysis tips
%*******************************************************************************
%max(full(ZM_Mus),[],'all')
%min(full(ZM_Mus),[],'all')
%length(find(ZM_Mus<0))
%length(find(ZM_Mus>0))
%spy(ZM_Mus)
%imshow(full(ZM_Mus))
%imshow(full(ZM_Mus),[])
%imshow(full(ZM_Mus),jet)
%colorbar('Direction','reverse')
%colorbar('Direction','normal')
%colormap jet
%colormap jet(5)
%caxis([-1 1])


%*******************************************************************************
%Clean Workspace
%*******************************************************************************
clear rrr_bas_csv rrr_bas_tbl
clear rrr_con_csv rrr_con_tbl
clear rrr_msk_csv rrr_msk_tbl
clear rrr_msx_csv rrr_msx_tbl
clear rrr_kfc_csv rrr_kfc_tbl
clear JS_riv_bas JS_riv_tot JS_avg JS_inN
clear ZS_den ZS_k ZS_x


%*******************************************************************************
%End
%*******************************************************************************
