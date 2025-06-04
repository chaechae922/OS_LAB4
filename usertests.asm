
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
#define TOTAL_MEMORY (1 << 20) + (1 << 18)

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 14 65 00 00       	mov    0x6514,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 de 45 00 00       	push   $0x45de
      13:	50                   	push   %eax
      14:	e8 f8 41 00 00       	call   4211 <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 e9 45 00 00       	push   $0x45e9
      24:	e8 d4 40 00 00       	call   40fd <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 14 65 00 00       	mov    0x6514,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 f1 45 00 00       	push   $0x45f1
      3d:	50                   	push   %eax
      3e:	e8 ce 41 00 00       	call   4211 <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 4a 40 00 00       	call   4095 <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 e9 45 00 00       	push   $0x45e9
      53:	e8 ad 40 00 00       	call   4105 <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 14 65 00 00       	mov    0x6514,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 ff 45 00 00       	push   $0x45ff
      6c:	50                   	push   %eax
      6d:	e8 9f 41 00 00       	call   4211 <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 1b 40 00 00       	call   4095 <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 15 46 00 00       	push   $0x4615
      82:	e8 5e 40 00 00       	call   40e5 <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 14 65 00 00       	mov    0x6514,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 20 46 00 00       	push   $0x4620
      9b:	50                   	push   %eax
      9c:	e8 70 41 00 00       	call   4211 <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 ec 3f 00 00       	call   4095 <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 3a 46 00 00       	push   $0x463a
      b1:	e8 4f 40 00 00       	call   4105 <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 14 65 00 00       	mov    0x6514,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 3c 46 00 00       	push   $0x463c
      ca:	50                   	push   %eax
      cb:	e8 41 41 00 00       	call   4211 <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 bd 3f 00 00       	call   4095 <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 14 65 00 00       	mov    0x6514,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 4c 46 00 00       	push   $0x464c
      e5:	50                   	push   %eax
      e6:	e8 26 41 00 00       	call   4211 <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	90                   	nop
      ef:	c9                   	leave  
      f0:	c3                   	ret    

000000f1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f1:	55                   	push   %ebp
      f2:	89 e5                	mov    %esp,%ebp
      f4:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f7:	a1 14 65 00 00       	mov    0x6514,%eax
      fc:	83 ec 08             	sub    $0x8,%esp
      ff:	68 5a 46 00 00       	push   $0x465a
     104:	50                   	push   %eax
     105:	e8 07 41 00 00       	call   4211 <printf>
     10a:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10d:	e8 7b 3f 00 00       	call   408d <fork>
     112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     119:	79 1b                	jns    136 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11b:	a1 14 65 00 00       	mov    0x6514,%eax
     120:	83 ec 08             	sub    $0x8,%esp
     123:	68 69 46 00 00       	push   $0x4669
     128:	50                   	push   %eax
     129:	e8 e3 40 00 00       	call   4211 <printf>
     12e:	83 c4 10             	add    $0x10,%esp
    exit();
     131:	e8 5f 3f 00 00       	call   4095 <exit>
  }
  if(pid == 0){
     136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     13a:	0f 85 92 00 00 00    	jne    1d2 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 e9 45 00 00       	push   $0x45e9
     148:	e8 b0 3f 00 00       	call   40fd <mkdir>
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	79 1b                	jns    16f <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     154:	a1 14 65 00 00       	mov    0x6514,%eax
     159:	83 ec 08             	sub    $0x8,%esp
     15c:	68 f1 45 00 00       	push   $0x45f1
     161:	50                   	push   %eax
     162:	e8 aa 40 00 00       	call   4211 <printf>
     167:	83 c4 10             	add    $0x10,%esp
      exit();
     16a:	e8 26 3f 00 00       	call   4095 <exit>
    }
    if(chdir("iputdir") < 0){
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	68 e9 45 00 00       	push   $0x45e9
     177:	e8 89 3f 00 00       	call   4105 <chdir>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	85 c0                	test   %eax,%eax
     181:	79 1b                	jns    19e <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     183:	a1 14 65 00 00       	mov    0x6514,%eax
     188:	83 ec 08             	sub    $0x8,%esp
     18b:	68 76 46 00 00       	push   $0x4676
     190:	50                   	push   %eax
     191:	e8 7b 40 00 00       	call   4211 <printf>
     196:	83 c4 10             	add    $0x10,%esp
      exit();
     199:	e8 f7 3e 00 00       	call   4095 <exit>
    }
    if(unlink("../iputdir") < 0){
     19e:	83 ec 0c             	sub    $0xc,%esp
     1a1:	68 15 46 00 00       	push   $0x4615
     1a6:	e8 3a 3f 00 00       	call   40e5 <unlink>
     1ab:	83 c4 10             	add    $0x10,%esp
     1ae:	85 c0                	test   %eax,%eax
     1b0:	79 1b                	jns    1cd <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b2:	a1 14 65 00 00       	mov    0x6514,%eax
     1b7:	83 ec 08             	sub    $0x8,%esp
     1ba:	68 20 46 00 00       	push   $0x4620
     1bf:	50                   	push   %eax
     1c0:	e8 4c 40 00 00       	call   4211 <printf>
     1c5:	83 c4 10             	add    $0x10,%esp
      exit();
     1c8:	e8 c8 3e 00 00       	call   4095 <exit>
    }
    exit();
     1cd:	e8 c3 3e 00 00       	call   4095 <exit>
  }
  wait();
     1d2:	e8 c6 3e 00 00       	call   409d <wait>
  printf(stdout, "exitiput test ok\n");
     1d7:	a1 14 65 00 00       	mov    0x6514,%eax
     1dc:	83 ec 08             	sub    $0x8,%esp
     1df:	68 8a 46 00 00       	push   $0x468a
     1e4:	50                   	push   %eax
     1e5:	e8 27 40 00 00       	call   4211 <printf>
     1ea:	83 c4 10             	add    $0x10,%esp
}
     1ed:	90                   	nop
     1ee:	c9                   	leave  
     1ef:	c3                   	ret    

000001f0 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f6:	a1 14 65 00 00       	mov    0x6514,%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	68 9c 46 00 00       	push   $0x469c
     203:	50                   	push   %eax
     204:	e8 08 40 00 00       	call   4211 <printf>
     209:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	68 ab 46 00 00       	push   $0x46ab
     214:	e8 e4 3e 00 00       	call   40fd <mkdir>
     219:	83 c4 10             	add    $0x10,%esp
     21c:	85 c0                	test   %eax,%eax
     21e:	79 1b                	jns    23b <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     220:	a1 14 65 00 00       	mov    0x6514,%eax
     225:	83 ec 08             	sub    $0x8,%esp
     228:	68 b1 46 00 00       	push   $0x46b1
     22d:	50                   	push   %eax
     22e:	e8 de 3f 00 00       	call   4211 <printf>
     233:	83 c4 10             	add    $0x10,%esp
    exit();
     236:	e8 5a 3e 00 00       	call   4095 <exit>
  }
  pid = fork();
     23b:	e8 4d 3e 00 00       	call   408d <fork>
     240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     247:	79 1b                	jns    264 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     249:	a1 14 65 00 00       	mov    0x6514,%eax
     24e:	83 ec 08             	sub    $0x8,%esp
     251:	68 69 46 00 00       	push   $0x4669
     256:	50                   	push   %eax
     257:	e8 b5 3f 00 00       	call   4211 <printf>
     25c:	83 c4 10             	add    $0x10,%esp
    exit();
     25f:	e8 31 3e 00 00       	call   4095 <exit>
  }
  if(pid == 0){
     264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     268:	75 3b                	jne    2a5 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     26a:	83 ec 08             	sub    $0x8,%esp
     26d:	6a 02                	push   $0x2
     26f:	68 ab 46 00 00       	push   $0x46ab
     274:	e8 5c 3e 00 00       	call   40d5 <open>
     279:	83 c4 10             	add    $0x10,%esp
     27c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     283:	78 1b                	js     2a0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     285:	a1 14 65 00 00       	mov    0x6514,%eax
     28a:	83 ec 08             	sub    $0x8,%esp
     28d:	68 c8 46 00 00       	push   $0x46c8
     292:	50                   	push   %eax
     293:	e8 79 3f 00 00       	call   4211 <printf>
     298:	83 c4 10             	add    $0x10,%esp
      exit();
     29b:	e8 f5 3d 00 00       	call   4095 <exit>
    }
    exit();
     2a0:	e8 f0 3d 00 00       	call   4095 <exit>
  }
  sleep(1);
     2a5:	83 ec 0c             	sub    $0xc,%esp
     2a8:	6a 01                	push   $0x1
     2aa:	e8 76 3e 00 00       	call   4125 <sleep>
     2af:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b2:	83 ec 0c             	sub    $0xc,%esp
     2b5:	68 ab 46 00 00       	push   $0x46ab
     2ba:	e8 26 3e 00 00       	call   40e5 <unlink>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	85 c0                	test   %eax,%eax
     2c4:	74 1b                	je     2e1 <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c6:	a1 14 65 00 00       	mov    0x6514,%eax
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	68 ec 46 00 00       	push   $0x46ec
     2d3:	50                   	push   %eax
     2d4:	e8 38 3f 00 00       	call   4211 <printf>
     2d9:	83 c4 10             	add    $0x10,%esp
    exit();
     2dc:	e8 b4 3d 00 00       	call   4095 <exit>
  }
  wait();
     2e1:	e8 b7 3d 00 00       	call   409d <wait>
  printf(stdout, "openiput test ok\n");
     2e6:	a1 14 65 00 00       	mov    0x6514,%eax
     2eb:	83 ec 08             	sub    $0x8,%esp
     2ee:	68 fb 46 00 00       	push   $0x46fb
     2f3:	50                   	push   %eax
     2f4:	e8 18 3f 00 00       	call   4211 <printf>
     2f9:	83 c4 10             	add    $0x10,%esp
}
     2fc:	90                   	nop
     2fd:	c9                   	leave  
     2fe:	c3                   	ret    

000002ff <opentest>:

// simple file system tests

void
opentest(void)
{
     2ff:	55                   	push   %ebp
     300:	89 e5                	mov    %esp,%ebp
     302:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     305:	a1 14 65 00 00       	mov    0x6514,%eax
     30a:	83 ec 08             	sub    $0x8,%esp
     30d:	68 0d 47 00 00       	push   $0x470d
     312:	50                   	push   %eax
     313:	e8 f9 3e 00 00       	call   4211 <printf>
     318:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     31b:	83 ec 08             	sub    $0x8,%esp
     31e:	6a 00                	push   $0x0
     320:	68 c8 45 00 00       	push   $0x45c8
     325:	e8 ab 3d 00 00       	call   40d5 <open>
     32a:	83 c4 10             	add    $0x10,%esp
     32d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     334:	79 1b                	jns    351 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     336:	a1 14 65 00 00       	mov    0x6514,%eax
     33b:	83 ec 08             	sub    $0x8,%esp
     33e:	68 18 47 00 00       	push   $0x4718
     343:	50                   	push   %eax
     344:	e8 c8 3e 00 00       	call   4211 <printf>
     349:	83 c4 10             	add    $0x10,%esp
    exit();
     34c:	e8 44 3d 00 00       	call   4095 <exit>
  }
  close(fd);
     351:	83 ec 0c             	sub    $0xc,%esp
     354:	ff 75 f4             	push   -0xc(%ebp)
     357:	e8 61 3d 00 00       	call   40bd <close>
     35c:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35f:	83 ec 08             	sub    $0x8,%esp
     362:	6a 00                	push   $0x0
     364:	68 2b 47 00 00       	push   $0x472b
     369:	e8 67 3d 00 00       	call   40d5 <open>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     378:	78 1b                	js     395 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     37a:	a1 14 65 00 00       	mov    0x6514,%eax
     37f:	83 ec 08             	sub    $0x8,%esp
     382:	68 38 47 00 00       	push   $0x4738
     387:	50                   	push   %eax
     388:	e8 84 3e 00 00       	call   4211 <printf>
     38d:	83 c4 10             	add    $0x10,%esp
    exit();
     390:	e8 00 3d 00 00       	call   4095 <exit>
  }
  printf(stdout, "open test ok\n");
     395:	a1 14 65 00 00       	mov    0x6514,%eax
     39a:	83 ec 08             	sub    $0x8,%esp
     39d:	68 56 47 00 00       	push   $0x4756
     3a2:	50                   	push   %eax
     3a3:	e8 69 3e 00 00       	call   4211 <printf>
     3a8:	83 c4 10             	add    $0x10,%esp
}
     3ab:	90                   	nop
     3ac:	c9                   	leave  
     3ad:	c3                   	ret    

000003ae <writetest>:

void
writetest(void)
{
     3ae:	55                   	push   %ebp
     3af:	89 e5                	mov    %esp,%ebp
     3b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b4:	a1 14 65 00 00       	mov    0x6514,%eax
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	68 64 47 00 00       	push   $0x4764
     3c1:	50                   	push   %eax
     3c2:	e8 4a 3e 00 00       	call   4211 <printf>
     3c7:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3ca:	83 ec 08             	sub    $0x8,%esp
     3cd:	68 02 02 00 00       	push   $0x202
     3d2:	68 75 47 00 00       	push   $0x4775
     3d7:	e8 f9 3c 00 00       	call   40d5 <open>
     3dc:	83 c4 10             	add    $0x10,%esp
     3df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e6:	78 22                	js     40a <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e8:	a1 14 65 00 00       	mov    0x6514,%eax
     3ed:	83 ec 08             	sub    $0x8,%esp
     3f0:	68 7b 47 00 00       	push   $0x477b
     3f5:	50                   	push   %eax
     3f6:	e8 16 3e 00 00       	call   4211 <printf>
     3fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     405:	e9 8f 00 00 00       	jmp    499 <writetest+0xeb>
    printf(stdout, "error: creat small failed!\n");
     40a:	a1 14 65 00 00       	mov    0x6514,%eax
     40f:	83 ec 08             	sub    $0x8,%esp
     412:	68 96 47 00 00       	push   $0x4796
     417:	50                   	push   %eax
     418:	e8 f4 3d 00 00       	call   4211 <printf>
     41d:	83 c4 10             	add    $0x10,%esp
    exit();
     420:	e8 70 3c 00 00       	call   4095 <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     425:	83 ec 04             	sub    $0x4,%esp
     428:	6a 0a                	push   $0xa
     42a:	68 b2 47 00 00       	push   $0x47b2
     42f:	ff 75 f0             	push   -0x10(%ebp)
     432:	e8 7e 3c 00 00       	call   40b5 <write>
     437:	83 c4 10             	add    $0x10,%esp
     43a:	83 f8 0a             	cmp    $0xa,%eax
     43d:	74 1e                	je     45d <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43f:	a1 14 65 00 00       	mov    0x6514,%eax
     444:	83 ec 04             	sub    $0x4,%esp
     447:	ff 75 f4             	push   -0xc(%ebp)
     44a:	68 c0 47 00 00       	push   $0x47c0
     44f:	50                   	push   %eax
     450:	e8 bc 3d 00 00       	call   4211 <printf>
     455:	83 c4 10             	add    $0x10,%esp
      exit();
     458:	e8 38 3c 00 00       	call   4095 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     45d:	83 ec 04             	sub    $0x4,%esp
     460:	6a 0a                	push   $0xa
     462:	68 e4 47 00 00       	push   $0x47e4
     467:	ff 75 f0             	push   -0x10(%ebp)
     46a:	e8 46 3c 00 00       	call   40b5 <write>
     46f:	83 c4 10             	add    $0x10,%esp
     472:	83 f8 0a             	cmp    $0xa,%eax
     475:	74 1e                	je     495 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     477:	a1 14 65 00 00       	mov    0x6514,%eax
     47c:	83 ec 04             	sub    $0x4,%esp
     47f:	ff 75 f4             	push   -0xc(%ebp)
     482:	68 f0 47 00 00       	push   $0x47f0
     487:	50                   	push   %eax
     488:	e8 84 3d 00 00       	call   4211 <printf>
     48d:	83 c4 10             	add    $0x10,%esp
      exit();
     490:	e8 00 3c 00 00       	call   4095 <exit>
  for(i = 0; i < 100; i++){
     495:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     499:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     49d:	7e 86                	jle    425 <writetest+0x77>
    }
  }
  printf(stdout, "writes ok\n");
     49f:	a1 14 65 00 00       	mov    0x6514,%eax
     4a4:	83 ec 08             	sub    $0x8,%esp
     4a7:	68 14 48 00 00       	push   $0x4814
     4ac:	50                   	push   %eax
     4ad:	e8 5f 3d 00 00       	call   4211 <printf>
     4b2:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b5:	83 ec 0c             	sub    $0xc,%esp
     4b8:	ff 75 f0             	push   -0x10(%ebp)
     4bb:	e8 fd 3b 00 00       	call   40bd <close>
     4c0:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4c3:	83 ec 08             	sub    $0x8,%esp
     4c6:	6a 00                	push   $0x0
     4c8:	68 75 47 00 00       	push   $0x4775
     4cd:	e8 03 3c 00 00       	call   40d5 <open>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4dc:	78 3c                	js     51a <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4de:	a1 14 65 00 00       	mov    0x6514,%eax
     4e3:	83 ec 08             	sub    $0x8,%esp
     4e6:	68 1f 48 00 00       	push   $0x481f
     4eb:	50                   	push   %eax
     4ec:	e8 20 3d 00 00       	call   4211 <printf>
     4f1:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f4:	83 ec 04             	sub    $0x4,%esp
     4f7:	68 d0 07 00 00       	push   $0x7d0
     4fc:	68 40 65 00 00       	push   $0x6540
     501:	ff 75 f0             	push   -0x10(%ebp)
     504:	e8 a4 3b 00 00       	call   40ad <read>
     509:	83 c4 10             	add    $0x10,%esp
     50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50f:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     516:	75 57                	jne    56f <writetest+0x1c1>
     518:	eb 1b                	jmp    535 <writetest+0x187>
    printf(stdout, "error: open small failed!\n");
     51a:	a1 14 65 00 00       	mov    0x6514,%eax
     51f:	83 ec 08             	sub    $0x8,%esp
     522:	68 38 48 00 00       	push   $0x4838
     527:	50                   	push   %eax
     528:	e8 e4 3c 00 00       	call   4211 <printf>
     52d:	83 c4 10             	add    $0x10,%esp
    exit();
     530:	e8 60 3b 00 00       	call   4095 <exit>
    printf(stdout, "read succeeded ok\n");
     535:	a1 14 65 00 00       	mov    0x6514,%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	68 53 48 00 00       	push   $0x4853
     542:	50                   	push   %eax
     543:	e8 c9 3c 00 00       	call   4211 <printf>
     548:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     54b:	83 ec 0c             	sub    $0xc,%esp
     54e:	ff 75 f0             	push   -0x10(%ebp)
     551:	e8 67 3b 00 00       	call   40bd <close>
     556:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     559:	83 ec 0c             	sub    $0xc,%esp
     55c:	68 75 47 00 00       	push   $0x4775
     561:	e8 7f 3b 00 00       	call   40e5 <unlink>
     566:	83 c4 10             	add    $0x10,%esp
     569:	85 c0                	test   %eax,%eax
     56b:	79 38                	jns    5a5 <writetest+0x1f7>
     56d:	eb 1b                	jmp    58a <writetest+0x1dc>
    printf(stdout, "read failed\n");
     56f:	a1 14 65 00 00       	mov    0x6514,%eax
     574:	83 ec 08             	sub    $0x8,%esp
     577:	68 66 48 00 00       	push   $0x4866
     57c:	50                   	push   %eax
     57d:	e8 8f 3c 00 00       	call   4211 <printf>
     582:	83 c4 10             	add    $0x10,%esp
    exit();
     585:	e8 0b 3b 00 00       	call   4095 <exit>
    printf(stdout, "unlink small failed\n");
     58a:	a1 14 65 00 00       	mov    0x6514,%eax
     58f:	83 ec 08             	sub    $0x8,%esp
     592:	68 73 48 00 00       	push   $0x4873
     597:	50                   	push   %eax
     598:	e8 74 3c 00 00       	call   4211 <printf>
     59d:	83 c4 10             	add    $0x10,%esp
    exit();
     5a0:	e8 f0 3a 00 00       	call   4095 <exit>
  }
  printf(stdout, "small file test ok\n");
     5a5:	a1 14 65 00 00       	mov    0x6514,%eax
     5aa:	83 ec 08             	sub    $0x8,%esp
     5ad:	68 88 48 00 00       	push   $0x4888
     5b2:	50                   	push   %eax
     5b3:	e8 59 3c 00 00       	call   4211 <printf>
     5b8:	83 c4 10             	add    $0x10,%esp
}
     5bb:	90                   	nop
     5bc:	c9                   	leave  
     5bd:	c3                   	ret    

000005be <writetest1>:

void
writetest1(void)
{
     5be:	55                   	push   %ebp
     5bf:	89 e5                	mov    %esp,%ebp
     5c1:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5c4:	a1 14 65 00 00       	mov    0x6514,%eax
     5c9:	83 ec 08             	sub    $0x8,%esp
     5cc:	68 9c 48 00 00       	push   $0x489c
     5d1:	50                   	push   %eax
     5d2:	e8 3a 3c 00 00       	call   4211 <printf>
     5d7:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	68 02 02 00 00       	push   $0x202
     5e2:	68 ac 48 00 00       	push   $0x48ac
     5e7:	e8 e9 3a 00 00       	call   40d5 <open>
     5ec:	83 c4 10             	add    $0x10,%esp
     5ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f6:	79 1b                	jns    613 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f8:	a1 14 65 00 00       	mov    0x6514,%eax
     5fd:	83 ec 08             	sub    $0x8,%esp
     600:	68 b0 48 00 00       	push   $0x48b0
     605:	50                   	push   %eax
     606:	e8 06 3c 00 00       	call   4211 <printf>
     60b:	83 c4 10             	add    $0x10,%esp
    exit();
     60e:	e8 82 3a 00 00       	call   4095 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     61a:	eb 4b                	jmp    667 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     61c:	ba 40 65 00 00       	mov    $0x6540,%edx
     621:	8b 45 f4             	mov    -0xc(%ebp),%eax
     624:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     626:	83 ec 04             	sub    $0x4,%esp
     629:	68 00 02 00 00       	push   $0x200
     62e:	68 40 65 00 00       	push   $0x6540
     633:	ff 75 ec             	push   -0x14(%ebp)
     636:	e8 7a 3a 00 00       	call   40b5 <write>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	3d 00 02 00 00       	cmp    $0x200,%eax
     643:	74 1e                	je     663 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     645:	a1 14 65 00 00       	mov    0x6514,%eax
     64a:	83 ec 04             	sub    $0x4,%esp
     64d:	ff 75 f4             	push   -0xc(%ebp)
     650:	68 ca 48 00 00       	push   $0x48ca
     655:	50                   	push   %eax
     656:	e8 b6 3b 00 00       	call   4211 <printf>
     65b:	83 c4 10             	add    $0x10,%esp
      exit();
     65e:	e8 32 3a 00 00       	call   4095 <exit>
  for(i = 0; i < MAXFILE; i++){
     663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     667:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66a:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66f:	76 ab                	jbe    61c <writetest1+0x5e>
    }
  }

  close(fd);
     671:	83 ec 0c             	sub    $0xc,%esp
     674:	ff 75 ec             	push   -0x14(%ebp)
     677:	e8 41 3a 00 00       	call   40bd <close>
     67c:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	6a 00                	push   $0x0
     684:	68 ac 48 00 00       	push   $0x48ac
     689:	e8 47 3a 00 00       	call   40d5 <open>
     68e:	83 c4 10             	add    $0x10,%esp
     691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     698:	79 1b                	jns    6b5 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     69a:	a1 14 65 00 00       	mov    0x6514,%eax
     69f:	83 ec 08             	sub    $0x8,%esp
     6a2:	68 e8 48 00 00       	push   $0x48e8
     6a7:	50                   	push   %eax
     6a8:	e8 64 3b 00 00       	call   4211 <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
    exit();
     6b0:	e8 e0 39 00 00       	call   4095 <exit>
  }

  n = 0;
     6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6bc:	83 ec 04             	sub    $0x4,%esp
     6bf:	68 00 02 00 00       	push   $0x200
     6c4:	68 40 65 00 00       	push   $0x6540
     6c9:	ff 75 ec             	push   -0x14(%ebp)
     6cc:	e8 dc 39 00 00       	call   40ad <read>
     6d1:	83 c4 10             	add    $0x10,%esp
     6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6db:	75 27                	jne    704 <writetest1+0x146>
      if(n == MAXFILE - 1){
     6dd:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6e4:	75 7d                	jne    763 <writetest1+0x1a5>
        printf(stdout, "read only %d blocks from big", n);
     6e6:	a1 14 65 00 00       	mov    0x6514,%eax
     6eb:	83 ec 04             	sub    $0x4,%esp
     6ee:	ff 75 f0             	push   -0x10(%ebp)
     6f1:	68 01 49 00 00       	push   $0x4901
     6f6:	50                   	push   %eax
     6f7:	e8 15 3b 00 00       	call   4211 <printf>
     6fc:	83 c4 10             	add    $0x10,%esp
        exit();
     6ff:	e8 91 39 00 00       	call   4095 <exit>
      }
      break;
    } else if(i != 512){
     704:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     70b:	74 1e                	je     72b <writetest1+0x16d>
      printf(stdout, "read failed %d\n", i);
     70d:	a1 14 65 00 00       	mov    0x6514,%eax
     712:	83 ec 04             	sub    $0x4,%esp
     715:	ff 75 f4             	push   -0xc(%ebp)
     718:	68 1e 49 00 00       	push   $0x491e
     71d:	50                   	push   %eax
     71e:	e8 ee 3a 00 00       	call   4211 <printf>
     723:	83 c4 10             	add    $0x10,%esp
      exit();
     726:	e8 6a 39 00 00       	call   4095 <exit>
    }
    if(((int*)buf)[0] != n){
     72b:	b8 40 65 00 00       	mov    $0x6540,%eax
     730:	8b 00                	mov    (%eax),%eax
     732:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     735:	74 23                	je     75a <writetest1+0x19c>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     737:	b8 40 65 00 00       	mov    $0x6540,%eax
      printf(stdout, "read content of block %d is %d\n",
     73c:	8b 10                	mov    (%eax),%edx
     73e:	a1 14 65 00 00       	mov    0x6514,%eax
     743:	52                   	push   %edx
     744:	ff 75 f0             	push   -0x10(%ebp)
     747:	68 30 49 00 00       	push   $0x4930
     74c:	50                   	push   %eax
     74d:	e8 bf 3a 00 00       	call   4211 <printf>
     752:	83 c4 10             	add    $0x10,%esp
      exit();
     755:	e8 3b 39 00 00       	call   4095 <exit>
    }
    n++;
     75a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    i = read(fd, buf, 512);
     75e:	e9 59 ff ff ff       	jmp    6bc <writetest1+0xfe>
      break;
     763:	90                   	nop
  }
  close(fd);
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	ff 75 ec             	push   -0x14(%ebp)
     76a:	e8 4e 39 00 00       	call   40bd <close>
     76f:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     772:	83 ec 0c             	sub    $0xc,%esp
     775:	68 ac 48 00 00       	push   $0x48ac
     77a:	e8 66 39 00 00       	call   40e5 <unlink>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	85 c0                	test   %eax,%eax
     784:	79 1b                	jns    7a1 <writetest1+0x1e3>
    printf(stdout, "unlink big failed\n");
     786:	a1 14 65 00 00       	mov    0x6514,%eax
     78b:	83 ec 08             	sub    $0x8,%esp
     78e:	68 50 49 00 00       	push   $0x4950
     793:	50                   	push   %eax
     794:	e8 78 3a 00 00       	call   4211 <printf>
     799:	83 c4 10             	add    $0x10,%esp
    exit();
     79c:	e8 f4 38 00 00       	call   4095 <exit>
  }
  printf(stdout, "big files ok\n");
     7a1:	a1 14 65 00 00       	mov    0x6514,%eax
     7a6:	83 ec 08             	sub    $0x8,%esp
     7a9:	68 63 49 00 00       	push   $0x4963
     7ae:	50                   	push   %eax
     7af:	e8 5d 3a 00 00       	call   4211 <printf>
     7b4:	83 c4 10             	add    $0x10,%esp
}
     7b7:	90                   	nop
     7b8:	c9                   	leave  
     7b9:	c3                   	ret    

000007ba <createtest>:

void
createtest(void)
{
     7ba:	55                   	push   %ebp
     7bb:	89 e5                	mov    %esp,%ebp
     7bd:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7c0:	a1 14 65 00 00       	mov    0x6514,%eax
     7c5:	83 ec 08             	sub    $0x8,%esp
     7c8:	68 74 49 00 00       	push   $0x4974
     7cd:	50                   	push   %eax
     7ce:	e8 3e 3a 00 00       	call   4211 <printf>
     7d3:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d6:	c6 05 40 85 00 00 61 	movb   $0x61,0x8540
  name[2] = '\0';
     7dd:	c6 05 42 85 00 00 00 	movb   $0x0,0x8542
  for(i = 0; i < 52; i++){
     7e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7eb:	eb 35                	jmp    822 <createtest+0x68>
    name[1] = '0' + i;
     7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f0:	83 c0 30             	add    $0x30,%eax
     7f3:	a2 41 85 00 00       	mov    %al,0x8541
    fd = open(name, O_CREATE|O_RDWR);
     7f8:	83 ec 08             	sub    $0x8,%esp
     7fb:	68 02 02 00 00       	push   $0x202
     800:	68 40 85 00 00       	push   $0x8540
     805:	e8 cb 38 00 00       	call   40d5 <open>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     810:	83 ec 0c             	sub    $0xc,%esp
     813:	ff 75 f0             	push   -0x10(%ebp)
     816:	e8 a2 38 00 00       	call   40bd <close>
     81b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     81e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     822:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     826:	7e c5                	jle    7ed <createtest+0x33>
  }
  name[0] = 'a';
     828:	c6 05 40 85 00 00 61 	movb   $0x61,0x8540
  name[2] = '\0';
     82f:	c6 05 42 85 00 00 00 	movb   $0x0,0x8542
  for(i = 0; i < 52; i++){
     836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     83d:	eb 1f                	jmp    85e <createtest+0xa4>
    name[1] = '0' + i;
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	83 c0 30             	add    $0x30,%eax
     845:	a2 41 85 00 00       	mov    %al,0x8541
    unlink(name);
     84a:	83 ec 0c             	sub    $0xc,%esp
     84d:	68 40 85 00 00       	push   $0x8540
     852:	e8 8e 38 00 00       	call   40e5 <unlink>
     857:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     85a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     862:	7e db                	jle    83f <createtest+0x85>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     864:	a1 14 65 00 00       	mov    0x6514,%eax
     869:	83 ec 08             	sub    $0x8,%esp
     86c:	68 9c 49 00 00       	push   $0x499c
     871:	50                   	push   %eax
     872:	e8 9a 39 00 00       	call   4211 <printf>
     877:	83 c4 10             	add    $0x10,%esp
}
     87a:	90                   	nop
     87b:	c9                   	leave  
     87c:	c3                   	ret    

0000087d <dirtest>:

void dirtest(void)
{
     87d:	55                   	push   %ebp
     87e:	89 e5                	mov    %esp,%ebp
     880:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     883:	a1 14 65 00 00       	mov    0x6514,%eax
     888:	83 ec 08             	sub    $0x8,%esp
     88b:	68 c2 49 00 00       	push   $0x49c2
     890:	50                   	push   %eax
     891:	e8 7b 39 00 00       	call   4211 <printf>
     896:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     899:	83 ec 0c             	sub    $0xc,%esp
     89c:	68 ce 49 00 00       	push   $0x49ce
     8a1:	e8 57 38 00 00       	call   40fd <mkdir>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	79 1b                	jns    8c8 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8ad:	a1 14 65 00 00       	mov    0x6514,%eax
     8b2:	83 ec 08             	sub    $0x8,%esp
     8b5:	68 f1 45 00 00       	push   $0x45f1
     8ba:	50                   	push   %eax
     8bb:	e8 51 39 00 00       	call   4211 <printf>
     8c0:	83 c4 10             	add    $0x10,%esp
    exit();
     8c3:	e8 cd 37 00 00       	call   4095 <exit>
  }

  if(chdir("dir0") < 0){
     8c8:	83 ec 0c             	sub    $0xc,%esp
     8cb:	68 ce 49 00 00       	push   $0x49ce
     8d0:	e8 30 38 00 00       	call   4105 <chdir>
     8d5:	83 c4 10             	add    $0x10,%esp
     8d8:	85 c0                	test   %eax,%eax
     8da:	79 1b                	jns    8f7 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8dc:	a1 14 65 00 00       	mov    0x6514,%eax
     8e1:	83 ec 08             	sub    $0x8,%esp
     8e4:	68 d3 49 00 00       	push   $0x49d3
     8e9:	50                   	push   %eax
     8ea:	e8 22 39 00 00       	call   4211 <printf>
     8ef:	83 c4 10             	add    $0x10,%esp
    exit();
     8f2:	e8 9e 37 00 00       	call   4095 <exit>
  }

  if(chdir("..") < 0){
     8f7:	83 ec 0c             	sub    $0xc,%esp
     8fa:	68 e6 49 00 00       	push   $0x49e6
     8ff:	e8 01 38 00 00       	call   4105 <chdir>
     904:	83 c4 10             	add    $0x10,%esp
     907:	85 c0                	test   %eax,%eax
     909:	79 1b                	jns    926 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     90b:	a1 14 65 00 00       	mov    0x6514,%eax
     910:	83 ec 08             	sub    $0x8,%esp
     913:	68 e9 49 00 00       	push   $0x49e9
     918:	50                   	push   %eax
     919:	e8 f3 38 00 00       	call   4211 <printf>
     91e:	83 c4 10             	add    $0x10,%esp
    exit();
     921:	e8 6f 37 00 00       	call   4095 <exit>
  }

  if(unlink("dir0") < 0){
     926:	83 ec 0c             	sub    $0xc,%esp
     929:	68 ce 49 00 00       	push   $0x49ce
     92e:	e8 b2 37 00 00       	call   40e5 <unlink>
     933:	83 c4 10             	add    $0x10,%esp
     936:	85 c0                	test   %eax,%eax
     938:	79 1b                	jns    955 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     93a:	a1 14 65 00 00       	mov    0x6514,%eax
     93f:	83 ec 08             	sub    $0x8,%esp
     942:	68 fa 49 00 00       	push   $0x49fa
     947:	50                   	push   %eax
     948:	e8 c4 38 00 00       	call   4211 <printf>
     94d:	83 c4 10             	add    $0x10,%esp
    exit();
     950:	e8 40 37 00 00       	call   4095 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     955:	a1 14 65 00 00       	mov    0x6514,%eax
     95a:	83 ec 08             	sub    $0x8,%esp
     95d:	68 0e 4a 00 00       	push   $0x4a0e
     962:	50                   	push   %eax
     963:	e8 a9 38 00 00       	call   4211 <printf>
     968:	83 c4 10             	add    $0x10,%esp
}
     96b:	90                   	nop
     96c:	c9                   	leave  
     96d:	c3                   	ret    

0000096e <exectest>:

void
exectest(void)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     974:	a1 14 65 00 00       	mov    0x6514,%eax
     979:	83 ec 08             	sub    $0x8,%esp
     97c:	68 1d 4a 00 00       	push   $0x4a1d
     981:	50                   	push   %eax
     982:	e8 8a 38 00 00       	call   4211 <printf>
     987:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     98a:	83 ec 08             	sub    $0x8,%esp
     98d:	68 00 65 00 00       	push   $0x6500
     992:	68 c8 45 00 00       	push   $0x45c8
     997:	e8 31 37 00 00       	call   40cd <exec>
     99c:	83 c4 10             	add    $0x10,%esp
     99f:	85 c0                	test   %eax,%eax
     9a1:	79 1b                	jns    9be <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     9a3:	a1 14 65 00 00       	mov    0x6514,%eax
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	68 28 4a 00 00       	push   $0x4a28
     9b0:	50                   	push   %eax
     9b1:	e8 5b 38 00 00       	call   4211 <printf>
     9b6:	83 c4 10             	add    $0x10,%esp
    exit();
     9b9:	e8 d7 36 00 00       	call   4095 <exit>
  }
}
     9be:	90                   	nop
     9bf:	c9                   	leave  
     9c0:	c3                   	ret    

