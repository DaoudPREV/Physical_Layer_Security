clear
clc

%%%%���������pΪ���û�,sΪ���û�,rΪ�����ն�,dΪ�ν��նˣ�%%%%
%%%%�ĸ����û����������û�%%%%
%���û�����
Sigma_hir=0.6;         %p->r,E(|hir|^2)=Sigma_ir
Sigma_hid=0.2;         %p->d,E(|hid|^2)=Sigma_id
Theta_ir=1;
Theta_ie=0.7;
M=4;                   %���û��������ڻ����2��
I=0.1;                 %���û��ĸ��ſ���ֵ  
Pp=10;                 %���û�����P 

%���û�����
Sigma_hjd=0.6;         %s->d,E(|hjd|^2)=Sigma_jd
Sigma_hjr=0.2;         %s->r,E(|hjr|^2)=Sigma_jr
Theta_jd=1;
Theta_je=0.7;
N=3;                   %���û��������ڻ����2��
P=10^0.2;              %���û��ķ��书��P

%��������
L=10000;               %ʵ�����
N0=0.1;                %���Ը�˹����������
k=1;

for MER=-10:2:30                                                           %MER��main-to-eavesdropper ratio
    lambda=10^(MER/10);                                                    %dB��Ϊʮ������
    Sigma_hie=Sigma_hir*Theta_ie/(Theta_ir*lambda);
    Sigma_hje=Sigma_hjd*Theta_je/(Theta_jd*lambda);
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(M,L)+sqrt(-Sigma_hir/2)*randn(M,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(M,L)+sqrt(-Sigma_hie/2)*randn(M,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(M,L)+sqrt(-Sigma_hid/2)*randn(M,L);        %���û����ν��ն˵��ŵ�
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hjd=sqrt(Sigma_hjd/2)*randn(N,L)+sqrt(-Sigma_hjd/2)*randn(N,L);        %���û����ν��ն˵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(N,L)+sqrt(-Sigma_hje/2)*randn(N,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(N,L)+sqrt(-Sigma_hjr/2)*randn(N,L);        %���û��������ն˵��ŵ�

   
    %%%%M�����û��Ͷ�Ӧ��N�����û��ı�������֮��%%%%
    Temp2=zeros(M*N,L);
    Temp3=zeros(M*N,L);
    Temp4=zeros(N*M,L);
    Temp5=zeros(N*M,L);
    Temp_pu_sc=zeros(M*N,L);
    Temp_su_sc=zeros(M*N,L);
    M_pu_N_su_joint_sc=zeros(M*N,L);
    Ps=zeros(N,L);
    
    %%%%���û��ķ��书������%%%%
    for j=1:N 
        for m=1:L 
            Ps(j,m)=min(P,I/(abs(hjr(j,m))^2));
        end
    end
    
    a=1;
    %%%%����M*N������%%%%
    for i=1:1:M
         for j=1:1:N
           Temp2(j,:)=log(1+(Pp*abs(hir(i,:)).^2)./(Ps(j,:).*(abs(hjr(j,:)).^2)+N0));     %���û������ŵ�����
           Temp3(j,:)=log(1+(Pp*abs(hie(i,:)).^2)./(Ps(j,:).*(abs(hje(j,:)).^2)+N0));     %���û��������ŵ�����
           Temp4(j,:)=log(1+(Ps(j,:).*(abs(hjd(j,:)).^2))./(Pp*abs(hid(i,:)).^2+N0));     %���û������ŵ�����
           Temp5(j,:)=log(1+(Ps(j,:).*(abs(hje(j,:)).^2))./(Pp*abs(hie(i,:)).^2+N0));     %���û��������ŵ�����
   
           Temp_pu_sc(a,:)=(Temp2(j,:)-Temp3(j,:)<0).*0+(Temp2(j,:)-Temp3(j,:)>=0).*(Temp2(j,:)-Temp3(j,:));                  %�����ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_su_sc(a,:)=(Temp4(j,:)-Temp5(j,:)<0).*0+(Temp4(j,:)-Temp5(j,:)>=0).*(Temp4(j,:)-Temp5(j,:));
           M_pu_N_su_joint_sc(a,:)= Temp_pu_sc(a,:)+ Temp_su_sc(a,:); 
           a=a+1;
         end
        
    end
        
    Temp=max(M_pu_N_su_joint_sc);                                          %M*N�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵ
    Cs_M_pu_N_su(k)=sum(Temp)/L;                                           %MERΪĳһֵʱ�������û���������֮�͵ľ�ֵ
    
    clear hir hie hid hjd hje hjr
    
    %%%%�������û��뵥�����û��ı�������֮��%%%% 
    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(1,L)+sqrt(-Sigma_hir/2)*randn(1,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(1,L)+sqrt(-Sigma_hie/2)*randn(1,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(1,L)+sqrt(-Sigma_hid/2)*randn(1,L);        %���û����ν��ն˵��ŵ�
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hjd=sqrt(Sigma_hjd/2)*randn(1,L)+sqrt(-Sigma_hjd/2)*randn(1,L);        %���û����ν��ն˵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(1,L)+sqrt(-Sigma_hje/2)*randn(1,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(1,L)+sqrt(-Sigma_hjr/2)*randn(1,L);        %���û��������ն˵��ŵ�

      Cpm=zeros(1,L);
      Cpe=zeros(1,L);
      Temp2=0;
      Temp3=0;
      Ps=zeros(1,L);
      for j=1:L
           Ps(1,j)=min(P,I/(abs(hjr(1,j))^2));
      end
      for i=1:1:L         
          Cpm_one=log2(1+(Pp*abs(hir(1,i))^2)/(Ps(1,i).*abs(hjd(1,i))^2+N0));
          Cpe_one=log2(1+(Pp*abs(hie(1,i))^2)/(Ps(1,i).*abs(hje(1,i))^2+N0));
          Temp2=Temp2+([Cpm_one-Cpe_one<0].*0+[Cpm_one-Cpe_one].*[Cpm_one-Cpe_one>=0]);
          Csm_one=log2(1+(Ps(1,i).*abs(hjd(1,i))^2)/(Pp*abs(hid(1,i))^2+N0));
          Cse_one=log2(1+(Ps(1,i).*abs(hje(1,i))^2)/(Pp*abs(hie(1,i))^2+N0));
          Temp3=Temp3+([Csm_one-Cse_one<0].*0+[Csm_one-Cse_one].*[Csm_one-Cse_one>=0]);
      end
      Cs_one_pu_one_su(k)=(Temp2+Temp3)/L;  
      k=k+1;
end   


%%%%�������û����ĸ����û�%%%%
%���û�����
M=6;                   %���û��������ڻ����2��

%���û�����
N=4;                   %���û��������ڻ����2��

k=1;
for MER=-10:2:30                                                           %MER��main-to-eavesdropper ratio
    lambda=10^(MER/10);                                                    %dB��Ϊʮ������
    Sigma_hie=Sigma_hir/lambda;
    Sigma_hje=Sigma_hjd/lambda;
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(M,L)+sqrt(-Sigma_hir/2)*randn(M,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(M,L)+sqrt(-Sigma_hie/2)*randn(M,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(M,L)+sqrt(-Sigma_hid/2)*randn(M,L);        %���û����ν��ն˵��ŵ�
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hjd=sqrt(Sigma_hjd/2)*randn(N,L)+sqrt(-Sigma_hjd/2)*randn(N,L);        %���û����ν��ն˵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(N,L)+sqrt(-Sigma_hje/2)*randn(N,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(N,L)+sqrt(-Sigma_hjr/2)*randn(N,L);        %���û��������ն˵��ŵ�

   
    %%%%M�����û��Ͷ�Ӧ��N�����û��ı�������֮��%%%%
    Temp2=zeros(M*N,L);
    Temp3=zeros(M*N,L);
    Temp4=zeros(N*M,L);
    Temp5=zeros(N*M,L);
    Temp_pu_sc=zeros(M*N,L);
    Temp_su_sc=zeros(M*N,L);
    M_pu_N_su_joint_sc=zeros(M*N,L);
    Ps=zeros(N,L);
    
    %%%%���û��ķ��书������%%%%
    for j=1:N 
        for m=1:L 
            Ps(j,m)=min(P,I/(abs(hjr(j,m))^2));
        end
    end
    
    a=1;
    %%%%����M*N������%%%%
    for i=1:1:M
         for j=1:1:N
           Temp2(j,:)=log(1+(Pp*abs(hir(i,:)).^2)./(Ps(j,:).*(abs(hjr(j,:)).^2)+N0));     %���û������ŵ�����
           Temp3(j,:)=log(1+(Pp*abs(hie(i,:)).^2)./(Ps(j,:).*(abs(hje(j,:)).^2)+N0));     %���û��������ŵ�����
           Temp4(j,:)=log(1+(Ps(j,:).*(abs(hjd(j,:)).^2))./(Pp*abs(hid(i,:)).^2+N0));     %���û������ŵ�����
           Temp5(j,:)=log(1+(Ps(j,:).*(abs(hje(j,:)).^2))./(Pp*abs(hie(i,:)).^2+N0));     %���û��������ŵ�����
   
           Temp_pu_sc(a,:)=(Temp2(j,:)-Temp3(j,:)<0).*0+(Temp2(j,:)-Temp3(j,:)>=0).*(Temp2(j,:)-Temp3(j,:));                  %�����ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_su_sc(a,:)=(Temp4(j,:)-Temp5(j,:)<0).*0+(Temp4(j,:)-Temp5(j,:)>=0).*(Temp4(j,:)-Temp5(j,:));
           M_pu_N_su_joint_sc(a,:)= Temp_pu_sc(a,:)+ Temp_su_sc(a,:); 
           a=a+1;
         end
        
    end
        
    Temp=max(M_pu_N_su_joint_sc);                                          %M*N�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵ
    Cs_M_pu_N_su_2(k)=sum(Temp)/L;                                         %MERΪĳһֵʱ�������û���������֮�͵ľ�ֵ
    k=k+1;
end   

%%%%ʮ�����û���˸����û�%%%%
%���û�����
M=10;                   %���û��������ڻ����2��

%���û�����
N=8;                   %���û��������ڻ����2��

k=1;
for MER=-10:2:30                                                           %MER��main-to-eavesdropper ratio
    lambda=10^(MER/10);                                                    %dB��Ϊʮ������
    Sigma_hie=Sigma_hir/lambda;
    Sigma_hje=Sigma_hjd/lambda;
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hir=sqrt(Sigma_hir/2)*randn(M,L)+sqrt(-Sigma_hir/2)*randn(M,L);        %���û��������ն˵��ŵ�
    hie=sqrt(Sigma_hie/2)*randn(M,L)+sqrt(-Sigma_hie/2)*randn(M,L);        %���û��������ߵ��ŵ�
    hid=sqrt(Sigma_hid/2)*randn(M,L)+sqrt(-Sigma_hid/2)*randn(M,L);        %���û����ν��ն˵��ŵ�
    
    %%%%���û��ŵ�˥��ϵ��%%%%
    hjd=sqrt(Sigma_hjd/2)*randn(N,L)+sqrt(-Sigma_hjd/2)*randn(N,L);        %���û����ν��ն˵��ŵ�
    hje=sqrt(Sigma_hje/2)*randn(N,L)+sqrt(-Sigma_hje/2)*randn(N,L);        %���û��������ߵ��ŵ�
    hjr=sqrt(Sigma_hjr/2)*randn(N,L)+sqrt(-Sigma_hjr/2)*randn(N,L);        %���û��������ն˵��ŵ�

   
    %%%%M�����û��Ͷ�Ӧ��N�����û��ı�������֮��%%%%
    Temp2=zeros(M*N,L);
    Temp3=zeros(M*N,L);
    Temp4=zeros(N*M,L);
    Temp5=zeros(N*M,L);
    Temp_pu_sc=zeros(M*N,L);
    Temp_su_sc=zeros(M*N,L);
    M_pu_N_su_joint_sc=zeros(M*N,L);
    Ps=zeros(N,L);
    
    %%%%���û��ķ��书������%%%%
    for j=1:N 
        for m=1:L 
            Ps(j,m)=min(P,I/(abs(hjr(j,m))^2));
        end
    end
    
    a=1;
    %%%%����M*N������%%%%
    for i=1:1:M
         for j=1:1:N
           Temp2(j,:)=log(1+(Pp*abs(hir(i,:)).^2)./(Ps(j,:).*(abs(hjr(j,:)).^2)+N0));     %���û������ŵ�����
           Temp3(j,:)=log(1+(Pp*abs(hie(i,:)).^2)./(Ps(j,:).*(abs(hje(j,:)).^2)+N0));     %���û��������ŵ�����
           Temp4(j,:)=log(1+(Ps(j,:).*(abs(hjd(j,:)).^2))./(Pp*abs(hid(i,:)).^2+N0));     %���û������ŵ�����
           Temp5(j,:)=log(1+(Ps(j,:).*(abs(hje(j,:)).^2))./(Pp*abs(hie(i,:)).^2+N0));     %���û��������ŵ�����
   
           Temp_pu_sc(a,:)=(Temp2(j,:)-Temp3(j,:)<0).*0+(Temp2(j,:)-Temp3(j,:)>=0).*(Temp2(j,:)-Temp3(j,:));                  %�����ŵ��������ŵ����ŵ�������ֵС����������Ϊ�㴦��
           Temp_su_sc(a,:)=(Temp4(j,:)-Temp5(j,:)<0).*0+(Temp4(j,:)-Temp5(j,:)>=0).*(Temp4(j,:)-Temp5(j,:));
           M_pu_N_su_joint_sc(a,:)= Temp_pu_sc(a,:)+ Temp_su_sc(a,:); 
           a=a+1;
         end
        
    end
        
    Temp=max(M_pu_N_su_joint_sc);                                          %M*N�������������ֵ,��M_pu_N_su_joint_sc��ÿ���ҳ����ֵ
    Cs_M_pu_N_su_3(k)=sum(Temp)/L;                                         %MERΪĳһֵʱ�������û���������֮�͵ľ�ֵ
    k=k+1;
end  

MER=-10:2:30;
plot(MER, Cs_M_pu_N_su_3,'k-d');
hold on
plot(MER, Cs_M_pu_N_su_2,'k-o');
hold on
plot(MER, Cs_M_pu_N_su,'k-v');
hold on
plot(MER, Cs_one_pu_one_su,'k-*');
set(gcf,'color','white');
xlabel('MER(dB)')
ylabel('�����û���ȫ����֮��(bit/s/Hz)')
legend('location','southeast','M=10 N=8','M=6 N=4','M=4 N=3','M=1 N=1')