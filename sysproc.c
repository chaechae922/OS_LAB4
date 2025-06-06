#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

extern int ppid[];
extern int pspage[];

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;

  struct proc *p = myproc();
  int addr = p->sz;
  uint oldsz = p->sz;
  uint newsz = oldsz + n;

  if (n < 0 && newsz > oldsz) return -1;
  if (n > 0 && newsz < oldsz) return -1;
  if (newsz >= KERNBASE) return -1;

  int i;
  for (i = 0; i < NPROC; i++) {
    if (ppid[i] == p->pid)
      break;
  }
  if (n > 0 && newsz >= KERNBASE - (pspage[i] + 2) * PGSIZE) return -1;

  if (n == 0)
    return addr;

  if (n > 0) {
    p->oldsz = p->sz;
    p->sz = newsz;
    return addr;
  }

  if ((newsz = deallocuvm(p->pgdir, oldsz, newsz)) == 0) {
    cprintf("Deallocating pages failed!\n");
    return -1;
  }

  p->sz = newsz;
  switchuvm(p);
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_printpt(void)
{
  int pid;
  if(argint(0, &pid) < 0)
    return -1;
  return printpt(pid);
}