000009c1 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9c1:	55                   	push   %ebp
     9c2:	89 e5                	mov    %esp,%ebp
     9c4:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c7:	83 ec 0c             	sub    $0xc,%esp
     9ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9cd:	50                   	push   %eax
     9ce:	e8 d2 36 00 00       	call   40a5 <pipe>
     9d3:	83 c4 10             	add    $0x10,%esp
     9d6:	85 c0                	test   %eax,%eax
     9d8:	74 17                	je     9f1 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9da:	83 ec 08             	sub    $0x8,%esp
     9dd:	68 3a 4a 00 00       	push   $0x4a3a
     9e2:	6a 01                	push   $0x1
     9e4:	e8 28 38 00 00       	call   4211 <printf>
     9e9:	83 c4 10             	add    $0x10,%esp
    exit();
     9ec:	e8 a4 36 00 00       	call   4095 <exit>
  }
  pid = fork();
     9f1:	e8 97 36 00 00       	call   408d <fork>
     9f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a04:	0f 85 89 00 00 00    	jne    a93 <pipe1+0xd2>
    close(fds[0]);
     a0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a0d:	83 ec 0c             	sub    $0xc,%esp
     a10:	50                   	push   %eax
     a11:	e8 a7 36 00 00       	call   40bd <close>
     a16:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a20:	eb 66                	jmp    a88 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a29:	eb 19                	jmp    a44 <pipe1+0x83>
        buf[i] = seq++;
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2e:	8d 50 01             	lea    0x1(%eax),%edx
     a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a34:	89 c2                	mov    %eax,%edx
     a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a39:	05 40 65 00 00       	add    $0x6540,%eax
     a3e:	88 10                	mov    %dl,(%eax)
      for(i = 0; i < 1033; i++)
     a40:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a44:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a4b:	7e de                	jle    a2b <pipe1+0x6a>
      if(write(fds[1], buf, 1033) != 1033){
     a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a50:	83 ec 04             	sub    $0x4,%esp
     a53:	68 09 04 00 00       	push   $0x409
     a58:	68 40 65 00 00       	push   $0x6540
     a5d:	50                   	push   %eax
     a5e:	e8 52 36 00 00       	call   40b5 <write>
     a63:	83 c4 10             	add    $0x10,%esp
     a66:	3d 09 04 00 00       	cmp    $0x409,%eax
     a6b:	74 17                	je     a84 <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a6d:	83 ec 08             	sub    $0x8,%esp
     a70:	68 49 4a 00 00       	push   $0x4a49
     a75:	6a 01                	push   $0x1
     a77:	e8 95 37 00 00       	call   4211 <printf>
     a7c:	83 c4 10             	add    $0x10,%esp
        exit();
     a7f:	e8 11 36 00 00       	call   4095 <exit>
    for(n = 0; n < 5; n++){
     a84:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a88:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a8c:	7e 94                	jle    a22 <pipe1+0x61>
      }
    }
    exit();
     a8e:	e8 02 36 00 00       	call   4095 <exit>
  } else if(pid > 0){
     a93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a97:	0f 8e f4 00 00 00    	jle    b91 <pipe1+0x1d0>
    close(fds[1]);
     a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa0:	83 ec 0c             	sub    $0xc,%esp
     aa3:	50                   	push   %eax
     aa4:	e8 14 36 00 00       	call   40bd <close>
     aa9:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     ab3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aba:	eb 66                	jmp    b22 <pipe1+0x161>
      for(i = 0; i < n; i++){
     abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ac3:	eb 3b                	jmp    b00 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac8:	05 40 65 00 00       	add    $0x6540,%eax
     acd:	0f b6 00             	movzbl (%eax),%eax
     ad0:	0f be c8             	movsbl %al,%ecx
     ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad6:	8d 50 01             	lea    0x1(%eax),%edx
     ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     adc:	31 c8                	xor    %ecx,%eax
     ade:	0f b6 c0             	movzbl %al,%eax
     ae1:	85 c0                	test   %eax,%eax
     ae3:	74 17                	je     afc <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ae5:	83 ec 08             	sub    $0x8,%esp
     ae8:	68 57 4a 00 00       	push   $0x4a57
     aed:	6a 01                	push   $0x1
     aef:	e8 1d 37 00 00       	call   4211 <printf>
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	e9 ac 00 00 00       	jmp    ba8 <pipe1+0x1e7>
      for(i = 0; i < n; i++){
     afc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b06:	7c bd                	jl     ac5 <pipe1+0x104>
          return;
        }
      }
      total += n;
     b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b0b:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b0e:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b14:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b19:	76 07                	jbe    b22 <pipe1+0x161>
        cc = sizeof(buf);
     b1b:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b25:	83 ec 04             	sub    $0x4,%esp
     b28:	ff 75 e8             	push   -0x18(%ebp)
     b2b:	68 40 65 00 00       	push   $0x6540
     b30:	50                   	push   %eax
     b31:	e8 77 35 00 00       	call   40ad <read>
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b40:	0f 8f 76 ff ff ff    	jg     abc <pipe1+0xfb>
    }
    if(total != 5 * 1033){
     b46:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b4d:	74 1a                	je     b69 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b4f:	83 ec 04             	sub    $0x4,%esp
     b52:	ff 75 e4             	push   -0x1c(%ebp)
     b55:	68 65 4a 00 00       	push   $0x4a65
     b5a:	6a 01                	push   $0x1
     b5c:	e8 b0 36 00 00       	call   4211 <printf>
     b61:	83 c4 10             	add    $0x10,%esp
      exit();
     b64:	e8 2c 35 00 00       	call   4095 <exit>
    }
    close(fds[0]);
     b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b6c:	83 ec 0c             	sub    $0xc,%esp
     b6f:	50                   	push   %eax
     b70:	e8 48 35 00 00       	call   40bd <close>
     b75:	83 c4 10             	add    $0x10,%esp
    wait();
     b78:	e8 20 35 00 00       	call   409d <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	68 8b 4a 00 00       	push   $0x4a8b
     b85:	6a 01                	push   $0x1
     b87:	e8 85 36 00 00       	call   4211 <printf>
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	eb 17                	jmp    ba8 <pipe1+0x1e7>
    printf(1, "fork() failed\n");
     b91:	83 ec 08             	sub    $0x8,%esp
     b94:	68 7c 4a 00 00       	push   $0x4a7c
     b99:	6a 01                	push   $0x1
     b9b:	e8 71 36 00 00       	call   4211 <printf>
     ba0:	83 c4 10             	add    $0x10,%esp
    exit();
     ba3:	e8 ed 34 00 00       	call   4095 <exit>
}
     ba8:	c9                   	leave  
     ba9:	c3                   	ret    

00000baa <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     baa:	55                   	push   %ebp
     bab:	89 e5                	mov    %esp,%ebp
     bad:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 95 4a 00 00       	push   $0x4a95
     bb8:	6a 01                	push   $0x1
     bba:	e8 52 36 00 00       	call   4211 <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bc2:	e8 c6 34 00 00       	call   408d <fork>
     bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bce:	75 02                	jne    bd2 <preempt+0x28>
    for(;;)
     bd0:	eb fe                	jmp    bd0 <preempt+0x26>
      ;

  pid2 = fork();
     bd2:	e8 b6 34 00 00       	call   408d <fork>
     bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bde:	75 02                	jne    be2 <preempt+0x38>
    for(;;)
     be0:	eb fe                	jmp    be0 <preempt+0x36>
      ;

  pipe(pfds);
     be2:	83 ec 0c             	sub    $0xc,%esp
     be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be8:	50                   	push   %eax
     be9:	e8 b7 34 00 00       	call   40a5 <pipe>
     bee:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bf1:	e8 97 34 00 00       	call   408d <fork>
     bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bfd:	75 4d                	jne    c4c <preempt+0xa2>
    close(pfds[0]);
     bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c02:	83 ec 0c             	sub    $0xc,%esp
     c05:	50                   	push   %eax
     c06:	e8 b2 34 00 00       	call   40bd <close>
     c0b:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c11:	83 ec 04             	sub    $0x4,%esp
     c14:	6a 01                	push   $0x1
     c16:	68 9f 4a 00 00       	push   $0x4a9f
     c1b:	50                   	push   %eax
     c1c:	e8 94 34 00 00       	call   40b5 <write>
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	83 f8 01             	cmp    $0x1,%eax
     c27:	74 12                	je     c3b <preempt+0x91>
      printf(1, "preempt write error");
     c29:	83 ec 08             	sub    $0x8,%esp
     c2c:	68 a1 4a 00 00       	push   $0x4aa1
     c31:	6a 01                	push   $0x1
     c33:	e8 d9 35 00 00       	call   4211 <printf>
     c38:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3e:	83 ec 0c             	sub    $0xc,%esp
     c41:	50                   	push   %eax
     c42:	e8 76 34 00 00       	call   40bd <close>
     c47:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c4a:	eb fe                	jmp    c4a <preempt+0xa0>
      ;
  }

  close(pfds[1]);
     c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c4f:	83 ec 0c             	sub    $0xc,%esp
     c52:	50                   	push   %eax
     c53:	e8 65 34 00 00       	call   40bd <close>
     c58:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c5e:	83 ec 04             	sub    $0x4,%esp
     c61:	68 00 20 00 00       	push   $0x2000
     c66:	68 40 65 00 00       	push   $0x6540
     c6b:	50                   	push   %eax
     c6c:	e8 3c 34 00 00       	call   40ad <read>
     c71:	83 c4 10             	add    $0x10,%esp
     c74:	83 f8 01             	cmp    $0x1,%eax
     c77:	74 14                	je     c8d <preempt+0xe3>
    printf(1, "preempt read error");
     c79:	83 ec 08             	sub    $0x8,%esp
     c7c:	68 b5 4a 00 00       	push   $0x4ab5
     c81:	6a 01                	push   $0x1
     c83:	e8 89 35 00 00       	call   4211 <printf>
     c88:	83 c4 10             	add    $0x10,%esp
     c8b:	eb 7e                	jmp    d0b <preempt+0x161>
    return;
  }
  close(pfds[0]);
     c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c90:	83 ec 0c             	sub    $0xc,%esp
     c93:	50                   	push   %eax
     c94:	e8 24 34 00 00       	call   40bd <close>
     c99:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c9c:	83 ec 08             	sub    $0x8,%esp
     c9f:	68 c8 4a 00 00       	push   $0x4ac8
     ca4:	6a 01                	push   $0x1
     ca6:	e8 66 35 00 00       	call   4211 <printf>
     cab:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     cae:	83 ec 0c             	sub    $0xc,%esp
     cb1:	ff 75 f4             	push   -0xc(%ebp)
     cb4:	e8 0c 34 00 00       	call   40c5 <kill>
     cb9:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     cbc:	83 ec 0c             	sub    $0xc,%esp
     cbf:	ff 75 f0             	push   -0x10(%ebp)
     cc2:	e8 fe 33 00 00       	call   40c5 <kill>
     cc7:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cca:	83 ec 0c             	sub    $0xc,%esp
     ccd:	ff 75 ec             	push   -0x14(%ebp)
     cd0:	e8 f0 33 00 00       	call   40c5 <kill>
     cd5:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cd8:	83 ec 08             	sub    $0x8,%esp
     cdb:	68 d1 4a 00 00       	push   $0x4ad1
     ce0:	6a 01                	push   $0x1
     ce2:	e8 2a 35 00 00       	call   4211 <printf>
     ce7:	83 c4 10             	add    $0x10,%esp
  wait();
     cea:	e8 ae 33 00 00       	call   409d <wait>
  wait();
     cef:	e8 a9 33 00 00       	call   409d <wait>
  wait();
     cf4:	e8 a4 33 00 00       	call   409d <wait>
  printf(1, "preempt ok\n");
     cf9:	83 ec 08             	sub    $0x8,%esp
     cfc:	68 da 4a 00 00       	push   $0x4ada
     d01:	6a 01                	push   $0x1
     d03:	e8 09 35 00 00       	call   4211 <printf>
     d08:	83 c4 10             	add    $0x10,%esp
}
     d0b:	c9                   	leave  
     d0c:	c3                   	ret    

00000d0d <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d0d:	55                   	push   %ebp
     d0e:	89 e5                	mov    %esp,%ebp
     d10:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d1a:	eb 4f                	jmp    d6b <exitwait+0x5e>
    pid = fork();
     d1c:	e8 6c 33 00 00       	call   408d <fork>
     d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d28:	79 14                	jns    d3e <exitwait+0x31>
      printf(1, "fork failed\n");
     d2a:	83 ec 08             	sub    $0x8,%esp
     d2d:	68 69 46 00 00       	push   $0x4669
     d32:	6a 01                	push   $0x1
     d34:	e8 d8 34 00 00       	call   4211 <printf>
     d39:	83 c4 10             	add    $0x10,%esp
      return;
     d3c:	eb 45                	jmp    d83 <exitwait+0x76>
    }
    if(pid){
     d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d42:	74 1e                	je     d62 <exitwait+0x55>
      if(wait() != pid){
     d44:	e8 54 33 00 00       	call   409d <wait>
     d49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     d4c:	74 19                	je     d67 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d4e:	83 ec 08             	sub    $0x8,%esp
     d51:	68 e6 4a 00 00       	push   $0x4ae6
     d56:	6a 01                	push   $0x1
     d58:	e8 b4 34 00 00       	call   4211 <printf>
     d5d:	83 c4 10             	add    $0x10,%esp
        return;
     d60:	eb 21                	jmp    d83 <exitwait+0x76>
      }
    } else {
      exit();
     d62:	e8 2e 33 00 00       	call   4095 <exit>
  for(i = 0; i < 100; i++){
     d67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d6b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d6f:	7e ab                	jle    d1c <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
     d71:	83 ec 08             	sub    $0x8,%esp
     d74:	68 f6 4a 00 00       	push   $0x4af6
     d79:	6a 01                	push   $0x1
     d7b:	e8 91 34 00 00       	call   4211 <printf>
     d80:	83 c4 10             	add    $0x10,%esp
}
     d83:	c9                   	leave  
     d84:	c3                   	ret    

00000d85 <mem>:

void
mem(void)
{
     d85:	55                   	push   %ebp
     d86:	89 e5                	mov    %esp,%ebp
     d88:	83 ec 28             	sub    $0x28,%esp
	void *m1 = 0, *m2, *start;
     d8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint cur = 0;
     d92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint count = 0;
     d99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint total_count;
	int pid;

	printf(1, "mem test\n");
     da0:	83 ec 08             	sub    $0x8,%esp
     da3:	68 03 4b 00 00       	push   $0x4b03
     da8:	6a 01                	push   $0x1
     daa:	e8 62 34 00 00       	call   4211 <printf>
     daf:	83 c4 10             	add    $0x10,%esp

	m1 = malloc(4096);
     db2:	83 ec 0c             	sub    $0xc,%esp
     db5:	68 00 10 00 00       	push   $0x1000
     dba:	e8 26 37 00 00       	call   44e5 <malloc>
     dbf:	83 c4 10             	add    $0x10,%esp
     dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (m1 == 0)
     dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dc9:	0f 84 15 01 00 00    	je     ee4 <mem+0x15f>
		goto failed;
	start = m1;
     dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	while (cur < TOTAL_MEMORY) {
     dd5:	eb 43                	jmp    e1a <mem+0x95>
		m2 = malloc(4096);
     dd7:	83 ec 0c             	sub    $0xc,%esp
     dda:	68 00 10 00 00       	push   $0x1000
     ddf:	e8 01 37 00 00       	call   44e5 <malloc>
     de4:	83 c4 10             	add    $0x10,%esp
     de7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (m2 == 0)
     dea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     dee:	0f 84 f3 00 00 00    	je     ee7 <mem+0x162>
			goto failed;
		*(char**)m1 = m2;
     df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df7:	8b 55 dc             	mov    -0x24(%ebp),%edx
     dfa:	89 10                	mov    %edx,(%eax)
		((int*)m1)[2] = count++;
     dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     dff:	8d 50 01             	lea    0x1(%eax),%edx
     e02:	89 55 ec             	mov    %edx,-0x14(%ebp)
     e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e08:	83 c2 08             	add    $0x8,%edx
     e0b:	89 02                	mov    %eax,(%edx)
		m1 = m2;
     e0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cur += 4096;
     e13:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	while (cur < TOTAL_MEMORY) {
     e1a:	81 7d f0 ff ff 13 00 	cmpl   $0x13ffff,-0x10(%ebp)
     e21:	76 b4                	jbe    dd7 <mem+0x52>
	}
	((int*)m1)[2] = count;
     e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e26:	8d 50 08             	lea    0x8(%eax),%edx
     e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e2c:	89 02                	mov    %eax,(%edx)
	total_count = count;
     e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e31:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	count = 0;
     e34:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	m1 = start;
     e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while (count != total_count) {
     e41:	eb 1d                	jmp    e60 <mem+0xdb>
		if (((int*)m1)[2] != count)
     e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e46:	83 c0 08             	add    $0x8,%eax
     e49:	8b 00                	mov    (%eax),%eax
     e4b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
     e4e:	0f 85 96 00 00 00    	jne    eea <mem+0x165>
			goto failed;
		m1 = *(char**)m1;
     e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e57:	8b 00                	mov    (%eax),%eax
     e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		count++;
     e5c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	while (count != total_count) {
     e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e63:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     e66:	75 db                	jne    e43 <mem+0xbe>
	}

	pid = fork();
     e68:	e8 20 32 00 00       	call   408d <fork>
     e6d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (pid == 0){
     e70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     e74:	75 35                	jne    eab <mem+0x126>
		count = 0;
     e76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		m1 = start;
     e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
		while (count != total_count) {
     e83:	eb 19                	jmp    e9e <mem+0x119>
			if (((int*)m1)[2] != count){
     e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e88:	83 c0 08             	add    $0x8,%eax
     e8b:	8b 00                	mov    (%eax),%eax
     e8d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
     e90:	75 5b                	jne    eed <mem+0x168>
				goto failed;
			}
			m1 = *(char**)m1;
     e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e95:	8b 00                	mov    (%eax),%eax
     e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
			count++;
     e9a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
		while (count != total_count) {
     e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ea1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     ea4:	75 df                	jne    e85 <mem+0x100>
		}
		exit();
     ea6:	e8 ea 31 00 00       	call   4095 <exit>
	}
	else if (pid < 0)
     eab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     eaf:	79 14                	jns    ec5 <mem+0x140>
	{
		printf(1, "fork failed\n");
     eb1:	83 ec 08             	sub    $0x8,%esp
     eb4:	68 69 46 00 00       	push   $0x4669
     eb9:	6a 01                	push   $0x1
     ebb:	e8 51 33 00 00       	call   4211 <printf>
     ec0:	83 c4 10             	add    $0x10,%esp
     ec3:	eb 0b                	jmp    ed0 <mem+0x14b>
	}
	else if (pid > 0)
     ec5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     ec9:	7e 05                	jle    ed0 <mem+0x14b>
	{
		wait();
     ecb:	e8 cd 31 00 00       	call   409d <wait>
	}

	printf(1, "mem ok\n");
     ed0:	83 ec 08             	sub    $0x8,%esp
     ed3:	68 0d 4b 00 00       	push   $0x4b0d
     ed8:	6a 01                	push   $0x1
     eda:	e8 32 33 00 00       	call   4211 <printf>
     edf:	83 c4 10             	add    $0x10,%esp
     ee2:	eb 0a                	jmp    eee <mem+0x169>
		goto failed;
     ee4:	90                   	nop
     ee5:	eb 07                	jmp    eee <mem+0x169>
			goto failed;
     ee7:	90                   	nop
     ee8:	eb 04                	jmp    eee <mem+0x169>
			goto failed;
     eea:	90                   	nop
     eeb:	eb 01                	jmp    eee <mem+0x169>
				goto failed;
     eed:	90                   	nop
failed:
	printf(1, "test failed!\n");
     eee:	83 ec 08             	sub    $0x8,%esp
     ef1:	68 15 4b 00 00       	push   $0x4b15
     ef6:	6a 01                	push   $0x1
     ef8:	e8 14 33 00 00       	call   4211 <printf>
     efd:	83 c4 10             	add    $0x10,%esp
}
     f00:	90                   	nop
     f01:	c9                   	leave  
     f02:	c3                   	ret    

00000f03 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     f03:	55                   	push   %ebp
     f04:	89 e5                	mov    %esp,%ebp
     f06:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     f09:	83 ec 08             	sub    $0x8,%esp
     f0c:	68 23 4b 00 00       	push   $0x4b23
     f11:	6a 01                	push   $0x1
     f13:	e8 f9 32 00 00       	call   4211 <printf>
     f18:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     f1b:	83 ec 0c             	sub    $0xc,%esp
     f1e:	68 32 4b 00 00       	push   $0x4b32
     f23:	e8 bd 31 00 00       	call   40e5 <unlink>
     f28:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     f2b:	83 ec 08             	sub    $0x8,%esp
     f2e:	68 02 02 00 00       	push   $0x202
     f33:	68 32 4b 00 00       	push   $0x4b32
     f38:	e8 98 31 00 00       	call   40d5 <open>
     f3d:	83 c4 10             	add    $0x10,%esp
     f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f47:	79 17                	jns    f60 <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     f49:	83 ec 08             	sub    $0x8,%esp
     f4c:	68 3c 4b 00 00       	push   $0x4b3c
     f51:	6a 01                	push   $0x1
     f53:	e8 b9 32 00 00       	call   4211 <printf>
     f58:	83 c4 10             	add    $0x10,%esp
    return;
     f5b:	e9 84 01 00 00       	jmp    10e4 <sharedfd+0x1e1>
  }
  pid = fork();
     f60:	e8 28 31 00 00       	call   408d <fork>
     f65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     f68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f6c:	75 07                	jne    f75 <sharedfd+0x72>
     f6e:	b8 63 00 00 00       	mov    $0x63,%eax
     f73:	eb 05                	jmp    f7a <sharedfd+0x77>
     f75:	b8 70 00 00 00       	mov    $0x70,%eax
     f7a:	83 ec 04             	sub    $0x4,%esp
     f7d:	6a 0a                	push   $0xa
     f7f:	50                   	push   %eax
     f80:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f83:	50                   	push   %eax
     f84:	e8 71 2f 00 00       	call   3efa <memset>
     f89:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     f8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f93:	eb 31                	jmp    fc6 <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f95:	83 ec 04             	sub    $0x4,%esp
     f98:	6a 0a                	push   $0xa
     f9a:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f9d:	50                   	push   %eax
     f9e:	ff 75 e8             	push   -0x18(%ebp)
     fa1:	e8 0f 31 00 00       	call   40b5 <write>
     fa6:	83 c4 10             	add    $0x10,%esp
     fa9:	83 f8 0a             	cmp    $0xa,%eax
     fac:	74 14                	je     fc2 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     fae:	83 ec 08             	sub    $0x8,%esp
     fb1:	68 68 4b 00 00       	push   $0x4b68
     fb6:	6a 01                	push   $0x1
     fb8:	e8 54 32 00 00       	call   4211 <printf>
     fbd:	83 c4 10             	add    $0x10,%esp
      break;
     fc0:	eb 0d                	jmp    fcf <sharedfd+0xcc>
  for(i = 0; i < 1000; i++){
     fc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fc6:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     fcd:	7e c6                	jle    f95 <sharedfd+0x92>
    }
  }
  if(pid == 0)
     fcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     fd3:	75 05                	jne    fda <sharedfd+0xd7>
    exit();
     fd5:	e8 bb 30 00 00       	call   4095 <exit>
  else
    wait();
     fda:	e8 be 30 00 00       	call   409d <wait>
  close(fd);
     fdf:	83 ec 0c             	sub    $0xc,%esp
     fe2:	ff 75 e8             	push   -0x18(%ebp)
     fe5:	e8 d3 30 00 00       	call   40bd <close>
     fea:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     fed:	83 ec 08             	sub    $0x8,%esp
     ff0:	6a 00                	push   $0x0
     ff2:	68 32 4b 00 00       	push   $0x4b32
     ff7:	e8 d9 30 00 00       	call   40d5 <open>
     ffc:	83 c4 10             	add    $0x10,%esp
     fff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    1002:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1006:	79 17                	jns    101f <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1008:	83 ec 08             	sub    $0x8,%esp
    100b:	68 88 4b 00 00       	push   $0x4b88
    1010:	6a 01                	push   $0x1
    1012:	e8 fa 31 00 00       	call   4211 <printf>
    1017:	83 c4 10             	add    $0x10,%esp
    return;
    101a:	e9 c5 00 00 00       	jmp    10e4 <sharedfd+0x1e1>
  }
  nc = np = 0;
    101f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1026:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1029:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    102c:	eb 3b                	jmp    1069 <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
    102e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1035:	eb 2a                	jmp    1061 <sharedfd+0x15e>
      if(buf[i] == 'c')
    1037:	8d 55 d6             	lea    -0x2a(%ebp),%edx
    103a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103d:	01 d0                	add    %edx,%eax
    103f:	0f b6 00             	movzbl (%eax),%eax
    1042:	3c 63                	cmp    $0x63,%al
    1044:	75 04                	jne    104a <sharedfd+0x147>
        nc++;
    1046:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
    104a:	8d 55 d6             	lea    -0x2a(%ebp),%edx
    104d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1050:	01 d0                	add    %edx,%eax
    1052:	0f b6 00             	movzbl (%eax),%eax
    1055:	3c 70                	cmp    $0x70,%al
    1057:	75 04                	jne    105d <sharedfd+0x15a>
        np++;
    1059:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
    105d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1061:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1064:	83 f8 09             	cmp    $0x9,%eax
    1067:	76 ce                	jbe    1037 <sharedfd+0x134>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1069:	83 ec 04             	sub    $0x4,%esp
    106c:	6a 0a                	push   $0xa
    106e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1071:	50                   	push   %eax
    1072:	ff 75 e8             	push   -0x18(%ebp)
    1075:	e8 33 30 00 00       	call   40ad <read>
    107a:	83 c4 10             	add    $0x10,%esp
    107d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1080:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1084:	7f a8                	jg     102e <sharedfd+0x12b>
    }
  }
  close(fd);
    1086:	83 ec 0c             	sub    $0xc,%esp
    1089:	ff 75 e8             	push   -0x18(%ebp)
    108c:	e8 2c 30 00 00       	call   40bd <close>
    1091:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
    1094:	83 ec 0c             	sub    $0xc,%esp
    1097:	68 32 4b 00 00       	push   $0x4b32
    109c:	e8 44 30 00 00       	call   40e5 <unlink>
    10a1:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    10a4:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    10ab:	75 1d                	jne    10ca <sharedfd+0x1c7>
    10ad:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    10b4:	75 14                	jne    10ca <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    10b6:	83 ec 08             	sub    $0x8,%esp
    10b9:	68 b3 4b 00 00       	push   $0x4bb3
    10be:	6a 01                	push   $0x1
    10c0:	e8 4c 31 00 00       	call   4211 <printf>
    10c5:	83 c4 10             	add    $0x10,%esp
    10c8:	eb 1a                	jmp    10e4 <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    10ca:	ff 75 ec             	push   -0x14(%ebp)
    10cd:	ff 75 f0             	push   -0x10(%ebp)
    10d0:	68 c0 4b 00 00       	push   $0x4bc0
    10d5:	6a 01                	push   $0x1
    10d7:	e8 35 31 00 00       	call   4211 <printf>
    10dc:	83 c4 10             	add    $0x10,%esp
    exit();
    10df:	e8 b1 2f 00 00       	call   4095 <exit>
  }
}
    10e4:	c9                   	leave  
    10e5:	c3                   	ret    

000010e6 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    10e6:	55                   	push   %ebp
    10e7:	89 e5                	mov    %esp,%ebp
    10e9:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    10ec:	c7 45 c8 d5 4b 00 00 	movl   $0x4bd5,-0x38(%ebp)
    10f3:	c7 45 cc d8 4b 00 00 	movl   $0x4bd8,-0x34(%ebp)
    10fa:	c7 45 d0 db 4b 00 00 	movl   $0x4bdb,-0x30(%ebp)
    1101:	c7 45 d4 de 4b 00 00 	movl   $0x4bde,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1108:	83 ec 08             	sub    $0x8,%esp
    110b:	68 e1 4b 00 00       	push   $0x4be1
    1110:	6a 01                	push   $0x1
    1112:	e8 fa 30 00 00       	call   4211 <printf>
    1117:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    111a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1121:	e9 f0 00 00 00       	jmp    1216 <fourfiles+0x130>
    fname = names[pi];
    1126:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1129:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    1130:	83 ec 0c             	sub    $0xc,%esp
    1133:	ff 75 e4             	push   -0x1c(%ebp)
    1136:	e8 aa 2f 00 00       	call   40e5 <unlink>
    113b:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    113e:	e8 4a 2f 00 00       	call   408d <fork>
    1143:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(pid < 0){
    1146:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    114a:	79 17                	jns    1163 <fourfiles+0x7d>
      printf(1, "fork failed\n");
    114c:	83 ec 08             	sub    $0x8,%esp
    114f:	68 69 46 00 00       	push   $0x4669
    1154:	6a 01                	push   $0x1
    1156:	e8 b6 30 00 00       	call   4211 <printf>
    115b:	83 c4 10             	add    $0x10,%esp
      exit();
    115e:	e8 32 2f 00 00       	call   4095 <exit>
    }

    if(pid == 0){
    1163:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    1167:	0f 85 a5 00 00 00    	jne    1212 <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    116d:	83 ec 08             	sub    $0x8,%esp
    1170:	68 02 02 00 00       	push   $0x202
    1175:	ff 75 e4             	push   -0x1c(%ebp)
    1178:	e8 58 2f 00 00       	call   40d5 <open>
    117d:	83 c4 10             	add    $0x10,%esp
    1180:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(fd < 0){
    1183:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1187:	79 17                	jns    11a0 <fourfiles+0xba>
        printf(1, "create failed\n");
    1189:	83 ec 08             	sub    $0x8,%esp
    118c:	68 f1 4b 00 00       	push   $0x4bf1
    1191:	6a 01                	push   $0x1
    1193:	e8 79 30 00 00       	call   4211 <printf>
    1198:	83 c4 10             	add    $0x10,%esp
        exit();
    119b:	e8 f5 2e 00 00       	call   4095 <exit>
      }

      memset(buf, '0'+pi, 512);
    11a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11a3:	83 c0 30             	add    $0x30,%eax
    11a6:	83 ec 04             	sub    $0x4,%esp
    11a9:	68 00 02 00 00       	push   $0x200
    11ae:	50                   	push   %eax
    11af:	68 40 65 00 00       	push   $0x6540
    11b4:	e8 41 2d 00 00       	call   3efa <memset>
    11b9:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    11bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11c3:	eb 42                	jmp    1207 <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    11c5:	83 ec 04             	sub    $0x4,%esp
    11c8:	68 f4 01 00 00       	push   $0x1f4
    11cd:	68 40 65 00 00       	push   $0x6540
    11d2:	ff 75 e0             	push   -0x20(%ebp)
    11d5:	e8 db 2e 00 00       	call   40b5 <write>
    11da:	83 c4 10             	add    $0x10,%esp
    11dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    11e0:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
    11e7:	74 1a                	je     1203 <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    11e9:	83 ec 04             	sub    $0x4,%esp
    11ec:	ff 75 dc             	push   -0x24(%ebp)
    11ef:	68 00 4c 00 00       	push   $0x4c00
    11f4:	6a 01                	push   $0x1
    11f6:	e8 16 30 00 00       	call   4211 <printf>
    11fb:	83 c4 10             	add    $0x10,%esp
          exit();
    11fe:	e8 92 2e 00 00       	call   4095 <exit>
      for(i = 0; i < 12; i++){
    1203:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1207:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    120b:	7e b8                	jle    11c5 <fourfiles+0xdf>
        }
      }
      exit();
    120d:	e8 83 2e 00 00       	call   4095 <exit>
  for(pi = 0; pi < 4; pi++){
    1212:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1216:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    121a:	0f 8e 06 ff ff ff    	jle    1126 <fourfiles+0x40>
    }
  }

  for(pi = 0; pi < 4; pi++){
    1220:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1227:	eb 09                	jmp    1232 <fourfiles+0x14c>
    wait();
    1229:	e8 6f 2e 00 00       	call   409d <wait>
  for(pi = 0; pi < 4; pi++){
    122e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1232:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1236:	7e f1                	jle    1229 <fourfiles+0x143>
  }

  for(i = 0; i < 2; i++){
    1238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    123f:	e9 d4 00 00 00       	jmp    1318 <fourfiles+0x232>
    fname = names[i];
    1244:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1247:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    124e:	83 ec 08             	sub    $0x8,%esp
    1251:	6a 00                	push   $0x0
    1253:	ff 75 e4             	push   -0x1c(%ebp)
    1256:	e8 7a 2e 00 00       	call   40d5 <open>
    125b:	83 c4 10             	add    $0x10,%esp
    125e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
    1261:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1268:	eb 4a                	jmp    12b4 <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    126a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1271:	eb 33                	jmp    12a6 <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    1273:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1276:	05 40 65 00 00       	add    $0x6540,%eax
    127b:	0f b6 00             	movzbl (%eax),%eax
    127e:	0f be c0             	movsbl %al,%eax
    1281:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1284:	83 c2 30             	add    $0x30,%edx
    1287:	39 d0                	cmp    %edx,%eax
    1289:	74 17                	je     12a2 <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    128b:	83 ec 08             	sub    $0x8,%esp
    128e:	68 11 4c 00 00       	push   $0x4c11
    1293:	6a 01                	push   $0x1
    1295:	e8 77 2f 00 00       	call   4211 <printf>
    129a:	83 c4 10             	add    $0x10,%esp
          exit();
    129d:	e8 f3 2d 00 00       	call   4095 <exit>
      for(j = 0; j < n; j++){
    12a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    12a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12a9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    12ac:	7c c5                	jl     1273 <fourfiles+0x18d>
        }
      }
      total += n;
    12ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
    12b1:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    12b4:	83 ec 04             	sub    $0x4,%esp
    12b7:	68 00 20 00 00       	push   $0x2000
    12bc:	68 40 65 00 00       	push   $0x6540
    12c1:	ff 75 e0             	push   -0x20(%ebp)
    12c4:	e8 e4 2d 00 00       	call   40ad <read>
    12c9:	83 c4 10             	add    $0x10,%esp
    12cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    12cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    12d3:	7f 95                	jg     126a <fourfiles+0x184>
    }
    close(fd);
    12d5:	83 ec 0c             	sub    $0xc,%esp
    12d8:	ff 75 e0             	push   -0x20(%ebp)
    12db:	e8 dd 2d 00 00       	call   40bd <close>
    12e0:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    12e3:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    12ea:	74 1a                	je     1306 <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    12ec:	83 ec 04             	sub    $0x4,%esp
    12ef:	ff 75 ec             	push   -0x14(%ebp)
    12f2:	68 1d 4c 00 00       	push   $0x4c1d
    12f7:	6a 01                	push   $0x1
    12f9:	e8 13 2f 00 00       	call   4211 <printf>
    12fe:	83 c4 10             	add    $0x10,%esp
      exit();
    1301:	e8 8f 2d 00 00       	call   4095 <exit>
    }
    unlink(fname);
    1306:	83 ec 0c             	sub    $0xc,%esp
    1309:	ff 75 e4             	push   -0x1c(%ebp)
    130c:	e8 d4 2d 00 00       	call   40e5 <unlink>
    1311:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 2; i++){
    1314:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1318:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    131c:	0f 8e 22 ff ff ff    	jle    1244 <fourfiles+0x15e>
  }

  printf(1, "fourfiles ok\n");
    1322:	83 ec 08             	sub    $0x8,%esp
    1325:	68 2e 4c 00 00       	push   $0x4c2e
    132a:	6a 01                	push   $0x1
    132c:	e8 e0 2e 00 00       	call   4211 <printf>
    1331:	83 c4 10             	add    $0x10,%esp
}
    1334:	90                   	nop
    1335:	c9                   	leave  
    1336:	c3                   	ret    

