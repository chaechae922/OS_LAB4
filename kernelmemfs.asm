
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
8010005a:	bc a0 82 19 80       	mov    $0x801982a0,%esp
  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
#  jz .waiting_main
  movl $main, %edx
8010005f:	ba 77 33 10 80       	mov    $0x80103377,%edx
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
8010006f:	68 40 a5 10 80       	push   $0x8010a540
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 42 48 00 00       	call   801048c0 <initlock>
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
801000bd:	68 47 a5 10 80       	push   $0x8010a547
801000c2:	50                   	push   %eax
801000c3:	e8 9b 46 00 00       	call   80104763 <initsleeplock>
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
80100101:	e8 dc 47 00 00       	call   801048e2 <acquire>
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
80100140:	e8 0b 48 00 00       	call   80104950 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 48 46 00 00       	call   8010479f <acquiresleep>
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
801001c1:	e8 8a 47 00 00       	call   80104950 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 c7 45 00 00       	call   8010479f <acquiresleep>
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
801001f5:	68 4e a5 10 80       	push   $0x8010a54e
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
8010022d:	e8 02 a2 00 00       	call   8010a434 <iderw>
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
8010024a:	e8 02 46 00 00       	call   80104851 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 5f a5 10 80       	push   $0x8010a55f
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
80100278:	e8 b7 a1 00 00       	call   8010a434 <iderw>
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
80100293:	e8 b9 45 00 00       	call   80104851 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 66 a5 10 80       	push   $0x8010a566
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 48 45 00 00       	call   80104803 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 17 46 00 00       	call   801048e2 <acquire>
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
80100336:	e8 15 46 00 00       	call   80104950 <release>
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
80100410:	e8 cd 44 00 00       	call   801048e2 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 6d a5 10 80       	push   $0x8010a56d
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
80100510:	c7 45 ec 76 a5 10 80 	movl   $0x8010a576,-0x14(%ebp)
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
8010059e:	e8 ad 43 00 00       	call   80104950 <release>
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
801005be:	e8 49 25 00 00       	call   80102b0c <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 7d a5 10 80       	push   $0x8010a57d
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
801005e6:	68 91 a5 10 80       	push   $0x8010a591
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 9f 43 00 00       	call   801049a2 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 93 a5 10 80       	push   $0x8010a593
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
801006a0:	e8 e6 7c 00 00       	call   8010838b <graphic_scroll_up>
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
801006f3:	e8 93 7c 00 00       	call   8010838b <graphic_scroll_up>
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
80100757:	e8 9a 7c 00 00       	call   801083f6 <font_render>
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
80100793:	e8 9f 5f 00 00       	call   80106737 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 92 5f 00 00       	call   80106737 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 85 5f 00 00       	call   80106737 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 75 5f 00 00       	call   80106737 <uartputc>
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
801007eb:	e8 f2 40 00 00       	call   801048e2 <acquire>
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
8010093f:	e8 22 3b 00 00       	call   80104466 <wakeup>
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
80100962:	e8 e9 3f 00 00       	call   80104950 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 ac 3b 00 00       	call   80104521 <procdump>
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
8010099a:	e8 43 3f 00 00       	call   801048e2 <acquire>
8010099f:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a2:	e9 ab 00 00 00       	jmp    80100a52 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009a7:	e8 96 30 00 00       	call   80103a42 <myproc>
801009ac:	8b 40 24             	mov    0x24(%eax),%eax
801009af:	85 c0                	test   %eax,%eax
801009b1:	74 28                	je     801009db <consoleread+0x63>
        release(&cons.lock);
801009b3:	83 ec 0c             	sub    $0xc,%esp
801009b6:	68 00 1a 19 80       	push   $0x80191a00
801009bb:	e8 90 3f 00 00       	call   80104950 <release>
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
801009e8:	e8 92 39 00 00       	call   8010437f <sleep>
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
80100a66:	e8 e5 3e 00 00       	call   80104950 <release>
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
80100aa2:	e8 3b 3e 00 00       	call   801048e2 <acquire>
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
80100ae4:	e8 67 3e 00 00       	call   80104950 <release>
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
80100b12:	68 97 a5 10 80       	push   $0x8010a597
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 9f 3d 00 00       	call   801048c0 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 9f a5 10 80 	movl   $0x8010a59f,-0xc(%ebp)
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
80100b89:	e8 b4 2e 00 00       	call   80103a42 <myproc>
80100b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b91:	e8 b8 24 00 00       	call   8010304e <begin_op>

  if((ip = namei(path)) == 0){
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	ff 75 08             	push   0x8(%ebp)
80100b9c:	e8 61 19 00 00       	call   80102502 <namei>
80100ba1:	83 c4 10             	add    $0x10,%esp
80100ba4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ba7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bab:	75 1f                	jne    80100bcc <exec+0x4c>
    end_op();
80100bad:	e8 28 25 00 00       	call   801030da <end_op>
    cprintf("exec: fail\n");
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	68 b5 a5 10 80       	push   $0x8010a5b5
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
80100c11:	e8 1d 6b 00 00       	call   80107733 <setupkvm>
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
80100cb7:	e8 70 6e 00 00       	call   80107b2c <allocuvm>
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
80100cfd:	e8 5d 6d 00 00       	call   80107a5f <loaduvm>
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
80100d3e:	e8 97 23 00 00       	call   801030da <end_op>
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
80100d73:	e8 b4 6d 00 00       	call   80107b2c <allocuvm>
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
80100dae:	e8 f3 3f 00 00       	call   80104da6 <strlen>
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
80100ddb:	e8 c6 3f 00 00       	call   80104da6 <strlen>
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
80100e01:	e8 f2 71 00 00       	call   80107ff8 <copyout>
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
80100e9d:	e8 56 71 00 00       	call   80107ff8 <copyout>
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
80100eeb:	e8 6b 3e 00 00       	call   80104d5b <safestrcpy>
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
80100f2e:	e8 1d 69 00 00       	call   80107850 <switchuvm>
80100f33:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	ff 75 cc             	push   -0x34(%ebp)
80100f3c:	e8 b4 6d 00 00       	call   80107cf5 <freevm>
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
80100f7c:	e8 74 6d 00 00       	call   80107cf5 <freevm>
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
80100f98:	e8 3d 21 00 00       	call   801030da <end_op>
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
80100fad:	68 c1 a5 10 80       	push   $0x8010a5c1
80100fb2:	68 a0 1a 19 80       	push   $0x80191aa0
80100fb7:	e8 04 39 00 00       	call   801048c0 <initlock>
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
80100fd0:	e8 0d 39 00 00       	call   801048e2 <acquire>
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
80100ffd:	e8 4e 39 00 00       	call   80104950 <release>
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
80101020:	e8 2b 39 00 00       	call   80104950 <release>
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
8010103d:	e8 a0 38 00 00       	call   801048e2 <acquire>
80101042:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	8b 40 04             	mov    0x4(%eax),%eax
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 0d                	jg     8010105c <filedup+0x2d>
    panic("filedup");
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	68 c8 a5 10 80       	push   $0x8010a5c8
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
80101073:	e8 d8 38 00 00       	call   80104950 <release>
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
8010108e:	e8 4f 38 00 00       	call   801048e2 <acquire>
80101093:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	8b 40 04             	mov    0x4(%eax),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	7f 0d                	jg     801010ad <fileclose+0x2d>
    panic("fileclose");
801010a0:	83 ec 0c             	sub    $0xc,%esp
801010a3:	68 d0 a5 10 80       	push   $0x8010a5d0
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
801010ce:	e8 7d 38 00 00       	call   80104950 <release>
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
8010111c:	e8 2f 38 00 00       	call   80104950 <release>
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
8010113b:	e8 91 25 00 00       	call   801036d1 <pipeclose>
80101140:	83 c4 10             	add    $0x10,%esp
80101143:	eb 21                	jmp    80101166 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101145:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101148:	83 f8 02             	cmp    $0x2,%eax
8010114b:	75 19                	jne    80101166 <fileclose+0xe6>
    begin_op();
8010114d:	e8 fc 1e 00 00       	call   8010304e <begin_op>
    iput(ff.ip);
80101152:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101155:	83 ec 0c             	sub    $0xc,%esp
80101158:	50                   	push   %eax
80101159:	e8 d2 09 00 00       	call   80101b30 <iput>
8010115e:	83 c4 10             	add    $0x10,%esp
    end_op();
80101161:	e8 74 1f 00 00       	call   801030da <end_op>
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
801011f4:	e8 85 26 00 00       	call   8010387e <piperead>
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
8010126b:	68 da a5 10 80       	push   $0x8010a5da
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
801012ad:	e8 ca 24 00 00       	call   8010377c <pipewrite>
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
801012f2:	e8 57 1d 00 00       	call   8010304e <begin_op>
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
80101358:	e8 7d 1d 00 00       	call   801030da <end_op>

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
8010136e:	68 e3 a5 10 80       	push   $0x8010a5e3
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
801013a4:	68 f3 a5 10 80       	push   $0x8010a5f3
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
801013dc:	e8 36 38 00 00       	call   80104c17 <memmove>
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
80101422:	e8 31 37 00 00       	call   80104b58 <memset>
80101427:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010142a:	83 ec 0c             	sub    $0xc,%esp
8010142d:	ff 75 f4             	push   -0xc(%ebp)
80101430:	e8 52 1e 00 00       	call   80103287 <log_write>
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
801014fc:	e8 86 1d 00 00       	call   80103287 <log_write>
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
80101581:	68 00 a6 10 80       	push   $0x8010a600
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
8010160c:	68 16 a6 10 80       	push   $0x8010a616
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
80101644:	e8 3e 1c 00 00       	call   80103287 <log_write>
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
80101670:	68 29 a6 10 80       	push   $0x8010a629
80101675:	68 60 24 19 80       	push   $0x80192460
8010167a:	e8 41 32 00 00       	call   801048c0 <initlock>
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
801016a6:	68 30 a6 10 80       	push   $0x8010a630
801016ab:	50                   	push   %eax
801016ac:	e8 b2 30 00 00       	call   80104763 <initsleeplock>
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
80101705:	68 38 a6 10 80       	push   $0x8010a638
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
8010177e:	e8 d5 33 00 00       	call   80104b58 <memset>
80101783:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101786:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101789:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010178d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101790:	83 ec 0c             	sub    $0xc,%esp
80101793:	ff 75 f0             	push   -0x10(%ebp)
80101796:	e8 ec 1a 00 00       	call   80103287 <log_write>
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
801017e6:	68 8b a6 10 80       	push   $0x8010a68b
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
8010188c:	e8 86 33 00 00       	call   80104c17 <memmove>
80101891:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	ff 75 f4             	push   -0xc(%ebp)
8010189a:	e8 e8 19 00 00       	call   80103287 <log_write>
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
801018c1:	e8 1c 30 00 00       	call   801048e2 <acquire>
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
8010190f:	e8 3c 30 00 00       	call   80104950 <release>
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
8010194b:	68 9d a6 10 80       	push   $0x8010a69d
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
80101988:	e8 c3 2f 00 00       	call   80104950 <release>
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
801019a3:	e8 3a 2f 00 00       	call   801048e2 <acquire>
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
801019c2:	e8 89 2f 00 00       	call   80104950 <release>
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
801019e8:	68 ad a6 10 80       	push   $0x8010a6ad
801019ed:	e8 b7 eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	83 c0 0c             	add    $0xc,%eax
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	50                   	push   %eax
801019fc:	e8 9e 2d 00 00       	call   8010479f <acquiresleep>
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
80101aa6:	e8 6c 31 00 00       	call   80104c17 <memmove>
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
80101ad5:	68 b3 a6 10 80       	push   $0x8010a6b3
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
80101af8:	e8 54 2d 00 00       	call   80104851 <holdingsleep>
80101afd:	83 c4 10             	add    $0x10,%esp
80101b00:	85 c0                	test   %eax,%eax
80101b02:	74 0a                	je     80101b0e <iunlock+0x2c>
80101b04:	8b 45 08             	mov    0x8(%ebp),%eax
80101b07:	8b 40 08             	mov    0x8(%eax),%eax
80101b0a:	85 c0                	test   %eax,%eax
80101b0c:	7f 0d                	jg     80101b1b <iunlock+0x39>
    panic("iunlock");
80101b0e:	83 ec 0c             	sub    $0xc,%esp
80101b11:	68 c2 a6 10 80       	push   $0x8010a6c2
80101b16:	e8 8e ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	83 c0 0c             	add    $0xc,%eax
80101b21:	83 ec 0c             	sub    $0xc,%esp
80101b24:	50                   	push   %eax
80101b25:	e8 d9 2c 00 00       	call   80104803 <releasesleep>
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
80101b40:	e8 5a 2c 00 00       	call   8010479f <acquiresleep>
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
80101b66:	e8 77 2d 00 00       	call   801048e2 <acquire>
80101b6b:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 40 08             	mov    0x8(%eax),%eax
80101b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b77:	83 ec 0c             	sub    $0xc,%esp
80101b7a:	68 60 24 19 80       	push   $0x80192460
80101b7f:	e8 cc 2d 00 00       	call   80104950 <release>
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
80101bc6:	e8 38 2c 00 00       	call   80104803 <releasesleep>
80101bcb:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101bce:	83 ec 0c             	sub    $0xc,%esp
80101bd1:	68 60 24 19 80       	push   $0x80192460
80101bd6:	e8 07 2d 00 00       	call   801048e2 <acquire>
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
80101bf5:	e8 56 2d 00 00       	call   80104950 <release>
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
80101d1b:	e8 67 15 00 00       	call   80103287 <log_write>
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
80101d39:	68 ca a6 10 80       	push   $0x8010a6ca
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
80101fd7:	e8 3b 2c 00 00       	call   80104c17 <memmove>
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
80102127:	e8 eb 2a 00 00       	call   80104c17 <memmove>
8010212c:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010212f:	83 ec 0c             	sub    $0xc,%esp
80102132:	ff 75 f0             	push   -0x10(%ebp)
80102135:	e8 4d 11 00 00       	call   80103287 <log_write>
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
801021a7:	e8 01 2b 00 00       	call   80104cad <strncmp>
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
801021c7:	68 dd a6 10 80       	push   $0x8010a6dd
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
801021f6:	68 ef a6 10 80       	push   $0x8010a6ef
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
801022cb:	68 fe a6 10 80       	push   $0x8010a6fe
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
80102306:	e8 f8 29 00 00       	call   80104d03 <strncpy>
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
80102332:	68 0b a7 10 80       	push   $0x8010a70b
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
801023a4:	e8 6e 28 00 00       	call   80104c17 <memmove>
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	eb 26                	jmp    801023d4 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b1:	83 ec 04             	sub    $0x4,%esp
801023b4:	50                   	push   %eax
801023b5:	ff 75 f4             	push   -0xc(%ebp)
801023b8:	ff 75 0c             	push   0xc(%ebp)
801023bb:	e8 57 28 00 00       	call   80104c17 <memmove>
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
8010240a:	e8 33 16 00 00       	call   80103a42 <myproc>
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
801025a0:	0f b6 05 64 6f 19 80 	movzbl 0x80196f64,%eax
801025a7:	0f b6 c0             	movzbl %al,%eax
801025aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025ad:	74 10                	je     801025bf <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025af:	83 ec 0c             	sub    $0xc,%esp
801025b2:	68 14 a7 10 80       	push   $0x8010a714
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
80102659:	68 46 a7 10 80       	push   $0x8010a746
8010265e:	68 c0 40 19 80       	push   $0x801940c0
80102663:	e8 58 22 00 00       	call   801048c0 <initlock>
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
80102718:	68 4b a7 10 80       	push   $0x8010a74b
8010271d:	e8 87 de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102722:	83 ec 04             	sub    $0x4,%esp
80102725:	68 00 10 00 00       	push   $0x1000
8010272a:	6a 01                	push   $0x1
8010272c:	ff 75 08             	push   0x8(%ebp)
8010272f:	e8 24 24 00 00       	call   80104b58 <memset>
80102734:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102737:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010273c:	85 c0                	test   %eax,%eax
8010273e:	74 10                	je     80102750 <kfree+0x65>
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 c0 40 19 80       	push   $0x801940c0
80102748:	e8 95 21 00 00       	call   801048e2 <acquire>
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
8010277a:	e8 d1 21 00 00       	call   80104950 <release>
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
8010279c:	e8 41 21 00 00       	call   801048e2 <acquire>
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
801027cd:	e8 7e 21 00 00       	call   80104950 <release>
801027d2:	83 c4 10             	add    $0x10,%esp

  if (r)
801027d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027d9:	74 17                	je     801027f2 <kalloc+0x6d>
    memset((char*)r, 5, PGSIZE); // fill with junk
801027db:	83 ec 04             	sub    $0x4,%esp
801027de:	68 00 10 00 00       	push   $0x1000
801027e3:	6a 05                	push   $0x5
801027e5:	ff 75 f4             	push   -0xc(%ebp)
801027e8:	e8 6b 23 00 00       	call   80104b58 <memset>
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	eb 10                	jmp    80102802 <kalloc+0x7d>
  else
    cprintf("kalloc: out of memory\n");
801027f2:	83 ec 0c             	sub    $0xc,%esp
801027f5:	68 51 a7 10 80       	push   $0x8010a751
801027fa:	e8 f5 db ff ff       	call   801003f4 <cprintf>
801027ff:	83 c4 10             	add    $0x10,%esp

  return (char*)r;
80102802:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102805:	c9                   	leave  
80102806:	c3                   	ret    

80102807 <inb>:
{
80102807:	55                   	push   %ebp
80102808:	89 e5                	mov    %esp,%ebp
8010280a:	83 ec 14             	sub    $0x14,%esp
8010280d:	8b 45 08             	mov    0x8(%ebp),%eax
80102810:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102814:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102818:	89 c2                	mov    %eax,%edx
8010281a:	ec                   	in     (%dx),%al
8010281b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010281e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102822:	c9                   	leave  
80102823:	c3                   	ret    

80102824 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102824:	55                   	push   %ebp
80102825:	89 e5                	mov    %esp,%ebp
80102827:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
8010282a:	6a 64                	push   $0x64
8010282c:	e8 d6 ff ff ff       	call   80102807 <inb>
80102831:	83 c4 04             	add    $0x4,%esp
80102834:	0f b6 c0             	movzbl %al,%eax
80102837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
8010283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283d:	83 e0 01             	and    $0x1,%eax
80102840:	85 c0                	test   %eax,%eax
80102842:	75 0a                	jne    8010284e <kbdgetc+0x2a>
    return -1;
80102844:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102849:	e9 23 01 00 00       	jmp    80102971 <kbdgetc+0x14d>
  data = inb(KBDATAP);
8010284e:	6a 60                	push   $0x60
80102850:	e8 b2 ff ff ff       	call   80102807 <inb>
80102855:	83 c4 04             	add    $0x4,%esp
80102858:	0f b6 c0             	movzbl %al,%eax
8010285b:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
8010285e:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102865:	75 17                	jne    8010287e <kbdgetc+0x5a>
    shift |= E0ESC;
80102867:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010286c:	83 c8 40             	or     $0x40,%eax
8010286f:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
80102874:	b8 00 00 00 00       	mov    $0x0,%eax
80102879:	e9 f3 00 00 00       	jmp    80102971 <kbdgetc+0x14d>
  } else if(data & 0x80){
8010287e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102881:	25 80 00 00 00       	and    $0x80,%eax
80102886:	85 c0                	test   %eax,%eax
80102888:	74 45                	je     801028cf <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010288a:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010288f:	83 e0 40             	and    $0x40,%eax
80102892:	85 c0                	test   %eax,%eax
80102894:	75 08                	jne    8010289e <kbdgetc+0x7a>
80102896:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102899:	83 e0 7f             	and    $0x7f,%eax
8010289c:	eb 03                	jmp    801028a1 <kbdgetc+0x7d>
8010289e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
801028a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028a7:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028ac:	0f b6 00             	movzbl (%eax),%eax
801028af:	83 c8 40             	or     $0x40,%eax
801028b2:	0f b6 c0             	movzbl %al,%eax
801028b5:	f7 d0                	not    %eax
801028b7:	89 c2                	mov    %eax,%edx
801028b9:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028be:	21 d0                	and    %edx,%eax
801028c0:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
801028c5:	b8 00 00 00 00       	mov    $0x0,%eax
801028ca:	e9 a2 00 00 00       	jmp    80102971 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801028cf:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028d4:	83 e0 40             	and    $0x40,%eax
801028d7:	85 c0                	test   %eax,%eax
801028d9:	74 14                	je     801028ef <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028db:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801028e2:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028e7:	83 e0 bf             	and    $0xffffffbf,%eax
801028ea:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  }

  shift |= shiftcode[data];
801028ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028f2:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028f7:	0f b6 00             	movzbl (%eax),%eax
801028fa:	0f b6 d0             	movzbl %al,%edx
801028fd:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102902:	09 d0                	or     %edx,%eax
80102904:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  shift ^= togglecode[data];
80102909:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010290c:	05 20 d1 10 80       	add    $0x8010d120,%eax
80102911:	0f b6 00             	movzbl (%eax),%eax
80102914:	0f b6 d0             	movzbl %al,%edx
80102917:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010291c:	31 d0                	xor    %edx,%eax
8010291e:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102923:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102928:	83 e0 03             	and    $0x3,%eax
8010292b:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102932:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102935:	01 d0                	add    %edx,%eax
80102937:	0f b6 00             	movzbl (%eax),%eax
8010293a:	0f b6 c0             	movzbl %al,%eax
8010293d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102940:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102945:	83 e0 08             	and    $0x8,%eax
80102948:	85 c0                	test   %eax,%eax
8010294a:	74 22                	je     8010296e <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010294c:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102950:	76 0c                	jbe    8010295e <kbdgetc+0x13a>
80102952:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102956:	77 06                	ja     8010295e <kbdgetc+0x13a>
      c += 'A' - 'a';
80102958:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010295c:	eb 10                	jmp    8010296e <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010295e:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102962:	76 0a                	jbe    8010296e <kbdgetc+0x14a>
80102964:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102968:	77 04                	ja     8010296e <kbdgetc+0x14a>
      c += 'a' - 'A';
8010296a:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
8010296e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102971:	c9                   	leave  
80102972:	c3                   	ret    

80102973 <kbdintr>:

void
kbdintr(void)
{
80102973:	55                   	push   %ebp
80102974:	89 e5                	mov    %esp,%ebp
80102976:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102979:	83 ec 0c             	sub    $0xc,%esp
8010297c:	68 24 28 10 80       	push   $0x80102824
80102981:	e8 50 de ff ff       	call   801007d6 <consoleintr>
80102986:	83 c4 10             	add    $0x10,%esp
}
80102989:	90                   	nop
8010298a:	c9                   	leave  
8010298b:	c3                   	ret    

8010298c <inb>:
{
8010298c:	55                   	push   %ebp
8010298d:	89 e5                	mov    %esp,%ebp
8010298f:	83 ec 14             	sub    $0x14,%esp
80102992:	8b 45 08             	mov    0x8(%ebp),%eax
80102995:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102999:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010299d:	89 c2                	mov    %eax,%edx
8010299f:	ec                   	in     (%dx),%al
801029a0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801029a3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801029a7:	c9                   	leave  
801029a8:	c3                   	ret    

801029a9 <outb>:
{
801029a9:	55                   	push   %ebp
801029aa:	89 e5                	mov    %esp,%ebp
801029ac:	83 ec 08             	sub    $0x8,%esp
801029af:	8b 45 08             	mov    0x8(%ebp),%eax
801029b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801029b5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801029b9:	89 d0                	mov    %edx,%eax
801029bb:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029be:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801029c2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801029c6:	ee                   	out    %al,(%dx)
}
801029c7:	90                   	nop
801029c8:	c9                   	leave  
801029c9:	c3                   	ret    

801029ca <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801029ca:	55                   	push   %ebp
801029cb:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801029cd:	8b 15 00 41 19 80    	mov    0x80194100,%edx
801029d3:	8b 45 08             	mov    0x8(%ebp),%eax
801029d6:	c1 e0 02             	shl    $0x2,%eax
801029d9:	01 c2                	add    %eax,%edx
801029db:	8b 45 0c             	mov    0xc(%ebp),%eax
801029de:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801029e0:	a1 00 41 19 80       	mov    0x80194100,%eax
801029e5:	83 c0 20             	add    $0x20,%eax
801029e8:	8b 00                	mov    (%eax),%eax
}
801029ea:	90                   	nop
801029eb:	5d                   	pop    %ebp
801029ec:	c3                   	ret    

801029ed <lapicinit>:

void
lapicinit(void)
{
801029ed:	55                   	push   %ebp
801029ee:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029f0:	a1 00 41 19 80       	mov    0x80194100,%eax
801029f5:	85 c0                	test   %eax,%eax
801029f7:	0f 84 0c 01 00 00    	je     80102b09 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801029fd:	68 3f 01 00 00       	push   $0x13f
80102a02:	6a 3c                	push   $0x3c
80102a04:	e8 c1 ff ff ff       	call   801029ca <lapicw>
80102a09:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102a0c:	6a 0b                	push   $0xb
80102a0e:	68 f8 00 00 00       	push   $0xf8
80102a13:	e8 b2 ff ff ff       	call   801029ca <lapicw>
80102a18:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102a1b:	68 20 00 02 00       	push   $0x20020
80102a20:	68 c8 00 00 00       	push   $0xc8
80102a25:	e8 a0 ff ff ff       	call   801029ca <lapicw>
80102a2a:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102a2d:	68 80 96 98 00       	push   $0x989680
80102a32:	68 e0 00 00 00       	push   $0xe0
80102a37:	e8 8e ff ff ff       	call   801029ca <lapicw>
80102a3c:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102a3f:	68 00 00 01 00       	push   $0x10000
80102a44:	68 d4 00 00 00       	push   $0xd4
80102a49:	e8 7c ff ff ff       	call   801029ca <lapicw>
80102a4e:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102a51:	68 00 00 01 00       	push   $0x10000
80102a56:	68 d8 00 00 00       	push   $0xd8
80102a5b:	e8 6a ff ff ff       	call   801029ca <lapicw>
80102a60:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a63:	a1 00 41 19 80       	mov    0x80194100,%eax
80102a68:	83 c0 30             	add    $0x30,%eax
80102a6b:	8b 00                	mov    (%eax),%eax
80102a6d:	c1 e8 10             	shr    $0x10,%eax
80102a70:	25 fc 00 00 00       	and    $0xfc,%eax
80102a75:	85 c0                	test   %eax,%eax
80102a77:	74 12                	je     80102a8b <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102a79:	68 00 00 01 00       	push   $0x10000
80102a7e:	68 d0 00 00 00       	push   $0xd0
80102a83:	e8 42 ff ff ff       	call   801029ca <lapicw>
80102a88:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102a8b:	6a 33                	push   $0x33
80102a8d:	68 dc 00 00 00       	push   $0xdc
80102a92:	e8 33 ff ff ff       	call   801029ca <lapicw>
80102a97:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102a9a:	6a 00                	push   $0x0
80102a9c:	68 a0 00 00 00       	push   $0xa0
80102aa1:	e8 24 ff ff ff       	call   801029ca <lapicw>
80102aa6:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102aa9:	6a 00                	push   $0x0
80102aab:	68 a0 00 00 00       	push   $0xa0
80102ab0:	e8 15 ff ff ff       	call   801029ca <lapicw>
80102ab5:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ab8:	6a 00                	push   $0x0
80102aba:	6a 2c                	push   $0x2c
80102abc:	e8 09 ff ff ff       	call   801029ca <lapicw>
80102ac1:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ac4:	6a 00                	push   $0x0
80102ac6:	68 c4 00 00 00       	push   $0xc4
80102acb:	e8 fa fe ff ff       	call   801029ca <lapicw>
80102ad0:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ad3:	68 00 85 08 00       	push   $0x88500
80102ad8:	68 c0 00 00 00       	push   $0xc0
80102add:	e8 e8 fe ff ff       	call   801029ca <lapicw>
80102ae2:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ae5:	90                   	nop
80102ae6:	a1 00 41 19 80       	mov    0x80194100,%eax
80102aeb:	05 00 03 00 00       	add    $0x300,%eax
80102af0:	8b 00                	mov    (%eax),%eax
80102af2:	25 00 10 00 00       	and    $0x1000,%eax
80102af7:	85 c0                	test   %eax,%eax
80102af9:	75 eb                	jne    80102ae6 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102afb:	6a 00                	push   $0x0
80102afd:	6a 20                	push   $0x20
80102aff:	e8 c6 fe ff ff       	call   801029ca <lapicw>
80102b04:	83 c4 08             	add    $0x8,%esp
80102b07:	eb 01                	jmp    80102b0a <lapicinit+0x11d>
    return;
80102b09:	90                   	nop
}
80102b0a:	c9                   	leave  
80102b0b:	c3                   	ret    

80102b0c <lapicid>:

int
lapicid(void)
{
80102b0c:	55                   	push   %ebp
80102b0d:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102b0f:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b14:	85 c0                	test   %eax,%eax
80102b16:	75 07                	jne    80102b1f <lapicid+0x13>
    return 0;
80102b18:	b8 00 00 00 00       	mov    $0x0,%eax
80102b1d:	eb 0d                	jmp    80102b2c <lapicid+0x20>
  }
  return lapic[ID] >> 24;
80102b1f:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b24:	83 c0 20             	add    $0x20,%eax
80102b27:	8b 00                	mov    (%eax),%eax
80102b29:	c1 e8 18             	shr    $0x18,%eax
}
80102b2c:	5d                   	pop    %ebp
80102b2d:	c3                   	ret    

80102b2e <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b2e:	55                   	push   %ebp
80102b2f:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b31:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b36:	85 c0                	test   %eax,%eax
80102b38:	74 0c                	je     80102b46 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102b3a:	6a 00                	push   $0x0
80102b3c:	6a 2c                	push   $0x2c
80102b3e:	e8 87 fe ff ff       	call   801029ca <lapicw>
80102b43:	83 c4 08             	add    $0x8,%esp
}
80102b46:	90                   	nop
80102b47:	c9                   	leave  
80102b48:	c3                   	ret    

80102b49 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b49:	55                   	push   %ebp
80102b4a:	89 e5                	mov    %esp,%ebp
}
80102b4c:	90                   	nop
80102b4d:	5d                   	pop    %ebp
80102b4e:	c3                   	ret    

80102b4f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b4f:	55                   	push   %ebp
80102b50:	89 e5                	mov    %esp,%ebp
80102b52:	83 ec 14             	sub    $0x14,%esp
80102b55:	8b 45 08             	mov    0x8(%ebp),%eax
80102b58:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102b5b:	6a 0f                	push   $0xf
80102b5d:	6a 70                	push   $0x70
80102b5f:	e8 45 fe ff ff       	call   801029a9 <outb>
80102b64:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102b67:	6a 0a                	push   $0xa
80102b69:	6a 71                	push   $0x71
80102b6b:	e8 39 fe ff ff       	call   801029a9 <outb>
80102b70:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102b73:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102b7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b7d:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102b82:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b85:	c1 e8 04             	shr    $0x4,%eax
80102b88:	89 c2                	mov    %eax,%edx
80102b8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b8d:	83 c0 02             	add    $0x2,%eax
80102b90:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b93:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102b97:	c1 e0 18             	shl    $0x18,%eax
80102b9a:	50                   	push   %eax
80102b9b:	68 c4 00 00 00       	push   $0xc4
80102ba0:	e8 25 fe ff ff       	call   801029ca <lapicw>
80102ba5:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ba8:	68 00 c5 00 00       	push   $0xc500
80102bad:	68 c0 00 00 00       	push   $0xc0
80102bb2:	e8 13 fe ff ff       	call   801029ca <lapicw>
80102bb7:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102bba:	68 c8 00 00 00       	push   $0xc8
80102bbf:	e8 85 ff ff ff       	call   80102b49 <microdelay>
80102bc4:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102bc7:	68 00 85 00 00       	push   $0x8500
80102bcc:	68 c0 00 00 00       	push   $0xc0
80102bd1:	e8 f4 fd ff ff       	call   801029ca <lapicw>
80102bd6:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102bd9:	6a 64                	push   $0x64
80102bdb:	e8 69 ff ff ff       	call   80102b49 <microdelay>
80102be0:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102be3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102bea:	eb 3d                	jmp    80102c29 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80102bec:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102bf0:	c1 e0 18             	shl    $0x18,%eax
80102bf3:	50                   	push   %eax
80102bf4:	68 c4 00 00 00       	push   $0xc4
80102bf9:	e8 cc fd ff ff       	call   801029ca <lapicw>
80102bfe:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c01:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c04:	c1 e8 0c             	shr    $0xc,%eax
80102c07:	80 cc 06             	or     $0x6,%ah
80102c0a:	50                   	push   %eax
80102c0b:	68 c0 00 00 00       	push   $0xc0
80102c10:	e8 b5 fd ff ff       	call   801029ca <lapicw>
80102c15:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102c18:	68 c8 00 00 00       	push   $0xc8
80102c1d:	e8 27 ff ff ff       	call   80102b49 <microdelay>
80102c22:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80102c25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102c29:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102c2d:	7e bd                	jle    80102bec <lapicstartap+0x9d>
  }
}
80102c2f:	90                   	nop
80102c30:	90                   	nop
80102c31:	c9                   	leave  
80102c32:	c3                   	ret    

80102c33 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102c33:	55                   	push   %ebp
80102c34:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80102c36:	8b 45 08             	mov    0x8(%ebp),%eax
80102c39:	0f b6 c0             	movzbl %al,%eax
80102c3c:	50                   	push   %eax
80102c3d:	6a 70                	push   $0x70
80102c3f:	e8 65 fd ff ff       	call   801029a9 <outb>
80102c44:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102c47:	68 c8 00 00 00       	push   $0xc8
80102c4c:	e8 f8 fe ff ff       	call   80102b49 <microdelay>
80102c51:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80102c54:	6a 71                	push   $0x71
80102c56:	e8 31 fd ff ff       	call   8010298c <inb>
80102c5b:	83 c4 04             	add    $0x4,%esp
80102c5e:	0f b6 c0             	movzbl %al,%eax
}
80102c61:	c9                   	leave  
80102c62:	c3                   	ret    

80102c63 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102c63:	55                   	push   %ebp
80102c64:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80102c66:	6a 00                	push   $0x0
80102c68:	e8 c6 ff ff ff       	call   80102c33 <cmos_read>
80102c6d:	83 c4 04             	add    $0x4,%esp
80102c70:	8b 55 08             	mov    0x8(%ebp),%edx
80102c73:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80102c75:	6a 02                	push   $0x2
80102c77:	e8 b7 ff ff ff       	call   80102c33 <cmos_read>
80102c7c:	83 c4 04             	add    $0x4,%esp
80102c7f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c82:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80102c85:	6a 04                	push   $0x4
80102c87:	e8 a7 ff ff ff       	call   80102c33 <cmos_read>
80102c8c:	83 c4 04             	add    $0x4,%esp
80102c8f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c92:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80102c95:	6a 07                	push   $0x7
80102c97:	e8 97 ff ff ff       	call   80102c33 <cmos_read>
80102c9c:	83 c4 04             	add    $0x4,%esp
80102c9f:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca2:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80102ca5:	6a 08                	push   $0x8
80102ca7:	e8 87 ff ff ff       	call   80102c33 <cmos_read>
80102cac:	83 c4 04             	add    $0x4,%esp
80102caf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cb2:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80102cb5:	6a 09                	push   $0x9
80102cb7:	e8 77 ff ff ff       	call   80102c33 <cmos_read>
80102cbc:	83 c4 04             	add    $0x4,%esp
80102cbf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cc2:	89 42 14             	mov    %eax,0x14(%edx)
}
80102cc5:	90                   	nop
80102cc6:	c9                   	leave  
80102cc7:	c3                   	ret    

80102cc8 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102cc8:	55                   	push   %ebp
80102cc9:	89 e5                	mov    %esp,%ebp
80102ccb:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102cce:	6a 0b                	push   $0xb
80102cd0:	e8 5e ff ff ff       	call   80102c33 <cmos_read>
80102cd5:	83 c4 04             	add    $0x4,%esp
80102cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80102cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cde:	83 e0 04             	and    $0x4,%eax
80102ce1:	85 c0                	test   %eax,%eax
80102ce3:	0f 94 c0             	sete   %al
80102ce6:	0f b6 c0             	movzbl %al,%eax
80102ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102cec:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cef:	50                   	push   %eax
80102cf0:	e8 6e ff ff ff       	call   80102c63 <fill_rtcdate>
80102cf5:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102cf8:	6a 0a                	push   $0xa
80102cfa:	e8 34 ff ff ff       	call   80102c33 <cmos_read>
80102cff:	83 c4 04             	add    $0x4,%esp
80102d02:	25 80 00 00 00       	and    $0x80,%eax
80102d07:	85 c0                	test   %eax,%eax
80102d09:	75 27                	jne    80102d32 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80102d0b:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102d0e:	50                   	push   %eax
80102d0f:	e8 4f ff ff ff       	call   80102c63 <fill_rtcdate>
80102d14:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d17:	83 ec 04             	sub    $0x4,%esp
80102d1a:	6a 18                	push   $0x18
80102d1c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102d1f:	50                   	push   %eax
80102d20:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102d23:	50                   	push   %eax
80102d24:	e8 96 1e 00 00       	call   80104bbf <memcmp>
80102d29:	83 c4 10             	add    $0x10,%esp
80102d2c:	85 c0                	test   %eax,%eax
80102d2e:	74 05                	je     80102d35 <cmostime+0x6d>
80102d30:	eb ba                	jmp    80102cec <cmostime+0x24>
        continue;
80102d32:	90                   	nop
    fill_rtcdate(&t1);
80102d33:	eb b7                	jmp    80102cec <cmostime+0x24>
      break;
80102d35:	90                   	nop
  }

  // convert
  if(bcd) {
80102d36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102d3a:	0f 84 b4 00 00 00    	je     80102df4 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d40:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d43:	c1 e8 04             	shr    $0x4,%eax
80102d46:	89 c2                	mov    %eax,%edx
80102d48:	89 d0                	mov    %edx,%eax
80102d4a:	c1 e0 02             	shl    $0x2,%eax
80102d4d:	01 d0                	add    %edx,%eax
80102d4f:	01 c0                	add    %eax,%eax
80102d51:	89 c2                	mov    %eax,%edx
80102d53:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	01 d0                	add    %edx,%eax
80102d5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80102d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d61:	c1 e8 04             	shr    $0x4,%eax
80102d64:	89 c2                	mov    %eax,%edx
80102d66:	89 d0                	mov    %edx,%eax
80102d68:	c1 e0 02             	shl    $0x2,%eax
80102d6b:	01 d0                	add    %edx,%eax
80102d6d:	01 c0                	add    %eax,%eax
80102d6f:	89 c2                	mov    %eax,%edx
80102d71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d74:	83 e0 0f             	and    $0xf,%eax
80102d77:	01 d0                	add    %edx,%eax
80102d79:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80102d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d7f:	c1 e8 04             	shr    $0x4,%eax
80102d82:	89 c2                	mov    %eax,%edx
80102d84:	89 d0                	mov    %edx,%eax
80102d86:	c1 e0 02             	shl    $0x2,%eax
80102d89:	01 d0                	add    %edx,%eax
80102d8b:	01 c0                	add    %eax,%eax
80102d8d:	89 c2                	mov    %eax,%edx
80102d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d92:	83 e0 0f             	and    $0xf,%eax
80102d95:	01 d0                	add    %edx,%eax
80102d97:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80102d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d9d:	c1 e8 04             	shr    $0x4,%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	89 d0                	mov    %edx,%eax
80102da4:	c1 e0 02             	shl    $0x2,%eax
80102da7:	01 d0                	add    %edx,%eax
80102da9:	01 c0                	add    %eax,%eax
80102dab:	89 c2                	mov    %eax,%edx
80102dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102db0:	83 e0 0f             	and    $0xf,%eax
80102db3:	01 d0                	add    %edx,%eax
80102db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80102db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dbb:	c1 e8 04             	shr    $0x4,%eax
80102dbe:	89 c2                	mov    %eax,%edx
80102dc0:	89 d0                	mov    %edx,%eax
80102dc2:	c1 e0 02             	shl    $0x2,%eax
80102dc5:	01 d0                	add    %edx,%eax
80102dc7:	01 c0                	add    %eax,%eax
80102dc9:	89 c2                	mov    %eax,%edx
80102dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dce:	83 e0 0f             	and    $0xf,%eax
80102dd1:	01 d0                	add    %edx,%eax
80102dd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80102dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dd9:	c1 e8 04             	shr    $0x4,%eax
80102ddc:	89 c2                	mov    %eax,%edx
80102dde:	89 d0                	mov    %edx,%eax
80102de0:	c1 e0 02             	shl    $0x2,%eax
80102de3:	01 d0                	add    %edx,%eax
80102de5:	01 c0                	add    %eax,%eax
80102de7:	89 c2                	mov    %eax,%edx
80102de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dec:	83 e0 0f             	and    $0xf,%eax
80102def:	01 d0                	add    %edx,%eax
80102df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80102df4:	8b 45 08             	mov    0x8(%ebp),%eax
80102df7:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102dfa:	89 10                	mov    %edx,(%eax)
80102dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102dff:	89 50 04             	mov    %edx,0x4(%eax)
80102e02:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102e05:	89 50 08             	mov    %edx,0x8(%eax)
80102e08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102e0b:	89 50 0c             	mov    %edx,0xc(%eax)
80102e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102e11:	89 50 10             	mov    %edx,0x10(%eax)
80102e14:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102e17:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80102e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e1d:	8b 40 14             	mov    0x14(%eax),%eax
80102e20:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102e26:	8b 45 08             	mov    0x8(%ebp),%eax
80102e29:	89 50 14             	mov    %edx,0x14(%eax)
}
80102e2c:	90                   	nop
80102e2d:	c9                   	leave  
80102e2e:	c3                   	ret    

80102e2f <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e2f:	55                   	push   %ebp
80102e30:	89 e5                	mov    %esp,%ebp
80102e32:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e35:	83 ec 08             	sub    $0x8,%esp
80102e38:	68 68 a7 10 80       	push   $0x8010a768
80102e3d:	68 20 41 19 80       	push   $0x80194120
80102e42:	e8 79 1a 00 00       	call   801048c0 <initlock>
80102e47:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80102e4a:	83 ec 08             	sub    $0x8,%esp
80102e4d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e50:	50                   	push   %eax
80102e51:	ff 75 08             	push   0x8(%ebp)
80102e54:	e8 5a e5 ff ff       	call   801013b3 <readsb>
80102e59:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80102e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e5f:	a3 54 41 19 80       	mov    %eax,0x80194154
  log.size = sb.nlog;
80102e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102e67:	a3 58 41 19 80       	mov    %eax,0x80194158
  log.dev = dev;
80102e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80102e6f:	a3 64 41 19 80       	mov    %eax,0x80194164
  recover_from_log();
80102e74:	e8 b3 01 00 00       	call   8010302c <recover_from_log>
}
80102e79:	90                   	nop
80102e7a:	c9                   	leave  
80102e7b:	c3                   	ret    

80102e7c <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e7c:	55                   	push   %ebp
80102e7d:	89 e5                	mov    %esp,%ebp
80102e7f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e89:	e9 95 00 00 00       	jmp    80102f23 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e8e:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80102e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e97:	01 d0                	add    %edx,%eax
80102e99:	83 c0 01             	add    $0x1,%eax
80102e9c:	89 c2                	mov    %eax,%edx
80102e9e:	a1 64 41 19 80       	mov    0x80194164,%eax
80102ea3:	83 ec 08             	sub    $0x8,%esp
80102ea6:	52                   	push   %edx
80102ea7:	50                   	push   %eax
80102ea8:	e8 54 d3 ff ff       	call   80100201 <bread>
80102ead:	83 c4 10             	add    $0x10,%esp
80102eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eb6:	83 c0 10             	add    $0x10,%eax
80102eb9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
80102ec0:	89 c2                	mov    %eax,%edx
80102ec2:	a1 64 41 19 80       	mov    0x80194164,%eax
80102ec7:	83 ec 08             	sub    $0x8,%esp
80102eca:	52                   	push   %edx
80102ecb:	50                   	push   %eax
80102ecc:	e8 30 d3 ff ff       	call   80100201 <bread>
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102eda:	8d 50 5c             	lea    0x5c(%eax),%edx
80102edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ee0:	83 c0 5c             	add    $0x5c,%eax
80102ee3:	83 ec 04             	sub    $0x4,%esp
80102ee6:	68 00 02 00 00       	push   $0x200
80102eeb:	52                   	push   %edx
80102eec:	50                   	push   %eax
80102eed:	e8 25 1d 00 00       	call   80104c17 <memmove>
80102ef2:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80102ef5:	83 ec 0c             	sub    $0xc,%esp
80102ef8:	ff 75 ec             	push   -0x14(%ebp)
80102efb:	e8 3a d3 ff ff       	call   8010023a <bwrite>
80102f00:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80102f03:	83 ec 0c             	sub    $0xc,%esp
80102f06:	ff 75 f0             	push   -0x10(%ebp)
80102f09:	e8 75 d3 ff ff       	call   80100283 <brelse>
80102f0e:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80102f11:	83 ec 0c             	sub    $0xc,%esp
80102f14:	ff 75 ec             	push   -0x14(%ebp)
80102f17:	e8 67 d3 ff ff       	call   80100283 <brelse>
80102f1c:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102f1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f23:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f2b:	0f 8c 5d ff ff ff    	jl     80102e8e <install_trans+0x12>
  }
}
80102f31:	90                   	nop
80102f32:	90                   	nop
80102f33:	c9                   	leave  
80102f34:	c3                   	ret    

80102f35 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102f35:	55                   	push   %ebp
80102f36:	89 e5                	mov    %esp,%ebp
80102f38:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f3b:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f40:	89 c2                	mov    %eax,%edx
80102f42:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f47:	83 ec 08             	sub    $0x8,%esp
80102f4a:	52                   	push   %edx
80102f4b:	50                   	push   %eax
80102f4c:	e8 b0 d2 ff ff       	call   80100201 <bread>
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80102f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f5a:	83 c0 5c             	add    $0x5c,%eax
80102f5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80102f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f63:	8b 00                	mov    (%eax),%eax
80102f65:	a3 68 41 19 80       	mov    %eax,0x80194168
  for (i = 0; i < log.lh.n; i++) {
80102f6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f71:	eb 1b                	jmp    80102f8e <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80102f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f79:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f80:	83 c2 10             	add    $0x10,%edx
80102f83:	89 04 95 2c 41 19 80 	mov    %eax,-0x7fe6bed4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f8a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f8e:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f93:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f96:	7c db                	jl     80102f73 <read_head+0x3e>
  }
  brelse(buf);
80102f98:	83 ec 0c             	sub    $0xc,%esp
80102f9b:	ff 75 f0             	push   -0x10(%ebp)
80102f9e:	e8 e0 d2 ff ff       	call   80100283 <brelse>
80102fa3:	83 c4 10             	add    $0x10,%esp
}
80102fa6:	90                   	nop
80102fa7:	c9                   	leave  
80102fa8:	c3                   	ret    

80102fa9 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fa9:	55                   	push   %ebp
80102faa:	89 e5                	mov    %esp,%ebp
80102fac:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102faf:	a1 54 41 19 80       	mov    0x80194154,%eax
80102fb4:	89 c2                	mov    %eax,%edx
80102fb6:	a1 64 41 19 80       	mov    0x80194164,%eax
80102fbb:	83 ec 08             	sub    $0x8,%esp
80102fbe:	52                   	push   %edx
80102fbf:	50                   	push   %eax
80102fc0:	e8 3c d2 ff ff       	call   80100201 <bread>
80102fc5:	83 c4 10             	add    $0x10,%esp
80102fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80102fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102fce:	83 c0 5c             	add    $0x5c,%eax
80102fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80102fd4:	8b 15 68 41 19 80    	mov    0x80194168,%edx
80102fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fdd:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fe6:	eb 1b                	jmp    80103003 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80102fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102feb:	83 c0 10             	add    $0x10,%eax
80102fee:	8b 0c 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%ecx
80102ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102ffb:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103003:	a1 68 41 19 80       	mov    0x80194168,%eax
80103008:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010300b:	7c db                	jl     80102fe8 <write_head+0x3f>
  }
  bwrite(buf);
8010300d:	83 ec 0c             	sub    $0xc,%esp
80103010:	ff 75 f0             	push   -0x10(%ebp)
80103013:	e8 22 d2 ff ff       	call   8010023a <bwrite>
80103018:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010301b:	83 ec 0c             	sub    $0xc,%esp
8010301e:	ff 75 f0             	push   -0x10(%ebp)
80103021:	e8 5d d2 ff ff       	call   80100283 <brelse>
80103026:	83 c4 10             	add    $0x10,%esp
}
80103029:	90                   	nop
8010302a:	c9                   	leave  
8010302b:	c3                   	ret    

8010302c <recover_from_log>:

static void
recover_from_log(void)
{
8010302c:	55                   	push   %ebp
8010302d:	89 e5                	mov    %esp,%ebp
8010302f:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103032:	e8 fe fe ff ff       	call   80102f35 <read_head>
  install_trans(); // if committed, copy from log to disk
80103037:	e8 40 fe ff ff       	call   80102e7c <install_trans>
  log.lh.n = 0;
8010303c:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
80103043:	00 00 00 
  write_head(); // clear the log
80103046:	e8 5e ff ff ff       	call   80102fa9 <write_head>
}
8010304b:	90                   	nop
8010304c:	c9                   	leave  
8010304d:	c3                   	ret    

8010304e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103054:	83 ec 0c             	sub    $0xc,%esp
80103057:	68 20 41 19 80       	push   $0x80194120
8010305c:	e8 81 18 00 00       	call   801048e2 <acquire>
80103061:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103064:	a1 60 41 19 80       	mov    0x80194160,%eax
80103069:	85 c0                	test   %eax,%eax
8010306b:	74 17                	je     80103084 <begin_op+0x36>
      sleep(&log, &log.lock);
8010306d:	83 ec 08             	sub    $0x8,%esp
80103070:	68 20 41 19 80       	push   $0x80194120
80103075:	68 20 41 19 80       	push   $0x80194120
8010307a:	e8 00 13 00 00       	call   8010437f <sleep>
8010307f:	83 c4 10             	add    $0x10,%esp
80103082:	eb e0                	jmp    80103064 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103084:	8b 0d 68 41 19 80    	mov    0x80194168,%ecx
8010308a:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010308f:	8d 50 01             	lea    0x1(%eax),%edx
80103092:	89 d0                	mov    %edx,%eax
80103094:	c1 e0 02             	shl    $0x2,%eax
80103097:	01 d0                	add    %edx,%eax
80103099:	01 c0                	add    %eax,%eax
8010309b:	01 c8                	add    %ecx,%eax
8010309d:	83 f8 1e             	cmp    $0x1e,%eax
801030a0:	7e 17                	jle    801030b9 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801030a2:	83 ec 08             	sub    $0x8,%esp
801030a5:	68 20 41 19 80       	push   $0x80194120
801030aa:	68 20 41 19 80       	push   $0x80194120
801030af:	e8 cb 12 00 00       	call   8010437f <sleep>
801030b4:	83 c4 10             	add    $0x10,%esp
801030b7:	eb ab                	jmp    80103064 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801030b9:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030be:	83 c0 01             	add    $0x1,%eax
801030c1:	a3 5c 41 19 80       	mov    %eax,0x8019415c
      release(&log.lock);
801030c6:	83 ec 0c             	sub    $0xc,%esp
801030c9:	68 20 41 19 80       	push   $0x80194120
801030ce:	e8 7d 18 00 00       	call   80104950 <release>
801030d3:	83 c4 10             	add    $0x10,%esp
      break;
801030d6:	90                   	nop
    }
  }
}
801030d7:	90                   	nop
801030d8:	c9                   	leave  
801030d9:	c3                   	ret    

801030da <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801030e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801030e7:	83 ec 0c             	sub    $0xc,%esp
801030ea:	68 20 41 19 80       	push   $0x80194120
801030ef:	e8 ee 17 00 00       	call   801048e2 <acquire>
801030f4:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030f7:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030fc:	83 e8 01             	sub    $0x1,%eax
801030ff:	a3 5c 41 19 80       	mov    %eax,0x8019415c
  if(log.committing)
80103104:	a1 60 41 19 80       	mov    0x80194160,%eax
80103109:	85 c0                	test   %eax,%eax
8010310b:	74 0d                	je     8010311a <end_op+0x40>
    panic("log.committing");
8010310d:	83 ec 0c             	sub    $0xc,%esp
80103110:	68 6c a7 10 80       	push   $0x8010a76c
80103115:	e8 8f d4 ff ff       	call   801005a9 <panic>
  if(log.outstanding == 0){
8010311a:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010311f:	85 c0                	test   %eax,%eax
80103121:	75 13                	jne    80103136 <end_op+0x5c>
    do_commit = 1;
80103123:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010312a:	c7 05 60 41 19 80 01 	movl   $0x1,0x80194160
80103131:	00 00 00 
80103134:	eb 10                	jmp    80103146 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 20 41 19 80       	push   $0x80194120
8010313e:	e8 23 13 00 00       	call   80104466 <wakeup>
80103143:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	68 20 41 19 80       	push   $0x80194120
8010314e:	e8 fd 17 00 00       	call   80104950 <release>
80103153:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010315a:	74 3f                	je     8010319b <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010315c:	e8 f6 00 00 00       	call   80103257 <commit>
    acquire(&log.lock);
80103161:	83 ec 0c             	sub    $0xc,%esp
80103164:	68 20 41 19 80       	push   $0x80194120
80103169:	e8 74 17 00 00       	call   801048e2 <acquire>
8010316e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103171:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103178:	00 00 00 
    wakeup(&log);
8010317b:	83 ec 0c             	sub    $0xc,%esp
8010317e:	68 20 41 19 80       	push   $0x80194120
80103183:	e8 de 12 00 00       	call   80104466 <wakeup>
80103188:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010318b:	83 ec 0c             	sub    $0xc,%esp
8010318e:	68 20 41 19 80       	push   $0x80194120
80103193:	e8 b8 17 00 00       	call   80104950 <release>
80103198:	83 c4 10             	add    $0x10,%esp
  }
}
8010319b:	90                   	nop
8010319c:	c9                   	leave  
8010319d:	c3                   	ret    

8010319e <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010319e:	55                   	push   %ebp
8010319f:	89 e5                	mov    %esp,%ebp
801031a1:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031ab:	e9 95 00 00 00       	jmp    80103245 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031b0:	8b 15 54 41 19 80    	mov    0x80194154,%edx
801031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031b9:	01 d0                	add    %edx,%eax
801031bb:	83 c0 01             	add    $0x1,%eax
801031be:	89 c2                	mov    %eax,%edx
801031c0:	a1 64 41 19 80       	mov    0x80194164,%eax
801031c5:	83 ec 08             	sub    $0x8,%esp
801031c8:	52                   	push   %edx
801031c9:	50                   	push   %eax
801031ca:	e8 32 d0 ff ff       	call   80100201 <bread>
801031cf:	83 c4 10             	add    $0x10,%esp
801031d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031d8:	83 c0 10             	add    $0x10,%eax
801031db:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801031e2:	89 c2                	mov    %eax,%edx
801031e4:	a1 64 41 19 80       	mov    0x80194164,%eax
801031e9:	83 ec 08             	sub    $0x8,%esp
801031ec:	52                   	push   %edx
801031ed:	50                   	push   %eax
801031ee:	e8 0e d0 ff ff       	call   80100201 <bread>
801031f3:	83 c4 10             	add    $0x10,%esp
801031f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031fc:	8d 50 5c             	lea    0x5c(%eax),%edx
801031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103202:	83 c0 5c             	add    $0x5c,%eax
80103205:	83 ec 04             	sub    $0x4,%esp
80103208:	68 00 02 00 00       	push   $0x200
8010320d:	52                   	push   %edx
8010320e:	50                   	push   %eax
8010320f:	e8 03 1a 00 00       	call   80104c17 <memmove>
80103214:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103217:	83 ec 0c             	sub    $0xc,%esp
8010321a:	ff 75 f0             	push   -0x10(%ebp)
8010321d:	e8 18 d0 ff ff       	call   8010023a <bwrite>
80103222:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103225:	83 ec 0c             	sub    $0xc,%esp
80103228:	ff 75 ec             	push   -0x14(%ebp)
8010322b:	e8 53 d0 ff ff       	call   80100283 <brelse>
80103230:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103233:	83 ec 0c             	sub    $0xc,%esp
80103236:	ff 75 f0             	push   -0x10(%ebp)
80103239:	e8 45 d0 ff ff       	call   80100283 <brelse>
8010323e:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103241:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103245:	a1 68 41 19 80       	mov    0x80194168,%eax
8010324a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010324d:	0f 8c 5d ff ff ff    	jl     801031b0 <write_log+0x12>
  }
}
80103253:	90                   	nop
80103254:	90                   	nop
80103255:	c9                   	leave  
80103256:	c3                   	ret    

80103257 <commit>:

static void
commit()
{
80103257:	55                   	push   %ebp
80103258:	89 e5                	mov    %esp,%ebp
8010325a:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010325d:	a1 68 41 19 80       	mov    0x80194168,%eax
80103262:	85 c0                	test   %eax,%eax
80103264:	7e 1e                	jle    80103284 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103266:	e8 33 ff ff ff       	call   8010319e <write_log>
    write_head();    // Write header to disk -- the real commit
8010326b:	e8 39 fd ff ff       	call   80102fa9 <write_head>
    install_trans(); // Now install writes to home locations
80103270:	e8 07 fc ff ff       	call   80102e7c <install_trans>
    log.lh.n = 0;
80103275:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
8010327c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010327f:	e8 25 fd ff ff       	call   80102fa9 <write_head>
  }
}
80103284:	90                   	nop
80103285:	c9                   	leave  
80103286:	c3                   	ret    

80103287 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103287:	55                   	push   %ebp
80103288:	89 e5                	mov    %esp,%ebp
8010328a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010328d:	a1 68 41 19 80       	mov    0x80194168,%eax
80103292:	83 f8 1d             	cmp    $0x1d,%eax
80103295:	7f 12                	jg     801032a9 <log_write+0x22>
80103297:	a1 68 41 19 80       	mov    0x80194168,%eax
8010329c:	8b 15 58 41 19 80    	mov    0x80194158,%edx
801032a2:	83 ea 01             	sub    $0x1,%edx
801032a5:	39 d0                	cmp    %edx,%eax
801032a7:	7c 0d                	jl     801032b6 <log_write+0x2f>
    panic("too big a transaction");
801032a9:	83 ec 0c             	sub    $0xc,%esp
801032ac:	68 7b a7 10 80       	push   $0x8010a77b
801032b1:	e8 f3 d2 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032b6:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032bb:	85 c0                	test   %eax,%eax
801032bd:	7f 0d                	jg     801032cc <log_write+0x45>
    panic("log_write outside of trans");
801032bf:	83 ec 0c             	sub    $0xc,%esp
801032c2:	68 91 a7 10 80       	push   $0x8010a791
801032c7:	e8 dd d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032cc:	83 ec 0c             	sub    $0xc,%esp
801032cf:	68 20 41 19 80       	push   $0x80194120
801032d4:	e8 09 16 00 00       	call   801048e2 <acquire>
801032d9:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801032dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032e3:	eb 1d                	jmp    80103302 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e8:	83 c0 10             	add    $0x10,%eax
801032eb:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801032f2:	89 c2                	mov    %eax,%edx
801032f4:	8b 45 08             	mov    0x8(%ebp),%eax
801032f7:	8b 40 08             	mov    0x8(%eax),%eax
801032fa:	39 c2                	cmp    %eax,%edx
801032fc:	74 10                	je     8010330e <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801032fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103302:	a1 68 41 19 80       	mov    0x80194168,%eax
80103307:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010330a:	7c d9                	jl     801032e5 <log_write+0x5e>
8010330c:	eb 01                	jmp    8010330f <log_write+0x88>
      break;
8010330e:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010330f:	8b 45 08             	mov    0x8(%ebp),%eax
80103312:	8b 40 08             	mov    0x8(%eax),%eax
80103315:	89 c2                	mov    %eax,%edx
80103317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010331a:	83 c0 10             	add    $0x10,%eax
8010331d:	89 14 85 2c 41 19 80 	mov    %edx,-0x7fe6bed4(,%eax,4)
  if (i == log.lh.n)
80103324:	a1 68 41 19 80       	mov    0x80194168,%eax
80103329:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010332c:	75 0d                	jne    8010333b <log_write+0xb4>
    log.lh.n++;
8010332e:	a1 68 41 19 80       	mov    0x80194168,%eax
80103333:	83 c0 01             	add    $0x1,%eax
80103336:	a3 68 41 19 80       	mov    %eax,0x80194168
  b->flags |= B_DIRTY; // prevent eviction
8010333b:	8b 45 08             	mov    0x8(%ebp),%eax
8010333e:	8b 00                	mov    (%eax),%eax
80103340:	83 c8 04             	or     $0x4,%eax
80103343:	89 c2                	mov    %eax,%edx
80103345:	8b 45 08             	mov    0x8(%ebp),%eax
80103348:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010334a:	83 ec 0c             	sub    $0xc,%esp
8010334d:	68 20 41 19 80       	push   $0x80194120
80103352:	e8 f9 15 00 00       	call   80104950 <release>
80103357:	83 c4 10             	add    $0x10,%esp
}
8010335a:	90                   	nop
8010335b:	c9                   	leave  
8010335c:	c3                   	ret    

8010335d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010335d:	55                   	push   %ebp
8010335e:	89 e5                	mov    %esp,%ebp
80103360:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103363:	8b 55 08             	mov    0x8(%ebp),%edx
80103366:	8b 45 0c             	mov    0xc(%ebp),%eax
80103369:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010336c:	f0 87 02             	lock xchg %eax,(%edx)
8010336f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103372:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103375:	c9                   	leave  
80103376:	c3                   	ret    

80103377 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103377:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010337b:	83 e4 f0             	and    $0xfffffff0,%esp
8010337e:	ff 71 fc             	push   -0x4(%ecx)
80103381:	55                   	push   %ebp
80103382:	89 e5                	mov    %esp,%ebp
80103384:	51                   	push   %ecx
80103385:	83 ec 04             	sub    $0x4,%esp
  graphic_init();
80103388:	e8 43 4f 00 00       	call   801082d0 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010338d:	83 ec 08             	sub    $0x8,%esp
80103390:	68 00 00 40 80       	push   $0x80400000
80103395:	68 00 90 19 80       	push   $0x80199000
8010339a:	e8 b1 f2 ff ff       	call   80102650 <kinit1>
8010339f:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801033a2:	e8 78 44 00 00       	call   8010781f <kvmalloc>
  mpinit_uefi();
801033a7:	e8 ea 4c 00 00       	call   80108096 <mpinit_uefi>
  lapicinit();     // interrupt controller
801033ac:	e8 3c f6 ff ff       	call   801029ed <lapicinit>
  seginit();       // segment descriptors
801033b1:	e8 01 3f 00 00       	call   801072b7 <seginit>
  picinit();    // disable pic
801033b6:	e8 9d 01 00 00       	call   80103558 <picinit>
  ioapicinit();    // another interrupt controller
801033bb:	e8 ab f1 ff ff       	call   8010256b <ioapicinit>
  consoleinit();   // console hardware
801033c0:	e8 3a d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
801033c5:	e8 86 32 00 00       	call   80106650 <uartinit>
  pinit();         // process table
801033ca:	e8 c2 05 00 00       	call   80103991 <pinit>
  tvinit();        // trap vectors
801033cf:	e8 92 2c 00 00       	call   80106066 <tvinit>
  binit();         // buffer cache
801033d4:	e8 8d cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033d9:	e8 c6 db ff ff       	call   80100fa4 <fileinit>
  ideinit();       // disk 
801033de:	e8 2e 70 00 00       	call   8010a411 <ideinit>
  startothers();   // start other processors
801033e3:	e8 8a 00 00 00       	call   80103472 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033e8:	83 ec 08             	sub    $0x8,%esp
801033eb:	68 00 00 00 a0       	push   $0xa0000000
801033f0:	68 00 00 40 80       	push   $0x80400000
801033f5:	e8 8f f2 ff ff       	call   80102689 <kinit2>
801033fa:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033fd:	e8 27 51 00 00       	call   80108529 <pci_init>
  arp_scan();
80103402:	e8 5e 5e 00 00       	call   80109265 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
80103407:	e8 8f 07 00 00       	call   80103b9b <userinit>

  mpmain();        // finish this processor's setup
8010340c:	e8 1a 00 00 00       	call   8010342b <mpmain>

80103411 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103411:	55                   	push   %ebp
80103412:	89 e5                	mov    %esp,%ebp
80103414:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103417:	e8 1b 44 00 00       	call   80107837 <switchkvm>
  seginit();
8010341c:	e8 96 3e 00 00       	call   801072b7 <seginit>
  lapicinit();
80103421:	e8 c7 f5 ff ff       	call   801029ed <lapicinit>
  mpmain();
80103426:	e8 00 00 00 00       	call   8010342b <mpmain>

8010342b <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010342b:	55                   	push   %ebp
8010342c:	89 e5                	mov    %esp,%ebp
8010342e:	53                   	push   %ebx
8010342f:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103432:	e8 78 05 00 00       	call   801039af <cpuid>
80103437:	89 c3                	mov    %eax,%ebx
80103439:	e8 71 05 00 00       	call   801039af <cpuid>
8010343e:	83 ec 04             	sub    $0x4,%esp
80103441:	53                   	push   %ebx
80103442:	50                   	push   %eax
80103443:	68 ac a7 10 80       	push   $0x8010a7ac
80103448:	e8 a7 cf ff ff       	call   801003f4 <cprintf>
8010344d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103450:	e8 87 2d 00 00       	call   801061dc <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103455:	e8 70 05 00 00       	call   801039ca <mycpu>
8010345a:	05 a0 00 00 00       	add    $0xa0,%eax
8010345f:	83 ec 08             	sub    $0x8,%esp
80103462:	6a 01                	push   $0x1
80103464:	50                   	push   %eax
80103465:	e8 f3 fe ff ff       	call   8010335d <xchg>
8010346a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010346d:	e8 1c 0d 00 00       	call   8010418e <scheduler>

80103472 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103472:	55                   	push   %ebp
80103473:	89 e5                	mov    %esp,%ebp
80103475:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103478:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010347f:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103484:	83 ec 04             	sub    $0x4,%esp
80103487:	50                   	push   %eax
80103488:	68 18 f5 10 80       	push   $0x8010f518
8010348d:	ff 75 f0             	push   -0x10(%ebp)
80103490:	e8 82 17 00 00       	call   80104c17 <memmove>
80103495:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103498:	c7 45 f4 a0 6c 19 80 	movl   $0x80196ca0,-0xc(%ebp)
8010349f:	eb 79                	jmp    8010351a <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
801034a1:	e8 24 05 00 00       	call   801039ca <mycpu>
801034a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801034a9:	74 67                	je     80103512 <startothers+0xa0>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801034ab:	e8 d5 f2 ff ff       	call   80102785 <kalloc>
801034b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b6:	83 e8 04             	sub    $0x4,%eax
801034b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034bc:	81 c2 00 10 00 00    	add    $0x1000,%edx
801034c2:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034c7:	83 e8 08             	sub    $0x8,%eax
801034ca:	c7 00 11 34 10 80    	movl   $0x80103411,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034d0:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801034d5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034de:	83 e8 0c             	sub    $0xc,%eax
801034e1:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034e6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034ef:	0f b6 00             	movzbl (%eax),%eax
801034f2:	0f b6 c0             	movzbl %al,%eax
801034f5:	83 ec 08             	sub    $0x8,%esp
801034f8:	52                   	push   %edx
801034f9:	50                   	push   %eax
801034fa:	e8 50 f6 ff ff       	call   80102b4f <lapicstartap>
801034ff:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103502:	90                   	nop
80103503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103506:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
8010350c:	85 c0                	test   %eax,%eax
8010350e:	74 f3                	je     80103503 <startothers+0x91>
80103510:	eb 01                	jmp    80103513 <startothers+0xa1>
      continue;
80103512:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103513:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
8010351a:	a1 60 6f 19 80       	mov    0x80196f60,%eax
8010351f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103525:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
8010352a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010352d:	0f 82 6e ff ff ff    	jb     801034a1 <startothers+0x2f>
      ;
  }
}
80103533:	90                   	nop
80103534:	90                   	nop
80103535:	c9                   	leave  
80103536:	c3                   	ret    

80103537 <outb>:
{
80103537:	55                   	push   %ebp
80103538:	89 e5                	mov    %esp,%ebp
8010353a:	83 ec 08             	sub    $0x8,%esp
8010353d:	8b 45 08             	mov    0x8(%ebp),%eax
80103540:	8b 55 0c             	mov    0xc(%ebp),%edx
80103543:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103547:	89 d0                	mov    %edx,%eax
80103549:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010354c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103550:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103554:	ee                   	out    %al,(%dx)
}
80103555:	90                   	nop
80103556:	c9                   	leave  
80103557:	c3                   	ret    

80103558 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103558:	55                   	push   %ebp
80103559:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010355b:	68 ff 00 00 00       	push   $0xff
80103560:	6a 21                	push   $0x21
80103562:	e8 d0 ff ff ff       	call   80103537 <outb>
80103567:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010356a:	68 ff 00 00 00       	push   $0xff
8010356f:	68 a1 00 00 00       	push   $0xa1
80103574:	e8 be ff ff ff       	call   80103537 <outb>
80103579:	83 c4 08             	add    $0x8,%esp
}
8010357c:	90                   	nop
8010357d:	c9                   	leave  
8010357e:	c3                   	ret    

8010357f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010357f:	55                   	push   %ebp
80103580:	89 e5                	mov    %esp,%ebp
80103582:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103585:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010358c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010358f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103595:	8b 45 0c             	mov    0xc(%ebp),%eax
80103598:	8b 10                	mov    (%eax),%edx
8010359a:	8b 45 08             	mov    0x8(%ebp),%eax
8010359d:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010359f:	e8 1e da ff ff       	call   80100fc2 <filealloc>
801035a4:	8b 55 08             	mov    0x8(%ebp),%edx
801035a7:	89 02                	mov    %eax,(%edx)
801035a9:	8b 45 08             	mov    0x8(%ebp),%eax
801035ac:	8b 00                	mov    (%eax),%eax
801035ae:	85 c0                	test   %eax,%eax
801035b0:	0f 84 c8 00 00 00    	je     8010367e <pipealloc+0xff>
801035b6:	e8 07 da ff ff       	call   80100fc2 <filealloc>
801035bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801035be:	89 02                	mov    %eax,(%edx)
801035c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c3:	8b 00                	mov    (%eax),%eax
801035c5:	85 c0                	test   %eax,%eax
801035c7:	0f 84 b1 00 00 00    	je     8010367e <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035cd:	e8 b3 f1 ff ff       	call   80102785 <kalloc>
801035d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035d9:	0f 84 a2 00 00 00    	je     80103681 <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801035df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035e2:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035e9:	00 00 00 
  p->writeopen = 1;
801035ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ef:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035f6:	00 00 00 
  p->nwrite = 0;
801035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035fc:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103603:	00 00 00 
  p->nread = 0;
80103606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103609:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103610:	00 00 00 
  initlock(&p->lock, "pipe");
80103613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103616:	83 ec 08             	sub    $0x8,%esp
80103619:	68 c0 a7 10 80       	push   $0x8010a7c0
8010361e:	50                   	push   %eax
8010361f:	e8 9c 12 00 00       	call   801048c0 <initlock>
80103624:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103627:	8b 45 08             	mov    0x8(%ebp),%eax
8010362a:	8b 00                	mov    (%eax),%eax
8010362c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103632:	8b 45 08             	mov    0x8(%ebp),%eax
80103635:	8b 00                	mov    (%eax),%eax
80103637:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010363b:	8b 45 08             	mov    0x8(%ebp),%eax
8010363e:	8b 00                	mov    (%eax),%eax
80103640:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103644:	8b 45 08             	mov    0x8(%ebp),%eax
80103647:	8b 00                	mov    (%eax),%eax
80103649:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010364c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010364f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103652:	8b 00                	mov    (%eax),%eax
80103654:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010365a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010365d:	8b 00                	mov    (%eax),%eax
8010365f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103663:	8b 45 0c             	mov    0xc(%ebp),%eax
80103666:	8b 00                	mov    (%eax),%eax
80103668:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010366c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010366f:	8b 00                	mov    (%eax),%eax
80103671:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103674:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103677:	b8 00 00 00 00       	mov    $0x0,%eax
8010367c:	eb 51                	jmp    801036cf <pipealloc+0x150>
    goto bad;
8010367e:	90                   	nop
8010367f:	eb 01                	jmp    80103682 <pipealloc+0x103>
    goto bad;
80103681:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103686:	74 0e                	je     80103696 <pipealloc+0x117>
    kfree((char*)p);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	ff 75 f4             	push   -0xc(%ebp)
8010368e:	e8 58 f0 ff ff       	call   801026eb <kfree>
80103693:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103696:	8b 45 08             	mov    0x8(%ebp),%eax
80103699:	8b 00                	mov    (%eax),%eax
8010369b:	85 c0                	test   %eax,%eax
8010369d:	74 11                	je     801036b0 <pipealloc+0x131>
    fileclose(*f0);
8010369f:	8b 45 08             	mov    0x8(%ebp),%eax
801036a2:	8b 00                	mov    (%eax),%eax
801036a4:	83 ec 0c             	sub    $0xc,%esp
801036a7:	50                   	push   %eax
801036a8:	e8 d3 d9 ff ff       	call   80101080 <fileclose>
801036ad:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801036b3:	8b 00                	mov    (%eax),%eax
801036b5:	85 c0                	test   %eax,%eax
801036b7:	74 11                	je     801036ca <pipealloc+0x14b>
    fileclose(*f1);
801036b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801036bc:	8b 00                	mov    (%eax),%eax
801036be:	83 ec 0c             	sub    $0xc,%esp
801036c1:	50                   	push   %eax
801036c2:	e8 b9 d9 ff ff       	call   80101080 <fileclose>
801036c7:	83 c4 10             	add    $0x10,%esp
  return -1;
801036ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036cf:	c9                   	leave  
801036d0:	c3                   	ret    

801036d1 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036d1:	55                   	push   %ebp
801036d2:	89 e5                	mov    %esp,%ebp
801036d4:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801036d7:	8b 45 08             	mov    0x8(%ebp),%eax
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	50                   	push   %eax
801036de:	e8 ff 11 00 00       	call   801048e2 <acquire>
801036e3:	83 c4 10             	add    $0x10,%esp
  if(writable){
801036e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801036ea:	74 23                	je     8010370f <pipeclose+0x3e>
    p->writeopen = 0;
801036ec:	8b 45 08             	mov    0x8(%ebp),%eax
801036ef:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801036f6:	00 00 00 
    wakeup(&p->nread);
801036f9:	8b 45 08             	mov    0x8(%ebp),%eax
801036fc:	05 34 02 00 00       	add    $0x234,%eax
80103701:	83 ec 0c             	sub    $0xc,%esp
80103704:	50                   	push   %eax
80103705:	e8 5c 0d 00 00       	call   80104466 <wakeup>
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	eb 21                	jmp    80103730 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010370f:	8b 45 08             	mov    0x8(%ebp),%eax
80103712:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103719:	00 00 00 
    wakeup(&p->nwrite);
8010371c:	8b 45 08             	mov    0x8(%ebp),%eax
8010371f:	05 38 02 00 00       	add    $0x238,%eax
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	50                   	push   %eax
80103728:	e8 39 0d 00 00       	call   80104466 <wakeup>
8010372d:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103730:	8b 45 08             	mov    0x8(%ebp),%eax
80103733:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103739:	85 c0                	test   %eax,%eax
8010373b:	75 2c                	jne    80103769 <pipeclose+0x98>
8010373d:	8b 45 08             	mov    0x8(%ebp),%eax
80103740:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103746:	85 c0                	test   %eax,%eax
80103748:	75 1f                	jne    80103769 <pipeclose+0x98>
    release(&p->lock);
8010374a:	8b 45 08             	mov    0x8(%ebp),%eax
8010374d:	83 ec 0c             	sub    $0xc,%esp
80103750:	50                   	push   %eax
80103751:	e8 fa 11 00 00       	call   80104950 <release>
80103756:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	ff 75 08             	push   0x8(%ebp)
8010375f:	e8 87 ef ff ff       	call   801026eb <kfree>
80103764:	83 c4 10             	add    $0x10,%esp
80103767:	eb 10                	jmp    80103779 <pipeclose+0xa8>
  } else
    release(&p->lock);
80103769:	8b 45 08             	mov    0x8(%ebp),%eax
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	50                   	push   %eax
80103770:	e8 db 11 00 00       	call   80104950 <release>
80103775:	83 c4 10             	add    $0x10,%esp
}
80103778:	90                   	nop
80103779:	90                   	nop
8010377a:	c9                   	leave  
8010377b:	c3                   	ret    

8010377c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010377c:	55                   	push   %ebp
8010377d:	89 e5                	mov    %esp,%ebp
8010377f:	53                   	push   %ebx
80103780:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103783:	8b 45 08             	mov    0x8(%ebp),%eax
80103786:	83 ec 0c             	sub    $0xc,%esp
80103789:	50                   	push   %eax
8010378a:	e8 53 11 00 00       	call   801048e2 <acquire>
8010378f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103799:	e9 ad 00 00 00       	jmp    8010384b <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010379e:	8b 45 08             	mov    0x8(%ebp),%eax
801037a1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801037a7:	85 c0                	test   %eax,%eax
801037a9:	74 0c                	je     801037b7 <pipewrite+0x3b>
801037ab:	e8 92 02 00 00       	call   80103a42 <myproc>
801037b0:	8b 40 24             	mov    0x24(%eax),%eax
801037b3:	85 c0                	test   %eax,%eax
801037b5:	74 19                	je     801037d0 <pipewrite+0x54>
        release(&p->lock);
801037b7:	8b 45 08             	mov    0x8(%ebp),%eax
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	50                   	push   %eax
801037be:	e8 8d 11 00 00       	call   80104950 <release>
801037c3:	83 c4 10             	add    $0x10,%esp
        return -1;
801037c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037cb:	e9 a9 00 00 00       	jmp    80103879 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
801037d0:	8b 45 08             	mov    0x8(%ebp),%eax
801037d3:	05 34 02 00 00       	add    $0x234,%eax
801037d8:	83 ec 0c             	sub    $0xc,%esp
801037db:	50                   	push   %eax
801037dc:	e8 85 0c 00 00       	call   80104466 <wakeup>
801037e1:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e4:	8b 45 08             	mov    0x8(%ebp),%eax
801037e7:	8b 55 08             	mov    0x8(%ebp),%edx
801037ea:	81 c2 38 02 00 00    	add    $0x238,%edx
801037f0:	83 ec 08             	sub    $0x8,%esp
801037f3:	50                   	push   %eax
801037f4:	52                   	push   %edx
801037f5:	e8 85 0b 00 00       	call   8010437f <sleep>
801037fa:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103800:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103806:	8b 45 08             	mov    0x8(%ebp),%eax
80103809:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010380f:	05 00 02 00 00       	add    $0x200,%eax
80103814:	39 c2                	cmp    %eax,%edx
80103816:	74 86                	je     8010379e <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103818:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010381b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010381e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103821:	8b 45 08             	mov    0x8(%ebp),%eax
80103824:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010382a:	8d 48 01             	lea    0x1(%eax),%ecx
8010382d:	8b 55 08             	mov    0x8(%ebp),%edx
80103830:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103836:	25 ff 01 00 00       	and    $0x1ff,%eax
8010383b:	89 c1                	mov    %eax,%ecx
8010383d:	0f b6 13             	movzbl (%ebx),%edx
80103840:	8b 45 08             	mov    0x8(%ebp),%eax
80103843:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103847:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010384e:	3b 45 10             	cmp    0x10(%ebp),%eax
80103851:	7c aa                	jl     801037fd <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103853:	8b 45 08             	mov    0x8(%ebp),%eax
80103856:	05 34 02 00 00       	add    $0x234,%eax
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	50                   	push   %eax
8010385f:	e8 02 0c 00 00       	call   80104466 <wakeup>
80103864:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103867:	8b 45 08             	mov    0x8(%ebp),%eax
8010386a:	83 ec 0c             	sub    $0xc,%esp
8010386d:	50                   	push   %eax
8010386e:	e8 dd 10 00 00       	call   80104950 <release>
80103873:	83 c4 10             	add    $0x10,%esp
  return n;
80103876:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    

8010387e <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010387e:	55                   	push   %ebp
8010387f:	89 e5                	mov    %esp,%ebp
80103881:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103884:	8b 45 08             	mov    0x8(%ebp),%eax
80103887:	83 ec 0c             	sub    $0xc,%esp
8010388a:	50                   	push   %eax
8010388b:	e8 52 10 00 00       	call   801048e2 <acquire>
80103890:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103893:	eb 3e                	jmp    801038d3 <piperead+0x55>
    if(myproc()->killed){
80103895:	e8 a8 01 00 00       	call   80103a42 <myproc>
8010389a:	8b 40 24             	mov    0x24(%eax),%eax
8010389d:	85 c0                	test   %eax,%eax
8010389f:	74 19                	je     801038ba <piperead+0x3c>
      release(&p->lock);
801038a1:	8b 45 08             	mov    0x8(%ebp),%eax
801038a4:	83 ec 0c             	sub    $0xc,%esp
801038a7:	50                   	push   %eax
801038a8:	e8 a3 10 00 00       	call   80104950 <release>
801038ad:	83 c4 10             	add    $0x10,%esp
      return -1;
801038b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038b5:	e9 be 00 00 00       	jmp    80103978 <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038ba:	8b 45 08             	mov    0x8(%ebp),%eax
801038bd:	8b 55 08             	mov    0x8(%ebp),%edx
801038c0:	81 c2 34 02 00 00    	add    $0x234,%edx
801038c6:	83 ec 08             	sub    $0x8,%esp
801038c9:	50                   	push   %eax
801038ca:	52                   	push   %edx
801038cb:	e8 af 0a 00 00       	call   8010437f <sleep>
801038d0:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038d3:	8b 45 08             	mov    0x8(%ebp),%eax
801038d6:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038dc:	8b 45 08             	mov    0x8(%ebp),%eax
801038df:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038e5:	39 c2                	cmp    %eax,%edx
801038e7:	75 0d                	jne    801038f6 <piperead+0x78>
801038e9:	8b 45 08             	mov    0x8(%ebp),%eax
801038ec:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	75 9f                	jne    80103895 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038fd:	eb 48                	jmp    80103947 <piperead+0xc9>
    if(p->nread == p->nwrite)
801038ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103902:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103908:	8b 45 08             	mov    0x8(%ebp),%eax
8010390b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103911:	39 c2                	cmp    %eax,%edx
80103913:	74 3c                	je     80103951 <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103915:	8b 45 08             	mov    0x8(%ebp),%eax
80103918:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010391e:	8d 48 01             	lea    0x1(%eax),%ecx
80103921:	8b 55 08             	mov    0x8(%ebp),%edx
80103924:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010392a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010392f:	89 c1                	mov    %eax,%ecx
80103931:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103934:	8b 45 0c             	mov    0xc(%ebp),%eax
80103937:	01 c2                	add    %eax,%edx
80103939:	8b 45 08             	mov    0x8(%ebp),%eax
8010393c:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80103941:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103943:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010394a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010394d:	7c b0                	jl     801038ff <piperead+0x81>
8010394f:	eb 01                	jmp    80103952 <piperead+0xd4>
      break;
80103951:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103952:	8b 45 08             	mov    0x8(%ebp),%eax
80103955:	05 38 02 00 00       	add    $0x238,%eax
8010395a:	83 ec 0c             	sub    $0xc,%esp
8010395d:	50                   	push   %eax
8010395e:	e8 03 0b 00 00       	call   80104466 <wakeup>
80103963:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103966:	8b 45 08             	mov    0x8(%ebp),%eax
80103969:	83 ec 0c             	sub    $0xc,%esp
8010396c:	50                   	push   %eax
8010396d:	e8 de 0f 00 00       	call   80104950 <release>
80103972:	83 c4 10             	add    $0x10,%esp
  return i;
80103975:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103978:	c9                   	leave  
80103979:	c3                   	ret    

8010397a <readeflags>:
{
8010397a:	55                   	push   %ebp
8010397b:	89 e5                	mov    %esp,%ebp
8010397d:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103980:	9c                   	pushf  
80103981:	58                   	pop    %eax
80103982:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103985:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103988:	c9                   	leave  
80103989:	c3                   	ret    

8010398a <sti>:
{
8010398a:	55                   	push   %ebp
8010398b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010398d:	fb                   	sti    
}
8010398e:	90                   	nop
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    

80103991 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103991:	55                   	push   %ebp
80103992:	89 e5                	mov    %esp,%ebp
80103994:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103997:	83 ec 08             	sub    $0x8,%esp
8010399a:	68 c8 a7 10 80       	push   $0x8010a7c8
8010399f:	68 00 42 19 80       	push   $0x80194200
801039a4:	e8 17 0f 00 00       	call   801048c0 <initlock>
801039a9:	83 c4 10             	add    $0x10,%esp
}
801039ac:	90                   	nop
801039ad:	c9                   	leave  
801039ae:	c3                   	ret    

801039af <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801039af:	55                   	push   %ebp
801039b0:	89 e5                	mov    %esp,%ebp
801039b2:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039b5:	e8 10 00 00 00       	call   801039ca <mycpu>
801039ba:	2d a0 6c 19 80       	sub    $0x80196ca0,%eax
801039bf:	c1 f8 04             	sar    $0x4,%eax
801039c2:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039c8:	c9                   	leave  
801039c9:	c3                   	ret    

801039ca <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801039ca:	55                   	push   %ebp
801039cb:	89 e5                	mov    %esp,%ebp
801039cd:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
801039d0:	e8 a5 ff ff ff       	call   8010397a <readeflags>
801039d5:	25 00 02 00 00       	and    $0x200,%eax
801039da:	85 c0                	test   %eax,%eax
801039dc:	74 0d                	je     801039eb <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801039de:	83 ec 0c             	sub    $0xc,%esp
801039e1:	68 d0 a7 10 80       	push   $0x8010a7d0
801039e6:	e8 be cb ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
801039eb:	e8 1c f1 ff ff       	call   80102b0c <lapicid>
801039f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039fa:	eb 2d                	jmp    80103a29 <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
801039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ff:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a05:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80103a0a:	0f b6 00             	movzbl (%eax),%eax
80103a0d:	0f b6 c0             	movzbl %al,%eax
80103a10:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103a13:	75 10                	jne    80103a25 <mycpu+0x5b>
      return &cpus[i];
80103a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a18:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a1e:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80103a23:	eb 1b                	jmp    80103a40 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103a25:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a29:	a1 60 6f 19 80       	mov    0x80196f60,%eax
80103a2e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a31:	7c c9                	jl     801039fc <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	68 f6 a7 10 80       	push   $0x8010a7f6
80103a3b:	e8 69 cb ff ff       	call   801005a9 <panic>
}
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    

80103a42 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103a42:	55                   	push   %ebp
80103a43:	89 e5                	mov    %esp,%ebp
80103a45:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a48:	e8 00 10 00 00       	call   80104a4d <pushcli>
  c = mycpu();
80103a4d:	e8 78 ff ff ff       	call   801039ca <mycpu>
80103a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a58:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a61:	e8 34 10 00 00       	call   80104a9a <popcli>
  return p;
80103a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103a69:	c9                   	leave  
80103a6a:	c3                   	ret    

80103a6b <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a6b:	55                   	push   %ebp
80103a6c:	89 e5                	mov    %esp,%ebp
80103a6e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a71:	83 ec 0c             	sub    $0xc,%esp
80103a74:	68 00 42 19 80       	push   $0x80194200
80103a79:	e8 64 0e 00 00       	call   801048e2 <acquire>
80103a7e:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a81:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a88:	eb 0e                	jmp    80103a98 <allocproc+0x2d>
    if(p->state == UNUSED){
80103a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8d:	8b 40 0c             	mov    0xc(%eax),%eax
80103a90:	85 c0                	test   %eax,%eax
80103a92:	74 27                	je     80103abb <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a94:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103a98:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103a9f:	72 e9                	jb     80103a8a <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103aa1:	83 ec 0c             	sub    $0xc,%esp
80103aa4:	68 00 42 19 80       	push   $0x80194200
80103aa9:	e8 a2 0e 00 00       	call   80104950 <release>
80103aae:	83 c4 10             	add    $0x10,%esp
  return 0;
80103ab1:	b8 00 00 00 00       	mov    $0x0,%eax
80103ab6:	e9 de 00 00 00       	jmp    80103b99 <allocproc+0x12e>
      goto found;
80103abb:	90                   	nop

found:
  p->state = EMBRYO;
80103abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abf:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103ac6:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103acb:	8d 50 01             	lea    0x1(%eax),%edx
80103ace:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ad7:	89 42 10             	mov    %eax,0x10(%edx)
  int index = p - ptable.proc;
80103ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103add:	2d 34 42 19 80       	sub    $0x80194234,%eax
80103ae2:	c1 f8 07             	sar    $0x7,%eax
80103ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ppid[index] = p->pid;
80103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aeb:	8b 50 10             	mov    0x10(%eax),%edx
80103aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af1:	89 14 85 40 62 19 80 	mov    %edx,-0x7fe69dc0(,%eax,4)
  pspage[index] = 1;
80103af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103afb:	c7 04 85 40 63 19 80 	movl   $0x1,-0x7fe69cc0(,%eax,4)
80103b02:	01 00 00 00 
  release(&ptable.lock);
80103b06:	83 ec 0c             	sub    $0xc,%esp
80103b09:	68 00 42 19 80       	push   $0x80194200
80103b0e:	e8 3d 0e 00 00       	call   80104950 <release>
80103b13:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b16:	e8 6a ec ff ff       	call   80102785 <kalloc>
80103b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b1e:	89 42 08             	mov    %eax,0x8(%edx)
80103b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b24:	8b 40 08             	mov    0x8(%eax),%eax
80103b27:	85 c0                	test   %eax,%eax
80103b29:	75 11                	jne    80103b3c <allocproc+0xd1>
    p->state = UNUSED;
80103b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103b35:	b8 00 00 00 00       	mov    $0x0,%eax
80103b3a:	eb 5d                	jmp    80103b99 <allocproc+0x12e>
  }
  sp = p->kstack + KSTACKSIZE;
80103b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3f:	8b 40 08             	mov    0x8(%eax),%eax
80103b42:	05 00 10 00 00       	add    $0x1000,%eax
80103b47:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b4a:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
  p->tf = (struct trapframe*)sp;
80103b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b51:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b54:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b57:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
80103b5b:	ba 20 60 10 80       	mov    $0x80106020,%edx
80103b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b63:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b65:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  p->context = (struct context*)sp;
80103b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b6f:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b75:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b78:	83 ec 04             	sub    $0x4,%esp
80103b7b:	6a 14                	push   $0x14
80103b7d:	6a 00                	push   $0x0
80103b7f:	50                   	push   %eax
80103b80:	e8 d3 0f 00 00       	call   80104b58 <memset>
80103b85:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b8b:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b8e:	ba 39 43 10 80       	mov    $0x80104339,%edx
80103b93:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b99:	c9                   	leave  
80103b9a:	c3                   	ret    

80103b9b <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b9b:	55                   	push   %ebp
80103b9c:	89 e5                	mov    %esp,%ebp
80103b9e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103ba1:	e8 c5 fe ff ff       	call   80103a6b <allocproc>
80103ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bac:	a3 40 64 19 80       	mov    %eax,0x80196440
  if((p->pgdir = setupkvm()) == 0){
80103bb1:	e8 7d 3b 00 00       	call   80107733 <setupkvm>
80103bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103bb9:	89 42 04             	mov    %eax,0x4(%edx)
80103bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbf:	8b 40 04             	mov    0x4(%eax),%eax
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 0d                	jne    80103bd3 <userinit+0x38>
    panic("userinit: out of memory?");
80103bc6:	83 ec 0c             	sub    $0xc,%esp
80103bc9:	68 06 a8 10 80       	push   $0x8010a806
80103bce:	e8 d6 c9 ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bd3:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bdb:	8b 40 04             	mov    0x4(%eax),%eax
80103bde:	83 ec 04             	sub    $0x4,%esp
80103be1:	52                   	push   %edx
80103be2:	68 ec f4 10 80       	push   $0x8010f4ec
80103be7:	50                   	push   %eax
80103be8:	e8 02 3e 00 00       	call   801079ef <inituvm>
80103bed:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf3:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfc:	8b 40 18             	mov    0x18(%eax),%eax
80103bff:	83 ec 04             	sub    $0x4,%esp
80103c02:	6a 4c                	push   $0x4c
80103c04:	6a 00                	push   $0x0
80103c06:	50                   	push   %eax
80103c07:	e8 4c 0f 00 00       	call   80104b58 <memset>
80103c0c:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c12:	8b 40 18             	mov    0x18(%eax),%eax
80103c15:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1e:	8b 40 18             	mov    0x18(%eax),%eax
80103c21:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2a:	8b 50 18             	mov    0x18(%eax),%edx
80103c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c30:	8b 40 18             	mov    0x18(%eax),%eax
80103c33:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c37:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3e:	8b 50 18             	mov    0x18(%eax),%edx
80103c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c44:	8b 40 18             	mov    0x18(%eax),%eax
80103c47:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c4b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c52:	8b 40 18             	mov    0x18(%eax),%eax
80103c55:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5f:	8b 40 18             	mov    0x18(%eax),%eax
80103c62:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6c:	8b 40 18             	mov    0x18(%eax),%eax
80103c6f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c79:	83 c0 6c             	add    $0x6c,%eax
80103c7c:	83 ec 04             	sub    $0x4,%esp
80103c7f:	6a 10                	push   $0x10
80103c81:	68 1f a8 10 80       	push   $0x8010a81f
80103c86:	50                   	push   %eax
80103c87:	e8 cf 10 00 00       	call   80104d5b <safestrcpy>
80103c8c:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c8f:	83 ec 0c             	sub    $0xc,%esp
80103c92:	68 28 a8 10 80       	push   $0x8010a828
80103c97:	e8 66 e8 ff ff       	call   80102502 <namei>
80103c9c:	83 c4 10             	add    $0x10,%esp
80103c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ca2:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ca5:	83 ec 0c             	sub    $0xc,%esp
80103ca8:	68 00 42 19 80       	push   $0x80194200
80103cad:	e8 30 0c 00 00       	call   801048e2 <acquire>
80103cb2:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103cbf:	83 ec 0c             	sub    $0xc,%esp
80103cc2:	68 00 42 19 80       	push   $0x80194200
80103cc7:	e8 84 0c 00 00       	call   80104950 <release>
80103ccc:	83 c4 10             	add    $0x10,%esp
}
80103ccf:	90                   	nop
80103cd0:	c9                   	leave  
80103cd1:	c3                   	ret    

80103cd2 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103cd2:	55                   	push   %ebp
80103cd3:	89 e5                	mov    %esp,%ebp
80103cd5:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103cd8:	e8 65 fd ff ff       	call   80103a42 <myproc>
80103cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sz = curproc->sz;
80103ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce3:	8b 00                	mov    (%eax),%eax
80103ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(n > 0){
80103ce8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cec:	7e 2e                	jle    80103d1c <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cee:	8b 55 08             	mov    0x8(%ebp),%edx
80103cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf4:	01 c2                	add    %eax,%edx
80103cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf9:	8b 40 04             	mov    0x4(%eax),%eax
80103cfc:	83 ec 04             	sub    $0x4,%esp
80103cff:	52                   	push   %edx
80103d00:	ff 75 f4             	push   -0xc(%ebp)
80103d03:	50                   	push   %eax
80103d04:	e8 23 3e 00 00       	call   80107b2c <allocuvm>
80103d09:	83 c4 10             	add    $0x10,%esp
80103d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d13:	75 3b                	jne    80103d50 <growproc+0x7e>
      return -1;
80103d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1a:	eb 4f                	jmp    80103d6b <growproc+0x99>
  } else if(n < 0){
80103d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103d20:	79 2e                	jns    80103d50 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d22:	8b 55 08             	mov    0x8(%ebp),%edx
80103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d28:	01 c2                	add    %eax,%edx
80103d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d2d:	8b 40 04             	mov    0x4(%eax),%eax
80103d30:	83 ec 04             	sub    $0x4,%esp
80103d33:	52                   	push   %edx
80103d34:	ff 75 f4             	push   -0xc(%ebp)
80103d37:	50                   	push   %eax
80103d38:	e8 f4 3e 00 00       	call   80107c31 <deallocuvm>
80103d3d:	83 c4 10             	add    $0x10,%esp
80103d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d47:	75 07                	jne    80103d50 <growproc+0x7e>
      return -1;
80103d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d4e:	eb 1b                	jmp    80103d6b <growproc+0x99>
  }
  curproc->sz = sz;
80103d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d56:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	ff 75 f0             	push   -0x10(%ebp)
80103d5e:	e8 ed 3a 00 00       	call   80107850 <switchuvm>
80103d63:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d6b:	c9                   	leave  
80103d6c:	c3                   	ret    

80103d6d <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d6d:	55                   	push   %ebp
80103d6e:	89 e5                	mov    %esp,%ebp
80103d70:	57                   	push   %edi
80103d71:	56                   	push   %esi
80103d72:	53                   	push   %ebx
80103d73:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d76:	e8 c7 fc ff ff       	call   80103a42 <myproc>
80103d7b:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d7e:	e8 e8 fc ff ff       	call   80103a6b <allocproc>
80103d83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103d86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80103d8a:	75 0a                	jne    80103d96 <fork+0x29>
    return -1;
80103d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d91:	e9 b0 01 00 00       	jmp    80103f46 <fork+0x1d9>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d96:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d99:	8b 10                	mov    (%eax),%edx
80103d9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d9e:	8b 40 04             	mov    0x4(%eax),%eax
80103da1:	83 ec 08             	sub    $0x8,%esp
80103da4:	52                   	push   %edx
80103da5:	50                   	push   %eax
80103da6:	e8 24 40 00 00       	call   80107dcf <copyuvm>
80103dab:	83 c4 10             	add    $0x10,%esp
80103dae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103db1:	89 42 04             	mov    %eax,0x4(%edx)
80103db4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103db7:	8b 40 04             	mov    0x4(%eax),%eax
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	75 30                	jne    80103dee <fork+0x81>
    kfree(np->kstack);
80103dbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dc1:	8b 40 08             	mov    0x8(%eax),%eax
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	50                   	push   %eax
80103dc8:	e8 1e e9 ff ff       	call   801026eb <kfree>
80103dcd:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103dd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103dda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103ddd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103de9:	e9 58 01 00 00       	jmp    80103f46 <fork+0x1d9>
  }
  np->sz = curproc->sz;
80103dee:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103df1:	8b 10                	mov    (%eax),%edx
80103df3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103df6:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dfb:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103dfe:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103e01:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e04:	8b 48 18             	mov    0x18(%eax),%ecx
80103e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e0a:	8b 40 18             	mov    0x18(%eax),%eax
80103e0d:	89 c2                	mov    %eax,%edx
80103e0f:	89 cb                	mov    %ecx,%ebx
80103e11:	b8 13 00 00 00       	mov    $0x13,%eax
80103e16:	89 d7                	mov    %edx,%edi
80103e18:	89 de                	mov    %ebx,%esi
80103e1a:	89 c1                	mov    %eax,%ecx
80103e1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103e1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e21:	8b 40 18             	mov    0x18(%eax),%eax
80103e24:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103e2b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103e32:	eb 3b                	jmp    80103e6f <fork+0x102>
    if(curproc->ofile[i])
80103e34:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e3a:	83 c2 08             	add    $0x8,%edx
80103e3d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e41:	85 c0                	test   %eax,%eax
80103e43:	74 26                	je     80103e6b <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e4b:	83 c2 08             	add    $0x8,%edx
80103e4e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e52:	83 ec 0c             	sub    $0xc,%esp
80103e55:	50                   	push   %eax
80103e56:	e8 d4 d1 ff ff       	call   8010102f <filedup>
80103e5b:	83 c4 10             	add    $0x10,%esp
80103e5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103e61:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e64:	83 c1 08             	add    $0x8,%ecx
80103e67:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e6b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e6f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e73:	7e bf                	jle    80103e34 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e75:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e78:	8b 40 68             	mov    0x68(%eax),%eax
80103e7b:	83 ec 0c             	sub    $0xc,%esp
80103e7e:	50                   	push   %eax
80103e7f:	e8 11 db ff ff       	call   80101995 <idup>
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103e8a:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e90:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e96:	83 c0 6c             	add    $0x6c,%eax
80103e99:	83 ec 04             	sub    $0x4,%esp
80103e9c:	6a 10                	push   $0x10
80103e9e:	52                   	push   %edx
80103e9f:	50                   	push   %eax
80103ea0:	e8 b6 0e 00 00       	call   80104d5b <safestrcpy>
80103ea5:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103eab:	8b 40 10             	mov    0x10(%eax),%eax
80103eae:	89 45 d0             	mov    %eax,-0x30(%ebp)

  acquire(&ptable.lock);
80103eb1:	83 ec 0c             	sub    $0xc,%esp
80103eb4:	68 00 42 19 80       	push   $0x80194200
80103eb9:	e8 24 0a 00 00       	call   801048e2 <acquire>
80103ebe:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103ec1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103ec4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(int i=0; i < NPROC; i++) {
80103ecb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80103ed2:	eb 59                	jmp    80103f2d <fork+0x1c0>
    if (ptable.proc[i].pid == pid) {
80103ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ed7:	c1 e0 07             	shl    $0x7,%eax
80103eda:	05 44 42 19 80       	add    $0x80194244,%eax
80103edf:	8b 00                	mov    (%eax),%eax
80103ee1:	39 45 d0             	cmp    %eax,-0x30(%ebp)
80103ee4:	75 43                	jne    80103f29 <fork+0x1bc>
      for(int j=0; j < NPROC; j++) {
80103ee6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80103eed:	eb 32                	jmp    80103f21 <fork+0x1b4>
        if (ptable.proc[j].pid == curproc->pid) {
80103eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ef2:	c1 e0 07             	shl    $0x7,%eax
80103ef5:	05 44 42 19 80       	add    $0x80194244,%eax
80103efa:	8b 10                	mov    (%eax),%edx
80103efc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103eff:	8b 40 10             	mov    0x10(%eax),%eax
80103f02:	39 c2                	cmp    %eax,%edx
80103f04:	75 17                	jne    80103f1d <fork+0x1b0>
          pspage[i] = pspage[j];
80103f06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f09:	8b 14 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%edx
80103f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f13:	89 14 85 40 63 19 80 	mov    %edx,-0x7fe69cc0(,%eax,4)
          break;
80103f1a:	90                   	nop
        }
       }
      break;
80103f1b:	eb 16                	jmp    80103f33 <fork+0x1c6>
      for(int j=0; j < NPROC; j++) {
80103f1d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80103f21:	83 7d dc 3f          	cmpl   $0x3f,-0x24(%ebp)
80103f25:	7e c8                	jle    80103eef <fork+0x182>
      break;
80103f27:	eb 0a                	jmp    80103f33 <fork+0x1c6>
  for(int i=0; i < NPROC; i++) {
80103f29:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80103f2d:	83 7d e0 3f          	cmpl   $0x3f,-0x20(%ebp)
80103f31:	7e a1                	jle    80103ed4 <fork+0x167>
    }
  }

  release(&ptable.lock);
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	68 00 42 19 80       	push   $0x80194200
80103f3b:	e8 10 0a 00 00       	call   80104950 <release>
80103f40:	83 c4 10             	add    $0x10,%esp

  return pid;
80103f43:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
80103f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f49:	5b                   	pop    %ebx
80103f4a:	5e                   	pop    %esi
80103f4b:	5f                   	pop    %edi
80103f4c:	5d                   	pop    %ebp
80103f4d:	c3                   	ret    

80103f4e <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103f4e:	55                   	push   %ebp
80103f4f:	89 e5                	mov    %esp,%ebp
80103f51:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103f54:	e8 e9 fa ff ff       	call   80103a42 <myproc>
80103f59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103f5c:	a1 40 64 19 80       	mov    0x80196440,%eax
80103f61:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f64:	75 0d                	jne    80103f73 <exit+0x25>
    panic("init exiting");
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	68 2a a8 10 80       	push   $0x8010a82a
80103f6e:	e8 36 c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103f73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103f7a:	eb 3f                	jmp    80103fbb <exit+0x6d>
    if(curproc->ofile[fd]){
80103f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f82:	83 c2 08             	add    $0x8,%edx
80103f85:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f89:	85 c0                	test   %eax,%eax
80103f8b:	74 2a                	je     80103fb7 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f90:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f93:	83 c2 08             	add    $0x8,%edx
80103f96:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	50                   	push   %eax
80103f9e:	e8 dd d0 ff ff       	call   80101080 <fileclose>
80103fa3:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103fac:	83 c2 08             	add    $0x8,%edx
80103faf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103fb6:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103fb7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103fbb:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103fbf:	7e bb                	jle    80103f7c <exit+0x2e>
    }
  }

  begin_op();
80103fc1:	e8 88 f0 ff ff       	call   8010304e <begin_op>
  iput(curproc->cwd);
80103fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fc9:	8b 40 68             	mov    0x68(%eax),%eax
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	50                   	push   %eax
80103fd0:	e8 5b db ff ff       	call   80101b30 <iput>
80103fd5:	83 c4 10             	add    $0x10,%esp
  end_op();
80103fd8:	e8 fd f0 ff ff       	call   801030da <end_op>
  curproc->cwd = 0;
80103fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fe0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 00 42 19 80       	push   $0x80194200
80103fef:	e8 ee 08 00 00       	call   801048e2 <acquire>
80103ff4:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ffa:	8b 40 14             	mov    0x14(%eax),%eax
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	50                   	push   %eax
80104001:	e8 20 04 00 00       	call   80104426 <wakeup1>
80104006:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104009:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104010:	eb 37                	jmp    80104049 <exit+0xfb>
    if(p->parent == curproc){
80104012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104015:	8b 40 14             	mov    0x14(%eax),%eax
80104018:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010401b:	75 28                	jne    80104045 <exit+0xf7>
      p->parent = initproc;
8010401d:	8b 15 40 64 19 80    	mov    0x80196440,%edx
80104023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104026:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402c:	8b 40 0c             	mov    0xc(%eax),%eax
8010402f:	83 f8 05             	cmp    $0x5,%eax
80104032:	75 11                	jne    80104045 <exit+0xf7>
        wakeup1(initproc);
80104034:	a1 40 64 19 80       	mov    0x80196440,%eax
80104039:	83 ec 0c             	sub    $0xc,%esp
8010403c:	50                   	push   %eax
8010403d:	e8 e4 03 00 00       	call   80104426 <wakeup1>
80104042:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104045:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104049:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104050:	72 c0                	jb     80104012 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104052:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104055:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010405c:	e8 e5 01 00 00       	call   80104246 <sched>
  panic("zombie exit");
80104061:	83 ec 0c             	sub    $0xc,%esp
80104064:	68 37 a8 10 80       	push   $0x8010a837
80104069:	e8 3b c5 ff ff       	call   801005a9 <panic>

8010406e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010406e:	55                   	push   %ebp
8010406f:	89 e5                	mov    %esp,%ebp
80104071:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104074:	e8 c9 f9 ff ff       	call   80103a42 <myproc>
80104079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010407c:	83 ec 0c             	sub    $0xc,%esp
8010407f:	68 00 42 19 80       	push   $0x80194200
80104084:	e8 59 08 00 00       	call   801048e2 <acquire>
80104089:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010408c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104093:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010409a:	e9 a1 00 00 00       	jmp    80104140 <wait+0xd2>
      if(p->parent != curproc)
8010409f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a2:	8b 40 14             	mov    0x14(%eax),%eax
801040a5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801040a8:	0f 85 8d 00 00 00    	jne    8010413b <wait+0xcd>
        continue;
      havekids = 1;
801040ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801040b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b8:	8b 40 0c             	mov    0xc(%eax),%eax
801040bb:	83 f8 05             	cmp    $0x5,%eax
801040be:	75 7c                	jne    8010413c <wait+0xce>
        // Found one.
        pid = p->pid;
801040c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c3:	8b 40 10             	mov    0x10(%eax),%eax
801040c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801040c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040cc:	8b 40 08             	mov    0x8(%eax),%eax
801040cf:	83 ec 0c             	sub    $0xc,%esp
801040d2:	50                   	push   %eax
801040d3:	e8 13 e6 ff ff       	call   801026eb <kfree>
801040d8:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801040db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801040e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e8:	8b 40 04             	mov    0x4(%eax),%eax
801040eb:	83 ec 0c             	sub    $0xc,%esp
801040ee:	50                   	push   %eax
801040ef:	e8 01 3c 00 00       	call   80107cf5 <freevm>
801040f4:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801040f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fa:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104104:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410e:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104115:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
8010411c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	68 00 42 19 80       	push   $0x80194200
8010412e:	e8 1d 08 00 00       	call   80104950 <release>
80104133:	83 c4 10             	add    $0x10,%esp
        return pid;
80104136:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104139:	eb 51                	jmp    8010418c <wait+0x11e>
        continue;
8010413b:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104140:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104147:	0f 82 52 ff ff ff    	jb     8010409f <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010414d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104151:	74 0a                	je     8010415d <wait+0xef>
80104153:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104156:	8b 40 24             	mov    0x24(%eax),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	74 17                	je     80104174 <wait+0x106>
      release(&ptable.lock);
8010415d:	83 ec 0c             	sub    $0xc,%esp
80104160:	68 00 42 19 80       	push   $0x80194200
80104165:	e8 e6 07 00 00       	call   80104950 <release>
8010416a:	83 c4 10             	add    $0x10,%esp
      return -1;
8010416d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104172:	eb 18                	jmp    8010418c <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104174:	83 ec 08             	sub    $0x8,%esp
80104177:	68 00 42 19 80       	push   $0x80194200
8010417c:	ff 75 ec             	push   -0x14(%ebp)
8010417f:	e8 fb 01 00 00       	call   8010437f <sleep>
80104184:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104187:	e9 00 ff ff ff       	jmp    8010408c <wait+0x1e>
  }
}
8010418c:	c9                   	leave  
8010418d:	c3                   	ret    

8010418e <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010418e:	55                   	push   %ebp
8010418f:	89 e5                	mov    %esp,%ebp
80104191:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104194:	e8 31 f8 ff ff       	call   801039ca <mycpu>
80104199:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
8010419c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010419f:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041a6:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801041a9:	e8 dc f7 ff ff       	call   8010398a <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801041ae:	83 ec 0c             	sub    $0xc,%esp
801041b1:	68 00 42 19 80       	push   $0x80194200
801041b6:	e8 27 07 00 00       	call   801048e2 <acquire>
801041bb:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041be:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801041c5:	eb 61                	jmp    80104228 <scheduler+0x9a>
      if(p->state != RUNNABLE)
801041c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ca:	8b 40 0c             	mov    0xc(%eax),%eax
801041cd:	83 f8 03             	cmp    $0x3,%eax
801041d0:	75 51                	jne    80104223 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801041d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801041de:	83 ec 0c             	sub    $0xc,%esp
801041e1:	ff 75 f4             	push   -0xc(%ebp)
801041e4:	e8 67 36 00 00       	call   80107850 <switchuvm>
801041e9:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801041ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ef:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801041f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f9:	8b 40 1c             	mov    0x1c(%eax),%eax
801041fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041ff:	83 c2 04             	add    $0x4,%edx
80104202:	83 ec 08             	sub    $0x8,%esp
80104205:	50                   	push   %eax
80104206:	52                   	push   %edx
80104207:	e8 c1 0b 00 00       	call   80104dcd <swtch>
8010420c:	83 c4 10             	add    $0x10,%esp
      switchkvm();
8010420f:	e8 23 36 00 00       	call   80107837 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104214:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104217:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010421e:	00 00 00 
80104221:	eb 01                	jmp    80104224 <scheduler+0x96>
        continue;
80104223:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104224:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104228:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
8010422f:	72 96                	jb     801041c7 <scheduler+0x39>
    }
    release(&ptable.lock);
80104231:	83 ec 0c             	sub    $0xc,%esp
80104234:	68 00 42 19 80       	push   $0x80194200
80104239:	e8 12 07 00 00       	call   80104950 <release>
8010423e:	83 c4 10             	add    $0x10,%esp
    sti();
80104241:	e9 63 ff ff ff       	jmp    801041a9 <scheduler+0x1b>

80104246 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104246:	55                   	push   %ebp
80104247:	89 e5                	mov    %esp,%ebp
80104249:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
8010424c:	e8 f1 f7 ff ff       	call   80103a42 <myproc>
80104251:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	68 00 42 19 80       	push   $0x80194200
8010425c:	e8 bc 07 00 00       	call   80104a1d <holding>
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	85 c0                	test   %eax,%eax
80104266:	75 0d                	jne    80104275 <sched+0x2f>
    panic("sched ptable.lock");
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 43 a8 10 80       	push   $0x8010a843
80104270:	e8 34 c3 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
80104275:	e8 50 f7 ff ff       	call   801039ca <mycpu>
8010427a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104280:	83 f8 01             	cmp    $0x1,%eax
80104283:	74 0d                	je     80104292 <sched+0x4c>
    panic("sched locks");
80104285:	83 ec 0c             	sub    $0xc,%esp
80104288:	68 55 a8 10 80       	push   $0x8010a855
8010428d:	e8 17 c3 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
80104292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104295:	8b 40 0c             	mov    0xc(%eax),%eax
80104298:	83 f8 04             	cmp    $0x4,%eax
8010429b:	75 0d                	jne    801042aa <sched+0x64>
    panic("sched running");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 61 a8 10 80       	push   $0x8010a861
801042a5:	e8 ff c2 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
801042aa:	e8 cb f6 ff ff       	call   8010397a <readeflags>
801042af:	25 00 02 00 00       	and    $0x200,%eax
801042b4:	85 c0                	test   %eax,%eax
801042b6:	74 0d                	je     801042c5 <sched+0x7f>
    panic("sched interruptible");
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 6f a8 10 80       	push   $0x8010a86f
801042c0:	e8 e4 c2 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
801042c5:	e8 00 f7 ff ff       	call   801039ca <mycpu>
801042ca:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801042d3:	e8 f2 f6 ff ff       	call   801039ca <mycpu>
801042d8:	8b 40 04             	mov    0x4(%eax),%eax
801042db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042de:	83 c2 1c             	add    $0x1c,%edx
801042e1:	83 ec 08             	sub    $0x8,%esp
801042e4:	50                   	push   %eax
801042e5:	52                   	push   %edx
801042e6:	e8 e2 0a 00 00       	call   80104dcd <swtch>
801042eb:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042ee:	e8 d7 f6 ff ff       	call   801039ca <mycpu>
801042f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042f6:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801042fc:	90                   	nop
801042fd:	c9                   	leave  
801042fe:	c3                   	ret    

801042ff <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801042ff:	55                   	push   %ebp
80104300:	89 e5                	mov    %esp,%ebp
80104302:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104305:	83 ec 0c             	sub    $0xc,%esp
80104308:	68 00 42 19 80       	push   $0x80194200
8010430d:	e8 d0 05 00 00       	call   801048e2 <acquire>
80104312:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104315:	e8 28 f7 ff ff       	call   80103a42 <myproc>
8010431a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104321:	e8 20 ff ff ff       	call   80104246 <sched>
  release(&ptable.lock);
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	68 00 42 19 80       	push   $0x80194200
8010432e:	e8 1d 06 00 00       	call   80104950 <release>
80104333:	83 c4 10             	add    $0x10,%esp
}
80104336:	90                   	nop
80104337:	c9                   	leave  
80104338:	c3                   	ret    

80104339 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104339:	55                   	push   %ebp
8010433a:	89 e5                	mov    %esp,%ebp
8010433c:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	68 00 42 19 80       	push   $0x80194200
80104347:	e8 04 06 00 00       	call   80104950 <release>
8010434c:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010434f:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104354:	85 c0                	test   %eax,%eax
80104356:	74 24                	je     8010437c <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104358:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
8010435f:	00 00 00 
    iinit(ROOTDEV);
80104362:	83 ec 0c             	sub    $0xc,%esp
80104365:	6a 01                	push   $0x1
80104367:	e8 f1 d2 ff ff       	call   8010165d <iinit>
8010436c:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	6a 01                	push   $0x1
80104374:	e8 b6 ea ff ff       	call   80102e2f <initlog>
80104379:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010437c:	90                   	nop
8010437d:	c9                   	leave  
8010437e:	c3                   	ret    

8010437f <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010437f:	55                   	push   %ebp
80104380:	89 e5                	mov    %esp,%ebp
80104382:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104385:	e8 b8 f6 ff ff       	call   80103a42 <myproc>
8010438a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
8010438d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104391:	75 0d                	jne    801043a0 <sleep+0x21>
    panic("sleep");
80104393:	83 ec 0c             	sub    $0xc,%esp
80104396:	68 83 a8 10 80       	push   $0x8010a883
8010439b:	e8 09 c2 ff ff       	call   801005a9 <panic>

  if(lk == 0)
801043a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801043a4:	75 0d                	jne    801043b3 <sleep+0x34>
    panic("sleep without lk");
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	68 89 a8 10 80       	push   $0x8010a889
801043ae:	e8 f6 c1 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043b3:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801043ba:	74 1e                	je     801043da <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043bc:	83 ec 0c             	sub    $0xc,%esp
801043bf:	68 00 42 19 80       	push   $0x80194200
801043c4:	e8 19 05 00 00       	call   801048e2 <acquire>
801043c9:	83 c4 10             	add    $0x10,%esp
    release(lk);
801043cc:	83 ec 0c             	sub    $0xc,%esp
801043cf:	ff 75 0c             	push   0xc(%ebp)
801043d2:	e8 79 05 00 00       	call   80104950 <release>
801043d7:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801043da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043dd:	8b 55 08             	mov    0x8(%ebp),%edx
801043e0:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e6:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801043ed:	e8 54 fe ff ff       	call   80104246 <sched>

  // Tidy up.
  p->chan = 0;
801043f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801043fc:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104403:	74 1e                	je     80104423 <sleep+0xa4>
    release(&ptable.lock);
80104405:	83 ec 0c             	sub    $0xc,%esp
80104408:	68 00 42 19 80       	push   $0x80194200
8010440d:	e8 3e 05 00 00       	call   80104950 <release>
80104412:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104415:	83 ec 0c             	sub    $0xc,%esp
80104418:	ff 75 0c             	push   0xc(%ebp)
8010441b:	e8 c2 04 00 00       	call   801048e2 <acquire>
80104420:	83 c4 10             	add    $0x10,%esp
  }
}
80104423:	90                   	nop
80104424:	c9                   	leave  
80104425:	c3                   	ret    

80104426 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104426:	55                   	push   %ebp
80104427:	89 e5                	mov    %esp,%ebp
80104429:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442c:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104433:	eb 24                	jmp    80104459 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104435:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104438:	8b 40 0c             	mov    0xc(%eax),%eax
8010443b:	83 f8 02             	cmp    $0x2,%eax
8010443e:	75 15                	jne    80104455 <wakeup1+0x2f>
80104440:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104443:	8b 40 20             	mov    0x20(%eax),%eax
80104446:	39 45 08             	cmp    %eax,0x8(%ebp)
80104449:	75 0a                	jne    80104455 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010444b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010444e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104455:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104459:	81 7d fc 34 62 19 80 	cmpl   $0x80196234,-0x4(%ebp)
80104460:	72 d3                	jb     80104435 <wakeup1+0xf>
}
80104462:	90                   	nop
80104463:	90                   	nop
80104464:	c9                   	leave  
80104465:	c3                   	ret    

80104466 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104466:	55                   	push   %ebp
80104467:	89 e5                	mov    %esp,%ebp
80104469:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010446c:	83 ec 0c             	sub    $0xc,%esp
8010446f:	68 00 42 19 80       	push   $0x80194200
80104474:	e8 69 04 00 00       	call   801048e2 <acquire>
80104479:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	ff 75 08             	push   0x8(%ebp)
80104482:	e8 9f ff ff ff       	call   80104426 <wakeup1>
80104487:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010448a:	83 ec 0c             	sub    $0xc,%esp
8010448d:	68 00 42 19 80       	push   $0x80194200
80104492:	e8 b9 04 00 00       	call   80104950 <release>
80104497:	83 c4 10             	add    $0x10,%esp
}
8010449a:	90                   	nop
8010449b:	c9                   	leave  
8010449c:	c3                   	ret    

8010449d <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010449d:	55                   	push   %ebp
8010449e:	89 e5                	mov    %esp,%ebp
801044a0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 00 42 19 80       	push   $0x80194200
801044ab:	e8 32 04 00 00       	call   801048e2 <acquire>
801044b0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b3:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801044ba:	eb 45                	jmp    80104501 <kill+0x64>
    if(p->pid == pid){
801044bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bf:	8b 40 10             	mov    0x10(%eax),%eax
801044c2:	39 45 08             	cmp    %eax,0x8(%ebp)
801044c5:	75 36                	jne    801044fd <kill+0x60>
      p->killed = 1;
801044c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ca:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d4:	8b 40 0c             	mov    0xc(%eax),%eax
801044d7:	83 f8 02             	cmp    $0x2,%eax
801044da:	75 0a                	jne    801044e6 <kill+0x49>
        p->state = RUNNABLE;
801044dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044e6:	83 ec 0c             	sub    $0xc,%esp
801044e9:	68 00 42 19 80       	push   $0x80194200
801044ee:	e8 5d 04 00 00       	call   80104950 <release>
801044f3:	83 c4 10             	add    $0x10,%esp
      return 0;
801044f6:	b8 00 00 00 00       	mov    $0x0,%eax
801044fb:	eb 22                	jmp    8010451f <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044fd:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104501:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104508:	72 b2                	jb     801044bc <kill+0x1f>
    }
  }
  release(&ptable.lock);
8010450a:	83 ec 0c             	sub    $0xc,%esp
8010450d:	68 00 42 19 80       	push   $0x80194200
80104512:	e8 39 04 00 00       	call   80104950 <release>
80104517:	83 c4 10             	add    $0x10,%esp
  return -1;
8010451a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010451f:	c9                   	leave  
80104520:	c3                   	ret    

80104521 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104521:	55                   	push   %ebp
80104522:	89 e5                	mov    %esp,%ebp
80104524:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104527:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
8010452e:	e9 d7 00 00 00       	jmp    8010460a <procdump+0xe9>
    if(p->state == UNUSED)
80104533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104536:	8b 40 0c             	mov    0xc(%eax),%eax
80104539:	85 c0                	test   %eax,%eax
8010453b:	0f 84 c4 00 00 00    	je     80104605 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104541:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104544:	8b 40 0c             	mov    0xc(%eax),%eax
80104547:	83 f8 05             	cmp    $0x5,%eax
8010454a:	77 23                	ja     8010456f <procdump+0x4e>
8010454c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010454f:	8b 40 0c             	mov    0xc(%eax),%eax
80104552:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104559:	85 c0                	test   %eax,%eax
8010455b:	74 12                	je     8010456f <procdump+0x4e>
      state = states[p->state];
8010455d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104560:	8b 40 0c             	mov    0xc(%eax),%eax
80104563:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
8010456a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010456d:	eb 07                	jmp    80104576 <procdump+0x55>
    else
      state = "???";
8010456f:	c7 45 ec 9a a8 10 80 	movl   $0x8010a89a,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104576:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104579:	8d 50 6c             	lea    0x6c(%eax),%edx
8010457c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010457f:	8b 40 10             	mov    0x10(%eax),%eax
80104582:	52                   	push   %edx
80104583:	ff 75 ec             	push   -0x14(%ebp)
80104586:	50                   	push   %eax
80104587:	68 9e a8 10 80       	push   $0x8010a89e
8010458c:	e8 63 be ff ff       	call   801003f4 <cprintf>
80104591:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104594:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104597:	8b 40 0c             	mov    0xc(%eax),%eax
8010459a:	83 f8 02             	cmp    $0x2,%eax
8010459d:	75 54                	jne    801045f3 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010459f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045a2:	8b 40 1c             	mov    0x1c(%eax),%eax
801045a5:	8b 40 0c             	mov    0xc(%eax),%eax
801045a8:	83 c0 08             	add    $0x8,%eax
801045ab:	89 c2                	mov    %eax,%edx
801045ad:	83 ec 08             	sub    $0x8,%esp
801045b0:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801045b3:	50                   	push   %eax
801045b4:	52                   	push   %edx
801045b5:	e8 e8 03 00 00       	call   801049a2 <getcallerpcs>
801045ba:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045c4:	eb 1c                	jmp    801045e2 <procdump+0xc1>
        cprintf(" %p", pc[i]);
801045c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801045cd:	83 ec 08             	sub    $0x8,%esp
801045d0:	50                   	push   %eax
801045d1:	68 a7 a8 10 80       	push   $0x8010a8a7
801045d6:	e8 19 be ff ff       	call   801003f4 <cprintf>
801045db:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045e2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801045e6:	7f 0b                	jg     801045f3 <procdump+0xd2>
801045e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045eb:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801045ef:	85 c0                	test   %eax,%eax
801045f1:	75 d3                	jne    801045c6 <procdump+0xa5>
    }
    cprintf("\n");
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	68 ab a8 10 80       	push   $0x8010a8ab
801045fb:	e8 f4 bd ff ff       	call   801003f4 <cprintf>
80104600:	83 c4 10             	add    $0x10,%esp
80104603:	eb 01                	jmp    80104606 <procdump+0xe5>
      continue;
80104605:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104606:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
8010460a:	81 7d f0 34 62 19 80 	cmpl   $0x80196234,-0x10(%ebp)
80104611:	0f 82 1c ff ff ff    	jb     80104533 <procdump+0x12>
  }
}
80104617:	90                   	nop
80104618:	90                   	nop
80104619:	c9                   	leave  
8010461a:	c3                   	ret    

8010461b <printpt>:

int printpt(int pid) {
8010461b:	55                   	push   %ebp
8010461c:	89 e5                	mov    %esp,%ebp
8010461e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  pte_t *pgtab;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104621:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104628:	e9 0f 01 00 00       	jmp    8010473c <printpt+0x121>
    if (p->pid == pid) {
8010462d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104630:	8b 40 10             	mov    0x10(%eax),%eax
80104633:	39 45 08             	cmp    %eax,0x8(%ebp)
80104636:	0f 85 fc 00 00 00    	jne    80104738 <printpt+0x11d>
      cprintf("START PAGE TABLE (pid %d)\n", pid);
8010463c:	83 ec 08             	sub    $0x8,%esp
8010463f:	ff 75 08             	push   0x8(%ebp)
80104642:	68 ad a8 10 80       	push   $0x8010a8ad
80104647:	e8 a8 bd ff ff       	call   801003f4 <cprintf>
8010464c:	83 c4 10             	add    $0x10,%esp
      for (uint va = 0; va < KERNBASE; va += PGSIZE) {
8010464f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104656:	e9 bb 00 00 00       	jmp    80104716 <printpt+0xfb>
        pde_t pde = p->pgdir[PDX(va)];
8010465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465e:	8b 50 04             	mov    0x4(%eax),%edx
80104661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104664:	c1 e8 16             	shr    $0x16,%eax
80104667:	c1 e0 02             	shl    $0x2,%eax
8010466a:	01 d0                	add    %edx,%eax
8010466c:	8b 00                	mov    (%eax),%eax
8010466e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pde & PTE_P) {
80104671:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104674:	83 e0 01             	and    $0x1,%eax
80104677:	85 c0                	test   %eax,%eax
80104679:	0f 84 90 00 00 00    	je     8010470f <printpt+0xf4>
          pgtab = (pte_t*)P2V(PTE_ADDR(pde));
8010467f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104682:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80104687:	05 00 00 00 80       	add    $0x80000000,%eax
8010468c:	89 45 e8             	mov    %eax,-0x18(%ebp)
          pte_t pte = pgtab[PTX(va)];
8010468f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104692:	c1 e8 0c             	shr    $0xc,%eax
80104695:	25 ff 03 00 00       	and    $0x3ff,%eax
8010469a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801046a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801046a4:	01 d0                	add    %edx,%eax
801046a6:	8b 00                	mov    (%eax),%eax
801046a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if (pte & PTE_P) {
801046ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046ae:	83 e0 01             	and    $0x1,%eax
801046b1:	85 c0                	test   %eax,%eax
801046b3:	74 5a                	je     8010470f <printpt+0xf4>
            char *u = (pte & PTE_U) ? "U" : "K";
801046b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046b8:	83 e0 04             	and    $0x4,%eax
801046bb:	85 c0                	test   %eax,%eax
801046bd:	74 07                	je     801046c6 <printpt+0xab>
801046bf:	b8 c8 a8 10 80       	mov    $0x8010a8c8,%eax
801046c4:	eb 05                	jmp    801046cb <printpt+0xb0>
801046c6:	b8 ca a8 10 80       	mov    $0x8010a8ca,%eax
801046cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
            char *w = (pte & PTE_W) ? "W" : "-";
801046ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046d1:	83 e0 02             	and    $0x2,%eax
801046d4:	85 c0                	test   %eax,%eax
801046d6:	74 07                	je     801046df <printpt+0xc4>
801046d8:	b8 cc a8 10 80       	mov    $0x8010a8cc,%eax
801046dd:	eb 05                	jmp    801046e4 <printpt+0xc9>
801046df:	b8 ce a8 10 80       	mov    $0x8010a8ce,%eax
801046e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
            cprintf("%x P %s %s %x\n", va >> 12, u, w, PTE_ADDR(pte));
801046e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801046ef:	89 c2                	mov    %eax,%edx
801046f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046f4:	c1 e8 0c             	shr    $0xc,%eax
801046f7:	83 ec 0c             	sub    $0xc,%esp
801046fa:	52                   	push   %edx
801046fb:	ff 75 dc             	push   -0x24(%ebp)
801046fe:	ff 75 e0             	push   -0x20(%ebp)
80104701:	50                   	push   %eax
80104702:	68 d0 a8 10 80       	push   $0x8010a8d0
80104707:	e8 e8 bc ff ff       	call   801003f4 <cprintf>
8010470c:	83 c4 20             	add    $0x20,%esp
      for (uint va = 0; va < KERNBASE; va += PGSIZE) {
8010470f:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
80104716:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104719:	85 c0                	test   %eax,%eax
8010471b:	0f 89 3a ff ff ff    	jns    8010465b <printpt+0x40>
          }
        }
      }
      cprintf("END PAGE TABLE\n");
80104721:	83 ec 0c             	sub    $0xc,%esp
80104724:	68 df a8 10 80       	push   $0x8010a8df
80104729:	e8 c6 bc ff ff       	call   801003f4 <cprintf>
8010472e:	83 c4 10             	add    $0x10,%esp
      return 0;
80104731:	b8 00 00 00 00       	mov    $0x0,%eax
80104736:	eb 29                	jmp    80104761 <printpt+0x146>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104738:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010473c:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104743:	0f 82 e4 fe ff ff    	jb     8010462d <printpt+0x12>
    }
  }

  cprintf("printpt: pid %d not found\n", pid);
80104749:	83 ec 08             	sub    $0x8,%esp
8010474c:	ff 75 08             	push   0x8(%ebp)
8010474f:	68 ef a8 10 80       	push   $0x8010a8ef
80104754:	e8 9b bc ff ff       	call   801003f4 <cprintf>
80104759:	83 c4 10             	add    $0x10,%esp
  return -1;
8010475c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104761:	c9                   	leave  
80104762:	c3                   	ret    

80104763 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104763:	55                   	push   %ebp
80104764:	89 e5                	mov    %esp,%ebp
80104766:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104769:	8b 45 08             	mov    0x8(%ebp),%eax
8010476c:	83 c0 04             	add    $0x4,%eax
8010476f:	83 ec 08             	sub    $0x8,%esp
80104772:	68 34 a9 10 80       	push   $0x8010a934
80104777:	50                   	push   %eax
80104778:	e8 43 01 00 00       	call   801048c0 <initlock>
8010477d:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104780:	8b 45 08             	mov    0x8(%ebp),%eax
80104783:	8b 55 0c             	mov    0xc(%ebp),%edx
80104786:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104789:	8b 45 08             	mov    0x8(%ebp),%eax
8010478c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104792:	8b 45 08             	mov    0x8(%ebp),%eax
80104795:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010479c:	90                   	nop
8010479d:	c9                   	leave  
8010479e:	c3                   	ret    

8010479f <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010479f:	55                   	push   %ebp
801047a0:	89 e5                	mov    %esp,%ebp
801047a2:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801047a5:	8b 45 08             	mov    0x8(%ebp),%eax
801047a8:	83 c0 04             	add    $0x4,%eax
801047ab:	83 ec 0c             	sub    $0xc,%esp
801047ae:	50                   	push   %eax
801047af:	e8 2e 01 00 00       	call   801048e2 <acquire>
801047b4:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801047b7:	eb 15                	jmp    801047ce <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
801047b9:	8b 45 08             	mov    0x8(%ebp),%eax
801047bc:	83 c0 04             	add    $0x4,%eax
801047bf:	83 ec 08             	sub    $0x8,%esp
801047c2:	50                   	push   %eax
801047c3:	ff 75 08             	push   0x8(%ebp)
801047c6:	e8 b4 fb ff ff       	call   8010437f <sleep>
801047cb:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801047ce:	8b 45 08             	mov    0x8(%ebp),%eax
801047d1:	8b 00                	mov    (%eax),%eax
801047d3:	85 c0                	test   %eax,%eax
801047d5:	75 e2                	jne    801047b9 <acquiresleep+0x1a>
  }
  lk->locked = 1;
801047d7:	8b 45 08             	mov    0x8(%ebp),%eax
801047da:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801047e0:	e8 5d f2 ff ff       	call   80103a42 <myproc>
801047e5:	8b 50 10             	mov    0x10(%eax),%edx
801047e8:	8b 45 08             	mov    0x8(%ebp),%eax
801047eb:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801047ee:	8b 45 08             	mov    0x8(%ebp),%eax
801047f1:	83 c0 04             	add    $0x4,%eax
801047f4:	83 ec 0c             	sub    $0xc,%esp
801047f7:	50                   	push   %eax
801047f8:	e8 53 01 00 00       	call   80104950 <release>
801047fd:	83 c4 10             	add    $0x10,%esp
}
80104800:	90                   	nop
80104801:	c9                   	leave  
80104802:	c3                   	ret    

80104803 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104803:	55                   	push   %ebp
80104804:	89 e5                	mov    %esp,%ebp
80104806:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104809:	8b 45 08             	mov    0x8(%ebp),%eax
8010480c:	83 c0 04             	add    $0x4,%eax
8010480f:	83 ec 0c             	sub    $0xc,%esp
80104812:	50                   	push   %eax
80104813:	e8 ca 00 00 00       	call   801048e2 <acquire>
80104818:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
8010481b:	8b 45 08             	mov    0x8(%ebp),%eax
8010481e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104824:	8b 45 08             	mov    0x8(%ebp),%eax
80104827:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010482e:	83 ec 0c             	sub    $0xc,%esp
80104831:	ff 75 08             	push   0x8(%ebp)
80104834:	e8 2d fc ff ff       	call   80104466 <wakeup>
80104839:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
8010483c:	8b 45 08             	mov    0x8(%ebp),%eax
8010483f:	83 c0 04             	add    $0x4,%eax
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	50                   	push   %eax
80104846:	e8 05 01 00 00       	call   80104950 <release>
8010484b:	83 c4 10             	add    $0x10,%esp
}
8010484e:	90                   	nop
8010484f:	c9                   	leave  
80104850:	c3                   	ret    

80104851 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104851:	55                   	push   %ebp
80104852:	89 e5                	mov    %esp,%ebp
80104854:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104857:	8b 45 08             	mov    0x8(%ebp),%eax
8010485a:	83 c0 04             	add    $0x4,%eax
8010485d:	83 ec 0c             	sub    $0xc,%esp
80104860:	50                   	push   %eax
80104861:	e8 7c 00 00 00       	call   801048e2 <acquire>
80104866:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104869:	8b 45 08             	mov    0x8(%ebp),%eax
8010486c:	8b 00                	mov    (%eax),%eax
8010486e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104871:	8b 45 08             	mov    0x8(%ebp),%eax
80104874:	83 c0 04             	add    $0x4,%eax
80104877:	83 ec 0c             	sub    $0xc,%esp
8010487a:	50                   	push   %eax
8010487b:	e8 d0 00 00 00       	call   80104950 <release>
80104880:	83 c4 10             	add    $0x10,%esp
  return r;
80104883:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104886:	c9                   	leave  
80104887:	c3                   	ret    

80104888 <readeflags>:
{
80104888:	55                   	push   %ebp
80104889:	89 e5                	mov    %esp,%ebp
8010488b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010488e:	9c                   	pushf  
8010488f:	58                   	pop    %eax
80104890:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104893:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104896:	c9                   	leave  
80104897:	c3                   	ret    

80104898 <cli>:
{
80104898:	55                   	push   %ebp
80104899:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010489b:	fa                   	cli    
}
8010489c:	90                   	nop
8010489d:	5d                   	pop    %ebp
8010489e:	c3                   	ret    

8010489f <sti>:
{
8010489f:	55                   	push   %ebp
801048a0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801048a2:	fb                   	sti    
}
801048a3:	90                   	nop
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret    

801048a6 <xchg>:
{
801048a6:	55                   	push   %ebp
801048a7:	89 e5                	mov    %esp,%ebp
801048a9:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801048ac:	8b 55 08             	mov    0x8(%ebp),%edx
801048af:	8b 45 0c             	mov    0xc(%ebp),%eax
801048b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048b5:	f0 87 02             	lock xchg %eax,(%edx)
801048b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801048bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801048be:	c9                   	leave  
801048bf:	c3                   	ret    

801048c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801048c3:	8b 45 08             	mov    0x8(%ebp),%eax
801048c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801048c9:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801048cc:	8b 45 08             	mov    0x8(%ebp),%eax
801048cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801048d5:	8b 45 08             	mov    0x8(%ebp),%eax
801048d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048df:	90                   	nop
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret    

801048e2 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048e2:	55                   	push   %ebp
801048e3:	89 e5                	mov    %esp,%ebp
801048e5:	53                   	push   %ebx
801048e6:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048e9:	e8 5f 01 00 00       	call   80104a4d <pushcli>
  if(holding(lk)){
801048ee:	8b 45 08             	mov    0x8(%ebp),%eax
801048f1:	83 ec 0c             	sub    $0xc,%esp
801048f4:	50                   	push   %eax
801048f5:	e8 23 01 00 00       	call   80104a1d <holding>
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	85 c0                	test   %eax,%eax
801048ff:	74 0d                	je     8010490e <acquire+0x2c>
    panic("acquire");
80104901:	83 ec 0c             	sub    $0xc,%esp
80104904:	68 3f a9 10 80       	push   $0x8010a93f
80104909:	e8 9b bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010490e:	90                   	nop
8010490f:	8b 45 08             	mov    0x8(%ebp),%eax
80104912:	83 ec 08             	sub    $0x8,%esp
80104915:	6a 01                	push   $0x1
80104917:	50                   	push   %eax
80104918:	e8 89 ff ff ff       	call   801048a6 <xchg>
8010491d:	83 c4 10             	add    $0x10,%esp
80104920:	85 c0                	test   %eax,%eax
80104922:	75 eb                	jne    8010490f <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104924:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104929:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010492c:	e8 99 f0 ff ff       	call   801039ca <mycpu>
80104931:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104934:	8b 45 08             	mov    0x8(%ebp),%eax
80104937:	83 c0 0c             	add    $0xc,%eax
8010493a:	83 ec 08             	sub    $0x8,%esp
8010493d:	50                   	push   %eax
8010493e:	8d 45 08             	lea    0x8(%ebp),%eax
80104941:	50                   	push   %eax
80104942:	e8 5b 00 00 00       	call   801049a2 <getcallerpcs>
80104947:	83 c4 10             	add    $0x10,%esp
}
8010494a:	90                   	nop
8010494b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010494e:	c9                   	leave  
8010494f:	c3                   	ret    

80104950 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104956:	83 ec 0c             	sub    $0xc,%esp
80104959:	ff 75 08             	push   0x8(%ebp)
8010495c:	e8 bc 00 00 00       	call   80104a1d <holding>
80104961:	83 c4 10             	add    $0x10,%esp
80104964:	85 c0                	test   %eax,%eax
80104966:	75 0d                	jne    80104975 <release+0x25>
    panic("release");
80104968:	83 ec 0c             	sub    $0xc,%esp
8010496b:	68 47 a9 10 80       	push   $0x8010a947
80104970:	e8 34 bc ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104975:	8b 45 08             	mov    0x8(%ebp),%eax
80104978:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010497f:	8b 45 08             	mov    0x8(%ebp),%eax
80104982:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104989:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010498e:	8b 45 08             	mov    0x8(%ebp),%eax
80104991:	8b 55 08             	mov    0x8(%ebp),%edx
80104994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010499a:	e8 fb 00 00 00       	call   80104a9a <popcli>
}
8010499f:	90                   	nop
801049a0:	c9                   	leave  
801049a1:	c3                   	ret    

801049a2 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801049a2:	55                   	push   %ebp
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801049a8:	8b 45 08             	mov    0x8(%ebp),%eax
801049ab:	83 e8 08             	sub    $0x8,%eax
801049ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801049b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801049b8:	eb 38                	jmp    801049f2 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801049be:	74 53                	je     80104a13 <getcallerpcs+0x71>
801049c0:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801049c7:	76 4a                	jbe    80104a13 <getcallerpcs+0x71>
801049c9:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801049cd:	74 44                	je     80104a13 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801049dc:	01 c2                	add    %eax,%edx
801049de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049e1:	8b 40 04             	mov    0x4(%eax),%eax
801049e4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801049e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049e9:	8b 00                	mov    (%eax),%eax
801049eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801049ee:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801049f2:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801049f6:	7e c2                	jle    801049ba <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801049f8:	eb 19                	jmp    80104a13 <getcallerpcs+0x71>
    pcs[i] = 0;
801049fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a04:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a07:	01 d0                	add    %edx,%eax
80104a09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a0f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a13:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a17:	7e e1                	jle    801049fa <getcallerpcs+0x58>
}
80104a19:	90                   	nop
80104a1a:	90                   	nop
80104a1b:	c9                   	leave  
80104a1c:	c3                   	ret    

80104a1d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a1d:	55                   	push   %ebp
80104a1e:	89 e5                	mov    %esp,%ebp
80104a20:	53                   	push   %ebx
80104a21:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104a24:	8b 45 08             	mov    0x8(%ebp),%eax
80104a27:	8b 00                	mov    (%eax),%eax
80104a29:	85 c0                	test   %eax,%eax
80104a2b:	74 16                	je     80104a43 <holding+0x26>
80104a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80104a30:	8b 58 08             	mov    0x8(%eax),%ebx
80104a33:	e8 92 ef ff ff       	call   801039ca <mycpu>
80104a38:	39 c3                	cmp    %eax,%ebx
80104a3a:	75 07                	jne    80104a43 <holding+0x26>
80104a3c:	b8 01 00 00 00       	mov    $0x1,%eax
80104a41:	eb 05                	jmp    80104a48 <holding+0x2b>
80104a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a4b:	c9                   	leave  
80104a4c:	c3                   	ret    

80104a4d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a4d:	55                   	push   %ebp
80104a4e:	89 e5                	mov    %esp,%ebp
80104a50:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104a53:	e8 30 fe ff ff       	call   80104888 <readeflags>
80104a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104a5b:	e8 38 fe ff ff       	call   80104898 <cli>
  if(mycpu()->ncli == 0)
80104a60:	e8 65 ef ff ff       	call   801039ca <mycpu>
80104a65:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	75 14                	jne    80104a83 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104a6f:	e8 56 ef ff ff       	call   801039ca <mycpu>
80104a74:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a77:	81 e2 00 02 00 00    	and    $0x200,%edx
80104a7d:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a83:	e8 42 ef ff ff       	call   801039ca <mycpu>
80104a88:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a8e:	83 c2 01             	add    $0x1,%edx
80104a91:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104a97:	90                   	nop
80104a98:	c9                   	leave  
80104a99:	c3                   	ret    

80104a9a <popcli>:

void
popcli(void)
{
80104a9a:	55                   	push   %ebp
80104a9b:	89 e5                	mov    %esp,%ebp
80104a9d:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104aa0:	e8 e3 fd ff ff       	call   80104888 <readeflags>
80104aa5:	25 00 02 00 00       	and    $0x200,%eax
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	74 0d                	je     80104abb <popcli+0x21>
    panic("popcli - interruptible");
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	68 4f a9 10 80       	push   $0x8010a94f
80104ab6:	e8 ee ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104abb:	e8 0a ef ff ff       	call   801039ca <mycpu>
80104ac0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ac6:	83 ea 01             	sub    $0x1,%edx
80104ac9:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104acf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ad5:	85 c0                	test   %eax,%eax
80104ad7:	79 0d                	jns    80104ae6 <popcli+0x4c>
    panic("popcli");
80104ad9:	83 ec 0c             	sub    $0xc,%esp
80104adc:	68 66 a9 10 80       	push   $0x8010a966
80104ae1:	e8 c3 ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ae6:	e8 df ee ff ff       	call   801039ca <mycpu>
80104aeb:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af1:	85 c0                	test   %eax,%eax
80104af3:	75 14                	jne    80104b09 <popcli+0x6f>
80104af5:	e8 d0 ee ff ff       	call   801039ca <mycpu>
80104afa:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b00:	85 c0                	test   %eax,%eax
80104b02:	74 05                	je     80104b09 <popcli+0x6f>
    sti();
80104b04:	e8 96 fd ff ff       	call   8010489f <sti>
}
80104b09:	90                   	nop
80104b0a:	c9                   	leave  
80104b0b:	c3                   	ret    

80104b0c <stosb>:
{
80104b0c:	55                   	push   %ebp
80104b0d:	89 e5                	mov    %esp,%ebp
80104b0f:	57                   	push   %edi
80104b10:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104b11:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b14:	8b 55 10             	mov    0x10(%ebp),%edx
80104b17:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b1a:	89 cb                	mov    %ecx,%ebx
80104b1c:	89 df                	mov    %ebx,%edi
80104b1e:	89 d1                	mov    %edx,%ecx
80104b20:	fc                   	cld    
80104b21:	f3 aa                	rep stos %al,%es:(%edi)
80104b23:	89 ca                	mov    %ecx,%edx
80104b25:	89 fb                	mov    %edi,%ebx
80104b27:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b2a:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b2d:	90                   	nop
80104b2e:	5b                   	pop    %ebx
80104b2f:	5f                   	pop    %edi
80104b30:	5d                   	pop    %ebp
80104b31:	c3                   	ret    

80104b32 <stosl>:
{
80104b32:	55                   	push   %ebp
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	57                   	push   %edi
80104b36:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104b37:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b3a:	8b 55 10             	mov    0x10(%ebp),%edx
80104b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b40:	89 cb                	mov    %ecx,%ebx
80104b42:	89 df                	mov    %ebx,%edi
80104b44:	89 d1                	mov    %edx,%ecx
80104b46:	fc                   	cld    
80104b47:	f3 ab                	rep stos %eax,%es:(%edi)
80104b49:	89 ca                	mov    %ecx,%edx
80104b4b:	89 fb                	mov    %edi,%ebx
80104b4d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b50:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b53:	90                   	nop
80104b54:	5b                   	pop    %ebx
80104b55:	5f                   	pop    %edi
80104b56:	5d                   	pop    %ebp
80104b57:	c3                   	ret    

80104b58 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b58:	55                   	push   %ebp
80104b59:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5e:	83 e0 03             	and    $0x3,%eax
80104b61:	85 c0                	test   %eax,%eax
80104b63:	75 43                	jne    80104ba8 <memset+0x50>
80104b65:	8b 45 10             	mov    0x10(%ebp),%eax
80104b68:	83 e0 03             	and    $0x3,%eax
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	75 39                	jne    80104ba8 <memset+0x50>
    c &= 0xFF;
80104b6f:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b76:	8b 45 10             	mov    0x10(%ebp),%eax
80104b79:	c1 e8 02             	shr    $0x2,%eax
80104b7c:	89 c2                	mov    %eax,%edx
80104b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b81:	c1 e0 18             	shl    $0x18,%eax
80104b84:	89 c1                	mov    %eax,%ecx
80104b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b89:	c1 e0 10             	shl    $0x10,%eax
80104b8c:	09 c1                	or     %eax,%ecx
80104b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b91:	c1 e0 08             	shl    $0x8,%eax
80104b94:	09 c8                	or     %ecx,%eax
80104b96:	0b 45 0c             	or     0xc(%ebp),%eax
80104b99:	52                   	push   %edx
80104b9a:	50                   	push   %eax
80104b9b:	ff 75 08             	push   0x8(%ebp)
80104b9e:	e8 8f ff ff ff       	call   80104b32 <stosl>
80104ba3:	83 c4 0c             	add    $0xc,%esp
80104ba6:	eb 12                	jmp    80104bba <memset+0x62>
  } else
    stosb(dst, c, n);
80104ba8:	8b 45 10             	mov    0x10(%ebp),%eax
80104bab:	50                   	push   %eax
80104bac:	ff 75 0c             	push   0xc(%ebp)
80104baf:	ff 75 08             	push   0x8(%ebp)
80104bb2:	e8 55 ff ff ff       	call   80104b0c <stosb>
80104bb7:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104bba:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104bbd:	c9                   	leave  
80104bbe:	c3                   	ret    

80104bbf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bbf:	55                   	push   %ebp
80104bc0:	89 e5                	mov    %esp,%ebp
80104bc2:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104bd1:	eb 30                	jmp    80104c03 <memcmp+0x44>
    if(*s1 != *s2)
80104bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bd6:	0f b6 10             	movzbl (%eax),%edx
80104bd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bdc:	0f b6 00             	movzbl (%eax),%eax
80104bdf:	38 c2                	cmp    %al,%dl
80104be1:	74 18                	je     80104bfb <memcmp+0x3c>
      return *s1 - *s2;
80104be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104be6:	0f b6 00             	movzbl (%eax),%eax
80104be9:	0f b6 d0             	movzbl %al,%edx
80104bec:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bef:	0f b6 00             	movzbl (%eax),%eax
80104bf2:	0f b6 c8             	movzbl %al,%ecx
80104bf5:	89 d0                	mov    %edx,%eax
80104bf7:	29 c8                	sub    %ecx,%eax
80104bf9:	eb 1a                	jmp    80104c15 <memcmp+0x56>
    s1++, s2++;
80104bfb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104bff:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104c03:	8b 45 10             	mov    0x10(%ebp),%eax
80104c06:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c09:	89 55 10             	mov    %edx,0x10(%ebp)
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	75 c3                	jne    80104bd3 <memcmp+0x14>
  }

  return 0;
80104c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    

80104c17 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c17:	55                   	push   %ebp
80104c18:	89 e5                	mov    %esp,%ebp
80104c1a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104c23:	8b 45 08             	mov    0x8(%ebp),%eax
80104c26:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c2c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104c2f:	73 54                	jae    80104c85 <memmove+0x6e>
80104c31:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c34:	8b 45 10             	mov    0x10(%ebp),%eax
80104c37:	01 d0                	add    %edx,%eax
80104c39:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104c3c:	73 47                	jae    80104c85 <memmove+0x6e>
    s += n;
80104c3e:	8b 45 10             	mov    0x10(%ebp),%eax
80104c41:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104c44:	8b 45 10             	mov    0x10(%ebp),%eax
80104c47:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104c4a:	eb 13                	jmp    80104c5f <memmove+0x48>
      *--d = *--s;
80104c4c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104c50:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c57:	0f b6 10             	movzbl (%eax),%edx
80104c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c5d:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104c5f:	8b 45 10             	mov    0x10(%ebp),%eax
80104c62:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c65:	89 55 10             	mov    %edx,0x10(%ebp)
80104c68:	85 c0                	test   %eax,%eax
80104c6a:	75 e0                	jne    80104c4c <memmove+0x35>
  if(s < d && s + n > d){
80104c6c:	eb 24                	jmp    80104c92 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104c6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c71:	8d 42 01             	lea    0x1(%edx),%eax
80104c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c7a:	8d 48 01             	lea    0x1(%eax),%ecx
80104c7d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104c80:	0f b6 12             	movzbl (%edx),%edx
80104c83:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104c85:	8b 45 10             	mov    0x10(%ebp),%eax
80104c88:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c8b:	89 55 10             	mov    %edx,0x10(%ebp)
80104c8e:	85 c0                	test   %eax,%eax
80104c90:	75 dc                	jne    80104c6e <memmove+0x57>

  return dst;
80104c92:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104c95:	c9                   	leave  
80104c96:	c3                   	ret    

80104c97 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c97:	55                   	push   %ebp
80104c98:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104c9a:	ff 75 10             	push   0x10(%ebp)
80104c9d:	ff 75 0c             	push   0xc(%ebp)
80104ca0:	ff 75 08             	push   0x8(%ebp)
80104ca3:	e8 6f ff ff ff       	call   80104c17 <memmove>
80104ca8:	83 c4 0c             	add    $0xc,%esp
}
80104cab:	c9                   	leave  
80104cac:	c3                   	ret    

80104cad <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104cad:	55                   	push   %ebp
80104cae:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104cb0:	eb 0c                	jmp    80104cbe <strncmp+0x11>
    n--, p++, q++;
80104cb2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104cb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104cba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104cc2:	74 1a                	je     80104cde <strncmp+0x31>
80104cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc7:	0f b6 00             	movzbl (%eax),%eax
80104cca:	84 c0                	test   %al,%al
80104ccc:	74 10                	je     80104cde <strncmp+0x31>
80104cce:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd1:	0f b6 10             	movzbl (%eax),%edx
80104cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cd7:	0f b6 00             	movzbl (%eax),%eax
80104cda:	38 c2                	cmp    %al,%dl
80104cdc:	74 d4                	je     80104cb2 <strncmp+0x5>
  if(n == 0)
80104cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ce2:	75 07                	jne    80104ceb <strncmp+0x3e>
    return 0;
80104ce4:	b8 00 00 00 00       	mov    $0x0,%eax
80104ce9:	eb 16                	jmp    80104d01 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80104cee:	0f b6 00             	movzbl (%eax),%eax
80104cf1:	0f b6 d0             	movzbl %al,%edx
80104cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cf7:	0f b6 00             	movzbl (%eax),%eax
80104cfa:	0f b6 c8             	movzbl %al,%ecx
80104cfd:	89 d0                	mov    %edx,%eax
80104cff:	29 c8                	sub    %ecx,%eax
}
80104d01:	5d                   	pop    %ebp
80104d02:	c3                   	ret    

80104d03 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d03:	55                   	push   %ebp
80104d04:	89 e5                	mov    %esp,%ebp
80104d06:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d09:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d0f:	90                   	nop
80104d10:	8b 45 10             	mov    0x10(%ebp),%eax
80104d13:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d16:	89 55 10             	mov    %edx,0x10(%ebp)
80104d19:	85 c0                	test   %eax,%eax
80104d1b:	7e 2c                	jle    80104d49 <strncpy+0x46>
80104d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d20:	8d 42 01             	lea    0x1(%edx),%eax
80104d23:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d26:	8b 45 08             	mov    0x8(%ebp),%eax
80104d29:	8d 48 01             	lea    0x1(%eax),%ecx
80104d2c:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d2f:	0f b6 12             	movzbl (%edx),%edx
80104d32:	88 10                	mov    %dl,(%eax)
80104d34:	0f b6 00             	movzbl (%eax),%eax
80104d37:	84 c0                	test   %al,%al
80104d39:	75 d5                	jne    80104d10 <strncpy+0xd>
    ;
  while(n-- > 0)
80104d3b:	eb 0c                	jmp    80104d49 <strncpy+0x46>
    *s++ = 0;
80104d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d40:	8d 50 01             	lea    0x1(%eax),%edx
80104d43:	89 55 08             	mov    %edx,0x8(%ebp)
80104d46:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104d49:	8b 45 10             	mov    0x10(%ebp),%eax
80104d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d4f:	89 55 10             	mov    %edx,0x10(%ebp)
80104d52:	85 c0                	test   %eax,%eax
80104d54:	7f e7                	jg     80104d3d <strncpy+0x3a>
  return os;
80104d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d59:	c9                   	leave  
80104d5a:	c3                   	ret    

80104d5b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d5b:	55                   	push   %ebp
80104d5c:	89 e5                	mov    %esp,%ebp
80104d5e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d61:	8b 45 08             	mov    0x8(%ebp),%eax
80104d64:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104d67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d6b:	7f 05                	jg     80104d72 <safestrcpy+0x17>
    return os;
80104d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d70:	eb 32                	jmp    80104da4 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80104d72:	90                   	nop
80104d73:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d7b:	7e 1e                	jle    80104d9b <safestrcpy+0x40>
80104d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d80:	8d 42 01             	lea    0x1(%edx),%eax
80104d83:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d86:	8b 45 08             	mov    0x8(%ebp),%eax
80104d89:	8d 48 01             	lea    0x1(%eax),%ecx
80104d8c:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d8f:	0f b6 12             	movzbl (%edx),%edx
80104d92:	88 10                	mov    %dl,(%eax)
80104d94:	0f b6 00             	movzbl (%eax),%eax
80104d97:	84 c0                	test   %al,%al
80104d99:	75 d8                	jne    80104d73 <safestrcpy+0x18>
    ;
  *s = 0;
80104d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d9e:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104da4:	c9                   	leave  
80104da5:	c3                   	ret    

80104da6 <strlen>:

int
strlen(const char *s)
{
80104da6:	55                   	push   %ebp
80104da7:	89 e5                	mov    %esp,%ebp
80104da9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104dac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104db3:	eb 04                	jmp    80104db9 <strlen+0x13>
80104db5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104db9:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dbc:	8b 45 08             	mov    0x8(%ebp),%eax
80104dbf:	01 d0                	add    %edx,%eax
80104dc1:	0f b6 00             	movzbl (%eax),%eax
80104dc4:	84 c0                	test   %al,%al
80104dc6:	75 ed                	jne    80104db5 <strlen+0xf>
    ;
  return n;
80104dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104dcb:	c9                   	leave  
80104dcc:	c3                   	ret    

80104dcd <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104dcd:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104dd1:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104dd5:	55                   	push   %ebp
  pushl %ebx
80104dd6:	53                   	push   %ebx
  pushl %esi
80104dd7:	56                   	push   %esi
  pushl %edi
80104dd8:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104dd9:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ddb:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104ddd:	5f                   	pop    %edi
  popl %esi
80104dde:	5e                   	pop    %esi
  popl %ebx
80104ddf:	5b                   	pop    %ebx
  popl %ebp
80104de0:	5d                   	pop    %ebp
  ret
80104de1:	c3                   	ret    

80104de2 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104de2:	55                   	push   %ebp
80104de3:	89 e5                	mov    %esp,%ebp
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
80104de5:	81 7d 08 fe ff ff 7f 	cmpl   $0x7ffffffe,0x8(%ebp)
80104dec:	77 0a                	ja     80104df8 <fetchint+0x16>
80104dee:	8b 45 08             	mov    0x8(%ebp),%eax
80104df1:	83 c0 04             	add    $0x4,%eax
80104df4:	85 c0                	test   %eax,%eax
80104df6:	79 07                	jns    80104dff <fetchint+0x1d>
    return -1;
80104df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfd:	eb 0f                	jmp    80104e0e <fetchint+0x2c>

  *ip = *(int*)(addr);
80104dff:	8b 45 08             	mov    0x8(%ebp),%eax
80104e02:	8b 10                	mov    (%eax),%edx
80104e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e07:	89 10                	mov    %edx,(%eax)
  
  return 0;
80104e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e0e:	5d                   	pop    %ebp
80104e0f:	c3                   	ret    

80104e10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= (KERNBASE-1))
80104e16:	81 7d 08 fe ff ff 7f 	cmpl   $0x7ffffffe,0x8(%ebp)
80104e1d:	76 07                	jbe    80104e26 <fetchstr+0x16>
    return -1;
80104e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e24:	eb 40                	jmp    80104e66 <fetchstr+0x56>

  *pp = (char*)addr;
80104e26:	8b 55 08             	mov    0x8(%ebp),%edx
80104e29:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e2c:	89 10                	mov    %edx,(%eax)
  ep = (char*)(KERNBASE-1);
80104e2e:	c7 45 f8 ff ff ff 7f 	movl   $0x7fffffff,-0x8(%ebp)

  for(s = *pp; s < ep; s++){
80104e35:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e38:	8b 00                	mov    (%eax),%eax
80104e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e3d:	eb 1a                	jmp    80104e59 <fetchstr+0x49>
    if(*s == 0)
80104e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e42:	0f b6 00             	movzbl (%eax),%eax
80104e45:	84 c0                	test   %al,%al
80104e47:	75 0c                	jne    80104e55 <fetchstr+0x45>
      return s - *pp;
80104e49:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e4c:	8b 10                	mov    (%eax),%edx
80104e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e51:	29 d0                	sub    %edx,%eax
80104e53:	eb 11                	jmp    80104e66 <fetchstr+0x56>
  for(s = *pp; s < ep; s++){
80104e55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e5f:	72 de                	jb     80104e3f <fetchstr+0x2f>
  }
  return -1;
80104e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e66:	c9                   	leave  
80104e67:	c3                   	ret    

80104e68 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e6e:	e8 cf eb ff ff       	call   80103a42 <myproc>
80104e73:	8b 40 18             	mov    0x18(%eax),%eax
80104e76:	8b 50 44             	mov    0x44(%eax),%edx
80104e79:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7c:	c1 e0 02             	shl    $0x2,%eax
80104e7f:	01 d0                	add    %edx,%eax
80104e81:	83 c0 04             	add    $0x4,%eax
80104e84:	83 ec 08             	sub    $0x8,%esp
80104e87:	ff 75 0c             	push   0xc(%ebp)
80104e8a:	50                   	push   %eax
80104e8b:	e8 52 ff ff ff       	call   80104de2 <fetchint>
80104e90:	83 c4 10             	add    $0x10,%esp
}
80104e93:	c9                   	leave  
80104e94:	c3                   	ret    

80104e95 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e95:	55                   	push   %ebp
80104e96:	89 e5                	mov    %esp,%ebp
80104e98:	83 ec 18             	sub    $0x18,%esp
  int i;
 
  if(argint(n, &i) < 0)
80104e9b:	83 ec 08             	sub    $0x8,%esp
80104e9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea1:	50                   	push   %eax
80104ea2:	ff 75 08             	push   0x8(%ebp)
80104ea5:	e8 be ff ff ff       	call   80104e68 <argint>
80104eaa:	83 c4 10             	add    $0x10,%esp
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	79 07                	jns    80104eb8 <argptr+0x23>
    return -1;
80104eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb6:	eb 34                	jmp    80104eec <argptr+0x57>
  if(size < 0 || (uint)i >= (KERNBASE-1) || (uint)i+size > (KERNBASE-1))
80104eb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ebc:	78 18                	js     80104ed6 <argptr+0x41>
80104ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec1:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104ec6:	77 0e                	ja     80104ed6 <argptr+0x41>
80104ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecb:	89 c2                	mov    %eax,%edx
80104ecd:	8b 45 10             	mov    0x10(%ebp),%eax
80104ed0:	01 d0                	add    %edx,%eax
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	79 07                	jns    80104edd <argptr+0x48>
    return -1;
80104ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edb:	eb 0f                	jmp    80104eec <argptr+0x57>
  *pp = (char*)i;
80104edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee0:	89 c2                	mov    %eax,%edx
80104ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ee5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104eec:	c9                   	leave  
80104eed:	c3                   	ret    

80104eee <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104eee:	55                   	push   %ebp
80104eef:	89 e5                	mov    %esp,%ebp
80104ef1:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ef4:	83 ec 08             	sub    $0x8,%esp
80104ef7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104efa:	50                   	push   %eax
80104efb:	ff 75 08             	push   0x8(%ebp)
80104efe:	e8 65 ff ff ff       	call   80104e68 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	79 07                	jns    80104f11 <argstr+0x23>
    return -1;
80104f0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0f:	eb 12                	jmp    80104f23 <argstr+0x35>
  return fetchstr(addr, pp);
80104f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f14:	83 ec 08             	sub    $0x8,%esp
80104f17:	ff 75 0c             	push   0xc(%ebp)
80104f1a:	50                   	push   %eax
80104f1b:	e8 f0 fe ff ff       	call   80104e10 <fetchstr>
80104f20:	83 c4 10             	add    $0x10,%esp
}
80104f23:	c9                   	leave  
80104f24:	c3                   	ret    

80104f25 <syscall>:
[SYS_printpt] sys_printpt,
};

void
syscall(void)
{
80104f25:	55                   	push   %ebp
80104f26:	89 e5                	mov    %esp,%ebp
80104f28:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104f2b:	e8 12 eb ff ff       	call   80103a42 <myproc>
80104f30:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f36:	8b 40 18             	mov    0x18(%eax),%eax
80104f39:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f43:	7e 2f                	jle    80104f74 <syscall+0x4f>
80104f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f48:	83 f8 16             	cmp    $0x16,%eax
80104f4b:	77 27                	ja     80104f74 <syscall+0x4f>
80104f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f50:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f57:	85 c0                	test   %eax,%eax
80104f59:	74 19                	je     80104f74 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f5e:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f65:	ff d0                	call   *%eax
80104f67:	89 c2                	mov    %eax,%edx
80104f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6c:	8b 40 18             	mov    0x18(%eax),%eax
80104f6f:	89 50 1c             	mov    %edx,0x1c(%eax)
80104f72:	eb 2c                	jmp    80104fa0 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f77:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f7d:	8b 40 10             	mov    0x10(%eax),%eax
80104f80:	ff 75 f0             	push   -0x10(%ebp)
80104f83:	52                   	push   %edx
80104f84:	50                   	push   %eax
80104f85:	68 6d a9 10 80       	push   $0x8010a96d
80104f8a:	e8 65 b4 ff ff       	call   801003f4 <cprintf>
80104f8f:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80104f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f95:	8b 40 18             	mov    0x18(%eax),%eax
80104f98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f9f:	90                   	nop
80104fa0:	90                   	nop
80104fa1:	c9                   	leave  
80104fa2:	c3                   	ret    

80104fa3 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104fa3:	55                   	push   %ebp
80104fa4:	89 e5                	mov    %esp,%ebp
80104fa6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fa9:	83 ec 08             	sub    $0x8,%esp
80104fac:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104faf:	50                   	push   %eax
80104fb0:	ff 75 08             	push   0x8(%ebp)
80104fb3:	e8 b0 fe ff ff       	call   80104e68 <argint>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	79 07                	jns    80104fc6 <argfd+0x23>
    return -1;
80104fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc4:	eb 4f                	jmp    80105015 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	78 20                	js     80104fed <argfd+0x4a>
80104fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd0:	83 f8 0f             	cmp    $0xf,%eax
80104fd3:	7f 18                	jg     80104fed <argfd+0x4a>
80104fd5:	e8 68 ea ff ff       	call   80103a42 <myproc>
80104fda:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fdd:	83 c2 08             	add    $0x8,%edx
80104fe0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104feb:	75 07                	jne    80104ff4 <argfd+0x51>
    return -1;
80104fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ff2:	eb 21                	jmp    80105015 <argfd+0x72>
  if(pfd)
80104ff4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ff8:	74 08                	je     80105002 <argfd+0x5f>
    *pfd = fd;
80104ffa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105000:	89 10                	mov    %edx,(%eax)
  if(pf)
80105002:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105006:	74 08                	je     80105010 <argfd+0x6d>
    *pf = f;
80105008:	8b 45 10             	mov    0x10(%ebp),%eax
8010500b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010500e:	89 10                	mov    %edx,(%eax)
  return 0;
80105010:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    

80105017 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105017:	55                   	push   %ebp
80105018:	89 e5                	mov    %esp,%ebp
8010501a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
8010501d:	e8 20 ea ff ff       	call   80103a42 <myproc>
80105022:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010502c:	eb 2a                	jmp    80105058 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
8010502e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105031:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105034:	83 c2 08             	add    $0x8,%edx
80105037:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010503b:	85 c0                	test   %eax,%eax
8010503d:	75 15                	jne    80105054 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
8010503f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105042:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105045:	8d 4a 08             	lea    0x8(%edx),%ecx
80105048:	8b 55 08             	mov    0x8(%ebp),%edx
8010504b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010504f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105052:	eb 0f                	jmp    80105063 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105054:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105058:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505c:	7e d0                	jle    8010502e <fdalloc+0x17>
    }
  }
  return -1;
8010505e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105063:	c9                   	leave  
80105064:	c3                   	ret    

80105065 <sys_dup>:

int
sys_dup(void)
{
80105065:	55                   	push   %ebp
80105066:	89 e5                	mov    %esp,%ebp
80105068:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010506b:	83 ec 04             	sub    $0x4,%esp
8010506e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105071:	50                   	push   %eax
80105072:	6a 00                	push   $0x0
80105074:	6a 00                	push   $0x0
80105076:	e8 28 ff ff ff       	call   80104fa3 <argfd>
8010507b:	83 c4 10             	add    $0x10,%esp
8010507e:	85 c0                	test   %eax,%eax
80105080:	79 07                	jns    80105089 <sys_dup+0x24>
    return -1;
80105082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105087:	eb 31                	jmp    801050ba <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010508c:	83 ec 0c             	sub    $0xc,%esp
8010508f:	50                   	push   %eax
80105090:	e8 82 ff ff ff       	call   80105017 <fdalloc>
80105095:	83 c4 10             	add    $0x10,%esp
80105098:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010509b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010509f:	79 07                	jns    801050a8 <sys_dup+0x43>
    return -1;
801050a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a6:	eb 12                	jmp    801050ba <sys_dup+0x55>
  filedup(f);
801050a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ab:	83 ec 0c             	sub    $0xc,%esp
801050ae:	50                   	push   %eax
801050af:	e8 7b bf ff ff       	call   8010102f <filedup>
801050b4:	83 c4 10             	add    $0x10,%esp
  return fd;
801050b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801050ba:	c9                   	leave  
801050bb:	c3                   	ret    

801050bc <sys_read>:

int
sys_read(void)
{
801050bc:	55                   	push   %ebp
801050bd:	89 e5                	mov    %esp,%ebp
801050bf:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c2:	83 ec 04             	sub    $0x4,%esp
801050c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050c8:	50                   	push   %eax
801050c9:	6a 00                	push   $0x0
801050cb:	6a 00                	push   $0x0
801050cd:	e8 d1 fe ff ff       	call   80104fa3 <argfd>
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	85 c0                	test   %eax,%eax
801050d7:	78 2e                	js     80105107 <sys_read+0x4b>
801050d9:	83 ec 08             	sub    $0x8,%esp
801050dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050df:	50                   	push   %eax
801050e0:	6a 02                	push   $0x2
801050e2:	e8 81 fd ff ff       	call   80104e68 <argint>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	85 c0                	test   %eax,%eax
801050ec:	78 19                	js     80105107 <sys_read+0x4b>
801050ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050f1:	83 ec 04             	sub    $0x4,%esp
801050f4:	50                   	push   %eax
801050f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050f8:	50                   	push   %eax
801050f9:	6a 01                	push   $0x1
801050fb:	e8 95 fd ff ff       	call   80104e95 <argptr>
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	85 c0                	test   %eax,%eax
80105105:	79 07                	jns    8010510e <sys_read+0x52>
    return -1;
80105107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510c:	eb 17                	jmp    80105125 <sys_read+0x69>
  return fileread(f, p, n);
8010510e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105111:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105117:	83 ec 04             	sub    $0x4,%esp
8010511a:	51                   	push   %ecx
8010511b:	52                   	push   %edx
8010511c:	50                   	push   %eax
8010511d:	e8 9d c0 ff ff       	call   801011bf <fileread>
80105122:	83 c4 10             	add    $0x10,%esp
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    

80105127 <sys_write>:

int
sys_write(void)
{
80105127:	55                   	push   %ebp
80105128:	89 e5                	mov    %esp,%ebp
8010512a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010512d:	83 ec 04             	sub    $0x4,%esp
80105130:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105133:	50                   	push   %eax
80105134:	6a 00                	push   $0x0
80105136:	6a 00                	push   $0x0
80105138:	e8 66 fe ff ff       	call   80104fa3 <argfd>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 2e                	js     80105172 <sys_write+0x4b>
80105144:	83 ec 08             	sub    $0x8,%esp
80105147:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010514a:	50                   	push   %eax
8010514b:	6a 02                	push   $0x2
8010514d:	e8 16 fd ff ff       	call   80104e68 <argint>
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	85 c0                	test   %eax,%eax
80105157:	78 19                	js     80105172 <sys_write+0x4b>
80105159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515c:	83 ec 04             	sub    $0x4,%esp
8010515f:	50                   	push   %eax
80105160:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105163:	50                   	push   %eax
80105164:	6a 01                	push   $0x1
80105166:	e8 2a fd ff ff       	call   80104e95 <argptr>
8010516b:	83 c4 10             	add    $0x10,%esp
8010516e:	85 c0                	test   %eax,%eax
80105170:	79 07                	jns    80105179 <sys_write+0x52>
    return -1;
80105172:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105177:	eb 17                	jmp    80105190 <sys_write+0x69>
  return filewrite(f, p, n);
80105179:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010517c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010517f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105182:	83 ec 04             	sub    $0x4,%esp
80105185:	51                   	push   %ecx
80105186:	52                   	push   %edx
80105187:	50                   	push   %eax
80105188:	e8 ea c0 ff ff       	call   80101277 <filewrite>
8010518d:	83 c4 10             	add    $0x10,%esp
}
80105190:	c9                   	leave  
80105191:	c3                   	ret    

80105192 <sys_close>:

int
sys_close(void)
{
80105192:	55                   	push   %ebp
80105193:	89 e5                	mov    %esp,%ebp
80105195:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105198:	83 ec 04             	sub    $0x4,%esp
8010519b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010519e:	50                   	push   %eax
8010519f:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051a2:	50                   	push   %eax
801051a3:	6a 00                	push   $0x0
801051a5:	e8 f9 fd ff ff       	call   80104fa3 <argfd>
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	85 c0                	test   %eax,%eax
801051af:	79 07                	jns    801051b8 <sys_close+0x26>
    return -1;
801051b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b6:	eb 27                	jmp    801051df <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
801051b8:	e8 85 e8 ff ff       	call   80103a42 <myproc>
801051bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051c0:	83 c2 08             	add    $0x8,%edx
801051c3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801051ca:	00 
  fileclose(f);
801051cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ce:	83 ec 0c             	sub    $0xc,%esp
801051d1:	50                   	push   %eax
801051d2:	e8 a9 be ff ff       	call   80101080 <fileclose>
801051d7:	83 c4 10             	add    $0x10,%esp
  return 0;
801051da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051df:	c9                   	leave  
801051e0:	c3                   	ret    

801051e1 <sys_fstat>:

int
sys_fstat(void)
{
801051e1:	55                   	push   %ebp
801051e2:	89 e5                	mov    %esp,%ebp
801051e4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051e7:	83 ec 04             	sub    $0x4,%esp
801051ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ed:	50                   	push   %eax
801051ee:	6a 00                	push   $0x0
801051f0:	6a 00                	push   $0x0
801051f2:	e8 ac fd ff ff       	call   80104fa3 <argfd>
801051f7:	83 c4 10             	add    $0x10,%esp
801051fa:	85 c0                	test   %eax,%eax
801051fc:	78 17                	js     80105215 <sys_fstat+0x34>
801051fe:	83 ec 04             	sub    $0x4,%esp
80105201:	6a 14                	push   $0x14
80105203:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105206:	50                   	push   %eax
80105207:	6a 01                	push   $0x1
80105209:	e8 87 fc ff ff       	call   80104e95 <argptr>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	79 07                	jns    8010521c <sys_fstat+0x3b>
    return -1;
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521a:	eb 13                	jmp    8010522f <sys_fstat+0x4e>
  return filestat(f, st);
8010521c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010521f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105222:	83 ec 08             	sub    $0x8,%esp
80105225:	52                   	push   %edx
80105226:	50                   	push   %eax
80105227:	e8 3c bf ff ff       	call   80101168 <filestat>
8010522c:	83 c4 10             	add    $0x10,%esp
}
8010522f:	c9                   	leave  
80105230:	c3                   	ret    

80105231 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105231:	55                   	push   %ebp
80105232:	89 e5                	mov    %esp,%ebp
80105234:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010523d:	50                   	push   %eax
8010523e:	6a 00                	push   $0x0
80105240:	e8 a9 fc ff ff       	call   80104eee <argstr>
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	85 c0                	test   %eax,%eax
8010524a:	78 15                	js     80105261 <sys_link+0x30>
8010524c:	83 ec 08             	sub    $0x8,%esp
8010524f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105252:	50                   	push   %eax
80105253:	6a 01                	push   $0x1
80105255:	e8 94 fc ff ff       	call   80104eee <argstr>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	79 0a                	jns    8010526b <sys_link+0x3a>
    return -1;
80105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105266:	e9 68 01 00 00       	jmp    801053d3 <sys_link+0x1a2>

  begin_op();
8010526b:	e8 de dd ff ff       	call   8010304e <begin_op>
  if((ip = namei(old)) == 0){
80105270:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105273:	83 ec 0c             	sub    $0xc,%esp
80105276:	50                   	push   %eax
80105277:	e8 86 d2 ff ff       	call   80102502 <namei>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105286:	75 0f                	jne    80105297 <sys_link+0x66>
    end_op();
80105288:	e8 4d de ff ff       	call   801030da <end_op>
    return -1;
8010528d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105292:	e9 3c 01 00 00       	jmp    801053d3 <sys_link+0x1a2>
  }

  ilock(ip);
80105297:	83 ec 0c             	sub    $0xc,%esp
8010529a:	ff 75 f4             	push   -0xc(%ebp)
8010529d:	e8 2d c7 ff ff       	call   801019cf <ilock>
801052a2:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801052a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a8:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801052ac:	66 83 f8 01          	cmp    $0x1,%ax
801052b0:	75 1d                	jne    801052cf <sys_link+0x9e>
    iunlockput(ip);
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	ff 75 f4             	push   -0xc(%ebp)
801052b8:	e8 43 c9 ff ff       	call   80101c00 <iunlockput>
801052bd:	83 c4 10             	add    $0x10,%esp
    end_op();
801052c0:	e8 15 de ff ff       	call   801030da <end_op>
    return -1;
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ca:	e9 04 01 00 00       	jmp    801053d3 <sys_link+0x1a2>
  }

  ip->nlink++;
801052cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052d2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801052d6:	83 c0 01             	add    $0x1,%eax
801052d9:	89 c2                	mov    %eax,%edx
801052db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052de:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801052e2:	83 ec 0c             	sub    $0xc,%esp
801052e5:	ff 75 f4             	push   -0xc(%ebp)
801052e8:	e8 05 c5 ff ff       	call   801017f2 <iupdate>
801052ed:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	ff 75 f4             	push   -0xc(%ebp)
801052f6:	e8 e7 c7 ff ff       	call   80101ae2 <iunlock>
801052fb:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801052fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105301:	83 ec 08             	sub    $0x8,%esp
80105304:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105307:	52                   	push   %edx
80105308:	50                   	push   %eax
80105309:	e8 10 d2 ff ff       	call   8010251e <nameiparent>
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105318:	74 71                	je     8010538b <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010531a:	83 ec 0c             	sub    $0xc,%esp
8010531d:	ff 75 f0             	push   -0x10(%ebp)
80105320:	e8 aa c6 ff ff       	call   801019cf <ilock>
80105325:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105328:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010532b:	8b 10                	mov    (%eax),%edx
8010532d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105330:	8b 00                	mov    (%eax),%eax
80105332:	39 c2                	cmp    %eax,%edx
80105334:	75 1d                	jne    80105353 <sys_link+0x122>
80105336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105339:	8b 40 04             	mov    0x4(%eax),%eax
8010533c:	83 ec 04             	sub    $0x4,%esp
8010533f:	50                   	push   %eax
80105340:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105343:	50                   	push   %eax
80105344:	ff 75 f0             	push   -0x10(%ebp)
80105347:	e8 1f cf ff ff       	call   8010226b <dirlink>
8010534c:	83 c4 10             	add    $0x10,%esp
8010534f:	85 c0                	test   %eax,%eax
80105351:	79 10                	jns    80105363 <sys_link+0x132>
    iunlockput(dp);
80105353:	83 ec 0c             	sub    $0xc,%esp
80105356:	ff 75 f0             	push   -0x10(%ebp)
80105359:	e8 a2 c8 ff ff       	call   80101c00 <iunlockput>
8010535e:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105361:	eb 29                	jmp    8010538c <sys_link+0x15b>
  }
  iunlockput(dp);
80105363:	83 ec 0c             	sub    $0xc,%esp
80105366:	ff 75 f0             	push   -0x10(%ebp)
80105369:	e8 92 c8 ff ff       	call   80101c00 <iunlockput>
8010536e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105371:	83 ec 0c             	sub    $0xc,%esp
80105374:	ff 75 f4             	push   -0xc(%ebp)
80105377:	e8 b4 c7 ff ff       	call   80101b30 <iput>
8010537c:	83 c4 10             	add    $0x10,%esp

  end_op();
8010537f:	e8 56 dd ff ff       	call   801030da <end_op>

  return 0;
80105384:	b8 00 00 00 00       	mov    $0x0,%eax
80105389:	eb 48                	jmp    801053d3 <sys_link+0x1a2>
    goto bad;
8010538b:	90                   	nop

bad:
  ilock(ip);
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	ff 75 f4             	push   -0xc(%ebp)
80105392:	e8 38 c6 ff ff       	call   801019cf <ilock>
80105397:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010539a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801053a1:	83 e8 01             	sub    $0x1,%eax
801053a4:	89 c2                	mov    %eax,%edx
801053a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a9:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801053ad:	83 ec 0c             	sub    $0xc,%esp
801053b0:	ff 75 f4             	push   -0xc(%ebp)
801053b3:	e8 3a c4 ff ff       	call   801017f2 <iupdate>
801053b8:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801053bb:	83 ec 0c             	sub    $0xc,%esp
801053be:	ff 75 f4             	push   -0xc(%ebp)
801053c1:	e8 3a c8 ff ff       	call   80101c00 <iunlockput>
801053c6:	83 c4 10             	add    $0x10,%esp
  end_op();
801053c9:	e8 0c dd ff ff       	call   801030da <end_op>
  return -1;
801053ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d3:	c9                   	leave  
801053d4:	c3                   	ret    

801053d5 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801053d5:	55                   	push   %ebp
801053d6:	89 e5                	mov    %esp,%ebp
801053d8:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053db:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801053e2:	eb 40                	jmp    80105424 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e7:	6a 10                	push   $0x10
801053e9:	50                   	push   %eax
801053ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053ed:	50                   	push   %eax
801053ee:	ff 75 08             	push   0x8(%ebp)
801053f1:	e8 c5 ca ff ff       	call   80101ebb <readi>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	83 f8 10             	cmp    $0x10,%eax
801053fc:	74 0d                	je     8010540b <isdirempty+0x36>
      panic("isdirempty: readi");
801053fe:	83 ec 0c             	sub    $0xc,%esp
80105401:	68 89 a9 10 80       	push   $0x8010a989
80105406:	e8 9e b1 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
8010540b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010540f:	66 85 c0             	test   %ax,%ax
80105412:	74 07                	je     8010541b <isdirempty+0x46>
      return 0;
80105414:	b8 00 00 00 00       	mov    $0x0,%eax
80105419:	eb 1b                	jmp    80105436 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010541b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010541e:	83 c0 10             	add    $0x10,%eax
80105421:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105424:	8b 45 08             	mov    0x8(%ebp),%eax
80105427:	8b 50 58             	mov    0x58(%eax),%edx
8010542a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010542d:	39 c2                	cmp    %eax,%edx
8010542f:	77 b3                	ja     801053e4 <isdirempty+0xf>
  }
  return 1;
80105431:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105436:	c9                   	leave  
80105437:	c3                   	ret    

80105438 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105438:	55                   	push   %ebp
80105439:	89 e5                	mov    %esp,%ebp
8010543b:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010543e:	83 ec 08             	sub    $0x8,%esp
80105441:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105444:	50                   	push   %eax
80105445:	6a 00                	push   $0x0
80105447:	e8 a2 fa ff ff       	call   80104eee <argstr>
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	85 c0                	test   %eax,%eax
80105451:	79 0a                	jns    8010545d <sys_unlink+0x25>
    return -1;
80105453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105458:	e9 bf 01 00 00       	jmp    8010561c <sys_unlink+0x1e4>

  begin_op();
8010545d:	e8 ec db ff ff       	call   8010304e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105462:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105465:	83 ec 08             	sub    $0x8,%esp
80105468:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010546b:	52                   	push   %edx
8010546c:	50                   	push   %eax
8010546d:	e8 ac d0 ff ff       	call   8010251e <nameiparent>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010547c:	75 0f                	jne    8010548d <sys_unlink+0x55>
    end_op();
8010547e:	e8 57 dc ff ff       	call   801030da <end_op>
    return -1;
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105488:	e9 8f 01 00 00       	jmp    8010561c <sys_unlink+0x1e4>
  }

  ilock(dp);
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	ff 75 f4             	push   -0xc(%ebp)
80105493:	e8 37 c5 ff ff       	call   801019cf <ilock>
80105498:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010549b:	83 ec 08             	sub    $0x8,%esp
8010549e:	68 9b a9 10 80       	push   $0x8010a99b
801054a3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054a6:	50                   	push   %eax
801054a7:	e8 ea cc ff ff       	call   80102196 <namecmp>
801054ac:	83 c4 10             	add    $0x10,%esp
801054af:	85 c0                	test   %eax,%eax
801054b1:	0f 84 49 01 00 00    	je     80105600 <sys_unlink+0x1c8>
801054b7:	83 ec 08             	sub    $0x8,%esp
801054ba:	68 9d a9 10 80       	push   $0x8010a99d
801054bf:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054c2:	50                   	push   %eax
801054c3:	e8 ce cc ff ff       	call   80102196 <namecmp>
801054c8:	83 c4 10             	add    $0x10,%esp
801054cb:	85 c0                	test   %eax,%eax
801054cd:	0f 84 2d 01 00 00    	je     80105600 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054d3:	83 ec 04             	sub    $0x4,%esp
801054d6:	8d 45 c8             	lea    -0x38(%ebp),%eax
801054d9:	50                   	push   %eax
801054da:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054dd:	50                   	push   %eax
801054de:	ff 75 f4             	push   -0xc(%ebp)
801054e1:	e8 cb cc ff ff       	call   801021b1 <dirlookup>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801054ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054f0:	0f 84 0d 01 00 00    	je     80105603 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801054f6:	83 ec 0c             	sub    $0xc,%esp
801054f9:	ff 75 f0             	push   -0x10(%ebp)
801054fc:	e8 ce c4 ff ff       	call   801019cf <ilock>
80105501:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105504:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105507:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010550b:	66 85 c0             	test   %ax,%ax
8010550e:	7f 0d                	jg     8010551d <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	68 a0 a9 10 80       	push   $0x8010a9a0
80105518:	e8 8c b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010551d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105520:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105524:	66 83 f8 01          	cmp    $0x1,%ax
80105528:	75 25                	jne    8010554f <sys_unlink+0x117>
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	ff 75 f0             	push   -0x10(%ebp)
80105530:	e8 a0 fe ff ff       	call   801053d5 <isdirempty>
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	85 c0                	test   %eax,%eax
8010553a:	75 13                	jne    8010554f <sys_unlink+0x117>
    iunlockput(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	ff 75 f0             	push   -0x10(%ebp)
80105542:	e8 b9 c6 ff ff       	call   80101c00 <iunlockput>
80105547:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010554a:	e9 b5 00 00 00       	jmp    80105604 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
8010554f:	83 ec 04             	sub    $0x4,%esp
80105552:	6a 10                	push   $0x10
80105554:	6a 00                	push   $0x0
80105556:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105559:	50                   	push   %eax
8010555a:	e8 f9 f5 ff ff       	call   80104b58 <memset>
8010555f:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105562:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105565:	6a 10                	push   $0x10
80105567:	50                   	push   %eax
80105568:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010556b:	50                   	push   %eax
8010556c:	ff 75 f4             	push   -0xc(%ebp)
8010556f:	e8 9c ca ff ff       	call   80102010 <writei>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	83 f8 10             	cmp    $0x10,%eax
8010557a:	74 0d                	je     80105589 <sys_unlink+0x151>
    panic("unlink: writei");
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	68 b2 a9 10 80       	push   $0x8010a9b2
80105584:	e8 20 b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105589:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010558c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105590:	66 83 f8 01          	cmp    $0x1,%ax
80105594:	75 21                	jne    801055b7 <sys_unlink+0x17f>
    dp->nlink--;
80105596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105599:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010559d:	83 e8 01             	sub    $0x1,%eax
801055a0:	89 c2                	mov    %eax,%edx
801055a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a5:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801055a9:	83 ec 0c             	sub    $0xc,%esp
801055ac:	ff 75 f4             	push   -0xc(%ebp)
801055af:	e8 3e c2 ff ff       	call   801017f2 <iupdate>
801055b4:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801055b7:	83 ec 0c             	sub    $0xc,%esp
801055ba:	ff 75 f4             	push   -0xc(%ebp)
801055bd:	e8 3e c6 ff ff       	call   80101c00 <iunlockput>
801055c2:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801055c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055c8:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055cc:	83 e8 01             	sub    $0x1,%eax
801055cf:	89 c2                	mov    %eax,%edx
801055d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d4:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	ff 75 f0             	push   -0x10(%ebp)
801055de:	e8 0f c2 ff ff       	call   801017f2 <iupdate>
801055e3:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801055e6:	83 ec 0c             	sub    $0xc,%esp
801055e9:	ff 75 f0             	push   -0x10(%ebp)
801055ec:	e8 0f c6 ff ff       	call   80101c00 <iunlockput>
801055f1:	83 c4 10             	add    $0x10,%esp

  end_op();
801055f4:	e8 e1 da ff ff       	call   801030da <end_op>

  return 0;
801055f9:	b8 00 00 00 00       	mov    $0x0,%eax
801055fe:	eb 1c                	jmp    8010561c <sys_unlink+0x1e4>
    goto bad;
80105600:	90                   	nop
80105601:	eb 01                	jmp    80105604 <sys_unlink+0x1cc>
    goto bad;
80105603:	90                   	nop

bad:
  iunlockput(dp);
80105604:	83 ec 0c             	sub    $0xc,%esp
80105607:	ff 75 f4             	push   -0xc(%ebp)
8010560a:	e8 f1 c5 ff ff       	call   80101c00 <iunlockput>
8010560f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105612:	e8 c3 da ff ff       	call   801030da <end_op>
  return -1;
80105617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561c:	c9                   	leave  
8010561d:	c3                   	ret    

8010561e <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010561e:	55                   	push   %ebp
8010561f:	89 e5                	mov    %esp,%ebp
80105621:	83 ec 38             	sub    $0x38,%esp
80105624:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105627:	8b 55 10             	mov    0x10(%ebp),%edx
8010562a:	8b 45 14             	mov    0x14(%ebp),%eax
8010562d:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105631:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105635:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105639:	83 ec 08             	sub    $0x8,%esp
8010563c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010563f:	50                   	push   %eax
80105640:	ff 75 08             	push   0x8(%ebp)
80105643:	e8 d6 ce ff ff       	call   8010251e <nameiparent>
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010564e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105652:	75 0a                	jne    8010565e <create+0x40>
    return 0;
80105654:	b8 00 00 00 00       	mov    $0x0,%eax
80105659:	e9 90 01 00 00       	jmp    801057ee <create+0x1d0>
  ilock(dp);
8010565e:	83 ec 0c             	sub    $0xc,%esp
80105661:	ff 75 f4             	push   -0xc(%ebp)
80105664:	e8 66 c3 ff ff       	call   801019cf <ilock>
80105669:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010566c:	83 ec 04             	sub    $0x4,%esp
8010566f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105672:	50                   	push   %eax
80105673:	8d 45 de             	lea    -0x22(%ebp),%eax
80105676:	50                   	push   %eax
80105677:	ff 75 f4             	push   -0xc(%ebp)
8010567a:	e8 32 cb ff ff       	call   801021b1 <dirlookup>
8010567f:	83 c4 10             	add    $0x10,%esp
80105682:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105685:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105689:	74 50                	je     801056db <create+0xbd>
    iunlockput(dp);
8010568b:	83 ec 0c             	sub    $0xc,%esp
8010568e:	ff 75 f4             	push   -0xc(%ebp)
80105691:	e8 6a c5 ff ff       	call   80101c00 <iunlockput>
80105696:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	ff 75 f0             	push   -0x10(%ebp)
8010569f:	e8 2b c3 ff ff       	call   801019cf <ilock>
801056a4:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801056a7:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801056ac:	75 15                	jne    801056c3 <create+0xa5>
801056ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b1:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801056b5:	66 83 f8 02          	cmp    $0x2,%ax
801056b9:	75 08                	jne    801056c3 <create+0xa5>
      return ip;
801056bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056be:	e9 2b 01 00 00       	jmp    801057ee <create+0x1d0>
    iunlockput(ip);
801056c3:	83 ec 0c             	sub    $0xc,%esp
801056c6:	ff 75 f0             	push   -0x10(%ebp)
801056c9:	e8 32 c5 ff ff       	call   80101c00 <iunlockput>
801056ce:	83 c4 10             	add    $0x10,%esp
    return 0;
801056d1:	b8 00 00 00 00       	mov    $0x0,%eax
801056d6:	e9 13 01 00 00       	jmp    801057ee <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801056db:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801056df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e2:	8b 00                	mov    (%eax),%eax
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	52                   	push   %edx
801056e8:	50                   	push   %eax
801056e9:	e8 2d c0 ff ff       	call   8010171b <ialloc>
801056ee:	83 c4 10             	add    $0x10,%esp
801056f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056f8:	75 0d                	jne    80105707 <create+0xe9>
    panic("create: ialloc");
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	68 c1 a9 10 80       	push   $0x8010a9c1
80105702:	e8 a2 ae ff ff       	call   801005a9 <panic>

  ilock(ip);
80105707:	83 ec 0c             	sub    $0xc,%esp
8010570a:	ff 75 f0             	push   -0x10(%ebp)
8010570d:	e8 bd c2 ff ff       	call   801019cf <ilock>
80105712:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105715:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105718:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010571c:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105720:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105723:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105727:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
8010572b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572e:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105734:	83 ec 0c             	sub    $0xc,%esp
80105737:	ff 75 f0             	push   -0x10(%ebp)
8010573a:	e8 b3 c0 ff ff       	call   801017f2 <iupdate>
8010573f:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105742:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105747:	75 6a                	jne    801057b3 <create+0x195>
    dp->nlink++;  // for ".."
80105749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105750:	83 c0 01             	add    $0x1,%eax
80105753:	89 c2                	mov    %eax,%edx
80105755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105758:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	ff 75 f4             	push   -0xc(%ebp)
80105762:	e8 8b c0 ff ff       	call   801017f2 <iupdate>
80105767:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010576a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576d:	8b 40 04             	mov    0x4(%eax),%eax
80105770:	83 ec 04             	sub    $0x4,%esp
80105773:	50                   	push   %eax
80105774:	68 9b a9 10 80       	push   $0x8010a99b
80105779:	ff 75 f0             	push   -0x10(%ebp)
8010577c:	e8 ea ca ff ff       	call   8010226b <dirlink>
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	85 c0                	test   %eax,%eax
80105786:	78 1e                	js     801057a6 <create+0x188>
80105788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010578b:	8b 40 04             	mov    0x4(%eax),%eax
8010578e:	83 ec 04             	sub    $0x4,%esp
80105791:	50                   	push   %eax
80105792:	68 9d a9 10 80       	push   $0x8010a99d
80105797:	ff 75 f0             	push   -0x10(%ebp)
8010579a:	e8 cc ca ff ff       	call   8010226b <dirlink>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	79 0d                	jns    801057b3 <create+0x195>
      panic("create dots");
801057a6:	83 ec 0c             	sub    $0xc,%esp
801057a9:	68 d0 a9 10 80       	push   $0x8010a9d0
801057ae:	e8 f6 ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801057b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b6:	8b 40 04             	mov    0x4(%eax),%eax
801057b9:	83 ec 04             	sub    $0x4,%esp
801057bc:	50                   	push   %eax
801057bd:	8d 45 de             	lea    -0x22(%ebp),%eax
801057c0:	50                   	push   %eax
801057c1:	ff 75 f4             	push   -0xc(%ebp)
801057c4:	e8 a2 ca ff ff       	call   8010226b <dirlink>
801057c9:	83 c4 10             	add    $0x10,%esp
801057cc:	85 c0                	test   %eax,%eax
801057ce:	79 0d                	jns    801057dd <create+0x1bf>
    panic("create: dirlink");
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	68 dc a9 10 80       	push   $0x8010a9dc
801057d8:	e8 cc ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801057dd:	83 ec 0c             	sub    $0xc,%esp
801057e0:	ff 75 f4             	push   -0xc(%ebp)
801057e3:	e8 18 c4 ff ff       	call   80101c00 <iunlockput>
801057e8:	83 c4 10             	add    $0x10,%esp

  return ip;
801057eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    

801057f0 <sys_open>:

int
sys_open(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057f6:	83 ec 08             	sub    $0x8,%esp
801057f9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801057fc:	50                   	push   %eax
801057fd:	6a 00                	push   $0x0
801057ff:	e8 ea f6 ff ff       	call   80104eee <argstr>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	85 c0                	test   %eax,%eax
80105809:	78 15                	js     80105820 <sys_open+0x30>
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105811:	50                   	push   %eax
80105812:	6a 01                	push   $0x1
80105814:	e8 4f f6 ff ff       	call   80104e68 <argint>
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	85 c0                	test   %eax,%eax
8010581e:	79 0a                	jns    8010582a <sys_open+0x3a>
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105825:	e9 61 01 00 00       	jmp    8010598b <sys_open+0x19b>

  begin_op();
8010582a:	e8 1f d8 ff ff       	call   8010304e <begin_op>

  if(omode & O_CREATE){
8010582f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105832:	25 00 02 00 00       	and    $0x200,%eax
80105837:	85 c0                	test   %eax,%eax
80105839:	74 2a                	je     80105865 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010583b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010583e:	6a 00                	push   $0x0
80105840:	6a 00                	push   $0x0
80105842:	6a 02                	push   $0x2
80105844:	50                   	push   %eax
80105845:	e8 d4 fd ff ff       	call   8010561e <create>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105854:	75 75                	jne    801058cb <sys_open+0xdb>
      end_op();
80105856:	e8 7f d8 ff ff       	call   801030da <end_op>
      return -1;
8010585b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105860:	e9 26 01 00 00       	jmp    8010598b <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105865:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	50                   	push   %eax
8010586c:	e8 91 cc ff ff       	call   80102502 <namei>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010587b:	75 0f                	jne    8010588c <sys_open+0x9c>
      end_op();
8010587d:	e8 58 d8 ff ff       	call   801030da <end_op>
      return -1;
80105882:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105887:	e9 ff 00 00 00       	jmp    8010598b <sys_open+0x19b>
    }
    ilock(ip);
8010588c:	83 ec 0c             	sub    $0xc,%esp
8010588f:	ff 75 f4             	push   -0xc(%ebp)
80105892:	e8 38 c1 ff ff       	call   801019cf <ilock>
80105897:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010589a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801058a1:	66 83 f8 01          	cmp    $0x1,%ax
801058a5:	75 24                	jne    801058cb <sys_open+0xdb>
801058a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058aa:	85 c0                	test   %eax,%eax
801058ac:	74 1d                	je     801058cb <sys_open+0xdb>
      iunlockput(ip);
801058ae:	83 ec 0c             	sub    $0xc,%esp
801058b1:	ff 75 f4             	push   -0xc(%ebp)
801058b4:	e8 47 c3 ff ff       	call   80101c00 <iunlockput>
801058b9:	83 c4 10             	add    $0x10,%esp
      end_op();
801058bc:	e8 19 d8 ff ff       	call   801030da <end_op>
      return -1;
801058c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c6:	e9 c0 00 00 00       	jmp    8010598b <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058cb:	e8 f2 b6 ff ff       	call   80100fc2 <filealloc>
801058d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058d7:	74 17                	je     801058f0 <sys_open+0x100>
801058d9:	83 ec 0c             	sub    $0xc,%esp
801058dc:	ff 75 f0             	push   -0x10(%ebp)
801058df:	e8 33 f7 ff ff       	call   80105017 <fdalloc>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801058ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801058ee:	79 2e                	jns    8010591e <sys_open+0x12e>
    if(f)
801058f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058f4:	74 0e                	je     80105904 <sys_open+0x114>
      fileclose(f);
801058f6:	83 ec 0c             	sub    $0xc,%esp
801058f9:	ff 75 f0             	push   -0x10(%ebp)
801058fc:	e8 7f b7 ff ff       	call   80101080 <fileclose>
80105901:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105904:	83 ec 0c             	sub    $0xc,%esp
80105907:	ff 75 f4             	push   -0xc(%ebp)
8010590a:	e8 f1 c2 ff ff       	call   80101c00 <iunlockput>
8010590f:	83 c4 10             	add    $0x10,%esp
    end_op();
80105912:	e8 c3 d7 ff ff       	call   801030da <end_op>
    return -1;
80105917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591c:	eb 6d                	jmp    8010598b <sys_open+0x19b>
  }
  iunlock(ip);
8010591e:	83 ec 0c             	sub    $0xc,%esp
80105921:	ff 75 f4             	push   -0xc(%ebp)
80105924:	e8 b9 c1 ff ff       	call   80101ae2 <iunlock>
80105929:	83 c4 10             	add    $0x10,%esp
  end_op();
8010592c:	e8 a9 d7 ff ff       	call   801030da <end_op>

  f->type = FD_INODE;
80105931:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105934:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010593a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010593d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105940:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105946:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010594d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105950:	83 e0 01             	and    $0x1,%eax
80105953:	85 c0                	test   %eax,%eax
80105955:	0f 94 c0             	sete   %al
80105958:	89 c2                	mov    %eax,%edx
8010595a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105963:	83 e0 01             	and    $0x1,%eax
80105966:	85 c0                	test   %eax,%eax
80105968:	75 0a                	jne    80105974 <sys_open+0x184>
8010596a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010596d:	83 e0 02             	and    $0x2,%eax
80105970:	85 c0                	test   %eax,%eax
80105972:	74 07                	je     8010597b <sys_open+0x18b>
80105974:	b8 01 00 00 00       	mov    $0x1,%eax
80105979:	eb 05                	jmp    80105980 <sys_open+0x190>
8010597b:	b8 00 00 00 00       	mov    $0x0,%eax
80105980:	89 c2                	mov    %eax,%edx
80105982:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105985:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105988:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010598b:	c9                   	leave  
8010598c:	c3                   	ret    

8010598d <sys_mkdir>:

int
sys_mkdir(void)
{
8010598d:	55                   	push   %ebp
8010598e:	89 e5                	mov    %esp,%ebp
80105990:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105993:	e8 b6 d6 ff ff       	call   8010304e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105998:	83 ec 08             	sub    $0x8,%esp
8010599b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010599e:	50                   	push   %eax
8010599f:	6a 00                	push   $0x0
801059a1:	e8 48 f5 ff ff       	call   80104eee <argstr>
801059a6:	83 c4 10             	add    $0x10,%esp
801059a9:	85 c0                	test   %eax,%eax
801059ab:	78 1b                	js     801059c8 <sys_mkdir+0x3b>
801059ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b0:	6a 00                	push   $0x0
801059b2:	6a 00                	push   $0x0
801059b4:	6a 01                	push   $0x1
801059b6:	50                   	push   %eax
801059b7:	e8 62 fc ff ff       	call   8010561e <create>
801059bc:	83 c4 10             	add    $0x10,%esp
801059bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059c6:	75 0c                	jne    801059d4 <sys_mkdir+0x47>
    end_op();
801059c8:	e8 0d d7 ff ff       	call   801030da <end_op>
    return -1;
801059cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d2:	eb 18                	jmp    801059ec <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801059d4:	83 ec 0c             	sub    $0xc,%esp
801059d7:	ff 75 f4             	push   -0xc(%ebp)
801059da:	e8 21 c2 ff ff       	call   80101c00 <iunlockput>
801059df:	83 c4 10             	add    $0x10,%esp
  end_op();
801059e2:	e8 f3 d6 ff ff       	call   801030da <end_op>
  return 0;
801059e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059ec:	c9                   	leave  
801059ed:	c3                   	ret    

801059ee <sys_mknod>:

int
sys_mknod(void)
{
801059ee:	55                   	push   %ebp
801059ef:	89 e5                	mov    %esp,%ebp
801059f1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059f4:	e8 55 d6 ff ff       	call   8010304e <begin_op>
  if((argstr(0, &path)) < 0 ||
801059f9:	83 ec 08             	sub    $0x8,%esp
801059fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ff:	50                   	push   %eax
80105a00:	6a 00                	push   $0x0
80105a02:	e8 e7 f4 ff ff       	call   80104eee <argstr>
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	78 4f                	js     80105a5d <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105a0e:	83 ec 08             	sub    $0x8,%esp
80105a11:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a14:	50                   	push   %eax
80105a15:	6a 01                	push   $0x1
80105a17:	e8 4c f4 ff ff       	call   80104e68 <argint>
80105a1c:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	78 3a                	js     80105a5d <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105a23:	83 ec 08             	sub    $0x8,%esp
80105a26:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 02                	push   $0x2
80105a2c:	e8 37 f4 ff ff       	call   80104e68 <argint>
80105a31:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105a34:	85 c0                	test   %eax,%eax
80105a36:	78 25                	js     80105a5d <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a3b:	0f bf c8             	movswl %ax,%ecx
80105a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a41:	0f bf d0             	movswl %ax,%edx
80105a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a47:	51                   	push   %ecx
80105a48:	52                   	push   %edx
80105a49:	6a 03                	push   $0x3
80105a4b:	50                   	push   %eax
80105a4c:	e8 cd fb ff ff       	call   8010561e <create>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a5b:	75 0c                	jne    80105a69 <sys_mknod+0x7b>
    end_op();
80105a5d:	e8 78 d6 ff ff       	call   801030da <end_op>
    return -1;
80105a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a67:	eb 18                	jmp    80105a81 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105a69:	83 ec 0c             	sub    $0xc,%esp
80105a6c:	ff 75 f4             	push   -0xc(%ebp)
80105a6f:	e8 8c c1 ff ff       	call   80101c00 <iunlockput>
80105a74:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a77:	e8 5e d6 ff ff       	call   801030da <end_op>
  return 0;
80105a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a81:	c9                   	leave  
80105a82:	c3                   	ret    

80105a83 <sys_chdir>:

int
sys_chdir(void)
{
80105a83:	55                   	push   %ebp
80105a84:	89 e5                	mov    %esp,%ebp
80105a86:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a89:	e8 b4 df ff ff       	call   80103a42 <myproc>
80105a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105a91:	e8 b8 d5 ff ff       	call   8010304e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a96:	83 ec 08             	sub    $0x8,%esp
80105a99:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a9c:	50                   	push   %eax
80105a9d:	6a 00                	push   $0x0
80105a9f:	e8 4a f4 ff ff       	call   80104eee <argstr>
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	78 18                	js     80105ac3 <sys_chdir+0x40>
80105aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105aae:	83 ec 0c             	sub    $0xc,%esp
80105ab1:	50                   	push   %eax
80105ab2:	e8 4b ca ff ff       	call   80102502 <namei>
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ac1:	75 0c                	jne    80105acf <sys_chdir+0x4c>
    end_op();
80105ac3:	e8 12 d6 ff ff       	call   801030da <end_op>
    return -1;
80105ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acd:	eb 68                	jmp    80105b37 <sys_chdir+0xb4>
  }
  ilock(ip);
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	ff 75 f0             	push   -0x10(%ebp)
80105ad5:	e8 f5 be ff ff       	call   801019cf <ilock>
80105ada:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105add:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ae4:	66 83 f8 01          	cmp    $0x1,%ax
80105ae8:	74 1a                	je     80105b04 <sys_chdir+0x81>
    iunlockput(ip);
80105aea:	83 ec 0c             	sub    $0xc,%esp
80105aed:	ff 75 f0             	push   -0x10(%ebp)
80105af0:	e8 0b c1 ff ff       	call   80101c00 <iunlockput>
80105af5:	83 c4 10             	add    $0x10,%esp
    end_op();
80105af8:	e8 dd d5 ff ff       	call   801030da <end_op>
    return -1;
80105afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b02:	eb 33                	jmp    80105b37 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105b04:	83 ec 0c             	sub    $0xc,%esp
80105b07:	ff 75 f0             	push   -0x10(%ebp)
80105b0a:	e8 d3 bf ff ff       	call   80101ae2 <iunlock>
80105b0f:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b15:	8b 40 68             	mov    0x68(%eax),%eax
80105b18:	83 ec 0c             	sub    $0xc,%esp
80105b1b:	50                   	push   %eax
80105b1c:	e8 0f c0 ff ff       	call   80101b30 <iput>
80105b21:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b24:	e8 b1 d5 ff ff       	call   801030da <end_op>
  curproc->cwd = ip;
80105b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b2f:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b37:	c9                   	leave  
80105b38:	c3                   	ret    

80105b39 <sys_exec>:

int
sys_exec(void)
{
80105b39:	55                   	push   %ebp
80105b3a:	89 e5                	mov    %esp,%ebp
80105b3c:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b42:	83 ec 08             	sub    $0x8,%esp
80105b45:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b48:	50                   	push   %eax
80105b49:	6a 00                	push   $0x0
80105b4b:	e8 9e f3 ff ff       	call   80104eee <argstr>
80105b50:	83 c4 10             	add    $0x10,%esp
80105b53:	85 c0                	test   %eax,%eax
80105b55:	78 18                	js     80105b6f <sys_exec+0x36>
80105b57:	83 ec 08             	sub    $0x8,%esp
80105b5a:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105b60:	50                   	push   %eax
80105b61:	6a 01                	push   $0x1
80105b63:	e8 00 f3 ff ff       	call   80104e68 <argint>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	79 0a                	jns    80105b79 <sys_exec+0x40>
    return -1;
80105b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b74:	e9 c6 00 00 00       	jmp    80105c3f <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105b79:	83 ec 04             	sub    $0x4,%esp
80105b7c:	68 80 00 00 00       	push   $0x80
80105b81:	6a 00                	push   $0x0
80105b83:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105b89:	50                   	push   %eax
80105b8a:	e8 c9 ef ff ff       	call   80104b58 <memset>
80105b8f:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105b92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9c:	83 f8 1f             	cmp    $0x1f,%eax
80105b9f:	76 0a                	jbe    80105bab <sys_exec+0x72>
      return -1;
80105ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba6:	e9 94 00 00 00       	jmp    80105c3f <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bae:	c1 e0 02             	shl    $0x2,%eax
80105bb1:	89 c2                	mov    %eax,%edx
80105bb3:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105bb9:	01 c2                	add    %eax,%edx
80105bbb:	83 ec 08             	sub    $0x8,%esp
80105bbe:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bc4:	50                   	push   %eax
80105bc5:	52                   	push   %edx
80105bc6:	e8 17 f2 ff ff       	call   80104de2 <fetchint>
80105bcb:	83 c4 10             	add    $0x10,%esp
80105bce:	85 c0                	test   %eax,%eax
80105bd0:	79 07                	jns    80105bd9 <sys_exec+0xa0>
      return -1;
80105bd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd7:	eb 66                	jmp    80105c3f <sys_exec+0x106>
    if(uarg == 0){
80105bd9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	75 27                	jne    80105c0a <sys_exec+0xd1>
      argv[i] = 0;
80105be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be6:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105bed:	00 00 00 00 
      break;
80105bf1:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf5:	83 ec 08             	sub    $0x8,%esp
80105bf8:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105bfe:	52                   	push   %edx
80105bff:	50                   	push   %eax
80105c00:	e8 7b af ff ff       	call   80100b80 <exec>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	eb 35                	jmp    80105c3f <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105c0a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c13:	c1 e0 02             	shl    $0x2,%eax
80105c16:	01 c2                	add    %eax,%edx
80105c18:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c1e:	83 ec 08             	sub    $0x8,%esp
80105c21:	52                   	push   %edx
80105c22:	50                   	push   %eax
80105c23:	e8 e8 f1 ff ff       	call   80104e10 <fetchstr>
80105c28:	83 c4 10             	add    $0x10,%esp
80105c2b:	85 c0                	test   %eax,%eax
80105c2d:	79 07                	jns    80105c36 <sys_exec+0xfd>
      return -1;
80105c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c34:	eb 09                	jmp    80105c3f <sys_exec+0x106>
  for(i=0;; i++){
80105c36:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c3a:	e9 5a ff ff ff       	jmp    80105b99 <sys_exec+0x60>
}
80105c3f:	c9                   	leave  
80105c40:	c3                   	ret    

80105c41 <sys_pipe>:

int
sys_pipe(void)
{
80105c41:	55                   	push   %ebp
80105c42:	89 e5                	mov    %esp,%ebp
80105c44:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c47:	83 ec 04             	sub    $0x4,%esp
80105c4a:	6a 08                	push   $0x8
80105c4c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c4f:	50                   	push   %eax
80105c50:	6a 00                	push   $0x0
80105c52:	e8 3e f2 ff ff       	call   80104e95 <argptr>
80105c57:	83 c4 10             	add    $0x10,%esp
80105c5a:	85 c0                	test   %eax,%eax
80105c5c:	79 0a                	jns    80105c68 <sys_pipe+0x27>
    return -1;
80105c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c63:	e9 ae 00 00 00       	jmp    80105d16 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c72:	50                   	push   %eax
80105c73:	e8 07 d9 ff ff       	call   8010357f <pipealloc>
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	85 c0                	test   %eax,%eax
80105c7d:	79 0a                	jns    80105c89 <sys_pipe+0x48>
    return -1;
80105c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c84:	e9 8d 00 00 00       	jmp    80105d16 <sys_pipe+0xd5>
  fd0 = -1;
80105c89:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c93:	83 ec 0c             	sub    $0xc,%esp
80105c96:	50                   	push   %eax
80105c97:	e8 7b f3 ff ff       	call   80105017 <fdalloc>
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ca6:	78 18                	js     80105cc0 <sys_pipe+0x7f>
80105ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cab:	83 ec 0c             	sub    $0xc,%esp
80105cae:	50                   	push   %eax
80105caf:	e8 63 f3 ff ff       	call   80105017 <fdalloc>
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cbe:	79 3e                	jns    80105cfe <sys_pipe+0xbd>
    if(fd0 >= 0)
80105cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cc4:	78 13                	js     80105cd9 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105cc6:	e8 77 dd ff ff       	call   80103a42 <myproc>
80105ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cce:	83 c2 08             	add    $0x8,%edx
80105cd1:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cd8:	00 
    fileclose(rf);
80105cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	50                   	push   %eax
80105ce0:	e8 9b b3 ff ff       	call   80101080 <fileclose>
80105ce5:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ceb:	83 ec 0c             	sub    $0xc,%esp
80105cee:	50                   	push   %eax
80105cef:	e8 8c b3 ff ff       	call   80101080 <fileclose>
80105cf4:	83 c4 10             	add    $0x10,%esp
    return -1;
80105cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfc:	eb 18                	jmp    80105d16 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d04:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d09:	8d 50 04             	lea    0x4(%eax),%edx
80105d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0f:	89 02                	mov    %eax,(%edx)
  return 0;
80105d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d16:	c9                   	leave  
80105d17:	c3                   	ret    

80105d18 <sys_fork>:
extern int ppid[];
extern int pspage[];

int
sys_fork(void)
{
80105d18:	55                   	push   %ebp
80105d19:	89 e5                	mov    %esp,%ebp
80105d1b:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105d1e:	e8 4a e0 ff ff       	call   80103d6d <fork>
}
80105d23:	c9                   	leave  
80105d24:	c3                   	ret    

80105d25 <sys_exit>:

int
sys_exit(void)
{
80105d25:	55                   	push   %ebp
80105d26:	89 e5                	mov    %esp,%ebp
80105d28:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d2b:	e8 1e e2 ff ff       	call   80103f4e <exit>
  return 0;  // not reached
80105d30:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    

80105d37 <sys_wait>:

int
sys_wait(void)
{
80105d37:	55                   	push   %ebp
80105d38:	89 e5                	mov    %esp,%ebp
80105d3a:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105d3d:	e8 2c e3 ff ff       	call   8010406e <wait>
}
80105d42:	c9                   	leave  
80105d43:	c3                   	ret    

80105d44 <sys_kill>:

int
sys_kill(void)
{
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d4a:	83 ec 08             	sub    $0x8,%esp
80105d4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d50:	50                   	push   %eax
80105d51:	6a 00                	push   $0x0
80105d53:	e8 10 f1 ff ff       	call   80104e68 <argint>
80105d58:	83 c4 10             	add    $0x10,%esp
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	79 07                	jns    80105d66 <sys_kill+0x22>
    return -1;
80105d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d64:	eb 0f                	jmp    80105d75 <sys_kill+0x31>
  return kill(pid);
80105d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d69:	83 ec 0c             	sub    $0xc,%esp
80105d6c:	50                   	push   %eax
80105d6d:	e8 2b e7 ff ff       	call   8010449d <kill>
80105d72:	83 c4 10             	add    $0x10,%esp
}
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    

80105d77 <sys_getpid>:

int
sys_getpid(void)
{
80105d77:	55                   	push   %ebp
80105d78:	89 e5                	mov    %esp,%ebp
80105d7a:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d7d:	e8 c0 dc ff ff       	call   80103a42 <myproc>
80105d82:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    

80105d87 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d87:	55                   	push   %ebp
80105d88:	89 e5                	mov    %esp,%ebp
80105d8a:	83 ec 28             	sub    $0x28,%esp
  int n;
  if (argint(0, &n) < 0)
80105d8d:	83 ec 08             	sub    $0x8,%esp
80105d90:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d93:	50                   	push   %eax
80105d94:	6a 00                	push   $0x0
80105d96:	e8 cd f0 ff ff       	call   80104e68 <argint>
80105d9b:	83 c4 10             	add    $0x10,%esp
80105d9e:	85 c0                	test   %eax,%eax
80105da0:	79 0a                	jns    80105dac <sys_sbrk+0x25>
    return -1;
80105da2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da7:	e9 5a 01 00 00       	jmp    80105f06 <sys_sbrk+0x17f>

  struct proc *p = myproc();
80105dac:	e8 91 dc ff ff       	call   80103a42 <myproc>
80105db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int addr = p->sz;
80105db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db7:	8b 00                	mov    (%eax),%eax
80105db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint oldsz = p->sz;
80105dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbf:	8b 00                	mov    (%eax),%eax
80105dc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint newsz = oldsz + n;
80105dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dc7:	89 c2                	mov    %eax,%edx
80105dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105dcc:	01 d0                	add    %edx,%eax
80105dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  // 오버플로 / 언더플로 보호
  if (n < 0 && newsz > oldsz) return -1;
80105dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dd4:	85 c0                	test   %eax,%eax
80105dd6:	79 12                	jns    80105dea <sys_sbrk+0x63>
80105dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ddb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80105dde:	76 0a                	jbe    80105dea <sys_sbrk+0x63>
80105de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de5:	e9 1c 01 00 00       	jmp    80105f06 <sys_sbrk+0x17f>
  if (n > 0 && newsz < oldsz) return -1;
80105dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ded:	85 c0                	test   %eax,%eax
80105def:	7e 12                	jle    80105e03 <sys_sbrk+0x7c>
80105df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105df4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80105df7:	73 0a                	jae    80105e03 <sys_sbrk+0x7c>
80105df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfe:	e9 03 01 00 00       	jmp    80105f06 <sys_sbrk+0x17f>

  // KERNBASE 침범 방지
  if (newsz >= KERNBASE) {
80105e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e06:	85 c0                	test   %eax,%eax
80105e08:	79 1a                	jns    80105e24 <sys_sbrk+0x9d>
    cprintf("Allocating pages failed: KERNBASE overflow\n");
80105e0a:	83 ec 0c             	sub    $0xc,%esp
80105e0d:	68 ec a9 10 80       	push   $0x8010a9ec
80105e12:	e8 dd a5 ff ff       	call   801003f4 <cprintf>
80105e17:	83 c4 10             	add    $0x10,%esp
    return -1;
80105e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1f:	e9 e2 00 00 00       	jmp    80105f06 <sys_sbrk+0x17f>
  }

  // (선택적) 스택과 겹치지 않게 pspage[] 고려
  int i;
  for (i = 0; i < NPROC; i++) {
80105e24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105e2b:	eb 18                	jmp    80105e45 <sys_sbrk+0xbe>
    if (ppid[i] == p->pid)
80105e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e30:	8b 14 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%edx
80105e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3a:	8b 40 10             	mov    0x10(%eax),%eax
80105e3d:	39 c2                	cmp    %eax,%edx
80105e3f:	74 0c                	je     80105e4d <sys_sbrk+0xc6>
  for (i = 0; i < NPROC; i++) {
80105e41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105e45:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80105e49:	7e e2                	jle    80105e2d <sys_sbrk+0xa6>
80105e4b:	eb 01                	jmp    80105e4e <sys_sbrk+0xc7>
      break;
80105e4d:	90                   	nop
  }
  if (n > 0 && newsz >= KERNBASE - (pspage[i] + 2) * PGSIZE) {
80105e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e51:	85 c0                	test   %eax,%eax
80105e53:	7e 35                	jle    80105e8a <sys_sbrk+0x103>
80105e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e58:	8b 04 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%eax
80105e5f:	83 c0 02             	add    $0x2,%eax
80105e62:	c1 e0 0c             	shl    $0xc,%eax
80105e65:	89 c2                	mov    %eax,%edx
80105e67:	b8 00 00 00 80       	mov    $0x80000000,%eax
80105e6c:	29 d0                	sub    %edx,%eax
80105e6e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80105e71:	72 17                	jb     80105e8a <sys_sbrk+0x103>
    cprintf("Allocating pages failed: stack collision\n");
80105e73:	83 ec 0c             	sub    $0xc,%esp
80105e76:	68 18 aa 10 80       	push   $0x8010aa18
80105e7b:	e8 74 a5 ff ff       	call   801003f4 <cprintf>
80105e80:	83 c4 10             	add    $0x10,%esp
    return -1;
80105e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e88:	eb 7c                	jmp    80105f06 <sys_sbrk+0x17f>
  }

  // sbrk(0)일 경우 주소만 반환
  if (n == 0)
80105e8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e8d:	85 c0                	test   %eax,%eax
80105e8f:	75 05                	jne    80105e96 <sys_sbrk+0x10f>
    return addr;
80105e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e94:	eb 70                	jmp    80105f06 <sys_sbrk+0x17f>

  // 확장
  if (n > 0) {
80105e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	7e 18                	jle    80105eb5 <sys_sbrk+0x12e>
    p->oldsz = p->sz;
80105e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea0:	8b 10                	mov    (%eax),%edx
80105ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea5:	89 50 7c             	mov    %edx,0x7c(%eax)
    p->sz = newsz;
80105ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105eae:	89 10                	mov    %edx,(%eax)
    return addr;
80105eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105eb3:	eb 51                	jmp    80105f06 <sys_sbrk+0x17f>
  }

  // 축소
  if ((newsz = deallocuvm(p->pgdir, oldsz, newsz)) == 0) {
80105eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb8:	8b 40 04             	mov    0x4(%eax),%eax
80105ebb:	83 ec 04             	sub    $0x4,%esp
80105ebe:	ff 75 e4             	push   -0x1c(%ebp)
80105ec1:	ff 75 e8             	push   -0x18(%ebp)
80105ec4:	50                   	push   %eax
80105ec5:	e8 67 1d 00 00       	call   80107c31 <deallocuvm>
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105ed0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80105ed4:	75 17                	jne    80105eed <sys_sbrk+0x166>
    cprintf("Deallocating pages failed!\n");
80105ed6:	83 ec 0c             	sub    $0xc,%esp
80105ed9:	68 42 aa 10 80       	push   $0x8010aa42
80105ede:	e8 11 a5 ff ff       	call   801003f4 <cprintf>
80105ee3:	83 c4 10             	add    $0x10,%esp
    return -1;
80105ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eeb:	eb 19                	jmp    80105f06 <sys_sbrk+0x17f>
  }

  p->sz = newsz;
80105eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105ef3:	89 10                	mov    %edx,(%eax)
  switchuvm(p);  // context 갱신
80105ef5:	83 ec 0c             	sub    $0xc,%esp
80105ef8:	ff 75 f0             	push   -0x10(%ebp)
80105efb:	e8 50 19 00 00       	call   80107850 <switchuvm>
80105f00:	83 c4 10             	add    $0x10,%esp
  return addr;
80105f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105f06:	c9                   	leave  
80105f07:	c3                   	ret    

80105f08 <sys_sleep>:

int
sys_sleep(void)
{
80105f08:	55                   	push   %ebp
80105f09:	89 e5                	mov    %esp,%ebp
80105f0b:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f0e:	83 ec 08             	sub    $0x8,%esp
80105f11:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f14:	50                   	push   %eax
80105f15:	6a 00                	push   $0x0
80105f17:	e8 4c ef ff ff       	call   80104e68 <argint>
80105f1c:	83 c4 10             	add    $0x10,%esp
80105f1f:	85 c0                	test   %eax,%eax
80105f21:	79 07                	jns    80105f2a <sys_sleep+0x22>
    return -1;
80105f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f28:	eb 76                	jmp    80105fa0 <sys_sleep+0x98>
  acquire(&tickslock);
80105f2a:	83 ec 0c             	sub    $0xc,%esp
80105f2d:	68 60 6c 19 80       	push   $0x80196c60
80105f32:	e8 ab e9 ff ff       	call   801048e2 <acquire>
80105f37:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105f3a:	a1 94 6c 19 80       	mov    0x80196c94,%eax
80105f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105f42:	eb 38                	jmp    80105f7c <sys_sleep+0x74>
    if(myproc()->killed){
80105f44:	e8 f9 da ff ff       	call   80103a42 <myproc>
80105f49:	8b 40 24             	mov    0x24(%eax),%eax
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	74 17                	je     80105f67 <sys_sleep+0x5f>
      release(&tickslock);
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	68 60 6c 19 80       	push   $0x80196c60
80105f58:	e8 f3 e9 ff ff       	call   80104950 <release>
80105f5d:	83 c4 10             	add    $0x10,%esp
      return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f65:	eb 39                	jmp    80105fa0 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105f67:	83 ec 08             	sub    $0x8,%esp
80105f6a:	68 60 6c 19 80       	push   $0x80196c60
80105f6f:	68 94 6c 19 80       	push   $0x80196c94
80105f74:	e8 06 e4 ff ff       	call   8010437f <sleep>
80105f79:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105f7c:	a1 94 6c 19 80       	mov    0x80196c94,%eax
80105f81:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105f84:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f87:	39 d0                	cmp    %edx,%eax
80105f89:	72 b9                	jb     80105f44 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105f8b:	83 ec 0c             	sub    $0xc,%esp
80105f8e:	68 60 6c 19 80       	push   $0x80196c60
80105f93:	e8 b8 e9 ff ff       	call   80104950 <release>
80105f98:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fa0:	c9                   	leave  
80105fa1:	c3                   	ret    

80105fa2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105fa2:	55                   	push   %ebp
80105fa3:	89 e5                	mov    %esp,%ebp
80105fa5:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	68 60 6c 19 80       	push   $0x80196c60
80105fb0:	e8 2d e9 ff ff       	call   801048e2 <acquire>
80105fb5:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105fb8:	a1 94 6c 19 80       	mov    0x80196c94,%eax
80105fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	68 60 6c 19 80       	push   $0x80196c60
80105fc8:	e8 83 e9 ff ff       	call   80104950 <release>
80105fcd:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105fd3:	c9                   	leave  
80105fd4:	c3                   	ret    

80105fd5 <sys_printpt>:

int sys_printpt(void)
{
80105fd5:	55                   	push   %ebp
80105fd6:	89 e5                	mov    %esp,%ebp
80105fd8:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if(argint(0, &pid) < 0)
80105fdb:	83 ec 08             	sub    $0x8,%esp
80105fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fe1:	50                   	push   %eax
80105fe2:	6a 00                	push   $0x0
80105fe4:	e8 7f ee ff ff       	call   80104e68 <argint>
80105fe9:	83 c4 10             	add    $0x10,%esp
80105fec:	85 c0                	test   %eax,%eax
80105fee:	79 07                	jns    80105ff7 <sys_printpt+0x22>
    return -1;
80105ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff5:	eb 0f                	jmp    80106006 <sys_printpt+0x31>
  return printpt(pid);
80105ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	50                   	push   %eax
80105ffe:	e8 18 e6 ff ff       	call   8010461b <printpt>
80106003:	83 c4 10             	add    $0x10,%esp
80106006:	c9                   	leave  
80106007:	c3                   	ret    

80106008 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106008:	1e                   	push   %ds
  pushl %es
80106009:	06                   	push   %es
  pushl %fs
8010600a:	0f a0                	push   %fs
  pushl %gs
8010600c:	0f a8                	push   %gs
  pushal
8010600e:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010600f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106013:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106015:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106017:	54                   	push   %esp
  call trap
80106018:	e8 d7 01 00 00       	call   801061f4 <trap>
  addl $4, %esp
8010601d:	83 c4 04             	add    $0x4,%esp

80106020 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106020:	61                   	popa   
  popl %gs
80106021:	0f a9                	pop    %gs
  popl %fs
80106023:	0f a1                	pop    %fs
  popl %es
80106025:	07                   	pop    %es
  popl %ds
80106026:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106027:	83 c4 08             	add    $0x8,%esp
  iret
8010602a:	cf                   	iret   

8010602b <lidt>:
{
8010602b:	55                   	push   %ebp
8010602c:	89 e5                	mov    %esp,%ebp
8010602e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106031:	8b 45 0c             	mov    0xc(%ebp),%eax
80106034:	83 e8 01             	sub    $0x1,%eax
80106037:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010603b:	8b 45 08             	mov    0x8(%ebp),%eax
8010603e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106042:	8b 45 08             	mov    0x8(%ebp),%eax
80106045:	c1 e8 10             	shr    $0x10,%eax
80106048:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010604c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010604f:	0f 01 18             	lidtl  (%eax)
}
80106052:	90                   	nop
80106053:	c9                   	leave  
80106054:	c3                   	ret    

80106055 <rcr2>:

static inline uint
rcr2(void)
{
80106055:	55                   	push   %ebp
80106056:	89 e5                	mov    %esp,%ebp
80106058:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010605b:	0f 20 d0             	mov    %cr2,%eax
8010605e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106064:	c9                   	leave  
80106065:	c3                   	ret    

80106066 <tvinit>:

extern int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
80106066:	55                   	push   %ebp
80106067:	89 e5                	mov    %esp,%ebp
80106069:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010606c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106073:	e9 c3 00 00 00       	jmp    8010613b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607b:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80106082:	89 c2                	mov    %eax,%edx
80106084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106087:	66 89 14 c5 60 64 19 	mov    %dx,-0x7fe69ba0(,%eax,8)
8010608e:	80 
8010608f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106092:	66 c7 04 c5 62 64 19 	movw   $0x8,-0x7fe69b9e(,%eax,8)
80106099:	80 08 00 
8010609c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609f:	0f b6 14 c5 64 64 19 	movzbl -0x7fe69b9c(,%eax,8),%edx
801060a6:	80 
801060a7:	83 e2 e0             	and    $0xffffffe0,%edx
801060aa:	88 14 c5 64 64 19 80 	mov    %dl,-0x7fe69b9c(,%eax,8)
801060b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b4:	0f b6 14 c5 64 64 19 	movzbl -0x7fe69b9c(,%eax,8),%edx
801060bb:	80 
801060bc:	83 e2 1f             	and    $0x1f,%edx
801060bf:	88 14 c5 64 64 19 80 	mov    %dl,-0x7fe69b9c(,%eax,8)
801060c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c9:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
801060d0:	80 
801060d1:	83 e2 f0             	and    $0xfffffff0,%edx
801060d4:	83 ca 0e             	or     $0xe,%edx
801060d7:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
801060de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e1:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
801060e8:	80 
801060e9:	83 e2 ef             	and    $0xffffffef,%edx
801060ec:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
801060f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f6:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
801060fd:	80 
801060fe:	83 e2 9f             	and    $0xffffff9f,%edx
80106101:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
80106108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010610b:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
80106112:	80 
80106113:	83 ca 80             	or     $0xffffff80,%edx
80106116:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
8010611d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106120:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80106127:	c1 e8 10             	shr    $0x10,%eax
8010612a:	89 c2                	mov    %eax,%edx
8010612c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612f:	66 89 14 c5 66 64 19 	mov    %dx,-0x7fe69b9a(,%eax,8)
80106136:	80 
  for(i = 0; i < 256; i++)
80106137:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010613b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106142:	0f 8e 30 ff ff ff    	jle    80106078 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106148:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
8010614d:	66 a3 60 66 19 80    	mov    %ax,0x80196660
80106153:	66 c7 05 62 66 19 80 	movw   $0x8,0x80196662
8010615a:	08 00 
8010615c:	0f b6 05 64 66 19 80 	movzbl 0x80196664,%eax
80106163:	83 e0 e0             	and    $0xffffffe0,%eax
80106166:	a2 64 66 19 80       	mov    %al,0x80196664
8010616b:	0f b6 05 64 66 19 80 	movzbl 0x80196664,%eax
80106172:	83 e0 1f             	and    $0x1f,%eax
80106175:	a2 64 66 19 80       	mov    %al,0x80196664
8010617a:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
80106181:	83 c8 0f             	or     $0xf,%eax
80106184:	a2 65 66 19 80       	mov    %al,0x80196665
80106189:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
80106190:	83 e0 ef             	and    $0xffffffef,%eax
80106193:	a2 65 66 19 80       	mov    %al,0x80196665
80106198:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
8010619f:	83 c8 60             	or     $0x60,%eax
801061a2:	a2 65 66 19 80       	mov    %al,0x80196665
801061a7:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
801061ae:	83 c8 80             	or     $0xffffff80,%eax
801061b1:	a2 65 66 19 80       	mov    %al,0x80196665
801061b6:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
801061bb:	c1 e8 10             	shr    $0x10,%eax
801061be:	66 a3 66 66 19 80    	mov    %ax,0x80196666

  initlock(&tickslock, "time");
801061c4:	83 ec 08             	sub    $0x8,%esp
801061c7:	68 60 aa 10 80       	push   $0x8010aa60
801061cc:	68 60 6c 19 80       	push   $0x80196c60
801061d1:	e8 ea e6 ff ff       	call   801048c0 <initlock>
801061d6:	83 c4 10             	add    $0x10,%esp
}
801061d9:	90                   	nop
801061da:	c9                   	leave  
801061db:	c3                   	ret    

801061dc <idtinit>:

void
idtinit(void)
{
801061dc:	55                   	push   %ebp
801061dd:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801061df:	68 00 08 00 00       	push   $0x800
801061e4:	68 60 64 19 80       	push   $0x80196460
801061e9:	e8 3d fe ff ff       	call   8010602b <lidt>
801061ee:	83 c4 08             	add    $0x8,%esp
}
801061f1:	90                   	nop
801061f2:	c9                   	leave  
801061f3:	c3                   	ret    

801061f4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	57                   	push   %edi
801061f8:	56                   	push   %esi
801061f9:	53                   	push   %ebx
801061fa:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801061fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106200:	8b 40 30             	mov    0x30(%eax),%eax
80106203:	83 f8 40             	cmp    $0x40,%eax
80106206:	75 3b                	jne    80106243 <trap+0x4f>
    if(myproc()->killed)
80106208:	e8 35 d8 ff ff       	call   80103a42 <myproc>
8010620d:	8b 40 24             	mov    0x24(%eax),%eax
80106210:	85 c0                	test   %eax,%eax
80106212:	74 05                	je     80106219 <trap+0x25>
      exit();
80106214:	e8 35 dd ff ff       	call   80103f4e <exit>
    myproc()->tf = tf;
80106219:	e8 24 d8 ff ff       	call   80103a42 <myproc>
8010621e:	8b 55 08             	mov    0x8(%ebp),%edx
80106221:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106224:	e8 fc ec ff ff       	call   80104f25 <syscall>
    if(myproc()->killed)
80106229:	e8 14 d8 ff ff       	call   80103a42 <myproc>
8010622e:	8b 40 24             	mov    0x24(%eax),%eax
80106231:	85 c0                	test   %eax,%eax
80106233:	0f 84 d0 03 00 00    	je     80106609 <trap+0x415>
      exit();
80106239:	e8 10 dd ff ff       	call   80103f4e <exit>
    return;
8010623e:	e9 c6 03 00 00       	jmp    80106609 <trap+0x415>
  }

  switch(tf->trapno){
80106243:	8b 45 08             	mov    0x8(%ebp),%eax
80106246:	8b 40 30             	mov    0x30(%eax),%eax
80106249:	83 e8 0e             	sub    $0xe,%eax
8010624c:	83 f8 31             	cmp    $0x31,%eax
8010624f:	0f 87 7c 02 00 00    	ja     801064d1 <trap+0x2dd>
80106255:	8b 04 85 08 ab 10 80 	mov    -0x7fef54f8(,%eax,4),%eax
8010625c:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010625e:	e8 4c d7 ff ff       	call   801039af <cpuid>
80106263:	85 c0                	test   %eax,%eax
80106265:	75 3d                	jne    801062a4 <trap+0xb0>
      acquire(&tickslock);
80106267:	83 ec 0c             	sub    $0xc,%esp
8010626a:	68 60 6c 19 80       	push   $0x80196c60
8010626f:	e8 6e e6 ff ff       	call   801048e2 <acquire>
80106274:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106277:	a1 94 6c 19 80       	mov    0x80196c94,%eax
8010627c:	83 c0 01             	add    $0x1,%eax
8010627f:	a3 94 6c 19 80       	mov    %eax,0x80196c94
      wakeup(&ticks);
80106284:	83 ec 0c             	sub    $0xc,%esp
80106287:	68 94 6c 19 80       	push   $0x80196c94
8010628c:	e8 d5 e1 ff ff       	call   80104466 <wakeup>
80106291:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106294:	83 ec 0c             	sub    $0xc,%esp
80106297:	68 60 6c 19 80       	push   $0x80196c60
8010629c:	e8 af e6 ff ff       	call   80104950 <release>
801062a1:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801062a4:	e8 85 c8 ff ff       	call   80102b2e <lapiceoi>
    break;
801062a9:	e9 db 02 00 00       	jmp    80106589 <trap+0x395>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801062ae:	e8 7b 41 00 00       	call   8010a42e <ideintr>
    lapiceoi();
801062b3:	e8 76 c8 ff ff       	call   80102b2e <lapiceoi>
    break;
801062b8:	e9 cc 02 00 00       	jmp    80106589 <trap+0x395>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801062bd:	e8 b1 c6 ff ff       	call   80102973 <kbdintr>
    lapiceoi();
801062c2:	e8 67 c8 ff ff       	call   80102b2e <lapiceoi>
    break;
801062c7:	e9 bd 02 00 00       	jmp    80106589 <trap+0x395>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801062cc:	e8 0e 05 00 00       	call   801067df <uartintr>
    lapiceoi();
801062d1:	e8 58 c8 ff ff       	call   80102b2e <lapiceoi>
    break;
801062d6:	e9 ae 02 00 00       	jmp    80106589 <trap+0x395>
  case T_IRQ0 + 0xB:
    i8254_intr();
801062db:	e8 01 2e 00 00       	call   801090e1 <i8254_intr>
    lapiceoi();
801062e0:	e8 49 c8 ff ff       	call   80102b2e <lapiceoi>
    break;
801062e5:	e9 9f 02 00 00       	jmp    80106589 <trap+0x395>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062ea:	8b 45 08             	mov    0x8(%ebp),%eax
801062ed:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801062f0:	8b 45 08             	mov    0x8(%ebp),%eax
801062f3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062f7:	0f b7 d8             	movzwl %ax,%ebx
801062fa:	e8 b0 d6 ff ff       	call   801039af <cpuid>
801062ff:	56                   	push   %esi
80106300:	53                   	push   %ebx
80106301:	50                   	push   %eax
80106302:	68 68 aa 10 80       	push   $0x8010aa68
80106307:	e8 e8 a0 ff ff       	call   801003f4 <cprintf>
8010630c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010630f:	e8 1a c8 ff ff       	call   80102b2e <lapiceoi>
    break;
80106314:	e9 70 02 00 00       	jmp    80106589 <trap+0x395>
case T_PGFLT: {
  uint va = PGROUNDDOWN(rcr2());
80106319:	e8 37 fd ff ff       	call   80106055 <rcr2>
8010631e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106323:	89 45 e0             	mov    %eax,-0x20(%ebp)
  struct proc *p = myproc();
80106326:	e8 17 d7 ff ff       	call   80103a42 <myproc>
8010632b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  if (va >= KERNBASE) {
8010632e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106331:	85 c0                	test   %eax,%eax
80106333:	79 0f                	jns    80106344 <trap+0x150>
    p->killed = 1;
80106335:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106338:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    break;
8010633f:	e9 45 02 00 00       	jmp    80106589 <trap+0x395>
  }

  // (1) Heap 영역 접근
  if (va >= p->oldsz && va < p->sz) {
80106344:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106347:	8b 40 7c             	mov    0x7c(%eax),%eax
8010634a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
8010634d:	0f 82 88 00 00 00    	jb     801063db <trap+0x1e7>
80106353:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106356:	8b 00                	mov    (%eax),%eax
80106358:	39 45 e0             	cmp    %eax,-0x20(%ebp)
8010635b:	73 7e                	jae    801063db <trap+0x1e7>
    char *mem = kalloc();
8010635d:	e8 23 c4 ff ff       	call   80102785 <kalloc>
80106362:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (!mem) {
80106365:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80106369:	75 0f                	jne    8010637a <trap+0x186>
      p->killed = 1;
8010636b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010636e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
80106375:	e9 0f 02 00 00       	jmp    80106589 <trap+0x395>
    }
    memset(mem, 0, PGSIZE);
8010637a:	83 ec 04             	sub    $0x4,%esp
8010637d:	68 00 10 00 00       	push   $0x1000
80106382:	6a 00                	push   $0x0
80106384:	ff 75 d8             	push   -0x28(%ebp)
80106387:	e8 cc e7 ff ff       	call   80104b58 <memset>
8010638c:	83 c4 10             	add    $0x10,%esp
    if (mappages(p->pgdir, (char*)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
8010638f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106392:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80106398:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010639b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010639e:	8b 40 04             	mov    0x4(%eax),%eax
801063a1:	83 ec 0c             	sub    $0xc,%esp
801063a4:	6a 06                	push   $0x6
801063a6:	51                   	push   %ecx
801063a7:	68 00 10 00 00       	push   $0x1000
801063ac:	52                   	push   %edx
801063ad:	50                   	push   %eax
801063ae:	e8 f0 12 00 00       	call   801076a3 <mappages>
801063b3:	83 c4 20             	add    $0x20,%esp
801063b6:	85 c0                	test   %eax,%eax
801063b8:	0f 89 ca 01 00 00    	jns    80106588 <trap+0x394>
      kfree(mem);
801063be:	83 ec 0c             	sub    $0xc,%esp
801063c1:	ff 75 d8             	push   -0x28(%ebp)
801063c4:	e8 22 c3 ff ff       	call   801026eb <kfree>
801063c9:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
801063cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063cf:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801063d6:	e9 ae 01 00 00       	jmp    80106589 <trap+0x395>
    break;
  }

  // (2) Stack 영역 확장
  int i;
  for (i = 0; i < NPROC; i++) {
801063db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801063e2:	eb 18                	jmp    801063fc <trap+0x208>
    if (ppid[i] == p->pid)
801063e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063e7:	8b 14 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%edx
801063ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063f1:	8b 40 10             	mov    0x10(%eax),%eax
801063f4:	39 c2                	cmp    %eax,%edx
801063f6:	74 0c                	je     80106404 <trap+0x210>
  for (i = 0; i < NPROC; i++) {
801063f8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801063fc:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
80106400:	7e e2                	jle    801063e4 <trap+0x1f0>
80106402:	eb 01                	jmp    80106405 <trap+0x211>
      break;
80106404:	90                   	nop
  }
  if (va + PGSIZE < KERNBASE - pspage[i] * PGSIZE) {
80106405:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106408:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
8010640e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106411:	8b 04 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%eax
80106418:	c1 e0 0c             	shl    $0xc,%eax
8010641b:	89 c1                	mov    %eax,%ecx
8010641d:	b8 00 00 00 80       	mov    $0x80000000,%eax
80106422:	29 c8                	sub    %ecx,%eax
80106424:	39 c2                	cmp    %eax,%edx
80106426:	0f 83 96 00 00 00    	jae    801064c2 <trap+0x2ce>
    char *mem = kalloc();
8010642c:	e8 54 c3 ff ff       	call   80102785 <kalloc>
80106431:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (!mem) {
80106434:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80106438:	75 0f                	jne    80106449 <trap+0x255>
      p->killed = 1;
8010643a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010643d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
80106444:	e9 40 01 00 00       	jmp    80106589 <trap+0x395>
    }
    memset(mem, 0, PGSIZE);
80106449:	83 ec 04             	sub    $0x4,%esp
8010644c:	68 00 10 00 00       	push   $0x1000
80106451:	6a 00                	push   $0x0
80106453:	ff 75 d4             	push   -0x2c(%ebp)
80106456:	e8 fd e6 ff ff       	call   80104b58 <memset>
8010645b:	83 c4 10             	add    $0x10,%esp
    if (mappages(p->pgdir, (char*)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
8010645e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106461:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80106467:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010646a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010646d:	8b 40 04             	mov    0x4(%eax),%eax
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	6a 06                	push   $0x6
80106475:	51                   	push   %ecx
80106476:	68 00 10 00 00       	push   $0x1000
8010647b:	52                   	push   %edx
8010647c:	50                   	push   %eax
8010647d:	e8 21 12 00 00       	call   801076a3 <mappages>
80106482:	83 c4 20             	add    $0x20,%esp
80106485:	85 c0                	test   %eax,%eax
80106487:	79 1d                	jns    801064a6 <trap+0x2b2>
      kfree(mem);
80106489:	83 ec 0c             	sub    $0xc,%esp
8010648c:	ff 75 d4             	push   -0x2c(%ebp)
8010648f:	e8 57 c2 ff ff       	call   801026eb <kfree>
80106494:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
80106497:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010649a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801064a1:	e9 e3 00 00 00       	jmp    80106589 <trap+0x395>
    }
    pspage[i]++;
801064a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a9:	8b 04 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%eax
801064b0:	8d 50 01             	lea    0x1(%eax),%edx
801064b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064b6:	89 14 85 40 63 19 80 	mov    %edx,-0x7fe69cc0(,%eax,4)
    break;
801064bd:	e9 c7 00 00 00       	jmp    80106589 <trap+0x395>
  }

  // (3) 그 외 → 잘못된 접근
  p->killed = 1;
801064c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  break;
801064cc:	e9 b8 00 00 00       	jmp    80106589 <trap+0x395>
}
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801064d1:	e8 6c d5 ff ff       	call   80103a42 <myproc>
801064d6:	85 c0                	test   %eax,%eax
801064d8:	74 11                	je     801064eb <trap+0x2f7>
801064da:	8b 45 08             	mov    0x8(%ebp),%eax
801064dd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801064e1:	0f b7 c0             	movzwl %ax,%eax
801064e4:	83 e0 03             	and    $0x3,%eax
801064e7:	85 c0                	test   %eax,%eax
801064e9:	75 39                	jne    80106524 <trap+0x330>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064eb:	e8 65 fb ff ff       	call   80106055 <rcr2>
801064f0:	89 c3                	mov    %eax,%ebx
801064f2:	8b 45 08             	mov    0x8(%ebp),%eax
801064f5:	8b 70 38             	mov    0x38(%eax),%esi
801064f8:	e8 b2 d4 ff ff       	call   801039af <cpuid>
801064fd:	8b 55 08             	mov    0x8(%ebp),%edx
80106500:	8b 52 30             	mov    0x30(%edx),%edx
80106503:	83 ec 0c             	sub    $0xc,%esp
80106506:	53                   	push   %ebx
80106507:	56                   	push   %esi
80106508:	50                   	push   %eax
80106509:	52                   	push   %edx
8010650a:	68 8c aa 10 80       	push   $0x8010aa8c
8010650f:	e8 e0 9e ff ff       	call   801003f4 <cprintf>
80106514:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106517:	83 ec 0c             	sub    $0xc,%esp
8010651a:	68 be aa 10 80       	push   $0x8010aabe
8010651f:	e8 85 a0 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106524:	e8 2c fb ff ff       	call   80106055 <rcr2>
80106529:	89 c6                	mov    %eax,%esi
8010652b:	8b 45 08             	mov    0x8(%ebp),%eax
8010652e:	8b 40 38             	mov    0x38(%eax),%eax
80106531:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80106534:	e8 76 d4 ff ff       	call   801039af <cpuid>
80106539:	89 c3                	mov    %eax,%ebx
8010653b:	8b 45 08             	mov    0x8(%ebp),%eax
8010653e:	8b 78 34             	mov    0x34(%eax),%edi
80106541:	89 7d c0             	mov    %edi,-0x40(%ebp)
80106544:	8b 45 08             	mov    0x8(%ebp),%eax
80106547:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010654a:	e8 f3 d4 ff ff       	call   80103a42 <myproc>
8010654f:	8d 48 6c             	lea    0x6c(%eax),%ecx
80106552:	89 4d bc             	mov    %ecx,-0x44(%ebp)
80106555:	e8 e8 d4 ff ff       	call   80103a42 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010655a:	8b 40 10             	mov    0x10(%eax),%eax
8010655d:	56                   	push   %esi
8010655e:	ff 75 c4             	push   -0x3c(%ebp)
80106561:	53                   	push   %ebx
80106562:	ff 75 c0             	push   -0x40(%ebp)
80106565:	57                   	push   %edi
80106566:	ff 75 bc             	push   -0x44(%ebp)
80106569:	50                   	push   %eax
8010656a:	68 c4 aa 10 80       	push   $0x8010aac4
8010656f:	e8 80 9e ff ff       	call   801003f4 <cprintf>
80106574:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106577:	e8 c6 d4 ff ff       	call   80103a42 <myproc>
8010657c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106583:	eb 04                	jmp    80106589 <trap+0x395>
    break;
80106585:	90                   	nop
80106586:	eb 01                	jmp    80106589 <trap+0x395>
    break;
80106588:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106589:	e8 b4 d4 ff ff       	call   80103a42 <myproc>
8010658e:	85 c0                	test   %eax,%eax
80106590:	74 23                	je     801065b5 <trap+0x3c1>
80106592:	e8 ab d4 ff ff       	call   80103a42 <myproc>
80106597:	8b 40 24             	mov    0x24(%eax),%eax
8010659a:	85 c0                	test   %eax,%eax
8010659c:	74 17                	je     801065b5 <trap+0x3c1>
8010659e:	8b 45 08             	mov    0x8(%ebp),%eax
801065a1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801065a5:	0f b7 c0             	movzwl %ax,%eax
801065a8:	83 e0 03             	and    $0x3,%eax
801065ab:	83 f8 03             	cmp    $0x3,%eax
801065ae:	75 05                	jne    801065b5 <trap+0x3c1>
    exit();
801065b0:	e8 99 d9 ff ff       	call   80103f4e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801065b5:	e8 88 d4 ff ff       	call   80103a42 <myproc>
801065ba:	85 c0                	test   %eax,%eax
801065bc:	74 1d                	je     801065db <trap+0x3e7>
801065be:	e8 7f d4 ff ff       	call   80103a42 <myproc>
801065c3:	8b 40 0c             	mov    0xc(%eax),%eax
801065c6:	83 f8 04             	cmp    $0x4,%eax
801065c9:	75 10                	jne    801065db <trap+0x3e7>
     tf->trapno == T_IRQ0+IRQ_TIMER){
801065cb:	8b 45 08             	mov    0x8(%ebp),%eax
801065ce:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801065d1:	83 f8 20             	cmp    $0x20,%eax
801065d4:	75 05                	jne    801065db <trap+0x3e7>
    yield();
801065d6:	e8 24 dd ff ff       	call   801042ff <yield>
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065db:	e8 62 d4 ff ff       	call   80103a42 <myproc>
801065e0:	85 c0                	test   %eax,%eax
801065e2:	74 26                	je     8010660a <trap+0x416>
801065e4:	e8 59 d4 ff ff       	call   80103a42 <myproc>
801065e9:	8b 40 24             	mov    0x24(%eax),%eax
801065ec:	85 c0                	test   %eax,%eax
801065ee:	74 1a                	je     8010660a <trap+0x416>
801065f0:	8b 45 08             	mov    0x8(%ebp),%eax
801065f3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801065f7:	0f b7 c0             	movzwl %ax,%eax
801065fa:	83 e0 03             	and    $0x3,%eax
801065fd:	83 f8 03             	cmp    $0x3,%eax
80106600:	75 08                	jne    8010660a <trap+0x416>
    exit();
80106602:	e8 47 d9 ff ff       	call   80103f4e <exit>
80106607:	eb 01                	jmp    8010660a <trap+0x416>
    return;
80106609:	90                   	nop
}
8010660a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010660d:	5b                   	pop    %ebx
8010660e:	5e                   	pop    %esi
8010660f:	5f                   	pop    %edi
80106610:	5d                   	pop    %ebp
80106611:	c3                   	ret    

80106612 <inb>:
{
80106612:	55                   	push   %ebp
80106613:	89 e5                	mov    %esp,%ebp
80106615:	83 ec 14             	sub    $0x14,%esp
80106618:	8b 45 08             	mov    0x8(%ebp),%eax
8010661b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010661f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106623:	89 c2                	mov    %eax,%edx
80106625:	ec                   	in     (%dx),%al
80106626:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106629:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010662d:	c9                   	leave  
8010662e:	c3                   	ret    

8010662f <outb>:
{
8010662f:	55                   	push   %ebp
80106630:	89 e5                	mov    %esp,%ebp
80106632:	83 ec 08             	sub    $0x8,%esp
80106635:	8b 45 08             	mov    0x8(%ebp),%eax
80106638:	8b 55 0c             	mov    0xc(%ebp),%edx
8010663b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010663f:	89 d0                	mov    %edx,%eax
80106641:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106644:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106648:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010664c:	ee                   	out    %al,(%dx)
}
8010664d:	90                   	nop
8010664e:	c9                   	leave  
8010664f:	c3                   	ret    

80106650 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106656:	6a 00                	push   $0x0
80106658:	68 fa 03 00 00       	push   $0x3fa
8010665d:	e8 cd ff ff ff       	call   8010662f <outb>
80106662:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106665:	68 80 00 00 00       	push   $0x80
8010666a:	68 fb 03 00 00       	push   $0x3fb
8010666f:	e8 bb ff ff ff       	call   8010662f <outb>
80106674:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106677:	6a 0c                	push   $0xc
80106679:	68 f8 03 00 00       	push   $0x3f8
8010667e:	e8 ac ff ff ff       	call   8010662f <outb>
80106683:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106686:	6a 00                	push   $0x0
80106688:	68 f9 03 00 00       	push   $0x3f9
8010668d:	e8 9d ff ff ff       	call   8010662f <outb>
80106692:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106695:	6a 03                	push   $0x3
80106697:	68 fb 03 00 00       	push   $0x3fb
8010669c:	e8 8e ff ff ff       	call   8010662f <outb>
801066a1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801066a4:	6a 00                	push   $0x0
801066a6:	68 fc 03 00 00       	push   $0x3fc
801066ab:	e8 7f ff ff ff       	call   8010662f <outb>
801066b0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801066b3:	6a 01                	push   $0x1
801066b5:	68 f9 03 00 00       	push   $0x3f9
801066ba:	e8 70 ff ff ff       	call   8010662f <outb>
801066bf:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801066c2:	68 fd 03 00 00       	push   $0x3fd
801066c7:	e8 46 ff ff ff       	call   80106612 <inb>
801066cc:	83 c4 04             	add    $0x4,%esp
801066cf:	3c ff                	cmp    $0xff,%al
801066d1:	74 61                	je     80106734 <uartinit+0xe4>
    return;
  uart = 1;
801066d3:	c7 05 98 6c 19 80 01 	movl   $0x1,0x80196c98
801066da:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801066dd:	68 fa 03 00 00       	push   $0x3fa
801066e2:	e8 2b ff ff ff       	call   80106612 <inb>
801066e7:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801066ea:	68 f8 03 00 00       	push   $0x3f8
801066ef:	e8 1e ff ff ff       	call   80106612 <inb>
801066f4:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801066f7:	83 ec 08             	sub    $0x8,%esp
801066fa:	6a 00                	push   $0x0
801066fc:	6a 04                	push   $0x4
801066fe:	e8 10 bf ff ff       	call   80102613 <ioapicenable>
80106703:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106706:	c7 45 f4 d0 ab 10 80 	movl   $0x8010abd0,-0xc(%ebp)
8010670d:	eb 19                	jmp    80106728 <uartinit+0xd8>
    uartputc(*p);
8010670f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106712:	0f b6 00             	movzbl (%eax),%eax
80106715:	0f be c0             	movsbl %al,%eax
80106718:	83 ec 0c             	sub    $0xc,%esp
8010671b:	50                   	push   %eax
8010671c:	e8 16 00 00 00       	call   80106737 <uartputc>
80106721:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106724:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672b:	0f b6 00             	movzbl (%eax),%eax
8010672e:	84 c0                	test   %al,%al
80106730:	75 dd                	jne    8010670f <uartinit+0xbf>
80106732:	eb 01                	jmp    80106735 <uartinit+0xe5>
    return;
80106734:	90                   	nop
}
80106735:	c9                   	leave  
80106736:	c3                   	ret    

80106737 <uartputc>:

void
uartputc(int c)
{
80106737:	55                   	push   %ebp
80106738:	89 e5                	mov    %esp,%ebp
8010673a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010673d:	a1 98 6c 19 80       	mov    0x80196c98,%eax
80106742:	85 c0                	test   %eax,%eax
80106744:	74 53                	je     80106799 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106746:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010674d:	eb 11                	jmp    80106760 <uartputc+0x29>
    microdelay(10);
8010674f:	83 ec 0c             	sub    $0xc,%esp
80106752:	6a 0a                	push   $0xa
80106754:	e8 f0 c3 ff ff       	call   80102b49 <microdelay>
80106759:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010675c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106760:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106764:	7f 1a                	jg     80106780 <uartputc+0x49>
80106766:	83 ec 0c             	sub    $0xc,%esp
80106769:	68 fd 03 00 00       	push   $0x3fd
8010676e:	e8 9f fe ff ff       	call   80106612 <inb>
80106773:	83 c4 10             	add    $0x10,%esp
80106776:	0f b6 c0             	movzbl %al,%eax
80106779:	83 e0 20             	and    $0x20,%eax
8010677c:	85 c0                	test   %eax,%eax
8010677e:	74 cf                	je     8010674f <uartputc+0x18>
  outb(COM1+0, c);
80106780:	8b 45 08             	mov    0x8(%ebp),%eax
80106783:	0f b6 c0             	movzbl %al,%eax
80106786:	83 ec 08             	sub    $0x8,%esp
80106789:	50                   	push   %eax
8010678a:	68 f8 03 00 00       	push   $0x3f8
8010678f:	e8 9b fe ff ff       	call   8010662f <outb>
80106794:	83 c4 10             	add    $0x10,%esp
80106797:	eb 01                	jmp    8010679a <uartputc+0x63>
    return;
80106799:	90                   	nop
}
8010679a:	c9                   	leave  
8010679b:	c3                   	ret    

8010679c <uartgetc>:

static int
uartgetc(void)
{
8010679c:	55                   	push   %ebp
8010679d:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010679f:	a1 98 6c 19 80       	mov    0x80196c98,%eax
801067a4:	85 c0                	test   %eax,%eax
801067a6:	75 07                	jne    801067af <uartgetc+0x13>
    return -1;
801067a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ad:	eb 2e                	jmp    801067dd <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801067af:	68 fd 03 00 00       	push   $0x3fd
801067b4:	e8 59 fe ff ff       	call   80106612 <inb>
801067b9:	83 c4 04             	add    $0x4,%esp
801067bc:	0f b6 c0             	movzbl %al,%eax
801067bf:	83 e0 01             	and    $0x1,%eax
801067c2:	85 c0                	test   %eax,%eax
801067c4:	75 07                	jne    801067cd <uartgetc+0x31>
    return -1;
801067c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067cb:	eb 10                	jmp    801067dd <uartgetc+0x41>
  return inb(COM1+0);
801067cd:	68 f8 03 00 00       	push   $0x3f8
801067d2:	e8 3b fe ff ff       	call   80106612 <inb>
801067d7:	83 c4 04             	add    $0x4,%esp
801067da:	0f b6 c0             	movzbl %al,%eax
}
801067dd:	c9                   	leave  
801067de:	c3                   	ret    

801067df <uartintr>:

void
uartintr(void)
{
801067df:	55                   	push   %ebp
801067e0:	89 e5                	mov    %esp,%ebp
801067e2:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801067e5:	83 ec 0c             	sub    $0xc,%esp
801067e8:	68 9c 67 10 80       	push   $0x8010679c
801067ed:	e8 e4 9f ff ff       	call   801007d6 <consoleintr>
801067f2:	83 c4 10             	add    $0x10,%esp
}
801067f5:	90                   	nop
801067f6:	c9                   	leave  
801067f7:	c3                   	ret    

801067f8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $0
801067fa:	6a 00                	push   $0x0
  jmp alltraps
801067fc:	e9 07 f8 ff ff       	jmp    80106008 <alltraps>

80106801 <vector1>:
.globl vector1
vector1:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $1
80106803:	6a 01                	push   $0x1
  jmp alltraps
80106805:	e9 fe f7 ff ff       	jmp    80106008 <alltraps>

8010680a <vector2>:
.globl vector2
vector2:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $2
8010680c:	6a 02                	push   $0x2
  jmp alltraps
8010680e:	e9 f5 f7 ff ff       	jmp    80106008 <alltraps>

80106813 <vector3>:
.globl vector3
vector3:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $3
80106815:	6a 03                	push   $0x3
  jmp alltraps
80106817:	e9 ec f7 ff ff       	jmp    80106008 <alltraps>

8010681c <vector4>:
.globl vector4
vector4:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $4
8010681e:	6a 04                	push   $0x4
  jmp alltraps
80106820:	e9 e3 f7 ff ff       	jmp    80106008 <alltraps>

80106825 <vector5>:
.globl vector5
vector5:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $5
80106827:	6a 05                	push   $0x5
  jmp alltraps
80106829:	e9 da f7 ff ff       	jmp    80106008 <alltraps>

8010682e <vector6>:
.globl vector6
vector6:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $6
80106830:	6a 06                	push   $0x6
  jmp alltraps
80106832:	e9 d1 f7 ff ff       	jmp    80106008 <alltraps>

80106837 <vector7>:
.globl vector7
vector7:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $7
80106839:	6a 07                	push   $0x7
  jmp alltraps
8010683b:	e9 c8 f7 ff ff       	jmp    80106008 <alltraps>

80106840 <vector8>:
.globl vector8
vector8:
  pushl $8
80106840:	6a 08                	push   $0x8
  jmp alltraps
80106842:	e9 c1 f7 ff ff       	jmp    80106008 <alltraps>

80106847 <vector9>:
.globl vector9
vector9:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $9
80106849:	6a 09                	push   $0x9
  jmp alltraps
8010684b:	e9 b8 f7 ff ff       	jmp    80106008 <alltraps>

80106850 <vector10>:
.globl vector10
vector10:
  pushl $10
80106850:	6a 0a                	push   $0xa
  jmp alltraps
80106852:	e9 b1 f7 ff ff       	jmp    80106008 <alltraps>

80106857 <vector11>:
.globl vector11
vector11:
  pushl $11
80106857:	6a 0b                	push   $0xb
  jmp alltraps
80106859:	e9 aa f7 ff ff       	jmp    80106008 <alltraps>

8010685e <vector12>:
.globl vector12
vector12:
  pushl $12
8010685e:	6a 0c                	push   $0xc
  jmp alltraps
80106860:	e9 a3 f7 ff ff       	jmp    80106008 <alltraps>

80106865 <vector13>:
.globl vector13
vector13:
  pushl $13
80106865:	6a 0d                	push   $0xd
  jmp alltraps
80106867:	e9 9c f7 ff ff       	jmp    80106008 <alltraps>

8010686c <vector14>:
.globl vector14
vector14:
  pushl $14
8010686c:	6a 0e                	push   $0xe
  jmp alltraps
8010686e:	e9 95 f7 ff ff       	jmp    80106008 <alltraps>

80106873 <vector15>:
.globl vector15
vector15:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $15
80106875:	6a 0f                	push   $0xf
  jmp alltraps
80106877:	e9 8c f7 ff ff       	jmp    80106008 <alltraps>

8010687c <vector16>:
.globl vector16
vector16:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $16
8010687e:	6a 10                	push   $0x10
  jmp alltraps
80106880:	e9 83 f7 ff ff       	jmp    80106008 <alltraps>

80106885 <vector17>:
.globl vector17
vector17:
  pushl $17
80106885:	6a 11                	push   $0x11
  jmp alltraps
80106887:	e9 7c f7 ff ff       	jmp    80106008 <alltraps>

8010688c <vector18>:
.globl vector18
vector18:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $18
8010688e:	6a 12                	push   $0x12
  jmp alltraps
80106890:	e9 73 f7 ff ff       	jmp    80106008 <alltraps>

80106895 <vector19>:
.globl vector19
vector19:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $19
80106897:	6a 13                	push   $0x13
  jmp alltraps
80106899:	e9 6a f7 ff ff       	jmp    80106008 <alltraps>

8010689e <vector20>:
.globl vector20
vector20:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $20
801068a0:	6a 14                	push   $0x14
  jmp alltraps
801068a2:	e9 61 f7 ff ff       	jmp    80106008 <alltraps>

801068a7 <vector21>:
.globl vector21
vector21:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $21
801068a9:	6a 15                	push   $0x15
  jmp alltraps
801068ab:	e9 58 f7 ff ff       	jmp    80106008 <alltraps>

801068b0 <vector22>:
.globl vector22
vector22:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $22
801068b2:	6a 16                	push   $0x16
  jmp alltraps
801068b4:	e9 4f f7 ff ff       	jmp    80106008 <alltraps>

801068b9 <vector23>:
.globl vector23
vector23:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $23
801068bb:	6a 17                	push   $0x17
  jmp alltraps
801068bd:	e9 46 f7 ff ff       	jmp    80106008 <alltraps>

801068c2 <vector24>:
.globl vector24
vector24:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $24
801068c4:	6a 18                	push   $0x18
  jmp alltraps
801068c6:	e9 3d f7 ff ff       	jmp    80106008 <alltraps>

801068cb <vector25>:
.globl vector25
vector25:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $25
801068cd:	6a 19                	push   $0x19
  jmp alltraps
801068cf:	e9 34 f7 ff ff       	jmp    80106008 <alltraps>

801068d4 <vector26>:
.globl vector26
vector26:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $26
801068d6:	6a 1a                	push   $0x1a
  jmp alltraps
801068d8:	e9 2b f7 ff ff       	jmp    80106008 <alltraps>

801068dd <vector27>:
.globl vector27
vector27:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $27
801068df:	6a 1b                	push   $0x1b
  jmp alltraps
801068e1:	e9 22 f7 ff ff       	jmp    80106008 <alltraps>

801068e6 <vector28>:
.globl vector28
vector28:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $28
801068e8:	6a 1c                	push   $0x1c
  jmp alltraps
801068ea:	e9 19 f7 ff ff       	jmp    80106008 <alltraps>

801068ef <vector29>:
.globl vector29
vector29:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $29
801068f1:	6a 1d                	push   $0x1d
  jmp alltraps
801068f3:	e9 10 f7 ff ff       	jmp    80106008 <alltraps>

801068f8 <vector30>:
.globl vector30
vector30:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $30
801068fa:	6a 1e                	push   $0x1e
  jmp alltraps
801068fc:	e9 07 f7 ff ff       	jmp    80106008 <alltraps>

80106901 <vector31>:
.globl vector31
vector31:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $31
80106903:	6a 1f                	push   $0x1f
  jmp alltraps
80106905:	e9 fe f6 ff ff       	jmp    80106008 <alltraps>

8010690a <vector32>:
.globl vector32
vector32:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $32
8010690c:	6a 20                	push   $0x20
  jmp alltraps
8010690e:	e9 f5 f6 ff ff       	jmp    80106008 <alltraps>

80106913 <vector33>:
.globl vector33
vector33:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $33
80106915:	6a 21                	push   $0x21
  jmp alltraps
80106917:	e9 ec f6 ff ff       	jmp    80106008 <alltraps>

8010691c <vector34>:
.globl vector34
vector34:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $34
8010691e:	6a 22                	push   $0x22
  jmp alltraps
80106920:	e9 e3 f6 ff ff       	jmp    80106008 <alltraps>

80106925 <vector35>:
.globl vector35
vector35:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $35
80106927:	6a 23                	push   $0x23
  jmp alltraps
80106929:	e9 da f6 ff ff       	jmp    80106008 <alltraps>

8010692e <vector36>:
.globl vector36
vector36:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $36
80106930:	6a 24                	push   $0x24
  jmp alltraps
80106932:	e9 d1 f6 ff ff       	jmp    80106008 <alltraps>

80106937 <vector37>:
.globl vector37
vector37:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $37
80106939:	6a 25                	push   $0x25
  jmp alltraps
8010693b:	e9 c8 f6 ff ff       	jmp    80106008 <alltraps>

80106940 <vector38>:
.globl vector38
vector38:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $38
80106942:	6a 26                	push   $0x26
  jmp alltraps
80106944:	e9 bf f6 ff ff       	jmp    80106008 <alltraps>

80106949 <vector39>:
.globl vector39
vector39:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $39
8010694b:	6a 27                	push   $0x27
  jmp alltraps
8010694d:	e9 b6 f6 ff ff       	jmp    80106008 <alltraps>

80106952 <vector40>:
.globl vector40
vector40:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $40
80106954:	6a 28                	push   $0x28
  jmp alltraps
80106956:	e9 ad f6 ff ff       	jmp    80106008 <alltraps>

8010695b <vector41>:
.globl vector41
vector41:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $41
8010695d:	6a 29                	push   $0x29
  jmp alltraps
8010695f:	e9 a4 f6 ff ff       	jmp    80106008 <alltraps>

80106964 <vector42>:
.globl vector42
vector42:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $42
80106966:	6a 2a                	push   $0x2a
  jmp alltraps
80106968:	e9 9b f6 ff ff       	jmp    80106008 <alltraps>

8010696d <vector43>:
.globl vector43
vector43:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $43
8010696f:	6a 2b                	push   $0x2b
  jmp alltraps
80106971:	e9 92 f6 ff ff       	jmp    80106008 <alltraps>

80106976 <vector44>:
.globl vector44
vector44:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $44
80106978:	6a 2c                	push   $0x2c
  jmp alltraps
8010697a:	e9 89 f6 ff ff       	jmp    80106008 <alltraps>

8010697f <vector45>:
.globl vector45
vector45:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $45
80106981:	6a 2d                	push   $0x2d
  jmp alltraps
80106983:	e9 80 f6 ff ff       	jmp    80106008 <alltraps>

80106988 <vector46>:
.globl vector46
vector46:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $46
8010698a:	6a 2e                	push   $0x2e
  jmp alltraps
8010698c:	e9 77 f6 ff ff       	jmp    80106008 <alltraps>

80106991 <vector47>:
.globl vector47
vector47:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $47
80106993:	6a 2f                	push   $0x2f
  jmp alltraps
80106995:	e9 6e f6 ff ff       	jmp    80106008 <alltraps>

8010699a <vector48>:
.globl vector48
vector48:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $48
8010699c:	6a 30                	push   $0x30
  jmp alltraps
8010699e:	e9 65 f6 ff ff       	jmp    80106008 <alltraps>

801069a3 <vector49>:
.globl vector49
vector49:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $49
801069a5:	6a 31                	push   $0x31
  jmp alltraps
801069a7:	e9 5c f6 ff ff       	jmp    80106008 <alltraps>

801069ac <vector50>:
.globl vector50
vector50:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $50
801069ae:	6a 32                	push   $0x32
  jmp alltraps
801069b0:	e9 53 f6 ff ff       	jmp    80106008 <alltraps>

801069b5 <vector51>:
.globl vector51
vector51:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $51
801069b7:	6a 33                	push   $0x33
  jmp alltraps
801069b9:	e9 4a f6 ff ff       	jmp    80106008 <alltraps>

801069be <vector52>:
.globl vector52
vector52:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $52
801069c0:	6a 34                	push   $0x34
  jmp alltraps
801069c2:	e9 41 f6 ff ff       	jmp    80106008 <alltraps>

801069c7 <vector53>:
.globl vector53
vector53:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $53
801069c9:	6a 35                	push   $0x35
  jmp alltraps
801069cb:	e9 38 f6 ff ff       	jmp    80106008 <alltraps>

801069d0 <vector54>:
.globl vector54
vector54:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $54
801069d2:	6a 36                	push   $0x36
  jmp alltraps
801069d4:	e9 2f f6 ff ff       	jmp    80106008 <alltraps>

801069d9 <vector55>:
.globl vector55
vector55:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $55
801069db:	6a 37                	push   $0x37
  jmp alltraps
801069dd:	e9 26 f6 ff ff       	jmp    80106008 <alltraps>

801069e2 <vector56>:
.globl vector56
vector56:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $56
801069e4:	6a 38                	push   $0x38
  jmp alltraps
801069e6:	e9 1d f6 ff ff       	jmp    80106008 <alltraps>

801069eb <vector57>:
.globl vector57
vector57:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $57
801069ed:	6a 39                	push   $0x39
  jmp alltraps
801069ef:	e9 14 f6 ff ff       	jmp    80106008 <alltraps>

801069f4 <vector58>:
.globl vector58
vector58:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $58
801069f6:	6a 3a                	push   $0x3a
  jmp alltraps
801069f8:	e9 0b f6 ff ff       	jmp    80106008 <alltraps>

801069fd <vector59>:
.globl vector59
vector59:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $59
801069ff:	6a 3b                	push   $0x3b
  jmp alltraps
80106a01:	e9 02 f6 ff ff       	jmp    80106008 <alltraps>

80106a06 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $60
80106a08:	6a 3c                	push   $0x3c
  jmp alltraps
80106a0a:	e9 f9 f5 ff ff       	jmp    80106008 <alltraps>

80106a0f <vector61>:
.globl vector61
vector61:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $61
80106a11:	6a 3d                	push   $0x3d
  jmp alltraps
80106a13:	e9 f0 f5 ff ff       	jmp    80106008 <alltraps>

80106a18 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $62
80106a1a:	6a 3e                	push   $0x3e
  jmp alltraps
80106a1c:	e9 e7 f5 ff ff       	jmp    80106008 <alltraps>

80106a21 <vector63>:
.globl vector63
vector63:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $63
80106a23:	6a 3f                	push   $0x3f
  jmp alltraps
80106a25:	e9 de f5 ff ff       	jmp    80106008 <alltraps>

80106a2a <vector64>:
.globl vector64
vector64:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $64
80106a2c:	6a 40                	push   $0x40
  jmp alltraps
80106a2e:	e9 d5 f5 ff ff       	jmp    80106008 <alltraps>

80106a33 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $65
80106a35:	6a 41                	push   $0x41
  jmp alltraps
80106a37:	e9 cc f5 ff ff       	jmp    80106008 <alltraps>

80106a3c <vector66>:
.globl vector66
vector66:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $66
80106a3e:	6a 42                	push   $0x42
  jmp alltraps
80106a40:	e9 c3 f5 ff ff       	jmp    80106008 <alltraps>

80106a45 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $67
80106a47:	6a 43                	push   $0x43
  jmp alltraps
80106a49:	e9 ba f5 ff ff       	jmp    80106008 <alltraps>

80106a4e <vector68>:
.globl vector68
vector68:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $68
80106a50:	6a 44                	push   $0x44
  jmp alltraps
80106a52:	e9 b1 f5 ff ff       	jmp    80106008 <alltraps>

80106a57 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $69
80106a59:	6a 45                	push   $0x45
  jmp alltraps
80106a5b:	e9 a8 f5 ff ff       	jmp    80106008 <alltraps>

80106a60 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $70
80106a62:	6a 46                	push   $0x46
  jmp alltraps
80106a64:	e9 9f f5 ff ff       	jmp    80106008 <alltraps>

80106a69 <vector71>:
.globl vector71
vector71:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $71
80106a6b:	6a 47                	push   $0x47
  jmp alltraps
80106a6d:	e9 96 f5 ff ff       	jmp    80106008 <alltraps>

80106a72 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $72
80106a74:	6a 48                	push   $0x48
  jmp alltraps
80106a76:	e9 8d f5 ff ff       	jmp    80106008 <alltraps>

80106a7b <vector73>:
.globl vector73
vector73:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $73
80106a7d:	6a 49                	push   $0x49
  jmp alltraps
80106a7f:	e9 84 f5 ff ff       	jmp    80106008 <alltraps>

80106a84 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $74
80106a86:	6a 4a                	push   $0x4a
  jmp alltraps
80106a88:	e9 7b f5 ff ff       	jmp    80106008 <alltraps>

80106a8d <vector75>:
.globl vector75
vector75:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $75
80106a8f:	6a 4b                	push   $0x4b
  jmp alltraps
80106a91:	e9 72 f5 ff ff       	jmp    80106008 <alltraps>

80106a96 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $76
80106a98:	6a 4c                	push   $0x4c
  jmp alltraps
80106a9a:	e9 69 f5 ff ff       	jmp    80106008 <alltraps>

80106a9f <vector77>:
.globl vector77
vector77:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $77
80106aa1:	6a 4d                	push   $0x4d
  jmp alltraps
80106aa3:	e9 60 f5 ff ff       	jmp    80106008 <alltraps>

80106aa8 <vector78>:
.globl vector78
vector78:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $78
80106aaa:	6a 4e                	push   $0x4e
  jmp alltraps
80106aac:	e9 57 f5 ff ff       	jmp    80106008 <alltraps>

80106ab1 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $79
80106ab3:	6a 4f                	push   $0x4f
  jmp alltraps
80106ab5:	e9 4e f5 ff ff       	jmp    80106008 <alltraps>

80106aba <vector80>:
.globl vector80
vector80:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $80
80106abc:	6a 50                	push   $0x50
  jmp alltraps
80106abe:	e9 45 f5 ff ff       	jmp    80106008 <alltraps>

80106ac3 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $81
80106ac5:	6a 51                	push   $0x51
  jmp alltraps
80106ac7:	e9 3c f5 ff ff       	jmp    80106008 <alltraps>

80106acc <vector82>:
.globl vector82
vector82:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $82
80106ace:	6a 52                	push   $0x52
  jmp alltraps
80106ad0:	e9 33 f5 ff ff       	jmp    80106008 <alltraps>

80106ad5 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $83
80106ad7:	6a 53                	push   $0x53
  jmp alltraps
80106ad9:	e9 2a f5 ff ff       	jmp    80106008 <alltraps>

80106ade <vector84>:
.globl vector84
vector84:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $84
80106ae0:	6a 54                	push   $0x54
  jmp alltraps
80106ae2:	e9 21 f5 ff ff       	jmp    80106008 <alltraps>

80106ae7 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $85
80106ae9:	6a 55                	push   $0x55
  jmp alltraps
80106aeb:	e9 18 f5 ff ff       	jmp    80106008 <alltraps>

80106af0 <vector86>:
.globl vector86
vector86:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $86
80106af2:	6a 56                	push   $0x56
  jmp alltraps
80106af4:	e9 0f f5 ff ff       	jmp    80106008 <alltraps>

80106af9 <vector87>:
.globl vector87
vector87:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $87
80106afb:	6a 57                	push   $0x57
  jmp alltraps
80106afd:	e9 06 f5 ff ff       	jmp    80106008 <alltraps>

80106b02 <vector88>:
.globl vector88
vector88:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $88
80106b04:	6a 58                	push   $0x58
  jmp alltraps
80106b06:	e9 fd f4 ff ff       	jmp    80106008 <alltraps>

80106b0b <vector89>:
.globl vector89
vector89:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $89
80106b0d:	6a 59                	push   $0x59
  jmp alltraps
80106b0f:	e9 f4 f4 ff ff       	jmp    80106008 <alltraps>

80106b14 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $90
80106b16:	6a 5a                	push   $0x5a
  jmp alltraps
80106b18:	e9 eb f4 ff ff       	jmp    80106008 <alltraps>

80106b1d <vector91>:
.globl vector91
vector91:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $91
80106b1f:	6a 5b                	push   $0x5b
  jmp alltraps
80106b21:	e9 e2 f4 ff ff       	jmp    80106008 <alltraps>

80106b26 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $92
80106b28:	6a 5c                	push   $0x5c
  jmp alltraps
80106b2a:	e9 d9 f4 ff ff       	jmp    80106008 <alltraps>

80106b2f <vector93>:
.globl vector93
vector93:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $93
80106b31:	6a 5d                	push   $0x5d
  jmp alltraps
80106b33:	e9 d0 f4 ff ff       	jmp    80106008 <alltraps>

80106b38 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $94
80106b3a:	6a 5e                	push   $0x5e
  jmp alltraps
80106b3c:	e9 c7 f4 ff ff       	jmp    80106008 <alltraps>

80106b41 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $95
80106b43:	6a 5f                	push   $0x5f
  jmp alltraps
80106b45:	e9 be f4 ff ff       	jmp    80106008 <alltraps>

80106b4a <vector96>:
.globl vector96
vector96:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $96
80106b4c:	6a 60                	push   $0x60
  jmp alltraps
80106b4e:	e9 b5 f4 ff ff       	jmp    80106008 <alltraps>

80106b53 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $97
80106b55:	6a 61                	push   $0x61
  jmp alltraps
80106b57:	e9 ac f4 ff ff       	jmp    80106008 <alltraps>

80106b5c <vector98>:
.globl vector98
vector98:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $98
80106b5e:	6a 62                	push   $0x62
  jmp alltraps
80106b60:	e9 a3 f4 ff ff       	jmp    80106008 <alltraps>

80106b65 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $99
80106b67:	6a 63                	push   $0x63
  jmp alltraps
80106b69:	e9 9a f4 ff ff       	jmp    80106008 <alltraps>

80106b6e <vector100>:
.globl vector100
vector100:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $100
80106b70:	6a 64                	push   $0x64
  jmp alltraps
80106b72:	e9 91 f4 ff ff       	jmp    80106008 <alltraps>

80106b77 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $101
80106b79:	6a 65                	push   $0x65
  jmp alltraps
80106b7b:	e9 88 f4 ff ff       	jmp    80106008 <alltraps>

80106b80 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $102
80106b82:	6a 66                	push   $0x66
  jmp alltraps
80106b84:	e9 7f f4 ff ff       	jmp    80106008 <alltraps>

80106b89 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $103
80106b8b:	6a 67                	push   $0x67
  jmp alltraps
80106b8d:	e9 76 f4 ff ff       	jmp    80106008 <alltraps>

80106b92 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $104
80106b94:	6a 68                	push   $0x68
  jmp alltraps
80106b96:	e9 6d f4 ff ff       	jmp    80106008 <alltraps>

80106b9b <vector105>:
.globl vector105
vector105:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $105
80106b9d:	6a 69                	push   $0x69
  jmp alltraps
80106b9f:	e9 64 f4 ff ff       	jmp    80106008 <alltraps>

80106ba4 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $106
80106ba6:	6a 6a                	push   $0x6a
  jmp alltraps
80106ba8:	e9 5b f4 ff ff       	jmp    80106008 <alltraps>

80106bad <vector107>:
.globl vector107
vector107:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $107
80106baf:	6a 6b                	push   $0x6b
  jmp alltraps
80106bb1:	e9 52 f4 ff ff       	jmp    80106008 <alltraps>

80106bb6 <vector108>:
.globl vector108
vector108:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $108
80106bb8:	6a 6c                	push   $0x6c
  jmp alltraps
80106bba:	e9 49 f4 ff ff       	jmp    80106008 <alltraps>

80106bbf <vector109>:
.globl vector109
vector109:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $109
80106bc1:	6a 6d                	push   $0x6d
  jmp alltraps
80106bc3:	e9 40 f4 ff ff       	jmp    80106008 <alltraps>

80106bc8 <vector110>:
.globl vector110
vector110:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $110
80106bca:	6a 6e                	push   $0x6e
  jmp alltraps
80106bcc:	e9 37 f4 ff ff       	jmp    80106008 <alltraps>

80106bd1 <vector111>:
.globl vector111
vector111:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $111
80106bd3:	6a 6f                	push   $0x6f
  jmp alltraps
80106bd5:	e9 2e f4 ff ff       	jmp    80106008 <alltraps>

80106bda <vector112>:
.globl vector112
vector112:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $112
80106bdc:	6a 70                	push   $0x70
  jmp alltraps
80106bde:	e9 25 f4 ff ff       	jmp    80106008 <alltraps>

80106be3 <vector113>:
.globl vector113
vector113:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $113
80106be5:	6a 71                	push   $0x71
  jmp alltraps
80106be7:	e9 1c f4 ff ff       	jmp    80106008 <alltraps>

80106bec <vector114>:
.globl vector114
vector114:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $114
80106bee:	6a 72                	push   $0x72
  jmp alltraps
80106bf0:	e9 13 f4 ff ff       	jmp    80106008 <alltraps>

80106bf5 <vector115>:
.globl vector115
vector115:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $115
80106bf7:	6a 73                	push   $0x73
  jmp alltraps
80106bf9:	e9 0a f4 ff ff       	jmp    80106008 <alltraps>

80106bfe <vector116>:
.globl vector116
vector116:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $116
80106c00:	6a 74                	push   $0x74
  jmp alltraps
80106c02:	e9 01 f4 ff ff       	jmp    80106008 <alltraps>

80106c07 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $117
80106c09:	6a 75                	push   $0x75
  jmp alltraps
80106c0b:	e9 f8 f3 ff ff       	jmp    80106008 <alltraps>

80106c10 <vector118>:
.globl vector118
vector118:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $118
80106c12:	6a 76                	push   $0x76
  jmp alltraps
80106c14:	e9 ef f3 ff ff       	jmp    80106008 <alltraps>

80106c19 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $119
80106c1b:	6a 77                	push   $0x77
  jmp alltraps
80106c1d:	e9 e6 f3 ff ff       	jmp    80106008 <alltraps>

80106c22 <vector120>:
.globl vector120
vector120:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $120
80106c24:	6a 78                	push   $0x78
  jmp alltraps
80106c26:	e9 dd f3 ff ff       	jmp    80106008 <alltraps>

80106c2b <vector121>:
.globl vector121
vector121:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $121
80106c2d:	6a 79                	push   $0x79
  jmp alltraps
80106c2f:	e9 d4 f3 ff ff       	jmp    80106008 <alltraps>

80106c34 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $122
80106c36:	6a 7a                	push   $0x7a
  jmp alltraps
80106c38:	e9 cb f3 ff ff       	jmp    80106008 <alltraps>

80106c3d <vector123>:
.globl vector123
vector123:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $123
80106c3f:	6a 7b                	push   $0x7b
  jmp alltraps
80106c41:	e9 c2 f3 ff ff       	jmp    80106008 <alltraps>

80106c46 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $124
80106c48:	6a 7c                	push   $0x7c
  jmp alltraps
80106c4a:	e9 b9 f3 ff ff       	jmp    80106008 <alltraps>

80106c4f <vector125>:
.globl vector125
vector125:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $125
80106c51:	6a 7d                	push   $0x7d
  jmp alltraps
80106c53:	e9 b0 f3 ff ff       	jmp    80106008 <alltraps>

80106c58 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $126
80106c5a:	6a 7e                	push   $0x7e
  jmp alltraps
80106c5c:	e9 a7 f3 ff ff       	jmp    80106008 <alltraps>

80106c61 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $127
80106c63:	6a 7f                	push   $0x7f
  jmp alltraps
80106c65:	e9 9e f3 ff ff       	jmp    80106008 <alltraps>

80106c6a <vector128>:
.globl vector128
vector128:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $128
80106c6c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c71:	e9 92 f3 ff ff       	jmp    80106008 <alltraps>

80106c76 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $129
80106c78:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c7d:	e9 86 f3 ff ff       	jmp    80106008 <alltraps>

80106c82 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $130
80106c84:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c89:	e9 7a f3 ff ff       	jmp    80106008 <alltraps>

80106c8e <vector131>:
.globl vector131
vector131:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $131
80106c90:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c95:	e9 6e f3 ff ff       	jmp    80106008 <alltraps>

80106c9a <vector132>:
.globl vector132
vector132:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $132
80106c9c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ca1:	e9 62 f3 ff ff       	jmp    80106008 <alltraps>

80106ca6 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $133
80106ca8:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cad:	e9 56 f3 ff ff       	jmp    80106008 <alltraps>

80106cb2 <vector134>:
.globl vector134
vector134:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $134
80106cb4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106cb9:	e9 4a f3 ff ff       	jmp    80106008 <alltraps>

80106cbe <vector135>:
.globl vector135
vector135:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $135
80106cc0:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106cc5:	e9 3e f3 ff ff       	jmp    80106008 <alltraps>

80106cca <vector136>:
.globl vector136
vector136:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $136
80106ccc:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106cd1:	e9 32 f3 ff ff       	jmp    80106008 <alltraps>

80106cd6 <vector137>:
.globl vector137
vector137:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $137
80106cd8:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106cdd:	e9 26 f3 ff ff       	jmp    80106008 <alltraps>

80106ce2 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $138
80106ce4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ce9:	e9 1a f3 ff ff       	jmp    80106008 <alltraps>

80106cee <vector139>:
.globl vector139
vector139:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $139
80106cf0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106cf5:	e9 0e f3 ff ff       	jmp    80106008 <alltraps>

80106cfa <vector140>:
.globl vector140
vector140:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $140
80106cfc:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d01:	e9 02 f3 ff ff       	jmp    80106008 <alltraps>

80106d06 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $141
80106d08:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d0d:	e9 f6 f2 ff ff       	jmp    80106008 <alltraps>

80106d12 <vector142>:
.globl vector142
vector142:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $142
80106d14:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d19:	e9 ea f2 ff ff       	jmp    80106008 <alltraps>

80106d1e <vector143>:
.globl vector143
vector143:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $143
80106d20:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d25:	e9 de f2 ff ff       	jmp    80106008 <alltraps>

80106d2a <vector144>:
.globl vector144
vector144:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $144
80106d2c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d31:	e9 d2 f2 ff ff       	jmp    80106008 <alltraps>

80106d36 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $145
80106d38:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d3d:	e9 c6 f2 ff ff       	jmp    80106008 <alltraps>

80106d42 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $146
80106d44:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d49:	e9 ba f2 ff ff       	jmp    80106008 <alltraps>

80106d4e <vector147>:
.globl vector147
vector147:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $147
80106d50:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d55:	e9 ae f2 ff ff       	jmp    80106008 <alltraps>

80106d5a <vector148>:
.globl vector148
vector148:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $148
80106d5c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d61:	e9 a2 f2 ff ff       	jmp    80106008 <alltraps>

80106d66 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $149
80106d68:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d6d:	e9 96 f2 ff ff       	jmp    80106008 <alltraps>

80106d72 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $150
80106d74:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d79:	e9 8a f2 ff ff       	jmp    80106008 <alltraps>

80106d7e <vector151>:
.globl vector151
vector151:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $151
80106d80:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d85:	e9 7e f2 ff ff       	jmp    80106008 <alltraps>

80106d8a <vector152>:
.globl vector152
vector152:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $152
80106d8c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d91:	e9 72 f2 ff ff       	jmp    80106008 <alltraps>

80106d96 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $153
80106d98:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d9d:	e9 66 f2 ff ff       	jmp    80106008 <alltraps>

80106da2 <vector154>:
.globl vector154
vector154:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $154
80106da4:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106da9:	e9 5a f2 ff ff       	jmp    80106008 <alltraps>

80106dae <vector155>:
.globl vector155
vector155:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $155
80106db0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106db5:	e9 4e f2 ff ff       	jmp    80106008 <alltraps>

80106dba <vector156>:
.globl vector156
vector156:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $156
80106dbc:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106dc1:	e9 42 f2 ff ff       	jmp    80106008 <alltraps>

80106dc6 <vector157>:
.globl vector157
vector157:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $157
80106dc8:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106dcd:	e9 36 f2 ff ff       	jmp    80106008 <alltraps>

80106dd2 <vector158>:
.globl vector158
vector158:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $158
80106dd4:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106dd9:	e9 2a f2 ff ff       	jmp    80106008 <alltraps>

80106dde <vector159>:
.globl vector159
vector159:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $159
80106de0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106de5:	e9 1e f2 ff ff       	jmp    80106008 <alltraps>

80106dea <vector160>:
.globl vector160
vector160:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $160
80106dec:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106df1:	e9 12 f2 ff ff       	jmp    80106008 <alltraps>

80106df6 <vector161>:
.globl vector161
vector161:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $161
80106df8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dfd:	e9 06 f2 ff ff       	jmp    80106008 <alltraps>

80106e02 <vector162>:
.globl vector162
vector162:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $162
80106e04:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e09:	e9 fa f1 ff ff       	jmp    80106008 <alltraps>

80106e0e <vector163>:
.globl vector163
vector163:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $163
80106e10:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e15:	e9 ee f1 ff ff       	jmp    80106008 <alltraps>

80106e1a <vector164>:
.globl vector164
vector164:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $164
80106e1c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e21:	e9 e2 f1 ff ff       	jmp    80106008 <alltraps>

80106e26 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $165
80106e28:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e2d:	e9 d6 f1 ff ff       	jmp    80106008 <alltraps>

80106e32 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $166
80106e34:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e39:	e9 ca f1 ff ff       	jmp    80106008 <alltraps>

80106e3e <vector167>:
.globl vector167
vector167:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $167
80106e40:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e45:	e9 be f1 ff ff       	jmp    80106008 <alltraps>

80106e4a <vector168>:
.globl vector168
vector168:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $168
80106e4c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e51:	e9 b2 f1 ff ff       	jmp    80106008 <alltraps>

80106e56 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $169
80106e58:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e5d:	e9 a6 f1 ff ff       	jmp    80106008 <alltraps>

80106e62 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $170
80106e64:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e69:	e9 9a f1 ff ff       	jmp    80106008 <alltraps>

80106e6e <vector171>:
.globl vector171
vector171:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $171
80106e70:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e75:	e9 8e f1 ff ff       	jmp    80106008 <alltraps>

80106e7a <vector172>:
.globl vector172
vector172:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $172
80106e7c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e81:	e9 82 f1 ff ff       	jmp    80106008 <alltraps>

80106e86 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $173
80106e88:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e8d:	e9 76 f1 ff ff       	jmp    80106008 <alltraps>

80106e92 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $174
80106e94:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e99:	e9 6a f1 ff ff       	jmp    80106008 <alltraps>

80106e9e <vector175>:
.globl vector175
vector175:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $175
80106ea0:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ea5:	e9 5e f1 ff ff       	jmp    80106008 <alltraps>

80106eaa <vector176>:
.globl vector176
vector176:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $176
80106eac:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106eb1:	e9 52 f1 ff ff       	jmp    80106008 <alltraps>

80106eb6 <vector177>:
.globl vector177
vector177:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $177
80106eb8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106ebd:	e9 46 f1 ff ff       	jmp    80106008 <alltraps>

80106ec2 <vector178>:
.globl vector178
vector178:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $178
80106ec4:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ec9:	e9 3a f1 ff ff       	jmp    80106008 <alltraps>

80106ece <vector179>:
.globl vector179
vector179:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $179
80106ed0:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ed5:	e9 2e f1 ff ff       	jmp    80106008 <alltraps>

80106eda <vector180>:
.globl vector180
vector180:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $180
80106edc:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ee1:	e9 22 f1 ff ff       	jmp    80106008 <alltraps>

80106ee6 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $181
80106ee8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106eed:	e9 16 f1 ff ff       	jmp    80106008 <alltraps>

80106ef2 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $182
80106ef4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ef9:	e9 0a f1 ff ff       	jmp    80106008 <alltraps>

80106efe <vector183>:
.globl vector183
vector183:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $183
80106f00:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f05:	e9 fe f0 ff ff       	jmp    80106008 <alltraps>

80106f0a <vector184>:
.globl vector184
vector184:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $184
80106f0c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f11:	e9 f2 f0 ff ff       	jmp    80106008 <alltraps>

80106f16 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $185
80106f18:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f1d:	e9 e6 f0 ff ff       	jmp    80106008 <alltraps>

80106f22 <vector186>:
.globl vector186
vector186:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $186
80106f24:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f29:	e9 da f0 ff ff       	jmp    80106008 <alltraps>

80106f2e <vector187>:
.globl vector187
vector187:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $187
80106f30:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f35:	e9 ce f0 ff ff       	jmp    80106008 <alltraps>

80106f3a <vector188>:
.globl vector188
vector188:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $188
80106f3c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f41:	e9 c2 f0 ff ff       	jmp    80106008 <alltraps>

80106f46 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $189
80106f48:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f4d:	e9 b6 f0 ff ff       	jmp    80106008 <alltraps>

80106f52 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $190
80106f54:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f59:	e9 aa f0 ff ff       	jmp    80106008 <alltraps>

80106f5e <vector191>:
.globl vector191
vector191:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $191
80106f60:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f65:	e9 9e f0 ff ff       	jmp    80106008 <alltraps>

80106f6a <vector192>:
.globl vector192
vector192:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $192
80106f6c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f71:	e9 92 f0 ff ff       	jmp    80106008 <alltraps>

80106f76 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $193
80106f78:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f7d:	e9 86 f0 ff ff       	jmp    80106008 <alltraps>

80106f82 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $194
80106f84:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f89:	e9 7a f0 ff ff       	jmp    80106008 <alltraps>

80106f8e <vector195>:
.globl vector195
vector195:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $195
80106f90:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f95:	e9 6e f0 ff ff       	jmp    80106008 <alltraps>

80106f9a <vector196>:
.globl vector196
vector196:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $196
80106f9c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106fa1:	e9 62 f0 ff ff       	jmp    80106008 <alltraps>

80106fa6 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $197
80106fa8:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106fad:	e9 56 f0 ff ff       	jmp    80106008 <alltraps>

80106fb2 <vector198>:
.globl vector198
vector198:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $198
80106fb4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106fb9:	e9 4a f0 ff ff       	jmp    80106008 <alltraps>

80106fbe <vector199>:
.globl vector199
vector199:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $199
80106fc0:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106fc5:	e9 3e f0 ff ff       	jmp    80106008 <alltraps>

80106fca <vector200>:
.globl vector200
vector200:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $200
80106fcc:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fd1:	e9 32 f0 ff ff       	jmp    80106008 <alltraps>

80106fd6 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $201
80106fd8:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fdd:	e9 26 f0 ff ff       	jmp    80106008 <alltraps>

80106fe2 <vector202>:
.globl vector202
vector202:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $202
80106fe4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106fe9:	e9 1a f0 ff ff       	jmp    80106008 <alltraps>

80106fee <vector203>:
.globl vector203
vector203:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $203
80106ff0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ff5:	e9 0e f0 ff ff       	jmp    80106008 <alltraps>

80106ffa <vector204>:
.globl vector204
vector204:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $204
80106ffc:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107001:	e9 02 f0 ff ff       	jmp    80106008 <alltraps>

80107006 <vector205>:
.globl vector205
vector205:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $205
80107008:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010700d:	e9 f6 ef ff ff       	jmp    80106008 <alltraps>

80107012 <vector206>:
.globl vector206
vector206:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $206
80107014:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107019:	e9 ea ef ff ff       	jmp    80106008 <alltraps>

8010701e <vector207>:
.globl vector207
vector207:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $207
80107020:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107025:	e9 de ef ff ff       	jmp    80106008 <alltraps>

8010702a <vector208>:
.globl vector208
vector208:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $208
8010702c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107031:	e9 d2 ef ff ff       	jmp    80106008 <alltraps>

80107036 <vector209>:
.globl vector209
vector209:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $209
80107038:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010703d:	e9 c6 ef ff ff       	jmp    80106008 <alltraps>

80107042 <vector210>:
.globl vector210
vector210:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $210
80107044:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107049:	e9 ba ef ff ff       	jmp    80106008 <alltraps>

8010704e <vector211>:
.globl vector211
vector211:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $211
80107050:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107055:	e9 ae ef ff ff       	jmp    80106008 <alltraps>

8010705a <vector212>:
.globl vector212
vector212:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $212
8010705c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107061:	e9 a2 ef ff ff       	jmp    80106008 <alltraps>

80107066 <vector213>:
.globl vector213
vector213:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $213
80107068:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010706d:	e9 96 ef ff ff       	jmp    80106008 <alltraps>

80107072 <vector214>:
.globl vector214
vector214:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $214
80107074:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107079:	e9 8a ef ff ff       	jmp    80106008 <alltraps>

8010707e <vector215>:
.globl vector215
vector215:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $215
80107080:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107085:	e9 7e ef ff ff       	jmp    80106008 <alltraps>

8010708a <vector216>:
.globl vector216
vector216:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $216
8010708c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107091:	e9 72 ef ff ff       	jmp    80106008 <alltraps>

80107096 <vector217>:
.globl vector217
vector217:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $217
80107098:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010709d:	e9 66 ef ff ff       	jmp    80106008 <alltraps>

801070a2 <vector218>:
.globl vector218
vector218:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $218
801070a4:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070a9:	e9 5a ef ff ff       	jmp    80106008 <alltraps>

801070ae <vector219>:
.globl vector219
vector219:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $219
801070b0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070b5:	e9 4e ef ff ff       	jmp    80106008 <alltraps>

801070ba <vector220>:
.globl vector220
vector220:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $220
801070bc:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070c1:	e9 42 ef ff ff       	jmp    80106008 <alltraps>

801070c6 <vector221>:
.globl vector221
vector221:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $221
801070c8:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070cd:	e9 36 ef ff ff       	jmp    80106008 <alltraps>

801070d2 <vector222>:
.globl vector222
vector222:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $222
801070d4:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070d9:	e9 2a ef ff ff       	jmp    80106008 <alltraps>

801070de <vector223>:
.globl vector223
vector223:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $223
801070e0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070e5:	e9 1e ef ff ff       	jmp    80106008 <alltraps>

801070ea <vector224>:
.globl vector224
vector224:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $224
801070ec:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070f1:	e9 12 ef ff ff       	jmp    80106008 <alltraps>

801070f6 <vector225>:
.globl vector225
vector225:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $225
801070f8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070fd:	e9 06 ef ff ff       	jmp    80106008 <alltraps>

80107102 <vector226>:
.globl vector226
vector226:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $226
80107104:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107109:	e9 fa ee ff ff       	jmp    80106008 <alltraps>

8010710e <vector227>:
.globl vector227
vector227:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $227
80107110:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107115:	e9 ee ee ff ff       	jmp    80106008 <alltraps>

8010711a <vector228>:
.globl vector228
vector228:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $228
8010711c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107121:	e9 e2 ee ff ff       	jmp    80106008 <alltraps>

80107126 <vector229>:
.globl vector229
vector229:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $229
80107128:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010712d:	e9 d6 ee ff ff       	jmp    80106008 <alltraps>

80107132 <vector230>:
.globl vector230
vector230:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $230
80107134:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107139:	e9 ca ee ff ff       	jmp    80106008 <alltraps>

8010713e <vector231>:
.globl vector231
vector231:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $231
80107140:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107145:	e9 be ee ff ff       	jmp    80106008 <alltraps>

8010714a <vector232>:
.globl vector232
vector232:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $232
8010714c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107151:	e9 b2 ee ff ff       	jmp    80106008 <alltraps>

80107156 <vector233>:
.globl vector233
vector233:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $233
80107158:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010715d:	e9 a6 ee ff ff       	jmp    80106008 <alltraps>

80107162 <vector234>:
.globl vector234
vector234:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $234
80107164:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107169:	e9 9a ee ff ff       	jmp    80106008 <alltraps>

8010716e <vector235>:
.globl vector235
vector235:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $235
80107170:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107175:	e9 8e ee ff ff       	jmp    80106008 <alltraps>

8010717a <vector236>:
.globl vector236
vector236:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $236
8010717c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107181:	e9 82 ee ff ff       	jmp    80106008 <alltraps>

80107186 <vector237>:
.globl vector237
vector237:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $237
80107188:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010718d:	e9 76 ee ff ff       	jmp    80106008 <alltraps>

80107192 <vector238>:
.globl vector238
vector238:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $238
80107194:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107199:	e9 6a ee ff ff       	jmp    80106008 <alltraps>

8010719e <vector239>:
.globl vector239
vector239:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $239
801071a0:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071a5:	e9 5e ee ff ff       	jmp    80106008 <alltraps>

801071aa <vector240>:
.globl vector240
vector240:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $240
801071ac:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071b1:	e9 52 ee ff ff       	jmp    80106008 <alltraps>

801071b6 <vector241>:
.globl vector241
vector241:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $241
801071b8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071bd:	e9 46 ee ff ff       	jmp    80106008 <alltraps>

801071c2 <vector242>:
.globl vector242
vector242:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $242
801071c4:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071c9:	e9 3a ee ff ff       	jmp    80106008 <alltraps>

801071ce <vector243>:
.globl vector243
vector243:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $243
801071d0:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071d5:	e9 2e ee ff ff       	jmp    80106008 <alltraps>

801071da <vector244>:
.globl vector244
vector244:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $244
801071dc:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071e1:	e9 22 ee ff ff       	jmp    80106008 <alltraps>

801071e6 <vector245>:
.globl vector245
vector245:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $245
801071e8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071ed:	e9 16 ee ff ff       	jmp    80106008 <alltraps>

801071f2 <vector246>:
.globl vector246
vector246:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $246
801071f4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071f9:	e9 0a ee ff ff       	jmp    80106008 <alltraps>

801071fe <vector247>:
.globl vector247
vector247:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $247
80107200:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107205:	e9 fe ed ff ff       	jmp    80106008 <alltraps>

8010720a <vector248>:
.globl vector248
vector248:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $248
8010720c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107211:	e9 f2 ed ff ff       	jmp    80106008 <alltraps>

80107216 <vector249>:
.globl vector249
vector249:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $249
80107218:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010721d:	e9 e6 ed ff ff       	jmp    80106008 <alltraps>

80107222 <vector250>:
.globl vector250
vector250:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $250
80107224:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107229:	e9 da ed ff ff       	jmp    80106008 <alltraps>

8010722e <vector251>:
.globl vector251
vector251:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $251
80107230:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107235:	e9 ce ed ff ff       	jmp    80106008 <alltraps>

8010723a <vector252>:
.globl vector252
vector252:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $252
8010723c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107241:	e9 c2 ed ff ff       	jmp    80106008 <alltraps>

80107246 <vector253>:
.globl vector253
vector253:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $253
80107248:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010724d:	e9 b6 ed ff ff       	jmp    80106008 <alltraps>

80107252 <vector254>:
.globl vector254
vector254:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $254
80107254:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107259:	e9 aa ed ff ff       	jmp    80106008 <alltraps>

8010725e <vector255>:
.globl vector255
vector255:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $255
80107260:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107265:	e9 9e ed ff ff       	jmp    80106008 <alltraps>

8010726a <lgdt>:
{
8010726a:	55                   	push   %ebp
8010726b:	89 e5                	mov    %esp,%ebp
8010726d:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107270:	8b 45 0c             	mov    0xc(%ebp),%eax
80107273:	83 e8 01             	sub    $0x1,%eax
80107276:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010727a:	8b 45 08             	mov    0x8(%ebp),%eax
8010727d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107281:	8b 45 08             	mov    0x8(%ebp),%eax
80107284:	c1 e8 10             	shr    $0x10,%eax
80107287:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010728b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010728e:	0f 01 10             	lgdtl  (%eax)
}
80107291:	90                   	nop
80107292:	c9                   	leave  
80107293:	c3                   	ret    

80107294 <ltr>:
{
80107294:	55                   	push   %ebp
80107295:	89 e5                	mov    %esp,%ebp
80107297:	83 ec 04             	sub    $0x4,%esp
8010729a:	8b 45 08             	mov    0x8(%ebp),%eax
8010729d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801072a1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801072a5:	0f 00 d8             	ltr    %ax
}
801072a8:	90                   	nop
801072a9:	c9                   	leave  
801072aa:	c3                   	ret    

801072ab <lcr3>:

static inline void
lcr3(uint val)
{
801072ab:	55                   	push   %ebp
801072ac:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ae:	8b 45 08             	mov    0x8(%ebp),%eax
801072b1:	0f 22 d8             	mov    %eax,%cr3
}
801072b4:	90                   	nop
801072b5:	5d                   	pop    %ebp
801072b6:	c3                   	ret    

801072b7 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801072b7:	55                   	push   %ebp
801072b8:	89 e5                	mov    %esp,%ebp
801072ba:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801072bd:	e8 ed c6 ff ff       	call   801039af <cpuid>
801072c2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801072c8:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
801072cd:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d3:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801072d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072dc:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801072e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e5:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801072e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ec:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072f0:	83 e2 f0             	and    $0xfffffff0,%edx
801072f3:	83 ca 0a             	or     $0xa,%edx
801072f6:	88 50 7d             	mov    %dl,0x7d(%eax)
801072f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072fc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107300:	83 ca 10             	or     $0x10,%edx
80107303:	88 50 7d             	mov    %dl,0x7d(%eax)
80107306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107309:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010730d:	83 e2 9f             	and    $0xffffff9f,%edx
80107310:	88 50 7d             	mov    %dl,0x7d(%eax)
80107313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107316:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010731a:	83 ca 80             	or     $0xffffff80,%edx
8010731d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107323:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107327:	83 ca 0f             	or     $0xf,%edx
8010732a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010732d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107330:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107334:	83 e2 ef             	and    $0xffffffef,%edx
80107337:	88 50 7e             	mov    %dl,0x7e(%eax)
8010733a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107341:	83 e2 df             	and    $0xffffffdf,%edx
80107344:	88 50 7e             	mov    %dl,0x7e(%eax)
80107347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010734e:	83 ca 40             	or     $0x40,%edx
80107351:	88 50 7e             	mov    %dl,0x7e(%eax)
80107354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107357:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010735b:	83 ca 80             	or     $0xffffff80,%edx
8010735e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107364:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107372:	ff ff 
80107374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107377:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010737e:	00 00 
80107380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107383:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010738a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107394:	83 e2 f0             	and    $0xfffffff0,%edx
80107397:	83 ca 02             	or     $0x2,%edx
8010739a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801073a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801073aa:	83 ca 10             	or     $0x10,%edx
801073ad:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801073b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801073bd:	83 e2 9f             	and    $0xffffff9f,%edx
801073c0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801073c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801073d0:	83 ca 80             	or     $0xffffff80,%edx
801073d3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801073d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073dc:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073e3:	83 ca 0f             	or     $0xf,%edx
801073e6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ef:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073f6:	83 e2 ef             	and    $0xffffffef,%edx
801073f9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107402:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107409:	83 e2 df             	and    $0xffffffdf,%edx
8010740c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107415:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010741c:	83 ca 40             	or     $0x40,%edx
8010741f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107428:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010742f:	83 ca 80             	or     $0xffffff80,%edx
80107432:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107445:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
8010744c:	ff ff 
8010744e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107451:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107458:	00 00 
8010745a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745d:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107467:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010746e:	83 e2 f0             	and    $0xfffffff0,%edx
80107471:	83 ca 0a             	or     $0xa,%edx
80107474:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010747a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107484:	83 ca 10             	or     $0x10,%edx
80107487:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010748d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107490:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107497:	83 ca 60             	or     $0x60,%edx
8010749a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801074a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801074aa:	83 ca 80             	or     $0xffffff80,%edx
801074ad:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801074b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074bd:	83 ca 0f             	or     $0xf,%edx
801074c0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074d0:	83 e2 ef             	and    $0xffffffef,%edx
801074d3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074dc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074e3:	83 e2 df             	and    $0xffffffdf,%edx
801074e6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ef:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074f6:	83 ca 40             	or     $0x40,%edx
801074f9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107502:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107509:	83 ca 80             	or     $0xffffff80,%edx
8010750c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107515:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010751c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751f:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107526:	ff ff 
80107528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752b:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107532:	00 00 
80107534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107537:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010753e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107541:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107548:	83 e2 f0             	and    $0xfffffff0,%edx
8010754b:	83 ca 02             	or     $0x2,%edx
8010754e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107557:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010755e:	83 ca 10             	or     $0x10,%edx
80107561:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107571:	83 ca 60             	or     $0x60,%edx
80107574:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010757a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107584:	83 ca 80             	or     $0xffffff80,%edx
80107587:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010758d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107590:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107597:	83 ca 0f             	or     $0xf,%edx
8010759a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801075aa:	83 e2 ef             	and    $0xffffffef,%edx
801075ad:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801075bd:	83 e2 df             	and    $0xffffffdf,%edx
801075c0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801075d0:	83 ca 40             	or     $0x40,%edx
801075d3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075dc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801075e3:	83 ca 80             	or     $0xffffff80,%edx
801075e6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ef:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801075f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f9:	83 c0 70             	add    $0x70,%eax
801075fc:	83 ec 08             	sub    $0x8,%esp
801075ff:	6a 30                	push   $0x30
80107601:	50                   	push   %eax
80107602:	e8 63 fc ff ff       	call   8010726a <lgdt>
80107607:	83 c4 10             	add    $0x10,%esp
}
8010760a:	90                   	nop
8010760b:	c9                   	leave  
8010760c:	c3                   	ret    

8010760d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010760d:	55                   	push   %ebp
8010760e:	89 e5                	mov    %esp,%ebp
80107610:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107613:	8b 45 0c             	mov    0xc(%ebp),%eax
80107616:	c1 e8 16             	shr    $0x16,%eax
80107619:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107620:	8b 45 08             	mov    0x8(%ebp),%eax
80107623:	01 d0                	add    %edx,%eax
80107625:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010762b:	8b 00                	mov    (%eax),%eax
8010762d:	83 e0 01             	and    $0x1,%eax
80107630:	85 c0                	test   %eax,%eax
80107632:	74 14                	je     80107648 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107634:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107637:	8b 00                	mov    (%eax),%eax
80107639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010763e:	05 00 00 00 80       	add    $0x80000000,%eax
80107643:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107646:	eb 42                	jmp    8010768a <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107648:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010764c:	74 0e                	je     8010765c <walkpgdir+0x4f>
8010764e:	e8 32 b1 ff ff       	call   80102785 <kalloc>
80107653:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010765a:	75 07                	jne    80107663 <walkpgdir+0x56>
      return 0;
8010765c:	b8 00 00 00 00       	mov    $0x0,%eax
80107661:	eb 3e                	jmp    801076a1 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107663:	83 ec 04             	sub    $0x4,%esp
80107666:	68 00 10 00 00       	push   $0x1000
8010766b:	6a 00                	push   $0x0
8010766d:	ff 75 f4             	push   -0xc(%ebp)
80107670:	e8 e3 d4 ff ff       	call   80104b58 <memset>
80107675:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767b:	05 00 00 00 80       	add    $0x80000000,%eax
80107680:	83 c8 07             	or     $0x7,%eax
80107683:	89 c2                	mov    %eax,%edx
80107685:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107688:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010768a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010768d:	c1 e8 0c             	shr    $0xc,%eax
80107690:	25 ff 03 00 00       	and    $0x3ff,%eax
80107695:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010769c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769f:	01 d0                	add    %edx,%eax
}
801076a1:	c9                   	leave  
801076a2:	c3                   	ret    

801076a3 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801076a3:	55                   	push   %ebp
801076a4:	89 e5                	mov    %esp,%ebp
801076a6:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801076a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801076ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801076b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801076b7:	8b 45 10             	mov    0x10(%ebp),%eax
801076ba:	01 d0                	add    %edx,%eax
801076bc:	83 e8 01             	sub    $0x1,%eax
801076bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801076c7:	83 ec 04             	sub    $0x4,%esp
801076ca:	6a 01                	push   $0x1
801076cc:	ff 75 f4             	push   -0xc(%ebp)
801076cf:	ff 75 08             	push   0x8(%ebp)
801076d2:	e8 36 ff ff ff       	call   8010760d <walkpgdir>
801076d7:	83 c4 10             	add    $0x10,%esp
801076da:	89 45 ec             	mov    %eax,-0x14(%ebp)
801076dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801076e1:	75 07                	jne    801076ea <mappages+0x47>
      return -1;
801076e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076e8:	eb 47                	jmp    80107731 <mappages+0x8e>
    if(*pte & PTE_P)
801076ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076ed:	8b 00                	mov    (%eax),%eax
801076ef:	83 e0 01             	and    $0x1,%eax
801076f2:	85 c0                	test   %eax,%eax
801076f4:	74 0d                	je     80107703 <mappages+0x60>
      panic("remap");
801076f6:	83 ec 0c             	sub    $0xc,%esp
801076f9:	68 d8 ab 10 80       	push   $0x8010abd8
801076fe:	e8 a6 8e ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
80107703:	8b 45 18             	mov    0x18(%ebp),%eax
80107706:	0b 45 14             	or     0x14(%ebp),%eax
80107709:	83 c8 01             	or     $0x1,%eax
8010770c:	89 c2                	mov    %eax,%edx
8010770e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107711:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107716:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107719:	74 10                	je     8010772b <mappages+0x88>
      break;
    a += PGSIZE;
8010771b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107722:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107729:	eb 9c                	jmp    801076c7 <mappages+0x24>
      break;
8010772b:	90                   	nop
  }
  return 0;
8010772c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107731:	c9                   	leave  
80107732:	c3                   	ret    

80107733 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107733:	55                   	push   %ebp
80107734:	89 e5                	mov    %esp,%ebp
80107736:	53                   	push   %ebx
80107737:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
8010773a:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107741:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
80107747:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
8010774c:	29 d0                	sub    %edx,%eax
8010774e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107751:	a1 68 6f 19 80       	mov    0x80196f68,%eax
80107756:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107759:	8b 15 68 6f 19 80    	mov    0x80196f68,%edx
8010775f:	a1 70 6f 19 80       	mov    0x80196f70,%eax
80107764:	01 d0                	add    %edx,%eax
80107766:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107769:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107773:	83 c0 30             	add    $0x30,%eax
80107776:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107779:	89 10                	mov    %edx,(%eax)
8010777b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010777e:	89 50 04             	mov    %edx,0x4(%eax)
80107781:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107784:	89 50 08             	mov    %edx,0x8(%eax)
80107787:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010778a:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
8010778d:	e8 f3 af ff ff       	call   80102785 <kalloc>
80107792:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107799:	75 07                	jne    801077a2 <setupkvm+0x6f>
    return 0;
8010779b:	b8 00 00 00 00       	mov    $0x0,%eax
801077a0:	eb 78                	jmp    8010781a <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
801077a2:	83 ec 04             	sub    $0x4,%esp
801077a5:	68 00 10 00 00       	push   $0x1000
801077aa:	6a 00                	push   $0x0
801077ac:	ff 75 f0             	push   -0x10(%ebp)
801077af:	e8 a4 d3 ff ff       	call   80104b58 <memset>
801077b4:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077b7:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
801077be:	eb 4e                	jmp    8010780e <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c3:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801077c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c9:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cf:	8b 58 08             	mov    0x8(%eax),%ebx
801077d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d5:	8b 40 04             	mov    0x4(%eax),%eax
801077d8:	29 c3                	sub    %eax,%ebx
801077da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dd:	8b 00                	mov    (%eax),%eax
801077df:	83 ec 0c             	sub    $0xc,%esp
801077e2:	51                   	push   %ecx
801077e3:	52                   	push   %edx
801077e4:	53                   	push   %ebx
801077e5:	50                   	push   %eax
801077e6:	ff 75 f0             	push   -0x10(%ebp)
801077e9:	e8 b5 fe ff ff       	call   801076a3 <mappages>
801077ee:	83 c4 20             	add    $0x20,%esp
801077f1:	85 c0                	test   %eax,%eax
801077f3:	79 15                	jns    8010780a <setupkvm+0xd7>
      freevm(pgdir);
801077f5:	83 ec 0c             	sub    $0xc,%esp
801077f8:	ff 75 f0             	push   -0x10(%ebp)
801077fb:	e8 f5 04 00 00       	call   80107cf5 <freevm>
80107800:	83 c4 10             	add    $0x10,%esp
      return 0;
80107803:	b8 00 00 00 00       	mov    $0x0,%eax
80107808:	eb 10                	jmp    8010781a <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010780a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010780e:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
80107815:	72 a9                	jb     801077c0 <setupkvm+0x8d>
    }
  return pgdir;
80107817:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010781a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010781d:	c9                   	leave  
8010781e:	c3                   	ret    

8010781f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010781f:	55                   	push   %ebp
80107820:	89 e5                	mov    %esp,%ebp
80107822:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107825:	e8 09 ff ff ff       	call   80107733 <setupkvm>
8010782a:	a3 9c 6c 19 80       	mov    %eax,0x80196c9c
  switchkvm();
8010782f:	e8 03 00 00 00       	call   80107837 <switchkvm>
}
80107834:	90                   	nop
80107835:	c9                   	leave  
80107836:	c3                   	ret    

80107837 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107837:	55                   	push   %ebp
80107838:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010783a:	a1 9c 6c 19 80       	mov    0x80196c9c,%eax
8010783f:	05 00 00 00 80       	add    $0x80000000,%eax
80107844:	50                   	push   %eax
80107845:	e8 61 fa ff ff       	call   801072ab <lcr3>
8010784a:	83 c4 04             	add    $0x4,%esp
}
8010784d:	90                   	nop
8010784e:	c9                   	leave  
8010784f:	c3                   	ret    

80107850 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	56                   	push   %esi
80107854:	53                   	push   %ebx
80107855:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107858:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010785c:	75 0d                	jne    8010786b <switchuvm+0x1b>
    panic("switchuvm: no process");
8010785e:	83 ec 0c             	sub    $0xc,%esp
80107861:	68 de ab 10 80       	push   $0x8010abde
80107866:	e8 3e 8d ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
8010786b:	8b 45 08             	mov    0x8(%ebp),%eax
8010786e:	8b 40 08             	mov    0x8(%eax),%eax
80107871:	85 c0                	test   %eax,%eax
80107873:	75 0d                	jne    80107882 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107875:	83 ec 0c             	sub    $0xc,%esp
80107878:	68 f4 ab 10 80       	push   $0x8010abf4
8010787d:	e8 27 8d ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107882:	8b 45 08             	mov    0x8(%ebp),%eax
80107885:	8b 40 04             	mov    0x4(%eax),%eax
80107888:	85 c0                	test   %eax,%eax
8010788a:	75 0d                	jne    80107899 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
8010788c:	83 ec 0c             	sub    $0xc,%esp
8010788f:	68 09 ac 10 80       	push   $0x8010ac09
80107894:	e8 10 8d ff ff       	call   801005a9 <panic>

  pushcli();
80107899:	e8 af d1 ff ff       	call   80104a4d <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010789e:	e8 27 c1 ff ff       	call   801039ca <mycpu>
801078a3:	89 c3                	mov    %eax,%ebx
801078a5:	e8 20 c1 ff ff       	call   801039ca <mycpu>
801078aa:	83 c0 08             	add    $0x8,%eax
801078ad:	89 c6                	mov    %eax,%esi
801078af:	e8 16 c1 ff ff       	call   801039ca <mycpu>
801078b4:	83 c0 08             	add    $0x8,%eax
801078b7:	c1 e8 10             	shr    $0x10,%eax
801078ba:	88 45 f7             	mov    %al,-0x9(%ebp)
801078bd:	e8 08 c1 ff ff       	call   801039ca <mycpu>
801078c2:	83 c0 08             	add    $0x8,%eax
801078c5:	c1 e8 18             	shr    $0x18,%eax
801078c8:	89 c2                	mov    %eax,%edx
801078ca:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801078d1:	67 00 
801078d3:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801078da:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801078de:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801078e4:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078eb:	83 e0 f0             	and    $0xfffffff0,%eax
801078ee:	83 c8 09             	or     $0x9,%eax
801078f1:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078f7:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078fe:	83 c8 10             	or     $0x10,%eax
80107901:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107907:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010790e:	83 e0 9f             	and    $0xffffff9f,%eax
80107911:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107917:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010791e:	83 c8 80             	or     $0xffffff80,%eax
80107921:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107927:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010792e:	83 e0 f0             	and    $0xfffffff0,%eax
80107931:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107937:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010793e:	83 e0 ef             	and    $0xffffffef,%eax
80107941:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107947:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010794e:	83 e0 df             	and    $0xffffffdf,%eax
80107951:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107957:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010795e:	83 c8 40             	or     $0x40,%eax
80107961:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107967:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010796e:	83 e0 7f             	and    $0x7f,%eax
80107971:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107977:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010797d:	e8 48 c0 ff ff       	call   801039ca <mycpu>
80107982:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107989:	83 e2 ef             	and    $0xffffffef,%edx
8010798c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107992:	e8 33 c0 ff ff       	call   801039ca <mycpu>
80107997:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010799d:	8b 45 08             	mov    0x8(%ebp),%eax
801079a0:	8b 40 08             	mov    0x8(%eax),%eax
801079a3:	89 c3                	mov    %eax,%ebx
801079a5:	e8 20 c0 ff ff       	call   801039ca <mycpu>
801079aa:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801079b0:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801079b3:	e8 12 c0 ff ff       	call   801039ca <mycpu>
801079b8:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801079be:	83 ec 0c             	sub    $0xc,%esp
801079c1:	6a 28                	push   $0x28
801079c3:	e8 cc f8 ff ff       	call   80107294 <ltr>
801079c8:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801079cb:	8b 45 08             	mov    0x8(%ebp),%eax
801079ce:	8b 40 04             	mov    0x4(%eax),%eax
801079d1:	05 00 00 00 80       	add    $0x80000000,%eax
801079d6:	83 ec 0c             	sub    $0xc,%esp
801079d9:	50                   	push   %eax
801079da:	e8 cc f8 ff ff       	call   801072ab <lcr3>
801079df:	83 c4 10             	add    $0x10,%esp
  popcli();
801079e2:	e8 b3 d0 ff ff       	call   80104a9a <popcli>
}
801079e7:	90                   	nop
801079e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079eb:	5b                   	pop    %ebx
801079ec:	5e                   	pop    %esi
801079ed:	5d                   	pop    %ebp
801079ee:	c3                   	ret    

801079ef <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801079ef:	55                   	push   %ebp
801079f0:	89 e5                	mov    %esp,%ebp
801079f2:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801079f5:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801079fc:	76 0d                	jbe    80107a0b <inituvm+0x1c>
    panic("inituvm: more than a page");
801079fe:	83 ec 0c             	sub    $0xc,%esp
80107a01:	68 1d ac 10 80       	push   $0x8010ac1d
80107a06:	e8 9e 8b ff ff       	call   801005a9 <panic>
  mem = kalloc();
80107a0b:	e8 75 ad ff ff       	call   80102785 <kalloc>
80107a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107a13:	83 ec 04             	sub    $0x4,%esp
80107a16:	68 00 10 00 00       	push   $0x1000
80107a1b:	6a 00                	push   $0x0
80107a1d:	ff 75 f4             	push   -0xc(%ebp)
80107a20:	e8 33 d1 ff ff       	call   80104b58 <memset>
80107a25:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2b:	05 00 00 00 80       	add    $0x80000000,%eax
80107a30:	83 ec 0c             	sub    $0xc,%esp
80107a33:	6a 06                	push   $0x6
80107a35:	50                   	push   %eax
80107a36:	68 00 10 00 00       	push   $0x1000
80107a3b:	6a 00                	push   $0x0
80107a3d:	ff 75 08             	push   0x8(%ebp)
80107a40:	e8 5e fc ff ff       	call   801076a3 <mappages>
80107a45:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107a48:	83 ec 04             	sub    $0x4,%esp
80107a4b:	ff 75 10             	push   0x10(%ebp)
80107a4e:	ff 75 0c             	push   0xc(%ebp)
80107a51:	ff 75 f4             	push   -0xc(%ebp)
80107a54:	e8 be d1 ff ff       	call   80104c17 <memmove>
80107a59:	83 c4 10             	add    $0x10,%esp
}
80107a5c:	90                   	nop
80107a5d:	c9                   	leave  
80107a5e:	c3                   	ret    

80107a5f <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107a5f:	55                   	push   %ebp
80107a60:	89 e5                	mov    %esp,%ebp
80107a62:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a65:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a68:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a6d:	85 c0                	test   %eax,%eax
80107a6f:	74 0d                	je     80107a7e <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107a71:	83 ec 0c             	sub    $0xc,%esp
80107a74:	68 38 ac 10 80       	push   $0x8010ac38
80107a79:	e8 2b 8b ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a85:	e9 8f 00 00 00       	jmp    80107b19 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a90:	01 d0                	add    %edx,%eax
80107a92:	83 ec 04             	sub    $0x4,%esp
80107a95:	6a 00                	push   $0x0
80107a97:	50                   	push   %eax
80107a98:	ff 75 08             	push   0x8(%ebp)
80107a9b:	e8 6d fb ff ff       	call   8010760d <walkpgdir>
80107aa0:	83 c4 10             	add    $0x10,%esp
80107aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107aa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107aaa:	75 0d                	jne    80107ab9 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107aac:	83 ec 0c             	sub    $0xc,%esp
80107aaf:	68 5b ac 10 80       	push   $0x8010ac5b
80107ab4:	e8 f0 8a ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107abc:	8b 00                	mov    (%eax),%eax
80107abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ac3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107ac6:	8b 45 18             	mov    0x18(%ebp),%eax
80107ac9:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107acc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107ad1:	77 0b                	ja     80107ade <loaduvm+0x7f>
      n = sz - i;
80107ad3:	8b 45 18             	mov    0x18(%ebp),%eax
80107ad6:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107adc:	eb 07                	jmp    80107ae5 <loaduvm+0x86>
    else
      n = PGSIZE;
80107ade:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ae5:	8b 55 14             	mov    0x14(%ebp),%edx
80107ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aeb:	01 d0                	add    %edx,%eax
80107aed:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107af0:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107af6:	ff 75 f0             	push   -0x10(%ebp)
80107af9:	50                   	push   %eax
80107afa:	52                   	push   %edx
80107afb:	ff 75 10             	push   0x10(%ebp)
80107afe:	e8 b8 a3 ff ff       	call   80101ebb <readi>
80107b03:	83 c4 10             	add    $0x10,%esp
80107b06:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107b09:	74 07                	je     80107b12 <loaduvm+0xb3>
      return -1;
80107b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b10:	eb 18                	jmp    80107b2a <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107b12:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1c:	3b 45 18             	cmp    0x18(%ebp),%eax
80107b1f:	0f 82 65 ff ff ff    	jb     80107a8a <loaduvm+0x2b>
  }
  return 0;
80107b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b2a:	c9                   	leave  
80107b2b:	c3                   	ret    

80107b2c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107b2c:	55                   	push   %ebp
80107b2d:	89 e5                	mov    %esp,%ebp
80107b2f:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107b32:	8b 45 10             	mov    0x10(%ebp),%eax
80107b35:	85 c0                	test   %eax,%eax
80107b37:	79 0a                	jns    80107b43 <allocuvm+0x17>
    return 0;
80107b39:	b8 00 00 00 00       	mov    $0x0,%eax
80107b3e:	e9 ec 00 00 00       	jmp    80107c2f <allocuvm+0x103>
  if(newsz < oldsz)
80107b43:	8b 45 10             	mov    0x10(%ebp),%eax
80107b46:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b49:	73 08                	jae    80107b53 <allocuvm+0x27>
    return oldsz;
80107b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b4e:	e9 dc 00 00 00       	jmp    80107c2f <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107b53:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b56:	05 ff 0f 00 00       	add    $0xfff,%eax
80107b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107b63:	e9 b8 00 00 00       	jmp    80107c20 <allocuvm+0xf4>
    mem = kalloc();
80107b68:	e8 18 ac ff ff       	call   80102785 <kalloc>
80107b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107b70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b74:	75 2e                	jne    80107ba4 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107b76:	83 ec 0c             	sub    $0xc,%esp
80107b79:	68 79 ac 10 80       	push   $0x8010ac79
80107b7e:	e8 71 88 ff ff       	call   801003f4 <cprintf>
80107b83:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107b86:	83 ec 04             	sub    $0x4,%esp
80107b89:	ff 75 0c             	push   0xc(%ebp)
80107b8c:	ff 75 10             	push   0x10(%ebp)
80107b8f:	ff 75 08             	push   0x8(%ebp)
80107b92:	e8 9a 00 00 00       	call   80107c31 <deallocuvm>
80107b97:	83 c4 10             	add    $0x10,%esp
      return 0;
80107b9a:	b8 00 00 00 00       	mov    $0x0,%eax
80107b9f:	e9 8b 00 00 00       	jmp    80107c2f <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107ba4:	83 ec 04             	sub    $0x4,%esp
80107ba7:	68 00 10 00 00       	push   $0x1000
80107bac:	6a 00                	push   $0x0
80107bae:	ff 75 f0             	push   -0x10(%ebp)
80107bb1:	e8 a2 cf ff ff       	call   80104b58 <memset>
80107bb6:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bbc:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc5:	83 ec 0c             	sub    $0xc,%esp
80107bc8:	6a 06                	push   $0x6
80107bca:	52                   	push   %edx
80107bcb:	68 00 10 00 00       	push   $0x1000
80107bd0:	50                   	push   %eax
80107bd1:	ff 75 08             	push   0x8(%ebp)
80107bd4:	e8 ca fa ff ff       	call   801076a3 <mappages>
80107bd9:	83 c4 20             	add    $0x20,%esp
80107bdc:	85 c0                	test   %eax,%eax
80107bde:	79 39                	jns    80107c19 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107be0:	83 ec 0c             	sub    $0xc,%esp
80107be3:	68 91 ac 10 80       	push   $0x8010ac91
80107be8:	e8 07 88 ff ff       	call   801003f4 <cprintf>
80107bed:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107bf0:	83 ec 04             	sub    $0x4,%esp
80107bf3:	ff 75 0c             	push   0xc(%ebp)
80107bf6:	ff 75 10             	push   0x10(%ebp)
80107bf9:	ff 75 08             	push   0x8(%ebp)
80107bfc:	e8 30 00 00 00       	call   80107c31 <deallocuvm>
80107c01:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107c04:	83 ec 0c             	sub    $0xc,%esp
80107c07:	ff 75 f0             	push   -0x10(%ebp)
80107c0a:	e8 dc aa ff ff       	call   801026eb <kfree>
80107c0f:	83 c4 10             	add    $0x10,%esp
      return 0;
80107c12:	b8 00 00 00 00       	mov    $0x0,%eax
80107c17:	eb 16                	jmp    80107c2f <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107c19:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c23:	3b 45 10             	cmp    0x10(%ebp),%eax
80107c26:	0f 82 3c ff ff ff    	jb     80107b68 <allocuvm+0x3c>
    }
  }
  return newsz;
80107c2c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107c2f:	c9                   	leave  
80107c30:	c3                   	ret    

80107c31 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c31:	55                   	push   %ebp
80107c32:	89 e5                	mov    %esp,%ebp
80107c34:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107c37:	8b 45 10             	mov    0x10(%ebp),%eax
80107c3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c3d:	72 08                	jb     80107c47 <deallocuvm+0x16>
    return oldsz;
80107c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c42:	e9 ac 00 00 00       	jmp    80107cf3 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107c47:	8b 45 10             	mov    0x10(%ebp),%eax
80107c4a:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c57:	e9 88 00 00 00       	jmp    80107ce4 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5f:	83 ec 04             	sub    $0x4,%esp
80107c62:	6a 00                	push   $0x0
80107c64:	50                   	push   %eax
80107c65:	ff 75 08             	push   0x8(%ebp)
80107c68:	e8 a0 f9 ff ff       	call   8010760d <walkpgdir>
80107c6d:	83 c4 10             	add    $0x10,%esp
80107c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c77:	75 16                	jne    80107c8f <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7c:	c1 e8 16             	shr    $0x16,%eax
80107c7f:	83 c0 01             	add    $0x1,%eax
80107c82:	c1 e0 16             	shl    $0x16,%eax
80107c85:	2d 00 10 00 00       	sub    $0x1000,%eax
80107c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c8d:	eb 4e                	jmp    80107cdd <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c92:	8b 00                	mov    (%eax),%eax
80107c94:	83 e0 01             	and    $0x1,%eax
80107c97:	85 c0                	test   %eax,%eax
80107c99:	74 42                	je     80107cdd <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c9e:	8b 00                	mov    (%eax),%eax
80107ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107ca8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cac:	75 0d                	jne    80107cbb <deallocuvm+0x8a>
        panic("kfree");
80107cae:	83 ec 0c             	sub    $0xc,%esp
80107cb1:	68 ad ac 10 80       	push   $0x8010acad
80107cb6:	e8 ee 88 ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cbe:	05 00 00 00 80       	add    $0x80000000,%eax
80107cc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107cc6:	83 ec 0c             	sub    $0xc,%esp
80107cc9:	ff 75 e8             	push   -0x18(%ebp)
80107ccc:	e8 1a aa ff ff       	call   801026eb <kfree>
80107cd1:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107cdd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce7:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cea:	0f 82 6c ff ff ff    	jb     80107c5c <deallocuvm+0x2b>
    }
  }
  return newsz;
80107cf0:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107cf3:	c9                   	leave  
80107cf4:	c3                   	ret    

80107cf5 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107cf5:	55                   	push   %ebp
80107cf6:	89 e5                	mov    %esp,%ebp
80107cf8:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107cfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107cff:	75 0d                	jne    80107d0e <freevm+0x19>
    panic("freevm: no pgdir");
80107d01:	83 ec 0c             	sub    $0xc,%esp
80107d04:	68 b3 ac 10 80       	push   $0x8010acb3
80107d09:	e8 9b 88 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107d0e:	83 ec 04             	sub    $0x4,%esp
80107d11:	6a 00                	push   $0x0
80107d13:	68 00 00 00 80       	push   $0x80000000
80107d18:	ff 75 08             	push   0x8(%ebp)
80107d1b:	e8 11 ff ff ff       	call   80107c31 <deallocuvm>
80107d20:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107d2a:	eb 48                	jmp    80107d74 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d36:	8b 45 08             	mov    0x8(%ebp),%eax
80107d39:	01 d0                	add    %edx,%eax
80107d3b:	8b 00                	mov    (%eax),%eax
80107d3d:	83 e0 01             	and    $0x1,%eax
80107d40:	85 c0                	test   %eax,%eax
80107d42:	74 2c                	je     80107d70 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80107d51:	01 d0                	add    %edx,%eax
80107d53:	8b 00                	mov    (%eax),%eax
80107d55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d5a:	05 00 00 00 80       	add    $0x80000000,%eax
80107d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107d62:	83 ec 0c             	sub    $0xc,%esp
80107d65:	ff 75 f0             	push   -0x10(%ebp)
80107d68:	e8 7e a9 ff ff       	call   801026eb <kfree>
80107d6d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107d74:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107d7b:	76 af                	jbe    80107d2c <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d7d:	83 ec 0c             	sub    $0xc,%esp
80107d80:	ff 75 08             	push   0x8(%ebp)
80107d83:	e8 63 a9 ff ff       	call   801026eb <kfree>
80107d88:	83 c4 10             	add    $0x10,%esp
}
80107d8b:	90                   	nop
80107d8c:	c9                   	leave  
80107d8d:	c3                   	ret    

80107d8e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d8e:	55                   	push   %ebp
80107d8f:	89 e5                	mov    %esp,%ebp
80107d91:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d94:	83 ec 04             	sub    $0x4,%esp
80107d97:	6a 00                	push   $0x0
80107d99:	ff 75 0c             	push   0xc(%ebp)
80107d9c:	ff 75 08             	push   0x8(%ebp)
80107d9f:	e8 69 f8 ff ff       	call   8010760d <walkpgdir>
80107da4:	83 c4 10             	add    $0x10,%esp
80107da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107dae:	75 0d                	jne    80107dbd <clearpteu+0x2f>
    panic("clearpteu");
80107db0:	83 ec 0c             	sub    $0xc,%esp
80107db3:	68 c4 ac 10 80       	push   $0x8010acc4
80107db8:	e8 ec 87 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc0:	8b 00                	mov    (%eax),%eax
80107dc2:	83 e0 fb             	and    $0xfffffffb,%eax
80107dc5:	89 c2                	mov    %eax,%edx
80107dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dca:	89 10                	mov    %edx,(%eax)
}
80107dcc:	90                   	nop
80107dcd:	c9                   	leave  
80107dce:	c3                   	ret    

80107dcf <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107dcf:	55                   	push   %ebp
80107dd0:	89 e5                	mov    %esp,%ebp
80107dd2:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107dd5:	e8 59 f9 ff ff       	call   80107733 <setupkvm>
80107dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ddd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107de1:	75 0a                	jne    80107ded <copyuvm+0x1e>
    return 0;
80107de3:	b8 00 00 00 00       	mov    $0x0,%eax
80107de8:	e9 b6 01 00 00       	jmp    80107fa3 <copyuvm+0x1d4>
  for(i = 0; i < sz; i += PGSIZE){
80107ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107df4:	e9 af 00 00 00       	jmp    80107ea8 <copyuvm+0xd9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfc:	83 ec 04             	sub    $0x4,%esp
80107dff:	6a 00                	push   $0x0
80107e01:	50                   	push   %eax
80107e02:	ff 75 08             	push   0x8(%ebp)
80107e05:	e8 03 f8 ff ff       	call   8010760d <walkpgdir>
80107e0a:	83 c4 10             	add    $0x10,%esp
80107e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107e10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107e14:	0f 84 83 00 00 00    	je     80107e9d <copyuvm+0xce>
      continue;
    if(!(*pte & PTE_P))
80107e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e1d:	8b 00                	mov    (%eax),%eax
80107e1f:	83 e0 01             	and    $0x1,%eax
80107e22:	85 c0                	test   %eax,%eax
80107e24:	74 7a                	je     80107ea0 <copyuvm+0xd1>
      continue;
    pa = PTE_ADDR(*pte);
80107e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e29:	8b 00                	mov    (%eax),%eax
80107e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80107e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e36:	8b 00                	mov    (%eax),%eax
80107e38:	25 ff 0f 00 00       	and    $0xfff,%eax
80107e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107e40:	e8 40 a9 ff ff       	call   80102785 <kalloc>
80107e45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107e4c:	0f 84 34 01 00 00    	je     80107f86 <copyuvm+0x1b7>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e55:	05 00 00 00 80       	add    $0x80000000,%eax
80107e5a:	83 ec 04             	sub    $0x4,%esp
80107e5d:	68 00 10 00 00       	push   $0x1000
80107e62:	50                   	push   %eax
80107e63:	ff 75 dc             	push   -0x24(%ebp)
80107e66:	e8 ac cd ff ff       	call   80104c17 <memmove>
80107e6b:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107e6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107e74:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7d:	83 ec 0c             	sub    $0xc,%esp
80107e80:	52                   	push   %edx
80107e81:	51                   	push   %ecx
80107e82:	68 00 10 00 00       	push   $0x1000
80107e87:	50                   	push   %eax
80107e88:	ff 75 f0             	push   -0x10(%ebp)
80107e8b:	e8 13 f8 ff ff       	call   801076a3 <mappages>
80107e90:	83 c4 20             	add    $0x20,%esp
80107e93:	85 c0                	test   %eax,%eax
80107e95:	0f 88 ee 00 00 00    	js     80107f89 <copyuvm+0x1ba>
80107e9b:	eb 04                	jmp    80107ea1 <copyuvm+0xd2>
      continue;
80107e9d:	90                   	nop
80107e9e:	eb 01                	jmp    80107ea1 <copyuvm+0xd2>
      continue;
80107ea0:	90                   	nop
  for(i = 0; i < sz; i += PGSIZE){
80107ea1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eab:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107eae:	0f 82 45 ff ff ff    	jb     80107df9 <copyuvm+0x2a>
      goto bad;
  }
  
  
  
  uint t = KERNBASE-1;
80107eb4:	c7 45 ec ff ff ff 7f 	movl   $0x7fffffff,-0x14(%ebp)
  t = PGROUNDDOWN(t);
80107ebb:	81 65 ec 00 f0 ff ff 	andl   $0xfffff000,-0x14(%ebp)
  for(i = t; i > t - PGSIZE; i -= PGSIZE){
80107ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ec8:	e9 a3 00 00 00       	jmp    80107f70 <copyuvm+0x1a1>
    
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed0:	83 ec 04             	sub    $0x4,%esp
80107ed3:	6a 00                	push   $0x0
80107ed5:	50                   	push   %eax
80107ed6:	ff 75 08             	push   0x8(%ebp)
80107ed9:	e8 2f f7 ff ff       	call   8010760d <walkpgdir>
80107ede:	83 c4 10             	add    $0x10,%esp
80107ee1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107ee4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107ee8:	74 7b                	je     80107f65 <copyuvm+0x196>
      continue;
    if(!(*pte & PTE_P))
80107eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107eed:	8b 00                	mov    (%eax),%eax
80107eef:	83 e0 01             	and    $0x1,%eax
80107ef2:	85 c0                	test   %eax,%eax
80107ef4:	74 72                	je     80107f68 <copyuvm+0x199>
      continue;
    pa = PTE_ADDR(*pte);
80107ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ef9:	8b 00                	mov    (%eax),%eax
80107efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80107f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f06:	8b 00                	mov    (%eax),%eax
80107f08:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107f10:	e8 70 a8 ff ff       	call   80102785 <kalloc>
80107f15:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107f18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107f1c:	74 6e                	je     80107f8c <copyuvm+0x1bd>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f21:	05 00 00 00 80       	add    $0x80000000,%eax
80107f26:	83 ec 04             	sub    $0x4,%esp
80107f29:	68 00 10 00 00       	push   $0x1000
80107f2e:	50                   	push   %eax
80107f2f:	ff 75 dc             	push   -0x24(%ebp)
80107f32:	e8 e0 cc ff ff       	call   80104c17 <memmove>
80107f37:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107f3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107f40:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f49:	83 ec 0c             	sub    $0xc,%esp
80107f4c:	52                   	push   %edx
80107f4d:	51                   	push   %ecx
80107f4e:	68 00 10 00 00       	push   $0x1000
80107f53:	50                   	push   %eax
80107f54:	ff 75 f0             	push   -0x10(%ebp)
80107f57:	e8 47 f7 ff ff       	call   801076a3 <mappages>
80107f5c:	83 c4 20             	add    $0x20,%esp
80107f5f:	85 c0                	test   %eax,%eax
80107f61:	78 2c                	js     80107f8f <copyuvm+0x1c0>
80107f63:	eb 04                	jmp    80107f69 <copyuvm+0x19a>
      continue;
80107f65:	90                   	nop
80107f66:	eb 01                	jmp    80107f69 <copyuvm+0x19a>
      continue;
80107f68:	90                   	nop
  for(i = t; i > t - PGSIZE; i -= PGSIZE){
80107f69:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
80107f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f73:	2d 00 10 00 00       	sub    $0x1000,%eax
80107f78:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107f7b:	0f 87 4c ff ff ff    	ja     80107ecd <copyuvm+0xfe>
      goto bad;
  }
  
  return d;
80107f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f84:	eb 1d                	jmp    80107fa3 <copyuvm+0x1d4>
      goto bad;
80107f86:	90                   	nop
80107f87:	eb 07                	jmp    80107f90 <copyuvm+0x1c1>
      goto bad;
80107f89:	90                   	nop
80107f8a:	eb 04                	jmp    80107f90 <copyuvm+0x1c1>
      goto bad;
80107f8c:	90                   	nop
80107f8d:	eb 01                	jmp    80107f90 <copyuvm+0x1c1>
      goto bad;
80107f8f:	90                   	nop

bad:
  freevm(d);
80107f90:	83 ec 0c             	sub    $0xc,%esp
80107f93:	ff 75 f0             	push   -0x10(%ebp)
80107f96:	e8 5a fd ff ff       	call   80107cf5 <freevm>
80107f9b:	83 c4 10             	add    $0x10,%esp
  return 0;
80107f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fa3:	c9                   	leave  
80107fa4:	c3                   	ret    

80107fa5 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107fa5:	55                   	push   %ebp
80107fa6:	89 e5                	mov    %esp,%ebp
80107fa8:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fab:	83 ec 04             	sub    $0x4,%esp
80107fae:	6a 00                	push   $0x0
80107fb0:	ff 75 0c             	push   0xc(%ebp)
80107fb3:	ff 75 08             	push   0x8(%ebp)
80107fb6:	e8 52 f6 ff ff       	call   8010760d <walkpgdir>
80107fbb:	83 c4 10             	add    $0x10,%esp
80107fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	8b 00                	mov    (%eax),%eax
80107fc6:	83 e0 01             	and    $0x1,%eax
80107fc9:	85 c0                	test   %eax,%eax
80107fcb:	75 07                	jne    80107fd4 <uva2ka+0x2f>
    return 0;
80107fcd:	b8 00 00 00 00       	mov    $0x0,%eax
80107fd2:	eb 22                	jmp    80107ff6 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd7:	8b 00                	mov    (%eax),%eax
80107fd9:	83 e0 04             	and    $0x4,%eax
80107fdc:	85 c0                	test   %eax,%eax
80107fde:	75 07                	jne    80107fe7 <uva2ka+0x42>
    return 0;
80107fe0:	b8 00 00 00 00       	mov    $0x0,%eax
80107fe5:	eb 0f                	jmp    80107ff6 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fea:	8b 00                	mov    (%eax),%eax
80107fec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ff1:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107ff6:	c9                   	leave  
80107ff7:	c3                   	ret    

80107ff8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ff8:	55                   	push   %ebp
80107ff9:	89 e5                	mov    %esp,%ebp
80107ffb:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107ffe:	8b 45 10             	mov    0x10(%ebp),%eax
80108001:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108004:	eb 7f                	jmp    80108085 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108006:	8b 45 0c             	mov    0xc(%ebp),%eax
80108009:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010800e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108011:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108014:	83 ec 08             	sub    $0x8,%esp
80108017:	50                   	push   %eax
80108018:	ff 75 08             	push   0x8(%ebp)
8010801b:	e8 85 ff ff ff       	call   80107fa5 <uva2ka>
80108020:	83 c4 10             	add    $0x10,%esp
80108023:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108026:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010802a:	75 07                	jne    80108033 <copyout+0x3b>
      return -1;
8010802c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108031:	eb 61                	jmp    80108094 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108033:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108036:	2b 45 0c             	sub    0xc(%ebp),%eax
80108039:	05 00 10 00 00       	add    $0x1000,%eax
8010803e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108041:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108044:	3b 45 14             	cmp    0x14(%ebp),%eax
80108047:	76 06                	jbe    8010804f <copyout+0x57>
      n = len;
80108049:	8b 45 14             	mov    0x14(%ebp),%eax
8010804c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010804f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108052:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108055:	89 c2                	mov    %eax,%edx
80108057:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010805a:	01 d0                	add    %edx,%eax
8010805c:	83 ec 04             	sub    $0x4,%esp
8010805f:	ff 75 f0             	push   -0x10(%ebp)
80108062:	ff 75 f4             	push   -0xc(%ebp)
80108065:	50                   	push   %eax
80108066:	e8 ac cb ff ff       	call   80104c17 <memmove>
8010806b:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010806e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108071:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108074:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108077:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010807a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010807d:	05 00 10 00 00       	add    $0x1000,%eax
80108082:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108085:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108089:	0f 85 77 ff ff ff    	jne    80108006 <copyout+0xe>
  }
  return 0;
8010808f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108094:	c9                   	leave  
80108095:	c3                   	ret    

80108096 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80108096:	55                   	push   %ebp
80108097:	89 e5                	mov    %esp,%ebp
80108099:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
8010809c:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
801080a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801080a6:	8b 40 08             	mov    0x8(%eax),%eax
801080a9:	05 00 00 00 80       	add    $0x80000000,%eax
801080ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
801080b1:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
801080b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bb:	8b 40 24             	mov    0x24(%eax),%eax
801080be:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
801080c3:	c7 05 60 6f 19 80 00 	movl   $0x0,0x80196f60
801080ca:	00 00 00 

  while(i<madt->len){
801080cd:	90                   	nop
801080ce:	e9 bd 00 00 00       	jmp    80108190 <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
801080d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080d9:	01 d0                	add    %edx,%eax
801080db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
801080de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080e1:	0f b6 00             	movzbl (%eax),%eax
801080e4:	0f b6 c0             	movzbl %al,%eax
801080e7:	83 f8 05             	cmp    $0x5,%eax
801080ea:	0f 87 a0 00 00 00    	ja     80108190 <mpinit_uefi+0xfa>
801080f0:	8b 04 85 d0 ac 10 80 	mov    -0x7fef5330(,%eax,4),%eax
801080f7:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
801080f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
801080ff:	a1 60 6f 19 80       	mov    0x80196f60,%eax
80108104:	83 f8 03             	cmp    $0x3,%eax
80108107:	7f 28                	jg     80108131 <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80108109:	8b 15 60 6f 19 80    	mov    0x80196f60,%edx
8010810f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108112:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80108116:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
8010811c:	81 c2 a0 6c 19 80    	add    $0x80196ca0,%edx
80108122:	88 02                	mov    %al,(%edx)
          ncpu++;
80108124:	a1 60 6f 19 80       	mov    0x80196f60,%eax
80108129:	83 c0 01             	add    $0x1,%eax
8010812c:	a3 60 6f 19 80       	mov    %eax,0x80196f60
        }
        i += lapic_entry->record_len;
80108131:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108134:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108138:	0f b6 c0             	movzbl %al,%eax
8010813b:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
8010813e:	eb 50                	jmp    80108190 <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80108140:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108143:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80108146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108149:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010814d:	a2 64 6f 19 80       	mov    %al,0x80196f64
        i += ioapic->record_len;
80108152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108155:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108159:	0f b6 c0             	movzbl %al,%eax
8010815c:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
8010815f:	eb 2f                	jmp    80108190 <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80108161:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108164:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80108167:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010816a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010816e:	0f b6 c0             	movzbl %al,%eax
80108171:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108174:	eb 1a                	jmp    80108190 <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80108176:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108179:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
8010817c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010817f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108183:	0f b6 c0             	movzbl %al,%eax
80108186:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108189:	eb 05                	jmp    80108190 <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
8010818b:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
8010818f:	90                   	nop
  while(i<madt->len){
80108190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108193:	8b 40 04             	mov    0x4(%eax),%eax
80108196:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80108199:	0f 82 34 ff ff ff    	jb     801080d3 <mpinit_uefi+0x3d>
    }
  }

}
8010819f:	90                   	nop
801081a0:	90                   	nop
801081a1:	c9                   	leave  
801081a2:	c3                   	ret    

801081a3 <inb>:
{
801081a3:	55                   	push   %ebp
801081a4:	89 e5                	mov    %esp,%ebp
801081a6:	83 ec 14             	sub    $0x14,%esp
801081a9:	8b 45 08             	mov    0x8(%ebp),%eax
801081ac:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801081b0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801081b4:	89 c2                	mov    %eax,%edx
801081b6:	ec                   	in     (%dx),%al
801081b7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801081ba:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801081be:	c9                   	leave  
801081bf:	c3                   	ret    

801081c0 <outb>:
{
801081c0:	55                   	push   %ebp
801081c1:	89 e5                	mov    %esp,%ebp
801081c3:	83 ec 08             	sub    $0x8,%esp
801081c6:	8b 45 08             	mov    0x8(%ebp),%eax
801081c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801081cc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801081d0:	89 d0                	mov    %edx,%eax
801081d2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801081d5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801081d9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801081dd:	ee                   	out    %al,(%dx)
}
801081de:	90                   	nop
801081df:	c9                   	leave  
801081e0:	c3                   	ret    

801081e1 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
801081e1:	55                   	push   %ebp
801081e2:	89 e5                	mov    %esp,%ebp
801081e4:	83 ec 28             	sub    $0x28,%esp
801081e7:	8b 45 08             	mov    0x8(%ebp),%eax
801081ea:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
801081ed:	6a 00                	push   $0x0
801081ef:	68 fa 03 00 00       	push   $0x3fa
801081f4:	e8 c7 ff ff ff       	call   801081c0 <outb>
801081f9:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801081fc:	68 80 00 00 00       	push   $0x80
80108201:	68 fb 03 00 00       	push   $0x3fb
80108206:	e8 b5 ff ff ff       	call   801081c0 <outb>
8010820b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010820e:	6a 0c                	push   $0xc
80108210:	68 f8 03 00 00       	push   $0x3f8
80108215:	e8 a6 ff ff ff       	call   801081c0 <outb>
8010821a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010821d:	6a 00                	push   $0x0
8010821f:	68 f9 03 00 00       	push   $0x3f9
80108224:	e8 97 ff ff ff       	call   801081c0 <outb>
80108229:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010822c:	6a 03                	push   $0x3
8010822e:	68 fb 03 00 00       	push   $0x3fb
80108233:	e8 88 ff ff ff       	call   801081c0 <outb>
80108238:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010823b:	6a 00                	push   $0x0
8010823d:	68 fc 03 00 00       	push   $0x3fc
80108242:	e8 79 ff ff ff       	call   801081c0 <outb>
80108247:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
8010824a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108251:	eb 11                	jmp    80108264 <uart_debug+0x83>
80108253:	83 ec 0c             	sub    $0xc,%esp
80108256:	6a 0a                	push   $0xa
80108258:	e8 ec a8 ff ff       	call   80102b49 <microdelay>
8010825d:	83 c4 10             	add    $0x10,%esp
80108260:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108264:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108268:	7f 1a                	jg     80108284 <uart_debug+0xa3>
8010826a:	83 ec 0c             	sub    $0xc,%esp
8010826d:	68 fd 03 00 00       	push   $0x3fd
80108272:	e8 2c ff ff ff       	call   801081a3 <inb>
80108277:	83 c4 10             	add    $0x10,%esp
8010827a:	0f b6 c0             	movzbl %al,%eax
8010827d:	83 e0 20             	and    $0x20,%eax
80108280:	85 c0                	test   %eax,%eax
80108282:	74 cf                	je     80108253 <uart_debug+0x72>
  outb(COM1+0, p);
80108284:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108288:	0f b6 c0             	movzbl %al,%eax
8010828b:	83 ec 08             	sub    $0x8,%esp
8010828e:	50                   	push   %eax
8010828f:	68 f8 03 00 00       	push   $0x3f8
80108294:	e8 27 ff ff ff       	call   801081c0 <outb>
80108299:	83 c4 10             	add    $0x10,%esp
}
8010829c:	90                   	nop
8010829d:	c9                   	leave  
8010829e:	c3                   	ret    

8010829f <uart_debugs>:

void uart_debugs(char *p){
8010829f:	55                   	push   %ebp
801082a0:	89 e5                	mov    %esp,%ebp
801082a2:	83 ec 08             	sub    $0x8,%esp
  while(*p){
801082a5:	eb 1b                	jmp    801082c2 <uart_debugs+0x23>
    uart_debug(*p++);
801082a7:	8b 45 08             	mov    0x8(%ebp),%eax
801082aa:	8d 50 01             	lea    0x1(%eax),%edx
801082ad:	89 55 08             	mov    %edx,0x8(%ebp)
801082b0:	0f b6 00             	movzbl (%eax),%eax
801082b3:	0f be c0             	movsbl %al,%eax
801082b6:	83 ec 0c             	sub    $0xc,%esp
801082b9:	50                   	push   %eax
801082ba:	e8 22 ff ff ff       	call   801081e1 <uart_debug>
801082bf:	83 c4 10             	add    $0x10,%esp
  while(*p){
801082c2:	8b 45 08             	mov    0x8(%ebp),%eax
801082c5:	0f b6 00             	movzbl (%eax),%eax
801082c8:	84 c0                	test   %al,%al
801082ca:	75 db                	jne    801082a7 <uart_debugs+0x8>
  }
}
801082cc:	90                   	nop
801082cd:	90                   	nop
801082ce:	c9                   	leave  
801082cf:	c3                   	ret    

801082d0 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
801082d0:	55                   	push   %ebp
801082d1:	89 e5                	mov    %esp,%ebp
801082d3:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
801082d6:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
801082dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082e0:	8b 50 14             	mov    0x14(%eax),%edx
801082e3:	8b 40 10             	mov    0x10(%eax),%eax
801082e6:	a3 68 6f 19 80       	mov    %eax,0x80196f68
  gpu.vram_size = boot_param->graphic_config.frame_size;
801082eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082ee:	8b 50 1c             	mov    0x1c(%eax),%edx
801082f1:	8b 40 18             	mov    0x18(%eax),%eax
801082f4:	a3 70 6f 19 80       	mov    %eax,0x80196f70
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801082f9:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
801082ff:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
80108304:	29 d0                	sub    %edx,%eax
80108306:	a3 6c 6f 19 80       	mov    %eax,0x80196f6c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
8010830b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010830e:	8b 50 24             	mov    0x24(%eax),%edx
80108311:	8b 40 20             	mov    0x20(%eax),%eax
80108314:	a3 74 6f 19 80       	mov    %eax,0x80196f74
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
80108319:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010831c:	8b 50 2c             	mov    0x2c(%eax),%edx
8010831f:	8b 40 28             	mov    0x28(%eax),%eax
80108322:	a3 78 6f 19 80       	mov    %eax,0x80196f78
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
80108327:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010832a:	8b 50 34             	mov    0x34(%eax),%edx
8010832d:	8b 40 30             	mov    0x30(%eax),%eax
80108330:	a3 7c 6f 19 80       	mov    %eax,0x80196f7c
}
80108335:	90                   	nop
80108336:	c9                   	leave  
80108337:	c3                   	ret    

80108338 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
80108338:	55                   	push   %ebp
80108339:	89 e5                	mov    %esp,%ebp
8010833b:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
8010833e:	8b 15 7c 6f 19 80    	mov    0x80196f7c,%edx
80108344:	8b 45 0c             	mov    0xc(%ebp),%eax
80108347:	0f af d0             	imul   %eax,%edx
8010834a:	8b 45 08             	mov    0x8(%ebp),%eax
8010834d:	01 d0                	add    %edx,%eax
8010834f:	c1 e0 02             	shl    $0x2,%eax
80108352:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108355:	8b 15 6c 6f 19 80    	mov    0x80196f6c,%edx
8010835b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010835e:	01 d0                	add    %edx,%eax
80108360:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108363:	8b 45 10             	mov    0x10(%ebp),%eax
80108366:	0f b6 10             	movzbl (%eax),%edx
80108369:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010836c:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
8010836e:	8b 45 10             	mov    0x10(%ebp),%eax
80108371:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108375:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108378:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
8010837b:	8b 45 10             	mov    0x10(%ebp),%eax
8010837e:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80108382:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108385:	88 50 02             	mov    %dl,0x2(%eax)
}
80108388:	90                   	nop
80108389:	c9                   	leave  
8010838a:	c3                   	ret    

8010838b <graphic_scroll_up>:

void graphic_scroll_up(int height){
8010838b:	55                   	push   %ebp
8010838c:	89 e5                	mov    %esp,%ebp
8010838e:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108391:	8b 15 7c 6f 19 80    	mov    0x80196f7c,%edx
80108397:	8b 45 08             	mov    0x8(%ebp),%eax
8010839a:	0f af c2             	imul   %edx,%eax
8010839d:	c1 e0 02             	shl    $0x2,%eax
801083a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
801083a3:	a1 70 6f 19 80       	mov    0x80196f70,%eax
801083a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801083ab:	29 d0                	sub    %edx,%eax
801083ad:	8b 0d 6c 6f 19 80    	mov    0x80196f6c,%ecx
801083b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801083b6:	01 ca                	add    %ecx,%edx
801083b8:	89 d1                	mov    %edx,%ecx
801083ba:	8b 15 6c 6f 19 80    	mov    0x80196f6c,%edx
801083c0:	83 ec 04             	sub    $0x4,%esp
801083c3:	50                   	push   %eax
801083c4:	51                   	push   %ecx
801083c5:	52                   	push   %edx
801083c6:	e8 4c c8 ff ff       	call   80104c17 <memmove>
801083cb:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
801083ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d1:	8b 0d 6c 6f 19 80    	mov    0x80196f6c,%ecx
801083d7:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
801083dd:	01 ca                	add    %ecx,%edx
801083df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801083e2:	29 ca                	sub    %ecx,%edx
801083e4:	83 ec 04             	sub    $0x4,%esp
801083e7:	50                   	push   %eax
801083e8:	6a 00                	push   $0x0
801083ea:	52                   	push   %edx
801083eb:	e8 68 c7 ff ff       	call   80104b58 <memset>
801083f0:	83 c4 10             	add    $0x10,%esp
}
801083f3:	90                   	nop
801083f4:	c9                   	leave  
801083f5:	c3                   	ret    

801083f6 <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
801083f6:	55                   	push   %ebp
801083f7:	89 e5                	mov    %esp,%ebp
801083f9:	53                   	push   %ebx
801083fa:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
801083fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108404:	e9 b1 00 00 00       	jmp    801084ba <font_render+0xc4>
    for(int j=14;j>-1;j--){
80108409:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
80108410:	e9 97 00 00 00       	jmp    801084ac <font_render+0xb6>
      bin = (font_bin[index-0x20][i])&(1 << j);
80108415:	8b 45 10             	mov    0x10(%ebp),%eax
80108418:	83 e8 20             	sub    $0x20,%eax
8010841b:	6b d0 1e             	imul   $0x1e,%eax,%edx
8010841e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108421:	01 d0                	add    %edx,%eax
80108423:	0f b7 84 00 00 ad 10 	movzwl -0x7fef5300(%eax,%eax,1),%eax
8010842a:	80 
8010842b:	0f b7 d0             	movzwl %ax,%edx
8010842e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108431:	bb 01 00 00 00       	mov    $0x1,%ebx
80108436:	89 c1                	mov    %eax,%ecx
80108438:	d3 e3                	shl    %cl,%ebx
8010843a:	89 d8                	mov    %ebx,%eax
8010843c:	21 d0                	and    %edx,%eax
8010843e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
80108441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108444:	ba 01 00 00 00       	mov    $0x1,%edx
80108449:	89 c1                	mov    %eax,%ecx
8010844b:	d3 e2                	shl    %cl,%edx
8010844d:	89 d0                	mov    %edx,%eax
8010844f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108452:	75 2b                	jne    8010847f <font_render+0x89>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
80108454:	8b 55 0c             	mov    0xc(%ebp),%edx
80108457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845a:	01 c2                	add    %eax,%edx
8010845c:	b8 0e 00 00 00       	mov    $0xe,%eax
80108461:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108464:	89 c1                	mov    %eax,%ecx
80108466:	8b 45 08             	mov    0x8(%ebp),%eax
80108469:	01 c8                	add    %ecx,%eax
8010846b:	83 ec 04             	sub    $0x4,%esp
8010846e:	68 e0 f4 10 80       	push   $0x8010f4e0
80108473:	52                   	push   %edx
80108474:	50                   	push   %eax
80108475:	e8 be fe ff ff       	call   80108338 <graphic_draw_pixel>
8010847a:	83 c4 10             	add    $0x10,%esp
8010847d:	eb 29                	jmp    801084a8 <font_render+0xb2>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
8010847f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108485:	01 c2                	add    %eax,%edx
80108487:	b8 0e 00 00 00       	mov    $0xe,%eax
8010848c:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010848f:	89 c1                	mov    %eax,%ecx
80108491:	8b 45 08             	mov    0x8(%ebp),%eax
80108494:	01 c8                	add    %ecx,%eax
80108496:	83 ec 04             	sub    $0x4,%esp
80108499:	68 80 6f 19 80       	push   $0x80196f80
8010849e:	52                   	push   %edx
8010849f:	50                   	push   %eax
801084a0:	e8 93 fe ff ff       	call   80108338 <graphic_draw_pixel>
801084a5:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
801084a8:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
801084ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084b0:	0f 89 5f ff ff ff    	jns    80108415 <font_render+0x1f>
  for(int i=0;i<30;i++){
801084b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801084ba:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
801084be:	0f 8e 45 ff ff ff    	jle    80108409 <font_render+0x13>
      }
    }
  }
}
801084c4:	90                   	nop
801084c5:	90                   	nop
801084c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084c9:	c9                   	leave  
801084ca:	c3                   	ret    

801084cb <font_render_string>:

void font_render_string(char *string,int row){
801084cb:	55                   	push   %ebp
801084cc:	89 e5                	mov    %esp,%ebp
801084ce:	53                   	push   %ebx
801084cf:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
801084d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
801084d9:	eb 33                	jmp    8010850e <font_render_string+0x43>
    font_render(i*15+2,row*30,string[i]);
801084db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801084de:	8b 45 08             	mov    0x8(%ebp),%eax
801084e1:	01 d0                	add    %edx,%eax
801084e3:	0f b6 00             	movzbl (%eax),%eax
801084e6:	0f be c8             	movsbl %al,%ecx
801084e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ec:	6b d0 1e             	imul   $0x1e,%eax,%edx
801084ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801084f2:	89 d8                	mov    %ebx,%eax
801084f4:	c1 e0 04             	shl    $0x4,%eax
801084f7:	29 d8                	sub    %ebx,%eax
801084f9:	83 c0 02             	add    $0x2,%eax
801084fc:	83 ec 04             	sub    $0x4,%esp
801084ff:	51                   	push   %ecx
80108500:	52                   	push   %edx
80108501:	50                   	push   %eax
80108502:	e8 ef fe ff ff       	call   801083f6 <font_render>
80108507:	83 c4 10             	add    $0x10,%esp
    i++;
8010850a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
8010850e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108511:	8b 45 08             	mov    0x8(%ebp),%eax
80108514:	01 d0                	add    %edx,%eax
80108516:	0f b6 00             	movzbl (%eax),%eax
80108519:	84 c0                	test   %al,%al
8010851b:	74 06                	je     80108523 <font_render_string+0x58>
8010851d:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
80108521:	7e b8                	jle    801084db <font_render_string+0x10>
  }
}
80108523:	90                   	nop
80108524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108527:	c9                   	leave  
80108528:	c3                   	ret    

80108529 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
80108529:	55                   	push   %ebp
8010852a:	89 e5                	mov    %esp,%ebp
8010852c:	53                   	push   %ebx
8010852d:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
80108530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108537:	eb 6b                	jmp    801085a4 <pci_init+0x7b>
    for(int j=0;j<32;j++){
80108539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108540:	eb 58                	jmp    8010859a <pci_init+0x71>
      for(int k=0;k<8;k++){
80108542:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108549:	eb 45                	jmp    80108590 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
8010854b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010854e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108554:	83 ec 0c             	sub    $0xc,%esp
80108557:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010855a:	53                   	push   %ebx
8010855b:	6a 00                	push   $0x0
8010855d:	51                   	push   %ecx
8010855e:	52                   	push   %edx
8010855f:	50                   	push   %eax
80108560:	e8 b0 00 00 00       	call   80108615 <pci_access_config>
80108565:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
80108568:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010856b:	0f b7 c0             	movzwl %ax,%eax
8010856e:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108573:	74 17                	je     8010858c <pci_init+0x63>
        pci_init_device(i,j,k);
80108575:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108578:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010857b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010857e:	83 ec 04             	sub    $0x4,%esp
80108581:	51                   	push   %ecx
80108582:	52                   	push   %edx
80108583:	50                   	push   %eax
80108584:	e8 37 01 00 00       	call   801086c0 <pci_init_device>
80108589:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
8010858c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108590:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108594:	7e b5                	jle    8010854b <pci_init+0x22>
    for(int j=0;j<32;j++){
80108596:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010859a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010859e:	7e a2                	jle    80108542 <pci_init+0x19>
  for(int i=0;i<256;i++){
801085a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085a4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801085ab:	7e 8c                	jle    80108539 <pci_init+0x10>
      }
      }
    }
  }
}
801085ad:	90                   	nop
801085ae:	90                   	nop
801085af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085b2:	c9                   	leave  
801085b3:	c3                   	ret    

801085b4 <pci_write_config>:

void pci_write_config(uint config){
801085b4:	55                   	push   %ebp
801085b5:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
801085b7:	8b 45 08             	mov    0x8(%ebp),%eax
801085ba:	ba f8 0c 00 00       	mov    $0xcf8,%edx
801085bf:	89 c0                	mov    %eax,%eax
801085c1:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801085c2:	90                   	nop
801085c3:	5d                   	pop    %ebp
801085c4:	c3                   	ret    

801085c5 <pci_write_data>:

void pci_write_data(uint config){
801085c5:	55                   	push   %ebp
801085c6:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
801085c8:	8b 45 08             	mov    0x8(%ebp),%eax
801085cb:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801085d0:	89 c0                	mov    %eax,%eax
801085d2:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801085d3:	90                   	nop
801085d4:	5d                   	pop    %ebp
801085d5:	c3                   	ret    

801085d6 <pci_read_config>:
uint pci_read_config(){
801085d6:	55                   	push   %ebp
801085d7:	89 e5                	mov    %esp,%ebp
801085d9:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801085dc:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801085e1:	ed                   	in     (%dx),%eax
801085e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801085e5:	83 ec 0c             	sub    $0xc,%esp
801085e8:	68 c8 00 00 00       	push   $0xc8
801085ed:	e8 57 a5 ff ff       	call   80102b49 <microdelay>
801085f2:	83 c4 10             	add    $0x10,%esp
  return data;
801085f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801085f8:	c9                   	leave  
801085f9:	c3                   	ret    

801085fa <pci_test>:


void pci_test(){
801085fa:	55                   	push   %ebp
801085fb:	89 e5                	mov    %esp,%ebp
801085fd:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
80108600:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
80108607:	ff 75 fc             	push   -0x4(%ebp)
8010860a:	e8 a5 ff ff ff       	call   801085b4 <pci_write_config>
8010860f:	83 c4 04             	add    $0x4,%esp
}
80108612:	90                   	nop
80108613:	c9                   	leave  
80108614:	c3                   	ret    

80108615 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
80108615:	55                   	push   %ebp
80108616:	89 e5                	mov    %esp,%ebp
80108618:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010861b:	8b 45 08             	mov    0x8(%ebp),%eax
8010861e:	c1 e0 10             	shl    $0x10,%eax
80108621:	25 00 00 ff 00       	and    $0xff0000,%eax
80108626:	89 c2                	mov    %eax,%edx
80108628:	8b 45 0c             	mov    0xc(%ebp),%eax
8010862b:	c1 e0 0b             	shl    $0xb,%eax
8010862e:	0f b7 c0             	movzwl %ax,%eax
80108631:	09 c2                	or     %eax,%edx
80108633:	8b 45 10             	mov    0x10(%ebp),%eax
80108636:	c1 e0 08             	shl    $0x8,%eax
80108639:	25 00 07 00 00       	and    $0x700,%eax
8010863e:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108640:	8b 45 14             	mov    0x14(%ebp),%eax
80108643:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108648:	09 d0                	or     %edx,%eax
8010864a:	0d 00 00 00 80       	or     $0x80000000,%eax
8010864f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108652:	ff 75 f4             	push   -0xc(%ebp)
80108655:	e8 5a ff ff ff       	call   801085b4 <pci_write_config>
8010865a:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
8010865d:	e8 74 ff ff ff       	call   801085d6 <pci_read_config>
80108662:	8b 55 18             	mov    0x18(%ebp),%edx
80108665:	89 02                	mov    %eax,(%edx)
}
80108667:	90                   	nop
80108668:	c9                   	leave  
80108669:	c3                   	ret    

8010866a <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
8010866a:	55                   	push   %ebp
8010866b:	89 e5                	mov    %esp,%ebp
8010866d:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108670:	8b 45 08             	mov    0x8(%ebp),%eax
80108673:	c1 e0 10             	shl    $0x10,%eax
80108676:	25 00 00 ff 00       	and    $0xff0000,%eax
8010867b:	89 c2                	mov    %eax,%edx
8010867d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108680:	c1 e0 0b             	shl    $0xb,%eax
80108683:	0f b7 c0             	movzwl %ax,%eax
80108686:	09 c2                	or     %eax,%edx
80108688:	8b 45 10             	mov    0x10(%ebp),%eax
8010868b:	c1 e0 08             	shl    $0x8,%eax
8010868e:	25 00 07 00 00       	and    $0x700,%eax
80108693:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108695:	8b 45 14             	mov    0x14(%ebp),%eax
80108698:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010869d:	09 d0                	or     %edx,%eax
8010869f:	0d 00 00 00 80       	or     $0x80000000,%eax
801086a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
801086a7:	ff 75 fc             	push   -0x4(%ebp)
801086aa:	e8 05 ff ff ff       	call   801085b4 <pci_write_config>
801086af:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
801086b2:	ff 75 18             	push   0x18(%ebp)
801086b5:	e8 0b ff ff ff       	call   801085c5 <pci_write_data>
801086ba:	83 c4 04             	add    $0x4,%esp
}
801086bd:	90                   	nop
801086be:	c9                   	leave  
801086bf:	c3                   	ret    

801086c0 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
801086c0:	55                   	push   %ebp
801086c1:	89 e5                	mov    %esp,%ebp
801086c3:	53                   	push   %ebx
801086c4:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
801086c7:	8b 45 08             	mov    0x8(%ebp),%eax
801086ca:	a2 84 6f 19 80       	mov    %al,0x80196f84
  dev.device_num = device_num;
801086cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801086d2:	a2 85 6f 19 80       	mov    %al,0x80196f85
  dev.function_num = function_num;
801086d7:	8b 45 10             	mov    0x10(%ebp),%eax
801086da:	a2 86 6f 19 80       	mov    %al,0x80196f86
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801086df:	ff 75 10             	push   0x10(%ebp)
801086e2:	ff 75 0c             	push   0xc(%ebp)
801086e5:	ff 75 08             	push   0x8(%ebp)
801086e8:	68 44 c3 10 80       	push   $0x8010c344
801086ed:	e8 02 7d ff ff       	call   801003f4 <cprintf>
801086f2:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801086f5:	83 ec 0c             	sub    $0xc,%esp
801086f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801086fb:	50                   	push   %eax
801086fc:	6a 00                	push   $0x0
801086fe:	ff 75 10             	push   0x10(%ebp)
80108701:	ff 75 0c             	push   0xc(%ebp)
80108704:	ff 75 08             	push   0x8(%ebp)
80108707:	e8 09 ff ff ff       	call   80108615 <pci_access_config>
8010870c:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
8010870f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108712:	c1 e8 10             	shr    $0x10,%eax
80108715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
80108718:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010871b:	25 ff ff 00 00       	and    $0xffff,%eax
80108720:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
80108723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108726:	a3 88 6f 19 80       	mov    %eax,0x80196f88
  dev.vendor_id = vendor_id;
8010872b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010872e:	a3 8c 6f 19 80       	mov    %eax,0x80196f8c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
80108733:	83 ec 04             	sub    $0x4,%esp
80108736:	ff 75 f0             	push   -0x10(%ebp)
80108739:	ff 75 f4             	push   -0xc(%ebp)
8010873c:	68 78 c3 10 80       	push   $0x8010c378
80108741:	e8 ae 7c ff ff       	call   801003f4 <cprintf>
80108746:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
80108749:	83 ec 0c             	sub    $0xc,%esp
8010874c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010874f:	50                   	push   %eax
80108750:	6a 08                	push   $0x8
80108752:	ff 75 10             	push   0x10(%ebp)
80108755:	ff 75 0c             	push   0xc(%ebp)
80108758:	ff 75 08             	push   0x8(%ebp)
8010875b:	e8 b5 fe ff ff       	call   80108615 <pci_access_config>
80108760:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108763:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108766:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108769:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010876c:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010876f:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108772:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108775:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108778:	0f b6 c0             	movzbl %al,%eax
8010877b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010877e:	c1 eb 18             	shr    $0x18,%ebx
80108781:	83 ec 0c             	sub    $0xc,%esp
80108784:	51                   	push   %ecx
80108785:	52                   	push   %edx
80108786:	50                   	push   %eax
80108787:	53                   	push   %ebx
80108788:	68 9c c3 10 80       	push   $0x8010c39c
8010878d:	e8 62 7c ff ff       	call   801003f4 <cprintf>
80108792:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108795:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108798:	c1 e8 18             	shr    $0x18,%eax
8010879b:	a2 90 6f 19 80       	mov    %al,0x80196f90
  dev.sub_class = (data>>16)&0xFF;
801087a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087a3:	c1 e8 10             	shr    $0x10,%eax
801087a6:	a2 91 6f 19 80       	mov    %al,0x80196f91
  dev.interface = (data>>8)&0xFF;
801087ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087ae:	c1 e8 08             	shr    $0x8,%eax
801087b1:	a2 92 6f 19 80       	mov    %al,0x80196f92
  dev.revision_id = data&0xFF;
801087b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087b9:	a2 93 6f 19 80       	mov    %al,0x80196f93
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
801087be:	83 ec 0c             	sub    $0xc,%esp
801087c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801087c4:	50                   	push   %eax
801087c5:	6a 10                	push   $0x10
801087c7:	ff 75 10             	push   0x10(%ebp)
801087ca:	ff 75 0c             	push   0xc(%ebp)
801087cd:	ff 75 08             	push   0x8(%ebp)
801087d0:	e8 40 fe ff ff       	call   80108615 <pci_access_config>
801087d5:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801087d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087db:	a3 94 6f 19 80       	mov    %eax,0x80196f94
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801087e0:	83 ec 0c             	sub    $0xc,%esp
801087e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801087e6:	50                   	push   %eax
801087e7:	6a 14                	push   $0x14
801087e9:	ff 75 10             	push   0x10(%ebp)
801087ec:	ff 75 0c             	push   0xc(%ebp)
801087ef:	ff 75 08             	push   0x8(%ebp)
801087f2:	e8 1e fe ff ff       	call   80108615 <pci_access_config>
801087f7:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801087fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087fd:	a3 98 6f 19 80       	mov    %eax,0x80196f98
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
80108802:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
80108809:	75 5a                	jne    80108865 <pci_init_device+0x1a5>
8010880b:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
80108812:	75 51                	jne    80108865 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
80108814:	83 ec 0c             	sub    $0xc,%esp
80108817:	68 e1 c3 10 80       	push   $0x8010c3e1
8010881c:	e8 d3 7b ff ff       	call   801003f4 <cprintf>
80108821:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
80108824:	83 ec 0c             	sub    $0xc,%esp
80108827:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010882a:	50                   	push   %eax
8010882b:	68 f0 00 00 00       	push   $0xf0
80108830:	ff 75 10             	push   0x10(%ebp)
80108833:	ff 75 0c             	push   0xc(%ebp)
80108836:	ff 75 08             	push   0x8(%ebp)
80108839:	e8 d7 fd ff ff       	call   80108615 <pci_access_config>
8010883e:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
80108841:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108844:	83 ec 08             	sub    $0x8,%esp
80108847:	50                   	push   %eax
80108848:	68 fb c3 10 80       	push   $0x8010c3fb
8010884d:	e8 a2 7b ff ff       	call   801003f4 <cprintf>
80108852:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108855:	83 ec 0c             	sub    $0xc,%esp
80108858:	68 84 6f 19 80       	push   $0x80196f84
8010885d:	e8 09 00 00 00       	call   8010886b <i8254_init>
80108862:	83 c4 10             	add    $0x10,%esp
  }
}
80108865:	90                   	nop
80108866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108869:	c9                   	leave  
8010886a:	c3                   	ret    

8010886b <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
8010886b:	55                   	push   %ebp
8010886c:	89 e5                	mov    %esp,%ebp
8010886e:	53                   	push   %ebx
8010886f:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108872:	8b 45 08             	mov    0x8(%ebp),%eax
80108875:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108879:	0f b6 c8             	movzbl %al,%ecx
8010887c:	8b 45 08             	mov    0x8(%ebp),%eax
8010887f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108883:	0f b6 d0             	movzbl %al,%edx
80108886:	8b 45 08             	mov    0x8(%ebp),%eax
80108889:	0f b6 00             	movzbl (%eax),%eax
8010888c:	0f b6 c0             	movzbl %al,%eax
8010888f:	83 ec 0c             	sub    $0xc,%esp
80108892:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108895:	53                   	push   %ebx
80108896:	6a 04                	push   $0x4
80108898:	51                   	push   %ecx
80108899:	52                   	push   %edx
8010889a:	50                   	push   %eax
8010889b:	e8 75 fd ff ff       	call   80108615 <pci_access_config>
801088a0:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
801088a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a6:	83 c8 04             	or     $0x4,%eax
801088a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
801088ac:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801088af:	8b 45 08             	mov    0x8(%ebp),%eax
801088b2:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801088b6:	0f b6 c8             	movzbl %al,%ecx
801088b9:	8b 45 08             	mov    0x8(%ebp),%eax
801088bc:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801088c0:	0f b6 d0             	movzbl %al,%edx
801088c3:	8b 45 08             	mov    0x8(%ebp),%eax
801088c6:	0f b6 00             	movzbl (%eax),%eax
801088c9:	0f b6 c0             	movzbl %al,%eax
801088cc:	83 ec 0c             	sub    $0xc,%esp
801088cf:	53                   	push   %ebx
801088d0:	6a 04                	push   $0x4
801088d2:	51                   	push   %ecx
801088d3:	52                   	push   %edx
801088d4:	50                   	push   %eax
801088d5:	e8 90 fd ff ff       	call   8010866a <pci_write_config_register>
801088da:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
801088dd:	8b 45 08             	mov    0x8(%ebp),%eax
801088e0:	8b 40 10             	mov    0x10(%eax),%eax
801088e3:	05 00 00 00 40       	add    $0x40000000,%eax
801088e8:	a3 9c 6f 19 80       	mov    %eax,0x80196f9c
  uint *ctrl = (uint *)base_addr;
801088ed:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
801088f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801088f5:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
801088fa:	05 d8 00 00 00       	add    $0xd8,%eax
801088ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
80108902:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108905:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
8010890b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010890e:	8b 00                	mov    (%eax),%eax
80108910:	0d 00 00 00 04       	or     $0x4000000,%eax
80108915:	89 c2                	mov    %eax,%edx
80108917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891a:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
8010891c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010891f:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
80108925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108928:	8b 00                	mov    (%eax),%eax
8010892a:	83 c8 40             	or     $0x40,%eax
8010892d:	89 c2                	mov    %eax,%edx
8010892f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108932:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
80108934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108937:	8b 10                	mov    (%eax),%edx
80108939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010893c:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
8010893e:	83 ec 0c             	sub    $0xc,%esp
80108941:	68 10 c4 10 80       	push   $0x8010c410
80108946:	e8 a9 7a ff ff       	call   801003f4 <cprintf>
8010894b:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
8010894e:	e8 32 9e ff ff       	call   80102785 <kalloc>
80108953:	a3 a8 6f 19 80       	mov    %eax,0x80196fa8
  *intr_addr = 0;
80108958:	a1 a8 6f 19 80       	mov    0x80196fa8,%eax
8010895d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108963:	a1 a8 6f 19 80       	mov    0x80196fa8,%eax
80108968:	83 ec 08             	sub    $0x8,%esp
8010896b:	50                   	push   %eax
8010896c:	68 32 c4 10 80       	push   $0x8010c432
80108971:	e8 7e 7a ff ff       	call   801003f4 <cprintf>
80108976:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108979:	e8 50 00 00 00       	call   801089ce <i8254_init_recv>
  i8254_init_send();
8010897e:	e8 69 03 00 00       	call   80108cec <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108983:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010898a:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
8010898d:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108994:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108997:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010899e:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
801089a1:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801089a8:	0f b6 c0             	movzbl %al,%eax
801089ab:	83 ec 0c             	sub    $0xc,%esp
801089ae:	53                   	push   %ebx
801089af:	51                   	push   %ecx
801089b0:	52                   	push   %edx
801089b1:	50                   	push   %eax
801089b2:	68 40 c4 10 80       	push   $0x8010c440
801089b7:	e8 38 7a ff ff       	call   801003f4 <cprintf>
801089bc:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
801089bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
801089c8:	90                   	nop
801089c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801089cc:	c9                   	leave  
801089cd:	c3                   	ret    

801089ce <i8254_init_recv>:

void i8254_init_recv(){
801089ce:	55                   	push   %ebp
801089cf:	89 e5                	mov    %esp,%ebp
801089d1:	57                   	push   %edi
801089d2:	56                   	push   %esi
801089d3:	53                   	push   %ebx
801089d4:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
801089d7:	83 ec 0c             	sub    $0xc,%esp
801089da:	6a 00                	push   $0x0
801089dc:	e8 e8 04 00 00       	call   80108ec9 <i8254_read_eeprom>
801089e1:	83 c4 10             	add    $0x10,%esp
801089e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
801089e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801089ea:	a2 a0 6f 19 80       	mov    %al,0x80196fa0
  mac_addr[1] = data_l>>8;
801089ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
801089f2:	c1 e8 08             	shr    $0x8,%eax
801089f5:	a2 a1 6f 19 80       	mov    %al,0x80196fa1
  uint data_m = i8254_read_eeprom(0x1);
801089fa:	83 ec 0c             	sub    $0xc,%esp
801089fd:	6a 01                	push   $0x1
801089ff:	e8 c5 04 00 00       	call   80108ec9 <i8254_read_eeprom>
80108a04:	83 c4 10             	add    $0x10,%esp
80108a07:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108a0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108a0d:	a2 a2 6f 19 80       	mov    %al,0x80196fa2
  mac_addr[3] = data_m>>8;
80108a12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108a15:	c1 e8 08             	shr    $0x8,%eax
80108a18:	a2 a3 6f 19 80       	mov    %al,0x80196fa3
  uint data_h = i8254_read_eeprom(0x2);
80108a1d:	83 ec 0c             	sub    $0xc,%esp
80108a20:	6a 02                	push   $0x2
80108a22:	e8 a2 04 00 00       	call   80108ec9 <i8254_read_eeprom>
80108a27:	83 c4 10             	add    $0x10,%esp
80108a2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108a2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a30:	a2 a4 6f 19 80       	mov    %al,0x80196fa4
  mac_addr[5] = data_h>>8;
80108a35:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a38:	c1 e8 08             	shr    $0x8,%eax
80108a3b:	a2 a5 6f 19 80       	mov    %al,0x80196fa5
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108a40:	0f b6 05 a5 6f 19 80 	movzbl 0x80196fa5,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a47:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108a4a:	0f b6 05 a4 6f 19 80 	movzbl 0x80196fa4,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a51:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108a54:	0f b6 05 a3 6f 19 80 	movzbl 0x80196fa3,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a5b:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108a5e:	0f b6 05 a2 6f 19 80 	movzbl 0x80196fa2,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a65:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108a68:	0f b6 05 a1 6f 19 80 	movzbl 0x80196fa1,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a6f:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108a72:	0f b6 05 a0 6f 19 80 	movzbl 0x80196fa0,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a79:	0f b6 c0             	movzbl %al,%eax
80108a7c:	83 ec 04             	sub    $0x4,%esp
80108a7f:	57                   	push   %edi
80108a80:	56                   	push   %esi
80108a81:	53                   	push   %ebx
80108a82:	51                   	push   %ecx
80108a83:	52                   	push   %edx
80108a84:	50                   	push   %eax
80108a85:	68 58 c4 10 80       	push   $0x8010c458
80108a8a:	e8 65 79 ff ff       	call   801003f4 <cprintf>
80108a8f:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108a92:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108a97:	05 00 54 00 00       	add    $0x5400,%eax
80108a9c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108a9f:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108aa4:	05 04 54 00 00       	add    $0x5404,%eax
80108aa9:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108aac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108aaf:	c1 e0 10             	shl    $0x10,%eax
80108ab2:	0b 45 d8             	or     -0x28(%ebp),%eax
80108ab5:	89 c2                	mov    %eax,%edx
80108ab7:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108aba:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108abc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108abf:	0d 00 00 00 80       	or     $0x80000000,%eax
80108ac4:	89 c2                	mov    %eax,%edx
80108ac6:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108ac9:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108acb:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ad0:	05 00 52 00 00       	add    $0x5200,%eax
80108ad5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108ad8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108adf:	eb 19                	jmp    80108afa <i8254_init_recv+0x12c>
    mta[i] = 0;
80108ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ae4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108aeb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108aee:	01 d0                	add    %edx,%eax
80108af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108af6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108afa:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108afe:	7e e1                	jle    80108ae1 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108b00:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b05:	05 d0 00 00 00       	add    $0xd0,%eax
80108b0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108b10:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108b16:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b1b:	05 c8 00 00 00       	add    $0xc8,%eax
80108b20:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108b23:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108b26:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108b2c:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b31:	05 28 28 00 00       	add    $0x2828,%eax
80108b36:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108b39:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108b3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108b42:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b47:	05 00 01 00 00       	add    $0x100,%eax
80108b4c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108b4f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108b52:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108b58:	e8 28 9c ff ff       	call   80102785 <kalloc>
80108b5d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108b60:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b65:	05 00 28 00 00       	add    $0x2800,%eax
80108b6a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108b6d:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b72:	05 04 28 00 00       	add    $0x2804,%eax
80108b77:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108b7a:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b7f:	05 08 28 00 00       	add    $0x2808,%eax
80108b84:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108b87:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b8c:	05 10 28 00 00       	add    $0x2810,%eax
80108b91:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108b94:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b99:	05 18 28 00 00       	add    $0x2818,%eax
80108b9e:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108ba4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108baa:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108bad:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108baf:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108bb8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108bbb:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108bc1:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108bc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108bca:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108bcd:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108bd3:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108bd6:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108bd9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108be0:	eb 73                	jmp    80108c55 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108be5:	c1 e0 04             	shl    $0x4,%eax
80108be8:	89 c2                	mov    %eax,%edx
80108bea:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bed:	01 d0                	add    %edx,%eax
80108bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bf9:	c1 e0 04             	shl    $0x4,%eax
80108bfc:	89 c2                	mov    %eax,%edx
80108bfe:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c01:	01 d0                	add    %edx,%eax
80108c03:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c0c:	c1 e0 04             	shl    $0x4,%eax
80108c0f:	89 c2                	mov    %eax,%edx
80108c11:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c14:	01 d0                	add    %edx,%eax
80108c16:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108c1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c1f:	c1 e0 04             	shl    $0x4,%eax
80108c22:	89 c2                	mov    %eax,%edx
80108c24:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c27:	01 d0                	add    %edx,%eax
80108c29:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c30:	c1 e0 04             	shl    $0x4,%eax
80108c33:	89 c2                	mov    %eax,%edx
80108c35:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c38:	01 d0                	add    %edx,%eax
80108c3a:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108c3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c41:	c1 e0 04             	shl    $0x4,%eax
80108c44:	89 c2                	mov    %eax,%edx
80108c46:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c49:	01 d0                	add    %edx,%eax
80108c4b:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108c51:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108c55:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108c5c:	7e 84                	jle    80108be2 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108c5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108c65:	eb 57                	jmp    80108cbe <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108c67:	e8 19 9b ff ff       	call   80102785 <kalloc>
80108c6c:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108c6f:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108c73:	75 12                	jne    80108c87 <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108c75:	83 ec 0c             	sub    $0xc,%esp
80108c78:	68 78 c4 10 80       	push   $0x8010c478
80108c7d:	e8 72 77 ff ff       	call   801003f4 <cprintf>
80108c82:	83 c4 10             	add    $0x10,%esp
      break;
80108c85:	eb 3d                	jmp    80108cc4 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108c87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c8a:	c1 e0 04             	shl    $0x4,%eax
80108c8d:	89 c2                	mov    %eax,%edx
80108c8f:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c92:	01 d0                	add    %edx,%eax
80108c94:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108c97:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c9d:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108ca2:	83 c0 01             	add    $0x1,%eax
80108ca5:	c1 e0 04             	shl    $0x4,%eax
80108ca8:	89 c2                	mov    %eax,%edx
80108caa:	8b 45 98             	mov    -0x68(%ebp),%eax
80108cad:	01 d0                	add    %edx,%eax
80108caf:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108cb2:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108cb8:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108cba:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108cbe:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108cc2:	7e a3                	jle    80108c67 <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108cc4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108cc7:	8b 00                	mov    (%eax),%eax
80108cc9:	83 c8 02             	or     $0x2,%eax
80108ccc:	89 c2                	mov    %eax,%edx
80108cce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108cd1:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108cd3:	83 ec 0c             	sub    $0xc,%esp
80108cd6:	68 98 c4 10 80       	push   $0x8010c498
80108cdb:	e8 14 77 ff ff       	call   801003f4 <cprintf>
80108ce0:	83 c4 10             	add    $0x10,%esp
}
80108ce3:	90                   	nop
80108ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ce7:	5b                   	pop    %ebx
80108ce8:	5e                   	pop    %esi
80108ce9:	5f                   	pop    %edi
80108cea:	5d                   	pop    %ebp
80108ceb:	c3                   	ret    

80108cec <i8254_init_send>:

void i8254_init_send(){
80108cec:	55                   	push   %ebp
80108ced:	89 e5                	mov    %esp,%ebp
80108cef:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108cf2:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108cf7:	05 28 38 00 00       	add    $0x3828,%eax
80108cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d02:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108d08:	e8 78 9a ff ff       	call   80102785 <kalloc>
80108d0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108d10:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d15:	05 00 38 00 00       	add    $0x3800,%eax
80108d1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108d1d:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d22:	05 04 38 00 00       	add    $0x3804,%eax
80108d27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108d2a:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d2f:	05 08 38 00 00       	add    $0x3808,%eax
80108d34:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d3a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108d43:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d51:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108d57:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d5c:	05 10 38 00 00       	add    $0x3810,%eax
80108d61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108d64:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d69:	05 18 38 00 00       	add    $0x3818,%eax
80108d6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108d71:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108d7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108d7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d86:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108d90:	e9 82 00 00 00       	jmp    80108e17 <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d98:	c1 e0 04             	shl    $0x4,%eax
80108d9b:	89 c2                	mov    %eax,%edx
80108d9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108da0:	01 d0                	add    %edx,%eax
80108da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dac:	c1 e0 04             	shl    $0x4,%eax
80108daf:	89 c2                	mov    %eax,%edx
80108db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108db4:	01 d0                	add    %edx,%eax
80108db6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbf:	c1 e0 04             	shl    $0x4,%eax
80108dc2:	89 c2                	mov    %eax,%edx
80108dc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108dc7:	01 d0                	add    %edx,%eax
80108dc9:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd0:	c1 e0 04             	shl    $0x4,%eax
80108dd3:	89 c2                	mov    %eax,%edx
80108dd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108dd8:	01 d0                	add    %edx,%eax
80108dda:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de1:	c1 e0 04             	shl    $0x4,%eax
80108de4:	89 c2                	mov    %eax,%edx
80108de6:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108de9:	01 d0                	add    %edx,%eax
80108deb:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df2:	c1 e0 04             	shl    $0x4,%eax
80108df5:	89 c2                	mov    %eax,%edx
80108df7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108dfa:	01 d0                	add    %edx,%eax
80108dfc:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e03:	c1 e0 04             	shl    $0x4,%eax
80108e06:	89 c2                	mov    %eax,%edx
80108e08:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e0b:	01 d0                	add    %edx,%eax
80108e0d:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108e13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108e17:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108e1e:	0f 8e 71 ff ff ff    	jle    80108d95 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108e24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108e2b:	eb 57                	jmp    80108e84 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108e2d:	e8 53 99 ff ff       	call   80102785 <kalloc>
80108e32:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108e35:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108e39:	75 12                	jne    80108e4d <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108e3b:	83 ec 0c             	sub    $0xc,%esp
80108e3e:	68 78 c4 10 80       	push   $0x8010c478
80108e43:	e8 ac 75 ff ff       	call   801003f4 <cprintf>
80108e48:	83 c4 10             	add    $0x10,%esp
      break;
80108e4b:	eb 3d                	jmp    80108e8a <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e50:	c1 e0 04             	shl    $0x4,%eax
80108e53:	89 c2                	mov    %eax,%edx
80108e55:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e58:	01 d0                	add    %edx,%eax
80108e5a:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108e5d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108e63:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e68:	83 c0 01             	add    $0x1,%eax
80108e6b:	c1 e0 04             	shl    $0x4,%eax
80108e6e:	89 c2                	mov    %eax,%edx
80108e70:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e73:	01 d0                	add    %edx,%eax
80108e75:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108e78:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108e7e:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108e80:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108e84:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108e88:	7e a3                	jle    80108e2d <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108e8a:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108e8f:	05 00 04 00 00       	add    $0x400,%eax
80108e94:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108e97:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108e9a:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108ea0:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ea5:	05 10 04 00 00       	add    $0x410,%eax
80108eaa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108ead:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108eb0:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108eb6:	83 ec 0c             	sub    $0xc,%esp
80108eb9:	68 b8 c4 10 80       	push   $0x8010c4b8
80108ebe:	e8 31 75 ff ff       	call   801003f4 <cprintf>
80108ec3:	83 c4 10             	add    $0x10,%esp

}
80108ec6:	90                   	nop
80108ec7:	c9                   	leave  
80108ec8:	c3                   	ret    

80108ec9 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108ec9:	55                   	push   %ebp
80108eca:	89 e5                	mov    %esp,%ebp
80108ecc:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108ecf:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ed4:	83 c0 14             	add    $0x14,%eax
80108ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108eda:	8b 45 08             	mov    0x8(%ebp),%eax
80108edd:	c1 e0 08             	shl    $0x8,%eax
80108ee0:	0f b7 c0             	movzwl %ax,%eax
80108ee3:	83 c8 01             	or     $0x1,%eax
80108ee6:	89 c2                	mov    %eax,%edx
80108ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eeb:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108eed:	83 ec 0c             	sub    $0xc,%esp
80108ef0:	68 d8 c4 10 80       	push   $0x8010c4d8
80108ef5:	e8 fa 74 ff ff       	call   801003f4 <cprintf>
80108efa:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f00:	8b 00                	mov    (%eax),%eax
80108f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f08:	83 e0 10             	and    $0x10,%eax
80108f0b:	85 c0                	test   %eax,%eax
80108f0d:	75 02                	jne    80108f11 <i8254_read_eeprom+0x48>
  while(1){
80108f0f:	eb dc                	jmp    80108eed <i8254_read_eeprom+0x24>
      break;
80108f11:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f15:	8b 00                	mov    (%eax),%eax
80108f17:	c1 e8 10             	shr    $0x10,%eax
}
80108f1a:	c9                   	leave  
80108f1b:	c3                   	ret    

80108f1c <i8254_recv>:
void i8254_recv(){
80108f1c:	55                   	push   %ebp
80108f1d:	89 e5                	mov    %esp,%ebp
80108f1f:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108f22:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108f27:	05 10 28 00 00       	add    $0x2810,%eax
80108f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108f2f:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108f34:	05 18 28 00 00       	add    $0x2818,%eax
80108f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108f3c:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108f41:	05 00 28 00 00       	add    $0x2800,%eax
80108f46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f4c:	8b 00                	mov    (%eax),%eax
80108f4e:	05 00 00 00 80       	add    $0x80000000,%eax
80108f53:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f59:	8b 10                	mov    (%eax),%edx
80108f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f5e:	8b 08                	mov    (%eax),%ecx
80108f60:	89 d0                	mov    %edx,%eax
80108f62:	29 c8                	sub    %ecx,%eax
80108f64:	25 ff 00 00 00       	and    $0xff,%eax
80108f69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108f70:	7e 37                	jle    80108fa9 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f75:	8b 00                	mov    (%eax),%eax
80108f77:	c1 e0 04             	shl    $0x4,%eax
80108f7a:	89 c2                	mov    %eax,%edx
80108f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f7f:	01 d0                	add    %edx,%eax
80108f81:	8b 00                	mov    (%eax),%eax
80108f83:	05 00 00 00 80       	add    $0x80000000,%eax
80108f88:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f8e:	8b 00                	mov    (%eax),%eax
80108f90:	83 c0 01             	add    $0x1,%eax
80108f93:	0f b6 d0             	movzbl %al,%edx
80108f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f99:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108f9b:	83 ec 0c             	sub    $0xc,%esp
80108f9e:	ff 75 e0             	push   -0x20(%ebp)
80108fa1:	e8 15 09 00 00       	call   801098bb <eth_proc>
80108fa6:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fac:	8b 10                	mov    (%eax),%edx
80108fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fb1:	8b 00                	mov    (%eax),%eax
80108fb3:	39 c2                	cmp    %eax,%edx
80108fb5:	75 9f                	jne    80108f56 <i8254_recv+0x3a>
      (*rdt)--;
80108fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fba:	8b 00                	mov    (%eax),%eax
80108fbc:	8d 50 ff             	lea    -0x1(%eax),%edx
80108fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fc2:	89 10                	mov    %edx,(%eax)
  while(1){
80108fc4:	eb 90                	jmp    80108f56 <i8254_recv+0x3a>

80108fc6 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108fc6:	55                   	push   %ebp
80108fc7:	89 e5                	mov    %esp,%ebp
80108fc9:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108fcc:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108fd1:	05 10 38 00 00       	add    $0x3810,%eax
80108fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108fd9:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108fde:	05 18 38 00 00       	add    $0x3818,%eax
80108fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108fe6:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108feb:	05 00 38 00 00       	add    $0x3800,%eax
80108ff0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ff6:	8b 00                	mov    (%eax),%eax
80108ff8:	05 00 00 00 80       	add    $0x80000000,%eax
80108ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80109000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109003:	8b 10                	mov    (%eax),%edx
80109005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109008:	8b 08                	mov    (%eax),%ecx
8010900a:	89 d0                	mov    %edx,%eax
8010900c:	29 c8                	sub    %ecx,%eax
8010900e:	0f b6 d0             	movzbl %al,%edx
80109011:	b8 00 01 00 00       	mov    $0x100,%eax
80109016:	29 d0                	sub    %edx,%eax
80109018:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
8010901b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010901e:	8b 00                	mov    (%eax),%eax
80109020:	25 ff 00 00 00       	and    $0xff,%eax
80109025:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80109028:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010902c:	0f 8e a8 00 00 00    	jle    801090da <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80109032:	8b 45 08             	mov    0x8(%ebp),%eax
80109035:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109038:	89 d1                	mov    %edx,%ecx
8010903a:	c1 e1 04             	shl    $0x4,%ecx
8010903d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80109040:	01 ca                	add    %ecx,%edx
80109042:	8b 12                	mov    (%edx),%edx
80109044:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010904a:	83 ec 04             	sub    $0x4,%esp
8010904d:	ff 75 0c             	push   0xc(%ebp)
80109050:	50                   	push   %eax
80109051:	52                   	push   %edx
80109052:	e8 c0 bb ff ff       	call   80104c17 <memmove>
80109057:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
8010905a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010905d:	c1 e0 04             	shl    $0x4,%eax
80109060:	89 c2                	mov    %eax,%edx
80109062:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109065:	01 d0                	add    %edx,%eax
80109067:	8b 55 0c             	mov    0xc(%ebp),%edx
8010906a:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
8010906e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109071:	c1 e0 04             	shl    $0x4,%eax
80109074:	89 c2                	mov    %eax,%edx
80109076:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109079:	01 d0                	add    %edx,%eax
8010907b:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
8010907f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109082:	c1 e0 04             	shl    $0x4,%eax
80109085:	89 c2                	mov    %eax,%edx
80109087:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010908a:	01 d0                	add    %edx,%eax
8010908c:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80109090:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109093:	c1 e0 04             	shl    $0x4,%eax
80109096:	89 c2                	mov    %eax,%edx
80109098:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010909b:	01 d0                	add    %edx,%eax
8010909d:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
801090a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090a4:	c1 e0 04             	shl    $0x4,%eax
801090a7:	89 c2                	mov    %eax,%edx
801090a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801090ac:	01 d0                	add    %edx,%eax
801090ae:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
801090b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090b7:	c1 e0 04             	shl    $0x4,%eax
801090ba:	89 c2                	mov    %eax,%edx
801090bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801090bf:	01 d0                	add    %edx,%eax
801090c1:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
801090c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090c8:	8b 00                	mov    (%eax),%eax
801090ca:	83 c0 01             	add    $0x1,%eax
801090cd:	0f b6 d0             	movzbl %al,%edx
801090d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d3:	89 10                	mov    %edx,(%eax)
    return len;
801090d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801090d8:	eb 05                	jmp    801090df <i8254_send+0x119>
  }else{
    return -1;
801090da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801090df:	c9                   	leave  
801090e0:	c3                   	ret    

801090e1 <i8254_intr>:

void i8254_intr(){
801090e1:	55                   	push   %ebp
801090e2:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
801090e4:	a1 a8 6f 19 80       	mov    0x80196fa8,%eax
801090e9:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
801090ef:	90                   	nop
801090f0:	5d                   	pop    %ebp
801090f1:	c3                   	ret    

801090f2 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
801090f2:	55                   	push   %ebp
801090f3:	89 e5                	mov    %esp,%ebp
801090f5:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
801090f8:	8b 45 08             	mov    0x8(%ebp),%eax
801090fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
801090fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109101:	0f b7 00             	movzwl (%eax),%eax
80109104:	66 3d 00 01          	cmp    $0x100,%ax
80109108:	74 0a                	je     80109114 <arp_proc+0x22>
8010910a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010910f:	e9 4f 01 00 00       	jmp    80109263 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80109114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109117:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010911b:	66 83 f8 08          	cmp    $0x8,%ax
8010911f:	74 0a                	je     8010912b <arp_proc+0x39>
80109121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109126:	e9 38 01 00 00       	jmp    80109263 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
8010912b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010912e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80109132:	3c 06                	cmp    $0x6,%al
80109134:	74 0a                	je     80109140 <arp_proc+0x4e>
80109136:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010913b:	e9 23 01 00 00       	jmp    80109263 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80109140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109143:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80109147:	3c 04                	cmp    $0x4,%al
80109149:	74 0a                	je     80109155 <arp_proc+0x63>
8010914b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109150:	e9 0e 01 00 00       	jmp    80109263 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80109155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109158:	83 c0 18             	add    $0x18,%eax
8010915b:	83 ec 04             	sub    $0x4,%esp
8010915e:	6a 04                	push   $0x4
80109160:	50                   	push   %eax
80109161:	68 e4 f4 10 80       	push   $0x8010f4e4
80109166:	e8 54 ba ff ff       	call   80104bbf <memcmp>
8010916b:	83 c4 10             	add    $0x10,%esp
8010916e:	85 c0                	test   %eax,%eax
80109170:	74 27                	je     80109199 <arp_proc+0xa7>
80109172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109175:	83 c0 0e             	add    $0xe,%eax
80109178:	83 ec 04             	sub    $0x4,%esp
8010917b:	6a 04                	push   $0x4
8010917d:	50                   	push   %eax
8010917e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109183:	e8 37 ba ff ff       	call   80104bbf <memcmp>
80109188:	83 c4 10             	add    $0x10,%esp
8010918b:	85 c0                	test   %eax,%eax
8010918d:	74 0a                	je     80109199 <arp_proc+0xa7>
8010918f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109194:	e9 ca 00 00 00       	jmp    80109263 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80109199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010919c:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801091a0:	66 3d 00 01          	cmp    $0x100,%ax
801091a4:	75 69                	jne    8010920f <arp_proc+0x11d>
801091a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091a9:	83 c0 18             	add    $0x18,%eax
801091ac:	83 ec 04             	sub    $0x4,%esp
801091af:	6a 04                	push   $0x4
801091b1:	50                   	push   %eax
801091b2:	68 e4 f4 10 80       	push   $0x8010f4e4
801091b7:	e8 03 ba ff ff       	call   80104bbf <memcmp>
801091bc:	83 c4 10             	add    $0x10,%esp
801091bf:	85 c0                	test   %eax,%eax
801091c1:	75 4c                	jne    8010920f <arp_proc+0x11d>
    uint send = (uint)kalloc();
801091c3:	e8 bd 95 ff ff       	call   80102785 <kalloc>
801091c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
801091cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
801091d2:	83 ec 04             	sub    $0x4,%esp
801091d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801091d8:	50                   	push   %eax
801091d9:	ff 75 f0             	push   -0x10(%ebp)
801091dc:	ff 75 f4             	push   -0xc(%ebp)
801091df:	e8 1f 04 00 00       	call   80109603 <arp_reply_pkt_create>
801091e4:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
801091e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091ea:	83 ec 08             	sub    $0x8,%esp
801091ed:	50                   	push   %eax
801091ee:	ff 75 f0             	push   -0x10(%ebp)
801091f1:	e8 d0 fd ff ff       	call   80108fc6 <i8254_send>
801091f6:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
801091f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091fc:	83 ec 0c             	sub    $0xc,%esp
801091ff:	50                   	push   %eax
80109200:	e8 e6 94 ff ff       	call   801026eb <kfree>
80109205:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80109208:	b8 02 00 00 00       	mov    $0x2,%eax
8010920d:	eb 54                	jmp    80109263 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
8010920f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109212:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109216:	66 3d 00 02          	cmp    $0x200,%ax
8010921a:	75 42                	jne    8010925e <arp_proc+0x16c>
8010921c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921f:	83 c0 18             	add    $0x18,%eax
80109222:	83 ec 04             	sub    $0x4,%esp
80109225:	6a 04                	push   $0x4
80109227:	50                   	push   %eax
80109228:	68 e4 f4 10 80       	push   $0x8010f4e4
8010922d:	e8 8d b9 ff ff       	call   80104bbf <memcmp>
80109232:	83 c4 10             	add    $0x10,%esp
80109235:	85 c0                	test   %eax,%eax
80109237:	75 25                	jne    8010925e <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80109239:	83 ec 0c             	sub    $0xc,%esp
8010923c:	68 dc c4 10 80       	push   $0x8010c4dc
80109241:	e8 ae 71 ff ff       	call   801003f4 <cprintf>
80109246:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80109249:	83 ec 0c             	sub    $0xc,%esp
8010924c:	ff 75 f4             	push   -0xc(%ebp)
8010924f:	e8 af 01 00 00       	call   80109403 <arp_table_update>
80109254:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80109257:	b8 01 00 00 00       	mov    $0x1,%eax
8010925c:	eb 05                	jmp    80109263 <arp_proc+0x171>
  }else{
    return -1;
8010925e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109263:	c9                   	leave  
80109264:	c3                   	ret    

80109265 <arp_scan>:

void arp_scan(){
80109265:	55                   	push   %ebp
80109266:	89 e5                	mov    %esp,%ebp
80109268:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
8010926b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109272:	eb 6f                	jmp    801092e3 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109274:	e8 0c 95 ff ff       	call   80102785 <kalloc>
80109279:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
8010927c:	83 ec 04             	sub    $0x4,%esp
8010927f:	ff 75 f4             	push   -0xc(%ebp)
80109282:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109285:	50                   	push   %eax
80109286:	ff 75 ec             	push   -0x14(%ebp)
80109289:	e8 62 00 00 00       	call   801092f0 <arp_broadcast>
8010928e:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80109291:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109294:	83 ec 08             	sub    $0x8,%esp
80109297:	50                   	push   %eax
80109298:	ff 75 ec             	push   -0x14(%ebp)
8010929b:	e8 26 fd ff ff       	call   80108fc6 <i8254_send>
801092a0:	83 c4 10             	add    $0x10,%esp
801092a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801092a6:	eb 22                	jmp    801092ca <arp_scan+0x65>
      microdelay(1);
801092a8:	83 ec 0c             	sub    $0xc,%esp
801092ab:	6a 01                	push   $0x1
801092ad:	e8 97 98 ff ff       	call   80102b49 <microdelay>
801092b2:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
801092b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801092b8:	83 ec 08             	sub    $0x8,%esp
801092bb:	50                   	push   %eax
801092bc:	ff 75 ec             	push   -0x14(%ebp)
801092bf:	e8 02 fd ff ff       	call   80108fc6 <i8254_send>
801092c4:	83 c4 10             	add    $0x10,%esp
801092c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801092ca:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801092ce:	74 d8                	je     801092a8 <arp_scan+0x43>
    }
    kfree((char *)send);
801092d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092d3:	83 ec 0c             	sub    $0xc,%esp
801092d6:	50                   	push   %eax
801092d7:	e8 0f 94 ff ff       	call   801026eb <kfree>
801092dc:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
801092df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801092e3:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801092ea:	7e 88                	jle    80109274 <arp_scan+0xf>
  }
}
801092ec:	90                   	nop
801092ed:	90                   	nop
801092ee:	c9                   	leave  
801092ef:	c3                   	ret    

801092f0 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801092f0:	55                   	push   %ebp
801092f1:	89 e5                	mov    %esp,%ebp
801092f3:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801092f6:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801092fa:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
801092fe:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
80109302:	8b 45 10             	mov    0x10(%ebp),%eax
80109305:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
80109308:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
8010930f:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
80109315:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010931c:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109322:	8b 45 0c             	mov    0xc(%ebp),%eax
80109325:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
8010932b:	8b 45 08             	mov    0x8(%ebp),%eax
8010932e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109331:	8b 45 08             	mov    0x8(%ebp),%eax
80109334:	83 c0 0e             	add    $0xe,%eax
80109337:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
8010933a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933d:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109344:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
80109348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010934b:	83 ec 04             	sub    $0x4,%esp
8010934e:	6a 06                	push   $0x6
80109350:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109353:	52                   	push   %edx
80109354:	50                   	push   %eax
80109355:	e8 bd b8 ff ff       	call   80104c17 <memmove>
8010935a:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010935d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109360:	83 c0 06             	add    $0x6,%eax
80109363:	83 ec 04             	sub    $0x4,%esp
80109366:	6a 06                	push   $0x6
80109368:	68 a0 6f 19 80       	push   $0x80196fa0
8010936d:	50                   	push   %eax
8010936e:	e8 a4 b8 ff ff       	call   80104c17 <memmove>
80109373:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109379:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010937e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109381:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010938a:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010938e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109391:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109395:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109398:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
8010939e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093a1:	8d 50 12             	lea    0x12(%eax),%edx
801093a4:	83 ec 04             	sub    $0x4,%esp
801093a7:	6a 06                	push   $0x6
801093a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801093ac:	50                   	push   %eax
801093ad:	52                   	push   %edx
801093ae:	e8 64 b8 ff ff       	call   80104c17 <memmove>
801093b3:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
801093b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093b9:	8d 50 18             	lea    0x18(%eax),%edx
801093bc:	83 ec 04             	sub    $0x4,%esp
801093bf:	6a 04                	push   $0x4
801093c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801093c4:	50                   	push   %eax
801093c5:	52                   	push   %edx
801093c6:	e8 4c b8 ff ff       	call   80104c17 <memmove>
801093cb:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801093ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093d1:	83 c0 08             	add    $0x8,%eax
801093d4:	83 ec 04             	sub    $0x4,%esp
801093d7:	6a 06                	push   $0x6
801093d9:	68 a0 6f 19 80       	push   $0x80196fa0
801093de:	50                   	push   %eax
801093df:	e8 33 b8 ff ff       	call   80104c17 <memmove>
801093e4:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801093e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ea:	83 c0 0e             	add    $0xe,%eax
801093ed:	83 ec 04             	sub    $0x4,%esp
801093f0:	6a 04                	push   $0x4
801093f2:	68 e4 f4 10 80       	push   $0x8010f4e4
801093f7:	50                   	push   %eax
801093f8:	e8 1a b8 ff ff       	call   80104c17 <memmove>
801093fd:	83 c4 10             	add    $0x10,%esp
}
80109400:	90                   	nop
80109401:	c9                   	leave  
80109402:	c3                   	ret    

80109403 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
80109403:	55                   	push   %ebp
80109404:	89 e5                	mov    %esp,%ebp
80109406:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
80109409:	8b 45 08             	mov    0x8(%ebp),%eax
8010940c:	83 c0 0e             	add    $0xe,%eax
8010940f:	83 ec 0c             	sub    $0xc,%esp
80109412:	50                   	push   %eax
80109413:	e8 bc 00 00 00       	call   801094d4 <arp_table_search>
80109418:	83 c4 10             	add    $0x10,%esp
8010941b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
8010941e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109422:	78 2d                	js     80109451 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109424:	8b 45 08             	mov    0x8(%ebp),%eax
80109427:	8d 48 08             	lea    0x8(%eax),%ecx
8010942a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010942d:	89 d0                	mov    %edx,%eax
8010942f:	c1 e0 02             	shl    $0x2,%eax
80109432:	01 d0                	add    %edx,%eax
80109434:	01 c0                	add    %eax,%eax
80109436:	01 d0                	add    %edx,%eax
80109438:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
8010943d:	83 c0 04             	add    $0x4,%eax
80109440:	83 ec 04             	sub    $0x4,%esp
80109443:	6a 06                	push   $0x6
80109445:	51                   	push   %ecx
80109446:	50                   	push   %eax
80109447:	e8 cb b7 ff ff       	call   80104c17 <memmove>
8010944c:	83 c4 10             	add    $0x10,%esp
8010944f:	eb 70                	jmp    801094c1 <arp_table_update+0xbe>
  }else{
    index += 1;
80109451:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109455:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109458:	8b 45 08             	mov    0x8(%ebp),%eax
8010945b:	8d 48 08             	lea    0x8(%eax),%ecx
8010945e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109461:	89 d0                	mov    %edx,%eax
80109463:	c1 e0 02             	shl    $0x2,%eax
80109466:	01 d0                	add    %edx,%eax
80109468:	01 c0                	add    %eax,%eax
8010946a:	01 d0                	add    %edx,%eax
8010946c:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
80109471:	83 c0 04             	add    $0x4,%eax
80109474:	83 ec 04             	sub    $0x4,%esp
80109477:	6a 06                	push   $0x6
80109479:	51                   	push   %ecx
8010947a:	50                   	push   %eax
8010947b:	e8 97 b7 ff ff       	call   80104c17 <memmove>
80109480:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109483:	8b 45 08             	mov    0x8(%ebp),%eax
80109486:	8d 48 0e             	lea    0xe(%eax),%ecx
80109489:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010948c:	89 d0                	mov    %edx,%eax
8010948e:	c1 e0 02             	shl    $0x2,%eax
80109491:	01 d0                	add    %edx,%eax
80109493:	01 c0                	add    %eax,%eax
80109495:	01 d0                	add    %edx,%eax
80109497:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
8010949c:	83 ec 04             	sub    $0x4,%esp
8010949f:	6a 04                	push   $0x4
801094a1:	51                   	push   %ecx
801094a2:	50                   	push   %eax
801094a3:	e8 6f b7 ff ff       	call   80104c17 <memmove>
801094a8:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
801094ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801094ae:	89 d0                	mov    %edx,%eax
801094b0:	c1 e0 02             	shl    $0x2,%eax
801094b3:	01 d0                	add    %edx,%eax
801094b5:	01 c0                	add    %eax,%eax
801094b7:	01 d0                	add    %edx,%eax
801094b9:	05 ca 6f 19 80       	add    $0x80196fca,%eax
801094be:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
801094c1:	83 ec 0c             	sub    $0xc,%esp
801094c4:	68 c0 6f 19 80       	push   $0x80196fc0
801094c9:	e8 83 00 00 00       	call   80109551 <print_arp_table>
801094ce:	83 c4 10             	add    $0x10,%esp
}
801094d1:	90                   	nop
801094d2:	c9                   	leave  
801094d3:	c3                   	ret    

801094d4 <arp_table_search>:

int arp_table_search(uchar *ip){
801094d4:	55                   	push   %ebp
801094d5:	89 e5                	mov    %esp,%ebp
801094d7:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801094da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801094e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801094e8:	eb 59                	jmp    80109543 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801094ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801094ed:	89 d0                	mov    %edx,%eax
801094ef:	c1 e0 02             	shl    $0x2,%eax
801094f2:	01 d0                	add    %edx,%eax
801094f4:	01 c0                	add    %eax,%eax
801094f6:	01 d0                	add    %edx,%eax
801094f8:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
801094fd:	83 ec 04             	sub    $0x4,%esp
80109500:	6a 04                	push   $0x4
80109502:	ff 75 08             	push   0x8(%ebp)
80109505:	50                   	push   %eax
80109506:	e8 b4 b6 ff ff       	call   80104bbf <memcmp>
8010950b:	83 c4 10             	add    $0x10,%esp
8010950e:	85 c0                	test   %eax,%eax
80109510:	75 05                	jne    80109517 <arp_table_search+0x43>
      return i;
80109512:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109515:	eb 38                	jmp    8010954f <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
80109517:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010951a:	89 d0                	mov    %edx,%eax
8010951c:	c1 e0 02             	shl    $0x2,%eax
8010951f:	01 d0                	add    %edx,%eax
80109521:	01 c0                	add    %eax,%eax
80109523:	01 d0                	add    %edx,%eax
80109525:	05 ca 6f 19 80       	add    $0x80196fca,%eax
8010952a:	0f b6 00             	movzbl (%eax),%eax
8010952d:	84 c0                	test   %al,%al
8010952f:	75 0e                	jne    8010953f <arp_table_search+0x6b>
80109531:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109535:	75 08                	jne    8010953f <arp_table_search+0x6b>
      empty = -i;
80109537:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010953a:	f7 d8                	neg    %eax
8010953c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010953f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109543:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
80109547:	7e a1                	jle    801094ea <arp_table_search+0x16>
    }
  }
  return empty-1;
80109549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010954c:	83 e8 01             	sub    $0x1,%eax
}
8010954f:	c9                   	leave  
80109550:	c3                   	ret    

80109551 <print_arp_table>:

void print_arp_table(){
80109551:	55                   	push   %ebp
80109552:	89 e5                	mov    %esp,%ebp
80109554:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010955e:	e9 92 00 00 00       	jmp    801095f5 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109563:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109566:	89 d0                	mov    %edx,%eax
80109568:	c1 e0 02             	shl    $0x2,%eax
8010956b:	01 d0                	add    %edx,%eax
8010956d:	01 c0                	add    %eax,%eax
8010956f:	01 d0                	add    %edx,%eax
80109571:	05 ca 6f 19 80       	add    $0x80196fca,%eax
80109576:	0f b6 00             	movzbl (%eax),%eax
80109579:	84 c0                	test   %al,%al
8010957b:	74 74                	je     801095f1 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
8010957d:	83 ec 08             	sub    $0x8,%esp
80109580:	ff 75 f4             	push   -0xc(%ebp)
80109583:	68 ef c4 10 80       	push   $0x8010c4ef
80109588:	e8 67 6e ff ff       	call   801003f4 <cprintf>
8010958d:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109593:	89 d0                	mov    %edx,%eax
80109595:	c1 e0 02             	shl    $0x2,%eax
80109598:	01 d0                	add    %edx,%eax
8010959a:	01 c0                	add    %eax,%eax
8010959c:	01 d0                	add    %edx,%eax
8010959e:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
801095a3:	83 ec 0c             	sub    $0xc,%esp
801095a6:	50                   	push   %eax
801095a7:	e8 54 02 00 00       	call   80109800 <print_ipv4>
801095ac:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
801095af:	83 ec 0c             	sub    $0xc,%esp
801095b2:	68 fe c4 10 80       	push   $0x8010c4fe
801095b7:	e8 38 6e ff ff       	call   801003f4 <cprintf>
801095bc:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
801095bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801095c2:	89 d0                	mov    %edx,%eax
801095c4:	c1 e0 02             	shl    $0x2,%eax
801095c7:	01 d0                	add    %edx,%eax
801095c9:	01 c0                	add    %eax,%eax
801095cb:	01 d0                	add    %edx,%eax
801095cd:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
801095d2:	83 c0 04             	add    $0x4,%eax
801095d5:	83 ec 0c             	sub    $0xc,%esp
801095d8:	50                   	push   %eax
801095d9:	e8 70 02 00 00       	call   8010984e <print_mac>
801095de:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801095e1:	83 ec 0c             	sub    $0xc,%esp
801095e4:	68 00 c5 10 80       	push   $0x8010c500
801095e9:	e8 06 6e ff ff       	call   801003f4 <cprintf>
801095ee:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801095f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801095f5:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801095f9:	0f 8e 64 ff ff ff    	jle    80109563 <print_arp_table+0x12>
    }
  }
}
801095ff:	90                   	nop
80109600:	90                   	nop
80109601:	c9                   	leave  
80109602:	c3                   	ret    

80109603 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
80109603:	55                   	push   %ebp
80109604:	89 e5                	mov    %esp,%ebp
80109606:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109609:	8b 45 10             	mov    0x10(%ebp),%eax
8010960c:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109612:	8b 45 0c             	mov    0xc(%ebp),%eax
80109615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109618:	8b 45 0c             	mov    0xc(%ebp),%eax
8010961b:	83 c0 0e             	add    $0xe,%eax
8010961e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
80109621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109624:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109628:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010962b:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
8010962f:	8b 45 08             	mov    0x8(%ebp),%eax
80109632:	8d 50 08             	lea    0x8(%eax),%edx
80109635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109638:	83 ec 04             	sub    $0x4,%esp
8010963b:	6a 06                	push   $0x6
8010963d:	52                   	push   %edx
8010963e:	50                   	push   %eax
8010963f:	e8 d3 b5 ff ff       	call   80104c17 <memmove>
80109644:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010964a:	83 c0 06             	add    $0x6,%eax
8010964d:	83 ec 04             	sub    $0x4,%esp
80109650:	6a 06                	push   $0x6
80109652:	68 a0 6f 19 80       	push   $0x80196fa0
80109657:	50                   	push   %eax
80109658:	e8 ba b5 ff ff       	call   80104c17 <memmove>
8010965d:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109660:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109663:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010966b:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109671:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109674:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109678:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010967b:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
8010967f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109682:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
80109688:	8b 45 08             	mov    0x8(%ebp),%eax
8010968b:	8d 50 08             	lea    0x8(%eax),%edx
8010968e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109691:	83 c0 12             	add    $0x12,%eax
80109694:	83 ec 04             	sub    $0x4,%esp
80109697:	6a 06                	push   $0x6
80109699:	52                   	push   %edx
8010969a:	50                   	push   %eax
8010969b:	e8 77 b5 ff ff       	call   80104c17 <memmove>
801096a0:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
801096a3:	8b 45 08             	mov    0x8(%ebp),%eax
801096a6:	8d 50 0e             	lea    0xe(%eax),%edx
801096a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096ac:	83 c0 18             	add    $0x18,%eax
801096af:	83 ec 04             	sub    $0x4,%esp
801096b2:	6a 04                	push   $0x4
801096b4:	52                   	push   %edx
801096b5:	50                   	push   %eax
801096b6:	e8 5c b5 ff ff       	call   80104c17 <memmove>
801096bb:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801096be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096c1:	83 c0 08             	add    $0x8,%eax
801096c4:	83 ec 04             	sub    $0x4,%esp
801096c7:	6a 06                	push   $0x6
801096c9:	68 a0 6f 19 80       	push   $0x80196fa0
801096ce:	50                   	push   %eax
801096cf:	e8 43 b5 ff ff       	call   80104c17 <memmove>
801096d4:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801096d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096da:	83 c0 0e             	add    $0xe,%eax
801096dd:	83 ec 04             	sub    $0x4,%esp
801096e0:	6a 04                	push   $0x4
801096e2:	68 e4 f4 10 80       	push   $0x8010f4e4
801096e7:	50                   	push   %eax
801096e8:	e8 2a b5 ff ff       	call   80104c17 <memmove>
801096ed:	83 c4 10             	add    $0x10,%esp
}
801096f0:	90                   	nop
801096f1:	c9                   	leave  
801096f2:	c3                   	ret    

801096f3 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801096f3:	55                   	push   %ebp
801096f4:	89 e5                	mov    %esp,%ebp
801096f6:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801096f9:	83 ec 0c             	sub    $0xc,%esp
801096fc:	68 02 c5 10 80       	push   $0x8010c502
80109701:	e8 ee 6c ff ff       	call   801003f4 <cprintf>
80109706:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
80109709:	8b 45 08             	mov    0x8(%ebp),%eax
8010970c:	83 c0 0e             	add    $0xe,%eax
8010970f:	83 ec 0c             	sub    $0xc,%esp
80109712:	50                   	push   %eax
80109713:	e8 e8 00 00 00       	call   80109800 <print_ipv4>
80109718:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010971b:	83 ec 0c             	sub    $0xc,%esp
8010971e:	68 00 c5 10 80       	push   $0x8010c500
80109723:	e8 cc 6c ff ff       	call   801003f4 <cprintf>
80109728:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
8010972b:	8b 45 08             	mov    0x8(%ebp),%eax
8010972e:	83 c0 08             	add    $0x8,%eax
80109731:	83 ec 0c             	sub    $0xc,%esp
80109734:	50                   	push   %eax
80109735:	e8 14 01 00 00       	call   8010984e <print_mac>
8010973a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010973d:	83 ec 0c             	sub    $0xc,%esp
80109740:	68 00 c5 10 80       	push   $0x8010c500
80109745:	e8 aa 6c ff ff       	call   801003f4 <cprintf>
8010974a:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
8010974d:	83 ec 0c             	sub    $0xc,%esp
80109750:	68 19 c5 10 80       	push   $0x8010c519
80109755:	e8 9a 6c ff ff       	call   801003f4 <cprintf>
8010975a:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
8010975d:	8b 45 08             	mov    0x8(%ebp),%eax
80109760:	83 c0 18             	add    $0x18,%eax
80109763:	83 ec 0c             	sub    $0xc,%esp
80109766:	50                   	push   %eax
80109767:	e8 94 00 00 00       	call   80109800 <print_ipv4>
8010976c:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010976f:	83 ec 0c             	sub    $0xc,%esp
80109772:	68 00 c5 10 80       	push   $0x8010c500
80109777:	e8 78 6c ff ff       	call   801003f4 <cprintf>
8010977c:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
8010977f:	8b 45 08             	mov    0x8(%ebp),%eax
80109782:	83 c0 12             	add    $0x12,%eax
80109785:	83 ec 0c             	sub    $0xc,%esp
80109788:	50                   	push   %eax
80109789:	e8 c0 00 00 00       	call   8010984e <print_mac>
8010978e:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109791:	83 ec 0c             	sub    $0xc,%esp
80109794:	68 00 c5 10 80       	push   $0x8010c500
80109799:	e8 56 6c ff ff       	call   801003f4 <cprintf>
8010979e:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
801097a1:	83 ec 0c             	sub    $0xc,%esp
801097a4:	68 30 c5 10 80       	push   $0x8010c530
801097a9:	e8 46 6c ff ff       	call   801003f4 <cprintf>
801097ae:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
801097b1:	8b 45 08             	mov    0x8(%ebp),%eax
801097b4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801097b8:	66 3d 00 01          	cmp    $0x100,%ax
801097bc:	75 12                	jne    801097d0 <print_arp_info+0xdd>
801097be:	83 ec 0c             	sub    $0xc,%esp
801097c1:	68 3c c5 10 80       	push   $0x8010c53c
801097c6:	e8 29 6c ff ff       	call   801003f4 <cprintf>
801097cb:	83 c4 10             	add    $0x10,%esp
801097ce:	eb 1d                	jmp    801097ed <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
801097d0:	8b 45 08             	mov    0x8(%ebp),%eax
801097d3:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801097d7:	66 3d 00 02          	cmp    $0x200,%ax
801097db:	75 10                	jne    801097ed <print_arp_info+0xfa>
    cprintf("Reply\n");
801097dd:	83 ec 0c             	sub    $0xc,%esp
801097e0:	68 45 c5 10 80       	push   $0x8010c545
801097e5:	e8 0a 6c ff ff       	call   801003f4 <cprintf>
801097ea:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801097ed:	83 ec 0c             	sub    $0xc,%esp
801097f0:	68 00 c5 10 80       	push   $0x8010c500
801097f5:	e8 fa 6b ff ff       	call   801003f4 <cprintf>
801097fa:	83 c4 10             	add    $0x10,%esp
}
801097fd:	90                   	nop
801097fe:	c9                   	leave  
801097ff:	c3                   	ret    

80109800 <print_ipv4>:

void print_ipv4(uchar *ip){
80109800:	55                   	push   %ebp
80109801:	89 e5                	mov    %esp,%ebp
80109803:	53                   	push   %ebx
80109804:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
80109807:	8b 45 08             	mov    0x8(%ebp),%eax
8010980a:	83 c0 03             	add    $0x3,%eax
8010980d:	0f b6 00             	movzbl (%eax),%eax
80109810:	0f b6 d8             	movzbl %al,%ebx
80109813:	8b 45 08             	mov    0x8(%ebp),%eax
80109816:	83 c0 02             	add    $0x2,%eax
80109819:	0f b6 00             	movzbl (%eax),%eax
8010981c:	0f b6 c8             	movzbl %al,%ecx
8010981f:	8b 45 08             	mov    0x8(%ebp),%eax
80109822:	83 c0 01             	add    $0x1,%eax
80109825:	0f b6 00             	movzbl (%eax),%eax
80109828:	0f b6 d0             	movzbl %al,%edx
8010982b:	8b 45 08             	mov    0x8(%ebp),%eax
8010982e:	0f b6 00             	movzbl (%eax),%eax
80109831:	0f b6 c0             	movzbl %al,%eax
80109834:	83 ec 0c             	sub    $0xc,%esp
80109837:	53                   	push   %ebx
80109838:	51                   	push   %ecx
80109839:	52                   	push   %edx
8010983a:	50                   	push   %eax
8010983b:	68 4c c5 10 80       	push   $0x8010c54c
80109840:	e8 af 6b ff ff       	call   801003f4 <cprintf>
80109845:	83 c4 20             	add    $0x20,%esp
}
80109848:	90                   	nop
80109849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010984c:	c9                   	leave  
8010984d:	c3                   	ret    

8010984e <print_mac>:

void print_mac(uchar *mac){
8010984e:	55                   	push   %ebp
8010984f:	89 e5                	mov    %esp,%ebp
80109851:	57                   	push   %edi
80109852:	56                   	push   %esi
80109853:	53                   	push   %ebx
80109854:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
80109857:	8b 45 08             	mov    0x8(%ebp),%eax
8010985a:	83 c0 05             	add    $0x5,%eax
8010985d:	0f b6 00             	movzbl (%eax),%eax
80109860:	0f b6 f8             	movzbl %al,%edi
80109863:	8b 45 08             	mov    0x8(%ebp),%eax
80109866:	83 c0 04             	add    $0x4,%eax
80109869:	0f b6 00             	movzbl (%eax),%eax
8010986c:	0f b6 f0             	movzbl %al,%esi
8010986f:	8b 45 08             	mov    0x8(%ebp),%eax
80109872:	83 c0 03             	add    $0x3,%eax
80109875:	0f b6 00             	movzbl (%eax),%eax
80109878:	0f b6 d8             	movzbl %al,%ebx
8010987b:	8b 45 08             	mov    0x8(%ebp),%eax
8010987e:	83 c0 02             	add    $0x2,%eax
80109881:	0f b6 00             	movzbl (%eax),%eax
80109884:	0f b6 c8             	movzbl %al,%ecx
80109887:	8b 45 08             	mov    0x8(%ebp),%eax
8010988a:	83 c0 01             	add    $0x1,%eax
8010988d:	0f b6 00             	movzbl (%eax),%eax
80109890:	0f b6 d0             	movzbl %al,%edx
80109893:	8b 45 08             	mov    0x8(%ebp),%eax
80109896:	0f b6 00             	movzbl (%eax),%eax
80109899:	0f b6 c0             	movzbl %al,%eax
8010989c:	83 ec 04             	sub    $0x4,%esp
8010989f:	57                   	push   %edi
801098a0:	56                   	push   %esi
801098a1:	53                   	push   %ebx
801098a2:	51                   	push   %ecx
801098a3:	52                   	push   %edx
801098a4:	50                   	push   %eax
801098a5:	68 64 c5 10 80       	push   $0x8010c564
801098aa:	e8 45 6b ff ff       	call   801003f4 <cprintf>
801098af:	83 c4 20             	add    $0x20,%esp
}
801098b2:	90                   	nop
801098b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801098b6:	5b                   	pop    %ebx
801098b7:	5e                   	pop    %esi
801098b8:	5f                   	pop    %edi
801098b9:	5d                   	pop    %ebp
801098ba:	c3                   	ret    

801098bb <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
801098bb:	55                   	push   %ebp
801098bc:	89 e5                	mov    %esp,%ebp
801098be:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
801098c1:	8b 45 08             	mov    0x8(%ebp),%eax
801098c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
801098c7:	8b 45 08             	mov    0x8(%ebp),%eax
801098ca:	83 c0 0e             	add    $0xe,%eax
801098cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
801098d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d3:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801098d7:	3c 08                	cmp    $0x8,%al
801098d9:	75 1b                	jne    801098f6 <eth_proc+0x3b>
801098db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098de:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801098e2:	3c 06                	cmp    $0x6,%al
801098e4:	75 10                	jne    801098f6 <eth_proc+0x3b>
    arp_proc(pkt_addr);
801098e6:	83 ec 0c             	sub    $0xc,%esp
801098e9:	ff 75 f0             	push   -0x10(%ebp)
801098ec:	e8 01 f8 ff ff       	call   801090f2 <arp_proc>
801098f1:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801098f4:	eb 24                	jmp    8010991a <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801098f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f9:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801098fd:	3c 08                	cmp    $0x8,%al
801098ff:	75 19                	jne    8010991a <eth_proc+0x5f>
80109901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109904:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109908:	84 c0                	test   %al,%al
8010990a:	75 0e                	jne    8010991a <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
8010990c:	83 ec 0c             	sub    $0xc,%esp
8010990f:	ff 75 08             	push   0x8(%ebp)
80109912:	e8 a3 00 00 00       	call   801099ba <ipv4_proc>
80109917:	83 c4 10             	add    $0x10,%esp
}
8010991a:	90                   	nop
8010991b:	c9                   	leave  
8010991c:	c3                   	ret    

8010991d <N2H_ushort>:

ushort N2H_ushort(ushort value){
8010991d:	55                   	push   %ebp
8010991e:	89 e5                	mov    %esp,%ebp
80109920:	83 ec 04             	sub    $0x4,%esp
80109923:	8b 45 08             	mov    0x8(%ebp),%eax
80109926:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
8010992a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010992e:	c1 e0 08             	shl    $0x8,%eax
80109931:	89 c2                	mov    %eax,%edx
80109933:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109937:	66 c1 e8 08          	shr    $0x8,%ax
8010993b:	01 d0                	add    %edx,%eax
}
8010993d:	c9                   	leave  
8010993e:	c3                   	ret    

8010993f <H2N_ushort>:

ushort H2N_ushort(ushort value){
8010993f:	55                   	push   %ebp
80109940:	89 e5                	mov    %esp,%ebp
80109942:	83 ec 04             	sub    $0x4,%esp
80109945:	8b 45 08             	mov    0x8(%ebp),%eax
80109948:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
8010994c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109950:	c1 e0 08             	shl    $0x8,%eax
80109953:	89 c2                	mov    %eax,%edx
80109955:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109959:	66 c1 e8 08          	shr    $0x8,%ax
8010995d:	01 d0                	add    %edx,%eax
}
8010995f:	c9                   	leave  
80109960:	c3                   	ret    

80109961 <H2N_uint>:

uint H2N_uint(uint value){
80109961:	55                   	push   %ebp
80109962:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109964:	8b 45 08             	mov    0x8(%ebp),%eax
80109967:	c1 e0 18             	shl    $0x18,%eax
8010996a:	25 00 00 00 0f       	and    $0xf000000,%eax
8010996f:	89 c2                	mov    %eax,%edx
80109971:	8b 45 08             	mov    0x8(%ebp),%eax
80109974:	c1 e0 08             	shl    $0x8,%eax
80109977:	25 00 f0 00 00       	and    $0xf000,%eax
8010997c:	09 c2                	or     %eax,%edx
8010997e:	8b 45 08             	mov    0x8(%ebp),%eax
80109981:	c1 e8 08             	shr    $0x8,%eax
80109984:	83 e0 0f             	and    $0xf,%eax
80109987:	01 d0                	add    %edx,%eax
}
80109989:	5d                   	pop    %ebp
8010998a:	c3                   	ret    

8010998b <N2H_uint>:

uint N2H_uint(uint value){
8010998b:	55                   	push   %ebp
8010998c:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010998e:	8b 45 08             	mov    0x8(%ebp),%eax
80109991:	c1 e0 18             	shl    $0x18,%eax
80109994:	89 c2                	mov    %eax,%edx
80109996:	8b 45 08             	mov    0x8(%ebp),%eax
80109999:	c1 e0 08             	shl    $0x8,%eax
8010999c:	25 00 00 ff 00       	and    $0xff0000,%eax
801099a1:	01 c2                	add    %eax,%edx
801099a3:	8b 45 08             	mov    0x8(%ebp),%eax
801099a6:	c1 e8 08             	shr    $0x8,%eax
801099a9:	25 00 ff 00 00       	and    $0xff00,%eax
801099ae:	01 c2                	add    %eax,%edx
801099b0:	8b 45 08             	mov    0x8(%ebp),%eax
801099b3:	c1 e8 18             	shr    $0x18,%eax
801099b6:	01 d0                	add    %edx,%eax
}
801099b8:	5d                   	pop    %ebp
801099b9:	c3                   	ret    

801099ba <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
801099ba:	55                   	push   %ebp
801099bb:	89 e5                	mov    %esp,%ebp
801099bd:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
801099c0:	8b 45 08             	mov    0x8(%ebp),%eax
801099c3:	83 c0 0e             	add    $0xe,%eax
801099c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
801099c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099cc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801099d0:	0f b7 d0             	movzwl %ax,%edx
801099d3:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
801099d8:	39 c2                	cmp    %eax,%edx
801099da:	74 60                	je     80109a3c <ipv4_proc+0x82>
801099dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099df:	83 c0 0c             	add    $0xc,%eax
801099e2:	83 ec 04             	sub    $0x4,%esp
801099e5:	6a 04                	push   $0x4
801099e7:	50                   	push   %eax
801099e8:	68 e4 f4 10 80       	push   $0x8010f4e4
801099ed:	e8 cd b1 ff ff       	call   80104bbf <memcmp>
801099f2:	83 c4 10             	add    $0x10,%esp
801099f5:	85 c0                	test   %eax,%eax
801099f7:	74 43                	je     80109a3c <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801099f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099fc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109a00:	0f b7 c0             	movzwl %ax,%eax
80109a03:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
80109a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a0b:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109a0f:	3c 01                	cmp    $0x1,%al
80109a11:	75 10                	jne    80109a23 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
80109a13:	83 ec 0c             	sub    $0xc,%esp
80109a16:	ff 75 08             	push   0x8(%ebp)
80109a19:	e8 a3 00 00 00       	call   80109ac1 <icmp_proc>
80109a1e:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
80109a21:	eb 19                	jmp    80109a3c <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a26:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109a2a:	3c 06                	cmp    $0x6,%al
80109a2c:	75 0e                	jne    80109a3c <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
80109a2e:	83 ec 0c             	sub    $0xc,%esp
80109a31:	ff 75 08             	push   0x8(%ebp)
80109a34:	e8 b3 03 00 00       	call   80109dec <tcp_proc>
80109a39:	83 c4 10             	add    $0x10,%esp
}
80109a3c:	90                   	nop
80109a3d:	c9                   	leave  
80109a3e:	c3                   	ret    

80109a3f <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
80109a3f:	55                   	push   %ebp
80109a40:	89 e5                	mov    %esp,%ebp
80109a42:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109a45:	8b 45 08             	mov    0x8(%ebp),%eax
80109a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
80109a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a4e:	0f b6 00             	movzbl (%eax),%eax
80109a51:	83 e0 0f             	and    $0xf,%eax
80109a54:	01 c0                	add    %eax,%eax
80109a56:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109a59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109a60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109a67:	eb 48                	jmp    80109ab1 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109a69:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a6c:	01 c0                	add    %eax,%eax
80109a6e:	89 c2                	mov    %eax,%edx
80109a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a73:	01 d0                	add    %edx,%eax
80109a75:	0f b6 00             	movzbl (%eax),%eax
80109a78:	0f b6 c0             	movzbl %al,%eax
80109a7b:	c1 e0 08             	shl    $0x8,%eax
80109a7e:	89 c2                	mov    %eax,%edx
80109a80:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a83:	01 c0                	add    %eax,%eax
80109a85:	8d 48 01             	lea    0x1(%eax),%ecx
80109a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a8b:	01 c8                	add    %ecx,%eax
80109a8d:	0f b6 00             	movzbl (%eax),%eax
80109a90:	0f b6 c0             	movzbl %al,%eax
80109a93:	01 d0                	add    %edx,%eax
80109a95:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109a98:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109a9f:	76 0c                	jbe    80109aad <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109aa4:	0f b7 c0             	movzwl %ax,%eax
80109aa7:	83 c0 01             	add    $0x1,%eax
80109aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109aad:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109ab1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109ab5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109ab8:	7c af                	jl     80109a69 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109abd:	f7 d0                	not    %eax
}
80109abf:	c9                   	leave  
80109ac0:	c3                   	ret    

80109ac1 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109ac1:	55                   	push   %ebp
80109ac2:	89 e5                	mov    %esp,%ebp
80109ac4:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80109aca:	83 c0 0e             	add    $0xe,%eax
80109acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ad3:	0f b6 00             	movzbl (%eax),%eax
80109ad6:	0f b6 c0             	movzbl %al,%eax
80109ad9:	83 e0 0f             	and    $0xf,%eax
80109adc:	c1 e0 02             	shl    $0x2,%eax
80109adf:	89 c2                	mov    %eax,%edx
80109ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ae4:	01 d0                	add    %edx,%eax
80109ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109aec:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109af0:	84 c0                	test   %al,%al
80109af2:	75 4f                	jne    80109b43 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
80109af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109af7:	0f b6 00             	movzbl (%eax),%eax
80109afa:	3c 08                	cmp    $0x8,%al
80109afc:	75 45                	jne    80109b43 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109afe:	e8 82 8c ff ff       	call   80102785 <kalloc>
80109b03:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109b06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109b0d:	83 ec 04             	sub    $0x4,%esp
80109b10:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109b13:	50                   	push   %eax
80109b14:	ff 75 ec             	push   -0x14(%ebp)
80109b17:	ff 75 08             	push   0x8(%ebp)
80109b1a:	e8 78 00 00 00       	call   80109b97 <icmp_reply_pkt_create>
80109b1f:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109b22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109b25:	83 ec 08             	sub    $0x8,%esp
80109b28:	50                   	push   %eax
80109b29:	ff 75 ec             	push   -0x14(%ebp)
80109b2c:	e8 95 f4 ff ff       	call   80108fc6 <i8254_send>
80109b31:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109b37:	83 ec 0c             	sub    $0xc,%esp
80109b3a:	50                   	push   %eax
80109b3b:	e8 ab 8b ff ff       	call   801026eb <kfree>
80109b40:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109b43:	90                   	nop
80109b44:	c9                   	leave  
80109b45:	c3                   	ret    

80109b46 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109b46:	55                   	push   %ebp
80109b47:	89 e5                	mov    %esp,%ebp
80109b49:	53                   	push   %ebx
80109b4a:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
80109b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80109b50:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109b54:	0f b7 c0             	movzwl %ax,%eax
80109b57:	83 ec 0c             	sub    $0xc,%esp
80109b5a:	50                   	push   %eax
80109b5b:	e8 bd fd ff ff       	call   8010991d <N2H_ushort>
80109b60:	83 c4 10             	add    $0x10,%esp
80109b63:	0f b7 d8             	movzwl %ax,%ebx
80109b66:	8b 45 08             	mov    0x8(%ebp),%eax
80109b69:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109b6d:	0f b7 c0             	movzwl %ax,%eax
80109b70:	83 ec 0c             	sub    $0xc,%esp
80109b73:	50                   	push   %eax
80109b74:	e8 a4 fd ff ff       	call   8010991d <N2H_ushort>
80109b79:	83 c4 10             	add    $0x10,%esp
80109b7c:	0f b7 c0             	movzwl %ax,%eax
80109b7f:	83 ec 04             	sub    $0x4,%esp
80109b82:	53                   	push   %ebx
80109b83:	50                   	push   %eax
80109b84:	68 83 c5 10 80       	push   $0x8010c583
80109b89:	e8 66 68 ff ff       	call   801003f4 <cprintf>
80109b8e:	83 c4 10             	add    $0x10,%esp
}
80109b91:	90                   	nop
80109b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109b95:	c9                   	leave  
80109b96:	c3                   	ret    

80109b97 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109b97:	55                   	push   %ebp
80109b98:	89 e5                	mov    %esp,%ebp
80109b9a:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80109ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80109ba6:	83 c0 0e             	add    $0xe,%eax
80109ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109baf:	0f b6 00             	movzbl (%eax),%eax
80109bb2:	0f b6 c0             	movzbl %al,%eax
80109bb5:	83 e0 0f             	and    $0xf,%eax
80109bb8:	c1 e0 02             	shl    $0x2,%eax
80109bbb:	89 c2                	mov    %eax,%edx
80109bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bc0:	01 d0                	add    %edx,%eax
80109bc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bce:	83 c0 0e             	add    $0xe,%eax
80109bd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109bd7:	83 c0 14             	add    $0x14,%eax
80109bda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109bdd:	8b 45 10             	mov    0x10(%ebp),%eax
80109be0:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109be9:	8d 50 06             	lea    0x6(%eax),%edx
80109bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bef:	83 ec 04             	sub    $0x4,%esp
80109bf2:	6a 06                	push   $0x6
80109bf4:	52                   	push   %edx
80109bf5:	50                   	push   %eax
80109bf6:	e8 1c b0 ff ff       	call   80104c17 <memmove>
80109bfb:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c01:	83 c0 06             	add    $0x6,%eax
80109c04:	83 ec 04             	sub    $0x4,%esp
80109c07:	6a 06                	push   $0x6
80109c09:	68 a0 6f 19 80       	push   $0x80196fa0
80109c0e:	50                   	push   %eax
80109c0f:	e8 03 b0 ff ff       	call   80104c17 <memmove>
80109c14:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c1a:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c21:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c28:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c2e:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109c32:	83 ec 0c             	sub    $0xc,%esp
80109c35:	6a 54                	push   $0x54
80109c37:	e8 03 fd ff ff       	call   8010993f <H2N_ushort>
80109c3c:	83 c4 10             	add    $0x10,%esp
80109c3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c42:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109c46:	0f b7 15 80 72 19 80 	movzwl 0x80197280,%edx
80109c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c50:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109c54:	0f b7 05 80 72 19 80 	movzwl 0x80197280,%eax
80109c5b:	83 c0 01             	add    $0x1,%eax
80109c5e:	66 a3 80 72 19 80    	mov    %ax,0x80197280
  ipv4_send->fragment = H2N_ushort(0x4000);
80109c64:	83 ec 0c             	sub    $0xc,%esp
80109c67:	68 00 40 00 00       	push   $0x4000
80109c6c:	e8 ce fc ff ff       	call   8010993f <H2N_ushort>
80109c71:	83 c4 10             	add    $0x10,%esp
80109c74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c77:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c7e:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c85:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c8c:	83 c0 0c             	add    $0xc,%eax
80109c8f:	83 ec 04             	sub    $0x4,%esp
80109c92:	6a 04                	push   $0x4
80109c94:	68 e4 f4 10 80       	push   $0x8010f4e4
80109c99:	50                   	push   %eax
80109c9a:	e8 78 af ff ff       	call   80104c17 <memmove>
80109c9f:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ca5:	8d 50 0c             	lea    0xc(%eax),%edx
80109ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cab:	83 c0 10             	add    $0x10,%eax
80109cae:	83 ec 04             	sub    $0x4,%esp
80109cb1:	6a 04                	push   $0x4
80109cb3:	52                   	push   %edx
80109cb4:	50                   	push   %eax
80109cb5:	e8 5d af ff ff       	call   80104c17 <memmove>
80109cba:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cc0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cc9:	83 ec 0c             	sub    $0xc,%esp
80109ccc:	50                   	push   %eax
80109ccd:	e8 6d fd ff ff       	call   80109a3f <ipv4_chksum>
80109cd2:	83 c4 10             	add    $0x10,%esp
80109cd5:	0f b7 c0             	movzwl %ax,%eax
80109cd8:	83 ec 0c             	sub    $0xc,%esp
80109cdb:	50                   	push   %eax
80109cdc:	e8 5e fc ff ff       	call   8010993f <H2N_ushort>
80109ce1:	83 c4 10             	add    $0x10,%esp
80109ce4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109ce7:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109ceb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cee:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cf4:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cfb:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d02:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d09:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d10:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d17:	8d 50 08             	lea    0x8(%eax),%edx
80109d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d1d:	83 c0 08             	add    $0x8,%eax
80109d20:	83 ec 04             	sub    $0x4,%esp
80109d23:	6a 08                	push   $0x8
80109d25:	52                   	push   %edx
80109d26:	50                   	push   %eax
80109d27:	e8 eb ae ff ff       	call   80104c17 <memmove>
80109d2c:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d32:	8d 50 10             	lea    0x10(%eax),%edx
80109d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d38:	83 c0 10             	add    $0x10,%eax
80109d3b:	83 ec 04             	sub    $0x4,%esp
80109d3e:	6a 30                	push   $0x30
80109d40:	52                   	push   %edx
80109d41:	50                   	push   %eax
80109d42:	e8 d0 ae ff ff       	call   80104c17 <memmove>
80109d47:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d4d:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109d53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d56:	83 ec 0c             	sub    $0xc,%esp
80109d59:	50                   	push   %eax
80109d5a:	e8 1c 00 00 00       	call   80109d7b <icmp_chksum>
80109d5f:	83 c4 10             	add    $0x10,%esp
80109d62:	0f b7 c0             	movzwl %ax,%eax
80109d65:	83 ec 0c             	sub    $0xc,%esp
80109d68:	50                   	push   %eax
80109d69:	e8 d1 fb ff ff       	call   8010993f <H2N_ushort>
80109d6e:	83 c4 10             	add    $0x10,%esp
80109d71:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109d74:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109d78:	90                   	nop
80109d79:	c9                   	leave  
80109d7a:	c3                   	ret    

80109d7b <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109d7b:	55                   	push   %ebp
80109d7c:	89 e5                	mov    %esp,%ebp
80109d7e:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109d81:	8b 45 08             	mov    0x8(%ebp),%eax
80109d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109d87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109d8e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109d95:	eb 48                	jmp    80109ddf <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d9a:	01 c0                	add    %eax,%eax
80109d9c:	89 c2                	mov    %eax,%edx
80109d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109da1:	01 d0                	add    %edx,%eax
80109da3:	0f b6 00             	movzbl (%eax),%eax
80109da6:	0f b6 c0             	movzbl %al,%eax
80109da9:	c1 e0 08             	shl    $0x8,%eax
80109dac:	89 c2                	mov    %eax,%edx
80109dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109db1:	01 c0                	add    %eax,%eax
80109db3:	8d 48 01             	lea    0x1(%eax),%ecx
80109db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109db9:	01 c8                	add    %ecx,%eax
80109dbb:	0f b6 00             	movzbl (%eax),%eax
80109dbe:	0f b6 c0             	movzbl %al,%eax
80109dc1:	01 d0                	add    %edx,%eax
80109dc3:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109dc6:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109dcd:	76 0c                	jbe    80109ddb <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109dd2:	0f b7 c0             	movzwl %ax,%eax
80109dd5:	83 c0 01             	add    $0x1,%eax
80109dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109ddb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109ddf:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109de3:	7e b2                	jle    80109d97 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109de8:	f7 d0                	not    %eax
}
80109dea:	c9                   	leave  
80109deb:	c3                   	ret    

80109dec <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109dec:	55                   	push   %ebp
80109ded:	89 e5                	mov    %esp,%ebp
80109def:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109df2:	8b 45 08             	mov    0x8(%ebp),%eax
80109df5:	83 c0 0e             	add    $0xe,%eax
80109df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109dfe:	0f b6 00             	movzbl (%eax),%eax
80109e01:	0f b6 c0             	movzbl %al,%eax
80109e04:	83 e0 0f             	and    $0xf,%eax
80109e07:	c1 e0 02             	shl    $0x2,%eax
80109e0a:	89 c2                	mov    %eax,%edx
80109e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e0f:	01 d0                	add    %edx,%eax
80109e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e17:	83 c0 14             	add    $0x14,%eax
80109e1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109e1d:	e8 63 89 ff ff       	call   80102785 <kalloc>
80109e22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109e25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e2f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109e33:	0f b6 c0             	movzbl %al,%eax
80109e36:	83 e0 02             	and    $0x2,%eax
80109e39:	85 c0                	test   %eax,%eax
80109e3b:	74 3d                	je     80109e7a <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109e3d:	83 ec 0c             	sub    $0xc,%esp
80109e40:	6a 00                	push   $0x0
80109e42:	6a 12                	push   $0x12
80109e44:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109e47:	50                   	push   %eax
80109e48:	ff 75 e8             	push   -0x18(%ebp)
80109e4b:	ff 75 08             	push   0x8(%ebp)
80109e4e:	e8 a2 01 00 00       	call   80109ff5 <tcp_pkt_create>
80109e53:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109e56:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109e59:	83 ec 08             	sub    $0x8,%esp
80109e5c:	50                   	push   %eax
80109e5d:	ff 75 e8             	push   -0x18(%ebp)
80109e60:	e8 61 f1 ff ff       	call   80108fc6 <i8254_send>
80109e65:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109e68:	a1 84 72 19 80       	mov    0x80197284,%eax
80109e6d:	83 c0 01             	add    $0x1,%eax
80109e70:	a3 84 72 19 80       	mov    %eax,0x80197284
80109e75:	e9 69 01 00 00       	jmp    80109fe3 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e7d:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109e81:	3c 18                	cmp    $0x18,%al
80109e83:	0f 85 10 01 00 00    	jne    80109f99 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109e89:	83 ec 04             	sub    $0x4,%esp
80109e8c:	6a 03                	push   $0x3
80109e8e:	68 9e c5 10 80       	push   $0x8010c59e
80109e93:	ff 75 ec             	push   -0x14(%ebp)
80109e96:	e8 24 ad ff ff       	call   80104bbf <memcmp>
80109e9b:	83 c4 10             	add    $0x10,%esp
80109e9e:	85 c0                	test   %eax,%eax
80109ea0:	74 74                	je     80109f16 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109ea2:	83 ec 0c             	sub    $0xc,%esp
80109ea5:	68 a2 c5 10 80       	push   $0x8010c5a2
80109eaa:	e8 45 65 ff ff       	call   801003f4 <cprintf>
80109eaf:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109eb2:	83 ec 0c             	sub    $0xc,%esp
80109eb5:	6a 00                	push   $0x0
80109eb7:	6a 10                	push   $0x10
80109eb9:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ebc:	50                   	push   %eax
80109ebd:	ff 75 e8             	push   -0x18(%ebp)
80109ec0:	ff 75 08             	push   0x8(%ebp)
80109ec3:	e8 2d 01 00 00       	call   80109ff5 <tcp_pkt_create>
80109ec8:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109ece:	83 ec 08             	sub    $0x8,%esp
80109ed1:	50                   	push   %eax
80109ed2:	ff 75 e8             	push   -0x18(%ebp)
80109ed5:	e8 ec f0 ff ff       	call   80108fc6 <i8254_send>
80109eda:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ee0:	83 c0 36             	add    $0x36,%eax
80109ee3:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109ee6:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109ee9:	50                   	push   %eax
80109eea:	ff 75 e0             	push   -0x20(%ebp)
80109eed:	6a 00                	push   $0x0
80109eef:	6a 00                	push   $0x0
80109ef1:	e8 5a 04 00 00       	call   8010a350 <http_proc>
80109ef6:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109ef9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109efc:	83 ec 0c             	sub    $0xc,%esp
80109eff:	50                   	push   %eax
80109f00:	6a 18                	push   $0x18
80109f02:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f05:	50                   	push   %eax
80109f06:	ff 75 e8             	push   -0x18(%ebp)
80109f09:	ff 75 08             	push   0x8(%ebp)
80109f0c:	e8 e4 00 00 00       	call   80109ff5 <tcp_pkt_create>
80109f11:	83 c4 20             	add    $0x20,%esp
80109f14:	eb 62                	jmp    80109f78 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109f16:	83 ec 0c             	sub    $0xc,%esp
80109f19:	6a 00                	push   $0x0
80109f1b:	6a 10                	push   $0x10
80109f1d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f20:	50                   	push   %eax
80109f21:	ff 75 e8             	push   -0x18(%ebp)
80109f24:	ff 75 08             	push   0x8(%ebp)
80109f27:	e8 c9 00 00 00       	call   80109ff5 <tcp_pkt_create>
80109f2c:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109f2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109f32:	83 ec 08             	sub    $0x8,%esp
80109f35:	50                   	push   %eax
80109f36:	ff 75 e8             	push   -0x18(%ebp)
80109f39:	e8 88 f0 ff ff       	call   80108fc6 <i8254_send>
80109f3e:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f44:	83 c0 36             	add    $0x36,%eax
80109f47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109f4a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f4d:	50                   	push   %eax
80109f4e:	ff 75 e4             	push   -0x1c(%ebp)
80109f51:	6a 00                	push   $0x0
80109f53:	6a 00                	push   $0x0
80109f55:	e8 f6 03 00 00       	call   8010a350 <http_proc>
80109f5a:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109f5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109f60:	83 ec 0c             	sub    $0xc,%esp
80109f63:	50                   	push   %eax
80109f64:	6a 18                	push   $0x18
80109f66:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f69:	50                   	push   %eax
80109f6a:	ff 75 e8             	push   -0x18(%ebp)
80109f6d:	ff 75 08             	push   0x8(%ebp)
80109f70:	e8 80 00 00 00       	call   80109ff5 <tcp_pkt_create>
80109f75:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109f7b:	83 ec 08             	sub    $0x8,%esp
80109f7e:	50                   	push   %eax
80109f7f:	ff 75 e8             	push   -0x18(%ebp)
80109f82:	e8 3f f0 ff ff       	call   80108fc6 <i8254_send>
80109f87:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109f8a:	a1 84 72 19 80       	mov    0x80197284,%eax
80109f8f:	83 c0 01             	add    $0x1,%eax
80109f92:	a3 84 72 19 80       	mov    %eax,0x80197284
80109f97:	eb 4a                	jmp    80109fe3 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f9c:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109fa0:	3c 10                	cmp    $0x10,%al
80109fa2:	75 3f                	jne    80109fe3 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109fa4:	a1 88 72 19 80       	mov    0x80197288,%eax
80109fa9:	83 f8 01             	cmp    $0x1,%eax
80109fac:	75 35                	jne    80109fe3 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109fae:	83 ec 0c             	sub    $0xc,%esp
80109fb1:	6a 00                	push   $0x0
80109fb3:	6a 01                	push   $0x1
80109fb5:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109fb8:	50                   	push   %eax
80109fb9:	ff 75 e8             	push   -0x18(%ebp)
80109fbc:	ff 75 08             	push   0x8(%ebp)
80109fbf:	e8 31 00 00 00       	call   80109ff5 <tcp_pkt_create>
80109fc4:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109fc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109fca:	83 ec 08             	sub    $0x8,%esp
80109fcd:	50                   	push   %eax
80109fce:	ff 75 e8             	push   -0x18(%ebp)
80109fd1:	e8 f0 ef ff ff       	call   80108fc6 <i8254_send>
80109fd6:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109fd9:	c7 05 88 72 19 80 00 	movl   $0x0,0x80197288
80109fe0:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fe6:	83 ec 0c             	sub    $0xc,%esp
80109fe9:	50                   	push   %eax
80109fea:	e8 fc 86 ff ff       	call   801026eb <kfree>
80109fef:	83 c4 10             	add    $0x10,%esp
}
80109ff2:	90                   	nop
80109ff3:	c9                   	leave  
80109ff4:	c3                   	ret    

80109ff5 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109ff5:	55                   	push   %ebp
80109ff6:	89 e5                	mov    %esp,%ebp
80109ff8:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80109ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
8010a001:	8b 45 08             	mov    0x8(%ebp),%eax
8010a004:	83 c0 0e             	add    $0xe,%eax
8010a007:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
8010a00a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a00d:	0f b6 00             	movzbl (%eax),%eax
8010a010:	0f b6 c0             	movzbl %al,%eax
8010a013:	83 e0 0f             	and    $0xf,%eax
8010a016:	c1 e0 02             	shl    $0x2,%eax
8010a019:	89 c2                	mov    %eax,%edx
8010a01b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a01e:	01 d0                	add    %edx,%eax
8010a020:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
8010a023:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a026:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
8010a029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a02c:	83 c0 0e             	add    $0xe,%eax
8010a02f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
8010a032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a035:	83 c0 14             	add    $0x14,%eax
8010a038:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
8010a03b:	8b 45 18             	mov    0x18(%ebp),%eax
8010a03e:	8d 50 36             	lea    0x36(%eax),%edx
8010a041:	8b 45 10             	mov    0x10(%ebp),%eax
8010a044:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
8010a046:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a049:	8d 50 06             	lea    0x6(%eax),%edx
8010a04c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a04f:	83 ec 04             	sub    $0x4,%esp
8010a052:	6a 06                	push   $0x6
8010a054:	52                   	push   %edx
8010a055:	50                   	push   %eax
8010a056:	e8 bc ab ff ff       	call   80104c17 <memmove>
8010a05b:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
8010a05e:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a061:	83 c0 06             	add    $0x6,%eax
8010a064:	83 ec 04             	sub    $0x4,%esp
8010a067:	6a 06                	push   $0x6
8010a069:	68 a0 6f 19 80       	push   $0x80196fa0
8010a06e:	50                   	push   %eax
8010a06f:	e8 a3 ab ff ff       	call   80104c17 <memmove>
8010a074:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010a077:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a07a:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010a07e:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a081:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010a085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a088:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010a08b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a08e:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
8010a092:	8b 45 18             	mov    0x18(%ebp),%eax
8010a095:	83 c0 28             	add    $0x28,%eax
8010a098:	0f b7 c0             	movzwl %ax,%eax
8010a09b:	83 ec 0c             	sub    $0xc,%esp
8010a09e:	50                   	push   %eax
8010a09f:	e8 9b f8 ff ff       	call   8010993f <H2N_ushort>
8010a0a4:	83 c4 10             	add    $0x10,%esp
8010a0a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a0aa:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
8010a0ae:	0f b7 15 80 72 19 80 	movzwl 0x80197280,%edx
8010a0b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0b8:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
8010a0bc:	0f b7 05 80 72 19 80 	movzwl 0x80197280,%eax
8010a0c3:	83 c0 01             	add    $0x1,%eax
8010a0c6:	66 a3 80 72 19 80    	mov    %ax,0x80197280
  ipv4_send->fragment = H2N_ushort(0x0000);
8010a0cc:	83 ec 0c             	sub    $0xc,%esp
8010a0cf:	6a 00                	push   $0x0
8010a0d1:	e8 69 f8 ff ff       	call   8010993f <H2N_ushort>
8010a0d6:	83 c4 10             	add    $0x10,%esp
8010a0d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a0dc:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010a0e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0e3:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
8010a0e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0ea:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010a0ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0f1:	83 c0 0c             	add    $0xc,%eax
8010a0f4:	83 ec 04             	sub    $0x4,%esp
8010a0f7:	6a 04                	push   $0x4
8010a0f9:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a0fe:	50                   	push   %eax
8010a0ff:	e8 13 ab ff ff       	call   80104c17 <memmove>
8010a104:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
8010a107:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a10a:	8d 50 0c             	lea    0xc(%eax),%edx
8010a10d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a110:	83 c0 10             	add    $0x10,%eax
8010a113:	83 ec 04             	sub    $0x4,%esp
8010a116:	6a 04                	push   $0x4
8010a118:	52                   	push   %edx
8010a119:	50                   	push   %eax
8010a11a:	e8 f8 aa ff ff       	call   80104c17 <memmove>
8010a11f:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010a122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a125:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010a12b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a12e:	83 ec 0c             	sub    $0xc,%esp
8010a131:	50                   	push   %eax
8010a132:	e8 08 f9 ff ff       	call   80109a3f <ipv4_chksum>
8010a137:	83 c4 10             	add    $0x10,%esp
8010a13a:	0f b7 c0             	movzwl %ax,%eax
8010a13d:	83 ec 0c             	sub    $0xc,%esp
8010a140:	50                   	push   %eax
8010a141:	e8 f9 f7 ff ff       	call   8010993f <H2N_ushort>
8010a146:	83 c4 10             	add    $0x10,%esp
8010a149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a14c:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
8010a150:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a153:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010a157:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a15a:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
8010a15d:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a160:	0f b7 10             	movzwl (%eax),%edx
8010a163:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a166:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
8010a16a:	a1 84 72 19 80       	mov    0x80197284,%eax
8010a16f:	83 ec 0c             	sub    $0xc,%esp
8010a172:	50                   	push   %eax
8010a173:	e8 e9 f7 ff ff       	call   80109961 <H2N_uint>
8010a178:	83 c4 10             	add    $0x10,%esp
8010a17b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a17e:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
8010a181:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a184:	8b 40 04             	mov    0x4(%eax),%eax
8010a187:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
8010a18d:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a190:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
8010a193:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a196:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
8010a19a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a19d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
8010a1a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a1a4:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
8010a1a8:	8b 45 14             	mov    0x14(%ebp),%eax
8010a1ab:	89 c2                	mov    %eax,%edx
8010a1ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a1b0:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
8010a1b3:	83 ec 0c             	sub    $0xc,%esp
8010a1b6:	68 90 38 00 00       	push   $0x3890
8010a1bb:	e8 7f f7 ff ff       	call   8010993f <H2N_ushort>
8010a1c0:	83 c4 10             	add    $0x10,%esp
8010a1c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a1c6:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
8010a1ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a1cd:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
8010a1d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a1d6:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
8010a1dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a1df:	83 ec 0c             	sub    $0xc,%esp
8010a1e2:	50                   	push   %eax
8010a1e3:	e8 1f 00 00 00       	call   8010a207 <tcp_chksum>
8010a1e8:	83 c4 10             	add    $0x10,%esp
8010a1eb:	83 c0 08             	add    $0x8,%eax
8010a1ee:	0f b7 c0             	movzwl %ax,%eax
8010a1f1:	83 ec 0c             	sub    $0xc,%esp
8010a1f4:	50                   	push   %eax
8010a1f5:	e8 45 f7 ff ff       	call   8010993f <H2N_ushort>
8010a1fa:	83 c4 10             	add    $0x10,%esp
8010a1fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a200:	66 89 42 10          	mov    %ax,0x10(%edx)


}
8010a204:	90                   	nop
8010a205:	c9                   	leave  
8010a206:	c3                   	ret    

8010a207 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
8010a207:	55                   	push   %ebp
8010a208:	89 e5                	mov    %esp,%ebp
8010a20a:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
8010a20d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a210:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
8010a213:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a216:	83 c0 14             	add    $0x14,%eax
8010a219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
8010a21c:	83 ec 04             	sub    $0x4,%esp
8010a21f:	6a 04                	push   $0x4
8010a221:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a226:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a229:	50                   	push   %eax
8010a22a:	e8 e8 a9 ff ff       	call   80104c17 <memmove>
8010a22f:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a232:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a235:	83 c0 0c             	add    $0xc,%eax
8010a238:	83 ec 04             	sub    $0x4,%esp
8010a23b:	6a 04                	push   $0x4
8010a23d:	50                   	push   %eax
8010a23e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a241:	83 c0 04             	add    $0x4,%eax
8010a244:	50                   	push   %eax
8010a245:	e8 cd a9 ff ff       	call   80104c17 <memmove>
8010a24a:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a24d:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a251:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a255:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a258:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a25c:	0f b7 c0             	movzwl %ax,%eax
8010a25f:	83 ec 0c             	sub    $0xc,%esp
8010a262:	50                   	push   %eax
8010a263:	e8 b5 f6 ff ff       	call   8010991d <N2H_ushort>
8010a268:	83 c4 10             	add    $0x10,%esp
8010a26b:	83 e8 14             	sub    $0x14,%eax
8010a26e:	0f b7 c0             	movzwl %ax,%eax
8010a271:	83 ec 0c             	sub    $0xc,%esp
8010a274:	50                   	push   %eax
8010a275:	e8 c5 f6 ff ff       	call   8010993f <H2N_ushort>
8010a27a:	83 c4 10             	add    $0x10,%esp
8010a27d:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a288:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a28b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a28e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a295:	eb 33                	jmp    8010a2ca <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a297:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a29a:	01 c0                	add    %eax,%eax
8010a29c:	89 c2                	mov    %eax,%edx
8010a29e:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2a1:	01 d0                	add    %edx,%eax
8010a2a3:	0f b6 00             	movzbl (%eax),%eax
8010a2a6:	0f b6 c0             	movzbl %al,%eax
8010a2a9:	c1 e0 08             	shl    $0x8,%eax
8010a2ac:	89 c2                	mov    %eax,%edx
8010a2ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a2b1:	01 c0                	add    %eax,%eax
8010a2b3:	8d 48 01             	lea    0x1(%eax),%ecx
8010a2b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2b9:	01 c8                	add    %ecx,%eax
8010a2bb:	0f b6 00             	movzbl (%eax),%eax
8010a2be:	0f b6 c0             	movzbl %al,%eax
8010a2c1:	01 d0                	add    %edx,%eax
8010a2c3:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a2c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a2ca:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a2ce:	7e c7                	jle    8010a297 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a2d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a2d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a2d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a2dd:	eb 33                	jmp    8010a312 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a2df:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2e2:	01 c0                	add    %eax,%eax
8010a2e4:	89 c2                	mov    %eax,%edx
8010a2e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2e9:	01 d0                	add    %edx,%eax
8010a2eb:	0f b6 00             	movzbl (%eax),%eax
8010a2ee:	0f b6 c0             	movzbl %al,%eax
8010a2f1:	c1 e0 08             	shl    $0x8,%eax
8010a2f4:	89 c2                	mov    %eax,%edx
8010a2f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2f9:	01 c0                	add    %eax,%eax
8010a2fb:	8d 48 01             	lea    0x1(%eax),%ecx
8010a2fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a301:	01 c8                	add    %ecx,%eax
8010a303:	0f b6 00             	movzbl (%eax),%eax
8010a306:	0f b6 c0             	movzbl %al,%eax
8010a309:	01 d0                	add    %edx,%eax
8010a30b:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a30e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a312:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a316:	0f b7 c0             	movzwl %ax,%eax
8010a319:	83 ec 0c             	sub    $0xc,%esp
8010a31c:	50                   	push   %eax
8010a31d:	e8 fb f5 ff ff       	call   8010991d <N2H_ushort>
8010a322:	83 c4 10             	add    $0x10,%esp
8010a325:	66 d1 e8             	shr    %ax
8010a328:	0f b7 c0             	movzwl %ax,%eax
8010a32b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a32e:	7c af                	jl     8010a2df <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a330:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a333:	c1 e8 10             	shr    $0x10,%eax
8010a336:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a33c:	f7 d0                	not    %eax
}
8010a33e:	c9                   	leave  
8010a33f:	c3                   	ret    

8010a340 <tcp_fin>:

void tcp_fin(){
8010a340:	55                   	push   %ebp
8010a341:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a343:	c7 05 88 72 19 80 01 	movl   $0x1,0x80197288
8010a34a:	00 00 00 
}
8010a34d:	90                   	nop
8010a34e:	5d                   	pop    %ebp
8010a34f:	c3                   	ret    

8010a350 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a350:	55                   	push   %ebp
8010a351:	89 e5                	mov    %esp,%ebp
8010a353:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a356:	8b 45 10             	mov    0x10(%ebp),%eax
8010a359:	83 ec 04             	sub    $0x4,%esp
8010a35c:	6a 00                	push   $0x0
8010a35e:	68 ab c5 10 80       	push   $0x8010c5ab
8010a363:	50                   	push   %eax
8010a364:	e8 65 00 00 00       	call   8010a3ce <http_strcpy>
8010a369:	83 c4 10             	add    $0x10,%esp
8010a36c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a36f:	8b 45 10             	mov    0x10(%ebp),%eax
8010a372:	83 ec 04             	sub    $0x4,%esp
8010a375:	ff 75 f4             	push   -0xc(%ebp)
8010a378:	68 be c5 10 80       	push   $0x8010c5be
8010a37d:	50                   	push   %eax
8010a37e:	e8 4b 00 00 00       	call   8010a3ce <http_strcpy>
8010a383:	83 c4 10             	add    $0x10,%esp
8010a386:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a389:	8b 45 10             	mov    0x10(%ebp),%eax
8010a38c:	83 ec 04             	sub    $0x4,%esp
8010a38f:	ff 75 f4             	push   -0xc(%ebp)
8010a392:	68 d9 c5 10 80       	push   $0x8010c5d9
8010a397:	50                   	push   %eax
8010a398:	e8 31 00 00 00       	call   8010a3ce <http_strcpy>
8010a39d:	83 c4 10             	add    $0x10,%esp
8010a3a0:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a3a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a3a6:	83 e0 01             	and    $0x1,%eax
8010a3a9:	85 c0                	test   %eax,%eax
8010a3ab:	74 11                	je     8010a3be <http_proc+0x6e>
    char *payload = (char *)send;
8010a3ad:	8b 45 10             	mov    0x10(%ebp),%eax
8010a3b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a3b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a3b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a3b9:	01 d0                	add    %edx,%eax
8010a3bb:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a3be:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a3c1:	8b 45 14             	mov    0x14(%ebp),%eax
8010a3c4:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a3c6:	e8 75 ff ff ff       	call   8010a340 <tcp_fin>
}
8010a3cb:	90                   	nop
8010a3cc:	c9                   	leave  
8010a3cd:	c3                   	ret    

8010a3ce <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a3ce:	55                   	push   %ebp
8010a3cf:	89 e5                	mov    %esp,%ebp
8010a3d1:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a3d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a3db:	eb 20                	jmp    8010a3fd <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a3dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a3e3:	01 d0                	add    %edx,%eax
8010a3e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a3e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a3eb:	01 ca                	add    %ecx,%edx
8010a3ed:	89 d1                	mov    %edx,%ecx
8010a3ef:	8b 55 08             	mov    0x8(%ebp),%edx
8010a3f2:	01 ca                	add    %ecx,%edx
8010a3f4:	0f b6 00             	movzbl (%eax),%eax
8010a3f7:	88 02                	mov    %al,(%edx)
    i++;
8010a3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a3fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a400:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a403:	01 d0                	add    %edx,%eax
8010a405:	0f b6 00             	movzbl (%eax),%eax
8010a408:	84 c0                	test   %al,%al
8010a40a:	75 d1                	jne    8010a3dd <http_strcpy+0xf>
  }
  return i;
8010a40c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a40f:	c9                   	leave  
8010a410:	c3                   	ret    

8010a411 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a411:	55                   	push   %ebp
8010a412:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a414:	c7 05 90 72 19 80 a2 	movl   $0x8010f5a2,0x80197290
8010a41b:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a41e:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a423:	c1 e8 09             	shr    $0x9,%eax
8010a426:	a3 8c 72 19 80       	mov    %eax,0x8019728c
}
8010a42b:	90                   	nop
8010a42c:	5d                   	pop    %ebp
8010a42d:	c3                   	ret    

8010a42e <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a42e:	55                   	push   %ebp
8010a42f:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a431:	90                   	nop
8010a432:	5d                   	pop    %ebp
8010a433:	c3                   	ret    

8010a434 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a434:	55                   	push   %ebp
8010a435:	89 e5                	mov    %esp,%ebp
8010a437:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a43a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a43d:	83 c0 0c             	add    $0xc,%eax
8010a440:	83 ec 0c             	sub    $0xc,%esp
8010a443:	50                   	push   %eax
8010a444:	e8 08 a4 ff ff       	call   80104851 <holdingsleep>
8010a449:	83 c4 10             	add    $0x10,%esp
8010a44c:	85 c0                	test   %eax,%eax
8010a44e:	75 0d                	jne    8010a45d <iderw+0x29>
    panic("iderw: buf not locked");
8010a450:	83 ec 0c             	sub    $0xc,%esp
8010a453:	68 ea c5 10 80       	push   $0x8010c5ea
8010a458:	e8 4c 61 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a45d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a460:	8b 00                	mov    (%eax),%eax
8010a462:	83 e0 06             	and    $0x6,%eax
8010a465:	83 f8 02             	cmp    $0x2,%eax
8010a468:	75 0d                	jne    8010a477 <iderw+0x43>
    panic("iderw: nothing to do");
8010a46a:	83 ec 0c             	sub    $0xc,%esp
8010a46d:	68 00 c6 10 80       	push   $0x8010c600
8010a472:	e8 32 61 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a477:	8b 45 08             	mov    0x8(%ebp),%eax
8010a47a:	8b 40 04             	mov    0x4(%eax),%eax
8010a47d:	83 f8 01             	cmp    $0x1,%eax
8010a480:	74 0d                	je     8010a48f <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a482:	83 ec 0c             	sub    $0xc,%esp
8010a485:	68 15 c6 10 80       	push   $0x8010c615
8010a48a:	e8 1a 61 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a48f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a492:	8b 40 08             	mov    0x8(%eax),%eax
8010a495:	8b 15 8c 72 19 80    	mov    0x8019728c,%edx
8010a49b:	39 d0                	cmp    %edx,%eax
8010a49d:	72 0d                	jb     8010a4ac <iderw+0x78>
    panic("iderw: block out of range");
8010a49f:	83 ec 0c             	sub    $0xc,%esp
8010a4a2:	68 33 c6 10 80       	push   $0x8010c633
8010a4a7:	e8 fd 60 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a4ac:	8b 15 90 72 19 80    	mov    0x80197290,%edx
8010a4b2:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4b5:	8b 40 08             	mov    0x8(%eax),%eax
8010a4b8:	c1 e0 09             	shl    $0x9,%eax
8010a4bb:	01 d0                	add    %edx,%eax
8010a4bd:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a4c0:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4c3:	8b 00                	mov    (%eax),%eax
8010a4c5:	83 e0 04             	and    $0x4,%eax
8010a4c8:	85 c0                	test   %eax,%eax
8010a4ca:	74 2b                	je     8010a4f7 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a4cc:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4cf:	8b 00                	mov    (%eax),%eax
8010a4d1:	83 e0 fb             	and    $0xfffffffb,%eax
8010a4d4:	89 c2                	mov    %eax,%edx
8010a4d6:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4d9:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a4db:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4de:	83 c0 5c             	add    $0x5c,%eax
8010a4e1:	83 ec 04             	sub    $0x4,%esp
8010a4e4:	68 00 02 00 00       	push   $0x200
8010a4e9:	50                   	push   %eax
8010a4ea:	ff 75 f4             	push   -0xc(%ebp)
8010a4ed:	e8 25 a7 ff ff       	call   80104c17 <memmove>
8010a4f2:	83 c4 10             	add    $0x10,%esp
8010a4f5:	eb 1a                	jmp    8010a511 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a4f7:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4fa:	83 c0 5c             	add    $0x5c,%eax
8010a4fd:	83 ec 04             	sub    $0x4,%esp
8010a500:	68 00 02 00 00       	push   $0x200
8010a505:	ff 75 f4             	push   -0xc(%ebp)
8010a508:	50                   	push   %eax
8010a509:	e8 09 a7 ff ff       	call   80104c17 <memmove>
8010a50e:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a511:	8b 45 08             	mov    0x8(%ebp),%eax
8010a514:	8b 00                	mov    (%eax),%eax
8010a516:	83 c8 02             	or     $0x2,%eax
8010a519:	89 c2                	mov    %eax,%edx
8010a51b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a51e:	89 10                	mov    %edx,(%eax)
}
8010a520:	90                   	nop
8010a521:	c9                   	leave  
8010a522:	c3                   	ret    
