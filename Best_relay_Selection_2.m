clear
clc

%%%%��������м̵Ķ��û�����%%%%
%%%%ʮ�����û�,�˸����û�,�˸���Ҫ�м�%%%%

%%%%���������puΪ���û�,suΪ���û�,srΪ��Ҫ�м�,rΪ�����ն�,dΪ�ν��նˣ�%%%%
%%%%I=20dBm%%%%
%���û�����
M=10;                  %���û��������ڻ����2��
I=0.1;                 %���û��ĸ��ſ���ֵ  
Pp=10;                 %���û�����  
Sigma_hir=0.6;         %pu->r,E(|hir|^2)=Sigma_ir
Sigma_hid=0.2;         %pu->d,E(|hid|^2)=Sigma_id
Sigma_hib=0.2;         %pu->sr,E(|hib|^2)=Sigma_ib
Theta_ir=1;
Theta_ie=0.7;

%���û�����
N=8;                   %���û��������ڻ����2��
P=10^0.2;              %���û��ķ��书��P
Sigma_hjb=1;           %su->sr,E(|hjb|^2)=Sigma_jb
Sigma_hjr=0.2;         %su->r,E(|hjr|^2)=Sigma_jr
Theta_jb=1;
Theta_je=0.7;

%��Ҫ�м̲���
R=8;                   %��Ҫ�м��������ڻ����2��
P=10^0.2;              %��Ҫ�м̵ķ��书��P
Sigma_hbd=1;           %sr->d,E(|hbd|^2)=Sigma_bd
Sigma_hbr=0.2;         %sr->r,E(|hbr|^2)=Sigma_br
Theta_bd=1;
Theta_be=0.7;

%��������
L=10000;               %ʵ�����
N0=0.1;                %���Ը�˹����������
k=1;