00001337 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1337:	55                   	push   %ebp
    1338:	89 e5                	mov    %esp,%ebp
    133a:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    133d:	83 ec 08             	sub    $0x8,%esp
    1340:	68 3c 4c 00 00       	push   $0x4c3c
    1345:	6a 01                	push   $0x1
    1347:	e8 c5 2e 00 00       	call   4211 <printf>
    134c:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    134f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1356:	e9 f6 00 00 00       	jmp    1451 <createdelete+0x11a>
    pid = fork();
    135b:	e8 2d 2d 00 00       	call   408d <fork>
    1360:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    1363:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1367:	79 17                	jns    1380 <createdelete+0x49>
      printf(1, "fork failed\n");
    1369:	83 ec 08             	sub    $0x8,%esp
    136c:	68 69 46 00 00       	push   $0x4669
    1371:	6a 01                	push   $0x1
    1373:	e8 99 2e 00 00       	call   4211 <printf>
    1378:	83 c4 10             	add    $0x10,%esp
      exit();
    137b:	e8 15 2d 00 00       	call   4095 <exit>
    }

    if(pid == 0){
    1380:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1384:	0f 85 c3 00 00 00    	jne    144d <createdelete+0x116>
      name[0] = 'p' + pi;
    138a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    138d:	83 c0 70             	add    $0x70,%eax
    1390:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1393:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    1397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    139e:	e9 9b 00 00 00       	jmp    143e <createdelete+0x107>
        name[1] = '0' + i;
    13a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a6:	83 c0 30             	add    $0x30,%eax
    13a9:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    13ac:	83 ec 08             	sub    $0x8,%esp
    13af:	68 02 02 00 00       	push   $0x202
    13b4:	8d 45 c8             	lea    -0x38(%ebp),%eax
    13b7:	50                   	push   %eax
    13b8:	e8 18 2d 00 00       	call   40d5 <open>
    13bd:	83 c4 10             	add    $0x10,%esp
    13c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if(fd < 0){
    13c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13c7:	79 17                	jns    13e0 <createdelete+0xa9>
          printf(1, "create failed\n");
    13c9:	83 ec 08             	sub    $0x8,%esp
    13cc:	68 f1 4b 00 00       	push   $0x4bf1
    13d1:	6a 01                	push   $0x1
    13d3:	e8 39 2e 00 00       	call   4211 <printf>
    13d8:	83 c4 10             	add    $0x10,%esp
          exit();
    13db:	e8 b5 2c 00 00       	call   4095 <exit>
        }
        close(fd);
    13e0:	83 ec 0c             	sub    $0xc,%esp
    13e3:	ff 75 ec             	push   -0x14(%ebp)
    13e6:	e8 d2 2c 00 00       	call   40bd <close>
    13eb:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    13ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13f2:	7e 46                	jle    143a <createdelete+0x103>
    13f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f7:	83 e0 01             	and    $0x1,%eax
    13fa:	85 c0                	test   %eax,%eax
    13fc:	75 3c                	jne    143a <createdelete+0x103>
          name[1] = '0' + (i / 2);
    13fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1401:	89 c2                	mov    %eax,%edx
    1403:	c1 ea 1f             	shr    $0x1f,%edx
    1406:	01 d0                	add    %edx,%eax
    1408:	d1 f8                	sar    %eax
    140a:	83 c0 30             	add    $0x30,%eax
    140d:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1410:	83 ec 0c             	sub    $0xc,%esp
    1413:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1416:	50                   	push   %eax
    1417:	e8 c9 2c 00 00       	call   40e5 <unlink>
    141c:	83 c4 10             	add    $0x10,%esp
    141f:	85 c0                	test   %eax,%eax
    1421:	79 17                	jns    143a <createdelete+0x103>
            printf(1, "unlink failed\n");
    1423:	83 ec 08             	sub    $0x8,%esp
    1426:	68 ec 46 00 00       	push   $0x46ec
    142b:	6a 01                	push   $0x1
    142d:	e8 df 2d 00 00       	call   4211 <printf>
    1432:	83 c4 10             	add    $0x10,%esp
            exit();
    1435:	e8 5b 2c 00 00       	call   4095 <exit>
      for(i = 0; i < N; i++){
    143a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    143e:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1442:	0f 8e 5b ff ff ff    	jle    13a3 <createdelete+0x6c>
          }
        }
      }
      exit();
    1448:	e8 48 2c 00 00       	call   4095 <exit>
  for(pi = 0; pi < 4; pi++){
    144d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1451:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1455:	0f 8e 00 ff ff ff    	jle    135b <createdelete+0x24>
    }
  }

  for(pi = 0; pi < 4; pi++){
    145b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1462:	eb 09                	jmp    146d <createdelete+0x136>
    wait();
    1464:	e8 34 2c 00 00       	call   409d <wait>
  for(pi = 0; pi < 4; pi++){
    1469:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    146d:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1471:	7e f1                	jle    1464 <createdelete+0x12d>
  }

  name[0] = name[1] = name[2] = 0;
    1473:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1477:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    147b:	88 45 c9             	mov    %al,-0x37(%ebp)
    147e:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    1482:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    1485:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    148c:	e9 b2 00 00 00       	jmp    1543 <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    1491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1498:	e9 98 00 00 00       	jmp    1535 <createdelete+0x1fe>
      name[0] = 'p' + pi;
    149d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14a0:	83 c0 70             	add    $0x70,%eax
    14a3:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a9:	83 c0 30             	add    $0x30,%eax
    14ac:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    14af:	83 ec 08             	sub    $0x8,%esp
    14b2:	6a 00                	push   $0x0
    14b4:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14b7:	50                   	push   %eax
    14b8:	e8 18 2c 00 00       	call   40d5 <open>
    14bd:	83 c4 10             	add    $0x10,%esp
    14c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    14c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14c7:	74 06                	je     14cf <createdelete+0x198>
    14c9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    14cd:	7e 21                	jle    14f0 <createdelete+0x1b9>
    14cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14d3:	79 1b                	jns    14f0 <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    14d5:	83 ec 04             	sub    $0x4,%esp
    14d8:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14db:	50                   	push   %eax
    14dc:	68 50 4c 00 00       	push   $0x4c50
    14e1:	6a 01                	push   $0x1
    14e3:	e8 29 2d 00 00       	call   4211 <printf>
    14e8:	83 c4 10             	add    $0x10,%esp
        exit();
    14eb:	e8 a5 2b 00 00       	call   4095 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    14f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14f4:	7e 27                	jle    151d <createdelete+0x1e6>
    14f6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    14fa:	7f 21                	jg     151d <createdelete+0x1e6>
    14fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1500:	78 1b                	js     151d <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    1502:	83 ec 04             	sub    $0x4,%esp
    1505:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1508:	50                   	push   %eax
    1509:	68 74 4c 00 00       	push   $0x4c74
    150e:	6a 01                	push   $0x1
    1510:	e8 fc 2c 00 00       	call   4211 <printf>
    1515:	83 c4 10             	add    $0x10,%esp
        exit();
    1518:	e8 78 2b 00 00       	call   4095 <exit>
      }
      if(fd >= 0)
    151d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1521:	78 0e                	js     1531 <createdelete+0x1fa>
        close(fd);
    1523:	83 ec 0c             	sub    $0xc,%esp
    1526:	ff 75 ec             	push   -0x14(%ebp)
    1529:	e8 8f 2b 00 00       	call   40bd <close>
    152e:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1531:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1535:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1539:	0f 8e 5e ff ff ff    	jle    149d <createdelete+0x166>
  for(i = 0; i < N; i++){
    153f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1543:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1547:	0f 8e 44 ff ff ff    	jle    1491 <createdelete+0x15a>
    }
  }

  for(i = 0; i < N; i++){
    154d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1554:	eb 38                	jmp    158e <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    1556:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    155d:	eb 25                	jmp    1584 <createdelete+0x24d>
      name[0] = 'p' + i;
    155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1562:	83 c0 70             	add    $0x70,%eax
    1565:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1568:	8b 45 f4             	mov    -0xc(%ebp),%eax
    156b:	83 c0 30             	add    $0x30,%eax
    156e:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    1571:	83 ec 0c             	sub    $0xc,%esp
    1574:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1577:	50                   	push   %eax
    1578:	e8 68 2b 00 00       	call   40e5 <unlink>
    157d:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1580:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1584:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1588:	7e d5                	jle    155f <createdelete+0x228>
  for(i = 0; i < N; i++){
    158a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    158e:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1592:	7e c2                	jle    1556 <createdelete+0x21f>
    }
  }

  printf(1, "createdelete ok\n");
    1594:	83 ec 08             	sub    $0x8,%esp
    1597:	68 94 4c 00 00       	push   $0x4c94
    159c:	6a 01                	push   $0x1
    159e:	e8 6e 2c 00 00       	call   4211 <printf>
    15a3:	83 c4 10             	add    $0x10,%esp
}
    15a6:	90                   	nop
    15a7:	c9                   	leave  
    15a8:	c3                   	ret    

000015a9 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    15a9:	55                   	push   %ebp
    15aa:	89 e5                	mov    %esp,%ebp
    15ac:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    15af:	83 ec 08             	sub    $0x8,%esp
    15b2:	68 a5 4c 00 00       	push   $0x4ca5
    15b7:	6a 01                	push   $0x1
    15b9:	e8 53 2c 00 00       	call   4211 <printf>
    15be:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    15c1:	83 ec 08             	sub    $0x8,%esp
    15c4:	68 02 02 00 00       	push   $0x202
    15c9:	68 b6 4c 00 00       	push   $0x4cb6
    15ce:	e8 02 2b 00 00       	call   40d5 <open>
    15d3:	83 c4 10             	add    $0x10,%esp
    15d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15dd:	79 17                	jns    15f6 <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    15df:	83 ec 08             	sub    $0x8,%esp
    15e2:	68 c1 4c 00 00       	push   $0x4cc1
    15e7:	6a 01                	push   $0x1
    15e9:	e8 23 2c 00 00       	call   4211 <printf>
    15ee:	83 c4 10             	add    $0x10,%esp
    exit();
    15f1:	e8 9f 2a 00 00       	call   4095 <exit>
  }
  write(fd, "hello", 5);
    15f6:	83 ec 04             	sub    $0x4,%esp
    15f9:	6a 05                	push   $0x5
    15fb:	68 db 4c 00 00       	push   $0x4cdb
    1600:	ff 75 f4             	push   -0xc(%ebp)
    1603:	e8 ad 2a 00 00       	call   40b5 <write>
    1608:	83 c4 10             	add    $0x10,%esp
  close(fd);
    160b:	83 ec 0c             	sub    $0xc,%esp
    160e:	ff 75 f4             	push   -0xc(%ebp)
    1611:	e8 a7 2a 00 00       	call   40bd <close>
    1616:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    1619:	83 ec 08             	sub    $0x8,%esp
    161c:	6a 02                	push   $0x2
    161e:	68 b6 4c 00 00       	push   $0x4cb6
    1623:	e8 ad 2a 00 00       	call   40d5 <open>
    1628:	83 c4 10             	add    $0x10,%esp
    162b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    162e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1632:	79 17                	jns    164b <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    1634:	83 ec 08             	sub    $0x8,%esp
    1637:	68 e1 4c 00 00       	push   $0x4ce1
    163c:	6a 01                	push   $0x1
    163e:	e8 ce 2b 00 00       	call   4211 <printf>
    1643:	83 c4 10             	add    $0x10,%esp
    exit();
    1646:	e8 4a 2a 00 00       	call   4095 <exit>
  }
  if(unlink("unlinkread") != 0){
    164b:	83 ec 0c             	sub    $0xc,%esp
    164e:	68 b6 4c 00 00       	push   $0x4cb6
    1653:	e8 8d 2a 00 00       	call   40e5 <unlink>
    1658:	83 c4 10             	add    $0x10,%esp
    165b:	85 c0                	test   %eax,%eax
    165d:	74 17                	je     1676 <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    165f:	83 ec 08             	sub    $0x8,%esp
    1662:	68 f9 4c 00 00       	push   $0x4cf9
    1667:	6a 01                	push   $0x1
    1669:	e8 a3 2b 00 00       	call   4211 <printf>
    166e:	83 c4 10             	add    $0x10,%esp
    exit();
    1671:	e8 1f 2a 00 00       	call   4095 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1676:	83 ec 08             	sub    $0x8,%esp
    1679:	68 02 02 00 00       	push   $0x202
    167e:	68 b6 4c 00 00       	push   $0x4cb6
    1683:	e8 4d 2a 00 00       	call   40d5 <open>
    1688:	83 c4 10             	add    $0x10,%esp
    168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    168e:	83 ec 04             	sub    $0x4,%esp
    1691:	6a 03                	push   $0x3
    1693:	68 13 4d 00 00       	push   $0x4d13
    1698:	ff 75 f0             	push   -0x10(%ebp)
    169b:	e8 15 2a 00 00       	call   40b5 <write>
    16a0:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    16a3:	83 ec 0c             	sub    $0xc,%esp
    16a6:	ff 75 f0             	push   -0x10(%ebp)
    16a9:	e8 0f 2a 00 00       	call   40bd <close>
    16ae:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    16b1:	83 ec 04             	sub    $0x4,%esp
    16b4:	68 00 20 00 00       	push   $0x2000
    16b9:	68 40 65 00 00       	push   $0x6540
    16be:	ff 75 f4             	push   -0xc(%ebp)
    16c1:	e8 e7 29 00 00       	call   40ad <read>
    16c6:	83 c4 10             	add    $0x10,%esp
    16c9:	83 f8 05             	cmp    $0x5,%eax
    16cc:	74 17                	je     16e5 <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    16ce:	83 ec 08             	sub    $0x8,%esp
    16d1:	68 17 4d 00 00       	push   $0x4d17
    16d6:	6a 01                	push   $0x1
    16d8:	e8 34 2b 00 00       	call   4211 <printf>
    16dd:	83 c4 10             	add    $0x10,%esp
    exit();
    16e0:	e8 b0 29 00 00       	call   4095 <exit>
  }
  if(buf[0] != 'h'){
    16e5:	0f b6 05 40 65 00 00 	movzbl 0x6540,%eax
    16ec:	3c 68                	cmp    $0x68,%al
    16ee:	74 17                	je     1707 <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    16f0:	83 ec 08             	sub    $0x8,%esp
    16f3:	68 2e 4d 00 00       	push   $0x4d2e
    16f8:	6a 01                	push   $0x1
    16fa:	e8 12 2b 00 00       	call   4211 <printf>
    16ff:	83 c4 10             	add    $0x10,%esp
    exit();
    1702:	e8 8e 29 00 00       	call   4095 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1707:	83 ec 04             	sub    $0x4,%esp
    170a:	6a 0a                	push   $0xa
    170c:	68 40 65 00 00       	push   $0x6540
    1711:	ff 75 f4             	push   -0xc(%ebp)
    1714:	e8 9c 29 00 00       	call   40b5 <write>
    1719:	83 c4 10             	add    $0x10,%esp
    171c:	83 f8 0a             	cmp    $0xa,%eax
    171f:	74 17                	je     1738 <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    1721:	83 ec 08             	sub    $0x8,%esp
    1724:	68 45 4d 00 00       	push   $0x4d45
    1729:	6a 01                	push   $0x1
    172b:	e8 e1 2a 00 00       	call   4211 <printf>
    1730:	83 c4 10             	add    $0x10,%esp
    exit();
    1733:	e8 5d 29 00 00       	call   4095 <exit>
  }
  close(fd);
    1738:	83 ec 0c             	sub    $0xc,%esp
    173b:	ff 75 f4             	push   -0xc(%ebp)
    173e:	e8 7a 29 00 00       	call   40bd <close>
    1743:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    1746:	83 ec 0c             	sub    $0xc,%esp
    1749:	68 b6 4c 00 00       	push   $0x4cb6
    174e:	e8 92 29 00 00       	call   40e5 <unlink>
    1753:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    1756:	83 ec 08             	sub    $0x8,%esp
    1759:	68 5e 4d 00 00       	push   $0x4d5e
    175e:	6a 01                	push   $0x1
    1760:	e8 ac 2a 00 00       	call   4211 <printf>
    1765:	83 c4 10             	add    $0x10,%esp
}
    1768:	90                   	nop
    1769:	c9                   	leave  
    176a:	c3                   	ret    

0000176b <linktest>:

void
linktest(void)
{
    176b:	55                   	push   %ebp
    176c:	89 e5                	mov    %esp,%ebp
    176e:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    1771:	83 ec 08             	sub    $0x8,%esp
    1774:	68 6d 4d 00 00       	push   $0x4d6d
    1779:	6a 01                	push   $0x1
    177b:	e8 91 2a 00 00       	call   4211 <printf>
    1780:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    1783:	83 ec 0c             	sub    $0xc,%esp
    1786:	68 77 4d 00 00       	push   $0x4d77
    178b:	e8 55 29 00 00       	call   40e5 <unlink>
    1790:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    1793:	83 ec 0c             	sub    $0xc,%esp
    1796:	68 7b 4d 00 00       	push   $0x4d7b
    179b:	e8 45 29 00 00       	call   40e5 <unlink>
    17a0:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    17a3:	83 ec 08             	sub    $0x8,%esp
    17a6:	68 02 02 00 00       	push   $0x202
    17ab:	68 77 4d 00 00       	push   $0x4d77
    17b0:	e8 20 29 00 00       	call   40d5 <open>
    17b5:	83 c4 10             	add    $0x10,%esp
    17b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    17bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17bf:	79 17                	jns    17d8 <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    17c1:	83 ec 08             	sub    $0x8,%esp
    17c4:	68 7f 4d 00 00       	push   $0x4d7f
    17c9:	6a 01                	push   $0x1
    17cb:	e8 41 2a 00 00       	call   4211 <printf>
    17d0:	83 c4 10             	add    $0x10,%esp
    exit();
    17d3:	e8 bd 28 00 00       	call   4095 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    17d8:	83 ec 04             	sub    $0x4,%esp
    17db:	6a 05                	push   $0x5
    17dd:	68 db 4c 00 00       	push   $0x4cdb
    17e2:	ff 75 f4             	push   -0xc(%ebp)
    17e5:	e8 cb 28 00 00       	call   40b5 <write>
    17ea:	83 c4 10             	add    $0x10,%esp
    17ed:	83 f8 05             	cmp    $0x5,%eax
    17f0:	74 17                	je     1809 <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    17f2:	83 ec 08             	sub    $0x8,%esp
    17f5:	68 92 4d 00 00       	push   $0x4d92
    17fa:	6a 01                	push   $0x1
    17fc:	e8 10 2a 00 00       	call   4211 <printf>
    1801:	83 c4 10             	add    $0x10,%esp
    exit();
    1804:	e8 8c 28 00 00       	call   4095 <exit>
  }
  close(fd);
    1809:	83 ec 0c             	sub    $0xc,%esp
    180c:	ff 75 f4             	push   -0xc(%ebp)
    180f:	e8 a9 28 00 00       	call   40bd <close>
    1814:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    1817:	83 ec 08             	sub    $0x8,%esp
    181a:	68 7b 4d 00 00       	push   $0x4d7b
    181f:	68 77 4d 00 00       	push   $0x4d77
    1824:	e8 cc 28 00 00       	call   40f5 <link>
    1829:	83 c4 10             	add    $0x10,%esp
    182c:	85 c0                	test   %eax,%eax
    182e:	79 17                	jns    1847 <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    1830:	83 ec 08             	sub    $0x8,%esp
    1833:	68 a4 4d 00 00       	push   $0x4da4
    1838:	6a 01                	push   $0x1
    183a:	e8 d2 29 00 00       	call   4211 <printf>
    183f:	83 c4 10             	add    $0x10,%esp
    exit();
    1842:	e8 4e 28 00 00       	call   4095 <exit>
  }
  unlink("lf1");
    1847:	83 ec 0c             	sub    $0xc,%esp
    184a:	68 77 4d 00 00       	push   $0x4d77
    184f:	e8 91 28 00 00       	call   40e5 <unlink>
    1854:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    1857:	83 ec 08             	sub    $0x8,%esp
    185a:	6a 00                	push   $0x0
    185c:	68 77 4d 00 00       	push   $0x4d77
    1861:	e8 6f 28 00 00       	call   40d5 <open>
    1866:	83 c4 10             	add    $0x10,%esp
    1869:	85 c0                	test   %eax,%eax
    186b:	78 17                	js     1884 <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    186d:	83 ec 08             	sub    $0x8,%esp
    1870:	68 bc 4d 00 00       	push   $0x4dbc
    1875:	6a 01                	push   $0x1
    1877:	e8 95 29 00 00       	call   4211 <printf>
    187c:	83 c4 10             	add    $0x10,%esp
    exit();
    187f:	e8 11 28 00 00       	call   4095 <exit>
  }

  fd = open("lf2", 0);
    1884:	83 ec 08             	sub    $0x8,%esp
    1887:	6a 00                	push   $0x0
    1889:	68 7b 4d 00 00       	push   $0x4d7b
    188e:	e8 42 28 00 00       	call   40d5 <open>
    1893:	83 c4 10             	add    $0x10,%esp
    1896:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    189d:	79 17                	jns    18b6 <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    189f:	83 ec 08             	sub    $0x8,%esp
    18a2:	68 e1 4d 00 00       	push   $0x4de1
    18a7:	6a 01                	push   $0x1
    18a9:	e8 63 29 00 00       	call   4211 <printf>
    18ae:	83 c4 10             	add    $0x10,%esp
    exit();
    18b1:	e8 df 27 00 00       	call   4095 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    18b6:	83 ec 04             	sub    $0x4,%esp
    18b9:	68 00 20 00 00       	push   $0x2000
    18be:	68 40 65 00 00       	push   $0x6540
    18c3:	ff 75 f4             	push   -0xc(%ebp)
    18c6:	e8 e2 27 00 00       	call   40ad <read>
    18cb:	83 c4 10             	add    $0x10,%esp
    18ce:	83 f8 05             	cmp    $0x5,%eax
    18d1:	74 17                	je     18ea <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    18d3:	83 ec 08             	sub    $0x8,%esp
    18d6:	68 f2 4d 00 00       	push   $0x4df2
    18db:	6a 01                	push   $0x1
    18dd:	e8 2f 29 00 00       	call   4211 <printf>
    18e2:	83 c4 10             	add    $0x10,%esp
    exit();
    18e5:	e8 ab 27 00 00       	call   4095 <exit>
  }
  close(fd);
    18ea:	83 ec 0c             	sub    $0xc,%esp
    18ed:	ff 75 f4             	push   -0xc(%ebp)
    18f0:	e8 c8 27 00 00       	call   40bd <close>
    18f5:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    18f8:	83 ec 08             	sub    $0x8,%esp
    18fb:	68 7b 4d 00 00       	push   $0x4d7b
    1900:	68 7b 4d 00 00       	push   $0x4d7b
    1905:	e8 eb 27 00 00       	call   40f5 <link>
    190a:	83 c4 10             	add    $0x10,%esp
    190d:	85 c0                	test   %eax,%eax
    190f:	78 17                	js     1928 <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1911:	83 ec 08             	sub    $0x8,%esp
    1914:	68 03 4e 00 00       	push   $0x4e03
    1919:	6a 01                	push   $0x1
    191b:	e8 f1 28 00 00       	call   4211 <printf>
    1920:	83 c4 10             	add    $0x10,%esp
    exit();
    1923:	e8 6d 27 00 00       	call   4095 <exit>
  }

  unlink("lf2");
    1928:	83 ec 0c             	sub    $0xc,%esp
    192b:	68 7b 4d 00 00       	push   $0x4d7b
    1930:	e8 b0 27 00 00       	call   40e5 <unlink>
    1935:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    1938:	83 ec 08             	sub    $0x8,%esp
    193b:	68 77 4d 00 00       	push   $0x4d77
    1940:	68 7b 4d 00 00       	push   $0x4d7b
    1945:	e8 ab 27 00 00       	call   40f5 <link>
    194a:	83 c4 10             	add    $0x10,%esp
    194d:	85 c0                	test   %eax,%eax
    194f:	78 17                	js     1968 <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    1951:	83 ec 08             	sub    $0x8,%esp
    1954:	68 24 4e 00 00       	push   $0x4e24
    1959:	6a 01                	push   $0x1
    195b:	e8 b1 28 00 00       	call   4211 <printf>
    1960:	83 c4 10             	add    $0x10,%esp
    exit();
    1963:	e8 2d 27 00 00       	call   4095 <exit>
  }

  if(link(".", "lf1") >= 0){
    1968:	83 ec 08             	sub    $0x8,%esp
    196b:	68 77 4d 00 00       	push   $0x4d77
    1970:	68 47 4e 00 00       	push   $0x4e47
    1975:	e8 7b 27 00 00       	call   40f5 <link>
    197a:	83 c4 10             	add    $0x10,%esp
    197d:	85 c0                	test   %eax,%eax
    197f:	78 17                	js     1998 <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    1981:	83 ec 08             	sub    $0x8,%esp
    1984:	68 49 4e 00 00       	push   $0x4e49
    1989:	6a 01                	push   $0x1
    198b:	e8 81 28 00 00       	call   4211 <printf>
    1990:	83 c4 10             	add    $0x10,%esp
    exit();
    1993:	e8 fd 26 00 00       	call   4095 <exit>
  }

  printf(1, "linktest ok\n");
    1998:	83 ec 08             	sub    $0x8,%esp
    199b:	68 65 4e 00 00       	push   $0x4e65
    19a0:	6a 01                	push   $0x1
    19a2:	e8 6a 28 00 00       	call   4211 <printf>
    19a7:	83 c4 10             	add    $0x10,%esp
}
    19aa:	90                   	nop
    19ab:	c9                   	leave  
    19ac:	c3                   	ret    

