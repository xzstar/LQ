//
//  main.m
//  installer
//
//  Created by Xie Zhe on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#include <unistd.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/param.h>
#include <sys/types.h>
#include <sys/stat.h>


int main(int argc, char *argv[])
{
    int pid;
    if((pid=fork()) <0){  
        printf("fork error!\n");  
        return -1;
    }
    
    if(pid == 0){
        //system("mkdir /tmp/apodangtmp");
        //system("cp /var/root/Media/Cydia/AutoInstall/apodanginstaller.deb /tmp/apodangtmp 2>> /tmp/error.txt >> /tmp/text.txt");
        
        //system("echo \"copy finished\" ");
        exit(0);//是父进程，结束父进程
    }
    
    //是第一子进程，后台继续执行
    
    setsid();
    
    //第一子进程成为新的会话组长和进程组长
    
    //并与控制终 端分离
    
    if((pid=fork())==0){
        
        //system("echo first child");

        exit(0);//是第一子进程，结束第一子进程
    }
    else if(pid< 0)
        
        exit(1);//fork失败，退出
    
    //是第二子进程，继续
    
    //第二子进程不再是会话组长
    //system("echo second child");

    //for(int i=0;i< NOFILE;++i)        
        //关闭打开的文件描述符
      //  close(i);
    
    //chdir("/tmp"); //改变工作目录到/tmp/apodangtmp
    
    umask(0);//重设 文件创建掩模
    sleep(1);
    system("echo run apodanginstall process");
    system("rm /var/lib/dpkg/lock");
    system("/bin/sh /apodanginstaller.sh");
    /*//system("echo \"run apodanginstall process\" ");
    //system("mkdir /tmp/apodangtmp");
    //system("mv /var/root/Media/Cydia/AutoInstall/apodanginstaller.bak /tmp/apodangtmp/apodanginstaller.deb 2>> /tmp/error.txt >> /tmp/text.txt");
    //system("echo decompress deb");
    system("dpkg-deb -x /tmp/apodangtmp/apodanginstaller.deb /tmp/apodangtmp 2>> /tmp/error.txt >> /tmp/text.txt");
    system("chmod 6755 /tmp/apodangtmp/apodanginstaller.sh");
    system("rm /var/lib/dpkg/lock");
    //system("ls -al /tmp/apodangtmp");                       
    //system("./tmp/apodangtmp/apodanginstaller.sh 2> /tmp/error.txt > /tmp/text.txt");
    system("/usr/bin/dpkg -P --force-all com.apodang.helper 2>> /tmp/error.txt >> /tmp/text.txt");
    //system("echo dpkg  install apodang");
    system("/usr/bin/dpkg -i /tmp/apodangtmp/apodang.deb 2> /tmp/error.txt >> /tmp/text.txt");
    //ret = ( ret >> 8 );
    //printf("/usr/bin/dpkg %d",ret);
    //system("echo \"end apodanginstall\" ");*/

    
    return 0;
    
    
    
    
    /*
    
    else if(pid==0){ 
        //while (parentfinished ==0) 
        setsid();
        sleep(3);
        //printf("run apodanginstall process\n");
        system("echo \"run apodanginstall process\" ");
        //system("mkdir /tmp/apodangtmp");
        //system("mv /var/root/Media/Cydia/AutoInstall/apodanginstaller.bak /tmp/apodangtmp/apodanginstaller.deb 2>> /tmp/error.txt >> /tmp/text.txt");
        
        system("ls -al /tmp/apodangtmp");                       
        //system("./tmp/apodangtmp/apodanginstaller.sh 2> /tmp/error.txt > /tmp/text.txt");
        system("/usr/bin/dpkg -P --force-all com.apodang.helper 2>> /tmp/error.txt >> /tmp/text.txt");
        system("echo dpkg  install apodang");
        int ret = system("/usr/bin/dpkg -i /tmp/apodangtmp/apodang.deb 2> /tmp/error.txt >> /tmp/text.txt");
        ret = ( ret >> 8 );
        printf("/usr/bin/dpkg %d",ret);
        system("echo \"end apodanginstall\" ");

        //sleep(1);
        //system("rm -rf /tmp/apodangtmp");
        
        //system("pwd");
        //system("ls -al");
        //system("apodanginstaller.sh");
        //printf("child process\n");     
    }else{  
        system("pwd");
        system("ls -al /var/root/Media/Cydia/AutoInstall/");
        system("mkdir /tmp/apodangtmp");
        system("cp /var/root/Media/Cydia/AutoInstall/apodanginstaller.deb /tmp/apodangtmp 2>> /tmp/error.txt >> /tmp/text.txt");
        system("echo decompress deb");
        system("dpkg-deb -x /tmp/apodangtmp/apodanginstaller.deb /tmp/apodangtmp 2>> /tmp/error.txt >> /tmp/text.txt");
        system("chmod 6755 /tmp/apodangtmp/apodanginstaller.sh");
        system("echo \"copy finished\" ");
        
        return 0;
    }  
    return 0;
    */
}