for MER=-10:2:30                                                           %MER��main-to-eavesdropper ratio             
    lambda=10^(MER/10);                                                    %dB��Ϊʮ������
    Sigma_hie=Sigma_hir*Theta_ie/(Theta_ir*lambda);
    Sigma_hje=Sigma_hjb*Theta_je/(Theta_jb*lambda);
    Sigma_hbe=Sigma_hbd*Theta_be/(Theta_bd*lambda);

    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(M,L)+sqrt(-Sigma_hir/2)*randn(M,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(M,L)+sqrt(-Sigma_hie/2)*randn(M,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(M,L)+sqrt(-Sigma_hid/2)*randn(M,L);        %���û�����Ҫ���ն˵��ŵ�
    hib=sqrt(Sigma_hib/2)*randn(M,L)+sqrt(-Sigma_hib/2)*randn(M,L);        %���û�����Ҫ�м̵��ŵ�
      
    %���û��ŵ�˥��ϵ��%%%%
    hjb=sqrt(Sigma_hjb/2)*randn(N,L)+sqrt(-Sigma_hjb/2)*randn(N,L);        %���û�����Ѵ�Ҫ�м̵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(N,L)+sqrt(-Sigma_hje/2)*randn(N,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(N,L)+sqrt(-Sigma_hjr/2)*randn(N,L);        %���û��������ն˵��ŵ�
  
    %��Ҫ�м��ŵ�˥��ϵ��%%%%
    hbd=sqrt(Sigma_hbd/2)*randn(R,L)+sqrt(-Sigma_hbd/2)*randn(R,L);        %��Ҫ�м̵���Ҫ���ն˵��ŵ�
    hbe=sqrt(Sigma_hbe/2)*randn(R,L)+sqrt(-Sigma_hbe/2)*randn(R,L);        %��Ҫ�м̵������ߵ��ŵ�
    hbr=sqrt(Sigma_hbr/2)*randn(R,L)+sqrt(-Sigma_hbr/2)*randn(R,L);        %��Ҫ�м̵������ն˵��ŵ�
    
    %%%%�ڶ���ʱ϶ʱ���û�����Ҫ�м̵ı�������%%%%
    Temp2=zeros(M*R,L);
    Temp3=zeros(M*R,L);
    Temp4=zeros(R*M,L);
    Temp5=zeros(R*M,L);
    Temp_pu_sc_2=zeros(M*R,L);
    Temp_sr_sc=zeros(M*R,L);
    M_pu_R_sr_joint_sc=zeros(M*R,L);
    Pb=zeros(R,L);
   
    %%%%��Ҫ�м̷��书�ʵ�����%%%%
    for r=1:R
        for m=1:L 
            Pb(r,m)=min(P,I/(abs(hbr(r,m)^2)));                            %��Ҫ��P����
        end
    end
        
    %%%%����M*R����������Ѵ�Ҫ�м̽���ѡȡ%%%%
    a=1;
    for i=1:1:M
        for r=1:1:R
           Temp2(r,:)=log(1+(Pp*abs(hir(i,:)).^2)./(Pb(r,:).*(abs(hbr(r,:)).^2)+N0));                                                   %���û��������ն˵����ŵ�����
           Temp3(r,:)=log(1+(Pp*abs(hie(i,:)).^2)./(Pb(r,:).*(abs(hbe(r,:)).^2)+N0));                                                   %���û��������ŵ�����
           Temp4(r,:)=0.5*log(1+(Pb(r,:).*(abs(hbd(r,:)).^2))./(Pp*abs(hid(i,:)).^2+N0));                                               %��Ҫ�м����ν��ն˵����ŵ�����
           Temp5(r,:)=0.5*log(1+(Pb(r,:).*(abs(hbe(r,:)).^2))./(Pp*abs(hie(i,:)).^2+N0));                                               %��Ҫ�м̵������ŵ�����
           Temp_pu_sc_2(a,:)=(Temp2(r,:)-Temp3(r,:)<0).*0+(Temp2(r,:)-Temp3(r,:)>=0).*(Temp2(r,:)-Temp3(r,:));                          %���û��ı��������������ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_sr_sc(a,:)=(Temp4(r,:)-Temp5(r,:)<0).*0+(Temp4(r,:)-Temp5(r,:)>=0).*(Temp4(r,:)-Temp5(r,:));                            %��Ҫ�м̵ı�������
           M_pu_R_sr_joint_sc(a,:)=Temp_pu_sc_2(a,:)+Temp_sr_sc(a,:);                                                                 %��i�����û����r����Ҫ�м̵ı�������֮��
           a=a+1; 
        end     
    end
        
    %%%%�����ֵ����Ӧ����%%%%
    [Temp_2 Location_pu_sr]=max(M_pu_R_sr_joint_sc);                       %M*R�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵTemp,Location_pu_sr��¼���ֵTemp��������
   
    %%%%ȷ��max��Ӧ��������û�%%%%
    Location_pu=zeros(1,L);
    for m=1:L
        if(mod(Location_pu_sr(1,m),R)~=0)
            Location_pu(1,m)=fix(Location_pu_sr(1,m)/R)+1;                 %max��Ӧ�����������û������������������fix(Location_pu_sr(1,m)/R)+1�����û�Ϊ������û�
        else
            Location_pu(1,m)=fix(Location_pu_sr(1,m)/R);                   %max��Ӧ�����������û��������������������fix(Location_pu_sr(1,m)/R)�����û�Ϊ������û�
        end
    end
            
    %%%%ȷ��max��Ӧ����Ѵ�Ҫ�м�%%%%
    Location_sr=rem(Location_pu_sr,R);                                     %max��Ӧ�����������û�����������Ϊ�㣬���R����Ҫ�м�Ϊ��Ӧ��Ѵ�Ҫ�м�
    Location_sr(Location_sr==0)=R;                                         %��������Ϊ�㣬���rem(Location_pu_sr,M)
    
    %%%%�ֱ����max��Ӧ��������û�����Ѵ�Ҫ�м̵İ�ȫ����%%%%
    a=1;
    Temp_pu_sc=zeros(1,L);
    Temp_pu_sc_2=zeros(1,L);
    Temp_sr_sc=zeros(1,L);
    for m=1:L
        Temp_pu_sc(1,a)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Pb(Location_sr(1,m),m)*(abs(hbr(Location_sr(1,m),m))^2)+N0))-log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Pb(Location_sr(1,m),m)*(abs(hbe(Location_sr(1,m),m))^2)+N0));         %Location_pu(1,m)��ʾ��m��ʵ��ʱ��Location_pu(1,m)�����û�Ϊ������û� 
        Temp_sr_sc(1,a)=0.5*log(1+(Pb(Location_sr(1,m),m)*(abs(hbd(Location_sr(1,m),m))^2))/(Pp*abs(hid(Location_pu(1,m),m))^2+N0))-0.5*log(1+(Pb(Location_sr(1,m),m)*(abs(hbe(Location_sr(1,m),m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));
        Temp_pu_sc_2(1,a)=(Temp_pu_sc(1,a)<0)*0+(Temp_pu_sc(1,a)>=0)*Temp_pu_sc(1,a);
        Temp_sr_sc(1,a)=(Temp_sr_sc(1,a)<0)*0+(Temp_sr_sc(1,a)>=0)*Temp_sr_sc(1,a);
        a=a+1;
    end
    
    Cs_M_pu_sc_2(k)=sum(Temp_pu_sc_2)/L;                                   %MERΪĳһֵʱ��������û��İ�ȫ������ֵ
    Cs_R_sr_sc(k)=sum(Temp_sr_sc)/L;                                       %MERΪĳһֵʱ����Ѵ�Ҫ�м̵İ�ȫ������ֵ
 
    
    
    %%%%��һ��ʱ϶ʱ������û�����Ҫ�û��ı�������%%%%
    %%%%ע:���û�����Ҫ�м���ѡ��%%%%
    Temp6=zeros(1*N,L);
    Temp7=zeros(1*N,L);
    Temp8=zeros(N*1,L);
    Temp9=zeros(N*1,L);
    Temp_pu_sc_1=zeros(1*N,L);
    Temp_su_sc=zeros(1*N,L);
    M_pu_N_su_joint_sc=zeros(1*N,L);
    Ps=zeros(N,L);
    
    %%%%��Ҫ�û����书�ʵ�����%%%%
    for j=1:N
        for m=1:L 
            Ps(j,m)=min(P,I/(abs(hjr(j,m)^2)));
        end
    end
    
    %%%%����ȷ���õ���Ѵ�Ҫ�м�,����N�������Դ��û�����ѡȡ%%%%
    %%%%ע:��m��ʵ���������û���Location_pu(1,m)%%%%
    %%%%ע:��m��ʵ�����Ѵ�Ҫ�м̣�Location_sr(1,m)%%%%
    
    a=1;
    for j=1:1:N
        for m=1:1:L
           Temp6(j,m)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Ps(j,m)*(abs(hjr(j,m))^2)+N0));                            %���û��������ն˵����ŵ�����
           Temp7(j,m)=log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Ps(j,m)*(abs(hje(j,m))^2)+N0));                            %���û��������ŵ�����
           Temp8(j,m)=0.5*log(1+(Ps(j,m)*(abs(hjb(j,m))^2))/(Pp*abs(hib(Location_pu(1,m),m))^2+N0));                        %���û�����Ѵ�Ҫ�м̵����ŵ�����
           Temp9(j,m)=0.5*log(1+(Ps(j,m)*(abs(hje(j,m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));                        %���û��������ŵ�����
   
           Temp_pu_sc_1(j,m)=(Temp6(j,m)-Temp7(j,m)<0).*0+(Temp6(j,m)-Temp7(j,m)>=0).*(Temp6(j,m)-Temp7(j,m));   %�����ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_su_sc(j,m)=(Temp8(j,m)-Temp9(j,m)<0).*0+(Temp8(j,m)-Temp9(j,m)>=0).*(Temp8(j,m)-Temp9(j,m));
           M_pu_N_su_joint_sc(j,m)= Temp_pu_sc_1(j,m)+ Temp_su_sc(j,m);      
        end
    end
         
    %%%%�����ֵ����Ӧ����%%%% 
    [Temp_1 Location_su]=max(M_pu_N_su_joint_sc);                          %M*R�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵTemp_1,Location_su��¼���ֵTemp��������
    Cs_M_pu_N_su_joint_sc(k)=sum(Temp_1)/L;                                %MERΪĳһֵʱ�������û���������֮�͵ľ�ֵ
    
    %%%%ȷ��max��Ӧ����Ѵ�Ҫ�û�%%%%      
    a=1;
    Temp_pu_sc=zeros(1,L);
    Temp_pu_sc_1=zeros(1,L);
    Temp_su_sc=zeros(1,L);
    
    for m=1:L
           Temp_pu_sc(1,a)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Ps(Location_su(1,m),m)*(abs(hjr(Location_su(1,m),m))^2)+N0))-log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Ps(Location_su(1,m),m)*(abs(hje(Location_su(1,m),m))^2)+N0));                            
           Temp_su_sc(1,a)=0.5*log(1+(Ps(Location_su(1,m),m)*(abs(hjb(Location_su(1,m),m))^2))/(Pp*abs(hib(Location_pu(1,m),m))^2+N0))-0.5*log(1+(Ps(Location_su(1,m),m)*(abs(hje(Location_su(1,m),m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));                      
           Temp_pu_sc_1(1,a)=(Temp_pu_sc(1,a)<0)*0+(Temp_pu_sc(1,a)>=0)*Temp_pu_sc(1,a); 
           Temp_su_sc(1,a)=(Temp_su_sc(1,a)<0)*0+(Temp_su_sc(1,a)>=0)*Temp_su_sc(1,a);
         a=a+1;
    end
        
    Cs_M_pu_sc_1(k)=sum(Temp_pu_sc_1)/L;                                   %MERΪĳһֵʱ��������û��İ�ȫ������ֵ
    Cs_N_su_sc(k)=sum(Temp_su_sc)/L;                                       %MERΪĳһֵʱ����Ѵ�Ҫ�м̵İ�ȫ������ֵ
 
    %%%%������û���ȫ��������Ѵ��û�������Ѵ�Ҫ�м̣���ȫ����֮��%%%%
    Cs_primary_sc(k)=min(Cs_M_pu_sc_1(k),Cs_M_pu_sc_2(k));                 %���û���ȫ����ȡ��������ʱ϶�ڵĽ�Сֵ
    Cs_secondary_sc(k)=min(Cs_R_sr_sc(k),Cs_N_su_sc(k));                   %��Ҫ���簲ȫ����ȡ��������ʱ϶�ڴ�Ҫ�û����Ҫ�м̰�ȫ�����Ľ�Сֵ
    Cs_pri_second_joint_sc(k)=Cs_primary_sc(k)+Cs_secondary_sc(k);         %������������簲ȫ����֮��
    
    clear hir hie hid hjd hje hjr
    k=k+1;
end




%%%%��������м̵Ķ��û�����%%%%
%%%%ʮ�����û�,�˸����û�,�˸���Ҫ�м�%%%%

%%%%���������puΪ���û�,suΪ���û�,srΪ��Ҫ�м�,rΪ�����ն�,dΪ�ν��նˣ�%%%%
%%%%I=10dBm%%%%
%���û�����
M=10;                  %���û��������ڻ����2��
I=0.01;                 %���û��ĸ��ſ���ֵ  
Pp=10;                 %���û�����  
Sigma_hir=0.6;         %pu->r,E(|hir|^2)=Sigma_ir
Sigma_hid=0.2;         %pu->d,E(|hid|^2)=Sigma_id
Sigma_hib=0.2;         %pu->sr,E(|hib|^2)=Sigma_ib
Theta_ir=1;
Theta_ie=0.7;

%���û�����
N=8;                   %���û��������ڻ����2��
P=10^0.2;              %���û��ķ��书��P
Sigma_hjb=1;           %su->sr,E(|hjb|^2)=Sigma_jb
Sigma_hjr=0.2;         %su->r,E(|hjr|^2)=Sigma_jr
Theta_jb=1;
Theta_je=0.7;

%��Ҫ�м̲���
R=8;                   %��Ҫ�м��������ڻ����2��
P=10^0.2;              %��Ҫ�м̵ķ��书��P
Sigma_hbd=1;           %sr->d,E(|hbd|^2)=Sigma_bd
Sigma_hbr=0.2;         %sr->r,E(|hbr|^2)=Sigma_br
Theta_bd=1;
Theta_be=0.7;

%��������
L=10000;               %ʵ�����
N0=0.1;                %���Ը�˹����������
k=1;

for MER=-10:2:30                                                           %MER��main-to-eavesdropper ratio             
    lambda=10^(MER/10);                                                    %dB��Ϊʮ������
    Sigma_hie=Sigma_hir*Theta_ie/(Theta_ir*lambda);
    Sigma_hje=Sigma_hjb*Theta_je/(Theta_jb*lambda);
    Sigma_hbe=Sigma_hbd*Theta_be/(Theta_bd*lambda);

    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(M,L)+sqrt(-Sigma_hir/2)*randn(M,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(M,L)+sqrt(-Sigma_hie/2)*randn(M,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(M,L)+sqrt(-Sigma_hid/2)*randn(M,L);        %���û�����Ҫ���ն˵��ŵ�
    hib=sqrt(Sigma_hib/2)*randn(M,L)+sqrt(-Sigma_hib/2)*randn(M,L);        %���û�����Ҫ�м̵��ŵ�
      
    %���û��ŵ�˥��ϵ��%%%%
    hjb=sqrt(Sigma_hjb/2)*randn(N,L)+sqrt(-Sigma_hjb/2)*randn(N,L);        %���û�����Ѵ�Ҫ�м̵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(N,L)+sqrt(-Sigma_hje/2)*randn(N,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(N,L)+sqrt(-Sigma_hjr/2)*randn(N,L);        %���û��������ն˵��ŵ�
  
    %��Ҫ�м��ŵ�˥��ϵ��%%%%
    hbd=sqrt(Sigma_hbd/2)*randn(R,L)+sqrt(-Sigma_hbd/2)*randn(R,L);        %��Ҫ�м̵���Ҫ���ն˵��ŵ�
    hbe=sqrt(Sigma_hbe/2)*randn(R,L)+sqrt(-Sigma_hbe/2)*randn(R,L);        %��Ҫ�м̵������ߵ��ŵ�
    hbr=sqrt(Sigma_hbr/2)*randn(R,L)+sqrt(-Sigma_hbr/2)*randn(R,L);        %��Ҫ�м̵������ն˵��ŵ�
    
    %%%%�ڶ���ʱ϶ʱ���û�����Ҫ�м̵ı�������%%%%
    Temp2=zeros(M*R,L);
    Temp3=zeros(M*R,L);
    Temp4=zeros(R*M,L);
    Temp5=zeros(R*M,L);
    Temp_pu_sc_2=zeros(M*R,L);
    Temp_sr_sc=zeros(M*R,L);
    M_pu_R_sr_joint_sc=zeros(M*R,L);
    Pb=zeros(R,L);
   
    %%%%��Ҫ�м̷��书�ʵ�����%%%%
    for r=1:R
        for m=1:L 
            Pb(r,m)=min(P,I/(abs(hbr(r,m)^2)));                            %��Ҫ��P����
        end
    end
        
    %%%%����M*R����������Ѵ�Ҫ�м̽���ѡȡ%%%%
    a=1;
    for i=1:1:M
        for r=1:1:R
           Temp2(r,:)=log(1+(Pp*abs(hir(i,:)).^2)./(Pb(r,:).*(abs(hbr(r,:)).^2)+N0));                                                   %���û��������ն˵����ŵ�����
           Temp3(r,:)=log(1+(Pp*abs(hie(i,:)).^2)./(Pb(r,:).*(abs(hbe(r,:)).^2)+N0));                                                   %���û��������ŵ�����
           Temp4(r,:)=0.5*log(1+(Pb(r,:).*(abs(hbd(r,:)).^2))./(Pp*abs(hid(i,:)).^2+N0));                                               %��Ҫ�м����ν��ն˵����ŵ�����
           Temp5(r,:)=0.5*log(1+(Pb(r,:).*(abs(hbe(r,:)).^2))./(Pp*abs(hie(i,:)).^2+N0));                                               %��Ҫ�м̵������ŵ�����
           Temp_pu_sc_2(a,:)=(Temp2(r,:)-Temp3(r,:)<0).*0+(Temp2(r,:)-Temp3(r,:)>=0).*(Temp2(r,:)-Temp3(r,:));                          %���û��ı��������������ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_sr_sc(a,:)=(Temp4(r,:)-Temp5(r,:)<0).*0+(Temp4(r,:)-Temp5(r,:)>=0).*(Temp4(r,:)-Temp5(r,:));                            %��Ҫ�м̵ı�������
           M_pu_R_sr_joint_sc(a,:)=Temp_pu_sc_2(a,:)+Temp_sr_sc(a,:);                                                                 %��i�����û����r����Ҫ�м̵ı�������֮��
           a=a+1; 
        end     
    end
        
    %%%%�����ֵ����Ӧ����%%%%
    [Temp_2 Location_pu_sr]=max(M_pu_R_sr_joint_sc);                       %M*R�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵTemp,Location_pu_sr��¼���ֵTemp��������
   
    %%%%ȷ��max��Ӧ��������û�%%%%
    Location_pu=zeros(1,L);
    for m=1:L
        if(mod(Location_pu_sr(1,m),R)~=0)
            Location_pu(1,m)=fix(Location_pu_sr(1,m)/R)+1;                 %max��Ӧ�����������û������������������fix(Location_pu_sr(1,m)/R)+1�����û�Ϊ������û�
        else
            Location_pu(1,m)=fix(Location_pu_sr(1,m)/R);                   %max��Ӧ�����������û��������������������fix(Location_pu_sr(1,m)/R)�����û�Ϊ������û�
        end
    end
            
    %%%%ȷ��max��Ӧ����Ѵ�Ҫ�м�%%%%
    Location_sr=rem(Location_pu_sr,R);                                     %max��Ӧ�����������û�����������Ϊ�㣬���R����Ҫ�м�Ϊ��Ӧ��Ѵ�Ҫ�м�
    Location_sr(Location_sr==0)=R;                                         %��������Ϊ�㣬���rem(Location_pu_sr,M)
    
    %%%%�ֱ����max��Ӧ��������û�����Ѵ�Ҫ�м̵İ�ȫ����%%%%
    a=1;
    Temp_pu_sc=zeros(1,L);
    Temp_pu_sc_2=zeros(1,L);
    Temp_sr_sc=zeros(1,L);
    for m=1:L
        Temp_pu_sc(1,a)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Pb(Location_sr(1,m),m)*(abs(hbr(Location_sr(1,m),m))^2)+N0))-log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Pb(Location_sr(1,m),m)*(abs(hbe(Location_sr(1,m),m))^2)+N0));         %Location_pu(1,m)��ʾ��m��ʵ��ʱ��Location_pu(1,m)�����û�Ϊ������û� 
        Temp_sr_sc(1,a)=0.5*log(1+(Pb(Location_sr(1,m),m)*(abs(hbd(Location_sr(1,m),m))^2))/(Pp*abs(hid(Location_pu(1,m),m))^2+N0))-0.5*log(1+(Pb(Location_sr(1,m),m)*(abs(hbe(Location_sr(1,m),m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));
        Temp_pu_sc_2(1,a)=(Temp_pu_sc(1,a)<0)*0+(Temp_pu_sc(1,a)>=0)*Temp_pu_sc(1,a);
        Temp_sr_sc(1,a)=(Temp_sr_sc(1,a)<0)*0+(Temp_sr_sc(1,a)>=0)*Temp_sr_sc(1,a);
        a=a+1;
    end
    
    Cs_M_pu_sc_2(k)=sum(Temp_pu_sc_2)/L;                                   %MERΪĳһֵʱ��������û��İ�ȫ������ֵ
    Cs_R_sr_sc(k)=sum(Temp_sr_sc)/L;                                       %MERΪĳһֵʱ����Ѵ�Ҫ�м̵İ�ȫ������ֵ
 
    
    
    %%%%��һ��ʱ϶ʱ������û�����Ҫ�û��ı�������%%%%
    %%%%ע:���û�����Ҫ�м���ѡ��%%%%
    Temp6=zeros(1*N,L);
    Temp7=zeros(1*N,L);
    Temp8=zeros(N*1,L);
    Temp9=zeros(N*1,L);
    Temp_pu_sc_1=zeros(1*N,L);
    Temp_su_sc=zeros(1*N,L);
    M_pu_N_su_joint_sc=zeros(1*N,L);
    Ps=zeros(N,L);
    
    %%%%��Ҫ�û����书�ʵ�����%%%%
    for j=1:N
        for m=1:L 
            Ps(j,m)=min(P,I/(abs(hjr(j,m)^2)));
        end
    end
    
    %%%%����ȷ���õ���Ѵ�Ҫ�м�,����N�������Դ��û�����ѡȡ%%%%
    %%%%ע:��m��ʵ���������û���Location_pu(1,m)%%%%
    %%%%ע:��m��ʵ�����Ѵ�Ҫ�м̣�Location_sr(1,m)%%%%
    
    a=1;
    for j=1:1:N
        for m=1:1:L
           Temp6(j,m)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Ps(j,m)*(abs(hjr(j,m))^2)+N0));                            %���û��������ն˵����ŵ�����
           Temp7(j,m)=log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Ps(j,m)*(abs(hje(j,m))^2)+N0));                            %���û��������ŵ�����
           Temp8(j,m)=0.5*log(1+(Ps(j,m)*(abs(hjb(j,m))^2))/(Pp*abs(hib(Location_pu(1,m),m))^2+N0));                        %���û�����Ѵ�Ҫ�м̵����ŵ�����
           Temp9(j,m)=0.5*log(1+(Ps(j,m)*(abs(hje(j,m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));                        %���û��������ŵ�����
   
           Temp_pu_sc_1(j,m)=(Temp6(j,m)-Temp7(j,m)<0).*0+(Temp6(j,m)-Temp7(j,m)>=0).*(Temp6(j,m)-Temp7(j,m));   %�����ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_su_sc(j,m)=(Temp8(j,m)-Temp9(j,m)<0).*0+(Temp8(j,m)-Temp9(j,m)>=0).*(Temp8(j,m)-Temp9(j,m));
           M_pu_N_su_joint_sc(j,m)= Temp_pu_sc_1(j,m)+ Temp_su_sc(j,m);      
        end
    end
         
    %%%%�����ֵ����Ӧ����%%%% 
    [Temp_1 Location_su]=max(M_pu_N_su_joint_sc);                          %M*R�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵTemp_1,Location_su��¼���ֵTemp��������
    Cs_M_pu_N_su_joint_sc(k)=sum(Temp_1)/L;                                %MERΪĳһֵʱ�������û���������֮�͵ľ�ֵ
    
    %%%%ȷ��max��Ӧ����Ѵ�Ҫ�û�%%%%      
    a=1;
    Temp_pu_sc=zeros(1,L);
    Temp_pu_sc_1=zeros(1,L);
    Temp_su_sc=zeros(1,L);
    
    for m=1:L
           Temp_pu_sc(1,a)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Ps(Location_su(1,m),m)*(abs(hjr(Location_su(1,m),m))^2)+N0))-log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Ps(Location_su(1,m),m)*(abs(hje(Location_su(1,m),m))^2)+N0));                            
           Temp_su_sc(1,a)=0.5*log(1+(Ps(Location_su(1,m),m)*(abs(hjb(Location_su(1,m),m))^2))/(Pp*abs(hib(Location_pu(1,m),m))^2+N0))-0.5*log(1+(Ps(Location_su(1,m),m)*(abs(hje(Location_su(1,m),m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));                      
           Temp_pu_sc_1(1,a)=(Temp_pu_sc(1,a)<0)*0+(Temp_pu_sc(1,a)>=0)*Temp_pu_sc(1,a); 
           Temp_su_sc(1,a)=(Temp_su_sc(1,a)<0)*0+(Temp_su_sc(1,a)>=0)*Temp_su_sc(1,a);
         a=a+1;
    end
        
    Cs_M_pu_sc_1(k)=sum(Temp_pu_sc_1)/L;                                   %MERΪĳһֵʱ��������û��İ�ȫ������ֵ
    Cs_N_su_sc(k)=sum(Temp_su_sc)/L;                                       %MERΪĳһֵʱ����Ѵ�Ҫ�м̵İ�ȫ������ֵ
 
    %%%%������û���ȫ��������Ѵ��û�������Ѵ�Ҫ�м̣���ȫ����֮��%%%%
    Cs_primary_sc_2(k)=min(Cs_M_pu_sc_1(k),Cs_M_pu_sc_2(k));                 %���û���ȫ����ȡ��������ʱ϶�ڵĽ�Сֵ
    Cs_secondary_sc_2(k)=min(Cs_R_sr_sc(k),Cs_N_su_sc(k));                   %��Ҫ���簲ȫ����ȡ��������ʱ϶�ڴ�Ҫ�û����Ҫ�м̰�ȫ�����Ľ�Сֵ
    Cs_pri_second_joint_sc_2(k)=Cs_primary_sc(k)+Cs_secondary_sc(k);         %������������簲ȫ����֮��
    
    clear hir hie hid hjd hje hjr
    k=k+1;
end

%%%%��������м̵Ķ��û�����%%%%
%%%%ʮ�����û�,�˸����û�,�˸���Ҫ�м�%%%%

%%%%���������puΪ���û�,suΪ���û�,srΪ��Ҫ�м�,rΪ�����ն�,dΪ�ν��նˣ�%%%%
%%%%I=30dBm%%%%
%���û�����
M=10;                  %���û��������ڻ����2��
I=1;                   %���û��ĸ��ſ���ֵ  
Pp=10;                 %���û�����  
Sigma_hir=0.6;         %pu->r,E(|hir|^2)=Sigma_ir
Sigma_hid=0.2;         %pu->d,E(|hid|^2)=Sigma_id
Sigma_hib=0.2;         %pu->sr,E(|hib|^2)=Sigma_ib
Theta_ir=1;
Theta_ie=0.7;

%���û�����
N=8;                   %���û��������ڻ����2��
P=10^0.2;              %���û��ķ��书��P
Sigma_hjb=1;           %su->sr,E(|hjb|^2)=Sigma_jb
Sigma_hjr=0.2;         %su->r,E(|hjr|^2)=Sigma_jr
Theta_jb=1;
Theta_je=0.7;

%��Ҫ�м̲���
R=8;                   %��Ҫ�м��������ڻ����2��
P=10^0.2;              %��Ҫ�м̵ķ��书��P
Sigma_hbd=1;           %sr->d,E(|hbd|^2)=Sigma_bd
Sigma_hbr=0.2;         %sr->r,E(|hbr|^2)=Sigma_br
Theta_bd=1;
Theta_be=0.7;

%��������
L=10000;               %ʵ�����
N0=0.1;                %���Ը�˹����������
k=1;

for MER=-10:2:30                                                           %MER��main-to-eavesdropper ratio             
    lambda=10^(MER/10);                                                    %dB��Ϊʮ������
    Sigma_hie=Sigma_hir*Theta_ie/(Theta_ir*lambda);
    Sigma_hje=Sigma_hjb*Theta_je/(Theta_jb*lambda);
    Sigma_hbe=Sigma_hbd*Theta_be/(Theta_bd*lambda);

    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(M,L)+sqrt(-Sigma_hir/2)*randn(M,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(M,L)+sqrt(-Sigma_hie/2)*randn(M,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(M,L)+sqrt(-Sigma_hid/2)*randn(M,L);        %���û�����Ҫ���ն˵��ŵ�
    hib=sqrt(Sigma_hib/2)*randn(M,L)+sqrt(-Sigma_hib/2)*randn(M,L);        %���û�����Ҫ�м̵��ŵ�
      
    %���û��ŵ�˥��ϵ��%%%%
    hjb=sqrt(Sigma_hjb/2)*randn(N,L)+sqrt(-Sigma_hjb/2)*randn(N,L);        %���û�����Ѵ�Ҫ�м̵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(N,L)+sqrt(-Sigma_hje/2)*randn(N,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(N,L)+sqrt(-Sigma_hjr/2)*randn(N,L);        %���û��������ն˵��ŵ�
  
    %��Ҫ�м��ŵ�˥��ϵ��%%%%
    hbd=sqrt(Sigma_hbd/2)*randn(R,L)+sqrt(-Sigma_hbd/2)*randn(R,L);        %��Ҫ�м̵���Ҫ���ն˵��ŵ�
    hbe=sqrt(Sigma_hbe/2)*randn(R,L)+sqrt(-Sigma_hbe/2)*randn(R,L);        %��Ҫ�м̵������ߵ��ŵ�
    hbr=sqrt(Sigma_hbr/2)*randn(R,L)+sqrt(-Sigma_hbr/2)*randn(R,L);        %��Ҫ�м̵������ն˵��ŵ�
    
    %%%%�ڶ���ʱ϶ʱ���û�����Ҫ�м̵ı�������%%%%
    Temp2=zeros(M*R,L);
    Temp3=zeros(M*R,L);
    Temp4=zeros(R*M,L);
    Temp5=zeros(R*M,L);
    Temp_pu_sc_2=zeros(M*R,L);
    Temp_sr_sc=zeros(M*R,L);
    M_pu_R_sr_joint_sc=zeros(M*R,L);
    Pb=zeros(R,L);
   
    %%%%��Ҫ�м̷��书�ʵ�����%%%%
    for r=1:R
        for m=1:L 
            Pb(r,m)=min(P,I/(abs(hbr(r,m)^2)));                            %��Ҫ��P����
        end
    end
        
    %%%%����M*R����������Ѵ�Ҫ�м̽���ѡȡ%%%%
    a=1;
    for i=1:1:M
        for r=1:1:R
           Temp2(r,:)=log(1+(Pp*abs(hir(i,:)).^2)./(Pb(r,:).*(abs(hbr(r,:)).^2)+N0));                                                   %���û��������ն˵����ŵ�����
           Temp3(r,:)=log(1+(Pp*abs(hie(i,:)).^2)./(Pb(r,:).*(abs(hbe(r,:)).^2)+N0));                                                   %���û��������ŵ�����
           Temp4(r,:)=0.5*log(1+(Pb(r,:).*(abs(hbd(r,:)).^2))./(Pp*abs(hid(i,:)).^2+N0));                                               %��Ҫ�м����ν��ն˵����ŵ�����
           Temp5(r,:)=0.5*log(1+(Pb(r,:).*(abs(hbe(r,:)).^2))./(Pp*abs(hie(i,:)).^2+N0));                                               %��Ҫ�м̵������ŵ�����
           Temp_pu_sc_2(a,:)=(Temp2(r,:)-Temp3(r,:)<0).*0+(Temp2(r,:)-Temp3(r,:)>=0).*(Temp2(r,:)-Temp3(r,:));                          %���û��ı��������������ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_sr_sc(a,:)=(Temp4(r,:)-Temp5(r,:)<0).*0+(Temp4(r,:)-Temp5(r,:)>=0).*(Temp4(r,:)-Temp5(r,:));                            %��Ҫ�м̵ı�������
           M_pu_R_sr_joint_sc(a,:)=Temp_pu_sc_2(a,:)+Temp_sr_sc(a,:);                                                                 %��i�����û����r����Ҫ�м̵ı�������֮��
           a=a+1; 
        end     
    end
        
    %%%%�����ֵ����Ӧ����%%%%
    [Temp_2 Location_pu_sr]=max(M_pu_R_sr_joint_sc);                       %M*R�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵTemp,Location_pu_sr��¼���ֵTemp��������
   
    %%%%ȷ��max��Ӧ��������û�%%%%
    Location_pu=zeros(1,L);
    for m=1:L
        if(mod(Location_pu_sr(1,m),R)~=0)
            Location_pu(1,m)=fix(Location_pu_sr(1,m)/R)+1;                 %max��Ӧ�����������û������������������fix(Location_pu_sr(1,m)/R)+1�����û�Ϊ������û�
        else
            Location_pu(1,m)=fix(Location_pu_sr(1,m)/R);                   %max��Ӧ�����������û��������������������fix(Location_pu_sr(1,m)/R)�����û�Ϊ������û�
        end
    end
            
    %%%%ȷ��max��Ӧ����Ѵ�Ҫ�м�%%%%
    Location_sr=rem(Location_pu_sr,R);                                     %max��Ӧ�����������û�����������Ϊ�㣬���R����Ҫ�м�Ϊ��Ӧ��Ѵ�Ҫ�м�
    Location_sr(Location_sr==0)=R;                                         %��������Ϊ�㣬���rem(Location_pu_sr,M)
    
    %%%%�ֱ����max��Ӧ��������û�����Ѵ�Ҫ�м̵İ�ȫ����%%%%
    a=1;
    Temp_pu_sc=zeros(1,L);
    Temp_pu_sc_2=zeros(1,L);
    Temp_sr_sc=zeros(1,L);
    for m=1:L
        Temp_pu_sc(1,a)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Pb(Location_sr(1,m),m)*(abs(hbr(Location_sr(1,m),m))^2)+N0))-log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Pb(Location_sr(1,m),m)*(abs(hbe(Location_sr(1,m),m))^2)+N0));         %Location_pu(1,m)��ʾ��m��ʵ��ʱ��Location_pu(1,m)�����û�Ϊ������û� 
        Temp_sr_sc(1,a)=0.5*log(1+(Pb(Location_sr(1,m),m)*(abs(hbd(Location_sr(1,m),m))^2))/(Pp*abs(hid(Location_pu(1,m),m))^2+N0))-0.5*log(1+(Pb(Location_sr(1,m),m)*(abs(hbe(Location_sr(1,m),m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));
        Temp_pu_sc_2(1,a)=(Temp_pu_sc(1,a)<0)*0+(Temp_pu_sc(1,a)>=0)*Temp_pu_sc(1,a);
        Temp_sr_sc(1,a)=(Temp_sr_sc(1,a)<0)*0+(Temp_sr_sc(1,a)>=0)*Temp_sr_sc(1,a);
        a=a+1;
    end
    
    Cs_M_pu_sc_2(k)=sum(Temp_pu_sc_2)/L;                                   %MERΪĳһֵʱ��������û��İ�ȫ������ֵ
    Cs_R_sr_sc(k)=sum(Temp_sr_sc)/L;                                       %MERΪĳһֵʱ����Ѵ�Ҫ�м̵İ�ȫ������ֵ
 
    
    
    %%%%��һ��ʱ϶ʱ������û�����Ҫ�û��ı�������%%%%
    %%%%ע:���û�����Ҫ�м���ѡ��%%%%
    Temp6=zeros(1*N,L);
    Temp7=zeros(1*N,L);
    Temp8=zeros(N*1,L);
    Temp9=zeros(N*1,L);
    Temp_pu_sc_1=zeros(1*N,L);
    Temp_su_sc=zeros(1*N,L);
    M_pu_N_su_joint_sc=zeros(1*N,L);
    Ps=zeros(N,L);
    
    %%%%��Ҫ�û����书�ʵ�����%%%%
    for j=1:N
        for m=1:L 
            Ps(j,m)=min(P,I/(abs(hjr(j,m)^2)));
        end
    end
    
    %%%%����ȷ���õ���Ѵ�Ҫ�м�,����N�������Դ��û�����ѡȡ%%%%
    %%%%ע:��m��ʵ���������û���Location_pu(1,m)%%%%
    %%%%ע:��m��ʵ�����Ѵ�Ҫ�м̣�Location_sr(1,m)%%%%
    
    a=1;
    for j=1:1:N
        for m=1:1:L
           Temp6(j,m)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Ps(j,m)*(abs(hjr(j,m))^2)+N0));                            %���û��������ն˵����ŵ�����
           Temp7(j,m)=log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Ps(j,m)*(abs(hje(j,m))^2)+N0));                            %���û��������ŵ�����
           Temp8(j,m)=0.5*log(1+(Ps(j,m)*(abs(hjb(j,m))^2))/(Pp*abs(hib(Location_pu(1,m),m))^2+N0));                        %���û�����Ѵ�Ҫ�м̵����ŵ�����
           Temp9(j,m)=0.5*log(1+(Ps(j,m)*(abs(hje(j,m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));                        %���û��������ŵ�����
   
           Temp_pu_sc_1(j,m)=(Temp6(j,m)-Temp7(j,m)<0).*0+(Temp6(j,m)-Temp7(j,m)>=0).*(Temp6(j,m)-Temp7(j,m));   %�����ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_su_sc(j,m)=(Temp8(j,m)-Temp9(j,m)<0).*0+(Temp8(j,m)-Temp9(j,m)>=0).*(Temp8(j,m)-Temp9(j,m));
           M_pu_N_su_joint_sc(j,m)= Temp_pu_sc_1(j,m)+ Temp_su_sc(j,m);      
        end
    end
         
    %%%%�����ֵ����Ӧ����%%%% 
    [Temp_1 Location_su]=max(M_pu_N_su_joint_sc);                          %M*R�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵTemp_1,Location_su��¼���ֵTemp��������
    Cs_M_pu_N_su_joint_sc(k)=sum(Temp_1)/L;                                %MERΪĳһֵʱ�������û���������֮�͵ľ�ֵ
    
    %%%%ȷ��max��Ӧ����Ѵ�Ҫ�û�%%%%      
    a=1;
    Temp_pu_sc=zeros(1,L);
    Temp_pu_sc_1=zeros(1,L);
    Temp_su_sc=zeros(1,L);
    
    for m=1:L
           Temp_pu_sc(1,a)=log(1+(Pp*abs(hir(Location_pu(1,m),m))^2)/(Ps(Location_su(1,m),m)*(abs(hjr(Location_su(1,m),m))^2)+N0))-log(1+(Pp*abs(hie(Location_pu(1,m),m))^2)/(Ps(Location_su(1,m),m)*(abs(hje(Location_su(1,m),m))^2)+N0));                            
           Temp_su_sc(1,a)=0.5*log(1+(Ps(Location_su(1,m),m)*(abs(hjb(Location_su(1,m),m))^2))/(Pp*abs(hib(Location_pu(1,m),m))^2+N0))-0.5*log(1+(Ps(Location_su(1,m),m)*(abs(hje(Location_su(1,m),m))^2))/(Pp*abs(hie(Location_pu(1,m),m))^2+N0));                      
           Temp_pu_sc_1(1,a)=(Temp_pu_sc(1,a)<0)*0+(Temp_pu_sc(1,a)>=0)*Temp_pu_sc(1,a); 
           Temp_su_sc(1,a)=(Temp_su_sc(1,a)<0)*0+(Temp_su_sc(1,a)>=0)*Temp_su_sc(1,a);
         a=a+1;
    end
        
    Cs_M_pu_sc_1(k)=sum(Temp_pu_sc_1)/L;                                   %MERΪĳһֵʱ��������û��İ�ȫ������ֵ
    Cs_N_su_sc(k)=sum(Temp_su_sc)/L;                                       %MERΪĳһֵʱ����Ѵ�Ҫ�м̵İ�ȫ������ֵ
 
    %%%%������û���ȫ��������Ѵ��û�������Ѵ�Ҫ�м̣���ȫ����֮��%%%%
    Cs_primary_sc_3(k)=min(Cs_M_pu_sc_1(k),Cs_M_pu_sc_2(k));                 %���û���ȫ����ȡ��������ʱ϶�ڵĽ�Сֵ
    Cs_secondary_sc_3(k)=min(Cs_R_sr_sc(k),Cs_N_su_sc(k));                   %��Ҫ���簲ȫ����ȡ��������ʱ϶�ڴ�Ҫ�û����Ҫ�м̰�ȫ�����Ľ�Сֵ
    Cs_pri_second_joint_sc_3(k)=Cs_primary_sc(k)+Cs_secondary_sc(k);         %������������簲ȫ����֮��
    
    clear hir hie hid hjd hje hjr
    k=k+1;
end

MER=-10:2:30;
plot(MER,Cs_secondary_sc_3,'k-v');
hold on
plot(MER,Cs_secondary_sc,'k-*');
hold on
plot(MER,Cs_secondary_sc_2,'k-o');
hold on
set(gcf,'color','white');
xlabel('MER(dB)')
ylabel('���û���ȫ����(bit/s/Hz)')
legend('location','NorthWest','I=30dBm (M=10 N=8 R=8)','I=20dBm (M=10 N=8 R=8)','I=10dBm (M=10 N=8 R=8)')