000019ad <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    19ad:	55                   	push   %ebp
    19ae:	89 e5                	mov    %esp,%ebp
    19b0:	53                   	push   %ebx
    19b1:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    19b4:	83 ec 08             	sub    $0x8,%esp
    19b7:	68 72 4e 00 00       	push   $0x4e72
    19bc:	6a 01                	push   $0x1
    19be:	e8 4e 28 00 00       	call   4211 <printf>
    19c3:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    19c6:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    19ca:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    19ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    19d5:	e9 00 01 00 00       	jmp    1ada <concreate+0x12d>
    file[1] = '0' + i;
    19da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19dd:	83 c0 30             	add    $0x30,%eax
    19e0:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    19e3:	83 ec 0c             	sub    $0xc,%esp
    19e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e9:	50                   	push   %eax
    19ea:	e8 f6 26 00 00       	call   40e5 <unlink>
    19ef:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    19f2:	e8 96 26 00 00       	call   408d <fork>
    19f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid && (i % 3) == 1){
    19fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fe:	74 3d                	je     1a3d <concreate+0x90>
    1a00:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1a03:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1a08:	89 c8                	mov    %ecx,%eax
    1a0a:	f7 ea                	imul   %edx
    1a0c:	89 cb                	mov    %ecx,%ebx
    1a0e:	c1 fb 1f             	sar    $0x1f,%ebx
    1a11:	89 d0                	mov    %edx,%eax
    1a13:	29 d8                	sub    %ebx,%eax
    1a15:	89 c2                	mov    %eax,%edx
    1a17:	01 d2                	add    %edx,%edx
    1a19:	01 c2                	add    %eax,%edx
    1a1b:	89 c8                	mov    %ecx,%eax
    1a1d:	29 d0                	sub    %edx,%eax
    1a1f:	83 f8 01             	cmp    $0x1,%eax
    1a22:	75 19                	jne    1a3d <concreate+0x90>
      link("C0", file);
    1a24:	83 ec 08             	sub    $0x8,%esp
    1a27:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a2a:	50                   	push   %eax
    1a2b:	68 82 4e 00 00       	push   $0x4e82
    1a30:	e8 c0 26 00 00       	call   40f5 <link>
    1a35:	83 c4 10             	add    $0x10,%esp
    1a38:	e9 89 00 00 00       	jmp    1ac6 <concreate+0x119>
    } else if(pid == 0 && (i % 5) == 1){
    1a3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a41:	75 3d                	jne    1a80 <concreate+0xd3>
    1a43:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1a46:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1a4b:	89 c8                	mov    %ecx,%eax
    1a4d:	f7 ea                	imul   %edx
    1a4f:	89 d0                	mov    %edx,%eax
    1a51:	d1 f8                	sar    %eax
    1a53:	89 ca                	mov    %ecx,%edx
    1a55:	c1 fa 1f             	sar    $0x1f,%edx
    1a58:	29 d0                	sub    %edx,%eax
    1a5a:	89 c2                	mov    %eax,%edx
    1a5c:	c1 e2 02             	shl    $0x2,%edx
    1a5f:	01 c2                	add    %eax,%edx
    1a61:	89 c8                	mov    %ecx,%eax
    1a63:	29 d0                	sub    %edx,%eax
    1a65:	83 f8 01             	cmp    $0x1,%eax
    1a68:	75 16                	jne    1a80 <concreate+0xd3>
      link("C0", file);
    1a6a:	83 ec 08             	sub    $0x8,%esp
    1a6d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a70:	50                   	push   %eax
    1a71:	68 82 4e 00 00       	push   $0x4e82
    1a76:	e8 7a 26 00 00       	call   40f5 <link>
    1a7b:	83 c4 10             	add    $0x10,%esp
    1a7e:	eb 46                	jmp    1ac6 <concreate+0x119>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1a80:	83 ec 08             	sub    $0x8,%esp
    1a83:	68 02 02 00 00       	push   $0x202
    1a88:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a8b:	50                   	push   %eax
    1a8c:	e8 44 26 00 00       	call   40d5 <open>
    1a91:	83 c4 10             	add    $0x10,%esp
    1a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(fd < 0){
    1a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a9b:	79 1b                	jns    1ab8 <concreate+0x10b>
        printf(1, "concreate create %s failed\n", file);
    1a9d:	83 ec 04             	sub    $0x4,%esp
    1aa0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1aa3:	50                   	push   %eax
    1aa4:	68 85 4e 00 00       	push   $0x4e85
    1aa9:	6a 01                	push   $0x1
    1aab:	e8 61 27 00 00       	call   4211 <printf>
    1ab0:	83 c4 10             	add    $0x10,%esp
        exit();
    1ab3:	e8 dd 25 00 00       	call   4095 <exit>
      }
      close(fd);
    1ab8:	83 ec 0c             	sub    $0xc,%esp
    1abb:	ff 75 ec             	push   -0x14(%ebp)
    1abe:	e8 fa 25 00 00       	call   40bd <close>
    1ac3:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1ac6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1aca:	75 05                	jne    1ad1 <concreate+0x124>
      exit();
    1acc:	e8 c4 25 00 00       	call   4095 <exit>
    else
      wait();
    1ad1:	e8 c7 25 00 00       	call   409d <wait>
  for(i = 0; i < 40; i++){
    1ad6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ada:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1ade:	0f 8e f6 fe ff ff    	jle    19da <concreate+0x2d>
  }

  memset(fa, 0, sizeof(fa));
    1ae4:	83 ec 04             	sub    $0x4,%esp
    1ae7:	6a 28                	push   $0x28
    1ae9:	6a 00                	push   $0x0
    1aeb:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1aee:	50                   	push   %eax
    1aef:	e8 06 24 00 00       	call   3efa <memset>
    1af4:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1af7:	83 ec 08             	sub    $0x8,%esp
    1afa:	6a 00                	push   $0x0
    1afc:	68 47 4e 00 00       	push   $0x4e47
    1b01:	e8 cf 25 00 00       	call   40d5 <open>
    1b06:	83 c4 10             	add    $0x10,%esp
    1b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  n = 0;
    1b0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1b13:	e9 93 00 00 00       	jmp    1bab <concreate+0x1fe>
    if(de.inum == 0)
    1b18:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1b1c:	66 85 c0             	test   %ax,%ax
    1b1f:	75 05                	jne    1b26 <concreate+0x179>
      continue;
    1b21:	e9 85 00 00 00       	jmp    1bab <concreate+0x1fe>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1b26:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1b2a:	3c 43                	cmp    $0x43,%al
    1b2c:	75 7d                	jne    1bab <concreate+0x1fe>
    1b2e:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1b32:	84 c0                	test   %al,%al
    1b34:	75 75                	jne    1bab <concreate+0x1fe>
      i = de.name[1] - '0';
    1b36:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1b3a:	0f be c0             	movsbl %al,%eax
    1b3d:	83 e8 30             	sub    $0x30,%eax
    1b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b47:	78 08                	js     1b51 <concreate+0x1a4>
    1b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b4c:	83 f8 27             	cmp    $0x27,%eax
    1b4f:	76 1e                	jbe    1b6f <concreate+0x1c2>
        printf(1, "concreate weird file %s\n", de.name);
    1b51:	83 ec 04             	sub    $0x4,%esp
    1b54:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b57:	83 c0 02             	add    $0x2,%eax
    1b5a:	50                   	push   %eax
    1b5b:	68 a1 4e 00 00       	push   $0x4ea1
    1b60:	6a 01                	push   $0x1
    1b62:	e8 aa 26 00 00       	call   4211 <printf>
    1b67:	83 c4 10             	add    $0x10,%esp
        exit();
    1b6a:	e8 26 25 00 00       	call   4095 <exit>
      }
      if(fa[i]){
    1b6f:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b75:	01 d0                	add    %edx,%eax
    1b77:	0f b6 00             	movzbl (%eax),%eax
    1b7a:	84 c0                	test   %al,%al
    1b7c:	74 1e                	je     1b9c <concreate+0x1ef>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b7e:	83 ec 04             	sub    $0x4,%esp
    1b81:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b84:	83 c0 02             	add    $0x2,%eax
    1b87:	50                   	push   %eax
    1b88:	68 ba 4e 00 00       	push   $0x4eba
    1b8d:	6a 01                	push   $0x1
    1b8f:	e8 7d 26 00 00       	call   4211 <printf>
    1b94:	83 c4 10             	add    $0x10,%esp
        exit();
    1b97:	e8 f9 24 00 00       	call   4095 <exit>
      }
      fa[i] = 1;
    1b9c:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ba2:	01 d0                	add    %edx,%eax
    1ba4:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1ba7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1bab:	83 ec 04             	sub    $0x4,%esp
    1bae:	6a 10                	push   $0x10
    1bb0:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1bb3:	50                   	push   %eax
    1bb4:	ff 75 ec             	push   -0x14(%ebp)
    1bb7:	e8 f1 24 00 00       	call   40ad <read>
    1bbc:	83 c4 10             	add    $0x10,%esp
    1bbf:	85 c0                	test   %eax,%eax
    1bc1:	0f 8f 51 ff ff ff    	jg     1b18 <concreate+0x16b>
    }
  }
  close(fd);
    1bc7:	83 ec 0c             	sub    $0xc,%esp
    1bca:	ff 75 ec             	push   -0x14(%ebp)
    1bcd:	e8 eb 24 00 00       	call   40bd <close>
    1bd2:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1bd5:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1bd9:	74 17                	je     1bf2 <concreate+0x245>
    printf(1, "concreate not enough files in directory listing\n");
    1bdb:	83 ec 08             	sub    $0x8,%esp
    1bde:	68 d8 4e 00 00       	push   $0x4ed8
    1be3:	6a 01                	push   $0x1
    1be5:	e8 27 26 00 00       	call   4211 <printf>
    1bea:	83 c4 10             	add    $0x10,%esp
    exit();
    1bed:	e8 a3 24 00 00       	call   4095 <exit>
  }

  for(i = 0; i < 40; i++){
    1bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bf9:	e9 47 01 00 00       	jmp    1d45 <concreate+0x398>
    file[1] = '0' + i;
    1bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c01:	83 c0 30             	add    $0x30,%eax
    1c04:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1c07:	e8 81 24 00 00       	call   408d <fork>
    1c0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    1c0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1c13:	79 17                	jns    1c2c <concreate+0x27f>
      printf(1, "fork failed\n");
    1c15:	83 ec 08             	sub    $0x8,%esp
    1c18:	68 69 46 00 00       	push   $0x4669
    1c1d:	6a 01                	push   $0x1
    1c1f:	e8 ed 25 00 00       	call   4211 <printf>
    1c24:	83 c4 10             	add    $0x10,%esp
      exit();
    1c27:	e8 69 24 00 00       	call   4095 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1c2c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1c2f:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1c34:	89 c8                	mov    %ecx,%eax
    1c36:	f7 ea                	imul   %edx
    1c38:	89 cb                	mov    %ecx,%ebx
    1c3a:	c1 fb 1f             	sar    $0x1f,%ebx
    1c3d:	89 d0                	mov    %edx,%eax
    1c3f:	29 d8                	sub    %ebx,%eax
    1c41:	89 c2                	mov    %eax,%edx
    1c43:	01 d2                	add    %edx,%edx
    1c45:	01 c2                	add    %eax,%edx
    1c47:	89 c8                	mov    %ecx,%eax
    1c49:	29 d0                	sub    %edx,%eax
    1c4b:	85 c0                	test   %eax,%eax
    1c4d:	75 06                	jne    1c55 <concreate+0x2a8>
    1c4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1c53:	74 2a                	je     1c7f <concreate+0x2d2>
       ((i % 3) == 1 && pid != 0)){
    1c55:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1c58:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1c5d:	89 c8                	mov    %ecx,%eax
    1c5f:	f7 ea                	imul   %edx
    1c61:	89 cb                	mov    %ecx,%ebx
    1c63:	c1 fb 1f             	sar    $0x1f,%ebx
    1c66:	89 d0                	mov    %edx,%eax
    1c68:	29 d8                	sub    %ebx,%eax
    1c6a:	89 c2                	mov    %eax,%edx
    1c6c:	01 d2                	add    %edx,%edx
    1c6e:	01 c2                	add    %eax,%edx
    1c70:	89 c8                	mov    %ecx,%eax
    1c72:	29 d0                	sub    %edx,%eax
    if(((i % 3) == 0 && pid == 0) ||
    1c74:	83 f8 01             	cmp    $0x1,%eax
    1c77:	75 7c                	jne    1cf5 <concreate+0x348>
       ((i % 3) == 1 && pid != 0)){
    1c79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1c7d:	74 76                	je     1cf5 <concreate+0x348>
      close(open(file, 0));
    1c7f:	83 ec 08             	sub    $0x8,%esp
    1c82:	6a 00                	push   $0x0
    1c84:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c87:	50                   	push   %eax
    1c88:	e8 48 24 00 00       	call   40d5 <open>
    1c8d:	83 c4 10             	add    $0x10,%esp
    1c90:	83 ec 0c             	sub    $0xc,%esp
    1c93:	50                   	push   %eax
    1c94:	e8 24 24 00 00       	call   40bd <close>
    1c99:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c9c:	83 ec 08             	sub    $0x8,%esp
    1c9f:	6a 00                	push   $0x0
    1ca1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1ca4:	50                   	push   %eax
    1ca5:	e8 2b 24 00 00       	call   40d5 <open>
    1caa:	83 c4 10             	add    $0x10,%esp
    1cad:	83 ec 0c             	sub    $0xc,%esp
    1cb0:	50                   	push   %eax
    1cb1:	e8 07 24 00 00       	call   40bd <close>
    1cb6:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1cb9:	83 ec 08             	sub    $0x8,%esp
    1cbc:	6a 00                	push   $0x0
    1cbe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cc1:	50                   	push   %eax
    1cc2:	e8 0e 24 00 00       	call   40d5 <open>
    1cc7:	83 c4 10             	add    $0x10,%esp
    1cca:	83 ec 0c             	sub    $0xc,%esp
    1ccd:	50                   	push   %eax
    1cce:	e8 ea 23 00 00       	call   40bd <close>
    1cd3:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1cd6:	83 ec 08             	sub    $0x8,%esp
    1cd9:	6a 00                	push   $0x0
    1cdb:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cde:	50                   	push   %eax
    1cdf:	e8 f1 23 00 00       	call   40d5 <open>
    1ce4:	83 c4 10             	add    $0x10,%esp
    1ce7:	83 ec 0c             	sub    $0xc,%esp
    1cea:	50                   	push   %eax
    1ceb:	e8 cd 23 00 00       	call   40bd <close>
    1cf0:	83 c4 10             	add    $0x10,%esp
    1cf3:	eb 3c                	jmp    1d31 <concreate+0x384>
    } else {
      unlink(file);
    1cf5:	83 ec 0c             	sub    $0xc,%esp
    1cf8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cfb:	50                   	push   %eax
    1cfc:	e8 e4 23 00 00       	call   40e5 <unlink>
    1d01:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1d04:	83 ec 0c             	sub    $0xc,%esp
    1d07:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1d0a:	50                   	push   %eax
    1d0b:	e8 d5 23 00 00       	call   40e5 <unlink>
    1d10:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1d13:	83 ec 0c             	sub    $0xc,%esp
    1d16:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1d19:	50                   	push   %eax
    1d1a:	e8 c6 23 00 00       	call   40e5 <unlink>
    1d1f:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1d22:	83 ec 0c             	sub    $0xc,%esp
    1d25:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1d28:	50                   	push   %eax
    1d29:	e8 b7 23 00 00       	call   40e5 <unlink>
    1d2e:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1d31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1d35:	75 05                	jne    1d3c <concreate+0x38f>
      exit();
    1d37:	e8 59 23 00 00       	call   4095 <exit>
    else
      wait();
    1d3c:	e8 5c 23 00 00       	call   409d <wait>
  for(i = 0; i < 40; i++){
    1d41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1d45:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1d49:	0f 8e af fe ff ff    	jle    1bfe <concreate+0x251>
  }

  printf(1, "concreate ok\n");
    1d4f:	83 ec 08             	sub    $0x8,%esp
    1d52:	68 09 4f 00 00       	push   $0x4f09
    1d57:	6a 01                	push   $0x1
    1d59:	e8 b3 24 00 00       	call   4211 <printf>
    1d5e:	83 c4 10             	add    $0x10,%esp
}
    1d61:	90                   	nop
    1d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1d65:	c9                   	leave  
    1d66:	c3                   	ret    

00001d67 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1d67:	55                   	push   %ebp
    1d68:	89 e5                	mov    %esp,%ebp
    1d6a:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1d6d:	83 ec 08             	sub    $0x8,%esp
    1d70:	68 17 4f 00 00       	push   $0x4f17
    1d75:	6a 01                	push   $0x1
    1d77:	e8 95 24 00 00       	call   4211 <printf>
    1d7c:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1d7f:	83 ec 0c             	sub    $0xc,%esp
    1d82:	68 9f 4a 00 00       	push   $0x4a9f
    1d87:	e8 59 23 00 00       	call   40e5 <unlink>
    1d8c:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1d8f:	e8 f9 22 00 00       	call   408d <fork>
    1d94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d9b:	79 17                	jns    1db4 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d9d:	83 ec 08             	sub    $0x8,%esp
    1da0:	68 69 46 00 00       	push   $0x4669
    1da5:	6a 01                	push   $0x1
    1da7:	e8 65 24 00 00       	call   4211 <printf>
    1dac:	83 c4 10             	add    $0x10,%esp
    exit();
    1daf:	e8 e1 22 00 00       	call   4095 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1db4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1db8:	74 07                	je     1dc1 <linkunlink+0x5a>
    1dba:	b8 01 00 00 00       	mov    $0x1,%eax
    1dbf:	eb 05                	jmp    1dc6 <linkunlink+0x5f>
    1dc1:	b8 61 00 00 00       	mov    $0x61,%eax
    1dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1dc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1dd0:	e9 9c 00 00 00       	jmp    1e71 <linkunlink+0x10a>
    x = x * 1103515245 + 12345;
    1dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1dd8:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1dde:	05 39 30 00 00       	add    $0x3039,%eax
    1de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1de6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1de9:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1dee:	89 c8                	mov    %ecx,%eax
    1df0:	f7 e2                	mul    %edx
    1df2:	89 d0                	mov    %edx,%eax
    1df4:	d1 e8                	shr    %eax
    1df6:	89 c2                	mov    %eax,%edx
    1df8:	01 d2                	add    %edx,%edx
    1dfa:	01 c2                	add    %eax,%edx
    1dfc:	89 c8                	mov    %ecx,%eax
    1dfe:	29 d0                	sub    %edx,%eax
    1e00:	85 c0                	test   %eax,%eax
    1e02:	75 23                	jne    1e27 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1e04:	83 ec 08             	sub    $0x8,%esp
    1e07:	68 02 02 00 00       	push   $0x202
    1e0c:	68 9f 4a 00 00       	push   $0x4a9f
    1e11:	e8 bf 22 00 00       	call   40d5 <open>
    1e16:	83 c4 10             	add    $0x10,%esp
    1e19:	83 ec 0c             	sub    $0xc,%esp
    1e1c:	50                   	push   %eax
    1e1d:	e8 9b 22 00 00       	call   40bd <close>
    1e22:	83 c4 10             	add    $0x10,%esp
    1e25:	eb 46                	jmp    1e6d <linkunlink+0x106>
    } else if((x % 3) == 1){
    1e27:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1e2a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1e2f:	89 c8                	mov    %ecx,%eax
    1e31:	f7 e2                	mul    %edx
    1e33:	89 d0                	mov    %edx,%eax
    1e35:	d1 e8                	shr    %eax
    1e37:	89 c2                	mov    %eax,%edx
    1e39:	01 d2                	add    %edx,%edx
    1e3b:	01 c2                	add    %eax,%edx
    1e3d:	89 c8                	mov    %ecx,%eax
    1e3f:	29 d0                	sub    %edx,%eax
    1e41:	83 f8 01             	cmp    $0x1,%eax
    1e44:	75 17                	jne    1e5d <linkunlink+0xf6>
      link("cat", "x");
    1e46:	83 ec 08             	sub    $0x8,%esp
    1e49:	68 9f 4a 00 00       	push   $0x4a9f
    1e4e:	68 28 4f 00 00       	push   $0x4f28
    1e53:	e8 9d 22 00 00       	call   40f5 <link>
    1e58:	83 c4 10             	add    $0x10,%esp
    1e5b:	eb 10                	jmp    1e6d <linkunlink+0x106>
    } else {
      unlink("x");
    1e5d:	83 ec 0c             	sub    $0xc,%esp
    1e60:	68 9f 4a 00 00       	push   $0x4a9f
    1e65:	e8 7b 22 00 00       	call   40e5 <unlink>
    1e6a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1e6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1e71:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1e75:	0f 8e 5a ff ff ff    	jle    1dd5 <linkunlink+0x6e>
    }
  }

  if(pid)
    1e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1e7f:	74 07                	je     1e88 <linkunlink+0x121>
    wait();
    1e81:	e8 17 22 00 00       	call   409d <wait>
    1e86:	eb 05                	jmp    1e8d <linkunlink+0x126>
  else
    exit();
    1e88:	e8 08 22 00 00       	call   4095 <exit>

  printf(1, "linkunlink ok\n");
    1e8d:	83 ec 08             	sub    $0x8,%esp
    1e90:	68 2c 4f 00 00       	push   $0x4f2c
    1e95:	6a 01                	push   $0x1
    1e97:	e8 75 23 00 00       	call   4211 <printf>
    1e9c:	83 c4 10             	add    $0x10,%esp
}
    1e9f:	90                   	nop
    1ea0:	c9                   	leave  
    1ea1:	c3                   	ret    

00001ea2 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1ea2:	55                   	push   %ebp
    1ea3:	89 e5                	mov    %esp,%ebp
    1ea5:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1ea8:	83 ec 08             	sub    $0x8,%esp
    1eab:	68 3b 4f 00 00       	push   $0x4f3b
    1eb0:	6a 01                	push   $0x1
    1eb2:	e8 5a 23 00 00       	call   4211 <printf>
    1eb7:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1eba:	83 ec 0c             	sub    $0xc,%esp
    1ebd:	68 48 4f 00 00       	push   $0x4f48
    1ec2:	e8 1e 22 00 00       	call   40e5 <unlink>
    1ec7:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1eca:	83 ec 08             	sub    $0x8,%esp
    1ecd:	68 00 02 00 00       	push   $0x200
    1ed2:	68 48 4f 00 00       	push   $0x4f48
    1ed7:	e8 f9 21 00 00       	call   40d5 <open>
    1edc:	83 c4 10             	add    $0x10,%esp
    1edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1ee2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1ee6:	79 17                	jns    1eff <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1ee8:	83 ec 08             	sub    $0x8,%esp
    1eeb:	68 4b 4f 00 00       	push   $0x4f4b
    1ef0:	6a 01                	push   $0x1
    1ef2:	e8 1a 23 00 00       	call   4211 <printf>
    1ef7:	83 c4 10             	add    $0x10,%esp
    exit();
    1efa:	e8 96 21 00 00       	call   4095 <exit>
  }
  close(fd);
    1eff:	83 ec 0c             	sub    $0xc,%esp
    1f02:	ff 75 f0             	push   -0x10(%ebp)
    1f05:	e8 b3 21 00 00       	call   40bd <close>
    1f0a:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1f0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f14:	eb 63                	jmp    1f79 <bigdir+0xd7>
    name[0] = 'x';
    1f16:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f1d:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f20:	85 c0                	test   %eax,%eax
    1f22:	0f 48 c2             	cmovs  %edx,%eax
    1f25:	c1 f8 06             	sar    $0x6,%eax
    1f28:	83 c0 30             	add    $0x30,%eax
    1f2b:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f31:	99                   	cltd   
    1f32:	c1 ea 1a             	shr    $0x1a,%edx
    1f35:	01 d0                	add    %edx,%eax
    1f37:	83 e0 3f             	and    $0x3f,%eax
    1f3a:	29 d0                	sub    %edx,%eax
    1f3c:	83 c0 30             	add    $0x30,%eax
    1f3f:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f42:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1f46:	83 ec 08             	sub    $0x8,%esp
    1f49:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f4c:	50                   	push   %eax
    1f4d:	68 48 4f 00 00       	push   $0x4f48
    1f52:	e8 9e 21 00 00       	call   40f5 <link>
    1f57:	83 c4 10             	add    $0x10,%esp
    1f5a:	85 c0                	test   %eax,%eax
    1f5c:	74 17                	je     1f75 <bigdir+0xd3>
      printf(1, "bigdir link failed\n");
    1f5e:	83 ec 08             	sub    $0x8,%esp
    1f61:	68 61 4f 00 00       	push   $0x4f61
    1f66:	6a 01                	push   $0x1
    1f68:	e8 a4 22 00 00       	call   4211 <printf>
    1f6d:	83 c4 10             	add    $0x10,%esp
      exit();
    1f70:	e8 20 21 00 00       	call   4095 <exit>
  for(i = 0; i < 500; i++){
    1f75:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f79:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f80:	7e 94                	jle    1f16 <bigdir+0x74>
    }
  }

  unlink("bd");
    1f82:	83 ec 0c             	sub    $0xc,%esp
    1f85:	68 48 4f 00 00       	push   $0x4f48
    1f8a:	e8 56 21 00 00       	call   40e5 <unlink>
    1f8f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1f92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f99:	eb 5e                	jmp    1ff9 <bigdir+0x157>
    name[0] = 'x';
    1f9b:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fa2:	8d 50 3f             	lea    0x3f(%eax),%edx
    1fa5:	85 c0                	test   %eax,%eax
    1fa7:	0f 48 c2             	cmovs  %edx,%eax
    1faa:	c1 f8 06             	sar    $0x6,%eax
    1fad:	83 c0 30             	add    $0x30,%eax
    1fb0:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fb6:	99                   	cltd   
    1fb7:	c1 ea 1a             	shr    $0x1a,%edx
    1fba:	01 d0                	add    %edx,%eax
    1fbc:	83 e0 3f             	and    $0x3f,%eax
    1fbf:	29 d0                	sub    %edx,%eax
    1fc1:	83 c0 30             	add    $0x30,%eax
    1fc4:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1fc7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1fcb:	83 ec 0c             	sub    $0xc,%esp
    1fce:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1fd1:	50                   	push   %eax
    1fd2:	e8 0e 21 00 00       	call   40e5 <unlink>
    1fd7:	83 c4 10             	add    $0x10,%esp
    1fda:	85 c0                	test   %eax,%eax
    1fdc:	74 17                	je     1ff5 <bigdir+0x153>
      printf(1, "bigdir unlink failed");
    1fde:	83 ec 08             	sub    $0x8,%esp
    1fe1:	68 75 4f 00 00       	push   $0x4f75
    1fe6:	6a 01                	push   $0x1
    1fe8:	e8 24 22 00 00       	call   4211 <printf>
    1fed:	83 c4 10             	add    $0x10,%esp
      exit();
    1ff0:	e8 a0 20 00 00       	call   4095 <exit>
  for(i = 0; i < 500; i++){
    1ff5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ff9:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    2000:	7e 99                	jle    1f9b <bigdir+0xf9>
    }
  }

  printf(1, "bigdir ok\n");
    2002:	83 ec 08             	sub    $0x8,%esp
    2005:	68 8a 4f 00 00       	push   $0x4f8a
    200a:	6a 01                	push   $0x1
    200c:	e8 00 22 00 00       	call   4211 <printf>
    2011:	83 c4 10             	add    $0x10,%esp
}
    2014:	90                   	nop
    2015:	c9                   	leave  
    2016:	c3                   	ret    

00002017 <subdir>:

void
subdir(void)
{
    2017:	55                   	push   %ebp
    2018:	89 e5                	mov    %esp,%ebp
    201a:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    201d:	83 ec 08             	sub    $0x8,%esp
    2020:	68 95 4f 00 00       	push   $0x4f95
    2025:	6a 01                	push   $0x1
    2027:	e8 e5 21 00 00       	call   4211 <printf>
    202c:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    202f:	83 ec 0c             	sub    $0xc,%esp
    2032:	68 a2 4f 00 00       	push   $0x4fa2
    2037:	e8 a9 20 00 00       	call   40e5 <unlink>
    203c:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    203f:	83 ec 0c             	sub    $0xc,%esp
    2042:	68 a5 4f 00 00       	push   $0x4fa5
    2047:	e8 b1 20 00 00       	call   40fd <mkdir>
    204c:	83 c4 10             	add    $0x10,%esp
    204f:	85 c0                	test   %eax,%eax
    2051:	74 17                	je     206a <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    2053:	83 ec 08             	sub    $0x8,%esp
    2056:	68 a8 4f 00 00       	push   $0x4fa8
    205b:	6a 01                	push   $0x1
    205d:	e8 af 21 00 00       	call   4211 <printf>
    2062:	83 c4 10             	add    $0x10,%esp
    exit();
    2065:	e8 2b 20 00 00       	call   4095 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    206a:	83 ec 08             	sub    $0x8,%esp
    206d:	68 02 02 00 00       	push   $0x202
    2072:	68 c0 4f 00 00       	push   $0x4fc0
    2077:	e8 59 20 00 00       	call   40d5 <open>
    207c:	83 c4 10             	add    $0x10,%esp
    207f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2086:	79 17                	jns    209f <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    2088:	83 ec 08             	sub    $0x8,%esp
    208b:	68 c6 4f 00 00       	push   $0x4fc6
    2090:	6a 01                	push   $0x1
    2092:	e8 7a 21 00 00       	call   4211 <printf>
    2097:	83 c4 10             	add    $0x10,%esp
    exit();
    209a:	e8 f6 1f 00 00       	call   4095 <exit>
  }
  write(fd, "ff", 2);
    209f:	83 ec 04             	sub    $0x4,%esp
    20a2:	6a 02                	push   $0x2
    20a4:	68 a2 4f 00 00       	push   $0x4fa2
    20a9:	ff 75 f4             	push   -0xc(%ebp)
    20ac:	e8 04 20 00 00       	call   40b5 <write>
    20b1:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20b4:	83 ec 0c             	sub    $0xc,%esp
    20b7:	ff 75 f4             	push   -0xc(%ebp)
    20ba:	e8 fe 1f 00 00       	call   40bd <close>
    20bf:	83 c4 10             	add    $0x10,%esp

  if(unlink("dd") >= 0){
    20c2:	83 ec 0c             	sub    $0xc,%esp
    20c5:	68 a5 4f 00 00       	push   $0x4fa5
    20ca:	e8 16 20 00 00       	call   40e5 <unlink>
    20cf:	83 c4 10             	add    $0x10,%esp
    20d2:	85 c0                	test   %eax,%eax
    20d4:	78 17                	js     20ed <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    20d6:	83 ec 08             	sub    $0x8,%esp
    20d9:	68 dc 4f 00 00       	push   $0x4fdc
    20de:	6a 01                	push   $0x1
    20e0:	e8 2c 21 00 00       	call   4211 <printf>
    20e5:	83 c4 10             	add    $0x10,%esp
    exit();
    20e8:	e8 a8 1f 00 00       	call   4095 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    20ed:	83 ec 0c             	sub    $0xc,%esp
    20f0:	68 02 50 00 00       	push   $0x5002
    20f5:	e8 03 20 00 00       	call   40fd <mkdir>
    20fa:	83 c4 10             	add    $0x10,%esp
    20fd:	85 c0                	test   %eax,%eax
    20ff:	74 17                	je     2118 <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2101:	83 ec 08             	sub    $0x8,%esp
    2104:	68 09 50 00 00       	push   $0x5009
    2109:	6a 01                	push   $0x1
    210b:	e8 01 21 00 00       	call   4211 <printf>
    2110:	83 c4 10             	add    $0x10,%esp
    exit();
    2113:	e8 7d 1f 00 00       	call   4095 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2118:	83 ec 08             	sub    $0x8,%esp
    211b:	68 02 02 00 00       	push   $0x202
    2120:	68 24 50 00 00       	push   $0x5024
    2125:	e8 ab 1f 00 00       	call   40d5 <open>
    212a:	83 c4 10             	add    $0x10,%esp
    212d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2134:	79 17                	jns    214d <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    2136:	83 ec 08             	sub    $0x8,%esp
    2139:	68 2d 50 00 00       	push   $0x502d
    213e:	6a 01                	push   $0x1
    2140:	e8 cc 20 00 00       	call   4211 <printf>
    2145:	83 c4 10             	add    $0x10,%esp
    exit();
    2148:	e8 48 1f 00 00       	call   4095 <exit>
  }
  write(fd, "FF", 2);
    214d:	83 ec 04             	sub    $0x4,%esp
    2150:	6a 02                	push   $0x2
    2152:	68 45 50 00 00       	push   $0x5045
    2157:	ff 75 f4             	push   -0xc(%ebp)
    215a:	e8 56 1f 00 00       	call   40b5 <write>
    215f:	83 c4 10             	add    $0x10,%esp
  close(fd);
    2162:	83 ec 0c             	sub    $0xc,%esp
    2165:	ff 75 f4             	push   -0xc(%ebp)
    2168:	e8 50 1f 00 00       	call   40bd <close>
    216d:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    2170:	83 ec 08             	sub    $0x8,%esp
    2173:	6a 00                	push   $0x0
    2175:	68 48 50 00 00       	push   $0x5048
    217a:	e8 56 1f 00 00       	call   40d5 <open>
    217f:	83 c4 10             	add    $0x10,%esp
    2182:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2185:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2189:	79 17                	jns    21a2 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    218b:	83 ec 08             	sub    $0x8,%esp
    218e:	68 54 50 00 00       	push   $0x5054
    2193:	6a 01                	push   $0x1
    2195:	e8 77 20 00 00       	call   4211 <printf>
    219a:	83 c4 10             	add    $0x10,%esp
    exit();
    219d:	e8 f3 1e 00 00       	call   4095 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    21a2:	83 ec 04             	sub    $0x4,%esp
    21a5:	68 00 20 00 00       	push   $0x2000
    21aa:	68 40 65 00 00       	push   $0x6540
    21af:	ff 75 f4             	push   -0xc(%ebp)
    21b2:	e8 f6 1e 00 00       	call   40ad <read>
    21b7:	83 c4 10             	add    $0x10,%esp
    21ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    21bd:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    21c1:	75 0b                	jne    21ce <subdir+0x1b7>
    21c3:	0f b6 05 40 65 00 00 	movzbl 0x6540,%eax
    21ca:	3c 66                	cmp    $0x66,%al
    21cc:	74 17                	je     21e5 <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    21ce:	83 ec 08             	sub    $0x8,%esp
    21d1:	68 6d 50 00 00       	push   $0x506d
    21d6:	6a 01                	push   $0x1
    21d8:	e8 34 20 00 00       	call   4211 <printf>
    21dd:	83 c4 10             	add    $0x10,%esp
    exit();
    21e0:	e8 b0 1e 00 00       	call   4095 <exit>
  }
  close(fd);
    21e5:	83 ec 0c             	sub    $0xc,%esp
    21e8:	ff 75 f4             	push   -0xc(%ebp)
    21eb:	e8 cd 1e 00 00       	call   40bd <close>
    21f0:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    21f3:	83 ec 08             	sub    $0x8,%esp
    21f6:	68 88 50 00 00       	push   $0x5088
    21fb:	68 24 50 00 00       	push   $0x5024
    2200:	e8 f0 1e 00 00       	call   40f5 <link>
    2205:	83 c4 10             	add    $0x10,%esp
    2208:	85 c0                	test   %eax,%eax
    220a:	74 17                	je     2223 <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    220c:	83 ec 08             	sub    $0x8,%esp
    220f:	68 94 50 00 00       	push   $0x5094
    2214:	6a 01                	push   $0x1
    2216:	e8 f6 1f 00 00       	call   4211 <printf>
    221b:	83 c4 10             	add    $0x10,%esp
    exit();
    221e:	e8 72 1e 00 00       	call   4095 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2223:	83 ec 0c             	sub    $0xc,%esp
    2226:	68 24 50 00 00       	push   $0x5024
    222b:	e8 b5 1e 00 00       	call   40e5 <unlink>
    2230:	83 c4 10             	add    $0x10,%esp
    2233:	85 c0                	test   %eax,%eax
    2235:	74 17                	je     224e <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    2237:	83 ec 08             	sub    $0x8,%esp
    223a:	68 b5 50 00 00       	push   $0x50b5
    223f:	6a 01                	push   $0x1
    2241:	e8 cb 1f 00 00       	call   4211 <printf>
    2246:	83 c4 10             	add    $0x10,%esp
    exit();
    2249:	e8 47 1e 00 00       	call   4095 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    224e:	83 ec 08             	sub    $0x8,%esp
    2251:	6a 00                	push   $0x0
    2253:	68 24 50 00 00       	push   $0x5024
    2258:	e8 78 1e 00 00       	call   40d5 <open>
    225d:	83 c4 10             	add    $0x10,%esp
    2260:	85 c0                	test   %eax,%eax
    2262:	78 17                	js     227b <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2264:	83 ec 08             	sub    $0x8,%esp
    2267:	68 d0 50 00 00       	push   $0x50d0
    226c:	6a 01                	push   $0x1
    226e:	e8 9e 1f 00 00       	call   4211 <printf>
    2273:	83 c4 10             	add    $0x10,%esp
    exit();
    2276:	e8 1a 1e 00 00       	call   4095 <exit>
  }

  if(chdir("dd") != 0){
    227b:	83 ec 0c             	sub    $0xc,%esp
    227e:	68 a5 4f 00 00       	push   $0x4fa5
    2283:	e8 7d 1e 00 00       	call   4105 <chdir>
    2288:	83 c4 10             	add    $0x10,%esp
    228b:	85 c0                	test   %eax,%eax
    228d:	74 17                	je     22a6 <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    228f:	83 ec 08             	sub    $0x8,%esp
    2292:	68 f4 50 00 00       	push   $0x50f4
    2297:	6a 01                	push   $0x1
    2299:	e8 73 1f 00 00       	call   4211 <printf>
    229e:	83 c4 10             	add    $0x10,%esp
    exit();
    22a1:	e8 ef 1d 00 00       	call   4095 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    22a6:	83 ec 0c             	sub    $0xc,%esp
    22a9:	68 05 51 00 00       	push   $0x5105
    22ae:	e8 52 1e 00 00       	call   4105 <chdir>
    22b3:	83 c4 10             	add    $0x10,%esp
    22b6:	85 c0                	test   %eax,%eax
    22b8:	74 17                	je     22d1 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    22ba:	83 ec 08             	sub    $0x8,%esp
    22bd:	68 11 51 00 00       	push   $0x5111
    22c2:	6a 01                	push   $0x1
    22c4:	e8 48 1f 00 00       	call   4211 <printf>
    22c9:	83 c4 10             	add    $0x10,%esp
    exit();
    22cc:	e8 c4 1d 00 00       	call   4095 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    22d1:	83 ec 0c             	sub    $0xc,%esp
    22d4:	68 2b 51 00 00       	push   $0x512b
    22d9:	e8 27 1e 00 00       	call   4105 <chdir>
    22de:	83 c4 10             	add    $0x10,%esp
    22e1:	85 c0                	test   %eax,%eax
    22e3:	74 17                	je     22fc <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    22e5:	83 ec 08             	sub    $0x8,%esp
    22e8:	68 11 51 00 00       	push   $0x5111
    22ed:	6a 01                	push   $0x1
    22ef:	e8 1d 1f 00 00       	call   4211 <printf>
    22f4:	83 c4 10             	add    $0x10,%esp
    exit();
    22f7:	e8 99 1d 00 00       	call   4095 <exit>
  }
  if(chdir("./..") != 0){
    22fc:	83 ec 0c             	sub    $0xc,%esp
    22ff:	68 3a 51 00 00       	push   $0x513a
    2304:	e8 fc 1d 00 00       	call   4105 <chdir>
    2309:	83 c4 10             	add    $0x10,%esp
    230c:	85 c0                	test   %eax,%eax
    230e:	74 17                	je     2327 <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2310:	83 ec 08             	sub    $0x8,%esp
    2313:	68 3f 51 00 00       	push   $0x513f
    2318:	6a 01                	push   $0x1
    231a:	e8 f2 1e 00 00       	call   4211 <printf>
    231f:	83 c4 10             	add    $0x10,%esp
    exit();
    2322:	e8 6e 1d 00 00       	call   4095 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2327:	83 ec 08             	sub    $0x8,%esp
    232a:	6a 00                	push   $0x0
    232c:	68 88 50 00 00       	push   $0x5088
    2331:	e8 9f 1d 00 00       	call   40d5 <open>
    2336:	83 c4 10             	add    $0x10,%esp
    2339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    233c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2340:	79 17                	jns    2359 <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    2342:	83 ec 08             	sub    $0x8,%esp
    2345:	68 52 51 00 00       	push   $0x5152
    234a:	6a 01                	push   $0x1
    234c:	e8 c0 1e 00 00       	call   4211 <printf>
    2351:	83 c4 10             	add    $0x10,%esp
    exit();
    2354:	e8 3c 1d 00 00       	call   4095 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2359:	83 ec 04             	sub    $0x4,%esp
    235c:	68 00 20 00 00       	push   $0x2000
    2361:	68 40 65 00 00       	push   $0x6540
    2366:	ff 75 f4             	push   -0xc(%ebp)
    2369:	e8 3f 1d 00 00       	call   40ad <read>
    236e:	83 c4 10             	add    $0x10,%esp
    2371:	83 f8 02             	cmp    $0x2,%eax
    2374:	74 17                	je     238d <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    2376:	83 ec 08             	sub    $0x8,%esp
    2379:	68 6a 51 00 00       	push   $0x516a
    237e:	6a 01                	push   $0x1
    2380:	e8 8c 1e 00 00       	call   4211 <printf>
    2385:	83 c4 10             	add    $0x10,%esp
    exit();
    2388:	e8 08 1d 00 00       	call   4095 <exit>
  }
  close(fd);
    238d:	83 ec 0c             	sub    $0xc,%esp
    2390:	ff 75 f4             	push   -0xc(%ebp)
    2393:	e8 25 1d 00 00       	call   40bd <close>
    2398:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    239b:	83 ec 08             	sub    $0x8,%esp
    239e:	6a 00                	push   $0x0
    23a0:	68 24 50 00 00       	push   $0x5024
    23a5:	e8 2b 1d 00 00       	call   40d5 <open>
    23aa:	83 c4 10             	add    $0x10,%esp
    23ad:	85 c0                	test   %eax,%eax
    23af:	78 17                	js     23c8 <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    23b1:	83 ec 08             	sub    $0x8,%esp
    23b4:	68 88 51 00 00       	push   $0x5188
    23b9:	6a 01                	push   $0x1
    23bb:	e8 51 1e 00 00       	call   4211 <printf>
    23c0:	83 c4 10             	add    $0x10,%esp
    exit();
    23c3:	e8 cd 1c 00 00       	call   4095 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    23c8:	83 ec 08             	sub    $0x8,%esp
    23cb:	68 02 02 00 00       	push   $0x202
    23d0:	68 ad 51 00 00       	push   $0x51ad
    23d5:	e8 fb 1c 00 00       	call   40d5 <open>
    23da:	83 c4 10             	add    $0x10,%esp
    23dd:	85 c0                	test   %eax,%eax
    23df:	78 17                	js     23f8 <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    23e1:	83 ec 08             	sub    $0x8,%esp
    23e4:	68 b6 51 00 00       	push   $0x51b6
    23e9:	6a 01                	push   $0x1
    23eb:	e8 21 1e 00 00       	call   4211 <printf>
    23f0:	83 c4 10             	add    $0x10,%esp
    exit();
    23f3:	e8 9d 1c 00 00       	call   4095 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    23f8:	83 ec 08             	sub    $0x8,%esp
    23fb:	68 02 02 00 00       	push   $0x202
    2400:	68 d2 51 00 00       	push   $0x51d2
    2405:	e8 cb 1c 00 00       	call   40d5 <open>
    240a:	83 c4 10             	add    $0x10,%esp
    240d:	85 c0                	test   %eax,%eax
    240f:	78 17                	js     2428 <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2411:	83 ec 08             	sub    $0x8,%esp
    2414:	68 db 51 00 00       	push   $0x51db
    2419:	6a 01                	push   $0x1
    241b:	e8 f1 1d 00 00       	call   4211 <printf>
    2420:	83 c4 10             	add    $0x10,%esp
    exit();
    2423:	e8 6d 1c 00 00       	call   4095 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2428:	83 ec 08             	sub    $0x8,%esp
    242b:	68 00 02 00 00       	push   $0x200
    2430:	68 a5 4f 00 00       	push   $0x4fa5
    2435:	e8 9b 1c 00 00       	call   40d5 <open>
    243a:	83 c4 10             	add    $0x10,%esp
    243d:	85 c0                	test   %eax,%eax
    243f:	78 17                	js     2458 <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    2441:	83 ec 08             	sub    $0x8,%esp
    2444:	68 f7 51 00 00       	push   $0x51f7
    2449:	6a 01                	push   $0x1
    244b:	e8 c1 1d 00 00       	call   4211 <printf>
    2450:	83 c4 10             	add    $0x10,%esp
    exit();
    2453:	e8 3d 1c 00 00       	call   4095 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    2458:	83 ec 08             	sub    $0x8,%esp
    245b:	6a 02                	push   $0x2
    245d:	68 a5 4f 00 00       	push   $0x4fa5
    2462:	e8 6e 1c 00 00       	call   40d5 <open>
    2467:	83 c4 10             	add    $0x10,%esp
    246a:	85 c0                	test   %eax,%eax
    246c:	78 17                	js     2485 <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    246e:	83 ec 08             	sub    $0x8,%esp
    2471:	68 0d 52 00 00       	push   $0x520d
    2476:	6a 01                	push   $0x1
    2478:	e8 94 1d 00 00       	call   4211 <printf>
    247d:	83 c4 10             	add    $0x10,%esp
    exit();
    2480:	e8 10 1c 00 00       	call   4095 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2485:	83 ec 08             	sub    $0x8,%esp
    2488:	6a 01                	push   $0x1
    248a:	68 a5 4f 00 00       	push   $0x4fa5
    248f:	e8 41 1c 00 00       	call   40d5 <open>
    2494:	83 c4 10             	add    $0x10,%esp
    2497:	85 c0                	test   %eax,%eax
    2499:	78 17                	js     24b2 <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    249b:	83 ec 08             	sub    $0x8,%esp
    249e:	68 26 52 00 00       	push   $0x5226
    24a3:	6a 01                	push   $0x1
    24a5:	e8 67 1d 00 00       	call   4211 <printf>
    24aa:	83 c4 10             	add    $0x10,%esp
    exit();
    24ad:	e8 e3 1b 00 00       	call   4095 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    24b2:	83 ec 08             	sub    $0x8,%esp
    24b5:	68 41 52 00 00       	push   $0x5241
    24ba:	68 ad 51 00 00       	push   $0x51ad
    24bf:	e8 31 1c 00 00       	call   40f5 <link>
    24c4:	83 c4 10             	add    $0x10,%esp
    24c7:	85 c0                	test   %eax,%eax
    24c9:	75 17                	jne    24e2 <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    24cb:	83 ec 08             	sub    $0x8,%esp
    24ce:	68 4c 52 00 00       	push   $0x524c
    24d3:	6a 01                	push   $0x1
    24d5:	e8 37 1d 00 00       	call   4211 <printf>
    24da:	83 c4 10             	add    $0x10,%esp
    exit();
    24dd:	e8 b3 1b 00 00       	call   4095 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    24e2:	83 ec 08             	sub    $0x8,%esp
    24e5:	68 41 52 00 00       	push   $0x5241
    24ea:	68 d2 51 00 00       	push   $0x51d2
    24ef:	e8 01 1c 00 00       	call   40f5 <link>
    24f4:	83 c4 10             	add    $0x10,%esp
    24f7:	85 c0                	test   %eax,%eax
    24f9:	75 17                	jne    2512 <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    24fb:	83 ec 08             	sub    $0x8,%esp
    24fe:	68 70 52 00 00       	push   $0x5270
    2503:	6a 01                	push   $0x1
    2505:	e8 07 1d 00 00       	call   4211 <printf>
    250a:	83 c4 10             	add    $0x10,%esp
    exit();
    250d:	e8 83 1b 00 00       	call   4095 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2512:	83 ec 08             	sub    $0x8,%esp
    2515:	68 88 50 00 00       	push   $0x5088
    251a:	68 c0 4f 00 00       	push   $0x4fc0
    251f:	e8 d1 1b 00 00       	call   40f5 <link>
    2524:	83 c4 10             	add    $0x10,%esp
    2527:	85 c0                	test   %eax,%eax
    2529:	75 17                	jne    2542 <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    252b:	83 ec 08             	sub    $0x8,%esp
    252e:	68 94 52 00 00       	push   $0x5294
    2533:	6a 01                	push   $0x1
    2535:	e8 d7 1c 00 00       	call   4211 <printf>
    253a:	83 c4 10             	add    $0x10,%esp
    exit();
    253d:	e8 53 1b 00 00       	call   4095 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2542:	83 ec 0c             	sub    $0xc,%esp
    2545:	68 ad 51 00 00       	push   $0x51ad
    254a:	e8 ae 1b 00 00       	call   40fd <mkdir>
    254f:	83 c4 10             	add    $0x10,%esp
    2552:	85 c0                	test   %eax,%eax
    2554:	75 17                	jne    256d <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2556:	83 ec 08             	sub    $0x8,%esp
    2559:	68 b6 52 00 00       	push   $0x52b6
    255e:	6a 01                	push   $0x1
    2560:	e8 ac 1c 00 00       	call   4211 <printf>
    2565:	83 c4 10             	add    $0x10,%esp
    exit();
    2568:	e8 28 1b 00 00       	call   4095 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    256d:	83 ec 0c             	sub    $0xc,%esp
    2570:	68 d2 51 00 00       	push   $0x51d2
    2575:	e8 83 1b 00 00       	call   40fd <mkdir>
    257a:	83 c4 10             	add    $0x10,%esp
    257d:	85 c0                	test   %eax,%eax
    257f:	75 17                	jne    2598 <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2581:	83 ec 08             	sub    $0x8,%esp
    2584:	68 d1 52 00 00       	push   $0x52d1
    2589:	6a 01                	push   $0x1
    258b:	e8 81 1c 00 00       	call   4211 <printf>
    2590:	83 c4 10             	add    $0x10,%esp
    exit();
    2593:	e8 fd 1a 00 00       	call   4095 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2598:	83 ec 0c             	sub    $0xc,%esp
    259b:	68 88 50 00 00       	push   $0x5088
    25a0:	e8 58 1b 00 00       	call   40fd <mkdir>
    25a5:	83 c4 10             	add    $0x10,%esp
    25a8:	85 c0                	test   %eax,%eax
    25aa:	75 17                	jne    25c3 <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    25ac:	83 ec 08             	sub    $0x8,%esp
    25af:	68 ec 52 00 00       	push   $0x52ec
    25b4:	6a 01                	push   $0x1
    25b6:	e8 56 1c 00 00       	call   4211 <printf>
    25bb:	83 c4 10             	add    $0x10,%esp
    exit();
    25be:	e8 d2 1a 00 00       	call   4095 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    25c3:	83 ec 0c             	sub    $0xc,%esp
    25c6:	68 d2 51 00 00       	push   $0x51d2
    25cb:	e8 15 1b 00 00       	call   40e5 <unlink>
    25d0:	83 c4 10             	add    $0x10,%esp
    25d3:	85 c0                	test   %eax,%eax
    25d5:	75 17                	jne    25ee <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    25d7:	83 ec 08             	sub    $0x8,%esp
    25da:	68 09 53 00 00       	push   $0x5309
    25df:	6a 01                	push   $0x1
    25e1:	e8 2b 1c 00 00       	call   4211 <printf>
    25e6:	83 c4 10             	add    $0x10,%esp
    exit();
    25e9:	e8 a7 1a 00 00       	call   4095 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    25ee:	83 ec 0c             	sub    $0xc,%esp
    25f1:	68 ad 51 00 00       	push   $0x51ad
    25f6:	e8 ea 1a 00 00       	call   40e5 <unlink>
    25fb:	83 c4 10             	add    $0x10,%esp
    25fe:	85 c0                	test   %eax,%eax
    2600:	75 17                	jne    2619 <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2602:	83 ec 08             	sub    $0x8,%esp
    2605:	68 25 53 00 00       	push   $0x5325
    260a:	6a 01                	push   $0x1
    260c:	e8 00 1c 00 00       	call   4211 <printf>
    2611:	83 c4 10             	add    $0x10,%esp
    exit();
    2614:	e8 7c 1a 00 00       	call   4095 <exit>
  }
  if(chdir("dd/ff") == 0){
    2619:	83 ec 0c             	sub    $0xc,%esp
    261c:	68 c0 4f 00 00       	push   $0x4fc0
    2621:	e8 df 1a 00 00       	call   4105 <chdir>
    2626:	83 c4 10             	add    $0x10,%esp
    2629:	85 c0                	test   %eax,%eax
    262b:	75 17                	jne    2644 <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    262d:	83 ec 08             	sub    $0x8,%esp
    2630:	68 41 53 00 00       	push   $0x5341
    2635:	6a 01                	push   $0x1
    2637:	e8 d5 1b 00 00       	call   4211 <printf>
    263c:	83 c4 10             	add    $0x10,%esp
    exit();
    263f:	e8 51 1a 00 00       	call   4095 <exit>
  }
  if(chdir("dd/xx") == 0){
    2644:	83 ec 0c             	sub    $0xc,%esp
    2647:	68 59 53 00 00       	push   $0x5359
    264c:	e8 b4 1a 00 00       	call   4105 <chdir>
    2651:	83 c4 10             	add    $0x10,%esp
    2654:	85 c0                	test   %eax,%eax
    2656:	75 17                	jne    266f <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    2658:	83 ec 08             	sub    $0x8,%esp
    265b:	68 5f 53 00 00       	push   $0x535f
    2660:	6a 01                	push   $0x1
    2662:	e8 aa 1b 00 00       	call   4211 <printf>
    2667:	83 c4 10             	add    $0x10,%esp
    exit();
    266a:	e8 26 1a 00 00       	call   4095 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    266f:	83 ec 0c             	sub    $0xc,%esp
    2672:	68 88 50 00 00       	push   $0x5088
    2677:	e8 69 1a 00 00       	call   40e5 <unlink>
    267c:	83 c4 10             	add    $0x10,%esp
    267f:	85 c0                	test   %eax,%eax
    2681:	74 17                	je     269a <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    2683:	83 ec 08             	sub    $0x8,%esp
    2686:	68 b5 50 00 00       	push   $0x50b5
    268b:	6a 01                	push   $0x1
    268d:	e8 7f 1b 00 00       	call   4211 <printf>
    2692:	83 c4 10             	add    $0x10,%esp
    exit();
    2695:	e8 fb 19 00 00       	call   4095 <exit>
  }
  if(unlink("dd/ff") != 0){
    269a:	83 ec 0c             	sub    $0xc,%esp
    269d:	68 c0 4f 00 00       	push   $0x4fc0
    26a2:	e8 3e 1a 00 00       	call   40e5 <unlink>
    26a7:	83 c4 10             	add    $0x10,%esp
    26aa:	85 c0                	test   %eax,%eax
    26ac:	74 17                	je     26c5 <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    26ae:	83 ec 08             	sub    $0x8,%esp
    26b1:	68 77 53 00 00       	push   $0x5377
    26b6:	6a 01                	push   $0x1
    26b8:	e8 54 1b 00 00       	call   4211 <printf>
    26bd:	83 c4 10             	add    $0x10,%esp
    exit();
    26c0:	e8 d0 19 00 00       	call   4095 <exit>
  }
  if(unlink("dd") == 0){
    26c5:	83 ec 0c             	sub    $0xc,%esp
    26c8:	68 a5 4f 00 00       	push   $0x4fa5
    26cd:	e8 13 1a 00 00       	call   40e5 <unlink>
    26d2:	83 c4 10             	add    $0x10,%esp
    26d5:	85 c0                	test   %eax,%eax
    26d7:	75 17                	jne    26f0 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    26d9:	83 ec 08             	sub    $0x8,%esp
    26dc:	68 8c 53 00 00       	push   $0x538c
    26e1:	6a 01                	push   $0x1
    26e3:	e8 29 1b 00 00       	call   4211 <printf>
    26e8:	83 c4 10             	add    $0x10,%esp
    exit();
    26eb:	e8 a5 19 00 00       	call   4095 <exit>
  }
  if(unlink("dd/dd") < 0){
    26f0:	83 ec 0c             	sub    $0xc,%esp
    26f3:	68 ac 53 00 00       	push   $0x53ac
    26f8:	e8 e8 19 00 00       	call   40e5 <unlink>
    26fd:	83 c4 10             	add    $0x10,%esp
    2700:	85 c0                	test   %eax,%eax
    2702:	79 17                	jns    271b <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    2704:	83 ec 08             	sub    $0x8,%esp
    2707:	68 b2 53 00 00       	push   $0x53b2
    270c:	6a 01                	push   $0x1
    270e:	e8 fe 1a 00 00       	call   4211 <printf>
    2713:	83 c4 10             	add    $0x10,%esp
    exit();
    2716:	e8 7a 19 00 00       	call   4095 <exit>
  }
  if(unlink("dd") < 0){
    271b:	83 ec 0c             	sub    $0xc,%esp
    271e:	68 a5 4f 00 00       	push   $0x4fa5
    2723:	e8 bd 19 00 00       	call   40e5 <unlink>
    2728:	83 c4 10             	add    $0x10,%esp
    272b:	85 c0                	test   %eax,%eax
    272d:	79 17                	jns    2746 <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    272f:	83 ec 08             	sub    $0x8,%esp
    2732:	68 c7 53 00 00       	push   $0x53c7
    2737:	6a 01                	push   $0x1
    2739:	e8 d3 1a 00 00       	call   4211 <printf>
    273e:	83 c4 10             	add    $0x10,%esp
    exit();
    2741:	e8 4f 19 00 00       	call   4095 <exit>
  }

  printf(1, "subdir ok\n");
    2746:	83 ec 08             	sub    $0x8,%esp
    2749:	68 d9 53 00 00       	push   $0x53d9
    274e:	6a 01                	push   $0x1
    2750:	e8 bc 1a 00 00       	call   4211 <printf>
    2755:	83 c4 10             	add    $0x10,%esp
}
    2758:	90                   	nop
    2759:	c9                   	leave  
    275a:	c3                   	ret    

