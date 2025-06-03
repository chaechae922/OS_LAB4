
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <wait_main>:
8010000c:	00 00                	add    %al,(%eax)
	...

80100010 <entry>:
  .long 0
# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  #Set Data Segment
  mov $0x10,%ax
80100010:	66 b8 10 00          	mov    $0x10,%ax
  mov %ax,%ds
80100014:	8e d8                	mov    %eax,%ds
  mov %ax,%es
80100016:	8e c0                	mov    %eax,%es
  mov %ax,%ss
80100018:	8e d0                	mov    %eax,%ss
  mov $0,%ax
8010001a:	66 b8 00 00          	mov    $0x0,%ax
  mov %ax,%fs
8010001e:	8e e0                	mov    %eax,%fs
  mov %ax,%gs
80100020:	8e e8                	mov    %eax,%gs

  #Turn off paing
  movl %cr0,%eax
80100022:	0f 20 c0             	mov    %cr0,%eax
  andl $0x7fffffff,%eax
80100025:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  movl %eax,%cr0 
8010002a:	0f 22 c0             	mov    %eax,%cr0

  #Set Page Table Base Address
  movl    $(V2P_WO(entrypgdir)), %eax
8010002d:	b8 00 e0 10 00       	mov    $0x10e000,%eax
  movl    %eax, %cr3
80100032:	0f 22 d8             	mov    %eax,%cr3
  
  #Disable IA32e mode
  movl $0x0c0000080,%ecx
80100035:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
8010003a:	0f 32                	rdmsr  
  andl $0xFFFFFEFF,%eax
8010003c:	25 ff fe ff ff       	and    $0xfffffeff,%eax
  wrmsr
80100041:	0f 30                	wrmsr  

  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80100043:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80100046:	83 c8 10             	or     $0x10,%eax
  andl    $0xFFFFFFDF, %eax
80100049:	83 e0 df             	and    $0xffffffdf,%eax
  movl    %eax, %cr4
8010004c:	0f 22 e0             	mov    %eax,%cr4

  #Turn on Paging
  movl    %cr0, %eax
8010004f:	0f 20 c0             	mov    %cr0,%eax
  orl     $0x80010001, %eax
80100052:	0d 01 00 01 80       	or     $0x80010001,%eax
  movl    %eax, %cr0
80100057:	0f 22 c0             	mov    %eax,%cr0




  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
8010005a:	bc a0 81 19 80       	mov    $0x801981a0,%esp
  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
#  jz .waiting_main
  movl $main, %edx
8010005f:	ba 4a 33 10 80       	mov    $0x8010334a,%edx
  jmp %edx
80100064:	ff e2                	jmp    *%edx

80100066 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100066:	55                   	push   %ebp
80100067:	89 e5                	mov    %esp,%ebp
80100069:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010006c:	83 ec 08             	sub    $0x8,%esp
8010006f:	68 c0 a4 10 80       	push   $0x8010a4c0
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 1b 48 00 00       	call   80104899 <initlock>
8010007e:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100081:	c7 05 4c 17 19 80 fc 	movl   $0x801916fc,0x8019174c
80100088:	16 19 80 
  bcache.head.next = &bcache.head;
8010008b:	c7 05 50 17 19 80 fc 	movl   $0x801916fc,0x80191750
80100092:	16 19 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100095:	c7 45 f4 34 d0 18 80 	movl   $0x8018d034,-0xc(%ebp)
8010009c:	eb 47                	jmp    801000e5 <binit+0x7f>
    b->next = bcache.head.next;
8010009e:	8b 15 50 17 19 80    	mov    0x80191750,%edx
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ad:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
801000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b7:	83 c0 0c             	add    $0xc,%eax
801000ba:	83 ec 08             	sub    $0x8,%esp
801000bd:	68 c7 a4 10 80       	push   $0x8010a4c7
801000c2:	50                   	push   %eax
801000c3:	e8 74 46 00 00       	call   8010473c <initsleeplock>
801000c8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000cb:	a1 50 17 19 80       	mov    0x80191750,%eax
801000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d3:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d9:	a3 50 17 19 80       	mov    %eax,0x80191750
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000de:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e5:	b8 fc 16 19 80       	mov    $0x801916fc,%eax
801000ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ed:	72 af                	jb     8010009e <binit+0x38>
  }
}
801000ef:	90                   	nop
801000f0:	90                   	nop
801000f1:	c9                   	leave  
801000f2:	c3                   	ret    

801000f3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000f3:	55                   	push   %ebp
801000f4:	89 e5                	mov    %esp,%ebp
801000f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000f9:	83 ec 0c             	sub    $0xc,%esp
801000fc:	68 00 d0 18 80       	push   $0x8018d000
80100101:	e8 b5 47 00 00       	call   801048bb <acquire>
80100106:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	a1 50 17 19 80       	mov    0x80191750,%eax
8010010e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100111:	eb 58                	jmp    8010016b <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	8b 40 04             	mov    0x4(%eax),%eax
80100119:	39 45 08             	cmp    %eax,0x8(%ebp)
8010011c:	75 44                	jne    80100162 <bget+0x6f>
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	8b 40 08             	mov    0x8(%eax),%eax
80100124:	39 45 0c             	cmp    %eax,0xc(%ebp)
80100127:	75 39                	jne    80100162 <bget+0x6f>
      b->refcnt++;
80100129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010012f:	8d 50 01             	lea    0x1(%eax),%edx
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100138:	83 ec 0c             	sub    $0xc,%esp
8010013b:	68 00 d0 18 80       	push   $0x8018d000
80100140:	e8 e4 47 00 00       	call   80104929 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 21 46 00 00       	call   80104778 <acquiresleep>
80100157:	83 c4 10             	add    $0x10,%esp
      return b;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	e9 9d 00 00 00       	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 40 54             	mov    0x54(%eax),%eax
80100168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010016b:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
80100172:	75 9f                	jne    80100113 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100174:	a1 4c 17 19 80       	mov    0x8019174c,%eax
80100179:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010017c:	eb 6b                	jmp    801001e9 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010017e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100181:	8b 40 4c             	mov    0x4c(%eax),%eax
80100184:	85 c0                	test   %eax,%eax
80100186:	75 58                	jne    801001e0 <bget+0xed>
80100188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018b:	8b 00                	mov    (%eax),%eax
8010018d:	83 e0 04             	and    $0x4,%eax
80100190:	85 c0                	test   %eax,%eax
80100192:	75 4c                	jne    801001e0 <bget+0xed>
      b->dev = dev;
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 55 08             	mov    0x8(%ebp),%edx
8010019a:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010019d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801001a3:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
801001a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
801001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	68 00 d0 18 80       	push   $0x8018d000
801001c1:	e8 63 47 00 00       	call   80104929 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 a0 45 00 00       	call   80104778 <acquiresleep>
801001d8:	83 c4 10             	add    $0x10,%esp
      return b;
801001db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001de:	eb 1f                	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e3:	8b 40 50             	mov    0x50(%eax),%eax
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001e9:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
801001f0:	75 8c                	jne    8010017e <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	68 ce a4 10 80       	push   $0x8010a4ce
801001fa:	e8 aa 03 00 00       	call   801005a9 <panic>
}
801001ff:	c9                   	leave  
80100200:	c3                   	ret    

80100201 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100201:	55                   	push   %ebp
80100202:	89 e5                	mov    %esp,%ebp
80100204:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100207:	83 ec 08             	sub    $0x8,%esp
8010020a:	ff 75 0c             	push   0xc(%ebp)
8010020d:	ff 75 08             	push   0x8(%ebp)
80100210:	e8 de fe ff ff       	call   801000f3 <bget>
80100215:	83 c4 10             	add    $0x10,%esp
80100218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
8010021b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010021e:	8b 00                	mov    (%eax),%eax
80100220:	83 e0 02             	and    $0x2,%eax
80100223:	85 c0                	test   %eax,%eax
80100225:	75 0e                	jne    80100235 <bread+0x34>
    iderw(b);
80100227:	83 ec 0c             	sub    $0xc,%esp
8010022a:	ff 75 f4             	push   -0xc(%ebp)
8010022d:	e8 9e a1 00 00       	call   8010a3d0 <iderw>
80100232:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100235:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100238:	c9                   	leave  
80100239:	c3                   	ret    

8010023a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010023a:	55                   	push   %ebp
8010023b:	89 e5                	mov    %esp,%ebp
8010023d:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100240:	8b 45 08             	mov    0x8(%ebp),%eax
80100243:	83 c0 0c             	add    $0xc,%eax
80100246:	83 ec 0c             	sub    $0xc,%esp
80100249:	50                   	push   %eax
8010024a:	e8 db 45 00 00       	call   8010482a <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 df a4 10 80       	push   $0x8010a4df
8010025e:	e8 46 03 00 00       	call   801005a9 <panic>
  b->flags |= B_DIRTY;
80100263:	8b 45 08             	mov    0x8(%ebp),%eax
80100266:	8b 00                	mov    (%eax),%eax
80100268:	83 c8 04             	or     $0x4,%eax
8010026b:	89 c2                	mov    %eax,%edx
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100272:	83 ec 0c             	sub    $0xc,%esp
80100275:	ff 75 08             	push   0x8(%ebp)
80100278:	e8 53 a1 00 00       	call   8010a3d0 <iderw>
8010027d:	83 c4 10             	add    $0x10,%esp
}
80100280:	90                   	nop
80100281:	c9                   	leave  
80100282:	c3                   	ret    

80100283 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100283:	55                   	push   %ebp
80100284:	89 e5                	mov    %esp,%ebp
80100286:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	83 c0 0c             	add    $0xc,%eax
8010028f:	83 ec 0c             	sub    $0xc,%esp
80100292:	50                   	push   %eax
80100293:	e8 92 45 00 00       	call   8010482a <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 e6 a4 10 80       	push   $0x8010a4e6
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 21 45 00 00       	call   801047dc <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 f0 45 00 00       	call   801048bb <acquire>
801002cb:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002ce:	8b 45 08             	mov    0x8(%ebp),%eax
801002d1:	8b 40 4c             	mov    0x4c(%eax),%eax
801002d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801002d7:	8b 45 08             	mov    0x8(%ebp),%eax
801002da:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002dd:	8b 45 08             	mov    0x8(%ebp),%eax
801002e0:	8b 40 4c             	mov    0x4c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	75 47                	jne    8010032e <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002e7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ea:	8b 40 54             	mov    0x54(%eax),%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	8b 52 50             	mov    0x50(%edx),%edx
801002f3:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002f6:	8b 45 08             	mov    0x8(%ebp),%eax
801002f9:	8b 40 50             	mov    0x50(%eax),%eax
801002fc:	8b 55 08             	mov    0x8(%ebp),%edx
801002ff:	8b 52 54             	mov    0x54(%edx),%edx
80100302:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100305:	8b 15 50 17 19 80    	mov    0x80191750,%edx
8010030b:	8b 45 08             	mov    0x8(%ebp),%eax
8010030e:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    bcache.head.next->prev = b;
8010031b:	a1 50 17 19 80       	mov    0x80191750,%eax
80100320:	8b 55 08             	mov    0x8(%ebp),%edx
80100323:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	a3 50 17 19 80       	mov    %eax,0x80191750
  }
  
  release(&bcache.lock);
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 00 d0 18 80       	push   $0x8018d000
80100336:	e8 ee 45 00 00       	call   80104929 <release>
8010033b:	83 c4 10             	add    $0x10,%esp
}
8010033e:	90                   	nop
8010033f:	c9                   	leave  
80100340:	c3                   	ret    

80100341 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100344:	fa                   	cli    
}
80100345:	90                   	nop
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret    

80100348 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010034e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100352:	74 1c                	je     80100370 <printint+0x28>
80100354:	8b 45 08             	mov    0x8(%ebp),%eax
80100357:	c1 e8 1f             	shr    $0x1f,%eax
8010035a:	0f b6 c0             	movzbl %al,%eax
8010035d:	89 45 10             	mov    %eax,0x10(%ebp)
80100360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100364:	74 0a                	je     80100370 <printint+0x28>
    x = -xx;
80100366:	8b 45 08             	mov    0x8(%ebp),%eax
80100369:	f7 d8                	neg    %eax
8010036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036e:	eb 06                	jmp    80100376 <printint+0x2e>
  else
    x = xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010037d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100383:	ba 00 00 00 00       	mov    $0x0,%edx
80100388:	f7 f1                	div    %ecx
8010038a:	89 d1                	mov    %edx,%ecx
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	0f b6 91 04 d0 10 80 	movzbl -0x7fef2ffc(%ecx),%edx
8010039c:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a6:	ba 00 00 00 00       	mov    $0x0,%edx
801003ab:	f7 f1                	div    %ecx
801003ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003b4:	75 c7                	jne    8010037d <printint+0x35>

  if(sign)
801003b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003ba:	74 2a                	je     801003e6 <printint+0x9e>
    buf[i++] = '-';
801003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bf:	8d 50 01             	lea    0x1(%eax),%edx
801003c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003c5:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ca:	eb 1a                	jmp    801003e6 <printint+0x9e>
    consputc(buf[i]);
801003cc:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d2:	01 d0                	add    %edx,%eax
801003d4:	0f b6 00             	movzbl (%eax),%eax
801003d7:	0f be c0             	movsbl %al,%eax
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 8c 03 00 00       	call   8010076f <consputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ee:	79 dc                	jns    801003cc <printint+0x84>
}
801003f0:	90                   	nop
801003f1:	90                   	nop
801003f2:	c9                   	leave  
801003f3:	c3                   	ret    

801003f4 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003f4:	55                   	push   %ebp
801003f5:	89 e5                	mov    %esp,%ebp
801003f7:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003fa:	a1 34 1a 19 80       	mov    0x80191a34,%eax
801003ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100406:	74 10                	je     80100418 <cprintf+0x24>
    acquire(&cons.lock);
80100408:	83 ec 0c             	sub    $0xc,%esp
8010040b:	68 00 1a 19 80       	push   $0x80191a00
80100410:	e8 a6 44 00 00       	call   801048bb <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 ed a4 10 80       	push   $0x8010a4ed
80100427:	e8 7d 01 00 00       	call   801005a9 <panic>


  argp = (uint*)(void*)(&fmt + 1);
8010042c:	8d 45 0c             	lea    0xc(%ebp),%eax
8010042f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100439:	e9 2f 01 00 00       	jmp    8010056d <cprintf+0x179>
    if(c != '%'){
8010043e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100442:	74 13                	je     80100457 <cprintf+0x63>
      consputc(c);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	ff 75 e4             	push   -0x1c(%ebp)
8010044a:	e8 20 03 00 00       	call   8010076f <consputc>
8010044f:	83 c4 10             	add    $0x10,%esp
      continue;
80100452:	e9 12 01 00 00       	jmp    80100569 <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100457:	8b 55 08             	mov    0x8(%ebp),%edx
8010045a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100461:	01 d0                	add    %edx,%eax
80100463:	0f b6 00             	movzbl (%eax),%eax
80100466:	0f be c0             	movsbl %al,%eax
80100469:	25 ff 00 00 00       	and    $0xff,%eax
8010046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100475:	0f 84 14 01 00 00    	je     8010058f <cprintf+0x19b>
      break;
    switch(c){
8010047b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010047f:	74 5e                	je     801004df <cprintf+0xeb>
80100481:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100485:	0f 8f c2 00 00 00    	jg     8010054d <cprintf+0x159>
8010048b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010048f:	74 6b                	je     801004fc <cprintf+0x108>
80100491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100495:	0f 8f b2 00 00 00    	jg     8010054d <cprintf+0x159>
8010049b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010049f:	74 3e                	je     801004df <cprintf+0xeb>
801004a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a5:	0f 8f a2 00 00 00    	jg     8010054d <cprintf+0x159>
801004ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004af:	0f 84 89 00 00 00    	je     8010053e <cprintf+0x14a>
801004b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004b9:	0f 85 8e 00 00 00    	jne    8010054d <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
801004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c2:	8d 50 04             	lea    0x4(%eax),%edx
801004c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c8:	8b 00                	mov    (%eax),%eax
801004ca:	83 ec 04             	sub    $0x4,%esp
801004cd:	6a 01                	push   $0x1
801004cf:	6a 0a                	push   $0xa
801004d1:	50                   	push   %eax
801004d2:	e8 71 fe ff ff       	call   80100348 <printint>
801004d7:	83 c4 10             	add    $0x10,%esp
      break;
801004da:	e9 8a 00 00 00       	jmp    80100569 <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e2:	8d 50 04             	lea    0x4(%eax),%edx
801004e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e8:	8b 00                	mov    (%eax),%eax
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	6a 00                	push   $0x0
801004ef:	6a 10                	push   $0x10
801004f1:	50                   	push   %eax
801004f2:	e8 51 fe ff ff       	call   80100348 <printint>
801004f7:	83 c4 10             	add    $0x10,%esp
      break;
801004fa:	eb 6d                	jmp    80100569 <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ff:	8d 50 04             	lea    0x4(%eax),%edx
80100502:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100505:	8b 00                	mov    (%eax),%eax
80100507:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010050a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010050e:	75 22                	jne    80100532 <cprintf+0x13e>
        s = "(null)";
80100510:	c7 45 ec f6 a4 10 80 	movl   $0x8010a4f6,-0x14(%ebp)
      for(; *s; s++)
80100517:	eb 19                	jmp    80100532 <cprintf+0x13e>
        consputc(*s);
80100519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051c:	0f b6 00             	movzbl (%eax),%eax
8010051f:	0f be c0             	movsbl %al,%eax
80100522:	83 ec 0c             	sub    $0xc,%esp
80100525:	50                   	push   %eax
80100526:	e8 44 02 00 00       	call   8010076f <consputc>
8010052b:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010052e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100535:	0f b6 00             	movzbl (%eax),%eax
80100538:	84 c0                	test   %al,%al
8010053a:	75 dd                	jne    80100519 <cprintf+0x125>
      break;
8010053c:	eb 2b                	jmp    80100569 <cprintf+0x175>
    case '%':
      consputc('%');
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	6a 25                	push   $0x25
80100543:	e8 27 02 00 00       	call   8010076f <consputc>
80100548:	83 c4 10             	add    $0x10,%esp
      break;
8010054b:	eb 1c                	jmp    80100569 <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	6a 25                	push   $0x25
80100552:	e8 18 02 00 00       	call   8010076f <consputc>
80100557:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010055a:	83 ec 0c             	sub    $0xc,%esp
8010055d:	ff 75 e4             	push   -0x1c(%ebp)
80100560:	e8 0a 02 00 00       	call   8010076f <consputc>
80100565:	83 c4 10             	add    $0x10,%esp
      break;
80100568:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010056d:	8b 55 08             	mov    0x8(%ebp),%edx
80100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100573:	01 d0                	add    %edx,%eax
80100575:	0f b6 00             	movzbl (%eax),%eax
80100578:	0f be c0             	movsbl %al,%eax
8010057b:	25 ff 00 00 00       	and    $0xff,%eax
80100580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100587:	0f 85 b1 fe ff ff    	jne    8010043e <cprintf+0x4a>
8010058d:	eb 01                	jmp    80100590 <cprintf+0x19c>
      break;
8010058f:	90                   	nop
    }
  }

  if(locking)
80100590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100594:	74 10                	je     801005a6 <cprintf+0x1b2>
    release(&cons.lock);
80100596:	83 ec 0c             	sub    $0xc,%esp
80100599:	68 00 1a 19 80       	push   $0x80191a00
8010059e:	e8 86 43 00 00       	call   80104929 <release>
801005a3:	83 c4 10             	add    $0x10,%esp
}
801005a6:	90                   	nop
801005a7:	c9                   	leave  
801005a8:	c3                   	ret    

801005a9 <panic>:

void
panic(char *s)
{
801005a9:	55                   	push   %ebp
801005aa:	89 e5                	mov    %esp,%ebp
801005ac:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005af:	e8 8d fd ff ff       	call   80100341 <cli>
  cons.locking = 0;
801005b4:	c7 05 34 1a 19 80 00 	movl   $0x0,0x80191a34
801005bb:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005be:	e8 1c 25 00 00       	call   80102adf <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 fd a4 10 80       	push   $0x8010a4fd
801005cc:	e8 23 fe ff ff       	call   801003f4 <cprintf>
801005d1:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005d4:	8b 45 08             	mov    0x8(%ebp),%eax
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	50                   	push   %eax
801005db:	e8 14 fe ff ff       	call   801003f4 <cprintf>
801005e0:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005e3:	83 ec 0c             	sub    $0xc,%esp
801005e6:	68 11 a5 10 80       	push   $0x8010a511
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 78 43 00 00       	call   8010497b <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 13 a5 10 80       	push   $0x8010a513
8010061f:	e8 d0 fd ff ff       	call   801003f4 <cprintf>
80100624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062f:	7e de                	jle    8010060f <panic+0x66>
  panicked = 1; // freeze other CPU
80100631:	c7 05 ec 19 19 80 01 	movl   $0x1,0x801919ec
80100638:	00 00 00 
  for(;;)
8010063b:	eb fe                	jmp    8010063b <panic+0x92>

8010063d <graphic_putc>:

#define CONSOLE_HORIZONTAL_MAX 53
#define CONSOLE_VERTICAL_MAX 20
int console_pos = CONSOLE_HORIZONTAL_MAX*(CONSOLE_VERTICAL_MAX);
//int console_pos = 0;
void graphic_putc(int c){
8010063d:	55                   	push   %ebp
8010063e:	89 e5                	mov    %esp,%ebp
80100640:	83 ec 18             	sub    $0x18,%esp
  if(c == '\n'){
80100643:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100647:	75 64                	jne    801006ad <graphic_putc+0x70>
    console_pos += CONSOLE_HORIZONTAL_MAX - console_pos%CONSOLE_HORIZONTAL_MAX;
80100649:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
8010064f:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100654:	89 c8                	mov    %ecx,%eax
80100656:	f7 ea                	imul   %edx
80100658:	89 d0                	mov    %edx,%eax
8010065a:	c1 f8 04             	sar    $0x4,%eax
8010065d:	89 ca                	mov    %ecx,%edx
8010065f:	c1 fa 1f             	sar    $0x1f,%edx
80100662:	29 d0                	sub    %edx,%eax
80100664:	6b d0 35             	imul   $0x35,%eax,%edx
80100667:	89 c8                	mov    %ecx,%eax
80100669:	29 d0                	sub    %edx,%eax
8010066b:	ba 35 00 00 00       	mov    $0x35,%edx
80100670:	29 c2                	sub    %eax,%edx
80100672:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100677:	01 d0                	add    %edx,%eax
80100679:	a3 00 d0 10 80       	mov    %eax,0x8010d000
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
8010067e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100683:	3d 23 04 00 00       	cmp    $0x423,%eax
80100688:	0f 8e de 00 00 00    	jle    8010076c <graphic_putc+0x12f>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
8010068e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100693:	83 e8 35             	sub    $0x35,%eax
80100696:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
8010069b:	83 ec 0c             	sub    $0xc,%esp
8010069e:	6a 1e                	push   $0x1e
801006a0:	e8 82 7c 00 00       	call   80108327 <graphic_scroll_up>
801006a5:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
    font_render(x,y,c);
    console_pos++;
  }
}
801006a8:	e9 bf 00 00 00       	jmp    8010076c <graphic_putc+0x12f>
  }else if(c == BACKSPACE){
801006ad:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006b4:	75 1f                	jne    801006d5 <graphic_putc+0x98>
    if(console_pos>0) --console_pos;
801006b6:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006bb:	85 c0                	test   %eax,%eax
801006bd:	0f 8e a9 00 00 00    	jle    8010076c <graphic_putc+0x12f>
801006c3:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006c8:	83 e8 01             	sub    $0x1,%eax
801006cb:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
801006d0:	e9 97 00 00 00       	jmp    8010076c <graphic_putc+0x12f>
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
801006d5:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006da:	3d 23 04 00 00       	cmp    $0x423,%eax
801006df:	7e 1a                	jle    801006fb <graphic_putc+0xbe>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
801006e1:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006e6:	83 e8 35             	sub    $0x35,%eax
801006e9:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
801006ee:	83 ec 0c             	sub    $0xc,%esp
801006f1:	6a 1e                	push   $0x1e
801006f3:	e8 2f 7c 00 00       	call   80108327 <graphic_scroll_up>
801006f8:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
801006fb:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100701:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100706:	89 c8                	mov    %ecx,%eax
80100708:	f7 ea                	imul   %edx
8010070a:	89 d0                	mov    %edx,%eax
8010070c:	c1 f8 04             	sar    $0x4,%eax
8010070f:	89 ca                	mov    %ecx,%edx
80100711:	c1 fa 1f             	sar    $0x1f,%edx
80100714:	29 d0                	sub    %edx,%eax
80100716:	6b d0 35             	imul   $0x35,%eax,%edx
80100719:	89 c8                	mov    %ecx,%eax
8010071b:	29 d0                	sub    %edx,%eax
8010071d:	89 c2                	mov    %eax,%edx
8010071f:	c1 e2 04             	shl    $0x4,%edx
80100722:	29 c2                	sub    %eax,%edx
80100724:	8d 42 02             	lea    0x2(%edx),%eax
80100727:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
8010072a:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100730:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100735:	89 c8                	mov    %ecx,%eax
80100737:	f7 ea                	imul   %edx
80100739:	89 d0                	mov    %edx,%eax
8010073b:	c1 f8 04             	sar    $0x4,%eax
8010073e:	c1 f9 1f             	sar    $0x1f,%ecx
80100741:	89 ca                	mov    %ecx,%edx
80100743:	29 d0                	sub    %edx,%eax
80100745:	6b c0 1e             	imul   $0x1e,%eax,%eax
80100748:	89 45 f0             	mov    %eax,-0x10(%ebp)
    font_render(x,y,c);
8010074b:	83 ec 04             	sub    $0x4,%esp
8010074e:	ff 75 08             	push   0x8(%ebp)
80100751:	ff 75 f0             	push   -0x10(%ebp)
80100754:	ff 75 f4             	push   -0xc(%ebp)
80100757:	e8 36 7c 00 00       	call   80108392 <font_render>
8010075c:	83 c4 10             	add    $0x10,%esp
    console_pos++;
8010075f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100764:	83 c0 01             	add    $0x1,%eax
80100767:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
8010076c:	90                   	nop
8010076d:	c9                   	leave  
8010076e:	c3                   	ret    

8010076f <consputc>:


void
consputc(int c)
{
8010076f:	55                   	push   %ebp
80100770:	89 e5                	mov    %esp,%ebp
80100772:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100775:	a1 ec 19 19 80       	mov    0x801919ec,%eax
8010077a:	85 c0                	test   %eax,%eax
8010077c:	74 07                	je     80100785 <consputc+0x16>
    cli();
8010077e:	e8 be fb ff ff       	call   80100341 <cli>
    for(;;)
80100783:	eb fe                	jmp    80100783 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
80100785:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010078c:	75 29                	jne    801007b7 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078e:	83 ec 0c             	sub    $0xc,%esp
80100791:	6a 08                	push   $0x8
80100793:	e8 3b 5f 00 00       	call   801066d3 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 2e 5f 00 00       	call   801066d3 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 21 5f 00 00       	call   801066d3 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 11 5f 00 00       	call   801066d3 <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
  }
  graphic_putc(c);
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	ff 75 08             	push   0x8(%ebp)
801007cb:	e8 6d fe ff ff       	call   8010063d <graphic_putc>
801007d0:	83 c4 10             	add    $0x10,%esp
}
801007d3:	90                   	nop
801007d4:	c9                   	leave  
801007d5:	c3                   	ret    

801007d6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d6:	55                   	push   %ebp
801007d7:	89 e5                	mov    %esp,%ebp
801007d9:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 00 1a 19 80       	push   $0x80191a00
801007eb:	e8 cb 40 00 00       	call   801048bb <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 50 01 00 00       	jmp    80100948 <consoleintr+0x172>
    switch(c){
801007f8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801007fc:	0f 84 81 00 00 00    	je     80100883 <consoleintr+0xad>
80100802:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100806:	0f 8f ac 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010080c:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100810:	74 43                	je     80100855 <consoleintr+0x7f>
80100812:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100816:	0f 8f 9c 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010081c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100820:	74 61                	je     80100883 <consoleintr+0xad>
80100822:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100826:	0f 85 8c 00 00 00    	jne    801008b8 <consoleintr+0xe2>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100833:	e9 10 01 00 00       	jmp    80100948 <consoleintr+0x172>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100838:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010083d:	83 e8 01             	sub    $0x1,%eax
80100840:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
80100845:	83 ec 0c             	sub    $0xc,%esp
80100848:	68 00 01 00 00       	push   $0x100
8010084d:	e8 1d ff ff ff       	call   8010076f <consputc>
80100852:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100855:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
8010085b:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	0f 84 e0 00 00 00    	je     80100948 <consoleintr+0x172>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100868:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	83 e0 7f             	and    $0x7f,%eax
80100873:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
      while(input.e != input.w &&
8010087a:	3c 0a                	cmp    $0xa,%al
8010087c:	75 ba                	jne    80100838 <consoleintr+0x62>
      }
      break;
8010087e:	e9 c5 00 00 00       	jmp    80100948 <consoleintr+0x172>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100883:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100889:	a1 e4 19 19 80       	mov    0x801919e4,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 b2 00 00 00    	je     80100948 <consoleintr+0x172>
        input.e--;
80100896:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 00 01 00 00       	push   $0x100
801008ab:	e8 bf fe ff ff       	call   8010076f <consputc>
801008b0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008b3:	e9 90 00 00 00       	jmp    80100948 <consoleintr+0x172>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 85 00 00 00    	je     80100947 <consoleintr+0x171>
801008c2:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008c7:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801008cd:	29 d0                	sub    %edx,%eax
801008cf:	83 f8 7f             	cmp    $0x7f,%eax
801008d2:	77 73                	ja     80100947 <consoleintr+0x171>
        c = (c == '\r') ? '\n' : c;
801008d4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d8:	74 05                	je     801008df <consoleintr+0x109>
801008da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008dd:	eb 05                	jmp    801008e4 <consoleintr+0x10e>
801008df:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e7:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008ec:	8d 50 01             	lea    0x1(%eax),%edx
801008ef:	89 15 e8 19 19 80    	mov    %edx,0x801919e8
801008f5:	83 e0 7f             	and    $0x7f,%eax
801008f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008fb:	88 90 60 19 19 80    	mov    %dl,-0x7fe6e6a0(%eax)
        consputc(c);
80100901:	83 ec 0c             	sub    $0xc,%esp
80100904:	ff 75 f0             	push   -0x10(%ebp)
80100907:	e8 63 fe ff ff       	call   8010076f <consputc>
8010090c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010090f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100913:	74 18                	je     8010092d <consoleintr+0x157>
80100915:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100919:	74 12                	je     8010092d <consoleintr+0x157>
8010091b:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100920:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
80100926:	83 ea 80             	sub    $0xffffff80,%edx
80100929:	39 d0                	cmp    %edx,%eax
8010092b:	75 1a                	jne    80100947 <consoleintr+0x171>
          input.w = input.e;
8010092d:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100932:	a3 e4 19 19 80       	mov    %eax,0x801919e4
          wakeup(&input.r);
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 e0 19 19 80       	push   $0x801919e0
8010093f:	e8 fb 3a 00 00       	call   8010443f <wakeup>
80100944:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100947:	90                   	nop
  while((c = getc()) >= 0){
80100948:	8b 45 08             	mov    0x8(%ebp),%eax
8010094b:	ff d0                	call   *%eax
8010094d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100950:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100954:	0f 89 9e fe ff ff    	jns    801007f8 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
8010095a:	83 ec 0c             	sub    $0xc,%esp
8010095d:	68 00 1a 19 80       	push   $0x80191a00
80100962:	e8 c2 3f 00 00       	call   80104929 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 85 3b 00 00       	call   801044fa <procdump>
  }
}
80100975:	90                   	nop
80100976:	c9                   	leave  
80100977:	c3                   	ret    

80100978 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100978:	55                   	push   %ebp
80100979:	89 e5                	mov    %esp,%ebp
8010097b:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010097e:	83 ec 0c             	sub    $0xc,%esp
80100981:	ff 75 08             	push   0x8(%ebp)
80100984:	e8 59 11 00 00       	call   80101ae2 <iunlock>
80100989:	83 c4 10             	add    $0x10,%esp
  target = n;
8010098c:	8b 45 10             	mov    0x10(%ebp),%eax
8010098f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100992:	83 ec 0c             	sub    $0xc,%esp
80100995:	68 00 1a 19 80       	push   $0x80191a00
8010099a:	e8 1c 3f 00 00       	call   801048bb <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009a7:	e8 69 30 00 00       	call   80103a15 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
        release(&cons.lock);
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 1a 19 80       	push   $0x80191a00
801009bb:	e8 69 3f 00 00       	call   80104929 <release>
801009c0:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009c3:	83 ec 0c             	sub    $0xc,%esp
801009c6:	ff 75 08             	push   0x8(%ebp)
801009c9:	e8 01 10 00 00       	call   801019cf <ilock>
801009ce:	83 c4 10             	add    $0x10,%esp
        return -1;
801009d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009d6:	e9 a9 00 00 00       	jmp    80100a84 <consoleread+0x10c>
      }
      sleep(&input.r, &cons.lock);
801009db:	83 ec 08             	sub    $0x8,%esp
801009de:	68 00 1a 19 80       	push   $0x80191a00
801009e3:	68 e0 19 19 80       	push   $0x801919e0
801009e8:	e8 6b 39 00 00       	call   80104358 <sleep>
801009ed:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
801009f0:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801009f6:	a1 e4 19 19 80       	mov    0x801919e4,%eax
801009fb:	39 c2                	cmp    %eax,%edx
801009fd:	74 a8                	je     801009a7 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ff:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a04:	8d 50 01             	lea    0x1(%eax),%edx
80100a07:	89 15 e0 19 19 80    	mov    %edx,0x801919e0
80100a0d:	83 e0 7f             	and    $0x7f,%eax
80100a10:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
80100a17:	0f be c0             	movsbl %al,%eax
80100a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a1d:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a21:	75 17                	jne    80100a3a <consoleread+0xc2>
      if(n < target){
80100a23:	8b 45 10             	mov    0x10(%ebp),%eax
80100a26:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a29:	76 2f                	jbe    80100a5a <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a2b:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a30:	83 e8 01             	sub    $0x1,%eax
80100a33:	a3 e0 19 19 80       	mov    %eax,0x801919e0
      }
      break;
80100a38:	eb 20                	jmp    80100a5a <consoleread+0xe2>
    }
    *dst++ = c;
80100a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a3d:	8d 50 01             	lea    0x1(%eax),%edx
80100a40:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a46:	88 10                	mov    %dl,(%eax)
    --n;
80100a48:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a4c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a50:	74 0b                	je     80100a5d <consoleread+0xe5>
  while(n > 0){
80100a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a56:	7f 98                	jg     801009f0 <consoleread+0x78>
80100a58:	eb 04                	jmp    80100a5e <consoleread+0xe6>
      break;
80100a5a:	90                   	nop
80100a5b:	eb 01                	jmp    80100a5e <consoleread+0xe6>
      break;
80100a5d:	90                   	nop
  }
  release(&cons.lock);
80100a5e:	83 ec 0c             	sub    $0xc,%esp
80100a61:	68 00 1a 19 80       	push   $0x80191a00
80100a66:	e8 be 3e 00 00       	call   80104929 <release>
80100a6b:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	ff 75 08             	push   0x8(%ebp)
80100a74:	e8 56 0f 00 00       	call   801019cf <ilock>
80100a79:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a7c:	8b 55 10             	mov    0x10(%ebp),%edx
80100a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a82:	29 d0                	sub    %edx,%eax
}
80100a84:	c9                   	leave  
80100a85:	c3                   	ret    

80100a86 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a86:	55                   	push   %ebp
80100a87:	89 e5                	mov    %esp,%ebp
80100a89:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	push   0x8(%ebp)
80100a92:	e8 4b 10 00 00       	call   80101ae2 <iunlock>
80100a97:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a9a:	83 ec 0c             	sub    $0xc,%esp
80100a9d:	68 00 1a 19 80       	push   $0x80191a00
80100aa2:	e8 14 3e 00 00       	call   801048bb <acquire>
80100aa7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ab1:	eb 21                	jmp    80100ad4 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab9:	01 d0                	add    %edx,%eax
80100abb:	0f b6 00             	movzbl (%eax),%eax
80100abe:	0f be c0             	movsbl %al,%eax
80100ac1:	0f b6 c0             	movzbl %al,%eax
80100ac4:	83 ec 0c             	sub    $0xc,%esp
80100ac7:	50                   	push   %eax
80100ac8:	e8 a2 fc ff ff       	call   8010076f <consputc>
80100acd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ad0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ad7:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ada:	7c d7                	jl     80100ab3 <consolewrite+0x2d>
  release(&cons.lock);
80100adc:	83 ec 0c             	sub    $0xc,%esp
80100adf:	68 00 1a 19 80       	push   $0x80191a00
80100ae4:	e8 40 3e 00 00       	call   80104929 <release>
80100ae9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aec:	83 ec 0c             	sub    $0xc,%esp
80100aef:	ff 75 08             	push   0x8(%ebp)
80100af2:	e8 d8 0e 00 00       	call   801019cf <ilock>
80100af7:	83 c4 10             	add    $0x10,%esp

  return n;
80100afa:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100afd:	c9                   	leave  
80100afe:	c3                   	ret    

80100aff <consoleinit>:

void
consoleinit(void)
{
80100aff:	55                   	push   %ebp
80100b00:	89 e5                	mov    %esp,%ebp
80100b02:	83 ec 18             	sub    $0x18,%esp
  panicked = 0;
80100b05:	c7 05 ec 19 19 80 00 	movl   $0x0,0x801919ec
80100b0c:	00 00 00 
  initlock(&cons.lock, "console");
80100b0f:	83 ec 08             	sub    $0x8,%esp
80100b12:	68 17 a5 10 80       	push   $0x8010a517
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 78 3d 00 00       	call   80104899 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 1f a5 10 80 	movl   $0x8010a51f,-0xc(%ebp)
80100b3f:	eb 19                	jmp    80100b5a <consoleinit+0x5b>
    graphic_putc(*p);
80100b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b44:	0f b6 00             	movzbl (%eax),%eax
80100b47:	0f be c0             	movsbl %al,%eax
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	50                   	push   %eax
80100b4e:	e8 ea fa ff ff       	call   8010063d <graphic_putc>
80100b53:	83 c4 10             	add    $0x10,%esp
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b5d:	0f b6 00             	movzbl (%eax),%eax
80100b60:	84 c0                	test   %al,%al
80100b62:	75 dd                	jne    80100b41 <consoleinit+0x42>
  
  cons.locking = 1;
80100b64:	c7 05 34 1a 19 80 01 	movl   $0x1,0x80191a34
80100b6b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b6e:	83 ec 08             	sub    $0x8,%esp
80100b71:	6a 00                	push   $0x0
80100b73:	6a 01                	push   $0x1
80100b75:	e8 99 1a 00 00       	call   80102613 <ioapicenable>
80100b7a:	83 c4 10             	add    $0x10,%esp
}
80100b7d:	90                   	nop
80100b7e:	c9                   	leave  
80100b7f:	c3                   	ret    

80100b80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b89:	e8 87 2e 00 00       	call   80103a15 <myproc>
80100b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b91:	e8 8b 24 00 00       	call   80103021 <begin_op>

  if((ip = namei(path)) == 0){
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	ff 75 08             	push   0x8(%ebp)
80100b9c:	e8 61 19 00 00       	call   80102502 <namei>
80100ba1:	83 c4 10             	add    $0x10,%esp
80100ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ba7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bab:	75 1f                	jne    80100bcc <exec+0x4c>
    end_op();
80100bad:	e8 fb 24 00 00       	call   801030ad <end_op>
    cprintf("exec: fail\n");
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	68 35 a5 10 80       	push   $0x8010a535
80100bba:	e8 35 f8 ff ff       	call   801003f4 <cprintf>
80100bbf:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 d6 03 00 00       	jmp    80100fa2 <exec+0x422>
  }
  ilock(ip);
80100bcc:	83 ec 0c             	sub    $0xc,%esp
80100bcf:	ff 75 d8             	push   -0x28(%ebp)
80100bd2:	e8 f8 0d 00 00       	call   801019cf <ilock>
80100bd7:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bda:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100be1:	6a 34                	push   $0x34
80100be3:	6a 00                	push   $0x0
80100be5:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100beb:	50                   	push   %eax
80100bec:	ff 75 d8             	push   -0x28(%ebp)
80100bef:	e8 c7 12 00 00       	call   80101ebb <readi>
80100bf4:	83 c4 10             	add    $0x10,%esp
80100bf7:	83 f8 34             	cmp    $0x34,%eax
80100bfa:	0f 85 4b 03 00 00    	jne    80100f4b <exec+0x3cb>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c00:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c06:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c0b:	0f 85 3d 03 00 00    	jne    80100f4e <exec+0x3ce>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c11:	e8 b9 6a 00 00       	call   801076cf <setupkvm>
80100c16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c1d:	0f 84 2e 03 00 00    	je     80100f51 <exec+0x3d1>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c31:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c3a:	e9 de 00 00 00       	jmp    80100d1d <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c42:	6a 20                	push   $0x20
80100c44:	50                   	push   %eax
80100c45:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c4b:	50                   	push   %eax
80100c4c:	ff 75 d8             	push   -0x28(%ebp)
80100c4f:	e8 67 12 00 00       	call   80101ebb <readi>
80100c54:	83 c4 10             	add    $0x10,%esp
80100c57:	83 f8 20             	cmp    $0x20,%eax
80100c5a:	0f 85 f4 02 00 00    	jne    80100f54 <exec+0x3d4>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c60:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c66:	83 f8 01             	cmp    $0x1,%eax
80100c69:	0f 85 a0 00 00 00    	jne    80100d0f <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c6f:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c75:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c7b:	39 c2                	cmp    %eax,%edx
80100c7d:	0f 82 d4 02 00 00    	jb     80100f57 <exec+0x3d7>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c83:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c89:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c8f:	01 c2                	add    %eax,%edx
80100c91:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c97:	39 c2                	cmp    %eax,%edx
80100c99:	0f 82 bb 02 00 00    	jb     80100f5a <exec+0x3da>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c9f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca5:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cab:	01 d0                	add    %edx,%eax
80100cad:	83 ec 04             	sub    $0x4,%esp
80100cb0:	50                   	push   %eax
80100cb1:	ff 75 e0             	push   -0x20(%ebp)
80100cb4:	ff 75 d4             	push   -0x2c(%ebp)
80100cb7:	e8 0c 6e 00 00       	call   80107ac8 <allocuvm>
80100cbc:	83 c4 10             	add    $0x10,%esp
80100cbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cc6:	0f 84 91 02 00 00    	je     80100f5d <exec+0x3dd>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ccc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cd2:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cd7:	85 c0                	test   %eax,%eax
80100cd9:	0f 85 81 02 00 00    	jne    80100f60 <exec+0x3e0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cdf:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100ce5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ceb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cf1:	83 ec 0c             	sub    $0xc,%esp
80100cf4:	52                   	push   %edx
80100cf5:	50                   	push   %eax
80100cf6:	ff 75 d8             	push   -0x28(%ebp)
80100cf9:	51                   	push   %ecx
80100cfa:	ff 75 d4             	push   -0x2c(%ebp)
80100cfd:	e8 f9 6c 00 00       	call   801079fb <loaduvm>
80100d02:	83 c4 20             	add    $0x20,%esp
80100d05:	85 c0                	test   %eax,%eax
80100d07:	0f 88 56 02 00 00    	js     80100f63 <exec+0x3e3>
80100d0d:	eb 01                	jmp    80100d10 <exec+0x190>
      continue;
80100d0f:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d10:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d17:	83 c0 20             	add    $0x20,%eax
80100d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d1d:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d24:	0f b7 c0             	movzwl %ax,%eax
80100d27:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d2a:	0f 8c 0f ff ff ff    	jl     80100c3f <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d30:	83 ec 0c             	sub    $0xc,%esp
80100d33:	ff 75 d8             	push   -0x28(%ebp)
80100d36:	e8 c5 0e 00 00       	call   80101c00 <iunlockput>
80100d3b:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d3e:	e8 6a 23 00 00       	call   801030ad <end_op>
  ip = 0;
80100d43:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d57:	89 45 e0             	mov    %eax,-0x20(%ebp)
  sp = KERNBASE-1;
80100d5a:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
  if((allocuvm(pgdir, sp - PGSIZE, sp)) == 0)
80100d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d64:	2d 00 10 00 00       	sub    $0x1000,%eax
80100d69:	83 ec 04             	sub    $0x4,%esp
80100d6c:	ff 75 dc             	push   -0x24(%ebp)
80100d6f:	50                   	push   %eax
80100d70:	ff 75 d4             	push   -0x2c(%ebp)
80100d73:	e8 50 6d 00 00       	call   80107ac8 <allocuvm>
80100d78:	83 c4 10             	add    $0x10,%esp
80100d7b:	85 c0                	test   %eax,%eax
80100d7d:	0f 84 e3 01 00 00    	je     80100f66 <exec+0x3e6>
    goto bad;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d8a:	e9 96 00 00 00       	jmp    80100e25 <exec+0x2a5>
    if(argc >= MAXARG)
80100d8f:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d93:	0f 87 d0 01 00 00    	ja     80100f69 <exec+0x3e9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da6:	01 d0                	add    %edx,%eax
80100da8:	8b 00                	mov    (%eax),%eax
80100daa:	83 ec 0c             	sub    $0xc,%esp
80100dad:	50                   	push   %eax
80100dae:	e8 cc 3f 00 00       	call   80104d7f <strlen>
80100db3:	83 c4 10             	add    $0x10,%esp
80100db6:	89 c2                	mov    %eax,%edx
80100db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dbb:	29 d0                	sub    %edx,%eax
80100dbd:	83 e8 01             	sub    $0x1,%eax
80100dc0:	83 e0 fc             	and    $0xfffffffc,%eax
80100dc3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd3:	01 d0                	add    %edx,%eax
80100dd5:	8b 00                	mov    (%eax),%eax
80100dd7:	83 ec 0c             	sub    $0xc,%esp
80100dda:	50                   	push   %eax
80100ddb:	e8 9f 3f 00 00       	call   80104d7f <strlen>
80100de0:	83 c4 10             	add    $0x10,%esp
80100de3:	83 c0 01             	add    $0x1,%eax
80100de6:	89 c2                	mov    %eax,%edx
80100de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100deb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df5:	01 c8                	add    %ecx,%eax
80100df7:	8b 00                	mov    (%eax),%eax
80100df9:	52                   	push   %edx
80100dfa:	50                   	push   %eax
80100dfb:	ff 75 dc             	push   -0x24(%ebp)
80100dfe:	ff 75 d4             	push   -0x2c(%ebp)
80100e01:	e8 8e 71 00 00       	call   80107f94 <copyout>
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	85 c0                	test   %eax,%eax
80100e0b:	0f 88 5b 01 00 00    	js     80100f6c <exec+0x3ec>
      goto bad;
    ustack[3+argc] = sp;
80100e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e14:	8d 50 03             	lea    0x3(%eax),%edx
80100e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1a:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e21:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e32:	01 d0                	add    %edx,%eax
80100e34:	8b 00                	mov    (%eax),%eax
80100e36:	85 c0                	test   %eax,%eax
80100e38:	0f 85 51 ff ff ff    	jne    80100d8f <exec+0x20f>
  }
  ustack[3+argc] = 0;
80100e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e41:	83 c0 03             	add    $0x3,%eax
80100e44:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e4b:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e4f:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e56:	ff ff ff 
  ustack[1] = argc;
80100e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e65:	83 c0 01             	add    $0x1,%eax
80100e68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e72:	29 d0                	sub    %edx,%eax
80100e74:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e7d:	83 c0 04             	add    $0x4,%eax
80100e80:	c1 e0 02             	shl    $0x2,%eax
80100e83:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e89:	83 c0 04             	add    $0x4,%eax
80100e8c:	c1 e0 02             	shl    $0x2,%eax
80100e8f:	50                   	push   %eax
80100e90:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e96:	50                   	push   %eax
80100e97:	ff 75 dc             	push   -0x24(%ebp)
80100e9a:	ff 75 d4             	push   -0x2c(%ebp)
80100e9d:	e8 f2 70 00 00       	call   80107f94 <copyout>
80100ea2:	83 c4 10             	add    $0x10,%esp
80100ea5:	85 c0                	test   %eax,%eax
80100ea7:	0f 88 c2 00 00 00    	js     80100f6f <exec+0x3ef>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ead:	8b 45 08             	mov    0x8(%ebp),%eax
80100eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eb9:	eb 17                	jmp    80100ed2 <exec+0x352>
    if(*s == '/')
80100ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ebe:	0f b6 00             	movzbl (%eax),%eax
80100ec1:	3c 2f                	cmp    $0x2f,%al
80100ec3:	75 09                	jne    80100ece <exec+0x34e>
      last = s+1;
80100ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec8:	83 c0 01             	add    $0x1,%eax
80100ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ece:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed5:	0f b6 00             	movzbl (%eax),%eax
80100ed8:	84 c0                	test   %al,%al
80100eda:	75 df                	jne    80100ebb <exec+0x33b>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100edc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100edf:	83 c0 6c             	add    $0x6c,%eax
80100ee2:	83 ec 04             	sub    $0x4,%esp
80100ee5:	6a 10                	push   $0x10
80100ee7:	ff 75 f0             	push   -0x10(%ebp)
80100eea:	50                   	push   %eax
80100eeb:	e8 44 3e 00 00       	call   80104d34 <safestrcpy>
80100ef0:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ef3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ef6:	8b 40 04             	mov    0x4(%eax),%eax
80100ef9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100efc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f02:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f05:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f0b:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f10:	8b 40 18             	mov    0x18(%eax),%eax
80100f13:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f19:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f1f:	8b 40 18             	mov    0x18(%eax),%eax
80100f22:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f25:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	ff 75 d0             	push   -0x30(%ebp)
80100f2e:	e8 b9 68 00 00       	call   801077ec <switchuvm>
80100f33:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	ff 75 cc             	push   -0x34(%ebp)
80100f3c:	e8 50 6d 00 00       	call   80107c91 <freevm>
80100f41:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f44:	b8 00 00 00 00       	mov    $0x0,%eax
80100f49:	eb 57                	jmp    80100fa2 <exec+0x422>
    goto bad;
80100f4b:	90                   	nop
80100f4c:	eb 22                	jmp    80100f70 <exec+0x3f0>
    goto bad;
80100f4e:	90                   	nop
80100f4f:	eb 1f                	jmp    80100f70 <exec+0x3f0>
    goto bad;
80100f51:	90                   	nop
80100f52:	eb 1c                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f54:	90                   	nop
80100f55:	eb 19                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f57:	90                   	nop
80100f58:	eb 16                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f5a:	90                   	nop
80100f5b:	eb 13                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f5d:	90                   	nop
80100f5e:	eb 10                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f60:	90                   	nop
80100f61:	eb 0d                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f63:	90                   	nop
80100f64:	eb 0a                	jmp    80100f70 <exec+0x3f0>
    goto bad;
80100f66:	90                   	nop
80100f67:	eb 07                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f69:	90                   	nop
80100f6a:	eb 04                	jmp    80100f70 <exec+0x3f0>
      goto bad;
80100f6c:	90                   	nop
80100f6d:	eb 01                	jmp    80100f70 <exec+0x3f0>
    goto bad;
80100f6f:	90                   	nop

 bad:
  if(pgdir)
80100f70:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f74:	74 0e                	je     80100f84 <exec+0x404>
    freevm(pgdir);
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	ff 75 d4             	push   -0x2c(%ebp)
80100f7c:	e8 10 6d 00 00       	call   80107c91 <freevm>
80100f81:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f84:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f88:	74 13                	je     80100f9d <exec+0x41d>
    iunlockput(ip);
80100f8a:	83 ec 0c             	sub    $0xc,%esp
80100f8d:	ff 75 d8             	push   -0x28(%ebp)
80100f90:	e8 6b 0c 00 00       	call   80101c00 <iunlockput>
80100f95:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f98:	e8 10 21 00 00       	call   801030ad <end_op>
  }
  return -1;
80100f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fa2:	c9                   	leave  
80100fa3:	c3                   	ret    

80100fa4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100faa:	83 ec 08             	sub    $0x8,%esp
80100fad:	68 41 a5 10 80       	push   $0x8010a541
80100fb2:	68 a0 1a 19 80       	push   $0x80191aa0
80100fb7:	e8 dd 38 00 00       	call   80104899 <initlock>
80100fbc:	83 c4 10             	add    $0x10,%esp
}
80100fbf:	90                   	nop
80100fc0:	c9                   	leave  
80100fc1:	c3                   	ret    

80100fc2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fc2:	55                   	push   %ebp
80100fc3:	89 e5                	mov    %esp,%ebp
80100fc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	68 a0 1a 19 80       	push   $0x80191aa0
80100fd0:	e8 e6 38 00 00       	call   801048bb <acquire>
80100fd5:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd8:	c7 45 f4 d4 1a 19 80 	movl   $0x80191ad4,-0xc(%ebp)
80100fdf:	eb 2d                	jmp    8010100e <filealloc+0x4c>
    if(f->ref == 0){
80100fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe4:	8b 40 04             	mov    0x4(%eax),%eax
80100fe7:	85 c0                	test   %eax,%eax
80100fe9:	75 1f                	jne    8010100a <filealloc+0x48>
      f->ref = 1;
80100feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fee:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100ff5:	83 ec 0c             	sub    $0xc,%esp
80100ff8:	68 a0 1a 19 80       	push   $0x80191aa0
80100ffd:	e8 27 39 00 00       	call   80104929 <release>
80101002:	83 c4 10             	add    $0x10,%esp
      return f;
80101005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101008:	eb 23                	jmp    8010102d <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010100a:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010100e:	b8 34 24 19 80       	mov    $0x80192434,%eax
80101013:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101016:	72 c9                	jb     80100fe1 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	68 a0 1a 19 80       	push   $0x80191aa0
80101020:	e8 04 39 00 00       	call   80104929 <release>
80101025:	83 c4 10             	add    $0x10,%esp
  return 0;
80101028:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010102d:	c9                   	leave  
8010102e:	c3                   	ret    

8010102f <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010102f:	55                   	push   %ebp
80101030:	89 e5                	mov    %esp,%ebp
80101032:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101035:	83 ec 0c             	sub    $0xc,%esp
80101038:	68 a0 1a 19 80       	push   $0x80191aa0
8010103d:	e8 79 38 00 00       	call   801048bb <acquire>
80101042:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	8b 40 04             	mov    0x4(%eax),%eax
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 0d                	jg     8010105c <filedup+0x2d>
    panic("filedup");
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	68 48 a5 10 80       	push   $0x8010a548
80101057:	e8 4d f5 ff ff       	call   801005a9 <panic>
  f->ref++;
8010105c:	8b 45 08             	mov    0x8(%ebp),%eax
8010105f:	8b 40 04             	mov    0x4(%eax),%eax
80101062:	8d 50 01             	lea    0x1(%eax),%edx
80101065:	8b 45 08             	mov    0x8(%ebp),%eax
80101068:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	68 a0 1a 19 80       	push   $0x80191aa0
80101073:	e8 b1 38 00 00       	call   80104929 <release>
80101078:	83 c4 10             	add    $0x10,%esp
  return f;
8010107b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010107e:	c9                   	leave  
8010107f:	c3                   	ret    

80101080 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	68 a0 1a 19 80       	push   $0x80191aa0
8010108e:	e8 28 38 00 00       	call   801048bb <acquire>
80101093:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	8b 40 04             	mov    0x4(%eax),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	7f 0d                	jg     801010ad <fileclose+0x2d>
    panic("fileclose");
801010a0:	83 ec 0c             	sub    $0xc,%esp
801010a3:	68 50 a5 10 80       	push   $0x8010a550
801010a8:	e8 fc f4 ff ff       	call   801005a9 <panic>
  if(--f->ref > 0){
801010ad:	8b 45 08             	mov    0x8(%ebp),%eax
801010b0:	8b 40 04             	mov    0x4(%eax),%eax
801010b3:	8d 50 ff             	lea    -0x1(%eax),%edx
801010b6:	8b 45 08             	mov    0x8(%ebp),%eax
801010b9:	89 50 04             	mov    %edx,0x4(%eax)
801010bc:	8b 45 08             	mov    0x8(%ebp),%eax
801010bf:	8b 40 04             	mov    0x4(%eax),%eax
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7e 15                	jle    801010db <fileclose+0x5b>
    release(&ftable.lock);
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	68 a0 1a 19 80       	push   $0x80191aa0
801010ce:	e8 56 38 00 00       	call   80104929 <release>
801010d3:	83 c4 10             	add    $0x10,%esp
801010d6:	e9 8b 00 00 00       	jmp    80101166 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	8b 10                	mov    (%eax),%edx
801010e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010e3:	8b 50 04             	mov    0x4(%eax),%edx
801010e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010e9:	8b 50 08             	mov    0x8(%eax),%edx
801010ec:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010ef:	8b 50 0c             	mov    0xc(%eax),%edx
801010f2:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010f5:	8b 50 10             	mov    0x10(%eax),%edx
801010f8:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010fb:	8b 40 14             	mov    0x14(%eax),%eax
801010fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101101:	8b 45 08             	mov    0x8(%ebp),%eax
80101104:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010110b:	8b 45 08             	mov    0x8(%ebp),%eax
8010110e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101114:	83 ec 0c             	sub    $0xc,%esp
80101117:	68 a0 1a 19 80       	push   $0x80191aa0
8010111c:	e8 08 38 00 00       	call   80104929 <release>
80101121:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101124:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101127:	83 f8 01             	cmp    $0x1,%eax
8010112a:	75 19                	jne    80101145 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010112c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101130:	0f be d0             	movsbl %al,%edx
80101133:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101136:	83 ec 08             	sub    $0x8,%esp
80101139:	52                   	push   %edx
8010113a:	50                   	push   %eax
8010113b:	e8 64 25 00 00       	call   801036a4 <pipeclose>
80101140:	83 c4 10             	add    $0x10,%esp
80101143:	eb 21                	jmp    80101166 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101145:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101148:	83 f8 02             	cmp    $0x2,%eax
8010114b:	75 19                	jne    80101166 <fileclose+0xe6>
    begin_op();
8010114d:	e8 cf 1e 00 00       	call   80103021 <begin_op>
    iput(ff.ip);
80101152:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101155:	83 ec 0c             	sub    $0xc,%esp
80101158:	50                   	push   %eax
80101159:	e8 d2 09 00 00       	call   80101b30 <iput>
8010115e:	83 c4 10             	add    $0x10,%esp
    end_op();
80101161:	e8 47 1f 00 00       	call   801030ad <end_op>
  }
}
80101166:	c9                   	leave  
80101167:	c3                   	ret    

80101168 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101168:	55                   	push   %ebp
80101169:	89 e5                	mov    %esp,%ebp
8010116b:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010116e:	8b 45 08             	mov    0x8(%ebp),%eax
80101171:	8b 00                	mov    (%eax),%eax
80101173:	83 f8 02             	cmp    $0x2,%eax
80101176:	75 40                	jne    801011b8 <filestat+0x50>
    ilock(f->ip);
80101178:	8b 45 08             	mov    0x8(%ebp),%eax
8010117b:	8b 40 10             	mov    0x10(%eax),%eax
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	50                   	push   %eax
80101182:	e8 48 08 00 00       	call   801019cf <ilock>
80101187:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010118a:	8b 45 08             	mov    0x8(%ebp),%eax
8010118d:	8b 40 10             	mov    0x10(%eax),%eax
80101190:	83 ec 08             	sub    $0x8,%esp
80101193:	ff 75 0c             	push   0xc(%ebp)
80101196:	50                   	push   %eax
80101197:	e8 d9 0c 00 00       	call   80101e75 <stati>
8010119c:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 40 10             	mov    0x10(%eax),%eax
801011a5:	83 ec 0c             	sub    $0xc,%esp
801011a8:	50                   	push   %eax
801011a9:	e8 34 09 00 00       	call   80101ae2 <iunlock>
801011ae:	83 c4 10             	add    $0x10,%esp
    return 0;
801011b1:	b8 00 00 00 00       	mov    $0x0,%eax
801011b6:	eb 05                	jmp    801011bd <filestat+0x55>
  }
  return -1;
801011b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011bd:	c9                   	leave  
801011be:	c3                   	ret    

801011bf <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011bf:	55                   	push   %ebp
801011c0:	89 e5                	mov    %esp,%ebp
801011c2:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011c5:	8b 45 08             	mov    0x8(%ebp),%eax
801011c8:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011cc:	84 c0                	test   %al,%al
801011ce:	75 0a                	jne    801011da <fileread+0x1b>
    return -1;
801011d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d5:	e9 9b 00 00 00       	jmp    80101275 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 00                	mov    (%eax),%eax
801011df:	83 f8 01             	cmp    $0x1,%eax
801011e2:	75 1a                	jne    801011fe <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011e4:	8b 45 08             	mov    0x8(%ebp),%eax
801011e7:	8b 40 0c             	mov    0xc(%eax),%eax
801011ea:	83 ec 04             	sub    $0x4,%esp
801011ed:	ff 75 10             	push   0x10(%ebp)
801011f0:	ff 75 0c             	push   0xc(%ebp)
801011f3:	50                   	push   %eax
801011f4:	e8 58 26 00 00       	call   80103851 <piperead>
801011f9:	83 c4 10             	add    $0x10,%esp
801011fc:	eb 77                	jmp    80101275 <fileread+0xb6>
  if(f->type == FD_INODE){
801011fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101201:	8b 00                	mov    (%eax),%eax
80101203:	83 f8 02             	cmp    $0x2,%eax
80101206:	75 60                	jne    80101268 <fileread+0xa9>
    ilock(f->ip);
80101208:	8b 45 08             	mov    0x8(%ebp),%eax
8010120b:	8b 40 10             	mov    0x10(%eax),%eax
8010120e:	83 ec 0c             	sub    $0xc,%esp
80101211:	50                   	push   %eax
80101212:	e8 b8 07 00 00       	call   801019cf <ilock>
80101217:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010121a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010121d:	8b 45 08             	mov    0x8(%ebp),%eax
80101220:	8b 50 14             	mov    0x14(%eax),%edx
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 40 10             	mov    0x10(%eax),%eax
80101229:	51                   	push   %ecx
8010122a:	52                   	push   %edx
8010122b:	ff 75 0c             	push   0xc(%ebp)
8010122e:	50                   	push   %eax
8010122f:	e8 87 0c 00 00       	call   80101ebb <readi>
80101234:	83 c4 10             	add    $0x10,%esp
80101237:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010123a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010123e:	7e 11                	jle    80101251 <fileread+0x92>
      f->off += r;
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	8b 50 14             	mov    0x14(%eax),%edx
80101246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101249:	01 c2                	add    %eax,%edx
8010124b:	8b 45 08             	mov    0x8(%ebp),%eax
8010124e:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101251:	8b 45 08             	mov    0x8(%ebp),%eax
80101254:	8b 40 10             	mov    0x10(%eax),%eax
80101257:	83 ec 0c             	sub    $0xc,%esp
8010125a:	50                   	push   %eax
8010125b:	e8 82 08 00 00       	call   80101ae2 <iunlock>
80101260:	83 c4 10             	add    $0x10,%esp
    return r;
80101263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101266:	eb 0d                	jmp    80101275 <fileread+0xb6>
  }
  panic("fileread");
80101268:	83 ec 0c             	sub    $0xc,%esp
8010126b:	68 5a a5 10 80       	push   $0x8010a55a
80101270:	e8 34 f3 ff ff       	call   801005a9 <panic>
}
80101275:	c9                   	leave  
80101276:	c3                   	ret    

80101277 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101277:	55                   	push   %ebp
80101278:	89 e5                	mov    %esp,%ebp
8010127a:	53                   	push   %ebx
8010127b:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010127e:	8b 45 08             	mov    0x8(%ebp),%eax
80101281:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101285:	84 c0                	test   %al,%al
80101287:	75 0a                	jne    80101293 <filewrite+0x1c>
    return -1;
80101289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010128e:	e9 1b 01 00 00       	jmp    801013ae <filewrite+0x137>
  if(f->type == FD_PIPE)
80101293:	8b 45 08             	mov    0x8(%ebp),%eax
80101296:	8b 00                	mov    (%eax),%eax
80101298:	83 f8 01             	cmp    $0x1,%eax
8010129b:	75 1d                	jne    801012ba <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010129d:	8b 45 08             	mov    0x8(%ebp),%eax
801012a0:	8b 40 0c             	mov    0xc(%eax),%eax
801012a3:	83 ec 04             	sub    $0x4,%esp
801012a6:	ff 75 10             	push   0x10(%ebp)
801012a9:	ff 75 0c             	push   0xc(%ebp)
801012ac:	50                   	push   %eax
801012ad:	e8 9d 24 00 00       	call   8010374f <pipewrite>
801012b2:	83 c4 10             	add    $0x10,%esp
801012b5:	e9 f4 00 00 00       	jmp    801013ae <filewrite+0x137>
  if(f->type == FD_INODE){
801012ba:	8b 45 08             	mov    0x8(%ebp),%eax
801012bd:	8b 00                	mov    (%eax),%eax
801012bf:	83 f8 02             	cmp    $0x2,%eax
801012c2:	0f 85 d9 00 00 00    	jne    801013a1 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012c8:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801012cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012d6:	e9 a3 00 00 00       	jmp    8010137e <filewrite+0x107>
      int n1 = n - i;
801012db:	8b 45 10             	mov    0x10(%ebp),%eax
801012de:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012ea:	7e 06                	jle    801012f2 <filewrite+0x7b>
        n1 = max;
801012ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012f2:	e8 2a 1d 00 00       	call   80103021 <begin_op>
      ilock(f->ip);
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	8b 40 10             	mov    0x10(%eax),%eax
801012fd:	83 ec 0c             	sub    $0xc,%esp
80101300:	50                   	push   %eax
80101301:	e8 c9 06 00 00       	call   801019cf <ilock>
80101306:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101309:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010130c:	8b 45 08             	mov    0x8(%ebp),%eax
8010130f:	8b 50 14             	mov    0x14(%eax),%edx
80101312:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101315:	8b 45 0c             	mov    0xc(%ebp),%eax
80101318:	01 c3                	add    %eax,%ebx
8010131a:	8b 45 08             	mov    0x8(%ebp),%eax
8010131d:	8b 40 10             	mov    0x10(%eax),%eax
80101320:	51                   	push   %ecx
80101321:	52                   	push   %edx
80101322:	53                   	push   %ebx
80101323:	50                   	push   %eax
80101324:	e8 e7 0c 00 00       	call   80102010 <writei>
80101329:	83 c4 10             	add    $0x10,%esp
8010132c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010132f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101333:	7e 11                	jle    80101346 <filewrite+0xcf>
        f->off += r;
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 50 14             	mov    0x14(%eax),%edx
8010133b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010133e:	01 c2                	add    %eax,%edx
80101340:	8b 45 08             	mov    0x8(%ebp),%eax
80101343:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101346:	8b 45 08             	mov    0x8(%ebp),%eax
80101349:	8b 40 10             	mov    0x10(%eax),%eax
8010134c:	83 ec 0c             	sub    $0xc,%esp
8010134f:	50                   	push   %eax
80101350:	e8 8d 07 00 00       	call   80101ae2 <iunlock>
80101355:	83 c4 10             	add    $0x10,%esp
      end_op();
80101358:	e8 50 1d 00 00       	call   801030ad <end_op>

      if(r < 0)
8010135d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101361:	78 29                	js     8010138c <filewrite+0x115>
        break;
      if(r != n1)
80101363:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101366:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101369:	74 0d                	je     80101378 <filewrite+0x101>
        panic("short filewrite");
8010136b:	83 ec 0c             	sub    $0xc,%esp
8010136e:	68 63 a5 10 80       	push   $0x8010a563
80101373:	e8 31 f2 ff ff       	call   801005a9 <panic>
      i += r;
80101378:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010137b:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101381:	3b 45 10             	cmp    0x10(%ebp),%eax
80101384:	0f 8c 51 ff ff ff    	jl     801012db <filewrite+0x64>
8010138a:	eb 01                	jmp    8010138d <filewrite+0x116>
        break;
8010138c:	90                   	nop
    }
    return i == n ? n : -1;
8010138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101390:	3b 45 10             	cmp    0x10(%ebp),%eax
80101393:	75 05                	jne    8010139a <filewrite+0x123>
80101395:	8b 45 10             	mov    0x10(%ebp),%eax
80101398:	eb 14                	jmp    801013ae <filewrite+0x137>
8010139a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010139f:	eb 0d                	jmp    801013ae <filewrite+0x137>
  }
  panic("filewrite");
801013a1:	83 ec 0c             	sub    $0xc,%esp
801013a4:	68 73 a5 10 80       	push   $0x8010a573
801013a9:	e8 fb f1 ff ff       	call   801005a9 <panic>
}
801013ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013b1:	c9                   	leave  
801013b2:	c3                   	ret    

801013b3 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b3:	55                   	push   %ebp
801013b4:	89 e5                	mov    %esp,%ebp
801013b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013b9:	8b 45 08             	mov    0x8(%ebp),%eax
801013bc:	83 ec 08             	sub    $0x8,%esp
801013bf:	6a 01                	push   $0x1
801013c1:	50                   	push   %eax
801013c2:	e8 3a ee ff ff       	call   80100201 <bread>
801013c7:	83 c4 10             	add    $0x10,%esp
801013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d0:	83 c0 5c             	add    $0x5c,%eax
801013d3:	83 ec 04             	sub    $0x4,%esp
801013d6:	6a 1c                	push   $0x1c
801013d8:	50                   	push   %eax
801013d9:	ff 75 0c             	push   0xc(%ebp)
801013dc:	e8 0f 38 00 00       	call   80104bf0 <memmove>
801013e1:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	ff 75 f4             	push   -0xc(%ebp)
801013ea:	e8 94 ee ff ff       	call   80100283 <brelse>
801013ef:	83 c4 10             	add    $0x10,%esp
}
801013f2:	90                   	nop
801013f3:	c9                   	leave  
801013f4:	c3                   	ret    

801013f5 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013f5:	55                   	push   %ebp
801013f6:	89 e5                	mov    %esp,%ebp
801013f8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
801013fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801013fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101401:	83 ec 08             	sub    $0x8,%esp
80101404:	52                   	push   %edx
80101405:	50                   	push   %eax
80101406:	e8 f6 ed ff ff       	call   80100201 <bread>
8010140b:	83 c4 10             	add    $0x10,%esp
8010140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101411:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101414:	83 c0 5c             	add    $0x5c,%eax
80101417:	83 ec 04             	sub    $0x4,%esp
8010141a:	68 00 02 00 00       	push   $0x200
8010141f:	6a 00                	push   $0x0
80101421:	50                   	push   %eax
80101422:	e8 0a 37 00 00       	call   80104b31 <memset>
80101427:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010142a:	83 ec 0c             	sub    $0xc,%esp
8010142d:	ff 75 f4             	push   -0xc(%ebp)
80101430:	e8 25 1e 00 00       	call   8010325a <log_write>
80101435:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101438:	83 ec 0c             	sub    $0xc,%esp
8010143b:	ff 75 f4             	push   -0xc(%ebp)
8010143e:	e8 40 ee ff ff       	call   80100283 <brelse>
80101443:	83 c4 10             	add    $0x10,%esp
}
80101446:	90                   	nop
80101447:	c9                   	leave  
80101448:	c3                   	ret    

80101449 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101449:	55                   	push   %ebp
8010144a:	89 e5                	mov    %esp,%ebp
8010144c:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010144f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010145d:	e9 0b 01 00 00       	jmp    8010156d <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
80101462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101465:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010146b:	85 c0                	test   %eax,%eax
8010146d:	0f 48 c2             	cmovs  %edx,%eax
80101470:	c1 f8 0c             	sar    $0xc,%eax
80101473:	89 c2                	mov    %eax,%edx
80101475:	a1 58 24 19 80       	mov    0x80192458,%eax
8010147a:	01 d0                	add    %edx,%eax
8010147c:	83 ec 08             	sub    $0x8,%esp
8010147f:	50                   	push   %eax
80101480:	ff 75 08             	push   0x8(%ebp)
80101483:	e8 79 ed ff ff       	call   80100201 <bread>
80101488:	83 c4 10             	add    $0x10,%esp
8010148b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101495:	e9 9e 00 00 00       	jmp    80101538 <balloc+0xef>
      m = 1 << (bi % 8);
8010149a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010149d:	83 e0 07             	and    $0x7,%eax
801014a0:	ba 01 00 00 00       	mov    $0x1,%edx
801014a5:	89 c1                	mov    %eax,%ecx
801014a7:	d3 e2                	shl    %cl,%edx
801014a9:	89 d0                	mov    %edx,%eax
801014ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b1:	8d 50 07             	lea    0x7(%eax),%edx
801014b4:	85 c0                	test   %eax,%eax
801014b6:	0f 48 c2             	cmovs  %edx,%eax
801014b9:	c1 f8 03             	sar    $0x3,%eax
801014bc:	89 c2                	mov    %eax,%edx
801014be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014c1:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014c6:	0f b6 c0             	movzbl %al,%eax
801014c9:	23 45 e8             	and    -0x18(%ebp),%eax
801014cc:	85 c0                	test   %eax,%eax
801014ce:	75 64                	jne    80101534 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
801014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d3:	8d 50 07             	lea    0x7(%eax),%edx
801014d6:	85 c0                	test   %eax,%eax
801014d8:	0f 48 c2             	cmovs  %edx,%eax
801014db:	c1 f8 03             	sar    $0x3,%eax
801014de:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014e1:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801014e6:	89 d1                	mov    %edx,%ecx
801014e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014eb:	09 ca                	or     %ecx,%edx
801014ed:	89 d1                	mov    %edx,%ecx
801014ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014f2:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
801014f6:	83 ec 0c             	sub    $0xc,%esp
801014f9:	ff 75 ec             	push   -0x14(%ebp)
801014fc:	e8 59 1d 00 00       	call   8010325a <log_write>
80101501:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	ff 75 ec             	push   -0x14(%ebp)
8010150a:	e8 74 ed ff ff       	call   80100283 <brelse>
8010150f:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101512:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101515:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101518:	01 c2                	add    %eax,%edx
8010151a:	8b 45 08             	mov    0x8(%ebp),%eax
8010151d:	83 ec 08             	sub    $0x8,%esp
80101520:	52                   	push   %edx
80101521:	50                   	push   %eax
80101522:	e8 ce fe ff ff       	call   801013f5 <bzero>
80101527:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010152a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	01 d0                	add    %edx,%eax
80101532:	eb 57                	jmp    8010158b <balloc+0x142>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101534:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101538:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010153f:	7f 17                	jg     80101558 <balloc+0x10f>
80101541:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101544:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101547:	01 d0                	add    %edx,%eax
80101549:	89 c2                	mov    %eax,%edx
8010154b:	a1 40 24 19 80       	mov    0x80192440,%eax
80101550:	39 c2                	cmp    %eax,%edx
80101552:	0f 82 42 ff ff ff    	jb     8010149a <balloc+0x51>
      }
    }
    brelse(bp);
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	ff 75 ec             	push   -0x14(%ebp)
8010155e:	e8 20 ed ff ff       	call   80100283 <brelse>
80101563:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101566:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010156d:	8b 15 40 24 19 80    	mov    0x80192440,%edx
80101573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101576:	39 c2                	cmp    %eax,%edx
80101578:	0f 87 e4 fe ff ff    	ja     80101462 <balloc+0x19>
  }
  panic("balloc: out of blocks");
8010157e:	83 ec 0c             	sub    $0xc,%esp
80101581:	68 80 a5 10 80       	push   $0x8010a580
80101586:	e8 1e f0 ff ff       	call   801005a9 <panic>
}
8010158b:	c9                   	leave  
8010158c:	c3                   	ret    

8010158d <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010158d:	55                   	push   %ebp
8010158e:	89 e5                	mov    %esp,%ebp
80101590:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101593:	83 ec 08             	sub    $0x8,%esp
80101596:	68 40 24 19 80       	push   $0x80192440
8010159b:	ff 75 08             	push   0x8(%ebp)
8010159e:	e8 10 fe ff ff       	call   801013b3 <readsb>
801015a3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a9:	c1 e8 0c             	shr    $0xc,%eax
801015ac:	89 c2                	mov    %eax,%edx
801015ae:	a1 58 24 19 80       	mov    0x80192458,%eax
801015b3:	01 c2                	add    %eax,%edx
801015b5:	8b 45 08             	mov    0x8(%ebp),%eax
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	52                   	push   %edx
801015bc:	50                   	push   %eax
801015bd:	e8 3f ec ff ff       	call   80100201 <bread>
801015c2:	83 c4 10             	add    $0x10,%esp
801015c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801015cb:	25 ff 0f 00 00       	and    $0xfff,%eax
801015d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d6:	83 e0 07             	and    $0x7,%eax
801015d9:	ba 01 00 00 00       	mov    $0x1,%edx
801015de:	89 c1                	mov    %eax,%ecx
801015e0:	d3 e2                	shl    %cl,%edx
801015e2:	89 d0                	mov    %edx,%eax
801015e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ea:	8d 50 07             	lea    0x7(%eax),%edx
801015ed:	85 c0                	test   %eax,%eax
801015ef:	0f 48 c2             	cmovs  %edx,%eax
801015f2:	c1 f8 03             	sar    $0x3,%eax
801015f5:	89 c2                	mov    %eax,%edx
801015f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fa:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801015ff:	0f b6 c0             	movzbl %al,%eax
80101602:	23 45 ec             	and    -0x14(%ebp),%eax
80101605:	85 c0                	test   %eax,%eax
80101607:	75 0d                	jne    80101616 <bfree+0x89>
    panic("freeing free block");
80101609:	83 ec 0c             	sub    $0xc,%esp
8010160c:	68 96 a5 10 80       	push   $0x8010a596
80101611:	e8 93 ef ff ff       	call   801005a9 <panic>
  bp->data[bi/8] &= ~m;
80101616:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101619:	8d 50 07             	lea    0x7(%eax),%edx
8010161c:	85 c0                	test   %eax,%eax
8010161e:	0f 48 c2             	cmovs  %edx,%eax
80101621:	c1 f8 03             	sar    $0x3,%eax
80101624:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101627:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010162c:	89 d1                	mov    %edx,%ecx
8010162e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101631:	f7 d2                	not    %edx
80101633:	21 ca                	and    %ecx,%edx
80101635:	89 d1                	mov    %edx,%ecx
80101637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010163a:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
8010163e:	83 ec 0c             	sub    $0xc,%esp
80101641:	ff 75 f4             	push   -0xc(%ebp)
80101644:	e8 11 1c 00 00       	call   8010325a <log_write>
80101649:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010164c:	83 ec 0c             	sub    $0xc,%esp
8010164f:	ff 75 f4             	push   -0xc(%ebp)
80101652:	e8 2c ec ff ff       	call   80100283 <brelse>
80101657:	83 c4 10             	add    $0x10,%esp
}
8010165a:	90                   	nop
8010165b:	c9                   	leave  
8010165c:	c3                   	ret    

8010165d <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010165d:	55                   	push   %ebp
8010165e:	89 e5                	mov    %esp,%ebp
80101660:	57                   	push   %edi
80101661:	56                   	push   %esi
80101662:	53                   	push   %ebx
80101663:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101666:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010166d:	83 ec 08             	sub    $0x8,%esp
80101670:	68 a9 a5 10 80       	push   $0x8010a5a9
80101675:	68 60 24 19 80       	push   $0x80192460
8010167a:	e8 1a 32 00 00       	call   80104899 <initlock>
8010167f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
80101682:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101689:	eb 2d                	jmp    801016b8 <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
8010168b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010168e:	89 d0                	mov    %edx,%eax
80101690:	c1 e0 03             	shl    $0x3,%eax
80101693:	01 d0                	add    %edx,%eax
80101695:	c1 e0 04             	shl    $0x4,%eax
80101698:	83 c0 30             	add    $0x30,%eax
8010169b:	05 60 24 19 80       	add    $0x80192460,%eax
801016a0:	83 c0 10             	add    $0x10,%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	68 b0 a5 10 80       	push   $0x8010a5b0
801016ab:	50                   	push   %eax
801016ac:	e8 8b 30 00 00       	call   8010473c <initsleeplock>
801016b1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016b4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016b8:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016bc:	7e cd                	jle    8010168b <iinit+0x2e>
  }

  readsb(dev, &sb);
801016be:	83 ec 08             	sub    $0x8,%esp
801016c1:	68 40 24 19 80       	push   $0x80192440
801016c6:	ff 75 08             	push   0x8(%ebp)
801016c9:	e8 e5 fc ff ff       	call   801013b3 <readsb>
801016ce:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016d1:	a1 58 24 19 80       	mov    0x80192458,%eax
801016d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016d9:	8b 3d 54 24 19 80    	mov    0x80192454,%edi
801016df:	8b 35 50 24 19 80    	mov    0x80192450,%esi
801016e5:	8b 1d 4c 24 19 80    	mov    0x8019244c,%ebx
801016eb:	8b 0d 48 24 19 80    	mov    0x80192448,%ecx
801016f1:	8b 15 44 24 19 80    	mov    0x80192444,%edx
801016f7:	a1 40 24 19 80       	mov    0x80192440,%eax
801016fc:	ff 75 d4             	push   -0x2c(%ebp)
801016ff:	57                   	push   %edi
80101700:	56                   	push   %esi
80101701:	53                   	push   %ebx
80101702:	51                   	push   %ecx
80101703:	52                   	push   %edx
80101704:	50                   	push   %eax
80101705:	68 b8 a5 10 80       	push   $0x8010a5b8
8010170a:	e8 e5 ec ff ff       	call   801003f4 <cprintf>
8010170f:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101712:	90                   	nop
80101713:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101716:	5b                   	pop    %ebx
80101717:	5e                   	pop    %esi
80101718:	5f                   	pop    %edi
80101719:	5d                   	pop    %ebp
8010171a:	c3                   	ret    

8010171b <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010171b:	55                   	push   %ebp
8010171c:	89 e5                	mov    %esp,%ebp
8010171e:	83 ec 28             	sub    $0x28,%esp
80101721:	8b 45 0c             	mov    0xc(%ebp),%eax
80101724:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101728:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010172f:	e9 9e 00 00 00       	jmp    801017d2 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101737:	c1 e8 03             	shr    $0x3,%eax
8010173a:	89 c2                	mov    %eax,%edx
8010173c:	a1 54 24 19 80       	mov    0x80192454,%eax
80101741:	01 d0                	add    %edx,%eax
80101743:	83 ec 08             	sub    $0x8,%esp
80101746:	50                   	push   %eax
80101747:	ff 75 08             	push   0x8(%ebp)
8010174a:	e8 b2 ea ff ff       	call   80100201 <bread>
8010174f:	83 c4 10             	add    $0x10,%esp
80101752:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101758:	8d 50 5c             	lea    0x5c(%eax),%edx
8010175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175e:	83 e0 07             	and    $0x7,%eax
80101761:	c1 e0 06             	shl    $0x6,%eax
80101764:	01 d0                	add    %edx,%eax
80101766:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101769:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010176c:	0f b7 00             	movzwl (%eax),%eax
8010176f:	66 85 c0             	test   %ax,%ax
80101772:	75 4c                	jne    801017c0 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101774:	83 ec 04             	sub    $0x4,%esp
80101777:	6a 40                	push   $0x40
80101779:	6a 00                	push   $0x0
8010177b:	ff 75 ec             	push   -0x14(%ebp)
8010177e:	e8 ae 33 00 00       	call   80104b31 <memset>
80101783:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101786:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101789:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010178d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101790:	83 ec 0c             	sub    $0xc,%esp
80101793:	ff 75 f0             	push   -0x10(%ebp)
80101796:	e8 bf 1a 00 00       	call   8010325a <log_write>
8010179b:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010179e:	83 ec 0c             	sub    $0xc,%esp
801017a1:	ff 75 f0             	push   -0x10(%ebp)
801017a4:	e8 da ea ff ff       	call   80100283 <brelse>
801017a9:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017af:	83 ec 08             	sub    $0x8,%esp
801017b2:	50                   	push   %eax
801017b3:	ff 75 08             	push   0x8(%ebp)
801017b6:	e8 f8 00 00 00       	call   801018b3 <iget>
801017bb:	83 c4 10             	add    $0x10,%esp
801017be:	eb 30                	jmp    801017f0 <ialloc+0xd5>
    }
    brelse(bp);
801017c0:	83 ec 0c             	sub    $0xc,%esp
801017c3:	ff 75 f0             	push   -0x10(%ebp)
801017c6:	e8 b8 ea ff ff       	call   80100283 <brelse>
801017cb:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017d2:	8b 15 48 24 19 80    	mov    0x80192448,%edx
801017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017db:	39 c2                	cmp    %eax,%edx
801017dd:	0f 87 51 ff ff ff    	ja     80101734 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
801017e3:	83 ec 0c             	sub    $0xc,%esp
801017e6:	68 0b a6 10 80       	push   $0x8010a60b
801017eb:	e8 b9 ed ff ff       	call   801005a9 <panic>
}
801017f0:	c9                   	leave  
801017f1:	c3                   	ret    

801017f2 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801017f2:	55                   	push   %ebp
801017f3:	89 e5                	mov    %esp,%ebp
801017f5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017f8:	8b 45 08             	mov    0x8(%ebp),%eax
801017fb:	8b 40 04             	mov    0x4(%eax),%eax
801017fe:	c1 e8 03             	shr    $0x3,%eax
80101801:	89 c2                	mov    %eax,%edx
80101803:	a1 54 24 19 80       	mov    0x80192454,%eax
80101808:	01 c2                	add    %eax,%edx
8010180a:	8b 45 08             	mov    0x8(%ebp),%eax
8010180d:	8b 00                	mov    (%eax),%eax
8010180f:	83 ec 08             	sub    $0x8,%esp
80101812:	52                   	push   %edx
80101813:	50                   	push   %eax
80101814:	e8 e8 e9 ff ff       	call   80100201 <bread>
80101819:	83 c4 10             	add    $0x10,%esp
8010181c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101822:	8d 50 5c             	lea    0x5c(%eax),%edx
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 04             	mov    0x4(%eax),%eax
8010182b:	83 e0 07             	and    $0x7,%eax
8010182e:	c1 e0 06             	shl    $0x6,%eax
80101831:	01 d0                	add    %edx,%eax
80101833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101836:	8b 45 08             	mov    0x8(%ebp),%eax
80101839:	0f b7 50 50          	movzwl 0x50(%eax),%edx
8010183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101840:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101843:	8b 45 08             	mov    0x8(%ebp),%eax
80101846:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184d:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101851:	8b 45 08             	mov    0x8(%ebp),%eax
80101854:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185b:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010185f:	8b 45 08             	mov    0x8(%ebp),%eax
80101862:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101866:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101869:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010186d:	8b 45 08             	mov    0x8(%ebp),%eax
80101870:	8b 50 58             	mov    0x58(%eax),%edx
80101873:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101876:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101879:	8b 45 08             	mov    0x8(%ebp),%eax
8010187c:	8d 50 5c             	lea    0x5c(%eax),%edx
8010187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101882:	83 c0 0c             	add    $0xc,%eax
80101885:	83 ec 04             	sub    $0x4,%esp
80101888:	6a 34                	push   $0x34
8010188a:	52                   	push   %edx
8010188b:	50                   	push   %eax
8010188c:	e8 5f 33 00 00       	call   80104bf0 <memmove>
80101891:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	ff 75 f4             	push   -0xc(%ebp)
8010189a:	e8 bb 19 00 00       	call   8010325a <log_write>
8010189f:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018a2:	83 ec 0c             	sub    $0xc,%esp
801018a5:	ff 75 f4             	push   -0xc(%ebp)
801018a8:	e8 d6 e9 ff ff       	call   80100283 <brelse>
801018ad:	83 c4 10             	add    $0x10,%esp
}
801018b0:	90                   	nop
801018b1:	c9                   	leave  
801018b2:	c3                   	ret    

801018b3 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018b3:	55                   	push   %ebp
801018b4:	89 e5                	mov    %esp,%ebp
801018b6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018b9:	83 ec 0c             	sub    $0xc,%esp
801018bc:	68 60 24 19 80       	push   $0x80192460
801018c1:	e8 f5 2f 00 00       	call   801048bb <acquire>
801018c6:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d0:	c7 45 f4 94 24 19 80 	movl   $0x80192494,-0xc(%ebp)
801018d7:	eb 60                	jmp    80101939 <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018dc:	8b 40 08             	mov    0x8(%eax),%eax
801018df:	85 c0                	test   %eax,%eax
801018e1:	7e 39                	jle    8010191c <iget+0x69>
801018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e6:	8b 00                	mov    (%eax),%eax
801018e8:	39 45 08             	cmp    %eax,0x8(%ebp)
801018eb:	75 2f                	jne    8010191c <iget+0x69>
801018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f0:	8b 40 04             	mov    0x4(%eax),%eax
801018f3:	39 45 0c             	cmp    %eax,0xc(%ebp)
801018f6:	75 24                	jne    8010191c <iget+0x69>
      ip->ref++;
801018f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018fb:	8b 40 08             	mov    0x8(%eax),%eax
801018fe:	8d 50 01             	lea    0x1(%eax),%edx
80101901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101904:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101907:	83 ec 0c             	sub    $0xc,%esp
8010190a:	68 60 24 19 80       	push   $0x80192460
8010190f:	e8 15 30 00 00       	call   80104929 <release>
80101914:	83 c4 10             	add    $0x10,%esp
      return ip;
80101917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191a:	eb 77                	jmp    80101993 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010191c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101920:	75 10                	jne    80101932 <iget+0x7f>
80101922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101925:	8b 40 08             	mov    0x8(%eax),%eax
80101928:	85 c0                	test   %eax,%eax
8010192a:	75 06                	jne    80101932 <iget+0x7f>
      empty = ip;
8010192c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101932:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101939:	81 7d f4 b4 40 19 80 	cmpl   $0x801940b4,-0xc(%ebp)
80101940:	72 97                	jb     801018d9 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101946:	75 0d                	jne    80101955 <iget+0xa2>
    panic("iget: no inodes");
80101948:	83 ec 0c             	sub    $0xc,%esp
8010194b:	68 1d a6 10 80       	push   $0x8010a61d
80101950:	e8 54 ec ff ff       	call   801005a9 <panic>

  ip = empty;
80101955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101958:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195e:	8b 55 08             	mov    0x8(%ebp),%edx
80101961:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101966:	8b 55 0c             	mov    0xc(%ebp),%edx
80101969:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010196c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	68 60 24 19 80       	push   $0x80192460
80101988:	e8 9c 2f 00 00       	call   80104929 <release>
8010198d:	83 c4 10             	add    $0x10,%esp

  return ip;
80101990:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101993:	c9                   	leave  
80101994:	c3                   	ret    

80101995 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101995:	55                   	push   %ebp
80101996:	89 e5                	mov    %esp,%ebp
80101998:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
8010199b:	83 ec 0c             	sub    $0xc,%esp
8010199e:	68 60 24 19 80       	push   $0x80192460
801019a3:	e8 13 2f 00 00       	call   801048bb <acquire>
801019a8:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ab:	8b 45 08             	mov    0x8(%ebp),%eax
801019ae:	8b 40 08             	mov    0x8(%eax),%eax
801019b1:	8d 50 01             	lea    0x1(%eax),%edx
801019b4:	8b 45 08             	mov    0x8(%ebp),%eax
801019b7:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019ba:	83 ec 0c             	sub    $0xc,%esp
801019bd:	68 60 24 19 80       	push   $0x80192460
801019c2:	e8 62 2f 00 00       	call   80104929 <release>
801019c7:	83 c4 10             	add    $0x10,%esp
  return ip;
801019ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019cd:	c9                   	leave  
801019ce:	c3                   	ret    

801019cf <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019cf:	55                   	push   %ebp
801019d0:	89 e5                	mov    %esp,%ebp
801019d2:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019d9:	74 0a                	je     801019e5 <ilock+0x16>
801019db:	8b 45 08             	mov    0x8(%ebp),%eax
801019de:	8b 40 08             	mov    0x8(%eax),%eax
801019e1:	85 c0                	test   %eax,%eax
801019e3:	7f 0d                	jg     801019f2 <ilock+0x23>
    panic("ilock");
801019e5:	83 ec 0c             	sub    $0xc,%esp
801019e8:	68 2d a6 10 80       	push   $0x8010a62d
801019ed:	e8 b7 eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	83 c0 0c             	add    $0xc,%eax
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	50                   	push   %eax
801019fc:	e8 77 2d 00 00       	call   80104778 <acquiresleep>
80101a01:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a04:	8b 45 08             	mov    0x8(%ebp),%eax
80101a07:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a0a:	85 c0                	test   %eax,%eax
80101a0c:	0f 85 cd 00 00 00    	jne    80101adf <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a12:	8b 45 08             	mov    0x8(%ebp),%eax
80101a15:	8b 40 04             	mov    0x4(%eax),%eax
80101a18:	c1 e8 03             	shr    $0x3,%eax
80101a1b:	89 c2                	mov    %eax,%edx
80101a1d:	a1 54 24 19 80       	mov    0x80192454,%eax
80101a22:	01 c2                	add    %eax,%edx
80101a24:	8b 45 08             	mov    0x8(%ebp),%eax
80101a27:	8b 00                	mov    (%eax),%eax
80101a29:	83 ec 08             	sub    $0x8,%esp
80101a2c:	52                   	push   %edx
80101a2d:	50                   	push   %eax
80101a2e:	e8 ce e7 ff ff       	call   80100201 <bread>
80101a33:	83 c4 10             	add    $0x10,%esp
80101a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3c:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	8b 40 04             	mov    0x4(%eax),%eax
80101a45:	83 e0 07             	and    $0x7,%eax
80101a48:	c1 e0 06             	shl    $0x6,%eax
80101a4b:	01 d0                	add    %edx,%eax
80101a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a53:	0f b7 10             	movzwl (%eax),%edx
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a60:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a72:	8b 45 08             	mov    0x8(%ebp),%eax
80101a75:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a7c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a8a:	8b 50 08             	mov    0x8(%eax),%edx
80101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a90:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a96:	8d 50 0c             	lea    0xc(%eax),%edx
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	83 c0 5c             	add    $0x5c,%eax
80101a9f:	83 ec 04             	sub    $0x4,%esp
80101aa2:	6a 34                	push   $0x34
80101aa4:	52                   	push   %edx
80101aa5:	50                   	push   %eax
80101aa6:	e8 45 31 00 00       	call   80104bf0 <memmove>
80101aab:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101aae:	83 ec 0c             	sub    $0xc,%esp
80101ab1:	ff 75 f4             	push   -0xc(%ebp)
80101ab4:	e8 ca e7 ff ff       	call   80100283 <brelse>
80101ab9:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac9:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101acd:	66 85 c0             	test   %ax,%ax
80101ad0:	75 0d                	jne    80101adf <ilock+0x110>
      panic("ilock: no type");
80101ad2:	83 ec 0c             	sub    $0xc,%esp
80101ad5:	68 33 a6 10 80       	push   $0x8010a633
80101ada:	e8 ca ea ff ff       	call   801005a9 <panic>
  }
}
80101adf:	90                   	nop
80101ae0:	c9                   	leave  
80101ae1:	c3                   	ret    

80101ae2 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ae2:	55                   	push   %ebp
80101ae3:	89 e5                	mov    %esp,%ebp
80101ae5:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101aec:	74 20                	je     80101b0e <iunlock+0x2c>
80101aee:	8b 45 08             	mov    0x8(%ebp),%eax
80101af1:	83 c0 0c             	add    $0xc,%eax
80101af4:	83 ec 0c             	sub    $0xc,%esp
80101af7:	50                   	push   %eax
80101af8:	e8 2d 2d 00 00       	call   8010482a <holdingsleep>
80101afd:	83 c4 10             	add    $0x10,%esp
80101b00:	85 c0                	test   %eax,%eax
80101b02:	74 0a                	je     80101b0e <iunlock+0x2c>
80101b04:	8b 45 08             	mov    0x8(%ebp),%eax
80101b07:	8b 40 08             	mov    0x8(%eax),%eax
80101b0a:	85 c0                	test   %eax,%eax
80101b0c:	7f 0d                	jg     80101b1b <iunlock+0x39>
    panic("iunlock");
80101b0e:	83 ec 0c             	sub    $0xc,%esp
80101b11:	68 42 a6 10 80       	push   $0x8010a642
80101b16:	e8 8e ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	83 c0 0c             	add    $0xc,%eax
80101b21:	83 ec 0c             	sub    $0xc,%esp
80101b24:	50                   	push   %eax
80101b25:	e8 b2 2c 00 00       	call   801047dc <releasesleep>
80101b2a:	83 c4 10             	add    $0x10,%esp
}
80101b2d:	90                   	nop
80101b2e:	c9                   	leave  
80101b2f:	c3                   	ret    

80101b30 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	83 c0 0c             	add    $0xc,%eax
80101b3c:	83 ec 0c             	sub    $0xc,%esp
80101b3f:	50                   	push   %eax
80101b40:	e8 33 2c 00 00       	call   80104778 <acquiresleep>
80101b45:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b48:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b4e:	85 c0                	test   %eax,%eax
80101b50:	74 6a                	je     80101bbc <iput+0x8c>
80101b52:	8b 45 08             	mov    0x8(%ebp),%eax
80101b55:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b59:	66 85 c0             	test   %ax,%ax
80101b5c:	75 5e                	jne    80101bbc <iput+0x8c>
    acquire(&icache.lock);
80101b5e:	83 ec 0c             	sub    $0xc,%esp
80101b61:	68 60 24 19 80       	push   $0x80192460
80101b66:	e8 50 2d 00 00       	call   801048bb <acquire>
80101b6b:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 40 08             	mov    0x8(%eax),%eax
80101b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b77:	83 ec 0c             	sub    $0xc,%esp
80101b7a:	68 60 24 19 80       	push   $0x80192460
80101b7f:	e8 a5 2d 00 00       	call   80104929 <release>
80101b84:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101b87:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101b8b:	75 2f                	jne    80101bbc <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101b8d:	83 ec 0c             	sub    $0xc,%esp
80101b90:	ff 75 08             	push   0x8(%ebp)
80101b93:	e8 ad 01 00 00       	call   80101d45 <itrunc>
80101b98:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9e:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	ff 75 08             	push   0x8(%ebp)
80101baa:	e8 43 fc ff ff       	call   801017f2 <iupdate>
80101baf:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbf:	83 c0 0c             	add    $0xc,%eax
80101bc2:	83 ec 0c             	sub    $0xc,%esp
80101bc5:	50                   	push   %eax
80101bc6:	e8 11 2c 00 00       	call   801047dc <releasesleep>
80101bcb:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101bce:	83 ec 0c             	sub    $0xc,%esp
80101bd1:	68 60 24 19 80       	push   $0x80192460
80101bd6:	e8 e0 2c 00 00       	call   801048bb <acquire>
80101bdb:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101bde:	8b 45 08             	mov    0x8(%ebp),%eax
80101be1:	8b 40 08             	mov    0x8(%eax),%eax
80101be4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101be7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bea:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bed:	83 ec 0c             	sub    $0xc,%esp
80101bf0:	68 60 24 19 80       	push   $0x80192460
80101bf5:	e8 2f 2d 00 00       	call   80104929 <release>
80101bfa:	83 c4 10             	add    $0x10,%esp
}
80101bfd:	90                   	nop
80101bfe:	c9                   	leave  
80101bff:	c3                   	ret    

80101c00 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c06:	83 ec 0c             	sub    $0xc,%esp
80101c09:	ff 75 08             	push   0x8(%ebp)
80101c0c:	e8 d1 fe ff ff       	call   80101ae2 <iunlock>
80101c11:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c14:	83 ec 0c             	sub    $0xc,%esp
80101c17:	ff 75 08             	push   0x8(%ebp)
80101c1a:	e8 11 ff ff ff       	call   80101b30 <iput>
80101c1f:	83 c4 10             	add    $0x10,%esp
}
80101c22:	90                   	nop
80101c23:	c9                   	leave  
80101c24:	c3                   	ret    

80101c25 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c25:	55                   	push   %ebp
80101c26:	89 e5                	mov    %esp,%ebp
80101c28:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c2b:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c2f:	77 42                	ja     80101c73 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c31:	8b 45 08             	mov    0x8(%ebp),%eax
80101c34:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c37:	83 c2 14             	add    $0x14,%edx
80101c3a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c45:	75 24                	jne    80101c6b <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c47:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4a:	8b 00                	mov    (%eax),%eax
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	50                   	push   %eax
80101c50:	e8 f4 f7 ff ff       	call   80101449 <balloc>
80101c55:	83 c4 10             	add    $0x10,%esp
80101c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c61:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c67:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c6e:	e9 d0 00 00 00       	jmp    80101d43 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101c73:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c77:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c7b:	0f 87 b5 00 00 00    	ja     80101d36 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c81:	8b 45 08             	mov    0x8(%ebp),%eax
80101c84:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c91:	75 20                	jne    80101cb3 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 00                	mov    (%eax),%eax
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	50                   	push   %eax
80101c9c:	e8 a8 f7 ff ff       	call   80101449 <balloc>
80101ca1:	83 c4 10             	add    $0x10,%esp
80101ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80101caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cad:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	8b 00                	mov    (%eax),%eax
80101cb8:	83 ec 08             	sub    $0x8,%esp
80101cbb:	ff 75 f4             	push   -0xc(%ebp)
80101cbe:	50                   	push   %eax
80101cbf:	e8 3d e5 ff ff       	call   80100201 <bread>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ccd:	83 c0 5c             	add    $0x5c,%eax
80101cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce0:	01 d0                	add    %edx,%eax
80101ce2:	8b 00                	mov    (%eax),%eax
80101ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ceb:	75 36                	jne    80101d23 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101ced:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf0:	8b 00                	mov    (%eax),%eax
80101cf2:	83 ec 0c             	sub    $0xc,%esp
80101cf5:	50                   	push   %eax
80101cf6:	e8 4e f7 ff ff       	call   80101449 <balloc>
80101cfb:	83 c4 10             	add    $0x10,%esp
80101cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d01:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d0e:	01 c2                	add    %eax,%edx
80101d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d13:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d15:	83 ec 0c             	sub    $0xc,%esp
80101d18:	ff 75 f0             	push   -0x10(%ebp)
80101d1b:	e8 3a 15 00 00       	call   8010325a <log_write>
80101d20:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d23:	83 ec 0c             	sub    $0xc,%esp
80101d26:	ff 75 f0             	push   -0x10(%ebp)
80101d29:	e8 55 e5 ff ff       	call   80100283 <brelse>
80101d2e:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d34:	eb 0d                	jmp    80101d43 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d36:	83 ec 0c             	sub    $0xc,%esp
80101d39:	68 4a a6 10 80       	push   $0x8010a64a
80101d3e:	e8 66 e8 ff ff       	call   801005a9 <panic>
}
80101d43:	c9                   	leave  
80101d44:	c3                   	ret    

80101d45 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d45:	55                   	push   %ebp
80101d46:	89 e5                	mov    %esp,%ebp
80101d48:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d52:	eb 45                	jmp    80101d99 <itrunc+0x54>
    if(ip->addrs[i]){
80101d54:	8b 45 08             	mov    0x8(%ebp),%eax
80101d57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d5a:	83 c2 14             	add    $0x14,%edx
80101d5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d61:	85 c0                	test   %eax,%eax
80101d63:	74 30                	je     80101d95 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d65:	8b 45 08             	mov    0x8(%ebp),%eax
80101d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6b:	83 c2 14             	add    $0x14,%edx
80101d6e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d72:	8b 55 08             	mov    0x8(%ebp),%edx
80101d75:	8b 12                	mov    (%edx),%edx
80101d77:	83 ec 08             	sub    $0x8,%esp
80101d7a:	50                   	push   %eax
80101d7b:	52                   	push   %edx
80101d7c:	e8 0c f8 ff ff       	call   8010158d <bfree>
80101d81:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d84:	8b 45 08             	mov    0x8(%ebp),%eax
80101d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d8a:	83 c2 14             	add    $0x14,%edx
80101d8d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d94:	00 
  for(i = 0; i < NDIRECT; i++){
80101d95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d99:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d9d:	7e b5                	jle    80101d54 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101da2:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101da8:	85 c0                	test   %eax,%eax
80101daa:	0f 84 aa 00 00 00    	je     80101e5a <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101db0:	8b 45 08             	mov    0x8(%ebp),%eax
80101db3:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101db9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbc:	8b 00                	mov    (%eax),%eax
80101dbe:	83 ec 08             	sub    $0x8,%esp
80101dc1:	52                   	push   %edx
80101dc2:	50                   	push   %eax
80101dc3:	e8 39 e4 ff ff       	call   80100201 <bread>
80101dc8:	83 c4 10             	add    $0x10,%esp
80101dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dd1:	83 c0 5c             	add    $0x5c,%eax
80101dd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dd7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101dde:	eb 3c                	jmp    80101e1c <itrunc+0xd7>
      if(a[j])
80101de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101de3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dea:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ded:	01 d0                	add    %edx,%eax
80101def:	8b 00                	mov    (%eax),%eax
80101df1:	85 c0                	test   %eax,%eax
80101df3:	74 23                	je     80101e18 <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e02:	01 d0                	add    %edx,%eax
80101e04:	8b 00                	mov    (%eax),%eax
80101e06:	8b 55 08             	mov    0x8(%ebp),%edx
80101e09:	8b 12                	mov    (%edx),%edx
80101e0b:	83 ec 08             	sub    $0x8,%esp
80101e0e:	50                   	push   %eax
80101e0f:	52                   	push   %edx
80101e10:	e8 78 f7 ff ff       	call   8010158d <bfree>
80101e15:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e18:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1f:	83 f8 7f             	cmp    $0x7f,%eax
80101e22:	76 bc                	jbe    80101de0 <itrunc+0x9b>
    }
    brelse(bp);
80101e24:	83 ec 0c             	sub    $0xc,%esp
80101e27:	ff 75 ec             	push   -0x14(%ebp)
80101e2a:	e8 54 e4 ff ff       	call   80100283 <brelse>
80101e2f:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e32:	8b 45 08             	mov    0x8(%ebp),%eax
80101e35:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e3b:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3e:	8b 12                	mov    (%edx),%edx
80101e40:	83 ec 08             	sub    $0x8,%esp
80101e43:	50                   	push   %eax
80101e44:	52                   	push   %edx
80101e45:	e8 43 f7 ff ff       	call   8010158d <bfree>
80101e4a:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e50:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e57:	00 00 00 
  }

  ip->size = 0;
80101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5d:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e64:	83 ec 0c             	sub    $0xc,%esp
80101e67:	ff 75 08             	push   0x8(%ebp)
80101e6a:	e8 83 f9 ff ff       	call   801017f2 <iupdate>
80101e6f:	83 c4 10             	add    $0x10,%esp
}
80101e72:	90                   	nop
80101e73:	c9                   	leave  
80101e74:	c3                   	ret    

80101e75 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e75:	55                   	push   %ebp
80101e76:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e78:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7b:	8b 00                	mov    (%eax),%eax
80101e7d:	89 c2                	mov    %eax,%edx
80101e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e82:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e85:	8b 45 08             	mov    0x8(%ebp),%eax
80101e88:	8b 50 04             	mov    0x4(%eax),%edx
80101e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8e:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e91:	8b 45 08             	mov    0x8(%ebp),%eax
80101e94:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101e98:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9b:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea1:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea8:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101eac:	8b 45 08             	mov    0x8(%ebp),%eax
80101eaf:	8b 50 58             	mov    0x58(%eax),%edx
80101eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb5:	89 50 10             	mov    %edx,0x10(%eax)
}
80101eb8:	90                   	nop
80101eb9:	5d                   	pop    %ebp
80101eba:	c3                   	ret    

80101ebb <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ebb:	55                   	push   %ebp
80101ebc:	89 e5                	mov    %esp,%ebp
80101ebe:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ec8:	66 83 f8 03          	cmp    $0x3,%ax
80101ecc:	75 5c                	jne    80101f2a <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ece:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed1:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ed5:	66 85 c0             	test   %ax,%ax
80101ed8:	78 20                	js     80101efa <readi+0x3f>
80101eda:	8b 45 08             	mov    0x8(%ebp),%eax
80101edd:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ee1:	66 83 f8 09          	cmp    $0x9,%ax
80101ee5:	7f 13                	jg     80101efa <readi+0x3f>
80101ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eea:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101eee:	98                   	cwtl   
80101eef:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101ef6:	85 c0                	test   %eax,%eax
80101ef8:	75 0a                	jne    80101f04 <readi+0x49>
      return -1;
80101efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eff:	e9 0a 01 00 00       	jmp    8010200e <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f04:	8b 45 08             	mov    0x8(%ebp),%eax
80101f07:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f0b:	98                   	cwtl   
80101f0c:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f13:	8b 55 14             	mov    0x14(%ebp),%edx
80101f16:	83 ec 04             	sub    $0x4,%esp
80101f19:	52                   	push   %edx
80101f1a:	ff 75 0c             	push   0xc(%ebp)
80101f1d:	ff 75 08             	push   0x8(%ebp)
80101f20:	ff d0                	call   *%eax
80101f22:	83 c4 10             	add    $0x10,%esp
80101f25:	e9 e4 00 00 00       	jmp    8010200e <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2d:	8b 40 58             	mov    0x58(%eax),%eax
80101f30:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f33:	77 0d                	ja     80101f42 <readi+0x87>
80101f35:	8b 55 10             	mov    0x10(%ebp),%edx
80101f38:	8b 45 14             	mov    0x14(%ebp),%eax
80101f3b:	01 d0                	add    %edx,%eax
80101f3d:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f40:	76 0a                	jbe    80101f4c <readi+0x91>
    return -1;
80101f42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f47:	e9 c2 00 00 00       	jmp    8010200e <readi+0x153>
  if(off + n > ip->size)
80101f4c:	8b 55 10             	mov    0x10(%ebp),%edx
80101f4f:	8b 45 14             	mov    0x14(%ebp),%eax
80101f52:	01 c2                	add    %eax,%edx
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	8b 40 58             	mov    0x58(%eax),%eax
80101f5a:	39 c2                	cmp    %eax,%edx
80101f5c:	76 0c                	jbe    80101f6a <readi+0xaf>
    n = ip->size - off;
80101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f61:	8b 40 58             	mov    0x58(%eax),%eax
80101f64:	2b 45 10             	sub    0x10(%ebp),%eax
80101f67:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f71:	e9 89 00 00 00       	jmp    80101fff <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f76:	8b 45 10             	mov    0x10(%ebp),%eax
80101f79:	c1 e8 09             	shr    $0x9,%eax
80101f7c:	83 ec 08             	sub    $0x8,%esp
80101f7f:	50                   	push   %eax
80101f80:	ff 75 08             	push   0x8(%ebp)
80101f83:	e8 9d fc ff ff       	call   80101c25 <bmap>
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	8b 55 08             	mov    0x8(%ebp),%edx
80101f8e:	8b 12                	mov    (%edx),%edx
80101f90:	83 ec 08             	sub    $0x8,%esp
80101f93:	50                   	push   %eax
80101f94:	52                   	push   %edx
80101f95:	e8 67 e2 ff ff       	call   80100201 <bread>
80101f9a:	83 c4 10             	add    $0x10,%esp
80101f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa3:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fa8:	ba 00 02 00 00       	mov    $0x200,%edx
80101fad:	29 c2                	sub    %eax,%edx
80101faf:	8b 45 14             	mov    0x14(%ebp),%eax
80101fb2:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fb5:	39 c2                	cmp    %eax,%edx
80101fb7:	0f 46 c2             	cmovbe %edx,%eax
80101fba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc0:	8d 50 5c             	lea    0x5c(%eax),%edx
80101fc3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fcb:	01 d0                	add    %edx,%eax
80101fcd:	83 ec 04             	sub    $0x4,%esp
80101fd0:	ff 75 ec             	push   -0x14(%ebp)
80101fd3:	50                   	push   %eax
80101fd4:	ff 75 0c             	push   0xc(%ebp)
80101fd7:	e8 14 2c 00 00       	call   80104bf0 <memmove>
80101fdc:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fdf:	83 ec 0c             	sub    $0xc,%esp
80101fe2:	ff 75 f0             	push   -0x10(%ebp)
80101fe5:	e8 99 e2 ff ff       	call   80100283 <brelse>
80101fea:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff0:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff6:	01 45 10             	add    %eax,0x10(%ebp)
80101ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ffc:	01 45 0c             	add    %eax,0xc(%ebp)
80101fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102002:	3b 45 14             	cmp    0x14(%ebp),%eax
80102005:	0f 82 6b ff ff ff    	jb     80101f76 <readi+0xbb>
  }
  return n;
8010200b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010200e:	c9                   	leave  
8010200f:	c3                   	ret    

80102010 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102016:	8b 45 08             	mov    0x8(%ebp),%eax
80102019:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010201d:	66 83 f8 03          	cmp    $0x3,%ax
80102021:	75 5c                	jne    8010207f <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102023:	8b 45 08             	mov    0x8(%ebp),%eax
80102026:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010202a:	66 85 c0             	test   %ax,%ax
8010202d:	78 20                	js     8010204f <writei+0x3f>
8010202f:	8b 45 08             	mov    0x8(%ebp),%eax
80102032:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102036:	66 83 f8 09          	cmp    $0x9,%ax
8010203a:	7f 13                	jg     8010204f <writei+0x3f>
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102043:	98                   	cwtl   
80102044:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
8010204b:	85 c0                	test   %eax,%eax
8010204d:	75 0a                	jne    80102059 <writei+0x49>
      return -1;
8010204f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102054:	e9 3b 01 00 00       	jmp    80102194 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
80102059:	8b 45 08             	mov    0x8(%ebp),%eax
8010205c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102060:	98                   	cwtl   
80102061:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
80102068:	8b 55 14             	mov    0x14(%ebp),%edx
8010206b:	83 ec 04             	sub    $0x4,%esp
8010206e:	52                   	push   %edx
8010206f:	ff 75 0c             	push   0xc(%ebp)
80102072:	ff 75 08             	push   0x8(%ebp)
80102075:	ff d0                	call   *%eax
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	e9 15 01 00 00       	jmp    80102194 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
8010207f:	8b 45 08             	mov    0x8(%ebp),%eax
80102082:	8b 40 58             	mov    0x58(%eax),%eax
80102085:	39 45 10             	cmp    %eax,0x10(%ebp)
80102088:	77 0d                	ja     80102097 <writei+0x87>
8010208a:	8b 55 10             	mov    0x10(%ebp),%edx
8010208d:	8b 45 14             	mov    0x14(%ebp),%eax
80102090:	01 d0                	add    %edx,%eax
80102092:	39 45 10             	cmp    %eax,0x10(%ebp)
80102095:	76 0a                	jbe    801020a1 <writei+0x91>
    return -1;
80102097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010209c:	e9 f3 00 00 00       	jmp    80102194 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020a1:	8b 55 10             	mov    0x10(%ebp),%edx
801020a4:	8b 45 14             	mov    0x14(%ebp),%eax
801020a7:	01 d0                	add    %edx,%eax
801020a9:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020ae:	76 0a                	jbe    801020ba <writei+0xaa>
    return -1;
801020b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020b5:	e9 da 00 00 00       	jmp    80102194 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020c1:	e9 97 00 00 00       	jmp    8010215d <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020c6:	8b 45 10             	mov    0x10(%ebp),%eax
801020c9:	c1 e8 09             	shr    $0x9,%eax
801020cc:	83 ec 08             	sub    $0x8,%esp
801020cf:	50                   	push   %eax
801020d0:	ff 75 08             	push   0x8(%ebp)
801020d3:	e8 4d fb ff ff       	call   80101c25 <bmap>
801020d8:	83 c4 10             	add    $0x10,%esp
801020db:	8b 55 08             	mov    0x8(%ebp),%edx
801020de:	8b 12                	mov    (%edx),%edx
801020e0:	83 ec 08             	sub    $0x8,%esp
801020e3:	50                   	push   %eax
801020e4:	52                   	push   %edx
801020e5:	e8 17 e1 ff ff       	call   80100201 <bread>
801020ea:	83 c4 10             	add    $0x10,%esp
801020ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020f0:	8b 45 10             	mov    0x10(%ebp),%eax
801020f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801020f8:	ba 00 02 00 00       	mov    $0x200,%edx
801020fd:	29 c2                	sub    %eax,%edx
801020ff:	8b 45 14             	mov    0x14(%ebp),%eax
80102102:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102105:	39 c2                	cmp    %eax,%edx
80102107:	0f 46 c2             	cmovbe %edx,%eax
8010210a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010210d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102110:	8d 50 5c             	lea    0x5c(%eax),%edx
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	25 ff 01 00 00       	and    $0x1ff,%eax
8010211b:	01 d0                	add    %edx,%eax
8010211d:	83 ec 04             	sub    $0x4,%esp
80102120:	ff 75 ec             	push   -0x14(%ebp)
80102123:	ff 75 0c             	push   0xc(%ebp)
80102126:	50                   	push   %eax
80102127:	e8 c4 2a 00 00       	call   80104bf0 <memmove>
8010212c:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010212f:	83 ec 0c             	sub    $0xc,%esp
80102132:	ff 75 f0             	push   -0x10(%ebp)
80102135:	e8 20 11 00 00       	call   8010325a <log_write>
8010213a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010213d:	83 ec 0c             	sub    $0xc,%esp
80102140:	ff 75 f0             	push   -0x10(%ebp)
80102143:	e8 3b e1 ff ff       	call   80100283 <brelse>
80102148:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010214b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010214e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102151:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102154:	01 45 10             	add    %eax,0x10(%ebp)
80102157:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010215a:	01 45 0c             	add    %eax,0xc(%ebp)
8010215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102160:	3b 45 14             	cmp    0x14(%ebp),%eax
80102163:	0f 82 5d ff ff ff    	jb     801020c6 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
80102169:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010216d:	74 22                	je     80102191 <writei+0x181>
8010216f:	8b 45 08             	mov    0x8(%ebp),%eax
80102172:	8b 40 58             	mov    0x58(%eax),%eax
80102175:	39 45 10             	cmp    %eax,0x10(%ebp)
80102178:	76 17                	jbe    80102191 <writei+0x181>
    ip->size = off;
8010217a:	8b 45 08             	mov    0x8(%ebp),%eax
8010217d:	8b 55 10             	mov    0x10(%ebp),%edx
80102180:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102183:	83 ec 0c             	sub    $0xc,%esp
80102186:	ff 75 08             	push   0x8(%ebp)
80102189:	e8 64 f6 ff ff       	call   801017f2 <iupdate>
8010218e:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102191:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102194:	c9                   	leave  
80102195:	c3                   	ret    

80102196 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102196:	55                   	push   %ebp
80102197:	89 e5                	mov    %esp,%ebp
80102199:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010219c:	83 ec 04             	sub    $0x4,%esp
8010219f:	6a 0e                	push   $0xe
801021a1:	ff 75 0c             	push   0xc(%ebp)
801021a4:	ff 75 08             	push   0x8(%ebp)
801021a7:	e8 da 2a 00 00       	call   80104c86 <strncmp>
801021ac:	83 c4 10             	add    $0x10,%esp
}
801021af:	c9                   	leave  
801021b0:	c3                   	ret    

801021b1 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021b1:	55                   	push   %ebp
801021b2:	89 e5                	mov    %esp,%ebp
801021b4:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021b7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ba:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021be:	66 83 f8 01          	cmp    $0x1,%ax
801021c2:	74 0d                	je     801021d1 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021c4:	83 ec 0c             	sub    $0xc,%esp
801021c7:	68 5d a6 10 80       	push   $0x8010a65d
801021cc:	e8 d8 e3 ff ff       	call   801005a9 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021d8:	eb 7b                	jmp    80102255 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021da:	6a 10                	push   $0x10
801021dc:	ff 75 f4             	push   -0xc(%ebp)
801021df:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021e2:	50                   	push   %eax
801021e3:	ff 75 08             	push   0x8(%ebp)
801021e6:	e8 d0 fc ff ff       	call   80101ebb <readi>
801021eb:	83 c4 10             	add    $0x10,%esp
801021ee:	83 f8 10             	cmp    $0x10,%eax
801021f1:	74 0d                	je     80102200 <dirlookup+0x4f>
      panic("dirlookup read");
801021f3:	83 ec 0c             	sub    $0xc,%esp
801021f6:	68 6f a6 10 80       	push   $0x8010a66f
801021fb:	e8 a9 e3 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
80102200:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102204:	66 85 c0             	test   %ax,%ax
80102207:	74 47                	je     80102250 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102209:	83 ec 08             	sub    $0x8,%esp
8010220c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010220f:	83 c0 02             	add    $0x2,%eax
80102212:	50                   	push   %eax
80102213:	ff 75 0c             	push   0xc(%ebp)
80102216:	e8 7b ff ff ff       	call   80102196 <namecmp>
8010221b:	83 c4 10             	add    $0x10,%esp
8010221e:	85 c0                	test   %eax,%eax
80102220:	75 2f                	jne    80102251 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102222:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102226:	74 08                	je     80102230 <dirlookup+0x7f>
        *poff = off;
80102228:	8b 45 10             	mov    0x10(%ebp),%eax
8010222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010222e:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102230:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102234:	0f b7 c0             	movzwl %ax,%eax
80102237:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010223a:	8b 45 08             	mov    0x8(%ebp),%eax
8010223d:	8b 00                	mov    (%eax),%eax
8010223f:	83 ec 08             	sub    $0x8,%esp
80102242:	ff 75 f0             	push   -0x10(%ebp)
80102245:	50                   	push   %eax
80102246:	e8 68 f6 ff ff       	call   801018b3 <iget>
8010224b:	83 c4 10             	add    $0x10,%esp
8010224e:	eb 19                	jmp    80102269 <dirlookup+0xb8>
      continue;
80102250:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102251:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102255:	8b 45 08             	mov    0x8(%ebp),%eax
80102258:	8b 40 58             	mov    0x58(%eax),%eax
8010225b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010225e:	0f 82 76 ff ff ff    	jb     801021da <dirlookup+0x29>
    }
  }

  return 0;
80102264:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102269:	c9                   	leave  
8010226a:	c3                   	ret    

8010226b <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010226b:	55                   	push   %ebp
8010226c:	89 e5                	mov    %esp,%ebp
8010226e:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102271:	83 ec 04             	sub    $0x4,%esp
80102274:	6a 00                	push   $0x0
80102276:	ff 75 0c             	push   0xc(%ebp)
80102279:	ff 75 08             	push   0x8(%ebp)
8010227c:	e8 30 ff ff ff       	call   801021b1 <dirlookup>
80102281:	83 c4 10             	add    $0x10,%esp
80102284:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102287:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010228b:	74 18                	je     801022a5 <dirlink+0x3a>
    iput(ip);
8010228d:	83 ec 0c             	sub    $0xc,%esp
80102290:	ff 75 f0             	push   -0x10(%ebp)
80102293:	e8 98 f8 ff ff       	call   80101b30 <iput>
80102298:	83 c4 10             	add    $0x10,%esp
    return -1;
8010229b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022a0:	e9 9c 00 00 00       	jmp    80102341 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022ac:	eb 39                	jmp    801022e7 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b1:	6a 10                	push   $0x10
801022b3:	50                   	push   %eax
801022b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b7:	50                   	push   %eax
801022b8:	ff 75 08             	push   0x8(%ebp)
801022bb:	e8 fb fb ff ff       	call   80101ebb <readi>
801022c0:	83 c4 10             	add    $0x10,%esp
801022c3:	83 f8 10             	cmp    $0x10,%eax
801022c6:	74 0d                	je     801022d5 <dirlink+0x6a>
      panic("dirlink read");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 7e a6 10 80       	push   $0x8010a67e
801022d0:	e8 d4 e2 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
801022d5:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022d9:	66 85 c0             	test   %ax,%ax
801022dc:	74 18                	je     801022f6 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e1:	83 c0 10             	add    $0x10,%eax
801022e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022e7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ea:	8b 50 58             	mov    0x58(%eax),%edx
801022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f0:	39 c2                	cmp    %eax,%edx
801022f2:	77 ba                	ja     801022ae <dirlink+0x43>
801022f4:	eb 01                	jmp    801022f7 <dirlink+0x8c>
      break;
801022f6:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022f7:	83 ec 04             	sub    $0x4,%esp
801022fa:	6a 0e                	push   $0xe
801022fc:	ff 75 0c             	push   0xc(%ebp)
801022ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102302:	83 c0 02             	add    $0x2,%eax
80102305:	50                   	push   %eax
80102306:	e8 d1 29 00 00       	call   80104cdc <strncpy>
8010230b:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010230e:	8b 45 10             	mov    0x10(%ebp),%eax
80102311:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102318:	6a 10                	push   $0x10
8010231a:	50                   	push   %eax
8010231b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010231e:	50                   	push   %eax
8010231f:	ff 75 08             	push   0x8(%ebp)
80102322:	e8 e9 fc ff ff       	call   80102010 <writei>
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	83 f8 10             	cmp    $0x10,%eax
8010232d:	74 0d                	je     8010233c <dirlink+0xd1>
    panic("dirlink");
8010232f:	83 ec 0c             	sub    $0xc,%esp
80102332:	68 8b a6 10 80       	push   $0x8010a68b
80102337:	e8 6d e2 ff ff       	call   801005a9 <panic>

  return 0;
8010233c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102341:	c9                   	leave  
80102342:	c3                   	ret    

80102343 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102343:	55                   	push   %ebp
80102344:	89 e5                	mov    %esp,%ebp
80102346:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102349:	eb 04                	jmp    8010234f <skipelem+0xc>
    path++;
8010234b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010234f:	8b 45 08             	mov    0x8(%ebp),%eax
80102352:	0f b6 00             	movzbl (%eax),%eax
80102355:	3c 2f                	cmp    $0x2f,%al
80102357:	74 f2                	je     8010234b <skipelem+0x8>
  if(*path == 0)
80102359:	8b 45 08             	mov    0x8(%ebp),%eax
8010235c:	0f b6 00             	movzbl (%eax),%eax
8010235f:	84 c0                	test   %al,%al
80102361:	75 07                	jne    8010236a <skipelem+0x27>
    return 0;
80102363:	b8 00 00 00 00       	mov    $0x0,%eax
80102368:	eb 77                	jmp    801023e1 <skipelem+0x9e>
  s = path;
8010236a:	8b 45 08             	mov    0x8(%ebp),%eax
8010236d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102370:	eb 04                	jmp    80102376 <skipelem+0x33>
    path++;
80102372:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102376:	8b 45 08             	mov    0x8(%ebp),%eax
80102379:	0f b6 00             	movzbl (%eax),%eax
8010237c:	3c 2f                	cmp    $0x2f,%al
8010237e:	74 0a                	je     8010238a <skipelem+0x47>
80102380:	8b 45 08             	mov    0x8(%ebp),%eax
80102383:	0f b6 00             	movzbl (%eax),%eax
80102386:	84 c0                	test   %al,%al
80102388:	75 e8                	jne    80102372 <skipelem+0x2f>
  len = path - s;
8010238a:	8b 45 08             	mov    0x8(%ebp),%eax
8010238d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102393:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102397:	7e 15                	jle    801023ae <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
80102399:	83 ec 04             	sub    $0x4,%esp
8010239c:	6a 0e                	push   $0xe
8010239e:	ff 75 f4             	push   -0xc(%ebp)
801023a1:	ff 75 0c             	push   0xc(%ebp)
801023a4:	e8 47 28 00 00       	call   80104bf0 <memmove>
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	eb 26                	jmp    801023d4 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b1:	83 ec 04             	sub    $0x4,%esp
801023b4:	50                   	push   %eax
801023b5:	ff 75 f4             	push   -0xc(%ebp)
801023b8:	ff 75 0c             	push   0xc(%ebp)
801023bb:	e8 30 28 00 00       	call   80104bf0 <memmove>
801023c0:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801023c9:	01 d0                	add    %edx,%eax
801023cb:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023ce:	eb 04                	jmp    801023d4 <skipelem+0x91>
    path++;
801023d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023d4:	8b 45 08             	mov    0x8(%ebp),%eax
801023d7:	0f b6 00             	movzbl (%eax),%eax
801023da:	3c 2f                	cmp    $0x2f,%al
801023dc:	74 f2                	je     801023d0 <skipelem+0x8d>
  return path;
801023de:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023e1:	c9                   	leave  
801023e2:	c3                   	ret    

801023e3 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023e3:	55                   	push   %ebp
801023e4:	89 e5                	mov    %esp,%ebp
801023e6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023e9:	8b 45 08             	mov    0x8(%ebp),%eax
801023ec:	0f b6 00             	movzbl (%eax),%eax
801023ef:	3c 2f                	cmp    $0x2f,%al
801023f1:	75 17                	jne    8010240a <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023f3:	83 ec 08             	sub    $0x8,%esp
801023f6:	6a 01                	push   $0x1
801023f8:	6a 01                	push   $0x1
801023fa:	e8 b4 f4 ff ff       	call   801018b3 <iget>
801023ff:	83 c4 10             	add    $0x10,%esp
80102402:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102405:	e9 ba 00 00 00       	jmp    801024c4 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
8010240a:	e8 06 16 00 00       	call   80103a15 <myproc>
8010240f:	8b 40 68             	mov    0x68(%eax),%eax
80102412:	83 ec 0c             	sub    $0xc,%esp
80102415:	50                   	push   %eax
80102416:	e8 7a f5 ff ff       	call   80101995 <idup>
8010241b:	83 c4 10             	add    $0x10,%esp
8010241e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102421:	e9 9e 00 00 00       	jmp    801024c4 <namex+0xe1>
    ilock(ip);
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	ff 75 f4             	push   -0xc(%ebp)
8010242c:	e8 9e f5 ff ff       	call   801019cf <ilock>
80102431:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102437:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010243b:	66 83 f8 01          	cmp    $0x1,%ax
8010243f:	74 18                	je     80102459 <namex+0x76>
      iunlockput(ip);
80102441:	83 ec 0c             	sub    $0xc,%esp
80102444:	ff 75 f4             	push   -0xc(%ebp)
80102447:	e8 b4 f7 ff ff       	call   80101c00 <iunlockput>
8010244c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010244f:	b8 00 00 00 00       	mov    $0x0,%eax
80102454:	e9 a7 00 00 00       	jmp    80102500 <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
80102459:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010245d:	74 20                	je     8010247f <namex+0x9c>
8010245f:	8b 45 08             	mov    0x8(%ebp),%eax
80102462:	0f b6 00             	movzbl (%eax),%eax
80102465:	84 c0                	test   %al,%al
80102467:	75 16                	jne    8010247f <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
80102469:	83 ec 0c             	sub    $0xc,%esp
8010246c:	ff 75 f4             	push   -0xc(%ebp)
8010246f:	e8 6e f6 ff ff       	call   80101ae2 <iunlock>
80102474:	83 c4 10             	add    $0x10,%esp
      return ip;
80102477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010247a:	e9 81 00 00 00       	jmp    80102500 <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010247f:	83 ec 04             	sub    $0x4,%esp
80102482:	6a 00                	push   $0x0
80102484:	ff 75 10             	push   0x10(%ebp)
80102487:	ff 75 f4             	push   -0xc(%ebp)
8010248a:	e8 22 fd ff ff       	call   801021b1 <dirlookup>
8010248f:	83 c4 10             	add    $0x10,%esp
80102492:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102495:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102499:	75 15                	jne    801024b0 <namex+0xcd>
      iunlockput(ip);
8010249b:	83 ec 0c             	sub    $0xc,%esp
8010249e:	ff 75 f4             	push   -0xc(%ebp)
801024a1:	e8 5a f7 ff ff       	call   80101c00 <iunlockput>
801024a6:	83 c4 10             	add    $0x10,%esp
      return 0;
801024a9:	b8 00 00 00 00       	mov    $0x0,%eax
801024ae:	eb 50                	jmp    80102500 <namex+0x11d>
    }
    iunlockput(ip);
801024b0:	83 ec 0c             	sub    $0xc,%esp
801024b3:	ff 75 f4             	push   -0xc(%ebp)
801024b6:	e8 45 f7 ff ff       	call   80101c00 <iunlockput>
801024bb:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024c4:	83 ec 08             	sub    $0x8,%esp
801024c7:	ff 75 10             	push   0x10(%ebp)
801024ca:	ff 75 08             	push   0x8(%ebp)
801024cd:	e8 71 fe ff ff       	call   80102343 <skipelem>
801024d2:	83 c4 10             	add    $0x10,%esp
801024d5:	89 45 08             	mov    %eax,0x8(%ebp)
801024d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024dc:	0f 85 44 ff ff ff    	jne    80102426 <namex+0x43>
  }
  if(nameiparent){
801024e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024e6:	74 15                	je     801024fd <namex+0x11a>
    iput(ip);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	ff 75 f4             	push   -0xc(%ebp)
801024ee:	e8 3d f6 ff ff       	call   80101b30 <iput>
801024f3:	83 c4 10             	add    $0x10,%esp
    return 0;
801024f6:	b8 00 00 00 00       	mov    $0x0,%eax
801024fb:	eb 03                	jmp    80102500 <namex+0x11d>
  }
  return ip;
801024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102500:	c9                   	leave  
80102501:	c3                   	ret    

80102502 <namei>:

struct inode*
namei(char *path)
{
80102502:	55                   	push   %ebp
80102503:	89 e5                	mov    %esp,%ebp
80102505:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102508:	83 ec 04             	sub    $0x4,%esp
8010250b:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010250e:	50                   	push   %eax
8010250f:	6a 00                	push   $0x0
80102511:	ff 75 08             	push   0x8(%ebp)
80102514:	e8 ca fe ff ff       	call   801023e3 <namex>
80102519:	83 c4 10             	add    $0x10,%esp
}
8010251c:	c9                   	leave  
8010251d:	c3                   	ret    

8010251e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010251e:	55                   	push   %ebp
8010251f:	89 e5                	mov    %esp,%ebp
80102521:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	ff 75 0c             	push   0xc(%ebp)
8010252a:	6a 01                	push   $0x1
8010252c:	ff 75 08             	push   0x8(%ebp)
8010252f:	e8 af fe ff ff       	call   801023e3 <namex>
80102534:	83 c4 10             	add    $0x10,%esp
}
80102537:	c9                   	leave  
80102538:	c3                   	ret    

80102539 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102539:	55                   	push   %ebp
8010253a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010253c:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102541:	8b 55 08             	mov    0x8(%ebp),%edx
80102544:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102546:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010254b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010254e:	5d                   	pop    %ebp
8010254f:	c3                   	ret    

80102550 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102553:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102558:	8b 55 08             	mov    0x8(%ebp),%edx
8010255b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010255d:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102562:	8b 55 0c             	mov    0xc(%ebp),%edx
80102565:	89 50 10             	mov    %edx,0x10(%eax)
}
80102568:	90                   	nop
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    

8010256b <ioapicinit>:

void
ioapicinit(void)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102571:	c7 05 b4 40 19 80 00 	movl   $0xfec00000,0x801940b4
80102578:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010257b:	6a 01                	push   $0x1
8010257d:	e8 b7 ff ff ff       	call   80102539 <ioapicread>
80102582:	83 c4 04             	add    $0x4,%esp
80102585:	c1 e8 10             	shr    $0x10,%eax
80102588:	25 ff 00 00 00       	and    $0xff,%eax
8010258d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102590:	6a 00                	push   $0x0
80102592:	e8 a2 ff ff ff       	call   80102539 <ioapicread>
80102597:	83 c4 04             	add    $0x4,%esp
8010259a:	c1 e8 18             	shr    $0x18,%eax
8010259d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801025a0:	0f b6 05 64 6e 19 80 	movzbl 0x80196e64,%eax
801025a7:	0f b6 c0             	movzbl %al,%eax
801025aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025ad:	74 10                	je     801025bf <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025af:	83 ec 0c             	sub    $0xc,%esp
801025b2:	68 94 a6 10 80       	push   $0x8010a694
801025b7:	e8 38 de ff ff       	call   801003f4 <cprintf>
801025bc:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801025bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025c6:	eb 3f                	jmp    80102607 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025cb:	83 c0 20             	add    $0x20,%eax
801025ce:	0d 00 00 01 00       	or     $0x10000,%eax
801025d3:	89 c2                	mov    %eax,%edx
801025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025d8:	83 c0 08             	add    $0x8,%eax
801025db:	01 c0                	add    %eax,%eax
801025dd:	83 ec 08             	sub    $0x8,%esp
801025e0:	52                   	push   %edx
801025e1:	50                   	push   %eax
801025e2:	e8 69 ff ff ff       	call   80102550 <ioapicwrite>
801025e7:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
801025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ed:	83 c0 08             	add    $0x8,%eax
801025f0:	01 c0                	add    %eax,%eax
801025f2:	83 c0 01             	add    $0x1,%eax
801025f5:	83 ec 08             	sub    $0x8,%esp
801025f8:	6a 00                	push   $0x0
801025fa:	50                   	push   %eax
801025fb:	e8 50 ff ff ff       	call   80102550 <ioapicwrite>
80102600:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102603:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010260a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010260d:	7e b9                	jle    801025c8 <ioapicinit+0x5d>
  }
}
8010260f:	90                   	nop
80102610:	90                   	nop
80102611:	c9                   	leave  
80102612:	c3                   	ret    

80102613 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102613:	55                   	push   %ebp
80102614:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102616:	8b 45 08             	mov    0x8(%ebp),%eax
80102619:	83 c0 20             	add    $0x20,%eax
8010261c:	89 c2                	mov    %eax,%edx
8010261e:	8b 45 08             	mov    0x8(%ebp),%eax
80102621:	83 c0 08             	add    $0x8,%eax
80102624:	01 c0                	add    %eax,%eax
80102626:	52                   	push   %edx
80102627:	50                   	push   %eax
80102628:	e8 23 ff ff ff       	call   80102550 <ioapicwrite>
8010262d:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102630:	8b 45 0c             	mov    0xc(%ebp),%eax
80102633:	c1 e0 18             	shl    $0x18,%eax
80102636:	89 c2                	mov    %eax,%edx
80102638:	8b 45 08             	mov    0x8(%ebp),%eax
8010263b:	83 c0 08             	add    $0x8,%eax
8010263e:	01 c0                	add    %eax,%eax
80102640:	83 c0 01             	add    $0x1,%eax
80102643:	52                   	push   %edx
80102644:	50                   	push   %eax
80102645:	e8 06 ff ff ff       	call   80102550 <ioapicwrite>
8010264a:	83 c4 08             	add    $0x8,%esp
}
8010264d:	90                   	nop
8010264e:	c9                   	leave  
8010264f:	c3                   	ret    

80102650 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102656:	83 ec 08             	sub    $0x8,%esp
80102659:	68 c6 a6 10 80       	push   $0x8010a6c6
8010265e:	68 c0 40 19 80       	push   $0x801940c0
80102663:	e8 31 22 00 00       	call   80104899 <initlock>
80102668:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
8010266b:	c7 05 f4 40 19 80 00 	movl   $0x0,0x801940f4
80102672:	00 00 00 
  freerange(vstart, vend);
80102675:	83 ec 08             	sub    $0x8,%esp
80102678:	ff 75 0c             	push   0xc(%ebp)
8010267b:	ff 75 08             	push   0x8(%ebp)
8010267e:	e8 2a 00 00 00       	call   801026ad <freerange>
80102683:	83 c4 10             	add    $0x10,%esp
}
80102686:	90                   	nop
80102687:	c9                   	leave  
80102688:	c3                   	ret    

80102689 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102689:	55                   	push   %ebp
8010268a:	89 e5                	mov    %esp,%ebp
8010268c:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
8010268f:	83 ec 08             	sub    $0x8,%esp
80102692:	ff 75 0c             	push   0xc(%ebp)
80102695:	ff 75 08             	push   0x8(%ebp)
80102698:	e8 10 00 00 00       	call   801026ad <freerange>
8010269d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
801026a0:	c7 05 f4 40 19 80 01 	movl   $0x1,0x801940f4
801026a7:	00 00 00 
}
801026aa:	90                   	nop
801026ab:	c9                   	leave  
801026ac:	c3                   	ret    

801026ad <freerange>:

void
freerange(void *vstart, void *vend)
{
801026ad:	55                   	push   %ebp
801026ae:	89 e5                	mov    %esp,%ebp
801026b0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801026b3:	8b 45 08             	mov    0x8(%ebp),%eax
801026b6:	05 ff 0f 00 00       	add    $0xfff,%eax
801026bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801026c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c3:	eb 15                	jmp    801026da <freerange+0x2d>
    kfree(p);
801026c5:	83 ec 0c             	sub    $0xc,%esp
801026c8:	ff 75 f4             	push   -0xc(%ebp)
801026cb:	e8 1b 00 00 00       	call   801026eb <kfree>
801026d0:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026dd:	05 00 10 00 00       	add    $0x1000,%eax
801026e2:	39 45 0c             	cmp    %eax,0xc(%ebp)
801026e5:	73 de                	jae    801026c5 <freerange+0x18>
}
801026e7:	90                   	nop
801026e8:	90                   	nop
801026e9:	c9                   	leave  
801026ea:	c3                   	ret    

801026eb <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026eb:	55                   	push   %ebp
801026ec:	89 e5                	mov    %esp,%ebp
801026ee:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026f1:	8b 45 08             	mov    0x8(%ebp),%eax
801026f4:	25 ff 0f 00 00       	and    $0xfff,%eax
801026f9:	85 c0                	test   %eax,%eax
801026fb:	75 18                	jne    80102715 <kfree+0x2a>
801026fd:	81 7d 08 00 90 19 80 	cmpl   $0x80199000,0x8(%ebp)
80102704:	72 0f                	jb     80102715 <kfree+0x2a>
80102706:	8b 45 08             	mov    0x8(%ebp),%eax
80102709:	05 00 00 00 80       	add    $0x80000000,%eax
8010270e:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80102713:	76 0d                	jbe    80102722 <kfree+0x37>
    panic("kfree");
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	68 cb a6 10 80       	push   $0x8010a6cb
8010271d:	e8 87 de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102722:	83 ec 04             	sub    $0x4,%esp
80102725:	68 00 10 00 00       	push   $0x1000
8010272a:	6a 01                	push   $0x1
8010272c:	ff 75 08             	push   0x8(%ebp)
8010272f:	e8 fd 23 00 00       	call   80104b31 <memset>
80102734:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102737:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010273c:	85 c0                	test   %eax,%eax
8010273e:	74 10                	je     80102750 <kfree+0x65>
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 c0 40 19 80       	push   $0x801940c0
80102748:	e8 6e 21 00 00       	call   801048bb <acquire>
8010274d:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102750:	8b 45 08             	mov    0x8(%ebp),%eax
80102753:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102756:	8b 15 f8 40 19 80    	mov    0x801940f8,%edx
8010275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275f:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102764:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
80102769:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010276e:	85 c0                	test   %eax,%eax
80102770:	74 10                	je     80102782 <kfree+0x97>
    release(&kmem.lock);
80102772:	83 ec 0c             	sub    $0xc,%esp
80102775:	68 c0 40 19 80       	push   $0x801940c0
8010277a:	e8 aa 21 00 00       	call   80104929 <release>
8010277f:	83 c4 10             	add    $0x10,%esp
}
80102782:	90                   	nop
80102783:	c9                   	leave  
80102784:	c3                   	ret    

80102785 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
80102788:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
8010278b:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102790:	85 c0                	test   %eax,%eax
80102792:	74 10                	je     801027a4 <kalloc+0x1f>
    acquire(&kmem.lock);
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 c0 40 19 80       	push   $0x801940c0
8010279c:	e8 1a 21 00 00       	call   801048bb <acquire>
801027a1:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
801027a4:	a1 f8 40 19 80       	mov    0x801940f8,%eax
801027a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
801027ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b0:	74 0a                	je     801027bc <kalloc+0x37>
    kmem.freelist = r->next;
801027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b5:	8b 00                	mov    (%eax),%eax
801027b7:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
801027bc:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027c1:	85 c0                	test   %eax,%eax
801027c3:	74 10                	je     801027d5 <kalloc+0x50>
    release(&kmem.lock);
801027c5:	83 ec 0c             	sub    $0xc,%esp
801027c8:	68 c0 40 19 80       	push   $0x801940c0
801027cd:	e8 57 21 00 00       	call   80104929 <release>
801027d2:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027d8:	c9                   	leave  
801027d9:	c3                   	ret    

801027da <inb>:
{
801027da:	55                   	push   %ebp
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	83 ec 14             	sub    $0x14,%esp
801027e0:	8b 45 08             	mov    0x8(%ebp),%eax
801027e3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801027eb:	89 c2                	mov    %eax,%edx
801027ed:	ec                   	in     (%dx),%al
801027ee:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801027f1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801027f5:	c9                   	leave  
801027f6:	c3                   	ret    

801027f7 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801027f7:	55                   	push   %ebp
801027f8:	89 e5                	mov    %esp,%ebp
801027fa:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
801027fd:	6a 64                	push   $0x64
801027ff:	e8 d6 ff ff ff       	call   801027da <inb>
80102804:	83 c4 04             	add    $0x4,%esp
80102807:	0f b6 c0             	movzbl %al,%eax
8010280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
8010280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102810:	83 e0 01             	and    $0x1,%eax
80102813:	85 c0                	test   %eax,%eax
80102815:	75 0a                	jne    80102821 <kbdgetc+0x2a>
    return -1;
80102817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010281c:	e9 23 01 00 00       	jmp    80102944 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102821:	6a 60                	push   $0x60
80102823:	e8 b2 ff ff ff       	call   801027da <inb>
80102828:	83 c4 04             	add    $0x4,%esp
8010282b:	0f b6 c0             	movzbl %al,%eax
8010282e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102831:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102838:	75 17                	jne    80102851 <kbdgetc+0x5a>
    shift |= E0ESC;
8010283a:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010283f:	83 c8 40             	or     $0x40,%eax
80102842:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
80102847:	b8 00 00 00 00       	mov    $0x0,%eax
8010284c:	e9 f3 00 00 00       	jmp    80102944 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102851:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102854:	25 80 00 00 00       	and    $0x80,%eax
80102859:	85 c0                	test   %eax,%eax
8010285b:	74 45                	je     801028a2 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010285d:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102862:	83 e0 40             	and    $0x40,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 08                	jne    80102871 <kbdgetc+0x7a>
80102869:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010286c:	83 e0 7f             	and    $0x7f,%eax
8010286f:	eb 03                	jmp    80102874 <kbdgetc+0x7d>
80102871:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102874:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102877:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010287a:	05 20 d0 10 80       	add    $0x8010d020,%eax
8010287f:	0f b6 00             	movzbl (%eax),%eax
80102882:	83 c8 40             	or     $0x40,%eax
80102885:	0f b6 c0             	movzbl %al,%eax
80102888:	f7 d0                	not    %eax
8010288a:	89 c2                	mov    %eax,%edx
8010288c:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102891:	21 d0                	and    %edx,%eax
80102893:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
80102898:	b8 00 00 00 00       	mov    $0x0,%eax
8010289d:	e9 a2 00 00 00       	jmp    80102944 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801028a2:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028a7:	83 e0 40             	and    $0x40,%eax
801028aa:	85 c0                	test   %eax,%eax
801028ac:	74 14                	je     801028c2 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028ae:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801028b5:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028ba:	83 e0 bf             	and    $0xffffffbf,%eax
801028bd:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  }

  shift |= shiftcode[data];
801028c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028c5:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028ca:	0f b6 00             	movzbl (%eax),%eax
801028cd:	0f b6 d0             	movzbl %al,%edx
801028d0:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028d5:	09 d0                	or     %edx,%eax
801028d7:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  shift ^= togglecode[data];
801028dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028df:	05 20 d1 10 80       	add    $0x8010d120,%eax
801028e4:	0f b6 00             	movzbl (%eax),%eax
801028e7:	0f b6 d0             	movzbl %al,%edx
801028ea:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028ef:	31 d0                	xor    %edx,%eax
801028f1:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  c = charcode[shift & (CTL | SHIFT)][data];
801028f6:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028fb:	83 e0 03             	and    $0x3,%eax
801028fe:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102905:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102908:	01 d0                	add    %edx,%eax
8010290a:	0f b6 00             	movzbl (%eax),%eax
8010290d:	0f b6 c0             	movzbl %al,%eax
80102910:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102913:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102918:	83 e0 08             	and    $0x8,%eax
8010291b:	85 c0                	test   %eax,%eax
8010291d:	74 22                	je     80102941 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010291f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102923:	76 0c                	jbe    80102931 <kbdgetc+0x13a>
80102925:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102929:	77 06                	ja     80102931 <kbdgetc+0x13a>
      c += 'A' - 'a';
8010292b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010292f:	eb 10                	jmp    80102941 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102931:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102935:	76 0a                	jbe    80102941 <kbdgetc+0x14a>
80102937:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
8010293b:	77 04                	ja     80102941 <kbdgetc+0x14a>
      c += 'a' - 'A';
8010293d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102941:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102944:	c9                   	leave  
80102945:	c3                   	ret    

80102946 <kbdintr>:

void
kbdintr(void)
{
80102946:	55                   	push   %ebp
80102947:	89 e5                	mov    %esp,%ebp
80102949:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
8010294c:	83 ec 0c             	sub    $0xc,%esp
8010294f:	68 f7 27 10 80       	push   $0x801027f7
80102954:	e8 7d de ff ff       	call   801007d6 <consoleintr>
80102959:	83 c4 10             	add    $0x10,%esp
}
8010295c:	90                   	nop
8010295d:	c9                   	leave  
8010295e:	c3                   	ret    

8010295f <inb>:
{
8010295f:	55                   	push   %ebp
80102960:	89 e5                	mov    %esp,%ebp
80102962:	83 ec 14             	sub    $0x14,%esp
80102965:	8b 45 08             	mov    0x8(%ebp),%eax
80102968:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102970:	89 c2                	mov    %eax,%edx
80102972:	ec                   	in     (%dx),%al
80102973:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102976:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010297a:	c9                   	leave  
8010297b:	c3                   	ret    

8010297c <outb>:
{
8010297c:	55                   	push   %ebp
8010297d:	89 e5                	mov    %esp,%ebp
8010297f:	83 ec 08             	sub    $0x8,%esp
80102982:	8b 45 08             	mov    0x8(%ebp),%eax
80102985:	8b 55 0c             	mov    0xc(%ebp),%edx
80102988:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010298c:	89 d0                	mov    %edx,%eax
8010298e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102995:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102999:	ee                   	out    %al,(%dx)
}
8010299a:	90                   	nop
8010299b:	c9                   	leave  
8010299c:	c3                   	ret    

8010299d <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
8010299d:	55                   	push   %ebp
8010299e:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801029a0:	8b 15 00 41 19 80    	mov    0x80194100,%edx
801029a6:	8b 45 08             	mov    0x8(%ebp),%eax
801029a9:	c1 e0 02             	shl    $0x2,%eax
801029ac:	01 c2                	add    %eax,%edx
801029ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801029b1:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801029b3:	a1 00 41 19 80       	mov    0x80194100,%eax
801029b8:	83 c0 20             	add    $0x20,%eax
801029bb:	8b 00                	mov    (%eax),%eax
}
801029bd:	90                   	nop
801029be:	5d                   	pop    %ebp
801029bf:	c3                   	ret    

801029c0 <lapicinit>:

void
lapicinit(void)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029c3:	a1 00 41 19 80       	mov    0x80194100,%eax
801029c8:	85 c0                	test   %eax,%eax
801029ca:	0f 84 0c 01 00 00    	je     80102adc <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801029d0:	68 3f 01 00 00       	push   $0x13f
801029d5:	6a 3c                	push   $0x3c
801029d7:	e8 c1 ff ff ff       	call   8010299d <lapicw>
801029dc:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801029df:	6a 0b                	push   $0xb
801029e1:	68 f8 00 00 00       	push   $0xf8
801029e6:	e8 b2 ff ff ff       	call   8010299d <lapicw>
801029eb:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801029ee:	68 20 00 02 00       	push   $0x20020
801029f3:	68 c8 00 00 00       	push   $0xc8
801029f8:	e8 a0 ff ff ff       	call   8010299d <lapicw>
801029fd:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102a00:	68 80 96 98 00       	push   $0x989680
80102a05:	68 e0 00 00 00       	push   $0xe0
80102a0a:	e8 8e ff ff ff       	call   8010299d <lapicw>
80102a0f:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102a12:	68 00 00 01 00       	push   $0x10000
80102a17:	68 d4 00 00 00       	push   $0xd4
80102a1c:	e8 7c ff ff ff       	call   8010299d <lapicw>
80102a21:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102a24:	68 00 00 01 00       	push   $0x10000
80102a29:	68 d8 00 00 00       	push   $0xd8
80102a2e:	e8 6a ff ff ff       	call   8010299d <lapicw>
80102a33:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a36:	a1 00 41 19 80       	mov    0x80194100,%eax
80102a3b:	83 c0 30             	add    $0x30,%eax
80102a3e:	8b 00                	mov    (%eax),%eax
80102a40:	c1 e8 10             	shr    $0x10,%eax
80102a43:	25 fc 00 00 00       	and    $0xfc,%eax
80102a48:	85 c0                	test   %eax,%eax
80102a4a:	74 12                	je     80102a5e <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102a4c:	68 00 00 01 00       	push   $0x10000
80102a51:	68 d0 00 00 00       	push   $0xd0
80102a56:	e8 42 ff ff ff       	call   8010299d <lapicw>
80102a5b:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102a5e:	6a 33                	push   $0x33
80102a60:	68 dc 00 00 00       	push   $0xdc
80102a65:	e8 33 ff ff ff       	call   8010299d <lapicw>
80102a6a:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102a6d:	6a 00                	push   $0x0
80102a6f:	68 a0 00 00 00       	push   $0xa0
80102a74:	e8 24 ff ff ff       	call   8010299d <lapicw>
80102a79:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102a7c:	6a 00                	push   $0x0
80102a7e:	68 a0 00 00 00       	push   $0xa0
80102a83:	e8 15 ff ff ff       	call   8010299d <lapicw>
80102a88:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102a8b:	6a 00                	push   $0x0
80102a8d:	6a 2c                	push   $0x2c
80102a8f:	e8 09 ff ff ff       	call   8010299d <lapicw>
80102a94:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102a97:	6a 00                	push   $0x0
80102a99:	68 c4 00 00 00       	push   $0xc4
80102a9e:	e8 fa fe ff ff       	call   8010299d <lapicw>
80102aa3:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102aa6:	68 00 85 08 00       	push   $0x88500
80102aab:	68 c0 00 00 00       	push   $0xc0
80102ab0:	e8 e8 fe ff ff       	call   8010299d <lapicw>
80102ab5:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ab8:	90                   	nop
80102ab9:	a1 00 41 19 80       	mov    0x80194100,%eax
80102abe:	05 00 03 00 00       	add    $0x300,%eax
80102ac3:	8b 00                	mov    (%eax),%eax
80102ac5:	25 00 10 00 00       	and    $0x1000,%eax
80102aca:	85 c0                	test   %eax,%eax
80102acc:	75 eb                	jne    80102ab9 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ace:	6a 00                	push   $0x0
80102ad0:	6a 20                	push   $0x20
80102ad2:	e8 c6 fe ff ff       	call   8010299d <lapicw>
80102ad7:	83 c4 08             	add    $0x8,%esp
80102ada:	eb 01                	jmp    80102add <lapicinit+0x11d>
    return;
80102adc:	90                   	nop
}
80102add:	c9                   	leave  
80102ade:	c3                   	ret    

80102adf <lapicid>:

int
lapicid(void)
{
80102adf:	55                   	push   %ebp
80102ae0:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102ae2:	a1 00 41 19 80       	mov    0x80194100,%eax
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	75 07                	jne    80102af2 <lapicid+0x13>
    return 0;
80102aeb:	b8 00 00 00 00       	mov    $0x0,%eax
80102af0:	eb 0d                	jmp    80102aff <lapicid+0x20>
  }
  return lapic[ID] >> 24;
80102af2:	a1 00 41 19 80       	mov    0x80194100,%eax
80102af7:	83 c0 20             	add    $0x20,%eax
80102afa:	8b 00                	mov    (%eax),%eax
80102afc:	c1 e8 18             	shr    $0x18,%eax
}
80102aff:	5d                   	pop    %ebp
80102b00:	c3                   	ret    

80102b01 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b01:	55                   	push   %ebp
80102b02:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b04:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b09:	85 c0                	test   %eax,%eax
80102b0b:	74 0c                	je     80102b19 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102b0d:	6a 00                	push   $0x0
80102b0f:	6a 2c                	push   $0x2c
80102b11:	e8 87 fe ff ff       	call   8010299d <lapicw>
80102b16:	83 c4 08             	add    $0x8,%esp
}
80102b19:	90                   	nop
80102b1a:	c9                   	leave  
80102b1b:	c3                   	ret    

80102b1c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b1c:	55                   	push   %ebp
80102b1d:	89 e5                	mov    %esp,%ebp
}
80102b1f:	90                   	nop
80102b20:	5d                   	pop    %ebp
80102b21:	c3                   	ret    

80102b22 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b22:	55                   	push   %ebp
80102b23:	89 e5                	mov    %esp,%ebp
80102b25:	83 ec 14             	sub    $0x14,%esp
80102b28:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2b:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102b2e:	6a 0f                	push   $0xf
80102b30:	6a 70                	push   $0x70
80102b32:	e8 45 fe ff ff       	call   8010297c <outb>
80102b37:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102b3a:	6a 0a                	push   $0xa
80102b3c:	6a 71                	push   $0x71
80102b3e:	e8 39 fe ff ff       	call   8010297c <outb>
80102b43:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102b46:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102b4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b50:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102b55:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b58:	c1 e8 04             	shr    $0x4,%eax
80102b5b:	89 c2                	mov    %eax,%edx
80102b5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b60:	83 c0 02             	add    $0x2,%eax
80102b63:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b66:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102b6a:	c1 e0 18             	shl    $0x18,%eax
80102b6d:	50                   	push   %eax
80102b6e:	68 c4 00 00 00       	push   $0xc4
80102b73:	e8 25 fe ff ff       	call   8010299d <lapicw>
80102b78:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102b7b:	68 00 c5 00 00       	push   $0xc500
80102b80:	68 c0 00 00 00       	push   $0xc0
80102b85:	e8 13 fe ff ff       	call   8010299d <lapicw>
80102b8a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102b8d:	68 c8 00 00 00       	push   $0xc8
80102b92:	e8 85 ff ff ff       	call   80102b1c <microdelay>
80102b97:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102b9a:	68 00 85 00 00       	push   $0x8500
80102b9f:	68 c0 00 00 00       	push   $0xc0
80102ba4:	e8 f4 fd ff ff       	call   8010299d <lapicw>
80102ba9:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102bac:	6a 64                	push   $0x64
80102bae:	e8 69 ff ff ff       	call   80102b1c <microdelay>
80102bb3:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102bbd:	eb 3d                	jmp    80102bfc <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80102bbf:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102bc3:	c1 e0 18             	shl    $0x18,%eax
80102bc6:	50                   	push   %eax
80102bc7:	68 c4 00 00 00       	push   $0xc4
80102bcc:	e8 cc fd ff ff       	call   8010299d <lapicw>
80102bd1:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bd7:	c1 e8 0c             	shr    $0xc,%eax
80102bda:	80 cc 06             	or     $0x6,%ah
80102bdd:	50                   	push   %eax
80102bde:	68 c0 00 00 00       	push   $0xc0
80102be3:	e8 b5 fd ff ff       	call   8010299d <lapicw>
80102be8:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102beb:	68 c8 00 00 00       	push   $0xc8
80102bf0:	e8 27 ff ff ff       	call   80102b1c <microdelay>
80102bf5:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80102bf8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102bfc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102c00:	7e bd                	jle    80102bbf <lapicstartap+0x9d>
  }
}
80102c02:	90                   	nop
80102c03:	90                   	nop
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    

80102c06 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102c06:	55                   	push   %ebp
80102c07:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80102c09:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0c:	0f b6 c0             	movzbl %al,%eax
80102c0f:	50                   	push   %eax
80102c10:	6a 70                	push   $0x70
80102c12:	e8 65 fd ff ff       	call   8010297c <outb>
80102c17:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102c1a:	68 c8 00 00 00       	push   $0xc8
80102c1f:	e8 f8 fe ff ff       	call   80102b1c <microdelay>
80102c24:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80102c27:	6a 71                	push   $0x71
80102c29:	e8 31 fd ff ff       	call   8010295f <inb>
80102c2e:	83 c4 04             	add    $0x4,%esp
80102c31:	0f b6 c0             	movzbl %al,%eax
}
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    

80102c36 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102c36:	55                   	push   %ebp
80102c37:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80102c39:	6a 00                	push   $0x0
80102c3b:	e8 c6 ff ff ff       	call   80102c06 <cmos_read>
80102c40:	83 c4 04             	add    $0x4,%esp
80102c43:	8b 55 08             	mov    0x8(%ebp),%edx
80102c46:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80102c48:	6a 02                	push   $0x2
80102c4a:	e8 b7 ff ff ff       	call   80102c06 <cmos_read>
80102c4f:	83 c4 04             	add    $0x4,%esp
80102c52:	8b 55 08             	mov    0x8(%ebp),%edx
80102c55:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80102c58:	6a 04                	push   $0x4
80102c5a:	e8 a7 ff ff ff       	call   80102c06 <cmos_read>
80102c5f:	83 c4 04             	add    $0x4,%esp
80102c62:	8b 55 08             	mov    0x8(%ebp),%edx
80102c65:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80102c68:	6a 07                	push   $0x7
80102c6a:	e8 97 ff ff ff       	call   80102c06 <cmos_read>
80102c6f:	83 c4 04             	add    $0x4,%esp
80102c72:	8b 55 08             	mov    0x8(%ebp),%edx
80102c75:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80102c78:	6a 08                	push   $0x8
80102c7a:	e8 87 ff ff ff       	call   80102c06 <cmos_read>
80102c7f:	83 c4 04             	add    $0x4,%esp
80102c82:	8b 55 08             	mov    0x8(%ebp),%edx
80102c85:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80102c88:	6a 09                	push   $0x9
80102c8a:	e8 77 ff ff ff       	call   80102c06 <cmos_read>
80102c8f:	83 c4 04             	add    $0x4,%esp
80102c92:	8b 55 08             	mov    0x8(%ebp),%edx
80102c95:	89 42 14             	mov    %eax,0x14(%edx)
}
80102c98:	90                   	nop
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    

80102c9b <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c9b:	55                   	push   %ebp
80102c9c:	89 e5                	mov    %esp,%ebp
80102c9e:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102ca1:	6a 0b                	push   $0xb
80102ca3:	e8 5e ff ff ff       	call   80102c06 <cmos_read>
80102ca8:	83 c4 04             	add    $0x4,%esp
80102cab:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80102cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb1:	83 e0 04             	and    $0x4,%eax
80102cb4:	85 c0                	test   %eax,%eax
80102cb6:	0f 94 c0             	sete   %al
80102cb9:	0f b6 c0             	movzbl %al,%eax
80102cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102cbf:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cc2:	50                   	push   %eax
80102cc3:	e8 6e ff ff ff       	call   80102c36 <fill_rtcdate>
80102cc8:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ccb:	6a 0a                	push   $0xa
80102ccd:	e8 34 ff ff ff       	call   80102c06 <cmos_read>
80102cd2:	83 c4 04             	add    $0x4,%esp
80102cd5:	25 80 00 00 00       	and    $0x80,%eax
80102cda:	85 c0                	test   %eax,%eax
80102cdc:	75 27                	jne    80102d05 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80102cde:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102ce1:	50                   	push   %eax
80102ce2:	e8 4f ff ff ff       	call   80102c36 <fill_rtcdate>
80102ce7:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cea:	83 ec 04             	sub    $0x4,%esp
80102ced:	6a 18                	push   $0x18
80102cef:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102cf2:	50                   	push   %eax
80102cf3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cf6:	50                   	push   %eax
80102cf7:	e8 9c 1e 00 00       	call   80104b98 <memcmp>
80102cfc:	83 c4 10             	add    $0x10,%esp
80102cff:	85 c0                	test   %eax,%eax
80102d01:	74 05                	je     80102d08 <cmostime+0x6d>
80102d03:	eb ba                	jmp    80102cbf <cmostime+0x24>
        continue;
80102d05:	90                   	nop
    fill_rtcdate(&t1);
80102d06:	eb b7                	jmp    80102cbf <cmostime+0x24>
      break;
80102d08:	90                   	nop
  }

  // convert
  if(bcd) {
80102d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102d0d:	0f 84 b4 00 00 00    	je     80102dc7 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d13:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d16:	c1 e8 04             	shr    $0x4,%eax
80102d19:	89 c2                	mov    %eax,%edx
80102d1b:	89 d0                	mov    %edx,%eax
80102d1d:	c1 e0 02             	shl    $0x2,%eax
80102d20:	01 d0                	add    %edx,%eax
80102d22:	01 c0                	add    %eax,%eax
80102d24:	89 c2                	mov    %eax,%edx
80102d26:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d29:	83 e0 0f             	and    $0xf,%eax
80102d2c:	01 d0                	add    %edx,%eax
80102d2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80102d31:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d34:	c1 e8 04             	shr    $0x4,%eax
80102d37:	89 c2                	mov    %eax,%edx
80102d39:	89 d0                	mov    %edx,%eax
80102d3b:	c1 e0 02             	shl    $0x2,%eax
80102d3e:	01 d0                	add    %edx,%eax
80102d40:	01 c0                	add    %eax,%eax
80102d42:	89 c2                	mov    %eax,%edx
80102d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d47:	83 e0 0f             	and    $0xf,%eax
80102d4a:	01 d0                	add    %edx,%eax
80102d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80102d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d52:	c1 e8 04             	shr    $0x4,%eax
80102d55:	89 c2                	mov    %eax,%edx
80102d57:	89 d0                	mov    %edx,%eax
80102d59:	c1 e0 02             	shl    $0x2,%eax
80102d5c:	01 d0                	add    %edx,%eax
80102d5e:	01 c0                	add    %eax,%eax
80102d60:	89 c2                	mov    %eax,%edx
80102d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d65:	83 e0 0f             	and    $0xf,%eax
80102d68:	01 d0                	add    %edx,%eax
80102d6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80102d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d70:	c1 e8 04             	shr    $0x4,%eax
80102d73:	89 c2                	mov    %eax,%edx
80102d75:	89 d0                	mov    %edx,%eax
80102d77:	c1 e0 02             	shl    $0x2,%eax
80102d7a:	01 d0                	add    %edx,%eax
80102d7c:	01 c0                	add    %eax,%eax
80102d7e:	89 c2                	mov    %eax,%edx
80102d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d83:	83 e0 0f             	and    $0xf,%eax
80102d86:	01 d0                	add    %edx,%eax
80102d88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80102d8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102d8e:	c1 e8 04             	shr    $0x4,%eax
80102d91:	89 c2                	mov    %eax,%edx
80102d93:	89 d0                	mov    %edx,%eax
80102d95:	c1 e0 02             	shl    $0x2,%eax
80102d98:	01 d0                	add    %edx,%eax
80102d9a:	01 c0                	add    %eax,%eax
80102d9c:	89 c2                	mov    %eax,%edx
80102d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102da1:	83 e0 0f             	and    $0xf,%eax
80102da4:	01 d0                	add    %edx,%eax
80102da6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80102da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dac:	c1 e8 04             	shr    $0x4,%eax
80102daf:	89 c2                	mov    %eax,%edx
80102db1:	89 d0                	mov    %edx,%eax
80102db3:	c1 e0 02             	shl    $0x2,%eax
80102db6:	01 d0                	add    %edx,%eax
80102db8:	01 c0                	add    %eax,%eax
80102dba:	89 c2                	mov    %eax,%edx
80102dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dbf:	83 e0 0f             	and    $0xf,%eax
80102dc2:	01 d0                	add    %edx,%eax
80102dc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80102dca:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102dcd:	89 10                	mov    %edx,(%eax)
80102dcf:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102dd2:	89 50 04             	mov    %edx,0x4(%eax)
80102dd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102dd8:	89 50 08             	mov    %edx,0x8(%eax)
80102ddb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102dde:	89 50 0c             	mov    %edx,0xc(%eax)
80102de1:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102de4:	89 50 10             	mov    %edx,0x10(%eax)
80102de7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102dea:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80102ded:	8b 45 08             	mov    0x8(%ebp),%eax
80102df0:	8b 40 14             	mov    0x14(%eax),%eax
80102df3:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102df9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dfc:	89 50 14             	mov    %edx,0x14(%eax)
}
80102dff:	90                   	nop
80102e00:	c9                   	leave  
80102e01:	c3                   	ret    

80102e02 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e02:	55                   	push   %ebp
80102e03:	89 e5                	mov    %esp,%ebp
80102e05:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e08:	83 ec 08             	sub    $0x8,%esp
80102e0b:	68 d1 a6 10 80       	push   $0x8010a6d1
80102e10:	68 20 41 19 80       	push   $0x80194120
80102e15:	e8 7f 1a 00 00       	call   80104899 <initlock>
80102e1a:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80102e1d:	83 ec 08             	sub    $0x8,%esp
80102e20:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e23:	50                   	push   %eax
80102e24:	ff 75 08             	push   0x8(%ebp)
80102e27:	e8 87 e5 ff ff       	call   801013b3 <readsb>
80102e2c:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80102e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e32:	a3 54 41 19 80       	mov    %eax,0x80194154
  log.size = sb.nlog;
80102e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102e3a:	a3 58 41 19 80       	mov    %eax,0x80194158
  log.dev = dev;
80102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102e42:	a3 64 41 19 80       	mov    %eax,0x80194164
  recover_from_log();
80102e47:	e8 b3 01 00 00       	call   80102fff <recover_from_log>
}
80102e4c:	90                   	nop
80102e4d:	c9                   	leave  
80102e4e:	c3                   	ret    

80102e4f <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e4f:	55                   	push   %ebp
80102e50:	89 e5                	mov    %esp,%ebp
80102e52:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e5c:	e9 95 00 00 00       	jmp    80102ef6 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e61:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e6a:	01 d0                	add    %edx,%eax
80102e6c:	83 c0 01             	add    $0x1,%eax
80102e6f:	89 c2                	mov    %eax,%edx
80102e71:	a1 64 41 19 80       	mov    0x80194164,%eax
80102e76:	83 ec 08             	sub    $0x8,%esp
80102e79:	52                   	push   %edx
80102e7a:	50                   	push   %eax
80102e7b:	e8 81 d3 ff ff       	call   80100201 <bread>
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e89:	83 c0 10             	add    $0x10,%eax
80102e8c:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
80102e93:	89 c2                	mov    %eax,%edx
80102e95:	a1 64 41 19 80       	mov    0x80194164,%eax
80102e9a:	83 ec 08             	sub    $0x8,%esp
80102e9d:	52                   	push   %edx
80102e9e:	50                   	push   %eax
80102e9f:	e8 5d d3 ff ff       	call   80100201 <bread>
80102ea4:	83 c4 10             	add    $0x10,%esp
80102ea7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ead:	8d 50 5c             	lea    0x5c(%eax),%edx
80102eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102eb3:	83 c0 5c             	add    $0x5c,%eax
80102eb6:	83 ec 04             	sub    $0x4,%esp
80102eb9:	68 00 02 00 00       	push   $0x200
80102ebe:	52                   	push   %edx
80102ebf:	50                   	push   %eax
80102ec0:	e8 2b 1d 00 00       	call   80104bf0 <memmove>
80102ec5:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80102ec8:	83 ec 0c             	sub    $0xc,%esp
80102ecb:	ff 75 ec             	push   -0x14(%ebp)
80102ece:	e8 67 d3 ff ff       	call   8010023a <bwrite>
80102ed3:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80102ed6:	83 ec 0c             	sub    $0xc,%esp
80102ed9:	ff 75 f0             	push   -0x10(%ebp)
80102edc:	e8 a2 d3 ff ff       	call   80100283 <brelse>
80102ee1:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80102ee4:	83 ec 0c             	sub    $0xc,%esp
80102ee7:	ff 75 ec             	push   -0x14(%ebp)
80102eea:	e8 94 d3 ff ff       	call   80100283 <brelse>
80102eef:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ef6:	a1 68 41 19 80       	mov    0x80194168,%eax
80102efb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102efe:	0f 8c 5d ff ff ff    	jl     80102e61 <install_trans+0x12>
  }
}
80102f04:	90                   	nop
80102f05:	90                   	nop
80102f06:	c9                   	leave  
80102f07:	c3                   	ret    

80102f08 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102f08:	55                   	push   %ebp
80102f09:	89 e5                	mov    %esp,%ebp
80102f0b:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f0e:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f13:	89 c2                	mov    %eax,%edx
80102f15:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f1a:	83 ec 08             	sub    $0x8,%esp
80102f1d:	52                   	push   %edx
80102f1e:	50                   	push   %eax
80102f1f:	e8 dd d2 ff ff       	call   80100201 <bread>
80102f24:	83 c4 10             	add    $0x10,%esp
80102f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80102f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f2d:	83 c0 5c             	add    $0x5c,%eax
80102f30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80102f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f36:	8b 00                	mov    (%eax),%eax
80102f38:	a3 68 41 19 80       	mov    %eax,0x80194168
  for (i = 0; i < log.lh.n; i++) {
80102f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f44:	eb 1b                	jmp    80102f61 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80102f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f4c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f53:	83 c2 10             	add    $0x10,%edx
80102f56:	89 04 95 2c 41 19 80 	mov    %eax,-0x7fe6bed4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f61:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f66:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f69:	7c db                	jl     80102f46 <read_head+0x3e>
  }
  brelse(buf);
80102f6b:	83 ec 0c             	sub    $0xc,%esp
80102f6e:	ff 75 f0             	push   -0x10(%ebp)
80102f71:	e8 0d d3 ff ff       	call   80100283 <brelse>
80102f76:	83 c4 10             	add    $0x10,%esp
}
80102f79:	90                   	nop
80102f7a:	c9                   	leave  
80102f7b:	c3                   	ret    

80102f7c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f7c:	55                   	push   %ebp
80102f7d:	89 e5                	mov    %esp,%ebp
80102f7f:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f82:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f87:	89 c2                	mov    %eax,%edx
80102f89:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f8e:	83 ec 08             	sub    $0x8,%esp
80102f91:	52                   	push   %edx
80102f92:	50                   	push   %eax
80102f93:	e8 69 d2 ff ff       	call   80100201 <bread>
80102f98:	83 c4 10             	add    $0x10,%esp
80102f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80102f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102fa1:	83 c0 5c             	add    $0x5c,%eax
80102fa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80102fa7:	8b 15 68 41 19 80    	mov    0x80194168,%edx
80102fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fb0:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fb9:	eb 1b                	jmp    80102fd6 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80102fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fbe:	83 c0 10             	add    $0x10,%eax
80102fc1:	8b 0c 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%ecx
80102fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102fce:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fd2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102fd6:	a1 68 41 19 80       	mov    0x80194168,%eax
80102fdb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102fde:	7c db                	jl     80102fbb <write_head+0x3f>
  }
  bwrite(buf);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	ff 75 f0             	push   -0x10(%ebp)
80102fe6:	e8 4f d2 ff ff       	call   8010023a <bwrite>
80102feb:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	ff 75 f0             	push   -0x10(%ebp)
80102ff4:	e8 8a d2 ff ff       	call   80100283 <brelse>
80102ff9:	83 c4 10             	add    $0x10,%esp
}
80102ffc:	90                   	nop
80102ffd:	c9                   	leave  
80102ffe:	c3                   	ret    

80102fff <recover_from_log>:

static void
recover_from_log(void)
{
80102fff:	55                   	push   %ebp
80103000:	89 e5                	mov    %esp,%ebp
80103002:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103005:	e8 fe fe ff ff       	call   80102f08 <read_head>
  install_trans(); // if committed, copy from log to disk
8010300a:	e8 40 fe ff ff       	call   80102e4f <install_trans>
  log.lh.n = 0;
8010300f:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
80103016:	00 00 00 
  write_head(); // clear the log
80103019:	e8 5e ff ff ff       	call   80102f7c <write_head>
}
8010301e:	90                   	nop
8010301f:	c9                   	leave  
80103020:	c3                   	ret    

80103021 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103021:	55                   	push   %ebp
80103022:	89 e5                	mov    %esp,%ebp
80103024:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103027:	83 ec 0c             	sub    $0xc,%esp
8010302a:	68 20 41 19 80       	push   $0x80194120
8010302f:	e8 87 18 00 00       	call   801048bb <acquire>
80103034:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103037:	a1 60 41 19 80       	mov    0x80194160,%eax
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 17                	je     80103057 <begin_op+0x36>
      sleep(&log, &log.lock);
80103040:	83 ec 08             	sub    $0x8,%esp
80103043:	68 20 41 19 80       	push   $0x80194120
80103048:	68 20 41 19 80       	push   $0x80194120
8010304d:	e8 06 13 00 00       	call   80104358 <sleep>
80103052:	83 c4 10             	add    $0x10,%esp
80103055:	eb e0                	jmp    80103037 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103057:	8b 0d 68 41 19 80    	mov    0x80194168,%ecx
8010305d:	a1 5c 41 19 80       	mov    0x8019415c,%eax
80103062:	8d 50 01             	lea    0x1(%eax),%edx
80103065:	89 d0                	mov    %edx,%eax
80103067:	c1 e0 02             	shl    $0x2,%eax
8010306a:	01 d0                	add    %edx,%eax
8010306c:	01 c0                	add    %eax,%eax
8010306e:	01 c8                	add    %ecx,%eax
80103070:	83 f8 1e             	cmp    $0x1e,%eax
80103073:	7e 17                	jle    8010308c <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103075:	83 ec 08             	sub    $0x8,%esp
80103078:	68 20 41 19 80       	push   $0x80194120
8010307d:	68 20 41 19 80       	push   $0x80194120
80103082:	e8 d1 12 00 00       	call   80104358 <sleep>
80103087:	83 c4 10             	add    $0x10,%esp
8010308a:	eb ab                	jmp    80103037 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010308c:	a1 5c 41 19 80       	mov    0x8019415c,%eax
80103091:	83 c0 01             	add    $0x1,%eax
80103094:	a3 5c 41 19 80       	mov    %eax,0x8019415c
      release(&log.lock);
80103099:	83 ec 0c             	sub    $0xc,%esp
8010309c:	68 20 41 19 80       	push   $0x80194120
801030a1:	e8 83 18 00 00       	call   80104929 <release>
801030a6:	83 c4 10             	add    $0x10,%esp
      break;
801030a9:	90                   	nop
    }
  }
}
801030aa:	90                   	nop
801030ab:	c9                   	leave  
801030ac:	c3                   	ret    

801030ad <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030ad:	55                   	push   %ebp
801030ae:	89 e5                	mov    %esp,%ebp
801030b0:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801030b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801030ba:	83 ec 0c             	sub    $0xc,%esp
801030bd:	68 20 41 19 80       	push   $0x80194120
801030c2:	e8 f4 17 00 00       	call   801048bb <acquire>
801030c7:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030ca:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030cf:	83 e8 01             	sub    $0x1,%eax
801030d2:	a3 5c 41 19 80       	mov    %eax,0x8019415c
  if(log.committing)
801030d7:	a1 60 41 19 80       	mov    0x80194160,%eax
801030dc:	85 c0                	test   %eax,%eax
801030de:	74 0d                	je     801030ed <end_op+0x40>
    panic("log.committing");
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	68 d5 a6 10 80       	push   $0x8010a6d5
801030e8:	e8 bc d4 ff ff       	call   801005a9 <panic>
  if(log.outstanding == 0){
801030ed:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030f2:	85 c0                	test   %eax,%eax
801030f4:	75 13                	jne    80103109 <end_op+0x5c>
    do_commit = 1;
801030f6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801030fd:	c7 05 60 41 19 80 01 	movl   $0x1,0x80194160
80103104:	00 00 00 
80103107:	eb 10                	jmp    80103119 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103109:	83 ec 0c             	sub    $0xc,%esp
8010310c:	68 20 41 19 80       	push   $0x80194120
80103111:	e8 29 13 00 00       	call   8010443f <wakeup>
80103116:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103119:	83 ec 0c             	sub    $0xc,%esp
8010311c:	68 20 41 19 80       	push   $0x80194120
80103121:	e8 03 18 00 00       	call   80104929 <release>
80103126:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010312d:	74 3f                	je     8010316e <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010312f:	e8 f6 00 00 00       	call   8010322a <commit>
    acquire(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 20 41 19 80       	push   $0x80194120
8010313c:	e8 7a 17 00 00       	call   801048bb <acquire>
80103141:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103144:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
8010314b:	00 00 00 
    wakeup(&log);
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	68 20 41 19 80       	push   $0x80194120
80103156:	e8 e4 12 00 00       	call   8010443f <wakeup>
8010315b:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010315e:	83 ec 0c             	sub    $0xc,%esp
80103161:	68 20 41 19 80       	push   $0x80194120
80103166:	e8 be 17 00 00       	call   80104929 <release>
8010316b:	83 c4 10             	add    $0x10,%esp
  }
}
8010316e:	90                   	nop
8010316f:	c9                   	leave  
80103170:	c3                   	ret    

80103171 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103171:	55                   	push   %ebp
80103172:	89 e5                	mov    %esp,%ebp
80103174:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010317e:	e9 95 00 00 00       	jmp    80103218 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103183:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80103189:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010318c:	01 d0                	add    %edx,%eax
8010318e:	83 c0 01             	add    $0x1,%eax
80103191:	89 c2                	mov    %eax,%edx
80103193:	a1 64 41 19 80       	mov    0x80194164,%eax
80103198:	83 ec 08             	sub    $0x8,%esp
8010319b:	52                   	push   %edx
8010319c:	50                   	push   %eax
8010319d:	e8 5f d0 ff ff       	call   80100201 <bread>
801031a2:	83 c4 10             	add    $0x10,%esp
801031a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031ab:	83 c0 10             	add    $0x10,%eax
801031ae:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801031b5:	89 c2                	mov    %eax,%edx
801031b7:	a1 64 41 19 80       	mov    0x80194164,%eax
801031bc:	83 ec 08             	sub    $0x8,%esp
801031bf:	52                   	push   %edx
801031c0:	50                   	push   %eax
801031c1:	e8 3b d0 ff ff       	call   80100201 <bread>
801031c6:	83 c4 10             	add    $0x10,%esp
801031c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801031cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031cf:	8d 50 5c             	lea    0x5c(%eax),%edx
801031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031d5:	83 c0 5c             	add    $0x5c,%eax
801031d8:	83 ec 04             	sub    $0x4,%esp
801031db:	68 00 02 00 00       	push   $0x200
801031e0:	52                   	push   %edx
801031e1:	50                   	push   %eax
801031e2:	e8 09 1a 00 00       	call   80104bf0 <memmove>
801031e7:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801031ea:	83 ec 0c             	sub    $0xc,%esp
801031ed:	ff 75 f0             	push   -0x10(%ebp)
801031f0:	e8 45 d0 ff ff       	call   8010023a <bwrite>
801031f5:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801031f8:	83 ec 0c             	sub    $0xc,%esp
801031fb:	ff 75 ec             	push   -0x14(%ebp)
801031fe:	e8 80 d0 ff ff       	call   80100283 <brelse>
80103203:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	ff 75 f0             	push   -0x10(%ebp)
8010320c:	e8 72 d0 ff ff       	call   80100283 <brelse>
80103211:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103218:	a1 68 41 19 80       	mov    0x80194168,%eax
8010321d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103220:	0f 8c 5d ff ff ff    	jl     80103183 <write_log+0x12>
  }
}
80103226:	90                   	nop
80103227:	90                   	nop
80103228:	c9                   	leave  
80103229:	c3                   	ret    

8010322a <commit>:

static void
commit()
{
8010322a:	55                   	push   %ebp
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103230:	a1 68 41 19 80       	mov    0x80194168,%eax
80103235:	85 c0                	test   %eax,%eax
80103237:	7e 1e                	jle    80103257 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103239:	e8 33 ff ff ff       	call   80103171 <write_log>
    write_head();    // Write header to disk -- the real commit
8010323e:	e8 39 fd ff ff       	call   80102f7c <write_head>
    install_trans(); // Now install writes to home locations
80103243:	e8 07 fc ff ff       	call   80102e4f <install_trans>
    log.lh.n = 0;
80103248:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
8010324f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103252:	e8 25 fd ff ff       	call   80102f7c <write_head>
  }
}
80103257:	90                   	nop
80103258:	c9                   	leave  
80103259:	c3                   	ret    

8010325a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010325a:	55                   	push   %ebp
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103260:	a1 68 41 19 80       	mov    0x80194168,%eax
80103265:	83 f8 1d             	cmp    $0x1d,%eax
80103268:	7f 12                	jg     8010327c <log_write+0x22>
8010326a:	a1 68 41 19 80       	mov    0x80194168,%eax
8010326f:	8b 15 58 41 19 80    	mov    0x80194158,%edx
80103275:	83 ea 01             	sub    $0x1,%edx
80103278:	39 d0                	cmp    %edx,%eax
8010327a:	7c 0d                	jl     80103289 <log_write+0x2f>
    panic("too big a transaction");
8010327c:	83 ec 0c             	sub    $0xc,%esp
8010327f:	68 e4 a6 10 80       	push   $0x8010a6e4
80103284:	e8 20 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
80103289:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	7f 0d                	jg     8010329f <log_write+0x45>
    panic("log_write outside of trans");
80103292:	83 ec 0c             	sub    $0xc,%esp
80103295:	68 fa a6 10 80       	push   $0x8010a6fa
8010329a:	e8 0a d3 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
8010329f:	83 ec 0c             	sub    $0xc,%esp
801032a2:	68 20 41 19 80       	push   $0x80194120
801032a7:	e8 0f 16 00 00       	call   801048bb <acquire>
801032ac:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801032af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032b6:	eb 1d                	jmp    801032d5 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032bb:	83 c0 10             	add    $0x10,%eax
801032be:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801032c5:	89 c2                	mov    %eax,%edx
801032c7:	8b 45 08             	mov    0x8(%ebp),%eax
801032ca:	8b 40 08             	mov    0x8(%eax),%eax
801032cd:	39 c2                	cmp    %eax,%edx
801032cf:	74 10                	je     801032e1 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801032d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032d5:	a1 68 41 19 80       	mov    0x80194168,%eax
801032da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801032dd:	7c d9                	jl     801032b8 <log_write+0x5e>
801032df:	eb 01                	jmp    801032e2 <log_write+0x88>
      break;
801032e1:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801032e2:	8b 45 08             	mov    0x8(%ebp),%eax
801032e5:	8b 40 08             	mov    0x8(%eax),%eax
801032e8:	89 c2                	mov    %eax,%edx
801032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032ed:	83 c0 10             	add    $0x10,%eax
801032f0:	89 14 85 2c 41 19 80 	mov    %edx,-0x7fe6bed4(,%eax,4)
  if (i == log.lh.n)
801032f7:	a1 68 41 19 80       	mov    0x80194168,%eax
801032fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801032ff:	75 0d                	jne    8010330e <log_write+0xb4>
    log.lh.n++;
80103301:	a1 68 41 19 80       	mov    0x80194168,%eax
80103306:	83 c0 01             	add    $0x1,%eax
80103309:	a3 68 41 19 80       	mov    %eax,0x80194168
  b->flags |= B_DIRTY; // prevent eviction
8010330e:	8b 45 08             	mov    0x8(%ebp),%eax
80103311:	8b 00                	mov    (%eax),%eax
80103313:	83 c8 04             	or     $0x4,%eax
80103316:	89 c2                	mov    %eax,%edx
80103318:	8b 45 08             	mov    0x8(%ebp),%eax
8010331b:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010331d:	83 ec 0c             	sub    $0xc,%esp
80103320:	68 20 41 19 80       	push   $0x80194120
80103325:	e8 ff 15 00 00       	call   80104929 <release>
8010332a:	83 c4 10             	add    $0x10,%esp
}
8010332d:	90                   	nop
8010332e:	c9                   	leave  
8010332f:	c3                   	ret    

80103330 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103336:	8b 55 08             	mov    0x8(%ebp),%edx
80103339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010333c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010333f:	f0 87 02             	lock xchg %eax,(%edx)
80103342:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103348:	c9                   	leave  
80103349:	c3                   	ret    

8010334a <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010334a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010334e:	83 e4 f0             	and    $0xfffffff0,%esp
80103351:	ff 71 fc             	push   -0x4(%ecx)
80103354:	55                   	push   %ebp
80103355:	89 e5                	mov    %esp,%ebp
80103357:	51                   	push   %ecx
80103358:	83 ec 04             	sub    $0x4,%esp
  graphic_init();
8010335b:	e8 0c 4f 00 00       	call   8010826c <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103360:	83 ec 08             	sub    $0x8,%esp
80103363:	68 00 00 40 80       	push   $0x80400000
80103368:	68 00 90 19 80       	push   $0x80199000
8010336d:	e8 de f2 ff ff       	call   80102650 <kinit1>
80103372:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103375:	e8 41 44 00 00       	call   801077bb <kvmalloc>
  mpinit_uefi();
8010337a:	e8 b3 4c 00 00       	call   80108032 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010337f:	e8 3c f6 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103384:	e8 ca 3e 00 00       	call   80107253 <seginit>
  picinit();    // disable pic
80103389:	e8 9d 01 00 00       	call   8010352b <picinit>
  ioapicinit();    // another interrupt controller
8010338e:	e8 d8 f1 ff ff       	call   8010256b <ioapicinit>
  consoleinit();   // console hardware
80103393:	e8 67 d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
80103398:	e8 4f 32 00 00       	call   801065ec <uartinit>
  pinit();         // process table
8010339d:	e8 c2 05 00 00       	call   80103964 <pinit>
  tvinit();        // trap vectors
801033a2:	e8 28 2c 00 00       	call   80105fcf <tvinit>
  binit();         // buffer cache
801033a7:	e8 ba cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033ac:	e8 f3 db ff ff       	call   80100fa4 <fileinit>
  ideinit();       // disk 
801033b1:	e8 f7 6f 00 00       	call   8010a3ad <ideinit>
  startothers();   // start other processors
801033b6:	e8 8a 00 00 00       	call   80103445 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033bb:	83 ec 08             	sub    $0x8,%esp
801033be:	68 00 00 00 a0       	push   $0xa0000000
801033c3:	68 00 00 40 80       	push   $0x80400000
801033c8:	e8 bc f2 ff ff       	call   80102689 <kinit2>
801033cd:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033d0:	e8 f0 50 00 00       	call   801084c5 <pci_init>
  arp_scan();
801033d5:	e8 27 5e 00 00       	call   80109201 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801033da:	e8 95 07 00 00       	call   80103b74 <userinit>

  mpmain();        // finish this processor's setup
801033df:	e8 1a 00 00 00       	call   801033fe <mpmain>

801033e4 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801033e4:	55                   	push   %ebp
801033e5:	89 e5                	mov    %esp,%ebp
801033e7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033ea:	e8 e4 43 00 00       	call   801077d3 <switchkvm>
  seginit();
801033ef:	e8 5f 3e 00 00       	call   80107253 <seginit>
  lapicinit();
801033f4:	e8 c7 f5 ff ff       	call   801029c0 <lapicinit>
  mpmain();
801033f9:	e8 00 00 00 00       	call   801033fe <mpmain>

801033fe <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801033fe:	55                   	push   %ebp
801033ff:	89 e5                	mov    %esp,%ebp
80103401:	53                   	push   %ebx
80103402:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103405:	e8 78 05 00 00       	call   80103982 <cpuid>
8010340a:	89 c3                	mov    %eax,%ebx
8010340c:	e8 71 05 00 00       	call   80103982 <cpuid>
80103411:	83 ec 04             	sub    $0x4,%esp
80103414:	53                   	push   %ebx
80103415:	50                   	push   %eax
80103416:	68 15 a7 10 80       	push   $0x8010a715
8010341b:	e8 d4 cf ff ff       	call   801003f4 <cprintf>
80103420:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103423:	e8 1d 2d 00 00       	call   80106145 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103428:	e8 70 05 00 00       	call   8010399d <mycpu>
8010342d:	05 a0 00 00 00       	add    $0xa0,%eax
80103432:	83 ec 08             	sub    $0x8,%esp
80103435:	6a 01                	push   $0x1
80103437:	50                   	push   %eax
80103438:	e8 f3 fe ff ff       	call   80103330 <xchg>
8010343d:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103440:	e8 22 0d 00 00       	call   80104167 <scheduler>

80103445 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103445:	55                   	push   %ebp
80103446:	89 e5                	mov    %esp,%ebp
80103448:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
8010344b:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103452:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103457:	83 ec 04             	sub    $0x4,%esp
8010345a:	50                   	push   %eax
8010345b:	68 18 f5 10 80       	push   $0x8010f518
80103460:	ff 75 f0             	push   -0x10(%ebp)
80103463:	e8 88 17 00 00       	call   80104bf0 <memmove>
80103468:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010346b:	c7 45 f4 a0 6b 19 80 	movl   $0x80196ba0,-0xc(%ebp)
80103472:	eb 79                	jmp    801034ed <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
80103474:	e8 24 05 00 00       	call   8010399d <mycpu>
80103479:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010347c:	74 67                	je     801034e5 <startothers+0xa0>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010347e:	e8 02 f3 ff ff       	call   80102785 <kalloc>
80103483:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103489:	83 e8 04             	sub    $0x4,%eax
8010348c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010348f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103495:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103497:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010349a:	83 e8 08             	sub    $0x8,%eax
8010349d:	c7 00 e4 33 10 80    	movl   $0x801033e4,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034a3:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801034a8:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b1:	83 e8 0c             	sub    $0xc,%eax
801034b4:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801034b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c2:	0f b6 00             	movzbl (%eax),%eax
801034c5:	0f b6 c0             	movzbl %al,%eax
801034c8:	83 ec 08             	sub    $0x8,%esp
801034cb:	52                   	push   %edx
801034cc:	50                   	push   %eax
801034cd:	e8 50 f6 ff ff       	call   80102b22 <lapicstartap>
801034d2:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034d5:	90                   	nop
801034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034d9:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801034df:	85 c0                	test   %eax,%eax
801034e1:	74 f3                	je     801034d6 <startothers+0x91>
801034e3:	eb 01                	jmp    801034e6 <startothers+0xa1>
      continue;
801034e5:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
801034e6:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801034ed:	a1 60 6e 19 80       	mov    0x80196e60,%eax
801034f2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801034f8:	05 a0 6b 19 80       	add    $0x80196ba0,%eax
801034fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103500:	0f 82 6e ff ff ff    	jb     80103474 <startothers+0x2f>
      ;
  }
}
80103506:	90                   	nop
80103507:	90                   	nop
80103508:	c9                   	leave  
80103509:	c3                   	ret    

8010350a <outb>:
{
8010350a:	55                   	push   %ebp
8010350b:	89 e5                	mov    %esp,%ebp
8010350d:	83 ec 08             	sub    $0x8,%esp
80103510:	8b 45 08             	mov    0x8(%ebp),%eax
80103513:	8b 55 0c             	mov    0xc(%ebp),%edx
80103516:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010351a:	89 d0                	mov    %edx,%eax
8010351c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103523:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103527:	ee                   	out    %al,(%dx)
}
80103528:	90                   	nop
80103529:	c9                   	leave  
8010352a:	c3                   	ret    

8010352b <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
8010352b:	55                   	push   %ebp
8010352c:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010352e:	68 ff 00 00 00       	push   $0xff
80103533:	6a 21                	push   $0x21
80103535:	e8 d0 ff ff ff       	call   8010350a <outb>
8010353a:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010353d:	68 ff 00 00 00       	push   $0xff
80103542:	68 a1 00 00 00       	push   $0xa1
80103547:	e8 be ff ff ff       	call   8010350a <outb>
8010354c:	83 c4 08             	add    $0x8,%esp
}
8010354f:	90                   	nop
80103550:	c9                   	leave  
80103551:	c3                   	ret    

80103552 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103552:	55                   	push   %ebp
80103553:	89 e5                	mov    %esp,%ebp
80103555:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010355f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103568:	8b 45 0c             	mov    0xc(%ebp),%eax
8010356b:	8b 10                	mov    (%eax),%edx
8010356d:	8b 45 08             	mov    0x8(%ebp),%eax
80103570:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103572:	e8 4b da ff ff       	call   80100fc2 <filealloc>
80103577:	8b 55 08             	mov    0x8(%ebp),%edx
8010357a:	89 02                	mov    %eax,(%edx)
8010357c:	8b 45 08             	mov    0x8(%ebp),%eax
8010357f:	8b 00                	mov    (%eax),%eax
80103581:	85 c0                	test   %eax,%eax
80103583:	0f 84 c8 00 00 00    	je     80103651 <pipealloc+0xff>
80103589:	e8 34 da ff ff       	call   80100fc2 <filealloc>
8010358e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103591:	89 02                	mov    %eax,(%edx)
80103593:	8b 45 0c             	mov    0xc(%ebp),%eax
80103596:	8b 00                	mov    (%eax),%eax
80103598:	85 c0                	test   %eax,%eax
8010359a:	0f 84 b1 00 00 00    	je     80103651 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035a0:	e8 e0 f1 ff ff       	call   80102785 <kalloc>
801035a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035ac:	0f 84 a2 00 00 00    	je     80103654 <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035b5:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035bc:	00 00 00 
  p->writeopen = 1;
801035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035c2:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035c9:	00 00 00 
  p->nwrite = 0;
801035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035cf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035d6:	00 00 00 
  p->nread = 0;
801035d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035dc:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035e3:	00 00 00 
  initlock(&p->lock, "pipe");
801035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035e9:	83 ec 08             	sub    $0x8,%esp
801035ec:	68 29 a7 10 80       	push   $0x8010a729
801035f1:	50                   	push   %eax
801035f2:	e8 a2 12 00 00       	call   80104899 <initlock>
801035f7:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035fa:	8b 45 08             	mov    0x8(%ebp),%eax
801035fd:	8b 00                	mov    (%eax),%eax
801035ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103605:	8b 45 08             	mov    0x8(%ebp),%eax
80103608:	8b 00                	mov    (%eax),%eax
8010360a:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010360e:	8b 45 08             	mov    0x8(%ebp),%eax
80103611:	8b 00                	mov    (%eax),%eax
80103613:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103617:	8b 45 08             	mov    0x8(%ebp),%eax
8010361a:	8b 00                	mov    (%eax),%eax
8010361c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010361f:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103622:	8b 45 0c             	mov    0xc(%ebp),%eax
80103625:	8b 00                	mov    (%eax),%eax
80103627:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010362d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103630:	8b 00                	mov    (%eax),%eax
80103632:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103636:	8b 45 0c             	mov    0xc(%ebp),%eax
80103639:	8b 00                	mov    (%eax),%eax
8010363b:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010363f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103642:	8b 00                	mov    (%eax),%eax
80103644:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103647:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010364a:	b8 00 00 00 00       	mov    $0x0,%eax
8010364f:	eb 51                	jmp    801036a2 <pipealloc+0x150>
    goto bad;
80103651:	90                   	nop
80103652:	eb 01                	jmp    80103655 <pipealloc+0x103>
    goto bad;
80103654:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103659:	74 0e                	je     80103669 <pipealloc+0x117>
    kfree((char*)p);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	ff 75 f4             	push   -0xc(%ebp)
80103661:	e8 85 f0 ff ff       	call   801026eb <kfree>
80103666:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103669:	8b 45 08             	mov    0x8(%ebp),%eax
8010366c:	8b 00                	mov    (%eax),%eax
8010366e:	85 c0                	test   %eax,%eax
80103670:	74 11                	je     80103683 <pipealloc+0x131>
    fileclose(*f0);
80103672:	8b 45 08             	mov    0x8(%ebp),%eax
80103675:	8b 00                	mov    (%eax),%eax
80103677:	83 ec 0c             	sub    $0xc,%esp
8010367a:	50                   	push   %eax
8010367b:	e8 00 da ff ff       	call   80101080 <fileclose>
80103680:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103683:	8b 45 0c             	mov    0xc(%ebp),%eax
80103686:	8b 00                	mov    (%eax),%eax
80103688:	85 c0                	test   %eax,%eax
8010368a:	74 11                	je     8010369d <pipealloc+0x14b>
    fileclose(*f1);
8010368c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010368f:	8b 00                	mov    (%eax),%eax
80103691:	83 ec 0c             	sub    $0xc,%esp
80103694:	50                   	push   %eax
80103695:	e8 e6 d9 ff ff       	call   80101080 <fileclose>
8010369a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010369d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036a2:	c9                   	leave  
801036a3:	c3                   	ret    

801036a4 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801036aa:	8b 45 08             	mov    0x8(%ebp),%eax
801036ad:	83 ec 0c             	sub    $0xc,%esp
801036b0:	50                   	push   %eax
801036b1:	e8 05 12 00 00       	call   801048bb <acquire>
801036b6:	83 c4 10             	add    $0x10,%esp
  if(writable){
801036b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801036bd:	74 23                	je     801036e2 <pipeclose+0x3e>
    p->writeopen = 0;
801036bf:	8b 45 08             	mov    0x8(%ebp),%eax
801036c2:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801036c9:	00 00 00 
    wakeup(&p->nread);
801036cc:	8b 45 08             	mov    0x8(%ebp),%eax
801036cf:	05 34 02 00 00       	add    $0x234,%eax
801036d4:	83 ec 0c             	sub    $0xc,%esp
801036d7:	50                   	push   %eax
801036d8:	e8 62 0d 00 00       	call   8010443f <wakeup>
801036dd:	83 c4 10             	add    $0x10,%esp
801036e0:	eb 21                	jmp    80103703 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801036e2:	8b 45 08             	mov    0x8(%ebp),%eax
801036e5:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801036ec:	00 00 00 
    wakeup(&p->nwrite);
801036ef:	8b 45 08             	mov    0x8(%ebp),%eax
801036f2:	05 38 02 00 00       	add    $0x238,%eax
801036f7:	83 ec 0c             	sub    $0xc,%esp
801036fa:	50                   	push   %eax
801036fb:	e8 3f 0d 00 00       	call   8010443f <wakeup>
80103700:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103703:	8b 45 08             	mov    0x8(%ebp),%eax
80103706:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010370c:	85 c0                	test   %eax,%eax
8010370e:	75 2c                	jne    8010373c <pipeclose+0x98>
80103710:	8b 45 08             	mov    0x8(%ebp),%eax
80103713:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 1f                	jne    8010373c <pipeclose+0x98>
    release(&p->lock);
8010371d:	8b 45 08             	mov    0x8(%ebp),%eax
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	50                   	push   %eax
80103724:	e8 00 12 00 00       	call   80104929 <release>
80103729:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010372c:	83 ec 0c             	sub    $0xc,%esp
8010372f:	ff 75 08             	push   0x8(%ebp)
80103732:	e8 b4 ef ff ff       	call   801026eb <kfree>
80103737:	83 c4 10             	add    $0x10,%esp
8010373a:	eb 10                	jmp    8010374c <pipeclose+0xa8>
  } else
    release(&p->lock);
8010373c:	8b 45 08             	mov    0x8(%ebp),%eax
8010373f:	83 ec 0c             	sub    $0xc,%esp
80103742:	50                   	push   %eax
80103743:	e8 e1 11 00 00       	call   80104929 <release>
80103748:	83 c4 10             	add    $0x10,%esp
}
8010374b:	90                   	nop
8010374c:	90                   	nop
8010374d:	c9                   	leave  
8010374e:	c3                   	ret    

8010374f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010374f:	55                   	push   %ebp
80103750:	89 e5                	mov    %esp,%ebp
80103752:	53                   	push   %ebx
80103753:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103756:	8b 45 08             	mov    0x8(%ebp),%eax
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	50                   	push   %eax
8010375d:	e8 59 11 00 00       	call   801048bb <acquire>
80103762:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010376c:	e9 ad 00 00 00       	jmp    8010381e <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80103771:	8b 45 08             	mov    0x8(%ebp),%eax
80103774:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010377a:	85 c0                	test   %eax,%eax
8010377c:	74 0c                	je     8010378a <pipewrite+0x3b>
8010377e:	e8 92 02 00 00       	call   80103a15 <myproc>
80103783:	8b 40 24             	mov    0x24(%eax),%eax
80103786:	85 c0                	test   %eax,%eax
80103788:	74 19                	je     801037a3 <pipewrite+0x54>
        release(&p->lock);
8010378a:	8b 45 08             	mov    0x8(%ebp),%eax
8010378d:	83 ec 0c             	sub    $0xc,%esp
80103790:	50                   	push   %eax
80103791:	e8 93 11 00 00       	call   80104929 <release>
80103796:	83 c4 10             	add    $0x10,%esp
        return -1;
80103799:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010379e:	e9 a9 00 00 00       	jmp    8010384c <pipewrite+0xfd>
      }
      wakeup(&p->nread);
801037a3:	8b 45 08             	mov    0x8(%ebp),%eax
801037a6:	05 34 02 00 00       	add    $0x234,%eax
801037ab:	83 ec 0c             	sub    $0xc,%esp
801037ae:	50                   	push   %eax
801037af:	e8 8b 0c 00 00       	call   8010443f <wakeup>
801037b4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037b7:	8b 45 08             	mov    0x8(%ebp),%eax
801037ba:	8b 55 08             	mov    0x8(%ebp),%edx
801037bd:	81 c2 38 02 00 00    	add    $0x238,%edx
801037c3:	83 ec 08             	sub    $0x8,%esp
801037c6:	50                   	push   %eax
801037c7:	52                   	push   %edx
801037c8:	e8 8b 0b 00 00       	call   80104358 <sleep>
801037cd:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d0:	8b 45 08             	mov    0x8(%ebp),%eax
801037d3:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801037d9:	8b 45 08             	mov    0x8(%ebp),%eax
801037dc:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801037e2:	05 00 02 00 00       	add    $0x200,%eax
801037e7:	39 c2                	cmp    %eax,%edx
801037e9:	74 86                	je     80103771 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801037f1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801037f4:	8b 45 08             	mov    0x8(%ebp),%eax
801037f7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801037fd:	8d 48 01             	lea    0x1(%eax),%ecx
80103800:	8b 55 08             	mov    0x8(%ebp),%edx
80103803:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103809:	25 ff 01 00 00       	and    $0x1ff,%eax
8010380e:	89 c1                	mov    %eax,%ecx
80103810:	0f b6 13             	movzbl (%ebx),%edx
80103813:	8b 45 08             	mov    0x8(%ebp),%eax
80103816:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
8010381a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103821:	3b 45 10             	cmp    0x10(%ebp),%eax
80103824:	7c aa                	jl     801037d0 <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103826:	8b 45 08             	mov    0x8(%ebp),%eax
80103829:	05 34 02 00 00       	add    $0x234,%eax
8010382e:	83 ec 0c             	sub    $0xc,%esp
80103831:	50                   	push   %eax
80103832:	e8 08 0c 00 00       	call   8010443f <wakeup>
80103837:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010383a:	8b 45 08             	mov    0x8(%ebp),%eax
8010383d:	83 ec 0c             	sub    $0xc,%esp
80103840:	50                   	push   %eax
80103841:	e8 e3 10 00 00       	call   80104929 <release>
80103846:	83 c4 10             	add    $0x10,%esp
  return n;
80103849:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010384c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384f:	c9                   	leave  
80103850:	c3                   	ret    

80103851 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103851:	55                   	push   %ebp
80103852:	89 e5                	mov    %esp,%ebp
80103854:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103857:	8b 45 08             	mov    0x8(%ebp),%eax
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	50                   	push   %eax
8010385e:	e8 58 10 00 00       	call   801048bb <acquire>
80103863:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103866:	eb 3e                	jmp    801038a6 <piperead+0x55>
    if(myproc()->killed){
80103868:	e8 a8 01 00 00       	call   80103a15 <myproc>
8010386d:	8b 40 24             	mov    0x24(%eax),%eax
80103870:	85 c0                	test   %eax,%eax
80103872:	74 19                	je     8010388d <piperead+0x3c>
      release(&p->lock);
80103874:	8b 45 08             	mov    0x8(%ebp),%eax
80103877:	83 ec 0c             	sub    $0xc,%esp
8010387a:	50                   	push   %eax
8010387b:	e8 a9 10 00 00       	call   80104929 <release>
80103880:	83 c4 10             	add    $0x10,%esp
      return -1;
80103883:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103888:	e9 be 00 00 00       	jmp    8010394b <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010388d:	8b 45 08             	mov    0x8(%ebp),%eax
80103890:	8b 55 08             	mov    0x8(%ebp),%edx
80103893:	81 c2 34 02 00 00    	add    $0x234,%edx
80103899:	83 ec 08             	sub    $0x8,%esp
8010389c:	50                   	push   %eax
8010389d:	52                   	push   %edx
8010389e:	e8 b5 0a 00 00       	call   80104358 <sleep>
801038a3:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038a6:	8b 45 08             	mov    0x8(%ebp),%eax
801038a9:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038af:	8b 45 08             	mov    0x8(%ebp),%eax
801038b2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038b8:	39 c2                	cmp    %eax,%edx
801038ba:	75 0d                	jne    801038c9 <piperead+0x78>
801038bc:	8b 45 08             	mov    0x8(%ebp),%eax
801038bf:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801038c5:	85 c0                	test   %eax,%eax
801038c7:	75 9f                	jne    80103868 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038d0:	eb 48                	jmp    8010391a <piperead+0xc9>
    if(p->nread == p->nwrite)
801038d2:	8b 45 08             	mov    0x8(%ebp),%eax
801038d5:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038db:	8b 45 08             	mov    0x8(%ebp),%eax
801038de:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038e4:	39 c2                	cmp    %eax,%edx
801038e6:	74 3c                	je     80103924 <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038e8:	8b 45 08             	mov    0x8(%ebp),%eax
801038eb:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801038f1:	8d 48 01             	lea    0x1(%eax),%ecx
801038f4:	8b 55 08             	mov    0x8(%ebp),%edx
801038f7:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801038fd:	25 ff 01 00 00       	and    $0x1ff,%eax
80103902:	89 c1                	mov    %eax,%ecx
80103904:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103907:	8b 45 0c             	mov    0xc(%ebp),%eax
8010390a:	01 c2                	add    %eax,%edx
8010390c:	8b 45 08             	mov    0x8(%ebp),%eax
8010390f:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80103914:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103916:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010391d:	3b 45 10             	cmp    0x10(%ebp),%eax
80103920:	7c b0                	jl     801038d2 <piperead+0x81>
80103922:	eb 01                	jmp    80103925 <piperead+0xd4>
      break;
80103924:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103925:	8b 45 08             	mov    0x8(%ebp),%eax
80103928:	05 38 02 00 00       	add    $0x238,%eax
8010392d:	83 ec 0c             	sub    $0xc,%esp
80103930:	50                   	push   %eax
80103931:	e8 09 0b 00 00       	call   8010443f <wakeup>
80103936:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103939:	8b 45 08             	mov    0x8(%ebp),%eax
8010393c:	83 ec 0c             	sub    $0xc,%esp
8010393f:	50                   	push   %eax
80103940:	e8 e4 0f 00 00       	call   80104929 <release>
80103945:	83 c4 10             	add    $0x10,%esp
  return i;
80103948:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010394b:	c9                   	leave  
8010394c:	c3                   	ret    

8010394d <readeflags>:
{
8010394d:	55                   	push   %ebp
8010394e:	89 e5                	mov    %esp,%ebp
80103950:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103953:	9c                   	pushf  
80103954:	58                   	pop    %eax
80103955:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103958:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010395b:	c9                   	leave  
8010395c:	c3                   	ret    

8010395d <sti>:
{
8010395d:	55                   	push   %ebp
8010395e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103960:	fb                   	sti    
}
80103961:	90                   	nop
80103962:	5d                   	pop    %ebp
80103963:	c3                   	ret    

80103964 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010396a:	83 ec 08             	sub    $0x8,%esp
8010396d:	68 30 a7 10 80       	push   $0x8010a730
80103972:	68 00 42 19 80       	push   $0x80194200
80103977:	e8 1d 0f 00 00       	call   80104899 <initlock>
8010397c:	83 c4 10             	add    $0x10,%esp
}
8010397f:	90                   	nop
80103980:	c9                   	leave  
80103981:	c3                   	ret    

80103982 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80103982:	55                   	push   %ebp
80103983:	89 e5                	mov    %esp,%ebp
80103985:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103988:	e8 10 00 00 00       	call   8010399d <mycpu>
8010398d:	2d a0 6b 19 80       	sub    $0x80196ba0,%eax
80103992:	c1 f8 04             	sar    $0x4,%eax
80103995:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399b:	c9                   	leave  
8010399c:	c3                   	ret    

8010399d <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
8010399d:	55                   	push   %ebp
8010399e:	89 e5                	mov    %esp,%ebp
801039a0:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
801039a3:	e8 a5 ff ff ff       	call   8010394d <readeflags>
801039a8:	25 00 02 00 00       	and    $0x200,%eax
801039ad:	85 c0                	test   %eax,%eax
801039af:	74 0d                	je     801039be <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801039b1:	83 ec 0c             	sub    $0xc,%esp
801039b4:	68 38 a7 10 80       	push   $0x8010a738
801039b9:	e8 eb cb ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
801039be:	e8 1c f1 ff ff       	call   80102adf <lapicid>
801039c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039cd:	eb 2d                	jmp    801039fc <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
801039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039d2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039d8:	05 a0 6b 19 80       	add    $0x80196ba0,%eax
801039dd:	0f b6 00             	movzbl (%eax),%eax
801039e0:	0f b6 c0             	movzbl %al,%eax
801039e3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801039e6:	75 10                	jne    801039f8 <mycpu+0x5b>
      return &cpus[i];
801039e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f1:	05 a0 6b 19 80       	add    $0x80196ba0,%eax
801039f6:	eb 1b                	jmp    80103a13 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
801039f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039fc:	a1 60 6e 19 80       	mov    0x80196e60,%eax
80103a01:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a04:	7c c9                	jl     801039cf <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	68 5e a7 10 80       	push   $0x8010a75e
80103a0e:	e8 96 cb ff ff       	call   801005a9 <panic>
}
80103a13:	c9                   	leave  
80103a14:	c3                   	ret    

80103a15 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103a15:	55                   	push   %ebp
80103a16:	89 e5                	mov    %esp,%ebp
80103a18:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a1b:	e8 06 10 00 00       	call   80104a26 <pushcli>
  c = mycpu();
80103a20:	e8 78 ff ff ff       	call   8010399d <mycpu>
80103a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a2b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a34:	e8 3a 10 00 00       	call   80104a73 <popcli>
  return p;
80103a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103a3c:	c9                   	leave  
80103a3d:	c3                   	ret    

80103a3e <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a3e:	55                   	push   %ebp
80103a3f:	89 e5                	mov    %esp,%ebp
80103a41:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a44:	83 ec 0c             	sub    $0xc,%esp
80103a47:	68 00 42 19 80       	push   $0x80194200
80103a4c:	e8 6a 0e 00 00       	call   801048bb <acquire>
80103a51:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a54:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a5b:	eb 0e                	jmp    80103a6b <allocproc+0x2d>
    if(p->state == UNUSED){
80103a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a60:	8b 40 0c             	mov    0xc(%eax),%eax
80103a63:	85 c0                	test   %eax,%eax
80103a65:	74 27                	je     80103a8e <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a67:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80103a6b:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80103a72:	72 e9                	jb     80103a5d <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103a74:	83 ec 0c             	sub    $0xc,%esp
80103a77:	68 00 42 19 80       	push   $0x80194200
80103a7c:	e8 a8 0e 00 00       	call   80104929 <release>
80103a81:	83 c4 10             	add    $0x10,%esp
  return 0;
80103a84:	b8 00 00 00 00       	mov    $0x0,%eax
80103a89:	e9 e4 00 00 00       	jmp    80103b72 <allocproc+0x134>
      goto found;
80103a8e:	90                   	nop

found:
  p->state = EMBRYO;
80103a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a92:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103a99:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103a9e:	8d 50 01             	lea    0x1(%eax),%edx
80103aa1:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103aaa:	89 42 10             	mov    %eax,0x10(%edx)
  int index = p - ptable.proc;
80103aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab0:	2d 34 42 19 80       	sub    $0x80194234,%eax
80103ab5:	c1 f8 02             	sar    $0x2,%eax
80103ab8:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
80103abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ppid[index] = p->pid;
80103ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac4:	8b 50 10             	mov    0x10(%eax),%edx
80103ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aca:	89 14 85 40 61 19 80 	mov    %edx,-0x7fe69ec0(,%eax,4)
  pspage[index] = 1;
80103ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad4:	c7 04 85 40 62 19 80 	movl   $0x1,-0x7fe69dc0(,%eax,4)
80103adb:	01 00 00 00 
  release(&ptable.lock);
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	68 00 42 19 80       	push   $0x80194200
80103ae7:	e8 3d 0e 00 00       	call   80104929 <release>
80103aec:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103aef:	e8 91 ec ff ff       	call   80102785 <kalloc>
80103af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103af7:	89 42 08             	mov    %eax,0x8(%edx)
80103afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afd:	8b 40 08             	mov    0x8(%eax),%eax
80103b00:	85 c0                	test   %eax,%eax
80103b02:	75 11                	jne    80103b15 <allocproc+0xd7>
    p->state = UNUSED;
80103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103b0e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b13:	eb 5d                	jmp    80103b72 <allocproc+0x134>
  }
  sp = p->kstack + KSTACKSIZE;
80103b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b18:	8b 40 08             	mov    0x8(%eax),%eax
80103b1b:	05 00 10 00 00       	add    $0x1000,%eax
80103b20:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b23:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
  p->tf = (struct trapframe*)sp;
80103b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b2d:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b30:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
80103b34:	ba 89 5f 10 80       	mov    $0x80105f89,%edx
80103b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b3c:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b3e:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  p->context = (struct context*)sp;
80103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b45:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b48:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4e:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b51:	83 ec 04             	sub    $0x4,%esp
80103b54:	6a 14                	push   $0x14
80103b56:	6a 00                	push   $0x0
80103b58:	50                   	push   %eax
80103b59:	e8 d3 0f 00 00       	call   80104b31 <memset>
80103b5e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b64:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b67:	ba 12 43 10 80       	mov    $0x80104312,%edx
80103b6c:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b72:	c9                   	leave  
80103b73:	c3                   	ret    

80103b74 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b74:	55                   	push   %ebp
80103b75:	89 e5                	mov    %esp,%ebp
80103b77:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b7a:	e8 bf fe ff ff       	call   80103a3e <allocproc>
80103b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b85:	a3 40 63 19 80       	mov    %eax,0x80196340
  if((p->pgdir = setupkvm()) == 0){
80103b8a:	e8 40 3b 00 00       	call   801076cf <setupkvm>
80103b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b92:	89 42 04             	mov    %eax,0x4(%edx)
80103b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b98:	8b 40 04             	mov    0x4(%eax),%eax
80103b9b:	85 c0                	test   %eax,%eax
80103b9d:	75 0d                	jne    80103bac <userinit+0x38>
    panic("userinit: out of memory?");
80103b9f:	83 ec 0c             	sub    $0xc,%esp
80103ba2:	68 6e a7 10 80       	push   $0x8010a76e
80103ba7:	e8 fd c9 ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bac:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb4:	8b 40 04             	mov    0x4(%eax),%eax
80103bb7:	83 ec 04             	sub    $0x4,%esp
80103bba:	52                   	push   %edx
80103bbb:	68 ec f4 10 80       	push   $0x8010f4ec
80103bc0:	50                   	push   %eax
80103bc1:	e8 c5 3d 00 00       	call   8010798b <inituvm>
80103bc6:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcc:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd5:	8b 40 18             	mov    0x18(%eax),%eax
80103bd8:	83 ec 04             	sub    $0x4,%esp
80103bdb:	6a 4c                	push   $0x4c
80103bdd:	6a 00                	push   $0x0
80103bdf:	50                   	push   %eax
80103be0:	e8 4c 0f 00 00       	call   80104b31 <memset>
80103be5:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103beb:	8b 40 18             	mov    0x18(%eax),%eax
80103bee:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf7:	8b 40 18             	mov    0x18(%eax),%eax
80103bfa:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c03:	8b 50 18             	mov    0x18(%eax),%edx
80103c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c09:	8b 40 18             	mov    0x18(%eax),%eax
80103c0c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c10:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c17:	8b 50 18             	mov    0x18(%eax),%edx
80103c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1d:	8b 40 18             	mov    0x18(%eax),%eax
80103c20:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c24:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2b:	8b 40 18             	mov    0x18(%eax),%eax
80103c2e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c38:	8b 40 18             	mov    0x18(%eax),%eax
80103c3b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c45:	8b 40 18             	mov    0x18(%eax),%eax
80103c48:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c52:	83 c0 6c             	add    $0x6c,%eax
80103c55:	83 ec 04             	sub    $0x4,%esp
80103c58:	6a 10                	push   $0x10
80103c5a:	68 87 a7 10 80       	push   $0x8010a787
80103c5f:	50                   	push   %eax
80103c60:	e8 cf 10 00 00       	call   80104d34 <safestrcpy>
80103c65:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c68:	83 ec 0c             	sub    $0xc,%esp
80103c6b:	68 90 a7 10 80       	push   $0x8010a790
80103c70:	e8 8d e8 ff ff       	call   80102502 <namei>
80103c75:	83 c4 10             	add    $0x10,%esp
80103c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c7b:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c7e:	83 ec 0c             	sub    $0xc,%esp
80103c81:	68 00 42 19 80       	push   $0x80194200
80103c86:	e8 30 0c 00 00       	call   801048bb <acquire>
80103c8b:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c91:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c98:	83 ec 0c             	sub    $0xc,%esp
80103c9b:	68 00 42 19 80       	push   $0x80194200
80103ca0:	e8 84 0c 00 00       	call   80104929 <release>
80103ca5:	83 c4 10             	add    $0x10,%esp
}
80103ca8:	90                   	nop
80103ca9:	c9                   	leave  
80103caa:	c3                   	ret    

80103cab <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103cab:	55                   	push   %ebp
80103cac:	89 e5                	mov    %esp,%ebp
80103cae:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103cb1:	e8 5f fd ff ff       	call   80103a15 <myproc>
80103cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sz = curproc->sz;
80103cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbc:	8b 00                	mov    (%eax),%eax
80103cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(n > 0){
80103cc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cc5:	7e 2e                	jle    80103cf5 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc7:	8b 55 08             	mov    0x8(%ebp),%edx
80103cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccd:	01 c2                	add    %eax,%edx
80103ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd2:	8b 40 04             	mov    0x4(%eax),%eax
80103cd5:	83 ec 04             	sub    $0x4,%esp
80103cd8:	52                   	push   %edx
80103cd9:	ff 75 f4             	push   -0xc(%ebp)
80103cdc:	50                   	push   %eax
80103cdd:	e8 e6 3d 00 00       	call   80107ac8 <allocuvm>
80103ce2:	83 c4 10             	add    $0x10,%esp
80103ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cec:	75 3b                	jne    80103d29 <growproc+0x7e>
      return -1;
80103cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cf3:	eb 4f                	jmp    80103d44 <growproc+0x99>
  } else if(n < 0){
80103cf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cf9:	79 2e                	jns    80103d29 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cfb:	8b 55 08             	mov    0x8(%ebp),%edx
80103cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d01:	01 c2                	add    %eax,%edx
80103d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d06:	8b 40 04             	mov    0x4(%eax),%eax
80103d09:	83 ec 04             	sub    $0x4,%esp
80103d0c:	52                   	push   %edx
80103d0d:	ff 75 f4             	push   -0xc(%ebp)
80103d10:	50                   	push   %eax
80103d11:	e8 b7 3e 00 00       	call   80107bcd <deallocuvm>
80103d16:	83 c4 10             	add    $0x10,%esp
80103d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d20:	75 07                	jne    80103d29 <growproc+0x7e>
      return -1;
80103d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d27:	eb 1b                	jmp    80103d44 <growproc+0x99>
  }
  curproc->sz = sz;
80103d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d2f:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d31:	83 ec 0c             	sub    $0xc,%esp
80103d34:	ff 75 f0             	push   -0x10(%ebp)
80103d37:	e8 b0 3a 00 00       	call   801077ec <switchuvm>
80103d3c:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d44:	c9                   	leave  
80103d45:	c3                   	ret    

80103d46 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d46:	55                   	push   %ebp
80103d47:	89 e5                	mov    %esp,%ebp
80103d49:	57                   	push   %edi
80103d4a:	56                   	push   %esi
80103d4b:	53                   	push   %ebx
80103d4c:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d4f:	e8 c1 fc ff ff       	call   80103a15 <myproc>
80103d54:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d57:	e8 e2 fc ff ff       	call   80103a3e <allocproc>
80103d5c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103d5f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80103d63:	75 0a                	jne    80103d6f <fork+0x29>
    return -1;
80103d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d6a:	e9 b0 01 00 00       	jmp    80103f1f <fork+0x1d9>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d72:	8b 10                	mov    (%eax),%edx
80103d74:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d77:	8b 40 04             	mov    0x4(%eax),%eax
80103d7a:	83 ec 08             	sub    $0x8,%esp
80103d7d:	52                   	push   %edx
80103d7e:	50                   	push   %eax
80103d7f:	e8 e7 3f 00 00       	call   80107d6b <copyuvm>
80103d84:	83 c4 10             	add    $0x10,%esp
80103d87:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103d8a:	89 42 04             	mov    %eax,0x4(%edx)
80103d8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103d90:	8b 40 04             	mov    0x4(%eax),%eax
80103d93:	85 c0                	test   %eax,%eax
80103d95:	75 30                	jne    80103dc7 <fork+0x81>
    kfree(np->kstack);
80103d97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103d9a:	8b 40 08             	mov    0x8(%eax),%eax
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	50                   	push   %eax
80103da1:	e8 45 e9 ff ff       	call   801026eb <kfree>
80103da6:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103da9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103db3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103db6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dc2:	e9 58 01 00 00       	jmp    80103f1f <fork+0x1d9>
  }
  np->sz = curproc->sz;
80103dc7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103dca:	8b 10                	mov    (%eax),%edx
80103dcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dcf:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103dd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103dd7:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103dda:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103ddd:	8b 48 18             	mov    0x18(%eax),%ecx
80103de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103de3:	8b 40 18             	mov    0x18(%eax),%eax
80103de6:	89 c2                	mov    %eax,%edx
80103de8:	89 cb                	mov    %ecx,%ebx
80103dea:	b8 13 00 00 00       	mov    $0x13,%eax
80103def:	89 d7                	mov    %edx,%edi
80103df1:	89 de                	mov    %ebx,%esi
80103df3:	89 c1                	mov    %eax,%ecx
80103df5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103df7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dfa:	8b 40 18             	mov    0x18(%eax),%eax
80103dfd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103e04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103e0b:	eb 3b                	jmp    80103e48 <fork+0x102>
    if(curproc->ofile[i])
80103e0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e13:	83 c2 08             	add    $0x8,%edx
80103e16:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	74 26                	je     80103e44 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e24:	83 c2 08             	add    $0x8,%edx
80103e27:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e2b:	83 ec 0c             	sub    $0xc,%esp
80103e2e:	50                   	push   %eax
80103e2f:	e8 fb d1 ff ff       	call   8010102f <filedup>
80103e34:	83 c4 10             	add    $0x10,%esp
80103e37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103e3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e3d:	83 c1 08             	add    $0x8,%ecx
80103e40:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e44:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e48:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e4c:	7e bf                	jle    80103e0d <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e51:	8b 40 68             	mov    0x68(%eax),%eax
80103e54:	83 ec 0c             	sub    $0xc,%esp
80103e57:	50                   	push   %eax
80103e58:	e8 38 db ff ff       	call   80101995 <idup>
80103e5d:	83 c4 10             	add    $0x10,%esp
80103e60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103e63:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e66:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e69:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e6f:	83 c0 6c             	add    $0x6c,%eax
80103e72:	83 ec 04             	sub    $0x4,%esp
80103e75:	6a 10                	push   $0x10
80103e77:	52                   	push   %edx
80103e78:	50                   	push   %eax
80103e79:	e8 b6 0e 00 00       	call   80104d34 <safestrcpy>
80103e7e:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e84:	8b 40 10             	mov    0x10(%eax),%eax
80103e87:	89 45 d0             	mov    %eax,-0x30(%ebp)

  acquire(&ptable.lock);
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 00 42 19 80       	push   $0x80194200
80103e92:	e8 24 0a 00 00       	call   801048bb <acquire>
80103e97:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e9d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(int i=0; i < NPROC; i++) {
80103ea4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80103eab:	eb 59                	jmp    80103f06 <fork+0x1c0>
    if (ptable.proc[i].pid == pid) {
80103ead:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eb0:	6b c0 7c             	imul   $0x7c,%eax,%eax
80103eb3:	05 44 42 19 80       	add    $0x80194244,%eax
80103eb8:	8b 00                	mov    (%eax),%eax
80103eba:	39 45 d0             	cmp    %eax,-0x30(%ebp)
80103ebd:	75 43                	jne    80103f02 <fork+0x1bc>
      for(int j=0; j < NPROC; j++) {
80103ebf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80103ec6:	eb 32                	jmp    80103efa <fork+0x1b4>
        if (ptable.proc[j].pid == curproc->pid) {
80103ec8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ecb:	6b c0 7c             	imul   $0x7c,%eax,%eax
80103ece:	05 44 42 19 80       	add    $0x80194244,%eax
80103ed3:	8b 10                	mov    (%eax),%edx
80103ed5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103ed8:	8b 40 10             	mov    0x10(%eax),%eax
80103edb:	39 c2                	cmp    %eax,%edx
80103edd:	75 17                	jne    80103ef6 <fork+0x1b0>
          pspage[i] = pspage[j];
80103edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ee2:	8b 14 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%edx
80103ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eec:	89 14 85 40 62 19 80 	mov    %edx,-0x7fe69dc0(,%eax,4)
          break;
80103ef3:	90                   	nop
        }
       }
      break;
80103ef4:	eb 16                	jmp    80103f0c <fork+0x1c6>
      for(int j=0; j < NPROC; j++) {
80103ef6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80103efa:	83 7d dc 3f          	cmpl   $0x3f,-0x24(%ebp)
80103efe:	7e c8                	jle    80103ec8 <fork+0x182>
      break;
80103f00:	eb 0a                	jmp    80103f0c <fork+0x1c6>
  for(int i=0; i < NPROC; i++) {
80103f02:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80103f06:	83 7d e0 3f          	cmpl   $0x3f,-0x20(%ebp)
80103f0a:	7e a1                	jle    80103ead <fork+0x167>
    }
  }

  release(&ptable.lock);
80103f0c:	83 ec 0c             	sub    $0xc,%esp
80103f0f:	68 00 42 19 80       	push   $0x80194200
80103f14:	e8 10 0a 00 00       	call   80104929 <release>
80103f19:	83 c4 10             	add    $0x10,%esp

  return pid;
80103f1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
80103f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f22:	5b                   	pop    %ebx
80103f23:	5e                   	pop    %esi
80103f24:	5f                   	pop    %edi
80103f25:	5d                   	pop    %ebp
80103f26:	c3                   	ret    

80103f27 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103f27:	55                   	push   %ebp
80103f28:	89 e5                	mov    %esp,%ebp
80103f2a:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103f2d:	e8 e3 fa ff ff       	call   80103a15 <myproc>
80103f32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103f35:	a1 40 63 19 80       	mov    0x80196340,%eax
80103f3a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f3d:	75 0d                	jne    80103f4c <exit+0x25>
    panic("init exiting");
80103f3f:	83 ec 0c             	sub    $0xc,%esp
80103f42:	68 92 a7 10 80       	push   $0x8010a792
80103f47:	e8 5d c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103f4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103f53:	eb 3f                	jmp    80103f94 <exit+0x6d>
    if(curproc->ofile[fd]){
80103f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f5b:	83 c2 08             	add    $0x8,%edx
80103f5e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	74 2a                	je     80103f90 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f69:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f6c:	83 c2 08             	add    $0x8,%edx
80103f6f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	50                   	push   %eax
80103f77:	e8 04 d1 ff ff       	call   80101080 <fileclose>
80103f7c:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f82:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f85:	83 c2 08             	add    $0x8,%edx
80103f88:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f8f:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103f90:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f94:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f98:	7e bb                	jle    80103f55 <exit+0x2e>
    }
  }

  begin_op();
80103f9a:	e8 82 f0 ff ff       	call   80103021 <begin_op>
  iput(curproc->cwd);
80103f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fa2:	8b 40 68             	mov    0x68(%eax),%eax
80103fa5:	83 ec 0c             	sub    $0xc,%esp
80103fa8:	50                   	push   %eax
80103fa9:	e8 82 db ff ff       	call   80101b30 <iput>
80103fae:	83 c4 10             	add    $0x10,%esp
  end_op();
80103fb1:	e8 f7 f0 ff ff       	call   801030ad <end_op>
  curproc->cwd = 0;
80103fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fb9:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	68 00 42 19 80       	push   $0x80194200
80103fc8:	e8 ee 08 00 00       	call   801048bb <acquire>
80103fcd:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fd3:	8b 40 14             	mov    0x14(%eax),%eax
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	50                   	push   %eax
80103fda:	e8 20 04 00 00       	call   801043ff <wakeup1>
80103fdf:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe2:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103fe9:	eb 37                	jmp    80104022 <exit+0xfb>
    if(p->parent == curproc){
80103feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fee:	8b 40 14             	mov    0x14(%eax),%eax
80103ff1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ff4:	75 28                	jne    8010401e <exit+0xf7>
      p->parent = initproc;
80103ff6:	8b 15 40 63 19 80    	mov    0x80196340,%edx
80103ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fff:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104005:	8b 40 0c             	mov    0xc(%eax),%eax
80104008:	83 f8 05             	cmp    $0x5,%eax
8010400b:	75 11                	jne    8010401e <exit+0xf7>
        wakeup1(initproc);
8010400d:	a1 40 63 19 80       	mov    0x80196340,%eax
80104012:	83 ec 0c             	sub    $0xc,%esp
80104015:	50                   	push   %eax
80104016:	e8 e4 03 00 00       	call   801043ff <wakeup1>
8010401b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401e:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104022:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80104029:	72 c0                	jb     80103feb <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010402b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010402e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104035:	e8 e5 01 00 00       	call   8010421f <sched>
  panic("zombie exit");
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 9f a7 10 80       	push   $0x8010a79f
80104042:	e8 62 c5 ff ff       	call   801005a9 <panic>

80104047 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104047:	55                   	push   %ebp
80104048:	89 e5                	mov    %esp,%ebp
8010404a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
8010404d:	e8 c3 f9 ff ff       	call   80103a15 <myproc>
80104052:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104055:	83 ec 0c             	sub    $0xc,%esp
80104058:	68 00 42 19 80       	push   $0x80194200
8010405d:	e8 59 08 00 00       	call   801048bb <acquire>
80104062:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104065:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406c:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104073:	e9 a1 00 00 00       	jmp    80104119 <wait+0xd2>
      if(p->parent != curproc)
80104078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407b:	8b 40 14             	mov    0x14(%eax),%eax
8010407e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104081:	0f 85 8d 00 00 00    	jne    80104114 <wait+0xcd>
        continue;
      havekids = 1;
80104087:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010408e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104091:	8b 40 0c             	mov    0xc(%eax),%eax
80104094:	83 f8 05             	cmp    $0x5,%eax
80104097:	75 7c                	jne    80104115 <wait+0xce>
        // Found one.
        pid = p->pid;
80104099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409c:	8b 40 10             	mov    0x10(%eax),%eax
8010409f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801040a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a5:	8b 40 08             	mov    0x8(%eax),%eax
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	50                   	push   %eax
801040ac:	e8 3a e6 ff ff       	call   801026eb <kfree>
801040b1:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801040b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801040be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c1:	8b 40 04             	mov    0x4(%eax),%eax
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	50                   	push   %eax
801040c8:	e8 c4 3b 00 00       	call   80107c91 <freevm>
801040cd:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801040da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040dd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801040e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e7:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801040eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ee:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801040f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801040ff:	83 ec 0c             	sub    $0xc,%esp
80104102:	68 00 42 19 80       	push   $0x80194200
80104107:	e8 1d 08 00 00       	call   80104929 <release>
8010410c:	83 c4 10             	add    $0x10,%esp
        return pid;
8010410f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104112:	eb 51                	jmp    80104165 <wait+0x11e>
        continue;
80104114:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104115:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104119:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80104120:	0f 82 52 ff ff ff    	jb     80104078 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010412a:	74 0a                	je     80104136 <wait+0xef>
8010412c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010412f:	8b 40 24             	mov    0x24(%eax),%eax
80104132:	85 c0                	test   %eax,%eax
80104134:	74 17                	je     8010414d <wait+0x106>
      release(&ptable.lock);
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 00 42 19 80       	push   $0x80194200
8010413e:	e8 e6 07 00 00       	call   80104929 <release>
80104143:	83 c4 10             	add    $0x10,%esp
      return -1;
80104146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010414b:	eb 18                	jmp    80104165 <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010414d:	83 ec 08             	sub    $0x8,%esp
80104150:	68 00 42 19 80       	push   $0x80194200
80104155:	ff 75 ec             	push   -0x14(%ebp)
80104158:	e8 fb 01 00 00       	call   80104358 <sleep>
8010415d:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104160:	e9 00 ff ff ff       	jmp    80104065 <wait+0x1e>
  }
}
80104165:	c9                   	leave  
80104166:	c3                   	ret    

80104167 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104167:	55                   	push   %ebp
80104168:	89 e5                	mov    %esp,%ebp
8010416a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
8010416d:	e8 2b f8 ff ff       	call   8010399d <mycpu>
80104172:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104178:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010417f:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104182:	e8 d6 f7 ff ff       	call   8010395d <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	68 00 42 19 80       	push   $0x80194200
8010418f:	e8 27 07 00 00       	call   801048bb <acquire>
80104194:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104197:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010419e:	eb 61                	jmp    80104201 <scheduler+0x9a>
      if(p->state != RUNNABLE)
801041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a3:	8b 40 0c             	mov    0xc(%eax),%eax
801041a6:	83 f8 03             	cmp    $0x3,%eax
801041a9:	75 51                	jne    801041fc <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801041ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b1:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801041b7:	83 ec 0c             	sub    $0xc,%esp
801041ba:	ff 75 f4             	push   -0xc(%ebp)
801041bd:	e8 2a 36 00 00       	call   801077ec <switchuvm>
801041c2:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801041c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c8:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801041cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d2:	8b 40 1c             	mov    0x1c(%eax),%eax
801041d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041d8:	83 c2 04             	add    $0x4,%edx
801041db:	83 ec 08             	sub    $0x8,%esp
801041de:	50                   	push   %eax
801041df:	52                   	push   %edx
801041e0:	e8 c1 0b 00 00       	call   80104da6 <swtch>
801041e5:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801041e8:	e8 e6 35 00 00       	call   801077d3 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801041ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041f0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041f7:	00 00 00 
801041fa:	eb 01                	jmp    801041fd <scheduler+0x96>
        continue;
801041fc:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fd:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104201:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
80104208:	72 96                	jb     801041a0 <scheduler+0x39>
    }
    release(&ptable.lock);
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 00 42 19 80       	push   $0x80194200
80104212:	e8 12 07 00 00       	call   80104929 <release>
80104217:	83 c4 10             	add    $0x10,%esp
    sti();
8010421a:	e9 63 ff ff ff       	jmp    80104182 <scheduler+0x1b>

8010421f <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010421f:	55                   	push   %ebp
80104220:	89 e5                	mov    %esp,%ebp
80104222:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104225:	e8 eb f7 ff ff       	call   80103a15 <myproc>
8010422a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	68 00 42 19 80       	push   $0x80194200
80104235:	e8 bc 07 00 00       	call   801049f6 <holding>
8010423a:	83 c4 10             	add    $0x10,%esp
8010423d:	85 c0                	test   %eax,%eax
8010423f:	75 0d                	jne    8010424e <sched+0x2f>
    panic("sched ptable.lock");
80104241:	83 ec 0c             	sub    $0xc,%esp
80104244:	68 ab a7 10 80       	push   $0x8010a7ab
80104249:	e8 5b c3 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
8010424e:	e8 4a f7 ff ff       	call   8010399d <mycpu>
80104253:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104259:	83 f8 01             	cmp    $0x1,%eax
8010425c:	74 0d                	je     8010426b <sched+0x4c>
    panic("sched locks");
8010425e:	83 ec 0c             	sub    $0xc,%esp
80104261:	68 bd a7 10 80       	push   $0x8010a7bd
80104266:	e8 3e c3 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
8010426b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426e:	8b 40 0c             	mov    0xc(%eax),%eax
80104271:	83 f8 04             	cmp    $0x4,%eax
80104274:	75 0d                	jne    80104283 <sched+0x64>
    panic("sched running");
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	68 c9 a7 10 80       	push   $0x8010a7c9
8010427e:	e8 26 c3 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104283:	e8 c5 f6 ff ff       	call   8010394d <readeflags>
80104288:	25 00 02 00 00       	and    $0x200,%eax
8010428d:	85 c0                	test   %eax,%eax
8010428f:	74 0d                	je     8010429e <sched+0x7f>
    panic("sched interruptible");
80104291:	83 ec 0c             	sub    $0xc,%esp
80104294:	68 d7 a7 10 80       	push   $0x8010a7d7
80104299:	e8 0b c3 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
8010429e:	e8 fa f6 ff ff       	call   8010399d <mycpu>
801042a3:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801042ac:	e8 ec f6 ff ff       	call   8010399d <mycpu>
801042b1:	8b 40 04             	mov    0x4(%eax),%eax
801042b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b7:	83 c2 1c             	add    $0x1c,%edx
801042ba:	83 ec 08             	sub    $0x8,%esp
801042bd:	50                   	push   %eax
801042be:	52                   	push   %edx
801042bf:	e8 e2 0a 00 00       	call   80104da6 <swtch>
801042c4:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042c7:	e8 d1 f6 ff ff       	call   8010399d <mycpu>
801042cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042cf:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801042d5:	90                   	nop
801042d6:	c9                   	leave  
801042d7:	c3                   	ret    

801042d8 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801042d8:	55                   	push   %ebp
801042d9:	89 e5                	mov    %esp,%ebp
801042db:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042de:	83 ec 0c             	sub    $0xc,%esp
801042e1:	68 00 42 19 80       	push   $0x80194200
801042e6:	e8 d0 05 00 00       	call   801048bb <acquire>
801042eb:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
801042ee:	e8 22 f7 ff ff       	call   80103a15 <myproc>
801042f3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801042fa:	e8 20 ff ff ff       	call   8010421f <sched>
  release(&ptable.lock);
801042ff:	83 ec 0c             	sub    $0xc,%esp
80104302:	68 00 42 19 80       	push   $0x80194200
80104307:	e8 1d 06 00 00       	call   80104929 <release>
8010430c:	83 c4 10             	add    $0x10,%esp
}
8010430f:	90                   	nop
80104310:	c9                   	leave  
80104311:	c3                   	ret    

80104312 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104312:	55                   	push   %ebp
80104313:	89 e5                	mov    %esp,%ebp
80104315:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 00 42 19 80       	push   $0x80194200
80104320:	e8 04 06 00 00       	call   80104929 <release>
80104325:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104328:	a1 04 f0 10 80       	mov    0x8010f004,%eax
8010432d:	85 c0                	test   %eax,%eax
8010432f:	74 24                	je     80104355 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104331:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104338:	00 00 00 
    iinit(ROOTDEV);
8010433b:	83 ec 0c             	sub    $0xc,%esp
8010433e:	6a 01                	push   $0x1
80104340:	e8 18 d3 ff ff       	call   8010165d <iinit>
80104345:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	6a 01                	push   $0x1
8010434d:	e8 b0 ea ff ff       	call   80102e02 <initlog>
80104352:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104355:	90                   	nop
80104356:	c9                   	leave  
80104357:	c3                   	ret    

80104358 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104358:	55                   	push   %ebp
80104359:	89 e5                	mov    %esp,%ebp
8010435b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
8010435e:	e8 b2 f6 ff ff       	call   80103a15 <myproc>
80104363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010436a:	75 0d                	jne    80104379 <sleep+0x21>
    panic("sleep");
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	68 eb a7 10 80       	push   $0x8010a7eb
80104374:	e8 30 c2 ff ff       	call   801005a9 <panic>

  if(lk == 0)
80104379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010437d:	75 0d                	jne    8010438c <sleep+0x34>
    panic("sleep without lk");
8010437f:	83 ec 0c             	sub    $0xc,%esp
80104382:	68 f1 a7 10 80       	push   $0x8010a7f1
80104387:	e8 1d c2 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010438c:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104393:	74 1e                	je     801043b3 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104395:	83 ec 0c             	sub    $0xc,%esp
80104398:	68 00 42 19 80       	push   $0x80194200
8010439d:	e8 19 05 00 00       	call   801048bb <acquire>
801043a2:	83 c4 10             	add    $0x10,%esp
    release(lk);
801043a5:	83 ec 0c             	sub    $0xc,%esp
801043a8:	ff 75 0c             	push   0xc(%ebp)
801043ab:	e8 79 05 00 00       	call   80104929 <release>
801043b0:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b6:	8b 55 08             	mov    0x8(%ebp),%edx
801043b9:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801043bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bf:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801043c6:	e8 54 fe ff ff       	call   8010421f <sched>

  // Tidy up.
  p->chan = 0;
801043cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ce:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801043d5:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801043dc:	74 1e                	je     801043fc <sleep+0xa4>
    release(&ptable.lock);
801043de:	83 ec 0c             	sub    $0xc,%esp
801043e1:	68 00 42 19 80       	push   $0x80194200
801043e6:	e8 3e 05 00 00       	call   80104929 <release>
801043eb:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	ff 75 0c             	push   0xc(%ebp)
801043f4:	e8 c2 04 00 00       	call   801048bb <acquire>
801043f9:	83 c4 10             	add    $0x10,%esp
  }
}
801043fc:	90                   	nop
801043fd:	c9                   	leave  
801043fe:	c3                   	ret    

801043ff <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801043ff:	55                   	push   %ebp
80104400:	89 e5                	mov    %esp,%ebp
80104402:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104405:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
8010440c:	eb 24                	jmp    80104432 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
8010440e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104411:	8b 40 0c             	mov    0xc(%eax),%eax
80104414:	83 f8 02             	cmp    $0x2,%eax
80104417:	75 15                	jne    8010442e <wakeup1+0x2f>
80104419:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010441c:	8b 40 20             	mov    0x20(%eax),%eax
8010441f:	39 45 08             	cmp    %eax,0x8(%ebp)
80104422:	75 0a                	jne    8010442e <wakeup1+0x2f>
      p->state = RUNNABLE;
80104424:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104427:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442e:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104432:	81 7d fc 34 61 19 80 	cmpl   $0x80196134,-0x4(%ebp)
80104439:	72 d3                	jb     8010440e <wakeup1+0xf>
}
8010443b:	90                   	nop
8010443c:	90                   	nop
8010443d:	c9                   	leave  
8010443e:	c3                   	ret    

8010443f <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010443f:	55                   	push   %ebp
80104440:	89 e5                	mov    %esp,%ebp
80104442:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104445:	83 ec 0c             	sub    $0xc,%esp
80104448:	68 00 42 19 80       	push   $0x80194200
8010444d:	e8 69 04 00 00       	call   801048bb <acquire>
80104452:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104455:	83 ec 0c             	sub    $0xc,%esp
80104458:	ff 75 08             	push   0x8(%ebp)
8010445b:	e8 9f ff ff ff       	call   801043ff <wakeup1>
80104460:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104463:	83 ec 0c             	sub    $0xc,%esp
80104466:	68 00 42 19 80       	push   $0x80194200
8010446b:	e8 b9 04 00 00       	call   80104929 <release>
80104470:	83 c4 10             	add    $0x10,%esp
}
80104473:	90                   	nop
80104474:	c9                   	leave  
80104475:	c3                   	ret    

80104476 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104476:	55                   	push   %ebp
80104477:	89 e5                	mov    %esp,%ebp
80104479:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	68 00 42 19 80       	push   $0x80194200
80104484:	e8 32 04 00 00       	call   801048bb <acquire>
80104489:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010448c:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104493:	eb 45                	jmp    801044da <kill+0x64>
    if(p->pid == pid){
80104495:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104498:	8b 40 10             	mov    0x10(%eax),%eax
8010449b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010449e:	75 36                	jne    801044d6 <kill+0x60>
      p->killed = 1;
801044a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ad:	8b 40 0c             	mov    0xc(%eax),%eax
801044b0:	83 f8 02             	cmp    $0x2,%eax
801044b3:	75 0a                	jne    801044bf <kill+0x49>
        p->state = RUNNABLE;
801044b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044bf:	83 ec 0c             	sub    $0xc,%esp
801044c2:	68 00 42 19 80       	push   $0x80194200
801044c7:	e8 5d 04 00 00       	call   80104929 <release>
801044cc:	83 c4 10             	add    $0x10,%esp
      return 0;
801044cf:	b8 00 00 00 00       	mov    $0x0,%eax
801044d4:	eb 22                	jmp    801044f8 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d6:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801044da:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
801044e1:	72 b2                	jb     80104495 <kill+0x1f>
    }
  }
  release(&ptable.lock);
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	68 00 42 19 80       	push   $0x80194200
801044eb:	e8 39 04 00 00       	call   80104929 <release>
801044f0:	83 c4 10             	add    $0x10,%esp
  return -1;
801044f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044f8:	c9                   	leave  
801044f9:	c3                   	ret    

801044fa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044fa:	55                   	push   %ebp
801044fb:	89 e5                	mov    %esp,%ebp
801044fd:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104500:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
80104507:	e9 d7 00 00 00       	jmp    801045e3 <procdump+0xe9>
    if(p->state == UNUSED)
8010450c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010450f:	8b 40 0c             	mov    0xc(%eax),%eax
80104512:	85 c0                	test   %eax,%eax
80104514:	0f 84 c4 00 00 00    	je     801045de <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010451a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010451d:	8b 40 0c             	mov    0xc(%eax),%eax
80104520:	83 f8 05             	cmp    $0x5,%eax
80104523:	77 23                	ja     80104548 <procdump+0x4e>
80104525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104528:	8b 40 0c             	mov    0xc(%eax),%eax
8010452b:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104532:	85 c0                	test   %eax,%eax
80104534:	74 12                	je     80104548 <procdump+0x4e>
      state = states[p->state];
80104536:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104539:	8b 40 0c             	mov    0xc(%eax),%eax
8010453c:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104543:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104546:	eb 07                	jmp    8010454f <procdump+0x55>
    else
      state = "???";
80104548:	c7 45 ec 02 a8 10 80 	movl   $0x8010a802,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104552:	8d 50 6c             	lea    0x6c(%eax),%edx
80104555:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104558:	8b 40 10             	mov    0x10(%eax),%eax
8010455b:	52                   	push   %edx
8010455c:	ff 75 ec             	push   -0x14(%ebp)
8010455f:	50                   	push   %eax
80104560:	68 06 a8 10 80       	push   $0x8010a806
80104565:	e8 8a be ff ff       	call   801003f4 <cprintf>
8010456a:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010456d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104570:	8b 40 0c             	mov    0xc(%eax),%eax
80104573:	83 f8 02             	cmp    $0x2,%eax
80104576:	75 54                	jne    801045cc <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104578:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010457b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010457e:	8b 40 0c             	mov    0xc(%eax),%eax
80104581:	83 c0 08             	add    $0x8,%eax
80104584:	89 c2                	mov    %eax,%edx
80104586:	83 ec 08             	sub    $0x8,%esp
80104589:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010458c:	50                   	push   %eax
8010458d:	52                   	push   %edx
8010458e:	e8 e8 03 00 00       	call   8010497b <getcallerpcs>
80104593:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010459d:	eb 1c                	jmp    801045bb <procdump+0xc1>
        cprintf(" %p", pc[i]);
8010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801045a6:	83 ec 08             	sub    $0x8,%esp
801045a9:	50                   	push   %eax
801045aa:	68 0f a8 10 80       	push   $0x8010a80f
801045af:	e8 40 be ff ff       	call   801003f4 <cprintf>
801045b4:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045bb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801045bf:	7f 0b                	jg     801045cc <procdump+0xd2>
801045c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801045c8:	85 c0                	test   %eax,%eax
801045ca:	75 d3                	jne    8010459f <procdump+0xa5>
    }
    cprintf("\n");
801045cc:	83 ec 0c             	sub    $0xc,%esp
801045cf:	68 13 a8 10 80       	push   $0x8010a813
801045d4:	e8 1b be ff ff       	call   801003f4 <cprintf>
801045d9:	83 c4 10             	add    $0x10,%esp
801045dc:	eb 01                	jmp    801045df <procdump+0xe5>
      continue;
801045de:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045df:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
801045e3:	81 7d f0 34 61 19 80 	cmpl   $0x80196134,-0x10(%ebp)
801045ea:	0f 82 1c ff ff ff    	jb     8010450c <procdump+0x12>
  }
}
801045f0:	90                   	nop
801045f1:	90                   	nop
801045f2:	c9                   	leave  
801045f3:	c3                   	ret    

801045f4 <printpt>:

int printpt(int pid) {
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  pte_t *pgtab;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045fa:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104601:	e9 0f 01 00 00       	jmp    80104715 <printpt+0x121>
    if (p->pid == pid) {
80104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104609:	8b 40 10             	mov    0x10(%eax),%eax
8010460c:	39 45 08             	cmp    %eax,0x8(%ebp)
8010460f:	0f 85 fc 00 00 00    	jne    80104711 <printpt+0x11d>
      cprintf("START PAGE TABLE (pid %d)\n", pid);
80104615:	83 ec 08             	sub    $0x8,%esp
80104618:	ff 75 08             	push   0x8(%ebp)
8010461b:	68 15 a8 10 80       	push   $0x8010a815
80104620:	e8 cf bd ff ff       	call   801003f4 <cprintf>
80104625:	83 c4 10             	add    $0x10,%esp
      for (uint va = 0; va < KERNBASE; va += PGSIZE) {
80104628:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010462f:	e9 bb 00 00 00       	jmp    801046ef <printpt+0xfb>
        pde_t pde = p->pgdir[PDX(va)];
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	8b 50 04             	mov    0x4(%eax),%edx
8010463a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010463d:	c1 e8 16             	shr    $0x16,%eax
80104640:	c1 e0 02             	shl    $0x2,%eax
80104643:	01 d0                	add    %edx,%eax
80104645:	8b 00                	mov    (%eax),%eax
80104647:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pde & PTE_P) {
8010464a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010464d:	83 e0 01             	and    $0x1,%eax
80104650:	85 c0                	test   %eax,%eax
80104652:	0f 84 90 00 00 00    	je     801046e8 <printpt+0xf4>
          pgtab = (pte_t*)P2V(PTE_ADDR(pde));
80104658:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010465b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104660:	05 00 00 00 80       	add    $0x80000000,%eax
80104665:	89 45 e8             	mov    %eax,-0x18(%ebp)
          pte_t pte = pgtab[PTX(va)];
80104668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010466b:	c1 e8 0c             	shr    $0xc,%eax
8010466e:	25 ff 03 00 00       	and    $0x3ff,%eax
80104673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010467a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010467d:	01 d0                	add    %edx,%eax
8010467f:	8b 00                	mov    (%eax),%eax
80104681:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if (pte & PTE_P) {
80104684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104687:	83 e0 01             	and    $0x1,%eax
8010468a:	85 c0                	test   %eax,%eax
8010468c:	74 5a                	je     801046e8 <printpt+0xf4>
            char *u = (pte & PTE_U) ? "U" : "K";
8010468e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104691:	83 e0 04             	and    $0x4,%eax
80104694:	85 c0                	test   %eax,%eax
80104696:	74 07                	je     8010469f <printpt+0xab>
80104698:	b8 30 a8 10 80       	mov    $0x8010a830,%eax
8010469d:	eb 05                	jmp    801046a4 <printpt+0xb0>
8010469f:	b8 32 a8 10 80       	mov    $0x8010a832,%eax
801046a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
            char *w = (pte & PTE_W) ? "W" : "-";
801046a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046aa:	83 e0 02             	and    $0x2,%eax
801046ad:	85 c0                	test   %eax,%eax
801046af:	74 07                	je     801046b8 <printpt+0xc4>
801046b1:	b8 34 a8 10 80       	mov    $0x8010a834,%eax
801046b6:	eb 05                	jmp    801046bd <printpt+0xc9>
801046b8:	b8 36 a8 10 80       	mov    $0x8010a836,%eax
801046bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
            cprintf("%x P %s %s %x\n", va >> 12, u, w, PTE_ADDR(pte));
801046c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801046c8:	89 c2                	mov    %eax,%edx
801046ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046cd:	c1 e8 0c             	shr    $0xc,%eax
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	52                   	push   %edx
801046d4:	ff 75 dc             	push   -0x24(%ebp)
801046d7:	ff 75 e0             	push   -0x20(%ebp)
801046da:	50                   	push   %eax
801046db:	68 38 a8 10 80       	push   $0x8010a838
801046e0:	e8 0f bd ff ff       	call   801003f4 <cprintf>
801046e5:	83 c4 20             	add    $0x20,%esp
      for (uint va = 0; va < KERNBASE; va += PGSIZE) {
801046e8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
801046ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046f2:	85 c0                	test   %eax,%eax
801046f4:	0f 89 3a ff ff ff    	jns    80104634 <printpt+0x40>
          }
        }
      }
      cprintf("END PAGE TABLE\n");
801046fa:	83 ec 0c             	sub    $0xc,%esp
801046fd:	68 47 a8 10 80       	push   $0x8010a847
80104702:	e8 ed bc ff ff       	call   801003f4 <cprintf>
80104707:	83 c4 10             	add    $0x10,%esp
      return 0;
8010470a:	b8 00 00 00 00       	mov    $0x0,%eax
8010470f:	eb 29                	jmp    8010473a <printpt+0x146>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104711:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104715:	81 7d f4 34 61 19 80 	cmpl   $0x80196134,-0xc(%ebp)
8010471c:	0f 82 e4 fe ff ff    	jb     80104606 <printpt+0x12>
    }
  }

  cprintf("printpt: pid %d not found\n", pid);
80104722:	83 ec 08             	sub    $0x8,%esp
80104725:	ff 75 08             	push   0x8(%ebp)
80104728:	68 57 a8 10 80       	push   $0x8010a857
8010472d:	e8 c2 bc ff ff       	call   801003f4 <cprintf>
80104732:	83 c4 10             	add    $0x10,%esp
  return -1;
80104735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010473a:	c9                   	leave  
8010473b:	c3                   	ret    

8010473c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010473c:	55                   	push   %ebp
8010473d:	89 e5                	mov    %esp,%ebp
8010473f:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104742:	8b 45 08             	mov    0x8(%ebp),%eax
80104745:	83 c0 04             	add    $0x4,%eax
80104748:	83 ec 08             	sub    $0x8,%esp
8010474b:	68 9c a8 10 80       	push   $0x8010a89c
80104750:	50                   	push   %eax
80104751:	e8 43 01 00 00       	call   80104899 <initlock>
80104756:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104759:	8b 45 08             	mov    0x8(%ebp),%eax
8010475c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010475f:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104762:	8b 45 08             	mov    0x8(%ebp),%eax
80104765:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010476b:	8b 45 08             	mov    0x8(%ebp),%eax
8010476e:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104775:	90                   	nop
80104776:	c9                   	leave  
80104777:	c3                   	ret    

80104778 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104778:	55                   	push   %ebp
80104779:	89 e5                	mov    %esp,%ebp
8010477b:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010477e:	8b 45 08             	mov    0x8(%ebp),%eax
80104781:	83 c0 04             	add    $0x4,%eax
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	50                   	push   %eax
80104788:	e8 2e 01 00 00       	call   801048bb <acquire>
8010478d:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104790:	eb 15                	jmp    801047a7 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104792:	8b 45 08             	mov    0x8(%ebp),%eax
80104795:	83 c0 04             	add    $0x4,%eax
80104798:	83 ec 08             	sub    $0x8,%esp
8010479b:	50                   	push   %eax
8010479c:	ff 75 08             	push   0x8(%ebp)
8010479f:	e8 b4 fb ff ff       	call   80104358 <sleep>
801047a4:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801047a7:	8b 45 08             	mov    0x8(%ebp),%eax
801047aa:	8b 00                	mov    (%eax),%eax
801047ac:	85 c0                	test   %eax,%eax
801047ae:	75 e2                	jne    80104792 <acquiresleep+0x1a>
  }
  lk->locked = 1;
801047b0:	8b 45 08             	mov    0x8(%ebp),%eax
801047b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801047b9:	e8 57 f2 ff ff       	call   80103a15 <myproc>
801047be:	8b 50 10             	mov    0x10(%eax),%edx
801047c1:	8b 45 08             	mov    0x8(%ebp),%eax
801047c4:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801047c7:	8b 45 08             	mov    0x8(%ebp),%eax
801047ca:	83 c0 04             	add    $0x4,%eax
801047cd:	83 ec 0c             	sub    $0xc,%esp
801047d0:	50                   	push   %eax
801047d1:	e8 53 01 00 00       	call   80104929 <release>
801047d6:	83 c4 10             	add    $0x10,%esp
}
801047d9:	90                   	nop
801047da:	c9                   	leave  
801047db:	c3                   	ret    

801047dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047dc:	55                   	push   %ebp
801047dd:	89 e5                	mov    %esp,%ebp
801047df:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801047e2:	8b 45 08             	mov    0x8(%ebp),%eax
801047e5:	83 c0 04             	add    $0x4,%eax
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	50                   	push   %eax
801047ec:	e8 ca 00 00 00       	call   801048bb <acquire>
801047f1:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801047f4:	8b 45 08             	mov    0x8(%ebp),%eax
801047f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801047fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104800:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104807:	83 ec 0c             	sub    $0xc,%esp
8010480a:	ff 75 08             	push   0x8(%ebp)
8010480d:	e8 2d fc ff ff       	call   8010443f <wakeup>
80104812:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104815:	8b 45 08             	mov    0x8(%ebp),%eax
80104818:	83 c0 04             	add    $0x4,%eax
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	50                   	push   %eax
8010481f:	e8 05 01 00 00       	call   80104929 <release>
80104824:	83 c4 10             	add    $0x10,%esp
}
80104827:	90                   	nop
80104828:	c9                   	leave  
80104829:	c3                   	ret    

8010482a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010482a:	55                   	push   %ebp
8010482b:	89 e5                	mov    %esp,%ebp
8010482d:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104830:	8b 45 08             	mov    0x8(%ebp),%eax
80104833:	83 c0 04             	add    $0x4,%eax
80104836:	83 ec 0c             	sub    $0xc,%esp
80104839:	50                   	push   %eax
8010483a:	e8 7c 00 00 00       	call   801048bb <acquire>
8010483f:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104842:	8b 45 08             	mov    0x8(%ebp),%eax
80104845:	8b 00                	mov    (%eax),%eax
80104847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010484a:	8b 45 08             	mov    0x8(%ebp),%eax
8010484d:	83 c0 04             	add    $0x4,%eax
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	50                   	push   %eax
80104854:	e8 d0 00 00 00       	call   80104929 <release>
80104859:	83 c4 10             	add    $0x10,%esp
  return r;
8010485c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010485f:	c9                   	leave  
80104860:	c3                   	ret    

80104861 <readeflags>:
{
80104861:	55                   	push   %ebp
80104862:	89 e5                	mov    %esp,%ebp
80104864:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104867:	9c                   	pushf  
80104868:	58                   	pop    %eax
80104869:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010486c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010486f:	c9                   	leave  
80104870:	c3                   	ret    

80104871 <cli>:
{
80104871:	55                   	push   %ebp
80104872:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104874:	fa                   	cli    
}
80104875:	90                   	nop
80104876:	5d                   	pop    %ebp
80104877:	c3                   	ret    

80104878 <sti>:
{
80104878:	55                   	push   %ebp
80104879:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010487b:	fb                   	sti    
}
8010487c:	90                   	nop
8010487d:	5d                   	pop    %ebp
8010487e:	c3                   	ret    

8010487f <xchg>:
{
8010487f:	55                   	push   %ebp
80104880:	89 e5                	mov    %esp,%ebp
80104882:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104885:	8b 55 08             	mov    0x8(%ebp),%edx
80104888:	8b 45 0c             	mov    0xc(%ebp),%eax
8010488b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010488e:	f0 87 02             	lock xchg %eax,(%edx)
80104891:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104894:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104897:	c9                   	leave  
80104898:	c3                   	ret    

80104899 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104899:	55                   	push   %ebp
8010489a:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010489c:	8b 45 08             	mov    0x8(%ebp),%eax
8010489f:	8b 55 0c             	mov    0xc(%ebp),%edx
801048a2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801048a5:	8b 45 08             	mov    0x8(%ebp),%eax
801048a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801048ae:	8b 45 08             	mov    0x8(%ebp),%eax
801048b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048b8:	90                   	nop
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    

801048bb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048bb:	55                   	push   %ebp
801048bc:	89 e5                	mov    %esp,%ebp
801048be:	53                   	push   %ebx
801048bf:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048c2:	e8 5f 01 00 00       	call   80104a26 <pushcli>
  if(holding(lk)){
801048c7:	8b 45 08             	mov    0x8(%ebp),%eax
801048ca:	83 ec 0c             	sub    $0xc,%esp
801048cd:	50                   	push   %eax
801048ce:	e8 23 01 00 00       	call   801049f6 <holding>
801048d3:	83 c4 10             	add    $0x10,%esp
801048d6:	85 c0                	test   %eax,%eax
801048d8:	74 0d                	je     801048e7 <acquire+0x2c>
    panic("acquire");
801048da:	83 ec 0c             	sub    $0xc,%esp
801048dd:	68 a7 a8 10 80       	push   $0x8010a8a7
801048e2:	e8 c2 bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801048e7:	90                   	nop
801048e8:	8b 45 08             	mov    0x8(%ebp),%eax
801048eb:	83 ec 08             	sub    $0x8,%esp
801048ee:	6a 01                	push   $0x1
801048f0:	50                   	push   %eax
801048f1:	e8 89 ff ff ff       	call   8010487f <xchg>
801048f6:	83 c4 10             	add    $0x10,%esp
801048f9:	85 c0                	test   %eax,%eax
801048fb:	75 eb                	jne    801048e8 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801048fd:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104902:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104905:	e8 93 f0 ff ff       	call   8010399d <mycpu>
8010490a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010490d:	8b 45 08             	mov    0x8(%ebp),%eax
80104910:	83 c0 0c             	add    $0xc,%eax
80104913:	83 ec 08             	sub    $0x8,%esp
80104916:	50                   	push   %eax
80104917:	8d 45 08             	lea    0x8(%ebp),%eax
8010491a:	50                   	push   %eax
8010491b:	e8 5b 00 00 00       	call   8010497b <getcallerpcs>
80104920:	83 c4 10             	add    $0x10,%esp
}
80104923:	90                   	nop
80104924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104927:	c9                   	leave  
80104928:	c3                   	ret    

80104929 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104929:	55                   	push   %ebp
8010492a:	89 e5                	mov    %esp,%ebp
8010492c:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010492f:	83 ec 0c             	sub    $0xc,%esp
80104932:	ff 75 08             	push   0x8(%ebp)
80104935:	e8 bc 00 00 00       	call   801049f6 <holding>
8010493a:	83 c4 10             	add    $0x10,%esp
8010493d:	85 c0                	test   %eax,%eax
8010493f:	75 0d                	jne    8010494e <release+0x25>
    panic("release");
80104941:	83 ec 0c             	sub    $0xc,%esp
80104944:	68 af a8 10 80       	push   $0x8010a8af
80104949:	e8 5b bc ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
8010494e:	8b 45 08             	mov    0x8(%ebp),%eax
80104951:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104958:	8b 45 08             	mov    0x8(%ebp),%eax
8010495b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104962:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104967:	8b 45 08             	mov    0x8(%ebp),%eax
8010496a:	8b 55 08             	mov    0x8(%ebp),%edx
8010496d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104973:	e8 fb 00 00 00       	call   80104a73 <popcli>
}
80104978:	90                   	nop
80104979:	c9                   	leave  
8010497a:	c3                   	ret    

8010497b <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010497b:	55                   	push   %ebp
8010497c:	89 e5                	mov    %esp,%ebp
8010497e:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104981:	8b 45 08             	mov    0x8(%ebp),%eax
80104984:	83 e8 08             	sub    $0x8,%eax
80104987:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010498a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104991:	eb 38                	jmp    801049cb <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104993:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104997:	74 53                	je     801049ec <getcallerpcs+0x71>
80104999:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801049a0:	76 4a                	jbe    801049ec <getcallerpcs+0x71>
801049a2:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801049a6:	74 44                	je     801049ec <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801049b5:	01 c2                	add    %eax,%edx
801049b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049ba:	8b 40 04             	mov    0x4(%eax),%eax
801049bd:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801049bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049c2:	8b 00                	mov    (%eax),%eax
801049c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801049c7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801049cb:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801049cf:	7e c2                	jle    80104993 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801049d1:	eb 19                	jmp    801049ec <getcallerpcs+0x71>
    pcs[i] = 0;
801049d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801049e0:	01 d0                	add    %edx,%eax
801049e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049e8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801049ec:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801049f0:	7e e1                	jle    801049d3 <getcallerpcs+0x58>
}
801049f2:	90                   	nop
801049f3:	90                   	nop
801049f4:	c9                   	leave  
801049f5:	c3                   	ret    

801049f6 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801049f6:	55                   	push   %ebp
801049f7:	89 e5                	mov    %esp,%ebp
801049f9:	53                   	push   %ebx
801049fa:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801049fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104a00:	8b 00                	mov    (%eax),%eax
80104a02:	85 c0                	test   %eax,%eax
80104a04:	74 16                	je     80104a1c <holding+0x26>
80104a06:	8b 45 08             	mov    0x8(%ebp),%eax
80104a09:	8b 58 08             	mov    0x8(%eax),%ebx
80104a0c:	e8 8c ef ff ff       	call   8010399d <mycpu>
80104a11:	39 c3                	cmp    %eax,%ebx
80104a13:	75 07                	jne    80104a1c <holding+0x26>
80104a15:	b8 01 00 00 00       	mov    $0x1,%eax
80104a1a:	eb 05                	jmp    80104a21 <holding+0x2b>
80104a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a24:	c9                   	leave  
80104a25:	c3                   	ret    

80104a26 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a26:	55                   	push   %ebp
80104a27:	89 e5                	mov    %esp,%ebp
80104a29:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104a2c:	e8 30 fe ff ff       	call   80104861 <readeflags>
80104a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104a34:	e8 38 fe ff ff       	call   80104871 <cli>
  if(mycpu()->ncli == 0)
80104a39:	e8 5f ef ff ff       	call   8010399d <mycpu>
80104a3e:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a44:	85 c0                	test   %eax,%eax
80104a46:	75 14                	jne    80104a5c <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104a48:	e8 50 ef ff ff       	call   8010399d <mycpu>
80104a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a50:	81 e2 00 02 00 00    	and    $0x200,%edx
80104a56:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a5c:	e8 3c ef ff ff       	call   8010399d <mycpu>
80104a61:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a67:	83 c2 01             	add    $0x1,%edx
80104a6a:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104a70:	90                   	nop
80104a71:	c9                   	leave  
80104a72:	c3                   	ret    

80104a73 <popcli>:

void
popcli(void)
{
80104a73:	55                   	push   %ebp
80104a74:	89 e5                	mov    %esp,%ebp
80104a76:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104a79:	e8 e3 fd ff ff       	call   80104861 <readeflags>
80104a7e:	25 00 02 00 00       	and    $0x200,%eax
80104a83:	85 c0                	test   %eax,%eax
80104a85:	74 0d                	je     80104a94 <popcli+0x21>
    panic("popcli - interruptible");
80104a87:	83 ec 0c             	sub    $0xc,%esp
80104a8a:	68 b7 a8 10 80       	push   $0x8010a8b7
80104a8f:	e8 15 bb ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104a94:	e8 04 ef ff ff       	call   8010399d <mycpu>
80104a99:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a9f:	83 ea 01             	sub    $0x1,%edx
80104aa2:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104aa8:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104aae:	85 c0                	test   %eax,%eax
80104ab0:	79 0d                	jns    80104abf <popcli+0x4c>
    panic("popcli");
80104ab2:	83 ec 0c             	sub    $0xc,%esp
80104ab5:	68 ce a8 10 80       	push   $0x8010a8ce
80104aba:	e8 ea ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104abf:	e8 d9 ee ff ff       	call   8010399d <mycpu>
80104ac4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104aca:	85 c0                	test   %eax,%eax
80104acc:	75 14                	jne    80104ae2 <popcli+0x6f>
80104ace:	e8 ca ee ff ff       	call   8010399d <mycpu>
80104ad3:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ad9:	85 c0                	test   %eax,%eax
80104adb:	74 05                	je     80104ae2 <popcli+0x6f>
    sti();
80104add:	e8 96 fd ff ff       	call   80104878 <sti>
}
80104ae2:	90                   	nop
80104ae3:	c9                   	leave  
80104ae4:	c3                   	ret    

80104ae5 <stosb>:
{
80104ae5:	55                   	push   %ebp
80104ae6:	89 e5                	mov    %esp,%ebp
80104ae8:	57                   	push   %edi
80104ae9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104aea:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aed:	8b 55 10             	mov    0x10(%ebp),%edx
80104af0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104af3:	89 cb                	mov    %ecx,%ebx
80104af5:	89 df                	mov    %ebx,%edi
80104af7:	89 d1                	mov    %edx,%ecx
80104af9:	fc                   	cld    
80104afa:	f3 aa                	rep stos %al,%es:(%edi)
80104afc:	89 ca                	mov    %ecx,%edx
80104afe:	89 fb                	mov    %edi,%ebx
80104b00:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b03:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b06:	90                   	nop
80104b07:	5b                   	pop    %ebx
80104b08:	5f                   	pop    %edi
80104b09:	5d                   	pop    %ebp
80104b0a:	c3                   	ret    

80104b0b <stosl>:
{
80104b0b:	55                   	push   %ebp
80104b0c:	89 e5                	mov    %esp,%ebp
80104b0e:	57                   	push   %edi
80104b0f:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b13:	8b 55 10             	mov    0x10(%ebp),%edx
80104b16:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b19:	89 cb                	mov    %ecx,%ebx
80104b1b:	89 df                	mov    %ebx,%edi
80104b1d:	89 d1                	mov    %edx,%ecx
80104b1f:	fc                   	cld    
80104b20:	f3 ab                	rep stos %eax,%es:(%edi)
80104b22:	89 ca                	mov    %ecx,%edx
80104b24:	89 fb                	mov    %edi,%ebx
80104b26:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b29:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b2c:	90                   	nop
80104b2d:	5b                   	pop    %ebx
80104b2e:	5f                   	pop    %edi
80104b2f:	5d                   	pop    %ebp
80104b30:	c3                   	ret    

80104b31 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b31:	55                   	push   %ebp
80104b32:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104b34:	8b 45 08             	mov    0x8(%ebp),%eax
80104b37:	83 e0 03             	and    $0x3,%eax
80104b3a:	85 c0                	test   %eax,%eax
80104b3c:	75 43                	jne    80104b81 <memset+0x50>
80104b3e:	8b 45 10             	mov    0x10(%ebp),%eax
80104b41:	83 e0 03             	and    $0x3,%eax
80104b44:	85 c0                	test   %eax,%eax
80104b46:	75 39                	jne    80104b81 <memset+0x50>
    c &= 0xFF;
80104b48:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b4f:	8b 45 10             	mov    0x10(%ebp),%eax
80104b52:	c1 e8 02             	shr    $0x2,%eax
80104b55:	89 c2                	mov    %eax,%edx
80104b57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5a:	c1 e0 18             	shl    $0x18,%eax
80104b5d:	89 c1                	mov    %eax,%ecx
80104b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b62:	c1 e0 10             	shl    $0x10,%eax
80104b65:	09 c1                	or     %eax,%ecx
80104b67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6a:	c1 e0 08             	shl    $0x8,%eax
80104b6d:	09 c8                	or     %ecx,%eax
80104b6f:	0b 45 0c             	or     0xc(%ebp),%eax
80104b72:	52                   	push   %edx
80104b73:	50                   	push   %eax
80104b74:	ff 75 08             	push   0x8(%ebp)
80104b77:	e8 8f ff ff ff       	call   80104b0b <stosl>
80104b7c:	83 c4 0c             	add    $0xc,%esp
80104b7f:	eb 12                	jmp    80104b93 <memset+0x62>
  } else
    stosb(dst, c, n);
80104b81:	8b 45 10             	mov    0x10(%ebp),%eax
80104b84:	50                   	push   %eax
80104b85:	ff 75 0c             	push   0xc(%ebp)
80104b88:	ff 75 08             	push   0x8(%ebp)
80104b8b:	e8 55 ff ff ff       	call   80104ae5 <stosb>
80104b90:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104b93:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104b96:	c9                   	leave  
80104b97:	c3                   	ret    

80104b98 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b98:	55                   	push   %ebp
80104b99:	89 e5                	mov    %esp,%ebp
80104b9b:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104ba1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104baa:	eb 30                	jmp    80104bdc <memcmp+0x44>
    if(*s1 != *s2)
80104bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104baf:	0f b6 10             	movzbl (%eax),%edx
80104bb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bb5:	0f b6 00             	movzbl (%eax),%eax
80104bb8:	38 c2                	cmp    %al,%dl
80104bba:	74 18                	je     80104bd4 <memcmp+0x3c>
      return *s1 - *s2;
80104bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bbf:	0f b6 00             	movzbl (%eax),%eax
80104bc2:	0f b6 d0             	movzbl %al,%edx
80104bc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bc8:	0f b6 00             	movzbl (%eax),%eax
80104bcb:	0f b6 c8             	movzbl %al,%ecx
80104bce:	89 d0                	mov    %edx,%eax
80104bd0:	29 c8                	sub    %ecx,%eax
80104bd2:	eb 1a                	jmp    80104bee <memcmp+0x56>
    s1++, s2++;
80104bd4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104bd8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104bdc:	8b 45 10             	mov    0x10(%ebp),%eax
80104bdf:	8d 50 ff             	lea    -0x1(%eax),%edx
80104be2:	89 55 10             	mov    %edx,0x10(%ebp)
80104be5:	85 c0                	test   %eax,%eax
80104be7:	75 c3                	jne    80104bac <memcmp+0x14>
  }

  return 0;
80104be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104bee:	c9                   	leave  
80104bef:	c3                   	ret    

80104bf0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80104bff:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104c08:	73 54                	jae    80104c5e <memmove+0x6e>
80104c0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c0d:	8b 45 10             	mov    0x10(%ebp),%eax
80104c10:	01 d0                	add    %edx,%eax
80104c12:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104c15:	73 47                	jae    80104c5e <memmove+0x6e>
    s += n;
80104c17:	8b 45 10             	mov    0x10(%ebp),%eax
80104c1a:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104c1d:	8b 45 10             	mov    0x10(%ebp),%eax
80104c20:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104c23:	eb 13                	jmp    80104c38 <memmove+0x48>
      *--d = *--s;
80104c25:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104c29:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c30:	0f b6 10             	movzbl (%eax),%edx
80104c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c36:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104c38:	8b 45 10             	mov    0x10(%ebp),%eax
80104c3b:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c3e:	89 55 10             	mov    %edx,0x10(%ebp)
80104c41:	85 c0                	test   %eax,%eax
80104c43:	75 e0                	jne    80104c25 <memmove+0x35>
  if(s < d && s + n > d){
80104c45:	eb 24                	jmp    80104c6b <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104c47:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c4a:	8d 42 01             	lea    0x1(%edx),%eax
80104c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c53:	8d 48 01             	lea    0x1(%eax),%ecx
80104c56:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104c59:	0f b6 12             	movzbl (%edx),%edx
80104c5c:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104c5e:	8b 45 10             	mov    0x10(%ebp),%eax
80104c61:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c64:	89 55 10             	mov    %edx,0x10(%ebp)
80104c67:	85 c0                	test   %eax,%eax
80104c69:	75 dc                	jne    80104c47 <memmove+0x57>

  return dst;
80104c6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104c6e:	c9                   	leave  
80104c6f:	c3                   	ret    

80104c70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104c73:	ff 75 10             	push   0x10(%ebp)
80104c76:	ff 75 0c             	push   0xc(%ebp)
80104c79:	ff 75 08             	push   0x8(%ebp)
80104c7c:	e8 6f ff ff ff       	call   80104bf0 <memmove>
80104c81:	83 c4 0c             	add    $0xc,%esp
}
80104c84:	c9                   	leave  
80104c85:	c3                   	ret    

80104c86 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104c86:	55                   	push   %ebp
80104c87:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104c89:	eb 0c                	jmp    80104c97 <strncmp+0x11>
    n--, p++, q++;
80104c8b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104c8f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104c93:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104c97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104c9b:	74 1a                	je     80104cb7 <strncmp+0x31>
80104c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca0:	0f b6 00             	movzbl (%eax),%eax
80104ca3:	84 c0                	test   %al,%al
80104ca5:	74 10                	je     80104cb7 <strncmp+0x31>
80104ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80104caa:	0f b6 10             	movzbl (%eax),%edx
80104cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cb0:	0f b6 00             	movzbl (%eax),%eax
80104cb3:	38 c2                	cmp    %al,%dl
80104cb5:	74 d4                	je     80104c8b <strncmp+0x5>
  if(n == 0)
80104cb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104cbb:	75 07                	jne    80104cc4 <strncmp+0x3e>
    return 0;
80104cbd:	b8 00 00 00 00       	mov    $0x0,%eax
80104cc2:	eb 16                	jmp    80104cda <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc7:	0f b6 00             	movzbl (%eax),%eax
80104cca:	0f b6 d0             	movzbl %al,%edx
80104ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cd0:	0f b6 00             	movzbl (%eax),%eax
80104cd3:	0f b6 c8             	movzbl %al,%ecx
80104cd6:	89 d0                	mov    %edx,%eax
80104cd8:	29 c8                	sub    %ecx,%eax
}
80104cda:	5d                   	pop    %ebp
80104cdb:	c3                   	ret    

80104cdc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cdc:	55                   	push   %ebp
80104cdd:	89 e5                	mov    %esp,%ebp
80104cdf:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ce8:	90                   	nop
80104ce9:	8b 45 10             	mov    0x10(%ebp),%eax
80104cec:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cef:	89 55 10             	mov    %edx,0x10(%ebp)
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	7e 2c                	jle    80104d22 <strncpy+0x46>
80104cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cf9:	8d 42 01             	lea    0x1(%edx),%eax
80104cfc:	89 45 0c             	mov    %eax,0xc(%ebp)
80104cff:	8b 45 08             	mov    0x8(%ebp),%eax
80104d02:	8d 48 01             	lea    0x1(%eax),%ecx
80104d05:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d08:	0f b6 12             	movzbl (%edx),%edx
80104d0b:	88 10                	mov    %dl,(%eax)
80104d0d:	0f b6 00             	movzbl (%eax),%eax
80104d10:	84 c0                	test   %al,%al
80104d12:	75 d5                	jne    80104ce9 <strncpy+0xd>
    ;
  while(n-- > 0)
80104d14:	eb 0c                	jmp    80104d22 <strncpy+0x46>
    *s++ = 0;
80104d16:	8b 45 08             	mov    0x8(%ebp),%eax
80104d19:	8d 50 01             	lea    0x1(%eax),%edx
80104d1c:	89 55 08             	mov    %edx,0x8(%ebp)
80104d1f:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104d22:	8b 45 10             	mov    0x10(%ebp),%eax
80104d25:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d28:	89 55 10             	mov    %edx,0x10(%ebp)
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	7f e7                	jg     80104d16 <strncpy+0x3a>
  return os;
80104d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d32:	c9                   	leave  
80104d33:	c3                   	ret    

80104d34 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d44:	7f 05                	jg     80104d4b <safestrcpy+0x17>
    return os;
80104d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d49:	eb 32                	jmp    80104d7d <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80104d4b:	90                   	nop
80104d4c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d54:	7e 1e                	jle    80104d74 <safestrcpy+0x40>
80104d56:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d59:	8d 42 01             	lea    0x1(%edx),%eax
80104d5c:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d62:	8d 48 01             	lea    0x1(%eax),%ecx
80104d65:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d68:	0f b6 12             	movzbl (%edx),%edx
80104d6b:	88 10                	mov    %dl,(%eax)
80104d6d:	0f b6 00             	movzbl (%eax),%eax
80104d70:	84 c0                	test   %al,%al
80104d72:	75 d8                	jne    80104d4c <safestrcpy+0x18>
    ;
  *s = 0;
80104d74:	8b 45 08             	mov    0x8(%ebp),%eax
80104d77:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d7d:	c9                   	leave  
80104d7e:	c3                   	ret    

80104d7f <strlen>:

int
strlen(const char *s)
{
80104d7f:	55                   	push   %ebp
80104d80:	89 e5                	mov    %esp,%ebp
80104d82:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104d85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104d8c:	eb 04                	jmp    80104d92 <strlen+0x13>
80104d8e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d92:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d95:	8b 45 08             	mov    0x8(%ebp),%eax
80104d98:	01 d0                	add    %edx,%eax
80104d9a:	0f b6 00             	movzbl (%eax),%eax
80104d9d:	84 c0                	test   %al,%al
80104d9f:	75 ed                	jne    80104d8e <strlen+0xf>
    ;
  return n;
80104da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104da4:	c9                   	leave  
80104da5:	c3                   	ret    

80104da6 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104da6:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104daa:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104dae:	55                   	push   %ebp
  pushl %ebx
80104daf:	53                   	push   %ebx
  pushl %esi
80104db0:	56                   	push   %esi
  pushl %edi
80104db1:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104db2:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104db4:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104db6:	5f                   	pop    %edi
  popl %esi
80104db7:	5e                   	pop    %esi
  popl %ebx
80104db8:	5b                   	pop    %ebx
  popl %ebp
80104db9:	5d                   	pop    %ebp
  ret
80104dba:	c3                   	ret    

80104dbb <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104dbb:	55                   	push   %ebp
80104dbc:	89 e5                	mov    %esp,%ebp
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
80104dbe:	81 7d 08 fe ff ff 7f 	cmpl   $0x7ffffffe,0x8(%ebp)
80104dc5:	77 0a                	ja     80104dd1 <fetchint+0x16>
80104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dca:	83 c0 04             	add    $0x4,%eax
80104dcd:	85 c0                	test   %eax,%eax
80104dcf:	79 07                	jns    80104dd8 <fetchint+0x1d>
    return -1;
80104dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd6:	eb 0f                	jmp    80104de7 <fetchint+0x2c>

  *ip = *(int*)(addr);
80104dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80104ddb:	8b 10                	mov    (%eax),%edx
80104ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104de0:	89 10                	mov    %edx,(%eax)
  
  return 0;
80104de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret    

80104de9 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104de9:	55                   	push   %ebp
80104dea:	89 e5                	mov    %esp,%ebp
80104dec:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= (KERNBASE-1))
80104def:	81 7d 08 fe ff ff 7f 	cmpl   $0x7ffffffe,0x8(%ebp)
80104df6:	76 07                	jbe    80104dff <fetchstr+0x16>
    return -1;
80104df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfd:	eb 40                	jmp    80104e3f <fetchstr+0x56>

  *pp = (char*)addr;
80104dff:	8b 55 08             	mov    0x8(%ebp),%edx
80104e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e05:	89 10                	mov    %edx,(%eax)
  ep = (char*)(KERNBASE-1);
80104e07:	c7 45 f8 ff ff ff 7f 	movl   $0x7fffffff,-0x8(%ebp)

  for(s = *pp; s < ep; s++){
80104e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e11:	8b 00                	mov    (%eax),%eax
80104e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e16:	eb 1a                	jmp    80104e32 <fetchstr+0x49>
    if(*s == 0)
80104e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e1b:	0f b6 00             	movzbl (%eax),%eax
80104e1e:	84 c0                	test   %al,%al
80104e20:	75 0c                	jne    80104e2e <fetchstr+0x45>
      return s - *pp;
80104e22:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e25:	8b 10                	mov    (%eax),%edx
80104e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e2a:	29 d0                	sub    %edx,%eax
80104e2c:	eb 11                	jmp    80104e3f <fetchstr+0x56>
  for(s = *pp; s < ep; s++){
80104e2e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e38:	72 de                	jb     80104e18 <fetchstr+0x2f>
  }
  return -1;
80104e3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e3f:	c9                   	leave  
80104e40:	c3                   	ret    

80104e41 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e41:	55                   	push   %ebp
80104e42:	89 e5                	mov    %esp,%ebp
80104e44:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e47:	e8 c9 eb ff ff       	call   80103a15 <myproc>
80104e4c:	8b 40 18             	mov    0x18(%eax),%eax
80104e4f:	8b 50 44             	mov    0x44(%eax),%edx
80104e52:	8b 45 08             	mov    0x8(%ebp),%eax
80104e55:	c1 e0 02             	shl    $0x2,%eax
80104e58:	01 d0                	add    %edx,%eax
80104e5a:	83 c0 04             	add    $0x4,%eax
80104e5d:	83 ec 08             	sub    $0x8,%esp
80104e60:	ff 75 0c             	push   0xc(%ebp)
80104e63:	50                   	push   %eax
80104e64:	e8 52 ff ff ff       	call   80104dbb <fetchint>
80104e69:	83 c4 10             	add    $0x10,%esp
}
80104e6c:	c9                   	leave  
80104e6d:	c3                   	ret    

80104e6e <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e6e:	55                   	push   %ebp
80104e6f:	89 e5                	mov    %esp,%ebp
80104e71:	83 ec 18             	sub    $0x18,%esp
  int i;
 
  if(argint(n, &i) < 0)
80104e74:	83 ec 08             	sub    $0x8,%esp
80104e77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7a:	50                   	push   %eax
80104e7b:	ff 75 08             	push   0x8(%ebp)
80104e7e:	e8 be ff ff ff       	call   80104e41 <argint>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	79 07                	jns    80104e91 <argptr+0x23>
    return -1;
80104e8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8f:	eb 34                	jmp    80104ec5 <argptr+0x57>
  if(size < 0 || (uint)i >= (KERNBASE-1) || (uint)i+size > (KERNBASE-1))
80104e91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e95:	78 18                	js     80104eaf <argptr+0x41>
80104e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9a:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104e9f:	77 0e                	ja     80104eaf <argptr+0x41>
80104ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea4:	89 c2                	mov    %eax,%edx
80104ea6:	8b 45 10             	mov    0x10(%ebp),%eax
80104ea9:	01 d0                	add    %edx,%eax
80104eab:	85 c0                	test   %eax,%eax
80104ead:	79 07                	jns    80104eb6 <argptr+0x48>
    return -1;
80104eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb4:	eb 0f                	jmp    80104ec5 <argptr+0x57>
  *pp = (char*)i;
80104eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb9:	89 c2                	mov    %eax,%edx
80104ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebe:	89 10                	mov    %edx,(%eax)
  return 0;
80104ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    

80104ec7 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ec7:	55                   	push   %ebp
80104ec8:	89 e5                	mov    %esp,%ebp
80104eca:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ecd:	83 ec 08             	sub    $0x8,%esp
80104ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ed3:	50                   	push   %eax
80104ed4:	ff 75 08             	push   0x8(%ebp)
80104ed7:	e8 65 ff ff ff       	call   80104e41 <argint>
80104edc:	83 c4 10             	add    $0x10,%esp
80104edf:	85 c0                	test   %eax,%eax
80104ee1:	79 07                	jns    80104eea <argstr+0x23>
    return -1;
80104ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee8:	eb 12                	jmp    80104efc <argstr+0x35>
  return fetchstr(addr, pp);
80104eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eed:	83 ec 08             	sub    $0x8,%esp
80104ef0:	ff 75 0c             	push   0xc(%ebp)
80104ef3:	50                   	push   %eax
80104ef4:	e8 f0 fe ff ff       	call   80104de9 <fetchstr>
80104ef9:	83 c4 10             	add    $0x10,%esp
}
80104efc:	c9                   	leave  
80104efd:	c3                   	ret    

80104efe <syscall>:
[SYS_printpt] sys_printpt,
};

void
syscall(void)
{
80104efe:	55                   	push   %ebp
80104eff:	89 e5                	mov    %esp,%ebp
80104f01:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104f04:	e8 0c eb ff ff       	call   80103a15 <myproc>
80104f09:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0f:	8b 40 18             	mov    0x18(%eax),%eax
80104f12:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f1c:	7e 2f                	jle    80104f4d <syscall+0x4f>
80104f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f21:	83 f8 16             	cmp    $0x16,%eax
80104f24:	77 27                	ja     80104f4d <syscall+0x4f>
80104f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f29:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f30:	85 c0                	test   %eax,%eax
80104f32:	74 19                	je     80104f4d <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f37:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f3e:	ff d0                	call   *%eax
80104f40:	89 c2                	mov    %eax,%edx
80104f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f45:	8b 40 18             	mov    0x18(%eax),%eax
80104f48:	89 50 1c             	mov    %edx,0x1c(%eax)
80104f4b:	eb 2c                	jmp    80104f79 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f50:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f56:	8b 40 10             	mov    0x10(%eax),%eax
80104f59:	ff 75 f0             	push   -0x10(%ebp)
80104f5c:	52                   	push   %edx
80104f5d:	50                   	push   %eax
80104f5e:	68 d5 a8 10 80       	push   $0x8010a8d5
80104f63:	e8 8c b4 ff ff       	call   801003f4 <cprintf>
80104f68:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80104f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6e:	8b 40 18             	mov    0x18(%eax),%eax
80104f71:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f78:	90                   	nop
80104f79:	90                   	nop
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    

80104f7c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104f7c:	55                   	push   %ebp
80104f7d:	89 e5                	mov    %esp,%ebp
80104f7f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104f82:	83 ec 08             	sub    $0x8,%esp
80104f85:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f88:	50                   	push   %eax
80104f89:	ff 75 08             	push   0x8(%ebp)
80104f8c:	e8 b0 fe ff ff       	call   80104e41 <argint>
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	85 c0                	test   %eax,%eax
80104f96:	79 07                	jns    80104f9f <argfd+0x23>
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb 4f                	jmp    80104fee <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	78 20                	js     80104fc6 <argfd+0x4a>
80104fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa9:	83 f8 0f             	cmp    $0xf,%eax
80104fac:	7f 18                	jg     80104fc6 <argfd+0x4a>
80104fae:	e8 62 ea ff ff       	call   80103a15 <myproc>
80104fb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fb6:	83 c2 08             	add    $0x8,%edx
80104fb9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fc4:	75 07                	jne    80104fcd <argfd+0x51>
    return -1;
80104fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcb:	eb 21                	jmp    80104fee <argfd+0x72>
  if(pfd)
80104fcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104fd1:	74 08                	je     80104fdb <argfd+0x5f>
    *pfd = fd;
80104fd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd9:	89 10                	mov    %edx,(%eax)
  if(pf)
80104fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fdf:	74 08                	je     80104fe9 <argfd+0x6d>
    *pf = f;
80104fe1:	8b 45 10             	mov    0x10(%ebp),%eax
80104fe4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe7:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fee:	c9                   	leave  
80104fef:	c3                   	ret    

80104ff0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80104ff6:	e8 1a ea ff ff       	call   80103a15 <myproc>
80104ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80104ffe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105005:	eb 2a                	jmp    80105031 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105007:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010500d:	83 c2 08             	add    $0x8,%edx
80105010:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105014:	85 c0                	test   %eax,%eax
80105016:	75 15                	jne    8010502d <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010501e:	8d 4a 08             	lea    0x8(%edx),%ecx
80105021:	8b 55 08             	mov    0x8(%ebp),%edx
80105024:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502b:	eb 0f                	jmp    8010503c <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
8010502d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105031:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105035:	7e d0                	jle    80105007 <fdalloc+0x17>
    }
  }
  return -1;
80105037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010503c:	c9                   	leave  
8010503d:	c3                   	ret    

8010503e <sys_dup>:

int
sys_dup(void)
{
8010503e:	55                   	push   %ebp
8010503f:	89 e5                	mov    %esp,%ebp
80105041:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105044:	83 ec 04             	sub    $0x4,%esp
80105047:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010504a:	50                   	push   %eax
8010504b:	6a 00                	push   $0x0
8010504d:	6a 00                	push   $0x0
8010504f:	e8 28 ff ff ff       	call   80104f7c <argfd>
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	85 c0                	test   %eax,%eax
80105059:	79 07                	jns    80105062 <sys_dup+0x24>
    return -1;
8010505b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105060:	eb 31                	jmp    80105093 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105065:	83 ec 0c             	sub    $0xc,%esp
80105068:	50                   	push   %eax
80105069:	e8 82 ff ff ff       	call   80104ff0 <fdalloc>
8010506e:	83 c4 10             	add    $0x10,%esp
80105071:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105078:	79 07                	jns    80105081 <sys_dup+0x43>
    return -1;
8010507a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507f:	eb 12                	jmp    80105093 <sys_dup+0x55>
  filedup(f);
80105081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	50                   	push   %eax
80105088:	e8 a2 bf ff ff       	call   8010102f <filedup>
8010508d:	83 c4 10             	add    $0x10,%esp
  return fd;
80105090:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105093:	c9                   	leave  
80105094:	c3                   	ret    

80105095 <sys_read>:

int
sys_read(void)
{
80105095:	55                   	push   %ebp
80105096:	89 e5                	mov    %esp,%ebp
80105098:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010509b:	83 ec 04             	sub    $0x4,%esp
8010509e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050a1:	50                   	push   %eax
801050a2:	6a 00                	push   $0x0
801050a4:	6a 00                	push   $0x0
801050a6:	e8 d1 fe ff ff       	call   80104f7c <argfd>
801050ab:	83 c4 10             	add    $0x10,%esp
801050ae:	85 c0                	test   %eax,%eax
801050b0:	78 2e                	js     801050e0 <sys_read+0x4b>
801050b2:	83 ec 08             	sub    $0x8,%esp
801050b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b8:	50                   	push   %eax
801050b9:	6a 02                	push   $0x2
801050bb:	e8 81 fd ff ff       	call   80104e41 <argint>
801050c0:	83 c4 10             	add    $0x10,%esp
801050c3:	85 c0                	test   %eax,%eax
801050c5:	78 19                	js     801050e0 <sys_read+0x4b>
801050c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ca:	83 ec 04             	sub    $0x4,%esp
801050cd:	50                   	push   %eax
801050ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050d1:	50                   	push   %eax
801050d2:	6a 01                	push   $0x1
801050d4:	e8 95 fd ff ff       	call   80104e6e <argptr>
801050d9:	83 c4 10             	add    $0x10,%esp
801050dc:	85 c0                	test   %eax,%eax
801050de:	79 07                	jns    801050e7 <sys_read+0x52>
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e5:	eb 17                	jmp    801050fe <sys_read+0x69>
  return fileread(f, p, n);
801050e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801050ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
801050ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f0:	83 ec 04             	sub    $0x4,%esp
801050f3:	51                   	push   %ecx
801050f4:	52                   	push   %edx
801050f5:	50                   	push   %eax
801050f6:	e8 c4 c0 ff ff       	call   801011bf <fileread>
801050fb:	83 c4 10             	add    $0x10,%esp
}
801050fe:	c9                   	leave  
801050ff:	c3                   	ret    

80105100 <sys_write>:

int
sys_write(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105106:	83 ec 04             	sub    $0x4,%esp
80105109:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010510c:	50                   	push   %eax
8010510d:	6a 00                	push   $0x0
8010510f:	6a 00                	push   $0x0
80105111:	e8 66 fe ff ff       	call   80104f7c <argfd>
80105116:	83 c4 10             	add    $0x10,%esp
80105119:	85 c0                	test   %eax,%eax
8010511b:	78 2e                	js     8010514b <sys_write+0x4b>
8010511d:	83 ec 08             	sub    $0x8,%esp
80105120:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105123:	50                   	push   %eax
80105124:	6a 02                	push   $0x2
80105126:	e8 16 fd ff ff       	call   80104e41 <argint>
8010512b:	83 c4 10             	add    $0x10,%esp
8010512e:	85 c0                	test   %eax,%eax
80105130:	78 19                	js     8010514b <sys_write+0x4b>
80105132:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105135:	83 ec 04             	sub    $0x4,%esp
80105138:	50                   	push   %eax
80105139:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010513c:	50                   	push   %eax
8010513d:	6a 01                	push   $0x1
8010513f:	e8 2a fd ff ff       	call   80104e6e <argptr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	79 07                	jns    80105152 <sys_write+0x52>
    return -1;
8010514b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105150:	eb 17                	jmp    80105169 <sys_write+0x69>
  return filewrite(f, p, n);
80105152:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105155:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515b:	83 ec 04             	sub    $0x4,%esp
8010515e:	51                   	push   %ecx
8010515f:	52                   	push   %edx
80105160:	50                   	push   %eax
80105161:	e8 11 c1 ff ff       	call   80101277 <filewrite>
80105166:	83 c4 10             	add    $0x10,%esp
}
80105169:	c9                   	leave  
8010516a:	c3                   	ret    

8010516b <sys_close>:

int
sys_close(void)
{
8010516b:	55                   	push   %ebp
8010516c:	89 e5                	mov    %esp,%ebp
8010516e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105171:	83 ec 04             	sub    $0x4,%esp
80105174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105177:	50                   	push   %eax
80105178:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010517b:	50                   	push   %eax
8010517c:	6a 00                	push   $0x0
8010517e:	e8 f9 fd ff ff       	call   80104f7c <argfd>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	79 07                	jns    80105191 <sys_close+0x26>
    return -1;
8010518a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518f:	eb 27                	jmp    801051b8 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
80105191:	e8 7f e8 ff ff       	call   80103a15 <myproc>
80105196:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105199:	83 c2 08             	add    $0x8,%edx
8010519c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801051a3:	00 
  fileclose(f);
801051a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a7:	83 ec 0c             	sub    $0xc,%esp
801051aa:	50                   	push   %eax
801051ab:	e8 d0 be ff ff       	call   80101080 <fileclose>
801051b0:	83 c4 10             	add    $0x10,%esp
  return 0;
801051b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051b8:	c9                   	leave  
801051b9:	c3                   	ret    

801051ba <sys_fstat>:

int
sys_fstat(void)
{
801051ba:	55                   	push   %ebp
801051bb:	89 e5                	mov    %esp,%ebp
801051bd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051c0:	83 ec 04             	sub    $0x4,%esp
801051c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c6:	50                   	push   %eax
801051c7:	6a 00                	push   $0x0
801051c9:	6a 00                	push   $0x0
801051cb:	e8 ac fd ff ff       	call   80104f7c <argfd>
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	85 c0                	test   %eax,%eax
801051d5:	78 17                	js     801051ee <sys_fstat+0x34>
801051d7:	83 ec 04             	sub    $0x4,%esp
801051da:	6a 14                	push   $0x14
801051dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051df:	50                   	push   %eax
801051e0:	6a 01                	push   $0x1
801051e2:	e8 87 fc ff ff       	call   80104e6e <argptr>
801051e7:	83 c4 10             	add    $0x10,%esp
801051ea:	85 c0                	test   %eax,%eax
801051ec:	79 07                	jns    801051f5 <sys_fstat+0x3b>
    return -1;
801051ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f3:	eb 13                	jmp    80105208 <sys_fstat+0x4e>
  return filestat(f, st);
801051f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051fb:	83 ec 08             	sub    $0x8,%esp
801051fe:	52                   	push   %edx
801051ff:	50                   	push   %eax
80105200:	e8 63 bf ff ff       	call   80101168 <filestat>
80105205:	83 c4 10             	add    $0x10,%esp
}
80105208:	c9                   	leave  
80105209:	c3                   	ret    

8010520a <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010520a:	55                   	push   %ebp
8010520b:	89 e5                	mov    %esp,%ebp
8010520d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105210:	83 ec 08             	sub    $0x8,%esp
80105213:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105216:	50                   	push   %eax
80105217:	6a 00                	push   $0x0
80105219:	e8 a9 fc ff ff       	call   80104ec7 <argstr>
8010521e:	83 c4 10             	add    $0x10,%esp
80105221:	85 c0                	test   %eax,%eax
80105223:	78 15                	js     8010523a <sys_link+0x30>
80105225:	83 ec 08             	sub    $0x8,%esp
80105228:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010522b:	50                   	push   %eax
8010522c:	6a 01                	push   $0x1
8010522e:	e8 94 fc ff ff       	call   80104ec7 <argstr>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	79 0a                	jns    80105244 <sys_link+0x3a>
    return -1;
8010523a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523f:	e9 68 01 00 00       	jmp    801053ac <sys_link+0x1a2>

  begin_op();
80105244:	e8 d8 dd ff ff       	call   80103021 <begin_op>
  if((ip = namei(old)) == 0){
80105249:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	50                   	push   %eax
80105250:	e8 ad d2 ff ff       	call   80102502 <namei>
80105255:	83 c4 10             	add    $0x10,%esp
80105258:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010525b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010525f:	75 0f                	jne    80105270 <sys_link+0x66>
    end_op();
80105261:	e8 47 de ff ff       	call   801030ad <end_op>
    return -1;
80105266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526b:	e9 3c 01 00 00       	jmp    801053ac <sys_link+0x1a2>
  }

  ilock(ip);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	ff 75 f4             	push   -0xc(%ebp)
80105276:	e8 54 c7 ff ff       	call   801019cf <ilock>
8010527b:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010527e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105281:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105285:	66 83 f8 01          	cmp    $0x1,%ax
80105289:	75 1d                	jne    801052a8 <sys_link+0x9e>
    iunlockput(ip);
8010528b:	83 ec 0c             	sub    $0xc,%esp
8010528e:	ff 75 f4             	push   -0xc(%ebp)
80105291:	e8 6a c9 ff ff       	call   80101c00 <iunlockput>
80105296:	83 c4 10             	add    $0x10,%esp
    end_op();
80105299:	e8 0f de ff ff       	call   801030ad <end_op>
    return -1;
8010529e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a3:	e9 04 01 00 00       	jmp    801053ac <sys_link+0x1a2>
  }

  ip->nlink++;
801052a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ab:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801052af:	83 c0 01             	add    $0x1,%eax
801052b2:	89 c2                	mov    %eax,%edx
801052b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b7:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801052bb:	83 ec 0c             	sub    $0xc,%esp
801052be:	ff 75 f4             	push   -0xc(%ebp)
801052c1:	e8 2c c5 ff ff       	call   801017f2 <iupdate>
801052c6:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	ff 75 f4             	push   -0xc(%ebp)
801052cf:	e8 0e c8 ff ff       	call   80101ae2 <iunlock>
801052d4:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801052d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801052da:	83 ec 08             	sub    $0x8,%esp
801052dd:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801052e0:	52                   	push   %edx
801052e1:	50                   	push   %eax
801052e2:	e8 37 d2 ff ff       	call   8010251e <nameiparent>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
801052ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052f1:	74 71                	je     80105364 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801052f3:	83 ec 0c             	sub    $0xc,%esp
801052f6:	ff 75 f0             	push   -0x10(%ebp)
801052f9:	e8 d1 c6 ff ff       	call   801019cf <ilock>
801052fe:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105301:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105304:	8b 10                	mov    (%eax),%edx
80105306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105309:	8b 00                	mov    (%eax),%eax
8010530b:	39 c2                	cmp    %eax,%edx
8010530d:	75 1d                	jne    8010532c <sys_link+0x122>
8010530f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105312:	8b 40 04             	mov    0x4(%eax),%eax
80105315:	83 ec 04             	sub    $0x4,%esp
80105318:	50                   	push   %eax
80105319:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010531c:	50                   	push   %eax
8010531d:	ff 75 f0             	push   -0x10(%ebp)
80105320:	e8 46 cf ff ff       	call   8010226b <dirlink>
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	85 c0                	test   %eax,%eax
8010532a:	79 10                	jns    8010533c <sys_link+0x132>
    iunlockput(dp);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	ff 75 f0             	push   -0x10(%ebp)
80105332:	e8 c9 c8 ff ff       	call   80101c00 <iunlockput>
80105337:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010533a:	eb 29                	jmp    80105365 <sys_link+0x15b>
  }
  iunlockput(dp);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	ff 75 f0             	push   -0x10(%ebp)
80105342:	e8 b9 c8 ff ff       	call   80101c00 <iunlockput>
80105347:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010534a:	83 ec 0c             	sub    $0xc,%esp
8010534d:	ff 75 f4             	push   -0xc(%ebp)
80105350:	e8 db c7 ff ff       	call   80101b30 <iput>
80105355:	83 c4 10             	add    $0x10,%esp

  end_op();
80105358:	e8 50 dd ff ff       	call   801030ad <end_op>

  return 0;
8010535d:	b8 00 00 00 00       	mov    $0x0,%eax
80105362:	eb 48                	jmp    801053ac <sys_link+0x1a2>
    goto bad;
80105364:	90                   	nop

bad:
  ilock(ip);
80105365:	83 ec 0c             	sub    $0xc,%esp
80105368:	ff 75 f4             	push   -0xc(%ebp)
8010536b:	e8 5f c6 ff ff       	call   801019cf <ilock>
80105370:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105376:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010537a:	83 e8 01             	sub    $0x1,%eax
8010537d:	89 c2                	mov    %eax,%edx
8010537f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105382:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105386:	83 ec 0c             	sub    $0xc,%esp
80105389:	ff 75 f4             	push   -0xc(%ebp)
8010538c:	e8 61 c4 ff ff       	call   801017f2 <iupdate>
80105391:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105394:	83 ec 0c             	sub    $0xc,%esp
80105397:	ff 75 f4             	push   -0xc(%ebp)
8010539a:	e8 61 c8 ff ff       	call   80101c00 <iunlockput>
8010539f:	83 c4 10             	add    $0x10,%esp
  end_op();
801053a2:	e8 06 dd ff ff       	call   801030ad <end_op>
  return -1;
801053a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ac:	c9                   	leave  
801053ad:	c3                   	ret    

801053ae <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801053ae:	55                   	push   %ebp
801053af:	89 e5                	mov    %esp,%ebp
801053b1:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053b4:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801053bb:	eb 40                	jmp    801053fd <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c0:	6a 10                	push   $0x10
801053c2:	50                   	push   %eax
801053c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c6:	50                   	push   %eax
801053c7:	ff 75 08             	push   0x8(%ebp)
801053ca:	e8 ec ca ff ff       	call   80101ebb <readi>
801053cf:	83 c4 10             	add    $0x10,%esp
801053d2:	83 f8 10             	cmp    $0x10,%eax
801053d5:	74 0d                	je     801053e4 <isdirempty+0x36>
      panic("isdirempty: readi");
801053d7:	83 ec 0c             	sub    $0xc,%esp
801053da:	68 f1 a8 10 80       	push   $0x8010a8f1
801053df:	e8 c5 b1 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801053e4:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801053e8:	66 85 c0             	test   %ax,%ax
801053eb:	74 07                	je     801053f4 <isdirempty+0x46>
      return 0;
801053ed:	b8 00 00 00 00       	mov    $0x0,%eax
801053f2:	eb 1b                	jmp    8010540f <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f7:	83 c0 10             	add    $0x10,%eax
801053fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105400:	8b 50 58             	mov    0x58(%eax),%edx
80105403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105406:	39 c2                	cmp    %eax,%edx
80105408:	77 b3                	ja     801053bd <isdirempty+0xf>
  }
  return 1;
8010540a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010540f:	c9                   	leave  
80105410:	c3                   	ret    

80105411 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105411:	55                   	push   %ebp
80105412:	89 e5                	mov    %esp,%ebp
80105414:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010541d:	50                   	push   %eax
8010541e:	6a 00                	push   $0x0
80105420:	e8 a2 fa ff ff       	call   80104ec7 <argstr>
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	85 c0                	test   %eax,%eax
8010542a:	79 0a                	jns    80105436 <sys_unlink+0x25>
    return -1;
8010542c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105431:	e9 bf 01 00 00       	jmp    801055f5 <sys_unlink+0x1e4>

  begin_op();
80105436:	e8 e6 db ff ff       	call   80103021 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010543b:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010543e:	83 ec 08             	sub    $0x8,%esp
80105441:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105444:	52                   	push   %edx
80105445:	50                   	push   %eax
80105446:	e8 d3 d0 ff ff       	call   8010251e <nameiparent>
8010544b:	83 c4 10             	add    $0x10,%esp
8010544e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105455:	75 0f                	jne    80105466 <sys_unlink+0x55>
    end_op();
80105457:	e8 51 dc ff ff       	call   801030ad <end_op>
    return -1;
8010545c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105461:	e9 8f 01 00 00       	jmp    801055f5 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105466:	83 ec 0c             	sub    $0xc,%esp
80105469:	ff 75 f4             	push   -0xc(%ebp)
8010546c:	e8 5e c5 ff ff       	call   801019cf <ilock>
80105471:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105474:	83 ec 08             	sub    $0x8,%esp
80105477:	68 03 a9 10 80       	push   $0x8010a903
8010547c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010547f:	50                   	push   %eax
80105480:	e8 11 cd ff ff       	call   80102196 <namecmp>
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	85 c0                	test   %eax,%eax
8010548a:	0f 84 49 01 00 00    	je     801055d9 <sys_unlink+0x1c8>
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	68 05 a9 10 80       	push   $0x8010a905
80105498:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010549b:	50                   	push   %eax
8010549c:	e8 f5 cc ff ff       	call   80102196 <namecmp>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	85 c0                	test   %eax,%eax
801054a6:	0f 84 2d 01 00 00    	je     801055d9 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054ac:	83 ec 04             	sub    $0x4,%esp
801054af:	8d 45 c8             	lea    -0x38(%ebp),%eax
801054b2:	50                   	push   %eax
801054b3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054b6:	50                   	push   %eax
801054b7:	ff 75 f4             	push   -0xc(%ebp)
801054ba:	e8 f2 cc ff ff       	call   801021b1 <dirlookup>
801054bf:	83 c4 10             	add    $0x10,%esp
801054c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801054c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054c9:	0f 84 0d 01 00 00    	je     801055dc <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	ff 75 f0             	push   -0x10(%ebp)
801054d5:	e8 f5 c4 ff ff       	call   801019cf <ilock>
801054da:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801054dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054e0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801054e4:	66 85 c0             	test   %ax,%ax
801054e7:	7f 0d                	jg     801054f6 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	68 08 a9 10 80       	push   $0x8010a908
801054f1:	e8 b3 b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054f9:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801054fd:	66 83 f8 01          	cmp    $0x1,%ax
80105501:	75 25                	jne    80105528 <sys_unlink+0x117>
80105503:	83 ec 0c             	sub    $0xc,%esp
80105506:	ff 75 f0             	push   -0x10(%ebp)
80105509:	e8 a0 fe ff ff       	call   801053ae <isdirempty>
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	85 c0                	test   %eax,%eax
80105513:	75 13                	jne    80105528 <sys_unlink+0x117>
    iunlockput(ip);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	ff 75 f0             	push   -0x10(%ebp)
8010551b:	e8 e0 c6 ff ff       	call   80101c00 <iunlockput>
80105520:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105523:	e9 b5 00 00 00       	jmp    801055dd <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105528:	83 ec 04             	sub    $0x4,%esp
8010552b:	6a 10                	push   $0x10
8010552d:	6a 00                	push   $0x0
8010552f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105532:	50                   	push   %eax
80105533:	e8 f9 f5 ff ff       	call   80104b31 <memset>
80105538:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010553b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010553e:	6a 10                	push   $0x10
80105540:	50                   	push   %eax
80105541:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105544:	50                   	push   %eax
80105545:	ff 75 f4             	push   -0xc(%ebp)
80105548:	e8 c3 ca ff ff       	call   80102010 <writei>
8010554d:	83 c4 10             	add    $0x10,%esp
80105550:	83 f8 10             	cmp    $0x10,%eax
80105553:	74 0d                	je     80105562 <sys_unlink+0x151>
    panic("unlink: writei");
80105555:	83 ec 0c             	sub    $0xc,%esp
80105558:	68 1a a9 10 80       	push   $0x8010a91a
8010555d:	e8 47 b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105562:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105565:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105569:	66 83 f8 01          	cmp    $0x1,%ax
8010556d:	75 21                	jne    80105590 <sys_unlink+0x17f>
    dp->nlink--;
8010556f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105572:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105576:	83 e8 01             	sub    $0x1,%eax
80105579:	89 c2                	mov    %eax,%edx
8010557b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010557e:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105582:	83 ec 0c             	sub    $0xc,%esp
80105585:	ff 75 f4             	push   -0xc(%ebp)
80105588:	e8 65 c2 ff ff       	call   801017f2 <iupdate>
8010558d:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	ff 75 f4             	push   -0xc(%ebp)
80105596:	e8 65 c6 ff ff       	call   80101c00 <iunlockput>
8010559b:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010559e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a1:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055a5:	83 e8 01             	sub    $0x1,%eax
801055a8:	89 c2                	mov    %eax,%edx
801055aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ad:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801055b1:	83 ec 0c             	sub    $0xc,%esp
801055b4:	ff 75 f0             	push   -0x10(%ebp)
801055b7:	e8 36 c2 ff ff       	call   801017f2 <iupdate>
801055bc:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	ff 75 f0             	push   -0x10(%ebp)
801055c5:	e8 36 c6 ff ff       	call   80101c00 <iunlockput>
801055ca:	83 c4 10             	add    $0x10,%esp

  end_op();
801055cd:	e8 db da ff ff       	call   801030ad <end_op>

  return 0;
801055d2:	b8 00 00 00 00       	mov    $0x0,%eax
801055d7:	eb 1c                	jmp    801055f5 <sys_unlink+0x1e4>
    goto bad;
801055d9:	90                   	nop
801055da:	eb 01                	jmp    801055dd <sys_unlink+0x1cc>
    goto bad;
801055dc:	90                   	nop

bad:
  iunlockput(dp);
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	ff 75 f4             	push   -0xc(%ebp)
801055e3:	e8 18 c6 ff ff       	call   80101c00 <iunlockput>
801055e8:	83 c4 10             	add    $0x10,%esp
  end_op();
801055eb:	e8 bd da ff ff       	call   801030ad <end_op>
  return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f5:	c9                   	leave  
801055f6:	c3                   	ret    

801055f7 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801055f7:	55                   	push   %ebp
801055f8:	89 e5                	mov    %esp,%ebp
801055fa:	83 ec 38             	sub    $0x38,%esp
801055fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105600:	8b 55 10             	mov    0x10(%ebp),%edx
80105603:	8b 45 14             	mov    0x14(%ebp),%eax
80105606:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010560a:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010560e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105612:	83 ec 08             	sub    $0x8,%esp
80105615:	8d 45 de             	lea    -0x22(%ebp),%eax
80105618:	50                   	push   %eax
80105619:	ff 75 08             	push   0x8(%ebp)
8010561c:	e8 fd ce ff ff       	call   8010251e <nameiparent>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010562b:	75 0a                	jne    80105637 <create+0x40>
    return 0;
8010562d:	b8 00 00 00 00       	mov    $0x0,%eax
80105632:	e9 90 01 00 00       	jmp    801057c7 <create+0x1d0>
  ilock(dp);
80105637:	83 ec 0c             	sub    $0xc,%esp
8010563a:	ff 75 f4             	push   -0xc(%ebp)
8010563d:	e8 8d c3 ff ff       	call   801019cf <ilock>
80105642:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105645:	83 ec 04             	sub    $0x4,%esp
80105648:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010564b:	50                   	push   %eax
8010564c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010564f:	50                   	push   %eax
80105650:	ff 75 f4             	push   -0xc(%ebp)
80105653:	e8 59 cb ff ff       	call   801021b1 <dirlookup>
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010565e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105662:	74 50                	je     801056b4 <create+0xbd>
    iunlockput(dp);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	ff 75 f4             	push   -0xc(%ebp)
8010566a:	e8 91 c5 ff ff       	call   80101c00 <iunlockput>
8010566f:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105672:	83 ec 0c             	sub    $0xc,%esp
80105675:	ff 75 f0             	push   -0x10(%ebp)
80105678:	e8 52 c3 ff ff       	call   801019cf <ilock>
8010567d:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105680:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105685:	75 15                	jne    8010569c <create+0xa5>
80105687:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010568a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010568e:	66 83 f8 02          	cmp    $0x2,%ax
80105692:	75 08                	jne    8010569c <create+0xa5>
      return ip;
80105694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105697:	e9 2b 01 00 00       	jmp    801057c7 <create+0x1d0>
    iunlockput(ip);
8010569c:	83 ec 0c             	sub    $0xc,%esp
8010569f:	ff 75 f0             	push   -0x10(%ebp)
801056a2:	e8 59 c5 ff ff       	call   80101c00 <iunlockput>
801056a7:	83 c4 10             	add    $0x10,%esp
    return 0;
801056aa:	b8 00 00 00 00       	mov    $0x0,%eax
801056af:	e9 13 01 00 00       	jmp    801057c7 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801056b4:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801056b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056bb:	8b 00                	mov    (%eax),%eax
801056bd:	83 ec 08             	sub    $0x8,%esp
801056c0:	52                   	push   %edx
801056c1:	50                   	push   %eax
801056c2:	e8 54 c0 ff ff       	call   8010171b <ialloc>
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056d1:	75 0d                	jne    801056e0 <create+0xe9>
    panic("create: ialloc");
801056d3:	83 ec 0c             	sub    $0xc,%esp
801056d6:	68 29 a9 10 80       	push   $0x8010a929
801056db:	e8 c9 ae ff ff       	call   801005a9 <panic>

  ilock(ip);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	ff 75 f0             	push   -0x10(%ebp)
801056e6:	e8 e4 c2 ff ff       	call   801019cf <ilock>
801056eb:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801056ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f1:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801056f5:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801056f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056fc:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105700:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105704:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105707:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	ff 75 f0             	push   -0x10(%ebp)
80105713:	e8 da c0 ff ff       	call   801017f2 <iupdate>
80105718:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010571b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105720:	75 6a                	jne    8010578c <create+0x195>
    dp->nlink++;  // for ".."
80105722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105725:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105729:	83 c0 01             	add    $0x1,%eax
8010572c:	89 c2                	mov    %eax,%edx
8010572e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105731:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	ff 75 f4             	push   -0xc(%ebp)
8010573b:	e8 b2 c0 ff ff       	call   801017f2 <iupdate>
80105740:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105743:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105746:	8b 40 04             	mov    0x4(%eax),%eax
80105749:	83 ec 04             	sub    $0x4,%esp
8010574c:	50                   	push   %eax
8010574d:	68 03 a9 10 80       	push   $0x8010a903
80105752:	ff 75 f0             	push   -0x10(%ebp)
80105755:	e8 11 cb ff ff       	call   8010226b <dirlink>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	78 1e                	js     8010577f <create+0x188>
80105761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105764:	8b 40 04             	mov    0x4(%eax),%eax
80105767:	83 ec 04             	sub    $0x4,%esp
8010576a:	50                   	push   %eax
8010576b:	68 05 a9 10 80       	push   $0x8010a905
80105770:	ff 75 f0             	push   -0x10(%ebp)
80105773:	e8 f3 ca ff ff       	call   8010226b <dirlink>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	85 c0                	test   %eax,%eax
8010577d:	79 0d                	jns    8010578c <create+0x195>
      panic("create dots");
8010577f:	83 ec 0c             	sub    $0xc,%esp
80105782:	68 38 a9 10 80       	push   $0x8010a938
80105787:	e8 1d ae ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010578c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010578f:	8b 40 04             	mov    0x4(%eax),%eax
80105792:	83 ec 04             	sub    $0x4,%esp
80105795:	50                   	push   %eax
80105796:	8d 45 de             	lea    -0x22(%ebp),%eax
80105799:	50                   	push   %eax
8010579a:	ff 75 f4             	push   -0xc(%ebp)
8010579d:	e8 c9 ca ff ff       	call   8010226b <dirlink>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	79 0d                	jns    801057b6 <create+0x1bf>
    panic("create: dirlink");
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	68 44 a9 10 80       	push   $0x8010a944
801057b1:	e8 f3 ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801057b6:	83 ec 0c             	sub    $0xc,%esp
801057b9:	ff 75 f4             	push   -0xc(%ebp)
801057bc:	e8 3f c4 ff ff       	call   80101c00 <iunlockput>
801057c1:	83 c4 10             	add    $0x10,%esp

  return ip;
801057c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801057c7:	c9                   	leave  
801057c8:	c3                   	ret    

801057c9 <sys_open>:

int
sys_open(void)
{
801057c9:	55                   	push   %ebp
801057ca:	89 e5                	mov    %esp,%ebp
801057cc:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057cf:	83 ec 08             	sub    $0x8,%esp
801057d2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801057d5:	50                   	push   %eax
801057d6:	6a 00                	push   $0x0
801057d8:	e8 ea f6 ff ff       	call   80104ec7 <argstr>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	78 15                	js     801057f9 <sys_open+0x30>
801057e4:	83 ec 08             	sub    $0x8,%esp
801057e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057ea:	50                   	push   %eax
801057eb:	6a 01                	push   $0x1
801057ed:	e8 4f f6 ff ff       	call   80104e41 <argint>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	79 0a                	jns    80105803 <sys_open+0x3a>
    return -1;
801057f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fe:	e9 61 01 00 00       	jmp    80105964 <sys_open+0x19b>

  begin_op();
80105803:	e8 19 d8 ff ff       	call   80103021 <begin_op>

  if(omode & O_CREATE){
80105808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010580b:	25 00 02 00 00       	and    $0x200,%eax
80105810:	85 c0                	test   %eax,%eax
80105812:	74 2a                	je     8010583e <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105814:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105817:	6a 00                	push   $0x0
80105819:	6a 00                	push   $0x0
8010581b:	6a 02                	push   $0x2
8010581d:	50                   	push   %eax
8010581e:	e8 d4 fd ff ff       	call   801055f7 <create>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010582d:	75 75                	jne    801058a4 <sys_open+0xdb>
      end_op();
8010582f:	e8 79 d8 ff ff       	call   801030ad <end_op>
      return -1;
80105834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105839:	e9 26 01 00 00       	jmp    80105964 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010583e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	50                   	push   %eax
80105845:	e8 b8 cc ff ff       	call   80102502 <namei>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105854:	75 0f                	jne    80105865 <sys_open+0x9c>
      end_op();
80105856:	e8 52 d8 ff ff       	call   801030ad <end_op>
      return -1;
8010585b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105860:	e9 ff 00 00 00       	jmp    80105964 <sys_open+0x19b>
    }
    ilock(ip);
80105865:	83 ec 0c             	sub    $0xc,%esp
80105868:	ff 75 f4             	push   -0xc(%ebp)
8010586b:	e8 5f c1 ff ff       	call   801019cf <ilock>
80105870:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105876:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010587a:	66 83 f8 01          	cmp    $0x1,%ax
8010587e:	75 24                	jne    801058a4 <sys_open+0xdb>
80105880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105883:	85 c0                	test   %eax,%eax
80105885:	74 1d                	je     801058a4 <sys_open+0xdb>
      iunlockput(ip);
80105887:	83 ec 0c             	sub    $0xc,%esp
8010588a:	ff 75 f4             	push   -0xc(%ebp)
8010588d:	e8 6e c3 ff ff       	call   80101c00 <iunlockput>
80105892:	83 c4 10             	add    $0x10,%esp
      end_op();
80105895:	e8 13 d8 ff ff       	call   801030ad <end_op>
      return -1;
8010589a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589f:	e9 c0 00 00 00       	jmp    80105964 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058a4:	e8 19 b7 ff ff       	call   80100fc2 <filealloc>
801058a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058b0:	74 17                	je     801058c9 <sys_open+0x100>
801058b2:	83 ec 0c             	sub    $0xc,%esp
801058b5:	ff 75 f0             	push   -0x10(%ebp)
801058b8:	e8 33 f7 ff ff       	call   80104ff0 <fdalloc>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801058c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801058c7:	79 2e                	jns    801058f7 <sys_open+0x12e>
    if(f)
801058c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058cd:	74 0e                	je     801058dd <sys_open+0x114>
      fileclose(f);
801058cf:	83 ec 0c             	sub    $0xc,%esp
801058d2:	ff 75 f0             	push   -0x10(%ebp)
801058d5:	e8 a6 b7 ff ff       	call   80101080 <fileclose>
801058da:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801058dd:	83 ec 0c             	sub    $0xc,%esp
801058e0:	ff 75 f4             	push   -0xc(%ebp)
801058e3:	e8 18 c3 ff ff       	call   80101c00 <iunlockput>
801058e8:	83 c4 10             	add    $0x10,%esp
    end_op();
801058eb:	e8 bd d7 ff ff       	call   801030ad <end_op>
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f5:	eb 6d                	jmp    80105964 <sys_open+0x19b>
  }
  iunlock(ip);
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	ff 75 f4             	push   -0xc(%ebp)
801058fd:	e8 e0 c1 ff ff       	call   80101ae2 <iunlock>
80105902:	83 c4 10             	add    $0x10,%esp
  end_op();
80105905:	e8 a3 d7 ff ff       	call   801030ad <end_op>

  f->type = FD_INODE;
8010590a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010590d:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105913:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105916:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105919:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010591c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105929:	83 e0 01             	and    $0x1,%eax
8010592c:	85 c0                	test   %eax,%eax
8010592e:	0f 94 c0             	sete   %al
80105931:	89 c2                	mov    %eax,%edx
80105933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105936:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010593c:	83 e0 01             	and    $0x1,%eax
8010593f:	85 c0                	test   %eax,%eax
80105941:	75 0a                	jne    8010594d <sys_open+0x184>
80105943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105946:	83 e0 02             	and    $0x2,%eax
80105949:	85 c0                	test   %eax,%eax
8010594b:	74 07                	je     80105954 <sys_open+0x18b>
8010594d:	b8 01 00 00 00       	mov    $0x1,%eax
80105952:	eb 05                	jmp    80105959 <sys_open+0x190>
80105954:	b8 00 00 00 00       	mov    $0x0,%eax
80105959:	89 c2                	mov    %eax,%edx
8010595b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595e:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105961:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105964:	c9                   	leave  
80105965:	c3                   	ret    

80105966 <sys_mkdir>:

int
sys_mkdir(void)
{
80105966:	55                   	push   %ebp
80105967:	89 e5                	mov    %esp,%ebp
80105969:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010596c:	e8 b0 d6 ff ff       	call   80103021 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105971:	83 ec 08             	sub    $0x8,%esp
80105974:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105977:	50                   	push   %eax
80105978:	6a 00                	push   $0x0
8010597a:	e8 48 f5 ff ff       	call   80104ec7 <argstr>
8010597f:	83 c4 10             	add    $0x10,%esp
80105982:	85 c0                	test   %eax,%eax
80105984:	78 1b                	js     801059a1 <sys_mkdir+0x3b>
80105986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105989:	6a 00                	push   $0x0
8010598b:	6a 00                	push   $0x0
8010598d:	6a 01                	push   $0x1
8010598f:	50                   	push   %eax
80105990:	e8 62 fc ff ff       	call   801055f7 <create>
80105995:	83 c4 10             	add    $0x10,%esp
80105998:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010599b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010599f:	75 0c                	jne    801059ad <sys_mkdir+0x47>
    end_op();
801059a1:	e8 07 d7 ff ff       	call   801030ad <end_op>
    return -1;
801059a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ab:	eb 18                	jmp    801059c5 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	ff 75 f4             	push   -0xc(%ebp)
801059b3:	e8 48 c2 ff ff       	call   80101c00 <iunlockput>
801059b8:	83 c4 10             	add    $0x10,%esp
  end_op();
801059bb:	e8 ed d6 ff ff       	call   801030ad <end_op>
  return 0;
801059c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    

801059c7 <sys_mknod>:

int
sys_mknod(void)
{
801059c7:	55                   	push   %ebp
801059c8:	89 e5                	mov    %esp,%ebp
801059ca:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059cd:	e8 4f d6 ff ff       	call   80103021 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059d2:	83 ec 08             	sub    $0x8,%esp
801059d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059d8:	50                   	push   %eax
801059d9:	6a 00                	push   $0x0
801059db:	e8 e7 f4 ff ff       	call   80104ec7 <argstr>
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	85 c0                	test   %eax,%eax
801059e5:	78 4f                	js     80105a36 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
801059e7:	83 ec 08             	sub    $0x8,%esp
801059ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059ed:	50                   	push   %eax
801059ee:	6a 01                	push   $0x1
801059f0:	e8 4c f4 ff ff       	call   80104e41 <argint>
801059f5:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801059f8:	85 c0                	test   %eax,%eax
801059fa:	78 3a                	js     80105a36 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
801059fc:	83 ec 08             	sub    $0x8,%esp
801059ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a02:	50                   	push   %eax
80105a03:	6a 02                	push   $0x2
80105a05:	e8 37 f4 ff ff       	call   80104e41 <argint>
80105a0a:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	78 25                	js     80105a36 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a14:	0f bf c8             	movswl %ax,%ecx
80105a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a1a:	0f bf d0             	movswl %ax,%edx
80105a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a20:	51                   	push   %ecx
80105a21:	52                   	push   %edx
80105a22:	6a 03                	push   $0x3
80105a24:	50                   	push   %eax
80105a25:	e8 cd fb ff ff       	call   801055f7 <create>
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a34:	75 0c                	jne    80105a42 <sys_mknod+0x7b>
    end_op();
80105a36:	e8 72 d6 ff ff       	call   801030ad <end_op>
    return -1;
80105a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a40:	eb 18                	jmp    80105a5a <sys_mknod+0x93>
  }
  iunlockput(ip);
80105a42:	83 ec 0c             	sub    $0xc,%esp
80105a45:	ff 75 f4             	push   -0xc(%ebp)
80105a48:	e8 b3 c1 ff ff       	call   80101c00 <iunlockput>
80105a4d:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a50:	e8 58 d6 ff ff       	call   801030ad <end_op>
  return 0;
80105a55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a5a:	c9                   	leave  
80105a5b:	c3                   	ret    

80105a5c <sys_chdir>:

int
sys_chdir(void)
{
80105a5c:	55                   	push   %ebp
80105a5d:	89 e5                	mov    %esp,%ebp
80105a5f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a62:	e8 ae df ff ff       	call   80103a15 <myproc>
80105a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105a6a:	e8 b2 d5 ff ff       	call   80103021 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a6f:	83 ec 08             	sub    $0x8,%esp
80105a72:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a75:	50                   	push   %eax
80105a76:	6a 00                	push   $0x0
80105a78:	e8 4a f4 ff ff       	call   80104ec7 <argstr>
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	85 c0                	test   %eax,%eax
80105a82:	78 18                	js     80105a9c <sys_chdir+0x40>
80105a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a87:	83 ec 0c             	sub    $0xc,%esp
80105a8a:	50                   	push   %eax
80105a8b:	e8 72 ca ff ff       	call   80102502 <namei>
80105a90:	83 c4 10             	add    $0x10,%esp
80105a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a9a:	75 0c                	jne    80105aa8 <sys_chdir+0x4c>
    end_op();
80105a9c:	e8 0c d6 ff ff       	call   801030ad <end_op>
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa6:	eb 68                	jmp    80105b10 <sys_chdir+0xb4>
  }
  ilock(ip);
80105aa8:	83 ec 0c             	sub    $0xc,%esp
80105aab:	ff 75 f0             	push   -0x10(%ebp)
80105aae:	e8 1c bf ff ff       	call   801019cf <ilock>
80105ab3:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab9:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105abd:	66 83 f8 01          	cmp    $0x1,%ax
80105ac1:	74 1a                	je     80105add <sys_chdir+0x81>
    iunlockput(ip);
80105ac3:	83 ec 0c             	sub    $0xc,%esp
80105ac6:	ff 75 f0             	push   -0x10(%ebp)
80105ac9:	e8 32 c1 ff ff       	call   80101c00 <iunlockput>
80105ace:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ad1:	e8 d7 d5 ff ff       	call   801030ad <end_op>
    return -1;
80105ad6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105adb:	eb 33                	jmp    80105b10 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	ff 75 f0             	push   -0x10(%ebp)
80105ae3:	e8 fa bf ff ff       	call   80101ae2 <iunlock>
80105ae8:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aee:	8b 40 68             	mov    0x68(%eax),%eax
80105af1:	83 ec 0c             	sub    $0xc,%esp
80105af4:	50                   	push   %eax
80105af5:	e8 36 c0 ff ff       	call   80101b30 <iput>
80105afa:	83 c4 10             	add    $0x10,%esp
  end_op();
80105afd:	e8 ab d5 ff ff       	call   801030ad <end_op>
  curproc->cwd = ip;
80105b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b08:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b10:	c9                   	leave  
80105b11:	c3                   	ret    

80105b12 <sys_exec>:

int
sys_exec(void)
{
80105b12:	55                   	push   %ebp
80105b13:	89 e5                	mov    %esp,%ebp
80105b15:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b1b:	83 ec 08             	sub    $0x8,%esp
80105b1e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b21:	50                   	push   %eax
80105b22:	6a 00                	push   $0x0
80105b24:	e8 9e f3 ff ff       	call   80104ec7 <argstr>
80105b29:	83 c4 10             	add    $0x10,%esp
80105b2c:	85 c0                	test   %eax,%eax
80105b2e:	78 18                	js     80105b48 <sys_exec+0x36>
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105b39:	50                   	push   %eax
80105b3a:	6a 01                	push   $0x1
80105b3c:	e8 00 f3 ff ff       	call   80104e41 <argint>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	79 0a                	jns    80105b52 <sys_exec+0x40>
    return -1;
80105b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b4d:	e9 c6 00 00 00       	jmp    80105c18 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105b52:	83 ec 04             	sub    $0x4,%esp
80105b55:	68 80 00 00 00       	push   $0x80
80105b5a:	6a 00                	push   $0x0
80105b5c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105b62:	50                   	push   %eax
80105b63:	e8 c9 ef ff ff       	call   80104b31 <memset>
80105b68:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b75:	83 f8 1f             	cmp    $0x1f,%eax
80105b78:	76 0a                	jbe    80105b84 <sys_exec+0x72>
      return -1;
80105b7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7f:	e9 94 00 00 00       	jmp    80105c18 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b87:	c1 e0 02             	shl    $0x2,%eax
80105b8a:	89 c2                	mov    %eax,%edx
80105b8c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105b92:	01 c2                	add    %eax,%edx
80105b94:	83 ec 08             	sub    $0x8,%esp
80105b97:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b9d:	50                   	push   %eax
80105b9e:	52                   	push   %edx
80105b9f:	e8 17 f2 ff ff       	call   80104dbb <fetchint>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	79 07                	jns    80105bb2 <sys_exec+0xa0>
      return -1;
80105bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb0:	eb 66                	jmp    80105c18 <sys_exec+0x106>
    if(uarg == 0){
80105bb2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105bb8:	85 c0                	test   %eax,%eax
80105bba:	75 27                	jne    80105be3 <sys_exec+0xd1>
      argv[i] = 0;
80105bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbf:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105bc6:	00 00 00 00 
      break;
80105bca:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bce:	83 ec 08             	sub    $0x8,%esp
80105bd1:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105bd7:	52                   	push   %edx
80105bd8:	50                   	push   %eax
80105bd9:	e8 a2 af ff ff       	call   80100b80 <exec>
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	eb 35                	jmp    80105c18 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105be3:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bec:	c1 e0 02             	shl    $0x2,%eax
80105bef:	01 c2                	add    %eax,%edx
80105bf1:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105bf7:	83 ec 08             	sub    $0x8,%esp
80105bfa:	52                   	push   %edx
80105bfb:	50                   	push   %eax
80105bfc:	e8 e8 f1 ff ff       	call   80104de9 <fetchstr>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	79 07                	jns    80105c0f <sys_exec+0xfd>
      return -1;
80105c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0d:	eb 09                	jmp    80105c18 <sys_exec+0x106>
  for(i=0;; i++){
80105c0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c13:	e9 5a ff ff ff       	jmp    80105b72 <sys_exec+0x60>
}
80105c18:	c9                   	leave  
80105c19:	c3                   	ret    

80105c1a <sys_pipe>:

int
sys_pipe(void)
{
80105c1a:	55                   	push   %ebp
80105c1b:	89 e5                	mov    %esp,%ebp
80105c1d:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c20:	83 ec 04             	sub    $0x4,%esp
80105c23:	6a 08                	push   $0x8
80105c25:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c28:	50                   	push   %eax
80105c29:	6a 00                	push   $0x0
80105c2b:	e8 3e f2 ff ff       	call   80104e6e <argptr>
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	85 c0                	test   %eax,%eax
80105c35:	79 0a                	jns    80105c41 <sys_pipe+0x27>
    return -1;
80105c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3c:	e9 ae 00 00 00       	jmp    80105cef <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105c41:	83 ec 08             	sub    $0x8,%esp
80105c44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c47:	50                   	push   %eax
80105c48:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c4b:	50                   	push   %eax
80105c4c:	e8 01 d9 ff ff       	call   80103552 <pipealloc>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	79 0a                	jns    80105c62 <sys_pipe+0x48>
    return -1;
80105c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5d:	e9 8d 00 00 00       	jmp    80105cef <sys_pipe+0xd5>
  fd0 = -1;
80105c62:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	50                   	push   %eax
80105c70:	e8 7b f3 ff ff       	call   80104ff0 <fdalloc>
80105c75:	83 c4 10             	add    $0x10,%esp
80105c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c7f:	78 18                	js     80105c99 <sys_pipe+0x7f>
80105c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c84:	83 ec 0c             	sub    $0xc,%esp
80105c87:	50                   	push   %eax
80105c88:	e8 63 f3 ff ff       	call   80104ff0 <fdalloc>
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c97:	79 3e                	jns    80105cd7 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c9d:	78 13                	js     80105cb2 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105c9f:	e8 71 dd ff ff       	call   80103a15 <myproc>
80105ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ca7:	83 c2 08             	add    $0x8,%edx
80105caa:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cb1:	00 
    fileclose(rf);
80105cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cb5:	83 ec 0c             	sub    $0xc,%esp
80105cb8:	50                   	push   %eax
80105cb9:	e8 c2 b3 ff ff       	call   80101080 <fileclose>
80105cbe:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cc4:	83 ec 0c             	sub    $0xc,%esp
80105cc7:	50                   	push   %eax
80105cc8:	e8 b3 b3 ff ff       	call   80101080 <fileclose>
80105ccd:	83 c4 10             	add    $0x10,%esp
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd5:	eb 18                	jmp    80105cef <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cdd:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ce2:	8d 50 04             	lea    0x4(%eax),%edx
80105ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce8:	89 02                	mov    %eax,(%edx)
  return 0;
80105cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cef:	c9                   	leave  
80105cf0:	c3                   	ret    

80105cf1 <sys_fork>:
extern int ppid[];
extern int pspage[];

int
sys_fork(void)
{
80105cf1:	55                   	push   %ebp
80105cf2:	89 e5                	mov    %esp,%ebp
80105cf4:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105cf7:	e8 4a e0 ff ff       	call   80103d46 <fork>
}
80105cfc:	c9                   	leave  
80105cfd:	c3                   	ret    

80105cfe <sys_exit>:

int
sys_exit(void)
{
80105cfe:	55                   	push   %ebp
80105cff:	89 e5                	mov    %esp,%ebp
80105d01:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d04:	e8 1e e2 ff ff       	call   80103f27 <exit>
  return 0;  // not reached
80105d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d0e:	c9                   	leave  
80105d0f:	c3                   	ret    

80105d10 <sys_wait>:

int
sys_wait(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105d16:	e8 2c e3 ff ff       	call   80104047 <wait>
}
80105d1b:	c9                   	leave  
80105d1c:	c3                   	ret    

80105d1d <sys_kill>:

int
sys_kill(void)
{
80105d1d:	55                   	push   %ebp
80105d1e:	89 e5                	mov    %esp,%ebp
80105d20:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d23:	83 ec 08             	sub    $0x8,%esp
80105d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 10 f1 ff ff       	call   80104e41 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	79 07                	jns    80105d3f <sys_kill+0x22>
    return -1;
80105d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3d:	eb 0f                	jmp    80105d4e <sys_kill+0x31>
  return kill(pid);
80105d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d42:	83 ec 0c             	sub    $0xc,%esp
80105d45:	50                   	push   %eax
80105d46:	e8 2b e7 ff ff       	call   80104476 <kill>
80105d4b:	83 c4 10             	add    $0x10,%esp
}
80105d4e:	c9                   	leave  
80105d4f:	c3                   	ret    

80105d50 <sys_getpid>:

int
sys_getpid(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d56:	e8 ba dc ff ff       	call   80103a15 <myproc>
80105d5b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d5e:	c9                   	leave  
80105d5f:	c3                   	ret    

80105d60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
80105d66:	83 ec 08             	sub    $0x8,%esp
80105d69:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d6c:	50                   	push   %eax
80105d6d:	6a 00                	push   $0x0
80105d6f:	e8 cd f0 ff ff       	call   80104e41 <argint>
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	85 c0                	test   %eax,%eax
80105d79:	79 0a                	jns    80105d85 <sys_sbrk+0x25>
    return -1;
80105d7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d80:	e9 ea 00 00 00       	jmp    80105e6f <sys_sbrk+0x10f>

  struct proc *p = myproc();
80105d85:	e8 8b dc ff ff       	call   80103a15 <myproc>
80105d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  addr = p->sz;
80105d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d90:	8b 00                	mov    (%eax),%eax
80105d92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint oldsz = p->sz;
80105d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d98:	8b 00                	mov    (%eax),%eax
80105d9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint newsz = oldsz + n;
80105d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105da0:	89 c2                	mov    %eax,%edx
80105da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105da5:	01 d0                	add    %edx,%eax
80105da7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if (n == 0)
80105daa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dad:	85 c0                	test   %eax,%eax
80105daf:	75 08                	jne    80105db9 <sys_sbrk+0x59>
    return addr;
80105db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105db4:	e9 b6 00 00 00       	jmp    80105e6f <sys_sbrk+0x10f>

  if (n > 0) {
80105db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	7e 6e                	jle    80105e2e <sys_sbrk+0xce>
    int i;
    for(i=0;i< NPROC; i++) {
80105dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105dc7:	eb 18                	jmp    80105de1 <sys_sbrk+0x81>
      if (ppid[i] == p->pid) {
80105dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcc:	8b 14 85 40 61 19 80 	mov    -0x7fe69ec0(,%eax,4),%edx
80105dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd6:	8b 40 10             	mov    0x10(%eax),%eax
80105dd9:	39 c2                	cmp    %eax,%edx
80105ddb:	74 0c                	je     80105de9 <sys_sbrk+0x89>
    for(i=0;i< NPROC; i++) {
80105ddd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105de1:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80105de5:	7e e2                	jle    80105dc9 <sys_sbrk+0x69>
80105de7:	eb 01                	jmp    80105dea <sys_sbrk+0x8a>
        break;
80105de9:	90                   	nop
      }
    }

    if(newsz >= KERNBASE - pspage[i] * PGSIZE) {
80105dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ded:	8b 04 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%eax
80105df4:	c1 e0 0c             	shl    $0xc,%eax
80105df7:	89 c2                	mov    %eax,%edx
80105df9:	b8 00 00 00 80       	mov    $0x80000000,%eax
80105dfe:	29 d0                	sub    %edx,%eax
80105e00:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80105e03:	72 07                	jb     80105e0c <sys_sbrk+0xac>
      return -1;
80105e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0a:	eb 63                	jmp    80105e6f <sys_sbrk+0x10f>
    }
    p->sz += n;
80105e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0f:	8b 10                	mov    (%eax),%edx
80105e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e14:	01 c2                	add    %eax,%edx
80105e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e19:	89 10                	mov    %edx,(%eax)
    switchuvm(p);
80105e1b:	83 ec 0c             	sub    $0xc,%esp
80105e1e:	ff 75 f0             	push   -0x10(%ebp)
80105e21:	e8 c6 19 00 00       	call   801077ec <switchuvm>
80105e26:	83 c4 10             	add    $0x10,%esp
    return addr;
80105e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e2c:	eb 41                	jmp    80105e6f <sys_sbrk+0x10f>
  }
  
  else{ // n < 0
    if ((newsz = deallocuvm(p->pgdir, oldsz, newsz)) == 0) {
80105e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e31:	8b 40 04             	mov    0x4(%eax),%eax
80105e34:	83 ec 04             	sub    $0x4,%esp
80105e37:	ff 75 e4             	push   -0x1c(%ebp)
80105e3a:	ff 75 e8             	push   -0x18(%ebp)
80105e3d:	50                   	push   %eax
80105e3e:	e8 8a 1d 00 00       	call   80107bcd <deallocuvm>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80105e4d:	75 07                	jne    80105e56 <sys_sbrk+0xf6>
      return -1;
80105e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e54:	eb 19                	jmp    80105e6f <sys_sbrk+0x10f>
    }
    p->sz = newsz;
80105e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105e5c:	89 10                	mov    %edx,(%eax)
    switchuvm(p);
80105e5e:	83 ec 0c             	sub    $0xc,%esp
80105e61:	ff 75 f0             	push   -0x10(%ebp)
80105e64:	e8 83 19 00 00       	call   801077ec <switchuvm>
80105e69:	83 c4 10             	add    $0x10,%esp
    return addr;
80105e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  }
  return addr;
}
80105e6f:	c9                   	leave  
80105e70:	c3                   	ret    

80105e71 <sys_sleep>:

int
sys_sleep(void)
{
80105e71:	55                   	push   %ebp
80105e72:	89 e5                	mov    %esp,%ebp
80105e74:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e77:	83 ec 08             	sub    $0x8,%esp
80105e7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e7d:	50                   	push   %eax
80105e7e:	6a 00                	push   $0x0
80105e80:	e8 bc ef ff ff       	call   80104e41 <argint>
80105e85:	83 c4 10             	add    $0x10,%esp
80105e88:	85 c0                	test   %eax,%eax
80105e8a:	79 07                	jns    80105e93 <sys_sleep+0x22>
    return -1;
80105e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e91:	eb 76                	jmp    80105f09 <sys_sleep+0x98>
  acquire(&tickslock);
80105e93:	83 ec 0c             	sub    $0xc,%esp
80105e96:	68 60 6b 19 80       	push   $0x80196b60
80105e9b:	e8 1b ea ff ff       	call   801048bb <acquire>
80105ea0:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ea3:	a1 94 6b 19 80       	mov    0x80196b94,%eax
80105ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105eab:	eb 38                	jmp    80105ee5 <sys_sleep+0x74>
    if(myproc()->killed){
80105ead:	e8 63 db ff ff       	call   80103a15 <myproc>
80105eb2:	8b 40 24             	mov    0x24(%eax),%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	74 17                	je     80105ed0 <sys_sleep+0x5f>
      release(&tickslock);
80105eb9:	83 ec 0c             	sub    $0xc,%esp
80105ebc:	68 60 6b 19 80       	push   $0x80196b60
80105ec1:	e8 63 ea ff ff       	call   80104929 <release>
80105ec6:	83 c4 10             	add    $0x10,%esp
      return -1;
80105ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ece:	eb 39                	jmp    80105f09 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105ed0:	83 ec 08             	sub    $0x8,%esp
80105ed3:	68 60 6b 19 80       	push   $0x80196b60
80105ed8:	68 94 6b 19 80       	push   $0x80196b94
80105edd:	e8 76 e4 ff ff       	call   80104358 <sleep>
80105ee2:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105ee5:	a1 94 6b 19 80       	mov    0x80196b94,%eax
80105eea:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105eed:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ef0:	39 d0                	cmp    %edx,%eax
80105ef2:	72 b9                	jb     80105ead <sys_sleep+0x3c>
  }
  release(&tickslock);
80105ef4:	83 ec 0c             	sub    $0xc,%esp
80105ef7:	68 60 6b 19 80       	push   $0x80196b60
80105efc:	e8 28 ea ff ff       	call   80104929 <release>
80105f01:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f09:	c9                   	leave  
80105f0a:	c3                   	ret    

80105f0b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f0b:	55                   	push   %ebp
80105f0c:	89 e5                	mov    %esp,%ebp
80105f0e:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105f11:	83 ec 0c             	sub    $0xc,%esp
80105f14:	68 60 6b 19 80       	push   $0x80196b60
80105f19:	e8 9d e9 ff ff       	call   801048bb <acquire>
80105f1e:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105f21:	a1 94 6b 19 80       	mov    0x80196b94,%eax
80105f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105f29:	83 ec 0c             	sub    $0xc,%esp
80105f2c:	68 60 6b 19 80       	push   $0x80196b60
80105f31:	e8 f3 e9 ff ff       	call   80104929 <release>
80105f36:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f3c:	c9                   	leave  
80105f3d:	c3                   	ret    

80105f3e <sys_printpt>:

int sys_printpt(void)
{
80105f3e:	55                   	push   %ebp
80105f3f:	89 e5                	mov    %esp,%ebp
80105f41:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if(argint(0, &pid) < 0)
80105f44:	83 ec 08             	sub    $0x8,%esp
80105f47:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 ef ee ff ff       	call   80104e41 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	79 07                	jns    80105f60 <sys_printpt+0x22>
    return -1;
80105f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5e:	eb 0f                	jmp    80105f6f <sys_printpt+0x31>
  return printpt(pid);
80105f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f63:	83 ec 0c             	sub    $0xc,%esp
80105f66:	50                   	push   %eax
80105f67:	e8 88 e6 ff ff       	call   801045f4 <printpt>
80105f6c:	83 c4 10             	add    $0x10,%esp
80105f6f:	c9                   	leave  
80105f70:	c3                   	ret    

80105f71 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f71:	1e                   	push   %ds
  pushl %es
80105f72:	06                   	push   %es
  pushl %fs
80105f73:	0f a0                	push   %fs
  pushl %gs
80105f75:	0f a8                	push   %gs
  pushal
80105f77:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f78:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f7c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f7e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f80:	54                   	push   %esp
  call trap
80105f81:	e8 d7 01 00 00       	call   8010615d <trap>
  addl $4, %esp
80105f86:	83 c4 04             	add    $0x4,%esp

80105f89 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f89:	61                   	popa   
  popl %gs
80105f8a:	0f a9                	pop    %gs
  popl %fs
80105f8c:	0f a1                	pop    %fs
  popl %es
80105f8e:	07                   	pop    %es
  popl %ds
80105f8f:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f90:	83 c4 08             	add    $0x8,%esp
  iret
80105f93:	cf                   	iret   

80105f94 <lidt>:
{
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f9d:	83 e8 01             	sub    $0x1,%eax
80105fa0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fab:	8b 45 08             	mov    0x8(%ebp),%eax
80105fae:	c1 e8 10             	shr    $0x10,%eax
80105fb1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fb5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fb8:	0f 01 18             	lidtl  (%eax)
}
80105fbb:	90                   	nop
80105fbc:	c9                   	leave  
80105fbd:	c3                   	ret    

80105fbe <rcr2>:

static inline uint
rcr2(void)
{
80105fbe:	55                   	push   %ebp
80105fbf:	89 e5                	mov    %esp,%ebp
80105fc1:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fc4:	0f 20 d0             	mov    %cr2,%eax
80105fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80105fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105fcd:	c9                   	leave  
80105fce:	c3                   	ret    

80105fcf <tvinit>:
extern int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
extern pte_t* walkpgdir(pde_t *pgdir, const void *va, int alloc);

void
tvinit(void)
{
80105fcf:	55                   	push   %ebp
80105fd0:	89 e5                	mov    %esp,%ebp
80105fd2:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80105fd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105fdc:	e9 c3 00 00 00       	jmp    801060a4 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe4:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80105feb:	89 c2                	mov    %eax,%edx
80105fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff0:	66 89 14 c5 60 63 19 	mov    %dx,-0x7fe69ca0(,%eax,8)
80105ff7:	80 
80105ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffb:	66 c7 04 c5 62 63 19 	movw   $0x8,-0x7fe69c9e(,%eax,8)
80106002:	80 08 00 
80106005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106008:	0f b6 14 c5 64 63 19 	movzbl -0x7fe69c9c(,%eax,8),%edx
8010600f:	80 
80106010:	83 e2 e0             	and    $0xffffffe0,%edx
80106013:	88 14 c5 64 63 19 80 	mov    %dl,-0x7fe69c9c(,%eax,8)
8010601a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601d:	0f b6 14 c5 64 63 19 	movzbl -0x7fe69c9c(,%eax,8),%edx
80106024:	80 
80106025:	83 e2 1f             	and    $0x1f,%edx
80106028:	88 14 c5 64 63 19 80 	mov    %dl,-0x7fe69c9c(,%eax,8)
8010602f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106032:	0f b6 14 c5 65 63 19 	movzbl -0x7fe69c9b(,%eax,8),%edx
80106039:	80 
8010603a:	83 e2 f0             	and    $0xfffffff0,%edx
8010603d:	83 ca 0e             	or     $0xe,%edx
80106040:	88 14 c5 65 63 19 80 	mov    %dl,-0x7fe69c9b(,%eax,8)
80106047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604a:	0f b6 14 c5 65 63 19 	movzbl -0x7fe69c9b(,%eax,8),%edx
80106051:	80 
80106052:	83 e2 ef             	and    $0xffffffef,%edx
80106055:	88 14 c5 65 63 19 80 	mov    %dl,-0x7fe69c9b(,%eax,8)
8010605c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605f:	0f b6 14 c5 65 63 19 	movzbl -0x7fe69c9b(,%eax,8),%edx
80106066:	80 
80106067:	83 e2 9f             	and    $0xffffff9f,%edx
8010606a:	88 14 c5 65 63 19 80 	mov    %dl,-0x7fe69c9b(,%eax,8)
80106071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106074:	0f b6 14 c5 65 63 19 	movzbl -0x7fe69c9b(,%eax,8),%edx
8010607b:	80 
8010607c:	83 ca 80             	or     $0xffffff80,%edx
8010607f:	88 14 c5 65 63 19 80 	mov    %dl,-0x7fe69c9b(,%eax,8)
80106086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106089:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80106090:	c1 e8 10             	shr    $0x10,%eax
80106093:	89 c2                	mov    %eax,%edx
80106095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106098:	66 89 14 c5 66 63 19 	mov    %dx,-0x7fe69c9a(,%eax,8)
8010609f:	80 
  for(i = 0; i < 256; i++)
801060a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801060a4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801060ab:	0f 8e 30 ff ff ff    	jle    80105fe1 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060b1:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
801060b6:	66 a3 60 65 19 80    	mov    %ax,0x80196560
801060bc:	66 c7 05 62 65 19 80 	movw   $0x8,0x80196562
801060c3:	08 00 
801060c5:	0f b6 05 64 65 19 80 	movzbl 0x80196564,%eax
801060cc:	83 e0 e0             	and    $0xffffffe0,%eax
801060cf:	a2 64 65 19 80       	mov    %al,0x80196564
801060d4:	0f b6 05 64 65 19 80 	movzbl 0x80196564,%eax
801060db:	83 e0 1f             	and    $0x1f,%eax
801060de:	a2 64 65 19 80       	mov    %al,0x80196564
801060e3:	0f b6 05 65 65 19 80 	movzbl 0x80196565,%eax
801060ea:	83 c8 0f             	or     $0xf,%eax
801060ed:	a2 65 65 19 80       	mov    %al,0x80196565
801060f2:	0f b6 05 65 65 19 80 	movzbl 0x80196565,%eax
801060f9:	83 e0 ef             	and    $0xffffffef,%eax
801060fc:	a2 65 65 19 80       	mov    %al,0x80196565
80106101:	0f b6 05 65 65 19 80 	movzbl 0x80196565,%eax
80106108:	83 c8 60             	or     $0x60,%eax
8010610b:	a2 65 65 19 80       	mov    %al,0x80196565
80106110:	0f b6 05 65 65 19 80 	movzbl 0x80196565,%eax
80106117:	83 c8 80             	or     $0xffffff80,%eax
8010611a:	a2 65 65 19 80       	mov    %al,0x80196565
8010611f:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
80106124:	c1 e8 10             	shr    $0x10,%eax
80106127:	66 a3 66 65 19 80    	mov    %ax,0x80196566

  initlock(&tickslock, "time");
8010612d:	83 ec 08             	sub    $0x8,%esp
80106130:	68 54 a9 10 80       	push   $0x8010a954
80106135:	68 60 6b 19 80       	push   $0x80196b60
8010613a:	e8 5a e7 ff ff       	call   80104899 <initlock>
8010613f:	83 c4 10             	add    $0x10,%esp
}
80106142:	90                   	nop
80106143:	c9                   	leave  
80106144:	c3                   	ret    

80106145 <idtinit>:

void
idtinit(void)
{
80106145:	55                   	push   %ebp
80106146:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106148:	68 00 08 00 00       	push   $0x800
8010614d:	68 60 63 19 80       	push   $0x80196360
80106152:	e8 3d fe ff ff       	call   80105f94 <lidt>
80106157:	83 c4 08             	add    $0x8,%esp
}
8010615a:	90                   	nop
8010615b:	c9                   	leave  
8010615c:	c3                   	ret    

8010615d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010615d:	55                   	push   %ebp
8010615e:	89 e5                	mov    %esp,%ebp
80106160:	57                   	push   %edi
80106161:	56                   	push   %esi
80106162:	53                   	push   %ebx
80106163:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106166:	8b 45 08             	mov    0x8(%ebp),%eax
80106169:	8b 40 30             	mov    0x30(%eax),%eax
8010616c:	83 f8 40             	cmp    $0x40,%eax
8010616f:	75 3b                	jne    801061ac <trap+0x4f>
    if(myproc()->killed)
80106171:	e8 9f d8 ff ff       	call   80103a15 <myproc>
80106176:	8b 40 24             	mov    0x24(%eax),%eax
80106179:	85 c0                	test   %eax,%eax
8010617b:	74 05                	je     80106182 <trap+0x25>
      exit();
8010617d:	e8 a5 dd ff ff       	call   80103f27 <exit>
    myproc()->tf = tf;
80106182:	e8 8e d8 ff ff       	call   80103a15 <myproc>
80106187:	8b 55 08             	mov    0x8(%ebp),%edx
8010618a:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010618d:	e8 6c ed ff ff       	call   80104efe <syscall>
    if(myproc()->killed)
80106192:	e8 7e d8 ff ff       	call   80103a15 <myproc>
80106197:	8b 40 24             	mov    0x24(%eax),%eax
8010619a:	85 c0                	test   %eax,%eax
8010619c:	0f 84 03 04 00 00    	je     801065a5 <trap+0x448>
      exit();
801061a2:	e8 80 dd ff ff       	call   80103f27 <exit>
    return;
801061a7:	e9 f9 03 00 00       	jmp    801065a5 <trap+0x448>
  }

  switch(tf->trapno){
801061ac:	8b 45 08             	mov    0x8(%ebp),%eax
801061af:	8b 40 30             	mov    0x30(%eax),%eax
801061b2:	83 e8 0e             	sub    $0xe,%eax
801061b5:	83 f8 31             	cmp    $0x31,%eax
801061b8:	0f 87 af 02 00 00    	ja     8010646d <trap+0x310>
801061be:	8b 04 85 fc a9 10 80 	mov    -0x7fef5604(,%eax,4),%eax
801061c5:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801061c7:	e8 b6 d7 ff ff       	call   80103982 <cpuid>
801061cc:	85 c0                	test   %eax,%eax
801061ce:	75 3d                	jne    8010620d <trap+0xb0>
      acquire(&tickslock);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	68 60 6b 19 80       	push   $0x80196b60
801061d8:	e8 de e6 ff ff       	call   801048bb <acquire>
801061dd:	83 c4 10             	add    $0x10,%esp
      ticks++;
801061e0:	a1 94 6b 19 80       	mov    0x80196b94,%eax
801061e5:	83 c0 01             	add    $0x1,%eax
801061e8:	a3 94 6b 19 80       	mov    %eax,0x80196b94
      wakeup(&ticks);
801061ed:	83 ec 0c             	sub    $0xc,%esp
801061f0:	68 94 6b 19 80       	push   $0x80196b94
801061f5:	e8 45 e2 ff ff       	call   8010443f <wakeup>
801061fa:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 60 6b 19 80       	push   $0x80196b60
80106205:	e8 1f e7 ff ff       	call   80104929 <release>
8010620a:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010620d:	e8 ef c8 ff ff       	call   80102b01 <lapiceoi>
    break;
80106212:	e9 0e 03 00 00       	jmp    80106525 <trap+0x3c8>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106217:	e8 ae 41 00 00       	call   8010a3ca <ideintr>
    lapiceoi();
8010621c:	e8 e0 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
80106221:	e9 ff 02 00 00       	jmp    80106525 <trap+0x3c8>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106226:	e8 1b c7 ff ff       	call   80102946 <kbdintr>
    lapiceoi();
8010622b:	e8 d1 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
80106230:	e9 f0 02 00 00       	jmp    80106525 <trap+0x3c8>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106235:	e8 41 05 00 00       	call   8010677b <uartintr>
    lapiceoi();
8010623a:	e8 c2 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
8010623f:	e9 e1 02 00 00       	jmp    80106525 <trap+0x3c8>
  case T_IRQ0 + 0xB:
    i8254_intr();
80106244:	e8 34 2e 00 00       	call   8010907d <i8254_intr>
    lapiceoi();
80106249:	e8 b3 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
8010624e:	e9 d2 02 00 00       	jmp    80106525 <trap+0x3c8>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106253:	8b 45 08             	mov    0x8(%ebp),%eax
80106256:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106259:	8b 45 08             	mov    0x8(%ebp),%eax
8010625c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106260:	0f b7 d8             	movzwl %ax,%ebx
80106263:	e8 1a d7 ff ff       	call   80103982 <cpuid>
80106268:	56                   	push   %esi
80106269:	53                   	push   %ebx
8010626a:	50                   	push   %eax
8010626b:	68 5c a9 10 80       	push   $0x8010a95c
80106270:	e8 7f a1 ff ff       	call   801003f4 <cprintf>
80106275:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106278:	e8 84 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
8010627d:	e9 a3 02 00 00       	jmp    80106525 <trap+0x3c8>
  case T_PGFLT: {
  uint va = PGROUNDDOWN(rcr2());
80106282:	e8 37 fd ff ff       	call   80105fbe <rcr2>
80106287:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010628c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  struct proc *p = myproc();
8010628f:	e8 81 d7 ff ff       	call   80103a15 <myproc>
80106294:	89 45 dc             	mov    %eax,-0x24(%ebp)

  pte_t *pte = walkpgdir(p->pgdir, (void *)va, 0);
80106297:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010629a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010629d:	8b 40 04             	mov    0x4(%eax),%eax
801062a0:	83 ec 04             	sub    $0x4,%esp
801062a3:	6a 00                	push   $0x0
801062a5:	52                   	push   %edx
801062a6:	50                   	push   %eax
801062a7:	e8 fd 12 00 00       	call   801075a9 <walkpgdir>
801062ac:	83 c4 10             	add    $0x10,%esp
801062af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (pte && (*pte & PTE_P)) {
801062b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801062b6:	74 10                	je     801062c8 <trap+0x16b>
801062b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801062bb:	8b 00                	mov    (%eax),%eax
801062bd:	83 e0 01             	and    $0x1,%eax
801062c0:	85 c0                	test   %eax,%eax
801062c2:	0f 85 5c 02 00 00    	jne    80106524 <trap+0x3c7>
    break;
  }

  if (va < p->sz) {
801062c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062cb:	8b 00                	mov    (%eax),%eax
801062cd:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801062d0:	0f 83 8d 00 00 00    	jae    80106363 <trap+0x206>
  // 코드 섹션 메모리 할당
    char *mem = kalloc();
801062d6:	e8 aa c4 ff ff       	call   80102785 <kalloc>
801062db:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if (!mem) {
801062de:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
801062e2:	75 0f                	jne    801062f3 <trap+0x196>
      p->killed = 1;
801062e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801062ee:	e9 32 02 00 00       	jmp    80106525 <trap+0x3c8>
    }
    memset(mem, 0, PGSIZE);
801062f3:	83 ec 04             	sub    $0x4,%esp
801062f6:	68 00 10 00 00       	push   $0x1000
801062fb:	6a 00                	push   $0x0
801062fd:	ff 75 d0             	push   -0x30(%ebp)
80106300:	e8 2c e8 ff ff       	call   80104b31 <memset>
80106305:	83 c4 10             	add    $0x10,%esp
    if (mappages(p->pgdir, (char*)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106308:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010630b:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80106311:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106314:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106317:	8b 40 04             	mov    0x4(%eax),%eax
8010631a:	83 ec 0c             	sub    $0xc,%esp
8010631d:	6a 06                	push   $0x6
8010631f:	51                   	push   %ecx
80106320:	68 00 10 00 00       	push   $0x1000
80106325:	52                   	push   %edx
80106326:	50                   	push   %eax
80106327:	e8 13 13 00 00       	call   8010763f <mappages>
8010632c:	83 c4 20             	add    $0x20,%esp
8010632f:	85 c0                	test   %eax,%eax
80106331:	79 1d                	jns    80106350 <trap+0x1f3>
      kfree(mem);
80106333:	83 ec 0c             	sub    $0xc,%esp
80106336:	ff 75 d0             	push   -0x30(%ebp)
80106339:	e8 ad c3 ff ff       	call   801026eb <kfree>
8010633e:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
80106341:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106344:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
8010634b:	e9 d5 01 00 00       	jmp    80106525 <trap+0x3c8>
    }
    switchuvm(p);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	ff 75 dc             	push   -0x24(%ebp)
80106356:	e8 91 14 00 00       	call   801077ec <switchuvm>
8010635b:	83 c4 10             	add    $0x10,%esp
    break;
8010635e:	e9 c2 01 00 00       	jmp    80106525 <trap+0x3c8>
  }

  // 스택 확장
  int i;
  for (i = 0; i < NPROC; i++) {
80106363:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010636a:	eb 18                	jmp    80106384 <trap+0x227>
    if (ppid[i] == p->pid)
8010636c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010636f:	8b 14 85 40 61 19 80 	mov    -0x7fe69ec0(,%eax,4),%edx
80106376:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106379:	8b 40 10             	mov    0x10(%eax),%eax
8010637c:	39 c2                	cmp    %eax,%edx
8010637e:	74 0c                	je     8010638c <trap+0x22f>
  for (i = 0; i < NPROC; i++) {
80106380:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80106384:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
80106388:	7e e2                	jle    8010636c <trap+0x20f>
8010638a:	eb 01                	jmp    8010638d <trap+0x230>
      break;
8010638c:	90                   	nop
  }

  if (va >= KERNBASE - (pspage[i] + 1) * PGSIZE && va < KERNBASE) {
8010638d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106390:	8b 04 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%eax
80106397:	83 c0 01             	add    $0x1,%eax
8010639a:	c1 e0 0c             	shl    $0xc,%eax
8010639d:	89 c2                	mov    %eax,%edx
8010639f:	b8 00 00 00 80       	mov    $0x80000000,%eax
801063a4:	29 d0                	sub    %edx,%eax
801063a6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801063a9:	0f 82 af 00 00 00    	jb     8010645e <trap+0x301>
801063af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801063b2:	85 c0                	test   %eax,%eax
801063b4:	0f 88 a4 00 00 00    	js     8010645e <trap+0x301>
    char *mem = kalloc();
801063ba:	e8 c6 c3 ff ff       	call   80102785 <kalloc>
801063bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (!mem) {
801063c2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801063c6:	75 0f                	jne    801063d7 <trap+0x27a>
      p->killed = 1;
801063c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063cb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801063d2:	e9 4e 01 00 00       	jmp    80106525 <trap+0x3c8>
    }
    memset(mem, 0, PGSIZE);
801063d7:	83 ec 04             	sub    $0x4,%esp
801063da:	68 00 10 00 00       	push   $0x1000
801063df:	6a 00                	push   $0x0
801063e1:	ff 75 d4             	push   -0x2c(%ebp)
801063e4:	e8 48 e7 ff ff       	call   80104b31 <memset>
801063e9:	83 c4 10             	add    $0x10,%esp
    if (mappages(p->pgdir, (char*)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801063ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801063ef:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801063f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801063f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063fb:	8b 40 04             	mov    0x4(%eax),%eax
801063fe:	83 ec 0c             	sub    $0xc,%esp
80106401:	6a 06                	push   $0x6
80106403:	51                   	push   %ecx
80106404:	68 00 10 00 00       	push   $0x1000
80106409:	52                   	push   %edx
8010640a:	50                   	push   %eax
8010640b:	e8 2f 12 00 00       	call   8010763f <mappages>
80106410:	83 c4 20             	add    $0x20,%esp
80106413:	85 c0                	test   %eax,%eax
80106415:	79 1d                	jns    80106434 <trap+0x2d7>
      kfree(mem);
80106417:	83 ec 0c             	sub    $0xc,%esp
8010641a:	ff 75 d4             	push   -0x2c(%ebp)
8010641d:	e8 c9 c2 ff ff       	call   801026eb <kfree>
80106422:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
80106425:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106428:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
8010642f:	e9 f1 00 00 00       	jmp    80106525 <trap+0x3c8>
    }
    pspage[i]++;
80106434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106437:	8b 04 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%eax
8010643e:	8d 50 01             	lea    0x1(%eax),%edx
80106441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106444:	89 14 85 40 62 19 80 	mov    %edx,-0x7fe69dc0(,%eax,4)
    switchuvm(p);
8010644b:	83 ec 0c             	sub    $0xc,%esp
8010644e:	ff 75 dc             	push   -0x24(%ebp)
80106451:	e8 96 13 00 00       	call   801077ec <switchuvm>
80106456:	83 c4 10             	add    $0x10,%esp
    break;
80106459:	e9 c7 00 00 00       	jmp    80106525 <trap+0x3c8>
  }

  p->killed = 1;
8010645e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106461:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  break;
80106468:	e9 b8 00 00 00       	jmp    80106525 <trap+0x3c8>
}
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010646d:	e8 a3 d5 ff ff       	call   80103a15 <myproc>
80106472:	85 c0                	test   %eax,%eax
80106474:	74 11                	je     80106487 <trap+0x32a>
80106476:	8b 45 08             	mov    0x8(%ebp),%eax
80106479:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010647d:	0f b7 c0             	movzwl %ax,%eax
80106480:	83 e0 03             	and    $0x3,%eax
80106483:	85 c0                	test   %eax,%eax
80106485:	75 39                	jne    801064c0 <trap+0x363>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106487:	e8 32 fb ff ff       	call   80105fbe <rcr2>
8010648c:	89 c3                	mov    %eax,%ebx
8010648e:	8b 45 08             	mov    0x8(%ebp),%eax
80106491:	8b 70 38             	mov    0x38(%eax),%esi
80106494:	e8 e9 d4 ff ff       	call   80103982 <cpuid>
80106499:	8b 55 08             	mov    0x8(%ebp),%edx
8010649c:	8b 52 30             	mov    0x30(%edx),%edx
8010649f:	83 ec 0c             	sub    $0xc,%esp
801064a2:	53                   	push   %ebx
801064a3:	56                   	push   %esi
801064a4:	50                   	push   %eax
801064a5:	52                   	push   %edx
801064a6:	68 80 a9 10 80       	push   $0x8010a980
801064ab:	e8 44 9f ff ff       	call   801003f4 <cprintf>
801064b0:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801064b3:	83 ec 0c             	sub    $0xc,%esp
801064b6:	68 b2 a9 10 80       	push   $0x8010a9b2
801064bb:	e8 e9 a0 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064c0:	e8 f9 fa ff ff       	call   80105fbe <rcr2>
801064c5:	89 c6                	mov    %eax,%esi
801064c7:	8b 45 08             	mov    0x8(%ebp),%eax
801064ca:	8b 40 38             	mov    0x38(%eax),%eax
801064cd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801064d0:	e8 ad d4 ff ff       	call   80103982 <cpuid>
801064d5:	89 c3                	mov    %eax,%ebx
801064d7:	8b 45 08             	mov    0x8(%ebp),%eax
801064da:	8b 78 34             	mov    0x34(%eax),%edi
801064dd:	89 7d c0             	mov    %edi,-0x40(%ebp)
801064e0:	8b 45 08             	mov    0x8(%ebp),%eax
801064e3:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801064e6:	e8 2a d5 ff ff       	call   80103a15 <myproc>
801064eb:	8d 48 6c             	lea    0x6c(%eax),%ecx
801064ee:	89 4d bc             	mov    %ecx,-0x44(%ebp)
801064f1:	e8 1f d5 ff ff       	call   80103a15 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064f6:	8b 40 10             	mov    0x10(%eax),%eax
801064f9:	56                   	push   %esi
801064fa:	ff 75 c4             	push   -0x3c(%ebp)
801064fd:	53                   	push   %ebx
801064fe:	ff 75 c0             	push   -0x40(%ebp)
80106501:	57                   	push   %edi
80106502:	ff 75 bc             	push   -0x44(%ebp)
80106505:	50                   	push   %eax
80106506:	68 b8 a9 10 80       	push   $0x8010a9b8
8010650b:	e8 e4 9e ff ff       	call   801003f4 <cprintf>
80106510:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106513:	e8 fd d4 ff ff       	call   80103a15 <myproc>
80106518:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010651f:	eb 04                	jmp    80106525 <trap+0x3c8>
    break;
80106521:	90                   	nop
80106522:	eb 01                	jmp    80106525 <trap+0x3c8>
    break;
80106524:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106525:	e8 eb d4 ff ff       	call   80103a15 <myproc>
8010652a:	85 c0                	test   %eax,%eax
8010652c:	74 23                	je     80106551 <trap+0x3f4>
8010652e:	e8 e2 d4 ff ff       	call   80103a15 <myproc>
80106533:	8b 40 24             	mov    0x24(%eax),%eax
80106536:	85 c0                	test   %eax,%eax
80106538:	74 17                	je     80106551 <trap+0x3f4>
8010653a:	8b 45 08             	mov    0x8(%ebp),%eax
8010653d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106541:	0f b7 c0             	movzwl %ax,%eax
80106544:	83 e0 03             	and    $0x3,%eax
80106547:	83 f8 03             	cmp    $0x3,%eax
8010654a:	75 05                	jne    80106551 <trap+0x3f4>
    exit();
8010654c:	e8 d6 d9 ff ff       	call   80103f27 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106551:	e8 bf d4 ff ff       	call   80103a15 <myproc>
80106556:	85 c0                	test   %eax,%eax
80106558:	74 1d                	je     80106577 <trap+0x41a>
8010655a:	e8 b6 d4 ff ff       	call   80103a15 <myproc>
8010655f:	8b 40 0c             	mov    0xc(%eax),%eax
80106562:	83 f8 04             	cmp    $0x4,%eax
80106565:	75 10                	jne    80106577 <trap+0x41a>
     tf->trapno == T_IRQ0+IRQ_TIMER){
80106567:	8b 45 08             	mov    0x8(%ebp),%eax
8010656a:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
8010656d:	83 f8 20             	cmp    $0x20,%eax
80106570:	75 05                	jne    80106577 <trap+0x41a>
    yield();
80106572:	e8 61 dd ff ff       	call   801042d8 <yield>
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106577:	e8 99 d4 ff ff       	call   80103a15 <myproc>
8010657c:	85 c0                	test   %eax,%eax
8010657e:	74 26                	je     801065a6 <trap+0x449>
80106580:	e8 90 d4 ff ff       	call   80103a15 <myproc>
80106585:	8b 40 24             	mov    0x24(%eax),%eax
80106588:	85 c0                	test   %eax,%eax
8010658a:	74 1a                	je     801065a6 <trap+0x449>
8010658c:	8b 45 08             	mov    0x8(%ebp),%eax
8010658f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106593:	0f b7 c0             	movzwl %ax,%eax
80106596:	83 e0 03             	and    $0x3,%eax
80106599:	83 f8 03             	cmp    $0x3,%eax
8010659c:	75 08                	jne    801065a6 <trap+0x449>
    exit();
8010659e:	e8 84 d9 ff ff       	call   80103f27 <exit>
801065a3:	eb 01                	jmp    801065a6 <trap+0x449>
    return;
801065a5:	90                   	nop
}
801065a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a9:	5b                   	pop    %ebx
801065aa:	5e                   	pop    %esi
801065ab:	5f                   	pop    %edi
801065ac:	5d                   	pop    %ebp
801065ad:	c3                   	ret    

801065ae <inb>:
{
801065ae:	55                   	push   %ebp
801065af:	89 e5                	mov    %esp,%ebp
801065b1:	83 ec 14             	sub    $0x14,%esp
801065b4:	8b 45 08             	mov    0x8(%ebp),%eax
801065b7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801065bf:	89 c2                	mov    %eax,%edx
801065c1:	ec                   	in     (%dx),%al
801065c2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801065c5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801065c9:	c9                   	leave  
801065ca:	c3                   	ret    

801065cb <outb>:
{
801065cb:	55                   	push   %ebp
801065cc:	89 e5                	mov    %esp,%ebp
801065ce:	83 ec 08             	sub    $0x8,%esp
801065d1:	8b 45 08             	mov    0x8(%ebp),%eax
801065d4:	8b 55 0c             	mov    0xc(%ebp),%edx
801065d7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801065db:	89 d0                	mov    %edx,%eax
801065dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801065e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801065e8:	ee                   	out    %al,(%dx)
}
801065e9:	90                   	nop
801065ea:	c9                   	leave  
801065eb:	c3                   	ret    

801065ec <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801065ec:	55                   	push   %ebp
801065ed:	89 e5                	mov    %esp,%ebp
801065ef:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801065f2:	6a 00                	push   $0x0
801065f4:	68 fa 03 00 00       	push   $0x3fa
801065f9:	e8 cd ff ff ff       	call   801065cb <outb>
801065fe:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106601:	68 80 00 00 00       	push   $0x80
80106606:	68 fb 03 00 00       	push   $0x3fb
8010660b:	e8 bb ff ff ff       	call   801065cb <outb>
80106610:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106613:	6a 0c                	push   $0xc
80106615:	68 f8 03 00 00       	push   $0x3f8
8010661a:	e8 ac ff ff ff       	call   801065cb <outb>
8010661f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106622:	6a 00                	push   $0x0
80106624:	68 f9 03 00 00       	push   $0x3f9
80106629:	e8 9d ff ff ff       	call   801065cb <outb>
8010662e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106631:	6a 03                	push   $0x3
80106633:	68 fb 03 00 00       	push   $0x3fb
80106638:	e8 8e ff ff ff       	call   801065cb <outb>
8010663d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106640:	6a 00                	push   $0x0
80106642:	68 fc 03 00 00       	push   $0x3fc
80106647:	e8 7f ff ff ff       	call   801065cb <outb>
8010664c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010664f:	6a 01                	push   $0x1
80106651:	68 f9 03 00 00       	push   $0x3f9
80106656:	e8 70 ff ff ff       	call   801065cb <outb>
8010665b:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010665e:	68 fd 03 00 00       	push   $0x3fd
80106663:	e8 46 ff ff ff       	call   801065ae <inb>
80106668:	83 c4 04             	add    $0x4,%esp
8010666b:	3c ff                	cmp    $0xff,%al
8010666d:	74 61                	je     801066d0 <uartinit+0xe4>
    return;
  uart = 1;
8010666f:	c7 05 98 6b 19 80 01 	movl   $0x1,0x80196b98
80106676:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106679:	68 fa 03 00 00       	push   $0x3fa
8010667e:	e8 2b ff ff ff       	call   801065ae <inb>
80106683:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106686:	68 f8 03 00 00       	push   $0x3f8
8010668b:	e8 1e ff ff ff       	call   801065ae <inb>
80106690:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106693:	83 ec 08             	sub    $0x8,%esp
80106696:	6a 00                	push   $0x0
80106698:	6a 04                	push   $0x4
8010669a:	e8 74 bf ff ff       	call   80102613 <ioapicenable>
8010669f:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801066a2:	c7 45 f4 c4 aa 10 80 	movl   $0x8010aac4,-0xc(%ebp)
801066a9:	eb 19                	jmp    801066c4 <uartinit+0xd8>
    uartputc(*p);
801066ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ae:	0f b6 00             	movzbl (%eax),%eax
801066b1:	0f be c0             	movsbl %al,%eax
801066b4:	83 ec 0c             	sub    $0xc,%esp
801066b7:	50                   	push   %eax
801066b8:	e8 16 00 00 00       	call   801066d3 <uartputc>
801066bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c7:	0f b6 00             	movzbl (%eax),%eax
801066ca:	84 c0                	test   %al,%al
801066cc:	75 dd                	jne    801066ab <uartinit+0xbf>
801066ce:	eb 01                	jmp    801066d1 <uartinit+0xe5>
    return;
801066d0:	90                   	nop
}
801066d1:	c9                   	leave  
801066d2:	c3                   	ret    

801066d3 <uartputc>:

void
uartputc(int c)
{
801066d3:	55                   	push   %ebp
801066d4:	89 e5                	mov    %esp,%ebp
801066d6:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801066d9:	a1 98 6b 19 80       	mov    0x80196b98,%eax
801066de:	85 c0                	test   %eax,%eax
801066e0:	74 53                	je     80106735 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066e9:	eb 11                	jmp    801066fc <uartputc+0x29>
    microdelay(10);
801066eb:	83 ec 0c             	sub    $0xc,%esp
801066ee:	6a 0a                	push   $0xa
801066f0:	e8 27 c4 ff ff       	call   80102b1c <microdelay>
801066f5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066fc:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106700:	7f 1a                	jg     8010671c <uartputc+0x49>
80106702:	83 ec 0c             	sub    $0xc,%esp
80106705:	68 fd 03 00 00       	push   $0x3fd
8010670a:	e8 9f fe ff ff       	call   801065ae <inb>
8010670f:	83 c4 10             	add    $0x10,%esp
80106712:	0f b6 c0             	movzbl %al,%eax
80106715:	83 e0 20             	and    $0x20,%eax
80106718:	85 c0                	test   %eax,%eax
8010671a:	74 cf                	je     801066eb <uartputc+0x18>
  outb(COM1+0, c);
8010671c:	8b 45 08             	mov    0x8(%ebp),%eax
8010671f:	0f b6 c0             	movzbl %al,%eax
80106722:	83 ec 08             	sub    $0x8,%esp
80106725:	50                   	push   %eax
80106726:	68 f8 03 00 00       	push   $0x3f8
8010672b:	e8 9b fe ff ff       	call   801065cb <outb>
80106730:	83 c4 10             	add    $0x10,%esp
80106733:	eb 01                	jmp    80106736 <uartputc+0x63>
    return;
80106735:	90                   	nop
}
80106736:	c9                   	leave  
80106737:	c3                   	ret    

80106738 <uartgetc>:

static int
uartgetc(void)
{
80106738:	55                   	push   %ebp
80106739:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010673b:	a1 98 6b 19 80       	mov    0x80196b98,%eax
80106740:	85 c0                	test   %eax,%eax
80106742:	75 07                	jne    8010674b <uartgetc+0x13>
    return -1;
80106744:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106749:	eb 2e                	jmp    80106779 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010674b:	68 fd 03 00 00       	push   $0x3fd
80106750:	e8 59 fe ff ff       	call   801065ae <inb>
80106755:	83 c4 04             	add    $0x4,%esp
80106758:	0f b6 c0             	movzbl %al,%eax
8010675b:	83 e0 01             	and    $0x1,%eax
8010675e:	85 c0                	test   %eax,%eax
80106760:	75 07                	jne    80106769 <uartgetc+0x31>
    return -1;
80106762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106767:	eb 10                	jmp    80106779 <uartgetc+0x41>
  return inb(COM1+0);
80106769:	68 f8 03 00 00       	push   $0x3f8
8010676e:	e8 3b fe ff ff       	call   801065ae <inb>
80106773:	83 c4 04             	add    $0x4,%esp
80106776:	0f b6 c0             	movzbl %al,%eax
}
80106779:	c9                   	leave  
8010677a:	c3                   	ret    

8010677b <uartintr>:

void
uartintr(void)
{
8010677b:	55                   	push   %ebp
8010677c:	89 e5                	mov    %esp,%ebp
8010677e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106781:	83 ec 0c             	sub    $0xc,%esp
80106784:	68 38 67 10 80       	push   $0x80106738
80106789:	e8 48 a0 ff ff       	call   801007d6 <consoleintr>
8010678e:	83 c4 10             	add    $0x10,%esp
}
80106791:	90                   	nop
80106792:	c9                   	leave  
80106793:	c3                   	ret    

80106794 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $0
80106796:	6a 00                	push   $0x0
  jmp alltraps
80106798:	e9 d4 f7 ff ff       	jmp    80105f71 <alltraps>

8010679d <vector1>:
.globl vector1
vector1:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $1
8010679f:	6a 01                	push   $0x1
  jmp alltraps
801067a1:	e9 cb f7 ff ff       	jmp    80105f71 <alltraps>

801067a6 <vector2>:
.globl vector2
vector2:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $2
801067a8:	6a 02                	push   $0x2
  jmp alltraps
801067aa:	e9 c2 f7 ff ff       	jmp    80105f71 <alltraps>

801067af <vector3>:
.globl vector3
vector3:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $3
801067b1:	6a 03                	push   $0x3
  jmp alltraps
801067b3:	e9 b9 f7 ff ff       	jmp    80105f71 <alltraps>

801067b8 <vector4>:
.globl vector4
vector4:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $4
801067ba:	6a 04                	push   $0x4
  jmp alltraps
801067bc:	e9 b0 f7 ff ff       	jmp    80105f71 <alltraps>

801067c1 <vector5>:
.globl vector5
vector5:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $5
801067c3:	6a 05                	push   $0x5
  jmp alltraps
801067c5:	e9 a7 f7 ff ff       	jmp    80105f71 <alltraps>

801067ca <vector6>:
.globl vector6
vector6:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $6
801067cc:	6a 06                	push   $0x6
  jmp alltraps
801067ce:	e9 9e f7 ff ff       	jmp    80105f71 <alltraps>

801067d3 <vector7>:
.globl vector7
vector7:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $7
801067d5:	6a 07                	push   $0x7
  jmp alltraps
801067d7:	e9 95 f7 ff ff       	jmp    80105f71 <alltraps>

801067dc <vector8>:
.globl vector8
vector8:
  pushl $8
801067dc:	6a 08                	push   $0x8
  jmp alltraps
801067de:	e9 8e f7 ff ff       	jmp    80105f71 <alltraps>

801067e3 <vector9>:
.globl vector9
vector9:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $9
801067e5:	6a 09                	push   $0x9
  jmp alltraps
801067e7:	e9 85 f7 ff ff       	jmp    80105f71 <alltraps>

801067ec <vector10>:
.globl vector10
vector10:
  pushl $10
801067ec:	6a 0a                	push   $0xa
  jmp alltraps
801067ee:	e9 7e f7 ff ff       	jmp    80105f71 <alltraps>

801067f3 <vector11>:
.globl vector11
vector11:
  pushl $11
801067f3:	6a 0b                	push   $0xb
  jmp alltraps
801067f5:	e9 77 f7 ff ff       	jmp    80105f71 <alltraps>

801067fa <vector12>:
.globl vector12
vector12:
  pushl $12
801067fa:	6a 0c                	push   $0xc
  jmp alltraps
801067fc:	e9 70 f7 ff ff       	jmp    80105f71 <alltraps>

80106801 <vector13>:
.globl vector13
vector13:
  pushl $13
80106801:	6a 0d                	push   $0xd
  jmp alltraps
80106803:	e9 69 f7 ff ff       	jmp    80105f71 <alltraps>

80106808 <vector14>:
.globl vector14
vector14:
  pushl $14
80106808:	6a 0e                	push   $0xe
  jmp alltraps
8010680a:	e9 62 f7 ff ff       	jmp    80105f71 <alltraps>

8010680f <vector15>:
.globl vector15
vector15:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $15
80106811:	6a 0f                	push   $0xf
  jmp alltraps
80106813:	e9 59 f7 ff ff       	jmp    80105f71 <alltraps>

80106818 <vector16>:
.globl vector16
vector16:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $16
8010681a:	6a 10                	push   $0x10
  jmp alltraps
8010681c:	e9 50 f7 ff ff       	jmp    80105f71 <alltraps>

80106821 <vector17>:
.globl vector17
vector17:
  pushl $17
80106821:	6a 11                	push   $0x11
  jmp alltraps
80106823:	e9 49 f7 ff ff       	jmp    80105f71 <alltraps>

80106828 <vector18>:
.globl vector18
vector18:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $18
8010682a:	6a 12                	push   $0x12
  jmp alltraps
8010682c:	e9 40 f7 ff ff       	jmp    80105f71 <alltraps>

80106831 <vector19>:
.globl vector19
vector19:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $19
80106833:	6a 13                	push   $0x13
  jmp alltraps
80106835:	e9 37 f7 ff ff       	jmp    80105f71 <alltraps>

8010683a <vector20>:
.globl vector20
vector20:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $20
8010683c:	6a 14                	push   $0x14
  jmp alltraps
8010683e:	e9 2e f7 ff ff       	jmp    80105f71 <alltraps>

80106843 <vector21>:
.globl vector21
vector21:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $21
80106845:	6a 15                	push   $0x15
  jmp alltraps
80106847:	e9 25 f7 ff ff       	jmp    80105f71 <alltraps>

8010684c <vector22>:
.globl vector22
vector22:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $22
8010684e:	6a 16                	push   $0x16
  jmp alltraps
80106850:	e9 1c f7 ff ff       	jmp    80105f71 <alltraps>

80106855 <vector23>:
.globl vector23
vector23:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $23
80106857:	6a 17                	push   $0x17
  jmp alltraps
80106859:	e9 13 f7 ff ff       	jmp    80105f71 <alltraps>

8010685e <vector24>:
.globl vector24
vector24:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $24
80106860:	6a 18                	push   $0x18
  jmp alltraps
80106862:	e9 0a f7 ff ff       	jmp    80105f71 <alltraps>

80106867 <vector25>:
.globl vector25
vector25:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $25
80106869:	6a 19                	push   $0x19
  jmp alltraps
8010686b:	e9 01 f7 ff ff       	jmp    80105f71 <alltraps>

80106870 <vector26>:
.globl vector26
vector26:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $26
80106872:	6a 1a                	push   $0x1a
  jmp alltraps
80106874:	e9 f8 f6 ff ff       	jmp    80105f71 <alltraps>

80106879 <vector27>:
.globl vector27
vector27:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $27
8010687b:	6a 1b                	push   $0x1b
  jmp alltraps
8010687d:	e9 ef f6 ff ff       	jmp    80105f71 <alltraps>

80106882 <vector28>:
.globl vector28
vector28:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $28
80106884:	6a 1c                	push   $0x1c
  jmp alltraps
80106886:	e9 e6 f6 ff ff       	jmp    80105f71 <alltraps>

8010688b <vector29>:
.globl vector29
vector29:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $29
8010688d:	6a 1d                	push   $0x1d
  jmp alltraps
8010688f:	e9 dd f6 ff ff       	jmp    80105f71 <alltraps>

80106894 <vector30>:
.globl vector30
vector30:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $30
80106896:	6a 1e                	push   $0x1e
  jmp alltraps
80106898:	e9 d4 f6 ff ff       	jmp    80105f71 <alltraps>

8010689d <vector31>:
.globl vector31
vector31:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $31
8010689f:	6a 1f                	push   $0x1f
  jmp alltraps
801068a1:	e9 cb f6 ff ff       	jmp    80105f71 <alltraps>

801068a6 <vector32>:
.globl vector32
vector32:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $32
801068a8:	6a 20                	push   $0x20
  jmp alltraps
801068aa:	e9 c2 f6 ff ff       	jmp    80105f71 <alltraps>

801068af <vector33>:
.globl vector33
vector33:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $33
801068b1:	6a 21                	push   $0x21
  jmp alltraps
801068b3:	e9 b9 f6 ff ff       	jmp    80105f71 <alltraps>

801068b8 <vector34>:
.globl vector34
vector34:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $34
801068ba:	6a 22                	push   $0x22
  jmp alltraps
801068bc:	e9 b0 f6 ff ff       	jmp    80105f71 <alltraps>

801068c1 <vector35>:
.globl vector35
vector35:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $35
801068c3:	6a 23                	push   $0x23
  jmp alltraps
801068c5:	e9 a7 f6 ff ff       	jmp    80105f71 <alltraps>

801068ca <vector36>:
.globl vector36
vector36:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $36
801068cc:	6a 24                	push   $0x24
  jmp alltraps
801068ce:	e9 9e f6 ff ff       	jmp    80105f71 <alltraps>

801068d3 <vector37>:
.globl vector37
vector37:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $37
801068d5:	6a 25                	push   $0x25
  jmp alltraps
801068d7:	e9 95 f6 ff ff       	jmp    80105f71 <alltraps>

801068dc <vector38>:
.globl vector38
vector38:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $38
801068de:	6a 26                	push   $0x26
  jmp alltraps
801068e0:	e9 8c f6 ff ff       	jmp    80105f71 <alltraps>

801068e5 <vector39>:
.globl vector39
vector39:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $39
801068e7:	6a 27                	push   $0x27
  jmp alltraps
801068e9:	e9 83 f6 ff ff       	jmp    80105f71 <alltraps>

801068ee <vector40>:
.globl vector40
vector40:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $40
801068f0:	6a 28                	push   $0x28
  jmp alltraps
801068f2:	e9 7a f6 ff ff       	jmp    80105f71 <alltraps>

801068f7 <vector41>:
.globl vector41
vector41:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $41
801068f9:	6a 29                	push   $0x29
  jmp alltraps
801068fb:	e9 71 f6 ff ff       	jmp    80105f71 <alltraps>

80106900 <vector42>:
.globl vector42
vector42:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $42
80106902:	6a 2a                	push   $0x2a
  jmp alltraps
80106904:	e9 68 f6 ff ff       	jmp    80105f71 <alltraps>

80106909 <vector43>:
.globl vector43
vector43:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $43
8010690b:	6a 2b                	push   $0x2b
  jmp alltraps
8010690d:	e9 5f f6 ff ff       	jmp    80105f71 <alltraps>

80106912 <vector44>:
.globl vector44
vector44:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $44
80106914:	6a 2c                	push   $0x2c
  jmp alltraps
80106916:	e9 56 f6 ff ff       	jmp    80105f71 <alltraps>

8010691b <vector45>:
.globl vector45
vector45:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $45
8010691d:	6a 2d                	push   $0x2d
  jmp alltraps
8010691f:	e9 4d f6 ff ff       	jmp    80105f71 <alltraps>

80106924 <vector46>:
.globl vector46
vector46:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $46
80106926:	6a 2e                	push   $0x2e
  jmp alltraps
80106928:	e9 44 f6 ff ff       	jmp    80105f71 <alltraps>

8010692d <vector47>:
.globl vector47
vector47:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $47
8010692f:	6a 2f                	push   $0x2f
  jmp alltraps
80106931:	e9 3b f6 ff ff       	jmp    80105f71 <alltraps>

80106936 <vector48>:
.globl vector48
vector48:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $48
80106938:	6a 30                	push   $0x30
  jmp alltraps
8010693a:	e9 32 f6 ff ff       	jmp    80105f71 <alltraps>

8010693f <vector49>:
.globl vector49
vector49:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $49
80106941:	6a 31                	push   $0x31
  jmp alltraps
80106943:	e9 29 f6 ff ff       	jmp    80105f71 <alltraps>

80106948 <vector50>:
.globl vector50
vector50:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $50
8010694a:	6a 32                	push   $0x32
  jmp alltraps
8010694c:	e9 20 f6 ff ff       	jmp    80105f71 <alltraps>

80106951 <vector51>:
.globl vector51
vector51:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $51
80106953:	6a 33                	push   $0x33
  jmp alltraps
80106955:	e9 17 f6 ff ff       	jmp    80105f71 <alltraps>

8010695a <vector52>:
.globl vector52
vector52:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $52
8010695c:	6a 34                	push   $0x34
  jmp alltraps
8010695e:	e9 0e f6 ff ff       	jmp    80105f71 <alltraps>

80106963 <vector53>:
.globl vector53
vector53:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $53
80106965:	6a 35                	push   $0x35
  jmp alltraps
80106967:	e9 05 f6 ff ff       	jmp    80105f71 <alltraps>

8010696c <vector54>:
.globl vector54
vector54:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $54
8010696e:	6a 36                	push   $0x36
  jmp alltraps
80106970:	e9 fc f5 ff ff       	jmp    80105f71 <alltraps>

80106975 <vector55>:
.globl vector55
vector55:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $55
80106977:	6a 37                	push   $0x37
  jmp alltraps
80106979:	e9 f3 f5 ff ff       	jmp    80105f71 <alltraps>

8010697e <vector56>:
.globl vector56
vector56:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $56
80106980:	6a 38                	push   $0x38
  jmp alltraps
80106982:	e9 ea f5 ff ff       	jmp    80105f71 <alltraps>

80106987 <vector57>:
.globl vector57
vector57:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $57
80106989:	6a 39                	push   $0x39
  jmp alltraps
8010698b:	e9 e1 f5 ff ff       	jmp    80105f71 <alltraps>

80106990 <vector58>:
.globl vector58
vector58:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $58
80106992:	6a 3a                	push   $0x3a
  jmp alltraps
80106994:	e9 d8 f5 ff ff       	jmp    80105f71 <alltraps>

80106999 <vector59>:
.globl vector59
vector59:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $59
8010699b:	6a 3b                	push   $0x3b
  jmp alltraps
8010699d:	e9 cf f5 ff ff       	jmp    80105f71 <alltraps>

801069a2 <vector60>:
.globl vector60
vector60:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $60
801069a4:	6a 3c                	push   $0x3c
  jmp alltraps
801069a6:	e9 c6 f5 ff ff       	jmp    80105f71 <alltraps>

801069ab <vector61>:
.globl vector61
vector61:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $61
801069ad:	6a 3d                	push   $0x3d
  jmp alltraps
801069af:	e9 bd f5 ff ff       	jmp    80105f71 <alltraps>

801069b4 <vector62>:
.globl vector62
vector62:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $62
801069b6:	6a 3e                	push   $0x3e
  jmp alltraps
801069b8:	e9 b4 f5 ff ff       	jmp    80105f71 <alltraps>

801069bd <vector63>:
.globl vector63
vector63:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $63
801069bf:	6a 3f                	push   $0x3f
  jmp alltraps
801069c1:	e9 ab f5 ff ff       	jmp    80105f71 <alltraps>

801069c6 <vector64>:
.globl vector64
vector64:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $64
801069c8:	6a 40                	push   $0x40
  jmp alltraps
801069ca:	e9 a2 f5 ff ff       	jmp    80105f71 <alltraps>

801069cf <vector65>:
.globl vector65
vector65:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $65
801069d1:	6a 41                	push   $0x41
  jmp alltraps
801069d3:	e9 99 f5 ff ff       	jmp    80105f71 <alltraps>

801069d8 <vector66>:
.globl vector66
vector66:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $66
801069da:	6a 42                	push   $0x42
  jmp alltraps
801069dc:	e9 90 f5 ff ff       	jmp    80105f71 <alltraps>

801069e1 <vector67>:
.globl vector67
vector67:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $67
801069e3:	6a 43                	push   $0x43
  jmp alltraps
801069e5:	e9 87 f5 ff ff       	jmp    80105f71 <alltraps>

801069ea <vector68>:
.globl vector68
vector68:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $68
801069ec:	6a 44                	push   $0x44
  jmp alltraps
801069ee:	e9 7e f5 ff ff       	jmp    80105f71 <alltraps>

801069f3 <vector69>:
.globl vector69
vector69:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $69
801069f5:	6a 45                	push   $0x45
  jmp alltraps
801069f7:	e9 75 f5 ff ff       	jmp    80105f71 <alltraps>

801069fc <vector70>:
.globl vector70
vector70:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $70
801069fe:	6a 46                	push   $0x46
  jmp alltraps
80106a00:	e9 6c f5 ff ff       	jmp    80105f71 <alltraps>

80106a05 <vector71>:
.globl vector71
vector71:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $71
80106a07:	6a 47                	push   $0x47
  jmp alltraps
80106a09:	e9 63 f5 ff ff       	jmp    80105f71 <alltraps>

80106a0e <vector72>:
.globl vector72
vector72:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $72
80106a10:	6a 48                	push   $0x48
  jmp alltraps
80106a12:	e9 5a f5 ff ff       	jmp    80105f71 <alltraps>

80106a17 <vector73>:
.globl vector73
vector73:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $73
80106a19:	6a 49                	push   $0x49
  jmp alltraps
80106a1b:	e9 51 f5 ff ff       	jmp    80105f71 <alltraps>

80106a20 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $74
80106a22:	6a 4a                	push   $0x4a
  jmp alltraps
80106a24:	e9 48 f5 ff ff       	jmp    80105f71 <alltraps>

80106a29 <vector75>:
.globl vector75
vector75:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $75
80106a2b:	6a 4b                	push   $0x4b
  jmp alltraps
80106a2d:	e9 3f f5 ff ff       	jmp    80105f71 <alltraps>

80106a32 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $76
80106a34:	6a 4c                	push   $0x4c
  jmp alltraps
80106a36:	e9 36 f5 ff ff       	jmp    80105f71 <alltraps>

80106a3b <vector77>:
.globl vector77
vector77:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $77
80106a3d:	6a 4d                	push   $0x4d
  jmp alltraps
80106a3f:	e9 2d f5 ff ff       	jmp    80105f71 <alltraps>

80106a44 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $78
80106a46:	6a 4e                	push   $0x4e
  jmp alltraps
80106a48:	e9 24 f5 ff ff       	jmp    80105f71 <alltraps>

80106a4d <vector79>:
.globl vector79
vector79:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $79
80106a4f:	6a 4f                	push   $0x4f
  jmp alltraps
80106a51:	e9 1b f5 ff ff       	jmp    80105f71 <alltraps>

80106a56 <vector80>:
.globl vector80
vector80:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $80
80106a58:	6a 50                	push   $0x50
  jmp alltraps
80106a5a:	e9 12 f5 ff ff       	jmp    80105f71 <alltraps>

80106a5f <vector81>:
.globl vector81
vector81:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $81
80106a61:	6a 51                	push   $0x51
  jmp alltraps
80106a63:	e9 09 f5 ff ff       	jmp    80105f71 <alltraps>

80106a68 <vector82>:
.globl vector82
vector82:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $82
80106a6a:	6a 52                	push   $0x52
  jmp alltraps
80106a6c:	e9 00 f5 ff ff       	jmp    80105f71 <alltraps>

80106a71 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $83
80106a73:	6a 53                	push   $0x53
  jmp alltraps
80106a75:	e9 f7 f4 ff ff       	jmp    80105f71 <alltraps>

80106a7a <vector84>:
.globl vector84
vector84:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $84
80106a7c:	6a 54                	push   $0x54
  jmp alltraps
80106a7e:	e9 ee f4 ff ff       	jmp    80105f71 <alltraps>

80106a83 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $85
80106a85:	6a 55                	push   $0x55
  jmp alltraps
80106a87:	e9 e5 f4 ff ff       	jmp    80105f71 <alltraps>

80106a8c <vector86>:
.globl vector86
vector86:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $86
80106a8e:	6a 56                	push   $0x56
  jmp alltraps
80106a90:	e9 dc f4 ff ff       	jmp    80105f71 <alltraps>

80106a95 <vector87>:
.globl vector87
vector87:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $87
80106a97:	6a 57                	push   $0x57
  jmp alltraps
80106a99:	e9 d3 f4 ff ff       	jmp    80105f71 <alltraps>

80106a9e <vector88>:
.globl vector88
vector88:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $88
80106aa0:	6a 58                	push   $0x58
  jmp alltraps
80106aa2:	e9 ca f4 ff ff       	jmp    80105f71 <alltraps>

80106aa7 <vector89>:
.globl vector89
vector89:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $89
80106aa9:	6a 59                	push   $0x59
  jmp alltraps
80106aab:	e9 c1 f4 ff ff       	jmp    80105f71 <alltraps>

80106ab0 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $90
80106ab2:	6a 5a                	push   $0x5a
  jmp alltraps
80106ab4:	e9 b8 f4 ff ff       	jmp    80105f71 <alltraps>

80106ab9 <vector91>:
.globl vector91
vector91:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $91
80106abb:	6a 5b                	push   $0x5b
  jmp alltraps
80106abd:	e9 af f4 ff ff       	jmp    80105f71 <alltraps>

80106ac2 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $92
80106ac4:	6a 5c                	push   $0x5c
  jmp alltraps
80106ac6:	e9 a6 f4 ff ff       	jmp    80105f71 <alltraps>

80106acb <vector93>:
.globl vector93
vector93:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $93
80106acd:	6a 5d                	push   $0x5d
  jmp alltraps
80106acf:	e9 9d f4 ff ff       	jmp    80105f71 <alltraps>

80106ad4 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $94
80106ad6:	6a 5e                	push   $0x5e
  jmp alltraps
80106ad8:	e9 94 f4 ff ff       	jmp    80105f71 <alltraps>

80106add <vector95>:
.globl vector95
vector95:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $95
80106adf:	6a 5f                	push   $0x5f
  jmp alltraps
80106ae1:	e9 8b f4 ff ff       	jmp    80105f71 <alltraps>

80106ae6 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $96
80106ae8:	6a 60                	push   $0x60
  jmp alltraps
80106aea:	e9 82 f4 ff ff       	jmp    80105f71 <alltraps>

80106aef <vector97>:
.globl vector97
vector97:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $97
80106af1:	6a 61                	push   $0x61
  jmp alltraps
80106af3:	e9 79 f4 ff ff       	jmp    80105f71 <alltraps>

80106af8 <vector98>:
.globl vector98
vector98:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $98
80106afa:	6a 62                	push   $0x62
  jmp alltraps
80106afc:	e9 70 f4 ff ff       	jmp    80105f71 <alltraps>

80106b01 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $99
80106b03:	6a 63                	push   $0x63
  jmp alltraps
80106b05:	e9 67 f4 ff ff       	jmp    80105f71 <alltraps>

80106b0a <vector100>:
.globl vector100
vector100:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $100
80106b0c:	6a 64                	push   $0x64
  jmp alltraps
80106b0e:	e9 5e f4 ff ff       	jmp    80105f71 <alltraps>

80106b13 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $101
80106b15:	6a 65                	push   $0x65
  jmp alltraps
80106b17:	e9 55 f4 ff ff       	jmp    80105f71 <alltraps>

80106b1c <vector102>:
.globl vector102
vector102:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $102
80106b1e:	6a 66                	push   $0x66
  jmp alltraps
80106b20:	e9 4c f4 ff ff       	jmp    80105f71 <alltraps>

80106b25 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $103
80106b27:	6a 67                	push   $0x67
  jmp alltraps
80106b29:	e9 43 f4 ff ff       	jmp    80105f71 <alltraps>

80106b2e <vector104>:
.globl vector104
vector104:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $104
80106b30:	6a 68                	push   $0x68
  jmp alltraps
80106b32:	e9 3a f4 ff ff       	jmp    80105f71 <alltraps>

80106b37 <vector105>:
.globl vector105
vector105:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $105
80106b39:	6a 69                	push   $0x69
  jmp alltraps
80106b3b:	e9 31 f4 ff ff       	jmp    80105f71 <alltraps>

80106b40 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $106
80106b42:	6a 6a                	push   $0x6a
  jmp alltraps
80106b44:	e9 28 f4 ff ff       	jmp    80105f71 <alltraps>

80106b49 <vector107>:
.globl vector107
vector107:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $107
80106b4b:	6a 6b                	push   $0x6b
  jmp alltraps
80106b4d:	e9 1f f4 ff ff       	jmp    80105f71 <alltraps>

80106b52 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $108
80106b54:	6a 6c                	push   $0x6c
  jmp alltraps
80106b56:	e9 16 f4 ff ff       	jmp    80105f71 <alltraps>

80106b5b <vector109>:
.globl vector109
vector109:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $109
80106b5d:	6a 6d                	push   $0x6d
  jmp alltraps
80106b5f:	e9 0d f4 ff ff       	jmp    80105f71 <alltraps>

80106b64 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $110
80106b66:	6a 6e                	push   $0x6e
  jmp alltraps
80106b68:	e9 04 f4 ff ff       	jmp    80105f71 <alltraps>

80106b6d <vector111>:
.globl vector111
vector111:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $111
80106b6f:	6a 6f                	push   $0x6f
  jmp alltraps
80106b71:	e9 fb f3 ff ff       	jmp    80105f71 <alltraps>

80106b76 <vector112>:
.globl vector112
vector112:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $112
80106b78:	6a 70                	push   $0x70
  jmp alltraps
80106b7a:	e9 f2 f3 ff ff       	jmp    80105f71 <alltraps>

80106b7f <vector113>:
.globl vector113
vector113:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $113
80106b81:	6a 71                	push   $0x71
  jmp alltraps
80106b83:	e9 e9 f3 ff ff       	jmp    80105f71 <alltraps>

80106b88 <vector114>:
.globl vector114
vector114:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $114
80106b8a:	6a 72                	push   $0x72
  jmp alltraps
80106b8c:	e9 e0 f3 ff ff       	jmp    80105f71 <alltraps>

80106b91 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $115
80106b93:	6a 73                	push   $0x73
  jmp alltraps
80106b95:	e9 d7 f3 ff ff       	jmp    80105f71 <alltraps>

80106b9a <vector116>:
.globl vector116
vector116:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $116
80106b9c:	6a 74                	push   $0x74
  jmp alltraps
80106b9e:	e9 ce f3 ff ff       	jmp    80105f71 <alltraps>

80106ba3 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $117
80106ba5:	6a 75                	push   $0x75
  jmp alltraps
80106ba7:	e9 c5 f3 ff ff       	jmp    80105f71 <alltraps>

80106bac <vector118>:
.globl vector118
vector118:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $118
80106bae:	6a 76                	push   $0x76
  jmp alltraps
80106bb0:	e9 bc f3 ff ff       	jmp    80105f71 <alltraps>

80106bb5 <vector119>:
.globl vector119
vector119:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $119
80106bb7:	6a 77                	push   $0x77
  jmp alltraps
80106bb9:	e9 b3 f3 ff ff       	jmp    80105f71 <alltraps>

80106bbe <vector120>:
.globl vector120
vector120:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $120
80106bc0:	6a 78                	push   $0x78
  jmp alltraps
80106bc2:	e9 aa f3 ff ff       	jmp    80105f71 <alltraps>

80106bc7 <vector121>:
.globl vector121
vector121:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $121
80106bc9:	6a 79                	push   $0x79
  jmp alltraps
80106bcb:	e9 a1 f3 ff ff       	jmp    80105f71 <alltraps>

80106bd0 <vector122>:
.globl vector122
vector122:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $122
80106bd2:	6a 7a                	push   $0x7a
  jmp alltraps
80106bd4:	e9 98 f3 ff ff       	jmp    80105f71 <alltraps>

80106bd9 <vector123>:
.globl vector123
vector123:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $123
80106bdb:	6a 7b                	push   $0x7b
  jmp alltraps
80106bdd:	e9 8f f3 ff ff       	jmp    80105f71 <alltraps>

80106be2 <vector124>:
.globl vector124
vector124:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $124
80106be4:	6a 7c                	push   $0x7c
  jmp alltraps
80106be6:	e9 86 f3 ff ff       	jmp    80105f71 <alltraps>

80106beb <vector125>:
.globl vector125
vector125:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $125
80106bed:	6a 7d                	push   $0x7d
  jmp alltraps
80106bef:	e9 7d f3 ff ff       	jmp    80105f71 <alltraps>

80106bf4 <vector126>:
.globl vector126
vector126:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $126
80106bf6:	6a 7e                	push   $0x7e
  jmp alltraps
80106bf8:	e9 74 f3 ff ff       	jmp    80105f71 <alltraps>

80106bfd <vector127>:
.globl vector127
vector127:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $127
80106bff:	6a 7f                	push   $0x7f
  jmp alltraps
80106c01:	e9 6b f3 ff ff       	jmp    80105f71 <alltraps>

80106c06 <vector128>:
.globl vector128
vector128:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $128
80106c08:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c0d:	e9 5f f3 ff ff       	jmp    80105f71 <alltraps>

80106c12 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $129
80106c14:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c19:	e9 53 f3 ff ff       	jmp    80105f71 <alltraps>

80106c1e <vector130>:
.globl vector130
vector130:
  pushl $0
80106c1e:	6a 00                	push   $0x0
  pushl $130
80106c20:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c25:	e9 47 f3 ff ff       	jmp    80105f71 <alltraps>

80106c2a <vector131>:
.globl vector131
vector131:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $131
80106c2c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c31:	e9 3b f3 ff ff       	jmp    80105f71 <alltraps>

80106c36 <vector132>:
.globl vector132
vector132:
  pushl $0
80106c36:	6a 00                	push   $0x0
  pushl $132
80106c38:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c3d:	e9 2f f3 ff ff       	jmp    80105f71 <alltraps>

80106c42 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c42:	6a 00                	push   $0x0
  pushl $133
80106c44:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c49:	e9 23 f3 ff ff       	jmp    80105f71 <alltraps>

80106c4e <vector134>:
.globl vector134
vector134:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $134
80106c50:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c55:	e9 17 f3 ff ff       	jmp    80105f71 <alltraps>

80106c5a <vector135>:
.globl vector135
vector135:
  pushl $0
80106c5a:	6a 00                	push   $0x0
  pushl $135
80106c5c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c61:	e9 0b f3 ff ff       	jmp    80105f71 <alltraps>

80106c66 <vector136>:
.globl vector136
vector136:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $136
80106c68:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c6d:	e9 ff f2 ff ff       	jmp    80105f71 <alltraps>

80106c72 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $137
80106c74:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c79:	e9 f3 f2 ff ff       	jmp    80105f71 <alltraps>

80106c7e <vector138>:
.globl vector138
vector138:
  pushl $0
80106c7e:	6a 00                	push   $0x0
  pushl $138
80106c80:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c85:	e9 e7 f2 ff ff       	jmp    80105f71 <alltraps>

80106c8a <vector139>:
.globl vector139
vector139:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $139
80106c8c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c91:	e9 db f2 ff ff       	jmp    80105f71 <alltraps>

80106c96 <vector140>:
.globl vector140
vector140:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $140
80106c98:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c9d:	e9 cf f2 ff ff       	jmp    80105f71 <alltraps>

80106ca2 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ca2:	6a 00                	push   $0x0
  pushl $141
80106ca4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ca9:	e9 c3 f2 ff ff       	jmp    80105f71 <alltraps>

80106cae <vector142>:
.globl vector142
vector142:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $142
80106cb0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106cb5:	e9 b7 f2 ff ff       	jmp    80105f71 <alltraps>

80106cba <vector143>:
.globl vector143
vector143:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $143
80106cbc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106cc1:	e9 ab f2 ff ff       	jmp    80105f71 <alltraps>

80106cc6 <vector144>:
.globl vector144
vector144:
  pushl $0
80106cc6:	6a 00                	push   $0x0
  pushl $144
80106cc8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ccd:	e9 9f f2 ff ff       	jmp    80105f71 <alltraps>

80106cd2 <vector145>:
.globl vector145
vector145:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $145
80106cd4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cd9:	e9 93 f2 ff ff       	jmp    80105f71 <alltraps>

80106cde <vector146>:
.globl vector146
vector146:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $146
80106ce0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ce5:	e9 87 f2 ff ff       	jmp    80105f71 <alltraps>

80106cea <vector147>:
.globl vector147
vector147:
  pushl $0
80106cea:	6a 00                	push   $0x0
  pushl $147
80106cec:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cf1:	e9 7b f2 ff ff       	jmp    80105f71 <alltraps>

80106cf6 <vector148>:
.globl vector148
vector148:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $148
80106cf8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cfd:	e9 6f f2 ff ff       	jmp    80105f71 <alltraps>

80106d02 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $149
80106d04:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d09:	e9 63 f2 ff ff       	jmp    80105f71 <alltraps>

80106d0e <vector150>:
.globl vector150
vector150:
  pushl $0
80106d0e:	6a 00                	push   $0x0
  pushl $150
80106d10:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d15:	e9 57 f2 ff ff       	jmp    80105f71 <alltraps>

80106d1a <vector151>:
.globl vector151
vector151:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $151
80106d1c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d21:	e9 4b f2 ff ff       	jmp    80105f71 <alltraps>

80106d26 <vector152>:
.globl vector152
vector152:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $152
80106d28:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d2d:	e9 3f f2 ff ff       	jmp    80105f71 <alltraps>

80106d32 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $153
80106d34:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d39:	e9 33 f2 ff ff       	jmp    80105f71 <alltraps>

80106d3e <vector154>:
.globl vector154
vector154:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $154
80106d40:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d45:	e9 27 f2 ff ff       	jmp    80105f71 <alltraps>

80106d4a <vector155>:
.globl vector155
vector155:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $155
80106d4c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d51:	e9 1b f2 ff ff       	jmp    80105f71 <alltraps>

80106d56 <vector156>:
.globl vector156
vector156:
  pushl $0
80106d56:	6a 00                	push   $0x0
  pushl $156
80106d58:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d5d:	e9 0f f2 ff ff       	jmp    80105f71 <alltraps>

80106d62 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $157
80106d64:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d69:	e9 03 f2 ff ff       	jmp    80105f71 <alltraps>

80106d6e <vector158>:
.globl vector158
vector158:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $158
80106d70:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d75:	e9 f7 f1 ff ff       	jmp    80105f71 <alltraps>

80106d7a <vector159>:
.globl vector159
vector159:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $159
80106d7c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d81:	e9 eb f1 ff ff       	jmp    80105f71 <alltraps>

80106d86 <vector160>:
.globl vector160
vector160:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $160
80106d88:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d8d:	e9 df f1 ff ff       	jmp    80105f71 <alltraps>

80106d92 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $161
80106d94:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d99:	e9 d3 f1 ff ff       	jmp    80105f71 <alltraps>

80106d9e <vector162>:
.globl vector162
vector162:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $162
80106da0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106da5:	e9 c7 f1 ff ff       	jmp    80105f71 <alltraps>

80106daa <vector163>:
.globl vector163
vector163:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $163
80106dac:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106db1:	e9 bb f1 ff ff       	jmp    80105f71 <alltraps>

80106db6 <vector164>:
.globl vector164
vector164:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $164
80106db8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106dbd:	e9 af f1 ff ff       	jmp    80105f71 <alltraps>

80106dc2 <vector165>:
.globl vector165
vector165:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $165
80106dc4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dc9:	e9 a3 f1 ff ff       	jmp    80105f71 <alltraps>

80106dce <vector166>:
.globl vector166
vector166:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $166
80106dd0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106dd5:	e9 97 f1 ff ff       	jmp    80105f71 <alltraps>

80106dda <vector167>:
.globl vector167
vector167:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $167
80106ddc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106de1:	e9 8b f1 ff ff       	jmp    80105f71 <alltraps>

80106de6 <vector168>:
.globl vector168
vector168:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $168
80106de8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ded:	e9 7f f1 ff ff       	jmp    80105f71 <alltraps>

80106df2 <vector169>:
.globl vector169
vector169:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $169
80106df4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106df9:	e9 73 f1 ff ff       	jmp    80105f71 <alltraps>

80106dfe <vector170>:
.globl vector170
vector170:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $170
80106e00:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e05:	e9 67 f1 ff ff       	jmp    80105f71 <alltraps>

80106e0a <vector171>:
.globl vector171
vector171:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $171
80106e0c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e11:	e9 5b f1 ff ff       	jmp    80105f71 <alltraps>

80106e16 <vector172>:
.globl vector172
vector172:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $172
80106e18:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e1d:	e9 4f f1 ff ff       	jmp    80105f71 <alltraps>

80106e22 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $173
80106e24:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e29:	e9 43 f1 ff ff       	jmp    80105f71 <alltraps>

80106e2e <vector174>:
.globl vector174
vector174:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $174
80106e30:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e35:	e9 37 f1 ff ff       	jmp    80105f71 <alltraps>

80106e3a <vector175>:
.globl vector175
vector175:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $175
80106e3c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e41:	e9 2b f1 ff ff       	jmp    80105f71 <alltraps>

80106e46 <vector176>:
.globl vector176
vector176:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $176
80106e48:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e4d:	e9 1f f1 ff ff       	jmp    80105f71 <alltraps>

80106e52 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $177
80106e54:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e59:	e9 13 f1 ff ff       	jmp    80105f71 <alltraps>

80106e5e <vector178>:
.globl vector178
vector178:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $178
80106e60:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e65:	e9 07 f1 ff ff       	jmp    80105f71 <alltraps>

80106e6a <vector179>:
.globl vector179
vector179:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $179
80106e6c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e71:	e9 fb f0 ff ff       	jmp    80105f71 <alltraps>

80106e76 <vector180>:
.globl vector180
vector180:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $180
80106e78:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e7d:	e9 ef f0 ff ff       	jmp    80105f71 <alltraps>

80106e82 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $181
80106e84:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e89:	e9 e3 f0 ff ff       	jmp    80105f71 <alltraps>

80106e8e <vector182>:
.globl vector182
vector182:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $182
80106e90:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e95:	e9 d7 f0 ff ff       	jmp    80105f71 <alltraps>

80106e9a <vector183>:
.globl vector183
vector183:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $183
80106e9c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ea1:	e9 cb f0 ff ff       	jmp    80105f71 <alltraps>

80106ea6 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $184
80106ea8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ead:	e9 bf f0 ff ff       	jmp    80105f71 <alltraps>

80106eb2 <vector185>:
.globl vector185
vector185:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $185
80106eb4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106eb9:	e9 b3 f0 ff ff       	jmp    80105f71 <alltraps>

80106ebe <vector186>:
.globl vector186
vector186:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $186
80106ec0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ec5:	e9 a7 f0 ff ff       	jmp    80105f71 <alltraps>

80106eca <vector187>:
.globl vector187
vector187:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $187
80106ecc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ed1:	e9 9b f0 ff ff       	jmp    80105f71 <alltraps>

80106ed6 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $188
80106ed8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106edd:	e9 8f f0 ff ff       	jmp    80105f71 <alltraps>

80106ee2 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $189
80106ee4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ee9:	e9 83 f0 ff ff       	jmp    80105f71 <alltraps>

80106eee <vector190>:
.globl vector190
vector190:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $190
80106ef0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ef5:	e9 77 f0 ff ff       	jmp    80105f71 <alltraps>

80106efa <vector191>:
.globl vector191
vector191:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $191
80106efc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f01:	e9 6b f0 ff ff       	jmp    80105f71 <alltraps>

80106f06 <vector192>:
.globl vector192
vector192:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $192
80106f08:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f0d:	e9 5f f0 ff ff       	jmp    80105f71 <alltraps>

80106f12 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $193
80106f14:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f19:	e9 53 f0 ff ff       	jmp    80105f71 <alltraps>

80106f1e <vector194>:
.globl vector194
vector194:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $194
80106f20:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f25:	e9 47 f0 ff ff       	jmp    80105f71 <alltraps>

80106f2a <vector195>:
.globl vector195
vector195:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $195
80106f2c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f31:	e9 3b f0 ff ff       	jmp    80105f71 <alltraps>

80106f36 <vector196>:
.globl vector196
vector196:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $196
80106f38:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f3d:	e9 2f f0 ff ff       	jmp    80105f71 <alltraps>

80106f42 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $197
80106f44:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f49:	e9 23 f0 ff ff       	jmp    80105f71 <alltraps>

80106f4e <vector198>:
.globl vector198
vector198:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $198
80106f50:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f55:	e9 17 f0 ff ff       	jmp    80105f71 <alltraps>

80106f5a <vector199>:
.globl vector199
vector199:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $199
80106f5c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f61:	e9 0b f0 ff ff       	jmp    80105f71 <alltraps>

80106f66 <vector200>:
.globl vector200
vector200:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $200
80106f68:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f6d:	e9 ff ef ff ff       	jmp    80105f71 <alltraps>

80106f72 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $201
80106f74:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f79:	e9 f3 ef ff ff       	jmp    80105f71 <alltraps>

80106f7e <vector202>:
.globl vector202
vector202:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $202
80106f80:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f85:	e9 e7 ef ff ff       	jmp    80105f71 <alltraps>

80106f8a <vector203>:
.globl vector203
vector203:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $203
80106f8c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f91:	e9 db ef ff ff       	jmp    80105f71 <alltraps>

80106f96 <vector204>:
.globl vector204
vector204:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $204
80106f98:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f9d:	e9 cf ef ff ff       	jmp    80105f71 <alltraps>

80106fa2 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $205
80106fa4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fa9:	e9 c3 ef ff ff       	jmp    80105f71 <alltraps>

80106fae <vector206>:
.globl vector206
vector206:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $206
80106fb0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106fb5:	e9 b7 ef ff ff       	jmp    80105f71 <alltraps>

80106fba <vector207>:
.globl vector207
vector207:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $207
80106fbc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fc1:	e9 ab ef ff ff       	jmp    80105f71 <alltraps>

80106fc6 <vector208>:
.globl vector208
vector208:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $208
80106fc8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fcd:	e9 9f ef ff ff       	jmp    80105f71 <alltraps>

80106fd2 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $209
80106fd4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fd9:	e9 93 ef ff ff       	jmp    80105f71 <alltraps>

80106fde <vector210>:
.globl vector210
vector210:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $210
80106fe0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fe5:	e9 87 ef ff ff       	jmp    80105f71 <alltraps>

80106fea <vector211>:
.globl vector211
vector211:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $211
80106fec:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ff1:	e9 7b ef ff ff       	jmp    80105f71 <alltraps>

80106ff6 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $212
80106ff8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ffd:	e9 6f ef ff ff       	jmp    80105f71 <alltraps>

80107002 <vector213>:
.globl vector213
vector213:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $213
80107004:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107009:	e9 63 ef ff ff       	jmp    80105f71 <alltraps>

8010700e <vector214>:
.globl vector214
vector214:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $214
80107010:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107015:	e9 57 ef ff ff       	jmp    80105f71 <alltraps>

8010701a <vector215>:
.globl vector215
vector215:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $215
8010701c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107021:	e9 4b ef ff ff       	jmp    80105f71 <alltraps>

80107026 <vector216>:
.globl vector216
vector216:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $216
80107028:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010702d:	e9 3f ef ff ff       	jmp    80105f71 <alltraps>

80107032 <vector217>:
.globl vector217
vector217:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $217
80107034:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107039:	e9 33 ef ff ff       	jmp    80105f71 <alltraps>

8010703e <vector218>:
.globl vector218
vector218:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $218
80107040:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107045:	e9 27 ef ff ff       	jmp    80105f71 <alltraps>

8010704a <vector219>:
.globl vector219
vector219:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $219
8010704c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107051:	e9 1b ef ff ff       	jmp    80105f71 <alltraps>

80107056 <vector220>:
.globl vector220
vector220:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $220
80107058:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010705d:	e9 0f ef ff ff       	jmp    80105f71 <alltraps>

80107062 <vector221>:
.globl vector221
vector221:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $221
80107064:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107069:	e9 03 ef ff ff       	jmp    80105f71 <alltraps>

8010706e <vector222>:
.globl vector222
vector222:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $222
80107070:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107075:	e9 f7 ee ff ff       	jmp    80105f71 <alltraps>

8010707a <vector223>:
.globl vector223
vector223:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $223
8010707c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107081:	e9 eb ee ff ff       	jmp    80105f71 <alltraps>

80107086 <vector224>:
.globl vector224
vector224:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $224
80107088:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010708d:	e9 df ee ff ff       	jmp    80105f71 <alltraps>

80107092 <vector225>:
.globl vector225
vector225:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $225
80107094:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107099:	e9 d3 ee ff ff       	jmp    80105f71 <alltraps>

8010709e <vector226>:
.globl vector226
vector226:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $226
801070a0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070a5:	e9 c7 ee ff ff       	jmp    80105f71 <alltraps>

801070aa <vector227>:
.globl vector227
vector227:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $227
801070ac:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070b1:	e9 bb ee ff ff       	jmp    80105f71 <alltraps>

801070b6 <vector228>:
.globl vector228
vector228:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $228
801070b8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070bd:	e9 af ee ff ff       	jmp    80105f71 <alltraps>

801070c2 <vector229>:
.globl vector229
vector229:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $229
801070c4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070c9:	e9 a3 ee ff ff       	jmp    80105f71 <alltraps>

801070ce <vector230>:
.globl vector230
vector230:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $230
801070d0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070d5:	e9 97 ee ff ff       	jmp    80105f71 <alltraps>

801070da <vector231>:
.globl vector231
vector231:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $231
801070dc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070e1:	e9 8b ee ff ff       	jmp    80105f71 <alltraps>

801070e6 <vector232>:
.globl vector232
vector232:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $232
801070e8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070ed:	e9 7f ee ff ff       	jmp    80105f71 <alltraps>

801070f2 <vector233>:
.globl vector233
vector233:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $233
801070f4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070f9:	e9 73 ee ff ff       	jmp    80105f71 <alltraps>

801070fe <vector234>:
.globl vector234
vector234:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $234
80107100:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107105:	e9 67 ee ff ff       	jmp    80105f71 <alltraps>

8010710a <vector235>:
.globl vector235
vector235:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $235
8010710c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107111:	e9 5b ee ff ff       	jmp    80105f71 <alltraps>

80107116 <vector236>:
.globl vector236
vector236:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $236
80107118:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010711d:	e9 4f ee ff ff       	jmp    80105f71 <alltraps>

80107122 <vector237>:
.globl vector237
vector237:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $237
80107124:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107129:	e9 43 ee ff ff       	jmp    80105f71 <alltraps>

8010712e <vector238>:
.globl vector238
vector238:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $238
80107130:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107135:	e9 37 ee ff ff       	jmp    80105f71 <alltraps>

8010713a <vector239>:
.globl vector239
vector239:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $239
8010713c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107141:	e9 2b ee ff ff       	jmp    80105f71 <alltraps>

80107146 <vector240>:
.globl vector240
vector240:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $240
80107148:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010714d:	e9 1f ee ff ff       	jmp    80105f71 <alltraps>

80107152 <vector241>:
.globl vector241
vector241:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $241
80107154:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107159:	e9 13 ee ff ff       	jmp    80105f71 <alltraps>

8010715e <vector242>:
.globl vector242
vector242:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $242
80107160:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107165:	e9 07 ee ff ff       	jmp    80105f71 <alltraps>

8010716a <vector243>:
.globl vector243
vector243:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $243
8010716c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107171:	e9 fb ed ff ff       	jmp    80105f71 <alltraps>

80107176 <vector244>:
.globl vector244
vector244:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $244
80107178:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010717d:	e9 ef ed ff ff       	jmp    80105f71 <alltraps>

80107182 <vector245>:
.globl vector245
vector245:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $245
80107184:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107189:	e9 e3 ed ff ff       	jmp    80105f71 <alltraps>

8010718e <vector246>:
.globl vector246
vector246:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $246
80107190:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107195:	e9 d7 ed ff ff       	jmp    80105f71 <alltraps>

8010719a <vector247>:
.globl vector247
vector247:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $247
8010719c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071a1:	e9 cb ed ff ff       	jmp    80105f71 <alltraps>

801071a6 <vector248>:
.globl vector248
vector248:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $248
801071a8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071ad:	e9 bf ed ff ff       	jmp    80105f71 <alltraps>

801071b2 <vector249>:
.globl vector249
vector249:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $249
801071b4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071b9:	e9 b3 ed ff ff       	jmp    80105f71 <alltraps>

801071be <vector250>:
.globl vector250
vector250:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $250
801071c0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071c5:	e9 a7 ed ff ff       	jmp    80105f71 <alltraps>

801071ca <vector251>:
.globl vector251
vector251:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $251
801071cc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071d1:	e9 9b ed ff ff       	jmp    80105f71 <alltraps>

801071d6 <vector252>:
.globl vector252
vector252:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $252
801071d8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071dd:	e9 8f ed ff ff       	jmp    80105f71 <alltraps>

801071e2 <vector253>:
.globl vector253
vector253:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $253
801071e4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071e9:	e9 83 ed ff ff       	jmp    80105f71 <alltraps>

801071ee <vector254>:
.globl vector254
vector254:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $254
801071f0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071f5:	e9 77 ed ff ff       	jmp    80105f71 <alltraps>

801071fa <vector255>:
.globl vector255
vector255:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $255
801071fc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107201:	e9 6b ed ff ff       	jmp    80105f71 <alltraps>

80107206 <lgdt>:
{
80107206:	55                   	push   %ebp
80107207:	89 e5                	mov    %esp,%ebp
80107209:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010720c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010720f:	83 e8 01             	sub    $0x1,%eax
80107212:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107216:	8b 45 08             	mov    0x8(%ebp),%eax
80107219:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010721d:	8b 45 08             	mov    0x8(%ebp),%eax
80107220:	c1 e8 10             	shr    $0x10,%eax
80107223:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107227:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010722a:	0f 01 10             	lgdtl  (%eax)
}
8010722d:	90                   	nop
8010722e:	c9                   	leave  
8010722f:	c3                   	ret    

80107230 <ltr>:
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 04             	sub    $0x4,%esp
80107236:	8b 45 08             	mov    0x8(%ebp),%eax
80107239:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010723d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107241:	0f 00 d8             	ltr    %ax
}
80107244:	90                   	nop
80107245:	c9                   	leave  
80107246:	c3                   	ret    

80107247 <lcr3>:

static inline void
lcr3(uint val)
{
80107247:	55                   	push   %ebp
80107248:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010724a:	8b 45 08             	mov    0x8(%ebp),%eax
8010724d:	0f 22 d8             	mov    %eax,%cr3
}
80107250:	90                   	nop
80107251:	5d                   	pop    %ebp
80107252:	c3                   	ret    

80107253 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107253:	55                   	push   %ebp
80107254:	89 e5                	mov    %esp,%ebp
80107256:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107259:	e8 24 c7 ff ff       	call   80103982 <cpuid>
8010725e:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107264:	05 a0 6b 19 80       	add    $0x80196ba0,%eax
80107269:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010726c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010726f:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107278:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010727e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107281:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107288:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010728c:	83 e2 f0             	and    $0xfffffff0,%edx
8010728f:	83 ca 0a             	or     $0xa,%edx
80107292:	88 50 7d             	mov    %dl,0x7d(%eax)
80107295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107298:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010729c:	83 ca 10             	or     $0x10,%edx
8010729f:	88 50 7d             	mov    %dl,0x7d(%eax)
801072a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072a9:	83 e2 9f             	and    $0xffffff9f,%edx
801072ac:	88 50 7d             	mov    %dl,0x7d(%eax)
801072af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b2:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072b6:	83 ca 80             	or     $0xffffff80,%edx
801072b9:	88 50 7d             	mov    %dl,0x7d(%eax)
801072bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072bf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072c3:	83 ca 0f             	or     $0xf,%edx
801072c6:	88 50 7e             	mov    %dl,0x7e(%eax)
801072c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072d0:	83 e2 ef             	and    $0xffffffef,%edx
801072d3:	88 50 7e             	mov    %dl,0x7e(%eax)
801072d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072dd:	83 e2 df             	and    $0xffffffdf,%edx
801072e0:	88 50 7e             	mov    %dl,0x7e(%eax)
801072e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072ea:	83 ca 40             	or     $0x40,%edx
801072ed:	88 50 7e             	mov    %dl,0x7e(%eax)
801072f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072f7:	83 ca 80             	or     $0xffffff80,%edx
801072fa:	88 50 7e             	mov    %dl,0x7e(%eax)
801072fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107300:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107307:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010730e:	ff ff 
80107310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107313:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010731a:	00 00 
8010731c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731f:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107329:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107330:	83 e2 f0             	and    $0xfffffff0,%edx
80107333:	83 ca 02             	or     $0x2,%edx
80107336:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010733c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107346:	83 ca 10             	or     $0x10,%edx
80107349:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010734f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107352:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107359:	83 e2 9f             	and    $0xffffff9f,%edx
8010735c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107365:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010736c:	83 ca 80             	or     $0xffffff80,%edx
8010736f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107378:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010737f:	83 ca 0f             	or     $0xf,%edx
80107382:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107392:	83 e2 ef             	and    $0xffffffef,%edx
80107395:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010739b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073a5:	83 e2 df             	and    $0xffffffdf,%edx
801073a8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073b8:	83 ca 40             	or     $0x40,%edx
801073bb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073cb:	83 ca 80             	or     $0xffffff80,%edx
801073ce:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e1:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801073e8:	ff ff 
801073ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ed:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801073f4:	00 00 
801073f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f9:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107403:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010740a:	83 e2 f0             	and    $0xfffffff0,%edx
8010740d:	83 ca 0a             	or     $0xa,%edx
80107410:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107419:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107420:	83 ca 10             	or     $0x10,%edx
80107423:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107433:	83 ca 60             	or     $0x60,%edx
80107436:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010743c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107446:	83 ca 80             	or     $0xffffff80,%edx
80107449:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010744f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107452:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107459:	83 ca 0f             	or     $0xf,%edx
8010745c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107465:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010746c:	83 e2 ef             	and    $0xffffffef,%edx
8010746f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107475:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107478:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010747f:	83 e2 df             	and    $0xffffffdf,%edx
80107482:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107488:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107492:	83 ca 40             	or     $0x40,%edx
80107495:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010749b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074a5:	83 ca 80             	or     $0xffffff80,%edx
801074a8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b1:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074bb:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801074c2:	ff ff 
801074c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c7:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801074ce:	00 00 
801074d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d3:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801074da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074dd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074e4:	83 e2 f0             	and    $0xfffffff0,%edx
801074e7:	83 ca 02             	or     $0x2,%edx
801074ea:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801074f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074fa:	83 ca 10             	or     $0x10,%edx
801074fd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107506:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010750d:	83 ca 60             	or     $0x60,%edx
80107510:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107519:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107520:	83 ca 80             	or     $0xffffff80,%edx
80107523:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107533:	83 ca 0f             	or     $0xf,%edx
80107536:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010753c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107546:	83 e2 ef             	and    $0xffffffef,%edx
80107549:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010754f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107552:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107559:	83 e2 df             	and    $0xffffffdf,%edx
8010755c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107565:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010756c:	83 ca 40             	or     $0x40,%edx
8010756f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107578:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010757f:	83 ca 80             	or     $0xffffff80,%edx
80107582:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758b:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107595:	83 c0 70             	add    $0x70,%eax
80107598:	83 ec 08             	sub    $0x8,%esp
8010759b:	6a 30                	push   $0x30
8010759d:	50                   	push   %eax
8010759e:	e8 63 fc ff ff       	call   80107206 <lgdt>
801075a3:	83 c4 10             	add    $0x10,%esp
}
801075a6:	90                   	nop
801075a7:	c9                   	leave  
801075a8:	c3                   	ret    

801075a9 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801075a9:	55                   	push   %ebp
801075aa:	89 e5                	mov    %esp,%ebp
801075ac:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801075af:	8b 45 0c             	mov    0xc(%ebp),%eax
801075b2:	c1 e8 16             	shr    $0x16,%eax
801075b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801075bc:	8b 45 08             	mov    0x8(%ebp),%eax
801075bf:	01 d0                	add    %edx,%eax
801075c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801075c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075c7:	8b 00                	mov    (%eax),%eax
801075c9:	83 e0 01             	and    $0x1,%eax
801075cc:	85 c0                	test   %eax,%eax
801075ce:	74 14                	je     801075e4 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075d3:	8b 00                	mov    (%eax),%eax
801075d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075da:	05 00 00 00 80       	add    $0x80000000,%eax
801075df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075e2:	eb 42                	jmp    80107626 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801075e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801075e8:	74 0e                	je     801075f8 <walkpgdir+0x4f>
801075ea:	e8 96 b1 ff ff       	call   80102785 <kalloc>
801075ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075f6:	75 07                	jne    801075ff <walkpgdir+0x56>
      return 0;
801075f8:	b8 00 00 00 00       	mov    $0x0,%eax
801075fd:	eb 3e                	jmp    8010763d <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801075ff:	83 ec 04             	sub    $0x4,%esp
80107602:	68 00 10 00 00       	push   $0x1000
80107607:	6a 00                	push   $0x0
80107609:	ff 75 f4             	push   -0xc(%ebp)
8010760c:	e8 20 d5 ff ff       	call   80104b31 <memset>
80107611:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107617:	05 00 00 00 80       	add    $0x80000000,%eax
8010761c:	83 c8 07             	or     $0x7,%eax
8010761f:	89 c2                	mov    %eax,%edx
80107621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107624:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107626:	8b 45 0c             	mov    0xc(%ebp),%eax
80107629:	c1 e8 0c             	shr    $0xc,%eax
8010762c:	25 ff 03 00 00       	and    $0x3ff,%eax
80107631:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763b:	01 d0                	add    %edx,%eax
}
8010763d:	c9                   	leave  
8010763e:	c3                   	ret    

8010763f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010763f:	55                   	push   %ebp
80107640:	89 e5                	mov    %esp,%ebp
80107642:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107645:	8b 45 0c             	mov    0xc(%ebp),%eax
80107648:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010764d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107650:	8b 55 0c             	mov    0xc(%ebp),%edx
80107653:	8b 45 10             	mov    0x10(%ebp),%eax
80107656:	01 d0                	add    %edx,%eax
80107658:	83 e8 01             	sub    $0x1,%eax
8010765b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107660:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107663:	83 ec 04             	sub    $0x4,%esp
80107666:	6a 01                	push   $0x1
80107668:	ff 75 f4             	push   -0xc(%ebp)
8010766b:	ff 75 08             	push   0x8(%ebp)
8010766e:	e8 36 ff ff ff       	call   801075a9 <walkpgdir>
80107673:	83 c4 10             	add    $0x10,%esp
80107676:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107679:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010767d:	75 07                	jne    80107686 <mappages+0x47>
      return -1;
8010767f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107684:	eb 47                	jmp    801076cd <mappages+0x8e>
    if(*pte & PTE_P)
80107686:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107689:	8b 00                	mov    (%eax),%eax
8010768b:	83 e0 01             	and    $0x1,%eax
8010768e:	85 c0                	test   %eax,%eax
80107690:	74 0d                	je     8010769f <mappages+0x60>
      panic("remap");
80107692:	83 ec 0c             	sub    $0xc,%esp
80107695:	68 cc aa 10 80       	push   $0x8010aacc
8010769a:	e8 0a 8f ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
8010769f:	8b 45 18             	mov    0x18(%ebp),%eax
801076a2:	0b 45 14             	or     0x14(%ebp),%eax
801076a5:	83 c8 01             	or     $0x1,%eax
801076a8:	89 c2                	mov    %eax,%edx
801076aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076ad:	89 10                	mov    %edx,(%eax)
    if(a == last)
801076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801076b5:	74 10                	je     801076c7 <mappages+0x88>
      break;
    a += PGSIZE;
801076b7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801076be:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801076c5:	eb 9c                	jmp    80107663 <mappages+0x24>
      break;
801076c7:	90                   	nop
  }
  return 0;
801076c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076cd:	c9                   	leave  
801076ce:	c3                   	ret    

801076cf <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801076cf:	55                   	push   %ebp
801076d0:	89 e5                	mov    %esp,%ebp
801076d2:	53                   	push   %ebx
801076d3:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801076d6:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801076dd:	8b 15 70 6e 19 80    	mov    0x80196e70,%edx
801076e3:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801076e8:	29 d0                	sub    %edx,%eax
801076ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076ed:	a1 68 6e 19 80       	mov    0x80196e68,%eax
801076f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076f5:	8b 15 68 6e 19 80    	mov    0x80196e68,%edx
801076fb:	a1 70 6e 19 80       	mov    0x80196e70,%eax
80107700:	01 d0                	add    %edx,%eax
80107702:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107705:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
8010770c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010770f:	83 c0 30             	add    $0x30,%eax
80107712:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107715:	89 10                	mov    %edx,(%eax)
80107717:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010771a:	89 50 04             	mov    %edx,0x4(%eax)
8010771d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107720:	89 50 08             	mov    %edx,0x8(%eax)
80107723:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107726:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107729:	e8 57 b0 ff ff       	call   80102785 <kalloc>
8010772e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107735:	75 07                	jne    8010773e <setupkvm+0x6f>
    return 0;
80107737:	b8 00 00 00 00       	mov    $0x0,%eax
8010773c:	eb 78                	jmp    801077b6 <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
8010773e:	83 ec 04             	sub    $0x4,%esp
80107741:	68 00 10 00 00       	push   $0x1000
80107746:	6a 00                	push   $0x0
80107748:	ff 75 f0             	push   -0x10(%ebp)
8010774b:	e8 e1 d3 ff ff       	call   80104b31 <memset>
80107750:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107753:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
8010775a:	eb 4e                	jmp    801077aa <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010775c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107765:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776b:	8b 58 08             	mov    0x8(%eax),%ebx
8010776e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107771:	8b 40 04             	mov    0x4(%eax),%eax
80107774:	29 c3                	sub    %eax,%ebx
80107776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107779:	8b 00                	mov    (%eax),%eax
8010777b:	83 ec 0c             	sub    $0xc,%esp
8010777e:	51                   	push   %ecx
8010777f:	52                   	push   %edx
80107780:	53                   	push   %ebx
80107781:	50                   	push   %eax
80107782:	ff 75 f0             	push   -0x10(%ebp)
80107785:	e8 b5 fe ff ff       	call   8010763f <mappages>
8010778a:	83 c4 20             	add    $0x20,%esp
8010778d:	85 c0                	test   %eax,%eax
8010778f:	79 15                	jns    801077a6 <setupkvm+0xd7>
      freevm(pgdir);
80107791:	83 ec 0c             	sub    $0xc,%esp
80107794:	ff 75 f0             	push   -0x10(%ebp)
80107797:	e8 f5 04 00 00       	call   80107c91 <freevm>
8010779c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010779f:	b8 00 00 00 00       	mov    $0x0,%eax
801077a4:	eb 10                	jmp    801077b6 <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801077aa:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
801077b1:	72 a9                	jb     8010775c <setupkvm+0x8d>
    }
  return pgdir;
801077b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801077b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801077b9:	c9                   	leave  
801077ba:	c3                   	ret    

801077bb <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801077bb:	55                   	push   %ebp
801077bc:	89 e5                	mov    %esp,%ebp
801077be:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077c1:	e8 09 ff ff ff       	call   801076cf <setupkvm>
801077c6:	a3 9c 6b 19 80       	mov    %eax,0x80196b9c
  switchkvm();
801077cb:	e8 03 00 00 00       	call   801077d3 <switchkvm>
}
801077d0:	90                   	nop
801077d1:	c9                   	leave  
801077d2:	c3                   	ret    

801077d3 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801077d3:	55                   	push   %ebp
801077d4:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077d6:	a1 9c 6b 19 80       	mov    0x80196b9c,%eax
801077db:	05 00 00 00 80       	add    $0x80000000,%eax
801077e0:	50                   	push   %eax
801077e1:	e8 61 fa ff ff       	call   80107247 <lcr3>
801077e6:	83 c4 04             	add    $0x4,%esp
}
801077e9:	90                   	nop
801077ea:	c9                   	leave  
801077eb:	c3                   	ret    

801077ec <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801077ec:	55                   	push   %ebp
801077ed:	89 e5                	mov    %esp,%ebp
801077ef:	56                   	push   %esi
801077f0:	53                   	push   %ebx
801077f1:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
801077f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801077f8:	75 0d                	jne    80107807 <switchuvm+0x1b>
    panic("switchuvm: no process");
801077fa:	83 ec 0c             	sub    $0xc,%esp
801077fd:	68 d2 aa 10 80       	push   $0x8010aad2
80107802:	e8 a2 8d ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
80107807:	8b 45 08             	mov    0x8(%ebp),%eax
8010780a:	8b 40 08             	mov    0x8(%eax),%eax
8010780d:	85 c0                	test   %eax,%eax
8010780f:	75 0d                	jne    8010781e <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107811:	83 ec 0c             	sub    $0xc,%esp
80107814:	68 e8 aa 10 80       	push   $0x8010aae8
80107819:	e8 8b 8d ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
8010781e:	8b 45 08             	mov    0x8(%ebp),%eax
80107821:	8b 40 04             	mov    0x4(%eax),%eax
80107824:	85 c0                	test   %eax,%eax
80107826:	75 0d                	jne    80107835 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107828:	83 ec 0c             	sub    $0xc,%esp
8010782b:	68 fd aa 10 80       	push   $0x8010aafd
80107830:	e8 74 8d ff ff       	call   801005a9 <panic>

  pushcli();
80107835:	e8 ec d1 ff ff       	call   80104a26 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010783a:	e8 5e c1 ff ff       	call   8010399d <mycpu>
8010783f:	89 c3                	mov    %eax,%ebx
80107841:	e8 57 c1 ff ff       	call   8010399d <mycpu>
80107846:	83 c0 08             	add    $0x8,%eax
80107849:	89 c6                	mov    %eax,%esi
8010784b:	e8 4d c1 ff ff       	call   8010399d <mycpu>
80107850:	83 c0 08             	add    $0x8,%eax
80107853:	c1 e8 10             	shr    $0x10,%eax
80107856:	88 45 f7             	mov    %al,-0x9(%ebp)
80107859:	e8 3f c1 ff ff       	call   8010399d <mycpu>
8010785e:	83 c0 08             	add    $0x8,%eax
80107861:	c1 e8 18             	shr    $0x18,%eax
80107864:	89 c2                	mov    %eax,%edx
80107866:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010786d:	67 00 
8010786f:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107876:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
8010787a:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107880:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107887:	83 e0 f0             	and    $0xfffffff0,%eax
8010788a:	83 c8 09             	or     $0x9,%eax
8010788d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107893:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010789a:	83 c8 10             	or     $0x10,%eax
8010789d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078a3:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078aa:	83 e0 9f             	and    $0xffffff9f,%eax
801078ad:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078b3:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078ba:	83 c8 80             	or     $0xffffff80,%eax
801078bd:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078c3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801078ca:	83 e0 f0             	and    $0xfffffff0,%eax
801078cd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801078d3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801078da:	83 e0 ef             	and    $0xffffffef,%eax
801078dd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801078e3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801078ea:	83 e0 df             	and    $0xffffffdf,%eax
801078ed:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801078f3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801078fa:	83 c8 40             	or     $0x40,%eax
801078fd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107903:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010790a:	83 e0 7f             	and    $0x7f,%eax
8010790d:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107913:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107919:	e8 7f c0 ff ff       	call   8010399d <mycpu>
8010791e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107925:	83 e2 ef             	and    $0xffffffef,%edx
80107928:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010792e:	e8 6a c0 ff ff       	call   8010399d <mycpu>
80107933:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107939:	8b 45 08             	mov    0x8(%ebp),%eax
8010793c:	8b 40 08             	mov    0x8(%eax),%eax
8010793f:	89 c3                	mov    %eax,%ebx
80107941:	e8 57 c0 ff ff       	call   8010399d <mycpu>
80107946:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
8010794c:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010794f:	e8 49 c0 ff ff       	call   8010399d <mycpu>
80107954:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
8010795a:	83 ec 0c             	sub    $0xc,%esp
8010795d:	6a 28                	push   $0x28
8010795f:	e8 cc f8 ff ff       	call   80107230 <ltr>
80107964:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107967:	8b 45 08             	mov    0x8(%ebp),%eax
8010796a:	8b 40 04             	mov    0x4(%eax),%eax
8010796d:	05 00 00 00 80       	add    $0x80000000,%eax
80107972:	83 ec 0c             	sub    $0xc,%esp
80107975:	50                   	push   %eax
80107976:	e8 cc f8 ff ff       	call   80107247 <lcr3>
8010797b:	83 c4 10             	add    $0x10,%esp
  popcli();
8010797e:	e8 f0 d0 ff ff       	call   80104a73 <popcli>
}
80107983:	90                   	nop
80107984:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107987:	5b                   	pop    %ebx
80107988:	5e                   	pop    %esi
80107989:	5d                   	pop    %ebp
8010798a:	c3                   	ret    

8010798b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010798b:	55                   	push   %ebp
8010798c:	89 e5                	mov    %esp,%ebp
8010798e:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107991:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107998:	76 0d                	jbe    801079a7 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010799a:	83 ec 0c             	sub    $0xc,%esp
8010799d:	68 11 ab 10 80       	push   $0x8010ab11
801079a2:	e8 02 8c ff ff       	call   801005a9 <panic>
  mem = kalloc();
801079a7:	e8 d9 ad ff ff       	call   80102785 <kalloc>
801079ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801079af:	83 ec 04             	sub    $0x4,%esp
801079b2:	68 00 10 00 00       	push   $0x1000
801079b7:	6a 00                	push   $0x0
801079b9:	ff 75 f4             	push   -0xc(%ebp)
801079bc:	e8 70 d1 ff ff       	call   80104b31 <memset>
801079c1:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c7:	05 00 00 00 80       	add    $0x80000000,%eax
801079cc:	83 ec 0c             	sub    $0xc,%esp
801079cf:	6a 06                	push   $0x6
801079d1:	50                   	push   %eax
801079d2:	68 00 10 00 00       	push   $0x1000
801079d7:	6a 00                	push   $0x0
801079d9:	ff 75 08             	push   0x8(%ebp)
801079dc:	e8 5e fc ff ff       	call   8010763f <mappages>
801079e1:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801079e4:	83 ec 04             	sub    $0x4,%esp
801079e7:	ff 75 10             	push   0x10(%ebp)
801079ea:	ff 75 0c             	push   0xc(%ebp)
801079ed:	ff 75 f4             	push   -0xc(%ebp)
801079f0:	e8 fb d1 ff ff       	call   80104bf0 <memmove>
801079f5:	83 c4 10             	add    $0x10,%esp
}
801079f8:	90                   	nop
801079f9:	c9                   	leave  
801079fa:	c3                   	ret    

801079fb <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801079fb:	55                   	push   %ebp
801079fc:	89 e5                	mov    %esp,%ebp
801079fe:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a01:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a04:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a09:	85 c0                	test   %eax,%eax
80107a0b:	74 0d                	je     80107a1a <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107a0d:	83 ec 0c             	sub    $0xc,%esp
80107a10:	68 2c ab 10 80       	push   $0x8010ab2c
80107a15:	e8 8f 8b ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a21:	e9 8f 00 00 00       	jmp    80107ab5 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a26:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2c:	01 d0                	add    %edx,%eax
80107a2e:	83 ec 04             	sub    $0x4,%esp
80107a31:	6a 00                	push   $0x0
80107a33:	50                   	push   %eax
80107a34:	ff 75 08             	push   0x8(%ebp)
80107a37:	e8 6d fb ff ff       	call   801075a9 <walkpgdir>
80107a3c:	83 c4 10             	add    $0x10,%esp
80107a3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a46:	75 0d                	jne    80107a55 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107a48:	83 ec 0c             	sub    $0xc,%esp
80107a4b:	68 4f ab 10 80       	push   $0x8010ab4f
80107a50:	e8 54 8b ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a58:	8b 00                	mov    (%eax),%eax
80107a5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107a62:	8b 45 18             	mov    0x18(%ebp),%eax
80107a65:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107a68:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107a6d:	77 0b                	ja     80107a7a <loaduvm+0x7f>
      n = sz - i;
80107a6f:	8b 45 18             	mov    0x18(%ebp),%eax
80107a72:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a78:	eb 07                	jmp    80107a81 <loaduvm+0x86>
    else
      n = PGSIZE;
80107a7a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a81:	8b 55 14             	mov    0x14(%ebp),%edx
80107a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a87:	01 d0                	add    %edx,%eax
80107a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107a8c:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a92:	ff 75 f0             	push   -0x10(%ebp)
80107a95:	50                   	push   %eax
80107a96:	52                   	push   %edx
80107a97:	ff 75 10             	push   0x10(%ebp)
80107a9a:	e8 1c a4 ff ff       	call   80101ebb <readi>
80107a9f:	83 c4 10             	add    $0x10,%esp
80107aa2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107aa5:	74 07                	je     80107aae <loaduvm+0xb3>
      return -1;
80107aa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107aac:	eb 18                	jmp    80107ac6 <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107aae:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab8:	3b 45 18             	cmp    0x18(%ebp),%eax
80107abb:	0f 82 65 ff ff ff    	jb     80107a26 <loaduvm+0x2b>
  }
  return 0;
80107ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ac6:	c9                   	leave  
80107ac7:	c3                   	ret    

80107ac8 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ac8:	55                   	push   %ebp
80107ac9:	89 e5                	mov    %esp,%ebp
80107acb:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107ace:	8b 45 10             	mov    0x10(%ebp),%eax
80107ad1:	85 c0                	test   %eax,%eax
80107ad3:	79 0a                	jns    80107adf <allocuvm+0x17>
    return 0;
80107ad5:	b8 00 00 00 00       	mov    $0x0,%eax
80107ada:	e9 ec 00 00 00       	jmp    80107bcb <allocuvm+0x103>
  if(newsz < oldsz)
80107adf:	8b 45 10             	mov    0x10(%ebp),%eax
80107ae2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ae5:	73 08                	jae    80107aef <allocuvm+0x27>
    return oldsz;
80107ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aea:	e9 dc 00 00 00       	jmp    80107bcb <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107aef:	8b 45 0c             	mov    0xc(%ebp),%eax
80107af2:	05 ff 0f 00 00       	add    $0xfff,%eax
80107af7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107aff:	e9 b8 00 00 00       	jmp    80107bbc <allocuvm+0xf4>
    mem = kalloc();
80107b04:	e8 7c ac ff ff       	call   80102785 <kalloc>
80107b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107b0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b10:	75 2e                	jne    80107b40 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107b12:	83 ec 0c             	sub    $0xc,%esp
80107b15:	68 6d ab 10 80       	push   $0x8010ab6d
80107b1a:	e8 d5 88 ff ff       	call   801003f4 <cprintf>
80107b1f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107b22:	83 ec 04             	sub    $0x4,%esp
80107b25:	ff 75 0c             	push   0xc(%ebp)
80107b28:	ff 75 10             	push   0x10(%ebp)
80107b2b:	ff 75 08             	push   0x8(%ebp)
80107b2e:	e8 9a 00 00 00       	call   80107bcd <deallocuvm>
80107b33:	83 c4 10             	add    $0x10,%esp
      return 0;
80107b36:	b8 00 00 00 00       	mov    $0x0,%eax
80107b3b:	e9 8b 00 00 00       	jmp    80107bcb <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107b40:	83 ec 04             	sub    $0x4,%esp
80107b43:	68 00 10 00 00       	push   $0x1000
80107b48:	6a 00                	push   $0x0
80107b4a:	ff 75 f0             	push   -0x10(%ebp)
80107b4d:	e8 df cf ff ff       	call   80104b31 <memset>
80107b52:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b58:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b61:	83 ec 0c             	sub    $0xc,%esp
80107b64:	6a 06                	push   $0x6
80107b66:	52                   	push   %edx
80107b67:	68 00 10 00 00       	push   $0x1000
80107b6c:	50                   	push   %eax
80107b6d:	ff 75 08             	push   0x8(%ebp)
80107b70:	e8 ca fa ff ff       	call   8010763f <mappages>
80107b75:	83 c4 20             	add    $0x20,%esp
80107b78:	85 c0                	test   %eax,%eax
80107b7a:	79 39                	jns    80107bb5 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107b7c:	83 ec 0c             	sub    $0xc,%esp
80107b7f:	68 85 ab 10 80       	push   $0x8010ab85
80107b84:	e8 6b 88 ff ff       	call   801003f4 <cprintf>
80107b89:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107b8c:	83 ec 04             	sub    $0x4,%esp
80107b8f:	ff 75 0c             	push   0xc(%ebp)
80107b92:	ff 75 10             	push   0x10(%ebp)
80107b95:	ff 75 08             	push   0x8(%ebp)
80107b98:	e8 30 00 00 00       	call   80107bcd <deallocuvm>
80107b9d:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107ba0:	83 ec 0c             	sub    $0xc,%esp
80107ba3:	ff 75 f0             	push   -0x10(%ebp)
80107ba6:	e8 40 ab ff ff       	call   801026eb <kfree>
80107bab:	83 c4 10             	add    $0x10,%esp
      return 0;
80107bae:	b8 00 00 00 00       	mov    $0x0,%eax
80107bb3:	eb 16                	jmp    80107bcb <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107bb5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbf:	3b 45 10             	cmp    0x10(%ebp),%eax
80107bc2:	0f 82 3c ff ff ff    	jb     80107b04 <allocuvm+0x3c>
    }
  }
  return newsz;
80107bc8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107bcb:	c9                   	leave  
80107bcc:	c3                   	ret    

80107bcd <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107bcd:	55                   	push   %ebp
80107bce:	89 e5                	mov    %esp,%ebp
80107bd0:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107bd3:	8b 45 10             	mov    0x10(%ebp),%eax
80107bd6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107bd9:	72 08                	jb     80107be3 <deallocuvm+0x16>
    return oldsz;
80107bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bde:	e9 ac 00 00 00       	jmp    80107c8f <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107be3:	8b 45 10             	mov    0x10(%ebp),%eax
80107be6:	05 ff 0f 00 00       	add    $0xfff,%eax
80107beb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107bf3:	e9 88 00 00 00       	jmp    80107c80 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfb:	83 ec 04             	sub    $0x4,%esp
80107bfe:	6a 00                	push   $0x0
80107c00:	50                   	push   %eax
80107c01:	ff 75 08             	push   0x8(%ebp)
80107c04:	e8 a0 f9 ff ff       	call   801075a9 <walkpgdir>
80107c09:	83 c4 10             	add    $0x10,%esp
80107c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107c0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c13:	75 16                	jne    80107c2b <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c18:	c1 e8 16             	shr    $0x16,%eax
80107c1b:	83 c0 01             	add    $0x1,%eax
80107c1e:	c1 e0 16             	shl    $0x16,%eax
80107c21:	2d 00 10 00 00       	sub    $0x1000,%eax
80107c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c29:	eb 4e                	jmp    80107c79 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c2e:	8b 00                	mov    (%eax),%eax
80107c30:	83 e0 01             	and    $0x1,%eax
80107c33:	85 c0                	test   %eax,%eax
80107c35:	74 42                	je     80107c79 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c3a:	8b 00                	mov    (%eax),%eax
80107c3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c41:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107c44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c48:	75 0d                	jne    80107c57 <deallocuvm+0x8a>
        panic("kfree");
80107c4a:	83 ec 0c             	sub    $0xc,%esp
80107c4d:	68 a1 ab 10 80       	push   $0x8010aba1
80107c52:	e8 52 89 ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c5a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107c62:	83 ec 0c             	sub    $0xc,%esp
80107c65:	ff 75 e8             	push   -0x18(%ebp)
80107c68:	e8 7e aa ff ff       	call   801026eb <kfree>
80107c6d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107c79:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c83:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c86:	0f 82 6c ff ff ff    	jb     80107bf8 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107c8c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107c8f:	c9                   	leave  
80107c90:	c3                   	ret    

80107c91 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c91:	55                   	push   %ebp
80107c92:	89 e5                	mov    %esp,%ebp
80107c94:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107c9b:	75 0d                	jne    80107caa <freevm+0x19>
    panic("freevm: no pgdir");
80107c9d:	83 ec 0c             	sub    $0xc,%esp
80107ca0:	68 a7 ab 10 80       	push   $0x8010aba7
80107ca5:	e8 ff 88 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107caa:	83 ec 04             	sub    $0x4,%esp
80107cad:	6a 00                	push   $0x0
80107caf:	68 00 00 00 80       	push   $0x80000000
80107cb4:	ff 75 08             	push   0x8(%ebp)
80107cb7:	e8 11 ff ff ff       	call   80107bcd <deallocuvm>
80107cbc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107cc6:	eb 48                	jmp    80107d10 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd5:	01 d0                	add    %edx,%eax
80107cd7:	8b 00                	mov    (%eax),%eax
80107cd9:	83 e0 01             	and    $0x1,%eax
80107cdc:	85 c0                	test   %eax,%eax
80107cde:	74 2c                	je     80107d0c <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107cea:	8b 45 08             	mov    0x8(%ebp),%eax
80107ced:	01 d0                	add    %edx,%eax
80107cef:	8b 00                	mov    (%eax),%eax
80107cf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cf6:	05 00 00 00 80       	add    $0x80000000,%eax
80107cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107cfe:	83 ec 0c             	sub    $0xc,%esp
80107d01:	ff 75 f0             	push   -0x10(%ebp)
80107d04:	e8 e2 a9 ff ff       	call   801026eb <kfree>
80107d09:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107d10:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107d17:	76 af                	jbe    80107cc8 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d19:	83 ec 0c             	sub    $0xc,%esp
80107d1c:	ff 75 08             	push   0x8(%ebp)
80107d1f:	e8 c7 a9 ff ff       	call   801026eb <kfree>
80107d24:	83 c4 10             	add    $0x10,%esp
}
80107d27:	90                   	nop
80107d28:	c9                   	leave  
80107d29:	c3                   	ret    

80107d2a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d2a:	55                   	push   %ebp
80107d2b:	89 e5                	mov    %esp,%ebp
80107d2d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d30:	83 ec 04             	sub    $0x4,%esp
80107d33:	6a 00                	push   $0x0
80107d35:	ff 75 0c             	push   0xc(%ebp)
80107d38:	ff 75 08             	push   0x8(%ebp)
80107d3b:	e8 69 f8 ff ff       	call   801075a9 <walkpgdir>
80107d40:	83 c4 10             	add    $0x10,%esp
80107d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d4a:	75 0d                	jne    80107d59 <clearpteu+0x2f>
    panic("clearpteu");
80107d4c:	83 ec 0c             	sub    $0xc,%esp
80107d4f:	68 b8 ab 10 80       	push   $0x8010abb8
80107d54:	e8 50 88 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5c:	8b 00                	mov    (%eax),%eax
80107d5e:	83 e0 fb             	and    $0xfffffffb,%eax
80107d61:	89 c2                	mov    %eax,%edx
80107d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d66:	89 10                	mov    %edx,(%eax)
}
80107d68:	90                   	nop
80107d69:	c9                   	leave  
80107d6a:	c3                   	ret    

80107d6b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107d6b:	55                   	push   %ebp
80107d6c:	89 e5                	mov    %esp,%ebp
80107d6e:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107d71:	e8 59 f9 ff ff       	call   801076cf <setupkvm>
80107d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d7d:	75 0a                	jne    80107d89 <copyuvm+0x1e>
    return 0;
80107d7f:	b8 00 00 00 00       	mov    $0x0,%eax
80107d84:	e9 b6 01 00 00       	jmp    80107f3f <copyuvm+0x1d4>
  for(i = 0; i < sz; i += PGSIZE){
80107d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107d90:	e9 af 00 00 00       	jmp    80107e44 <copyuvm+0xd9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d98:	83 ec 04             	sub    $0x4,%esp
80107d9b:	6a 00                	push   $0x0
80107d9d:	50                   	push   %eax
80107d9e:	ff 75 08             	push   0x8(%ebp)
80107da1:	e8 03 f8 ff ff       	call   801075a9 <walkpgdir>
80107da6:	83 c4 10             	add    $0x10,%esp
80107da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107dac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107db0:	0f 84 83 00 00 00    	je     80107e39 <copyuvm+0xce>
      continue;
    if(!(*pte & PTE_P))
80107db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107db9:	8b 00                	mov    (%eax),%eax
80107dbb:	83 e0 01             	and    $0x1,%eax
80107dbe:	85 c0                	test   %eax,%eax
80107dc0:	74 7a                	je     80107e3c <copyuvm+0xd1>
      continue;
    pa = PTE_ADDR(*pte);
80107dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dc5:	8b 00                	mov    (%eax),%eax
80107dc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80107dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dd2:	8b 00                	mov    (%eax),%eax
80107dd4:	25 ff 0f 00 00       	and    $0xfff,%eax
80107dd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107ddc:	e8 a4 a9 ff ff       	call   80102785 <kalloc>
80107de1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107de4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107de8:	0f 84 34 01 00 00    	je     80107f22 <copyuvm+0x1b7>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107df1:	05 00 00 00 80       	add    $0x80000000,%eax
80107df6:	83 ec 04             	sub    $0x4,%esp
80107df9:	68 00 10 00 00       	push   $0x1000
80107dfe:	50                   	push   %eax
80107dff:	ff 75 dc             	push   -0x24(%ebp)
80107e02:	e8 e9 cd ff ff       	call   80104bf0 <memmove>
80107e07:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107e0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107e10:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	83 ec 0c             	sub    $0xc,%esp
80107e1c:	52                   	push   %edx
80107e1d:	51                   	push   %ecx
80107e1e:	68 00 10 00 00       	push   $0x1000
80107e23:	50                   	push   %eax
80107e24:	ff 75 f0             	push   -0x10(%ebp)
80107e27:	e8 13 f8 ff ff       	call   8010763f <mappages>
80107e2c:	83 c4 20             	add    $0x20,%esp
80107e2f:	85 c0                	test   %eax,%eax
80107e31:	0f 88 ee 00 00 00    	js     80107f25 <copyuvm+0x1ba>
80107e37:	eb 04                	jmp    80107e3d <copyuvm+0xd2>
      continue;
80107e39:	90                   	nop
80107e3a:	eb 01                	jmp    80107e3d <copyuvm+0xd2>
      continue;
80107e3c:	90                   	nop
  for(i = 0; i < sz; i += PGSIZE){
80107e3d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e47:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e4a:	0f 82 45 ff ff ff    	jb     80107d95 <copyuvm+0x2a>
      goto bad;
  }
  
  
  
  uint t = KERNBASE-1;
80107e50:	c7 45 ec ff ff ff 7f 	movl   $0x7fffffff,-0x14(%ebp)
  t = PGROUNDDOWN(t);
80107e57:	81 65 ec 00 f0 ff ff 	andl   $0xfffff000,-0x14(%ebp)
  for(i = t; i > t - PGSIZE; i -= PGSIZE){
80107e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e64:	e9 a3 00 00 00       	jmp    80107f0c <copyuvm+0x1a1>
    
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6c:	83 ec 04             	sub    $0x4,%esp
80107e6f:	6a 00                	push   $0x0
80107e71:	50                   	push   %eax
80107e72:	ff 75 08             	push   0x8(%ebp)
80107e75:	e8 2f f7 ff ff       	call   801075a9 <walkpgdir>
80107e7a:	83 c4 10             	add    $0x10,%esp
80107e7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107e80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107e84:	74 7b                	je     80107f01 <copyuvm+0x196>
      continue;
    if(!(*pte & PTE_P))
80107e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e89:	8b 00                	mov    (%eax),%eax
80107e8b:	83 e0 01             	and    $0x1,%eax
80107e8e:	85 c0                	test   %eax,%eax
80107e90:	74 72                	je     80107f04 <copyuvm+0x199>
      continue;
    pa = PTE_ADDR(*pte);
80107e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e95:	8b 00                	mov    (%eax),%eax
80107e97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80107e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ea2:	8b 00                	mov    (%eax),%eax
80107ea4:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ea9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107eac:	e8 d4 a8 ff ff       	call   80102785 <kalloc>
80107eb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107eb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107eb8:	74 6e                	je     80107f28 <copyuvm+0x1bd>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ebd:	05 00 00 00 80       	add    $0x80000000,%eax
80107ec2:	83 ec 04             	sub    $0x4,%esp
80107ec5:	68 00 10 00 00       	push   $0x1000
80107eca:	50                   	push   %eax
80107ecb:	ff 75 dc             	push   -0x24(%ebp)
80107ece:	e8 1d cd ff ff       	call   80104bf0 <memmove>
80107ed3:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107ed6:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107edc:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee5:	83 ec 0c             	sub    $0xc,%esp
80107ee8:	52                   	push   %edx
80107ee9:	51                   	push   %ecx
80107eea:	68 00 10 00 00       	push   $0x1000
80107eef:	50                   	push   %eax
80107ef0:	ff 75 f0             	push   -0x10(%ebp)
80107ef3:	e8 47 f7 ff ff       	call   8010763f <mappages>
80107ef8:	83 c4 20             	add    $0x20,%esp
80107efb:	85 c0                	test   %eax,%eax
80107efd:	78 2c                	js     80107f2b <copyuvm+0x1c0>
80107eff:	eb 04                	jmp    80107f05 <copyuvm+0x19a>
      continue;
80107f01:	90                   	nop
80107f02:	eb 01                	jmp    80107f05 <copyuvm+0x19a>
      continue;
80107f04:	90                   	nop
  for(i = t; i > t - PGSIZE; i -= PGSIZE){
80107f05:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
80107f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f0f:	2d 00 10 00 00       	sub    $0x1000,%eax
80107f14:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107f17:	0f 87 4c ff ff ff    	ja     80107e69 <copyuvm+0xfe>
      goto bad;
  }
  
  return d;
80107f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f20:	eb 1d                	jmp    80107f3f <copyuvm+0x1d4>
      goto bad;
80107f22:	90                   	nop
80107f23:	eb 07                	jmp    80107f2c <copyuvm+0x1c1>
      goto bad;
80107f25:	90                   	nop
80107f26:	eb 04                	jmp    80107f2c <copyuvm+0x1c1>
      goto bad;
80107f28:	90                   	nop
80107f29:	eb 01                	jmp    80107f2c <copyuvm+0x1c1>
      goto bad;
80107f2b:	90                   	nop

bad:
  freevm(d);
80107f2c:	83 ec 0c             	sub    $0xc,%esp
80107f2f:	ff 75 f0             	push   -0x10(%ebp)
80107f32:	e8 5a fd ff ff       	call   80107c91 <freevm>
80107f37:	83 c4 10             	add    $0x10,%esp
  return 0;
80107f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f3f:	c9                   	leave  
80107f40:	c3                   	ret    

80107f41 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f41:	55                   	push   %ebp
80107f42:	89 e5                	mov    %esp,%ebp
80107f44:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f47:	83 ec 04             	sub    $0x4,%esp
80107f4a:	6a 00                	push   $0x0
80107f4c:	ff 75 0c             	push   0xc(%ebp)
80107f4f:	ff 75 08             	push   0x8(%ebp)
80107f52:	e8 52 f6 ff ff       	call   801075a9 <walkpgdir>
80107f57:	83 c4 10             	add    $0x10,%esp
80107f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f60:	8b 00                	mov    (%eax),%eax
80107f62:	83 e0 01             	and    $0x1,%eax
80107f65:	85 c0                	test   %eax,%eax
80107f67:	75 07                	jne    80107f70 <uva2ka+0x2f>
    return 0;
80107f69:	b8 00 00 00 00       	mov    $0x0,%eax
80107f6e:	eb 22                	jmp    80107f92 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	8b 00                	mov    (%eax),%eax
80107f75:	83 e0 04             	and    $0x4,%eax
80107f78:	85 c0                	test   %eax,%eax
80107f7a:	75 07                	jne    80107f83 <uva2ka+0x42>
    return 0;
80107f7c:	b8 00 00 00 00       	mov    $0x0,%eax
80107f81:	eb 0f                	jmp    80107f92 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f86:	8b 00                	mov    (%eax),%eax
80107f88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f8d:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107f92:	c9                   	leave  
80107f93:	c3                   	ret    

80107f94 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f94:	55                   	push   %ebp
80107f95:	89 e5                	mov    %esp,%ebp
80107f97:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107f9a:	8b 45 10             	mov    0x10(%ebp),%eax
80107f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107fa0:	eb 7f                	jmp    80108021 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fa5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107faa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fb0:	83 ec 08             	sub    $0x8,%esp
80107fb3:	50                   	push   %eax
80107fb4:	ff 75 08             	push   0x8(%ebp)
80107fb7:	e8 85 ff ff ff       	call   80107f41 <uva2ka>
80107fbc:	83 c4 10             	add    $0x10,%esp
80107fbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107fc2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107fc6:	75 07                	jne    80107fcf <copyout+0x3b>
      return -1;
80107fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fcd:	eb 61                	jmp    80108030 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fd2:	2b 45 0c             	sub    0xc(%ebp),%eax
80107fd5:	05 00 10 00 00       	add    $0x1000,%eax
80107fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fe0:	3b 45 14             	cmp    0x14(%ebp),%eax
80107fe3:	76 06                	jbe    80107feb <copyout+0x57>
      n = len;
80107fe5:	8b 45 14             	mov    0x14(%ebp),%eax
80107fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fee:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107ff1:	89 c2                	mov    %eax,%edx
80107ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ff6:	01 d0                	add    %edx,%eax
80107ff8:	83 ec 04             	sub    $0x4,%esp
80107ffb:	ff 75 f0             	push   -0x10(%ebp)
80107ffe:	ff 75 f4             	push   -0xc(%ebp)
80108001:	50                   	push   %eax
80108002:	e8 e9 cb ff ff       	call   80104bf0 <memmove>
80108007:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010800a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010800d:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108010:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108013:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108016:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108019:	05 00 10 00 00       	add    $0x1000,%eax
8010801e:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108021:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108025:	0f 85 77 ff ff ff    	jne    80107fa2 <copyout+0xe>
  }
  return 0;
8010802b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108030:	c9                   	leave  
80108031:	c3                   	ret    

80108032 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80108032:	55                   	push   %ebp
80108033:	89 e5                	mov    %esp,%ebp
80108035:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108038:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
8010803f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108042:	8b 40 08             	mov    0x8(%eax),%eax
80108045:	05 00 00 00 80       	add    $0x80000000,%eax
8010804a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
8010804d:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80108054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108057:	8b 40 24             	mov    0x24(%eax),%eax
8010805a:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
8010805f:	c7 05 60 6e 19 80 00 	movl   $0x0,0x80196e60
80108066:	00 00 00 

  while(i<madt->len){
80108069:	90                   	nop
8010806a:	e9 bd 00 00 00       	jmp    8010812c <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
8010806f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108072:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108075:	01 d0                	add    %edx,%eax
80108077:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
8010807a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010807d:	0f b6 00             	movzbl (%eax),%eax
80108080:	0f b6 c0             	movzbl %al,%eax
80108083:	83 f8 05             	cmp    $0x5,%eax
80108086:	0f 87 a0 00 00 00    	ja     8010812c <mpinit_uefi+0xfa>
8010808c:	8b 04 85 c4 ab 10 80 	mov    -0x7fef543c(,%eax,4),%eax
80108093:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80108095:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108098:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
8010809b:	a1 60 6e 19 80       	mov    0x80196e60,%eax
801080a0:	83 f8 03             	cmp    $0x3,%eax
801080a3:	7f 28                	jg     801080cd <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
801080a5:	8b 15 60 6e 19 80    	mov    0x80196e60,%edx
801080ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080ae:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801080b2:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
801080b8:	81 c2 a0 6b 19 80    	add    $0x80196ba0,%edx
801080be:	88 02                	mov    %al,(%edx)
          ncpu++;
801080c0:	a1 60 6e 19 80       	mov    0x80196e60,%eax
801080c5:	83 c0 01             	add    $0x1,%eax
801080c8:	a3 60 6e 19 80       	mov    %eax,0x80196e60
        }
        i += lapic_entry->record_len;
801080cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080d0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801080d4:	0f b6 c0             	movzbl %al,%eax
801080d7:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
801080da:	eb 50                	jmp    8010812c <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
801080dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
801080e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080e5:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801080e9:	a2 64 6e 19 80       	mov    %al,0x80196e64
        i += ioapic->record_len;
801080ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080f1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801080f5:	0f b6 c0             	movzbl %al,%eax
801080f8:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
801080fb:	eb 2f                	jmp    8010812c <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
801080fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108100:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80108103:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108106:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010810a:	0f b6 c0             	movzbl %al,%eax
8010810d:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108110:	eb 1a                	jmp    8010812c <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80108112:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108115:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80108118:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010811b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010811f:	0f b6 c0             	movzbl %al,%eax
80108122:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108125:	eb 05                	jmp    8010812c <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
80108127:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
8010812b:	90                   	nop
  while(i<madt->len){
8010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812f:	8b 40 04             	mov    0x4(%eax),%eax
80108132:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80108135:	0f 82 34 ff ff ff    	jb     8010806f <mpinit_uefi+0x3d>
    }
  }

}
8010813b:	90                   	nop
8010813c:	90                   	nop
8010813d:	c9                   	leave  
8010813e:	c3                   	ret    

8010813f <inb>:
{
8010813f:	55                   	push   %ebp
80108140:	89 e5                	mov    %esp,%ebp
80108142:	83 ec 14             	sub    $0x14,%esp
80108145:	8b 45 08             	mov    0x8(%ebp),%eax
80108148:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010814c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108150:	89 c2                	mov    %eax,%edx
80108152:	ec                   	in     (%dx),%al
80108153:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108156:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010815a:	c9                   	leave  
8010815b:	c3                   	ret    

8010815c <outb>:
{
8010815c:	55                   	push   %ebp
8010815d:	89 e5                	mov    %esp,%ebp
8010815f:	83 ec 08             	sub    $0x8,%esp
80108162:	8b 45 08             	mov    0x8(%ebp),%eax
80108165:	8b 55 0c             	mov    0xc(%ebp),%edx
80108168:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010816c:	89 d0                	mov    %edx,%eax
8010816e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108171:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108175:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108179:	ee                   	out    %al,(%dx)
}
8010817a:	90                   	nop
8010817b:	c9                   	leave  
8010817c:	c3                   	ret    

8010817d <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
8010817d:	55                   	push   %ebp
8010817e:	89 e5                	mov    %esp,%ebp
80108180:	83 ec 28             	sub    $0x28,%esp
80108183:	8b 45 08             	mov    0x8(%ebp),%eax
80108186:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80108189:	6a 00                	push   $0x0
8010818b:	68 fa 03 00 00       	push   $0x3fa
80108190:	e8 c7 ff ff ff       	call   8010815c <outb>
80108195:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108198:	68 80 00 00 00       	push   $0x80
8010819d:	68 fb 03 00 00       	push   $0x3fb
801081a2:	e8 b5 ff ff ff       	call   8010815c <outb>
801081a7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801081aa:	6a 0c                	push   $0xc
801081ac:	68 f8 03 00 00       	push   $0x3f8
801081b1:	e8 a6 ff ff ff       	call   8010815c <outb>
801081b6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801081b9:	6a 00                	push   $0x0
801081bb:	68 f9 03 00 00       	push   $0x3f9
801081c0:	e8 97 ff ff ff       	call   8010815c <outb>
801081c5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801081c8:	6a 03                	push   $0x3
801081ca:	68 fb 03 00 00       	push   $0x3fb
801081cf:	e8 88 ff ff ff       	call   8010815c <outb>
801081d4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801081d7:	6a 00                	push   $0x0
801081d9:	68 fc 03 00 00       	push   $0x3fc
801081de:	e8 79 ff ff ff       	call   8010815c <outb>
801081e3:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
801081e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081ed:	eb 11                	jmp    80108200 <uart_debug+0x83>
801081ef:	83 ec 0c             	sub    $0xc,%esp
801081f2:	6a 0a                	push   $0xa
801081f4:	e8 23 a9 ff ff       	call   80102b1c <microdelay>
801081f9:	83 c4 10             	add    $0x10,%esp
801081fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108200:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108204:	7f 1a                	jg     80108220 <uart_debug+0xa3>
80108206:	83 ec 0c             	sub    $0xc,%esp
80108209:	68 fd 03 00 00       	push   $0x3fd
8010820e:	e8 2c ff ff ff       	call   8010813f <inb>
80108213:	83 c4 10             	add    $0x10,%esp
80108216:	0f b6 c0             	movzbl %al,%eax
80108219:	83 e0 20             	and    $0x20,%eax
8010821c:	85 c0                	test   %eax,%eax
8010821e:	74 cf                	je     801081ef <uart_debug+0x72>
  outb(COM1+0, p);
80108220:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108224:	0f b6 c0             	movzbl %al,%eax
80108227:	83 ec 08             	sub    $0x8,%esp
8010822a:	50                   	push   %eax
8010822b:	68 f8 03 00 00       	push   $0x3f8
80108230:	e8 27 ff ff ff       	call   8010815c <outb>
80108235:	83 c4 10             	add    $0x10,%esp
}
80108238:	90                   	nop
80108239:	c9                   	leave  
8010823a:	c3                   	ret    

8010823b <uart_debugs>:

void uart_debugs(char *p){
8010823b:	55                   	push   %ebp
8010823c:	89 e5                	mov    %esp,%ebp
8010823e:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108241:	eb 1b                	jmp    8010825e <uart_debugs+0x23>
    uart_debug(*p++);
80108243:	8b 45 08             	mov    0x8(%ebp),%eax
80108246:	8d 50 01             	lea    0x1(%eax),%edx
80108249:	89 55 08             	mov    %edx,0x8(%ebp)
8010824c:	0f b6 00             	movzbl (%eax),%eax
8010824f:	0f be c0             	movsbl %al,%eax
80108252:	83 ec 0c             	sub    $0xc,%esp
80108255:	50                   	push   %eax
80108256:	e8 22 ff ff ff       	call   8010817d <uart_debug>
8010825b:	83 c4 10             	add    $0x10,%esp
  while(*p){
8010825e:	8b 45 08             	mov    0x8(%ebp),%eax
80108261:	0f b6 00             	movzbl (%eax),%eax
80108264:	84 c0                	test   %al,%al
80108266:	75 db                	jne    80108243 <uart_debugs+0x8>
  }
}
80108268:	90                   	nop
80108269:	90                   	nop
8010826a:	c9                   	leave  
8010826b:	c3                   	ret    

8010826c <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
8010826c:	55                   	push   %ebp
8010826d:	89 e5                	mov    %esp,%ebp
8010826f:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108272:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80108279:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010827c:	8b 50 14             	mov    0x14(%eax),%edx
8010827f:	8b 40 10             	mov    0x10(%eax),%eax
80108282:	a3 68 6e 19 80       	mov    %eax,0x80196e68
  gpu.vram_size = boot_param->graphic_config.frame_size;
80108287:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010828a:	8b 50 1c             	mov    0x1c(%eax),%edx
8010828d:	8b 40 18             	mov    0x18(%eax),%eax
80108290:	a3 70 6e 19 80       	mov    %eax,0x80196e70
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
80108295:	8b 15 70 6e 19 80    	mov    0x80196e70,%edx
8010829b:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801082a0:	29 d0                	sub    %edx,%eax
801082a2:	a3 6c 6e 19 80       	mov    %eax,0x80196e6c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801082a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082aa:	8b 50 24             	mov    0x24(%eax),%edx
801082ad:	8b 40 20             	mov    0x20(%eax),%eax
801082b0:	a3 74 6e 19 80       	mov    %eax,0x80196e74
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801082b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082b8:	8b 50 2c             	mov    0x2c(%eax),%edx
801082bb:	8b 40 28             	mov    0x28(%eax),%eax
801082be:	a3 78 6e 19 80       	mov    %eax,0x80196e78
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801082c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082c6:	8b 50 34             	mov    0x34(%eax),%edx
801082c9:	8b 40 30             	mov    0x30(%eax),%eax
801082cc:	a3 7c 6e 19 80       	mov    %eax,0x80196e7c
}
801082d1:	90                   	nop
801082d2:	c9                   	leave  
801082d3:	c3                   	ret    

801082d4 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
801082d4:	55                   	push   %ebp
801082d5:	89 e5                	mov    %esp,%ebp
801082d7:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
801082da:	8b 15 7c 6e 19 80    	mov    0x80196e7c,%edx
801082e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801082e3:	0f af d0             	imul   %eax,%edx
801082e6:	8b 45 08             	mov    0x8(%ebp),%eax
801082e9:	01 d0                	add    %edx,%eax
801082eb:	c1 e0 02             	shl    $0x2,%eax
801082ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
801082f1:	8b 15 6c 6e 19 80    	mov    0x80196e6c,%edx
801082f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082fa:	01 d0                	add    %edx,%eax
801082fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
801082ff:	8b 45 10             	mov    0x10(%ebp),%eax
80108302:	0f b6 10             	movzbl (%eax),%edx
80108305:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108308:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
8010830a:	8b 45 10             	mov    0x10(%ebp),%eax
8010830d:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108311:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108314:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108317:	8b 45 10             	mov    0x10(%ebp),%eax
8010831a:	0f b6 50 02          	movzbl 0x2(%eax),%edx
8010831e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108321:	88 50 02             	mov    %dl,0x2(%eax)
}
80108324:	90                   	nop
80108325:	c9                   	leave  
80108326:	c3                   	ret    

80108327 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108327:	55                   	push   %ebp
80108328:	89 e5                	mov    %esp,%ebp
8010832a:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
8010832d:	8b 15 7c 6e 19 80    	mov    0x80196e7c,%edx
80108333:	8b 45 08             	mov    0x8(%ebp),%eax
80108336:	0f af c2             	imul   %edx,%eax
80108339:	c1 e0 02             	shl    $0x2,%eax
8010833c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
8010833f:	a1 70 6e 19 80       	mov    0x80196e70,%eax
80108344:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108347:	29 d0                	sub    %edx,%eax
80108349:	8b 0d 6c 6e 19 80    	mov    0x80196e6c,%ecx
8010834f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108352:	01 ca                	add    %ecx,%edx
80108354:	89 d1                	mov    %edx,%ecx
80108356:	8b 15 6c 6e 19 80    	mov    0x80196e6c,%edx
8010835c:	83 ec 04             	sub    $0x4,%esp
8010835f:	50                   	push   %eax
80108360:	51                   	push   %ecx
80108361:	52                   	push   %edx
80108362:	e8 89 c8 ff ff       	call   80104bf0 <memmove>
80108367:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
8010836a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836d:	8b 0d 6c 6e 19 80    	mov    0x80196e6c,%ecx
80108373:	8b 15 70 6e 19 80    	mov    0x80196e70,%edx
80108379:	01 ca                	add    %ecx,%edx
8010837b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010837e:	29 ca                	sub    %ecx,%edx
80108380:	83 ec 04             	sub    $0x4,%esp
80108383:	50                   	push   %eax
80108384:	6a 00                	push   $0x0
80108386:	52                   	push   %edx
80108387:	e8 a5 c7 ff ff       	call   80104b31 <memset>
8010838c:	83 c4 10             	add    $0x10,%esp
}
8010838f:	90                   	nop
80108390:	c9                   	leave  
80108391:	c3                   	ret    

80108392 <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
80108392:	55                   	push   %ebp
80108393:	89 e5                	mov    %esp,%ebp
80108395:	53                   	push   %ebx
80108396:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
80108399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801083a0:	e9 b1 00 00 00       	jmp    80108456 <font_render+0xc4>
    for(int j=14;j>-1;j--){
801083a5:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801083ac:	e9 97 00 00 00       	jmp    80108448 <font_render+0xb6>
      bin = (font_bin[index-0x20][i])&(1 << j);
801083b1:	8b 45 10             	mov    0x10(%ebp),%eax
801083b4:	83 e8 20             	sub    $0x20,%eax
801083b7:	6b d0 1e             	imul   $0x1e,%eax,%edx
801083ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bd:	01 d0                	add    %edx,%eax
801083bf:	0f b7 84 00 e0 ab 10 	movzwl -0x7fef5420(%eax,%eax,1),%eax
801083c6:	80 
801083c7:	0f b7 d0             	movzwl %ax,%edx
801083ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083cd:	bb 01 00 00 00       	mov    $0x1,%ebx
801083d2:	89 c1                	mov    %eax,%ecx
801083d4:	d3 e3                	shl    %cl,%ebx
801083d6:	89 d8                	mov    %ebx,%eax
801083d8:	21 d0                	and    %edx,%eax
801083da:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
801083dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e0:	ba 01 00 00 00       	mov    $0x1,%edx
801083e5:	89 c1                	mov    %eax,%ecx
801083e7:	d3 e2                	shl    %cl,%edx
801083e9:	89 d0                	mov    %edx,%eax
801083eb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801083ee:	75 2b                	jne    8010841b <font_render+0x89>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
801083f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801083f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f6:	01 c2                	add    %eax,%edx
801083f8:	b8 0e 00 00 00       	mov    $0xe,%eax
801083fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108400:	89 c1                	mov    %eax,%ecx
80108402:	8b 45 08             	mov    0x8(%ebp),%eax
80108405:	01 c8                	add    %ecx,%eax
80108407:	83 ec 04             	sub    $0x4,%esp
8010840a:	68 e0 f4 10 80       	push   $0x8010f4e0
8010840f:	52                   	push   %edx
80108410:	50                   	push   %eax
80108411:	e8 be fe ff ff       	call   801082d4 <graphic_draw_pixel>
80108416:	83 c4 10             	add    $0x10,%esp
80108419:	eb 29                	jmp    80108444 <font_render+0xb2>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
8010841b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010841e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108421:	01 c2                	add    %eax,%edx
80108423:	b8 0e 00 00 00       	mov    $0xe,%eax
80108428:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010842b:	89 c1                	mov    %eax,%ecx
8010842d:	8b 45 08             	mov    0x8(%ebp),%eax
80108430:	01 c8                	add    %ecx,%eax
80108432:	83 ec 04             	sub    $0x4,%esp
80108435:	68 80 6e 19 80       	push   $0x80196e80
8010843a:	52                   	push   %edx
8010843b:	50                   	push   %eax
8010843c:	e8 93 fe ff ff       	call   801082d4 <graphic_draw_pixel>
80108441:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
80108444:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108448:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010844c:	0f 89 5f ff ff ff    	jns    801083b1 <font_render+0x1f>
  for(int i=0;i<30;i++){
80108452:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108456:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
8010845a:	0f 8e 45 ff ff ff    	jle    801083a5 <font_render+0x13>
      }
    }
  }
}
80108460:	90                   	nop
80108461:	90                   	nop
80108462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108465:	c9                   	leave  
80108466:	c3                   	ret    

80108467 <font_render_string>:

void font_render_string(char *string,int row){
80108467:	55                   	push   %ebp
80108468:	89 e5                	mov    %esp,%ebp
8010846a:	53                   	push   %ebx
8010846b:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
8010846e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
80108475:	eb 33                	jmp    801084aa <font_render_string+0x43>
    font_render(i*15+2,row*30,string[i]);
80108477:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010847a:	8b 45 08             	mov    0x8(%ebp),%eax
8010847d:	01 d0                	add    %edx,%eax
8010847f:	0f b6 00             	movzbl (%eax),%eax
80108482:	0f be c8             	movsbl %al,%ecx
80108485:	8b 45 0c             	mov    0xc(%ebp),%eax
80108488:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010848b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010848e:	89 d8                	mov    %ebx,%eax
80108490:	c1 e0 04             	shl    $0x4,%eax
80108493:	29 d8                	sub    %ebx,%eax
80108495:	83 c0 02             	add    $0x2,%eax
80108498:	83 ec 04             	sub    $0x4,%esp
8010849b:	51                   	push   %ecx
8010849c:	52                   	push   %edx
8010849d:	50                   	push   %eax
8010849e:	e8 ef fe ff ff       	call   80108392 <font_render>
801084a3:	83 c4 10             	add    $0x10,%esp
    i++;
801084a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
801084aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801084ad:	8b 45 08             	mov    0x8(%ebp),%eax
801084b0:	01 d0                	add    %edx,%eax
801084b2:	0f b6 00             	movzbl (%eax),%eax
801084b5:	84 c0                	test   %al,%al
801084b7:	74 06                	je     801084bf <font_render_string+0x58>
801084b9:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801084bd:	7e b8                	jle    80108477 <font_render_string+0x10>
  }
}
801084bf:	90                   	nop
801084c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084c3:	c9                   	leave  
801084c4:	c3                   	ret    

801084c5 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801084c5:	55                   	push   %ebp
801084c6:	89 e5                	mov    %esp,%ebp
801084c8:	53                   	push   %ebx
801084c9:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801084cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084d3:	eb 6b                	jmp    80108540 <pci_init+0x7b>
    for(int j=0;j<32;j++){
801084d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801084dc:	eb 58                	jmp    80108536 <pci_init+0x71>
      for(int k=0;k<8;k++){
801084de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801084e5:	eb 45                	jmp    8010852c <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801084e7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801084ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801084ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f0:	83 ec 0c             	sub    $0xc,%esp
801084f3:	8d 5d e8             	lea    -0x18(%ebp),%ebx
801084f6:	53                   	push   %ebx
801084f7:	6a 00                	push   $0x0
801084f9:	51                   	push   %ecx
801084fa:	52                   	push   %edx
801084fb:	50                   	push   %eax
801084fc:	e8 b0 00 00 00       	call   801085b1 <pci_access_config>
80108501:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108504:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108507:	0f b7 c0             	movzwl %ax,%eax
8010850a:	3d ff ff 00 00       	cmp    $0xffff,%eax
8010850f:	74 17                	je     80108528 <pci_init+0x63>
        pci_init_device(i,j,k);
80108511:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108514:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851a:	83 ec 04             	sub    $0x4,%esp
8010851d:	51                   	push   %ecx
8010851e:	52                   	push   %edx
8010851f:	50                   	push   %eax
80108520:	e8 37 01 00 00       	call   8010865c <pci_init_device>
80108525:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
80108528:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010852c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108530:	7e b5                	jle    801084e7 <pci_init+0x22>
    for(int j=0;j<32;j++){
80108532:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108536:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010853a:	7e a2                	jle    801084de <pci_init+0x19>
  for(int i=0;i<256;i++){
8010853c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108540:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108547:	7e 8c                	jle    801084d5 <pci_init+0x10>
      }
      }
    }
  }
}
80108549:	90                   	nop
8010854a:	90                   	nop
8010854b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010854e:	c9                   	leave  
8010854f:	c3                   	ret    

80108550 <pci_write_config>:

void pci_write_config(uint config){
80108550:	55                   	push   %ebp
80108551:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
80108553:	8b 45 08             	mov    0x8(%ebp),%eax
80108556:	ba f8 0c 00 00       	mov    $0xcf8,%edx
8010855b:	89 c0                	mov    %eax,%eax
8010855d:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010855e:	90                   	nop
8010855f:	5d                   	pop    %ebp
80108560:	c3                   	ret    

80108561 <pci_write_data>:

void pci_write_data(uint config){
80108561:	55                   	push   %ebp
80108562:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108564:	8b 45 08             	mov    0x8(%ebp),%eax
80108567:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010856c:	89 c0                	mov    %eax,%eax
8010856e:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010856f:	90                   	nop
80108570:	5d                   	pop    %ebp
80108571:	c3                   	ret    

80108572 <pci_read_config>:
uint pci_read_config(){
80108572:	55                   	push   %ebp
80108573:	89 e5                	mov    %esp,%ebp
80108575:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
80108578:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010857d:	ed                   	in     (%dx),%eax
8010857e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
80108581:	83 ec 0c             	sub    $0xc,%esp
80108584:	68 c8 00 00 00       	push   $0xc8
80108589:	e8 8e a5 ff ff       	call   80102b1c <microdelay>
8010858e:	83 c4 10             	add    $0x10,%esp
  return data;
80108591:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80108594:	c9                   	leave  
80108595:	c3                   	ret    

80108596 <pci_test>:


void pci_test(){
80108596:	55                   	push   %ebp
80108597:	89 e5                	mov    %esp,%ebp
80108599:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
8010859c:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801085a3:	ff 75 fc             	push   -0x4(%ebp)
801085a6:	e8 a5 ff ff ff       	call   80108550 <pci_write_config>
801085ab:	83 c4 04             	add    $0x4,%esp
}
801085ae:	90                   	nop
801085af:	c9                   	leave  
801085b0:	c3                   	ret    

801085b1 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801085b1:	55                   	push   %ebp
801085b2:	89 e5                	mov    %esp,%ebp
801085b4:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801085b7:	8b 45 08             	mov    0x8(%ebp),%eax
801085ba:	c1 e0 10             	shl    $0x10,%eax
801085bd:	25 00 00 ff 00       	and    $0xff0000,%eax
801085c2:	89 c2                	mov    %eax,%edx
801085c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801085c7:	c1 e0 0b             	shl    $0xb,%eax
801085ca:	0f b7 c0             	movzwl %ax,%eax
801085cd:	09 c2                	or     %eax,%edx
801085cf:	8b 45 10             	mov    0x10(%ebp),%eax
801085d2:	c1 e0 08             	shl    $0x8,%eax
801085d5:	25 00 07 00 00       	and    $0x700,%eax
801085da:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801085dc:	8b 45 14             	mov    0x14(%ebp),%eax
801085df:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801085e4:	09 d0                	or     %edx,%eax
801085e6:	0d 00 00 00 80       	or     $0x80000000,%eax
801085eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
801085ee:	ff 75 f4             	push   -0xc(%ebp)
801085f1:	e8 5a ff ff ff       	call   80108550 <pci_write_config>
801085f6:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
801085f9:	e8 74 ff ff ff       	call   80108572 <pci_read_config>
801085fe:	8b 55 18             	mov    0x18(%ebp),%edx
80108601:	89 02                	mov    %eax,(%edx)
}
80108603:	90                   	nop
80108604:	c9                   	leave  
80108605:	c3                   	ret    

80108606 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108606:	55                   	push   %ebp
80108607:	89 e5                	mov    %esp,%ebp
80108609:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010860c:	8b 45 08             	mov    0x8(%ebp),%eax
8010860f:	c1 e0 10             	shl    $0x10,%eax
80108612:	25 00 00 ff 00       	and    $0xff0000,%eax
80108617:	89 c2                	mov    %eax,%edx
80108619:	8b 45 0c             	mov    0xc(%ebp),%eax
8010861c:	c1 e0 0b             	shl    $0xb,%eax
8010861f:	0f b7 c0             	movzwl %ax,%eax
80108622:	09 c2                	or     %eax,%edx
80108624:	8b 45 10             	mov    0x10(%ebp),%eax
80108627:	c1 e0 08             	shl    $0x8,%eax
8010862a:	25 00 07 00 00       	and    $0x700,%eax
8010862f:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108631:	8b 45 14             	mov    0x14(%ebp),%eax
80108634:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108639:	09 d0                	or     %edx,%eax
8010863b:	0d 00 00 00 80       	or     $0x80000000,%eax
80108640:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108643:	ff 75 fc             	push   -0x4(%ebp)
80108646:	e8 05 ff ff ff       	call   80108550 <pci_write_config>
8010864b:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
8010864e:	ff 75 18             	push   0x18(%ebp)
80108651:	e8 0b ff ff ff       	call   80108561 <pci_write_data>
80108656:	83 c4 04             	add    $0x4,%esp
}
80108659:	90                   	nop
8010865a:	c9                   	leave  
8010865b:	c3                   	ret    

8010865c <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
8010865c:	55                   	push   %ebp
8010865d:	89 e5                	mov    %esp,%ebp
8010865f:	53                   	push   %ebx
80108660:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
80108663:	8b 45 08             	mov    0x8(%ebp),%eax
80108666:	a2 84 6e 19 80       	mov    %al,0x80196e84
  dev.device_num = device_num;
8010866b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010866e:	a2 85 6e 19 80       	mov    %al,0x80196e85
  dev.function_num = function_num;
80108673:	8b 45 10             	mov    0x10(%ebp),%eax
80108676:	a2 86 6e 19 80       	mov    %al,0x80196e86
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
8010867b:	ff 75 10             	push   0x10(%ebp)
8010867e:	ff 75 0c             	push   0xc(%ebp)
80108681:	ff 75 08             	push   0x8(%ebp)
80108684:	68 24 c2 10 80       	push   $0x8010c224
80108689:	e8 66 7d ff ff       	call   801003f4 <cprintf>
8010868e:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
80108691:	83 ec 0c             	sub    $0xc,%esp
80108694:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108697:	50                   	push   %eax
80108698:	6a 00                	push   $0x0
8010869a:	ff 75 10             	push   0x10(%ebp)
8010869d:	ff 75 0c             	push   0xc(%ebp)
801086a0:	ff 75 08             	push   0x8(%ebp)
801086a3:	e8 09 ff ff ff       	call   801085b1 <pci_access_config>
801086a8:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801086ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086ae:	c1 e8 10             	shr    $0x10,%eax
801086b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801086b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086b7:	25 ff ff 00 00       	and    $0xffff,%eax
801086bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801086bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c2:	a3 88 6e 19 80       	mov    %eax,0x80196e88
  dev.vendor_id = vendor_id;
801086c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ca:	a3 8c 6e 19 80       	mov    %eax,0x80196e8c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
801086cf:	83 ec 04             	sub    $0x4,%esp
801086d2:	ff 75 f0             	push   -0x10(%ebp)
801086d5:	ff 75 f4             	push   -0xc(%ebp)
801086d8:	68 58 c2 10 80       	push   $0x8010c258
801086dd:	e8 12 7d ff ff       	call   801003f4 <cprintf>
801086e2:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801086e5:	83 ec 0c             	sub    $0xc,%esp
801086e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801086eb:	50                   	push   %eax
801086ec:	6a 08                	push   $0x8
801086ee:	ff 75 10             	push   0x10(%ebp)
801086f1:	ff 75 0c             	push   0xc(%ebp)
801086f4:	ff 75 08             	push   0x8(%ebp)
801086f7:	e8 b5 fe ff ff       	call   801085b1 <pci_access_config>
801086fc:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
801086ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108702:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108705:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108708:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010870b:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010870e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108711:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108714:	0f b6 c0             	movzbl %al,%eax
80108717:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010871a:	c1 eb 18             	shr    $0x18,%ebx
8010871d:	83 ec 0c             	sub    $0xc,%esp
80108720:	51                   	push   %ecx
80108721:	52                   	push   %edx
80108722:	50                   	push   %eax
80108723:	53                   	push   %ebx
80108724:	68 7c c2 10 80       	push   $0x8010c27c
80108729:	e8 c6 7c ff ff       	call   801003f4 <cprintf>
8010872e:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108731:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108734:	c1 e8 18             	shr    $0x18,%eax
80108737:	a2 90 6e 19 80       	mov    %al,0x80196e90
  dev.sub_class = (data>>16)&0xFF;
8010873c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010873f:	c1 e8 10             	shr    $0x10,%eax
80108742:	a2 91 6e 19 80       	mov    %al,0x80196e91
  dev.interface = (data>>8)&0xFF;
80108747:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010874a:	c1 e8 08             	shr    $0x8,%eax
8010874d:	a2 92 6e 19 80       	mov    %al,0x80196e92
  dev.revision_id = data&0xFF;
80108752:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108755:	a2 93 6e 19 80       	mov    %al,0x80196e93
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
8010875a:	83 ec 0c             	sub    $0xc,%esp
8010875d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108760:	50                   	push   %eax
80108761:	6a 10                	push   $0x10
80108763:	ff 75 10             	push   0x10(%ebp)
80108766:	ff 75 0c             	push   0xc(%ebp)
80108769:	ff 75 08             	push   0x8(%ebp)
8010876c:	e8 40 fe ff ff       	call   801085b1 <pci_access_config>
80108771:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
80108774:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108777:	a3 94 6e 19 80       	mov    %eax,0x80196e94
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
8010877c:	83 ec 0c             	sub    $0xc,%esp
8010877f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108782:	50                   	push   %eax
80108783:	6a 14                	push   $0x14
80108785:	ff 75 10             	push   0x10(%ebp)
80108788:	ff 75 0c             	push   0xc(%ebp)
8010878b:	ff 75 08             	push   0x8(%ebp)
8010878e:	e8 1e fe ff ff       	call   801085b1 <pci_access_config>
80108793:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108796:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108799:	a3 98 6e 19 80       	mov    %eax,0x80196e98
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
8010879e:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801087a5:	75 5a                	jne    80108801 <pci_init_device+0x1a5>
801087a7:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801087ae:	75 51                	jne    80108801 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801087b0:	83 ec 0c             	sub    $0xc,%esp
801087b3:	68 c1 c2 10 80       	push   $0x8010c2c1
801087b8:	e8 37 7c ff ff       	call   801003f4 <cprintf>
801087bd:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
801087c0:	83 ec 0c             	sub    $0xc,%esp
801087c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801087c6:	50                   	push   %eax
801087c7:	68 f0 00 00 00       	push   $0xf0
801087cc:	ff 75 10             	push   0x10(%ebp)
801087cf:	ff 75 0c             	push   0xc(%ebp)
801087d2:	ff 75 08             	push   0x8(%ebp)
801087d5:	e8 d7 fd ff ff       	call   801085b1 <pci_access_config>
801087da:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
801087dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087e0:	83 ec 08             	sub    $0x8,%esp
801087e3:	50                   	push   %eax
801087e4:	68 db c2 10 80       	push   $0x8010c2db
801087e9:	e8 06 7c ff ff       	call   801003f4 <cprintf>
801087ee:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
801087f1:	83 ec 0c             	sub    $0xc,%esp
801087f4:	68 84 6e 19 80       	push   $0x80196e84
801087f9:	e8 09 00 00 00       	call   80108807 <i8254_init>
801087fe:	83 c4 10             	add    $0x10,%esp
  }
}
80108801:	90                   	nop
80108802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108805:	c9                   	leave  
80108806:	c3                   	ret    

80108807 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108807:	55                   	push   %ebp
80108808:	89 e5                	mov    %esp,%ebp
8010880a:	53                   	push   %ebx
8010880b:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
8010880e:	8b 45 08             	mov    0x8(%ebp),%eax
80108811:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108815:	0f b6 c8             	movzbl %al,%ecx
80108818:	8b 45 08             	mov    0x8(%ebp),%eax
8010881b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010881f:	0f b6 d0             	movzbl %al,%edx
80108822:	8b 45 08             	mov    0x8(%ebp),%eax
80108825:	0f b6 00             	movzbl (%eax),%eax
80108828:	0f b6 c0             	movzbl %al,%eax
8010882b:	83 ec 0c             	sub    $0xc,%esp
8010882e:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108831:	53                   	push   %ebx
80108832:	6a 04                	push   $0x4
80108834:	51                   	push   %ecx
80108835:	52                   	push   %edx
80108836:	50                   	push   %eax
80108837:	e8 75 fd ff ff       	call   801085b1 <pci_access_config>
8010883c:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
8010883f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108842:	83 c8 04             	or     $0x4,%eax
80108845:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108848:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010884b:	8b 45 08             	mov    0x8(%ebp),%eax
8010884e:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108852:	0f b6 c8             	movzbl %al,%ecx
80108855:	8b 45 08             	mov    0x8(%ebp),%eax
80108858:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010885c:	0f b6 d0             	movzbl %al,%edx
8010885f:	8b 45 08             	mov    0x8(%ebp),%eax
80108862:	0f b6 00             	movzbl (%eax),%eax
80108865:	0f b6 c0             	movzbl %al,%eax
80108868:	83 ec 0c             	sub    $0xc,%esp
8010886b:	53                   	push   %ebx
8010886c:	6a 04                	push   $0x4
8010886e:	51                   	push   %ecx
8010886f:	52                   	push   %edx
80108870:	50                   	push   %eax
80108871:	e8 90 fd ff ff       	call   80108606 <pci_write_config_register>
80108876:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108879:	8b 45 08             	mov    0x8(%ebp),%eax
8010887c:	8b 40 10             	mov    0x10(%eax),%eax
8010887f:	05 00 00 00 40       	add    $0x40000000,%eax
80108884:	a3 9c 6e 19 80       	mov    %eax,0x80196e9c
  uint *ctrl = (uint *)base_addr;
80108889:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
8010888e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
80108891:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108896:	05 d8 00 00 00       	add    $0xd8,%eax
8010889b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
8010889e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088a1:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801088a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088aa:	8b 00                	mov    (%eax),%eax
801088ac:	0d 00 00 00 04       	or     $0x4000000,%eax
801088b1:	89 c2                	mov    %eax,%edx
801088b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b6:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801088b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088bb:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
801088c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c4:	8b 00                	mov    (%eax),%eax
801088c6:	83 c8 40             	or     $0x40,%eax
801088c9:	89 c2                	mov    %eax,%edx
801088cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ce:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
801088d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d3:	8b 10                	mov    (%eax),%edx
801088d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d8:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
801088da:	83 ec 0c             	sub    $0xc,%esp
801088dd:	68 f0 c2 10 80       	push   $0x8010c2f0
801088e2:	e8 0d 7b ff ff       	call   801003f4 <cprintf>
801088e7:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
801088ea:	e8 96 9e ff ff       	call   80102785 <kalloc>
801088ef:	a3 a8 6e 19 80       	mov    %eax,0x80196ea8
  *intr_addr = 0;
801088f4:	a1 a8 6e 19 80       	mov    0x80196ea8,%eax
801088f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
801088ff:	a1 a8 6e 19 80       	mov    0x80196ea8,%eax
80108904:	83 ec 08             	sub    $0x8,%esp
80108907:	50                   	push   %eax
80108908:	68 12 c3 10 80       	push   $0x8010c312
8010890d:	e8 e2 7a ff ff       	call   801003f4 <cprintf>
80108912:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108915:	e8 50 00 00 00       	call   8010896a <i8254_init_recv>
  i8254_init_send();
8010891a:	e8 69 03 00 00       	call   80108c88 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
8010891f:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108926:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108929:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108930:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108933:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010893a:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
8010893d:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108944:	0f b6 c0             	movzbl %al,%eax
80108947:	83 ec 0c             	sub    $0xc,%esp
8010894a:	53                   	push   %ebx
8010894b:	51                   	push   %ecx
8010894c:	52                   	push   %edx
8010894d:	50                   	push   %eax
8010894e:	68 20 c3 10 80       	push   $0x8010c320
80108953:	e8 9c 7a ff ff       	call   801003f4 <cprintf>
80108958:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
8010895b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010895e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108964:	90                   	nop
80108965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108968:	c9                   	leave  
80108969:	c3                   	ret    

8010896a <i8254_init_recv>:

void i8254_init_recv(){
8010896a:	55                   	push   %ebp
8010896b:	89 e5                	mov    %esp,%ebp
8010896d:	57                   	push   %edi
8010896e:	56                   	push   %esi
8010896f:	53                   	push   %ebx
80108970:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108973:	83 ec 0c             	sub    $0xc,%esp
80108976:	6a 00                	push   $0x0
80108978:	e8 e8 04 00 00       	call   80108e65 <i8254_read_eeprom>
8010897d:	83 c4 10             	add    $0x10,%esp
80108980:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108983:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108986:	a2 a0 6e 19 80       	mov    %al,0x80196ea0
  mac_addr[1] = data_l>>8;
8010898b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010898e:	c1 e8 08             	shr    $0x8,%eax
80108991:	a2 a1 6e 19 80       	mov    %al,0x80196ea1
  uint data_m = i8254_read_eeprom(0x1);
80108996:	83 ec 0c             	sub    $0xc,%esp
80108999:	6a 01                	push   $0x1
8010899b:	e8 c5 04 00 00       	call   80108e65 <i8254_read_eeprom>
801089a0:	83 c4 10             	add    $0x10,%esp
801089a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801089a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801089a9:	a2 a2 6e 19 80       	mov    %al,0x80196ea2
  mac_addr[3] = data_m>>8;
801089ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801089b1:	c1 e8 08             	shr    $0x8,%eax
801089b4:	a2 a3 6e 19 80       	mov    %al,0x80196ea3
  uint data_h = i8254_read_eeprom(0x2);
801089b9:	83 ec 0c             	sub    $0xc,%esp
801089bc:	6a 02                	push   $0x2
801089be:	e8 a2 04 00 00       	call   80108e65 <i8254_read_eeprom>
801089c3:	83 c4 10             	add    $0x10,%esp
801089c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
801089c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089cc:	a2 a4 6e 19 80       	mov    %al,0x80196ea4
  mac_addr[5] = data_h>>8;
801089d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089d4:	c1 e8 08             	shr    $0x8,%eax
801089d7:	a2 a5 6e 19 80       	mov    %al,0x80196ea5
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
801089dc:	0f b6 05 a5 6e 19 80 	movzbl 0x80196ea5,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801089e3:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
801089e6:	0f b6 05 a4 6e 19 80 	movzbl 0x80196ea4,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801089ed:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
801089f0:	0f b6 05 a3 6e 19 80 	movzbl 0x80196ea3,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801089f7:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
801089fa:	0f b6 05 a2 6e 19 80 	movzbl 0x80196ea2,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a01:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108a04:	0f b6 05 a1 6e 19 80 	movzbl 0x80196ea1,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a0b:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108a0e:	0f b6 05 a0 6e 19 80 	movzbl 0x80196ea0,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a15:	0f b6 c0             	movzbl %al,%eax
80108a18:	83 ec 04             	sub    $0x4,%esp
80108a1b:	57                   	push   %edi
80108a1c:	56                   	push   %esi
80108a1d:	53                   	push   %ebx
80108a1e:	51                   	push   %ecx
80108a1f:	52                   	push   %edx
80108a20:	50                   	push   %eax
80108a21:	68 38 c3 10 80       	push   $0x8010c338
80108a26:	e8 c9 79 ff ff       	call   801003f4 <cprintf>
80108a2b:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108a2e:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108a33:	05 00 54 00 00       	add    $0x5400,%eax
80108a38:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108a3b:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108a40:	05 04 54 00 00       	add    $0x5404,%eax
80108a45:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108a4b:	c1 e0 10             	shl    $0x10,%eax
80108a4e:	0b 45 d8             	or     -0x28(%ebp),%eax
80108a51:	89 c2                	mov    %eax,%edx
80108a53:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108a56:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108a58:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a5b:	0d 00 00 00 80       	or     $0x80000000,%eax
80108a60:	89 c2                	mov    %eax,%edx
80108a62:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108a65:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108a67:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108a6c:	05 00 52 00 00       	add    $0x5200,%eax
80108a71:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108a74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108a7b:	eb 19                	jmp    80108a96 <i8254_init_recv+0x12c>
    mta[i] = 0;
80108a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108a8a:	01 d0                	add    %edx,%eax
80108a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108a92:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108a96:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108a9a:	7e e1                	jle    80108a7d <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108a9c:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108aa1:	05 d0 00 00 00       	add    $0xd0,%eax
80108aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108aac:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108ab2:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108ab7:	05 c8 00 00 00       	add    $0xc8,%eax
80108abc:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108abf:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108ac2:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108ac8:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108acd:	05 28 28 00 00       	add    $0x2828,%eax
80108ad2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108ade:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108ae3:	05 00 01 00 00       	add    $0x100,%eax
80108ae8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108aeb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108aee:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108af4:	e8 8c 9c ff ff       	call   80102785 <kalloc>
80108af9:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108afc:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108b01:	05 00 28 00 00       	add    $0x2800,%eax
80108b06:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108b09:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108b0e:	05 04 28 00 00       	add    $0x2804,%eax
80108b13:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108b16:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108b1b:	05 08 28 00 00       	add    $0x2808,%eax
80108b20:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108b23:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108b28:	05 10 28 00 00       	add    $0x2810,%eax
80108b2d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108b30:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108b35:	05 18 28 00 00       	add    $0x2818,%eax
80108b3a:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108b3d:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108b40:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108b46:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108b49:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108b4b:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108b57:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108b5d:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108b66:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108b69:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108b6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108b72:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108b75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108b7c:	eb 73                	jmp    80108bf1 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b81:	c1 e0 04             	shl    $0x4,%eax
80108b84:	89 c2                	mov    %eax,%edx
80108b86:	8b 45 98             	mov    -0x68(%ebp),%eax
80108b89:	01 d0                	add    %edx,%eax
80108b8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108b92:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b95:	c1 e0 04             	shl    $0x4,%eax
80108b98:	89 c2                	mov    %eax,%edx
80108b9a:	8b 45 98             	mov    -0x68(%ebp),%eax
80108b9d:	01 d0                	add    %edx,%eax
80108b9f:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ba8:	c1 e0 04             	shl    $0x4,%eax
80108bab:	89 c2                	mov    %eax,%edx
80108bad:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bb0:	01 d0                	add    %edx,%eax
80108bb2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bbb:	c1 e0 04             	shl    $0x4,%eax
80108bbe:	89 c2                	mov    %eax,%edx
80108bc0:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bc3:	01 d0                	add    %edx,%eax
80108bc5:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108bc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bcc:	c1 e0 04             	shl    $0x4,%eax
80108bcf:	89 c2                	mov    %eax,%edx
80108bd1:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bd4:	01 d0                	add    %edx,%eax
80108bd6:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bdd:	c1 e0 04             	shl    $0x4,%eax
80108be0:	89 c2                	mov    %eax,%edx
80108be2:	8b 45 98             	mov    -0x68(%ebp),%eax
80108be5:	01 d0                	add    %edx,%eax
80108be7:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108bed:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108bf1:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108bf8:	7e 84                	jle    80108b7e <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108bfa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108c01:	eb 57                	jmp    80108c5a <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108c03:	e8 7d 9b ff ff       	call   80102785 <kalloc>
80108c08:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108c0b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108c0f:	75 12                	jne    80108c23 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108c11:	83 ec 0c             	sub    $0xc,%esp
80108c14:	68 58 c3 10 80       	push   $0x8010c358
80108c19:	e8 d6 77 ff ff       	call   801003f4 <cprintf>
80108c1e:	83 c4 10             	add    $0x10,%esp
      break;
80108c21:	eb 3d                	jmp    80108c60 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108c23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c26:	c1 e0 04             	shl    $0x4,%eax
80108c29:	89 c2                	mov    %eax,%edx
80108c2b:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c2e:	01 d0                	add    %edx,%eax
80108c30:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108c33:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c39:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c3e:	83 c0 01             	add    $0x1,%eax
80108c41:	c1 e0 04             	shl    $0x4,%eax
80108c44:	89 c2                	mov    %eax,%edx
80108c46:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c49:	01 d0                	add    %edx,%eax
80108c4b:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108c4e:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108c54:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108c56:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108c5a:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108c5e:	7e a3                	jle    80108c03 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108c60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108c63:	8b 00                	mov    (%eax),%eax
80108c65:	83 c8 02             	or     $0x2,%eax
80108c68:	89 c2                	mov    %eax,%edx
80108c6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108c6d:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108c6f:	83 ec 0c             	sub    $0xc,%esp
80108c72:	68 78 c3 10 80       	push   $0x8010c378
80108c77:	e8 78 77 ff ff       	call   801003f4 <cprintf>
80108c7c:	83 c4 10             	add    $0x10,%esp
}
80108c7f:	90                   	nop
80108c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c83:	5b                   	pop    %ebx
80108c84:	5e                   	pop    %esi
80108c85:	5f                   	pop    %edi
80108c86:	5d                   	pop    %ebp
80108c87:	c3                   	ret    

80108c88 <i8254_init_send>:

void i8254_init_send(){
80108c88:	55                   	push   %ebp
80108c89:	89 e5                	mov    %esp,%ebp
80108c8b:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108c8e:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108c93:	05 28 38 00 00       	add    $0x3828,%eax
80108c98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c9e:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108ca4:	e8 dc 9a ff ff       	call   80102785 <kalloc>
80108ca9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108cac:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108cb1:	05 00 38 00 00       	add    $0x3800,%eax
80108cb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108cb9:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108cbe:	05 04 38 00 00       	add    $0x3804,%eax
80108cc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108cc6:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108ccb:	05 08 38 00 00       	add    $0x3808,%eax
80108cd0:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108cd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cd6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108cdf:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ce4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108cea:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108ced:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108cf3:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108cf8:	05 10 38 00 00       	add    $0x3810,%eax
80108cfd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108d00:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108d05:	05 18 38 00 00       	add    $0x3818,%eax
80108d0a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108d0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108d16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108d19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d22:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108d25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108d2c:	e9 82 00 00 00       	jmp    80108db3 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d34:	c1 e0 04             	shl    $0x4,%eax
80108d37:	89 c2                	mov    %eax,%edx
80108d39:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d3c:	01 d0                	add    %edx,%eax
80108d3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d48:	c1 e0 04             	shl    $0x4,%eax
80108d4b:	89 c2                	mov    %eax,%edx
80108d4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d50:	01 d0                	add    %edx,%eax
80108d52:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5b:	c1 e0 04             	shl    $0x4,%eax
80108d5e:	89 c2                	mov    %eax,%edx
80108d60:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d63:	01 d0                	add    %edx,%eax
80108d65:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d6c:	c1 e0 04             	shl    $0x4,%eax
80108d6f:	89 c2                	mov    %eax,%edx
80108d71:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d74:	01 d0                	add    %edx,%eax
80108d76:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d7d:	c1 e0 04             	shl    $0x4,%eax
80108d80:	89 c2                	mov    %eax,%edx
80108d82:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d85:	01 d0                	add    %edx,%eax
80108d87:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8e:	c1 e0 04             	shl    $0x4,%eax
80108d91:	89 c2                	mov    %eax,%edx
80108d93:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d96:	01 d0                	add    %edx,%eax
80108d98:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9f:	c1 e0 04             	shl    $0x4,%eax
80108da2:	89 c2                	mov    %eax,%edx
80108da4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108da7:	01 d0                	add    %edx,%eax
80108da9:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108daf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108db3:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108dba:	0f 8e 71 ff ff ff    	jle    80108d31 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108dc0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108dc7:	eb 57                	jmp    80108e20 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108dc9:	e8 b7 99 ff ff       	call   80102785 <kalloc>
80108dce:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108dd1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108dd5:	75 12                	jne    80108de9 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108dd7:	83 ec 0c             	sub    $0xc,%esp
80108dda:	68 58 c3 10 80       	push   $0x8010c358
80108ddf:	e8 10 76 ff ff       	call   801003f4 <cprintf>
80108de4:	83 c4 10             	add    $0x10,%esp
      break;
80108de7:	eb 3d                	jmp    80108e26 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dec:	c1 e0 04             	shl    $0x4,%eax
80108def:	89 c2                	mov    %eax,%edx
80108df1:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108df4:	01 d0                	add    %edx,%eax
80108df6:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108df9:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108dff:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e04:	83 c0 01             	add    $0x1,%eax
80108e07:	c1 e0 04             	shl    $0x4,%eax
80108e0a:	89 c2                	mov    %eax,%edx
80108e0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e0f:	01 d0                	add    %edx,%eax
80108e11:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108e14:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108e1a:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108e1c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108e20:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108e24:	7e a3                	jle    80108dc9 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108e26:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108e2b:	05 00 04 00 00       	add    $0x400,%eax
80108e30:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108e33:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108e36:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108e3c:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108e41:	05 10 04 00 00       	add    $0x410,%eax
80108e46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108e49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108e4c:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108e52:	83 ec 0c             	sub    $0xc,%esp
80108e55:	68 98 c3 10 80       	push   $0x8010c398
80108e5a:	e8 95 75 ff ff       	call   801003f4 <cprintf>
80108e5f:	83 c4 10             	add    $0x10,%esp

}
80108e62:	90                   	nop
80108e63:	c9                   	leave  
80108e64:	c3                   	ret    

80108e65 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108e65:	55                   	push   %ebp
80108e66:	89 e5                	mov    %esp,%ebp
80108e68:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108e6b:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108e70:	83 c0 14             	add    $0x14,%eax
80108e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108e76:	8b 45 08             	mov    0x8(%ebp),%eax
80108e79:	c1 e0 08             	shl    $0x8,%eax
80108e7c:	0f b7 c0             	movzwl %ax,%eax
80108e7f:	83 c8 01             	or     $0x1,%eax
80108e82:	89 c2                	mov    %eax,%edx
80108e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e87:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108e89:	83 ec 0c             	sub    $0xc,%esp
80108e8c:	68 b8 c3 10 80       	push   $0x8010c3b8
80108e91:	e8 5e 75 ff ff       	call   801003f4 <cprintf>
80108e96:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e9c:	8b 00                	mov    (%eax),%eax
80108e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ea4:	83 e0 10             	and    $0x10,%eax
80108ea7:	85 c0                	test   %eax,%eax
80108ea9:	75 02                	jne    80108ead <i8254_read_eeprom+0x48>
  while(1){
80108eab:	eb dc                	jmp    80108e89 <i8254_read_eeprom+0x24>
      break;
80108ead:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb1:	8b 00                	mov    (%eax),%eax
80108eb3:	c1 e8 10             	shr    $0x10,%eax
}
80108eb6:	c9                   	leave  
80108eb7:	c3                   	ret    

80108eb8 <i8254_recv>:
void i8254_recv(){
80108eb8:	55                   	push   %ebp
80108eb9:	89 e5                	mov    %esp,%ebp
80108ebb:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108ebe:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108ec3:	05 10 28 00 00       	add    $0x2810,%eax
80108ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108ecb:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108ed0:	05 18 28 00 00       	add    $0x2818,%eax
80108ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108ed8:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108edd:	05 00 28 00 00       	add    $0x2800,%eax
80108ee2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ee8:	8b 00                	mov    (%eax),%eax
80108eea:	05 00 00 00 80       	add    $0x80000000,%eax
80108eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef5:	8b 10                	mov    (%eax),%edx
80108ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108efa:	8b 08                	mov    (%eax),%ecx
80108efc:	89 d0                	mov    %edx,%eax
80108efe:	29 c8                	sub    %ecx,%eax
80108f00:	25 ff 00 00 00       	and    $0xff,%eax
80108f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108f0c:	7e 37                	jle    80108f45 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f11:	8b 00                	mov    (%eax),%eax
80108f13:	c1 e0 04             	shl    $0x4,%eax
80108f16:	89 c2                	mov    %eax,%edx
80108f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f1b:	01 d0                	add    %edx,%eax
80108f1d:	8b 00                	mov    (%eax),%eax
80108f1f:	05 00 00 00 80       	add    $0x80000000,%eax
80108f24:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f2a:	8b 00                	mov    (%eax),%eax
80108f2c:	83 c0 01             	add    $0x1,%eax
80108f2f:	0f b6 d0             	movzbl %al,%edx
80108f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f35:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108f37:	83 ec 0c             	sub    $0xc,%esp
80108f3a:	ff 75 e0             	push   -0x20(%ebp)
80108f3d:	e8 15 09 00 00       	call   80109857 <eth_proc>
80108f42:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f48:	8b 10                	mov    (%eax),%edx
80108f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4d:	8b 00                	mov    (%eax),%eax
80108f4f:	39 c2                	cmp    %eax,%edx
80108f51:	75 9f                	jne    80108ef2 <i8254_recv+0x3a>
      (*rdt)--;
80108f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f56:	8b 00                	mov    (%eax),%eax
80108f58:	8d 50 ff             	lea    -0x1(%eax),%edx
80108f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f5e:	89 10                	mov    %edx,(%eax)
  while(1){
80108f60:	eb 90                	jmp    80108ef2 <i8254_recv+0x3a>

80108f62 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108f62:	55                   	push   %ebp
80108f63:	89 e5                	mov    %esp,%ebp
80108f65:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108f68:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108f6d:	05 10 38 00 00       	add    $0x3810,%eax
80108f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108f75:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108f7a:	05 18 38 00 00       	add    $0x3818,%eax
80108f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108f82:	a1 9c 6e 19 80       	mov    0x80196e9c,%eax
80108f87:	05 00 38 00 00       	add    $0x3800,%eax
80108f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f92:	8b 00                	mov    (%eax),%eax
80108f94:	05 00 00 00 80       	add    $0x80000000,%eax
80108f99:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f9f:	8b 10                	mov    (%eax),%edx
80108fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fa4:	8b 08                	mov    (%eax),%ecx
80108fa6:	89 d0                	mov    %edx,%eax
80108fa8:	29 c8                	sub    %ecx,%eax
80108faa:	0f b6 d0             	movzbl %al,%edx
80108fad:	b8 00 01 00 00       	mov    $0x100,%eax
80108fb2:	29 d0                	sub    %edx,%eax
80108fb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fba:	8b 00                	mov    (%eax),%eax
80108fbc:	25 ff 00 00 00       	and    $0xff,%eax
80108fc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108fc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108fc8:	0f 8e a8 00 00 00    	jle    80109076 <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108fce:	8b 45 08             	mov    0x8(%ebp),%eax
80108fd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108fd4:	89 d1                	mov    %edx,%ecx
80108fd6:	c1 e1 04             	shl    $0x4,%ecx
80108fd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108fdc:	01 ca                	add    %ecx,%edx
80108fde:	8b 12                	mov    (%edx),%edx
80108fe0:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108fe6:	83 ec 04             	sub    $0x4,%esp
80108fe9:	ff 75 0c             	push   0xc(%ebp)
80108fec:	50                   	push   %eax
80108fed:	52                   	push   %edx
80108fee:	e8 fd bb ff ff       	call   80104bf0 <memmove>
80108ff3:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108ff6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ff9:	c1 e0 04             	shl    $0x4,%eax
80108ffc:	89 c2                	mov    %eax,%edx
80108ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109001:	01 d0                	add    %edx,%eax
80109003:	8b 55 0c             	mov    0xc(%ebp),%edx
80109006:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
8010900a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010900d:	c1 e0 04             	shl    $0x4,%eax
80109010:	89 c2                	mov    %eax,%edx
80109012:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109015:	01 d0                	add    %edx,%eax
80109017:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
8010901b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010901e:	c1 e0 04             	shl    $0x4,%eax
80109021:	89 c2                	mov    %eax,%edx
80109023:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109026:	01 d0                	add    %edx,%eax
80109028:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
8010902c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010902f:	c1 e0 04             	shl    $0x4,%eax
80109032:	89 c2                	mov    %eax,%edx
80109034:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109037:	01 d0                	add    %edx,%eax
80109039:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
8010903d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109040:	c1 e0 04             	shl    $0x4,%eax
80109043:	89 c2                	mov    %eax,%edx
80109045:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109048:	01 d0                	add    %edx,%eax
8010904a:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80109050:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109053:	c1 e0 04             	shl    $0x4,%eax
80109056:	89 c2                	mov    %eax,%edx
80109058:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010905b:	01 d0                	add    %edx,%eax
8010905d:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80109061:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109064:	8b 00                	mov    (%eax),%eax
80109066:	83 c0 01             	add    $0x1,%eax
80109069:	0f b6 d0             	movzbl %al,%edx
8010906c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010906f:	89 10                	mov    %edx,(%eax)
    return len;
80109071:	8b 45 0c             	mov    0xc(%ebp),%eax
80109074:	eb 05                	jmp    8010907b <i8254_send+0x119>
  }else{
    return -1;
80109076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010907b:	c9                   	leave  
8010907c:	c3                   	ret    

8010907d <i8254_intr>:

void i8254_intr(){
8010907d:	55                   	push   %ebp
8010907e:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80109080:	a1 a8 6e 19 80       	mov    0x80196ea8,%eax
80109085:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
8010908b:	90                   	nop
8010908c:	5d                   	pop    %ebp
8010908d:	c3                   	ret    

8010908e <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
8010908e:	55                   	push   %ebp
8010908f:	89 e5                	mov    %esp,%ebp
80109091:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80109094:	8b 45 08             	mov    0x8(%ebp),%eax
80109097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
8010909a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909d:	0f b7 00             	movzwl (%eax),%eax
801090a0:	66 3d 00 01          	cmp    $0x100,%ax
801090a4:	74 0a                	je     801090b0 <arp_proc+0x22>
801090a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090ab:	e9 4f 01 00 00       	jmp    801091ff <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
801090b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090b3:	0f b7 40 02          	movzwl 0x2(%eax),%eax
801090b7:	66 83 f8 08          	cmp    $0x8,%ax
801090bb:	74 0a                	je     801090c7 <arp_proc+0x39>
801090bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090c2:	e9 38 01 00 00       	jmp    801091ff <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
801090c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ca:	0f b6 40 04          	movzbl 0x4(%eax),%eax
801090ce:	3c 06                	cmp    $0x6,%al
801090d0:	74 0a                	je     801090dc <arp_proc+0x4e>
801090d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090d7:	e9 23 01 00 00       	jmp    801091ff <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
801090dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090df:	0f b6 40 05          	movzbl 0x5(%eax),%eax
801090e3:	3c 04                	cmp    $0x4,%al
801090e5:	74 0a                	je     801090f1 <arp_proc+0x63>
801090e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090ec:	e9 0e 01 00 00       	jmp    801091ff <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
801090f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f4:	83 c0 18             	add    $0x18,%eax
801090f7:	83 ec 04             	sub    $0x4,%esp
801090fa:	6a 04                	push   $0x4
801090fc:	50                   	push   %eax
801090fd:	68 e4 f4 10 80       	push   $0x8010f4e4
80109102:	e8 91 ba ff ff       	call   80104b98 <memcmp>
80109107:	83 c4 10             	add    $0x10,%esp
8010910a:	85 c0                	test   %eax,%eax
8010910c:	74 27                	je     80109135 <arp_proc+0xa7>
8010910e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109111:	83 c0 0e             	add    $0xe,%eax
80109114:	83 ec 04             	sub    $0x4,%esp
80109117:	6a 04                	push   $0x4
80109119:	50                   	push   %eax
8010911a:	68 e4 f4 10 80       	push   $0x8010f4e4
8010911f:	e8 74 ba ff ff       	call   80104b98 <memcmp>
80109124:	83 c4 10             	add    $0x10,%esp
80109127:	85 c0                	test   %eax,%eax
80109129:	74 0a                	je     80109135 <arp_proc+0xa7>
8010912b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109130:	e9 ca 00 00 00       	jmp    801091ff <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80109135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109138:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010913c:	66 3d 00 01          	cmp    $0x100,%ax
80109140:	75 69                	jne    801091ab <arp_proc+0x11d>
80109142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109145:	83 c0 18             	add    $0x18,%eax
80109148:	83 ec 04             	sub    $0x4,%esp
8010914b:	6a 04                	push   $0x4
8010914d:	50                   	push   %eax
8010914e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109153:	e8 40 ba ff ff       	call   80104b98 <memcmp>
80109158:	83 c4 10             	add    $0x10,%esp
8010915b:	85 c0                	test   %eax,%eax
8010915d:	75 4c                	jne    801091ab <arp_proc+0x11d>
    uint send = (uint)kalloc();
8010915f:	e8 21 96 ff ff       	call   80102785 <kalloc>
80109164:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80109167:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
8010916e:	83 ec 04             	sub    $0x4,%esp
80109171:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109174:	50                   	push   %eax
80109175:	ff 75 f0             	push   -0x10(%ebp)
80109178:	ff 75 f4             	push   -0xc(%ebp)
8010917b:	e8 1f 04 00 00       	call   8010959f <arp_reply_pkt_create>
80109180:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80109183:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109186:	83 ec 08             	sub    $0x8,%esp
80109189:	50                   	push   %eax
8010918a:	ff 75 f0             	push   -0x10(%ebp)
8010918d:	e8 d0 fd ff ff       	call   80108f62 <i8254_send>
80109192:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80109195:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109198:	83 ec 0c             	sub    $0xc,%esp
8010919b:	50                   	push   %eax
8010919c:	e8 4a 95 ff ff       	call   801026eb <kfree>
801091a1:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
801091a4:	b8 02 00 00 00       	mov    $0x2,%eax
801091a9:	eb 54                	jmp    801091ff <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
801091ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ae:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801091b2:	66 3d 00 02          	cmp    $0x200,%ax
801091b6:	75 42                	jne    801091fa <arp_proc+0x16c>
801091b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091bb:	83 c0 18             	add    $0x18,%eax
801091be:	83 ec 04             	sub    $0x4,%esp
801091c1:	6a 04                	push   $0x4
801091c3:	50                   	push   %eax
801091c4:	68 e4 f4 10 80       	push   $0x8010f4e4
801091c9:	e8 ca b9 ff ff       	call   80104b98 <memcmp>
801091ce:	83 c4 10             	add    $0x10,%esp
801091d1:	85 c0                	test   %eax,%eax
801091d3:	75 25                	jne    801091fa <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
801091d5:	83 ec 0c             	sub    $0xc,%esp
801091d8:	68 bc c3 10 80       	push   $0x8010c3bc
801091dd:	e8 12 72 ff ff       	call   801003f4 <cprintf>
801091e2:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
801091e5:	83 ec 0c             	sub    $0xc,%esp
801091e8:	ff 75 f4             	push   -0xc(%ebp)
801091eb:	e8 af 01 00 00       	call   8010939f <arp_table_update>
801091f0:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
801091f3:	b8 01 00 00 00       	mov    $0x1,%eax
801091f8:	eb 05                	jmp    801091ff <arp_proc+0x171>
  }else{
    return -1;
801091fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801091ff:	c9                   	leave  
80109200:	c3                   	ret    

80109201 <arp_scan>:

void arp_scan(){
80109201:	55                   	push   %ebp
80109202:	89 e5                	mov    %esp,%ebp
80109204:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80109207:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010920e:	eb 6f                	jmp    8010927f <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109210:	e8 70 95 ff ff       	call   80102785 <kalloc>
80109215:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80109218:	83 ec 04             	sub    $0x4,%esp
8010921b:	ff 75 f4             	push   -0xc(%ebp)
8010921e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109221:	50                   	push   %eax
80109222:	ff 75 ec             	push   -0x14(%ebp)
80109225:	e8 62 00 00 00       	call   8010928c <arp_broadcast>
8010922a:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
8010922d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109230:	83 ec 08             	sub    $0x8,%esp
80109233:	50                   	push   %eax
80109234:	ff 75 ec             	push   -0x14(%ebp)
80109237:	e8 26 fd ff ff       	call   80108f62 <i8254_send>
8010923c:	83 c4 10             	add    $0x10,%esp
8010923f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109242:	eb 22                	jmp    80109266 <arp_scan+0x65>
      microdelay(1);
80109244:	83 ec 0c             	sub    $0xc,%esp
80109247:	6a 01                	push   $0x1
80109249:	e8 ce 98 ff ff       	call   80102b1c <microdelay>
8010924e:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109251:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109254:	83 ec 08             	sub    $0x8,%esp
80109257:	50                   	push   %eax
80109258:	ff 75 ec             	push   -0x14(%ebp)
8010925b:	e8 02 fd ff ff       	call   80108f62 <i8254_send>
80109260:	83 c4 10             	add    $0x10,%esp
80109263:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109266:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
8010926a:	74 d8                	je     80109244 <arp_scan+0x43>
    }
    kfree((char *)send);
8010926c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010926f:	83 ec 0c             	sub    $0xc,%esp
80109272:	50                   	push   %eax
80109273:	e8 73 94 ff ff       	call   801026eb <kfree>
80109278:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
8010927b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010927f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80109286:	7e 88                	jle    80109210 <arp_scan+0xf>
  }
}
80109288:	90                   	nop
80109289:	90                   	nop
8010928a:	c9                   	leave  
8010928b:	c3                   	ret    

8010928c <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
8010928c:	55                   	push   %ebp
8010928d:	89 e5                	mov    %esp,%ebp
8010928f:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
80109292:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80109296:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
8010929a:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
8010929e:	8b 45 10             	mov    0x10(%ebp),%eax
801092a1:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801092a4:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801092ab:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801092b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801092b8:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801092be:	8b 45 0c             	mov    0xc(%ebp),%eax
801092c1:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801092c7:	8b 45 08             	mov    0x8(%ebp),%eax
801092ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801092cd:	8b 45 08             	mov    0x8(%ebp),%eax
801092d0:	83 c0 0e             	add    $0xe,%eax
801092d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
801092d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092d9:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801092dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e0:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
801092e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e7:	83 ec 04             	sub    $0x4,%esp
801092ea:	6a 06                	push   $0x6
801092ec:	8d 55 e6             	lea    -0x1a(%ebp),%edx
801092ef:	52                   	push   %edx
801092f0:	50                   	push   %eax
801092f1:	e8 fa b8 ff ff       	call   80104bf0 <memmove>
801092f6:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801092f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092fc:	83 c0 06             	add    $0x6,%eax
801092ff:	83 ec 04             	sub    $0x4,%esp
80109302:	6a 06                	push   $0x6
80109304:	68 a0 6e 19 80       	push   $0x80196ea0
80109309:	50                   	push   %eax
8010930a:	e8 e1 b8 ff ff       	call   80104bf0 <memmove>
8010930f:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109315:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010931a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010931d:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109323:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109326:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010932a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010932d:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109334:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
8010933a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010933d:	8d 50 12             	lea    0x12(%eax),%edx
80109340:	83 ec 04             	sub    $0x4,%esp
80109343:	6a 06                	push   $0x6
80109345:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109348:	50                   	push   %eax
80109349:	52                   	push   %edx
8010934a:	e8 a1 b8 ff ff       	call   80104bf0 <memmove>
8010934f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109355:	8d 50 18             	lea    0x18(%eax),%edx
80109358:	83 ec 04             	sub    $0x4,%esp
8010935b:	6a 04                	push   $0x4
8010935d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109360:	50                   	push   %eax
80109361:	52                   	push   %edx
80109362:	e8 89 b8 ff ff       	call   80104bf0 <memmove>
80109367:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010936a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010936d:	83 c0 08             	add    $0x8,%eax
80109370:	83 ec 04             	sub    $0x4,%esp
80109373:	6a 06                	push   $0x6
80109375:	68 a0 6e 19 80       	push   $0x80196ea0
8010937a:	50                   	push   %eax
8010937b:	e8 70 b8 ff ff       	call   80104bf0 <memmove>
80109380:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109383:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109386:	83 c0 0e             	add    $0xe,%eax
80109389:	83 ec 04             	sub    $0x4,%esp
8010938c:	6a 04                	push   $0x4
8010938e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109393:	50                   	push   %eax
80109394:	e8 57 b8 ff ff       	call   80104bf0 <memmove>
80109399:	83 c4 10             	add    $0x10,%esp
}
8010939c:	90                   	nop
8010939d:	c9                   	leave  
8010939e:	c3                   	ret    

8010939f <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
8010939f:	55                   	push   %ebp
801093a0:	89 e5                	mov    %esp,%ebp
801093a2:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801093a5:	8b 45 08             	mov    0x8(%ebp),%eax
801093a8:	83 c0 0e             	add    $0xe,%eax
801093ab:	83 ec 0c             	sub    $0xc,%esp
801093ae:	50                   	push   %eax
801093af:	e8 bc 00 00 00       	call   80109470 <arp_table_search>
801093b4:	83 c4 10             	add    $0x10,%esp
801093b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801093ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801093be:	78 2d                	js     801093ed <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801093c0:	8b 45 08             	mov    0x8(%ebp),%eax
801093c3:	8d 48 08             	lea    0x8(%eax),%ecx
801093c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801093c9:	89 d0                	mov    %edx,%eax
801093cb:	c1 e0 02             	shl    $0x2,%eax
801093ce:	01 d0                	add    %edx,%eax
801093d0:	01 c0                	add    %eax,%eax
801093d2:	01 d0                	add    %edx,%eax
801093d4:	05 c0 6e 19 80       	add    $0x80196ec0,%eax
801093d9:	83 c0 04             	add    $0x4,%eax
801093dc:	83 ec 04             	sub    $0x4,%esp
801093df:	6a 06                	push   $0x6
801093e1:	51                   	push   %ecx
801093e2:	50                   	push   %eax
801093e3:	e8 08 b8 ff ff       	call   80104bf0 <memmove>
801093e8:	83 c4 10             	add    $0x10,%esp
801093eb:	eb 70                	jmp    8010945d <arp_table_update+0xbe>
  }else{
    index += 1;
801093ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
801093f1:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801093f4:	8b 45 08             	mov    0x8(%ebp),%eax
801093f7:	8d 48 08             	lea    0x8(%eax),%ecx
801093fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801093fd:	89 d0                	mov    %edx,%eax
801093ff:	c1 e0 02             	shl    $0x2,%eax
80109402:	01 d0                	add    %edx,%eax
80109404:	01 c0                	add    %eax,%eax
80109406:	01 d0                	add    %edx,%eax
80109408:	05 c0 6e 19 80       	add    $0x80196ec0,%eax
8010940d:	83 c0 04             	add    $0x4,%eax
80109410:	83 ec 04             	sub    $0x4,%esp
80109413:	6a 06                	push   $0x6
80109415:	51                   	push   %ecx
80109416:	50                   	push   %eax
80109417:	e8 d4 b7 ff ff       	call   80104bf0 <memmove>
8010941c:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
8010941f:	8b 45 08             	mov    0x8(%ebp),%eax
80109422:	8d 48 0e             	lea    0xe(%eax),%ecx
80109425:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109428:	89 d0                	mov    %edx,%eax
8010942a:	c1 e0 02             	shl    $0x2,%eax
8010942d:	01 d0                	add    %edx,%eax
8010942f:	01 c0                	add    %eax,%eax
80109431:	01 d0                	add    %edx,%eax
80109433:	05 c0 6e 19 80       	add    $0x80196ec0,%eax
80109438:	83 ec 04             	sub    $0x4,%esp
8010943b:	6a 04                	push   $0x4
8010943d:	51                   	push   %ecx
8010943e:	50                   	push   %eax
8010943f:	e8 ac b7 ff ff       	call   80104bf0 <memmove>
80109444:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109447:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010944a:	89 d0                	mov    %edx,%eax
8010944c:	c1 e0 02             	shl    $0x2,%eax
8010944f:	01 d0                	add    %edx,%eax
80109451:	01 c0                	add    %eax,%eax
80109453:	01 d0                	add    %edx,%eax
80109455:	05 ca 6e 19 80       	add    $0x80196eca,%eax
8010945a:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
8010945d:	83 ec 0c             	sub    $0xc,%esp
80109460:	68 c0 6e 19 80       	push   $0x80196ec0
80109465:	e8 83 00 00 00       	call   801094ed <print_arp_table>
8010946a:	83 c4 10             	add    $0x10,%esp
}
8010946d:	90                   	nop
8010946e:	c9                   	leave  
8010946f:	c3                   	ret    

80109470 <arp_table_search>:

int arp_table_search(uchar *ip){
80109470:	55                   	push   %ebp
80109471:	89 e5                	mov    %esp,%ebp
80109473:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
80109476:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010947d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109484:	eb 59                	jmp    801094df <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
80109486:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109489:	89 d0                	mov    %edx,%eax
8010948b:	c1 e0 02             	shl    $0x2,%eax
8010948e:	01 d0                	add    %edx,%eax
80109490:	01 c0                	add    %eax,%eax
80109492:	01 d0                	add    %edx,%eax
80109494:	05 c0 6e 19 80       	add    $0x80196ec0,%eax
80109499:	83 ec 04             	sub    $0x4,%esp
8010949c:	6a 04                	push   $0x4
8010949e:	ff 75 08             	push   0x8(%ebp)
801094a1:	50                   	push   %eax
801094a2:	e8 f1 b6 ff ff       	call   80104b98 <memcmp>
801094a7:	83 c4 10             	add    $0x10,%esp
801094aa:	85 c0                	test   %eax,%eax
801094ac:	75 05                	jne    801094b3 <arp_table_search+0x43>
      return i;
801094ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094b1:	eb 38                	jmp    801094eb <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801094b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801094b6:	89 d0                	mov    %edx,%eax
801094b8:	c1 e0 02             	shl    $0x2,%eax
801094bb:	01 d0                	add    %edx,%eax
801094bd:	01 c0                	add    %eax,%eax
801094bf:	01 d0                	add    %edx,%eax
801094c1:	05 ca 6e 19 80       	add    $0x80196eca,%eax
801094c6:	0f b6 00             	movzbl (%eax),%eax
801094c9:	84 c0                	test   %al,%al
801094cb:	75 0e                	jne    801094db <arp_table_search+0x6b>
801094cd:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801094d1:	75 08                	jne    801094db <arp_table_search+0x6b>
      empty = -i;
801094d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094d6:	f7 d8                	neg    %eax
801094d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801094db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801094df:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801094e3:	7e a1                	jle    80109486 <arp_table_search+0x16>
    }
  }
  return empty-1;
801094e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e8:	83 e8 01             	sub    $0x1,%eax
}
801094eb:	c9                   	leave  
801094ec:	c3                   	ret    

801094ed <print_arp_table>:

void print_arp_table(){
801094ed:	55                   	push   %ebp
801094ee:	89 e5                	mov    %esp,%ebp
801094f0:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801094f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801094fa:	e9 92 00 00 00       	jmp    80109591 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
801094ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109502:	89 d0                	mov    %edx,%eax
80109504:	c1 e0 02             	shl    $0x2,%eax
80109507:	01 d0                	add    %edx,%eax
80109509:	01 c0                	add    %eax,%eax
8010950b:	01 d0                	add    %edx,%eax
8010950d:	05 ca 6e 19 80       	add    $0x80196eca,%eax
80109512:	0f b6 00             	movzbl (%eax),%eax
80109515:	84 c0                	test   %al,%al
80109517:	74 74                	je     8010958d <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109519:	83 ec 08             	sub    $0x8,%esp
8010951c:	ff 75 f4             	push   -0xc(%ebp)
8010951f:	68 cf c3 10 80       	push   $0x8010c3cf
80109524:	e8 cb 6e ff ff       	call   801003f4 <cprintf>
80109529:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
8010952c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010952f:	89 d0                	mov    %edx,%eax
80109531:	c1 e0 02             	shl    $0x2,%eax
80109534:	01 d0                	add    %edx,%eax
80109536:	01 c0                	add    %eax,%eax
80109538:	01 d0                	add    %edx,%eax
8010953a:	05 c0 6e 19 80       	add    $0x80196ec0,%eax
8010953f:	83 ec 0c             	sub    $0xc,%esp
80109542:	50                   	push   %eax
80109543:	e8 54 02 00 00       	call   8010979c <print_ipv4>
80109548:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
8010954b:	83 ec 0c             	sub    $0xc,%esp
8010954e:	68 de c3 10 80       	push   $0x8010c3de
80109553:	e8 9c 6e ff ff       	call   801003f4 <cprintf>
80109558:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
8010955b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010955e:	89 d0                	mov    %edx,%eax
80109560:	c1 e0 02             	shl    $0x2,%eax
80109563:	01 d0                	add    %edx,%eax
80109565:	01 c0                	add    %eax,%eax
80109567:	01 d0                	add    %edx,%eax
80109569:	05 c0 6e 19 80       	add    $0x80196ec0,%eax
8010956e:	83 c0 04             	add    $0x4,%eax
80109571:	83 ec 0c             	sub    $0xc,%esp
80109574:	50                   	push   %eax
80109575:	e8 70 02 00 00       	call   801097ea <print_mac>
8010957a:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
8010957d:	83 ec 0c             	sub    $0xc,%esp
80109580:	68 e0 c3 10 80       	push   $0x8010c3e0
80109585:	e8 6a 6e ff ff       	call   801003f4 <cprintf>
8010958a:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010958d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109591:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80109595:	0f 8e 64 ff ff ff    	jle    801094ff <print_arp_table+0x12>
    }
  }
}
8010959b:	90                   	nop
8010959c:	90                   	nop
8010959d:	c9                   	leave  
8010959e:	c3                   	ret    

8010959f <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
8010959f:	55                   	push   %ebp
801095a0:	89 e5                	mov    %esp,%ebp
801095a2:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801095a5:	8b 45 10             	mov    0x10(%ebp),%eax
801095a8:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801095ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801095b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801095b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801095b7:	83 c0 0e             	add    $0xe,%eax
801095ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801095bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c0:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801095c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c7:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
801095cb:	8b 45 08             	mov    0x8(%ebp),%eax
801095ce:	8d 50 08             	lea    0x8(%eax),%edx
801095d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d4:	83 ec 04             	sub    $0x4,%esp
801095d7:	6a 06                	push   $0x6
801095d9:	52                   	push   %edx
801095da:	50                   	push   %eax
801095db:	e8 10 b6 ff ff       	call   80104bf0 <memmove>
801095e0:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801095e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e6:	83 c0 06             	add    $0x6,%eax
801095e9:	83 ec 04             	sub    $0x4,%esp
801095ec:	6a 06                	push   $0x6
801095ee:	68 a0 6e 19 80       	push   $0x80196ea0
801095f3:	50                   	push   %eax
801095f4:	e8 f7 b5 ff ff       	call   80104bf0 <memmove>
801095f9:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
801095fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095ff:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109604:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109607:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010960d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109610:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109617:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
8010961b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010961e:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109624:	8b 45 08             	mov    0x8(%ebp),%eax
80109627:	8d 50 08             	lea    0x8(%eax),%edx
8010962a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010962d:	83 c0 12             	add    $0x12,%eax
80109630:	83 ec 04             	sub    $0x4,%esp
80109633:	6a 06                	push   $0x6
80109635:	52                   	push   %edx
80109636:	50                   	push   %eax
80109637:	e8 b4 b5 ff ff       	call   80104bf0 <memmove>
8010963c:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
8010963f:	8b 45 08             	mov    0x8(%ebp),%eax
80109642:	8d 50 0e             	lea    0xe(%eax),%edx
80109645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109648:	83 c0 18             	add    $0x18,%eax
8010964b:	83 ec 04             	sub    $0x4,%esp
8010964e:	6a 04                	push   $0x4
80109650:	52                   	push   %edx
80109651:	50                   	push   %eax
80109652:	e8 99 b5 ff ff       	call   80104bf0 <memmove>
80109657:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
8010965a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010965d:	83 c0 08             	add    $0x8,%eax
80109660:	83 ec 04             	sub    $0x4,%esp
80109663:	6a 06                	push   $0x6
80109665:	68 a0 6e 19 80       	push   $0x80196ea0
8010966a:	50                   	push   %eax
8010966b:	e8 80 b5 ff ff       	call   80104bf0 <memmove>
80109670:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
80109673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109676:	83 c0 0e             	add    $0xe,%eax
80109679:	83 ec 04             	sub    $0x4,%esp
8010967c:	6a 04                	push   $0x4
8010967e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109683:	50                   	push   %eax
80109684:	e8 67 b5 ff ff       	call   80104bf0 <memmove>
80109689:	83 c4 10             	add    $0x10,%esp
}
8010968c:	90                   	nop
8010968d:	c9                   	leave  
8010968e:	c3                   	ret    

8010968f <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
8010968f:	55                   	push   %ebp
80109690:	89 e5                	mov    %esp,%ebp
80109692:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
80109695:	83 ec 0c             	sub    $0xc,%esp
80109698:	68 e2 c3 10 80       	push   $0x8010c3e2
8010969d:	e8 52 6d ff ff       	call   801003f4 <cprintf>
801096a2:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801096a5:	8b 45 08             	mov    0x8(%ebp),%eax
801096a8:	83 c0 0e             	add    $0xe,%eax
801096ab:	83 ec 0c             	sub    $0xc,%esp
801096ae:	50                   	push   %eax
801096af:	e8 e8 00 00 00       	call   8010979c <print_ipv4>
801096b4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801096b7:	83 ec 0c             	sub    $0xc,%esp
801096ba:	68 e0 c3 10 80       	push   $0x8010c3e0
801096bf:	e8 30 6d ff ff       	call   801003f4 <cprintf>
801096c4:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
801096c7:	8b 45 08             	mov    0x8(%ebp),%eax
801096ca:	83 c0 08             	add    $0x8,%eax
801096cd:	83 ec 0c             	sub    $0xc,%esp
801096d0:	50                   	push   %eax
801096d1:	e8 14 01 00 00       	call   801097ea <print_mac>
801096d6:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801096d9:	83 ec 0c             	sub    $0xc,%esp
801096dc:	68 e0 c3 10 80       	push   $0x8010c3e0
801096e1:	e8 0e 6d ff ff       	call   801003f4 <cprintf>
801096e6:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
801096e9:	83 ec 0c             	sub    $0xc,%esp
801096ec:	68 f9 c3 10 80       	push   $0x8010c3f9
801096f1:	e8 fe 6c ff ff       	call   801003f4 <cprintf>
801096f6:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
801096f9:	8b 45 08             	mov    0x8(%ebp),%eax
801096fc:	83 c0 18             	add    $0x18,%eax
801096ff:	83 ec 0c             	sub    $0xc,%esp
80109702:	50                   	push   %eax
80109703:	e8 94 00 00 00       	call   8010979c <print_ipv4>
80109708:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010970b:	83 ec 0c             	sub    $0xc,%esp
8010970e:	68 e0 c3 10 80       	push   $0x8010c3e0
80109713:	e8 dc 6c ff ff       	call   801003f4 <cprintf>
80109718:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
8010971b:	8b 45 08             	mov    0x8(%ebp),%eax
8010971e:	83 c0 12             	add    $0x12,%eax
80109721:	83 ec 0c             	sub    $0xc,%esp
80109724:	50                   	push   %eax
80109725:	e8 c0 00 00 00       	call   801097ea <print_mac>
8010972a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010972d:	83 ec 0c             	sub    $0xc,%esp
80109730:	68 e0 c3 10 80       	push   $0x8010c3e0
80109735:	e8 ba 6c ff ff       	call   801003f4 <cprintf>
8010973a:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
8010973d:	83 ec 0c             	sub    $0xc,%esp
80109740:	68 10 c4 10 80       	push   $0x8010c410
80109745:	e8 aa 6c ff ff       	call   801003f4 <cprintf>
8010974a:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
8010974d:	8b 45 08             	mov    0x8(%ebp),%eax
80109750:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109754:	66 3d 00 01          	cmp    $0x100,%ax
80109758:	75 12                	jne    8010976c <print_arp_info+0xdd>
8010975a:	83 ec 0c             	sub    $0xc,%esp
8010975d:	68 1c c4 10 80       	push   $0x8010c41c
80109762:	e8 8d 6c ff ff       	call   801003f4 <cprintf>
80109767:	83 c4 10             	add    $0x10,%esp
8010976a:	eb 1d                	jmp    80109789 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
8010976c:	8b 45 08             	mov    0x8(%ebp),%eax
8010976f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109773:	66 3d 00 02          	cmp    $0x200,%ax
80109777:	75 10                	jne    80109789 <print_arp_info+0xfa>
    cprintf("Reply\n");
80109779:	83 ec 0c             	sub    $0xc,%esp
8010977c:	68 25 c4 10 80       	push   $0x8010c425
80109781:	e8 6e 6c ff ff       	call   801003f4 <cprintf>
80109786:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109789:	83 ec 0c             	sub    $0xc,%esp
8010978c:	68 e0 c3 10 80       	push   $0x8010c3e0
80109791:	e8 5e 6c ff ff       	call   801003f4 <cprintf>
80109796:	83 c4 10             	add    $0x10,%esp
}
80109799:	90                   	nop
8010979a:	c9                   	leave  
8010979b:	c3                   	ret    

8010979c <print_ipv4>:

void print_ipv4(uchar *ip){
8010979c:	55                   	push   %ebp
8010979d:	89 e5                	mov    %esp,%ebp
8010979f:	53                   	push   %ebx
801097a0:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801097a3:	8b 45 08             	mov    0x8(%ebp),%eax
801097a6:	83 c0 03             	add    $0x3,%eax
801097a9:	0f b6 00             	movzbl (%eax),%eax
801097ac:	0f b6 d8             	movzbl %al,%ebx
801097af:	8b 45 08             	mov    0x8(%ebp),%eax
801097b2:	83 c0 02             	add    $0x2,%eax
801097b5:	0f b6 00             	movzbl (%eax),%eax
801097b8:	0f b6 c8             	movzbl %al,%ecx
801097bb:	8b 45 08             	mov    0x8(%ebp),%eax
801097be:	83 c0 01             	add    $0x1,%eax
801097c1:	0f b6 00             	movzbl (%eax),%eax
801097c4:	0f b6 d0             	movzbl %al,%edx
801097c7:	8b 45 08             	mov    0x8(%ebp),%eax
801097ca:	0f b6 00             	movzbl (%eax),%eax
801097cd:	0f b6 c0             	movzbl %al,%eax
801097d0:	83 ec 0c             	sub    $0xc,%esp
801097d3:	53                   	push   %ebx
801097d4:	51                   	push   %ecx
801097d5:	52                   	push   %edx
801097d6:	50                   	push   %eax
801097d7:	68 2c c4 10 80       	push   $0x8010c42c
801097dc:	e8 13 6c ff ff       	call   801003f4 <cprintf>
801097e1:	83 c4 20             	add    $0x20,%esp
}
801097e4:	90                   	nop
801097e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801097e8:	c9                   	leave  
801097e9:	c3                   	ret    

801097ea <print_mac>:

void print_mac(uchar *mac){
801097ea:	55                   	push   %ebp
801097eb:	89 e5                	mov    %esp,%ebp
801097ed:	57                   	push   %edi
801097ee:	56                   	push   %esi
801097ef:	53                   	push   %ebx
801097f0:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
801097f3:	8b 45 08             	mov    0x8(%ebp),%eax
801097f6:	83 c0 05             	add    $0x5,%eax
801097f9:	0f b6 00             	movzbl (%eax),%eax
801097fc:	0f b6 f8             	movzbl %al,%edi
801097ff:	8b 45 08             	mov    0x8(%ebp),%eax
80109802:	83 c0 04             	add    $0x4,%eax
80109805:	0f b6 00             	movzbl (%eax),%eax
80109808:	0f b6 f0             	movzbl %al,%esi
8010980b:	8b 45 08             	mov    0x8(%ebp),%eax
8010980e:	83 c0 03             	add    $0x3,%eax
80109811:	0f b6 00             	movzbl (%eax),%eax
80109814:	0f b6 d8             	movzbl %al,%ebx
80109817:	8b 45 08             	mov    0x8(%ebp),%eax
8010981a:	83 c0 02             	add    $0x2,%eax
8010981d:	0f b6 00             	movzbl (%eax),%eax
80109820:	0f b6 c8             	movzbl %al,%ecx
80109823:	8b 45 08             	mov    0x8(%ebp),%eax
80109826:	83 c0 01             	add    $0x1,%eax
80109829:	0f b6 00             	movzbl (%eax),%eax
8010982c:	0f b6 d0             	movzbl %al,%edx
8010982f:	8b 45 08             	mov    0x8(%ebp),%eax
80109832:	0f b6 00             	movzbl (%eax),%eax
80109835:	0f b6 c0             	movzbl %al,%eax
80109838:	83 ec 04             	sub    $0x4,%esp
8010983b:	57                   	push   %edi
8010983c:	56                   	push   %esi
8010983d:	53                   	push   %ebx
8010983e:	51                   	push   %ecx
8010983f:	52                   	push   %edx
80109840:	50                   	push   %eax
80109841:	68 44 c4 10 80       	push   $0x8010c444
80109846:	e8 a9 6b ff ff       	call   801003f4 <cprintf>
8010984b:	83 c4 20             	add    $0x20,%esp
}
8010984e:	90                   	nop
8010984f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109852:	5b                   	pop    %ebx
80109853:	5e                   	pop    %esi
80109854:	5f                   	pop    %edi
80109855:	5d                   	pop    %ebp
80109856:	c3                   	ret    

80109857 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109857:	55                   	push   %ebp
80109858:	89 e5                	mov    %esp,%ebp
8010985a:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
8010985d:	8b 45 08             	mov    0x8(%ebp),%eax
80109860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
80109863:	8b 45 08             	mov    0x8(%ebp),%eax
80109866:	83 c0 0e             	add    $0xe,%eax
80109869:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
8010986c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010986f:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109873:	3c 08                	cmp    $0x8,%al
80109875:	75 1b                	jne    80109892 <eth_proc+0x3b>
80109877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010987a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010987e:	3c 06                	cmp    $0x6,%al
80109880:	75 10                	jne    80109892 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109882:	83 ec 0c             	sub    $0xc,%esp
80109885:	ff 75 f0             	push   -0x10(%ebp)
80109888:	e8 01 f8 ff ff       	call   8010908e <arp_proc>
8010988d:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
80109890:	eb 24                	jmp    801098b6 <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
80109892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109895:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109899:	3c 08                	cmp    $0x8,%al
8010989b:	75 19                	jne    801098b6 <eth_proc+0x5f>
8010989d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098a0:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801098a4:	84 c0                	test   %al,%al
801098a6:	75 0e                	jne    801098b6 <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801098a8:	83 ec 0c             	sub    $0xc,%esp
801098ab:	ff 75 08             	push   0x8(%ebp)
801098ae:	e8 a3 00 00 00       	call   80109956 <ipv4_proc>
801098b3:	83 c4 10             	add    $0x10,%esp
}
801098b6:	90                   	nop
801098b7:	c9                   	leave  
801098b8:	c3                   	ret    

801098b9 <N2H_ushort>:

ushort N2H_ushort(ushort value){
801098b9:	55                   	push   %ebp
801098ba:	89 e5                	mov    %esp,%ebp
801098bc:	83 ec 04             	sub    $0x4,%esp
801098bf:	8b 45 08             	mov    0x8(%ebp),%eax
801098c2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801098c6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801098ca:	c1 e0 08             	shl    $0x8,%eax
801098cd:	89 c2                	mov    %eax,%edx
801098cf:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801098d3:	66 c1 e8 08          	shr    $0x8,%ax
801098d7:	01 d0                	add    %edx,%eax
}
801098d9:	c9                   	leave  
801098da:	c3                   	ret    

801098db <H2N_ushort>:

ushort H2N_ushort(ushort value){
801098db:	55                   	push   %ebp
801098dc:	89 e5                	mov    %esp,%ebp
801098de:	83 ec 04             	sub    $0x4,%esp
801098e1:	8b 45 08             	mov    0x8(%ebp),%eax
801098e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801098e8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801098ec:	c1 e0 08             	shl    $0x8,%eax
801098ef:	89 c2                	mov    %eax,%edx
801098f1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801098f5:	66 c1 e8 08          	shr    $0x8,%ax
801098f9:	01 d0                	add    %edx,%eax
}
801098fb:	c9                   	leave  
801098fc:	c3                   	ret    

801098fd <H2N_uint>:

uint H2N_uint(uint value){
801098fd:	55                   	push   %ebp
801098fe:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109900:	8b 45 08             	mov    0x8(%ebp),%eax
80109903:	c1 e0 18             	shl    $0x18,%eax
80109906:	25 00 00 00 0f       	and    $0xf000000,%eax
8010990b:	89 c2                	mov    %eax,%edx
8010990d:	8b 45 08             	mov    0x8(%ebp),%eax
80109910:	c1 e0 08             	shl    $0x8,%eax
80109913:	25 00 f0 00 00       	and    $0xf000,%eax
80109918:	09 c2                	or     %eax,%edx
8010991a:	8b 45 08             	mov    0x8(%ebp),%eax
8010991d:	c1 e8 08             	shr    $0x8,%eax
80109920:	83 e0 0f             	and    $0xf,%eax
80109923:	01 d0                	add    %edx,%eax
}
80109925:	5d                   	pop    %ebp
80109926:	c3                   	ret    

80109927 <N2H_uint>:

uint N2H_uint(uint value){
80109927:	55                   	push   %ebp
80109928:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010992a:	8b 45 08             	mov    0x8(%ebp),%eax
8010992d:	c1 e0 18             	shl    $0x18,%eax
80109930:	89 c2                	mov    %eax,%edx
80109932:	8b 45 08             	mov    0x8(%ebp),%eax
80109935:	c1 e0 08             	shl    $0x8,%eax
80109938:	25 00 00 ff 00       	and    $0xff0000,%eax
8010993d:	01 c2                	add    %eax,%edx
8010993f:	8b 45 08             	mov    0x8(%ebp),%eax
80109942:	c1 e8 08             	shr    $0x8,%eax
80109945:	25 00 ff 00 00       	and    $0xff00,%eax
8010994a:	01 c2                	add    %eax,%edx
8010994c:	8b 45 08             	mov    0x8(%ebp),%eax
8010994f:	c1 e8 18             	shr    $0x18,%eax
80109952:	01 d0                	add    %edx,%eax
}
80109954:	5d                   	pop    %ebp
80109955:	c3                   	ret    

80109956 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109956:	55                   	push   %ebp
80109957:	89 e5                	mov    %esp,%ebp
80109959:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
8010995c:	8b 45 08             	mov    0x8(%ebp),%eax
8010995f:	83 c0 0e             	add    $0xe,%eax
80109962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109968:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010996c:	0f b7 d0             	movzwl %ax,%edx
8010996f:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
80109974:	39 c2                	cmp    %eax,%edx
80109976:	74 60                	je     801099d8 <ipv4_proc+0x82>
80109978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010997b:	83 c0 0c             	add    $0xc,%eax
8010997e:	83 ec 04             	sub    $0x4,%esp
80109981:	6a 04                	push   $0x4
80109983:	50                   	push   %eax
80109984:	68 e4 f4 10 80       	push   $0x8010f4e4
80109989:	e8 0a b2 ff ff       	call   80104b98 <memcmp>
8010998e:	83 c4 10             	add    $0x10,%esp
80109991:	85 c0                	test   %eax,%eax
80109993:	74 43                	je     801099d8 <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
80109995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109998:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010999c:	0f b7 c0             	movzwl %ax,%eax
8010999f:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801099a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099a7:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801099ab:	3c 01                	cmp    $0x1,%al
801099ad:	75 10                	jne    801099bf <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801099af:	83 ec 0c             	sub    $0xc,%esp
801099b2:	ff 75 08             	push   0x8(%ebp)
801099b5:	e8 a3 00 00 00       	call   80109a5d <icmp_proc>
801099ba:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801099bd:	eb 19                	jmp    801099d8 <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
801099bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099c2:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801099c6:	3c 06                	cmp    $0x6,%al
801099c8:	75 0e                	jne    801099d8 <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
801099ca:	83 ec 0c             	sub    $0xc,%esp
801099cd:	ff 75 08             	push   0x8(%ebp)
801099d0:	e8 b3 03 00 00       	call   80109d88 <tcp_proc>
801099d5:	83 c4 10             	add    $0x10,%esp
}
801099d8:	90                   	nop
801099d9:	c9                   	leave  
801099da:	c3                   	ret    

801099db <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
801099db:	55                   	push   %ebp
801099dc:	89 e5                	mov    %esp,%ebp
801099de:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
801099e1:	8b 45 08             	mov    0x8(%ebp),%eax
801099e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
801099e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099ea:	0f b6 00             	movzbl (%eax),%eax
801099ed:	83 e0 0f             	and    $0xf,%eax
801099f0:	01 c0                	add    %eax,%eax
801099f2:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
801099f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
801099fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109a03:	eb 48                	jmp    80109a4d <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109a05:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a08:	01 c0                	add    %eax,%eax
80109a0a:	89 c2                	mov    %eax,%edx
80109a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a0f:	01 d0                	add    %edx,%eax
80109a11:	0f b6 00             	movzbl (%eax),%eax
80109a14:	0f b6 c0             	movzbl %al,%eax
80109a17:	c1 e0 08             	shl    $0x8,%eax
80109a1a:	89 c2                	mov    %eax,%edx
80109a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a1f:	01 c0                	add    %eax,%eax
80109a21:	8d 48 01             	lea    0x1(%eax),%ecx
80109a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a27:	01 c8                	add    %ecx,%eax
80109a29:	0f b6 00             	movzbl (%eax),%eax
80109a2c:	0f b6 c0             	movzbl %al,%eax
80109a2f:	01 d0                	add    %edx,%eax
80109a31:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109a34:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109a3b:	76 0c                	jbe    80109a49 <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109a40:	0f b7 c0             	movzwl %ax,%eax
80109a43:	83 c0 01             	add    $0x1,%eax
80109a46:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109a49:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109a4d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109a51:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109a54:	7c af                	jl     80109a05 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109a59:	f7 d0                	not    %eax
}
80109a5b:	c9                   	leave  
80109a5c:	c3                   	ret    

80109a5d <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109a5d:	55                   	push   %ebp
80109a5e:	89 e5                	mov    %esp,%ebp
80109a60:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109a63:	8b 45 08             	mov    0x8(%ebp),%eax
80109a66:	83 c0 0e             	add    $0xe,%eax
80109a69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a6f:	0f b6 00             	movzbl (%eax),%eax
80109a72:	0f b6 c0             	movzbl %al,%eax
80109a75:	83 e0 0f             	and    $0xf,%eax
80109a78:	c1 e0 02             	shl    $0x2,%eax
80109a7b:	89 c2                	mov    %eax,%edx
80109a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a80:	01 d0                	add    %edx,%eax
80109a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a88:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109a8c:	84 c0                	test   %al,%al
80109a8e:	75 4f                	jne    80109adf <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
80109a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a93:	0f b6 00             	movzbl (%eax),%eax
80109a96:	3c 08                	cmp    $0x8,%al
80109a98:	75 45                	jne    80109adf <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109a9a:	e8 e6 8c ff ff       	call   80102785 <kalloc>
80109a9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109aa2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109aa9:	83 ec 04             	sub    $0x4,%esp
80109aac:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109aaf:	50                   	push   %eax
80109ab0:	ff 75 ec             	push   -0x14(%ebp)
80109ab3:	ff 75 08             	push   0x8(%ebp)
80109ab6:	e8 78 00 00 00       	call   80109b33 <icmp_reply_pkt_create>
80109abb:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ac1:	83 ec 08             	sub    $0x8,%esp
80109ac4:	50                   	push   %eax
80109ac5:	ff 75 ec             	push   -0x14(%ebp)
80109ac8:	e8 95 f4 ff ff       	call   80108f62 <i8254_send>
80109acd:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ad3:	83 ec 0c             	sub    $0xc,%esp
80109ad6:	50                   	push   %eax
80109ad7:	e8 0f 8c ff ff       	call   801026eb <kfree>
80109adc:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109adf:	90                   	nop
80109ae0:	c9                   	leave  
80109ae1:	c3                   	ret    

80109ae2 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109ae2:	55                   	push   %ebp
80109ae3:	89 e5                	mov    %esp,%ebp
80109ae5:	53                   	push   %ebx
80109ae6:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
80109ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80109aec:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109af0:	0f b7 c0             	movzwl %ax,%eax
80109af3:	83 ec 0c             	sub    $0xc,%esp
80109af6:	50                   	push   %eax
80109af7:	e8 bd fd ff ff       	call   801098b9 <N2H_ushort>
80109afc:	83 c4 10             	add    $0x10,%esp
80109aff:	0f b7 d8             	movzwl %ax,%ebx
80109b02:	8b 45 08             	mov    0x8(%ebp),%eax
80109b05:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109b09:	0f b7 c0             	movzwl %ax,%eax
80109b0c:	83 ec 0c             	sub    $0xc,%esp
80109b0f:	50                   	push   %eax
80109b10:	e8 a4 fd ff ff       	call   801098b9 <N2H_ushort>
80109b15:	83 c4 10             	add    $0x10,%esp
80109b18:	0f b7 c0             	movzwl %ax,%eax
80109b1b:	83 ec 04             	sub    $0x4,%esp
80109b1e:	53                   	push   %ebx
80109b1f:	50                   	push   %eax
80109b20:	68 63 c4 10 80       	push   $0x8010c463
80109b25:	e8 ca 68 ff ff       	call   801003f4 <cprintf>
80109b2a:	83 c4 10             	add    $0x10,%esp
}
80109b2d:	90                   	nop
80109b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109b31:	c9                   	leave  
80109b32:	c3                   	ret    

80109b33 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109b33:	55                   	push   %ebp
80109b34:	89 e5                	mov    %esp,%ebp
80109b36:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109b39:	8b 45 08             	mov    0x8(%ebp),%eax
80109b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80109b42:	83 c0 0e             	add    $0xe,%eax
80109b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b4b:	0f b6 00             	movzbl (%eax),%eax
80109b4e:	0f b6 c0             	movzbl %al,%eax
80109b51:	83 e0 0f             	and    $0xf,%eax
80109b54:	c1 e0 02             	shl    $0x2,%eax
80109b57:	89 c2                	mov    %eax,%edx
80109b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b5c:	01 d0                	add    %edx,%eax
80109b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109b61:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b64:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109b67:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b6a:	83 c0 0e             	add    $0xe,%eax
80109b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109b73:	83 c0 14             	add    $0x14,%eax
80109b76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109b79:	8b 45 10             	mov    0x10(%ebp),%eax
80109b7c:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b85:	8d 50 06             	lea    0x6(%eax),%edx
80109b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109b8b:	83 ec 04             	sub    $0x4,%esp
80109b8e:	6a 06                	push   $0x6
80109b90:	52                   	push   %edx
80109b91:	50                   	push   %eax
80109b92:	e8 59 b0 ff ff       	call   80104bf0 <memmove>
80109b97:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109b9d:	83 c0 06             	add    $0x6,%eax
80109ba0:	83 ec 04             	sub    $0x4,%esp
80109ba3:	6a 06                	push   $0x6
80109ba5:	68 a0 6e 19 80       	push   $0x80196ea0
80109baa:	50                   	push   %eax
80109bab:	e8 40 b0 ff ff       	call   80104bf0 <memmove>
80109bb0:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109bb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bb6:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bbd:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109bc4:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109bca:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109bce:	83 ec 0c             	sub    $0xc,%esp
80109bd1:	6a 54                	push   $0x54
80109bd3:	e8 03 fd ff ff       	call   801098db <H2N_ushort>
80109bd8:	83 c4 10             	add    $0x10,%esp
80109bdb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109bde:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109be2:	0f b7 15 80 71 19 80 	movzwl 0x80197180,%edx
80109be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109bec:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109bf0:	0f b7 05 80 71 19 80 	movzwl 0x80197180,%eax
80109bf7:	83 c0 01             	add    $0x1,%eax
80109bfa:	66 a3 80 71 19 80    	mov    %ax,0x80197180
  ipv4_send->fragment = H2N_ushort(0x4000);
80109c00:	83 ec 0c             	sub    $0xc,%esp
80109c03:	68 00 40 00 00       	push   $0x4000
80109c08:	e8 ce fc ff ff       	call   801098db <H2N_ushort>
80109c0d:	83 c4 10             	add    $0x10,%esp
80109c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c13:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c1a:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c21:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c28:	83 c0 0c             	add    $0xc,%eax
80109c2b:	83 ec 04             	sub    $0x4,%esp
80109c2e:	6a 04                	push   $0x4
80109c30:	68 e4 f4 10 80       	push   $0x8010f4e4
80109c35:	50                   	push   %eax
80109c36:	e8 b5 af ff ff       	call   80104bf0 <memmove>
80109c3b:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c41:	8d 50 0c             	lea    0xc(%eax),%edx
80109c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c47:	83 c0 10             	add    $0x10,%eax
80109c4a:	83 ec 04             	sub    $0x4,%esp
80109c4d:	6a 04                	push   $0x4
80109c4f:	52                   	push   %edx
80109c50:	50                   	push   %eax
80109c51:	e8 9a af ff ff       	call   80104bf0 <memmove>
80109c56:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c5c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c65:	83 ec 0c             	sub    $0xc,%esp
80109c68:	50                   	push   %eax
80109c69:	e8 6d fd ff ff       	call   801099db <ipv4_chksum>
80109c6e:	83 c4 10             	add    $0x10,%esp
80109c71:	0f b7 c0             	movzwl %ax,%eax
80109c74:	83 ec 0c             	sub    $0xc,%esp
80109c77:	50                   	push   %eax
80109c78:	e8 5e fc ff ff       	call   801098db <H2N_ushort>
80109c7d:	83 c4 10             	add    $0x10,%esp
80109c80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c83:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109c87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109c8a:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109c8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109c90:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c97:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109c9e:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ca5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cac:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cb3:	8d 50 08             	lea    0x8(%eax),%edx
80109cb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cb9:	83 c0 08             	add    $0x8,%eax
80109cbc:	83 ec 04             	sub    $0x4,%esp
80109cbf:	6a 08                	push   $0x8
80109cc1:	52                   	push   %edx
80109cc2:	50                   	push   %eax
80109cc3:	e8 28 af ff ff       	call   80104bf0 <memmove>
80109cc8:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cce:	8d 50 10             	lea    0x10(%eax),%edx
80109cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cd4:	83 c0 10             	add    $0x10,%eax
80109cd7:	83 ec 04             	sub    $0x4,%esp
80109cda:	6a 30                	push   $0x30
80109cdc:	52                   	push   %edx
80109cdd:	50                   	push   %eax
80109cde:	e8 0d af ff ff       	call   80104bf0 <memmove>
80109ce3:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ce9:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cf2:	83 ec 0c             	sub    $0xc,%esp
80109cf5:	50                   	push   %eax
80109cf6:	e8 1c 00 00 00       	call   80109d17 <icmp_chksum>
80109cfb:	83 c4 10             	add    $0x10,%esp
80109cfe:	0f b7 c0             	movzwl %ax,%eax
80109d01:	83 ec 0c             	sub    $0xc,%esp
80109d04:	50                   	push   %eax
80109d05:	e8 d1 fb ff ff       	call   801098db <H2N_ushort>
80109d0a:	83 c4 10             	add    $0x10,%esp
80109d0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109d10:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109d14:	90                   	nop
80109d15:	c9                   	leave  
80109d16:	c3                   	ret    

80109d17 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109d17:	55                   	push   %ebp
80109d18:	89 e5                	mov    %esp,%ebp
80109d1a:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80109d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109d23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109d2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109d31:	eb 48                	jmp    80109d7b <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109d33:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d36:	01 c0                	add    %eax,%eax
80109d38:	89 c2                	mov    %eax,%edx
80109d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d3d:	01 d0                	add    %edx,%eax
80109d3f:	0f b6 00             	movzbl (%eax),%eax
80109d42:	0f b6 c0             	movzbl %al,%eax
80109d45:	c1 e0 08             	shl    $0x8,%eax
80109d48:	89 c2                	mov    %eax,%edx
80109d4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d4d:	01 c0                	add    %eax,%eax
80109d4f:	8d 48 01             	lea    0x1(%eax),%ecx
80109d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d55:	01 c8                	add    %ecx,%eax
80109d57:	0f b6 00             	movzbl (%eax),%eax
80109d5a:	0f b6 c0             	movzbl %al,%eax
80109d5d:	01 d0                	add    %edx,%eax
80109d5f:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109d62:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109d69:	76 0c                	jbe    80109d77 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109d6e:	0f b7 c0             	movzwl %ax,%eax
80109d71:	83 c0 01             	add    $0x1,%eax
80109d74:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109d77:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109d7b:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109d7f:	7e b2                	jle    80109d33 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109d84:	f7 d0                	not    %eax
}
80109d86:	c9                   	leave  
80109d87:	c3                   	ret    

80109d88 <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109d88:	55                   	push   %ebp
80109d89:	89 e5                	mov    %esp,%ebp
80109d8b:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80109d91:	83 c0 0e             	add    $0xe,%eax
80109d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d9a:	0f b6 00             	movzbl (%eax),%eax
80109d9d:	0f b6 c0             	movzbl %al,%eax
80109da0:	83 e0 0f             	and    $0xf,%eax
80109da3:	c1 e0 02             	shl    $0x2,%eax
80109da6:	89 c2                	mov    %eax,%edx
80109da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109dab:	01 d0                	add    %edx,%eax
80109dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109db3:	83 c0 14             	add    $0x14,%eax
80109db6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109db9:	e8 c7 89 ff ff       	call   80102785 <kalloc>
80109dbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109dc1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dcb:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109dcf:	0f b6 c0             	movzbl %al,%eax
80109dd2:	83 e0 02             	and    $0x2,%eax
80109dd5:	85 c0                	test   %eax,%eax
80109dd7:	74 3d                	je     80109e16 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109dd9:	83 ec 0c             	sub    $0xc,%esp
80109ddc:	6a 00                	push   $0x0
80109dde:	6a 12                	push   $0x12
80109de0:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109de3:	50                   	push   %eax
80109de4:	ff 75 e8             	push   -0x18(%ebp)
80109de7:	ff 75 08             	push   0x8(%ebp)
80109dea:	e8 a2 01 00 00       	call   80109f91 <tcp_pkt_create>
80109def:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109df2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109df5:	83 ec 08             	sub    $0x8,%esp
80109df8:	50                   	push   %eax
80109df9:	ff 75 e8             	push   -0x18(%ebp)
80109dfc:	e8 61 f1 ff ff       	call   80108f62 <i8254_send>
80109e01:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109e04:	a1 84 71 19 80       	mov    0x80197184,%eax
80109e09:	83 c0 01             	add    $0x1,%eax
80109e0c:	a3 84 71 19 80       	mov    %eax,0x80197184
80109e11:	e9 69 01 00 00       	jmp    80109f7f <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e19:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109e1d:	3c 18                	cmp    $0x18,%al
80109e1f:	0f 85 10 01 00 00    	jne    80109f35 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109e25:	83 ec 04             	sub    $0x4,%esp
80109e28:	6a 03                	push   $0x3
80109e2a:	68 7e c4 10 80       	push   $0x8010c47e
80109e2f:	ff 75 ec             	push   -0x14(%ebp)
80109e32:	e8 61 ad ff ff       	call   80104b98 <memcmp>
80109e37:	83 c4 10             	add    $0x10,%esp
80109e3a:	85 c0                	test   %eax,%eax
80109e3c:	74 74                	je     80109eb2 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109e3e:	83 ec 0c             	sub    $0xc,%esp
80109e41:	68 82 c4 10 80       	push   $0x8010c482
80109e46:	e8 a9 65 ff ff       	call   801003f4 <cprintf>
80109e4b:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109e4e:	83 ec 0c             	sub    $0xc,%esp
80109e51:	6a 00                	push   $0x0
80109e53:	6a 10                	push   $0x10
80109e55:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109e58:	50                   	push   %eax
80109e59:	ff 75 e8             	push   -0x18(%ebp)
80109e5c:	ff 75 08             	push   0x8(%ebp)
80109e5f:	e8 2d 01 00 00       	call   80109f91 <tcp_pkt_create>
80109e64:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109e6a:	83 ec 08             	sub    $0x8,%esp
80109e6d:	50                   	push   %eax
80109e6e:	ff 75 e8             	push   -0x18(%ebp)
80109e71:	e8 ec f0 ff ff       	call   80108f62 <i8254_send>
80109e76:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e7c:	83 c0 36             	add    $0x36,%eax
80109e7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109e82:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109e85:	50                   	push   %eax
80109e86:	ff 75 e0             	push   -0x20(%ebp)
80109e89:	6a 00                	push   $0x0
80109e8b:	6a 00                	push   $0x0
80109e8d:	e8 5a 04 00 00       	call   8010a2ec <http_proc>
80109e92:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109e95:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109e98:	83 ec 0c             	sub    $0xc,%esp
80109e9b:	50                   	push   %eax
80109e9c:	6a 18                	push   $0x18
80109e9e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ea1:	50                   	push   %eax
80109ea2:	ff 75 e8             	push   -0x18(%ebp)
80109ea5:	ff 75 08             	push   0x8(%ebp)
80109ea8:	e8 e4 00 00 00       	call   80109f91 <tcp_pkt_create>
80109ead:	83 c4 20             	add    $0x20,%esp
80109eb0:	eb 62                	jmp    80109f14 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109eb2:	83 ec 0c             	sub    $0xc,%esp
80109eb5:	6a 00                	push   $0x0
80109eb7:	6a 10                	push   $0x10
80109eb9:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ebc:	50                   	push   %eax
80109ebd:	ff 75 e8             	push   -0x18(%ebp)
80109ec0:	ff 75 08             	push   0x8(%ebp)
80109ec3:	e8 c9 00 00 00       	call   80109f91 <tcp_pkt_create>
80109ec8:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109ece:	83 ec 08             	sub    $0x8,%esp
80109ed1:	50                   	push   %eax
80109ed2:	ff 75 e8             	push   -0x18(%ebp)
80109ed5:	e8 88 f0 ff ff       	call   80108f62 <i8254_send>
80109eda:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ee0:	83 c0 36             	add    $0x36,%eax
80109ee3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109ee6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109ee9:	50                   	push   %eax
80109eea:	ff 75 e4             	push   -0x1c(%ebp)
80109eed:	6a 00                	push   $0x0
80109eef:	6a 00                	push   $0x0
80109ef1:	e8 f6 03 00 00       	call   8010a2ec <http_proc>
80109ef6:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109ef9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109efc:	83 ec 0c             	sub    $0xc,%esp
80109eff:	50                   	push   %eax
80109f00:	6a 18                	push   $0x18
80109f02:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f05:	50                   	push   %eax
80109f06:	ff 75 e8             	push   -0x18(%ebp)
80109f09:	ff 75 08             	push   0x8(%ebp)
80109f0c:	e8 80 00 00 00       	call   80109f91 <tcp_pkt_create>
80109f11:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109f17:	83 ec 08             	sub    $0x8,%esp
80109f1a:	50                   	push   %eax
80109f1b:	ff 75 e8             	push   -0x18(%ebp)
80109f1e:	e8 3f f0 ff ff       	call   80108f62 <i8254_send>
80109f23:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109f26:	a1 84 71 19 80       	mov    0x80197184,%eax
80109f2b:	83 c0 01             	add    $0x1,%eax
80109f2e:	a3 84 71 19 80       	mov    %eax,0x80197184
80109f33:	eb 4a                	jmp    80109f7f <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f38:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109f3c:	3c 10                	cmp    $0x10,%al
80109f3e:	75 3f                	jne    80109f7f <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109f40:	a1 88 71 19 80       	mov    0x80197188,%eax
80109f45:	83 f8 01             	cmp    $0x1,%eax
80109f48:	75 35                	jne    80109f7f <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109f4a:	83 ec 0c             	sub    $0xc,%esp
80109f4d:	6a 00                	push   $0x0
80109f4f:	6a 01                	push   $0x1
80109f51:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f54:	50                   	push   %eax
80109f55:	ff 75 e8             	push   -0x18(%ebp)
80109f58:	ff 75 08             	push   0x8(%ebp)
80109f5b:	e8 31 00 00 00       	call   80109f91 <tcp_pkt_create>
80109f60:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109f63:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109f66:	83 ec 08             	sub    $0x8,%esp
80109f69:	50                   	push   %eax
80109f6a:	ff 75 e8             	push   -0x18(%ebp)
80109f6d:	e8 f0 ef ff ff       	call   80108f62 <i8254_send>
80109f72:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109f75:	c7 05 88 71 19 80 00 	movl   $0x0,0x80197188
80109f7c:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109f7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f82:	83 ec 0c             	sub    $0xc,%esp
80109f85:	50                   	push   %eax
80109f86:	e8 60 87 ff ff       	call   801026eb <kfree>
80109f8b:	83 c4 10             	add    $0x10,%esp
}
80109f8e:	90                   	nop
80109f8f:	c9                   	leave  
80109f90:	c3                   	ret    

80109f91 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109f91:	55                   	push   %ebp
80109f92:	89 e5                	mov    %esp,%ebp
80109f94:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109f97:	8b 45 08             	mov    0x8(%ebp),%eax
80109f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80109fa0:	83 c0 0e             	add    $0xe,%eax
80109fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fa9:	0f b6 00             	movzbl (%eax),%eax
80109fac:	0f b6 c0             	movzbl %al,%eax
80109faf:	83 e0 0f             	and    $0xf,%eax
80109fb2:	c1 e0 02             	shl    $0x2,%eax
80109fb5:	89 c2                	mov    %eax,%edx
80109fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fba:	01 d0                	add    %edx,%eax
80109fbc:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80109fc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80109fc8:	83 c0 0e             	add    $0xe,%eax
80109fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109fd1:	83 c0 14             	add    $0x14,%eax
80109fd4:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109fd7:	8b 45 18             	mov    0x18(%ebp),%eax
80109fda:	8d 50 36             	lea    0x36(%eax),%edx
80109fdd:	8b 45 10             	mov    0x10(%ebp),%eax
80109fe0:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fe5:	8d 50 06             	lea    0x6(%eax),%edx
80109fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109feb:	83 ec 04             	sub    $0x4,%esp
80109fee:	6a 06                	push   $0x6
80109ff0:	52                   	push   %edx
80109ff1:	50                   	push   %eax
80109ff2:	e8 f9 ab ff ff       	call   80104bf0 <memmove>
80109ff7:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ffd:	83 c0 06             	add    $0x6,%eax
8010a000:	83 ec 04             	sub    $0x4,%esp
8010a003:	6a 06                	push   $0x6
8010a005:	68 a0 6e 19 80       	push   $0x80196ea0
8010a00a:	50                   	push   %eax
8010a00b:	e8 e0 ab ff ff       	call   80104bf0 <memmove>
8010a010:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010a013:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a016:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010a01a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a01d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010a021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a024:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010a027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a02a:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
8010a02e:	8b 45 18             	mov    0x18(%ebp),%eax
8010a031:	83 c0 28             	add    $0x28,%eax
8010a034:	0f b7 c0             	movzwl %ax,%eax
8010a037:	83 ec 0c             	sub    $0xc,%esp
8010a03a:	50                   	push   %eax
8010a03b:	e8 9b f8 ff ff       	call   801098db <H2N_ushort>
8010a040:	83 c4 10             	add    $0x10,%esp
8010a043:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a046:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
8010a04a:	0f b7 15 80 71 19 80 	movzwl 0x80197180,%edx
8010a051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a054:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
8010a058:	0f b7 05 80 71 19 80 	movzwl 0x80197180,%eax
8010a05f:	83 c0 01             	add    $0x1,%eax
8010a062:	66 a3 80 71 19 80    	mov    %ax,0x80197180
  ipv4_send->fragment = H2N_ushort(0x0000);
8010a068:	83 ec 0c             	sub    $0xc,%esp
8010a06b:	6a 00                	push   $0x0
8010a06d:	e8 69 f8 ff ff       	call   801098db <H2N_ushort>
8010a072:	83 c4 10             	add    $0x10,%esp
8010a075:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a078:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010a07c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a07f:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
8010a083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a086:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010a08a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a08d:	83 c0 0c             	add    $0xc,%eax
8010a090:	83 ec 04             	sub    $0x4,%esp
8010a093:	6a 04                	push   $0x4
8010a095:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a09a:	50                   	push   %eax
8010a09b:	e8 50 ab ff ff       	call   80104bf0 <memmove>
8010a0a0:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
8010a0a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0a6:	8d 50 0c             	lea    0xc(%eax),%edx
8010a0a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0ac:	83 c0 10             	add    $0x10,%eax
8010a0af:	83 ec 04             	sub    $0x4,%esp
8010a0b2:	6a 04                	push   $0x4
8010a0b4:	52                   	push   %edx
8010a0b5:	50                   	push   %eax
8010a0b6:	e8 35 ab ff ff       	call   80104bf0 <memmove>
8010a0bb:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010a0be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0c1:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010a0c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0ca:	83 ec 0c             	sub    $0xc,%esp
8010a0cd:	50                   	push   %eax
8010a0ce:	e8 08 f9 ff ff       	call   801099db <ipv4_chksum>
8010a0d3:	83 c4 10             	add    $0x10,%esp
8010a0d6:	0f b7 c0             	movzwl %ax,%eax
8010a0d9:	83 ec 0c             	sub    $0xc,%esp
8010a0dc:	50                   	push   %eax
8010a0dd:	e8 f9 f7 ff ff       	call   801098db <H2N_ushort>
8010a0e2:	83 c4 10             	add    $0x10,%esp
8010a0e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a0e8:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
8010a0ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0ef:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010a0f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a0f6:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
8010a0f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0fc:	0f b7 10             	movzwl (%eax),%edx
8010a0ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a102:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
8010a106:	a1 84 71 19 80       	mov    0x80197184,%eax
8010a10b:	83 ec 0c             	sub    $0xc,%esp
8010a10e:	50                   	push   %eax
8010a10f:	e8 e9 f7 ff ff       	call   801098fd <H2N_uint>
8010a114:	83 c4 10             	add    $0x10,%esp
8010a117:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a11a:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
8010a11d:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a120:	8b 40 04             	mov    0x4(%eax),%eax
8010a123:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
8010a129:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a12c:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
8010a12f:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a132:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
8010a136:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a139:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
8010a13d:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a140:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
8010a144:	8b 45 14             	mov    0x14(%ebp),%eax
8010a147:	89 c2                	mov    %eax,%edx
8010a149:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a14c:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
8010a14f:	83 ec 0c             	sub    $0xc,%esp
8010a152:	68 90 38 00 00       	push   $0x3890
8010a157:	e8 7f f7 ff ff       	call   801098db <H2N_ushort>
8010a15c:	83 c4 10             	add    $0x10,%esp
8010a15f:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a162:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
8010a166:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a169:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
8010a16f:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a172:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
8010a178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a17b:	83 ec 0c             	sub    $0xc,%esp
8010a17e:	50                   	push   %eax
8010a17f:	e8 1f 00 00 00       	call   8010a1a3 <tcp_chksum>
8010a184:	83 c4 10             	add    $0x10,%esp
8010a187:	83 c0 08             	add    $0x8,%eax
8010a18a:	0f b7 c0             	movzwl %ax,%eax
8010a18d:	83 ec 0c             	sub    $0xc,%esp
8010a190:	50                   	push   %eax
8010a191:	e8 45 f7 ff ff       	call   801098db <H2N_ushort>
8010a196:	83 c4 10             	add    $0x10,%esp
8010a199:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a19c:	66 89 42 10          	mov    %ax,0x10(%edx)


}
8010a1a0:	90                   	nop
8010a1a1:	c9                   	leave  
8010a1a2:	c3                   	ret    

8010a1a3 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
8010a1a3:	55                   	push   %ebp
8010a1a4:	89 e5                	mov    %esp,%ebp
8010a1a6:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
8010a1a9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
8010a1af:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1b2:	83 c0 14             	add    $0x14,%eax
8010a1b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
8010a1b8:	83 ec 04             	sub    $0x4,%esp
8010a1bb:	6a 04                	push   $0x4
8010a1bd:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a1c2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a1c5:	50                   	push   %eax
8010a1c6:	e8 25 aa ff ff       	call   80104bf0 <memmove>
8010a1cb:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a1ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1d1:	83 c0 0c             	add    $0xc,%eax
8010a1d4:	83 ec 04             	sub    $0x4,%esp
8010a1d7:	6a 04                	push   $0x4
8010a1d9:	50                   	push   %eax
8010a1da:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a1dd:	83 c0 04             	add    $0x4,%eax
8010a1e0:	50                   	push   %eax
8010a1e1:	e8 0a aa ff ff       	call   80104bf0 <memmove>
8010a1e6:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a1e9:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a1ed:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a1f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1f4:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a1f8:	0f b7 c0             	movzwl %ax,%eax
8010a1fb:	83 ec 0c             	sub    $0xc,%esp
8010a1fe:	50                   	push   %eax
8010a1ff:	e8 b5 f6 ff ff       	call   801098b9 <N2H_ushort>
8010a204:	83 c4 10             	add    $0x10,%esp
8010a207:	83 e8 14             	sub    $0x14,%eax
8010a20a:	0f b7 c0             	movzwl %ax,%eax
8010a20d:	83 ec 0c             	sub    $0xc,%esp
8010a210:	50                   	push   %eax
8010a211:	e8 c5 f6 ff ff       	call   801098db <H2N_ushort>
8010a216:	83 c4 10             	add    $0x10,%esp
8010a219:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a21d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a224:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a227:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a22a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a231:	eb 33                	jmp    8010a266 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a233:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a236:	01 c0                	add    %eax,%eax
8010a238:	89 c2                	mov    %eax,%edx
8010a23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a23d:	01 d0                	add    %edx,%eax
8010a23f:	0f b6 00             	movzbl (%eax),%eax
8010a242:	0f b6 c0             	movzbl %al,%eax
8010a245:	c1 e0 08             	shl    $0x8,%eax
8010a248:	89 c2                	mov    %eax,%edx
8010a24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a24d:	01 c0                	add    %eax,%eax
8010a24f:	8d 48 01             	lea    0x1(%eax),%ecx
8010a252:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a255:	01 c8                	add    %ecx,%eax
8010a257:	0f b6 00             	movzbl (%eax),%eax
8010a25a:	0f b6 c0             	movzbl %al,%eax
8010a25d:	01 d0                	add    %edx,%eax
8010a25f:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a262:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a266:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a26a:	7e c7                	jle    8010a233 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a26c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a26f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a272:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a279:	eb 33                	jmp    8010a2ae <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a27b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a27e:	01 c0                	add    %eax,%eax
8010a280:	89 c2                	mov    %eax,%edx
8010a282:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a285:	01 d0                	add    %edx,%eax
8010a287:	0f b6 00             	movzbl (%eax),%eax
8010a28a:	0f b6 c0             	movzbl %al,%eax
8010a28d:	c1 e0 08             	shl    $0x8,%eax
8010a290:	89 c2                	mov    %eax,%edx
8010a292:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a295:	01 c0                	add    %eax,%eax
8010a297:	8d 48 01             	lea    0x1(%eax),%ecx
8010a29a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a29d:	01 c8                	add    %ecx,%eax
8010a29f:	0f b6 00             	movzbl (%eax),%eax
8010a2a2:	0f b6 c0             	movzbl %al,%eax
8010a2a5:	01 d0                	add    %edx,%eax
8010a2a7:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a2aa:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a2ae:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a2b2:	0f b7 c0             	movzwl %ax,%eax
8010a2b5:	83 ec 0c             	sub    $0xc,%esp
8010a2b8:	50                   	push   %eax
8010a2b9:	e8 fb f5 ff ff       	call   801098b9 <N2H_ushort>
8010a2be:	83 c4 10             	add    $0x10,%esp
8010a2c1:	66 d1 e8             	shr    %ax
8010a2c4:	0f b7 c0             	movzwl %ax,%eax
8010a2c7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a2ca:	7c af                	jl     8010a27b <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a2cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a2cf:	c1 e8 10             	shr    $0x10,%eax
8010a2d2:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a2d8:	f7 d0                	not    %eax
}
8010a2da:	c9                   	leave  
8010a2db:	c3                   	ret    

8010a2dc <tcp_fin>:

void tcp_fin(){
8010a2dc:	55                   	push   %ebp
8010a2dd:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a2df:	c7 05 88 71 19 80 01 	movl   $0x1,0x80197188
8010a2e6:	00 00 00 
}
8010a2e9:	90                   	nop
8010a2ea:	5d                   	pop    %ebp
8010a2eb:	c3                   	ret    

8010a2ec <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a2ec:	55                   	push   %ebp
8010a2ed:	89 e5                	mov    %esp,%ebp
8010a2ef:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a2f2:	8b 45 10             	mov    0x10(%ebp),%eax
8010a2f5:	83 ec 04             	sub    $0x4,%esp
8010a2f8:	6a 00                	push   $0x0
8010a2fa:	68 8b c4 10 80       	push   $0x8010c48b
8010a2ff:	50                   	push   %eax
8010a300:	e8 65 00 00 00       	call   8010a36a <http_strcpy>
8010a305:	83 c4 10             	add    $0x10,%esp
8010a308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a30b:	8b 45 10             	mov    0x10(%ebp),%eax
8010a30e:	83 ec 04             	sub    $0x4,%esp
8010a311:	ff 75 f4             	push   -0xc(%ebp)
8010a314:	68 9e c4 10 80       	push   $0x8010c49e
8010a319:	50                   	push   %eax
8010a31a:	e8 4b 00 00 00       	call   8010a36a <http_strcpy>
8010a31f:	83 c4 10             	add    $0x10,%esp
8010a322:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a325:	8b 45 10             	mov    0x10(%ebp),%eax
8010a328:	83 ec 04             	sub    $0x4,%esp
8010a32b:	ff 75 f4             	push   -0xc(%ebp)
8010a32e:	68 b9 c4 10 80       	push   $0x8010c4b9
8010a333:	50                   	push   %eax
8010a334:	e8 31 00 00 00       	call   8010a36a <http_strcpy>
8010a339:	83 c4 10             	add    $0x10,%esp
8010a33c:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a33f:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a342:	83 e0 01             	and    $0x1,%eax
8010a345:	85 c0                	test   %eax,%eax
8010a347:	74 11                	je     8010a35a <http_proc+0x6e>
    char *payload = (char *)send;
8010a349:	8b 45 10             	mov    0x10(%ebp),%eax
8010a34c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a34f:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a352:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a355:	01 d0                	add    %edx,%eax
8010a357:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a35a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a35d:	8b 45 14             	mov    0x14(%ebp),%eax
8010a360:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a362:	e8 75 ff ff ff       	call   8010a2dc <tcp_fin>
}
8010a367:	90                   	nop
8010a368:	c9                   	leave  
8010a369:	c3                   	ret    

8010a36a <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a36a:	55                   	push   %ebp
8010a36b:	89 e5                	mov    %esp,%ebp
8010a36d:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a377:	eb 20                	jmp    8010a399 <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a379:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a37c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a37f:	01 d0                	add    %edx,%eax
8010a381:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a384:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a387:	01 ca                	add    %ecx,%edx
8010a389:	89 d1                	mov    %edx,%ecx
8010a38b:	8b 55 08             	mov    0x8(%ebp),%edx
8010a38e:	01 ca                	add    %ecx,%edx
8010a390:	0f b6 00             	movzbl (%eax),%eax
8010a393:	88 02                	mov    %al,(%edx)
    i++;
8010a395:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a399:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a39c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a39f:	01 d0                	add    %edx,%eax
8010a3a1:	0f b6 00             	movzbl (%eax),%eax
8010a3a4:	84 c0                	test   %al,%al
8010a3a6:	75 d1                	jne    8010a379 <http_strcpy+0xf>
  }
  return i;
8010a3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a3ab:	c9                   	leave  
8010a3ac:	c3                   	ret    

8010a3ad <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a3ad:	55                   	push   %ebp
8010a3ae:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a3b0:	c7 05 90 71 19 80 a2 	movl   $0x8010f5a2,0x80197190
8010a3b7:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a3ba:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a3bf:	c1 e8 09             	shr    $0x9,%eax
8010a3c2:	a3 8c 71 19 80       	mov    %eax,0x8019718c
}
8010a3c7:	90                   	nop
8010a3c8:	5d                   	pop    %ebp
8010a3c9:	c3                   	ret    

8010a3ca <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a3ca:	55                   	push   %ebp
8010a3cb:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a3cd:	90                   	nop
8010a3ce:	5d                   	pop    %ebp
8010a3cf:	c3                   	ret    

8010a3d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a3d0:	55                   	push   %ebp
8010a3d1:	89 e5                	mov    %esp,%ebp
8010a3d3:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a3d6:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3d9:	83 c0 0c             	add    $0xc,%eax
8010a3dc:	83 ec 0c             	sub    $0xc,%esp
8010a3df:	50                   	push   %eax
8010a3e0:	e8 45 a4 ff ff       	call   8010482a <holdingsleep>
8010a3e5:	83 c4 10             	add    $0x10,%esp
8010a3e8:	85 c0                	test   %eax,%eax
8010a3ea:	75 0d                	jne    8010a3f9 <iderw+0x29>
    panic("iderw: buf not locked");
8010a3ec:	83 ec 0c             	sub    $0xc,%esp
8010a3ef:	68 ca c4 10 80       	push   $0x8010c4ca
8010a3f4:	e8 b0 61 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a3f9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3fc:	8b 00                	mov    (%eax),%eax
8010a3fe:	83 e0 06             	and    $0x6,%eax
8010a401:	83 f8 02             	cmp    $0x2,%eax
8010a404:	75 0d                	jne    8010a413 <iderw+0x43>
    panic("iderw: nothing to do");
8010a406:	83 ec 0c             	sub    $0xc,%esp
8010a409:	68 e0 c4 10 80       	push   $0x8010c4e0
8010a40e:	e8 96 61 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a413:	8b 45 08             	mov    0x8(%ebp),%eax
8010a416:	8b 40 04             	mov    0x4(%eax),%eax
8010a419:	83 f8 01             	cmp    $0x1,%eax
8010a41c:	74 0d                	je     8010a42b <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a41e:	83 ec 0c             	sub    $0xc,%esp
8010a421:	68 f5 c4 10 80       	push   $0x8010c4f5
8010a426:	e8 7e 61 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a42b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a42e:	8b 40 08             	mov    0x8(%eax),%eax
8010a431:	8b 15 8c 71 19 80    	mov    0x8019718c,%edx
8010a437:	39 d0                	cmp    %edx,%eax
8010a439:	72 0d                	jb     8010a448 <iderw+0x78>
    panic("iderw: block out of range");
8010a43b:	83 ec 0c             	sub    $0xc,%esp
8010a43e:	68 13 c5 10 80       	push   $0x8010c513
8010a443:	e8 61 61 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a448:	8b 15 90 71 19 80    	mov    0x80197190,%edx
8010a44e:	8b 45 08             	mov    0x8(%ebp),%eax
8010a451:	8b 40 08             	mov    0x8(%eax),%eax
8010a454:	c1 e0 09             	shl    $0x9,%eax
8010a457:	01 d0                	add    %edx,%eax
8010a459:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a45c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a45f:	8b 00                	mov    (%eax),%eax
8010a461:	83 e0 04             	and    $0x4,%eax
8010a464:	85 c0                	test   %eax,%eax
8010a466:	74 2b                	je     8010a493 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a468:	8b 45 08             	mov    0x8(%ebp),%eax
8010a46b:	8b 00                	mov    (%eax),%eax
8010a46d:	83 e0 fb             	and    $0xfffffffb,%eax
8010a470:	89 c2                	mov    %eax,%edx
8010a472:	8b 45 08             	mov    0x8(%ebp),%eax
8010a475:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a477:	8b 45 08             	mov    0x8(%ebp),%eax
8010a47a:	83 c0 5c             	add    $0x5c,%eax
8010a47d:	83 ec 04             	sub    $0x4,%esp
8010a480:	68 00 02 00 00       	push   $0x200
8010a485:	50                   	push   %eax
8010a486:	ff 75 f4             	push   -0xc(%ebp)
8010a489:	e8 62 a7 ff ff       	call   80104bf0 <memmove>
8010a48e:	83 c4 10             	add    $0x10,%esp
8010a491:	eb 1a                	jmp    8010a4ad <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a493:	8b 45 08             	mov    0x8(%ebp),%eax
8010a496:	83 c0 5c             	add    $0x5c,%eax
8010a499:	83 ec 04             	sub    $0x4,%esp
8010a49c:	68 00 02 00 00       	push   $0x200
8010a4a1:	ff 75 f4             	push   -0xc(%ebp)
8010a4a4:	50                   	push   %eax
8010a4a5:	e8 46 a7 ff ff       	call   80104bf0 <memmove>
8010a4aa:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a4ad:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4b0:	8b 00                	mov    (%eax),%eax
8010a4b2:	83 c8 02             	or     $0x2,%eax
8010a4b5:	89 c2                	mov    %eax,%edx
8010a4b7:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4ba:	89 10                	mov    %edx,(%eax)
}
8010a4bc:	90                   	nop
8010a4bd:	c9                   	leave  
8010a4be:	c3                   	ret    