0000275b <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    275b:	55                   	push   %ebp
    275c:	89 e5                	mov    %esp,%ebp
    275e:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2761:	83 ec 08             	sub    $0x8,%esp
    2764:	68 e4 53 00 00       	push   $0x53e4
    2769:	6a 01                	push   $0x1
    276b:	e8 a1 1a 00 00       	call   4211 <printf>
    2770:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    2773:	83 ec 0c             	sub    $0xc,%esp
    2776:	68 f3 53 00 00       	push   $0x53f3
    277b:	e8 65 19 00 00       	call   40e5 <unlink>
    2780:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2783:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    278a:	e9 a8 00 00 00       	jmp    2837 <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    278f:	83 ec 08             	sub    $0x8,%esp
    2792:	68 02 02 00 00       	push   $0x202
    2797:	68 f3 53 00 00       	push   $0x53f3
    279c:	e8 34 19 00 00       	call   40d5 <open>
    27a1:	83 c4 10             	add    $0x10,%esp
    27a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    27a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    27ab:	79 17                	jns    27c4 <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    27ad:	83 ec 08             	sub    $0x8,%esp
    27b0:	68 fc 53 00 00       	push   $0x53fc
    27b5:	6a 01                	push   $0x1
    27b7:	e8 55 1a 00 00       	call   4211 <printf>
    27bc:	83 c4 10             	add    $0x10,%esp
      exit();
    27bf:	e8 d1 18 00 00       	call   4095 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    27c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    27cb:	eb 3f                	jmp    280c <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    27cd:	83 ec 04             	sub    $0x4,%esp
    27d0:	ff 75 f4             	push   -0xc(%ebp)
    27d3:	68 40 65 00 00       	push   $0x6540
    27d8:	ff 75 ec             	push   -0x14(%ebp)
    27db:	e8 d5 18 00 00       	call   40b5 <write>
    27e0:	83 c4 10             	add    $0x10,%esp
    27e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    27e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    27e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    27ec:	74 1a                	je     2808 <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    27ee:	ff 75 e8             	push   -0x18(%ebp)
    27f1:	ff 75 f4             	push   -0xc(%ebp)
    27f4:	68 14 54 00 00       	push   $0x5414
    27f9:	6a 01                	push   $0x1
    27fb:	e8 11 1a 00 00       	call   4211 <printf>
    2800:	83 c4 10             	add    $0x10,%esp
        exit();
    2803:	e8 8d 18 00 00       	call   4095 <exit>
    for(i = 0; i < 2; i++){
    2808:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    280c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2810:	7e bb                	jle    27cd <bigwrite+0x72>
      }
    }
    close(fd);
    2812:	83 ec 0c             	sub    $0xc,%esp
    2815:	ff 75 ec             	push   -0x14(%ebp)
    2818:	e8 a0 18 00 00       	call   40bd <close>
    281d:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2820:	83 ec 0c             	sub    $0xc,%esp
    2823:	68 f3 53 00 00       	push   $0x53f3
    2828:	e8 b8 18 00 00       	call   40e5 <unlink>
    282d:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2830:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2837:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    283e:	0f 8e 4b ff ff ff    	jle    278f <bigwrite+0x34>
  }

  printf(1, "bigwrite ok\n");
    2844:	83 ec 08             	sub    $0x8,%esp
    2847:	68 26 54 00 00       	push   $0x5426
    284c:	6a 01                	push   $0x1
    284e:	e8 be 19 00 00       	call   4211 <printf>
    2853:	83 c4 10             	add    $0x10,%esp
}
    2856:	90                   	nop
    2857:	c9                   	leave  
    2858:	c3                   	ret    

00002859 <bigfile>:

void
bigfile(void)
{
    2859:	55                   	push   %ebp
    285a:	89 e5                	mov    %esp,%ebp
    285c:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    285f:	83 ec 08             	sub    $0x8,%esp
    2862:	68 33 54 00 00       	push   $0x5433
    2867:	6a 01                	push   $0x1
    2869:	e8 a3 19 00 00       	call   4211 <printf>
    286e:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    2871:	83 ec 0c             	sub    $0xc,%esp
    2874:	68 41 54 00 00       	push   $0x5441
    2879:	e8 67 18 00 00       	call   40e5 <unlink>
    287e:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    2881:	83 ec 08             	sub    $0x8,%esp
    2884:	68 02 02 00 00       	push   $0x202
    2889:	68 41 54 00 00       	push   $0x5441
    288e:	e8 42 18 00 00       	call   40d5 <open>
    2893:	83 c4 10             	add    $0x10,%esp
    2896:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2899:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    289d:	79 17                	jns    28b6 <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    289f:	83 ec 08             	sub    $0x8,%esp
    28a2:	68 49 54 00 00       	push   $0x5449
    28a7:	6a 01                	push   $0x1
    28a9:	e8 63 19 00 00       	call   4211 <printf>
    28ae:	83 c4 10             	add    $0x10,%esp
    exit();
    28b1:	e8 df 17 00 00       	call   4095 <exit>
  }
  for(i = 0; i < 20; i++){
    28b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    28bd:	eb 52                	jmp    2911 <bigfile+0xb8>
    memset(buf, i, 600);
    28bf:	83 ec 04             	sub    $0x4,%esp
    28c2:	68 58 02 00 00       	push   $0x258
    28c7:	ff 75 f4             	push   -0xc(%ebp)
    28ca:	68 40 65 00 00       	push   $0x6540
    28cf:	e8 26 16 00 00       	call   3efa <memset>
    28d4:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    28d7:	83 ec 04             	sub    $0x4,%esp
    28da:	68 58 02 00 00       	push   $0x258
    28df:	68 40 65 00 00       	push   $0x6540
    28e4:	ff 75 ec             	push   -0x14(%ebp)
    28e7:	e8 c9 17 00 00       	call   40b5 <write>
    28ec:	83 c4 10             	add    $0x10,%esp
    28ef:	3d 58 02 00 00       	cmp    $0x258,%eax
    28f4:	74 17                	je     290d <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    28f6:	83 ec 08             	sub    $0x8,%esp
    28f9:	68 5f 54 00 00       	push   $0x545f
    28fe:	6a 01                	push   $0x1
    2900:	e8 0c 19 00 00       	call   4211 <printf>
    2905:	83 c4 10             	add    $0x10,%esp
      exit();
    2908:	e8 88 17 00 00       	call   4095 <exit>
  for(i = 0; i < 20; i++){
    290d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2911:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2915:	7e a8                	jle    28bf <bigfile+0x66>
    }
  }
  close(fd);
    2917:	83 ec 0c             	sub    $0xc,%esp
    291a:	ff 75 ec             	push   -0x14(%ebp)
    291d:	e8 9b 17 00 00       	call   40bd <close>
    2922:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    2925:	83 ec 08             	sub    $0x8,%esp
    2928:	6a 00                	push   $0x0
    292a:	68 41 54 00 00       	push   $0x5441
    292f:	e8 a1 17 00 00       	call   40d5 <open>
    2934:	83 c4 10             	add    $0x10,%esp
    2937:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    293a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    293e:	79 17                	jns    2957 <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    2940:	83 ec 08             	sub    $0x8,%esp
    2943:	68 75 54 00 00       	push   $0x5475
    2948:	6a 01                	push   $0x1
    294a:	e8 c2 18 00 00       	call   4211 <printf>
    294f:	83 c4 10             	add    $0x10,%esp
    exit();
    2952:	e8 3e 17 00 00       	call   4095 <exit>
  }
  total = 0;
    2957:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    295e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2965:	83 ec 04             	sub    $0x4,%esp
    2968:	68 2c 01 00 00       	push   $0x12c
    296d:	68 40 65 00 00       	push   $0x6540
    2972:	ff 75 ec             	push   -0x14(%ebp)
    2975:	e8 33 17 00 00       	call   40ad <read>
    297a:	83 c4 10             	add    $0x10,%esp
    297d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    2980:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2984:	79 17                	jns    299d <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    2986:	83 ec 08             	sub    $0x8,%esp
    2989:	68 8a 54 00 00       	push   $0x548a
    298e:	6a 01                	push   $0x1
    2990:	e8 7c 18 00 00       	call   4211 <printf>
    2995:	83 c4 10             	add    $0x10,%esp
      exit();
    2998:	e8 f8 16 00 00       	call   4095 <exit>
    }
    if(cc == 0)
    299d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    29a1:	74 7a                	je     2a1d <bigfile+0x1c4>
      break;
    if(cc != 300){
    29a3:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    29aa:	74 17                	je     29c3 <bigfile+0x16a>
      printf(1, "short read bigfile\n");
    29ac:	83 ec 08             	sub    $0x8,%esp
    29af:	68 9f 54 00 00       	push   $0x549f
    29b4:	6a 01                	push   $0x1
    29b6:	e8 56 18 00 00       	call   4211 <printf>
    29bb:	83 c4 10             	add    $0x10,%esp
      exit();
    29be:	e8 d2 16 00 00       	call   4095 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    29c3:	0f b6 05 40 65 00 00 	movzbl 0x6540,%eax
    29ca:	0f be d0             	movsbl %al,%edx
    29cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29d0:	89 c1                	mov    %eax,%ecx
    29d2:	c1 e9 1f             	shr    $0x1f,%ecx
    29d5:	01 c8                	add    %ecx,%eax
    29d7:	d1 f8                	sar    %eax
    29d9:	39 c2                	cmp    %eax,%edx
    29db:	75 1a                	jne    29f7 <bigfile+0x19e>
    29dd:	0f b6 05 6b 66 00 00 	movzbl 0x666b,%eax
    29e4:	0f be d0             	movsbl %al,%edx
    29e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29ea:	89 c1                	mov    %eax,%ecx
    29ec:	c1 e9 1f             	shr    $0x1f,%ecx
    29ef:	01 c8                	add    %ecx,%eax
    29f1:	d1 f8                	sar    %eax
    29f3:	39 c2                	cmp    %eax,%edx
    29f5:	74 17                	je     2a0e <bigfile+0x1b5>
      printf(1, "read bigfile wrong data\n");
    29f7:	83 ec 08             	sub    $0x8,%esp
    29fa:	68 b3 54 00 00       	push   $0x54b3
    29ff:	6a 01                	push   $0x1
    2a01:	e8 0b 18 00 00       	call   4211 <printf>
    2a06:	83 c4 10             	add    $0x10,%esp
      exit();
    2a09:	e8 87 16 00 00       	call   4095 <exit>
    }
    total += cc;
    2a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2a11:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    2a14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2a18:	e9 48 ff ff ff       	jmp    2965 <bigfile+0x10c>
      break;
    2a1d:	90                   	nop
  }
  close(fd);
    2a1e:	83 ec 0c             	sub    $0xc,%esp
    2a21:	ff 75 ec             	push   -0x14(%ebp)
    2a24:	e8 94 16 00 00       	call   40bd <close>
    2a29:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    2a2c:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    2a33:	74 17                	je     2a4c <bigfile+0x1f3>
    printf(1, "read bigfile wrong total\n");
    2a35:	83 ec 08             	sub    $0x8,%esp
    2a38:	68 cc 54 00 00       	push   $0x54cc
    2a3d:	6a 01                	push   $0x1
    2a3f:	e8 cd 17 00 00       	call   4211 <printf>
    2a44:	83 c4 10             	add    $0x10,%esp
    exit();
    2a47:	e8 49 16 00 00       	call   4095 <exit>
  }
  unlink("bigfile");
    2a4c:	83 ec 0c             	sub    $0xc,%esp
    2a4f:	68 41 54 00 00       	push   $0x5441
    2a54:	e8 8c 16 00 00       	call   40e5 <unlink>
    2a59:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    2a5c:	83 ec 08             	sub    $0x8,%esp
    2a5f:	68 e6 54 00 00       	push   $0x54e6
    2a64:	6a 01                	push   $0x1
    2a66:	e8 a6 17 00 00       	call   4211 <printf>
    2a6b:	83 c4 10             	add    $0x10,%esp
}
    2a6e:	90                   	nop
    2a6f:	c9                   	leave  
    2a70:	c3                   	ret    

00002a71 <fourteen>:

void
fourteen(void)
{
    2a71:	55                   	push   %ebp
    2a72:	89 e5                	mov    %esp,%ebp
    2a74:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2a77:	83 ec 08             	sub    $0x8,%esp
    2a7a:	68 f7 54 00 00       	push   $0x54f7
    2a7f:	6a 01                	push   $0x1
    2a81:	e8 8b 17 00 00       	call   4211 <printf>
    2a86:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    2a89:	83 ec 0c             	sub    $0xc,%esp
    2a8c:	68 06 55 00 00       	push   $0x5506
    2a91:	e8 67 16 00 00       	call   40fd <mkdir>
    2a96:	83 c4 10             	add    $0x10,%esp
    2a99:	85 c0                	test   %eax,%eax
    2a9b:	74 17                	je     2ab4 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a9d:	83 ec 08             	sub    $0x8,%esp
    2aa0:	68 15 55 00 00       	push   $0x5515
    2aa5:	6a 01                	push   $0x1
    2aa7:	e8 65 17 00 00       	call   4211 <printf>
    2aac:	83 c4 10             	add    $0x10,%esp
    exit();
    2aaf:	e8 e1 15 00 00       	call   4095 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2ab4:	83 ec 0c             	sub    $0xc,%esp
    2ab7:	68 34 55 00 00       	push   $0x5534
    2abc:	e8 3c 16 00 00       	call   40fd <mkdir>
    2ac1:	83 c4 10             	add    $0x10,%esp
    2ac4:	85 c0                	test   %eax,%eax
    2ac6:	74 17                	je     2adf <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2ac8:	83 ec 08             	sub    $0x8,%esp
    2acb:	68 54 55 00 00       	push   $0x5554
    2ad0:	6a 01                	push   $0x1
    2ad2:	e8 3a 17 00 00       	call   4211 <printf>
    2ad7:	83 c4 10             	add    $0x10,%esp
    exit();
    2ada:	e8 b6 15 00 00       	call   4095 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2adf:	83 ec 08             	sub    $0x8,%esp
    2ae2:	68 00 02 00 00       	push   $0x200
    2ae7:	68 84 55 00 00       	push   $0x5584
    2aec:	e8 e4 15 00 00       	call   40d5 <open>
    2af1:	83 c4 10             	add    $0x10,%esp
    2af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2afb:	79 17                	jns    2b14 <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2afd:	83 ec 08             	sub    $0x8,%esp
    2b00:	68 b4 55 00 00       	push   $0x55b4
    2b05:	6a 01                	push   $0x1
    2b07:	e8 05 17 00 00       	call   4211 <printf>
    2b0c:	83 c4 10             	add    $0x10,%esp
    exit();
    2b0f:	e8 81 15 00 00       	call   4095 <exit>
  }
  close(fd);
    2b14:	83 ec 0c             	sub    $0xc,%esp
    2b17:	ff 75 f4             	push   -0xc(%ebp)
    2b1a:	e8 9e 15 00 00       	call   40bd <close>
    2b1f:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2b22:	83 ec 08             	sub    $0x8,%esp
    2b25:	6a 00                	push   $0x0
    2b27:	68 f4 55 00 00       	push   $0x55f4
    2b2c:	e8 a4 15 00 00       	call   40d5 <open>
    2b31:	83 c4 10             	add    $0x10,%esp
    2b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2b3b:	79 17                	jns    2b54 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2b3d:	83 ec 08             	sub    $0x8,%esp
    2b40:	68 24 56 00 00       	push   $0x5624
    2b45:	6a 01                	push   $0x1
    2b47:	e8 c5 16 00 00       	call   4211 <printf>
    2b4c:	83 c4 10             	add    $0x10,%esp
    exit();
    2b4f:	e8 41 15 00 00       	call   4095 <exit>
  }
  close(fd);
    2b54:	83 ec 0c             	sub    $0xc,%esp
    2b57:	ff 75 f4             	push   -0xc(%ebp)
    2b5a:	e8 5e 15 00 00       	call   40bd <close>
    2b5f:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2b62:	83 ec 0c             	sub    $0xc,%esp
    2b65:	68 5e 56 00 00       	push   $0x565e
    2b6a:	e8 8e 15 00 00       	call   40fd <mkdir>
    2b6f:	83 c4 10             	add    $0x10,%esp
    2b72:	85 c0                	test   %eax,%eax
    2b74:	75 17                	jne    2b8d <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2b76:	83 ec 08             	sub    $0x8,%esp
    2b79:	68 7c 56 00 00       	push   $0x567c
    2b7e:	6a 01                	push   $0x1
    2b80:	e8 8c 16 00 00       	call   4211 <printf>
    2b85:	83 c4 10             	add    $0x10,%esp
    exit();
    2b88:	e8 08 15 00 00       	call   4095 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2b8d:	83 ec 0c             	sub    $0xc,%esp
    2b90:	68 ac 56 00 00       	push   $0x56ac
    2b95:	e8 63 15 00 00       	call   40fd <mkdir>
    2b9a:	83 c4 10             	add    $0x10,%esp
    2b9d:	85 c0                	test   %eax,%eax
    2b9f:	75 17                	jne    2bb8 <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2ba1:	83 ec 08             	sub    $0x8,%esp
    2ba4:	68 cc 56 00 00       	push   $0x56cc
    2ba9:	6a 01                	push   $0x1
    2bab:	e8 61 16 00 00       	call   4211 <printf>
    2bb0:	83 c4 10             	add    $0x10,%esp
    exit();
    2bb3:	e8 dd 14 00 00       	call   4095 <exit>
  }

  printf(1, "fourteen ok\n");
    2bb8:	83 ec 08             	sub    $0x8,%esp
    2bbb:	68 fd 56 00 00       	push   $0x56fd
    2bc0:	6a 01                	push   $0x1
    2bc2:	e8 4a 16 00 00       	call   4211 <printf>
    2bc7:	83 c4 10             	add    $0x10,%esp
}
    2bca:	90                   	nop
    2bcb:	c9                   	leave  
    2bcc:	c3                   	ret    

00002bcd <rmdot>:

void
rmdot(void)
{
    2bcd:	55                   	push   %ebp
    2bce:	89 e5                	mov    %esp,%ebp
    2bd0:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2bd3:	83 ec 08             	sub    $0x8,%esp
    2bd6:	68 0a 57 00 00       	push   $0x570a
    2bdb:	6a 01                	push   $0x1
    2bdd:	e8 2f 16 00 00       	call   4211 <printf>
    2be2:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2be5:	83 ec 0c             	sub    $0xc,%esp
    2be8:	68 16 57 00 00       	push   $0x5716
    2bed:	e8 0b 15 00 00       	call   40fd <mkdir>
    2bf2:	83 c4 10             	add    $0x10,%esp
    2bf5:	85 c0                	test   %eax,%eax
    2bf7:	74 17                	je     2c10 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2bf9:	83 ec 08             	sub    $0x8,%esp
    2bfc:	68 1b 57 00 00       	push   $0x571b
    2c01:	6a 01                	push   $0x1
    2c03:	e8 09 16 00 00       	call   4211 <printf>
    2c08:	83 c4 10             	add    $0x10,%esp
    exit();
    2c0b:	e8 85 14 00 00       	call   4095 <exit>
  }
  if(chdir("dots") != 0){
    2c10:	83 ec 0c             	sub    $0xc,%esp
    2c13:	68 16 57 00 00       	push   $0x5716
    2c18:	e8 e8 14 00 00       	call   4105 <chdir>
    2c1d:	83 c4 10             	add    $0x10,%esp
    2c20:	85 c0                	test   %eax,%eax
    2c22:	74 17                	je     2c3b <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2c24:	83 ec 08             	sub    $0x8,%esp
    2c27:	68 2e 57 00 00       	push   $0x572e
    2c2c:	6a 01                	push   $0x1
    2c2e:	e8 de 15 00 00       	call   4211 <printf>
    2c33:	83 c4 10             	add    $0x10,%esp
    exit();
    2c36:	e8 5a 14 00 00       	call   4095 <exit>
  }
  if(unlink(".") == 0){
    2c3b:	83 ec 0c             	sub    $0xc,%esp
    2c3e:	68 47 4e 00 00       	push   $0x4e47
    2c43:	e8 9d 14 00 00       	call   40e5 <unlink>
    2c48:	83 c4 10             	add    $0x10,%esp
    2c4b:	85 c0                	test   %eax,%eax
    2c4d:	75 17                	jne    2c66 <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2c4f:	83 ec 08             	sub    $0x8,%esp
    2c52:	68 41 57 00 00       	push   $0x5741
    2c57:	6a 01                	push   $0x1
    2c59:	e8 b3 15 00 00       	call   4211 <printf>
    2c5e:	83 c4 10             	add    $0x10,%esp
    exit();
    2c61:	e8 2f 14 00 00       	call   4095 <exit>
  }
  if(unlink("..") == 0){
    2c66:	83 ec 0c             	sub    $0xc,%esp
    2c69:	68 e6 49 00 00       	push   $0x49e6
    2c6e:	e8 72 14 00 00       	call   40e5 <unlink>
    2c73:	83 c4 10             	add    $0x10,%esp
    2c76:	85 c0                	test   %eax,%eax
    2c78:	75 17                	jne    2c91 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2c7a:	83 ec 08             	sub    $0x8,%esp
    2c7d:	68 4f 57 00 00       	push   $0x574f
    2c82:	6a 01                	push   $0x1
    2c84:	e8 88 15 00 00       	call   4211 <printf>
    2c89:	83 c4 10             	add    $0x10,%esp
    exit();
    2c8c:	e8 04 14 00 00       	call   4095 <exit>
  }
  if(chdir("/") != 0){
    2c91:	83 ec 0c             	sub    $0xc,%esp
    2c94:	68 3a 46 00 00       	push   $0x463a
    2c99:	e8 67 14 00 00       	call   4105 <chdir>
    2c9e:	83 c4 10             	add    $0x10,%esp
    2ca1:	85 c0                	test   %eax,%eax
    2ca3:	74 17                	je     2cbc <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2ca5:	83 ec 08             	sub    $0x8,%esp
    2ca8:	68 3c 46 00 00       	push   $0x463c
    2cad:	6a 01                	push   $0x1
    2caf:	e8 5d 15 00 00       	call   4211 <printf>
    2cb4:	83 c4 10             	add    $0x10,%esp
    exit();
    2cb7:	e8 d9 13 00 00       	call   4095 <exit>
  }
  if(unlink("dots/.") == 0){
    2cbc:	83 ec 0c             	sub    $0xc,%esp
    2cbf:	68 5e 57 00 00       	push   $0x575e
    2cc4:	e8 1c 14 00 00       	call   40e5 <unlink>
    2cc9:	83 c4 10             	add    $0x10,%esp
    2ccc:	85 c0                	test   %eax,%eax
    2cce:	75 17                	jne    2ce7 <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2cd0:	83 ec 08             	sub    $0x8,%esp
    2cd3:	68 65 57 00 00       	push   $0x5765
    2cd8:	6a 01                	push   $0x1
    2cda:	e8 32 15 00 00       	call   4211 <printf>
    2cdf:	83 c4 10             	add    $0x10,%esp
    exit();
    2ce2:	e8 ae 13 00 00       	call   4095 <exit>
  }
  if(unlink("dots/..") == 0){
    2ce7:	83 ec 0c             	sub    $0xc,%esp
    2cea:	68 7c 57 00 00       	push   $0x577c
    2cef:	e8 f1 13 00 00       	call   40e5 <unlink>
    2cf4:	83 c4 10             	add    $0x10,%esp
    2cf7:	85 c0                	test   %eax,%eax
    2cf9:	75 17                	jne    2d12 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2cfb:	83 ec 08             	sub    $0x8,%esp
    2cfe:	68 84 57 00 00       	push   $0x5784
    2d03:	6a 01                	push   $0x1
    2d05:	e8 07 15 00 00       	call   4211 <printf>
    2d0a:	83 c4 10             	add    $0x10,%esp
    exit();
    2d0d:	e8 83 13 00 00       	call   4095 <exit>
  }
  if(unlink("dots") != 0){
    2d12:	83 ec 0c             	sub    $0xc,%esp
    2d15:	68 16 57 00 00       	push   $0x5716
    2d1a:	e8 c6 13 00 00       	call   40e5 <unlink>
    2d1f:	83 c4 10             	add    $0x10,%esp
    2d22:	85 c0                	test   %eax,%eax
    2d24:	74 17                	je     2d3d <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2d26:	83 ec 08             	sub    $0x8,%esp
    2d29:	68 9c 57 00 00       	push   $0x579c
    2d2e:	6a 01                	push   $0x1
    2d30:	e8 dc 14 00 00       	call   4211 <printf>
    2d35:	83 c4 10             	add    $0x10,%esp
    exit();
    2d38:	e8 58 13 00 00       	call   4095 <exit>
  }
  printf(1, "rmdot ok\n");
    2d3d:	83 ec 08             	sub    $0x8,%esp
    2d40:	68 b1 57 00 00       	push   $0x57b1
    2d45:	6a 01                	push   $0x1
    2d47:	e8 c5 14 00 00       	call   4211 <printf>
    2d4c:	83 c4 10             	add    $0x10,%esp
}
    2d4f:	90                   	nop
    2d50:	c9                   	leave  
    2d51:	c3                   	ret    

00002d52 <dirfile>:

void
dirfile(void)
{
    2d52:	55                   	push   %ebp
    2d53:	89 e5                	mov    %esp,%ebp
    2d55:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2d58:	83 ec 08             	sub    $0x8,%esp
    2d5b:	68 bb 57 00 00       	push   $0x57bb
    2d60:	6a 01                	push   $0x1
    2d62:	e8 aa 14 00 00       	call   4211 <printf>
    2d67:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2d6a:	83 ec 08             	sub    $0x8,%esp
    2d6d:	68 00 02 00 00       	push   $0x200
    2d72:	68 c8 57 00 00       	push   $0x57c8
    2d77:	e8 59 13 00 00       	call   40d5 <open>
    2d7c:	83 c4 10             	add    $0x10,%esp
    2d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d86:	79 17                	jns    2d9f <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2d88:	83 ec 08             	sub    $0x8,%esp
    2d8b:	68 d0 57 00 00       	push   $0x57d0
    2d90:	6a 01                	push   $0x1
    2d92:	e8 7a 14 00 00       	call   4211 <printf>
    2d97:	83 c4 10             	add    $0x10,%esp
    exit();
    2d9a:	e8 f6 12 00 00       	call   4095 <exit>
  }
  close(fd);
    2d9f:	83 ec 0c             	sub    $0xc,%esp
    2da2:	ff 75 f4             	push   -0xc(%ebp)
    2da5:	e8 13 13 00 00       	call   40bd <close>
    2daa:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2dad:	83 ec 0c             	sub    $0xc,%esp
    2db0:	68 c8 57 00 00       	push   $0x57c8
    2db5:	e8 4b 13 00 00       	call   4105 <chdir>
    2dba:	83 c4 10             	add    $0x10,%esp
    2dbd:	85 c0                	test   %eax,%eax
    2dbf:	75 17                	jne    2dd8 <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2dc1:	83 ec 08             	sub    $0x8,%esp
    2dc4:	68 e7 57 00 00       	push   $0x57e7
    2dc9:	6a 01                	push   $0x1
    2dcb:	e8 41 14 00 00       	call   4211 <printf>
    2dd0:	83 c4 10             	add    $0x10,%esp
    exit();
    2dd3:	e8 bd 12 00 00       	call   4095 <exit>
  }
  fd = open("dirfile/xx", 0);
    2dd8:	83 ec 08             	sub    $0x8,%esp
    2ddb:	6a 00                	push   $0x0
    2ddd:	68 01 58 00 00       	push   $0x5801
    2de2:	e8 ee 12 00 00       	call   40d5 <open>
    2de7:	83 c4 10             	add    $0x10,%esp
    2dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2df1:	78 17                	js     2e0a <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2df3:	83 ec 08             	sub    $0x8,%esp
    2df6:	68 0c 58 00 00       	push   $0x580c
    2dfb:	6a 01                	push   $0x1
    2dfd:	e8 0f 14 00 00       	call   4211 <printf>
    2e02:	83 c4 10             	add    $0x10,%esp
    exit();
    2e05:	e8 8b 12 00 00       	call   4095 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2e0a:	83 ec 08             	sub    $0x8,%esp
    2e0d:	68 00 02 00 00       	push   $0x200
    2e12:	68 01 58 00 00       	push   $0x5801
    2e17:	e8 b9 12 00 00       	call   40d5 <open>
    2e1c:	83 c4 10             	add    $0x10,%esp
    2e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e26:	78 17                	js     2e3f <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2e28:	83 ec 08             	sub    $0x8,%esp
    2e2b:	68 0c 58 00 00       	push   $0x580c
    2e30:	6a 01                	push   $0x1
    2e32:	e8 da 13 00 00       	call   4211 <printf>
    2e37:	83 c4 10             	add    $0x10,%esp
    exit();
    2e3a:	e8 56 12 00 00       	call   4095 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2e3f:	83 ec 0c             	sub    $0xc,%esp
    2e42:	68 01 58 00 00       	push   $0x5801
    2e47:	e8 b1 12 00 00       	call   40fd <mkdir>
    2e4c:	83 c4 10             	add    $0x10,%esp
    2e4f:	85 c0                	test   %eax,%eax
    2e51:	75 17                	jne    2e6a <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2e53:	83 ec 08             	sub    $0x8,%esp
    2e56:	68 2a 58 00 00       	push   $0x582a
    2e5b:	6a 01                	push   $0x1
    2e5d:	e8 af 13 00 00       	call   4211 <printf>
    2e62:	83 c4 10             	add    $0x10,%esp
    exit();
    2e65:	e8 2b 12 00 00       	call   4095 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2e6a:	83 ec 0c             	sub    $0xc,%esp
    2e6d:	68 01 58 00 00       	push   $0x5801
    2e72:	e8 6e 12 00 00       	call   40e5 <unlink>
    2e77:	83 c4 10             	add    $0x10,%esp
    2e7a:	85 c0                	test   %eax,%eax
    2e7c:	75 17                	jne    2e95 <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2e7e:	83 ec 08             	sub    $0x8,%esp
    2e81:	68 47 58 00 00       	push   $0x5847
    2e86:	6a 01                	push   $0x1
    2e88:	e8 84 13 00 00       	call   4211 <printf>
    2e8d:	83 c4 10             	add    $0x10,%esp
    exit();
    2e90:	e8 00 12 00 00       	call   4095 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2e95:	83 ec 08             	sub    $0x8,%esp
    2e98:	68 01 58 00 00       	push   $0x5801
    2e9d:	68 65 58 00 00       	push   $0x5865
    2ea2:	e8 4e 12 00 00       	call   40f5 <link>
    2ea7:	83 c4 10             	add    $0x10,%esp
    2eaa:	85 c0                	test   %eax,%eax
    2eac:	75 17                	jne    2ec5 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2eae:	83 ec 08             	sub    $0x8,%esp
    2eb1:	68 6c 58 00 00       	push   $0x586c
    2eb6:	6a 01                	push   $0x1
    2eb8:	e8 54 13 00 00       	call   4211 <printf>
    2ebd:	83 c4 10             	add    $0x10,%esp
    exit();
    2ec0:	e8 d0 11 00 00       	call   4095 <exit>
  }
  if(unlink("dirfile") != 0){
    2ec5:	83 ec 0c             	sub    $0xc,%esp
    2ec8:	68 c8 57 00 00       	push   $0x57c8
    2ecd:	e8 13 12 00 00       	call   40e5 <unlink>
    2ed2:	83 c4 10             	add    $0x10,%esp
    2ed5:	85 c0                	test   %eax,%eax
    2ed7:	74 17                	je     2ef0 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2ed9:	83 ec 08             	sub    $0x8,%esp
    2edc:	68 8b 58 00 00       	push   $0x588b
    2ee1:	6a 01                	push   $0x1
    2ee3:	e8 29 13 00 00       	call   4211 <printf>
    2ee8:	83 c4 10             	add    $0x10,%esp
    exit();
    2eeb:	e8 a5 11 00 00       	call   4095 <exit>
  }

  fd = open(".", O_RDWR);
    2ef0:	83 ec 08             	sub    $0x8,%esp
    2ef3:	6a 02                	push   $0x2
    2ef5:	68 47 4e 00 00       	push   $0x4e47
    2efa:	e8 d6 11 00 00       	call   40d5 <open>
    2eff:	83 c4 10             	add    $0x10,%esp
    2f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2f09:	78 17                	js     2f22 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2f0b:	83 ec 08             	sub    $0x8,%esp
    2f0e:	68 a4 58 00 00       	push   $0x58a4
    2f13:	6a 01                	push   $0x1
    2f15:	e8 f7 12 00 00       	call   4211 <printf>
    2f1a:	83 c4 10             	add    $0x10,%esp
    exit();
    2f1d:	e8 73 11 00 00       	call   4095 <exit>
  }
  fd = open(".", 0);
    2f22:	83 ec 08             	sub    $0x8,%esp
    2f25:	6a 00                	push   $0x0
    2f27:	68 47 4e 00 00       	push   $0x4e47
    2f2c:	e8 a4 11 00 00       	call   40d5 <open>
    2f31:	83 c4 10             	add    $0x10,%esp
    2f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2f37:	83 ec 04             	sub    $0x4,%esp
    2f3a:	6a 01                	push   $0x1
    2f3c:	68 9f 4a 00 00       	push   $0x4a9f
    2f41:	ff 75 f4             	push   -0xc(%ebp)
    2f44:	e8 6c 11 00 00       	call   40b5 <write>
    2f49:	83 c4 10             	add    $0x10,%esp
    2f4c:	85 c0                	test   %eax,%eax
    2f4e:	7e 17                	jle    2f67 <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2f50:	83 ec 08             	sub    $0x8,%esp
    2f53:	68 c3 58 00 00       	push   $0x58c3
    2f58:	6a 01                	push   $0x1
    2f5a:	e8 b2 12 00 00       	call   4211 <printf>
    2f5f:	83 c4 10             	add    $0x10,%esp
    exit();
    2f62:	e8 2e 11 00 00       	call   4095 <exit>
  }
  close(fd);
    2f67:	83 ec 0c             	sub    $0xc,%esp
    2f6a:	ff 75 f4             	push   -0xc(%ebp)
    2f6d:	e8 4b 11 00 00       	call   40bd <close>
    2f72:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2f75:	83 ec 08             	sub    $0x8,%esp
    2f78:	68 d7 58 00 00       	push   $0x58d7
    2f7d:	6a 01                	push   $0x1
    2f7f:	e8 8d 12 00 00       	call   4211 <printf>
    2f84:	83 c4 10             	add    $0x10,%esp
}
    2f87:	90                   	nop
    2f88:	c9                   	leave  
    2f89:	c3                   	ret    

00002f8a <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f8a:	55                   	push   %ebp
    2f8b:	89 e5                	mov    %esp,%ebp
    2f8d:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2f90:	83 ec 08             	sub    $0x8,%esp
    2f93:	68 e7 58 00 00       	push   $0x58e7
    2f98:	6a 01                	push   $0x1
    2f9a:	e8 72 12 00 00       	call   4211 <printf>
    2f9f:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2fa9:	e9 e7 00 00 00       	jmp    3095 <iref+0x10b>
    if(mkdir("irefd") != 0){
    2fae:	83 ec 0c             	sub    $0xc,%esp
    2fb1:	68 f8 58 00 00       	push   $0x58f8
    2fb6:	e8 42 11 00 00       	call   40fd <mkdir>
    2fbb:	83 c4 10             	add    $0x10,%esp
    2fbe:	85 c0                	test   %eax,%eax
    2fc0:	74 17                	je     2fd9 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2fc2:	83 ec 08             	sub    $0x8,%esp
    2fc5:	68 fe 58 00 00       	push   $0x58fe
    2fca:	6a 01                	push   $0x1
    2fcc:	e8 40 12 00 00       	call   4211 <printf>
    2fd1:	83 c4 10             	add    $0x10,%esp
      exit();
    2fd4:	e8 bc 10 00 00       	call   4095 <exit>
    }
    if(chdir("irefd") != 0){
    2fd9:	83 ec 0c             	sub    $0xc,%esp
    2fdc:	68 f8 58 00 00       	push   $0x58f8
    2fe1:	e8 1f 11 00 00       	call   4105 <chdir>
    2fe6:	83 c4 10             	add    $0x10,%esp
    2fe9:	85 c0                	test   %eax,%eax
    2feb:	74 17                	je     3004 <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2fed:	83 ec 08             	sub    $0x8,%esp
    2ff0:	68 12 59 00 00       	push   $0x5912
    2ff5:	6a 01                	push   $0x1
    2ff7:	e8 15 12 00 00       	call   4211 <printf>
    2ffc:	83 c4 10             	add    $0x10,%esp
      exit();
    2fff:	e8 91 10 00 00       	call   4095 <exit>
    }

    mkdir("");
    3004:	83 ec 0c             	sub    $0xc,%esp
    3007:	68 26 59 00 00       	push   $0x5926
    300c:	e8 ec 10 00 00       	call   40fd <mkdir>
    3011:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    3014:	83 ec 08             	sub    $0x8,%esp
    3017:	68 26 59 00 00       	push   $0x5926
    301c:	68 65 58 00 00       	push   $0x5865
    3021:	e8 cf 10 00 00       	call   40f5 <link>
    3026:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    3029:	83 ec 08             	sub    $0x8,%esp
    302c:	68 00 02 00 00       	push   $0x200
    3031:	68 26 59 00 00       	push   $0x5926
    3036:	e8 9a 10 00 00       	call   40d5 <open>
    303b:	83 c4 10             	add    $0x10,%esp
    303e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3041:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3045:	78 0e                	js     3055 <iref+0xcb>
      close(fd);
    3047:	83 ec 0c             	sub    $0xc,%esp
    304a:	ff 75 f0             	push   -0x10(%ebp)
    304d:	e8 6b 10 00 00       	call   40bd <close>
    3052:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    3055:	83 ec 08             	sub    $0x8,%esp
    3058:	68 00 02 00 00       	push   $0x200
    305d:	68 27 59 00 00       	push   $0x5927
    3062:	e8 6e 10 00 00       	call   40d5 <open>
    3067:	83 c4 10             	add    $0x10,%esp
    306a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    306d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3071:	78 0e                	js     3081 <iref+0xf7>
      close(fd);
    3073:	83 ec 0c             	sub    $0xc,%esp
    3076:	ff 75 f0             	push   -0x10(%ebp)
    3079:	e8 3f 10 00 00       	call   40bd <close>
    307e:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    3081:	83 ec 0c             	sub    $0xc,%esp
    3084:	68 27 59 00 00       	push   $0x5927
    3089:	e8 57 10 00 00       	call   40e5 <unlink>
    308e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 50 + 1; i++){
    3091:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3095:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3099:	0f 8e 0f ff ff ff    	jle    2fae <iref+0x24>
  }

  chdir("/");
    309f:	83 ec 0c             	sub    $0xc,%esp
    30a2:	68 3a 46 00 00       	push   $0x463a
    30a7:	e8 59 10 00 00       	call   4105 <chdir>
    30ac:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    30af:	83 ec 08             	sub    $0x8,%esp
    30b2:	68 2a 59 00 00       	push   $0x592a
    30b7:	6a 01                	push   $0x1
    30b9:	e8 53 11 00 00       	call   4211 <printf>
    30be:	83 c4 10             	add    $0x10,%esp
}
    30c1:	90                   	nop
    30c2:	c9                   	leave  
    30c3:	c3                   	ret    

000030c4 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    30c4:	55                   	push   %ebp
    30c5:	89 e5                	mov    %esp,%ebp
    30c7:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    30ca:	83 ec 08             	sub    $0x8,%esp
    30cd:	68 3e 59 00 00       	push   $0x593e
    30d2:	6a 01                	push   $0x1
    30d4:	e8 38 11 00 00       	call   4211 <printf>
    30d9:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    30dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    30e3:	eb 1d                	jmp    3102 <forktest+0x3e>
    pid = fork();
    30e5:	e8 a3 0f 00 00       	call   408d <fork>
    30ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    30ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    30f1:	78 1a                	js     310d <forktest+0x49>
      break;
    if(pid == 0)
    30f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    30f7:	75 05                	jne    30fe <forktest+0x3a>
      exit();
    30f9:	e8 97 0f 00 00       	call   4095 <exit>
  for(n=0; n<1000; n++){
    30fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3102:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3109:	7e da                	jle    30e5 <forktest+0x21>
    310b:	eb 01                	jmp    310e <forktest+0x4a>
      break;
    310d:	90                   	nop
  }

  if(n == 1000){
    310e:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    3115:	75 3b                	jne    3152 <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    3117:	83 ec 08             	sub    $0x8,%esp
    311a:	68 4c 59 00 00       	push   $0x594c
    311f:	6a 01                	push   $0x1
    3121:	e8 eb 10 00 00       	call   4211 <printf>
    3126:	83 c4 10             	add    $0x10,%esp
    exit();
    3129:	e8 67 0f 00 00       	call   4095 <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
    312e:	e8 6a 0f 00 00       	call   409d <wait>
    3133:	85 c0                	test   %eax,%eax
    3135:	79 17                	jns    314e <forktest+0x8a>
      printf(1, "wait stopped early\n");
    3137:	83 ec 08             	sub    $0x8,%esp
    313a:	68 6e 59 00 00       	push   $0x596e
    313f:	6a 01                	push   $0x1
    3141:	e8 cb 10 00 00       	call   4211 <printf>
    3146:	83 c4 10             	add    $0x10,%esp
      exit();
    3149:	e8 47 0f 00 00       	call   4095 <exit>
  for(; n > 0; n--){
    314e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    3152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3156:	7f d6                	jg     312e <forktest+0x6a>
    }
  }

  if(wait() != -1){
    3158:	e8 40 0f 00 00       	call   409d <wait>
    315d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3160:	74 17                	je     3179 <forktest+0xb5>
    printf(1, "wait got too many\n");
    3162:	83 ec 08             	sub    $0x8,%esp
    3165:	68 82 59 00 00       	push   $0x5982
    316a:	6a 01                	push   $0x1
    316c:	e8 a0 10 00 00       	call   4211 <printf>
    3171:	83 c4 10             	add    $0x10,%esp
    exit();
    3174:	e8 1c 0f 00 00       	call   4095 <exit>
  }

  printf(1, "fork test OK\n");
    3179:	83 ec 08             	sub    $0x8,%esp
    317c:	68 95 59 00 00       	push   $0x5995
    3181:	6a 01                	push   $0x1
    3183:	e8 89 10 00 00       	call   4211 <printf>
    3188:	83 c4 10             	add    $0x10,%esp
}
    318b:	90                   	nop
    318c:	c9                   	leave  
    318d:	c3                   	ret    

0000318e <sbrktest>:

void
sbrktest(void)
{
    318e:	55                   	push   %ebp
    318f:	89 e5                	mov    %esp,%ebp
    3191:	83 ec 68             	sub    $0x68,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3194:	a1 14 65 00 00       	mov    0x6514,%eax
    3199:	83 ec 08             	sub    $0x8,%esp
    319c:	68 a3 59 00 00       	push   $0x59a3
    31a1:	50                   	push   %eax
    31a2:	e8 6a 10 00 00       	call   4211 <printf>
    31a7:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    31aa:	83 ec 0c             	sub    $0xc,%esp
    31ad:	6a 00                	push   $0x0
    31af:	e8 69 0f 00 00       	call   411d <sbrk>
    31b4:	83 c4 10             	add    $0x10,%esp
    31b7:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    31ba:	83 ec 0c             	sub    $0xc,%esp
    31bd:	6a 00                	push   $0x0
    31bf:	e8 59 0f 00 00       	call   411d <sbrk>
    31c4:	83 c4 10             	add    $0x10,%esp
    31c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
    31ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    31d1:	eb 4f                	jmp    3222 <sbrktest+0x94>
    b = sbrk(1);
    31d3:	83 ec 0c             	sub    $0xc,%esp
    31d6:	6a 01                	push   $0x1
    31d8:	e8 40 0f 00 00       	call   411d <sbrk>
    31dd:	83 c4 10             	add    $0x10,%esp
    31e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(b != a){
    31e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
    31e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    31e9:	74 24                	je     320f <sbrktest+0x81>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    31eb:	a1 14 65 00 00       	mov    0x6514,%eax
    31f0:	83 ec 0c             	sub    $0xc,%esp
    31f3:	ff 75 d0             	push   -0x30(%ebp)
    31f6:	ff 75 f4             	push   -0xc(%ebp)
    31f9:	ff 75 f0             	push   -0x10(%ebp)
    31fc:	68 ae 59 00 00       	push   $0x59ae
    3201:	50                   	push   %eax
    3202:	e8 0a 10 00 00       	call   4211 <printf>
    3207:	83 c4 20             	add    $0x20,%esp
      exit();
    320a:	e8 86 0e 00 00       	call   4095 <exit>
    }
    *b = 1;
    320f:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3212:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3215:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3218:	83 c0 01             	add    $0x1,%eax
    321b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){
    321e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3222:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3229:	7e a8                	jle    31d3 <sbrktest+0x45>
  }
  pid = fork();
    322b:	e8 5d 0e 00 00       	call   408d <fork>
    3230:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    3233:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3237:	79 1b                	jns    3254 <sbrktest+0xc6>
    printf(stdout, "sbrk test fork failed\n");
    3239:	a1 14 65 00 00       	mov    0x6514,%eax
    323e:	83 ec 08             	sub    $0x8,%esp
    3241:	68 c9 59 00 00       	push   $0x59c9
    3246:	50                   	push   %eax
    3247:	e8 c5 0f 00 00       	call   4211 <printf>
    324c:	83 c4 10             	add    $0x10,%esp
    exit();
    324f:	e8 41 0e 00 00       	call   4095 <exit>
  }
  c = sbrk(1);
    3254:	83 ec 0c             	sub    $0xc,%esp
    3257:	6a 01                	push   $0x1
    3259:	e8 bf 0e 00 00       	call   411d <sbrk>
    325e:	83 c4 10             	add    $0x10,%esp
    3261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c = sbrk(1);
    3264:	83 ec 0c             	sub    $0xc,%esp
    3267:	6a 01                	push   $0x1
    3269:	e8 af 0e 00 00       	call   411d <sbrk>
    326e:	83 c4 10             	add    $0x10,%esp
    3271:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a + 1){
    3274:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3277:	83 c0 01             	add    $0x1,%eax
    327a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    327d:	74 1b                	je     329a <sbrktest+0x10c>
    printf(stdout, "sbrk test failed post-fork\n");
    327f:	a1 14 65 00 00       	mov    0x6514,%eax
    3284:	83 ec 08             	sub    $0x8,%esp
    3287:	68 e0 59 00 00       	push   $0x59e0
    328c:	50                   	push   %eax
    328d:	e8 7f 0f 00 00       	call   4211 <printf>
    3292:	83 c4 10             	add    $0x10,%esp
    exit();
    3295:	e8 fb 0d 00 00       	call   4095 <exit>
  }
  if(pid == 0)
    329a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    329e:	75 05                	jne    32a5 <sbrktest+0x117>
    exit();
    32a0:	e8 f0 0d 00 00       	call   4095 <exit>
  wait();
    32a5:	e8 f3 0d 00 00       	call   409d <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    32aa:	83 ec 0c             	sub    $0xc,%esp
    32ad:	6a 00                	push   $0x0
    32af:	e8 69 0e 00 00       	call   411d <sbrk>
    32b4:	83 c4 10             	add    $0x10,%esp
    32b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    32ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32bd:	b8 00 00 40 06       	mov    $0x6400000,%eax
    32c2:	29 d0                	sub    %edx,%eax
    32c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  p = sbrk(amt);
    32c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    32ca:	83 ec 0c             	sub    $0xc,%esp
    32cd:	50                   	push   %eax
    32ce:	e8 4a 0e 00 00       	call   411d <sbrk>
    32d3:	83 c4 10             	add    $0x10,%esp
    32d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (p != a) {
    32d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    32dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    32df:	74 1b                	je     32fc <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    32e1:	a1 14 65 00 00       	mov    0x6514,%eax
    32e6:	83 ec 08             	sub    $0x8,%esp
    32e9:	68 fc 59 00 00       	push   $0x59fc
    32ee:	50                   	push   %eax
    32ef:	e8 1d 0f 00 00       	call   4211 <printf>
    32f4:	83 c4 10             	add    $0x10,%esp
    exit();
    32f7:	e8 99 0d 00 00       	call   4095 <exit>
  }
  lastaddr = (char*) (BIG-1);
    32fc:	c7 45 d8 ff ff 3f 06 	movl   $0x63fffff,-0x28(%ebp)
  *lastaddr = 99;
    3303:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3306:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3309:	83 ec 0c             	sub    $0xc,%esp
    330c:	6a 00                	push   $0x0
    330e:	e8 0a 0e 00 00       	call   411d <sbrk>
    3313:	83 c4 10             	add    $0x10,%esp
    3316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3319:	83 ec 0c             	sub    $0xc,%esp
    331c:	68 00 f0 ff ff       	push   $0xfffff000
    3321:	e8 f7 0d 00 00       	call   411d <sbrk>
    3326:	83 c4 10             	add    $0x10,%esp
    3329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c == (char*)0xffffffff){
    332c:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    3330:	75 1b                	jne    334d <sbrktest+0x1bf>
    printf(stdout, "sbrk could not deallocate\n");
    3332:	a1 14 65 00 00       	mov    0x6514,%eax
    3337:	83 ec 08             	sub    $0x8,%esp
    333a:	68 3a 5a 00 00       	push   $0x5a3a
    333f:	50                   	push   %eax
    3340:	e8 cc 0e 00 00       	call   4211 <printf>
    3345:	83 c4 10             	add    $0x10,%esp
    exit();
    3348:	e8 48 0d 00 00       	call   4095 <exit>
  }
  c = sbrk(0);
    334d:	83 ec 0c             	sub    $0xc,%esp
    3350:	6a 00                	push   $0x0
    3352:	e8 c6 0d 00 00       	call   411d <sbrk>
    3357:	83 c4 10             	add    $0x10,%esp
    335a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a - 4096){
    335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3360:	2d 00 10 00 00       	sub    $0x1000,%eax
    3365:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    3368:	74 1e                	je     3388 <sbrktest+0x1fa>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    336a:	a1 14 65 00 00       	mov    0x6514,%eax
    336f:	ff 75 e4             	push   -0x1c(%ebp)
    3372:	ff 75 f4             	push   -0xc(%ebp)
    3375:	68 58 5a 00 00       	push   $0x5a58
    337a:	50                   	push   %eax
    337b:	e8 91 0e 00 00       	call   4211 <printf>
    3380:	83 c4 10             	add    $0x10,%esp
    exit();
    3383:	e8 0d 0d 00 00       	call   4095 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3388:	83 ec 0c             	sub    $0xc,%esp
    338b:	6a 00                	push   $0x0
    338d:	e8 8b 0d 00 00       	call   411d <sbrk>
    3392:	83 c4 10             	add    $0x10,%esp
    3395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3398:	83 ec 0c             	sub    $0xc,%esp
    339b:	68 00 10 00 00       	push   $0x1000
    33a0:	e8 78 0d 00 00       	call   411d <sbrk>
    33a5:	83 c4 10             	add    $0x10,%esp
    33a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    33ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    33ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33b1:	75 1a                	jne    33cd <sbrktest+0x23f>
    33b3:	83 ec 0c             	sub    $0xc,%esp
    33b6:	6a 00                	push   $0x0
    33b8:	e8 60 0d 00 00       	call   411d <sbrk>
    33bd:	83 c4 10             	add    $0x10,%esp
    33c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33c3:	81 c2 00 10 00 00    	add    $0x1000,%edx
    33c9:	39 d0                	cmp    %edx,%eax
    33cb:	74 1e                	je     33eb <sbrktest+0x25d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    33cd:	a1 14 65 00 00       	mov    0x6514,%eax
    33d2:	ff 75 e4             	push   -0x1c(%ebp)
    33d5:	ff 75 f4             	push   -0xc(%ebp)
    33d8:	68 90 5a 00 00       	push   $0x5a90
    33dd:	50                   	push   %eax
    33de:	e8 2e 0e 00 00       	call   4211 <printf>
    33e3:	83 c4 10             	add    $0x10,%esp
    exit();
    33e6:	e8 aa 0c 00 00       	call   4095 <exit>
  }
  if(*lastaddr == 99){
    33eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
    33ee:	0f b6 00             	movzbl (%eax),%eax
    33f1:	3c 63                	cmp    $0x63,%al
    33f3:	75 1b                	jne    3410 <sbrktest+0x282>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    33f5:	a1 14 65 00 00       	mov    0x6514,%eax
    33fa:	83 ec 08             	sub    $0x8,%esp
    33fd:	68 b8 5a 00 00       	push   $0x5ab8
    3402:	50                   	push   %eax
    3403:	e8 09 0e 00 00       	call   4211 <printf>
    3408:	83 c4 10             	add    $0x10,%esp
    exit();
    340b:	e8 85 0c 00 00       	call   4095 <exit>
  }

  a = sbrk(0);
    3410:	83 ec 0c             	sub    $0xc,%esp
    3413:	6a 00                	push   $0x0
    3415:	e8 03 0d 00 00       	call   411d <sbrk>
    341a:	83 c4 10             	add    $0x10,%esp
    341d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3420:	83 ec 0c             	sub    $0xc,%esp
    3423:	6a 00                	push   $0x0
    3425:	e8 f3 0c 00 00       	call   411d <sbrk>
    342a:	83 c4 10             	add    $0x10,%esp
    342d:	89 c2                	mov    %eax,%edx
    342f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3432:	29 d0                	sub    %edx,%eax
    3434:	83 ec 0c             	sub    $0xc,%esp
    3437:	50                   	push   %eax
    3438:	e8 e0 0c 00 00       	call   411d <sbrk>
    343d:	83 c4 10             	add    $0x10,%esp
    3440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a){
    3443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3446:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3449:	74 1e                	je     3469 <sbrktest+0x2db>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    344b:	a1 14 65 00 00       	mov    0x6514,%eax
    3450:	ff 75 e4             	push   -0x1c(%ebp)
    3453:	ff 75 f4             	push   -0xc(%ebp)
    3456:	68 e8 5a 00 00       	push   $0x5ae8
    345b:	50                   	push   %eax
    345c:	e8 b0 0d 00 00       	call   4211 <printf>
    3461:	83 c4 10             	add    $0x10,%esp
    exit();
    3464:	e8 2c 0c 00 00       	call   4095 <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3469:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3470:	eb 76                	jmp    34e8 <sbrktest+0x35a>
    ppid = getpid();
    3472:	e8 9e 0c 00 00       	call   4115 <getpid>
    3477:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    pid = fork();
    347a:	e8 0e 0c 00 00       	call   408d <fork>
    347f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    3482:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3486:	79 1b                	jns    34a3 <sbrktest+0x315>
      printf(stdout, "fork failed\n");
    3488:	a1 14 65 00 00       	mov    0x6514,%eax
    348d:	83 ec 08             	sub    $0x8,%esp
    3490:	68 69 46 00 00       	push   $0x4669
    3495:	50                   	push   %eax
    3496:	e8 76 0d 00 00       	call   4211 <printf>
    349b:	83 c4 10             	add    $0x10,%esp
      exit();
    349e:	e8 f2 0b 00 00       	call   4095 <exit>
    }
    if(pid == 0){
    34a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    34a7:	75 33                	jne    34dc <sbrktest+0x34e>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    34a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34ac:	0f b6 00             	movzbl (%eax),%eax
    34af:	0f be d0             	movsbl %al,%edx
    34b2:	a1 14 65 00 00       	mov    0x6514,%eax
    34b7:	52                   	push   %edx
    34b8:	ff 75 f4             	push   -0xc(%ebp)
    34bb:	68 09 5b 00 00       	push   $0x5b09
    34c0:	50                   	push   %eax
    34c1:	e8 4b 0d 00 00       	call   4211 <printf>
    34c6:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    34c9:	83 ec 0c             	sub    $0xc,%esp
    34cc:	ff 75 d4             	push   -0x2c(%ebp)
    34cf:	e8 f1 0b 00 00       	call   40c5 <kill>
    34d4:	83 c4 10             	add    $0x10,%esp
      exit();
    34d7:	e8 b9 0b 00 00       	call   4095 <exit>
    }
    wait();
    34dc:	e8 bc 0b 00 00       	call   409d <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34e1:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    34e8:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    34ef:	76 81                	jbe    3472 <sbrktest+0x2e4>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    34f1:	83 ec 0c             	sub    $0xc,%esp
    34f4:	8d 45 c8             	lea    -0x38(%ebp),%eax
    34f7:	50                   	push   %eax
    34f8:	e8 a8 0b 00 00       	call   40a5 <pipe>
    34fd:	83 c4 10             	add    $0x10,%esp
    3500:	85 c0                	test   %eax,%eax
    3502:	74 17                	je     351b <sbrktest+0x38d>
    printf(1, "pipe() failed\n");
    3504:	83 ec 08             	sub    $0x8,%esp
    3507:	68 3a 4a 00 00       	push   $0x4a3a
    350c:	6a 01                	push   $0x1
    350e:	e8 fe 0c 00 00       	call   4211 <printf>
    3513:	83 c4 10             	add    $0x10,%esp
    exit();
    3516:	e8 7a 0b 00 00       	call   4095 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    351b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3522:	e9 86 00 00 00       	jmp    35ad <sbrktest+0x41f>
    if((pids[i] = fork()) == 0){
    3527:	e8 61 0b 00 00       	call   408d <fork>
    352c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    352f:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    3533:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3536:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    353a:	85 c0                	test   %eax,%eax
    353c:	75 4a                	jne    3588 <sbrktest+0x3fa>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    353e:	83 ec 0c             	sub    $0xc,%esp
    3541:	6a 00                	push   $0x0
    3543:	e8 d5 0b 00 00       	call   411d <sbrk>
    3548:	83 c4 10             	add    $0x10,%esp
    354b:	89 c2                	mov    %eax,%edx
    354d:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3552:	29 d0                	sub    %edx,%eax
    3554:	83 ec 0c             	sub    $0xc,%esp
    3557:	50                   	push   %eax
    3558:	e8 c0 0b 00 00       	call   411d <sbrk>
    355d:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    3560:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3563:	83 ec 04             	sub    $0x4,%esp
    3566:	6a 01                	push   $0x1
    3568:	68 9f 4a 00 00       	push   $0x4a9f
    356d:	50                   	push   %eax
    356e:	e8 42 0b 00 00       	call   40b5 <write>
    3573:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    3576:	83 ec 0c             	sub    $0xc,%esp
    3579:	68 e8 03 00 00       	push   $0x3e8
    357e:	e8 a2 0b 00 00       	call   4125 <sleep>
    3583:	83 c4 10             	add    $0x10,%esp
    3586:	eb ee                	jmp    3576 <sbrktest+0x3e8>
    }
    if(pids[i] != -1)
    3588:	8b 45 f0             	mov    -0x10(%ebp),%eax
    358b:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    358f:	83 f8 ff             	cmp    $0xffffffff,%eax
    3592:	74 15                	je     35a9 <sbrktest+0x41b>
      read(fds[0], &scratch, 1);
    3594:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3597:	83 ec 04             	sub    $0x4,%esp
    359a:	6a 01                	push   $0x1
    359c:	8d 55 9f             	lea    -0x61(%ebp),%edx
    359f:	52                   	push   %edx
    35a0:	50                   	push   %eax
    35a1:	e8 07 0b 00 00       	call   40ad <read>
    35a6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    35a9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    35ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35b0:	83 f8 09             	cmp    $0x9,%eax
    35b3:	0f 86 6e ff ff ff    	jbe    3527 <sbrktest+0x399>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    35b9:	83 ec 0c             	sub    $0xc,%esp
    35bc:	68 00 10 00 00       	push   $0x1000
    35c1:	e8 57 0b 00 00       	call   411d <sbrk>
    35c6:	83 c4 10             	add    $0x10,%esp
    35c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    35cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    35d3:	eb 2b                	jmp    3600 <sbrktest+0x472>
    if(pids[i] == -1)
    35d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35d8:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    35dc:	83 f8 ff             	cmp    $0xffffffff,%eax
    35df:	74 1a                	je     35fb <sbrktest+0x46d>
      continue;
    kill(pids[i]);
    35e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35e4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    35e8:	83 ec 0c             	sub    $0xc,%esp
    35eb:	50                   	push   %eax
    35ec:	e8 d4 0a 00 00       	call   40c5 <kill>
    35f1:	83 c4 10             	add    $0x10,%esp
    wait();
    35f4:	e8 a4 0a 00 00       	call   409d <wait>
    35f9:	eb 01                	jmp    35fc <sbrktest+0x46e>
      continue;
    35fb:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    35fc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3600:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3603:	83 f8 09             	cmp    $0x9,%eax
    3606:	76 cd                	jbe    35d5 <sbrktest+0x447>
  }
  if(c == (char*)0xffffffff){
    3608:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    360c:	75 1b                	jne    3629 <sbrktest+0x49b>
    printf(stdout, "failed sbrk leaked memory\n");
    360e:	a1 14 65 00 00       	mov    0x6514,%eax
    3613:	83 ec 08             	sub    $0x8,%esp
    3616:	68 22 5b 00 00       	push   $0x5b22
    361b:	50                   	push   %eax
    361c:	e8 f0 0b 00 00       	call   4211 <printf>
    3621:	83 c4 10             	add    $0x10,%esp
    exit();
    3624:	e8 6c 0a 00 00       	call   4095 <exit>
  }

  if(sbrk(0) > oldbrk)
    3629:	83 ec 0c             	sub    $0xc,%esp
    362c:	6a 00                	push   $0x0
    362e:	e8 ea 0a 00 00       	call   411d <sbrk>
    3633:	83 c4 10             	add    $0x10,%esp
    3636:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    3639:	73 20                	jae    365b <sbrktest+0x4cd>
    sbrk(-(sbrk(0) - oldbrk));
    363b:	83 ec 0c             	sub    $0xc,%esp
    363e:	6a 00                	push   $0x0
    3640:	e8 d8 0a 00 00       	call   411d <sbrk>
    3645:	83 c4 10             	add    $0x10,%esp
    3648:	89 c2                	mov    %eax,%edx
    364a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    364d:	29 d0                	sub    %edx,%eax
    364f:	83 ec 0c             	sub    $0xc,%esp
    3652:	50                   	push   %eax
    3653:	e8 c5 0a 00 00       	call   411d <sbrk>
    3658:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    365b:	a1 14 65 00 00       	mov    0x6514,%eax
    3660:	83 ec 08             	sub    $0x8,%esp
    3663:	68 3d 5b 00 00       	push   $0x5b3d
    3668:	50                   	push   %eax
    3669:	e8 a3 0b 00 00       	call   4211 <printf>
    366e:	83 c4 10             	add    $0x10,%esp
}
    3671:	90                   	nop
    3672:	c9                   	leave  
    3673:	c3                   	ret    

00003674 <validateint>:

void
validateint(int *p)
{
    3674:	55                   	push   %ebp
    3675:	89 e5                	mov    %esp,%ebp
    3677:	53                   	push   %ebx
    3678:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    367b:	b8 0d 00 00 00       	mov    $0xd,%eax
    3680:	8b 55 08             	mov    0x8(%ebp),%edx
    3683:	89 d1                	mov    %edx,%ecx
    3685:	89 e3                	mov    %esp,%ebx
    3687:	89 cc                	mov    %ecx,%esp
    3689:	cd 40                	int    $0x40
    368b:	89 dc                	mov    %ebx,%esp
    368d:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3690:	90                   	nop
    3691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3694:	c9                   	leave  
    3695:	c3                   	ret    

00003696 <validatetest>:

void
validatetest(void)
{
    3696:	55                   	push   %ebp
    3697:	89 e5                	mov    %esp,%ebp
    3699:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    369c:	a1 14 65 00 00       	mov    0x6514,%eax
    36a1:	83 ec 08             	sub    $0x8,%esp
    36a4:	68 4b 5b 00 00       	push   $0x5b4b
    36a9:	50                   	push   %eax
    36aa:	e8 62 0b 00 00       	call   4211 <printf>
    36af:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    36b2:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    36b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    36c0:	e9 8a 00 00 00       	jmp    374f <validatetest+0xb9>
    if((pid = fork()) == 0){
    36c5:	e8 c3 09 00 00       	call   408d <fork>
    36ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    36cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    36d1:	75 14                	jne    36e7 <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    36d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36d6:	83 ec 0c             	sub    $0xc,%esp
    36d9:	50                   	push   %eax
    36da:	e8 95 ff ff ff       	call   3674 <validateint>
    36df:	83 c4 10             	add    $0x10,%esp
      exit();
    36e2:	e8 ae 09 00 00       	call   4095 <exit>
    }
    sleep(0);
    36e7:	83 ec 0c             	sub    $0xc,%esp
    36ea:	6a 00                	push   $0x0
    36ec:	e8 34 0a 00 00       	call   4125 <sleep>
    36f1:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    36f4:	83 ec 0c             	sub    $0xc,%esp
    36f7:	6a 00                	push   $0x0
    36f9:	e8 27 0a 00 00       	call   4125 <sleep>
    36fe:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    3701:	83 ec 0c             	sub    $0xc,%esp
    3704:	ff 75 ec             	push   -0x14(%ebp)
    3707:	e8 b9 09 00 00       	call   40c5 <kill>
    370c:	83 c4 10             	add    $0x10,%esp
    wait();
    370f:	e8 89 09 00 00       	call   409d <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3714:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3717:	83 ec 08             	sub    $0x8,%esp
    371a:	50                   	push   %eax
    371b:	68 5a 5b 00 00       	push   $0x5b5a
    3720:	e8 d0 09 00 00       	call   40f5 <link>
    3725:	83 c4 10             	add    $0x10,%esp
    3728:	83 f8 ff             	cmp    $0xffffffff,%eax
    372b:	74 1b                	je     3748 <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    372d:	a1 14 65 00 00       	mov    0x6514,%eax
    3732:	83 ec 08             	sub    $0x8,%esp
    3735:	68 65 5b 00 00       	push   $0x5b65
    373a:	50                   	push   %eax
    373b:	e8 d1 0a 00 00       	call   4211 <printf>
    3740:	83 c4 10             	add    $0x10,%esp
      exit();
    3743:	e8 4d 09 00 00       	call   4095 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    3748:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3752:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    3755:	0f 86 6a ff ff ff    	jbe    36c5 <validatetest+0x2f>
    }
  }

  printf(stdout, "validate ok\n");
    375b:	a1 14 65 00 00       	mov    0x6514,%eax
    3760:	83 ec 08             	sub    $0x8,%esp
    3763:	68 7e 5b 00 00       	push   $0x5b7e
    3768:	50                   	push   %eax
    3769:	e8 a3 0a 00 00       	call   4211 <printf>
    376e:	83 c4 10             	add    $0x10,%esp
}
    3771:	90                   	nop
    3772:	c9                   	leave  
    3773:	c3                   	ret    

00003774 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3774:	55                   	push   %ebp
    3775:	89 e5                	mov    %esp,%ebp
    3777:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    377a:	a1 14 65 00 00       	mov    0x6514,%eax
    377f:	83 ec 08             	sub    $0x8,%esp
    3782:	68 8b 5b 00 00       	push   $0x5b8b
    3787:	50                   	push   %eax
    3788:	e8 84 0a 00 00       	call   4211 <printf>
    378d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    3790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3797:	eb 2e                	jmp    37c7 <bsstest+0x53>
    if(uninit[i] != '\0'){
    3799:	8b 45 f4             	mov    -0xc(%ebp),%eax
    379c:	05 60 85 00 00       	add    $0x8560,%eax
    37a1:	0f b6 00             	movzbl (%eax),%eax
    37a4:	84 c0                	test   %al,%al
    37a6:	74 1b                	je     37c3 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    37a8:	a1 14 65 00 00       	mov    0x6514,%eax
    37ad:	83 ec 08             	sub    $0x8,%esp
    37b0:	68 95 5b 00 00       	push   $0x5b95
    37b5:	50                   	push   %eax
    37b6:	e8 56 0a 00 00       	call   4211 <printf>
    37bb:	83 c4 10             	add    $0x10,%esp
      exit();
    37be:	e8 d2 08 00 00       	call   4095 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    37c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37ca:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    37cf:	76 c8                	jbe    3799 <bsstest+0x25>
    }
  }
  printf(stdout, "bss test ok\n");
    37d1:	a1 14 65 00 00       	mov    0x6514,%eax
    37d6:	83 ec 08             	sub    $0x8,%esp
    37d9:	68 a6 5b 00 00       	push   $0x5ba6
    37de:	50                   	push   %eax
    37df:	e8 2d 0a 00 00       	call   4211 <printf>
    37e4:	83 c4 10             	add    $0x10,%esp
}
    37e7:	90                   	nop
    37e8:	c9                   	leave  
    37e9:	c3                   	ret    

000037ea <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    37ea:	55                   	push   %ebp
    37eb:	89 e5                	mov    %esp,%ebp
    37ed:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    37f0:	83 ec 0c             	sub    $0xc,%esp
    37f3:	68 b3 5b 00 00       	push   $0x5bb3
    37f8:	e8 e8 08 00 00       	call   40e5 <unlink>
    37fd:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3800:	e8 88 08 00 00       	call   408d <fork>
    3805:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3808:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    380c:	0f 85 97 00 00 00    	jne    38a9 <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3819:	eb 12                	jmp    382d <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    381e:	c7 04 85 80 ac 00 00 	movl   $0x5bc0,0xac80(,%eax,4)
    3825:	c0 5b 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3829:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    382d:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3831:	7e e8                	jle    381b <bigargtest+0x31>
    args[MAXARG-1] = 0;
    3833:	c7 05 fc ac 00 00 00 	movl   $0x0,0xacfc
    383a:	00 00 00 
    printf(stdout, "bigarg test\n");
    383d:	a1 14 65 00 00       	mov    0x6514,%eax
    3842:	83 ec 08             	sub    $0x8,%esp
    3845:	68 9d 5c 00 00       	push   $0x5c9d
    384a:	50                   	push   %eax
    384b:	e8 c1 09 00 00       	call   4211 <printf>
    3850:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    3853:	83 ec 08             	sub    $0x8,%esp
    3856:	68 80 ac 00 00       	push   $0xac80
    385b:	68 c8 45 00 00       	push   $0x45c8
    3860:	e8 68 08 00 00       	call   40cd <exec>
    3865:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    3868:	a1 14 65 00 00       	mov    0x6514,%eax
    386d:	83 ec 08             	sub    $0x8,%esp
    3870:	68 aa 5c 00 00       	push   $0x5caa
    3875:	50                   	push   %eax
    3876:	e8 96 09 00 00       	call   4211 <printf>
    387b:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    387e:	83 ec 08             	sub    $0x8,%esp
    3881:	68 00 02 00 00       	push   $0x200
    3886:	68 b3 5b 00 00       	push   $0x5bb3
    388b:	e8 45 08 00 00       	call   40d5 <open>
    3890:	83 c4 10             	add    $0x10,%esp
    3893:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3896:	83 ec 0c             	sub    $0xc,%esp
    3899:	ff 75 ec             	push   -0x14(%ebp)
    389c:	e8 1c 08 00 00       	call   40bd <close>
    38a1:	83 c4 10             	add    $0x10,%esp
    exit();
    38a4:	e8 ec 07 00 00       	call   4095 <exit>
  } else if(pid < 0){
    38a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    38ad:	79 1b                	jns    38ca <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    38af:	a1 14 65 00 00       	mov    0x6514,%eax
    38b4:	83 ec 08             	sub    $0x8,%esp
    38b7:	68 ba 5c 00 00       	push   $0x5cba
    38bc:	50                   	push   %eax
    38bd:	e8 4f 09 00 00       	call   4211 <printf>
    38c2:	83 c4 10             	add    $0x10,%esp
    exit();
    38c5:	e8 cb 07 00 00       	call   4095 <exit>
  }
  wait();
    38ca:	e8 ce 07 00 00       	call   409d <wait>
  fd = open("bigarg-ok", 0);
    38cf:	83 ec 08             	sub    $0x8,%esp
    38d2:	6a 00                	push   $0x0
    38d4:	68 b3 5b 00 00       	push   $0x5bb3
    38d9:	e8 f7 07 00 00       	call   40d5 <open>
    38de:	83 c4 10             	add    $0x10,%esp
    38e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    38e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    38e8:	79 1b                	jns    3905 <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    38ea:	a1 14 65 00 00       	mov    0x6514,%eax
    38ef:	83 ec 08             	sub    $0x8,%esp
    38f2:	68 d3 5c 00 00       	push   $0x5cd3
    38f7:	50                   	push   %eax
    38f8:	e8 14 09 00 00       	call   4211 <printf>
    38fd:	83 c4 10             	add    $0x10,%esp
    exit();
    3900:	e8 90 07 00 00       	call   4095 <exit>
  }
  close(fd);
    3905:	83 ec 0c             	sub    $0xc,%esp
    3908:	ff 75 ec             	push   -0x14(%ebp)
    390b:	e8 ad 07 00 00       	call   40bd <close>
    3910:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3913:	83 ec 0c             	sub    $0xc,%esp
    3916:	68 b3 5b 00 00       	push   $0x5bb3
    391b:	e8 c5 07 00 00       	call   40e5 <unlink>
    3920:	83 c4 10             	add    $0x10,%esp
}
    3923:	90                   	nop
    3924:	c9                   	leave  
    3925:	c3                   	ret    

00003926 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3926:	55                   	push   %ebp
    3927:	89 e5                	mov    %esp,%ebp
    3929:	53                   	push   %ebx
    392a:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    392d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    3934:	83 ec 08             	sub    $0x8,%esp
    3937:	68 e8 5c 00 00       	push   $0x5ce8
    393c:	6a 01                	push   $0x1
    393e:	e8 ce 08 00 00       	call   4211 <printf>
    3943:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    394d:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3951:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3954:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3959:	89 c8                	mov    %ecx,%eax
    395b:	f7 ea                	imul   %edx
    395d:	89 d0                	mov    %edx,%eax
    395f:	c1 f8 06             	sar    $0x6,%eax
    3962:	c1 f9 1f             	sar    $0x1f,%ecx
    3965:	89 ca                	mov    %ecx,%edx
    3967:	29 d0                	sub    %edx,%eax
    3969:	83 c0 30             	add    $0x30,%eax
    396c:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    396f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3972:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3977:	89 d8                	mov    %ebx,%eax
    3979:	f7 ea                	imul   %edx
    397b:	89 d0                	mov    %edx,%eax
    397d:	c1 f8 06             	sar    $0x6,%eax
    3980:	89 da                	mov    %ebx,%edx
    3982:	c1 fa 1f             	sar    $0x1f,%edx
    3985:	29 d0                	sub    %edx,%eax
    3987:	89 c1                	mov    %eax,%ecx
    3989:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    398f:	29 c3                	sub    %eax,%ebx
    3991:	89 d9                	mov    %ebx,%ecx
    3993:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3998:	89 c8                	mov    %ecx,%eax
    399a:	f7 ea                	imul   %edx
    399c:	89 d0                	mov    %edx,%eax
    399e:	c1 f8 05             	sar    $0x5,%eax
    39a1:	c1 f9 1f             	sar    $0x1f,%ecx
    39a4:	89 ca                	mov    %ecx,%edx
    39a6:	29 d0                	sub    %edx,%eax
    39a8:	83 c0 30             	add    $0x30,%eax
    39ab:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    39ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    39b1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    39b6:	89 d8                	mov    %ebx,%eax
    39b8:	f7 ea                	imul   %edx
    39ba:	89 d0                	mov    %edx,%eax
    39bc:	c1 f8 05             	sar    $0x5,%eax
    39bf:	89 da                	mov    %ebx,%edx
    39c1:	c1 fa 1f             	sar    $0x1f,%edx
    39c4:	29 d0                	sub    %edx,%eax
    39c6:	89 c1                	mov    %eax,%ecx
    39c8:	6b c1 64             	imul   $0x64,%ecx,%eax
    39cb:	29 c3                	sub    %eax,%ebx
    39cd:	89 d9                	mov    %ebx,%ecx
    39cf:	ba 67 66 66 66       	mov    $0x66666667,%edx
    39d4:	89 c8                	mov    %ecx,%eax
    39d6:	f7 ea                	imul   %edx
    39d8:	89 d0                	mov    %edx,%eax
    39da:	c1 f8 02             	sar    $0x2,%eax
    39dd:	c1 f9 1f             	sar    $0x1f,%ecx
    39e0:	89 ca                	mov    %ecx,%edx
    39e2:	29 d0                	sub    %edx,%eax
    39e4:	83 c0 30             	add    $0x30,%eax
    39e7:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    39ea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    39ed:	ba 67 66 66 66       	mov    $0x66666667,%edx
    39f2:	89 c8                	mov    %ecx,%eax
    39f4:	f7 ea                	imul   %edx
    39f6:	89 d0                	mov    %edx,%eax
    39f8:	c1 f8 02             	sar    $0x2,%eax
    39fb:	89 cb                	mov    %ecx,%ebx
    39fd:	c1 fb 1f             	sar    $0x1f,%ebx
    3a00:	29 d8                	sub    %ebx,%eax
    3a02:	89 c2                	mov    %eax,%edx
    3a04:	89 d0                	mov    %edx,%eax
    3a06:	c1 e0 02             	shl    $0x2,%eax
    3a09:	01 d0                	add    %edx,%eax
    3a0b:	01 c0                	add    %eax,%eax
    3a0d:	29 c1                	sub    %eax,%ecx
    3a0f:	89 ca                	mov    %ecx,%edx
    3a11:	89 d0                	mov    %edx,%eax
    3a13:	83 c0 30             	add    $0x30,%eax
    3a16:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3a19:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3a1d:	83 ec 04             	sub    $0x4,%esp
    3a20:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a23:	50                   	push   %eax
    3a24:	68 f5 5c 00 00       	push   $0x5cf5
    3a29:	6a 01                	push   $0x1
    3a2b:	e8 e1 07 00 00       	call   4211 <printf>
    3a30:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3a33:	83 ec 08             	sub    $0x8,%esp
    3a36:	68 02 02 00 00       	push   $0x202
    3a3b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a3e:	50                   	push   %eax
    3a3f:	e8 91 06 00 00       	call   40d5 <open>
    3a44:	83 c4 10             	add    $0x10,%esp
    3a47:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3a4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3a4e:	79 18                	jns    3a68 <fsfull+0x142>
      printf(1, "open %s failed\n", name);
    3a50:	83 ec 04             	sub    $0x4,%esp
    3a53:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a56:	50                   	push   %eax
    3a57:	68 01 5d 00 00       	push   $0x5d01
    3a5c:	6a 01                	push   $0x1
    3a5e:	e8 ae 07 00 00       	call   4211 <printf>
    3a63:	83 c4 10             	add    $0x10,%esp
      break;
    3a66:	eb 6b                	jmp    3ad3 <fsfull+0x1ad>
    }
    int total = 0;
    3a68:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3a6f:	83 ec 04             	sub    $0x4,%esp
    3a72:	68 00 02 00 00       	push   $0x200
    3a77:	68 40 65 00 00       	push   $0x6540
    3a7c:	ff 75 e8             	push   -0x18(%ebp)
    3a7f:	e8 31 06 00 00       	call   40b5 <write>
    3a84:	83 c4 10             	add    $0x10,%esp
    3a87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3a8a:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3a91:	7e 0c                	jle    3a9f <fsfull+0x179>
        break;
      total += cc;
    3a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a96:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a99:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(1){
    3a9d:	eb d0                	jmp    3a6f <fsfull+0x149>
        break;
    3a9f:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    3aa0:	83 ec 04             	sub    $0x4,%esp
    3aa3:	ff 75 ec             	push   -0x14(%ebp)
    3aa6:	68 11 5d 00 00       	push   $0x5d11
    3aab:	6a 01                	push   $0x1
    3aad:	e8 5f 07 00 00       	call   4211 <printf>
    3ab2:	83 c4 10             	add    $0x10,%esp
    close(fd);
    3ab5:	83 ec 0c             	sub    $0xc,%esp
    3ab8:	ff 75 e8             	push   -0x18(%ebp)
    3abb:	e8 fd 05 00 00       	call   40bd <close>
    3ac0:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3ac3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3ac7:	74 09                	je     3ad2 <fsfull+0x1ac>
  for(nfiles = 0; ; nfiles++){
    3ac9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3acd:	e9 7b fe ff ff       	jmp    394d <fsfull+0x27>
      break;
    3ad2:	90                   	nop
  }

  while(nfiles >= 0){
    3ad3:	e9 e3 00 00 00       	jmp    3bbb <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    3ad8:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3adc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3adf:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3ae4:	89 c8                	mov    %ecx,%eax
    3ae6:	f7 ea                	imul   %edx
    3ae8:	89 d0                	mov    %edx,%eax
    3aea:	c1 f8 06             	sar    $0x6,%eax
    3aed:	c1 f9 1f             	sar    $0x1f,%ecx
    3af0:	89 ca                	mov    %ecx,%edx
    3af2:	29 d0                	sub    %edx,%eax
    3af4:	83 c0 30             	add    $0x30,%eax
    3af7:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3afa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3afd:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3b02:	89 d8                	mov    %ebx,%eax
    3b04:	f7 ea                	imul   %edx
    3b06:	89 d0                	mov    %edx,%eax
    3b08:	c1 f8 06             	sar    $0x6,%eax
    3b0b:	89 da                	mov    %ebx,%edx
    3b0d:	c1 fa 1f             	sar    $0x1f,%edx
    3b10:	29 d0                	sub    %edx,%eax
    3b12:	89 c1                	mov    %eax,%ecx
    3b14:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3b1a:	29 c3                	sub    %eax,%ebx
    3b1c:	89 d9                	mov    %ebx,%ecx
    3b1e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3b23:	89 c8                	mov    %ecx,%eax
    3b25:	f7 ea                	imul   %edx
    3b27:	89 d0                	mov    %edx,%eax
    3b29:	c1 f8 05             	sar    $0x5,%eax
    3b2c:	c1 f9 1f             	sar    $0x1f,%ecx
    3b2f:	89 ca                	mov    %ecx,%edx
    3b31:	29 d0                	sub    %edx,%eax
    3b33:	83 c0 30             	add    $0x30,%eax
    3b36:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3b39:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3b3c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3b41:	89 d8                	mov    %ebx,%eax
    3b43:	f7 ea                	imul   %edx
    3b45:	89 d0                	mov    %edx,%eax
    3b47:	c1 f8 05             	sar    $0x5,%eax
    3b4a:	89 da                	mov    %ebx,%edx
    3b4c:	c1 fa 1f             	sar    $0x1f,%edx
    3b4f:	29 d0                	sub    %edx,%eax
    3b51:	89 c1                	mov    %eax,%ecx
    3b53:	6b c1 64             	imul   $0x64,%ecx,%eax
    3b56:	29 c3                	sub    %eax,%ebx
    3b58:	89 d9                	mov    %ebx,%ecx
    3b5a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3b5f:	89 c8                	mov    %ecx,%eax
    3b61:	f7 ea                	imul   %edx
    3b63:	89 d0                	mov    %edx,%eax
    3b65:	c1 f8 02             	sar    $0x2,%eax
    3b68:	c1 f9 1f             	sar    $0x1f,%ecx
    3b6b:	89 ca                	mov    %ecx,%edx
    3b6d:	29 d0                	sub    %edx,%eax
    3b6f:	83 c0 30             	add    $0x30,%eax
    3b72:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3b75:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3b78:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3b7d:	89 c8                	mov    %ecx,%eax
    3b7f:	f7 ea                	imul   %edx
    3b81:	89 d0                	mov    %edx,%eax
    3b83:	c1 f8 02             	sar    $0x2,%eax
    3b86:	89 cb                	mov    %ecx,%ebx
    3b88:	c1 fb 1f             	sar    $0x1f,%ebx
    3b8b:	29 d8                	sub    %ebx,%eax
    3b8d:	89 c2                	mov    %eax,%edx
    3b8f:	89 d0                	mov    %edx,%eax
    3b91:	c1 e0 02             	shl    $0x2,%eax
    3b94:	01 d0                	add    %edx,%eax
    3b96:	01 c0                	add    %eax,%eax
    3b98:	29 c1                	sub    %eax,%ecx
    3b9a:	89 ca                	mov    %ecx,%edx
    3b9c:	89 d0                	mov    %edx,%eax
    3b9e:	83 c0 30             	add    $0x30,%eax
    3ba1:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3ba4:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3ba8:	83 ec 0c             	sub    $0xc,%esp
    3bab:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3bae:	50                   	push   %eax
    3baf:	e8 31 05 00 00       	call   40e5 <unlink>
    3bb4:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3bb7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    3bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3bbf:	0f 89 13 ff ff ff    	jns    3ad8 <fsfull+0x1b2>
  }

  printf(1, "fsfull test finished\n");
    3bc5:	83 ec 08             	sub    $0x8,%esp
    3bc8:	68 21 5d 00 00       	push   $0x5d21
    3bcd:	6a 01                	push   $0x1
    3bcf:	e8 3d 06 00 00       	call   4211 <printf>
    3bd4:	83 c4 10             	add    $0x10,%esp
}
    3bd7:	90                   	nop
    3bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3bdb:	c9                   	leave  
    3bdc:	c3                   	ret    

00003bdd <uio>:

void
uio()
{
    3bdd:	55                   	push   %ebp
    3bde:	89 e5                	mov    %esp,%ebp
    3be0:	83 ec 18             	sub    $0x18,%esp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    3be3:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
  uchar val = 0;
    3be9:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
  int pid;

  printf(1, "uio test\n");
    3bed:	83 ec 08             	sub    $0x8,%esp
    3bf0:	68 37 5d 00 00       	push   $0x5d37
    3bf5:	6a 01                	push   $0x1
    3bf7:	e8 15 06 00 00       	call   4211 <printf>
    3bfc:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3bff:	e8 89 04 00 00       	call   408d <fork>
    3c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3c0b:	75 3a                	jne    3c47 <uio+0x6a>
    port = RTC_ADDR;
    3c0d:	66 c7 45 f6 70 00    	movw   $0x70,-0xa(%ebp)
    val = 0x09;  /* year */
    3c13:	c6 45 f5 09          	movb   $0x9,-0xb(%ebp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3c17:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    3c1b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
    3c1f:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    3c20:	66 c7 45 f6 71 00    	movw   $0x71,-0xa(%ebp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3c26:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    3c2a:	89 c2                	mov    %eax,%edx
    3c2c:	ec                   	in     (%dx),%al
    3c2d:	88 45 f5             	mov    %al,-0xb(%ebp)
    printf(1, "uio: uio succeeded; test FAILED\n");
    3c30:	83 ec 08             	sub    $0x8,%esp
    3c33:	68 44 5d 00 00       	push   $0x5d44
    3c38:	6a 01                	push   $0x1
    3c3a:	e8 d2 05 00 00       	call   4211 <printf>
    3c3f:	83 c4 10             	add    $0x10,%esp
    exit();
    3c42:	e8 4e 04 00 00       	call   4095 <exit>
  } else if(pid < 0){
    3c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3c4b:	79 17                	jns    3c64 <uio+0x87>
    printf (1, "fork failed\n");
    3c4d:	83 ec 08             	sub    $0x8,%esp
    3c50:	68 69 46 00 00       	push   $0x4669
    3c55:	6a 01                	push   $0x1
    3c57:	e8 b5 05 00 00       	call   4211 <printf>
    3c5c:	83 c4 10             	add    $0x10,%esp
    exit();
    3c5f:	e8 31 04 00 00       	call   4095 <exit>
  }
  wait();
    3c64:	e8 34 04 00 00       	call   409d <wait>
  printf(1, "uio test done\n");
    3c69:	83 ec 08             	sub    $0x8,%esp
    3c6c:	68 65 5d 00 00       	push   $0x5d65
    3c71:	6a 01                	push   $0x1
    3c73:	e8 99 05 00 00       	call   4211 <printf>
    3c78:	83 c4 10             	add    $0x10,%esp
}
    3c7b:	90                   	nop
    3c7c:	c9                   	leave  
    3c7d:	c3                   	ret    

00003c7e <argptest>:

void argptest()
{
    3c7e:	55                   	push   %ebp
    3c7f:	89 e5                	mov    %esp,%ebp
    3c81:	83 ec 18             	sub    $0x18,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3c84:	83 ec 08             	sub    $0x8,%esp
    3c87:	6a 00                	push   $0x0
    3c89:	68 74 5d 00 00       	push   $0x5d74
    3c8e:	e8 42 04 00 00       	call   40d5 <open>
    3c93:	83 c4 10             	add    $0x10,%esp
    3c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0) {
    3c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3c9d:	79 17                	jns    3cb6 <argptest+0x38>
    printf(2, "open failed\n");
    3c9f:	83 ec 08             	sub    $0x8,%esp
    3ca2:	68 79 5d 00 00       	push   $0x5d79
    3ca7:	6a 02                	push   $0x2
    3ca9:	e8 63 05 00 00       	call   4211 <printf>
    3cae:	83 c4 10             	add    $0x10,%esp
    exit();
    3cb1:	e8 df 03 00 00       	call   4095 <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    3cb6:	83 ec 0c             	sub    $0xc,%esp
    3cb9:	6a 00                	push   $0x0
    3cbb:	e8 5d 04 00 00       	call   411d <sbrk>
    3cc0:	83 c4 10             	add    $0x10,%esp
    3cc3:	83 e8 01             	sub    $0x1,%eax
    3cc6:	83 ec 04             	sub    $0x4,%esp
    3cc9:	6a ff                	push   $0xffffffff
    3ccb:	50                   	push   %eax
    3ccc:	ff 75 f4             	push   -0xc(%ebp)
    3ccf:	e8 d9 03 00 00       	call   40ad <read>
    3cd4:	83 c4 10             	add    $0x10,%esp
  close(fd);
    3cd7:	83 ec 0c             	sub    $0xc,%esp
    3cda:	ff 75 f4             	push   -0xc(%ebp)
    3cdd:	e8 db 03 00 00       	call   40bd <close>
    3ce2:	83 c4 10             	add    $0x10,%esp
  printf(1, "arg test passed\n");
    3ce5:	83 ec 08             	sub    $0x8,%esp
    3ce8:	68 86 5d 00 00       	push   $0x5d86
    3ced:	6a 01                	push   $0x1
    3cef:	e8 1d 05 00 00       	call   4211 <printf>
    3cf4:	83 c4 10             	add    $0x10,%esp
}
    3cf7:	90                   	nop
    3cf8:	c9                   	leave  
    3cf9:	c3                   	ret    

00003cfa <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3cfa:	55                   	push   %ebp
    3cfb:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3cfd:	a1 18 65 00 00       	mov    0x6518,%eax
    3d02:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3d08:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3d0d:	a3 18 65 00 00       	mov    %eax,0x6518
  return randstate;
    3d12:	a1 18 65 00 00       	mov    0x6518,%eax
}
    3d17:	5d                   	pop    %ebp
    3d18:	c3                   	ret    

00003d19 <main>:

int
main(int argc, char *argv[])
{
    3d19:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3d1d:	83 e4 f0             	and    $0xfffffff0,%esp
    3d20:	ff 71 fc             	push   -0x4(%ecx)
    3d23:	55                   	push   %ebp
    3d24:	89 e5                	mov    %esp,%ebp
    3d26:	51                   	push   %ecx
    3d27:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3d2a:	83 ec 08             	sub    $0x8,%esp
    3d2d:	68 97 5d 00 00       	push   $0x5d97
    3d32:	6a 01                	push   $0x1
    3d34:	e8 d8 04 00 00       	call   4211 <printf>
    3d39:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3d3c:	83 ec 08             	sub    $0x8,%esp
    3d3f:	6a 00                	push   $0x0
    3d41:	68 ab 5d 00 00       	push   $0x5dab
    3d46:	e8 8a 03 00 00       	call   40d5 <open>
    3d4b:	83 c4 10             	add    $0x10,%esp
    3d4e:	85 c0                	test   %eax,%eax
    3d50:	78 17                	js     3d69 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3d52:	83 ec 08             	sub    $0x8,%esp
    3d55:	68 bc 5d 00 00       	push   $0x5dbc
    3d5a:	6a 01                	push   $0x1
    3d5c:	e8 b0 04 00 00       	call   4211 <printf>
    3d61:	83 c4 10             	add    $0x10,%esp
    exit();
    3d64:	e8 2c 03 00 00       	call   4095 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3d69:	83 ec 08             	sub    $0x8,%esp
    3d6c:	68 00 02 00 00       	push   $0x200
    3d71:	68 ab 5d 00 00       	push   $0x5dab
    3d76:	e8 5a 03 00 00       	call   40d5 <open>
    3d7b:	83 c4 10             	add    $0x10,%esp
    3d7e:	83 ec 0c             	sub    $0xc,%esp
    3d81:	50                   	push   %eax
    3d82:	e8 36 03 00 00       	call   40bd <close>
    3d87:	83 c4 10             	add    $0x10,%esp

  argptest();
    3d8a:	e8 ef fe ff ff       	call   3c7e <argptest>
  createdelete();
    3d8f:	e8 a3 d5 ff ff       	call   1337 <createdelete>
  linkunlink();
    3d94:	e8 ce df ff ff       	call   1d67 <linkunlink>
  concreate();
    3d99:	e8 0f dc ff ff       	call   19ad <concreate>
  fourfiles();
    3d9e:	e8 43 d3 ff ff       	call   10e6 <fourfiles>
  sharedfd();
    3da3:	e8 5b d1 ff ff       	call   f03 <sharedfd>

  bigargtest();
    3da8:	e8 3d fa ff ff       	call   37ea <bigargtest>
  bigwrite();
    3dad:	e8 a9 e9 ff ff       	call   275b <bigwrite>
  bigargtest();
    3db2:	e8 33 fa ff ff       	call   37ea <bigargtest>
  bsstest();
    3db7:	e8 b8 f9 ff ff       	call   3774 <bsstest>
  sbrktest();
    3dbc:	e8 cd f3 ff ff       	call   318e <sbrktest>
  validatetest();
    3dc1:	e8 d0 f8 ff ff       	call   3696 <validatetest>

  opentest();
    3dc6:	e8 34 c5 ff ff       	call   2ff <opentest>
  writetest();
    3dcb:	e8 de c5 ff ff       	call   3ae <writetest>
  writetest1();
    3dd0:	e8 e9 c7 ff ff       	call   5be <writetest1>
  createtest();
    3dd5:	e8 e0 c9 ff ff       	call   7ba <createtest>

  openiputtest();
    3dda:	e8 11 c4 ff ff       	call   1f0 <openiputtest>
  exitiputtest();
    3ddf:	e8 0d c3 ff ff       	call   f1 <exitiputtest>
  iputtest();
    3de4:	e8 17 c2 ff ff       	call   0 <iputtest>

  mem();
    3de9:	e8 97 cf ff ff       	call   d85 <mem>
  pipe1();
    3dee:	e8 ce cb ff ff       	call   9c1 <pipe1>
  preempt();
    3df3:	e8 b2 cd ff ff       	call   baa <preempt>
  exitwait();
    3df8:	e8 10 cf ff ff       	call   d0d <exitwait>

  rmdot();
    3dfd:	e8 cb ed ff ff       	call   2bcd <rmdot>
  fourteen();
    3e02:	e8 6a ec ff ff       	call   2a71 <fourteen>
  bigfile();
    3e07:	e8 4d ea ff ff       	call   2859 <bigfile>
  subdir();
    3e0c:	e8 06 e2 ff ff       	call   2017 <subdir>
  linktest();
    3e11:	e8 55 d9 ff ff       	call   176b <linktest>
  unlinkread();
    3e16:	e8 8e d7 ff ff       	call   15a9 <unlinkread>
  dirfile();
    3e1b:	e8 32 ef ff ff       	call   2d52 <dirfile>
  iref();
    3e20:	e8 65 f1 ff ff       	call   2f8a <iref>
  forktest();
    3e25:	e8 9a f2 ff ff       	call   30c4 <forktest>
  bigdir(); // slow
    3e2a:	e8 73 e0 ff ff       	call   1ea2 <bigdir>

  uio();
    3e2f:	e8 a9 fd ff ff       	call   3bdd <uio>

  exectest();
    3e34:	e8 35 cb ff ff       	call   96e <exectest>

  exit();
    3e39:	e8 57 02 00 00       	call   4095 <exit>

00003e3e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3e3e:	55                   	push   %ebp
    3e3f:	89 e5                	mov    %esp,%ebp
    3e41:	57                   	push   %edi
    3e42:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3e43:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3e46:	8b 55 10             	mov    0x10(%ebp),%edx
    3e49:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e4c:	89 cb                	mov    %ecx,%ebx
    3e4e:	89 df                	mov    %ebx,%edi
    3e50:	89 d1                	mov    %edx,%ecx
    3e52:	fc                   	cld    
    3e53:	f3 aa                	rep stos %al,%es:(%edi)
    3e55:	89 ca                	mov    %ecx,%edx
    3e57:	89 fb                	mov    %edi,%ebx
    3e59:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3e5c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3e5f:	90                   	nop
    3e60:	5b                   	pop    %ebx
    3e61:	5f                   	pop    %edi
    3e62:	5d                   	pop    %ebp
    3e63:	c3                   	ret    

00003e64 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3e64:	55                   	push   %ebp
    3e65:	89 e5                	mov    %esp,%ebp
    3e67:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3e6a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3e70:	90                   	nop
    3e71:	8b 55 0c             	mov    0xc(%ebp),%edx
    3e74:	8d 42 01             	lea    0x1(%edx),%eax
    3e77:	89 45 0c             	mov    %eax,0xc(%ebp)
    3e7a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7d:	8d 48 01             	lea    0x1(%eax),%ecx
    3e80:	89 4d 08             	mov    %ecx,0x8(%ebp)
    3e83:	0f b6 12             	movzbl (%edx),%edx
    3e86:	88 10                	mov    %dl,(%eax)
    3e88:	0f b6 00             	movzbl (%eax),%eax
    3e8b:	84 c0                	test   %al,%al
    3e8d:	75 e2                	jne    3e71 <strcpy+0xd>
    ;
  return os;
    3e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e92:	c9                   	leave  
    3e93:	c3                   	ret    

00003e94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3e94:	55                   	push   %ebp
    3e95:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3e97:	eb 08                	jmp    3ea1 <strcmp+0xd>
    p++, q++;
    3e99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e9d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    3ea1:	8b 45 08             	mov    0x8(%ebp),%eax
    3ea4:	0f b6 00             	movzbl (%eax),%eax
    3ea7:	84 c0                	test   %al,%al
    3ea9:	74 10                	je     3ebb <strcmp+0x27>
    3eab:	8b 45 08             	mov    0x8(%ebp),%eax
    3eae:	0f b6 10             	movzbl (%eax),%edx
    3eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
    3eb4:	0f b6 00             	movzbl (%eax),%eax
    3eb7:	38 c2                	cmp    %al,%dl
    3eb9:	74 de                	je     3e99 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    3ebb:	8b 45 08             	mov    0x8(%ebp),%eax
    3ebe:	0f b6 00             	movzbl (%eax),%eax
    3ec1:	0f b6 d0             	movzbl %al,%edx
    3ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ec7:	0f b6 00             	movzbl (%eax),%eax
    3eca:	0f b6 c8             	movzbl %al,%ecx
    3ecd:	89 d0                	mov    %edx,%eax
    3ecf:	29 c8                	sub    %ecx,%eax
}
    3ed1:	5d                   	pop    %ebp
    3ed2:	c3                   	ret    

00003ed3 <strlen>:

uint
strlen(char *s)
{
    3ed3:	55                   	push   %ebp
    3ed4:	89 e5                	mov    %esp,%ebp
    3ed6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3ed9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3ee0:	eb 04                	jmp    3ee6 <strlen+0x13>
    3ee2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3ee9:	8b 45 08             	mov    0x8(%ebp),%eax
    3eec:	01 d0                	add    %edx,%eax
    3eee:	0f b6 00             	movzbl (%eax),%eax
    3ef1:	84 c0                	test   %al,%al
    3ef3:	75 ed                	jne    3ee2 <strlen+0xf>
    ;
  return n;
    3ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3ef8:	c9                   	leave  
    3ef9:	c3                   	ret    

00003efa <memset>:

void*
memset(void *dst, int c, uint n)
{
    3efa:	55                   	push   %ebp
    3efb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3efd:	8b 45 10             	mov    0x10(%ebp),%eax
    3f00:	50                   	push   %eax
    3f01:	ff 75 0c             	push   0xc(%ebp)
    3f04:	ff 75 08             	push   0x8(%ebp)
    3f07:	e8 32 ff ff ff       	call   3e3e <stosb>
    3f0c:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3f12:	c9                   	leave  
    3f13:	c3                   	ret    

00003f14 <strchr>:

char*
strchr(const char *s, char c)
{
    3f14:	55                   	push   %ebp
    3f15:	89 e5                	mov    %esp,%ebp
    3f17:	83 ec 04             	sub    $0x4,%esp
    3f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f1d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3f20:	eb 14                	jmp    3f36 <strchr+0x22>
    if(*s == c)
    3f22:	8b 45 08             	mov    0x8(%ebp),%eax
    3f25:	0f b6 00             	movzbl (%eax),%eax
    3f28:	38 45 fc             	cmp    %al,-0x4(%ebp)
    3f2b:	75 05                	jne    3f32 <strchr+0x1e>
      return (char*)s;
    3f2d:	8b 45 08             	mov    0x8(%ebp),%eax
    3f30:	eb 13                	jmp    3f45 <strchr+0x31>
  for(; *s; s++)
    3f32:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3f36:	8b 45 08             	mov    0x8(%ebp),%eax
    3f39:	0f b6 00             	movzbl (%eax),%eax
    3f3c:	84 c0                	test   %al,%al
    3f3e:	75 e2                	jne    3f22 <strchr+0xe>
  return 0;
    3f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3f45:	c9                   	leave  
    3f46:	c3                   	ret    

00003f47 <gets>:

char*
gets(char *buf, int max)
{
    3f47:	55                   	push   %ebp
    3f48:	89 e5                	mov    %esp,%ebp
    3f4a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3f4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3f54:	eb 42                	jmp    3f98 <gets+0x51>
    cc = read(0, &c, 1);
    3f56:	83 ec 04             	sub    $0x4,%esp
    3f59:	6a 01                	push   $0x1
    3f5b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3f5e:	50                   	push   %eax
    3f5f:	6a 00                	push   $0x0
    3f61:	e8 47 01 00 00       	call   40ad <read>
    3f66:	83 c4 10             	add    $0x10,%esp
    3f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3f70:	7e 33                	jle    3fa5 <gets+0x5e>
      break;
    buf[i++] = c;
    3f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f75:	8d 50 01             	lea    0x1(%eax),%edx
    3f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3f7b:	89 c2                	mov    %eax,%edx
    3f7d:	8b 45 08             	mov    0x8(%ebp),%eax
    3f80:	01 c2                	add    %eax,%edx
    3f82:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f86:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3f88:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f8c:	3c 0a                	cmp    $0xa,%al
    3f8e:	74 16                	je     3fa6 <gets+0x5f>
    3f90:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f94:	3c 0d                	cmp    $0xd,%al
    3f96:	74 0e                	je     3fa6 <gets+0x5f>
  for(i=0; i+1 < max; ){
    3f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f9b:	83 c0 01             	add    $0x1,%eax
    3f9e:	39 45 0c             	cmp    %eax,0xc(%ebp)
    3fa1:	7f b3                	jg     3f56 <gets+0xf>
    3fa3:	eb 01                	jmp    3fa6 <gets+0x5f>
      break;
    3fa5:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3fa9:	8b 45 08             	mov    0x8(%ebp),%eax
    3fac:	01 d0                	add    %edx,%eax
    3fae:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3fb4:	c9                   	leave  
    3fb5:	c3                   	ret    

00003fb6 <stat>:

int
stat(char *n, struct stat *st)
{
    3fb6:	55                   	push   %ebp
    3fb7:	89 e5                	mov    %esp,%ebp
    3fb9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3fbc:	83 ec 08             	sub    $0x8,%esp
    3fbf:	6a 00                	push   $0x0
    3fc1:	ff 75 08             	push   0x8(%ebp)
    3fc4:	e8 0c 01 00 00       	call   40d5 <open>
    3fc9:	83 c4 10             	add    $0x10,%esp
    3fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3fd3:	79 07                	jns    3fdc <stat+0x26>
    return -1;
    3fd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3fda:	eb 25                	jmp    4001 <stat+0x4b>
  r = fstat(fd, st);
    3fdc:	83 ec 08             	sub    $0x8,%esp
    3fdf:	ff 75 0c             	push   0xc(%ebp)
    3fe2:	ff 75 f4             	push   -0xc(%ebp)
    3fe5:	e8 03 01 00 00       	call   40ed <fstat>
    3fea:	83 c4 10             	add    $0x10,%esp
    3fed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3ff0:	83 ec 0c             	sub    $0xc,%esp
    3ff3:	ff 75 f4             	push   -0xc(%ebp)
    3ff6:	e8 c2 00 00 00       	call   40bd <close>
    3ffb:	83 c4 10             	add    $0x10,%esp
  return r;
    3ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    4001:	c9                   	leave  
    4002:	c3                   	ret    

00004003 <atoi>:

int
atoi(const char *s)
{
    4003:	55                   	push   %ebp
    4004:	89 e5                	mov    %esp,%ebp
    4006:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    4009:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4010:	eb 25                	jmp    4037 <atoi+0x34>
    n = n*10 + *s++ - '0';
    4012:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4015:	89 d0                	mov    %edx,%eax
    4017:	c1 e0 02             	shl    $0x2,%eax
    401a:	01 d0                	add    %edx,%eax
    401c:	01 c0                	add    %eax,%eax
    401e:	89 c1                	mov    %eax,%ecx
    4020:	8b 45 08             	mov    0x8(%ebp),%eax
    4023:	8d 50 01             	lea    0x1(%eax),%edx
    4026:	89 55 08             	mov    %edx,0x8(%ebp)
    4029:	0f b6 00             	movzbl (%eax),%eax
    402c:	0f be c0             	movsbl %al,%eax
    402f:	01 c8                	add    %ecx,%eax
    4031:	83 e8 30             	sub    $0x30,%eax
    4034:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4037:	8b 45 08             	mov    0x8(%ebp),%eax
    403a:	0f b6 00             	movzbl (%eax),%eax
    403d:	3c 2f                	cmp    $0x2f,%al
    403f:	7e 0a                	jle    404b <atoi+0x48>
    4041:	8b 45 08             	mov    0x8(%ebp),%eax
    4044:	0f b6 00             	movzbl (%eax),%eax
    4047:	3c 39                	cmp    $0x39,%al
    4049:	7e c7                	jle    4012 <atoi+0xf>
  return n;
    404b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    404e:	c9                   	leave  
    404f:	c3                   	ret    

00004050 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    4050:	55                   	push   %ebp
    4051:	89 e5                	mov    %esp,%ebp
    4053:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    4056:	8b 45 08             	mov    0x8(%ebp),%eax
    4059:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    405c:	8b 45 0c             	mov    0xc(%ebp),%eax
    405f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    4062:	eb 17                	jmp    407b <memmove+0x2b>
    *dst++ = *src++;
    4064:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4067:	8d 42 01             	lea    0x1(%edx),%eax
    406a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    406d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4070:	8d 48 01             	lea    0x1(%eax),%ecx
    4073:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    4076:	0f b6 12             	movzbl (%edx),%edx
    4079:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    407b:	8b 45 10             	mov    0x10(%ebp),%eax
    407e:	8d 50 ff             	lea    -0x1(%eax),%edx
    4081:	89 55 10             	mov    %edx,0x10(%ebp)
    4084:	85 c0                	test   %eax,%eax
    4086:	7f dc                	jg     4064 <memmove+0x14>
  return vdst;
    4088:	8b 45 08             	mov    0x8(%ebp),%eax
}
    408b:	c9                   	leave  
    408c:	c3                   	ret    

0000408d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    408d:	b8 01 00 00 00       	mov    $0x1,%eax
    4092:	cd 40                	int    $0x40
    4094:	c3                   	ret    

00004095 <exit>:
SYSCALL(exit)
    4095:	b8 02 00 00 00       	mov    $0x2,%eax
    409a:	cd 40                	int    $0x40
    409c:	c3                   	ret    

0000409d <wait>:
SYSCALL(wait)
    409d:	b8 03 00 00 00       	mov    $0x3,%eax
    40a2:	cd 40                	int    $0x40
    40a4:	c3                   	ret    

000040a5 <pipe>:
SYSCALL(pipe)
    40a5:	b8 04 00 00 00       	mov    $0x4,%eax
    40aa:	cd 40                	int    $0x40
    40ac:	c3                   	ret    

000040ad <read>:
SYSCALL(read)
    40ad:	b8 05 00 00 00       	mov    $0x5,%eax
    40b2:	cd 40                	int    $0x40
    40b4:	c3                   	ret    

000040b5 <write>:
SYSCALL(write)
    40b5:	b8 10 00 00 00       	mov    $0x10,%eax
    40ba:	cd 40                	int    $0x40
    40bc:	c3                   	ret    

000040bd <close>:
SYSCALL(close)
    40bd:	b8 15 00 00 00       	mov    $0x15,%eax
    40c2:	cd 40                	int    $0x40
    40c4:	c3                   	ret    

000040c5 <kill>:
SYSCALL(kill)
    40c5:	b8 06 00 00 00       	mov    $0x6,%eax
    40ca:	cd 40                	int    $0x40
    40cc:	c3                   	ret    

000040cd <exec>:
SYSCALL(exec)
    40cd:	b8 07 00 00 00       	mov    $0x7,%eax
    40d2:	cd 40                	int    $0x40
    40d4:	c3                   	ret    

000040d5 <open>:
SYSCALL(open)
    40d5:	b8 0f 00 00 00       	mov    $0xf,%eax
    40da:	cd 40                	int    $0x40
    40dc:	c3                   	ret    

000040dd <mknod>:
SYSCALL(mknod)
    40dd:	b8 11 00 00 00       	mov    $0x11,%eax
    40e2:	cd 40                	int    $0x40
    40e4:	c3                   	ret    

000040e5 <unlink>:
SYSCALL(unlink)
    40e5:	b8 12 00 00 00       	mov    $0x12,%eax
    40ea:	cd 40                	int    $0x40
    40ec:	c3                   	ret    

000040ed <fstat>:
SYSCALL(fstat)
    40ed:	b8 08 00 00 00       	mov    $0x8,%eax
    40f2:	cd 40                	int    $0x40
    40f4:	c3                   	ret    

000040f5 <link>:
SYSCALL(link)
    40f5:	b8 13 00 00 00       	mov    $0x13,%eax
    40fa:	cd 40                	int    $0x40
    40fc:	c3                   	ret    

000040fd <mkdir>:
SYSCALL(mkdir)
    40fd:	b8 14 00 00 00       	mov    $0x14,%eax
    4102:	cd 40                	int    $0x40
    4104:	c3                   	ret    

00004105 <chdir>:
SYSCALL(chdir)
    4105:	b8 09 00 00 00       	mov    $0x9,%eax
    410a:	cd 40                	int    $0x40
    410c:	c3                   	ret    

0000410d <dup>:
SYSCALL(dup)
    410d:	b8 0a 00 00 00       	mov    $0xa,%eax
    4112:	cd 40                	int    $0x40
    4114:	c3                   	ret    

00004115 <getpid>:
SYSCALL(getpid)
    4115:	b8 0b 00 00 00       	mov    $0xb,%eax
    411a:	cd 40                	int    $0x40
    411c:	c3                   	ret    

0000411d <sbrk>:
SYSCALL(sbrk)
    411d:	b8 0c 00 00 00       	mov    $0xc,%eax
    4122:	cd 40                	int    $0x40
    4124:	c3                   	ret    

00004125 <sleep>:
SYSCALL(sleep)
    4125:	b8 0d 00 00 00       	mov    $0xd,%eax
    412a:	cd 40                	int    $0x40
    412c:	c3                   	ret    

0000412d <uptime>:
SYSCALL(uptime)
    412d:	b8 0e 00 00 00       	mov    $0xe,%eax
    4132:	cd 40                	int    $0x40
    4134:	c3                   	ret    

00004135 <printpt>:
SYSCALL(printpt)
    4135:	b8 16 00 00 00       	mov    $0x16,%eax
    413a:	cd 40                	int    $0x40
    413c:	c3                   	ret    

0000413d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    413d:	55                   	push   %ebp
    413e:	89 e5                	mov    %esp,%ebp
    4140:	83 ec 18             	sub    $0x18,%esp
    4143:	8b 45 0c             	mov    0xc(%ebp),%eax
    4146:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    4149:	83 ec 04             	sub    $0x4,%esp
    414c:	6a 01                	push   $0x1
    414e:	8d 45 f4             	lea    -0xc(%ebp),%eax
    4151:	50                   	push   %eax
    4152:	ff 75 08             	push   0x8(%ebp)
    4155:	e8 5b ff ff ff       	call   40b5 <write>
    415a:	83 c4 10             	add    $0x10,%esp
}
    415d:	90                   	nop
    415e:	c9                   	leave  
    415f:	c3                   	ret    

00004160 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4160:	55                   	push   %ebp
    4161:	89 e5                	mov    %esp,%ebp
    4163:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    4166:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    416d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    4171:	74 17                	je     418a <printint+0x2a>
    4173:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    4177:	79 11                	jns    418a <printint+0x2a>
    neg = 1;
    4179:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    4180:	8b 45 0c             	mov    0xc(%ebp),%eax
    4183:	f7 d8                	neg    %eax
    4185:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4188:	eb 06                	jmp    4190 <printint+0x30>
  } else {
    x = xx;
    418a:	8b 45 0c             	mov    0xc(%ebp),%eax
    418d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    4190:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    4197:	8b 4d 10             	mov    0x10(%ebp),%ecx
    419a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    419d:	ba 00 00 00 00       	mov    $0x0,%edx
    41a2:	f7 f1                	div    %ecx
    41a4:	89 d1                	mov    %edx,%ecx
    41a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    41a9:	8d 50 01             	lea    0x1(%eax),%edx
    41ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
    41af:	0f b6 91 1c 65 00 00 	movzbl 0x651c(%ecx),%edx
    41b6:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    41ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
    41bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41c0:	ba 00 00 00 00       	mov    $0x0,%edx
    41c5:	f7 f1                	div    %ecx
    41c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    41ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    41ce:	75 c7                	jne    4197 <printint+0x37>
  if(neg)
    41d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    41d4:	74 2d                	je     4203 <printint+0xa3>
    buf[i++] = '-';
    41d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    41d9:	8d 50 01             	lea    0x1(%eax),%edx
    41dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
    41df:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    41e4:	eb 1d                	jmp    4203 <printint+0xa3>
    putc(fd, buf[i]);
    41e6:	8d 55 dc             	lea    -0x24(%ebp),%edx
    41e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    41ec:	01 d0                	add    %edx,%eax
    41ee:	0f b6 00             	movzbl (%eax),%eax
    41f1:	0f be c0             	movsbl %al,%eax
    41f4:	83 ec 08             	sub    $0x8,%esp
    41f7:	50                   	push   %eax
    41f8:	ff 75 08             	push   0x8(%ebp)
    41fb:	e8 3d ff ff ff       	call   413d <putc>
    4200:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    4203:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    420b:	79 d9                	jns    41e6 <printint+0x86>
}
    420d:	90                   	nop
    420e:	90                   	nop
    420f:	c9                   	leave  
    4210:	c3                   	ret    

00004211 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4211:	55                   	push   %ebp
    4212:	89 e5                	mov    %esp,%ebp
    4214:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4217:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    421e:	8d 45 0c             	lea    0xc(%ebp),%eax
    4221:	83 c0 04             	add    $0x4,%eax
    4224:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    422e:	e9 59 01 00 00       	jmp    438c <printf+0x17b>
    c = fmt[i] & 0xff;
    4233:	8b 55 0c             	mov    0xc(%ebp),%edx
    4236:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4239:	01 d0                	add    %edx,%eax
    423b:	0f b6 00             	movzbl (%eax),%eax
    423e:	0f be c0             	movsbl %al,%eax
    4241:	25 ff 00 00 00       	and    $0xff,%eax
    4246:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4249:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    424d:	75 2c                	jne    427b <printf+0x6a>
      if(c == '%'){
    424f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4253:	75 0c                	jne    4261 <printf+0x50>
        state = '%';
    4255:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    425c:	e9 27 01 00 00       	jmp    4388 <printf+0x177>
      } else {
        putc(fd, c);
    4261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4264:	0f be c0             	movsbl %al,%eax
    4267:	83 ec 08             	sub    $0x8,%esp
    426a:	50                   	push   %eax
    426b:	ff 75 08             	push   0x8(%ebp)
    426e:	e8 ca fe ff ff       	call   413d <putc>
    4273:	83 c4 10             	add    $0x10,%esp
    4276:	e9 0d 01 00 00       	jmp    4388 <printf+0x177>
      }
    } else if(state == '%'){
    427b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    427f:	0f 85 03 01 00 00    	jne    4388 <printf+0x177>
      if(c == 'd'){
    4285:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    4289:	75 1e                	jne    42a9 <printf+0x98>
        printint(fd, *ap, 10, 1);
    428b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    428e:	8b 00                	mov    (%eax),%eax
    4290:	6a 01                	push   $0x1
    4292:	6a 0a                	push   $0xa
    4294:	50                   	push   %eax
    4295:	ff 75 08             	push   0x8(%ebp)
    4298:	e8 c3 fe ff ff       	call   4160 <printint>
    429d:	83 c4 10             	add    $0x10,%esp
        ap++;
    42a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    42a4:	e9 d8 00 00 00       	jmp    4381 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    42a9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    42ad:	74 06                	je     42b5 <printf+0xa4>
    42af:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    42b3:	75 1e                	jne    42d3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    42b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    42b8:	8b 00                	mov    (%eax),%eax
    42ba:	6a 00                	push   $0x0
    42bc:	6a 10                	push   $0x10
    42be:	50                   	push   %eax
    42bf:	ff 75 08             	push   0x8(%ebp)
    42c2:	e8 99 fe ff ff       	call   4160 <printint>
    42c7:	83 c4 10             	add    $0x10,%esp
        ap++;
    42ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    42ce:	e9 ae 00 00 00       	jmp    4381 <printf+0x170>
      } else if(c == 's'){
    42d3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    42d7:	75 43                	jne    431c <printf+0x10b>
        s = (char*)*ap;
    42d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    42dc:	8b 00                	mov    (%eax),%eax
    42de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    42e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    42e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    42e9:	75 25                	jne    4310 <printf+0xff>
          s = "(null)";
    42eb:	c7 45 f4 e6 5d 00 00 	movl   $0x5de6,-0xc(%ebp)
        while(*s != 0){
    42f2:	eb 1c                	jmp    4310 <printf+0xff>
          putc(fd, *s);
    42f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42f7:	0f b6 00             	movzbl (%eax),%eax
    42fa:	0f be c0             	movsbl %al,%eax
    42fd:	83 ec 08             	sub    $0x8,%esp
    4300:	50                   	push   %eax
    4301:	ff 75 08             	push   0x8(%ebp)
    4304:	e8 34 fe ff ff       	call   413d <putc>
    4309:	83 c4 10             	add    $0x10,%esp
          s++;
    430c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    4310:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4313:	0f b6 00             	movzbl (%eax),%eax
    4316:	84 c0                	test   %al,%al
    4318:	75 da                	jne    42f4 <printf+0xe3>
    431a:	eb 65                	jmp    4381 <printf+0x170>
        }
      } else if(c == 'c'){
    431c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4320:	75 1d                	jne    433f <printf+0x12e>
        putc(fd, *ap);
    4322:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4325:	8b 00                	mov    (%eax),%eax
    4327:	0f be c0             	movsbl %al,%eax
    432a:	83 ec 08             	sub    $0x8,%esp
    432d:	50                   	push   %eax
    432e:	ff 75 08             	push   0x8(%ebp)
    4331:	e8 07 fe ff ff       	call   413d <putc>
    4336:	83 c4 10             	add    $0x10,%esp
        ap++;
    4339:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    433d:	eb 42                	jmp    4381 <printf+0x170>
      } else if(c == '%'){
    433f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4343:	75 17                	jne    435c <printf+0x14b>
        putc(fd, c);
    4345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4348:	0f be c0             	movsbl %al,%eax
    434b:	83 ec 08             	sub    $0x8,%esp
    434e:	50                   	push   %eax
    434f:	ff 75 08             	push   0x8(%ebp)
    4352:	e8 e6 fd ff ff       	call   413d <putc>
    4357:	83 c4 10             	add    $0x10,%esp
    435a:	eb 25                	jmp    4381 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    435c:	83 ec 08             	sub    $0x8,%esp
    435f:	6a 25                	push   $0x25
    4361:	ff 75 08             	push   0x8(%ebp)
    4364:	e8 d4 fd ff ff       	call   413d <putc>
    4369:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    436c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    436f:	0f be c0             	movsbl %al,%eax
    4372:	83 ec 08             	sub    $0x8,%esp
    4375:	50                   	push   %eax
    4376:	ff 75 08             	push   0x8(%ebp)
    4379:	e8 bf fd ff ff       	call   413d <putc>
    437e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    4381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    4388:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    438c:	8b 55 0c             	mov    0xc(%ebp),%edx
    438f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4392:	01 d0                	add    %edx,%eax
    4394:	0f b6 00             	movzbl (%eax),%eax
    4397:	84 c0                	test   %al,%al
    4399:	0f 85 94 fe ff ff    	jne    4233 <printf+0x22>
    }
  }
}
    439f:	90                   	nop
    43a0:	90                   	nop
    43a1:	c9                   	leave  
    43a2:	c3                   	ret    

000043a3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    43a3:	55                   	push   %ebp
    43a4:	89 e5                	mov    %esp,%ebp
    43a6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    43a9:	8b 45 08             	mov    0x8(%ebp),%eax
    43ac:	83 e8 08             	sub    $0x8,%eax
    43af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    43b2:	a1 08 ad 00 00       	mov    0xad08,%eax
    43b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    43ba:	eb 24                	jmp    43e0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    43bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43bf:	8b 00                	mov    (%eax),%eax
    43c1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    43c4:	72 12                	jb     43d8 <free+0x35>
    43c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    43cc:	77 24                	ja     43f2 <free+0x4f>
    43ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43d1:	8b 00                	mov    (%eax),%eax
    43d3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    43d6:	72 1a                	jb     43f2 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    43d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43db:	8b 00                	mov    (%eax),%eax
    43dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    43e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    43e6:	76 d4                	jbe    43bc <free+0x19>
    43e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43eb:	8b 00                	mov    (%eax),%eax
    43ed:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    43f0:	73 ca                	jae    43bc <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    43f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43f5:	8b 40 04             	mov    0x4(%eax),%eax
    43f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    43ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4402:	01 c2                	add    %eax,%edx
    4404:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4407:	8b 00                	mov    (%eax),%eax
    4409:	39 c2                	cmp    %eax,%edx
    440b:	75 24                	jne    4431 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    440d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4410:	8b 50 04             	mov    0x4(%eax),%edx
    4413:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4416:	8b 00                	mov    (%eax),%eax
    4418:	8b 40 04             	mov    0x4(%eax),%eax
    441b:	01 c2                	add    %eax,%edx
    441d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4420:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4423:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4426:	8b 00                	mov    (%eax),%eax
    4428:	8b 10                	mov    (%eax),%edx
    442a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    442d:	89 10                	mov    %edx,(%eax)
    442f:	eb 0a                	jmp    443b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4431:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4434:	8b 10                	mov    (%eax),%edx
    4436:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4439:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    443b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    443e:	8b 40 04             	mov    0x4(%eax),%eax
    4441:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4448:	8b 45 fc             	mov    -0x4(%ebp),%eax
    444b:	01 d0                	add    %edx,%eax
    444d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    4450:	75 20                	jne    4472 <free+0xcf>
    p->s.size += bp->s.size;
    4452:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4455:	8b 50 04             	mov    0x4(%eax),%edx
    4458:	8b 45 f8             	mov    -0x8(%ebp),%eax
    445b:	8b 40 04             	mov    0x4(%eax),%eax
    445e:	01 c2                	add    %eax,%edx
    4460:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4463:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4466:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4469:	8b 10                	mov    (%eax),%edx
    446b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    446e:	89 10                	mov    %edx,(%eax)
    4470:	eb 08                	jmp    447a <free+0xd7>
  } else
    p->s.ptr = bp;
    4472:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4475:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4478:	89 10                	mov    %edx,(%eax)
  freep = p;
    447a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    447d:	a3 08 ad 00 00       	mov    %eax,0xad08
}
    4482:	90                   	nop
    4483:	c9                   	leave  
    4484:	c3                   	ret    

00004485 <morecore>:

static Header*
morecore(uint nu)
{
    4485:	55                   	push   %ebp
    4486:	89 e5                	mov    %esp,%ebp
    4488:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    448b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4492:	77 07                	ja     449b <morecore+0x16>
    nu = 4096;
    4494:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    449b:	8b 45 08             	mov    0x8(%ebp),%eax
    449e:	c1 e0 03             	shl    $0x3,%eax
    44a1:	83 ec 0c             	sub    $0xc,%esp
    44a4:	50                   	push   %eax
    44a5:	e8 73 fc ff ff       	call   411d <sbrk>
    44aa:	83 c4 10             	add    $0x10,%esp
    44ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    44b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    44b4:	75 07                	jne    44bd <morecore+0x38>
    return 0;
    44b6:	b8 00 00 00 00       	mov    $0x0,%eax
    44bb:	eb 26                	jmp    44e3 <morecore+0x5e>
  hp = (Header*)p;
    44bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    44c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44c6:	8b 55 08             	mov    0x8(%ebp),%edx
    44c9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    44cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44cf:	83 c0 08             	add    $0x8,%eax
    44d2:	83 ec 0c             	sub    $0xc,%esp
    44d5:	50                   	push   %eax
    44d6:	e8 c8 fe ff ff       	call   43a3 <free>
    44db:	83 c4 10             	add    $0x10,%esp
  return freep;
    44de:	a1 08 ad 00 00       	mov    0xad08,%eax
}
    44e3:	c9                   	leave  
    44e4:	c3                   	ret    

000044e5 <malloc>:

void*
malloc(uint nbytes)
{
    44e5:	55                   	push   %ebp
    44e6:	89 e5                	mov    %esp,%ebp
    44e8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    44eb:	8b 45 08             	mov    0x8(%ebp),%eax
    44ee:	83 c0 07             	add    $0x7,%eax
    44f1:	c1 e8 03             	shr    $0x3,%eax
    44f4:	83 c0 01             	add    $0x1,%eax
    44f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    44fa:	a1 08 ad 00 00       	mov    0xad08,%eax
    44ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4502:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4506:	75 23                	jne    452b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4508:	c7 45 f0 00 ad 00 00 	movl   $0xad00,-0x10(%ebp)
    450f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4512:	a3 08 ad 00 00       	mov    %eax,0xad08
    4517:	a1 08 ad 00 00       	mov    0xad08,%eax
    451c:	a3 00 ad 00 00       	mov    %eax,0xad00
    base.s.size = 0;
    4521:	c7 05 04 ad 00 00 00 	movl   $0x0,0xad04
    4528:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    452b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    452e:	8b 00                	mov    (%eax),%eax
    4530:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4533:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4536:	8b 40 04             	mov    0x4(%eax),%eax
    4539:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    453c:	77 4d                	ja     458b <malloc+0xa6>
      if(p->s.size == nunits)
    453e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4541:	8b 40 04             	mov    0x4(%eax),%eax
    4544:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    4547:	75 0c                	jne    4555 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4549:	8b 45 f4             	mov    -0xc(%ebp),%eax
    454c:	8b 10                	mov    (%eax),%edx
    454e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4551:	89 10                	mov    %edx,(%eax)
    4553:	eb 26                	jmp    457b <malloc+0x96>
      else {
        p->s.size -= nunits;
    4555:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4558:	8b 40 04             	mov    0x4(%eax),%eax
    455b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    455e:	89 c2                	mov    %eax,%edx
    4560:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4563:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    4566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4569:	8b 40 04             	mov    0x4(%eax),%eax
    456c:	c1 e0 03             	shl    $0x3,%eax
    456f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4572:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4575:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4578:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    457b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    457e:	a3 08 ad 00 00       	mov    %eax,0xad08
      return (void*)(p + 1);
    4583:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4586:	83 c0 08             	add    $0x8,%eax
    4589:	eb 3b                	jmp    45c6 <malloc+0xe1>
    }
    if(p == freep)
    458b:	a1 08 ad 00 00       	mov    0xad08,%eax
    4590:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4593:	75 1e                	jne    45b3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    4595:	83 ec 0c             	sub    $0xc,%esp
    4598:	ff 75 ec             	push   -0x14(%ebp)
    459b:	e8 e5 fe ff ff       	call   4485 <morecore>
    45a0:	83 c4 10             	add    $0x10,%esp
    45a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    45a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    45aa:	75 07                	jne    45b3 <malloc+0xce>
        return 0;
    45ac:	b8 00 00 00 00       	mov    $0x0,%eax
    45b1:	eb 13                	jmp    45c6 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    45b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    45b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45bc:	8b 00                	mov    (%eax),%eax
    45be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    45c1:	e9 6d ff ff ff       	jmp    4533 <malloc+0x4e>
  }
}
    45c6:	c9                   	leave  
    45c7:	c3                   	ret    
