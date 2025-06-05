
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
8010006f:	68 e0 a4 10 80       	push   $0x8010a4e0
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 15 48 00 00       	call   80104893 <initlock>
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
801000bd:	68 e7 a4 10 80       	push   $0x8010a4e7
801000c2:	50                   	push   %eax
801000c3:	e8 6e 46 00 00       	call   80104736 <initsleeplock>
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
80100101:	e8 af 47 00 00       	call   801048b5 <acquire>
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
80100140:	e8 de 47 00 00       	call   80104923 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 1b 46 00 00       	call   80104772 <acquiresleep>
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
801001c1:	e8 5d 47 00 00       	call   80104923 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 9a 45 00 00       	call   80104772 <acquiresleep>
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
801001f5:	68 ee a4 10 80       	push   $0x8010a4ee
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
8010022d:	e8 b5 a1 00 00       	call   8010a3e7 <iderw>
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
8010024a:	e8 d5 45 00 00       	call   80104824 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 ff a4 10 80       	push   $0x8010a4ff
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
80100278:	e8 6a a1 00 00       	call   8010a3e7 <iderw>
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
80100293:	e8 8c 45 00 00       	call   80104824 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 06 a5 10 80       	push   $0x8010a506
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 1b 45 00 00       	call   801047d6 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 ea 45 00 00       	call   801048b5 <acquire>
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
80100336:	e8 e8 45 00 00       	call   80104923 <release>
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
80100410:	e8 a0 44 00 00       	call   801048b5 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 0d a5 10 80       	push   $0x8010a50d
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
80100510:	c7 45 ec 16 a5 10 80 	movl   $0x8010a516,-0x14(%ebp)
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
8010059e:	e8 80 43 00 00       	call   80104923 <release>
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
801005c7:	68 1d a5 10 80       	push   $0x8010a51d
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
801005e6:	68 31 a5 10 80       	push   $0x8010a531
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 72 43 00 00       	call   80104975 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 33 a5 10 80       	push   $0x8010a533
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
801006a0:	e8 99 7c 00 00       	call   8010833e <graphic_scroll_up>
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
801006f3:	e8 46 7c 00 00       	call   8010833e <graphic_scroll_up>
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
80100757:	e8 4d 7c 00 00       	call   801083a9 <font_render>
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
80100793:	e8 52 5f 00 00       	call   801066ea <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 45 5f 00 00       	call   801066ea <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 38 5f 00 00       	call   801066ea <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x56>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 28 5f 00 00       	call   801066ea <uartputc>
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
801007eb:	e8 c5 40 00 00       	call   801048b5 <acquire>
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
8010093f:	e8 f5 3a 00 00       	call   80104439 <wakeup>
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
80100962:	e8 bc 3f 00 00       	call   80104923 <release>
80100967:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010096e:	74 05                	je     80100975 <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
80100970:	e8 7f 3b 00 00       	call   801044f4 <procdump>
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
8010099a:	e8 16 3f 00 00       	call   801048b5 <acquire>
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
801009bb:	e8 63 3f 00 00       	call   80104923 <release>
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
801009e8:	e8 65 39 00 00       	call   80104352 <sleep>
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
80100a66:	e8 b8 3e 00 00       	call   80104923 <release>
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
80100aa2:	e8 0e 3e 00 00       	call   801048b5 <acquire>
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
80100ae4:	e8 3a 3e 00 00       	call   80104923 <release>
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
80100b12:	68 37 a5 10 80       	push   $0x8010a537
80100b17:	68 00 1a 19 80       	push   $0x80191a00
80100b1c:	e8 72 3d 00 00       	call   80104893 <initlock>
80100b21:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b24:	c7 05 4c 1a 19 80 86 	movl   $0x80100a86,0x80191a4c
80100b2b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b2e:	c7 05 48 1a 19 80 78 	movl   $0x80100978,0x80191a48
80100b35:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b38:	c7 45 f4 3f a5 10 80 	movl   $0x8010a53f,-0xc(%ebp)
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
80100bb5:	68 55 a5 10 80       	push   $0x8010a555
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
80100c11:	e8 d0 6a 00 00       	call   801076e6 <setupkvm>
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
80100cb7:	e8 23 6e 00 00       	call   80107adf <allocuvm>
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
80100cfd:	e8 10 6d 00 00       	call   80107a12 <loaduvm>
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
80100d73:	e8 67 6d 00 00       	call   80107adf <allocuvm>
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
80100dae:	e8 c6 3f 00 00       	call   80104d79 <strlen>
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
80100ddb:	e8 99 3f 00 00       	call   80104d79 <strlen>
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
80100e01:	e8 a5 71 00 00       	call   80107fab <copyout>
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
80100e9d:	e8 09 71 00 00       	call   80107fab <copyout>
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
80100eeb:	e8 3e 3e 00 00       	call   80104d2e <safestrcpy>
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
80100f2e:	e8 d0 68 00 00       	call   80107803 <switchuvm>
80100f33:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	ff 75 cc             	push   -0x34(%ebp)
80100f3c:	e8 67 6d 00 00       	call   80107ca8 <freevm>
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
80100f7c:	e8 27 6d 00 00       	call   80107ca8 <freevm>
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
80100fad:	68 61 a5 10 80       	push   $0x8010a561
80100fb2:	68 a0 1a 19 80       	push   $0x80191aa0
80100fb7:	e8 d7 38 00 00       	call   80104893 <initlock>
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
80100fd0:	e8 e0 38 00 00       	call   801048b5 <acquire>
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
80100ffd:	e8 21 39 00 00       	call   80104923 <release>
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
80101020:	e8 fe 38 00 00       	call   80104923 <release>
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
8010103d:	e8 73 38 00 00       	call   801048b5 <acquire>
80101042:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	8b 40 04             	mov    0x4(%eax),%eax
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 0d                	jg     8010105c <filedup+0x2d>
    panic("filedup");
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	68 68 a5 10 80       	push   $0x8010a568
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
80101073:	e8 ab 38 00 00       	call   80104923 <release>
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
8010108e:	e8 22 38 00 00       	call   801048b5 <acquire>
80101093:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	8b 40 04             	mov    0x4(%eax),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	7f 0d                	jg     801010ad <fileclose+0x2d>
    panic("fileclose");
801010a0:	83 ec 0c             	sub    $0xc,%esp
801010a3:	68 70 a5 10 80       	push   $0x8010a570
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
801010ce:	e8 50 38 00 00       	call   80104923 <release>
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
8010111c:	e8 02 38 00 00       	call   80104923 <release>
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
8010126b:	68 7a a5 10 80       	push   $0x8010a57a
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
8010136e:	68 83 a5 10 80       	push   $0x8010a583
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
801013a4:	68 93 a5 10 80       	push   $0x8010a593
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
801013dc:	e8 09 38 00 00       	call   80104bea <memmove>
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
80101422:	e8 04 37 00 00       	call   80104b2b <memset>
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
80101581:	68 a0 a5 10 80       	push   $0x8010a5a0
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
8010160c:	68 b6 a5 10 80       	push   $0x8010a5b6
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
80101670:	68 c9 a5 10 80       	push   $0x8010a5c9
80101675:	68 60 24 19 80       	push   $0x80192460
8010167a:	e8 14 32 00 00       	call   80104893 <initlock>
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
801016a6:	68 d0 a5 10 80       	push   $0x8010a5d0
801016ab:	50                   	push   %eax
801016ac:	e8 85 30 00 00       	call   80104736 <initsleeplock>
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
80101705:	68 d8 a5 10 80       	push   $0x8010a5d8
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
8010177e:	e8 a8 33 00 00       	call   80104b2b <memset>
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
801017e6:	68 2b a6 10 80       	push   $0x8010a62b
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
8010188c:	e8 59 33 00 00       	call   80104bea <memmove>
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
801018c1:	e8 ef 2f 00 00       	call   801048b5 <acquire>
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
8010190f:	e8 0f 30 00 00       	call   80104923 <release>
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
8010194b:	68 3d a6 10 80       	push   $0x8010a63d
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
80101988:	e8 96 2f 00 00       	call   80104923 <release>
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
801019a3:	e8 0d 2f 00 00       	call   801048b5 <acquire>
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
801019c2:	e8 5c 2f 00 00       	call   80104923 <release>
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
801019e8:	68 4d a6 10 80       	push   $0x8010a64d
801019ed:	e8 b7 eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	83 c0 0c             	add    $0xc,%eax
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	50                   	push   %eax
801019fc:	e8 71 2d 00 00       	call   80104772 <acquiresleep>
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
80101aa6:	e8 3f 31 00 00       	call   80104bea <memmove>
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
80101ad5:	68 53 a6 10 80       	push   $0x8010a653
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
80101af8:	e8 27 2d 00 00       	call   80104824 <holdingsleep>
80101afd:	83 c4 10             	add    $0x10,%esp
80101b00:	85 c0                	test   %eax,%eax
80101b02:	74 0a                	je     80101b0e <iunlock+0x2c>
80101b04:	8b 45 08             	mov    0x8(%ebp),%eax
80101b07:	8b 40 08             	mov    0x8(%eax),%eax
80101b0a:	85 c0                	test   %eax,%eax
80101b0c:	7f 0d                	jg     80101b1b <iunlock+0x39>
    panic("iunlock");
80101b0e:	83 ec 0c             	sub    $0xc,%esp
80101b11:	68 62 a6 10 80       	push   $0x8010a662
80101b16:	e8 8e ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	83 c0 0c             	add    $0xc,%eax
80101b21:	83 ec 0c             	sub    $0xc,%esp
80101b24:	50                   	push   %eax
80101b25:	e8 ac 2c 00 00       	call   801047d6 <releasesleep>
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
80101b40:	e8 2d 2c 00 00       	call   80104772 <acquiresleep>
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
80101b66:	e8 4a 2d 00 00       	call   801048b5 <acquire>
80101b6b:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 40 08             	mov    0x8(%eax),%eax
80101b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b77:	83 ec 0c             	sub    $0xc,%esp
80101b7a:	68 60 24 19 80       	push   $0x80192460
80101b7f:	e8 9f 2d 00 00       	call   80104923 <release>
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
80101bc6:	e8 0b 2c 00 00       	call   801047d6 <releasesleep>
80101bcb:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101bce:	83 ec 0c             	sub    $0xc,%esp
80101bd1:	68 60 24 19 80       	push   $0x80192460
80101bd6:	e8 da 2c 00 00       	call   801048b5 <acquire>
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
80101bf5:	e8 29 2d 00 00       	call   80104923 <release>
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
80101d39:	68 6a a6 10 80       	push   $0x8010a66a
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
80101fd7:	e8 0e 2c 00 00       	call   80104bea <memmove>
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
80102127:	e8 be 2a 00 00       	call   80104bea <memmove>
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
801021a7:	e8 d4 2a 00 00       	call   80104c80 <strncmp>
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
801021c7:	68 7d a6 10 80       	push   $0x8010a67d
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
801021f6:	68 8f a6 10 80       	push   $0x8010a68f
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
801022cb:	68 9e a6 10 80       	push   $0x8010a69e
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
80102306:	e8 cb 29 00 00       	call   80104cd6 <strncpy>
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
80102332:	68 ab a6 10 80       	push   $0x8010a6ab
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
801023a4:	e8 41 28 00 00       	call   80104bea <memmove>
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	eb 26                	jmp    801023d4 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b1:	83 ec 04             	sub    $0x4,%esp
801023b4:	50                   	push   %eax
801023b5:	ff 75 f4             	push   -0xc(%ebp)
801023b8:	ff 75 0c             	push   0xc(%ebp)
801023bb:	e8 2a 28 00 00       	call   80104bea <memmove>
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
801025a0:	0f b6 05 64 6f 19 80 	movzbl 0x80196f64,%eax
801025a7:	0f b6 c0             	movzbl %al,%eax
801025aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025ad:	74 10                	je     801025bf <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025af:	83 ec 0c             	sub    $0xc,%esp
801025b2:	68 b4 a6 10 80       	push   $0x8010a6b4
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
80102659:	68 e6 a6 10 80       	push   $0x8010a6e6
8010265e:	68 c0 40 19 80       	push   $0x801940c0
80102663:	e8 2b 22 00 00       	call   80104893 <initlock>
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
80102718:	68 eb a6 10 80       	push   $0x8010a6eb
8010271d:	e8 87 de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102722:	83 ec 04             	sub    $0x4,%esp
80102725:	68 00 10 00 00       	push   $0x1000
8010272a:	6a 01                	push   $0x1
8010272c:	ff 75 08             	push   0x8(%ebp)
8010272f:	e8 f7 23 00 00       	call   80104b2b <memset>
80102734:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102737:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010273c:	85 c0                	test   %eax,%eax
8010273e:	74 10                	je     80102750 <kfree+0x65>
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 c0 40 19 80       	push   $0x801940c0
80102748:	e8 68 21 00 00       	call   801048b5 <acquire>
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
8010277a:	e8 a4 21 00 00       	call   80104923 <release>
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
8010279c:	e8 14 21 00 00       	call   801048b5 <acquire>
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
801027cd:	e8 51 21 00 00       	call   80104923 <release>
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
80102cf7:	e8 96 1e 00 00       	call   80104b92 <memcmp>
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
80102e0b:	68 f1 a6 10 80       	push   $0x8010a6f1
80102e10:	68 20 41 19 80       	push   $0x80194120
80102e15:	e8 79 1a 00 00       	call   80104893 <initlock>
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
80102ec0:	e8 25 1d 00 00       	call   80104bea <memmove>
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
8010302f:	e8 81 18 00 00       	call   801048b5 <acquire>
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
8010304d:	e8 00 13 00 00       	call   80104352 <sleep>
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
80103082:	e8 cb 12 00 00       	call   80104352 <sleep>
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
801030a1:	e8 7d 18 00 00       	call   80104923 <release>
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
801030c2:	e8 ee 17 00 00       	call   801048b5 <acquire>
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
801030e3:	68 f5 a6 10 80       	push   $0x8010a6f5
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
80103111:	e8 23 13 00 00       	call   80104439 <wakeup>
80103116:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103119:	83 ec 0c             	sub    $0xc,%esp
8010311c:	68 20 41 19 80       	push   $0x80194120
80103121:	e8 fd 17 00 00       	call   80104923 <release>
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
8010313c:	e8 74 17 00 00       	call   801048b5 <acquire>
80103141:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103144:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
8010314b:	00 00 00 
    wakeup(&log);
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	68 20 41 19 80       	push   $0x80194120
80103156:	e8 de 12 00 00       	call   80104439 <wakeup>
8010315b:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010315e:	83 ec 0c             	sub    $0xc,%esp
80103161:	68 20 41 19 80       	push   $0x80194120
80103166:	e8 b8 17 00 00       	call   80104923 <release>
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
801031e2:	e8 03 1a 00 00       	call   80104bea <memmove>
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
8010327f:	68 04 a7 10 80       	push   $0x8010a704
80103284:	e8 20 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
80103289:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	7f 0d                	jg     8010329f <log_write+0x45>
    panic("log_write outside of trans");
80103292:	83 ec 0c             	sub    $0xc,%esp
80103295:	68 1a a7 10 80       	push   $0x8010a71a
8010329a:	e8 0a d3 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
8010329f:	83 ec 0c             	sub    $0xc,%esp
801032a2:	68 20 41 19 80       	push   $0x80194120
801032a7:	e8 09 16 00 00       	call   801048b5 <acquire>
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
80103325:	e8 f9 15 00 00       	call   80104923 <release>
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
8010335b:	e8 23 4f 00 00       	call   80108283 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103360:	83 ec 08             	sub    $0x8,%esp
80103363:	68 00 00 40 80       	push   $0x80400000
80103368:	68 00 90 19 80       	push   $0x80199000
8010336d:	e8 de f2 ff ff       	call   80102650 <kinit1>
80103372:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103375:	e8 58 44 00 00       	call   801077d2 <kvmalloc>
  mpinit_uefi();
8010337a:	e8 ca 4c 00 00       	call   80108049 <mpinit_uefi>
  lapicinit();     // interrupt controller
8010337f:	e8 3c f6 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103384:	e8 e1 3e 00 00       	call   8010726a <seginit>
  picinit();    // disable pic
80103389:	e8 9d 01 00 00       	call   8010352b <picinit>
  ioapicinit();    // another interrupt controller
8010338e:	e8 d8 f1 ff ff       	call   8010256b <ioapicinit>
  consoleinit();   // console hardware
80103393:	e8 67 d7 ff ff       	call   80100aff <consoleinit>
  uartinit();      // serial port
80103398:	e8 66 32 00 00       	call   80106603 <uartinit>
  pinit();         // process table
8010339d:	e8 c2 05 00 00       	call   80103964 <pinit>
  tvinit();        // trap vectors
801033a2:	e8 72 2c 00 00       	call   80106019 <tvinit>
  binit();         // buffer cache
801033a7:	e8 ba cc ff ff       	call   80100066 <binit>
  fileinit();      // file table
801033ac:	e8 f3 db ff ff       	call   80100fa4 <fileinit>
  ideinit();       // disk 
801033b1:	e8 0e 70 00 00       	call   8010a3c4 <ideinit>
  startothers();   // start other processors
801033b6:	e8 8a 00 00 00       	call   80103445 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033bb:	83 ec 08             	sub    $0x8,%esp
801033be:	68 00 00 00 a0       	push   $0xa0000000
801033c3:	68 00 00 40 80       	push   $0x80400000
801033c8:	e8 bc f2 ff ff       	call   80102689 <kinit2>
801033cd:	83 c4 10             	add    $0x10,%esp
  pci_init();
801033d0:	e8 07 51 00 00       	call   801084dc <pci_init>
  arp_scan();
801033d5:	e8 3e 5e 00 00       	call   80109218 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
801033da:	e8 8f 07 00 00       	call   80103b6e <userinit>

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
801033ea:	e8 fb 43 00 00       	call   801077ea <switchkvm>
  seginit();
801033ef:	e8 76 3e 00 00       	call   8010726a <seginit>
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
80103416:	68 35 a7 10 80       	push   $0x8010a735
8010341b:	e8 d4 cf ff ff       	call   801003f4 <cprintf>
80103420:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103423:	e8 67 2d 00 00       	call   8010618f <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103428:	e8 70 05 00 00       	call   8010399d <mycpu>
8010342d:	05 a0 00 00 00       	add    $0xa0,%eax
80103432:	83 ec 08             	sub    $0x8,%esp
80103435:	6a 01                	push   $0x1
80103437:	50                   	push   %eax
80103438:	e8 f3 fe ff ff       	call   80103330 <xchg>
8010343d:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103440:	e8 1c 0d 00 00       	call   80104161 <scheduler>

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
80103463:	e8 82 17 00 00       	call   80104bea <memmove>
80103468:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010346b:	c7 45 f4 a0 6c 19 80 	movl   $0x80196ca0,-0xc(%ebp)
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
801034ed:	a1 60 6f 19 80       	mov    0x80196f60,%eax
801034f2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801034f8:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
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
801035ec:	68 49 a7 10 80       	push   $0x8010a749
801035f1:	50                   	push   %eax
801035f2:	e8 9c 12 00 00       	call   80104893 <initlock>
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
801036b1:	e8 ff 11 00 00       	call   801048b5 <acquire>
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
801036d8:	e8 5c 0d 00 00       	call   80104439 <wakeup>
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
801036fb:	e8 39 0d 00 00       	call   80104439 <wakeup>
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
80103724:	e8 fa 11 00 00       	call   80104923 <release>
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
80103743:	e8 db 11 00 00       	call   80104923 <release>
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
8010375d:	e8 53 11 00 00       	call   801048b5 <acquire>
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
80103791:	e8 8d 11 00 00       	call   80104923 <release>
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
801037af:	e8 85 0c 00 00       	call   80104439 <wakeup>
801037b4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037b7:	8b 45 08             	mov    0x8(%ebp),%eax
801037ba:	8b 55 08             	mov    0x8(%ebp),%edx
801037bd:	81 c2 38 02 00 00    	add    $0x238,%edx
801037c3:	83 ec 08             	sub    $0x8,%esp
801037c6:	50                   	push   %eax
801037c7:	52                   	push   %edx
801037c8:	e8 85 0b 00 00       	call   80104352 <sleep>
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
80103832:	e8 02 0c 00 00       	call   80104439 <wakeup>
80103837:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010383a:	8b 45 08             	mov    0x8(%ebp),%eax
8010383d:	83 ec 0c             	sub    $0xc,%esp
80103840:	50                   	push   %eax
80103841:	e8 dd 10 00 00       	call   80104923 <release>
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
8010385e:	e8 52 10 00 00       	call   801048b5 <acquire>
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
8010387b:	e8 a3 10 00 00       	call   80104923 <release>
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
8010389e:	e8 af 0a 00 00       	call   80104352 <sleep>
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
80103931:	e8 03 0b 00 00       	call   80104439 <wakeup>
80103936:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103939:	8b 45 08             	mov    0x8(%ebp),%eax
8010393c:	83 ec 0c             	sub    $0xc,%esp
8010393f:	50                   	push   %eax
80103940:	e8 de 0f 00 00       	call   80104923 <release>
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
8010396d:	68 50 a7 10 80       	push   $0x8010a750
80103972:	68 00 42 19 80       	push   $0x80194200
80103977:	e8 17 0f 00 00       	call   80104893 <initlock>
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
8010398d:	2d a0 6c 19 80       	sub    $0x80196ca0,%eax
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
801039b4:	68 58 a7 10 80       	push   $0x8010a758
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
801039d8:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
801039dd:	0f b6 00             	movzbl (%eax),%eax
801039e0:	0f b6 c0             	movzbl %al,%eax
801039e3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801039e6:	75 10                	jne    801039f8 <mycpu+0x5b>
      return &cpus[i];
801039e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f1:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
801039f6:	eb 1b                	jmp    80103a13 <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
801039f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039fc:	a1 60 6f 19 80       	mov    0x80196f60,%eax
80103a01:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a04:	7c c9                	jl     801039cf <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	68 7e a7 10 80       	push   $0x8010a77e
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
80103a1b:	e8 00 10 00 00       	call   80104a20 <pushcli>
  c = mycpu();
80103a20:	e8 78 ff ff ff       	call   8010399d <mycpu>
80103a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a2b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a34:	e8 34 10 00 00       	call   80104a6d <popcli>
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
80103a4c:	e8 64 0e 00 00       	call   801048b5 <acquire>
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
80103a67:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103a6b:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103a72:	72 e9                	jb     80103a5d <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103a74:	83 ec 0c             	sub    $0xc,%esp
80103a77:	68 00 42 19 80       	push   $0x80194200
80103a7c:	e8 a2 0e 00 00       	call   80104923 <release>
80103a81:	83 c4 10             	add    $0x10,%esp
  return 0;
80103a84:	b8 00 00 00 00       	mov    $0x0,%eax
80103a89:	e9 de 00 00 00       	jmp    80103b6c <allocproc+0x12e>
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
80103ab5:	c1 f8 07             	sar    $0x7,%eax
80103ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ppid[index] = p->pid;
80103abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abe:	8b 50 10             	mov    0x10(%eax),%edx
80103ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac4:	89 14 85 40 62 19 80 	mov    %edx,-0x7fe69dc0(,%eax,4)
  pspage[index] = 1;
80103acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ace:	c7 04 85 40 63 19 80 	movl   $0x1,-0x7fe69cc0(,%eax,4)
80103ad5:	01 00 00 00 
  release(&ptable.lock);
80103ad9:	83 ec 0c             	sub    $0xc,%esp
80103adc:	68 00 42 19 80       	push   $0x80194200
80103ae1:	e8 3d 0e 00 00       	call   80104923 <release>
80103ae6:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ae9:	e8 97 ec ff ff       	call   80102785 <kalloc>
80103aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103af1:	89 42 08             	mov    %eax,0x8(%edx)
80103af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af7:	8b 40 08             	mov    0x8(%eax),%eax
80103afa:	85 c0                	test   %eax,%eax
80103afc:	75 11                	jne    80103b0f <allocproc+0xd1>
    p->state = UNUSED;
80103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103b08:	b8 00 00 00 00       	mov    $0x0,%eax
80103b0d:	eb 5d                	jmp    80103b6c <allocproc+0x12e>
  }
  sp = p->kstack + KSTACKSIZE;
80103b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b12:	8b 40 08             	mov    0x8(%eax),%eax
80103b15:	05 00 10 00 00       	add    $0x1000,%eax
80103b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b1d:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
  p->tf = (struct trapframe*)sp;
80103b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b24:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b27:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b2a:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
80103b2e:	ba d3 5f 10 80       	mov    $0x80105fd3,%edx
80103b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b36:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b38:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  p->context = (struct context*)sp;
80103b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b42:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b48:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b4b:	83 ec 04             	sub    $0x4,%esp
80103b4e:	6a 14                	push   $0x14
80103b50:	6a 00                	push   $0x0
80103b52:	50                   	push   %eax
80103b53:	e8 d3 0f 00 00       	call   80104b2b <memset>
80103b58:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b5e:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b61:	ba 0c 43 10 80       	mov    $0x8010430c,%edx
80103b66:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b6c:	c9                   	leave  
80103b6d:	c3                   	ret    

80103b6e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b6e:	55                   	push   %ebp
80103b6f:	89 e5                	mov    %esp,%ebp
80103b71:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b74:	e8 c5 fe ff ff       	call   80103a3e <allocproc>
80103b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b7f:	a3 40 64 19 80       	mov    %eax,0x80196440
  if((p->pgdir = setupkvm()) == 0){
80103b84:	e8 5d 3b 00 00       	call   801076e6 <setupkvm>
80103b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b8c:	89 42 04             	mov    %eax,0x4(%edx)
80103b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b92:	8b 40 04             	mov    0x4(%eax),%eax
80103b95:	85 c0                	test   %eax,%eax
80103b97:	75 0d                	jne    80103ba6 <userinit+0x38>
    panic("userinit: out of memory?");
80103b99:	83 ec 0c             	sub    $0xc,%esp
80103b9c:	68 8e a7 10 80       	push   $0x8010a78e
80103ba1:	e8 03 ca ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba6:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bae:	8b 40 04             	mov    0x4(%eax),%eax
80103bb1:	83 ec 04             	sub    $0x4,%esp
80103bb4:	52                   	push   %edx
80103bb5:	68 ec f4 10 80       	push   $0x8010f4ec
80103bba:	50                   	push   %eax
80103bbb:	e8 e2 3d 00 00       	call   801079a2 <inituvm>
80103bc0:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc6:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcf:	8b 40 18             	mov    0x18(%eax),%eax
80103bd2:	83 ec 04             	sub    $0x4,%esp
80103bd5:	6a 4c                	push   $0x4c
80103bd7:	6a 00                	push   $0x0
80103bd9:	50                   	push   %eax
80103bda:	e8 4c 0f 00 00       	call   80104b2b <memset>
80103bdf:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be5:	8b 40 18             	mov    0x18(%eax),%eax
80103be8:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf1:	8b 40 18             	mov    0x18(%eax),%eax
80103bf4:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfd:	8b 50 18             	mov    0x18(%eax),%edx
80103c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c03:	8b 40 18             	mov    0x18(%eax),%eax
80103c06:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c0a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c11:	8b 50 18             	mov    0x18(%eax),%edx
80103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c17:	8b 40 18             	mov    0x18(%eax),%eax
80103c1a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c1e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c25:	8b 40 18             	mov    0x18(%eax),%eax
80103c28:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c32:	8b 40 18             	mov    0x18(%eax),%eax
80103c35:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3f:	8b 40 18             	mov    0x18(%eax),%eax
80103c42:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c4c:	83 c0 6c             	add    $0x6c,%eax
80103c4f:	83 ec 04             	sub    $0x4,%esp
80103c52:	6a 10                	push   $0x10
80103c54:	68 a7 a7 10 80       	push   $0x8010a7a7
80103c59:	50                   	push   %eax
80103c5a:	e8 cf 10 00 00       	call   80104d2e <safestrcpy>
80103c5f:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c62:	83 ec 0c             	sub    $0xc,%esp
80103c65:	68 b0 a7 10 80       	push   $0x8010a7b0
80103c6a:	e8 93 e8 ff ff       	call   80102502 <namei>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c75:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c78:	83 ec 0c             	sub    $0xc,%esp
80103c7b:	68 00 42 19 80       	push   $0x80194200
80103c80:	e8 30 0c 00 00       	call   801048b5 <acquire>
80103c85:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c92:	83 ec 0c             	sub    $0xc,%esp
80103c95:	68 00 42 19 80       	push   $0x80194200
80103c9a:	e8 84 0c 00 00       	call   80104923 <release>
80103c9f:	83 c4 10             	add    $0x10,%esp
}
80103ca2:	90                   	nop
80103ca3:	c9                   	leave  
80103ca4:	c3                   	ret    

80103ca5 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103ca5:	55                   	push   %ebp
80103ca6:	89 e5                	mov    %esp,%ebp
80103ca8:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103cab:	e8 65 fd ff ff       	call   80103a15 <myproc>
80103cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sz = curproc->sz;
80103cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cb6:	8b 00                	mov    (%eax),%eax
80103cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(n > 0){
80103cbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cbf:	7e 2e                	jle    80103cef <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc1:	8b 55 08             	mov    0x8(%ebp),%edx
80103cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc7:	01 c2                	add    %eax,%edx
80103cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ccc:	8b 40 04             	mov    0x4(%eax),%eax
80103ccf:	83 ec 04             	sub    $0x4,%esp
80103cd2:	52                   	push   %edx
80103cd3:	ff 75 f4             	push   -0xc(%ebp)
80103cd6:	50                   	push   %eax
80103cd7:	e8 03 3e 00 00       	call   80107adf <allocuvm>
80103cdc:	83 c4 10             	add    $0x10,%esp
80103cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ce6:	75 3b                	jne    80103d23 <growproc+0x7e>
      return -1;
80103ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ced:	eb 4f                	jmp    80103d3e <growproc+0x99>
  } else if(n < 0){
80103cef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cf3:	79 2e                	jns    80103d23 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf5:	8b 55 08             	mov    0x8(%ebp),%edx
80103cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfb:	01 c2                	add    %eax,%edx
80103cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d00:	8b 40 04             	mov    0x4(%eax),%eax
80103d03:	83 ec 04             	sub    $0x4,%esp
80103d06:	52                   	push   %edx
80103d07:	ff 75 f4             	push   -0xc(%ebp)
80103d0a:	50                   	push   %eax
80103d0b:	e8 d4 3e 00 00       	call   80107be4 <deallocuvm>
80103d10:	83 c4 10             	add    $0x10,%esp
80103d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d1a:	75 07                	jne    80103d23 <growproc+0x7e>
      return -1;
80103d1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d21:	eb 1b                	jmp    80103d3e <growproc+0x99>
  }
  curproc->sz = sz;
80103d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d29:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d2b:	83 ec 0c             	sub    $0xc,%esp
80103d2e:	ff 75 f0             	push   -0x10(%ebp)
80103d31:	e8 cd 3a 00 00       	call   80107803 <switchuvm>
80103d36:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d3e:	c9                   	leave  
80103d3f:	c3                   	ret    

80103d40 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d49:	e8 c7 fc ff ff       	call   80103a15 <myproc>
80103d4e:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d51:	e8 e8 fc ff ff       	call   80103a3e <allocproc>
80103d56:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103d59:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80103d5d:	75 0a                	jne    80103d69 <fork+0x29>
    return -1;
80103d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d64:	e9 b0 01 00 00       	jmp    80103f19 <fork+0x1d9>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d6c:	8b 10                	mov    (%eax),%edx
80103d6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103d71:	8b 40 04             	mov    0x4(%eax),%eax
80103d74:	83 ec 08             	sub    $0x8,%esp
80103d77:	52                   	push   %edx
80103d78:	50                   	push   %eax
80103d79:	e8 04 40 00 00       	call   80107d82 <copyuvm>
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103d84:	89 42 04             	mov    %eax,0x4(%edx)
80103d87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103d8a:	8b 40 04             	mov    0x4(%eax),%eax
80103d8d:	85 c0                	test   %eax,%eax
80103d8f:	75 30                	jne    80103dc1 <fork+0x81>
    kfree(np->kstack);
80103d91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103d94:	8b 40 08             	mov    0x8(%eax),%eax
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	50                   	push   %eax
80103d9b:	e8 4b e9 ff ff       	call   801026eb <kfree>
80103da0:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103dad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103db0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dbc:	e9 58 01 00 00       	jmp    80103f19 <fork+0x1d9>
  }
  np->sz = curproc->sz;
80103dc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103dc4:	8b 10                	mov    (%eax),%edx
80103dc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dc9:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103dcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103dce:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103dd1:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103dd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103dd7:	8b 48 18             	mov    0x18(%eax),%ecx
80103dda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103ddd:	8b 40 18             	mov    0x18(%eax),%eax
80103de0:	89 c2                	mov    %eax,%edx
80103de2:	89 cb                	mov    %ecx,%ebx
80103de4:	b8 13 00 00 00       	mov    $0x13,%eax
80103de9:	89 d7                	mov    %edx,%edi
80103deb:	89 de                	mov    %ebx,%esi
80103ded:	89 c1                	mov    %eax,%ecx
80103def:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103df1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103df4:	8b 40 18             	mov    0x18(%eax),%eax
80103df7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103dfe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103e05:	eb 3b                	jmp    80103e42 <fork+0x102>
    if(curproc->ofile[i])
80103e07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e0d:	83 c2 08             	add    $0x8,%edx
80103e10:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 26                	je     80103e3e <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e18:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e1e:	83 c2 08             	add    $0x8,%edx
80103e21:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e25:	83 ec 0c             	sub    $0xc,%esp
80103e28:	50                   	push   %eax
80103e29:	e8 01 d2 ff ff       	call   8010102f <filedup>
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103e34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e37:	83 c1 08             	add    $0x8,%ecx
80103e3a:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e3e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e42:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e46:	7e bf                	jle    80103e07 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e4b:	8b 40 68             	mov    0x68(%eax),%eax
80103e4e:	83 ec 0c             	sub    $0xc,%esp
80103e51:	50                   	push   %eax
80103e52:	e8 3e db ff ff       	call   80101995 <idup>
80103e57:	83 c4 10             	add    $0x10,%esp
80103e5a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103e5d:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e60:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103e63:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e69:	83 c0 6c             	add    $0x6c,%eax
80103e6c:	83 ec 04             	sub    $0x4,%esp
80103e6f:	6a 10                	push   $0x10
80103e71:	52                   	push   %edx
80103e72:	50                   	push   %eax
80103e73:	e8 b6 0e 00 00       	call   80104d2e <safestrcpy>
80103e78:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e7e:	8b 40 10             	mov    0x10(%eax),%eax
80103e81:	89 45 d0             	mov    %eax,-0x30(%ebp)

  acquire(&ptable.lock);
80103e84:	83 ec 0c             	sub    $0xc,%esp
80103e87:	68 00 42 19 80       	push   $0x80194200
80103e8c:	e8 24 0a 00 00       	call   801048b5 <acquire>
80103e91:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103e97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(int i=0; i < NPROC; i++) {
80103e9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80103ea5:	eb 59                	jmp    80103f00 <fork+0x1c0>
    if (ptable.proc[i].pid == pid) {
80103ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eaa:	c1 e0 07             	shl    $0x7,%eax
80103ead:	05 44 42 19 80       	add    $0x80194244,%eax
80103eb2:	8b 00                	mov    (%eax),%eax
80103eb4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
80103eb7:	75 43                	jne    80103efc <fork+0x1bc>
      for(int j=0; j < NPROC; j++) {
80103eb9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80103ec0:	eb 32                	jmp    80103ef4 <fork+0x1b4>
        if (ptable.proc[j].pid == curproc->pid) {
80103ec2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ec5:	c1 e0 07             	shl    $0x7,%eax
80103ec8:	05 44 42 19 80       	add    $0x80194244,%eax
80103ecd:	8b 10                	mov    (%eax),%edx
80103ecf:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103ed2:	8b 40 10             	mov    0x10(%eax),%eax
80103ed5:	39 c2                	cmp    %eax,%edx
80103ed7:	75 17                	jne    80103ef0 <fork+0x1b0>
          pspage[i] = pspage[j];
80103ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103edc:	8b 14 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%edx
80103ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ee6:	89 14 85 40 63 19 80 	mov    %edx,-0x7fe69cc0(,%eax,4)
          break;
80103eed:	90                   	nop
        }
       }
      break;
80103eee:	eb 16                	jmp    80103f06 <fork+0x1c6>
      for(int j=0; j < NPROC; j++) {
80103ef0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80103ef4:	83 7d dc 3f          	cmpl   $0x3f,-0x24(%ebp)
80103ef8:	7e c8                	jle    80103ec2 <fork+0x182>
      break;
80103efa:	eb 0a                	jmp    80103f06 <fork+0x1c6>
  for(int i=0; i < NPROC; i++) {
80103efc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80103f00:	83 7d e0 3f          	cmpl   $0x3f,-0x20(%ebp)
80103f04:	7e a1                	jle    80103ea7 <fork+0x167>
    }
  }

  release(&ptable.lock);
80103f06:	83 ec 0c             	sub    $0xc,%esp
80103f09:	68 00 42 19 80       	push   $0x80194200
80103f0e:	e8 10 0a 00 00       	call   80104923 <release>
80103f13:	83 c4 10             	add    $0x10,%esp

  return pid;
80103f16:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
80103f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f1c:	5b                   	pop    %ebx
80103f1d:	5e                   	pop    %esi
80103f1e:	5f                   	pop    %edi
80103f1f:	5d                   	pop    %ebp
80103f20:	c3                   	ret    

80103f21 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103f21:	55                   	push   %ebp
80103f22:	89 e5                	mov    %esp,%ebp
80103f24:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103f27:	e8 e9 fa ff ff       	call   80103a15 <myproc>
80103f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103f2f:	a1 40 64 19 80       	mov    0x80196440,%eax
80103f34:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f37:	75 0d                	jne    80103f46 <exit+0x25>
    panic("init exiting");
80103f39:	83 ec 0c             	sub    $0xc,%esp
80103f3c:	68 b2 a7 10 80       	push   $0x8010a7b2
80103f41:	e8 63 c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103f46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103f4d:	eb 3f                	jmp    80103f8e <exit+0x6d>
    if(curproc->ofile[fd]){
80103f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f52:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f55:	83 c2 08             	add    $0x8,%edx
80103f58:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f5c:	85 c0                	test   %eax,%eax
80103f5e:	74 2a                	je     80103f8a <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f63:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f66:	83 c2 08             	add    $0x8,%edx
80103f69:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	50                   	push   %eax
80103f71:	e8 0a d1 ff ff       	call   80101080 <fileclose>
80103f76:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f7f:	83 c2 08             	add    $0x8,%edx
80103f82:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f89:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103f8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f8e:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f92:	7e bb                	jle    80103f4f <exit+0x2e>
    }
  }

  begin_op();
80103f94:	e8 88 f0 ff ff       	call   80103021 <begin_op>
  iput(curproc->cwd);
80103f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f9c:	8b 40 68             	mov    0x68(%eax),%eax
80103f9f:	83 ec 0c             	sub    $0xc,%esp
80103fa2:	50                   	push   %eax
80103fa3:	e8 88 db ff ff       	call   80101b30 <iput>
80103fa8:	83 c4 10             	add    $0x10,%esp
  end_op();
80103fab:	e8 fd f0 ff ff       	call   801030ad <end_op>
  curproc->cwd = 0;
80103fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fb3:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 00 42 19 80       	push   $0x80194200
80103fc2:	e8 ee 08 00 00       	call   801048b5 <acquire>
80103fc7:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fcd:	8b 40 14             	mov    0x14(%eax),%eax
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	50                   	push   %eax
80103fd4:	e8 20 04 00 00       	call   801043f9 <wakeup1>
80103fd9:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fdc:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103fe3:	eb 37                	jmp    8010401c <exit+0xfb>
    if(p->parent == curproc){
80103fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe8:	8b 40 14             	mov    0x14(%eax),%eax
80103feb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103fee:	75 28                	jne    80104018 <exit+0xf7>
      p->parent = initproc;
80103ff0:	8b 15 40 64 19 80    	mov    0x80196440,%edx
80103ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff9:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80103ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fff:	8b 40 0c             	mov    0xc(%eax),%eax
80104002:	83 f8 05             	cmp    $0x5,%eax
80104005:	75 11                	jne    80104018 <exit+0xf7>
        wakeup1(initproc);
80104007:	a1 40 64 19 80       	mov    0x80196440,%eax
8010400c:	83 ec 0c             	sub    $0xc,%esp
8010400f:	50                   	push   %eax
80104010:	e8 e4 03 00 00       	call   801043f9 <wakeup1>
80104015:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104018:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010401c:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104023:	72 c0                	jb     80103fe5 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104025:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104028:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010402f:	e8 e5 01 00 00       	call   80104219 <sched>
  panic("zombie exit");
80104034:	83 ec 0c             	sub    $0xc,%esp
80104037:	68 bf a7 10 80       	push   $0x8010a7bf
8010403c:	e8 68 c5 ff ff       	call   801005a9 <panic>

80104041 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104041:	55                   	push   %ebp
80104042:	89 e5                	mov    %esp,%ebp
80104044:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104047:	e8 c9 f9 ff ff       	call   80103a15 <myproc>
8010404c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010404f:	83 ec 0c             	sub    $0xc,%esp
80104052:	68 00 42 19 80       	push   $0x80194200
80104057:	e8 59 08 00 00       	call   801048b5 <acquire>
8010405c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010405f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104066:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010406d:	e9 a1 00 00 00       	jmp    80104113 <wait+0xd2>
      if(p->parent != curproc)
80104072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104075:	8b 40 14             	mov    0x14(%eax),%eax
80104078:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010407b:	0f 85 8d 00 00 00    	jne    8010410e <wait+0xcd>
        continue;
      havekids = 1;
80104081:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104088:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010408b:	8b 40 0c             	mov    0xc(%eax),%eax
8010408e:	83 f8 05             	cmp    $0x5,%eax
80104091:	75 7c                	jne    8010410f <wait+0xce>
        // Found one.
        pid = p->pid;
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	8b 40 10             	mov    0x10(%eax),%eax
80104099:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010409c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409f:	8b 40 08             	mov    0x8(%eax),%eax
801040a2:	83 ec 0c             	sub    $0xc,%esp
801040a5:	50                   	push   %eax
801040a6:	e8 40 e6 ff ff       	call   801026eb <kfree>
801040ab:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801040ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801040b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bb:	8b 40 04             	mov    0x4(%eax),%eax
801040be:	83 ec 0c             	sub    $0xc,%esp
801040c1:	50                   	push   %eax
801040c2:	e8 e1 3b 00 00       	call   80107ca8 <freevm>
801040c7:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801040ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040cd:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801040d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801040de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e1:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801040e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e8:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801040ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801040f9:	83 ec 0c             	sub    $0xc,%esp
801040fc:	68 00 42 19 80       	push   $0x80194200
80104101:	e8 1d 08 00 00       	call   80104923 <release>
80104106:	83 c4 10             	add    $0x10,%esp
        return pid;
80104109:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010410c:	eb 51                	jmp    8010415f <wait+0x11e>
        continue;
8010410e:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104113:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
8010411a:	0f 82 52 ff ff ff    	jb     80104072 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104120:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104124:	74 0a                	je     80104130 <wait+0xef>
80104126:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104129:	8b 40 24             	mov    0x24(%eax),%eax
8010412c:	85 c0                	test   %eax,%eax
8010412e:	74 17                	je     80104147 <wait+0x106>
      release(&ptable.lock);
80104130:	83 ec 0c             	sub    $0xc,%esp
80104133:	68 00 42 19 80       	push   $0x80194200
80104138:	e8 e6 07 00 00       	call   80104923 <release>
8010413d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104145:	eb 18                	jmp    8010415f <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104147:	83 ec 08             	sub    $0x8,%esp
8010414a:	68 00 42 19 80       	push   $0x80194200
8010414f:	ff 75 ec             	push   -0x14(%ebp)
80104152:	e8 fb 01 00 00       	call   80104352 <sleep>
80104157:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010415a:	e9 00 ff ff ff       	jmp    8010405f <wait+0x1e>
  }
}
8010415f:	c9                   	leave  
80104160:	c3                   	ret    

80104161 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104161:	55                   	push   %ebp
80104162:	89 e5                	mov    %esp,%ebp
80104164:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104167:	e8 31 f8 ff ff       	call   8010399d <mycpu>
8010416c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
8010416f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104172:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104179:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
8010417c:	e8 dc f7 ff ff       	call   8010395d <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104181:	83 ec 0c             	sub    $0xc,%esp
80104184:	68 00 42 19 80       	push   $0x80194200
80104189:	e8 27 07 00 00       	call   801048b5 <acquire>
8010418e:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104191:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104198:	eb 61                	jmp    801041fb <scheduler+0x9a>
      if(p->state != RUNNABLE)
8010419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419d:	8b 40 0c             	mov    0xc(%eax),%eax
801041a0:	83 f8 03             	cmp    $0x3,%eax
801041a3:	75 51                	jne    801041f6 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801041a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ab:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801041b1:	83 ec 0c             	sub    $0xc,%esp
801041b4:	ff 75 f4             	push   -0xc(%ebp)
801041b7:	e8 47 36 00 00       	call   80107803 <switchuvm>
801041bc:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801041bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c2:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801041c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041cc:	8b 40 1c             	mov    0x1c(%eax),%eax
801041cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801041d2:	83 c2 04             	add    $0x4,%edx
801041d5:	83 ec 08             	sub    $0x8,%esp
801041d8:	50                   	push   %eax
801041d9:	52                   	push   %edx
801041da:	e8 c1 0b 00 00       	call   80104da0 <swtch>
801041df:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801041e2:	e8 03 36 00 00       	call   801077ea <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801041e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041ea:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041f1:	00 00 00 
801041f4:	eb 01                	jmp    801041f7 <scheduler+0x96>
        continue;
801041f6:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f7:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801041fb:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104202:	72 96                	jb     8010419a <scheduler+0x39>
    }
    release(&ptable.lock);
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	68 00 42 19 80       	push   $0x80194200
8010420c:	e8 12 07 00 00       	call   80104923 <release>
80104211:	83 c4 10             	add    $0x10,%esp
    sti();
80104214:	e9 63 ff ff ff       	jmp    8010417c <scheduler+0x1b>

80104219 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104219:	55                   	push   %ebp
8010421a:	89 e5                	mov    %esp,%ebp
8010421c:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
8010421f:	e8 f1 f7 ff ff       	call   80103a15 <myproc>
80104224:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	68 00 42 19 80       	push   $0x80194200
8010422f:	e8 bc 07 00 00       	call   801049f0 <holding>
80104234:	83 c4 10             	add    $0x10,%esp
80104237:	85 c0                	test   %eax,%eax
80104239:	75 0d                	jne    80104248 <sched+0x2f>
    panic("sched ptable.lock");
8010423b:	83 ec 0c             	sub    $0xc,%esp
8010423e:	68 cb a7 10 80       	push   $0x8010a7cb
80104243:	e8 61 c3 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
80104248:	e8 50 f7 ff ff       	call   8010399d <mycpu>
8010424d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104253:	83 f8 01             	cmp    $0x1,%eax
80104256:	74 0d                	je     80104265 <sched+0x4c>
    panic("sched locks");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 dd a7 10 80       	push   $0x8010a7dd
80104260:	e8 44 c3 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
80104265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104268:	8b 40 0c             	mov    0xc(%eax),%eax
8010426b:	83 f8 04             	cmp    $0x4,%eax
8010426e:	75 0d                	jne    8010427d <sched+0x64>
    panic("sched running");
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 e9 a7 10 80       	push   $0x8010a7e9
80104278:	e8 2c c3 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
8010427d:	e8 cb f6 ff ff       	call   8010394d <readeflags>
80104282:	25 00 02 00 00       	and    $0x200,%eax
80104287:	85 c0                	test   %eax,%eax
80104289:	74 0d                	je     80104298 <sched+0x7f>
    panic("sched interruptible");
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	68 f7 a7 10 80       	push   $0x8010a7f7
80104293:	e8 11 c3 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
80104298:	e8 00 f7 ff ff       	call   8010399d <mycpu>
8010429d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801042a6:	e8 f2 f6 ff ff       	call   8010399d <mycpu>
801042ab:	8b 40 04             	mov    0x4(%eax),%eax
801042ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b1:	83 c2 1c             	add    $0x1c,%edx
801042b4:	83 ec 08             	sub    $0x8,%esp
801042b7:	50                   	push   %eax
801042b8:	52                   	push   %edx
801042b9:	e8 e2 0a 00 00       	call   80104da0 <swtch>
801042be:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042c1:	e8 d7 f6 ff ff       	call   8010399d <mycpu>
801042c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042c9:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801042cf:	90                   	nop
801042d0:	c9                   	leave  
801042d1:	c3                   	ret    

801042d2 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801042d2:	55                   	push   %ebp
801042d3:	89 e5                	mov    %esp,%ebp
801042d5:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	68 00 42 19 80       	push   $0x80194200
801042e0:	e8 d0 05 00 00       	call   801048b5 <acquire>
801042e5:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
801042e8:	e8 28 f7 ff ff       	call   80103a15 <myproc>
801042ed:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801042f4:	e8 20 ff ff ff       	call   80104219 <sched>
  release(&ptable.lock);
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	68 00 42 19 80       	push   $0x80194200
80104301:	e8 1d 06 00 00       	call   80104923 <release>
80104306:	83 c4 10             	add    $0x10,%esp
}
80104309:	90                   	nop
8010430a:	c9                   	leave  
8010430b:	c3                   	ret    

8010430c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010430c:	55                   	push   %ebp
8010430d:	89 e5                	mov    %esp,%ebp
8010430f:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104312:	83 ec 0c             	sub    $0xc,%esp
80104315:	68 00 42 19 80       	push   $0x80194200
8010431a:	e8 04 06 00 00       	call   80104923 <release>
8010431f:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104322:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104327:	85 c0                	test   %eax,%eax
80104329:	74 24                	je     8010434f <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
8010432b:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104332:	00 00 00 
    iinit(ROOTDEV);
80104335:	83 ec 0c             	sub    $0xc,%esp
80104338:	6a 01                	push   $0x1
8010433a:	e8 1e d3 ff ff       	call   8010165d <iinit>
8010433f:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104342:	83 ec 0c             	sub    $0xc,%esp
80104345:	6a 01                	push   $0x1
80104347:	e8 b6 ea ff ff       	call   80102e02 <initlog>
8010434c:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010434f:	90                   	nop
80104350:	c9                   	leave  
80104351:	c3                   	ret    

80104352 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104352:	55                   	push   %ebp
80104353:	89 e5                	mov    %esp,%ebp
80104355:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104358:	e8 b8 f6 ff ff       	call   80103a15 <myproc>
8010435d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104364:	75 0d                	jne    80104373 <sleep+0x21>
    panic("sleep");
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	68 0b a8 10 80       	push   $0x8010a80b
8010436e:	e8 36 c2 ff ff       	call   801005a9 <panic>

  if(lk == 0)
80104373:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104377:	75 0d                	jne    80104386 <sleep+0x34>
    panic("sleep without lk");
80104379:	83 ec 0c             	sub    $0xc,%esp
8010437c:	68 11 a8 10 80       	push   $0x8010a811
80104381:	e8 23 c2 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104386:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
8010438d:	74 1e                	je     801043ad <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010438f:	83 ec 0c             	sub    $0xc,%esp
80104392:	68 00 42 19 80       	push   $0x80194200
80104397:	e8 19 05 00 00       	call   801048b5 <acquire>
8010439c:	83 c4 10             	add    $0x10,%esp
    release(lk);
8010439f:	83 ec 0c             	sub    $0xc,%esp
801043a2:	ff 75 0c             	push   0xc(%ebp)
801043a5:	e8 79 05 00 00       	call   80104923 <release>
801043aa:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801043ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b0:	8b 55 08             	mov    0x8(%ebp),%edx
801043b3:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b9:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801043c0:	e8 54 fe ff ff       	call   80104219 <sched>

  // Tidy up.
  p->chan = 0;
801043c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c8:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801043cf:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
801043d6:	74 1e                	je     801043f6 <sleep+0xa4>
    release(&ptable.lock);
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 00 42 19 80       	push   $0x80194200
801043e0:	e8 3e 05 00 00       	call   80104923 <release>
801043e5:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	ff 75 0c             	push   0xc(%ebp)
801043ee:	e8 c2 04 00 00       	call   801048b5 <acquire>
801043f3:	83 c4 10             	add    $0x10,%esp
  }
}
801043f6:	90                   	nop
801043f7:	c9                   	leave  
801043f8:	c3                   	ret    

801043f9 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801043f9:	55                   	push   %ebp
801043fa:	89 e5                	mov    %esp,%ebp
801043fc:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ff:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104406:	eb 24                	jmp    8010442c <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104408:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010440b:	8b 40 0c             	mov    0xc(%eax),%eax
8010440e:	83 f8 02             	cmp    $0x2,%eax
80104411:	75 15                	jne    80104428 <wakeup1+0x2f>
80104413:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104416:	8b 40 20             	mov    0x20(%eax),%eax
80104419:	39 45 08             	cmp    %eax,0x8(%ebp)
8010441c:	75 0a                	jne    80104428 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010441e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104421:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104428:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
8010442c:	81 7d fc 34 62 19 80 	cmpl   $0x80196234,-0x4(%ebp)
80104433:	72 d3                	jb     80104408 <wakeup1+0xf>
}
80104435:	90                   	nop
80104436:	90                   	nop
80104437:	c9                   	leave  
80104438:	c3                   	ret    

80104439 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104439:	55                   	push   %ebp
8010443a:	89 e5                	mov    %esp,%ebp
8010443c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	68 00 42 19 80       	push   $0x80194200
80104447:	e8 69 04 00 00       	call   801048b5 <acquire>
8010444c:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010444f:	83 ec 0c             	sub    $0xc,%esp
80104452:	ff 75 08             	push   0x8(%ebp)
80104455:	e8 9f ff ff ff       	call   801043f9 <wakeup1>
8010445a:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010445d:	83 ec 0c             	sub    $0xc,%esp
80104460:	68 00 42 19 80       	push   $0x80194200
80104465:	e8 b9 04 00 00       	call   80104923 <release>
8010446a:	83 c4 10             	add    $0x10,%esp
}
8010446d:	90                   	nop
8010446e:	c9                   	leave  
8010446f:	c3                   	ret    

80104470 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	68 00 42 19 80       	push   $0x80194200
8010447e:	e8 32 04 00 00       	call   801048b5 <acquire>
80104483:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104486:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010448d:	eb 45                	jmp    801044d4 <kill+0x64>
    if(p->pid == pid){
8010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104492:	8b 40 10             	mov    0x10(%eax),%eax
80104495:	39 45 08             	cmp    %eax,0x8(%ebp)
80104498:	75 36                	jne    801044d0 <kill+0x60>
      p->killed = 1;
8010449a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a7:	8b 40 0c             	mov    0xc(%eax),%eax
801044aa:	83 f8 02             	cmp    $0x2,%eax
801044ad:	75 0a                	jne    801044b9 <kill+0x49>
        p->state = RUNNABLE;
801044af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044b9:	83 ec 0c             	sub    $0xc,%esp
801044bc:	68 00 42 19 80       	push   $0x80194200
801044c1:	e8 5d 04 00 00       	call   80104923 <release>
801044c6:	83 c4 10             	add    $0x10,%esp
      return 0;
801044c9:	b8 00 00 00 00       	mov    $0x0,%eax
801044ce:	eb 22                	jmp    801044f2 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d0:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801044d4:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801044db:	72 b2                	jb     8010448f <kill+0x1f>
    }
  }
  release(&ptable.lock);
801044dd:	83 ec 0c             	sub    $0xc,%esp
801044e0:	68 00 42 19 80       	push   $0x80194200
801044e5:	e8 39 04 00 00       	call   80104923 <release>
801044ea:	83 c4 10             	add    $0x10,%esp
  return -1;
801044ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044f2:	c9                   	leave  
801044f3:	c3                   	ret    

801044f4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044f4:	55                   	push   %ebp
801044f5:	89 e5                	mov    %esp,%ebp
801044f7:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044fa:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
80104501:	e9 d7 00 00 00       	jmp    801045dd <procdump+0xe9>
    if(p->state == UNUSED)
80104506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104509:	8b 40 0c             	mov    0xc(%eax),%eax
8010450c:	85 c0                	test   %eax,%eax
8010450e:	0f 84 c4 00 00 00    	je     801045d8 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104514:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104517:	8b 40 0c             	mov    0xc(%eax),%eax
8010451a:	83 f8 05             	cmp    $0x5,%eax
8010451d:	77 23                	ja     80104542 <procdump+0x4e>
8010451f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104522:	8b 40 0c             	mov    0xc(%eax),%eax
80104525:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
8010452c:	85 c0                	test   %eax,%eax
8010452e:	74 12                	je     80104542 <procdump+0x4e>
      state = states[p->state];
80104530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104533:	8b 40 0c             	mov    0xc(%eax),%eax
80104536:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
8010453d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104540:	eb 07                	jmp    80104549 <procdump+0x55>
    else
      state = "???";
80104542:	c7 45 ec 22 a8 10 80 	movl   $0x8010a822,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010454c:	8d 50 6c             	lea    0x6c(%eax),%edx
8010454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104552:	8b 40 10             	mov    0x10(%eax),%eax
80104555:	52                   	push   %edx
80104556:	ff 75 ec             	push   -0x14(%ebp)
80104559:	50                   	push   %eax
8010455a:	68 26 a8 10 80       	push   $0x8010a826
8010455f:	e8 90 be ff ff       	call   801003f4 <cprintf>
80104564:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010456a:	8b 40 0c             	mov    0xc(%eax),%eax
8010456d:	83 f8 02             	cmp    $0x2,%eax
80104570:	75 54                	jne    801045c6 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104572:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104575:	8b 40 1c             	mov    0x1c(%eax),%eax
80104578:	8b 40 0c             	mov    0xc(%eax),%eax
8010457b:	83 c0 08             	add    $0x8,%eax
8010457e:	89 c2                	mov    %eax,%edx
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104586:	50                   	push   %eax
80104587:	52                   	push   %edx
80104588:	e8 e8 03 00 00       	call   80104975 <getcallerpcs>
8010458d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104590:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104597:	eb 1c                	jmp    801045b5 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801045a0:	83 ec 08             	sub    $0x8,%esp
801045a3:	50                   	push   %eax
801045a4:	68 2f a8 10 80       	push   $0x8010a82f
801045a9:	e8 46 be ff ff       	call   801003f4 <cprintf>
801045ae:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045b5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801045b9:	7f 0b                	jg     801045c6 <procdump+0xd2>
801045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045be:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801045c2:	85 c0                	test   %eax,%eax
801045c4:	75 d3                	jne    80104599 <procdump+0xa5>
    }
    cprintf("\n");
801045c6:	83 ec 0c             	sub    $0xc,%esp
801045c9:	68 33 a8 10 80       	push   $0x8010a833
801045ce:	e8 21 be ff ff       	call   801003f4 <cprintf>
801045d3:	83 c4 10             	add    $0x10,%esp
801045d6:	eb 01                	jmp    801045d9 <procdump+0xe5>
      continue;
801045d8:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d9:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
801045dd:	81 7d f0 34 62 19 80 	cmpl   $0x80196234,-0x10(%ebp)
801045e4:	0f 82 1c ff ff ff    	jb     80104506 <procdump+0x12>
  }
}
801045ea:	90                   	nop
801045eb:	90                   	nop
801045ec:	c9                   	leave  
801045ed:	c3                   	ret    

801045ee <printpt>:

int printpt(int pid) {
801045ee:	55                   	push   %ebp
801045ef:	89 e5                	mov    %esp,%ebp
801045f1:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  pte_t *pgtab;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045f4:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801045fb:	e9 0f 01 00 00       	jmp    8010470f <printpt+0x121>
    if (p->pid == pid) {
80104600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104603:	8b 40 10             	mov    0x10(%eax),%eax
80104606:	39 45 08             	cmp    %eax,0x8(%ebp)
80104609:	0f 85 fc 00 00 00    	jne    8010470b <printpt+0x11d>
      cprintf("START PAGE TABLE (pid %d)\n", pid);
8010460f:	83 ec 08             	sub    $0x8,%esp
80104612:	ff 75 08             	push   0x8(%ebp)
80104615:	68 35 a8 10 80       	push   $0x8010a835
8010461a:	e8 d5 bd ff ff       	call   801003f4 <cprintf>
8010461f:	83 c4 10             	add    $0x10,%esp
      for (uint va = 0; va < KERNBASE; va += PGSIZE) {
80104622:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104629:	e9 bb 00 00 00       	jmp    801046e9 <printpt+0xfb>
        pde_t pde = p->pgdir[PDX(va)];
8010462e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104631:	8b 50 04             	mov    0x4(%eax),%edx
80104634:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104637:	c1 e8 16             	shr    $0x16,%eax
8010463a:	c1 e0 02             	shl    $0x2,%eax
8010463d:	01 d0                	add    %edx,%eax
8010463f:	8b 00                	mov    (%eax),%eax
80104641:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (pde & PTE_P) {
80104644:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104647:	83 e0 01             	and    $0x1,%eax
8010464a:	85 c0                	test   %eax,%eax
8010464c:	0f 84 90 00 00 00    	je     801046e2 <printpt+0xf4>
          pgtab = (pte_t*)P2V(PTE_ADDR(pde));
80104652:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104655:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010465a:	05 00 00 00 80       	add    $0x80000000,%eax
8010465f:	89 45 e8             	mov    %eax,-0x18(%ebp)
          pte_t pte = pgtab[PTX(va)];
80104662:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104665:	c1 e8 0c             	shr    $0xc,%eax
80104668:	25 ff 03 00 00       	and    $0x3ff,%eax
8010466d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104674:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104677:	01 d0                	add    %edx,%eax
80104679:	8b 00                	mov    (%eax),%eax
8010467b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if (pte & PTE_P) {
8010467e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104681:	83 e0 01             	and    $0x1,%eax
80104684:	85 c0                	test   %eax,%eax
80104686:	74 5a                	je     801046e2 <printpt+0xf4>
            char *u = (pte & PTE_U) ? "U" : "K";
80104688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010468b:	83 e0 04             	and    $0x4,%eax
8010468e:	85 c0                	test   %eax,%eax
80104690:	74 07                	je     80104699 <printpt+0xab>
80104692:	b8 50 a8 10 80       	mov    $0x8010a850,%eax
80104697:	eb 05                	jmp    8010469e <printpt+0xb0>
80104699:	b8 52 a8 10 80       	mov    $0x8010a852,%eax
8010469e:	89 45 e0             	mov    %eax,-0x20(%ebp)
            char *w = (pte & PTE_W) ? "W" : "-";
801046a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046a4:	83 e0 02             	and    $0x2,%eax
801046a7:	85 c0                	test   %eax,%eax
801046a9:	74 07                	je     801046b2 <printpt+0xc4>
801046ab:	b8 54 a8 10 80       	mov    $0x8010a854,%eax
801046b0:	eb 05                	jmp    801046b7 <printpt+0xc9>
801046b2:	b8 56 a8 10 80       	mov    $0x8010a856,%eax
801046b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
            cprintf("%x P %s %s %x\n", va >> 12, u, w, PTE_ADDR(pte));
801046ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801046c2:	89 c2                	mov    %eax,%edx
801046c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046c7:	c1 e8 0c             	shr    $0xc,%eax
801046ca:	83 ec 0c             	sub    $0xc,%esp
801046cd:	52                   	push   %edx
801046ce:	ff 75 dc             	push   -0x24(%ebp)
801046d1:	ff 75 e0             	push   -0x20(%ebp)
801046d4:	50                   	push   %eax
801046d5:	68 58 a8 10 80       	push   $0x8010a858
801046da:	e8 15 bd ff ff       	call   801003f4 <cprintf>
801046df:	83 c4 20             	add    $0x20,%esp
      for (uint va = 0; va < KERNBASE; va += PGSIZE) {
801046e2:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
801046e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046ec:	85 c0                	test   %eax,%eax
801046ee:	0f 89 3a ff ff ff    	jns    8010462e <printpt+0x40>
          }
        }
      }
      cprintf("END PAGE TABLE\n");
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	68 67 a8 10 80       	push   $0x8010a867
801046fc:	e8 f3 bc ff ff       	call   801003f4 <cprintf>
80104701:	83 c4 10             	add    $0x10,%esp
      return 0;
80104704:	b8 00 00 00 00       	mov    $0x0,%eax
80104709:	eb 29                	jmp    80104734 <printpt+0x146>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010470b:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010470f:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104716:	0f 82 e4 fe ff ff    	jb     80104600 <printpt+0x12>
    }
  }

  cprintf("printpt: pid %d not found\n", pid);
8010471c:	83 ec 08             	sub    $0x8,%esp
8010471f:	ff 75 08             	push   0x8(%ebp)
80104722:	68 77 a8 10 80       	push   $0x8010a877
80104727:	e8 c8 bc ff ff       	call   801003f4 <cprintf>
8010472c:	83 c4 10             	add    $0x10,%esp
  return -1;
8010472f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104734:	c9                   	leave  
80104735:	c3                   	ret    

80104736 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104736:	55                   	push   %ebp
80104737:	89 e5                	mov    %esp,%ebp
80104739:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
8010473c:	8b 45 08             	mov    0x8(%ebp),%eax
8010473f:	83 c0 04             	add    $0x4,%eax
80104742:	83 ec 08             	sub    $0x8,%esp
80104745:	68 bc a8 10 80       	push   $0x8010a8bc
8010474a:	50                   	push   %eax
8010474b:	e8 43 01 00 00       	call   80104893 <initlock>
80104750:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104753:	8b 45 08             	mov    0x8(%ebp),%eax
80104756:	8b 55 0c             	mov    0xc(%ebp),%edx
80104759:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
8010475c:	8b 45 08             	mov    0x8(%ebp),%eax
8010475f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104765:	8b 45 08             	mov    0x8(%ebp),%eax
80104768:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010476f:	90                   	nop
80104770:	c9                   	leave  
80104771:	c3                   	ret    

80104772 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104772:	55                   	push   %ebp
80104773:	89 e5                	mov    %esp,%ebp
80104775:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104778:	8b 45 08             	mov    0x8(%ebp),%eax
8010477b:	83 c0 04             	add    $0x4,%eax
8010477e:	83 ec 0c             	sub    $0xc,%esp
80104781:	50                   	push   %eax
80104782:	e8 2e 01 00 00       	call   801048b5 <acquire>
80104787:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010478a:	eb 15                	jmp    801047a1 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
8010478c:	8b 45 08             	mov    0x8(%ebp),%eax
8010478f:	83 c0 04             	add    $0x4,%eax
80104792:	83 ec 08             	sub    $0x8,%esp
80104795:	50                   	push   %eax
80104796:	ff 75 08             	push   0x8(%ebp)
80104799:	e8 b4 fb ff ff       	call   80104352 <sleep>
8010479e:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801047a1:	8b 45 08             	mov    0x8(%ebp),%eax
801047a4:	8b 00                	mov    (%eax),%eax
801047a6:	85 c0                	test   %eax,%eax
801047a8:	75 e2                	jne    8010478c <acquiresleep+0x1a>
  }
  lk->locked = 1;
801047aa:	8b 45 08             	mov    0x8(%ebp),%eax
801047ad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801047b3:	e8 5d f2 ff ff       	call   80103a15 <myproc>
801047b8:	8b 50 10             	mov    0x10(%eax),%edx
801047bb:	8b 45 08             	mov    0x8(%ebp),%eax
801047be:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801047c1:	8b 45 08             	mov    0x8(%ebp),%eax
801047c4:	83 c0 04             	add    $0x4,%eax
801047c7:	83 ec 0c             	sub    $0xc,%esp
801047ca:	50                   	push   %eax
801047cb:	e8 53 01 00 00       	call   80104923 <release>
801047d0:	83 c4 10             	add    $0x10,%esp
}
801047d3:	90                   	nop
801047d4:	c9                   	leave  
801047d5:	c3                   	ret    

801047d6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047d6:	55                   	push   %ebp
801047d7:	89 e5                	mov    %esp,%ebp
801047d9:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801047dc:	8b 45 08             	mov    0x8(%ebp),%eax
801047df:	83 c0 04             	add    $0x4,%eax
801047e2:	83 ec 0c             	sub    $0xc,%esp
801047e5:	50                   	push   %eax
801047e6:	e8 ca 00 00 00       	call   801048b5 <acquire>
801047eb:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801047ee:	8b 45 08             	mov    0x8(%ebp),%eax
801047f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801047f7:	8b 45 08             	mov    0x8(%ebp),%eax
801047fa:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104801:	83 ec 0c             	sub    $0xc,%esp
80104804:	ff 75 08             	push   0x8(%ebp)
80104807:	e8 2d fc ff ff       	call   80104439 <wakeup>
8010480c:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
8010480f:	8b 45 08             	mov    0x8(%ebp),%eax
80104812:	83 c0 04             	add    $0x4,%eax
80104815:	83 ec 0c             	sub    $0xc,%esp
80104818:	50                   	push   %eax
80104819:	e8 05 01 00 00       	call   80104923 <release>
8010481e:	83 c4 10             	add    $0x10,%esp
}
80104821:	90                   	nop
80104822:	c9                   	leave  
80104823:	c3                   	ret    

80104824 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
8010482a:	8b 45 08             	mov    0x8(%ebp),%eax
8010482d:	83 c0 04             	add    $0x4,%eax
80104830:	83 ec 0c             	sub    $0xc,%esp
80104833:	50                   	push   %eax
80104834:	e8 7c 00 00 00       	call   801048b5 <acquire>
80104839:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
8010483c:	8b 45 08             	mov    0x8(%ebp),%eax
8010483f:	8b 00                	mov    (%eax),%eax
80104841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104844:	8b 45 08             	mov    0x8(%ebp),%eax
80104847:	83 c0 04             	add    $0x4,%eax
8010484a:	83 ec 0c             	sub    $0xc,%esp
8010484d:	50                   	push   %eax
8010484e:	e8 d0 00 00 00       	call   80104923 <release>
80104853:	83 c4 10             	add    $0x10,%esp
  return r;
80104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104859:	c9                   	leave  
8010485a:	c3                   	ret    

8010485b <readeflags>:
{
8010485b:	55                   	push   %ebp
8010485c:	89 e5                	mov    %esp,%ebp
8010485e:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104861:	9c                   	pushf  
80104862:	58                   	pop    %eax
80104863:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104866:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104869:	c9                   	leave  
8010486a:	c3                   	ret    

8010486b <cli>:
{
8010486b:	55                   	push   %ebp
8010486c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010486e:	fa                   	cli    
}
8010486f:	90                   	nop
80104870:	5d                   	pop    %ebp
80104871:	c3                   	ret    

80104872 <sti>:
{
80104872:	55                   	push   %ebp
80104873:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104875:	fb                   	sti    
}
80104876:	90                   	nop
80104877:	5d                   	pop    %ebp
80104878:	c3                   	ret    

80104879 <xchg>:
{
80104879:	55                   	push   %ebp
8010487a:	89 e5                	mov    %esp,%ebp
8010487c:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
8010487f:	8b 55 08             	mov    0x8(%ebp),%edx
80104882:	8b 45 0c             	mov    0xc(%ebp),%eax
80104885:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104888:	f0 87 02             	lock xchg %eax,(%edx)
8010488b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010488e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104891:	c9                   	leave  
80104892:	c3                   	ret    

80104893 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104893:	55                   	push   %ebp
80104894:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104896:	8b 45 08             	mov    0x8(%ebp),%eax
80104899:	8b 55 0c             	mov    0xc(%ebp),%edx
8010489c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010489f:	8b 45 08             	mov    0x8(%ebp),%eax
801048a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801048a8:	8b 45 08             	mov    0x8(%ebp),%eax
801048ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048b2:	90                   	nop
801048b3:	5d                   	pop    %ebp
801048b4:	c3                   	ret    

801048b5 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048b5:	55                   	push   %ebp
801048b6:	89 e5                	mov    %esp,%ebp
801048b8:	53                   	push   %ebx
801048b9:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048bc:	e8 5f 01 00 00       	call   80104a20 <pushcli>
  if(holding(lk)){
801048c1:	8b 45 08             	mov    0x8(%ebp),%eax
801048c4:	83 ec 0c             	sub    $0xc,%esp
801048c7:	50                   	push   %eax
801048c8:	e8 23 01 00 00       	call   801049f0 <holding>
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	85 c0                	test   %eax,%eax
801048d2:	74 0d                	je     801048e1 <acquire+0x2c>
    panic("acquire");
801048d4:	83 ec 0c             	sub    $0xc,%esp
801048d7:	68 c7 a8 10 80       	push   $0x8010a8c7
801048dc:	e8 c8 bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801048e1:	90                   	nop
801048e2:	8b 45 08             	mov    0x8(%ebp),%eax
801048e5:	83 ec 08             	sub    $0x8,%esp
801048e8:	6a 01                	push   $0x1
801048ea:	50                   	push   %eax
801048eb:	e8 89 ff ff ff       	call   80104879 <xchg>
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	85 c0                	test   %eax,%eax
801048f5:	75 eb                	jne    801048e2 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801048f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048ff:	e8 99 f0 ff ff       	call   8010399d <mycpu>
80104904:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104907:	8b 45 08             	mov    0x8(%ebp),%eax
8010490a:	83 c0 0c             	add    $0xc,%eax
8010490d:	83 ec 08             	sub    $0x8,%esp
80104910:	50                   	push   %eax
80104911:	8d 45 08             	lea    0x8(%ebp),%eax
80104914:	50                   	push   %eax
80104915:	e8 5b 00 00 00       	call   80104975 <getcallerpcs>
8010491a:	83 c4 10             	add    $0x10,%esp
}
8010491d:	90                   	nop
8010491e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104921:	c9                   	leave  
80104922:	c3                   	ret    

80104923 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104923:	55                   	push   %ebp
80104924:	89 e5                	mov    %esp,%ebp
80104926:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104929:	83 ec 0c             	sub    $0xc,%esp
8010492c:	ff 75 08             	push   0x8(%ebp)
8010492f:	e8 bc 00 00 00       	call   801049f0 <holding>
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	85 c0                	test   %eax,%eax
80104939:	75 0d                	jne    80104948 <release+0x25>
    panic("release");
8010493b:	83 ec 0c             	sub    $0xc,%esp
8010493e:	68 cf a8 10 80       	push   $0x8010a8cf
80104943:	e8 61 bc ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104948:	8b 45 08             	mov    0x8(%ebp),%eax
8010494b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104952:	8b 45 08             	mov    0x8(%ebp),%eax
80104955:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010495c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104961:	8b 45 08             	mov    0x8(%ebp),%eax
80104964:	8b 55 08             	mov    0x8(%ebp),%edx
80104967:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010496d:	e8 fb 00 00 00       	call   80104a6d <popcli>
}
80104972:	90                   	nop
80104973:	c9                   	leave  
80104974:	c3                   	ret    

80104975 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104975:	55                   	push   %ebp
80104976:	89 e5                	mov    %esp,%ebp
80104978:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010497b:	8b 45 08             	mov    0x8(%ebp),%eax
8010497e:	83 e8 08             	sub    $0x8,%eax
80104981:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104984:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010498b:	eb 38                	jmp    801049c5 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010498d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104991:	74 53                	je     801049e6 <getcallerpcs+0x71>
80104993:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010499a:	76 4a                	jbe    801049e6 <getcallerpcs+0x71>
8010499c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801049a0:	74 44                	je     801049e6 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801049af:	01 c2                	add    %eax,%edx
801049b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049b4:	8b 40 04             	mov    0x4(%eax),%eax
801049b7:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801049b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049bc:	8b 00                	mov    (%eax),%eax
801049be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801049c1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801049c5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801049c9:	7e c2                	jle    8010498d <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801049cb:	eb 19                	jmp    801049e6 <getcallerpcs+0x71>
    pcs[i] = 0;
801049cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801049d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801049d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801049da:	01 d0                	add    %edx,%eax
801049dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049e2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801049e6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801049ea:	7e e1                	jle    801049cd <getcallerpcs+0x58>
}
801049ec:	90                   	nop
801049ed:	90                   	nop
801049ee:	c9                   	leave  
801049ef:	c3                   	ret    

801049f0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801049f7:	8b 45 08             	mov    0x8(%ebp),%eax
801049fa:	8b 00                	mov    (%eax),%eax
801049fc:	85 c0                	test   %eax,%eax
801049fe:	74 16                	je     80104a16 <holding+0x26>
80104a00:	8b 45 08             	mov    0x8(%ebp),%eax
80104a03:	8b 58 08             	mov    0x8(%eax),%ebx
80104a06:	e8 92 ef ff ff       	call   8010399d <mycpu>
80104a0b:	39 c3                	cmp    %eax,%ebx
80104a0d:	75 07                	jne    80104a16 <holding+0x26>
80104a0f:	b8 01 00 00 00       	mov    $0x1,%eax
80104a14:	eb 05                	jmp    80104a1b <holding+0x2b>
80104a16:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a1e:	c9                   	leave  
80104a1f:	c3                   	ret    

80104a20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104a26:	e8 30 fe ff ff       	call   8010485b <readeflags>
80104a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104a2e:	e8 38 fe ff ff       	call   8010486b <cli>
  if(mycpu()->ncli == 0)
80104a33:	e8 65 ef ff ff       	call   8010399d <mycpu>
80104a38:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a3e:	85 c0                	test   %eax,%eax
80104a40:	75 14                	jne    80104a56 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104a42:	e8 56 ef ff ff       	call   8010399d <mycpu>
80104a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a4a:	81 e2 00 02 00 00    	and    $0x200,%edx
80104a50:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a56:	e8 42 ef ff ff       	call   8010399d <mycpu>
80104a5b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a61:	83 c2 01             	add    $0x1,%edx
80104a64:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104a6a:	90                   	nop
80104a6b:	c9                   	leave  
80104a6c:	c3                   	ret    

80104a6d <popcli>:

void
popcli(void)
{
80104a6d:	55                   	push   %ebp
80104a6e:	89 e5                	mov    %esp,%ebp
80104a70:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104a73:	e8 e3 fd ff ff       	call   8010485b <readeflags>
80104a78:	25 00 02 00 00       	and    $0x200,%eax
80104a7d:	85 c0                	test   %eax,%eax
80104a7f:	74 0d                	je     80104a8e <popcli+0x21>
    panic("popcli - interruptible");
80104a81:	83 ec 0c             	sub    $0xc,%esp
80104a84:	68 d7 a8 10 80       	push   $0x8010a8d7
80104a89:	e8 1b bb ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104a8e:	e8 0a ef ff ff       	call   8010399d <mycpu>
80104a93:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a99:	83 ea 01             	sub    $0x1,%edx
80104a9c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104aa2:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104aa8:	85 c0                	test   %eax,%eax
80104aaa:	79 0d                	jns    80104ab9 <popcli+0x4c>
    panic("popcli");
80104aac:	83 ec 0c             	sub    $0xc,%esp
80104aaf:	68 ee a8 10 80       	push   $0x8010a8ee
80104ab4:	e8 f0 ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ab9:	e8 df ee ff ff       	call   8010399d <mycpu>
80104abe:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ac4:	85 c0                	test   %eax,%eax
80104ac6:	75 14                	jne    80104adc <popcli+0x6f>
80104ac8:	e8 d0 ee ff ff       	call   8010399d <mycpu>
80104acd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ad3:	85 c0                	test   %eax,%eax
80104ad5:	74 05                	je     80104adc <popcli+0x6f>
    sti();
80104ad7:	e8 96 fd ff ff       	call   80104872 <sti>
}
80104adc:	90                   	nop
80104add:	c9                   	leave  
80104ade:	c3                   	ret    

80104adf <stosb>:
{
80104adf:	55                   	push   %ebp
80104ae0:	89 e5                	mov    %esp,%ebp
80104ae2:	57                   	push   %edi
80104ae3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104ae4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ae7:	8b 55 10             	mov    0x10(%ebp),%edx
80104aea:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aed:	89 cb                	mov    %ecx,%ebx
80104aef:	89 df                	mov    %ebx,%edi
80104af1:	89 d1                	mov    %edx,%ecx
80104af3:	fc                   	cld    
80104af4:	f3 aa                	rep stos %al,%es:(%edi)
80104af6:	89 ca                	mov    %ecx,%edx
80104af8:	89 fb                	mov    %edi,%ebx
80104afa:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104afd:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b00:	90                   	nop
80104b01:	5b                   	pop    %ebx
80104b02:	5f                   	pop    %edi
80104b03:	5d                   	pop    %ebp
80104b04:	c3                   	ret    

80104b05 <stosl>:
{
80104b05:	55                   	push   %ebp
80104b06:	89 e5                	mov    %esp,%ebp
80104b08:	57                   	push   %edi
80104b09:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104b0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b0d:	8b 55 10             	mov    0x10(%ebp),%edx
80104b10:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b13:	89 cb                	mov    %ecx,%ebx
80104b15:	89 df                	mov    %ebx,%edi
80104b17:	89 d1                	mov    %edx,%ecx
80104b19:	fc                   	cld    
80104b1a:	f3 ab                	rep stos %eax,%es:(%edi)
80104b1c:	89 ca                	mov    %ecx,%edx
80104b1e:	89 fb                	mov    %edi,%ebx
80104b20:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b23:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b26:	90                   	nop
80104b27:	5b                   	pop    %ebx
80104b28:	5f                   	pop    %edi
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    

80104b2b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b2b:	55                   	push   %ebp
80104b2c:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b31:	83 e0 03             	and    $0x3,%eax
80104b34:	85 c0                	test   %eax,%eax
80104b36:	75 43                	jne    80104b7b <memset+0x50>
80104b38:	8b 45 10             	mov    0x10(%ebp),%eax
80104b3b:	83 e0 03             	and    $0x3,%eax
80104b3e:	85 c0                	test   %eax,%eax
80104b40:	75 39                	jne    80104b7b <memset+0x50>
    c &= 0xFF;
80104b42:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b49:	8b 45 10             	mov    0x10(%ebp),%eax
80104b4c:	c1 e8 02             	shr    $0x2,%eax
80104b4f:	89 c2                	mov    %eax,%edx
80104b51:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b54:	c1 e0 18             	shl    $0x18,%eax
80104b57:	89 c1                	mov    %eax,%ecx
80104b59:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5c:	c1 e0 10             	shl    $0x10,%eax
80104b5f:	09 c1                	or     %eax,%ecx
80104b61:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b64:	c1 e0 08             	shl    $0x8,%eax
80104b67:	09 c8                	or     %ecx,%eax
80104b69:	0b 45 0c             	or     0xc(%ebp),%eax
80104b6c:	52                   	push   %edx
80104b6d:	50                   	push   %eax
80104b6e:	ff 75 08             	push   0x8(%ebp)
80104b71:	e8 8f ff ff ff       	call   80104b05 <stosl>
80104b76:	83 c4 0c             	add    $0xc,%esp
80104b79:	eb 12                	jmp    80104b8d <memset+0x62>
  } else
    stosb(dst, c, n);
80104b7b:	8b 45 10             	mov    0x10(%ebp),%eax
80104b7e:	50                   	push   %eax
80104b7f:	ff 75 0c             	push   0xc(%ebp)
80104b82:	ff 75 08             	push   0x8(%ebp)
80104b85:	e8 55 ff ff ff       	call   80104adf <stosb>
80104b8a:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104b8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104b90:	c9                   	leave  
80104b91:	c3                   	ret    

80104b92 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b92:	55                   	push   %ebp
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104b98:	8b 45 08             	mov    0x8(%ebp),%eax
80104b9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104ba4:	eb 30                	jmp    80104bd6 <memcmp+0x44>
    if(*s1 != *s2)
80104ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ba9:	0f b6 10             	movzbl (%eax),%edx
80104bac:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104baf:	0f b6 00             	movzbl (%eax),%eax
80104bb2:	38 c2                	cmp    %al,%dl
80104bb4:	74 18                	je     80104bce <memcmp+0x3c>
      return *s1 - *s2;
80104bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bb9:	0f b6 00             	movzbl (%eax),%eax
80104bbc:	0f b6 d0             	movzbl %al,%edx
80104bbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bc2:	0f b6 00             	movzbl (%eax),%eax
80104bc5:	0f b6 c8             	movzbl %al,%ecx
80104bc8:	89 d0                	mov    %edx,%eax
80104bca:	29 c8                	sub    %ecx,%eax
80104bcc:	eb 1a                	jmp    80104be8 <memcmp+0x56>
    s1++, s2++;
80104bce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104bd2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104bd6:	8b 45 10             	mov    0x10(%ebp),%eax
80104bd9:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bdc:	89 55 10             	mov    %edx,0x10(%ebp)
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	75 c3                	jne    80104ba6 <memcmp+0x14>
  }

  return 0;
80104be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104be8:	c9                   	leave  
80104be9:	c3                   	ret    

80104bea <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bea:	55                   	push   %ebp
80104beb:	89 e5                	mov    %esp,%ebp
80104bed:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104c02:	73 54                	jae    80104c58 <memmove+0x6e>
80104c04:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c07:	8b 45 10             	mov    0x10(%ebp),%eax
80104c0a:	01 d0                	add    %edx,%eax
80104c0c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104c0f:	73 47                	jae    80104c58 <memmove+0x6e>
    s += n;
80104c11:	8b 45 10             	mov    0x10(%ebp),%eax
80104c14:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104c17:	8b 45 10             	mov    0x10(%ebp),%eax
80104c1a:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104c1d:	eb 13                	jmp    80104c32 <memmove+0x48>
      *--d = *--s;
80104c1f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104c23:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c2a:	0f b6 10             	movzbl (%eax),%edx
80104c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c30:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104c32:	8b 45 10             	mov    0x10(%ebp),%eax
80104c35:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c38:	89 55 10             	mov    %edx,0x10(%ebp)
80104c3b:	85 c0                	test   %eax,%eax
80104c3d:	75 e0                	jne    80104c1f <memmove+0x35>
  if(s < d && s + n > d){
80104c3f:	eb 24                	jmp    80104c65 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104c41:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c44:	8d 42 01             	lea    0x1(%edx),%eax
80104c47:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c4d:	8d 48 01             	lea    0x1(%eax),%ecx
80104c50:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104c53:	0f b6 12             	movzbl (%edx),%edx
80104c56:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104c58:	8b 45 10             	mov    0x10(%ebp),%eax
80104c5b:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c5e:	89 55 10             	mov    %edx,0x10(%ebp)
80104c61:	85 c0                	test   %eax,%eax
80104c63:	75 dc                	jne    80104c41 <memmove+0x57>

  return dst;
80104c65:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    

80104c6a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c6a:	55                   	push   %ebp
80104c6b:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104c6d:	ff 75 10             	push   0x10(%ebp)
80104c70:	ff 75 0c             	push   0xc(%ebp)
80104c73:	ff 75 08             	push   0x8(%ebp)
80104c76:	e8 6f ff ff ff       	call   80104bea <memmove>
80104c7b:	83 c4 0c             	add    $0xc,%esp
}
80104c7e:	c9                   	leave  
80104c7f:	c3                   	ret    

80104c80 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104c83:	eb 0c                	jmp    80104c91 <strncmp+0x11>
    n--, p++, q++;
80104c85:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104c89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104c8d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104c95:	74 1a                	je     80104cb1 <strncmp+0x31>
80104c97:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9a:	0f b6 00             	movzbl (%eax),%eax
80104c9d:	84 c0                	test   %al,%al
80104c9f:	74 10                	je     80104cb1 <strncmp+0x31>
80104ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca4:	0f b6 10             	movzbl (%eax),%edx
80104ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104caa:	0f b6 00             	movzbl (%eax),%eax
80104cad:	38 c2                	cmp    %al,%dl
80104caf:	74 d4                	je     80104c85 <strncmp+0x5>
  if(n == 0)
80104cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104cb5:	75 07                	jne    80104cbe <strncmp+0x3e>
    return 0;
80104cb7:	b8 00 00 00 00       	mov    $0x0,%eax
80104cbc:	eb 16                	jmp    80104cd4 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc1:	0f b6 00             	movzbl (%eax),%eax
80104cc4:	0f b6 d0             	movzbl %al,%edx
80104cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cca:	0f b6 00             	movzbl (%eax),%eax
80104ccd:	0f b6 c8             	movzbl %al,%ecx
80104cd0:	89 d0                	mov    %edx,%eax
80104cd2:	29 c8                	sub    %ecx,%eax
}
80104cd4:	5d                   	pop    %ebp
80104cd5:	c3                   	ret    

80104cd6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cd6:	55                   	push   %ebp
80104cd7:	89 e5                	mov    %esp,%ebp
80104cd9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80104cdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ce2:	90                   	nop
80104ce3:	8b 45 10             	mov    0x10(%ebp),%eax
80104ce6:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ce9:	89 55 10             	mov    %edx,0x10(%ebp)
80104cec:	85 c0                	test   %eax,%eax
80104cee:	7e 2c                	jle    80104d1c <strncpy+0x46>
80104cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cf3:	8d 42 01             	lea    0x1(%edx),%eax
80104cf6:	89 45 0c             	mov    %eax,0xc(%ebp)
80104cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfc:	8d 48 01             	lea    0x1(%eax),%ecx
80104cff:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d02:	0f b6 12             	movzbl (%edx),%edx
80104d05:	88 10                	mov    %dl,(%eax)
80104d07:	0f b6 00             	movzbl (%eax),%eax
80104d0a:	84 c0                	test   %al,%al
80104d0c:	75 d5                	jne    80104ce3 <strncpy+0xd>
    ;
  while(n-- > 0)
80104d0e:	eb 0c                	jmp    80104d1c <strncpy+0x46>
    *s++ = 0;
80104d10:	8b 45 08             	mov    0x8(%ebp),%eax
80104d13:	8d 50 01             	lea    0x1(%eax),%edx
80104d16:	89 55 08             	mov    %edx,0x8(%ebp)
80104d19:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104d1c:	8b 45 10             	mov    0x10(%ebp),%eax
80104d1f:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d22:	89 55 10             	mov    %edx,0x10(%ebp)
80104d25:	85 c0                	test   %eax,%eax
80104d27:	7f e7                	jg     80104d10 <strncpy+0x3a>
  return os;
80104d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    

80104d2e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d2e:	55                   	push   %ebp
80104d2f:	89 e5                	mov    %esp,%ebp
80104d31:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d34:	8b 45 08             	mov    0x8(%ebp),%eax
80104d37:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d3e:	7f 05                	jg     80104d45 <safestrcpy+0x17>
    return os;
80104d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d43:	eb 32                	jmp    80104d77 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80104d45:	90                   	nop
80104d46:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d4e:	7e 1e                	jle    80104d6e <safestrcpy+0x40>
80104d50:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d53:	8d 42 01             	lea    0x1(%edx),%eax
80104d56:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d59:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5c:	8d 48 01             	lea    0x1(%eax),%ecx
80104d5f:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d62:	0f b6 12             	movzbl (%edx),%edx
80104d65:	88 10                	mov    %dl,(%eax)
80104d67:	0f b6 00             	movzbl (%eax),%eax
80104d6a:	84 c0                	test   %al,%al
80104d6c:	75 d8                	jne    80104d46 <safestrcpy+0x18>
    ;
  *s = 0;
80104d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d71:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d77:	c9                   	leave  
80104d78:	c3                   	ret    

80104d79 <strlen>:

int
strlen(const char *s)
{
80104d79:	55                   	push   %ebp
80104d7a:	89 e5                	mov    %esp,%ebp
80104d7c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104d86:	eb 04                	jmp    80104d8c <strlen+0x13>
80104d88:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d92:	01 d0                	add    %edx,%eax
80104d94:	0f b6 00             	movzbl (%eax),%eax
80104d97:	84 c0                	test   %al,%al
80104d99:	75 ed                	jne    80104d88 <strlen+0xf>
    ;
  return n;
80104d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d9e:	c9                   	leave  
80104d9f:	c3                   	ret    

80104da0 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104da0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104da4:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104da8:	55                   	push   %ebp
  pushl %ebx
80104da9:	53                   	push   %ebx
  pushl %esi
80104daa:	56                   	push   %esi
  pushl %edi
80104dab:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104dac:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104dae:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104db0:	5f                   	pop    %edi
  popl %esi
80104db1:	5e                   	pop    %esi
  popl %ebx
80104db2:	5b                   	pop    %ebx
  popl %ebp
80104db3:	5d                   	pop    %ebp
  ret
80104db4:	c3                   	ret    

80104db5 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104db5:	55                   	push   %ebp
80104db6:	89 e5                	mov    %esp,%ebp
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
80104db8:	81 7d 08 fe ff ff 7f 	cmpl   $0x7ffffffe,0x8(%ebp)
80104dbf:	77 0a                	ja     80104dcb <fetchint+0x16>
80104dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc4:	83 c0 04             	add    $0x4,%eax
80104dc7:	85 c0                	test   %eax,%eax
80104dc9:	79 07                	jns    80104dd2 <fetchint+0x1d>
    return -1;
80104dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd0:	eb 0f                	jmp    80104de1 <fetchint+0x2c>

  *ip = *(int*)(addr);
80104dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd5:	8b 10                	mov    (%eax),%edx
80104dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dda:	89 10                	mov    %edx,(%eax)
  
  return 0;
80104ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    

80104de3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104de3:	55                   	push   %ebp
80104de4:	89 e5                	mov    %esp,%ebp
80104de6:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= (KERNBASE-1))
80104de9:	81 7d 08 fe ff ff 7f 	cmpl   $0x7ffffffe,0x8(%ebp)
80104df0:	76 07                	jbe    80104df9 <fetchstr+0x16>
    return -1;
80104df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df7:	eb 40                	jmp    80104e39 <fetchstr+0x56>

  *pp = (char*)addr;
80104df9:	8b 55 08             	mov    0x8(%ebp),%edx
80104dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dff:	89 10                	mov    %edx,(%eax)
  ep = (char*)(KERNBASE-1);
80104e01:	c7 45 f8 ff ff ff 7f 	movl   $0x7fffffff,-0x8(%ebp)

  for(s = *pp; s < ep; s++){
80104e08:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e0b:	8b 00                	mov    (%eax),%eax
80104e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e10:	eb 1a                	jmp    80104e2c <fetchstr+0x49>
    if(*s == 0)
80104e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e15:	0f b6 00             	movzbl (%eax),%eax
80104e18:	84 c0                	test   %al,%al
80104e1a:	75 0c                	jne    80104e28 <fetchstr+0x45>
      return s - *pp;
80104e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e1f:	8b 10                	mov    (%eax),%edx
80104e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e24:	29 d0                	sub    %edx,%eax
80104e26:	eb 11                	jmp    80104e39 <fetchstr+0x56>
  for(s = *pp; s < ep; s++){
80104e28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e32:	72 de                	jb     80104e12 <fetchstr+0x2f>
  }
  return -1;
80104e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e39:	c9                   	leave  
80104e3a:	c3                   	ret    

80104e3b <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e3b:	55                   	push   %ebp
80104e3c:	89 e5                	mov    %esp,%ebp
80104e3e:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e41:	e8 cf eb ff ff       	call   80103a15 <myproc>
80104e46:	8b 40 18             	mov    0x18(%eax),%eax
80104e49:	8b 50 44             	mov    0x44(%eax),%edx
80104e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4f:	c1 e0 02             	shl    $0x2,%eax
80104e52:	01 d0                	add    %edx,%eax
80104e54:	83 c0 04             	add    $0x4,%eax
80104e57:	83 ec 08             	sub    $0x8,%esp
80104e5a:	ff 75 0c             	push   0xc(%ebp)
80104e5d:	50                   	push   %eax
80104e5e:	e8 52 ff ff ff       	call   80104db5 <fetchint>
80104e63:	83 c4 10             	add    $0x10,%esp
}
80104e66:	c9                   	leave  
80104e67:	c3                   	ret    

80104e68 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 18             	sub    $0x18,%esp
  int i;
 
  if(argint(n, &i) < 0)
80104e6e:	83 ec 08             	sub    $0x8,%esp
80104e71:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e74:	50                   	push   %eax
80104e75:	ff 75 08             	push   0x8(%ebp)
80104e78:	e8 be ff ff ff       	call   80104e3b <argint>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	79 07                	jns    80104e8b <argptr+0x23>
    return -1;
80104e84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e89:	eb 34                	jmp    80104ebf <argptr+0x57>
  if(size < 0 || (uint)i >= (KERNBASE-1) || (uint)i+size > (KERNBASE-1))
80104e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e8f:	78 18                	js     80104ea9 <argptr+0x41>
80104e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e94:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104e99:	77 0e                	ja     80104ea9 <argptr+0x41>
80104e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9e:	89 c2                	mov    %eax,%edx
80104ea0:	8b 45 10             	mov    0x10(%ebp),%eax
80104ea3:	01 d0                	add    %edx,%eax
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	79 07                	jns    80104eb0 <argptr+0x48>
    return -1;
80104ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eae:	eb 0f                	jmp    80104ebf <argptr+0x57>
  *pp = (char*)i;
80104eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb3:	89 c2                	mov    %eax,%edx
80104eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eb8:	89 10                	mov    %edx,(%eax)
  return 0;
80104eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ebf:	c9                   	leave  
80104ec0:	c3                   	ret    

80104ec1 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ec1:	55                   	push   %ebp
80104ec2:	89 e5                	mov    %esp,%ebp
80104ec4:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ec7:	83 ec 08             	sub    $0x8,%esp
80104eca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ecd:	50                   	push   %eax
80104ece:	ff 75 08             	push   0x8(%ebp)
80104ed1:	e8 65 ff ff ff       	call   80104e3b <argint>
80104ed6:	83 c4 10             	add    $0x10,%esp
80104ed9:	85 c0                	test   %eax,%eax
80104edb:	79 07                	jns    80104ee4 <argstr+0x23>
    return -1;
80104edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee2:	eb 12                	jmp    80104ef6 <argstr+0x35>
  return fetchstr(addr, pp);
80104ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee7:	83 ec 08             	sub    $0x8,%esp
80104eea:	ff 75 0c             	push   0xc(%ebp)
80104eed:	50                   	push   %eax
80104eee:	e8 f0 fe ff ff       	call   80104de3 <fetchstr>
80104ef3:	83 c4 10             	add    $0x10,%esp
}
80104ef6:	c9                   	leave  
80104ef7:	c3                   	ret    

80104ef8 <syscall>:
[SYS_printpt] sys_printpt,
};

void
syscall(void)
{
80104ef8:	55                   	push   %ebp
80104ef9:	89 e5                	mov    %esp,%ebp
80104efb:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104efe:	e8 12 eb ff ff       	call   80103a15 <myproc>
80104f03:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f09:	8b 40 18             	mov    0x18(%eax),%eax
80104f0c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f16:	7e 2f                	jle    80104f47 <syscall+0x4f>
80104f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f1b:	83 f8 16             	cmp    $0x16,%eax
80104f1e:	77 27                	ja     80104f47 <syscall+0x4f>
80104f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f23:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	74 19                	je     80104f47 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f31:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104f38:	ff d0                	call   *%eax
80104f3a:	89 c2                	mov    %eax,%edx
80104f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f3f:	8b 40 18             	mov    0x18(%eax),%eax
80104f42:	89 50 1c             	mov    %edx,0x1c(%eax)
80104f45:	eb 2c                	jmp    80104f73 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f50:	8b 40 10             	mov    0x10(%eax),%eax
80104f53:	ff 75 f0             	push   -0x10(%ebp)
80104f56:	52                   	push   %edx
80104f57:	50                   	push   %eax
80104f58:	68 f5 a8 10 80       	push   $0x8010a8f5
80104f5d:	e8 92 b4 ff ff       	call   801003f4 <cprintf>
80104f62:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80104f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f68:	8b 40 18             	mov    0x18(%eax),%eax
80104f6b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f72:	90                   	nop
80104f73:	90                   	nop
80104f74:	c9                   	leave  
80104f75:	c3                   	ret    

80104f76 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104f76:	55                   	push   %ebp
80104f77:	89 e5                	mov    %esp,%ebp
80104f79:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104f7c:	83 ec 08             	sub    $0x8,%esp
80104f7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f82:	50                   	push   %eax
80104f83:	ff 75 08             	push   0x8(%ebp)
80104f86:	e8 b0 fe ff ff       	call   80104e3b <argint>
80104f8b:	83 c4 10             	add    $0x10,%esp
80104f8e:	85 c0                	test   %eax,%eax
80104f90:	79 07                	jns    80104f99 <argfd+0x23>
    return -1;
80104f92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f97:	eb 4f                	jmp    80104fe8 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f9c:	85 c0                	test   %eax,%eax
80104f9e:	78 20                	js     80104fc0 <argfd+0x4a>
80104fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa3:	83 f8 0f             	cmp    $0xf,%eax
80104fa6:	7f 18                	jg     80104fc0 <argfd+0x4a>
80104fa8:	e8 68 ea ff ff       	call   80103a15 <myproc>
80104fad:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fb0:	83 c2 08             	add    $0x8,%edx
80104fb3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104fbe:	75 07                	jne    80104fc7 <argfd+0x51>
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb 21                	jmp    80104fe8 <argfd+0x72>
  if(pfd)
80104fc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104fcb:	74 08                	je     80104fd5 <argfd+0x5f>
    *pfd = fd;
80104fcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd3:	89 10                	mov    %edx,(%eax)
  if(pf)
80104fd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fd9:	74 08                	je     80104fe3 <argfd+0x6d>
    *pf = f;
80104fdb:	8b 45 10             	mov    0x10(%ebp),%eax
80104fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fe8:	c9                   	leave  
80104fe9:	c3                   	ret    

80104fea <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104fea:	55                   	push   %ebp
80104feb:	89 e5                	mov    %esp,%ebp
80104fed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80104ff0:	e8 20 ea ff ff       	call   80103a15 <myproc>
80104ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80104ff8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fff:	eb 2a                	jmp    8010502b <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105004:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105007:	83 c2 08             	add    $0x8,%edx
8010500a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010500e:	85 c0                	test   %eax,%eax
80105010:	75 15                	jne    80105027 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105012:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8d 4a 08             	lea    0x8(%edx),%ecx
8010501b:	8b 55 08             	mov    0x8(%ebp),%edx
8010501e:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105025:	eb 0f                	jmp    80105036 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105027:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010502b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010502f:	7e d0                	jle    80105001 <fdalloc+0x17>
    }
  }
  return -1;
80105031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105036:	c9                   	leave  
80105037:	c3                   	ret    

80105038 <sys_dup>:

int
sys_dup(void)
{
80105038:	55                   	push   %ebp
80105039:	89 e5                	mov    %esp,%ebp
8010503b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010503e:	83 ec 04             	sub    $0x4,%esp
80105041:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105044:	50                   	push   %eax
80105045:	6a 00                	push   $0x0
80105047:	6a 00                	push   $0x0
80105049:	e8 28 ff ff ff       	call   80104f76 <argfd>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	85 c0                	test   %eax,%eax
80105053:	79 07                	jns    8010505c <sys_dup+0x24>
    return -1;
80105055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505a:	eb 31                	jmp    8010508d <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010505c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010505f:	83 ec 0c             	sub    $0xc,%esp
80105062:	50                   	push   %eax
80105063:	e8 82 ff ff ff       	call   80104fea <fdalloc>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010506e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105072:	79 07                	jns    8010507b <sys_dup+0x43>
    return -1;
80105074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105079:	eb 12                	jmp    8010508d <sys_dup+0x55>
  filedup(f);
8010507b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507e:	83 ec 0c             	sub    $0xc,%esp
80105081:	50                   	push   %eax
80105082:	e8 a8 bf ff ff       	call   8010102f <filedup>
80105087:	83 c4 10             	add    $0x10,%esp
  return fd;
8010508a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010508d:	c9                   	leave  
8010508e:	c3                   	ret    

8010508f <sys_read>:

int
sys_read(void)
{
8010508f:	55                   	push   %ebp
80105090:	89 e5                	mov    %esp,%ebp
80105092:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105095:	83 ec 04             	sub    $0x4,%esp
80105098:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010509b:	50                   	push   %eax
8010509c:	6a 00                	push   $0x0
8010509e:	6a 00                	push   $0x0
801050a0:	e8 d1 fe ff ff       	call   80104f76 <argfd>
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	85 c0                	test   %eax,%eax
801050aa:	78 2e                	js     801050da <sys_read+0x4b>
801050ac:	83 ec 08             	sub    $0x8,%esp
801050af:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b2:	50                   	push   %eax
801050b3:	6a 02                	push   $0x2
801050b5:	e8 81 fd ff ff       	call   80104e3b <argint>
801050ba:	83 c4 10             	add    $0x10,%esp
801050bd:	85 c0                	test   %eax,%eax
801050bf:	78 19                	js     801050da <sys_read+0x4b>
801050c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050c4:	83 ec 04             	sub    $0x4,%esp
801050c7:	50                   	push   %eax
801050c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050cb:	50                   	push   %eax
801050cc:	6a 01                	push   $0x1
801050ce:	e8 95 fd ff ff       	call   80104e68 <argptr>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	79 07                	jns    801050e1 <sys_read+0x52>
    return -1;
801050da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050df:	eb 17                	jmp    801050f8 <sys_read+0x69>
  return fileread(f, p, n);
801050e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801050e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801050e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ea:	83 ec 04             	sub    $0x4,%esp
801050ed:	51                   	push   %ecx
801050ee:	52                   	push   %edx
801050ef:	50                   	push   %eax
801050f0:	e8 ca c0 ff ff       	call   801011bf <fileread>
801050f5:	83 c4 10             	add    $0x10,%esp
}
801050f8:	c9                   	leave  
801050f9:	c3                   	ret    

801050fa <sys_write>:

int
sys_write(void)
{
801050fa:	55                   	push   %ebp
801050fb:	89 e5                	mov    %esp,%ebp
801050fd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105100:	83 ec 04             	sub    $0x4,%esp
80105103:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105106:	50                   	push   %eax
80105107:	6a 00                	push   $0x0
80105109:	6a 00                	push   $0x0
8010510b:	e8 66 fe ff ff       	call   80104f76 <argfd>
80105110:	83 c4 10             	add    $0x10,%esp
80105113:	85 c0                	test   %eax,%eax
80105115:	78 2e                	js     80105145 <sys_write+0x4b>
80105117:	83 ec 08             	sub    $0x8,%esp
8010511a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010511d:	50                   	push   %eax
8010511e:	6a 02                	push   $0x2
80105120:	e8 16 fd ff ff       	call   80104e3b <argint>
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	85 c0                	test   %eax,%eax
8010512a:	78 19                	js     80105145 <sys_write+0x4b>
8010512c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010512f:	83 ec 04             	sub    $0x4,%esp
80105132:	50                   	push   %eax
80105133:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105136:	50                   	push   %eax
80105137:	6a 01                	push   $0x1
80105139:	e8 2a fd ff ff       	call   80104e68 <argptr>
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	85 c0                	test   %eax,%eax
80105143:	79 07                	jns    8010514c <sys_write+0x52>
    return -1;
80105145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514a:	eb 17                	jmp    80105163 <sys_write+0x69>
  return filewrite(f, p, n);
8010514c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010514f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105155:	83 ec 04             	sub    $0x4,%esp
80105158:	51                   	push   %ecx
80105159:	52                   	push   %edx
8010515a:	50                   	push   %eax
8010515b:	e8 17 c1 ff ff       	call   80101277 <filewrite>
80105160:	83 c4 10             	add    $0x10,%esp
}
80105163:	c9                   	leave  
80105164:	c3                   	ret    

80105165 <sys_close>:

int
sys_close(void)
{
80105165:	55                   	push   %ebp
80105166:	89 e5                	mov    %esp,%ebp
80105168:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010516b:	83 ec 04             	sub    $0x4,%esp
8010516e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105171:	50                   	push   %eax
80105172:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105175:	50                   	push   %eax
80105176:	6a 00                	push   $0x0
80105178:	e8 f9 fd ff ff       	call   80104f76 <argfd>
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	85 c0                	test   %eax,%eax
80105182:	79 07                	jns    8010518b <sys_close+0x26>
    return -1;
80105184:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105189:	eb 27                	jmp    801051b2 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
8010518b:	e8 85 e8 ff ff       	call   80103a15 <myproc>
80105190:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105193:	83 c2 08             	add    $0x8,%edx
80105196:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010519d:	00 
  fileclose(f);
8010519e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a1:	83 ec 0c             	sub    $0xc,%esp
801051a4:	50                   	push   %eax
801051a5:	e8 d6 be ff ff       	call   80101080 <fileclose>
801051aa:	83 c4 10             	add    $0x10,%esp
  return 0;
801051ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051b2:	c9                   	leave  
801051b3:	c3                   	ret    

801051b4 <sys_fstat>:

int
sys_fstat(void)
{
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051ba:	83 ec 04             	sub    $0x4,%esp
801051bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c0:	50                   	push   %eax
801051c1:	6a 00                	push   $0x0
801051c3:	6a 00                	push   $0x0
801051c5:	e8 ac fd ff ff       	call   80104f76 <argfd>
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	85 c0                	test   %eax,%eax
801051cf:	78 17                	js     801051e8 <sys_fstat+0x34>
801051d1:	83 ec 04             	sub    $0x4,%esp
801051d4:	6a 14                	push   $0x14
801051d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051d9:	50                   	push   %eax
801051da:	6a 01                	push   $0x1
801051dc:	e8 87 fc ff ff       	call   80104e68 <argptr>
801051e1:	83 c4 10             	add    $0x10,%esp
801051e4:	85 c0                	test   %eax,%eax
801051e6:	79 07                	jns    801051ef <sys_fstat+0x3b>
    return -1;
801051e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ed:	eb 13                	jmp    80105202 <sys_fstat+0x4e>
  return filestat(f, st);
801051ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	52                   	push   %edx
801051f9:	50                   	push   %eax
801051fa:	e8 69 bf ff ff       	call   80101168 <filestat>
801051ff:	83 c4 10             	add    $0x10,%esp
}
80105202:	c9                   	leave  
80105203:	c3                   	ret    

80105204 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010520a:	83 ec 08             	sub    $0x8,%esp
8010520d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105210:	50                   	push   %eax
80105211:	6a 00                	push   $0x0
80105213:	e8 a9 fc ff ff       	call   80104ec1 <argstr>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	78 15                	js     80105234 <sys_link+0x30>
8010521f:	83 ec 08             	sub    $0x8,%esp
80105222:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105225:	50                   	push   %eax
80105226:	6a 01                	push   $0x1
80105228:	e8 94 fc ff ff       	call   80104ec1 <argstr>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	79 0a                	jns    8010523e <sys_link+0x3a>
    return -1;
80105234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105239:	e9 68 01 00 00       	jmp    801053a6 <sys_link+0x1a2>

  begin_op();
8010523e:	e8 de dd ff ff       	call   80103021 <begin_op>
  if((ip = namei(old)) == 0){
80105243:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105246:	83 ec 0c             	sub    $0xc,%esp
80105249:	50                   	push   %eax
8010524a:	e8 b3 d2 ff ff       	call   80102502 <namei>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105259:	75 0f                	jne    8010526a <sys_link+0x66>
    end_op();
8010525b:	e8 4d de ff ff       	call   801030ad <end_op>
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105265:	e9 3c 01 00 00       	jmp    801053a6 <sys_link+0x1a2>
  }

  ilock(ip);
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	ff 75 f4             	push   -0xc(%ebp)
80105270:	e8 5a c7 ff ff       	call   801019cf <ilock>
80105275:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010527b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010527f:	66 83 f8 01          	cmp    $0x1,%ax
80105283:	75 1d                	jne    801052a2 <sys_link+0x9e>
    iunlockput(ip);
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	ff 75 f4             	push   -0xc(%ebp)
8010528b:	e8 70 c9 ff ff       	call   80101c00 <iunlockput>
80105290:	83 c4 10             	add    $0x10,%esp
    end_op();
80105293:	e8 15 de ff ff       	call   801030ad <end_op>
    return -1;
80105298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529d:	e9 04 01 00 00       	jmp    801053a6 <sys_link+0x1a2>
  }

  ip->nlink++;
801052a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a5:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801052a9:	83 c0 01             	add    $0x1,%eax
801052ac:	89 c2                	mov    %eax,%edx
801052ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b1:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801052b5:	83 ec 0c             	sub    $0xc,%esp
801052b8:	ff 75 f4             	push   -0xc(%ebp)
801052bb:	e8 32 c5 ff ff       	call   801017f2 <iupdate>
801052c0:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801052c3:	83 ec 0c             	sub    $0xc,%esp
801052c6:	ff 75 f4             	push   -0xc(%ebp)
801052c9:	e8 14 c8 ff ff       	call   80101ae2 <iunlock>
801052ce:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801052d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801052d4:	83 ec 08             	sub    $0x8,%esp
801052d7:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801052da:	52                   	push   %edx
801052db:	50                   	push   %eax
801052dc:	e8 3d d2 ff ff       	call   8010251e <nameiparent>
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801052e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052eb:	74 71                	je     8010535e <sys_link+0x15a>
    goto bad;
  ilock(dp);
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	ff 75 f0             	push   -0x10(%ebp)
801052f3:	e8 d7 c6 ff ff       	call   801019cf <ilock>
801052f8:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052fe:	8b 10                	mov    (%eax),%edx
80105300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105303:	8b 00                	mov    (%eax),%eax
80105305:	39 c2                	cmp    %eax,%edx
80105307:	75 1d                	jne    80105326 <sys_link+0x122>
80105309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530c:	8b 40 04             	mov    0x4(%eax),%eax
8010530f:	83 ec 04             	sub    $0x4,%esp
80105312:	50                   	push   %eax
80105313:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105316:	50                   	push   %eax
80105317:	ff 75 f0             	push   -0x10(%ebp)
8010531a:	e8 4c cf ff ff       	call   8010226b <dirlink>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	79 10                	jns    80105336 <sys_link+0x132>
    iunlockput(dp);
80105326:	83 ec 0c             	sub    $0xc,%esp
80105329:	ff 75 f0             	push   -0x10(%ebp)
8010532c:	e8 cf c8 ff ff       	call   80101c00 <iunlockput>
80105331:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105334:	eb 29                	jmp    8010535f <sys_link+0x15b>
  }
  iunlockput(dp);
80105336:	83 ec 0c             	sub    $0xc,%esp
80105339:	ff 75 f0             	push   -0x10(%ebp)
8010533c:	e8 bf c8 ff ff       	call   80101c00 <iunlockput>
80105341:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	ff 75 f4             	push   -0xc(%ebp)
8010534a:	e8 e1 c7 ff ff       	call   80101b30 <iput>
8010534f:	83 c4 10             	add    $0x10,%esp

  end_op();
80105352:	e8 56 dd ff ff       	call   801030ad <end_op>

  return 0;
80105357:	b8 00 00 00 00       	mov    $0x0,%eax
8010535c:	eb 48                	jmp    801053a6 <sys_link+0x1a2>
    goto bad;
8010535e:	90                   	nop

bad:
  ilock(ip);
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	ff 75 f4             	push   -0xc(%ebp)
80105365:	e8 65 c6 ff ff       	call   801019cf <ilock>
8010536a:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010536d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105370:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105374:	83 e8 01             	sub    $0x1,%eax
80105377:	89 c2                	mov    %eax,%edx
80105379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537c:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	ff 75 f4             	push   -0xc(%ebp)
80105386:	e8 67 c4 ff ff       	call   801017f2 <iupdate>
8010538b:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010538e:	83 ec 0c             	sub    $0xc,%esp
80105391:	ff 75 f4             	push   -0xc(%ebp)
80105394:	e8 67 c8 ff ff       	call   80101c00 <iunlockput>
80105399:	83 c4 10             	add    $0x10,%esp
  end_op();
8010539c:	e8 0c dd ff ff       	call   801030ad <end_op>
  return -1;
801053a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053a6:	c9                   	leave  
801053a7:	c3                   	ret    

801053a8 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801053a8:	55                   	push   %ebp
801053a9:	89 e5                	mov    %esp,%ebp
801053ab:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053ae:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801053b5:	eb 40                	jmp    801053f7 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ba:	6a 10                	push   $0x10
801053bc:	50                   	push   %eax
801053bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c0:	50                   	push   %eax
801053c1:	ff 75 08             	push   0x8(%ebp)
801053c4:	e8 f2 ca ff ff       	call   80101ebb <readi>
801053c9:	83 c4 10             	add    $0x10,%esp
801053cc:	83 f8 10             	cmp    $0x10,%eax
801053cf:	74 0d                	je     801053de <isdirempty+0x36>
      panic("isdirempty: readi");
801053d1:	83 ec 0c             	sub    $0xc,%esp
801053d4:	68 11 a9 10 80       	push   $0x8010a911
801053d9:	e8 cb b1 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801053de:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801053e2:	66 85 c0             	test   %ax,%ax
801053e5:	74 07                	je     801053ee <isdirempty+0x46>
      return 0;
801053e7:	b8 00 00 00 00       	mov    $0x0,%eax
801053ec:	eb 1b                	jmp    80105409 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f1:	83 c0 10             	add    $0x10,%eax
801053f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053f7:	8b 45 08             	mov    0x8(%ebp),%eax
801053fa:	8b 50 58             	mov    0x58(%eax),%edx
801053fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105400:	39 c2                	cmp    %eax,%edx
80105402:	77 b3                	ja     801053b7 <isdirempty+0xf>
  }
  return 1;
80105404:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105409:	c9                   	leave  
8010540a:	c3                   	ret    

8010540b <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010540b:	55                   	push   %ebp
8010540c:	89 e5                	mov    %esp,%ebp
8010540e:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105411:	83 ec 08             	sub    $0x8,%esp
80105414:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105417:	50                   	push   %eax
80105418:	6a 00                	push   $0x0
8010541a:	e8 a2 fa ff ff       	call   80104ec1 <argstr>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	85 c0                	test   %eax,%eax
80105424:	79 0a                	jns    80105430 <sys_unlink+0x25>
    return -1;
80105426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542b:	e9 bf 01 00 00       	jmp    801055ef <sys_unlink+0x1e4>

  begin_op();
80105430:	e8 ec db ff ff       	call   80103021 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105435:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105438:	83 ec 08             	sub    $0x8,%esp
8010543b:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010543e:	52                   	push   %edx
8010543f:	50                   	push   %eax
80105440:	e8 d9 d0 ff ff       	call   8010251e <nameiparent>
80105445:	83 c4 10             	add    $0x10,%esp
80105448:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010544b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010544f:	75 0f                	jne    80105460 <sys_unlink+0x55>
    end_op();
80105451:	e8 57 dc ff ff       	call   801030ad <end_op>
    return -1;
80105456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545b:	e9 8f 01 00 00       	jmp    801055ef <sys_unlink+0x1e4>
  }

  ilock(dp);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	ff 75 f4             	push   -0xc(%ebp)
80105466:	e8 64 c5 ff ff       	call   801019cf <ilock>
8010546b:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010546e:	83 ec 08             	sub    $0x8,%esp
80105471:	68 23 a9 10 80       	push   $0x8010a923
80105476:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105479:	50                   	push   %eax
8010547a:	e8 17 cd ff ff       	call   80102196 <namecmp>
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	85 c0                	test   %eax,%eax
80105484:	0f 84 49 01 00 00    	je     801055d3 <sys_unlink+0x1c8>
8010548a:	83 ec 08             	sub    $0x8,%esp
8010548d:	68 25 a9 10 80       	push   $0x8010a925
80105492:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105495:	50                   	push   %eax
80105496:	e8 fb cc ff ff       	call   80102196 <namecmp>
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	85 c0                	test   %eax,%eax
801054a0:	0f 84 2d 01 00 00    	je     801055d3 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	8d 45 c8             	lea    -0x38(%ebp),%eax
801054ac:	50                   	push   %eax
801054ad:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801054b0:	50                   	push   %eax
801054b1:	ff 75 f4             	push   -0xc(%ebp)
801054b4:	e8 f8 cc ff ff       	call   801021b1 <dirlookup>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801054bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054c3:	0f 84 0d 01 00 00    	je     801055d6 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	ff 75 f0             	push   -0x10(%ebp)
801054cf:	e8 fb c4 ff ff       	call   801019cf <ilock>
801054d4:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801054d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054da:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801054de:	66 85 c0             	test   %ax,%ax
801054e1:	7f 0d                	jg     801054f0 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801054e3:	83 ec 0c             	sub    $0xc,%esp
801054e6:	68 28 a9 10 80       	push   $0x8010a928
801054eb:	e8 b9 b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054f3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801054f7:	66 83 f8 01          	cmp    $0x1,%ax
801054fb:	75 25                	jne    80105522 <sys_unlink+0x117>
801054fd:	83 ec 0c             	sub    $0xc,%esp
80105500:	ff 75 f0             	push   -0x10(%ebp)
80105503:	e8 a0 fe ff ff       	call   801053a8 <isdirempty>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	75 13                	jne    80105522 <sys_unlink+0x117>
    iunlockput(ip);
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	ff 75 f0             	push   -0x10(%ebp)
80105515:	e8 e6 c6 ff ff       	call   80101c00 <iunlockput>
8010551a:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010551d:	e9 b5 00 00 00       	jmp    801055d7 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105522:	83 ec 04             	sub    $0x4,%esp
80105525:	6a 10                	push   $0x10
80105527:	6a 00                	push   $0x0
80105529:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010552c:	50                   	push   %eax
8010552d:	e8 f9 f5 ff ff       	call   80104b2b <memset>
80105532:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105535:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105538:	6a 10                	push   $0x10
8010553a:	50                   	push   %eax
8010553b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010553e:	50                   	push   %eax
8010553f:	ff 75 f4             	push   -0xc(%ebp)
80105542:	e8 c9 ca ff ff       	call   80102010 <writei>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	83 f8 10             	cmp    $0x10,%eax
8010554d:	74 0d                	je     8010555c <sys_unlink+0x151>
    panic("unlink: writei");
8010554f:	83 ec 0c             	sub    $0xc,%esp
80105552:	68 3a a9 10 80       	push   $0x8010a93a
80105557:	e8 4d b0 ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
8010555c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010555f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105563:	66 83 f8 01          	cmp    $0x1,%ax
80105567:	75 21                	jne    8010558a <sys_unlink+0x17f>
    dp->nlink--;
80105569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010556c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105570:	83 e8 01             	sub    $0x1,%eax
80105573:	89 c2                	mov    %eax,%edx
80105575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105578:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	ff 75 f4             	push   -0xc(%ebp)
80105582:	e8 6b c2 ff ff       	call   801017f2 <iupdate>
80105587:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010558a:	83 ec 0c             	sub    $0xc,%esp
8010558d:	ff 75 f4             	push   -0xc(%ebp)
80105590:	e8 6b c6 ff ff       	call   80101c00 <iunlockput>
80105595:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010559b:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010559f:	83 e8 01             	sub    $0x1,%eax
801055a2:	89 c2                	mov    %eax,%edx
801055a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a7:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801055ab:	83 ec 0c             	sub    $0xc,%esp
801055ae:	ff 75 f0             	push   -0x10(%ebp)
801055b1:	e8 3c c2 ff ff       	call   801017f2 <iupdate>
801055b6:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	ff 75 f0             	push   -0x10(%ebp)
801055bf:	e8 3c c6 ff ff       	call   80101c00 <iunlockput>
801055c4:	83 c4 10             	add    $0x10,%esp

  end_op();
801055c7:	e8 e1 da ff ff       	call   801030ad <end_op>

  return 0;
801055cc:	b8 00 00 00 00       	mov    $0x0,%eax
801055d1:	eb 1c                	jmp    801055ef <sys_unlink+0x1e4>
    goto bad;
801055d3:	90                   	nop
801055d4:	eb 01                	jmp    801055d7 <sys_unlink+0x1cc>
    goto bad;
801055d6:	90                   	nop

bad:
  iunlockput(dp);
801055d7:	83 ec 0c             	sub    $0xc,%esp
801055da:	ff 75 f4             	push   -0xc(%ebp)
801055dd:	e8 1e c6 ff ff       	call   80101c00 <iunlockput>
801055e2:	83 c4 10             	add    $0x10,%esp
  end_op();
801055e5:	e8 c3 da ff ff       	call   801030ad <end_op>
  return -1;
801055ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ef:	c9                   	leave  
801055f0:	c3                   	ret    

801055f1 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801055f1:	55                   	push   %ebp
801055f2:	89 e5                	mov    %esp,%ebp
801055f4:	83 ec 38             	sub    $0x38,%esp
801055f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055fa:	8b 55 10             	mov    0x10(%ebp),%edx
801055fd:	8b 45 14             	mov    0x14(%ebp),%eax
80105600:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105604:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105608:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010560c:	83 ec 08             	sub    $0x8,%esp
8010560f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105612:	50                   	push   %eax
80105613:	ff 75 08             	push   0x8(%ebp)
80105616:	e8 03 cf ff ff       	call   8010251e <nameiparent>
8010561b:	83 c4 10             	add    $0x10,%esp
8010561e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105625:	75 0a                	jne    80105631 <create+0x40>
    return 0;
80105627:	b8 00 00 00 00       	mov    $0x0,%eax
8010562c:	e9 90 01 00 00       	jmp    801057c1 <create+0x1d0>
  ilock(dp);
80105631:	83 ec 0c             	sub    $0xc,%esp
80105634:	ff 75 f4             	push   -0xc(%ebp)
80105637:	e8 93 c3 ff ff       	call   801019cf <ilock>
8010563c:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010563f:	83 ec 04             	sub    $0x4,%esp
80105642:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105645:	50                   	push   %eax
80105646:	8d 45 de             	lea    -0x22(%ebp),%eax
80105649:	50                   	push   %eax
8010564a:	ff 75 f4             	push   -0xc(%ebp)
8010564d:	e8 5f cb ff ff       	call   801021b1 <dirlookup>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105658:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010565c:	74 50                	je     801056ae <create+0xbd>
    iunlockput(dp);
8010565e:	83 ec 0c             	sub    $0xc,%esp
80105661:	ff 75 f4             	push   -0xc(%ebp)
80105664:	e8 97 c5 ff ff       	call   80101c00 <iunlockput>
80105669:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010566c:	83 ec 0c             	sub    $0xc,%esp
8010566f:	ff 75 f0             	push   -0x10(%ebp)
80105672:	e8 58 c3 ff ff       	call   801019cf <ilock>
80105677:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010567a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010567f:	75 15                	jne    80105696 <create+0xa5>
80105681:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105684:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105688:	66 83 f8 02          	cmp    $0x2,%ax
8010568c:	75 08                	jne    80105696 <create+0xa5>
      return ip;
8010568e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105691:	e9 2b 01 00 00       	jmp    801057c1 <create+0x1d0>
    iunlockput(ip);
80105696:	83 ec 0c             	sub    $0xc,%esp
80105699:	ff 75 f0             	push   -0x10(%ebp)
8010569c:	e8 5f c5 ff ff       	call   80101c00 <iunlockput>
801056a1:	83 c4 10             	add    $0x10,%esp
    return 0;
801056a4:	b8 00 00 00 00       	mov    $0x0,%eax
801056a9:	e9 13 01 00 00       	jmp    801057c1 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801056ae:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801056b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b5:	8b 00                	mov    (%eax),%eax
801056b7:	83 ec 08             	sub    $0x8,%esp
801056ba:	52                   	push   %edx
801056bb:	50                   	push   %eax
801056bc:	e8 5a c0 ff ff       	call   8010171b <ialloc>
801056c1:	83 c4 10             	add    $0x10,%esp
801056c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056cb:	75 0d                	jne    801056da <create+0xe9>
    panic("create: ialloc");
801056cd:	83 ec 0c             	sub    $0xc,%esp
801056d0:	68 49 a9 10 80       	push   $0x8010a949
801056d5:	e8 cf ae ff ff       	call   801005a9 <panic>

  ilock(ip);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	ff 75 f0             	push   -0x10(%ebp)
801056e0:	e8 ea c2 ff ff       	call   801019cf <ilock>
801056e5:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801056e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056eb:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801056ef:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801056f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f6:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801056fa:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801056fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105701:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105707:	83 ec 0c             	sub    $0xc,%esp
8010570a:	ff 75 f0             	push   -0x10(%ebp)
8010570d:	e8 e0 c0 ff ff       	call   801017f2 <iupdate>
80105712:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105715:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010571a:	75 6a                	jne    80105786 <create+0x195>
    dp->nlink++;  // for ".."
8010571c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105723:	83 c0 01             	add    $0x1,%eax
80105726:	89 c2                	mov    %eax,%edx
80105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572b:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010572f:	83 ec 0c             	sub    $0xc,%esp
80105732:	ff 75 f4             	push   -0xc(%ebp)
80105735:	e8 b8 c0 ff ff       	call   801017f2 <iupdate>
8010573a:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010573d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105740:	8b 40 04             	mov    0x4(%eax),%eax
80105743:	83 ec 04             	sub    $0x4,%esp
80105746:	50                   	push   %eax
80105747:	68 23 a9 10 80       	push   $0x8010a923
8010574c:	ff 75 f0             	push   -0x10(%ebp)
8010574f:	e8 17 cb ff ff       	call   8010226b <dirlink>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	78 1e                	js     80105779 <create+0x188>
8010575b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575e:	8b 40 04             	mov    0x4(%eax),%eax
80105761:	83 ec 04             	sub    $0x4,%esp
80105764:	50                   	push   %eax
80105765:	68 25 a9 10 80       	push   $0x8010a925
8010576a:	ff 75 f0             	push   -0x10(%ebp)
8010576d:	e8 f9 ca ff ff       	call   8010226b <dirlink>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	79 0d                	jns    80105786 <create+0x195>
      panic("create dots");
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	68 58 a9 10 80       	push   $0x8010a958
80105781:	e8 23 ae ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105786:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105789:	8b 40 04             	mov    0x4(%eax),%eax
8010578c:	83 ec 04             	sub    $0x4,%esp
8010578f:	50                   	push   %eax
80105790:	8d 45 de             	lea    -0x22(%ebp),%eax
80105793:	50                   	push   %eax
80105794:	ff 75 f4             	push   -0xc(%ebp)
80105797:	e8 cf ca ff ff       	call   8010226b <dirlink>
8010579c:	83 c4 10             	add    $0x10,%esp
8010579f:	85 c0                	test   %eax,%eax
801057a1:	79 0d                	jns    801057b0 <create+0x1bf>
    panic("create: dirlink");
801057a3:	83 ec 0c             	sub    $0xc,%esp
801057a6:	68 64 a9 10 80       	push   $0x8010a964
801057ab:	e8 f9 ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	ff 75 f4             	push   -0xc(%ebp)
801057b6:	e8 45 c4 ff ff       	call   80101c00 <iunlockput>
801057bb:	83 c4 10             	add    $0x10,%esp

  return ip;
801057be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801057c1:	c9                   	leave  
801057c2:	c3                   	ret    

801057c3 <sys_open>:

int
sys_open(void)
{
801057c3:	55                   	push   %ebp
801057c4:	89 e5                	mov    %esp,%ebp
801057c6:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057c9:	83 ec 08             	sub    $0x8,%esp
801057cc:	8d 45 e8             	lea    -0x18(%ebp),%eax
801057cf:	50                   	push   %eax
801057d0:	6a 00                	push   $0x0
801057d2:	e8 ea f6 ff ff       	call   80104ec1 <argstr>
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	85 c0                	test   %eax,%eax
801057dc:	78 15                	js     801057f3 <sys_open+0x30>
801057de:	83 ec 08             	sub    $0x8,%esp
801057e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057e4:	50                   	push   %eax
801057e5:	6a 01                	push   $0x1
801057e7:	e8 4f f6 ff ff       	call   80104e3b <argint>
801057ec:	83 c4 10             	add    $0x10,%esp
801057ef:	85 c0                	test   %eax,%eax
801057f1:	79 0a                	jns    801057fd <sys_open+0x3a>
    return -1;
801057f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f8:	e9 61 01 00 00       	jmp    8010595e <sys_open+0x19b>

  begin_op();
801057fd:	e8 1f d8 ff ff       	call   80103021 <begin_op>

  if(omode & O_CREATE){
80105802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105805:	25 00 02 00 00       	and    $0x200,%eax
8010580a:	85 c0                	test   %eax,%eax
8010580c:	74 2a                	je     80105838 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010580e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105811:	6a 00                	push   $0x0
80105813:	6a 00                	push   $0x0
80105815:	6a 02                	push   $0x2
80105817:	50                   	push   %eax
80105818:	e8 d4 fd ff ff       	call   801055f1 <create>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105827:	75 75                	jne    8010589e <sys_open+0xdb>
      end_op();
80105829:	e8 7f d8 ff ff       	call   801030ad <end_op>
      return -1;
8010582e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105833:	e9 26 01 00 00       	jmp    8010595e <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105838:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010583b:	83 ec 0c             	sub    $0xc,%esp
8010583e:	50                   	push   %eax
8010583f:	e8 be cc ff ff       	call   80102502 <namei>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010584a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010584e:	75 0f                	jne    8010585f <sys_open+0x9c>
      end_op();
80105850:	e8 58 d8 ff ff       	call   801030ad <end_op>
      return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	e9 ff 00 00 00       	jmp    8010595e <sys_open+0x19b>
    }
    ilock(ip);
8010585f:	83 ec 0c             	sub    $0xc,%esp
80105862:	ff 75 f4             	push   -0xc(%ebp)
80105865:	e8 65 c1 ff ff       	call   801019cf <ilock>
8010586a:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010586d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105870:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105874:	66 83 f8 01          	cmp    $0x1,%ax
80105878:	75 24                	jne    8010589e <sys_open+0xdb>
8010587a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010587d:	85 c0                	test   %eax,%eax
8010587f:	74 1d                	je     8010589e <sys_open+0xdb>
      iunlockput(ip);
80105881:	83 ec 0c             	sub    $0xc,%esp
80105884:	ff 75 f4             	push   -0xc(%ebp)
80105887:	e8 74 c3 ff ff       	call   80101c00 <iunlockput>
8010588c:	83 c4 10             	add    $0x10,%esp
      end_op();
8010588f:	e8 19 d8 ff ff       	call   801030ad <end_op>
      return -1;
80105894:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105899:	e9 c0 00 00 00       	jmp    8010595e <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010589e:	e8 1f b7 ff ff       	call   80100fc2 <filealloc>
801058a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058aa:	74 17                	je     801058c3 <sys_open+0x100>
801058ac:	83 ec 0c             	sub    $0xc,%esp
801058af:	ff 75 f0             	push   -0x10(%ebp)
801058b2:	e8 33 f7 ff ff       	call   80104fea <fdalloc>
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
801058bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801058c1:	79 2e                	jns    801058f1 <sys_open+0x12e>
    if(f)
801058c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058c7:	74 0e                	je     801058d7 <sys_open+0x114>
      fileclose(f);
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	ff 75 f0             	push   -0x10(%ebp)
801058cf:	e8 ac b7 ff ff       	call   80101080 <fileclose>
801058d4:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	ff 75 f4             	push   -0xc(%ebp)
801058dd:	e8 1e c3 ff ff       	call   80101c00 <iunlockput>
801058e2:	83 c4 10             	add    $0x10,%esp
    end_op();
801058e5:	e8 c3 d7 ff ff       	call   801030ad <end_op>
    return -1;
801058ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ef:	eb 6d                	jmp    8010595e <sys_open+0x19b>
  }
  iunlock(ip);
801058f1:	83 ec 0c             	sub    $0xc,%esp
801058f4:	ff 75 f4             	push   -0xc(%ebp)
801058f7:	e8 e6 c1 ff ff       	call   80101ae2 <iunlock>
801058fc:	83 c4 10             	add    $0x10,%esp
  end_op();
801058ff:	e8 a9 d7 ff ff       	call   801030ad <end_op>

  f->type = FD_INODE;
80105904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105907:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010590d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105910:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105913:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105916:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105919:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105923:	83 e0 01             	and    $0x1,%eax
80105926:	85 c0                	test   %eax,%eax
80105928:	0f 94 c0             	sete   %al
8010592b:	89 c2                	mov    %eax,%edx
8010592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105930:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105936:	83 e0 01             	and    $0x1,%eax
80105939:	85 c0                	test   %eax,%eax
8010593b:	75 0a                	jne    80105947 <sys_open+0x184>
8010593d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105940:	83 e0 02             	and    $0x2,%eax
80105943:	85 c0                	test   %eax,%eax
80105945:	74 07                	je     8010594e <sys_open+0x18b>
80105947:	b8 01 00 00 00       	mov    $0x1,%eax
8010594c:	eb 05                	jmp    80105953 <sys_open+0x190>
8010594e:	b8 00 00 00 00       	mov    $0x0,%eax
80105953:	89 c2                	mov    %eax,%edx
80105955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105958:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010595b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010595e:	c9                   	leave  
8010595f:	c3                   	ret    

80105960 <sys_mkdir>:

int
sys_mkdir(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105966:	e8 b6 d6 ff ff       	call   80103021 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105971:	50                   	push   %eax
80105972:	6a 00                	push   $0x0
80105974:	e8 48 f5 ff ff       	call   80104ec1 <argstr>
80105979:	83 c4 10             	add    $0x10,%esp
8010597c:	85 c0                	test   %eax,%eax
8010597e:	78 1b                	js     8010599b <sys_mkdir+0x3b>
80105980:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105983:	6a 00                	push   $0x0
80105985:	6a 00                	push   $0x0
80105987:	6a 01                	push   $0x1
80105989:	50                   	push   %eax
8010598a:	e8 62 fc ff ff       	call   801055f1 <create>
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105995:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105999:	75 0c                	jne    801059a7 <sys_mkdir+0x47>
    end_op();
8010599b:	e8 0d d7 ff ff       	call   801030ad <end_op>
    return -1;
801059a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a5:	eb 18                	jmp    801059bf <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801059a7:	83 ec 0c             	sub    $0xc,%esp
801059aa:	ff 75 f4             	push   -0xc(%ebp)
801059ad:	e8 4e c2 ff ff       	call   80101c00 <iunlockput>
801059b2:	83 c4 10             	add    $0x10,%esp
  end_op();
801059b5:	e8 f3 d6 ff ff       	call   801030ad <end_op>
  return 0;
801059ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059bf:	c9                   	leave  
801059c0:	c3                   	ret    

801059c1 <sys_mknod>:

int
sys_mknod(void)
{
801059c1:	55                   	push   %ebp
801059c2:	89 e5                	mov    %esp,%ebp
801059c4:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059c7:	e8 55 d6 ff ff       	call   80103021 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059cc:	83 ec 08             	sub    $0x8,%esp
801059cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059d2:	50                   	push   %eax
801059d3:	6a 00                	push   $0x0
801059d5:	e8 e7 f4 ff ff       	call   80104ec1 <argstr>
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	85 c0                	test   %eax,%eax
801059df:	78 4f                	js     80105a30 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
801059e1:	83 ec 08             	sub    $0x8,%esp
801059e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e7:	50                   	push   %eax
801059e8:	6a 01                	push   $0x1
801059ea:	e8 4c f4 ff ff       	call   80104e3b <argint>
801059ef:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801059f2:	85 c0                	test   %eax,%eax
801059f4:	78 3a                	js     80105a30 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
801059f6:	83 ec 08             	sub    $0x8,%esp
801059f9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801059fc:	50                   	push   %eax
801059fd:	6a 02                	push   $0x2
801059ff:	e8 37 f4 ff ff       	call   80104e3b <argint>
80105a04:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105a07:	85 c0                	test   %eax,%eax
80105a09:	78 25                	js     80105a30 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a0e:	0f bf c8             	movswl %ax,%ecx
80105a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a14:	0f bf d0             	movswl %ax,%edx
80105a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1a:	51                   	push   %ecx
80105a1b:	52                   	push   %edx
80105a1c:	6a 03                	push   $0x3
80105a1e:	50                   	push   %eax
80105a1f:	e8 cd fb ff ff       	call   801055f1 <create>
80105a24:	83 c4 10             	add    $0x10,%esp
80105a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a2e:	75 0c                	jne    80105a3c <sys_mknod+0x7b>
    end_op();
80105a30:	e8 78 d6 ff ff       	call   801030ad <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb 18                	jmp    80105a54 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105a3c:	83 ec 0c             	sub    $0xc,%esp
80105a3f:	ff 75 f4             	push   -0xc(%ebp)
80105a42:	e8 b9 c1 ff ff       	call   80101c00 <iunlockput>
80105a47:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a4a:	e8 5e d6 ff ff       	call   801030ad <end_op>
  return 0;
80105a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a54:	c9                   	leave  
80105a55:	c3                   	ret    

80105a56 <sys_chdir>:

int
sys_chdir(void)
{
80105a56:	55                   	push   %ebp
80105a57:	89 e5                	mov    %esp,%ebp
80105a59:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a5c:	e8 b4 df ff ff       	call   80103a15 <myproc>
80105a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105a64:	e8 b8 d5 ff ff       	call   80103021 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a69:	83 ec 08             	sub    $0x8,%esp
80105a6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a6f:	50                   	push   %eax
80105a70:	6a 00                	push   $0x0
80105a72:	e8 4a f4 ff ff       	call   80104ec1 <argstr>
80105a77:	83 c4 10             	add    $0x10,%esp
80105a7a:	85 c0                	test   %eax,%eax
80105a7c:	78 18                	js     80105a96 <sys_chdir+0x40>
80105a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a81:	83 ec 0c             	sub    $0xc,%esp
80105a84:	50                   	push   %eax
80105a85:	e8 78 ca ff ff       	call   80102502 <namei>
80105a8a:	83 c4 10             	add    $0x10,%esp
80105a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a94:	75 0c                	jne    80105aa2 <sys_chdir+0x4c>
    end_op();
80105a96:	e8 12 d6 ff ff       	call   801030ad <end_op>
    return -1;
80105a9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa0:	eb 68                	jmp    80105b0a <sys_chdir+0xb4>
  }
  ilock(ip);
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	ff 75 f0             	push   -0x10(%ebp)
80105aa8:	e8 22 bf ff ff       	call   801019cf <ilock>
80105aad:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ab7:	66 83 f8 01          	cmp    $0x1,%ax
80105abb:	74 1a                	je     80105ad7 <sys_chdir+0x81>
    iunlockput(ip);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	ff 75 f0             	push   -0x10(%ebp)
80105ac3:	e8 38 c1 ff ff       	call   80101c00 <iunlockput>
80105ac8:	83 c4 10             	add    $0x10,%esp
    end_op();
80105acb:	e8 dd d5 ff ff       	call   801030ad <end_op>
    return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad5:	eb 33                	jmp    80105b0a <sys_chdir+0xb4>
  }
  iunlock(ip);
80105ad7:	83 ec 0c             	sub    $0xc,%esp
80105ada:	ff 75 f0             	push   -0x10(%ebp)
80105add:	e8 00 c0 ff ff       	call   80101ae2 <iunlock>
80105ae2:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae8:	8b 40 68             	mov    0x68(%eax),%eax
80105aeb:	83 ec 0c             	sub    $0xc,%esp
80105aee:	50                   	push   %eax
80105aef:	e8 3c c0 ff ff       	call   80101b30 <iput>
80105af4:	83 c4 10             	add    $0x10,%esp
  end_op();
80105af7:	e8 b1 d5 ff ff       	call   801030ad <end_op>
  curproc->cwd = ip;
80105afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b02:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b0a:	c9                   	leave  
80105b0b:	c3                   	ret    

80105b0c <sys_exec>:

int
sys_exec(void)
{
80105b0c:	55                   	push   %ebp
80105b0d:	89 e5                	mov    %esp,%ebp
80105b0f:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b15:	83 ec 08             	sub    $0x8,%esp
80105b18:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b1b:	50                   	push   %eax
80105b1c:	6a 00                	push   $0x0
80105b1e:	e8 9e f3 ff ff       	call   80104ec1 <argstr>
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 c0                	test   %eax,%eax
80105b28:	78 18                	js     80105b42 <sys_exec+0x36>
80105b2a:	83 ec 08             	sub    $0x8,%esp
80105b2d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105b33:	50                   	push   %eax
80105b34:	6a 01                	push   $0x1
80105b36:	e8 00 f3 ff ff       	call   80104e3b <argint>
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	85 c0                	test   %eax,%eax
80105b40:	79 0a                	jns    80105b4c <sys_exec+0x40>
    return -1;
80105b42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b47:	e9 c6 00 00 00       	jmp    80105c12 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105b4c:	83 ec 04             	sub    $0x4,%esp
80105b4f:	68 80 00 00 00       	push   $0x80
80105b54:	6a 00                	push   $0x0
80105b56:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105b5c:	50                   	push   %eax
80105b5d:	e8 c9 ef ff ff       	call   80104b2b <memset>
80105b62:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6f:	83 f8 1f             	cmp    $0x1f,%eax
80105b72:	76 0a                	jbe    80105b7e <sys_exec+0x72>
      return -1;
80105b74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b79:	e9 94 00 00 00       	jmp    80105c12 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b81:	c1 e0 02             	shl    $0x2,%eax
80105b84:	89 c2                	mov    %eax,%edx
80105b86:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105b8c:	01 c2                	add    %eax,%edx
80105b8e:	83 ec 08             	sub    $0x8,%esp
80105b91:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b97:	50                   	push   %eax
80105b98:	52                   	push   %edx
80105b99:	e8 17 f2 ff ff       	call   80104db5 <fetchint>
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	85 c0                	test   %eax,%eax
80105ba3:	79 07                	jns    80105bac <sys_exec+0xa0>
      return -1;
80105ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105baa:	eb 66                	jmp    80105c12 <sys_exec+0x106>
    if(uarg == 0){
80105bac:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105bb2:	85 c0                	test   %eax,%eax
80105bb4:	75 27                	jne    80105bdd <sys_exec+0xd1>
      argv[i] = 0;
80105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb9:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105bc0:	00 00 00 00 
      break;
80105bc4:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc8:	83 ec 08             	sub    $0x8,%esp
80105bcb:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105bd1:	52                   	push   %edx
80105bd2:	50                   	push   %eax
80105bd3:	e8 a8 af ff ff       	call   80100b80 <exec>
80105bd8:	83 c4 10             	add    $0x10,%esp
80105bdb:	eb 35                	jmp    80105c12 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105bdd:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be6:	c1 e0 02             	shl    $0x2,%eax
80105be9:	01 c2                	add    %eax,%edx
80105beb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105bf1:	83 ec 08             	sub    $0x8,%esp
80105bf4:	52                   	push   %edx
80105bf5:	50                   	push   %eax
80105bf6:	e8 e8 f1 ff ff       	call   80104de3 <fetchstr>
80105bfb:	83 c4 10             	add    $0x10,%esp
80105bfe:	85 c0                	test   %eax,%eax
80105c00:	79 07                	jns    80105c09 <sys_exec+0xfd>
      return -1;
80105c02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c07:	eb 09                	jmp    80105c12 <sys_exec+0x106>
  for(i=0;; i++){
80105c09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c0d:	e9 5a ff ff ff       	jmp    80105b6c <sys_exec+0x60>
}
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    

80105c14 <sys_pipe>:

int
sys_pipe(void)
{
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c1a:	83 ec 04             	sub    $0x4,%esp
80105c1d:	6a 08                	push   $0x8
80105c1f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c22:	50                   	push   %eax
80105c23:	6a 00                	push   $0x0
80105c25:	e8 3e f2 ff ff       	call   80104e68 <argptr>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	79 0a                	jns    80105c3b <sys_pipe+0x27>
    return -1;
80105c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c36:	e9 ae 00 00 00       	jmp    80105ce9 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105c3b:	83 ec 08             	sub    $0x8,%esp
80105c3e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c41:	50                   	push   %eax
80105c42:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c45:	50                   	push   %eax
80105c46:	e8 07 d9 ff ff       	call   80103552 <pipealloc>
80105c4b:	83 c4 10             	add    $0x10,%esp
80105c4e:	85 c0                	test   %eax,%eax
80105c50:	79 0a                	jns    80105c5c <sys_pipe+0x48>
    return -1;
80105c52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c57:	e9 8d 00 00 00       	jmp    80105ce9 <sys_pipe+0xd5>
  fd0 = -1;
80105c5c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c63:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c66:	83 ec 0c             	sub    $0xc,%esp
80105c69:	50                   	push   %eax
80105c6a:	e8 7b f3 ff ff       	call   80104fea <fdalloc>
80105c6f:	83 c4 10             	add    $0x10,%esp
80105c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c79:	78 18                	js     80105c93 <sys_pipe+0x7f>
80105c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c7e:	83 ec 0c             	sub    $0xc,%esp
80105c81:	50                   	push   %eax
80105c82:	e8 63 f3 ff ff       	call   80104fea <fdalloc>
80105c87:	83 c4 10             	add    $0x10,%esp
80105c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c91:	79 3e                	jns    80105cd1 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c97:	78 13                	js     80105cac <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105c99:	e8 77 dd ff ff       	call   80103a15 <myproc>
80105c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ca1:	83 c2 08             	add    $0x8,%edx
80105ca4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cab:	00 
    fileclose(rf);
80105cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105caf:	83 ec 0c             	sub    $0xc,%esp
80105cb2:	50                   	push   %eax
80105cb3:	e8 c8 b3 ff ff       	call   80101080 <fileclose>
80105cb8:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cbe:	83 ec 0c             	sub    $0xc,%esp
80105cc1:	50                   	push   %eax
80105cc2:	e8 b9 b3 ff ff       	call   80101080 <fileclose>
80105cc7:	83 c4 10             	add    $0x10,%esp
    return -1;
80105cca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ccf:	eb 18                	jmp    80105ce9 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd7:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cdc:	8d 50 04             	lea    0x4(%eax),%edx
80105cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce2:	89 02                	mov    %eax,(%edx)
  return 0;
80105ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ce9:	c9                   	leave  
80105cea:	c3                   	ret    

80105ceb <sys_fork>:
extern int ppid[];
extern int pspage[];

int
sys_fork(void)
{
80105ceb:	55                   	push   %ebp
80105cec:	89 e5                	mov    %esp,%ebp
80105cee:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105cf1:	e8 4a e0 ff ff       	call   80103d40 <fork>
}
80105cf6:	c9                   	leave  
80105cf7:	c3                   	ret    

80105cf8 <sys_exit>:

int
sys_exit(void)
{
80105cf8:	55                   	push   %ebp
80105cf9:	89 e5                	mov    %esp,%ebp
80105cfb:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cfe:	e8 1e e2 ff ff       	call   80103f21 <exit>
  return 0;  // not reached
80105d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d08:	c9                   	leave  
80105d09:	c3                   	ret    

80105d0a <sys_wait>:

int
sys_wait(void)
{
80105d0a:	55                   	push   %ebp
80105d0b:	89 e5                	mov    %esp,%ebp
80105d0d:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105d10:	e8 2c e3 ff ff       	call   80104041 <wait>
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    

80105d17 <sys_kill>:

int
sys_kill(void)
{
80105d17:	55                   	push   %ebp
80105d18:	89 e5                	mov    %esp,%ebp
80105d1a:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d1d:	83 ec 08             	sub    $0x8,%esp
80105d20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d23:	50                   	push   %eax
80105d24:	6a 00                	push   $0x0
80105d26:	e8 10 f1 ff ff       	call   80104e3b <argint>
80105d2b:	83 c4 10             	add    $0x10,%esp
80105d2e:	85 c0                	test   %eax,%eax
80105d30:	79 07                	jns    80105d39 <sys_kill+0x22>
    return -1;
80105d32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d37:	eb 0f                	jmp    80105d48 <sys_kill+0x31>
  return kill(pid);
80105d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3c:	83 ec 0c             	sub    $0xc,%esp
80105d3f:	50                   	push   %eax
80105d40:	e8 2b e7 ff ff       	call   80104470 <kill>
80105d45:	83 c4 10             	add    $0x10,%esp
}
80105d48:	c9                   	leave  
80105d49:	c3                   	ret    

80105d4a <sys_getpid>:

int
sys_getpid(void)
{
80105d4a:	55                   	push   %ebp
80105d4b:	89 e5                	mov    %esp,%ebp
80105d4d:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d50:	e8 c0 dc ff ff       	call   80103a15 <myproc>
80105d55:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d58:	c9                   	leave  
80105d59:	c3                   	ret    

80105d5a <sys_sbrk>:

int
sys_sbrk(void)
{
80105d5a:	55                   	push   %ebp
80105d5b:	89 e5                	mov    %esp,%ebp
80105d5d:	83 ec 28             	sub    $0x28,%esp
  int n;
  if (argint(0, &n) < 0)
80105d60:	83 ec 08             	sub    $0x8,%esp
80105d63:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d66:	50                   	push   %eax
80105d67:	6a 00                	push   $0x0
80105d69:	e8 cd f0 ff ff       	call   80104e3b <argint>
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	85 c0                	test   %eax,%eax
80105d73:	79 0a                	jns    80105d7f <sys_sbrk+0x25>
    return -1;
80105d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7a:	e9 3a 01 00 00       	jmp    80105eb9 <sys_sbrk+0x15f>

  struct proc *p = myproc();
80105d7f:	e8 91 dc ff ff       	call   80103a15 <myproc>
80105d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int addr = p->sz;
80105d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8a:	8b 00                	mov    (%eax),%eax
80105d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint oldsz = p->sz;
80105d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d92:	8b 00                	mov    (%eax),%eax
80105d94:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint newsz = oldsz + n;
80105d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d9a:	89 c2                	mov    %eax,%edx
80105d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d9f:	01 d0                	add    %edx,%eax
80105da1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if (n < 0 && newsz > oldsz) return -1;
80105da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105da7:	85 c0                	test   %eax,%eax
80105da9:	79 12                	jns    80105dbd <sys_sbrk+0x63>
80105dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dae:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80105db1:	76 0a                	jbe    80105dbd <sys_sbrk+0x63>
80105db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db8:	e9 fc 00 00 00       	jmp    80105eb9 <sys_sbrk+0x15f>
  if (n > 0 && newsz < oldsz) return -1;
80105dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	7e 12                	jle    80105dd6 <sys_sbrk+0x7c>
80105dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dc7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80105dca:	73 0a                	jae    80105dd6 <sys_sbrk+0x7c>
80105dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd1:	e9 e3 00 00 00       	jmp    80105eb9 <sys_sbrk+0x15f>
  if (newsz >= KERNBASE) return -1;
80105dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	79 0a                	jns    80105de7 <sys_sbrk+0x8d>
80105ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de2:	e9 d2 00 00 00       	jmp    80105eb9 <sys_sbrk+0x15f>

  int i;
  for (i = 0; i < NPROC; i++) {
80105de7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105dee:	eb 18                	jmp    80105e08 <sys_sbrk+0xae>
    if (ppid[i] == p->pid)
80105df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df3:	8b 14 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%edx
80105dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfd:	8b 40 10             	mov    0x10(%eax),%eax
80105e00:	39 c2                	cmp    %eax,%edx
80105e02:	74 0c                	je     80105e10 <sys_sbrk+0xb6>
  for (i = 0; i < NPROC; i++) {
80105e04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105e08:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80105e0c:	7e e2                	jle    80105df0 <sys_sbrk+0x96>
80105e0e:	eb 01                	jmp    80105e11 <sys_sbrk+0xb7>
      break;
80105e10:	90                   	nop
  }
  if (n > 0 && newsz >= KERNBASE - (pspage[i] + 2) * PGSIZE) return -1;
80105e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e14:	85 c0                	test   %eax,%eax
80105e16:	7e 25                	jle    80105e3d <sys_sbrk+0xe3>
80105e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1b:	8b 04 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%eax
80105e22:	83 c0 02             	add    $0x2,%eax
80105e25:	c1 e0 0c             	shl    $0xc,%eax
80105e28:	89 c2                	mov    %eax,%edx
80105e2a:	b8 00 00 00 80       	mov    $0x80000000,%eax
80105e2f:	29 d0                	sub    %edx,%eax
80105e31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80105e34:	72 07                	jb     80105e3d <sys_sbrk+0xe3>
80105e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3b:	eb 7c                	jmp    80105eb9 <sys_sbrk+0x15f>

  if (n == 0)
80105e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e40:	85 c0                	test   %eax,%eax
80105e42:	75 05                	jne    80105e49 <sys_sbrk+0xef>
    return addr;
80105e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e47:	eb 70                	jmp    80105eb9 <sys_sbrk+0x15f>

  if (n > 0) {
80105e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e4c:	85 c0                	test   %eax,%eax
80105e4e:	7e 18                	jle    80105e68 <sys_sbrk+0x10e>
    p->oldsz = p->sz;
80105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e53:	8b 10                	mov    (%eax),%edx
80105e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e58:	89 50 7c             	mov    %edx,0x7c(%eax)
    p->sz = newsz;
80105e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105e61:	89 10                	mov    %edx,(%eax)
    return addr;
80105e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e66:	eb 51                	jmp    80105eb9 <sys_sbrk+0x15f>
  }

  if ((newsz = deallocuvm(p->pgdir, oldsz, newsz)) == 0) {
80105e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6b:	8b 40 04             	mov    0x4(%eax),%eax
80105e6e:	83 ec 04             	sub    $0x4,%esp
80105e71:	ff 75 e4             	push   -0x1c(%ebp)
80105e74:	ff 75 e8             	push   -0x18(%ebp)
80105e77:	50                   	push   %eax
80105e78:	e8 67 1d 00 00       	call   80107be4 <deallocuvm>
80105e7d:	83 c4 10             	add    $0x10,%esp
80105e80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80105e87:	75 17                	jne    80105ea0 <sys_sbrk+0x146>
    cprintf("Deallocating pages failed!\n");
80105e89:	83 ec 0c             	sub    $0xc,%esp
80105e8c:	68 74 a9 10 80       	push   $0x8010a974
80105e91:	e8 5e a5 ff ff       	call   801003f4 <cprintf>
80105e96:	83 c4 10             	add    $0x10,%esp
    return -1;
80105e99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9e:	eb 19                	jmp    80105eb9 <sys_sbrk+0x15f>
  }

  p->sz = newsz;
80105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105ea6:	89 10                	mov    %edx,(%eax)
  switchuvm(p);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	ff 75 f0             	push   -0x10(%ebp)
80105eae:	e8 50 19 00 00       	call   80107803 <switchuvm>
80105eb3:	83 c4 10             	add    $0x10,%esp
  return addr;
80105eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105eb9:	c9                   	leave  
80105eba:	c3                   	ret    

80105ebb <sys_sleep>:

int
sys_sleep(void)
{
80105ebb:	55                   	push   %ebp
80105ebc:	89 e5                	mov    %esp,%ebp
80105ebe:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ec1:	83 ec 08             	sub    $0x8,%esp
80105ec4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ec7:	50                   	push   %eax
80105ec8:	6a 00                	push   $0x0
80105eca:	e8 6c ef ff ff       	call   80104e3b <argint>
80105ecf:	83 c4 10             	add    $0x10,%esp
80105ed2:	85 c0                	test   %eax,%eax
80105ed4:	79 07                	jns    80105edd <sys_sleep+0x22>
    return -1;
80105ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105edb:	eb 76                	jmp    80105f53 <sys_sleep+0x98>
  acquire(&tickslock);
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	68 60 6c 19 80       	push   $0x80196c60
80105ee5:	e8 cb e9 ff ff       	call   801048b5 <acquire>
80105eea:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105eed:	a1 94 6c 19 80       	mov    0x80196c94,%eax
80105ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105ef5:	eb 38                	jmp    80105f2f <sys_sleep+0x74>
    if(myproc()->killed){
80105ef7:	e8 19 db ff ff       	call   80103a15 <myproc>
80105efc:	8b 40 24             	mov    0x24(%eax),%eax
80105eff:	85 c0                	test   %eax,%eax
80105f01:	74 17                	je     80105f1a <sys_sleep+0x5f>
      release(&tickslock);
80105f03:	83 ec 0c             	sub    $0xc,%esp
80105f06:	68 60 6c 19 80       	push   $0x80196c60
80105f0b:	e8 13 ea ff ff       	call   80104923 <release>
80105f10:	83 c4 10             	add    $0x10,%esp
      return -1;
80105f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f18:	eb 39                	jmp    80105f53 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105f1a:	83 ec 08             	sub    $0x8,%esp
80105f1d:	68 60 6c 19 80       	push   $0x80196c60
80105f22:	68 94 6c 19 80       	push   $0x80196c94
80105f27:	e8 26 e4 ff ff       	call   80104352 <sleep>
80105f2c:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105f2f:	a1 94 6c 19 80       	mov    0x80196c94,%eax
80105f34:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105f37:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f3a:	39 d0                	cmp    %edx,%eax
80105f3c:	72 b9                	jb     80105ef7 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105f3e:	83 ec 0c             	sub    $0xc,%esp
80105f41:	68 60 6c 19 80       	push   $0x80196c60
80105f46:	e8 d8 e9 ff ff       	call   80104923 <release>
80105f4b:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f53:	c9                   	leave  
80105f54:	c3                   	ret    

80105f55 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f55:	55                   	push   %ebp
80105f56:	89 e5                	mov    %esp,%ebp
80105f58:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105f5b:	83 ec 0c             	sub    $0xc,%esp
80105f5e:	68 60 6c 19 80       	push   $0x80196c60
80105f63:	e8 4d e9 ff ff       	call   801048b5 <acquire>
80105f68:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105f6b:	a1 94 6c 19 80       	mov    0x80196c94,%eax
80105f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105f73:	83 ec 0c             	sub    $0xc,%esp
80105f76:	68 60 6c 19 80       	push   $0x80196c60
80105f7b:	e8 a3 e9 ff ff       	call   80104923 <release>
80105f80:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f86:	c9                   	leave  
80105f87:	c3                   	ret    

80105f88 <sys_printpt>:

int sys_printpt(void)
{
80105f88:	55                   	push   %ebp
80105f89:	89 e5                	mov    %esp,%ebp
80105f8b:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if(argint(0, &pid) < 0)
80105f8e:	83 ec 08             	sub    $0x8,%esp
80105f91:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f94:	50                   	push   %eax
80105f95:	6a 00                	push   $0x0
80105f97:	e8 9f ee ff ff       	call   80104e3b <argint>
80105f9c:	83 c4 10             	add    $0x10,%esp
80105f9f:	85 c0                	test   %eax,%eax
80105fa1:	79 07                	jns    80105faa <sys_printpt+0x22>
    return -1;
80105fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa8:	eb 0f                	jmp    80105fb9 <sys_printpt+0x31>
  return printpt(pid);
80105faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fad:	83 ec 0c             	sub    $0xc,%esp
80105fb0:	50                   	push   %eax
80105fb1:	e8 38 e6 ff ff       	call   801045ee <printpt>
80105fb6:	83 c4 10             	add    $0x10,%esp
80105fb9:	c9                   	leave  
80105fba:	c3                   	ret    

80105fbb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fbb:	1e                   	push   %ds
  pushl %es
80105fbc:	06                   	push   %es
  pushl %fs
80105fbd:	0f a0                	push   %fs
  pushl %gs
80105fbf:	0f a8                	push   %gs
  pushal
80105fc1:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fc2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fc6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fc8:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fca:	54                   	push   %esp
  call trap
80105fcb:	e8 d7 01 00 00       	call   801061a7 <trap>
  addl $4, %esp
80105fd0:	83 c4 04             	add    $0x4,%esp

80105fd3 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fd3:	61                   	popa   
  popl %gs
80105fd4:	0f a9                	pop    %gs
  popl %fs
80105fd6:	0f a1                	pop    %fs
  popl %es
80105fd8:	07                   	pop    %es
  popl %ds
80105fd9:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fda:	83 c4 08             	add    $0x8,%esp
  iret
80105fdd:	cf                   	iret   

80105fde <lidt>:
{
80105fde:	55                   	push   %ebp
80105fdf:	89 e5                	mov    %esp,%ebp
80105fe1:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fe7:	83 e8 01             	sub    $0x1,%eax
80105fea:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fee:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff8:	c1 e8 10             	shr    $0x10,%eax
80105ffb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106002:	0f 01 18             	lidtl  (%eax)
}
80106005:	90                   	nop
80106006:	c9                   	leave  
80106007:	c3                   	ret    

80106008 <rcr2>:

static inline uint
rcr2(void)
{
80106008:	55                   	push   %ebp
80106009:	89 e5                	mov    %esp,%ebp
8010600b:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010600e:	0f 20 d0             	mov    %cr2,%eax
80106011:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106014:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106017:	c9                   	leave  
80106018:	c3                   	ret    

80106019 <tvinit>:

extern int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
80106019:	55                   	push   %ebp
8010601a:	89 e5                	mov    %esp,%ebp
8010601c:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010601f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106026:	e9 c3 00 00 00       	jmp    801060ee <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010602b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010602e:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80106035:	89 c2                	mov    %eax,%edx
80106037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603a:	66 89 14 c5 60 64 19 	mov    %dx,-0x7fe69ba0(,%eax,8)
80106041:	80 
80106042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106045:	66 c7 04 c5 62 64 19 	movw   $0x8,-0x7fe69b9e(,%eax,8)
8010604c:	80 08 00 
8010604f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106052:	0f b6 14 c5 64 64 19 	movzbl -0x7fe69b9c(,%eax,8),%edx
80106059:	80 
8010605a:	83 e2 e0             	and    $0xffffffe0,%edx
8010605d:	88 14 c5 64 64 19 80 	mov    %dl,-0x7fe69b9c(,%eax,8)
80106064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106067:	0f b6 14 c5 64 64 19 	movzbl -0x7fe69b9c(,%eax,8),%edx
8010606e:	80 
8010606f:	83 e2 1f             	and    $0x1f,%edx
80106072:	88 14 c5 64 64 19 80 	mov    %dl,-0x7fe69b9c(,%eax,8)
80106079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607c:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
80106083:	80 
80106084:	83 e2 f0             	and    $0xfffffff0,%edx
80106087:	83 ca 0e             	or     $0xe,%edx
8010608a:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
80106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106094:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
8010609b:	80 
8010609c:	83 e2 ef             	and    $0xffffffef,%edx
8010609f:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
801060a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a9:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
801060b0:	80 
801060b1:	83 e2 9f             	and    $0xffffff9f,%edx
801060b4:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
801060bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060be:	0f b6 14 c5 65 64 19 	movzbl -0x7fe69b9b(,%eax,8),%edx
801060c5:	80 
801060c6:	83 ca 80             	or     $0xffffff80,%edx
801060c9:	88 14 c5 65 64 19 80 	mov    %dl,-0x7fe69b9b(,%eax,8)
801060d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d3:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
801060da:	c1 e8 10             	shr    $0x10,%eax
801060dd:	89 c2                	mov    %eax,%edx
801060df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e2:	66 89 14 c5 66 64 19 	mov    %dx,-0x7fe69b9a(,%eax,8)
801060e9:	80 
  for(i = 0; i < 256; i++)
801060ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801060ee:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801060f5:	0f 8e 30 ff ff ff    	jle    8010602b <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060fb:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
80106100:	66 a3 60 66 19 80    	mov    %ax,0x80196660
80106106:	66 c7 05 62 66 19 80 	movw   $0x8,0x80196662
8010610d:	08 00 
8010610f:	0f b6 05 64 66 19 80 	movzbl 0x80196664,%eax
80106116:	83 e0 e0             	and    $0xffffffe0,%eax
80106119:	a2 64 66 19 80       	mov    %al,0x80196664
8010611e:	0f b6 05 64 66 19 80 	movzbl 0x80196664,%eax
80106125:	83 e0 1f             	and    $0x1f,%eax
80106128:	a2 64 66 19 80       	mov    %al,0x80196664
8010612d:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
80106134:	83 c8 0f             	or     $0xf,%eax
80106137:	a2 65 66 19 80       	mov    %al,0x80196665
8010613c:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
80106143:	83 e0 ef             	and    $0xffffffef,%eax
80106146:	a2 65 66 19 80       	mov    %al,0x80196665
8010614b:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
80106152:	83 c8 60             	or     $0x60,%eax
80106155:	a2 65 66 19 80       	mov    %al,0x80196665
8010615a:	0f b6 05 65 66 19 80 	movzbl 0x80196665,%eax
80106161:	83 c8 80             	or     $0xffffff80,%eax
80106164:	a2 65 66 19 80       	mov    %al,0x80196665
80106169:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
8010616e:	c1 e8 10             	shr    $0x10,%eax
80106171:	66 a3 66 66 19 80    	mov    %ax,0x80196666

  initlock(&tickslock, "time");
80106177:	83 ec 08             	sub    $0x8,%esp
8010617a:	68 90 a9 10 80       	push   $0x8010a990
8010617f:	68 60 6c 19 80       	push   $0x80196c60
80106184:	e8 0a e7 ff ff       	call   80104893 <initlock>
80106189:	83 c4 10             	add    $0x10,%esp
}
8010618c:	90                   	nop
8010618d:	c9                   	leave  
8010618e:	c3                   	ret    

8010618f <idtinit>:

void
idtinit(void)
{
8010618f:	55                   	push   %ebp
80106190:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106192:	68 00 08 00 00       	push   $0x800
80106197:	68 60 64 19 80       	push   $0x80196460
8010619c:	e8 3d fe ff ff       	call   80105fde <lidt>
801061a1:	83 c4 08             	add    $0x8,%esp
}
801061a4:	90                   	nop
801061a5:	c9                   	leave  
801061a6:	c3                   	ret    

801061a7 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061a7:	55                   	push   %ebp
801061a8:	89 e5                	mov    %esp,%ebp
801061aa:	57                   	push   %edi
801061ab:	56                   	push   %esi
801061ac:	53                   	push   %ebx
801061ad:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801061b0:	8b 45 08             	mov    0x8(%ebp),%eax
801061b3:	8b 40 30             	mov    0x30(%eax),%eax
801061b6:	83 f8 40             	cmp    $0x40,%eax
801061b9:	75 3b                	jne    801061f6 <trap+0x4f>
    if(myproc()->killed)
801061bb:	e8 55 d8 ff ff       	call   80103a15 <myproc>
801061c0:	8b 40 24             	mov    0x24(%eax),%eax
801061c3:	85 c0                	test   %eax,%eax
801061c5:	74 05                	je     801061cc <trap+0x25>
      exit();
801061c7:	e8 55 dd ff ff       	call   80103f21 <exit>
    myproc()->tf = tf;
801061cc:	e8 44 d8 ff ff       	call   80103a15 <myproc>
801061d1:	8b 55 08             	mov    0x8(%ebp),%edx
801061d4:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801061d7:	e8 1c ed ff ff       	call   80104ef8 <syscall>
    if(myproc()->killed)
801061dc:	e8 34 d8 ff ff       	call   80103a15 <myproc>
801061e1:	8b 40 24             	mov    0x24(%eax),%eax
801061e4:	85 c0                	test   %eax,%eax
801061e6:	0f 84 d0 03 00 00    	je     801065bc <trap+0x415>
      exit();
801061ec:	e8 30 dd ff ff       	call   80103f21 <exit>
    return;
801061f1:	e9 c6 03 00 00       	jmp    801065bc <trap+0x415>
  }

  switch(tf->trapno){
801061f6:	8b 45 08             	mov    0x8(%ebp),%eax
801061f9:	8b 40 30             	mov    0x30(%eax),%eax
801061fc:	83 e8 0e             	sub    $0xe,%eax
801061ff:	83 f8 31             	cmp    $0x31,%eax
80106202:	0f 87 7c 02 00 00    	ja     80106484 <trap+0x2dd>
80106208:	8b 04 85 38 aa 10 80 	mov    -0x7fef55c8(,%eax,4),%eax
8010620f:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106211:	e8 6c d7 ff ff       	call   80103982 <cpuid>
80106216:	85 c0                	test   %eax,%eax
80106218:	75 3d                	jne    80106257 <trap+0xb0>
      acquire(&tickslock);
8010621a:	83 ec 0c             	sub    $0xc,%esp
8010621d:	68 60 6c 19 80       	push   $0x80196c60
80106222:	e8 8e e6 ff ff       	call   801048b5 <acquire>
80106227:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010622a:	a1 94 6c 19 80       	mov    0x80196c94,%eax
8010622f:	83 c0 01             	add    $0x1,%eax
80106232:	a3 94 6c 19 80       	mov    %eax,0x80196c94
      wakeup(&ticks);
80106237:	83 ec 0c             	sub    $0xc,%esp
8010623a:	68 94 6c 19 80       	push   $0x80196c94
8010623f:	e8 f5 e1 ff ff       	call   80104439 <wakeup>
80106244:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106247:	83 ec 0c             	sub    $0xc,%esp
8010624a:	68 60 6c 19 80       	push   $0x80196c60
8010624f:	e8 cf e6 ff ff       	call   80104923 <release>
80106254:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106257:	e8 a5 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
8010625c:	e9 db 02 00 00       	jmp    8010653c <trap+0x395>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106261:	e8 7b 41 00 00       	call   8010a3e1 <ideintr>
    lapiceoi();
80106266:	e8 96 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
8010626b:	e9 cc 02 00 00       	jmp    8010653c <trap+0x395>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106270:	e8 d1 c6 ff ff       	call   80102946 <kbdintr>
    lapiceoi();
80106275:	e8 87 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
8010627a:	e9 bd 02 00 00       	jmp    8010653c <trap+0x395>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010627f:	e8 0e 05 00 00       	call   80106792 <uartintr>
    lapiceoi();
80106284:	e8 78 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
80106289:	e9 ae 02 00 00       	jmp    8010653c <trap+0x395>
  case T_IRQ0 + 0xB:
    i8254_intr();
8010628e:	e8 01 2e 00 00       	call   80109094 <i8254_intr>
    lapiceoi();
80106293:	e8 69 c8 ff ff       	call   80102b01 <lapiceoi>
    break;
80106298:	e9 9f 02 00 00       	jmp    8010653c <trap+0x395>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010629d:	8b 45 08             	mov    0x8(%ebp),%eax
801062a0:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801062a3:	8b 45 08             	mov    0x8(%ebp),%eax
801062a6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062aa:	0f b7 d8             	movzwl %ax,%ebx
801062ad:	e8 d0 d6 ff ff       	call   80103982 <cpuid>
801062b2:	56                   	push   %esi
801062b3:	53                   	push   %ebx
801062b4:	50                   	push   %eax
801062b5:	68 98 a9 10 80       	push   $0x8010a998
801062ba:	e8 35 a1 ff ff       	call   801003f4 <cprintf>
801062bf:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062c2:	e8 3a c8 ff ff       	call   80102b01 <lapiceoi>
    break;
801062c7:	e9 70 02 00 00       	jmp    8010653c <trap+0x395>
case T_PGFLT: {
  uint va = PGROUNDDOWN(rcr2());
801062cc:	e8 37 fd ff ff       	call   80106008 <rcr2>
801062d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801062d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  struct proc *p = myproc();
801062d9:	e8 37 d7 ff ff       	call   80103a15 <myproc>
801062de:	89 45 dc             	mov    %eax,-0x24(%ebp)

  if (va >= KERNBASE) {
801062e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801062e4:	85 c0                	test   %eax,%eax
801062e6:	79 0f                	jns    801062f7 <trap+0x150>
    p->killed = 1;
801062e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062eb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    break;
801062f2:	e9 45 02 00 00       	jmp    8010653c <trap+0x395>
  }

  if (va >= p->oldsz && va < p->sz) {
801062f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062fa:	8b 40 7c             	mov    0x7c(%eax),%eax
801062fd:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80106300:	0f 82 88 00 00 00    	jb     8010638e <trap+0x1e7>
80106306:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106309:	8b 00                	mov    (%eax),%eax
8010630b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
8010630e:	73 7e                	jae    8010638e <trap+0x1e7>
    char *mem = kalloc();
80106310:	e8 70 c4 ff ff       	call   80102785 <kalloc>
80106315:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (!mem) {
80106318:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010631c:	75 0f                	jne    8010632d <trap+0x186>
      p->killed = 1;
8010631e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106321:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
80106328:	e9 0f 02 00 00       	jmp    8010653c <trap+0x395>
    }
    memset(mem, 0, PGSIZE);
8010632d:	83 ec 04             	sub    $0x4,%esp
80106330:	68 00 10 00 00       	push   $0x1000
80106335:	6a 00                	push   $0x0
80106337:	ff 75 d8             	push   -0x28(%ebp)
8010633a:	e8 ec e7 ff ff       	call   80104b2b <memset>
8010633f:	83 c4 10             	add    $0x10,%esp
    if (mappages(p->pgdir, (char*)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106342:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106345:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010634b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010634e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106351:	8b 40 04             	mov    0x4(%eax),%eax
80106354:	83 ec 0c             	sub    $0xc,%esp
80106357:	6a 06                	push   $0x6
80106359:	51                   	push   %ecx
8010635a:	68 00 10 00 00       	push   $0x1000
8010635f:	52                   	push   %edx
80106360:	50                   	push   %eax
80106361:	e8 f0 12 00 00       	call   80107656 <mappages>
80106366:	83 c4 20             	add    $0x20,%esp
80106369:	85 c0                	test   %eax,%eax
8010636b:	0f 89 ca 01 00 00    	jns    8010653b <trap+0x394>
      kfree(mem);
80106371:	83 ec 0c             	sub    $0xc,%esp
80106374:	ff 75 d8             	push   -0x28(%ebp)
80106377:	e8 6f c3 ff ff       	call   801026eb <kfree>
8010637c:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
8010637f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106382:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
80106389:	e9 ae 01 00 00       	jmp    8010653c <trap+0x395>
    }
    break;
  }

  int i;
  for (i = 0; i < NPROC; i++) {
8010638e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106395:	eb 18                	jmp    801063af <trap+0x208>
    if (ppid[i] == p->pid)
80106397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010639a:	8b 14 85 40 62 19 80 	mov    -0x7fe69dc0(,%eax,4),%edx
801063a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063a4:	8b 40 10             	mov    0x10(%eax),%eax
801063a7:	39 c2                	cmp    %eax,%edx
801063a9:	74 0c                	je     801063b7 <trap+0x210>
  for (i = 0; i < NPROC; i++) {
801063ab:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801063af:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
801063b3:	7e e2                	jle    80106397 <trap+0x1f0>
801063b5:	eb 01                	jmp    801063b8 <trap+0x211>
      break;
801063b7:	90                   	nop
  }
  if (va + PGSIZE < KERNBASE - pspage[i] * PGSIZE) {
801063b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801063bb:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
801063c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063c4:	8b 04 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%eax
801063cb:	c1 e0 0c             	shl    $0xc,%eax
801063ce:	89 c1                	mov    %eax,%ecx
801063d0:	b8 00 00 00 80       	mov    $0x80000000,%eax
801063d5:	29 c8                	sub    %ecx,%eax
801063d7:	39 c2                	cmp    %eax,%edx
801063d9:	0f 83 96 00 00 00    	jae    80106475 <trap+0x2ce>
    char *mem = kalloc();
801063df:	e8 a1 c3 ff ff       	call   80102785 <kalloc>
801063e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (!mem) {
801063e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801063eb:	75 0f                	jne    801063fc <trap+0x255>
      p->killed = 1;
801063ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801063f0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
801063f7:	e9 40 01 00 00       	jmp    8010653c <trap+0x395>
    }
    memset(mem, 0, PGSIZE);
801063fc:	83 ec 04             	sub    $0x4,%esp
801063ff:	68 00 10 00 00       	push   $0x1000
80106404:	6a 00                	push   $0x0
80106406:	ff 75 d4             	push   -0x2c(%ebp)
80106409:	e8 1d e7 ff ff       	call   80104b2b <memset>
8010640e:	83 c4 10             	add    $0x10,%esp
    if (mappages(p->pgdir, (char*)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106411:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106414:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010641a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010641d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106420:	8b 40 04             	mov    0x4(%eax),%eax
80106423:	83 ec 0c             	sub    $0xc,%esp
80106426:	6a 06                	push   $0x6
80106428:	51                   	push   %ecx
80106429:	68 00 10 00 00       	push   $0x1000
8010642e:	52                   	push   %edx
8010642f:	50                   	push   %eax
80106430:	e8 21 12 00 00       	call   80107656 <mappages>
80106435:	83 c4 20             	add    $0x20,%esp
80106438:	85 c0                	test   %eax,%eax
8010643a:	79 1d                	jns    80106459 <trap+0x2b2>
      kfree(mem);
8010643c:	83 ec 0c             	sub    $0xc,%esp
8010643f:	ff 75 d4             	push   -0x2c(%ebp)
80106442:	e8 a4 c2 ff ff       	call   801026eb <kfree>
80106447:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
8010644a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010644d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      break;
80106454:	e9 e3 00 00 00       	jmp    8010653c <trap+0x395>
    }
    pspage[i]++;
80106459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010645c:	8b 04 85 40 63 19 80 	mov    -0x7fe69cc0(,%eax,4),%eax
80106463:	8d 50 01             	lea    0x1(%eax),%edx
80106466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106469:	89 14 85 40 63 19 80 	mov    %edx,-0x7fe69cc0(,%eax,4)
    break;
80106470:	e9 c7 00 00 00       	jmp    8010653c <trap+0x395>
  }

  p->killed = 1;
80106475:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106478:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  break;
8010647f:	e9 b8 00 00 00       	jmp    8010653c <trap+0x395>
}
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106484:	e8 8c d5 ff ff       	call   80103a15 <myproc>
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 11                	je     8010649e <trap+0x2f7>
8010648d:	8b 45 08             	mov    0x8(%ebp),%eax
80106490:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106494:	0f b7 c0             	movzwl %ax,%eax
80106497:	83 e0 03             	and    $0x3,%eax
8010649a:	85 c0                	test   %eax,%eax
8010649c:	75 39                	jne    801064d7 <trap+0x330>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010649e:	e8 65 fb ff ff       	call   80106008 <rcr2>
801064a3:	89 c3                	mov    %eax,%ebx
801064a5:	8b 45 08             	mov    0x8(%ebp),%eax
801064a8:	8b 70 38             	mov    0x38(%eax),%esi
801064ab:	e8 d2 d4 ff ff       	call   80103982 <cpuid>
801064b0:	8b 55 08             	mov    0x8(%ebp),%edx
801064b3:	8b 52 30             	mov    0x30(%edx),%edx
801064b6:	83 ec 0c             	sub    $0xc,%esp
801064b9:	53                   	push   %ebx
801064ba:	56                   	push   %esi
801064bb:	50                   	push   %eax
801064bc:	52                   	push   %edx
801064bd:	68 bc a9 10 80       	push   $0x8010a9bc
801064c2:	e8 2d 9f ff ff       	call   801003f4 <cprintf>
801064c7:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801064ca:	83 ec 0c             	sub    $0xc,%esp
801064cd:	68 ee a9 10 80       	push   $0x8010a9ee
801064d2:	e8 d2 a0 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064d7:	e8 2c fb ff ff       	call   80106008 <rcr2>
801064dc:	89 c6                	mov    %eax,%esi
801064de:	8b 45 08             	mov    0x8(%ebp),%eax
801064e1:	8b 40 38             	mov    0x38(%eax),%eax
801064e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801064e7:	e8 96 d4 ff ff       	call   80103982 <cpuid>
801064ec:	89 c3                	mov    %eax,%ebx
801064ee:	8b 45 08             	mov    0x8(%ebp),%eax
801064f1:	8b 78 34             	mov    0x34(%eax),%edi
801064f4:	89 7d c0             	mov    %edi,-0x40(%ebp)
801064f7:	8b 45 08             	mov    0x8(%ebp),%eax
801064fa:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801064fd:	e8 13 d5 ff ff       	call   80103a15 <myproc>
80106502:	8d 48 6c             	lea    0x6c(%eax),%ecx
80106505:	89 4d bc             	mov    %ecx,-0x44(%ebp)
80106508:	e8 08 d5 ff ff       	call   80103a15 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010650d:	8b 40 10             	mov    0x10(%eax),%eax
80106510:	56                   	push   %esi
80106511:	ff 75 c4             	push   -0x3c(%ebp)
80106514:	53                   	push   %ebx
80106515:	ff 75 c0             	push   -0x40(%ebp)
80106518:	57                   	push   %edi
80106519:	ff 75 bc             	push   -0x44(%ebp)
8010651c:	50                   	push   %eax
8010651d:	68 f4 a9 10 80       	push   $0x8010a9f4
80106522:	e8 cd 9e ff ff       	call   801003f4 <cprintf>
80106527:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010652a:	e8 e6 d4 ff ff       	call   80103a15 <myproc>
8010652f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106536:	eb 04                	jmp    8010653c <trap+0x395>
    break;
80106538:	90                   	nop
80106539:	eb 01                	jmp    8010653c <trap+0x395>
    break;
8010653b:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010653c:	e8 d4 d4 ff ff       	call   80103a15 <myproc>
80106541:	85 c0                	test   %eax,%eax
80106543:	74 23                	je     80106568 <trap+0x3c1>
80106545:	e8 cb d4 ff ff       	call   80103a15 <myproc>
8010654a:	8b 40 24             	mov    0x24(%eax),%eax
8010654d:	85 c0                	test   %eax,%eax
8010654f:	74 17                	je     80106568 <trap+0x3c1>
80106551:	8b 45 08             	mov    0x8(%ebp),%eax
80106554:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106558:	0f b7 c0             	movzwl %ax,%eax
8010655b:	83 e0 03             	and    $0x3,%eax
8010655e:	83 f8 03             	cmp    $0x3,%eax
80106561:	75 05                	jne    80106568 <trap+0x3c1>
    exit();
80106563:	e8 b9 d9 ff ff       	call   80103f21 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106568:	e8 a8 d4 ff ff       	call   80103a15 <myproc>
8010656d:	85 c0                	test   %eax,%eax
8010656f:	74 1d                	je     8010658e <trap+0x3e7>
80106571:	e8 9f d4 ff ff       	call   80103a15 <myproc>
80106576:	8b 40 0c             	mov    0xc(%eax),%eax
80106579:	83 f8 04             	cmp    $0x4,%eax
8010657c:	75 10                	jne    8010658e <trap+0x3e7>
     tf->trapno == T_IRQ0+IRQ_TIMER){
8010657e:	8b 45 08             	mov    0x8(%ebp),%eax
80106581:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106584:	83 f8 20             	cmp    $0x20,%eax
80106587:	75 05                	jne    8010658e <trap+0x3e7>
    yield();
80106589:	e8 44 dd ff ff       	call   801042d2 <yield>
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010658e:	e8 82 d4 ff ff       	call   80103a15 <myproc>
80106593:	85 c0                	test   %eax,%eax
80106595:	74 26                	je     801065bd <trap+0x416>
80106597:	e8 79 d4 ff ff       	call   80103a15 <myproc>
8010659c:	8b 40 24             	mov    0x24(%eax),%eax
8010659f:	85 c0                	test   %eax,%eax
801065a1:	74 1a                	je     801065bd <trap+0x416>
801065a3:	8b 45 08             	mov    0x8(%ebp),%eax
801065a6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801065aa:	0f b7 c0             	movzwl %ax,%eax
801065ad:	83 e0 03             	and    $0x3,%eax
801065b0:	83 f8 03             	cmp    $0x3,%eax
801065b3:	75 08                	jne    801065bd <trap+0x416>
    exit();
801065b5:	e8 67 d9 ff ff       	call   80103f21 <exit>
801065ba:	eb 01                	jmp    801065bd <trap+0x416>
    return;
801065bc:	90                   	nop
}
801065bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c0:	5b                   	pop    %ebx
801065c1:	5e                   	pop    %esi
801065c2:	5f                   	pop    %edi
801065c3:	5d                   	pop    %ebp
801065c4:	c3                   	ret    

801065c5 <inb>:
{
801065c5:	55                   	push   %ebp
801065c6:	89 e5                	mov    %esp,%ebp
801065c8:	83 ec 14             	sub    $0x14,%esp
801065cb:	8b 45 08             	mov    0x8(%ebp),%eax
801065ce:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065d2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801065d6:	89 c2                	mov    %eax,%edx
801065d8:	ec                   	in     (%dx),%al
801065d9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801065dc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801065e0:	c9                   	leave  
801065e1:	c3                   	ret    

801065e2 <outb>:
{
801065e2:	55                   	push   %ebp
801065e3:	89 e5                	mov    %esp,%ebp
801065e5:	83 ec 08             	sub    $0x8,%esp
801065e8:	8b 45 08             	mov    0x8(%ebp),%eax
801065eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801065ee:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801065f2:	89 d0                	mov    %edx,%eax
801065f4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065f7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801065fb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801065ff:	ee                   	out    %al,(%dx)
}
80106600:	90                   	nop
80106601:	c9                   	leave  
80106602:	c3                   	ret    

80106603 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106603:	55                   	push   %ebp
80106604:	89 e5                	mov    %esp,%ebp
80106606:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106609:	6a 00                	push   $0x0
8010660b:	68 fa 03 00 00       	push   $0x3fa
80106610:	e8 cd ff ff ff       	call   801065e2 <outb>
80106615:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106618:	68 80 00 00 00       	push   $0x80
8010661d:	68 fb 03 00 00       	push   $0x3fb
80106622:	e8 bb ff ff ff       	call   801065e2 <outb>
80106627:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010662a:	6a 0c                	push   $0xc
8010662c:	68 f8 03 00 00       	push   $0x3f8
80106631:	e8 ac ff ff ff       	call   801065e2 <outb>
80106636:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106639:	6a 00                	push   $0x0
8010663b:	68 f9 03 00 00       	push   $0x3f9
80106640:	e8 9d ff ff ff       	call   801065e2 <outb>
80106645:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106648:	6a 03                	push   $0x3
8010664a:	68 fb 03 00 00       	push   $0x3fb
8010664f:	e8 8e ff ff ff       	call   801065e2 <outb>
80106654:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106657:	6a 00                	push   $0x0
80106659:	68 fc 03 00 00       	push   $0x3fc
8010665e:	e8 7f ff ff ff       	call   801065e2 <outb>
80106663:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106666:	6a 01                	push   $0x1
80106668:	68 f9 03 00 00       	push   $0x3f9
8010666d:	e8 70 ff ff ff       	call   801065e2 <outb>
80106672:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106675:	68 fd 03 00 00       	push   $0x3fd
8010667a:	e8 46 ff ff ff       	call   801065c5 <inb>
8010667f:	83 c4 04             	add    $0x4,%esp
80106682:	3c ff                	cmp    $0xff,%al
80106684:	74 61                	je     801066e7 <uartinit+0xe4>
    return;
  uart = 1;
80106686:	c7 05 98 6c 19 80 01 	movl   $0x1,0x80196c98
8010668d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106690:	68 fa 03 00 00       	push   $0x3fa
80106695:	e8 2b ff ff ff       	call   801065c5 <inb>
8010669a:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010669d:	68 f8 03 00 00       	push   $0x3f8
801066a2:	e8 1e ff ff ff       	call   801065c5 <inb>
801066a7:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801066aa:	83 ec 08             	sub    $0x8,%esp
801066ad:	6a 00                	push   $0x0
801066af:	6a 04                	push   $0x4
801066b1:	e8 5d bf ff ff       	call   80102613 <ioapicenable>
801066b6:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801066b9:	c7 45 f4 00 ab 10 80 	movl   $0x8010ab00,-0xc(%ebp)
801066c0:	eb 19                	jmp    801066db <uartinit+0xd8>
    uartputc(*p);
801066c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c5:	0f b6 00             	movzbl (%eax),%eax
801066c8:	0f be c0             	movsbl %al,%eax
801066cb:	83 ec 0c             	sub    $0xc,%esp
801066ce:	50                   	push   %eax
801066cf:	e8 16 00 00 00       	call   801066ea <uartputc>
801066d4:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066de:	0f b6 00             	movzbl (%eax),%eax
801066e1:	84 c0                	test   %al,%al
801066e3:	75 dd                	jne    801066c2 <uartinit+0xbf>
801066e5:	eb 01                	jmp    801066e8 <uartinit+0xe5>
    return;
801066e7:	90                   	nop
}
801066e8:	c9                   	leave  
801066e9:	c3                   	ret    

801066ea <uartputc>:

void
uartputc(int c)
{
801066ea:	55                   	push   %ebp
801066eb:	89 e5                	mov    %esp,%ebp
801066ed:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801066f0:	a1 98 6c 19 80       	mov    0x80196c98,%eax
801066f5:	85 c0                	test   %eax,%eax
801066f7:	74 53                	je     8010674c <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106700:	eb 11                	jmp    80106713 <uartputc+0x29>
    microdelay(10);
80106702:	83 ec 0c             	sub    $0xc,%esp
80106705:	6a 0a                	push   $0xa
80106707:	e8 10 c4 ff ff       	call   80102b1c <microdelay>
8010670c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010670f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106713:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106717:	7f 1a                	jg     80106733 <uartputc+0x49>
80106719:	83 ec 0c             	sub    $0xc,%esp
8010671c:	68 fd 03 00 00       	push   $0x3fd
80106721:	e8 9f fe ff ff       	call   801065c5 <inb>
80106726:	83 c4 10             	add    $0x10,%esp
80106729:	0f b6 c0             	movzbl %al,%eax
8010672c:	83 e0 20             	and    $0x20,%eax
8010672f:	85 c0                	test   %eax,%eax
80106731:	74 cf                	je     80106702 <uartputc+0x18>
  outb(COM1+0, c);
80106733:	8b 45 08             	mov    0x8(%ebp),%eax
80106736:	0f b6 c0             	movzbl %al,%eax
80106739:	83 ec 08             	sub    $0x8,%esp
8010673c:	50                   	push   %eax
8010673d:	68 f8 03 00 00       	push   $0x3f8
80106742:	e8 9b fe ff ff       	call   801065e2 <outb>
80106747:	83 c4 10             	add    $0x10,%esp
8010674a:	eb 01                	jmp    8010674d <uartputc+0x63>
    return;
8010674c:	90                   	nop
}
8010674d:	c9                   	leave  
8010674e:	c3                   	ret    

8010674f <uartgetc>:

static int
uartgetc(void)
{
8010674f:	55                   	push   %ebp
80106750:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106752:	a1 98 6c 19 80       	mov    0x80196c98,%eax
80106757:	85 c0                	test   %eax,%eax
80106759:	75 07                	jne    80106762 <uartgetc+0x13>
    return -1;
8010675b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106760:	eb 2e                	jmp    80106790 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106762:	68 fd 03 00 00       	push   $0x3fd
80106767:	e8 59 fe ff ff       	call   801065c5 <inb>
8010676c:	83 c4 04             	add    $0x4,%esp
8010676f:	0f b6 c0             	movzbl %al,%eax
80106772:	83 e0 01             	and    $0x1,%eax
80106775:	85 c0                	test   %eax,%eax
80106777:	75 07                	jne    80106780 <uartgetc+0x31>
    return -1;
80106779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677e:	eb 10                	jmp    80106790 <uartgetc+0x41>
  return inb(COM1+0);
80106780:	68 f8 03 00 00       	push   $0x3f8
80106785:	e8 3b fe ff ff       	call   801065c5 <inb>
8010678a:	83 c4 04             	add    $0x4,%esp
8010678d:	0f b6 c0             	movzbl %al,%eax
}
80106790:	c9                   	leave  
80106791:	c3                   	ret    

80106792 <uartintr>:

void
uartintr(void)
{
80106792:	55                   	push   %ebp
80106793:	89 e5                	mov    %esp,%ebp
80106795:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106798:	83 ec 0c             	sub    $0xc,%esp
8010679b:	68 4f 67 10 80       	push   $0x8010674f
801067a0:	e8 31 a0 ff ff       	call   801007d6 <consoleintr>
801067a5:	83 c4 10             	add    $0x10,%esp
}
801067a8:	90                   	nop
801067a9:	c9                   	leave  
801067aa:	c3                   	ret    

801067ab <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $0
801067ad:	6a 00                	push   $0x0
  jmp alltraps
801067af:	e9 07 f8 ff ff       	jmp    80105fbb <alltraps>

801067b4 <vector1>:
.globl vector1
vector1:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $1
801067b6:	6a 01                	push   $0x1
  jmp alltraps
801067b8:	e9 fe f7 ff ff       	jmp    80105fbb <alltraps>

801067bd <vector2>:
.globl vector2
vector2:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $2
801067bf:	6a 02                	push   $0x2
  jmp alltraps
801067c1:	e9 f5 f7 ff ff       	jmp    80105fbb <alltraps>

801067c6 <vector3>:
.globl vector3
vector3:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $3
801067c8:	6a 03                	push   $0x3
  jmp alltraps
801067ca:	e9 ec f7 ff ff       	jmp    80105fbb <alltraps>

801067cf <vector4>:
.globl vector4
vector4:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $4
801067d1:	6a 04                	push   $0x4
  jmp alltraps
801067d3:	e9 e3 f7 ff ff       	jmp    80105fbb <alltraps>

801067d8 <vector5>:
.globl vector5
vector5:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $5
801067da:	6a 05                	push   $0x5
  jmp alltraps
801067dc:	e9 da f7 ff ff       	jmp    80105fbb <alltraps>

801067e1 <vector6>:
.globl vector6
vector6:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $6
801067e3:	6a 06                	push   $0x6
  jmp alltraps
801067e5:	e9 d1 f7 ff ff       	jmp    80105fbb <alltraps>

801067ea <vector7>:
.globl vector7
vector7:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $7
801067ec:	6a 07                	push   $0x7
  jmp alltraps
801067ee:	e9 c8 f7 ff ff       	jmp    80105fbb <alltraps>

801067f3 <vector8>:
.globl vector8
vector8:
  pushl $8
801067f3:	6a 08                	push   $0x8
  jmp alltraps
801067f5:	e9 c1 f7 ff ff       	jmp    80105fbb <alltraps>

801067fa <vector9>:
.globl vector9
vector9:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $9
801067fc:	6a 09                	push   $0x9
  jmp alltraps
801067fe:	e9 b8 f7 ff ff       	jmp    80105fbb <alltraps>

80106803 <vector10>:
.globl vector10
vector10:
  pushl $10
80106803:	6a 0a                	push   $0xa
  jmp alltraps
80106805:	e9 b1 f7 ff ff       	jmp    80105fbb <alltraps>

8010680a <vector11>:
.globl vector11
vector11:
  pushl $11
8010680a:	6a 0b                	push   $0xb
  jmp alltraps
8010680c:	e9 aa f7 ff ff       	jmp    80105fbb <alltraps>

80106811 <vector12>:
.globl vector12
vector12:
  pushl $12
80106811:	6a 0c                	push   $0xc
  jmp alltraps
80106813:	e9 a3 f7 ff ff       	jmp    80105fbb <alltraps>

80106818 <vector13>:
.globl vector13
vector13:
  pushl $13
80106818:	6a 0d                	push   $0xd
  jmp alltraps
8010681a:	e9 9c f7 ff ff       	jmp    80105fbb <alltraps>

8010681f <vector14>:
.globl vector14
vector14:
  pushl $14
8010681f:	6a 0e                	push   $0xe
  jmp alltraps
80106821:	e9 95 f7 ff ff       	jmp    80105fbb <alltraps>

80106826 <vector15>:
.globl vector15
vector15:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $15
80106828:	6a 0f                	push   $0xf
  jmp alltraps
8010682a:	e9 8c f7 ff ff       	jmp    80105fbb <alltraps>

8010682f <vector16>:
.globl vector16
vector16:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $16
80106831:	6a 10                	push   $0x10
  jmp alltraps
80106833:	e9 83 f7 ff ff       	jmp    80105fbb <alltraps>

80106838 <vector17>:
.globl vector17
vector17:
  pushl $17
80106838:	6a 11                	push   $0x11
  jmp alltraps
8010683a:	e9 7c f7 ff ff       	jmp    80105fbb <alltraps>

8010683f <vector18>:
.globl vector18
vector18:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $18
80106841:	6a 12                	push   $0x12
  jmp alltraps
80106843:	e9 73 f7 ff ff       	jmp    80105fbb <alltraps>

80106848 <vector19>:
.globl vector19
vector19:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $19
8010684a:	6a 13                	push   $0x13
  jmp alltraps
8010684c:	e9 6a f7 ff ff       	jmp    80105fbb <alltraps>

80106851 <vector20>:
.globl vector20
vector20:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $20
80106853:	6a 14                	push   $0x14
  jmp alltraps
80106855:	e9 61 f7 ff ff       	jmp    80105fbb <alltraps>

8010685a <vector21>:
.globl vector21
vector21:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $21
8010685c:	6a 15                	push   $0x15
  jmp alltraps
8010685e:	e9 58 f7 ff ff       	jmp    80105fbb <alltraps>

80106863 <vector22>:
.globl vector22
vector22:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $22
80106865:	6a 16                	push   $0x16
  jmp alltraps
80106867:	e9 4f f7 ff ff       	jmp    80105fbb <alltraps>

8010686c <vector23>:
.globl vector23
vector23:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $23
8010686e:	6a 17                	push   $0x17
  jmp alltraps
80106870:	e9 46 f7 ff ff       	jmp    80105fbb <alltraps>

80106875 <vector24>:
.globl vector24
vector24:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $24
80106877:	6a 18                	push   $0x18
  jmp alltraps
80106879:	e9 3d f7 ff ff       	jmp    80105fbb <alltraps>

8010687e <vector25>:
.globl vector25
vector25:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $25
80106880:	6a 19                	push   $0x19
  jmp alltraps
80106882:	e9 34 f7 ff ff       	jmp    80105fbb <alltraps>

80106887 <vector26>:
.globl vector26
vector26:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $26
80106889:	6a 1a                	push   $0x1a
  jmp alltraps
8010688b:	e9 2b f7 ff ff       	jmp    80105fbb <alltraps>

80106890 <vector27>:
.globl vector27
vector27:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $27
80106892:	6a 1b                	push   $0x1b
  jmp alltraps
80106894:	e9 22 f7 ff ff       	jmp    80105fbb <alltraps>

80106899 <vector28>:
.globl vector28
vector28:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $28
8010689b:	6a 1c                	push   $0x1c
  jmp alltraps
8010689d:	e9 19 f7 ff ff       	jmp    80105fbb <alltraps>

801068a2 <vector29>:
.globl vector29
vector29:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $29
801068a4:	6a 1d                	push   $0x1d
  jmp alltraps
801068a6:	e9 10 f7 ff ff       	jmp    80105fbb <alltraps>

801068ab <vector30>:
.globl vector30
vector30:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $30
801068ad:	6a 1e                	push   $0x1e
  jmp alltraps
801068af:	e9 07 f7 ff ff       	jmp    80105fbb <alltraps>

801068b4 <vector31>:
.globl vector31
vector31:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $31
801068b6:	6a 1f                	push   $0x1f
  jmp alltraps
801068b8:	e9 fe f6 ff ff       	jmp    80105fbb <alltraps>

801068bd <vector32>:
.globl vector32
vector32:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $32
801068bf:	6a 20                	push   $0x20
  jmp alltraps
801068c1:	e9 f5 f6 ff ff       	jmp    80105fbb <alltraps>

801068c6 <vector33>:
.globl vector33
vector33:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $33
801068c8:	6a 21                	push   $0x21
  jmp alltraps
801068ca:	e9 ec f6 ff ff       	jmp    80105fbb <alltraps>

801068cf <vector34>:
.globl vector34
vector34:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $34
801068d1:	6a 22                	push   $0x22
  jmp alltraps
801068d3:	e9 e3 f6 ff ff       	jmp    80105fbb <alltraps>

801068d8 <vector35>:
.globl vector35
vector35:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $35
801068da:	6a 23                	push   $0x23
  jmp alltraps
801068dc:	e9 da f6 ff ff       	jmp    80105fbb <alltraps>

801068e1 <vector36>:
.globl vector36
vector36:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $36
801068e3:	6a 24                	push   $0x24
  jmp alltraps
801068e5:	e9 d1 f6 ff ff       	jmp    80105fbb <alltraps>

801068ea <vector37>:
.globl vector37
vector37:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $37
801068ec:	6a 25                	push   $0x25
  jmp alltraps
801068ee:	e9 c8 f6 ff ff       	jmp    80105fbb <alltraps>

801068f3 <vector38>:
.globl vector38
vector38:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $38
801068f5:	6a 26                	push   $0x26
  jmp alltraps
801068f7:	e9 bf f6 ff ff       	jmp    80105fbb <alltraps>

801068fc <vector39>:
.globl vector39
vector39:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $39
801068fe:	6a 27                	push   $0x27
  jmp alltraps
80106900:	e9 b6 f6 ff ff       	jmp    80105fbb <alltraps>

80106905 <vector40>:
.globl vector40
vector40:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $40
80106907:	6a 28                	push   $0x28
  jmp alltraps
80106909:	e9 ad f6 ff ff       	jmp    80105fbb <alltraps>

8010690e <vector41>:
.globl vector41
vector41:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $41
80106910:	6a 29                	push   $0x29
  jmp alltraps
80106912:	e9 a4 f6 ff ff       	jmp    80105fbb <alltraps>

80106917 <vector42>:
.globl vector42
vector42:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $42
80106919:	6a 2a                	push   $0x2a
  jmp alltraps
8010691b:	e9 9b f6 ff ff       	jmp    80105fbb <alltraps>

80106920 <vector43>:
.globl vector43
vector43:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $43
80106922:	6a 2b                	push   $0x2b
  jmp alltraps
80106924:	e9 92 f6 ff ff       	jmp    80105fbb <alltraps>

80106929 <vector44>:
.globl vector44
vector44:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $44
8010692b:	6a 2c                	push   $0x2c
  jmp alltraps
8010692d:	e9 89 f6 ff ff       	jmp    80105fbb <alltraps>

80106932 <vector45>:
.globl vector45
vector45:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $45
80106934:	6a 2d                	push   $0x2d
  jmp alltraps
80106936:	e9 80 f6 ff ff       	jmp    80105fbb <alltraps>

8010693b <vector46>:
.globl vector46
vector46:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $46
8010693d:	6a 2e                	push   $0x2e
  jmp alltraps
8010693f:	e9 77 f6 ff ff       	jmp    80105fbb <alltraps>

80106944 <vector47>:
.globl vector47
vector47:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $47
80106946:	6a 2f                	push   $0x2f
  jmp alltraps
80106948:	e9 6e f6 ff ff       	jmp    80105fbb <alltraps>

8010694d <vector48>:
.globl vector48
vector48:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $48
8010694f:	6a 30                	push   $0x30
  jmp alltraps
80106951:	e9 65 f6 ff ff       	jmp    80105fbb <alltraps>

80106956 <vector49>:
.globl vector49
vector49:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $49
80106958:	6a 31                	push   $0x31
  jmp alltraps
8010695a:	e9 5c f6 ff ff       	jmp    80105fbb <alltraps>

8010695f <vector50>:
.globl vector50
vector50:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $50
80106961:	6a 32                	push   $0x32
  jmp alltraps
80106963:	e9 53 f6 ff ff       	jmp    80105fbb <alltraps>

80106968 <vector51>:
.globl vector51
vector51:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $51
8010696a:	6a 33                	push   $0x33
  jmp alltraps
8010696c:	e9 4a f6 ff ff       	jmp    80105fbb <alltraps>

80106971 <vector52>:
.globl vector52
vector52:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $52
80106973:	6a 34                	push   $0x34
  jmp alltraps
80106975:	e9 41 f6 ff ff       	jmp    80105fbb <alltraps>

8010697a <vector53>:
.globl vector53
vector53:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $53
8010697c:	6a 35                	push   $0x35
  jmp alltraps
8010697e:	e9 38 f6 ff ff       	jmp    80105fbb <alltraps>

80106983 <vector54>:
.globl vector54
vector54:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $54
80106985:	6a 36                	push   $0x36
  jmp alltraps
80106987:	e9 2f f6 ff ff       	jmp    80105fbb <alltraps>

8010698c <vector55>:
.globl vector55
vector55:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $55
8010698e:	6a 37                	push   $0x37
  jmp alltraps
80106990:	e9 26 f6 ff ff       	jmp    80105fbb <alltraps>

80106995 <vector56>:
.globl vector56
vector56:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $56
80106997:	6a 38                	push   $0x38
  jmp alltraps
80106999:	e9 1d f6 ff ff       	jmp    80105fbb <alltraps>

8010699e <vector57>:
.globl vector57
vector57:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $57
801069a0:	6a 39                	push   $0x39
  jmp alltraps
801069a2:	e9 14 f6 ff ff       	jmp    80105fbb <alltraps>

801069a7 <vector58>:
.globl vector58
vector58:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $58
801069a9:	6a 3a                	push   $0x3a
  jmp alltraps
801069ab:	e9 0b f6 ff ff       	jmp    80105fbb <alltraps>

801069b0 <vector59>:
.globl vector59
vector59:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $59
801069b2:	6a 3b                	push   $0x3b
  jmp alltraps
801069b4:	e9 02 f6 ff ff       	jmp    80105fbb <alltraps>

801069b9 <vector60>:
.globl vector60
vector60:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $60
801069bb:	6a 3c                	push   $0x3c
  jmp alltraps
801069bd:	e9 f9 f5 ff ff       	jmp    80105fbb <alltraps>

801069c2 <vector61>:
.globl vector61
vector61:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $61
801069c4:	6a 3d                	push   $0x3d
  jmp alltraps
801069c6:	e9 f0 f5 ff ff       	jmp    80105fbb <alltraps>

801069cb <vector62>:
.globl vector62
vector62:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $62
801069cd:	6a 3e                	push   $0x3e
  jmp alltraps
801069cf:	e9 e7 f5 ff ff       	jmp    80105fbb <alltraps>

801069d4 <vector63>:
.globl vector63
vector63:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $63
801069d6:	6a 3f                	push   $0x3f
  jmp alltraps
801069d8:	e9 de f5 ff ff       	jmp    80105fbb <alltraps>

801069dd <vector64>:
.globl vector64
vector64:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $64
801069df:	6a 40                	push   $0x40
  jmp alltraps
801069e1:	e9 d5 f5 ff ff       	jmp    80105fbb <alltraps>

801069e6 <vector65>:
.globl vector65
vector65:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $65
801069e8:	6a 41                	push   $0x41
  jmp alltraps
801069ea:	e9 cc f5 ff ff       	jmp    80105fbb <alltraps>

801069ef <vector66>:
.globl vector66
vector66:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $66
801069f1:	6a 42                	push   $0x42
  jmp alltraps
801069f3:	e9 c3 f5 ff ff       	jmp    80105fbb <alltraps>

801069f8 <vector67>:
.globl vector67
vector67:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $67
801069fa:	6a 43                	push   $0x43
  jmp alltraps
801069fc:	e9 ba f5 ff ff       	jmp    80105fbb <alltraps>

80106a01 <vector68>:
.globl vector68
vector68:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $68
80106a03:	6a 44                	push   $0x44
  jmp alltraps
80106a05:	e9 b1 f5 ff ff       	jmp    80105fbb <alltraps>

80106a0a <vector69>:
.globl vector69
vector69:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $69
80106a0c:	6a 45                	push   $0x45
  jmp alltraps
80106a0e:	e9 a8 f5 ff ff       	jmp    80105fbb <alltraps>

80106a13 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $70
80106a15:	6a 46                	push   $0x46
  jmp alltraps
80106a17:	e9 9f f5 ff ff       	jmp    80105fbb <alltraps>

80106a1c <vector71>:
.globl vector71
vector71:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $71
80106a1e:	6a 47                	push   $0x47
  jmp alltraps
80106a20:	e9 96 f5 ff ff       	jmp    80105fbb <alltraps>

80106a25 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $72
80106a27:	6a 48                	push   $0x48
  jmp alltraps
80106a29:	e9 8d f5 ff ff       	jmp    80105fbb <alltraps>

80106a2e <vector73>:
.globl vector73
vector73:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $73
80106a30:	6a 49                	push   $0x49
  jmp alltraps
80106a32:	e9 84 f5 ff ff       	jmp    80105fbb <alltraps>

80106a37 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $74
80106a39:	6a 4a                	push   $0x4a
  jmp alltraps
80106a3b:	e9 7b f5 ff ff       	jmp    80105fbb <alltraps>

80106a40 <vector75>:
.globl vector75
vector75:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $75
80106a42:	6a 4b                	push   $0x4b
  jmp alltraps
80106a44:	e9 72 f5 ff ff       	jmp    80105fbb <alltraps>

80106a49 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $76
80106a4b:	6a 4c                	push   $0x4c
  jmp alltraps
80106a4d:	e9 69 f5 ff ff       	jmp    80105fbb <alltraps>

80106a52 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $77
80106a54:	6a 4d                	push   $0x4d
  jmp alltraps
80106a56:	e9 60 f5 ff ff       	jmp    80105fbb <alltraps>

80106a5b <vector78>:
.globl vector78
vector78:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $78
80106a5d:	6a 4e                	push   $0x4e
  jmp alltraps
80106a5f:	e9 57 f5 ff ff       	jmp    80105fbb <alltraps>

80106a64 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $79
80106a66:	6a 4f                	push   $0x4f
  jmp alltraps
80106a68:	e9 4e f5 ff ff       	jmp    80105fbb <alltraps>

80106a6d <vector80>:
.globl vector80
vector80:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $80
80106a6f:	6a 50                	push   $0x50
  jmp alltraps
80106a71:	e9 45 f5 ff ff       	jmp    80105fbb <alltraps>

80106a76 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $81
80106a78:	6a 51                	push   $0x51
  jmp alltraps
80106a7a:	e9 3c f5 ff ff       	jmp    80105fbb <alltraps>

80106a7f <vector82>:
.globl vector82
vector82:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $82
80106a81:	6a 52                	push   $0x52
  jmp alltraps
80106a83:	e9 33 f5 ff ff       	jmp    80105fbb <alltraps>

80106a88 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $83
80106a8a:	6a 53                	push   $0x53
  jmp alltraps
80106a8c:	e9 2a f5 ff ff       	jmp    80105fbb <alltraps>

80106a91 <vector84>:
.globl vector84
vector84:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $84
80106a93:	6a 54                	push   $0x54
  jmp alltraps
80106a95:	e9 21 f5 ff ff       	jmp    80105fbb <alltraps>

80106a9a <vector85>:
.globl vector85
vector85:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $85
80106a9c:	6a 55                	push   $0x55
  jmp alltraps
80106a9e:	e9 18 f5 ff ff       	jmp    80105fbb <alltraps>

80106aa3 <vector86>:
.globl vector86
vector86:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $86
80106aa5:	6a 56                	push   $0x56
  jmp alltraps
80106aa7:	e9 0f f5 ff ff       	jmp    80105fbb <alltraps>

80106aac <vector87>:
.globl vector87
vector87:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $87
80106aae:	6a 57                	push   $0x57
  jmp alltraps
80106ab0:	e9 06 f5 ff ff       	jmp    80105fbb <alltraps>

80106ab5 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $88
80106ab7:	6a 58                	push   $0x58
  jmp alltraps
80106ab9:	e9 fd f4 ff ff       	jmp    80105fbb <alltraps>

80106abe <vector89>:
.globl vector89
vector89:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $89
80106ac0:	6a 59                	push   $0x59
  jmp alltraps
80106ac2:	e9 f4 f4 ff ff       	jmp    80105fbb <alltraps>

80106ac7 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $90
80106ac9:	6a 5a                	push   $0x5a
  jmp alltraps
80106acb:	e9 eb f4 ff ff       	jmp    80105fbb <alltraps>

80106ad0 <vector91>:
.globl vector91
vector91:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $91
80106ad2:	6a 5b                	push   $0x5b
  jmp alltraps
80106ad4:	e9 e2 f4 ff ff       	jmp    80105fbb <alltraps>

80106ad9 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $92
80106adb:	6a 5c                	push   $0x5c
  jmp alltraps
80106add:	e9 d9 f4 ff ff       	jmp    80105fbb <alltraps>

80106ae2 <vector93>:
.globl vector93
vector93:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $93
80106ae4:	6a 5d                	push   $0x5d
  jmp alltraps
80106ae6:	e9 d0 f4 ff ff       	jmp    80105fbb <alltraps>

80106aeb <vector94>:
.globl vector94
vector94:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $94
80106aed:	6a 5e                	push   $0x5e
  jmp alltraps
80106aef:	e9 c7 f4 ff ff       	jmp    80105fbb <alltraps>

80106af4 <vector95>:
.globl vector95
vector95:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $95
80106af6:	6a 5f                	push   $0x5f
  jmp alltraps
80106af8:	e9 be f4 ff ff       	jmp    80105fbb <alltraps>

80106afd <vector96>:
.globl vector96
vector96:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $96
80106aff:	6a 60                	push   $0x60
  jmp alltraps
80106b01:	e9 b5 f4 ff ff       	jmp    80105fbb <alltraps>

80106b06 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $97
80106b08:	6a 61                	push   $0x61
  jmp alltraps
80106b0a:	e9 ac f4 ff ff       	jmp    80105fbb <alltraps>

80106b0f <vector98>:
.globl vector98
vector98:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $98
80106b11:	6a 62                	push   $0x62
  jmp alltraps
80106b13:	e9 a3 f4 ff ff       	jmp    80105fbb <alltraps>

80106b18 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $99
80106b1a:	6a 63                	push   $0x63
  jmp alltraps
80106b1c:	e9 9a f4 ff ff       	jmp    80105fbb <alltraps>

80106b21 <vector100>:
.globl vector100
vector100:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $100
80106b23:	6a 64                	push   $0x64
  jmp alltraps
80106b25:	e9 91 f4 ff ff       	jmp    80105fbb <alltraps>

80106b2a <vector101>:
.globl vector101
vector101:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $101
80106b2c:	6a 65                	push   $0x65
  jmp alltraps
80106b2e:	e9 88 f4 ff ff       	jmp    80105fbb <alltraps>

80106b33 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $102
80106b35:	6a 66                	push   $0x66
  jmp alltraps
80106b37:	e9 7f f4 ff ff       	jmp    80105fbb <alltraps>

80106b3c <vector103>:
.globl vector103
vector103:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $103
80106b3e:	6a 67                	push   $0x67
  jmp alltraps
80106b40:	e9 76 f4 ff ff       	jmp    80105fbb <alltraps>

80106b45 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $104
80106b47:	6a 68                	push   $0x68
  jmp alltraps
80106b49:	e9 6d f4 ff ff       	jmp    80105fbb <alltraps>

80106b4e <vector105>:
.globl vector105
vector105:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $105
80106b50:	6a 69                	push   $0x69
  jmp alltraps
80106b52:	e9 64 f4 ff ff       	jmp    80105fbb <alltraps>

80106b57 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $106
80106b59:	6a 6a                	push   $0x6a
  jmp alltraps
80106b5b:	e9 5b f4 ff ff       	jmp    80105fbb <alltraps>

80106b60 <vector107>:
.globl vector107
vector107:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $107
80106b62:	6a 6b                	push   $0x6b
  jmp alltraps
80106b64:	e9 52 f4 ff ff       	jmp    80105fbb <alltraps>

80106b69 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $108
80106b6b:	6a 6c                	push   $0x6c
  jmp alltraps
80106b6d:	e9 49 f4 ff ff       	jmp    80105fbb <alltraps>

80106b72 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $109
80106b74:	6a 6d                	push   $0x6d
  jmp alltraps
80106b76:	e9 40 f4 ff ff       	jmp    80105fbb <alltraps>

80106b7b <vector110>:
.globl vector110
vector110:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $110
80106b7d:	6a 6e                	push   $0x6e
  jmp alltraps
80106b7f:	e9 37 f4 ff ff       	jmp    80105fbb <alltraps>

80106b84 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $111
80106b86:	6a 6f                	push   $0x6f
  jmp alltraps
80106b88:	e9 2e f4 ff ff       	jmp    80105fbb <alltraps>

80106b8d <vector112>:
.globl vector112
vector112:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $112
80106b8f:	6a 70                	push   $0x70
  jmp alltraps
80106b91:	e9 25 f4 ff ff       	jmp    80105fbb <alltraps>

80106b96 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $113
80106b98:	6a 71                	push   $0x71
  jmp alltraps
80106b9a:	e9 1c f4 ff ff       	jmp    80105fbb <alltraps>

80106b9f <vector114>:
.globl vector114
vector114:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $114
80106ba1:	6a 72                	push   $0x72
  jmp alltraps
80106ba3:	e9 13 f4 ff ff       	jmp    80105fbb <alltraps>

80106ba8 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $115
80106baa:	6a 73                	push   $0x73
  jmp alltraps
80106bac:	e9 0a f4 ff ff       	jmp    80105fbb <alltraps>

80106bb1 <vector116>:
.globl vector116
vector116:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $116
80106bb3:	6a 74                	push   $0x74
  jmp alltraps
80106bb5:	e9 01 f4 ff ff       	jmp    80105fbb <alltraps>

80106bba <vector117>:
.globl vector117
vector117:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $117
80106bbc:	6a 75                	push   $0x75
  jmp alltraps
80106bbe:	e9 f8 f3 ff ff       	jmp    80105fbb <alltraps>

80106bc3 <vector118>:
.globl vector118
vector118:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $118
80106bc5:	6a 76                	push   $0x76
  jmp alltraps
80106bc7:	e9 ef f3 ff ff       	jmp    80105fbb <alltraps>

80106bcc <vector119>:
.globl vector119
vector119:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $119
80106bce:	6a 77                	push   $0x77
  jmp alltraps
80106bd0:	e9 e6 f3 ff ff       	jmp    80105fbb <alltraps>

80106bd5 <vector120>:
.globl vector120
vector120:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $120
80106bd7:	6a 78                	push   $0x78
  jmp alltraps
80106bd9:	e9 dd f3 ff ff       	jmp    80105fbb <alltraps>

80106bde <vector121>:
.globl vector121
vector121:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $121
80106be0:	6a 79                	push   $0x79
  jmp alltraps
80106be2:	e9 d4 f3 ff ff       	jmp    80105fbb <alltraps>

80106be7 <vector122>:
.globl vector122
vector122:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $122
80106be9:	6a 7a                	push   $0x7a
  jmp alltraps
80106beb:	e9 cb f3 ff ff       	jmp    80105fbb <alltraps>

80106bf0 <vector123>:
.globl vector123
vector123:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $123
80106bf2:	6a 7b                	push   $0x7b
  jmp alltraps
80106bf4:	e9 c2 f3 ff ff       	jmp    80105fbb <alltraps>

80106bf9 <vector124>:
.globl vector124
vector124:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $124
80106bfb:	6a 7c                	push   $0x7c
  jmp alltraps
80106bfd:	e9 b9 f3 ff ff       	jmp    80105fbb <alltraps>

80106c02 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $125
80106c04:	6a 7d                	push   $0x7d
  jmp alltraps
80106c06:	e9 b0 f3 ff ff       	jmp    80105fbb <alltraps>

80106c0b <vector126>:
.globl vector126
vector126:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $126
80106c0d:	6a 7e                	push   $0x7e
  jmp alltraps
80106c0f:	e9 a7 f3 ff ff       	jmp    80105fbb <alltraps>

80106c14 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $127
80106c16:	6a 7f                	push   $0x7f
  jmp alltraps
80106c18:	e9 9e f3 ff ff       	jmp    80105fbb <alltraps>

80106c1d <vector128>:
.globl vector128
vector128:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $128
80106c1f:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c24:	e9 92 f3 ff ff       	jmp    80105fbb <alltraps>

80106c29 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $129
80106c2b:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c30:	e9 86 f3 ff ff       	jmp    80105fbb <alltraps>

80106c35 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $130
80106c37:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c3c:	e9 7a f3 ff ff       	jmp    80105fbb <alltraps>

80106c41 <vector131>:
.globl vector131
vector131:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $131
80106c43:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c48:	e9 6e f3 ff ff       	jmp    80105fbb <alltraps>

80106c4d <vector132>:
.globl vector132
vector132:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $132
80106c4f:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c54:	e9 62 f3 ff ff       	jmp    80105fbb <alltraps>

80106c59 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $133
80106c5b:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c60:	e9 56 f3 ff ff       	jmp    80105fbb <alltraps>

80106c65 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $134
80106c67:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c6c:	e9 4a f3 ff ff       	jmp    80105fbb <alltraps>

80106c71 <vector135>:
.globl vector135
vector135:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $135
80106c73:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c78:	e9 3e f3 ff ff       	jmp    80105fbb <alltraps>

80106c7d <vector136>:
.globl vector136
vector136:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $136
80106c7f:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c84:	e9 32 f3 ff ff       	jmp    80105fbb <alltraps>

80106c89 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $137
80106c8b:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c90:	e9 26 f3 ff ff       	jmp    80105fbb <alltraps>

80106c95 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $138
80106c97:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c9c:	e9 1a f3 ff ff       	jmp    80105fbb <alltraps>

80106ca1 <vector139>:
.globl vector139
vector139:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $139
80106ca3:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ca8:	e9 0e f3 ff ff       	jmp    80105fbb <alltraps>

80106cad <vector140>:
.globl vector140
vector140:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $140
80106caf:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cb4:	e9 02 f3 ff ff       	jmp    80105fbb <alltraps>

80106cb9 <vector141>:
.globl vector141
vector141:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $141
80106cbb:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cc0:	e9 f6 f2 ff ff       	jmp    80105fbb <alltraps>

80106cc5 <vector142>:
.globl vector142
vector142:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $142
80106cc7:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ccc:	e9 ea f2 ff ff       	jmp    80105fbb <alltraps>

80106cd1 <vector143>:
.globl vector143
vector143:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $143
80106cd3:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106cd8:	e9 de f2 ff ff       	jmp    80105fbb <alltraps>

80106cdd <vector144>:
.globl vector144
vector144:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $144
80106cdf:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ce4:	e9 d2 f2 ff ff       	jmp    80105fbb <alltraps>

80106ce9 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $145
80106ceb:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cf0:	e9 c6 f2 ff ff       	jmp    80105fbb <alltraps>

80106cf5 <vector146>:
.globl vector146
vector146:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $146
80106cf7:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106cfc:	e9 ba f2 ff ff       	jmp    80105fbb <alltraps>

80106d01 <vector147>:
.globl vector147
vector147:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $147
80106d03:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d08:	e9 ae f2 ff ff       	jmp    80105fbb <alltraps>

80106d0d <vector148>:
.globl vector148
vector148:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $148
80106d0f:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d14:	e9 a2 f2 ff ff       	jmp    80105fbb <alltraps>

80106d19 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $149
80106d1b:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d20:	e9 96 f2 ff ff       	jmp    80105fbb <alltraps>

80106d25 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $150
80106d27:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d2c:	e9 8a f2 ff ff       	jmp    80105fbb <alltraps>

80106d31 <vector151>:
.globl vector151
vector151:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $151
80106d33:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d38:	e9 7e f2 ff ff       	jmp    80105fbb <alltraps>

80106d3d <vector152>:
.globl vector152
vector152:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $152
80106d3f:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d44:	e9 72 f2 ff ff       	jmp    80105fbb <alltraps>

80106d49 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $153
80106d4b:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d50:	e9 66 f2 ff ff       	jmp    80105fbb <alltraps>

80106d55 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $154
80106d57:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d5c:	e9 5a f2 ff ff       	jmp    80105fbb <alltraps>

80106d61 <vector155>:
.globl vector155
vector155:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $155
80106d63:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d68:	e9 4e f2 ff ff       	jmp    80105fbb <alltraps>

80106d6d <vector156>:
.globl vector156
vector156:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $156
80106d6f:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d74:	e9 42 f2 ff ff       	jmp    80105fbb <alltraps>

80106d79 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $157
80106d7b:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d80:	e9 36 f2 ff ff       	jmp    80105fbb <alltraps>

80106d85 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $158
80106d87:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d8c:	e9 2a f2 ff ff       	jmp    80105fbb <alltraps>

80106d91 <vector159>:
.globl vector159
vector159:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $159
80106d93:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d98:	e9 1e f2 ff ff       	jmp    80105fbb <alltraps>

80106d9d <vector160>:
.globl vector160
vector160:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $160
80106d9f:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106da4:	e9 12 f2 ff ff       	jmp    80105fbb <alltraps>

80106da9 <vector161>:
.globl vector161
vector161:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $161
80106dab:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106db0:	e9 06 f2 ff ff       	jmp    80105fbb <alltraps>

80106db5 <vector162>:
.globl vector162
vector162:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $162
80106db7:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106dbc:	e9 fa f1 ff ff       	jmp    80105fbb <alltraps>

80106dc1 <vector163>:
.globl vector163
vector163:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $163
80106dc3:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106dc8:	e9 ee f1 ff ff       	jmp    80105fbb <alltraps>

80106dcd <vector164>:
.globl vector164
vector164:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $164
80106dcf:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106dd4:	e9 e2 f1 ff ff       	jmp    80105fbb <alltraps>

80106dd9 <vector165>:
.globl vector165
vector165:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $165
80106ddb:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106de0:	e9 d6 f1 ff ff       	jmp    80105fbb <alltraps>

80106de5 <vector166>:
.globl vector166
vector166:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $166
80106de7:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106dec:	e9 ca f1 ff ff       	jmp    80105fbb <alltraps>

80106df1 <vector167>:
.globl vector167
vector167:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $167
80106df3:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106df8:	e9 be f1 ff ff       	jmp    80105fbb <alltraps>

80106dfd <vector168>:
.globl vector168
vector168:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $168
80106dff:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e04:	e9 b2 f1 ff ff       	jmp    80105fbb <alltraps>

80106e09 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $169
80106e0b:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e10:	e9 a6 f1 ff ff       	jmp    80105fbb <alltraps>

80106e15 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $170
80106e17:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e1c:	e9 9a f1 ff ff       	jmp    80105fbb <alltraps>

80106e21 <vector171>:
.globl vector171
vector171:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $171
80106e23:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e28:	e9 8e f1 ff ff       	jmp    80105fbb <alltraps>

80106e2d <vector172>:
.globl vector172
vector172:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $172
80106e2f:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e34:	e9 82 f1 ff ff       	jmp    80105fbb <alltraps>

80106e39 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $173
80106e3b:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e40:	e9 76 f1 ff ff       	jmp    80105fbb <alltraps>

80106e45 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $174
80106e47:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e4c:	e9 6a f1 ff ff       	jmp    80105fbb <alltraps>

80106e51 <vector175>:
.globl vector175
vector175:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $175
80106e53:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e58:	e9 5e f1 ff ff       	jmp    80105fbb <alltraps>

80106e5d <vector176>:
.globl vector176
vector176:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $176
80106e5f:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e64:	e9 52 f1 ff ff       	jmp    80105fbb <alltraps>

80106e69 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $177
80106e6b:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e70:	e9 46 f1 ff ff       	jmp    80105fbb <alltraps>

80106e75 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $178
80106e77:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e7c:	e9 3a f1 ff ff       	jmp    80105fbb <alltraps>

80106e81 <vector179>:
.globl vector179
vector179:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $179
80106e83:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e88:	e9 2e f1 ff ff       	jmp    80105fbb <alltraps>

80106e8d <vector180>:
.globl vector180
vector180:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $180
80106e8f:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e94:	e9 22 f1 ff ff       	jmp    80105fbb <alltraps>

80106e99 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $181
80106e9b:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ea0:	e9 16 f1 ff ff       	jmp    80105fbb <alltraps>

80106ea5 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $182
80106ea7:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106eac:	e9 0a f1 ff ff       	jmp    80105fbb <alltraps>

80106eb1 <vector183>:
.globl vector183
vector183:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $183
80106eb3:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106eb8:	e9 fe f0 ff ff       	jmp    80105fbb <alltraps>

80106ebd <vector184>:
.globl vector184
vector184:
  pushl $0
80106ebd:	6a 00                	push   $0x0
  pushl $184
80106ebf:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ec4:	e9 f2 f0 ff ff       	jmp    80105fbb <alltraps>

80106ec9 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $185
80106ecb:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106ed0:	e9 e6 f0 ff ff       	jmp    80105fbb <alltraps>

80106ed5 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $186
80106ed7:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106edc:	e9 da f0 ff ff       	jmp    80105fbb <alltraps>

80106ee1 <vector187>:
.globl vector187
vector187:
  pushl $0
80106ee1:	6a 00                	push   $0x0
  pushl $187
80106ee3:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ee8:	e9 ce f0 ff ff       	jmp    80105fbb <alltraps>

80106eed <vector188>:
.globl vector188
vector188:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $188
80106eef:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ef4:	e9 c2 f0 ff ff       	jmp    80105fbb <alltraps>

80106ef9 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $189
80106efb:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f00:	e9 b6 f0 ff ff       	jmp    80105fbb <alltraps>

80106f05 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $190
80106f07:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f0c:	e9 aa f0 ff ff       	jmp    80105fbb <alltraps>

80106f11 <vector191>:
.globl vector191
vector191:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $191
80106f13:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f18:	e9 9e f0 ff ff       	jmp    80105fbb <alltraps>

80106f1d <vector192>:
.globl vector192
vector192:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $192
80106f1f:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f24:	e9 92 f0 ff ff       	jmp    80105fbb <alltraps>

80106f29 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $193
80106f2b:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f30:	e9 86 f0 ff ff       	jmp    80105fbb <alltraps>

80106f35 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $194
80106f37:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f3c:	e9 7a f0 ff ff       	jmp    80105fbb <alltraps>

80106f41 <vector195>:
.globl vector195
vector195:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $195
80106f43:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f48:	e9 6e f0 ff ff       	jmp    80105fbb <alltraps>

80106f4d <vector196>:
.globl vector196
vector196:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $196
80106f4f:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f54:	e9 62 f0 ff ff       	jmp    80105fbb <alltraps>

80106f59 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $197
80106f5b:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f60:	e9 56 f0 ff ff       	jmp    80105fbb <alltraps>

80106f65 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $198
80106f67:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f6c:	e9 4a f0 ff ff       	jmp    80105fbb <alltraps>

80106f71 <vector199>:
.globl vector199
vector199:
  pushl $0
80106f71:	6a 00                	push   $0x0
  pushl $199
80106f73:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f78:	e9 3e f0 ff ff       	jmp    80105fbb <alltraps>

80106f7d <vector200>:
.globl vector200
vector200:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $200
80106f7f:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f84:	e9 32 f0 ff ff       	jmp    80105fbb <alltraps>

80106f89 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $201
80106f8b:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f90:	e9 26 f0 ff ff       	jmp    80105fbb <alltraps>

80106f95 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f95:	6a 00                	push   $0x0
  pushl $202
80106f97:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f9c:	e9 1a f0 ff ff       	jmp    80105fbb <alltraps>

80106fa1 <vector203>:
.globl vector203
vector203:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $203
80106fa3:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fa8:	e9 0e f0 ff ff       	jmp    80105fbb <alltraps>

80106fad <vector204>:
.globl vector204
vector204:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $204
80106faf:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106fb4:	e9 02 f0 ff ff       	jmp    80105fbb <alltraps>

80106fb9 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fb9:	6a 00                	push   $0x0
  pushl $205
80106fbb:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fc0:	e9 f6 ef ff ff       	jmp    80105fbb <alltraps>

80106fc5 <vector206>:
.globl vector206
vector206:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $206
80106fc7:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106fcc:	e9 ea ef ff ff       	jmp    80105fbb <alltraps>

80106fd1 <vector207>:
.globl vector207
vector207:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $207
80106fd3:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fd8:	e9 de ef ff ff       	jmp    80105fbb <alltraps>

80106fdd <vector208>:
.globl vector208
vector208:
  pushl $0
80106fdd:	6a 00                	push   $0x0
  pushl $208
80106fdf:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fe4:	e9 d2 ef ff ff       	jmp    80105fbb <alltraps>

80106fe9 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $209
80106feb:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106ff0:	e9 c6 ef ff ff       	jmp    80105fbb <alltraps>

80106ff5 <vector210>:
.globl vector210
vector210:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $210
80106ff7:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ffc:	e9 ba ef ff ff       	jmp    80105fbb <alltraps>

80107001 <vector211>:
.globl vector211
vector211:
  pushl $0
80107001:	6a 00                	push   $0x0
  pushl $211
80107003:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107008:	e9 ae ef ff ff       	jmp    80105fbb <alltraps>

8010700d <vector212>:
.globl vector212
vector212:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $212
8010700f:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107014:	e9 a2 ef ff ff       	jmp    80105fbb <alltraps>

80107019 <vector213>:
.globl vector213
vector213:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $213
8010701b:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107020:	e9 96 ef ff ff       	jmp    80105fbb <alltraps>

80107025 <vector214>:
.globl vector214
vector214:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $214
80107027:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010702c:	e9 8a ef ff ff       	jmp    80105fbb <alltraps>

80107031 <vector215>:
.globl vector215
vector215:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $215
80107033:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107038:	e9 7e ef ff ff       	jmp    80105fbb <alltraps>

8010703d <vector216>:
.globl vector216
vector216:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $216
8010703f:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107044:	e9 72 ef ff ff       	jmp    80105fbb <alltraps>

80107049 <vector217>:
.globl vector217
vector217:
  pushl $0
80107049:	6a 00                	push   $0x0
  pushl $217
8010704b:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107050:	e9 66 ef ff ff       	jmp    80105fbb <alltraps>

80107055 <vector218>:
.globl vector218
vector218:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $218
80107057:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010705c:	e9 5a ef ff ff       	jmp    80105fbb <alltraps>

80107061 <vector219>:
.globl vector219
vector219:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $219
80107063:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107068:	e9 4e ef ff ff       	jmp    80105fbb <alltraps>

8010706d <vector220>:
.globl vector220
vector220:
  pushl $0
8010706d:	6a 00                	push   $0x0
  pushl $220
8010706f:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107074:	e9 42 ef ff ff       	jmp    80105fbb <alltraps>

80107079 <vector221>:
.globl vector221
vector221:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $221
8010707b:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107080:	e9 36 ef ff ff       	jmp    80105fbb <alltraps>

80107085 <vector222>:
.globl vector222
vector222:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $222
80107087:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010708c:	e9 2a ef ff ff       	jmp    80105fbb <alltraps>

80107091 <vector223>:
.globl vector223
vector223:
  pushl $0
80107091:	6a 00                	push   $0x0
  pushl $223
80107093:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107098:	e9 1e ef ff ff       	jmp    80105fbb <alltraps>

8010709d <vector224>:
.globl vector224
vector224:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $224
8010709f:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070a4:	e9 12 ef ff ff       	jmp    80105fbb <alltraps>

801070a9 <vector225>:
.globl vector225
vector225:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $225
801070ab:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070b0:	e9 06 ef ff ff       	jmp    80105fbb <alltraps>

801070b5 <vector226>:
.globl vector226
vector226:
  pushl $0
801070b5:	6a 00                	push   $0x0
  pushl $226
801070b7:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070bc:	e9 fa ee ff ff       	jmp    80105fbb <alltraps>

801070c1 <vector227>:
.globl vector227
vector227:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $227
801070c3:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070c8:	e9 ee ee ff ff       	jmp    80105fbb <alltraps>

801070cd <vector228>:
.globl vector228
vector228:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $228
801070cf:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070d4:	e9 e2 ee ff ff       	jmp    80105fbb <alltraps>

801070d9 <vector229>:
.globl vector229
vector229:
  pushl $0
801070d9:	6a 00                	push   $0x0
  pushl $229
801070db:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070e0:	e9 d6 ee ff ff       	jmp    80105fbb <alltraps>

801070e5 <vector230>:
.globl vector230
vector230:
  pushl $0
801070e5:	6a 00                	push   $0x0
  pushl $230
801070e7:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070ec:	e9 ca ee ff ff       	jmp    80105fbb <alltraps>

801070f1 <vector231>:
.globl vector231
vector231:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $231
801070f3:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070f8:	e9 be ee ff ff       	jmp    80105fbb <alltraps>

801070fd <vector232>:
.globl vector232
vector232:
  pushl $0
801070fd:	6a 00                	push   $0x0
  pushl $232
801070ff:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107104:	e9 b2 ee ff ff       	jmp    80105fbb <alltraps>

80107109 <vector233>:
.globl vector233
vector233:
  pushl $0
80107109:	6a 00                	push   $0x0
  pushl $233
8010710b:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107110:	e9 a6 ee ff ff       	jmp    80105fbb <alltraps>

80107115 <vector234>:
.globl vector234
vector234:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $234
80107117:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010711c:	e9 9a ee ff ff       	jmp    80105fbb <alltraps>

80107121 <vector235>:
.globl vector235
vector235:
  pushl $0
80107121:	6a 00                	push   $0x0
  pushl $235
80107123:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107128:	e9 8e ee ff ff       	jmp    80105fbb <alltraps>

8010712d <vector236>:
.globl vector236
vector236:
  pushl $0
8010712d:	6a 00                	push   $0x0
  pushl $236
8010712f:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107134:	e9 82 ee ff ff       	jmp    80105fbb <alltraps>

80107139 <vector237>:
.globl vector237
vector237:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $237
8010713b:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107140:	e9 76 ee ff ff       	jmp    80105fbb <alltraps>

80107145 <vector238>:
.globl vector238
vector238:
  pushl $0
80107145:	6a 00                	push   $0x0
  pushl $238
80107147:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010714c:	e9 6a ee ff ff       	jmp    80105fbb <alltraps>

80107151 <vector239>:
.globl vector239
vector239:
  pushl $0
80107151:	6a 00                	push   $0x0
  pushl $239
80107153:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107158:	e9 5e ee ff ff       	jmp    80105fbb <alltraps>

8010715d <vector240>:
.globl vector240
vector240:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $240
8010715f:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107164:	e9 52 ee ff ff       	jmp    80105fbb <alltraps>

80107169 <vector241>:
.globl vector241
vector241:
  pushl $0
80107169:	6a 00                	push   $0x0
  pushl $241
8010716b:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107170:	e9 46 ee ff ff       	jmp    80105fbb <alltraps>

80107175 <vector242>:
.globl vector242
vector242:
  pushl $0
80107175:	6a 00                	push   $0x0
  pushl $242
80107177:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010717c:	e9 3a ee ff ff       	jmp    80105fbb <alltraps>

80107181 <vector243>:
.globl vector243
vector243:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $243
80107183:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107188:	e9 2e ee ff ff       	jmp    80105fbb <alltraps>

8010718d <vector244>:
.globl vector244
vector244:
  pushl $0
8010718d:	6a 00                	push   $0x0
  pushl $244
8010718f:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107194:	e9 22 ee ff ff       	jmp    80105fbb <alltraps>

80107199 <vector245>:
.globl vector245
vector245:
  pushl $0
80107199:	6a 00                	push   $0x0
  pushl $245
8010719b:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071a0:	e9 16 ee ff ff       	jmp    80105fbb <alltraps>

801071a5 <vector246>:
.globl vector246
vector246:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $246
801071a7:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071ac:	e9 0a ee ff ff       	jmp    80105fbb <alltraps>

801071b1 <vector247>:
.globl vector247
vector247:
  pushl $0
801071b1:	6a 00                	push   $0x0
  pushl $247
801071b3:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071b8:	e9 fe ed ff ff       	jmp    80105fbb <alltraps>

801071bd <vector248>:
.globl vector248
vector248:
  pushl $0
801071bd:	6a 00                	push   $0x0
  pushl $248
801071bf:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071c4:	e9 f2 ed ff ff       	jmp    80105fbb <alltraps>

801071c9 <vector249>:
.globl vector249
vector249:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $249
801071cb:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071d0:	e9 e6 ed ff ff       	jmp    80105fbb <alltraps>

801071d5 <vector250>:
.globl vector250
vector250:
  pushl $0
801071d5:	6a 00                	push   $0x0
  pushl $250
801071d7:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071dc:	e9 da ed ff ff       	jmp    80105fbb <alltraps>

801071e1 <vector251>:
.globl vector251
vector251:
  pushl $0
801071e1:	6a 00                	push   $0x0
  pushl $251
801071e3:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071e8:	e9 ce ed ff ff       	jmp    80105fbb <alltraps>

801071ed <vector252>:
.globl vector252
vector252:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $252
801071ef:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071f4:	e9 c2 ed ff ff       	jmp    80105fbb <alltraps>

801071f9 <vector253>:
.globl vector253
vector253:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $253
801071fb:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107200:	e9 b6 ed ff ff       	jmp    80105fbb <alltraps>

80107205 <vector254>:
.globl vector254
vector254:
  pushl $0
80107205:	6a 00                	push   $0x0
  pushl $254
80107207:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010720c:	e9 aa ed ff ff       	jmp    80105fbb <alltraps>

80107211 <vector255>:
.globl vector255
vector255:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $255
80107213:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107218:	e9 9e ed ff ff       	jmp    80105fbb <alltraps>

8010721d <lgdt>:
{
8010721d:	55                   	push   %ebp
8010721e:	89 e5                	mov    %esp,%ebp
80107220:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107223:	8b 45 0c             	mov    0xc(%ebp),%eax
80107226:	83 e8 01             	sub    $0x1,%eax
80107229:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010722d:	8b 45 08             	mov    0x8(%ebp),%eax
80107230:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107234:	8b 45 08             	mov    0x8(%ebp),%eax
80107237:	c1 e8 10             	shr    $0x10,%eax
8010723a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010723e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107241:	0f 01 10             	lgdtl  (%eax)
}
80107244:	90                   	nop
80107245:	c9                   	leave  
80107246:	c3                   	ret    

80107247 <ltr>:
{
80107247:	55                   	push   %ebp
80107248:	89 e5                	mov    %esp,%ebp
8010724a:	83 ec 04             	sub    $0x4,%esp
8010724d:	8b 45 08             	mov    0x8(%ebp),%eax
80107250:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107254:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107258:	0f 00 d8             	ltr    %ax
}
8010725b:	90                   	nop
8010725c:	c9                   	leave  
8010725d:	c3                   	ret    

8010725e <lcr3>:

static inline void
lcr3(uint val)
{
8010725e:	55                   	push   %ebp
8010725f:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107261:	8b 45 08             	mov    0x8(%ebp),%eax
80107264:	0f 22 d8             	mov    %eax,%cr3
}
80107267:	90                   	nop
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    

8010726a <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010726a:	55                   	push   %ebp
8010726b:	89 e5                	mov    %esp,%ebp
8010726d:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107270:	e8 0d c7 ff ff       	call   80103982 <cpuid>
80107275:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010727b:	05 a0 6c 19 80       	add    $0x80196ca0,%eax
80107280:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107286:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010728c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010728f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107298:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010729c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072a3:	83 e2 f0             	and    $0xfffffff0,%edx
801072a6:	83 ca 0a             	or     $0xa,%edx
801072a9:	88 50 7d             	mov    %dl,0x7d(%eax)
801072ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072af:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072b3:	83 ca 10             	or     $0x10,%edx
801072b6:	88 50 7d             	mov    %dl,0x7d(%eax)
801072b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072bc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072c0:	83 e2 9f             	and    $0xffffff9f,%edx
801072c3:	88 50 7d             	mov    %dl,0x7d(%eax)
801072c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801072cd:	83 ca 80             	or     $0xffffff80,%edx
801072d0:	88 50 7d             	mov    %dl,0x7d(%eax)
801072d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072da:	83 ca 0f             	or     $0xf,%edx
801072dd:	88 50 7e             	mov    %dl,0x7e(%eax)
801072e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072e7:	83 e2 ef             	and    $0xffffffef,%edx
801072ea:	88 50 7e             	mov    %dl,0x7e(%eax)
801072ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801072f4:	83 e2 df             	and    $0xffffffdf,%edx
801072f7:	88 50 7e             	mov    %dl,0x7e(%eax)
801072fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072fd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107301:	83 ca 40             	or     $0x40,%edx
80107304:	88 50 7e             	mov    %dl,0x7e(%eax)
80107307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010730e:	83 ca 80             	or     $0xffffff80,%edx
80107311:	88 50 7e             	mov    %dl,0x7e(%eax)
80107314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107317:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010731b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731e:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107325:	ff ff 
80107327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107331:	00 00 
80107333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107336:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010733d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107340:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107347:	83 e2 f0             	and    $0xfffffff0,%edx
8010734a:	83 ca 02             	or     $0x2,%edx
8010734d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107356:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010735d:	83 ca 10             	or     $0x10,%edx
80107360:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107369:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107370:	83 e2 9f             	and    $0xffffff9f,%edx
80107373:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107383:	83 ca 80             	or     $0xffffff80,%edx
80107386:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010738c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107396:	83 ca 0f             	or     $0xf,%edx
80107399:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010739f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073a9:	83 e2 ef             	and    $0xffffffef,%edx
801073ac:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073bc:	83 e2 df             	and    $0xffffffdf,%edx
801073bf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073cf:	83 ca 40             	or     $0x40,%edx
801073d2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073db:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801073e2:	83 ca 80             	or     $0xffffff80,%edx
801073e5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ee:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f8:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801073ff:	ff ff 
80107401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107404:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
8010740b:	00 00 
8010740d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107410:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107421:	83 e2 f0             	and    $0xfffffff0,%edx
80107424:	83 ca 0a             	or     $0xa,%edx
80107427:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010742d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107430:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107437:	83 ca 10             	or     $0x10,%edx
8010743a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107443:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010744a:	83 ca 60             	or     $0x60,%edx
8010744d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107456:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010745d:	83 ca 80             	or     $0xffffff80,%edx
80107460:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107469:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107470:	83 ca 0f             	or     $0xf,%edx
80107473:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107479:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107483:	83 e2 ef             	and    $0xffffffef,%edx
80107486:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010748c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107496:	83 e2 df             	and    $0xffffffdf,%edx
80107499:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010749f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074a9:	83 ca 40             	or     $0x40,%edx
801074ac:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801074bc:	83 ca 80             	or     $0xffffff80,%edx
801074bf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801074c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c8:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d2:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801074d9:	ff ff 
801074db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074de:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801074e5:	00 00 
801074e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ea:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801074f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801074fb:	83 e2 f0             	and    $0xfffffff0,%edx
801074fe:	83 ca 02             	or     $0x2,%edx
80107501:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107511:	83 ca 10             	or     $0x10,%edx
80107514:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010751a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107524:	83 ca 60             	or     $0x60,%edx
80107527:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010752d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107530:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107537:	83 ca 80             	or     $0xffffff80,%edx
8010753a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107543:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010754a:	83 ca 0f             	or     $0xf,%edx
8010754d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107556:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010755d:	83 e2 ef             	and    $0xffffffef,%edx
80107560:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107569:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107570:	83 e2 df             	and    $0xffffffdf,%edx
80107573:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107583:	83 ca 40             	or     $0x40,%edx
80107586:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010758c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107596:	83 ca 80             	or     $0xffffff80,%edx
80107599:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010759f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a2:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801075a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ac:	83 c0 70             	add    $0x70,%eax
801075af:	83 ec 08             	sub    $0x8,%esp
801075b2:	6a 30                	push   $0x30
801075b4:	50                   	push   %eax
801075b5:	e8 63 fc ff ff       	call   8010721d <lgdt>
801075ba:	83 c4 10             	add    $0x10,%esp
}
801075bd:	90                   	nop
801075be:	c9                   	leave  
801075bf:	c3                   	ret    

801075c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801075c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c9:	c1 e8 16             	shr    $0x16,%eax
801075cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801075d3:	8b 45 08             	mov    0x8(%ebp),%eax
801075d6:	01 d0                	add    %edx,%eax
801075d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801075db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075de:	8b 00                	mov    (%eax),%eax
801075e0:	83 e0 01             	and    $0x1,%eax
801075e3:	85 c0                	test   %eax,%eax
801075e5:	74 14                	je     801075fb <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075ea:	8b 00                	mov    (%eax),%eax
801075ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075f1:	05 00 00 00 80       	add    $0x80000000,%eax
801075f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075f9:	eb 42                	jmp    8010763d <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801075fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801075ff:	74 0e                	je     8010760f <walkpgdir+0x4f>
80107601:	e8 7f b1 ff ff       	call   80102785 <kalloc>
80107606:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010760d:	75 07                	jne    80107616 <walkpgdir+0x56>
      return 0;
8010760f:	b8 00 00 00 00       	mov    $0x0,%eax
80107614:	eb 3e                	jmp    80107654 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107616:	83 ec 04             	sub    $0x4,%esp
80107619:	68 00 10 00 00       	push   $0x1000
8010761e:	6a 00                	push   $0x0
80107620:	ff 75 f4             	push   -0xc(%ebp)
80107623:	e8 03 d5 ff ff       	call   80104b2b <memset>
80107628:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010762b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762e:	05 00 00 00 80       	add    $0x80000000,%eax
80107633:	83 c8 07             	or     $0x7,%eax
80107636:	89 c2                	mov    %eax,%edx
80107638:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010763b:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010763d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107640:	c1 e8 0c             	shr    $0xc,%eax
80107643:	25 ff 03 00 00       	and    $0x3ff,%eax
80107648:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010764f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107652:	01 d0                	add    %edx,%eax
}
80107654:	c9                   	leave  
80107655:	c3                   	ret    

80107656 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107656:	55                   	push   %ebp
80107657:	89 e5                	mov    %esp,%ebp
80107659:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010765c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010765f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107667:	8b 55 0c             	mov    0xc(%ebp),%edx
8010766a:	8b 45 10             	mov    0x10(%ebp),%eax
8010766d:	01 d0                	add    %edx,%eax
8010766f:	83 e8 01             	sub    $0x1,%eax
80107672:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010767a:	83 ec 04             	sub    $0x4,%esp
8010767d:	6a 01                	push   $0x1
8010767f:	ff 75 f4             	push   -0xc(%ebp)
80107682:	ff 75 08             	push   0x8(%ebp)
80107685:	e8 36 ff ff ff       	call   801075c0 <walkpgdir>
8010768a:	83 c4 10             	add    $0x10,%esp
8010768d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107690:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107694:	75 07                	jne    8010769d <mappages+0x47>
      return -1;
80107696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010769b:	eb 47                	jmp    801076e4 <mappages+0x8e>
    if(*pte & PTE_P)
8010769d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076a0:	8b 00                	mov    (%eax),%eax
801076a2:	83 e0 01             	and    $0x1,%eax
801076a5:	85 c0                	test   %eax,%eax
801076a7:	74 0d                	je     801076b6 <mappages+0x60>
      panic("remap");
801076a9:	83 ec 0c             	sub    $0xc,%esp
801076ac:	68 08 ab 10 80       	push   $0x8010ab08
801076b1:	e8 f3 8e ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
801076b6:	8b 45 18             	mov    0x18(%ebp),%eax
801076b9:	0b 45 14             	or     0x14(%ebp),%eax
801076bc:	83 c8 01             	or     $0x1,%eax
801076bf:	89 c2                	mov    %eax,%edx
801076c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076c4:	89 10                	mov    %edx,(%eax)
    if(a == last)
801076c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801076cc:	74 10                	je     801076de <mappages+0x88>
      break;
    a += PGSIZE;
801076ce:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801076d5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801076dc:	eb 9c                	jmp    8010767a <mappages+0x24>
      break;
801076de:	90                   	nop
  }
  return 0;
801076df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076e4:	c9                   	leave  
801076e5:	c3                   	ret    

801076e6 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801076e6:	55                   	push   %ebp
801076e7:	89 e5                	mov    %esp,%ebp
801076e9:	53                   	push   %ebx
801076ea:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801076ed:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801076f4:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
801076fa:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801076ff:	29 d0                	sub    %edx,%eax
80107701:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107704:	a1 68 6f 19 80       	mov    0x80196f68,%eax
80107709:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010770c:	8b 15 68 6f 19 80    	mov    0x80196f68,%edx
80107712:	a1 70 6f 19 80       	mov    0x80196f70,%eax
80107717:	01 d0                	add    %edx,%eax
80107719:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010771c:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107726:	83 c0 30             	add    $0x30,%eax
80107729:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010772c:	89 10                	mov    %edx,(%eax)
8010772e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107731:	89 50 04             	mov    %edx,0x4(%eax)
80107734:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107737:	89 50 08             	mov    %edx,0x8(%eax)
8010773a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010773d:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107740:	e8 40 b0 ff ff       	call   80102785 <kalloc>
80107745:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010774c:	75 07                	jne    80107755 <setupkvm+0x6f>
    return 0;
8010774e:	b8 00 00 00 00       	mov    $0x0,%eax
80107753:	eb 78                	jmp    801077cd <setupkvm+0xe7>
  }
  memset(pgdir, 0, PGSIZE);
80107755:	83 ec 04             	sub    $0x4,%esp
80107758:	68 00 10 00 00       	push   $0x1000
8010775d:	6a 00                	push   $0x0
8010775f:	ff 75 f0             	push   -0x10(%ebp)
80107762:	e8 c4 d3 ff ff       	call   80104b2b <memset>
80107767:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010776a:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
80107771:	eb 4e                	jmp    801077c1 <setupkvm+0xdb>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107776:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777c:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010777f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107782:	8b 58 08             	mov    0x8(%eax),%ebx
80107785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107788:	8b 40 04             	mov    0x4(%eax),%eax
8010778b:	29 c3                	sub    %eax,%ebx
8010778d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107790:	8b 00                	mov    (%eax),%eax
80107792:	83 ec 0c             	sub    $0xc,%esp
80107795:	51                   	push   %ecx
80107796:	52                   	push   %edx
80107797:	53                   	push   %ebx
80107798:	50                   	push   %eax
80107799:	ff 75 f0             	push   -0x10(%ebp)
8010779c:	e8 b5 fe ff ff       	call   80107656 <mappages>
801077a1:	83 c4 20             	add    $0x20,%esp
801077a4:	85 c0                	test   %eax,%eax
801077a6:	79 15                	jns    801077bd <setupkvm+0xd7>
      freevm(pgdir);
801077a8:	83 ec 0c             	sub    $0xc,%esp
801077ab:	ff 75 f0             	push   -0x10(%ebp)
801077ae:	e8 f5 04 00 00       	call   80107ca8 <freevm>
801077b3:	83 c4 10             	add    $0x10,%esp
      return 0;
801077b6:	b8 00 00 00 00       	mov    $0x0,%eax
801077bb:	eb 10                	jmp    801077cd <setupkvm+0xe7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077bd:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801077c1:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
801077c8:	72 a9                	jb     80107773 <setupkvm+0x8d>
    }
  return pgdir;
801077ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801077cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801077d0:	c9                   	leave  
801077d1:	c3                   	ret    

801077d2 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801077d2:	55                   	push   %ebp
801077d3:	89 e5                	mov    %esp,%ebp
801077d5:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077d8:	e8 09 ff ff ff       	call   801076e6 <setupkvm>
801077dd:	a3 9c 6c 19 80       	mov    %eax,0x80196c9c
  switchkvm();
801077e2:	e8 03 00 00 00       	call   801077ea <switchkvm>
}
801077e7:	90                   	nop
801077e8:	c9                   	leave  
801077e9:	c3                   	ret    

801077ea <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801077ea:	55                   	push   %ebp
801077eb:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077ed:	a1 9c 6c 19 80       	mov    0x80196c9c,%eax
801077f2:	05 00 00 00 80       	add    $0x80000000,%eax
801077f7:	50                   	push   %eax
801077f8:	e8 61 fa ff ff       	call   8010725e <lcr3>
801077fd:	83 c4 04             	add    $0x4,%esp
}
80107800:	90                   	nop
80107801:	c9                   	leave  
80107802:	c3                   	ret    

80107803 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107803:	55                   	push   %ebp
80107804:	89 e5                	mov    %esp,%ebp
80107806:	56                   	push   %esi
80107807:	53                   	push   %ebx
80107808:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010780b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010780f:	75 0d                	jne    8010781e <switchuvm+0x1b>
    panic("switchuvm: no process");
80107811:	83 ec 0c             	sub    $0xc,%esp
80107814:	68 0e ab 10 80       	push   $0x8010ab0e
80107819:	e8 8b 8d ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
8010781e:	8b 45 08             	mov    0x8(%ebp),%eax
80107821:	8b 40 08             	mov    0x8(%eax),%eax
80107824:	85 c0                	test   %eax,%eax
80107826:	75 0d                	jne    80107835 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107828:	83 ec 0c             	sub    $0xc,%esp
8010782b:	68 24 ab 10 80       	push   $0x8010ab24
80107830:	e8 74 8d ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107835:	8b 45 08             	mov    0x8(%ebp),%eax
80107838:	8b 40 04             	mov    0x4(%eax),%eax
8010783b:	85 c0                	test   %eax,%eax
8010783d:	75 0d                	jne    8010784c <switchuvm+0x49>
    panic("switchuvm: no pgdir");
8010783f:	83 ec 0c             	sub    $0xc,%esp
80107842:	68 39 ab 10 80       	push   $0x8010ab39
80107847:	e8 5d 8d ff ff       	call   801005a9 <panic>

  pushcli();
8010784c:	e8 cf d1 ff ff       	call   80104a20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107851:	e8 47 c1 ff ff       	call   8010399d <mycpu>
80107856:	89 c3                	mov    %eax,%ebx
80107858:	e8 40 c1 ff ff       	call   8010399d <mycpu>
8010785d:	83 c0 08             	add    $0x8,%eax
80107860:	89 c6                	mov    %eax,%esi
80107862:	e8 36 c1 ff ff       	call   8010399d <mycpu>
80107867:	83 c0 08             	add    $0x8,%eax
8010786a:	c1 e8 10             	shr    $0x10,%eax
8010786d:	88 45 f7             	mov    %al,-0x9(%ebp)
80107870:	e8 28 c1 ff ff       	call   8010399d <mycpu>
80107875:	83 c0 08             	add    $0x8,%eax
80107878:	c1 e8 18             	shr    $0x18,%eax
8010787b:	89 c2                	mov    %eax,%edx
8010787d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107884:	67 00 
80107886:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
8010788d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107891:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107897:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010789e:	83 e0 f0             	and    $0xfffffff0,%eax
801078a1:	83 c8 09             	or     $0x9,%eax
801078a4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078aa:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078b1:	83 c8 10             	or     $0x10,%eax
801078b4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078ba:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078c1:	83 e0 9f             	and    $0xffffff9f,%eax
801078c4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078ca:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801078d1:	83 c8 80             	or     $0xffffff80,%eax
801078d4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801078da:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801078e1:	83 e0 f0             	and    $0xfffffff0,%eax
801078e4:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801078ea:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801078f1:	83 e0 ef             	and    $0xffffffef,%eax
801078f4:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801078fa:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107901:	83 e0 df             	and    $0xffffffdf,%eax
80107904:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010790a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107911:	83 c8 40             	or     $0x40,%eax
80107914:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010791a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107921:	83 e0 7f             	and    $0x7f,%eax
80107924:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010792a:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107930:	e8 68 c0 ff ff       	call   8010399d <mycpu>
80107935:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010793c:	83 e2 ef             	and    $0xffffffef,%edx
8010793f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107945:	e8 53 c0 ff ff       	call   8010399d <mycpu>
8010794a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107950:	8b 45 08             	mov    0x8(%ebp),%eax
80107953:	8b 40 08             	mov    0x8(%eax),%eax
80107956:	89 c3                	mov    %eax,%ebx
80107958:	e8 40 c0 ff ff       	call   8010399d <mycpu>
8010795d:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107963:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107966:	e8 32 c0 ff ff       	call   8010399d <mycpu>
8010796b:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107971:	83 ec 0c             	sub    $0xc,%esp
80107974:	6a 28                	push   $0x28
80107976:	e8 cc f8 ff ff       	call   80107247 <ltr>
8010797b:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010797e:	8b 45 08             	mov    0x8(%ebp),%eax
80107981:	8b 40 04             	mov    0x4(%eax),%eax
80107984:	05 00 00 00 80       	add    $0x80000000,%eax
80107989:	83 ec 0c             	sub    $0xc,%esp
8010798c:	50                   	push   %eax
8010798d:	e8 cc f8 ff ff       	call   8010725e <lcr3>
80107992:	83 c4 10             	add    $0x10,%esp
  popcli();
80107995:	e8 d3 d0 ff ff       	call   80104a6d <popcli>
}
8010799a:	90                   	nop
8010799b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010799e:	5b                   	pop    %ebx
8010799f:	5e                   	pop    %esi
801079a0:	5d                   	pop    %ebp
801079a1:	c3                   	ret    

801079a2 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801079a2:	55                   	push   %ebp
801079a3:	89 e5                	mov    %esp,%ebp
801079a5:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801079a8:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801079af:	76 0d                	jbe    801079be <inituvm+0x1c>
    panic("inituvm: more than a page");
801079b1:	83 ec 0c             	sub    $0xc,%esp
801079b4:	68 4d ab 10 80       	push   $0x8010ab4d
801079b9:	e8 eb 8b ff ff       	call   801005a9 <panic>
  mem = kalloc();
801079be:	e8 c2 ad ff ff       	call   80102785 <kalloc>
801079c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801079c6:	83 ec 04             	sub    $0x4,%esp
801079c9:	68 00 10 00 00       	push   $0x1000
801079ce:	6a 00                	push   $0x0
801079d0:	ff 75 f4             	push   -0xc(%ebp)
801079d3:	e8 53 d1 ff ff       	call   80104b2b <memset>
801079d8:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079de:	05 00 00 00 80       	add    $0x80000000,%eax
801079e3:	83 ec 0c             	sub    $0xc,%esp
801079e6:	6a 06                	push   $0x6
801079e8:	50                   	push   %eax
801079e9:	68 00 10 00 00       	push   $0x1000
801079ee:	6a 00                	push   $0x0
801079f0:	ff 75 08             	push   0x8(%ebp)
801079f3:	e8 5e fc ff ff       	call   80107656 <mappages>
801079f8:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801079fb:	83 ec 04             	sub    $0x4,%esp
801079fe:	ff 75 10             	push   0x10(%ebp)
80107a01:	ff 75 0c             	push   0xc(%ebp)
80107a04:	ff 75 f4             	push   -0xc(%ebp)
80107a07:	e8 de d1 ff ff       	call   80104bea <memmove>
80107a0c:	83 c4 10             	add    $0x10,%esp
}
80107a0f:	90                   	nop
80107a10:	c9                   	leave  
80107a11:	c3                   	ret    

80107a12 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107a12:	55                   	push   %ebp
80107a13:	89 e5                	mov    %esp,%ebp
80107a15:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a18:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a1b:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a20:	85 c0                	test   %eax,%eax
80107a22:	74 0d                	je     80107a31 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107a24:	83 ec 0c             	sub    $0xc,%esp
80107a27:	68 68 ab 10 80       	push   $0x8010ab68
80107a2c:	e8 78 8b ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a38:	e9 8f 00 00 00       	jmp    80107acc <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a43:	01 d0                	add    %edx,%eax
80107a45:	83 ec 04             	sub    $0x4,%esp
80107a48:	6a 00                	push   $0x0
80107a4a:	50                   	push   %eax
80107a4b:	ff 75 08             	push   0x8(%ebp)
80107a4e:	e8 6d fb ff ff       	call   801075c0 <walkpgdir>
80107a53:	83 c4 10             	add    $0x10,%esp
80107a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a5d:	75 0d                	jne    80107a6c <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107a5f:	83 ec 0c             	sub    $0xc,%esp
80107a62:	68 8b ab 10 80       	push   $0x8010ab8b
80107a67:	e8 3d 8b ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a6f:	8b 00                	mov    (%eax),%eax
80107a71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107a79:	8b 45 18             	mov    0x18(%ebp),%eax
80107a7c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107a7f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107a84:	77 0b                	ja     80107a91 <loaduvm+0x7f>
      n = sz - i;
80107a86:	8b 45 18             	mov    0x18(%ebp),%eax
80107a89:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a8f:	eb 07                	jmp    80107a98 <loaduvm+0x86>
    else
      n = PGSIZE;
80107a91:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a98:	8b 55 14             	mov    0x14(%ebp),%edx
80107a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9e:	01 d0                	add    %edx,%eax
80107aa0:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107aa3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107aa9:	ff 75 f0             	push   -0x10(%ebp)
80107aac:	50                   	push   %eax
80107aad:	52                   	push   %edx
80107aae:	ff 75 10             	push   0x10(%ebp)
80107ab1:	e8 05 a4 ff ff       	call   80101ebb <readi>
80107ab6:	83 c4 10             	add    $0x10,%esp
80107ab9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107abc:	74 07                	je     80107ac5 <loaduvm+0xb3>
      return -1;
80107abe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ac3:	eb 18                	jmp    80107add <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107ac5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acf:	3b 45 18             	cmp    0x18(%ebp),%eax
80107ad2:	0f 82 65 ff ff ff    	jb     80107a3d <loaduvm+0x2b>
  }
  return 0;
80107ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107add:	c9                   	leave  
80107ade:	c3                   	ret    

80107adf <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107adf:	55                   	push   %ebp
80107ae0:	89 e5                	mov    %esp,%ebp
80107ae2:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107ae5:	8b 45 10             	mov    0x10(%ebp),%eax
80107ae8:	85 c0                	test   %eax,%eax
80107aea:	79 0a                	jns    80107af6 <allocuvm+0x17>
    return 0;
80107aec:	b8 00 00 00 00       	mov    $0x0,%eax
80107af1:	e9 ec 00 00 00       	jmp    80107be2 <allocuvm+0x103>
  if(newsz < oldsz)
80107af6:	8b 45 10             	mov    0x10(%ebp),%eax
80107af9:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107afc:	73 08                	jae    80107b06 <allocuvm+0x27>
    return oldsz;
80107afe:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b01:	e9 dc 00 00 00       	jmp    80107be2 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107b06:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b09:	05 ff 0f 00 00       	add    $0xfff,%eax
80107b0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107b16:	e9 b8 00 00 00       	jmp    80107bd3 <allocuvm+0xf4>
    mem = kalloc();
80107b1b:	e8 65 ac ff ff       	call   80102785 <kalloc>
80107b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b27:	75 2e                	jne    80107b57 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107b29:	83 ec 0c             	sub    $0xc,%esp
80107b2c:	68 a9 ab 10 80       	push   $0x8010aba9
80107b31:	e8 be 88 ff ff       	call   801003f4 <cprintf>
80107b36:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107b39:	83 ec 04             	sub    $0x4,%esp
80107b3c:	ff 75 0c             	push   0xc(%ebp)
80107b3f:	ff 75 10             	push   0x10(%ebp)
80107b42:	ff 75 08             	push   0x8(%ebp)
80107b45:	e8 9a 00 00 00       	call   80107be4 <deallocuvm>
80107b4a:	83 c4 10             	add    $0x10,%esp
      return 0;
80107b4d:	b8 00 00 00 00       	mov    $0x0,%eax
80107b52:	e9 8b 00 00 00       	jmp    80107be2 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107b57:	83 ec 04             	sub    $0x4,%esp
80107b5a:	68 00 10 00 00       	push   $0x1000
80107b5f:	6a 00                	push   $0x0
80107b61:	ff 75 f0             	push   -0x10(%ebp)
80107b64:	e8 c2 cf ff ff       	call   80104b2b <memset>
80107b69:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b6f:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b78:	83 ec 0c             	sub    $0xc,%esp
80107b7b:	6a 06                	push   $0x6
80107b7d:	52                   	push   %edx
80107b7e:	68 00 10 00 00       	push   $0x1000
80107b83:	50                   	push   %eax
80107b84:	ff 75 08             	push   0x8(%ebp)
80107b87:	e8 ca fa ff ff       	call   80107656 <mappages>
80107b8c:	83 c4 20             	add    $0x20,%esp
80107b8f:	85 c0                	test   %eax,%eax
80107b91:	79 39                	jns    80107bcc <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107b93:	83 ec 0c             	sub    $0xc,%esp
80107b96:	68 c1 ab 10 80       	push   $0x8010abc1
80107b9b:	e8 54 88 ff ff       	call   801003f4 <cprintf>
80107ba0:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107ba3:	83 ec 04             	sub    $0x4,%esp
80107ba6:	ff 75 0c             	push   0xc(%ebp)
80107ba9:	ff 75 10             	push   0x10(%ebp)
80107bac:	ff 75 08             	push   0x8(%ebp)
80107baf:	e8 30 00 00 00       	call   80107be4 <deallocuvm>
80107bb4:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107bb7:	83 ec 0c             	sub    $0xc,%esp
80107bba:	ff 75 f0             	push   -0x10(%ebp)
80107bbd:	e8 29 ab ff ff       	call   801026eb <kfree>
80107bc2:	83 c4 10             	add    $0x10,%esp
      return 0;
80107bc5:	b8 00 00 00 00       	mov    $0x0,%eax
80107bca:	eb 16                	jmp    80107be2 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107bcc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd6:	3b 45 10             	cmp    0x10(%ebp),%eax
80107bd9:	0f 82 3c ff ff ff    	jb     80107b1b <allocuvm+0x3c>
    }
  }
  return newsz;
80107bdf:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107be2:	c9                   	leave  
80107be3:	c3                   	ret    

80107be4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107be4:	55                   	push   %ebp
80107be5:	89 e5                	mov    %esp,%ebp
80107be7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107bea:	8b 45 10             	mov    0x10(%ebp),%eax
80107bed:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107bf0:	72 08                	jb     80107bfa <deallocuvm+0x16>
    return oldsz;
80107bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bf5:	e9 ac 00 00 00       	jmp    80107ca6 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107bfa:	8b 45 10             	mov    0x10(%ebp),%eax
80107bfd:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c0a:	e9 88 00 00 00       	jmp    80107c97 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c12:	83 ec 04             	sub    $0x4,%esp
80107c15:	6a 00                	push   $0x0
80107c17:	50                   	push   %eax
80107c18:	ff 75 08             	push   0x8(%ebp)
80107c1b:	e8 a0 f9 ff ff       	call   801075c0 <walkpgdir>
80107c20:	83 c4 10             	add    $0x10,%esp
80107c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c2a:	75 16                	jne    80107c42 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2f:	c1 e8 16             	shr    $0x16,%eax
80107c32:	83 c0 01             	add    $0x1,%eax
80107c35:	c1 e0 16             	shl    $0x16,%eax
80107c38:	2d 00 10 00 00       	sub    $0x1000,%eax
80107c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c40:	eb 4e                	jmp    80107c90 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c45:	8b 00                	mov    (%eax),%eax
80107c47:	83 e0 01             	and    $0x1,%eax
80107c4a:	85 c0                	test   %eax,%eax
80107c4c:	74 42                	je     80107c90 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c51:	8b 00                	mov    (%eax),%eax
80107c53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107c5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c5f:	75 0d                	jne    80107c6e <deallocuvm+0x8a>
        panic("kfree");
80107c61:	83 ec 0c             	sub    $0xc,%esp
80107c64:	68 dd ab 10 80       	push   $0x8010abdd
80107c69:	e8 3b 89 ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c71:	05 00 00 00 80       	add    $0x80000000,%eax
80107c76:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107c79:	83 ec 0c             	sub    $0xc,%esp
80107c7c:	ff 75 e8             	push   -0x18(%ebp)
80107c7f:	e8 67 aa ff ff       	call   801026eb <kfree>
80107c84:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107c90:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c9d:	0f 82 6c ff ff ff    	jb     80107c0f <deallocuvm+0x2b>
    }
  }
  return newsz;
80107ca3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ca6:	c9                   	leave  
80107ca7:	c3                   	ret    

80107ca8 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ca8:	55                   	push   %ebp
80107ca9:	89 e5                	mov    %esp,%ebp
80107cab:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107cb2:	75 0d                	jne    80107cc1 <freevm+0x19>
    panic("freevm: no pgdir");
80107cb4:	83 ec 0c             	sub    $0xc,%esp
80107cb7:	68 e3 ab 10 80       	push   $0x8010abe3
80107cbc:	e8 e8 88 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107cc1:	83 ec 04             	sub    $0x4,%esp
80107cc4:	6a 00                	push   $0x0
80107cc6:	68 00 00 00 80       	push   $0x80000000
80107ccb:	ff 75 08             	push   0x8(%ebp)
80107cce:	e8 11 ff ff ff       	call   80107be4 <deallocuvm>
80107cd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107cdd:	eb 48                	jmp    80107d27 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80107cec:	01 d0                	add    %edx,%eax
80107cee:	8b 00                	mov    (%eax),%eax
80107cf0:	83 e0 01             	and    $0x1,%eax
80107cf3:	85 c0                	test   %eax,%eax
80107cf5:	74 2c                	je     80107d23 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d01:	8b 45 08             	mov    0x8(%ebp),%eax
80107d04:	01 d0                	add    %edx,%eax
80107d06:	8b 00                	mov    (%eax),%eax
80107d08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d0d:	05 00 00 00 80       	add    $0x80000000,%eax
80107d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107d15:	83 ec 0c             	sub    $0xc,%esp
80107d18:	ff 75 f0             	push   -0x10(%ebp)
80107d1b:	e8 cb a9 ff ff       	call   801026eb <kfree>
80107d20:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107d27:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107d2e:	76 af                	jbe    80107cdf <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d30:	83 ec 0c             	sub    $0xc,%esp
80107d33:	ff 75 08             	push   0x8(%ebp)
80107d36:	e8 b0 a9 ff ff       	call   801026eb <kfree>
80107d3b:	83 c4 10             	add    $0x10,%esp
}
80107d3e:	90                   	nop
80107d3f:	c9                   	leave  
80107d40:	c3                   	ret    

80107d41 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d41:	55                   	push   %ebp
80107d42:	89 e5                	mov    %esp,%ebp
80107d44:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d47:	83 ec 04             	sub    $0x4,%esp
80107d4a:	6a 00                	push   $0x0
80107d4c:	ff 75 0c             	push   0xc(%ebp)
80107d4f:	ff 75 08             	push   0x8(%ebp)
80107d52:	e8 69 f8 ff ff       	call   801075c0 <walkpgdir>
80107d57:	83 c4 10             	add    $0x10,%esp
80107d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d61:	75 0d                	jne    80107d70 <clearpteu+0x2f>
    panic("clearpteu");
80107d63:	83 ec 0c             	sub    $0xc,%esp
80107d66:	68 f4 ab 10 80       	push   $0x8010abf4
80107d6b:	e8 39 88 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d73:	8b 00                	mov    (%eax),%eax
80107d75:	83 e0 fb             	and    $0xfffffffb,%eax
80107d78:	89 c2                	mov    %eax,%edx
80107d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7d:	89 10                	mov    %edx,(%eax)
}
80107d7f:	90                   	nop
80107d80:	c9                   	leave  
80107d81:	c3                   	ret    

80107d82 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107d82:	55                   	push   %ebp
80107d83:	89 e5                	mov    %esp,%ebp
80107d85:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107d88:	e8 59 f9 ff ff       	call   801076e6 <setupkvm>
80107d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d94:	75 0a                	jne    80107da0 <copyuvm+0x1e>
    return 0;
80107d96:	b8 00 00 00 00       	mov    $0x0,%eax
80107d9b:	e9 b6 01 00 00       	jmp    80107f56 <copyuvm+0x1d4>
  for(i = 0; i < sz; i += PGSIZE){
80107da0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107da7:	e9 af 00 00 00       	jmp    80107e5b <copyuvm+0xd9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107daf:	83 ec 04             	sub    $0x4,%esp
80107db2:	6a 00                	push   $0x0
80107db4:	50                   	push   %eax
80107db5:	ff 75 08             	push   0x8(%ebp)
80107db8:	e8 03 f8 ff ff       	call   801075c0 <walkpgdir>
80107dbd:	83 c4 10             	add    $0x10,%esp
80107dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107dc3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107dc7:	0f 84 83 00 00 00    	je     80107e50 <copyuvm+0xce>
      continue;
    if(!(*pte & PTE_P))
80107dcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dd0:	8b 00                	mov    (%eax),%eax
80107dd2:	83 e0 01             	and    $0x1,%eax
80107dd5:	85 c0                	test   %eax,%eax
80107dd7:	74 7a                	je     80107e53 <copyuvm+0xd1>
      continue;
    pa = PTE_ADDR(*pte);
80107dd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ddc:	8b 00                	mov    (%eax),%eax
80107dde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80107de6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107de9:	8b 00                	mov    (%eax),%eax
80107deb:	25 ff 0f 00 00       	and    $0xfff,%eax
80107df0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107df3:	e8 8d a9 ff ff       	call   80102785 <kalloc>
80107df8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107dfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107dff:	0f 84 34 01 00 00    	je     80107f39 <copyuvm+0x1b7>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e08:	05 00 00 00 80       	add    $0x80000000,%eax
80107e0d:	83 ec 04             	sub    $0x4,%esp
80107e10:	68 00 10 00 00       	push   $0x1000
80107e15:	50                   	push   %eax
80107e16:	ff 75 dc             	push   -0x24(%ebp)
80107e19:	e8 cc cd ff ff       	call   80104bea <memmove>
80107e1e:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107e21:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107e27:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e30:	83 ec 0c             	sub    $0xc,%esp
80107e33:	52                   	push   %edx
80107e34:	51                   	push   %ecx
80107e35:	68 00 10 00 00       	push   $0x1000
80107e3a:	50                   	push   %eax
80107e3b:	ff 75 f0             	push   -0x10(%ebp)
80107e3e:	e8 13 f8 ff ff       	call   80107656 <mappages>
80107e43:	83 c4 20             	add    $0x20,%esp
80107e46:	85 c0                	test   %eax,%eax
80107e48:	0f 88 ee 00 00 00    	js     80107f3c <copyuvm+0x1ba>
80107e4e:	eb 04                	jmp    80107e54 <copyuvm+0xd2>
      continue;
80107e50:	90                   	nop
80107e51:	eb 01                	jmp    80107e54 <copyuvm+0xd2>
      continue;
80107e53:	90                   	nop
  for(i = 0; i < sz; i += PGSIZE){
80107e54:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e61:	0f 82 45 ff ff ff    	jb     80107dac <copyuvm+0x2a>
      goto bad;
  }
  
  
  
  uint t = KERNBASE-1;
80107e67:	c7 45 ec ff ff ff 7f 	movl   $0x7fffffff,-0x14(%ebp)
  t = PGROUNDDOWN(t);
80107e6e:	81 65 ec 00 f0 ff ff 	andl   $0xfffff000,-0x14(%ebp)
  for(i = t; i > t - PGSIZE; i -= PGSIZE){
80107e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e7b:	e9 a3 00 00 00       	jmp    80107f23 <copyuvm+0x1a1>
    
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e83:	83 ec 04             	sub    $0x4,%esp
80107e86:	6a 00                	push   $0x0
80107e88:	50                   	push   %eax
80107e89:	ff 75 08             	push   0x8(%ebp)
80107e8c:	e8 2f f7 ff ff       	call   801075c0 <walkpgdir>
80107e91:	83 c4 10             	add    $0x10,%esp
80107e94:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107e97:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107e9b:	74 7b                	je     80107f18 <copyuvm+0x196>
      continue;
    if(!(*pte & PTE_P))
80107e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ea0:	8b 00                	mov    (%eax),%eax
80107ea2:	83 e0 01             	and    $0x1,%eax
80107ea5:	85 c0                	test   %eax,%eax
80107ea7:	74 72                	je     80107f1b <copyuvm+0x199>
      continue;
    pa = PTE_ADDR(*pte);
80107ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107eac:	8b 00                	mov    (%eax),%eax
80107eae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80107eb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107eb9:	8b 00                	mov    (%eax),%eax
80107ebb:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ec0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107ec3:	e8 bd a8 ff ff       	call   80102785 <kalloc>
80107ec8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107ecb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107ecf:	74 6e                	je     80107f3f <copyuvm+0x1bd>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ed4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ed9:	83 ec 04             	sub    $0x4,%esp
80107edc:	68 00 10 00 00       	push   $0x1000
80107ee1:	50                   	push   %eax
80107ee2:	ff 75 dc             	push   -0x24(%ebp)
80107ee5:	e8 00 cd ff ff       	call   80104bea <memmove>
80107eea:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107eed:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107ef3:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efc:	83 ec 0c             	sub    $0xc,%esp
80107eff:	52                   	push   %edx
80107f00:	51                   	push   %ecx
80107f01:	68 00 10 00 00       	push   $0x1000
80107f06:	50                   	push   %eax
80107f07:	ff 75 f0             	push   -0x10(%ebp)
80107f0a:	e8 47 f7 ff ff       	call   80107656 <mappages>
80107f0f:	83 c4 20             	add    $0x20,%esp
80107f12:	85 c0                	test   %eax,%eax
80107f14:	78 2c                	js     80107f42 <copyuvm+0x1c0>
80107f16:	eb 04                	jmp    80107f1c <copyuvm+0x19a>
      continue;
80107f18:	90                   	nop
80107f19:	eb 01                	jmp    80107f1c <copyuvm+0x19a>
      continue;
80107f1b:	90                   	nop
  for(i = t; i > t - PGSIZE; i -= PGSIZE){
80107f1c:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
80107f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f26:	2d 00 10 00 00       	sub    $0x1000,%eax
80107f2b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107f2e:	0f 87 4c ff ff ff    	ja     80107e80 <copyuvm+0xfe>
      goto bad;
  }
  
  return d;
80107f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f37:	eb 1d                	jmp    80107f56 <copyuvm+0x1d4>
      goto bad;
80107f39:	90                   	nop
80107f3a:	eb 07                	jmp    80107f43 <copyuvm+0x1c1>
      goto bad;
80107f3c:	90                   	nop
80107f3d:	eb 04                	jmp    80107f43 <copyuvm+0x1c1>
      goto bad;
80107f3f:	90                   	nop
80107f40:	eb 01                	jmp    80107f43 <copyuvm+0x1c1>
      goto bad;
80107f42:	90                   	nop

bad:
  freevm(d);
80107f43:	83 ec 0c             	sub    $0xc,%esp
80107f46:	ff 75 f0             	push   -0x10(%ebp)
80107f49:	e8 5a fd ff ff       	call   80107ca8 <freevm>
80107f4e:	83 c4 10             	add    $0x10,%esp
  return 0;
80107f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f56:	c9                   	leave  
80107f57:	c3                   	ret    

80107f58 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f58:	55                   	push   %ebp
80107f59:	89 e5                	mov    %esp,%ebp
80107f5b:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f5e:	83 ec 04             	sub    $0x4,%esp
80107f61:	6a 00                	push   $0x0
80107f63:	ff 75 0c             	push   0xc(%ebp)
80107f66:	ff 75 08             	push   0x8(%ebp)
80107f69:	e8 52 f6 ff ff       	call   801075c0 <walkpgdir>
80107f6e:	83 c4 10             	add    $0x10,%esp
80107f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f77:	8b 00                	mov    (%eax),%eax
80107f79:	83 e0 01             	and    $0x1,%eax
80107f7c:	85 c0                	test   %eax,%eax
80107f7e:	75 07                	jne    80107f87 <uva2ka+0x2f>
    return 0;
80107f80:	b8 00 00 00 00       	mov    $0x0,%eax
80107f85:	eb 22                	jmp    80107fa9 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8a:	8b 00                	mov    (%eax),%eax
80107f8c:	83 e0 04             	and    $0x4,%eax
80107f8f:	85 c0                	test   %eax,%eax
80107f91:	75 07                	jne    80107f9a <uva2ka+0x42>
    return 0;
80107f93:	b8 00 00 00 00       	mov    $0x0,%eax
80107f98:	eb 0f                	jmp    80107fa9 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9d:	8b 00                	mov    (%eax),%eax
80107f9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fa4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107fa9:	c9                   	leave  
80107faa:	c3                   	ret    

80107fab <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107fab:	55                   	push   %ebp
80107fac:	89 e5                	mov    %esp,%ebp
80107fae:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107fb1:	8b 45 10             	mov    0x10(%ebp),%eax
80107fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107fb7:	eb 7f                	jmp    80108038 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc7:	83 ec 08             	sub    $0x8,%esp
80107fca:	50                   	push   %eax
80107fcb:	ff 75 08             	push   0x8(%ebp)
80107fce:	e8 85 ff ff ff       	call   80107f58 <uva2ka>
80107fd3:	83 c4 10             	add    $0x10,%esp
80107fd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107fd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107fdd:	75 07                	jne    80107fe6 <copyout+0x3b>
      return -1;
80107fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fe4:	eb 61                	jmp    80108047 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fe9:	2b 45 0c             	sub    0xc(%ebp),%eax
80107fec:	05 00 10 00 00       	add    $0x1000,%eax
80107ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ff7:	3b 45 14             	cmp    0x14(%ebp),%eax
80107ffa:	76 06                	jbe    80108002 <copyout+0x57>
      n = len;
80107ffc:	8b 45 14             	mov    0x14(%ebp),%eax
80107fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108002:	8b 45 0c             	mov    0xc(%ebp),%eax
80108005:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108008:	89 c2                	mov    %eax,%edx
8010800a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010800d:	01 d0                	add    %edx,%eax
8010800f:	83 ec 04             	sub    $0x4,%esp
80108012:	ff 75 f0             	push   -0x10(%ebp)
80108015:	ff 75 f4             	push   -0xc(%ebp)
80108018:	50                   	push   %eax
80108019:	e8 cc cb ff ff       	call   80104bea <memmove>
8010801e:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108021:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108024:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108027:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010802a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010802d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108030:	05 00 10 00 00       	add    $0x1000,%eax
80108035:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108038:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010803c:	0f 85 77 ff ff ff    	jne    80107fb9 <copyout+0xe>
  }
  return 0;
80108042:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108047:	c9                   	leave  
80108048:	c3                   	ret    

80108049 <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80108049:	55                   	push   %ebp
8010804a:	89 e5                	mov    %esp,%ebp
8010804c:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
8010804f:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80108056:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108059:	8b 40 08             	mov    0x8(%eax),%eax
8010805c:	05 00 00 00 80       	add    $0x80000000,%eax
80108061:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80108064:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
8010806b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806e:	8b 40 24             	mov    0x24(%eax),%eax
80108071:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80108076:	c7 05 60 6f 19 80 00 	movl   $0x0,0x80196f60
8010807d:	00 00 00 

  while(i<madt->len){
80108080:	90                   	nop
80108081:	e9 bd 00 00 00       	jmp    80108143 <mpinit_uefi+0xfa>
    uchar *entry_type = ((uchar *)madt)+i;
80108086:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108089:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010808c:	01 d0                	add    %edx,%eax
8010808e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80108091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108094:	0f b6 00             	movzbl (%eax),%eax
80108097:	0f b6 c0             	movzbl %al,%eax
8010809a:	83 f8 05             	cmp    $0x5,%eax
8010809d:	0f 87 a0 00 00 00    	ja     80108143 <mpinit_uefi+0xfa>
801080a3:	8b 04 85 00 ac 10 80 	mov    -0x7fef5400(,%eax,4),%eax
801080aa:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
801080ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080af:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
801080b2:	a1 60 6f 19 80       	mov    0x80196f60,%eax
801080b7:	83 f8 03             	cmp    $0x3,%eax
801080ba:	7f 28                	jg     801080e4 <mpinit_uefi+0x9b>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
801080bc:	8b 15 60 6f 19 80    	mov    0x80196f60,%edx
801080c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080c5:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801080c9:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
801080cf:	81 c2 a0 6c 19 80    	add    $0x80196ca0,%edx
801080d5:	88 02                	mov    %al,(%edx)
          ncpu++;
801080d7:	a1 60 6f 19 80       	mov    0x80196f60,%eax
801080dc:	83 c0 01             	add    $0x1,%eax
801080df:	a3 60 6f 19 80       	mov    %eax,0x80196f60
        }
        i += lapic_entry->record_len;
801080e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080e7:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801080eb:	0f b6 c0             	movzbl %al,%eax
801080ee:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
801080f1:	eb 50                	jmp    80108143 <mpinit_uefi+0xfa>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
801080f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
801080f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080fc:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108100:	a2 64 6f 19 80       	mov    %al,0x80196f64
        i += ioapic->record_len;
80108105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108108:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010810c:	0f b6 c0             	movzbl %al,%eax
8010810f:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108112:	eb 2f                	jmp    80108143 <mpinit_uefi+0xfa>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80108114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108117:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
8010811a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010811d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108121:	0f b6 c0             	movzbl %al,%eax
80108124:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108127:	eb 1a                	jmp    80108143 <mpinit_uefi+0xfa>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80108129:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010812c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
8010812f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108132:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108136:	0f b6 c0             	movzbl %al,%eax
80108139:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
8010813c:	eb 05                	jmp    80108143 <mpinit_uefi+0xfa>

      case 5:
        i = i + 0xC;
8010813e:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80108142:	90                   	nop
  while(i<madt->len){
80108143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108146:	8b 40 04             	mov    0x4(%eax),%eax
80108149:	39 45 fc             	cmp    %eax,-0x4(%ebp)
8010814c:	0f 82 34 ff ff ff    	jb     80108086 <mpinit_uefi+0x3d>
    }
  }

}
80108152:	90                   	nop
80108153:	90                   	nop
80108154:	c9                   	leave  
80108155:	c3                   	ret    

80108156 <inb>:
{
80108156:	55                   	push   %ebp
80108157:	89 e5                	mov    %esp,%ebp
80108159:	83 ec 14             	sub    $0x14,%esp
8010815c:	8b 45 08             	mov    0x8(%ebp),%eax
8010815f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108163:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108167:	89 c2                	mov    %eax,%edx
80108169:	ec                   	in     (%dx),%al
8010816a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010816d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80108171:	c9                   	leave  
80108172:	c3                   	ret    

80108173 <outb>:
{
80108173:	55                   	push   %ebp
80108174:	89 e5                	mov    %esp,%ebp
80108176:	83 ec 08             	sub    $0x8,%esp
80108179:	8b 45 08             	mov    0x8(%ebp),%eax
8010817c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010817f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80108183:	89 d0                	mov    %edx,%eax
80108185:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108188:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010818c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108190:	ee                   	out    %al,(%dx)
}
80108191:	90                   	nop
80108192:	c9                   	leave  
80108193:	c3                   	ret    

80108194 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80108194:	55                   	push   %ebp
80108195:	89 e5                	mov    %esp,%ebp
80108197:	83 ec 28             	sub    $0x28,%esp
8010819a:	8b 45 08             	mov    0x8(%ebp),%eax
8010819d:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
801081a0:	6a 00                	push   $0x0
801081a2:	68 fa 03 00 00       	push   $0x3fa
801081a7:	e8 c7 ff ff ff       	call   80108173 <outb>
801081ac:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801081af:	68 80 00 00 00       	push   $0x80
801081b4:	68 fb 03 00 00       	push   $0x3fb
801081b9:	e8 b5 ff ff ff       	call   80108173 <outb>
801081be:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801081c1:	6a 0c                	push   $0xc
801081c3:	68 f8 03 00 00       	push   $0x3f8
801081c8:	e8 a6 ff ff ff       	call   80108173 <outb>
801081cd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801081d0:	6a 00                	push   $0x0
801081d2:	68 f9 03 00 00       	push   $0x3f9
801081d7:	e8 97 ff ff ff       	call   80108173 <outb>
801081dc:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801081df:	6a 03                	push   $0x3
801081e1:	68 fb 03 00 00       	push   $0x3fb
801081e6:	e8 88 ff ff ff       	call   80108173 <outb>
801081eb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801081ee:	6a 00                	push   $0x0
801081f0:	68 fc 03 00 00       	push   $0x3fc
801081f5:	e8 79 ff ff ff       	call   80108173 <outb>
801081fa:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
801081fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108204:	eb 11                	jmp    80108217 <uart_debug+0x83>
80108206:	83 ec 0c             	sub    $0xc,%esp
80108209:	6a 0a                	push   $0xa
8010820b:	e8 0c a9 ff ff       	call   80102b1c <microdelay>
80108210:	83 c4 10             	add    $0x10,%esp
80108213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108217:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010821b:	7f 1a                	jg     80108237 <uart_debug+0xa3>
8010821d:	83 ec 0c             	sub    $0xc,%esp
80108220:	68 fd 03 00 00       	push   $0x3fd
80108225:	e8 2c ff ff ff       	call   80108156 <inb>
8010822a:	83 c4 10             	add    $0x10,%esp
8010822d:	0f b6 c0             	movzbl %al,%eax
80108230:	83 e0 20             	and    $0x20,%eax
80108233:	85 c0                	test   %eax,%eax
80108235:	74 cf                	je     80108206 <uart_debug+0x72>
  outb(COM1+0, p);
80108237:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
8010823b:	0f b6 c0             	movzbl %al,%eax
8010823e:	83 ec 08             	sub    $0x8,%esp
80108241:	50                   	push   %eax
80108242:	68 f8 03 00 00       	push   $0x3f8
80108247:	e8 27 ff ff ff       	call   80108173 <outb>
8010824c:	83 c4 10             	add    $0x10,%esp
}
8010824f:	90                   	nop
80108250:	c9                   	leave  
80108251:	c3                   	ret    

80108252 <uart_debugs>:

void uart_debugs(char *p){
80108252:	55                   	push   %ebp
80108253:	89 e5                	mov    %esp,%ebp
80108255:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108258:	eb 1b                	jmp    80108275 <uart_debugs+0x23>
    uart_debug(*p++);
8010825a:	8b 45 08             	mov    0x8(%ebp),%eax
8010825d:	8d 50 01             	lea    0x1(%eax),%edx
80108260:	89 55 08             	mov    %edx,0x8(%ebp)
80108263:	0f b6 00             	movzbl (%eax),%eax
80108266:	0f be c0             	movsbl %al,%eax
80108269:	83 ec 0c             	sub    $0xc,%esp
8010826c:	50                   	push   %eax
8010826d:	e8 22 ff ff ff       	call   80108194 <uart_debug>
80108272:	83 c4 10             	add    $0x10,%esp
  while(*p){
80108275:	8b 45 08             	mov    0x8(%ebp),%eax
80108278:	0f b6 00             	movzbl (%eax),%eax
8010827b:	84 c0                	test   %al,%al
8010827d:	75 db                	jne    8010825a <uart_debugs+0x8>
  }
}
8010827f:	90                   	nop
80108280:	90                   	nop
80108281:	c9                   	leave  
80108282:	c3                   	ret    

80108283 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80108283:	55                   	push   %ebp
80108284:	89 e5                	mov    %esp,%ebp
80108286:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108289:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80108290:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108293:	8b 50 14             	mov    0x14(%eax),%edx
80108296:	8b 40 10             	mov    0x10(%eax),%eax
80108299:	a3 68 6f 19 80       	mov    %eax,0x80196f68
  gpu.vram_size = boot_param->graphic_config.frame_size;
8010829e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082a1:	8b 50 1c             	mov    0x1c(%eax),%edx
801082a4:	8b 40 18             	mov    0x18(%eax),%eax
801082a7:	a3 70 6f 19 80       	mov    %eax,0x80196f70
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801082ac:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
801082b2:	b8 00 00 00 fe       	mov    $0xfe000000,%eax
801082b7:	29 d0                	sub    %edx,%eax
801082b9:	a3 6c 6f 19 80       	mov    %eax,0x80196f6c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801082be:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082c1:	8b 50 24             	mov    0x24(%eax),%edx
801082c4:	8b 40 20             	mov    0x20(%eax),%eax
801082c7:	a3 74 6f 19 80       	mov    %eax,0x80196f74
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801082cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082cf:	8b 50 2c             	mov    0x2c(%eax),%edx
801082d2:	8b 40 28             	mov    0x28(%eax),%eax
801082d5:	a3 78 6f 19 80       	mov    %eax,0x80196f78
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801082da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082dd:	8b 50 34             	mov    0x34(%eax),%edx
801082e0:	8b 40 30             	mov    0x30(%eax),%eax
801082e3:	a3 7c 6f 19 80       	mov    %eax,0x80196f7c
}
801082e8:	90                   	nop
801082e9:	c9                   	leave  
801082ea:	c3                   	ret    

801082eb <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
801082eb:	55                   	push   %ebp
801082ec:	89 e5                	mov    %esp,%ebp
801082ee:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
801082f1:	8b 15 7c 6f 19 80    	mov    0x80196f7c,%edx
801082f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801082fa:	0f af d0             	imul   %eax,%edx
801082fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108300:	01 d0                	add    %edx,%eax
80108302:	c1 e0 02             	shl    $0x2,%eax
80108305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108308:	8b 15 6c 6f 19 80    	mov    0x80196f6c,%edx
8010830e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108311:	01 d0                	add    %edx,%eax
80108313:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108316:	8b 45 10             	mov    0x10(%ebp),%eax
80108319:	0f b6 10             	movzbl (%eax),%edx
8010831c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010831f:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80108321:	8b 45 10             	mov    0x10(%ebp),%eax
80108324:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108328:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010832b:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
8010832e:	8b 45 10             	mov    0x10(%ebp),%eax
80108331:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80108335:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108338:	88 50 02             	mov    %dl,0x2(%eax)
}
8010833b:	90                   	nop
8010833c:	c9                   	leave  
8010833d:	c3                   	ret    

8010833e <graphic_scroll_up>:

void graphic_scroll_up(int height){
8010833e:	55                   	push   %ebp
8010833f:	89 e5                	mov    %esp,%ebp
80108341:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108344:	8b 15 7c 6f 19 80    	mov    0x80196f7c,%edx
8010834a:	8b 45 08             	mov    0x8(%ebp),%eax
8010834d:	0f af c2             	imul   %edx,%eax
80108350:	c1 e0 02             	shl    $0x2,%eax
80108353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108356:	a1 70 6f 19 80       	mov    0x80196f70,%eax
8010835b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010835e:	29 d0                	sub    %edx,%eax
80108360:	8b 0d 6c 6f 19 80    	mov    0x80196f6c,%ecx
80108366:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108369:	01 ca                	add    %ecx,%edx
8010836b:	89 d1                	mov    %edx,%ecx
8010836d:	8b 15 6c 6f 19 80    	mov    0x80196f6c,%edx
80108373:	83 ec 04             	sub    $0x4,%esp
80108376:	50                   	push   %eax
80108377:	51                   	push   %ecx
80108378:	52                   	push   %edx
80108379:	e8 6c c8 ff ff       	call   80104bea <memmove>
8010837e:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
80108381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108384:	8b 0d 6c 6f 19 80    	mov    0x80196f6c,%ecx
8010838a:	8b 15 70 6f 19 80    	mov    0x80196f70,%edx
80108390:	01 ca                	add    %ecx,%edx
80108392:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80108395:	29 ca                	sub    %ecx,%edx
80108397:	83 ec 04             	sub    $0x4,%esp
8010839a:	50                   	push   %eax
8010839b:	6a 00                	push   $0x0
8010839d:	52                   	push   %edx
8010839e:	e8 88 c7 ff ff       	call   80104b2b <memset>
801083a3:	83 c4 10             	add    $0x10,%esp
}
801083a6:	90                   	nop
801083a7:	c9                   	leave  
801083a8:	c3                   	ret    

801083a9 <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
801083a9:	55                   	push   %ebp
801083aa:	89 e5                	mov    %esp,%ebp
801083ac:	53                   	push   %ebx
801083ad:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
801083b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801083b7:	e9 b1 00 00 00       	jmp    8010846d <font_render+0xc4>
    for(int j=14;j>-1;j--){
801083bc:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801083c3:	e9 97 00 00 00       	jmp    8010845f <font_render+0xb6>
      bin = (font_bin[index-0x20][i])&(1 << j);
801083c8:	8b 45 10             	mov    0x10(%ebp),%eax
801083cb:	83 e8 20             	sub    $0x20,%eax
801083ce:	6b d0 1e             	imul   $0x1e,%eax,%edx
801083d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d4:	01 d0                	add    %edx,%eax
801083d6:	0f b7 84 00 20 ac 10 	movzwl -0x7fef53e0(%eax,%eax,1),%eax
801083dd:	80 
801083de:	0f b7 d0             	movzwl %ax,%edx
801083e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e4:	bb 01 00 00 00       	mov    $0x1,%ebx
801083e9:	89 c1                	mov    %eax,%ecx
801083eb:	d3 e3                	shl    %cl,%ebx
801083ed:	89 d8                	mov    %ebx,%eax
801083ef:	21 d0                	and    %edx,%eax
801083f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
801083f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083f7:	ba 01 00 00 00       	mov    $0x1,%edx
801083fc:	89 c1                	mov    %eax,%ecx
801083fe:	d3 e2                	shl    %cl,%edx
80108400:	89 d0                	mov    %edx,%eax
80108402:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108405:	75 2b                	jne    80108432 <font_render+0x89>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
80108407:	8b 55 0c             	mov    0xc(%ebp),%edx
8010840a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840d:	01 c2                	add    %eax,%edx
8010840f:	b8 0e 00 00 00       	mov    $0xe,%eax
80108414:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108417:	89 c1                	mov    %eax,%ecx
80108419:	8b 45 08             	mov    0x8(%ebp),%eax
8010841c:	01 c8                	add    %ecx,%eax
8010841e:	83 ec 04             	sub    $0x4,%esp
80108421:	68 e0 f4 10 80       	push   $0x8010f4e0
80108426:	52                   	push   %edx
80108427:	50                   	push   %eax
80108428:	e8 be fe ff ff       	call   801082eb <graphic_draw_pixel>
8010842d:	83 c4 10             	add    $0x10,%esp
80108430:	eb 29                	jmp    8010845b <font_render+0xb2>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
80108432:	8b 55 0c             	mov    0xc(%ebp),%edx
80108435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108438:	01 c2                	add    %eax,%edx
8010843a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010843f:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108442:	89 c1                	mov    %eax,%ecx
80108444:	8b 45 08             	mov    0x8(%ebp),%eax
80108447:	01 c8                	add    %ecx,%eax
80108449:	83 ec 04             	sub    $0x4,%esp
8010844c:	68 80 6f 19 80       	push   $0x80196f80
80108451:	52                   	push   %edx
80108452:	50                   	push   %eax
80108453:	e8 93 fe ff ff       	call   801082eb <graphic_draw_pixel>
80108458:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
8010845b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
8010845f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108463:	0f 89 5f ff ff ff    	jns    801083c8 <font_render+0x1f>
  for(int i=0;i<30;i++){
80108469:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010846d:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
80108471:	0f 8e 45 ff ff ff    	jle    801083bc <font_render+0x13>
      }
    }
  }
}
80108477:	90                   	nop
80108478:	90                   	nop
80108479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010847c:	c9                   	leave  
8010847d:	c3                   	ret    

8010847e <font_render_string>:

void font_render_string(char *string,int row){
8010847e:	55                   	push   %ebp
8010847f:	89 e5                	mov    %esp,%ebp
80108481:	53                   	push   %ebx
80108482:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
80108485:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
8010848c:	eb 33                	jmp    801084c1 <font_render_string+0x43>
    font_render(i*15+2,row*30,string[i]);
8010848e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108491:	8b 45 08             	mov    0x8(%ebp),%eax
80108494:	01 d0                	add    %edx,%eax
80108496:	0f b6 00             	movzbl (%eax),%eax
80108499:	0f be c8             	movsbl %al,%ecx
8010849c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010849f:	6b d0 1e             	imul   $0x1e,%eax,%edx
801084a2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801084a5:	89 d8                	mov    %ebx,%eax
801084a7:	c1 e0 04             	shl    $0x4,%eax
801084aa:	29 d8                	sub    %ebx,%eax
801084ac:	83 c0 02             	add    $0x2,%eax
801084af:	83 ec 04             	sub    $0x4,%esp
801084b2:	51                   	push   %ecx
801084b3:	52                   	push   %edx
801084b4:	50                   	push   %eax
801084b5:	e8 ef fe ff ff       	call   801083a9 <font_render>
801084ba:	83 c4 10             	add    $0x10,%esp
    i++;
801084bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
801084c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801084c4:	8b 45 08             	mov    0x8(%ebp),%eax
801084c7:	01 d0                	add    %edx,%eax
801084c9:	0f b6 00             	movzbl (%eax),%eax
801084cc:	84 c0                	test   %al,%al
801084ce:	74 06                	je     801084d6 <font_render_string+0x58>
801084d0:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801084d4:	7e b8                	jle    8010848e <font_render_string+0x10>
  }
}
801084d6:	90                   	nop
801084d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084da:	c9                   	leave  
801084db:	c3                   	ret    

801084dc <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801084dc:	55                   	push   %ebp
801084dd:	89 e5                	mov    %esp,%ebp
801084df:	53                   	push   %ebx
801084e0:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801084e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084ea:	eb 6b                	jmp    80108557 <pci_init+0x7b>
    for(int j=0;j<32;j++){
801084ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801084f3:	eb 58                	jmp    8010854d <pci_init+0x71>
      for(int k=0;k<8;k++){
801084f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801084fc:	eb 45                	jmp    80108543 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
801084fe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108501:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108507:	83 ec 0c             	sub    $0xc,%esp
8010850a:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010850d:	53                   	push   %ebx
8010850e:	6a 00                	push   $0x0
80108510:	51                   	push   %ecx
80108511:	52                   	push   %edx
80108512:	50                   	push   %eax
80108513:	e8 b0 00 00 00       	call   801085c8 <pci_access_config>
80108518:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
8010851b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010851e:	0f b7 c0             	movzwl %ax,%eax
80108521:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108526:	74 17                	je     8010853f <pci_init+0x63>
        pci_init_device(i,j,k);
80108528:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010852b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010852e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108531:	83 ec 04             	sub    $0x4,%esp
80108534:	51                   	push   %ecx
80108535:	52                   	push   %edx
80108536:	50                   	push   %eax
80108537:	e8 37 01 00 00       	call   80108673 <pci_init_device>
8010853c:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
8010853f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108543:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108547:	7e b5                	jle    801084fe <pci_init+0x22>
    for(int j=0;j<32;j++){
80108549:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010854d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80108551:	7e a2                	jle    801084f5 <pci_init+0x19>
  for(int i=0;i<256;i++){
80108553:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108557:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010855e:	7e 8c                	jle    801084ec <pci_init+0x10>
      }
      }
    }
  }
}
80108560:	90                   	nop
80108561:	90                   	nop
80108562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108565:	c9                   	leave  
80108566:	c3                   	ret    

80108567 <pci_write_config>:

void pci_write_config(uint config){
80108567:	55                   	push   %ebp
80108568:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
8010856a:	8b 45 08             	mov    0x8(%ebp),%eax
8010856d:	ba f8 0c 00 00       	mov    $0xcf8,%edx
80108572:	89 c0                	mov    %eax,%eax
80108574:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108575:	90                   	nop
80108576:	5d                   	pop    %ebp
80108577:	c3                   	ret    

80108578 <pci_write_data>:

void pci_write_data(uint config){
80108578:	55                   	push   %ebp
80108579:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
8010857b:	8b 45 08             	mov    0x8(%ebp),%eax
8010857e:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108583:	89 c0                	mov    %eax,%eax
80108585:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108586:	90                   	nop
80108587:	5d                   	pop    %ebp
80108588:	c3                   	ret    

80108589 <pci_read_config>:
uint pci_read_config(){
80108589:	55                   	push   %ebp
8010858a:	89 e5                	mov    %esp,%ebp
8010858c:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
8010858f:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80108594:	ed                   	in     (%dx),%eax
80108595:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
80108598:	83 ec 0c             	sub    $0xc,%esp
8010859b:	68 c8 00 00 00       	push   $0xc8
801085a0:	e8 77 a5 ff ff       	call   80102b1c <microdelay>
801085a5:	83 c4 10             	add    $0x10,%esp
  return data;
801085a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801085ab:	c9                   	leave  
801085ac:	c3                   	ret    

801085ad <pci_test>:


void pci_test(){
801085ad:	55                   	push   %ebp
801085ae:	89 e5                	mov    %esp,%ebp
801085b0:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801085b3:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801085ba:	ff 75 fc             	push   -0x4(%ebp)
801085bd:	e8 a5 ff ff ff       	call   80108567 <pci_write_config>
801085c2:	83 c4 04             	add    $0x4,%esp
}
801085c5:	90                   	nop
801085c6:	c9                   	leave  
801085c7:	c3                   	ret    

801085c8 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801085c8:	55                   	push   %ebp
801085c9:	89 e5                	mov    %esp,%ebp
801085cb:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801085ce:	8b 45 08             	mov    0x8(%ebp),%eax
801085d1:	c1 e0 10             	shl    $0x10,%eax
801085d4:	25 00 00 ff 00       	and    $0xff0000,%eax
801085d9:	89 c2                	mov    %eax,%edx
801085db:	8b 45 0c             	mov    0xc(%ebp),%eax
801085de:	c1 e0 0b             	shl    $0xb,%eax
801085e1:	0f b7 c0             	movzwl %ax,%eax
801085e4:	09 c2                	or     %eax,%edx
801085e6:	8b 45 10             	mov    0x10(%ebp),%eax
801085e9:	c1 e0 08             	shl    $0x8,%eax
801085ec:	25 00 07 00 00       	and    $0x700,%eax
801085f1:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801085f3:	8b 45 14             	mov    0x14(%ebp),%eax
801085f6:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801085fb:	09 d0                	or     %edx,%eax
801085fd:	0d 00 00 00 80       	or     $0x80000000,%eax
80108602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108605:	ff 75 f4             	push   -0xc(%ebp)
80108608:	e8 5a ff ff ff       	call   80108567 <pci_write_config>
8010860d:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
80108610:	e8 74 ff ff ff       	call   80108589 <pci_read_config>
80108615:	8b 55 18             	mov    0x18(%ebp),%edx
80108618:	89 02                	mov    %eax,(%edx)
}
8010861a:	90                   	nop
8010861b:	c9                   	leave  
8010861c:	c3                   	ret    

8010861d <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
8010861d:	55                   	push   %ebp
8010861e:	89 e5                	mov    %esp,%ebp
80108620:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108623:	8b 45 08             	mov    0x8(%ebp),%eax
80108626:	c1 e0 10             	shl    $0x10,%eax
80108629:	25 00 00 ff 00       	and    $0xff0000,%eax
8010862e:	89 c2                	mov    %eax,%edx
80108630:	8b 45 0c             	mov    0xc(%ebp),%eax
80108633:	c1 e0 0b             	shl    $0xb,%eax
80108636:	0f b7 c0             	movzwl %ax,%eax
80108639:	09 c2                	or     %eax,%edx
8010863b:	8b 45 10             	mov    0x10(%ebp),%eax
8010863e:	c1 e0 08             	shl    $0x8,%eax
80108641:	25 00 07 00 00       	and    $0x700,%eax
80108646:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108648:	8b 45 14             	mov    0x14(%ebp),%eax
8010864b:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108650:	09 d0                	or     %edx,%eax
80108652:	0d 00 00 00 80       	or     $0x80000000,%eax
80108657:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
8010865a:	ff 75 fc             	push   -0x4(%ebp)
8010865d:	e8 05 ff ff ff       	call   80108567 <pci_write_config>
80108662:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
80108665:	ff 75 18             	push   0x18(%ebp)
80108668:	e8 0b ff ff ff       	call   80108578 <pci_write_data>
8010866d:	83 c4 04             	add    $0x4,%esp
}
80108670:	90                   	nop
80108671:	c9                   	leave  
80108672:	c3                   	ret    

80108673 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
80108673:	55                   	push   %ebp
80108674:	89 e5                	mov    %esp,%ebp
80108676:	53                   	push   %ebx
80108677:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
8010867a:	8b 45 08             	mov    0x8(%ebp),%eax
8010867d:	a2 84 6f 19 80       	mov    %al,0x80196f84
  dev.device_num = device_num;
80108682:	8b 45 0c             	mov    0xc(%ebp),%eax
80108685:	a2 85 6f 19 80       	mov    %al,0x80196f85
  dev.function_num = function_num;
8010868a:	8b 45 10             	mov    0x10(%ebp),%eax
8010868d:	a2 86 6f 19 80       	mov    %al,0x80196f86
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
80108692:	ff 75 10             	push   0x10(%ebp)
80108695:	ff 75 0c             	push   0xc(%ebp)
80108698:	ff 75 08             	push   0x8(%ebp)
8010869b:	68 64 c2 10 80       	push   $0x8010c264
801086a0:	e8 4f 7d ff ff       	call   801003f4 <cprintf>
801086a5:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801086a8:	83 ec 0c             	sub    $0xc,%esp
801086ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801086ae:	50                   	push   %eax
801086af:	6a 00                	push   $0x0
801086b1:	ff 75 10             	push   0x10(%ebp)
801086b4:	ff 75 0c             	push   0xc(%ebp)
801086b7:	ff 75 08             	push   0x8(%ebp)
801086ba:	e8 09 ff ff ff       	call   801085c8 <pci_access_config>
801086bf:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801086c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c5:	c1 e8 10             	shr    $0x10,%eax
801086c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801086cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086ce:	25 ff ff 00 00       	and    $0xffff,%eax
801086d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801086d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d9:	a3 88 6f 19 80       	mov    %eax,0x80196f88
  dev.vendor_id = vendor_id;
801086de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e1:	a3 8c 6f 19 80       	mov    %eax,0x80196f8c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
801086e6:	83 ec 04             	sub    $0x4,%esp
801086e9:	ff 75 f0             	push   -0x10(%ebp)
801086ec:	ff 75 f4             	push   -0xc(%ebp)
801086ef:	68 98 c2 10 80       	push   $0x8010c298
801086f4:	e8 fb 7c ff ff       	call   801003f4 <cprintf>
801086f9:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
801086fc:	83 ec 0c             	sub    $0xc,%esp
801086ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108702:	50                   	push   %eax
80108703:	6a 08                	push   $0x8
80108705:	ff 75 10             	push   0x10(%ebp)
80108708:	ff 75 0c             	push   0xc(%ebp)
8010870b:	ff 75 08             	push   0x8(%ebp)
8010870e:	e8 b5 fe ff ff       	call   801085c8 <pci_access_config>
80108713:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108716:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108719:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010871c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010871f:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108722:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108725:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108728:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010872b:	0f b6 c0             	movzbl %al,%eax
8010872e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108731:	c1 eb 18             	shr    $0x18,%ebx
80108734:	83 ec 0c             	sub    $0xc,%esp
80108737:	51                   	push   %ecx
80108738:	52                   	push   %edx
80108739:	50                   	push   %eax
8010873a:	53                   	push   %ebx
8010873b:	68 bc c2 10 80       	push   $0x8010c2bc
80108740:	e8 af 7c ff ff       	call   801003f4 <cprintf>
80108745:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108748:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010874b:	c1 e8 18             	shr    $0x18,%eax
8010874e:	a2 90 6f 19 80       	mov    %al,0x80196f90
  dev.sub_class = (data>>16)&0xFF;
80108753:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108756:	c1 e8 10             	shr    $0x10,%eax
80108759:	a2 91 6f 19 80       	mov    %al,0x80196f91
  dev.interface = (data>>8)&0xFF;
8010875e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108761:	c1 e8 08             	shr    $0x8,%eax
80108764:	a2 92 6f 19 80       	mov    %al,0x80196f92
  dev.revision_id = data&0xFF;
80108769:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010876c:	a2 93 6f 19 80       	mov    %al,0x80196f93
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
80108771:	83 ec 0c             	sub    $0xc,%esp
80108774:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108777:	50                   	push   %eax
80108778:	6a 10                	push   $0x10
8010877a:	ff 75 10             	push   0x10(%ebp)
8010877d:	ff 75 0c             	push   0xc(%ebp)
80108780:	ff 75 08             	push   0x8(%ebp)
80108783:	e8 40 fe ff ff       	call   801085c8 <pci_access_config>
80108788:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
8010878b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010878e:	a3 94 6f 19 80       	mov    %eax,0x80196f94
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
80108793:	83 ec 0c             	sub    $0xc,%esp
80108796:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108799:	50                   	push   %eax
8010879a:	6a 14                	push   $0x14
8010879c:	ff 75 10             	push   0x10(%ebp)
8010879f:	ff 75 0c             	push   0xc(%ebp)
801087a2:	ff 75 08             	push   0x8(%ebp)
801087a5:	e8 1e fe ff ff       	call   801085c8 <pci_access_config>
801087aa:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801087ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087b0:	a3 98 6f 19 80       	mov    %eax,0x80196f98
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
801087b5:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801087bc:	75 5a                	jne    80108818 <pci_init_device+0x1a5>
801087be:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801087c5:	75 51                	jne    80108818 <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801087c7:	83 ec 0c             	sub    $0xc,%esp
801087ca:	68 01 c3 10 80       	push   $0x8010c301
801087cf:	e8 20 7c ff ff       	call   801003f4 <cprintf>
801087d4:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
801087d7:	83 ec 0c             	sub    $0xc,%esp
801087da:	8d 45 ec             	lea    -0x14(%ebp),%eax
801087dd:	50                   	push   %eax
801087de:	68 f0 00 00 00       	push   $0xf0
801087e3:	ff 75 10             	push   0x10(%ebp)
801087e6:	ff 75 0c             	push   0xc(%ebp)
801087e9:	ff 75 08             	push   0x8(%ebp)
801087ec:	e8 d7 fd ff ff       	call   801085c8 <pci_access_config>
801087f1:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
801087f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087f7:	83 ec 08             	sub    $0x8,%esp
801087fa:	50                   	push   %eax
801087fb:	68 1b c3 10 80       	push   $0x8010c31b
80108800:	e8 ef 7b ff ff       	call   801003f4 <cprintf>
80108805:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108808:	83 ec 0c             	sub    $0xc,%esp
8010880b:	68 84 6f 19 80       	push   $0x80196f84
80108810:	e8 09 00 00 00       	call   8010881e <i8254_init>
80108815:	83 c4 10             	add    $0x10,%esp
  }
}
80108818:	90                   	nop
80108819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010881c:	c9                   	leave  
8010881d:	c3                   	ret    

8010881e <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
8010881e:	55                   	push   %ebp
8010881f:	89 e5                	mov    %esp,%ebp
80108821:	53                   	push   %ebx
80108822:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108825:	8b 45 08             	mov    0x8(%ebp),%eax
80108828:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010882c:	0f b6 c8             	movzbl %al,%ecx
8010882f:	8b 45 08             	mov    0x8(%ebp),%eax
80108832:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108836:	0f b6 d0             	movzbl %al,%edx
80108839:	8b 45 08             	mov    0x8(%ebp),%eax
8010883c:	0f b6 00             	movzbl (%eax),%eax
8010883f:	0f b6 c0             	movzbl %al,%eax
80108842:	83 ec 0c             	sub    $0xc,%esp
80108845:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108848:	53                   	push   %ebx
80108849:	6a 04                	push   $0x4
8010884b:	51                   	push   %ecx
8010884c:	52                   	push   %edx
8010884d:	50                   	push   %eax
8010884e:	e8 75 fd ff ff       	call   801085c8 <pci_access_config>
80108853:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108856:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108859:	83 c8 04             	or     $0x4,%eax
8010885c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
8010885f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108862:	8b 45 08             	mov    0x8(%ebp),%eax
80108865:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108869:	0f b6 c8             	movzbl %al,%ecx
8010886c:	8b 45 08             	mov    0x8(%ebp),%eax
8010886f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108873:	0f b6 d0             	movzbl %al,%edx
80108876:	8b 45 08             	mov    0x8(%ebp),%eax
80108879:	0f b6 00             	movzbl (%eax),%eax
8010887c:	0f b6 c0             	movzbl %al,%eax
8010887f:	83 ec 0c             	sub    $0xc,%esp
80108882:	53                   	push   %ebx
80108883:	6a 04                	push   $0x4
80108885:	51                   	push   %ecx
80108886:	52                   	push   %edx
80108887:	50                   	push   %eax
80108888:	e8 90 fd ff ff       	call   8010861d <pci_write_config_register>
8010888d:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
80108890:	8b 45 08             	mov    0x8(%ebp),%eax
80108893:	8b 40 10             	mov    0x10(%eax),%eax
80108896:	05 00 00 00 40       	add    $0x40000000,%eax
8010889b:	a3 9c 6f 19 80       	mov    %eax,0x80196f9c
  uint *ctrl = (uint *)base_addr;
801088a0:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
801088a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801088a8:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
801088ad:	05 d8 00 00 00       	add    $0xd8,%eax
801088b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
801088b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088b8:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801088be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c1:	8b 00                	mov    (%eax),%eax
801088c3:	0d 00 00 00 04       	or     $0x4000000,%eax
801088c8:	89 c2                	mov    %eax,%edx
801088ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088cd:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801088cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088d2:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
801088d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088db:	8b 00                	mov    (%eax),%eax
801088dd:	83 c8 40             	or     $0x40,%eax
801088e0:	89 c2                	mov    %eax,%edx
801088e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e5:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
801088e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ea:	8b 10                	mov    (%eax),%edx
801088ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ef:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
801088f1:	83 ec 0c             	sub    $0xc,%esp
801088f4:	68 30 c3 10 80       	push   $0x8010c330
801088f9:	e8 f6 7a ff ff       	call   801003f4 <cprintf>
801088fe:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108901:	e8 7f 9e ff ff       	call   80102785 <kalloc>
80108906:	a3 a8 6f 19 80       	mov    %eax,0x80196fa8
  *intr_addr = 0;
8010890b:	a1 a8 6f 19 80       	mov    0x80196fa8,%eax
80108910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108916:	a1 a8 6f 19 80       	mov    0x80196fa8,%eax
8010891b:	83 ec 08             	sub    $0x8,%esp
8010891e:	50                   	push   %eax
8010891f:	68 52 c3 10 80       	push   $0x8010c352
80108924:	e8 cb 7a ff ff       	call   801003f4 <cprintf>
80108929:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
8010892c:	e8 50 00 00 00       	call   80108981 <i8254_init_recv>
  i8254_init_send();
80108931:	e8 69 03 00 00       	call   80108c9f <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108936:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010893d:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108940:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108947:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
8010894a:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108951:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108954:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010895b:	0f b6 c0             	movzbl %al,%eax
8010895e:	83 ec 0c             	sub    $0xc,%esp
80108961:	53                   	push   %ebx
80108962:	51                   	push   %ecx
80108963:	52                   	push   %edx
80108964:	50                   	push   %eax
80108965:	68 60 c3 10 80       	push   $0x8010c360
8010896a:	e8 85 7a ff ff       	call   801003f4 <cprintf>
8010896f:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108972:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
8010897b:	90                   	nop
8010897c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010897f:	c9                   	leave  
80108980:	c3                   	ret    

80108981 <i8254_init_recv>:

void i8254_init_recv(){
80108981:	55                   	push   %ebp
80108982:	89 e5                	mov    %esp,%ebp
80108984:	57                   	push   %edi
80108985:	56                   	push   %esi
80108986:	53                   	push   %ebx
80108987:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
8010898a:	83 ec 0c             	sub    $0xc,%esp
8010898d:	6a 00                	push   $0x0
8010898f:	e8 e8 04 00 00       	call   80108e7c <i8254_read_eeprom>
80108994:	83 c4 10             	add    $0x10,%esp
80108997:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
8010899a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010899d:	a2 a0 6f 19 80       	mov    %al,0x80196fa0
  mac_addr[1] = data_l>>8;
801089a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801089a5:	c1 e8 08             	shr    $0x8,%eax
801089a8:	a2 a1 6f 19 80       	mov    %al,0x80196fa1
  uint data_m = i8254_read_eeprom(0x1);
801089ad:	83 ec 0c             	sub    $0xc,%esp
801089b0:	6a 01                	push   $0x1
801089b2:	e8 c5 04 00 00       	call   80108e7c <i8254_read_eeprom>
801089b7:	83 c4 10             	add    $0x10,%esp
801089ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801089bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801089c0:	a2 a2 6f 19 80       	mov    %al,0x80196fa2
  mac_addr[3] = data_m>>8;
801089c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801089c8:	c1 e8 08             	shr    $0x8,%eax
801089cb:	a2 a3 6f 19 80       	mov    %al,0x80196fa3
  uint data_h = i8254_read_eeprom(0x2);
801089d0:	83 ec 0c             	sub    $0xc,%esp
801089d3:	6a 02                	push   $0x2
801089d5:	e8 a2 04 00 00       	call   80108e7c <i8254_read_eeprom>
801089da:	83 c4 10             	add    $0x10,%esp
801089dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
801089e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089e3:	a2 a4 6f 19 80       	mov    %al,0x80196fa4
  mac_addr[5] = data_h>>8;
801089e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801089eb:	c1 e8 08             	shr    $0x8,%eax
801089ee:	a2 a5 6f 19 80       	mov    %al,0x80196fa5
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
801089f3:	0f b6 05 a5 6f 19 80 	movzbl 0x80196fa5,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
801089fa:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
801089fd:	0f b6 05 a4 6f 19 80 	movzbl 0x80196fa4,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a04:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108a07:	0f b6 05 a3 6f 19 80 	movzbl 0x80196fa3,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a0e:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108a11:	0f b6 05 a2 6f 19 80 	movzbl 0x80196fa2,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a18:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108a1b:	0f b6 05 a1 6f 19 80 	movzbl 0x80196fa1,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a22:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108a25:	0f b6 05 a0 6f 19 80 	movzbl 0x80196fa0,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108a2c:	0f b6 c0             	movzbl %al,%eax
80108a2f:	83 ec 04             	sub    $0x4,%esp
80108a32:	57                   	push   %edi
80108a33:	56                   	push   %esi
80108a34:	53                   	push   %ebx
80108a35:	51                   	push   %ecx
80108a36:	52                   	push   %edx
80108a37:	50                   	push   %eax
80108a38:	68 78 c3 10 80       	push   $0x8010c378
80108a3d:	e8 b2 79 ff ff       	call   801003f4 <cprintf>
80108a42:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108a45:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108a4a:	05 00 54 00 00       	add    $0x5400,%eax
80108a4f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108a52:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108a57:	05 04 54 00 00       	add    $0x5404,%eax
80108a5c:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108a62:	c1 e0 10             	shl    $0x10,%eax
80108a65:	0b 45 d8             	or     -0x28(%ebp),%eax
80108a68:	89 c2                	mov    %eax,%edx
80108a6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108a6d:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108a6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108a72:	0d 00 00 00 80       	or     $0x80000000,%eax
80108a77:	89 c2                	mov    %eax,%edx
80108a79:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108a7c:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108a7e:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108a83:	05 00 52 00 00       	add    $0x5200,%eax
80108a88:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108a8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108a92:	eb 19                	jmp    80108aad <i8254_init_recv+0x12c>
    mta[i] = 0;
80108a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a9e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108aa1:	01 d0                	add    %edx,%eax
80108aa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108aa9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108aad:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108ab1:	7e e1                	jle    80108a94 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108ab3:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ab8:	05 d0 00 00 00       	add    $0xd0,%eax
80108abd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108ac0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108ac3:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108ac9:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ace:	05 c8 00 00 00       	add    $0xc8,%eax
80108ad3:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108ad6:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108ad9:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108adf:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ae4:	05 28 28 00 00       	add    $0x2828,%eax
80108ae9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108aec:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108aef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108af5:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108afa:	05 00 01 00 00       	add    $0x100,%eax
80108aff:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108b02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108b05:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108b0b:	e8 75 9c ff ff       	call   80102785 <kalloc>
80108b10:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108b13:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b18:	05 00 28 00 00       	add    $0x2800,%eax
80108b1d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108b20:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b25:	05 04 28 00 00       	add    $0x2804,%eax
80108b2a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108b2d:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b32:	05 08 28 00 00       	add    $0x2808,%eax
80108b37:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108b3a:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b3f:	05 10 28 00 00       	add    $0x2810,%eax
80108b44:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108b47:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108b4c:	05 18 28 00 00       	add    $0x2818,%eax
80108b51:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108b54:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108b57:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108b5d:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108b60:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108b62:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108b6b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108b6e:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108b74:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108b7d:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108b80:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108b86:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108b89:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108b8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108b93:	eb 73                	jmp    80108c08 <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
80108b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b98:	c1 e0 04             	shl    $0x4,%eax
80108b9b:	89 c2                	mov    %eax,%edx
80108b9d:	8b 45 98             	mov    -0x68(%ebp),%eax
80108ba0:	01 d0                	add    %edx,%eax
80108ba2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bac:	c1 e0 04             	shl    $0x4,%eax
80108baf:	89 c2                	mov    %eax,%edx
80108bb1:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bb4:	01 d0                	add    %edx,%eax
80108bb6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bbf:	c1 e0 04             	shl    $0x4,%eax
80108bc2:	89 c2                	mov    %eax,%edx
80108bc4:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bc7:	01 d0                	add    %edx,%eax
80108bc9:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bd2:	c1 e0 04             	shl    $0x4,%eax
80108bd5:	89 c2                	mov    %eax,%edx
80108bd7:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bda:	01 d0                	add    %edx,%eax
80108bdc:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108be3:	c1 e0 04             	shl    $0x4,%eax
80108be6:	89 c2                	mov    %eax,%edx
80108be8:	8b 45 98             	mov    -0x68(%ebp),%eax
80108beb:	01 d0                	add    %edx,%eax
80108bed:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bf4:	c1 e0 04             	shl    $0x4,%eax
80108bf7:	89 c2                	mov    %eax,%edx
80108bf9:	8b 45 98             	mov    -0x68(%ebp),%eax
80108bfc:	01 d0                	add    %edx,%eax
80108bfe:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108c04:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108c08:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108c0f:	7e 84                	jle    80108b95 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108c11:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108c18:	eb 57                	jmp    80108c71 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108c1a:	e8 66 9b ff ff       	call   80102785 <kalloc>
80108c1f:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108c22:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108c26:	75 12                	jne    80108c3a <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108c28:	83 ec 0c             	sub    $0xc,%esp
80108c2b:	68 98 c3 10 80       	push   $0x8010c398
80108c30:	e8 bf 77 ff ff       	call   801003f4 <cprintf>
80108c35:	83 c4 10             	add    $0x10,%esp
      break;
80108c38:	eb 3d                	jmp    80108c77 <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108c3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c3d:	c1 e0 04             	shl    $0x4,%eax
80108c40:	89 c2                	mov    %eax,%edx
80108c42:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c45:	01 d0                	add    %edx,%eax
80108c47:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108c4a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c50:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c55:	83 c0 01             	add    $0x1,%eax
80108c58:	c1 e0 04             	shl    $0x4,%eax
80108c5b:	89 c2                	mov    %eax,%edx
80108c5d:	8b 45 98             	mov    -0x68(%ebp),%eax
80108c60:	01 d0                	add    %edx,%eax
80108c62:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108c65:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108c6b:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108c6d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108c71:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108c75:	7e a3                	jle    80108c1a <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108c77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108c7a:	8b 00                	mov    (%eax),%eax
80108c7c:	83 c8 02             	or     $0x2,%eax
80108c7f:	89 c2                	mov    %eax,%edx
80108c81:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108c84:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108c86:	83 ec 0c             	sub    $0xc,%esp
80108c89:	68 b8 c3 10 80       	push   $0x8010c3b8
80108c8e:	e8 61 77 ff ff       	call   801003f4 <cprintf>
80108c93:	83 c4 10             	add    $0x10,%esp
}
80108c96:	90                   	nop
80108c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c9a:	5b                   	pop    %ebx
80108c9b:	5e                   	pop    %esi
80108c9c:	5f                   	pop    %edi
80108c9d:	5d                   	pop    %ebp
80108c9e:	c3                   	ret    

80108c9f <i8254_init_send>:

void i8254_init_send(){
80108c9f:	55                   	push   %ebp
80108ca0:	89 e5                	mov    %esp,%ebp
80108ca2:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108ca5:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108caa:	05 28 38 00 00       	add    $0x3828,%eax
80108caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cb5:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108cbb:	e8 c5 9a ff ff       	call   80102785 <kalloc>
80108cc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108cc3:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108cc8:	05 00 38 00 00       	add    $0x3800,%eax
80108ccd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108cd0:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108cd5:	05 04 38 00 00       	add    $0x3804,%eax
80108cda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108cdd:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ce2:	05 08 38 00 00       	add    $0x3808,%eax
80108ce7:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ced:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108cf6:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108d01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d04:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108d0a:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d0f:	05 10 38 00 00       	add    $0x3810,%eax
80108d14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108d17:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108d1c:	05 18 38 00 00       	add    $0x3818,%eax
80108d21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108d24:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108d2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d39:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108d3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108d43:	e9 82 00 00 00       	jmp    80108dca <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4b:	c1 e0 04             	shl    $0x4,%eax
80108d4e:	89 c2                	mov    %eax,%edx
80108d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d53:	01 d0                	add    %edx,%eax
80108d55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5f:	c1 e0 04             	shl    $0x4,%eax
80108d62:	89 c2                	mov    %eax,%edx
80108d64:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d67:	01 d0                	add    %edx,%eax
80108d69:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d72:	c1 e0 04             	shl    $0x4,%eax
80108d75:	89 c2                	mov    %eax,%edx
80108d77:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d7a:	01 d0                	add    %edx,%eax
80108d7c:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d83:	c1 e0 04             	shl    $0x4,%eax
80108d86:	89 c2                	mov    %eax,%edx
80108d88:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d8b:	01 d0                	add    %edx,%eax
80108d8d:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d94:	c1 e0 04             	shl    $0x4,%eax
80108d97:	89 c2                	mov    %eax,%edx
80108d99:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108d9c:	01 d0                	add    %edx,%eax
80108d9e:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da5:	c1 e0 04             	shl    $0x4,%eax
80108da8:	89 c2                	mov    %eax,%edx
80108daa:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108dad:	01 d0                	add    %edx,%eax
80108daf:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db6:	c1 e0 04             	shl    $0x4,%eax
80108db9:	89 c2                	mov    %eax,%edx
80108dbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108dbe:	01 d0                	add    %edx,%eax
80108dc0:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108dc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108dca:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108dd1:	0f 8e 71 ff ff ff    	jle    80108d48 <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108dd7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108dde:	eb 57                	jmp    80108e37 <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108de0:	e8 a0 99 ff ff       	call   80102785 <kalloc>
80108de5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108de8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108dec:	75 12                	jne    80108e00 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108dee:	83 ec 0c             	sub    $0xc,%esp
80108df1:	68 98 c3 10 80       	push   $0x8010c398
80108df6:	e8 f9 75 ff ff       	call   801003f4 <cprintf>
80108dfb:	83 c4 10             	add    $0x10,%esp
      break;
80108dfe:	eb 3d                	jmp    80108e3d <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e03:	c1 e0 04             	shl    $0x4,%eax
80108e06:	89 c2                	mov    %eax,%edx
80108e08:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e0b:	01 d0                	add    %edx,%eax
80108e0d:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108e10:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108e16:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e1b:	83 c0 01             	add    $0x1,%eax
80108e1e:	c1 e0 04             	shl    $0x4,%eax
80108e21:	89 c2                	mov    %eax,%edx
80108e23:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e26:	01 d0                	add    %edx,%eax
80108e28:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108e2b:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108e31:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108e33:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108e37:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108e3b:	7e a3                	jle    80108de0 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108e3d:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108e42:	05 00 04 00 00       	add    $0x400,%eax
80108e47:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108e4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108e4d:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108e53:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108e58:	05 10 04 00 00       	add    $0x410,%eax
80108e5d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108e60:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108e63:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108e69:	83 ec 0c             	sub    $0xc,%esp
80108e6c:	68 d8 c3 10 80       	push   $0x8010c3d8
80108e71:	e8 7e 75 ff ff       	call   801003f4 <cprintf>
80108e76:	83 c4 10             	add    $0x10,%esp

}
80108e79:	90                   	nop
80108e7a:	c9                   	leave  
80108e7b:	c3                   	ret    

80108e7c <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108e7c:	55                   	push   %ebp
80108e7d:	89 e5                	mov    %esp,%ebp
80108e7f:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108e82:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108e87:	83 c0 14             	add    $0x14,%eax
80108e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80108e90:	c1 e0 08             	shl    $0x8,%eax
80108e93:	0f b7 c0             	movzwl %ax,%eax
80108e96:	83 c8 01             	or     $0x1,%eax
80108e99:	89 c2                	mov    %eax,%edx
80108e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e9e:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108ea0:	83 ec 0c             	sub    $0xc,%esp
80108ea3:	68 f8 c3 10 80       	push   $0x8010c3f8
80108ea8:	e8 47 75 ff ff       	call   801003f4 <cprintf>
80108ead:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb3:	8b 00                	mov    (%eax),%eax
80108eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ebb:	83 e0 10             	and    $0x10,%eax
80108ebe:	85 c0                	test   %eax,%eax
80108ec0:	75 02                	jne    80108ec4 <i8254_read_eeprom+0x48>
  while(1){
80108ec2:	eb dc                	jmp    80108ea0 <i8254_read_eeprom+0x24>
      break;
80108ec4:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec8:	8b 00                	mov    (%eax),%eax
80108eca:	c1 e8 10             	shr    $0x10,%eax
}
80108ecd:	c9                   	leave  
80108ece:	c3                   	ret    

80108ecf <i8254_recv>:
void i8254_recv(){
80108ecf:	55                   	push   %ebp
80108ed0:	89 e5                	mov    %esp,%ebp
80108ed2:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108ed5:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108eda:	05 10 28 00 00       	add    $0x2810,%eax
80108edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108ee2:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ee7:	05 18 28 00 00       	add    $0x2818,%eax
80108eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108eef:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108ef4:	05 00 28 00 00       	add    $0x2800,%eax
80108ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eff:	8b 00                	mov    (%eax),%eax
80108f01:	05 00 00 00 80       	add    $0x80000000,%eax
80108f06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f0c:	8b 10                	mov    (%eax),%edx
80108f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f11:	8b 08                	mov    (%eax),%ecx
80108f13:	89 d0                	mov    %edx,%eax
80108f15:	29 c8                	sub    %ecx,%eax
80108f17:	25 ff 00 00 00       	and    $0xff,%eax
80108f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108f1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108f23:	7e 37                	jle    80108f5c <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f28:	8b 00                	mov    (%eax),%eax
80108f2a:	c1 e0 04             	shl    $0x4,%eax
80108f2d:	89 c2                	mov    %eax,%edx
80108f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f32:	01 d0                	add    %edx,%eax
80108f34:	8b 00                	mov    (%eax),%eax
80108f36:	05 00 00 00 80       	add    $0x80000000,%eax
80108f3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f41:	8b 00                	mov    (%eax),%eax
80108f43:	83 c0 01             	add    $0x1,%eax
80108f46:	0f b6 d0             	movzbl %al,%edx
80108f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f4c:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108f4e:	83 ec 0c             	sub    $0xc,%esp
80108f51:	ff 75 e0             	push   -0x20(%ebp)
80108f54:	e8 15 09 00 00       	call   8010986e <eth_proc>
80108f59:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f5f:	8b 10                	mov    (%eax),%edx
80108f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f64:	8b 00                	mov    (%eax),%eax
80108f66:	39 c2                	cmp    %eax,%edx
80108f68:	75 9f                	jne    80108f09 <i8254_recv+0x3a>
      (*rdt)--;
80108f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f6d:	8b 00                	mov    (%eax),%eax
80108f6f:	8d 50 ff             	lea    -0x1(%eax),%edx
80108f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f75:	89 10                	mov    %edx,(%eax)
  while(1){
80108f77:	eb 90                	jmp    80108f09 <i8254_recv+0x3a>

80108f79 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108f79:	55                   	push   %ebp
80108f7a:	89 e5                	mov    %esp,%ebp
80108f7c:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108f7f:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108f84:	05 10 38 00 00       	add    $0x3810,%eax
80108f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108f8c:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108f91:	05 18 38 00 00       	add    $0x3818,%eax
80108f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108f99:	a1 9c 6f 19 80       	mov    0x80196f9c,%eax
80108f9e:	05 00 38 00 00       	add    $0x3800,%eax
80108fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fa9:	8b 00                	mov    (%eax),%eax
80108fab:	05 00 00 00 80       	add    $0x80000000,%eax
80108fb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fb6:	8b 10                	mov    (%eax),%edx
80108fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fbb:	8b 08                	mov    (%eax),%ecx
80108fbd:	89 d0                	mov    %edx,%eax
80108fbf:	29 c8                	sub    %ecx,%eax
80108fc1:	0f b6 d0             	movzbl %al,%edx
80108fc4:	b8 00 01 00 00       	mov    $0x100,%eax
80108fc9:	29 d0                	sub    %edx,%eax
80108fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fd1:	8b 00                	mov    (%eax),%eax
80108fd3:	25 ff 00 00 00       	and    $0xff,%eax
80108fd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108fdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108fdf:	0f 8e a8 00 00 00    	jle    8010908d <i8254_send+0x114>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80108fe8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108feb:	89 d1                	mov    %edx,%ecx
80108fed:	c1 e1 04             	shl    $0x4,%ecx
80108ff0:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108ff3:	01 ca                	add    %ecx,%edx
80108ff5:	8b 12                	mov    (%edx),%edx
80108ff7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108ffd:	83 ec 04             	sub    $0x4,%esp
80109000:	ff 75 0c             	push   0xc(%ebp)
80109003:	50                   	push   %eax
80109004:	52                   	push   %edx
80109005:	e8 e0 bb ff ff       	call   80104bea <memmove>
8010900a:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
8010900d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109010:	c1 e0 04             	shl    $0x4,%eax
80109013:	89 c2                	mov    %eax,%edx
80109015:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109018:	01 d0                	add    %edx,%eax
8010901a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010901d:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80109021:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109024:	c1 e0 04             	shl    $0x4,%eax
80109027:	89 c2                	mov    %eax,%edx
80109029:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010902c:	01 d0                	add    %edx,%eax
8010902e:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80109032:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109035:	c1 e0 04             	shl    $0x4,%eax
80109038:	89 c2                	mov    %eax,%edx
8010903a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010903d:	01 d0                	add    %edx,%eax
8010903f:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80109043:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109046:	c1 e0 04             	shl    $0x4,%eax
80109049:	89 c2                	mov    %eax,%edx
8010904b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010904e:	01 d0                	add    %edx,%eax
80109050:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80109054:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109057:	c1 e0 04             	shl    $0x4,%eax
8010905a:	89 c2                	mov    %eax,%edx
8010905c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010905f:	01 d0                	add    %edx,%eax
80109061:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80109067:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010906a:	c1 e0 04             	shl    $0x4,%eax
8010906d:	89 c2                	mov    %eax,%edx
8010906f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109072:	01 d0                	add    %edx,%eax
80109074:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80109078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010907b:	8b 00                	mov    (%eax),%eax
8010907d:	83 c0 01             	add    $0x1,%eax
80109080:	0f b6 d0             	movzbl %al,%edx
80109083:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109086:	89 10                	mov    %edx,(%eax)
    return len;
80109088:	8b 45 0c             	mov    0xc(%ebp),%eax
8010908b:	eb 05                	jmp    80109092 <i8254_send+0x119>
  }else{
    return -1;
8010908d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80109092:	c9                   	leave  
80109093:	c3                   	ret    

80109094 <i8254_intr>:

void i8254_intr(){
80109094:	55                   	push   %ebp
80109095:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80109097:	a1 a8 6f 19 80       	mov    0x80196fa8,%eax
8010909c:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
801090a2:	90                   	nop
801090a3:	5d                   	pop    %ebp
801090a4:	c3                   	ret    

801090a5 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
801090a5:	55                   	push   %ebp
801090a6:	89 e5                	mov    %esp,%ebp
801090a8:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
801090ab:	8b 45 08             	mov    0x8(%ebp),%eax
801090ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
801090b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090b4:	0f b7 00             	movzwl (%eax),%eax
801090b7:	66 3d 00 01          	cmp    $0x100,%ax
801090bb:	74 0a                	je     801090c7 <arp_proc+0x22>
801090bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090c2:	e9 4f 01 00 00       	jmp    80109216 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
801090c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ca:	0f b7 40 02          	movzwl 0x2(%eax),%eax
801090ce:	66 83 f8 08          	cmp    $0x8,%ax
801090d2:	74 0a                	je     801090de <arp_proc+0x39>
801090d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090d9:	e9 38 01 00 00       	jmp    80109216 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
801090de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090e1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
801090e5:	3c 06                	cmp    $0x6,%al
801090e7:	74 0a                	je     801090f3 <arp_proc+0x4e>
801090e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090ee:	e9 23 01 00 00       	jmp    80109216 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
801090f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f6:	0f b6 40 05          	movzbl 0x5(%eax),%eax
801090fa:	3c 04                	cmp    $0x4,%al
801090fc:	74 0a                	je     80109108 <arp_proc+0x63>
801090fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109103:	e9 0e 01 00 00       	jmp    80109216 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80109108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010910b:	83 c0 18             	add    $0x18,%eax
8010910e:	83 ec 04             	sub    $0x4,%esp
80109111:	6a 04                	push   $0x4
80109113:	50                   	push   %eax
80109114:	68 e4 f4 10 80       	push   $0x8010f4e4
80109119:	e8 74 ba ff ff       	call   80104b92 <memcmp>
8010911e:	83 c4 10             	add    $0x10,%esp
80109121:	85 c0                	test   %eax,%eax
80109123:	74 27                	je     8010914c <arp_proc+0xa7>
80109125:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109128:	83 c0 0e             	add    $0xe,%eax
8010912b:	83 ec 04             	sub    $0x4,%esp
8010912e:	6a 04                	push   $0x4
80109130:	50                   	push   %eax
80109131:	68 e4 f4 10 80       	push   $0x8010f4e4
80109136:	e8 57 ba ff ff       	call   80104b92 <memcmp>
8010913b:	83 c4 10             	add    $0x10,%esp
8010913e:	85 c0                	test   %eax,%eax
80109140:	74 0a                	je     8010914c <arp_proc+0xa7>
80109142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109147:	e9 ca 00 00 00       	jmp    80109216 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
8010914c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010914f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109153:	66 3d 00 01          	cmp    $0x100,%ax
80109157:	75 69                	jne    801091c2 <arp_proc+0x11d>
80109159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010915c:	83 c0 18             	add    $0x18,%eax
8010915f:	83 ec 04             	sub    $0x4,%esp
80109162:	6a 04                	push   $0x4
80109164:	50                   	push   %eax
80109165:	68 e4 f4 10 80       	push   $0x8010f4e4
8010916a:	e8 23 ba ff ff       	call   80104b92 <memcmp>
8010916f:	83 c4 10             	add    $0x10,%esp
80109172:	85 c0                	test   %eax,%eax
80109174:	75 4c                	jne    801091c2 <arp_proc+0x11d>
    uint send = (uint)kalloc();
80109176:	e8 0a 96 ff ff       	call   80102785 <kalloc>
8010917b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
8010917e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80109185:	83 ec 04             	sub    $0x4,%esp
80109188:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010918b:	50                   	push   %eax
8010918c:	ff 75 f0             	push   -0x10(%ebp)
8010918f:	ff 75 f4             	push   -0xc(%ebp)
80109192:	e8 1f 04 00 00       	call   801095b6 <arp_reply_pkt_create>
80109197:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
8010919a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010919d:	83 ec 08             	sub    $0x8,%esp
801091a0:	50                   	push   %eax
801091a1:	ff 75 f0             	push   -0x10(%ebp)
801091a4:	e8 d0 fd ff ff       	call   80108f79 <i8254_send>
801091a9:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
801091ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091af:	83 ec 0c             	sub    $0xc,%esp
801091b2:	50                   	push   %eax
801091b3:	e8 33 95 ff ff       	call   801026eb <kfree>
801091b8:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
801091bb:	b8 02 00 00 00       	mov    $0x2,%eax
801091c0:	eb 54                	jmp    80109216 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
801091c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c5:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801091c9:	66 3d 00 02          	cmp    $0x200,%ax
801091cd:	75 42                	jne    80109211 <arp_proc+0x16c>
801091cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091d2:	83 c0 18             	add    $0x18,%eax
801091d5:	83 ec 04             	sub    $0x4,%esp
801091d8:	6a 04                	push   $0x4
801091da:	50                   	push   %eax
801091db:	68 e4 f4 10 80       	push   $0x8010f4e4
801091e0:	e8 ad b9 ff ff       	call   80104b92 <memcmp>
801091e5:	83 c4 10             	add    $0x10,%esp
801091e8:	85 c0                	test   %eax,%eax
801091ea:	75 25                	jne    80109211 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
801091ec:	83 ec 0c             	sub    $0xc,%esp
801091ef:	68 fc c3 10 80       	push   $0x8010c3fc
801091f4:	e8 fb 71 ff ff       	call   801003f4 <cprintf>
801091f9:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
801091fc:	83 ec 0c             	sub    $0xc,%esp
801091ff:	ff 75 f4             	push   -0xc(%ebp)
80109202:	e8 af 01 00 00       	call   801093b6 <arp_table_update>
80109207:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
8010920a:	b8 01 00 00 00       	mov    $0x1,%eax
8010920f:	eb 05                	jmp    80109216 <arp_proc+0x171>
  }else{
    return -1;
80109211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109216:	c9                   	leave  
80109217:	c3                   	ret    

80109218 <arp_scan>:

void arp_scan(){
80109218:	55                   	push   %ebp
80109219:	89 e5                	mov    %esp,%ebp
8010921b:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
8010921e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109225:	eb 6f                	jmp    80109296 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109227:	e8 59 95 ff ff       	call   80102785 <kalloc>
8010922c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
8010922f:	83 ec 04             	sub    $0x4,%esp
80109232:	ff 75 f4             	push   -0xc(%ebp)
80109235:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109238:	50                   	push   %eax
80109239:	ff 75 ec             	push   -0x14(%ebp)
8010923c:	e8 62 00 00 00       	call   801092a3 <arp_broadcast>
80109241:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80109244:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109247:	83 ec 08             	sub    $0x8,%esp
8010924a:	50                   	push   %eax
8010924b:	ff 75 ec             	push   -0x14(%ebp)
8010924e:	e8 26 fd ff ff       	call   80108f79 <i8254_send>
80109253:	83 c4 10             	add    $0x10,%esp
80109256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80109259:	eb 22                	jmp    8010927d <arp_scan+0x65>
      microdelay(1);
8010925b:	83 ec 0c             	sub    $0xc,%esp
8010925e:	6a 01                	push   $0x1
80109260:	e8 b7 98 ff ff       	call   80102b1c <microdelay>
80109265:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80109268:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010926b:	83 ec 08             	sub    $0x8,%esp
8010926e:	50                   	push   %eax
8010926f:	ff 75 ec             	push   -0x14(%ebp)
80109272:	e8 02 fd ff ff       	call   80108f79 <i8254_send>
80109277:	83 c4 10             	add    $0x10,%esp
8010927a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
8010927d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80109281:	74 d8                	je     8010925b <arp_scan+0x43>
    }
    kfree((char *)send);
80109283:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109286:	83 ec 0c             	sub    $0xc,%esp
80109289:	50                   	push   %eax
8010928a:	e8 5c 94 ff ff       	call   801026eb <kfree>
8010928f:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
80109292:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109296:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010929d:	7e 88                	jle    80109227 <arp_scan+0xf>
  }
}
8010929f:	90                   	nop
801092a0:	90                   	nop
801092a1:	c9                   	leave  
801092a2:	c3                   	ret    

801092a3 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801092a3:	55                   	push   %ebp
801092a4:	89 e5                	mov    %esp,%ebp
801092a6:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801092a9:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801092ad:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
801092b1:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
801092b5:	8b 45 10             	mov    0x10(%ebp),%eax
801092b8:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801092bb:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801092c2:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801092c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801092cf:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801092d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801092d8:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801092de:	8b 45 08             	mov    0x8(%ebp),%eax
801092e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801092e4:	8b 45 08             	mov    0x8(%ebp),%eax
801092e7:	83 c0 0e             	add    $0xe,%eax
801092ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
801092ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f0:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801092f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f7:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
801092fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092fe:	83 ec 04             	sub    $0x4,%esp
80109301:	6a 06                	push   $0x6
80109303:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109306:	52                   	push   %edx
80109307:	50                   	push   %eax
80109308:	e8 dd b8 ff ff       	call   80104bea <memmove>
8010930d:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109313:	83 c0 06             	add    $0x6,%eax
80109316:	83 ec 04             	sub    $0x4,%esp
80109319:	6a 06                	push   $0x6
8010931b:	68 a0 6f 19 80       	push   $0x80196fa0
80109320:	50                   	push   %eax
80109321:	e8 c4 b8 ff ff       	call   80104bea <memmove>
80109326:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109329:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010932c:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109334:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010933a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010933d:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109341:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109344:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
80109348:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010934b:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
80109351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109354:	8d 50 12             	lea    0x12(%eax),%edx
80109357:	83 ec 04             	sub    $0x4,%esp
8010935a:	6a 06                	push   $0x6
8010935c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010935f:	50                   	push   %eax
80109360:	52                   	push   %edx
80109361:	e8 84 b8 ff ff       	call   80104bea <memmove>
80109366:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
80109369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010936c:	8d 50 18             	lea    0x18(%eax),%edx
8010936f:	83 ec 04             	sub    $0x4,%esp
80109372:	6a 04                	push   $0x4
80109374:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109377:	50                   	push   %eax
80109378:	52                   	push   %edx
80109379:	e8 6c b8 ff ff       	call   80104bea <memmove>
8010937e:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109384:	83 c0 08             	add    $0x8,%eax
80109387:	83 ec 04             	sub    $0x4,%esp
8010938a:	6a 06                	push   $0x6
8010938c:	68 a0 6f 19 80       	push   $0x80196fa0
80109391:	50                   	push   %eax
80109392:	e8 53 b8 ff ff       	call   80104bea <memmove>
80109397:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
8010939a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010939d:	83 c0 0e             	add    $0xe,%eax
801093a0:	83 ec 04             	sub    $0x4,%esp
801093a3:	6a 04                	push   $0x4
801093a5:	68 e4 f4 10 80       	push   $0x8010f4e4
801093aa:	50                   	push   %eax
801093ab:	e8 3a b8 ff ff       	call   80104bea <memmove>
801093b0:	83 c4 10             	add    $0x10,%esp
}
801093b3:	90                   	nop
801093b4:	c9                   	leave  
801093b5:	c3                   	ret    

801093b6 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
801093b6:	55                   	push   %ebp
801093b7:	89 e5                	mov    %esp,%ebp
801093b9:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801093bc:	8b 45 08             	mov    0x8(%ebp),%eax
801093bf:	83 c0 0e             	add    $0xe,%eax
801093c2:	83 ec 0c             	sub    $0xc,%esp
801093c5:	50                   	push   %eax
801093c6:	e8 bc 00 00 00       	call   80109487 <arp_table_search>
801093cb:	83 c4 10             	add    $0x10,%esp
801093ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801093d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801093d5:	78 2d                	js     80109404 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801093d7:	8b 45 08             	mov    0x8(%ebp),%eax
801093da:	8d 48 08             	lea    0x8(%eax),%ecx
801093dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801093e0:	89 d0                	mov    %edx,%eax
801093e2:	c1 e0 02             	shl    $0x2,%eax
801093e5:	01 d0                	add    %edx,%eax
801093e7:	01 c0                	add    %eax,%eax
801093e9:	01 d0                	add    %edx,%eax
801093eb:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
801093f0:	83 c0 04             	add    $0x4,%eax
801093f3:	83 ec 04             	sub    $0x4,%esp
801093f6:	6a 06                	push   $0x6
801093f8:	51                   	push   %ecx
801093f9:	50                   	push   %eax
801093fa:	e8 eb b7 ff ff       	call   80104bea <memmove>
801093ff:	83 c4 10             	add    $0x10,%esp
80109402:	eb 70                	jmp    80109474 <arp_table_update+0xbe>
  }else{
    index += 1;
80109404:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109408:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010940b:	8b 45 08             	mov    0x8(%ebp),%eax
8010940e:	8d 48 08             	lea    0x8(%eax),%ecx
80109411:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109414:	89 d0                	mov    %edx,%eax
80109416:	c1 e0 02             	shl    $0x2,%eax
80109419:	01 d0                	add    %edx,%eax
8010941b:	01 c0                	add    %eax,%eax
8010941d:	01 d0                	add    %edx,%eax
8010941f:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
80109424:	83 c0 04             	add    $0x4,%eax
80109427:	83 ec 04             	sub    $0x4,%esp
8010942a:	6a 06                	push   $0x6
8010942c:	51                   	push   %ecx
8010942d:	50                   	push   %eax
8010942e:	e8 b7 b7 ff ff       	call   80104bea <memmove>
80109433:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109436:	8b 45 08             	mov    0x8(%ebp),%eax
80109439:	8d 48 0e             	lea    0xe(%eax),%ecx
8010943c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010943f:	89 d0                	mov    %edx,%eax
80109441:	c1 e0 02             	shl    $0x2,%eax
80109444:	01 d0                	add    %edx,%eax
80109446:	01 c0                	add    %eax,%eax
80109448:	01 d0                	add    %edx,%eax
8010944a:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
8010944f:	83 ec 04             	sub    $0x4,%esp
80109452:	6a 04                	push   $0x4
80109454:	51                   	push   %ecx
80109455:	50                   	push   %eax
80109456:	e8 8f b7 ff ff       	call   80104bea <memmove>
8010945b:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
8010945e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109461:	89 d0                	mov    %edx,%eax
80109463:	c1 e0 02             	shl    $0x2,%eax
80109466:	01 d0                	add    %edx,%eax
80109468:	01 c0                	add    %eax,%eax
8010946a:	01 d0                	add    %edx,%eax
8010946c:	05 ca 6f 19 80       	add    $0x80196fca,%eax
80109471:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
80109474:	83 ec 0c             	sub    $0xc,%esp
80109477:	68 c0 6f 19 80       	push   $0x80196fc0
8010947c:	e8 83 00 00 00       	call   80109504 <print_arp_table>
80109481:	83 c4 10             	add    $0x10,%esp
}
80109484:	90                   	nop
80109485:	c9                   	leave  
80109486:	c3                   	ret    

80109487 <arp_table_search>:

int arp_table_search(uchar *ip){
80109487:	55                   	push   %ebp
80109488:	89 e5                	mov    %esp,%ebp
8010948a:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
8010948d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109494:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010949b:	eb 59                	jmp    801094f6 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
8010949d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801094a0:	89 d0                	mov    %edx,%eax
801094a2:	c1 e0 02             	shl    $0x2,%eax
801094a5:	01 d0                	add    %edx,%eax
801094a7:	01 c0                	add    %eax,%eax
801094a9:	01 d0                	add    %edx,%eax
801094ab:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
801094b0:	83 ec 04             	sub    $0x4,%esp
801094b3:	6a 04                	push   $0x4
801094b5:	ff 75 08             	push   0x8(%ebp)
801094b8:	50                   	push   %eax
801094b9:	e8 d4 b6 ff ff       	call   80104b92 <memcmp>
801094be:	83 c4 10             	add    $0x10,%esp
801094c1:	85 c0                	test   %eax,%eax
801094c3:	75 05                	jne    801094ca <arp_table_search+0x43>
      return i;
801094c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094c8:	eb 38                	jmp    80109502 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801094ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801094cd:	89 d0                	mov    %edx,%eax
801094cf:	c1 e0 02             	shl    $0x2,%eax
801094d2:	01 d0                	add    %edx,%eax
801094d4:	01 c0                	add    %eax,%eax
801094d6:	01 d0                	add    %edx,%eax
801094d8:	05 ca 6f 19 80       	add    $0x80196fca,%eax
801094dd:	0f b6 00             	movzbl (%eax),%eax
801094e0:	84 c0                	test   %al,%al
801094e2:	75 0e                	jne    801094f2 <arp_table_search+0x6b>
801094e4:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801094e8:	75 08                	jne    801094f2 <arp_table_search+0x6b>
      empty = -i;
801094ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094ed:	f7 d8                	neg    %eax
801094ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801094f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801094f6:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
801094fa:	7e a1                	jle    8010949d <arp_table_search+0x16>
    }
  }
  return empty-1;
801094fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ff:	83 e8 01             	sub    $0x1,%eax
}
80109502:	c9                   	leave  
80109503:	c3                   	ret    

80109504 <print_arp_table>:

void print_arp_table(){
80109504:	55                   	push   %ebp
80109505:	89 e5                	mov    %esp,%ebp
80109507:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010950a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109511:	e9 92 00 00 00       	jmp    801095a8 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109519:	89 d0                	mov    %edx,%eax
8010951b:	c1 e0 02             	shl    $0x2,%eax
8010951e:	01 d0                	add    %edx,%eax
80109520:	01 c0                	add    %eax,%eax
80109522:	01 d0                	add    %edx,%eax
80109524:	05 ca 6f 19 80       	add    $0x80196fca,%eax
80109529:	0f b6 00             	movzbl (%eax),%eax
8010952c:	84 c0                	test   %al,%al
8010952e:	74 74                	je     801095a4 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109530:	83 ec 08             	sub    $0x8,%esp
80109533:	ff 75 f4             	push   -0xc(%ebp)
80109536:	68 0f c4 10 80       	push   $0x8010c40f
8010953b:	e8 b4 6e ff ff       	call   801003f4 <cprintf>
80109540:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109543:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109546:	89 d0                	mov    %edx,%eax
80109548:	c1 e0 02             	shl    $0x2,%eax
8010954b:	01 d0                	add    %edx,%eax
8010954d:	01 c0                	add    %eax,%eax
8010954f:	01 d0                	add    %edx,%eax
80109551:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
80109556:	83 ec 0c             	sub    $0xc,%esp
80109559:	50                   	push   %eax
8010955a:	e8 54 02 00 00       	call   801097b3 <print_ipv4>
8010955f:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
80109562:	83 ec 0c             	sub    $0xc,%esp
80109565:	68 1e c4 10 80       	push   $0x8010c41e
8010956a:	e8 85 6e ff ff       	call   801003f4 <cprintf>
8010956f:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
80109572:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109575:	89 d0                	mov    %edx,%eax
80109577:	c1 e0 02             	shl    $0x2,%eax
8010957a:	01 d0                	add    %edx,%eax
8010957c:	01 c0                	add    %eax,%eax
8010957e:	01 d0                	add    %edx,%eax
80109580:	05 c0 6f 19 80       	add    $0x80196fc0,%eax
80109585:	83 c0 04             	add    $0x4,%eax
80109588:	83 ec 0c             	sub    $0xc,%esp
8010958b:	50                   	push   %eax
8010958c:	e8 70 02 00 00       	call   80109801 <print_mac>
80109591:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
80109594:	83 ec 0c             	sub    $0xc,%esp
80109597:	68 20 c4 10 80       	push   $0x8010c420
8010959c:	e8 53 6e ff ff       	call   801003f4 <cprintf>
801095a1:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801095a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801095a8:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801095ac:	0f 8e 64 ff ff ff    	jle    80109516 <print_arp_table+0x12>
    }
  }
}
801095b2:	90                   	nop
801095b3:	90                   	nop
801095b4:	c9                   	leave  
801095b5:	c3                   	ret    

801095b6 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
801095b6:	55                   	push   %ebp
801095b7:	89 e5                	mov    %esp,%ebp
801095b9:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801095bc:	8b 45 10             	mov    0x10(%ebp),%eax
801095bf:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801095c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801095c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801095cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801095ce:	83 c0 0e             	add    $0xe,%eax
801095d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801095d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d7:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801095db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095de:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
801095e2:	8b 45 08             	mov    0x8(%ebp),%eax
801095e5:	8d 50 08             	lea    0x8(%eax),%edx
801095e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095eb:	83 ec 04             	sub    $0x4,%esp
801095ee:	6a 06                	push   $0x6
801095f0:	52                   	push   %edx
801095f1:	50                   	push   %eax
801095f2:	e8 f3 b5 ff ff       	call   80104bea <memmove>
801095f7:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
801095fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095fd:	83 c0 06             	add    $0x6,%eax
80109600:	83 ec 04             	sub    $0x4,%esp
80109603:	6a 06                	push   $0x6
80109605:	68 a0 6f 19 80       	push   $0x80196fa0
8010960a:	50                   	push   %eax
8010960b:	e8 da b5 ff ff       	call   80104bea <memmove>
80109610:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109613:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109616:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010961b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010961e:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109627:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010962b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010962e:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109632:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109635:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
8010963b:	8b 45 08             	mov    0x8(%ebp),%eax
8010963e:	8d 50 08             	lea    0x8(%eax),%edx
80109641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109644:	83 c0 12             	add    $0x12,%eax
80109647:	83 ec 04             	sub    $0x4,%esp
8010964a:	6a 06                	push   $0x6
8010964c:	52                   	push   %edx
8010964d:	50                   	push   %eax
8010964e:	e8 97 b5 ff ff       	call   80104bea <memmove>
80109653:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109656:	8b 45 08             	mov    0x8(%ebp),%eax
80109659:	8d 50 0e             	lea    0xe(%eax),%edx
8010965c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010965f:	83 c0 18             	add    $0x18,%eax
80109662:	83 ec 04             	sub    $0x4,%esp
80109665:	6a 04                	push   $0x4
80109667:	52                   	push   %edx
80109668:	50                   	push   %eax
80109669:	e8 7c b5 ff ff       	call   80104bea <memmove>
8010966e:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109671:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109674:	83 c0 08             	add    $0x8,%eax
80109677:	83 ec 04             	sub    $0x4,%esp
8010967a:	6a 06                	push   $0x6
8010967c:	68 a0 6f 19 80       	push   $0x80196fa0
80109681:	50                   	push   %eax
80109682:	e8 63 b5 ff ff       	call   80104bea <memmove>
80109687:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
8010968a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010968d:	83 c0 0e             	add    $0xe,%eax
80109690:	83 ec 04             	sub    $0x4,%esp
80109693:	6a 04                	push   $0x4
80109695:	68 e4 f4 10 80       	push   $0x8010f4e4
8010969a:	50                   	push   %eax
8010969b:	e8 4a b5 ff ff       	call   80104bea <memmove>
801096a0:	83 c4 10             	add    $0x10,%esp
}
801096a3:	90                   	nop
801096a4:	c9                   	leave  
801096a5:	c3                   	ret    

801096a6 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801096a6:	55                   	push   %ebp
801096a7:	89 e5                	mov    %esp,%ebp
801096a9:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801096ac:	83 ec 0c             	sub    $0xc,%esp
801096af:	68 22 c4 10 80       	push   $0x8010c422
801096b4:	e8 3b 6d ff ff       	call   801003f4 <cprintf>
801096b9:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801096bc:	8b 45 08             	mov    0x8(%ebp),%eax
801096bf:	83 c0 0e             	add    $0xe,%eax
801096c2:	83 ec 0c             	sub    $0xc,%esp
801096c5:	50                   	push   %eax
801096c6:	e8 e8 00 00 00       	call   801097b3 <print_ipv4>
801096cb:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801096ce:	83 ec 0c             	sub    $0xc,%esp
801096d1:	68 20 c4 10 80       	push   $0x8010c420
801096d6:	e8 19 6d ff ff       	call   801003f4 <cprintf>
801096db:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
801096de:	8b 45 08             	mov    0x8(%ebp),%eax
801096e1:	83 c0 08             	add    $0x8,%eax
801096e4:	83 ec 0c             	sub    $0xc,%esp
801096e7:	50                   	push   %eax
801096e8:	e8 14 01 00 00       	call   80109801 <print_mac>
801096ed:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801096f0:	83 ec 0c             	sub    $0xc,%esp
801096f3:	68 20 c4 10 80       	push   $0x8010c420
801096f8:	e8 f7 6c ff ff       	call   801003f4 <cprintf>
801096fd:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
80109700:	83 ec 0c             	sub    $0xc,%esp
80109703:	68 39 c4 10 80       	push   $0x8010c439
80109708:	e8 e7 6c ff ff       	call   801003f4 <cprintf>
8010970d:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109710:	8b 45 08             	mov    0x8(%ebp),%eax
80109713:	83 c0 18             	add    $0x18,%eax
80109716:	83 ec 0c             	sub    $0xc,%esp
80109719:	50                   	push   %eax
8010971a:	e8 94 00 00 00       	call   801097b3 <print_ipv4>
8010971f:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109722:	83 ec 0c             	sub    $0xc,%esp
80109725:	68 20 c4 10 80       	push   $0x8010c420
8010972a:	e8 c5 6c ff ff       	call   801003f4 <cprintf>
8010972f:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109732:	8b 45 08             	mov    0x8(%ebp),%eax
80109735:	83 c0 12             	add    $0x12,%eax
80109738:	83 ec 0c             	sub    $0xc,%esp
8010973b:	50                   	push   %eax
8010973c:	e8 c0 00 00 00       	call   80109801 <print_mac>
80109741:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109744:	83 ec 0c             	sub    $0xc,%esp
80109747:	68 20 c4 10 80       	push   $0x8010c420
8010974c:	e8 a3 6c ff ff       	call   801003f4 <cprintf>
80109751:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
80109754:	83 ec 0c             	sub    $0xc,%esp
80109757:	68 50 c4 10 80       	push   $0x8010c450
8010975c:	e8 93 6c ff ff       	call   801003f4 <cprintf>
80109761:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
80109764:	8b 45 08             	mov    0x8(%ebp),%eax
80109767:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010976b:	66 3d 00 01          	cmp    $0x100,%ax
8010976f:	75 12                	jne    80109783 <print_arp_info+0xdd>
80109771:	83 ec 0c             	sub    $0xc,%esp
80109774:	68 5c c4 10 80       	push   $0x8010c45c
80109779:	e8 76 6c ff ff       	call   801003f4 <cprintf>
8010977e:	83 c4 10             	add    $0x10,%esp
80109781:	eb 1d                	jmp    801097a0 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
80109783:	8b 45 08             	mov    0x8(%ebp),%eax
80109786:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010978a:	66 3d 00 02          	cmp    $0x200,%ax
8010978e:	75 10                	jne    801097a0 <print_arp_info+0xfa>
    cprintf("Reply\n");
80109790:	83 ec 0c             	sub    $0xc,%esp
80109793:	68 65 c4 10 80       	push   $0x8010c465
80109798:	e8 57 6c ff ff       	call   801003f4 <cprintf>
8010979d:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801097a0:	83 ec 0c             	sub    $0xc,%esp
801097a3:	68 20 c4 10 80       	push   $0x8010c420
801097a8:	e8 47 6c ff ff       	call   801003f4 <cprintf>
801097ad:	83 c4 10             	add    $0x10,%esp
}
801097b0:	90                   	nop
801097b1:	c9                   	leave  
801097b2:	c3                   	ret    

801097b3 <print_ipv4>:

void print_ipv4(uchar *ip){
801097b3:	55                   	push   %ebp
801097b4:	89 e5                	mov    %esp,%ebp
801097b6:	53                   	push   %ebx
801097b7:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801097ba:	8b 45 08             	mov    0x8(%ebp),%eax
801097bd:	83 c0 03             	add    $0x3,%eax
801097c0:	0f b6 00             	movzbl (%eax),%eax
801097c3:	0f b6 d8             	movzbl %al,%ebx
801097c6:	8b 45 08             	mov    0x8(%ebp),%eax
801097c9:	83 c0 02             	add    $0x2,%eax
801097cc:	0f b6 00             	movzbl (%eax),%eax
801097cf:	0f b6 c8             	movzbl %al,%ecx
801097d2:	8b 45 08             	mov    0x8(%ebp),%eax
801097d5:	83 c0 01             	add    $0x1,%eax
801097d8:	0f b6 00             	movzbl (%eax),%eax
801097db:	0f b6 d0             	movzbl %al,%edx
801097de:	8b 45 08             	mov    0x8(%ebp),%eax
801097e1:	0f b6 00             	movzbl (%eax),%eax
801097e4:	0f b6 c0             	movzbl %al,%eax
801097e7:	83 ec 0c             	sub    $0xc,%esp
801097ea:	53                   	push   %ebx
801097eb:	51                   	push   %ecx
801097ec:	52                   	push   %edx
801097ed:	50                   	push   %eax
801097ee:	68 6c c4 10 80       	push   $0x8010c46c
801097f3:	e8 fc 6b ff ff       	call   801003f4 <cprintf>
801097f8:	83 c4 20             	add    $0x20,%esp
}
801097fb:	90                   	nop
801097fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801097ff:	c9                   	leave  
80109800:	c3                   	ret    

80109801 <print_mac>:

void print_mac(uchar *mac){
80109801:	55                   	push   %ebp
80109802:	89 e5                	mov    %esp,%ebp
80109804:	57                   	push   %edi
80109805:	56                   	push   %esi
80109806:	53                   	push   %ebx
80109807:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
8010980a:	8b 45 08             	mov    0x8(%ebp),%eax
8010980d:	83 c0 05             	add    $0x5,%eax
80109810:	0f b6 00             	movzbl (%eax),%eax
80109813:	0f b6 f8             	movzbl %al,%edi
80109816:	8b 45 08             	mov    0x8(%ebp),%eax
80109819:	83 c0 04             	add    $0x4,%eax
8010981c:	0f b6 00             	movzbl (%eax),%eax
8010981f:	0f b6 f0             	movzbl %al,%esi
80109822:	8b 45 08             	mov    0x8(%ebp),%eax
80109825:	83 c0 03             	add    $0x3,%eax
80109828:	0f b6 00             	movzbl (%eax),%eax
8010982b:	0f b6 d8             	movzbl %al,%ebx
8010982e:	8b 45 08             	mov    0x8(%ebp),%eax
80109831:	83 c0 02             	add    $0x2,%eax
80109834:	0f b6 00             	movzbl (%eax),%eax
80109837:	0f b6 c8             	movzbl %al,%ecx
8010983a:	8b 45 08             	mov    0x8(%ebp),%eax
8010983d:	83 c0 01             	add    $0x1,%eax
80109840:	0f b6 00             	movzbl (%eax),%eax
80109843:	0f b6 d0             	movzbl %al,%edx
80109846:	8b 45 08             	mov    0x8(%ebp),%eax
80109849:	0f b6 00             	movzbl (%eax),%eax
8010984c:	0f b6 c0             	movzbl %al,%eax
8010984f:	83 ec 04             	sub    $0x4,%esp
80109852:	57                   	push   %edi
80109853:	56                   	push   %esi
80109854:	53                   	push   %ebx
80109855:	51                   	push   %ecx
80109856:	52                   	push   %edx
80109857:	50                   	push   %eax
80109858:	68 84 c4 10 80       	push   $0x8010c484
8010985d:	e8 92 6b ff ff       	call   801003f4 <cprintf>
80109862:	83 c4 20             	add    $0x20,%esp
}
80109865:	90                   	nop
80109866:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109869:	5b                   	pop    %ebx
8010986a:	5e                   	pop    %esi
8010986b:	5f                   	pop    %edi
8010986c:	5d                   	pop    %ebp
8010986d:	c3                   	ret    

8010986e <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
8010986e:	55                   	push   %ebp
8010986f:	89 e5                	mov    %esp,%ebp
80109871:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109874:	8b 45 08             	mov    0x8(%ebp),%eax
80109877:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
8010987a:	8b 45 08             	mov    0x8(%ebp),%eax
8010987d:	83 c0 0e             	add    $0xe,%eax
80109880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
80109883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109886:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
8010988a:	3c 08                	cmp    $0x8,%al
8010988c:	75 1b                	jne    801098a9 <eth_proc+0x3b>
8010988e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109891:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109895:	3c 06                	cmp    $0x6,%al
80109897:	75 10                	jne    801098a9 <eth_proc+0x3b>
    arp_proc(pkt_addr);
80109899:	83 ec 0c             	sub    $0xc,%esp
8010989c:	ff 75 f0             	push   -0x10(%ebp)
8010989f:	e8 01 f8 ff ff       	call   801090a5 <arp_proc>
801098a4:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801098a7:	eb 24                	jmp    801098cd <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801098a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098ac:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801098b0:	3c 08                	cmp    $0x8,%al
801098b2:	75 19                	jne    801098cd <eth_proc+0x5f>
801098b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098b7:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801098bb:	84 c0                	test   %al,%al
801098bd:	75 0e                	jne    801098cd <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801098bf:	83 ec 0c             	sub    $0xc,%esp
801098c2:	ff 75 08             	push   0x8(%ebp)
801098c5:	e8 a3 00 00 00       	call   8010996d <ipv4_proc>
801098ca:	83 c4 10             	add    $0x10,%esp
}
801098cd:	90                   	nop
801098ce:	c9                   	leave  
801098cf:	c3                   	ret    

801098d0 <N2H_ushort>:

ushort N2H_ushort(ushort value){
801098d0:	55                   	push   %ebp
801098d1:	89 e5                	mov    %esp,%ebp
801098d3:	83 ec 04             	sub    $0x4,%esp
801098d6:	8b 45 08             	mov    0x8(%ebp),%eax
801098d9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801098dd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801098e1:	c1 e0 08             	shl    $0x8,%eax
801098e4:	89 c2                	mov    %eax,%edx
801098e6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801098ea:	66 c1 e8 08          	shr    $0x8,%ax
801098ee:	01 d0                	add    %edx,%eax
}
801098f0:	c9                   	leave  
801098f1:	c3                   	ret    

801098f2 <H2N_ushort>:

ushort H2N_ushort(ushort value){
801098f2:	55                   	push   %ebp
801098f3:	89 e5                	mov    %esp,%ebp
801098f5:	83 ec 04             	sub    $0x4,%esp
801098f8:	8b 45 08             	mov    0x8(%ebp),%eax
801098fb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801098ff:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109903:	c1 e0 08             	shl    $0x8,%eax
80109906:	89 c2                	mov    %eax,%edx
80109908:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010990c:	66 c1 e8 08          	shr    $0x8,%ax
80109910:	01 d0                	add    %edx,%eax
}
80109912:	c9                   	leave  
80109913:	c3                   	ret    

80109914 <H2N_uint>:

uint H2N_uint(uint value){
80109914:	55                   	push   %ebp
80109915:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109917:	8b 45 08             	mov    0x8(%ebp),%eax
8010991a:	c1 e0 18             	shl    $0x18,%eax
8010991d:	25 00 00 00 0f       	and    $0xf000000,%eax
80109922:	89 c2                	mov    %eax,%edx
80109924:	8b 45 08             	mov    0x8(%ebp),%eax
80109927:	c1 e0 08             	shl    $0x8,%eax
8010992a:	25 00 f0 00 00       	and    $0xf000,%eax
8010992f:	09 c2                	or     %eax,%edx
80109931:	8b 45 08             	mov    0x8(%ebp),%eax
80109934:	c1 e8 08             	shr    $0x8,%eax
80109937:	83 e0 0f             	and    $0xf,%eax
8010993a:	01 d0                	add    %edx,%eax
}
8010993c:	5d                   	pop    %ebp
8010993d:	c3                   	ret    

8010993e <N2H_uint>:

uint N2H_uint(uint value){
8010993e:	55                   	push   %ebp
8010993f:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
80109941:	8b 45 08             	mov    0x8(%ebp),%eax
80109944:	c1 e0 18             	shl    $0x18,%eax
80109947:	89 c2                	mov    %eax,%edx
80109949:	8b 45 08             	mov    0x8(%ebp),%eax
8010994c:	c1 e0 08             	shl    $0x8,%eax
8010994f:	25 00 00 ff 00       	and    $0xff0000,%eax
80109954:	01 c2                	add    %eax,%edx
80109956:	8b 45 08             	mov    0x8(%ebp),%eax
80109959:	c1 e8 08             	shr    $0x8,%eax
8010995c:	25 00 ff 00 00       	and    $0xff00,%eax
80109961:	01 c2                	add    %eax,%edx
80109963:	8b 45 08             	mov    0x8(%ebp),%eax
80109966:	c1 e8 18             	shr    $0x18,%eax
80109969:	01 d0                	add    %edx,%eax
}
8010996b:	5d                   	pop    %ebp
8010996c:	c3                   	ret    

8010996d <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
8010996d:	55                   	push   %ebp
8010996e:	89 e5                	mov    %esp,%ebp
80109970:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109973:	8b 45 08             	mov    0x8(%ebp),%eax
80109976:	83 c0 0e             	add    $0xe,%eax
80109979:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
8010997c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010997f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109983:	0f b7 d0             	movzwl %ax,%edx
80109986:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
8010998b:	39 c2                	cmp    %eax,%edx
8010998d:	74 60                	je     801099ef <ipv4_proc+0x82>
8010998f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109992:	83 c0 0c             	add    $0xc,%eax
80109995:	83 ec 04             	sub    $0x4,%esp
80109998:	6a 04                	push   $0x4
8010999a:	50                   	push   %eax
8010999b:	68 e4 f4 10 80       	push   $0x8010f4e4
801099a0:	e8 ed b1 ff ff       	call   80104b92 <memcmp>
801099a5:	83 c4 10             	add    $0x10,%esp
801099a8:	85 c0                	test   %eax,%eax
801099aa:	74 43                	je     801099ef <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801099ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099af:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801099b3:	0f b7 c0             	movzwl %ax,%eax
801099b6:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801099bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099be:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801099c2:	3c 01                	cmp    $0x1,%al
801099c4:	75 10                	jne    801099d6 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801099c6:	83 ec 0c             	sub    $0xc,%esp
801099c9:	ff 75 08             	push   0x8(%ebp)
801099cc:	e8 a3 00 00 00       	call   80109a74 <icmp_proc>
801099d1:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801099d4:	eb 19                	jmp    801099ef <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
801099d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099d9:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801099dd:	3c 06                	cmp    $0x6,%al
801099df:	75 0e                	jne    801099ef <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
801099e1:	83 ec 0c             	sub    $0xc,%esp
801099e4:	ff 75 08             	push   0x8(%ebp)
801099e7:	e8 b3 03 00 00       	call   80109d9f <tcp_proc>
801099ec:	83 c4 10             	add    $0x10,%esp
}
801099ef:	90                   	nop
801099f0:	c9                   	leave  
801099f1:	c3                   	ret    

801099f2 <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
801099f2:	55                   	push   %ebp
801099f3:	89 e5                	mov    %esp,%ebp
801099f5:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
801099f8:	8b 45 08             	mov    0x8(%ebp),%eax
801099fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
801099fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a01:	0f b6 00             	movzbl (%eax),%eax
80109a04:	83 e0 0f             	and    $0xf,%eax
80109a07:	01 c0                	add    %eax,%eax
80109a09:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109a0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109a13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109a1a:	eb 48                	jmp    80109a64 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a1f:	01 c0                	add    %eax,%eax
80109a21:	89 c2                	mov    %eax,%edx
80109a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a26:	01 d0                	add    %edx,%eax
80109a28:	0f b6 00             	movzbl (%eax),%eax
80109a2b:	0f b6 c0             	movzbl %al,%eax
80109a2e:	c1 e0 08             	shl    $0x8,%eax
80109a31:	89 c2                	mov    %eax,%edx
80109a33:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a36:	01 c0                	add    %eax,%eax
80109a38:	8d 48 01             	lea    0x1(%eax),%ecx
80109a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a3e:	01 c8                	add    %ecx,%eax
80109a40:	0f b6 00             	movzbl (%eax),%eax
80109a43:	0f b6 c0             	movzbl %al,%eax
80109a46:	01 d0                	add    %edx,%eax
80109a48:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109a4b:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109a52:	76 0c                	jbe    80109a60 <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109a54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109a57:	0f b7 c0             	movzwl %ax,%eax
80109a5a:	83 c0 01             	add    $0x1,%eax
80109a5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109a60:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109a64:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109a68:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109a6b:	7c af                	jl     80109a1c <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109a70:	f7 d0                	not    %eax
}
80109a72:	c9                   	leave  
80109a73:	c3                   	ret    

80109a74 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109a74:	55                   	push   %ebp
80109a75:	89 e5                	mov    %esp,%ebp
80109a77:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80109a7d:	83 c0 0e             	add    $0xe,%eax
80109a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a86:	0f b6 00             	movzbl (%eax),%eax
80109a89:	0f b6 c0             	movzbl %al,%eax
80109a8c:	83 e0 0f             	and    $0xf,%eax
80109a8f:	c1 e0 02             	shl    $0x2,%eax
80109a92:	89 c2                	mov    %eax,%edx
80109a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a97:	01 d0                	add    %edx,%eax
80109a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a9f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109aa3:	84 c0                	test   %al,%al
80109aa5:	75 4f                	jne    80109af6 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
80109aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109aaa:	0f b6 00             	movzbl (%eax),%eax
80109aad:	3c 08                	cmp    $0x8,%al
80109aaf:	75 45                	jne    80109af6 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
80109ab1:	e8 cf 8c ff ff       	call   80102785 <kalloc>
80109ab6:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109ac0:	83 ec 04             	sub    $0x4,%esp
80109ac3:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109ac6:	50                   	push   %eax
80109ac7:	ff 75 ec             	push   -0x14(%ebp)
80109aca:	ff 75 08             	push   0x8(%ebp)
80109acd:	e8 78 00 00 00       	call   80109b4a <icmp_reply_pkt_create>
80109ad2:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ad8:	83 ec 08             	sub    $0x8,%esp
80109adb:	50                   	push   %eax
80109adc:	ff 75 ec             	push   -0x14(%ebp)
80109adf:	e8 95 f4 ff ff       	call   80108f79 <i8254_send>
80109ae4:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109aea:	83 ec 0c             	sub    $0xc,%esp
80109aed:	50                   	push   %eax
80109aee:	e8 f8 8b ff ff       	call   801026eb <kfree>
80109af3:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109af6:	90                   	nop
80109af7:	c9                   	leave  
80109af8:	c3                   	ret    

80109af9 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109af9:	55                   	push   %ebp
80109afa:	89 e5                	mov    %esp,%ebp
80109afc:	53                   	push   %ebx
80109afd:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
80109b00:	8b 45 08             	mov    0x8(%ebp),%eax
80109b03:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109b07:	0f b7 c0             	movzwl %ax,%eax
80109b0a:	83 ec 0c             	sub    $0xc,%esp
80109b0d:	50                   	push   %eax
80109b0e:	e8 bd fd ff ff       	call   801098d0 <N2H_ushort>
80109b13:	83 c4 10             	add    $0x10,%esp
80109b16:	0f b7 d8             	movzwl %ax,%ebx
80109b19:	8b 45 08             	mov    0x8(%ebp),%eax
80109b1c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109b20:	0f b7 c0             	movzwl %ax,%eax
80109b23:	83 ec 0c             	sub    $0xc,%esp
80109b26:	50                   	push   %eax
80109b27:	e8 a4 fd ff ff       	call   801098d0 <N2H_ushort>
80109b2c:	83 c4 10             	add    $0x10,%esp
80109b2f:	0f b7 c0             	movzwl %ax,%eax
80109b32:	83 ec 04             	sub    $0x4,%esp
80109b35:	53                   	push   %ebx
80109b36:	50                   	push   %eax
80109b37:	68 a3 c4 10 80       	push   $0x8010c4a3
80109b3c:	e8 b3 68 ff ff       	call   801003f4 <cprintf>
80109b41:	83 c4 10             	add    $0x10,%esp
}
80109b44:	90                   	nop
80109b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109b48:	c9                   	leave  
80109b49:	c3                   	ret    

80109b4a <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109b4a:	55                   	push   %ebp
80109b4b:	89 e5                	mov    %esp,%ebp
80109b4d:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109b50:	8b 45 08             	mov    0x8(%ebp),%eax
80109b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109b56:	8b 45 08             	mov    0x8(%ebp),%eax
80109b59:	83 c0 0e             	add    $0xe,%eax
80109b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b62:	0f b6 00             	movzbl (%eax),%eax
80109b65:	0f b6 c0             	movzbl %al,%eax
80109b68:	83 e0 0f             	and    $0xf,%eax
80109b6b:	c1 e0 02             	shl    $0x2,%eax
80109b6e:	89 c2                	mov    %eax,%edx
80109b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b73:	01 d0                	add    %edx,%eax
80109b75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109b78:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b81:	83 c0 0e             	add    $0xe,%eax
80109b84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109b8a:	83 c0 14             	add    $0x14,%eax
80109b8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109b90:	8b 45 10             	mov    0x10(%ebp),%eax
80109b93:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b9c:	8d 50 06             	lea    0x6(%eax),%edx
80109b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ba2:	83 ec 04             	sub    $0x4,%esp
80109ba5:	6a 06                	push   $0x6
80109ba7:	52                   	push   %edx
80109ba8:	50                   	push   %eax
80109ba9:	e8 3c b0 ff ff       	call   80104bea <memmove>
80109bae:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bb4:	83 c0 06             	add    $0x6,%eax
80109bb7:	83 ec 04             	sub    $0x4,%esp
80109bba:	6a 06                	push   $0x6
80109bbc:	68 a0 6f 19 80       	push   $0x80196fa0
80109bc1:	50                   	push   %eax
80109bc2:	e8 23 b0 ff ff       	call   80104bea <memmove>
80109bc7:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109bca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bcd:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bd4:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109bdb:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109be1:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109be5:	83 ec 0c             	sub    $0xc,%esp
80109be8:	6a 54                	push   $0x54
80109bea:	e8 03 fd ff ff       	call   801098f2 <H2N_ushort>
80109bef:	83 c4 10             	add    $0x10,%esp
80109bf2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109bf5:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109bf9:	0f b7 15 80 72 19 80 	movzwl 0x80197280,%edx
80109c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c03:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109c07:	0f b7 05 80 72 19 80 	movzwl 0x80197280,%eax
80109c0e:	83 c0 01             	add    $0x1,%eax
80109c11:	66 a3 80 72 19 80    	mov    %ax,0x80197280
  ipv4_send->fragment = H2N_ushort(0x4000);
80109c17:	83 ec 0c             	sub    $0xc,%esp
80109c1a:	68 00 40 00 00       	push   $0x4000
80109c1f:	e8 ce fc ff ff       	call   801098f2 <H2N_ushort>
80109c24:	83 c4 10             	add    $0x10,%esp
80109c27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c2a:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c31:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c38:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c3f:	83 c0 0c             	add    $0xc,%eax
80109c42:	83 ec 04             	sub    $0x4,%esp
80109c45:	6a 04                	push   $0x4
80109c47:	68 e4 f4 10 80       	push   $0x8010f4e4
80109c4c:	50                   	push   %eax
80109c4d:	e8 98 af ff ff       	call   80104bea <memmove>
80109c52:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c58:	8d 50 0c             	lea    0xc(%eax),%edx
80109c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c5e:	83 c0 10             	add    $0x10,%eax
80109c61:	83 ec 04             	sub    $0x4,%esp
80109c64:	6a 04                	push   $0x4
80109c66:	52                   	push   %edx
80109c67:	50                   	push   %eax
80109c68:	e8 7d af ff ff       	call   80104bea <memmove>
80109c6d:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c73:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109c7c:	83 ec 0c             	sub    $0xc,%esp
80109c7f:	50                   	push   %eax
80109c80:	e8 6d fd ff ff       	call   801099f2 <ipv4_chksum>
80109c85:	83 c4 10             	add    $0x10,%esp
80109c88:	0f b7 c0             	movzwl %ax,%eax
80109c8b:	83 ec 0c             	sub    $0xc,%esp
80109c8e:	50                   	push   %eax
80109c8f:	e8 5e fc ff ff       	call   801098f2 <H2N_ushort>
80109c94:	83 c4 10             	add    $0x10,%esp
80109c97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109c9a:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109c9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ca1:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ca7:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cae:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109cb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cb5:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cbc:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cc3:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cca:	8d 50 08             	lea    0x8(%eax),%edx
80109ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109cd0:	83 c0 08             	add    $0x8,%eax
80109cd3:	83 ec 04             	sub    $0x4,%esp
80109cd6:	6a 08                	push   $0x8
80109cd8:	52                   	push   %edx
80109cd9:	50                   	push   %eax
80109cda:	e8 0b af ff ff       	call   80104bea <memmove>
80109cdf:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ce5:	8d 50 10             	lea    0x10(%eax),%edx
80109ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ceb:	83 c0 10             	add    $0x10,%eax
80109cee:	83 ec 04             	sub    $0x4,%esp
80109cf1:	6a 30                	push   $0x30
80109cf3:	52                   	push   %edx
80109cf4:	50                   	push   %eax
80109cf5:	e8 f0 ae ff ff       	call   80104bea <memmove>
80109cfa:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109cfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d00:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109d09:	83 ec 0c             	sub    $0xc,%esp
80109d0c:	50                   	push   %eax
80109d0d:	e8 1c 00 00 00       	call   80109d2e <icmp_chksum>
80109d12:	83 c4 10             	add    $0x10,%esp
80109d15:	0f b7 c0             	movzwl %ax,%eax
80109d18:	83 ec 0c             	sub    $0xc,%esp
80109d1b:	50                   	push   %eax
80109d1c:	e8 d1 fb ff ff       	call   801098f2 <H2N_ushort>
80109d21:	83 c4 10             	add    $0x10,%esp
80109d24:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109d27:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109d2b:	90                   	nop
80109d2c:	c9                   	leave  
80109d2d:	c3                   	ret    

80109d2e <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109d2e:	55                   	push   %ebp
80109d2f:	89 e5                	mov    %esp,%ebp
80109d31:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109d34:	8b 45 08             	mov    0x8(%ebp),%eax
80109d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109d3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109d41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109d48:	eb 48                	jmp    80109d92 <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109d4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d4d:	01 c0                	add    %eax,%eax
80109d4f:	89 c2                	mov    %eax,%edx
80109d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d54:	01 d0                	add    %edx,%eax
80109d56:	0f b6 00             	movzbl (%eax),%eax
80109d59:	0f b6 c0             	movzbl %al,%eax
80109d5c:	c1 e0 08             	shl    $0x8,%eax
80109d5f:	89 c2                	mov    %eax,%edx
80109d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109d64:	01 c0                	add    %eax,%eax
80109d66:	8d 48 01             	lea    0x1(%eax),%ecx
80109d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d6c:	01 c8                	add    %ecx,%eax
80109d6e:	0f b6 00             	movzbl (%eax),%eax
80109d71:	0f b6 c0             	movzbl %al,%eax
80109d74:	01 d0                	add    %edx,%eax
80109d76:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109d79:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109d80:	76 0c                	jbe    80109d8e <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109d85:	0f b7 c0             	movzwl %ax,%eax
80109d88:	83 c0 01             	add    $0x1,%eax
80109d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109d8e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109d92:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109d96:	7e b2                	jle    80109d4a <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109d9b:	f7 d0                	not    %eax
}
80109d9d:	c9                   	leave  
80109d9e:	c3                   	ret    

80109d9f <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109d9f:	55                   	push   %ebp
80109da0:	89 e5                	mov    %esp,%ebp
80109da2:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109da5:	8b 45 08             	mov    0x8(%ebp),%eax
80109da8:	83 c0 0e             	add    $0xe,%eax
80109dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109db1:	0f b6 00             	movzbl (%eax),%eax
80109db4:	0f b6 c0             	movzbl %al,%eax
80109db7:	83 e0 0f             	and    $0xf,%eax
80109dba:	c1 e0 02             	shl    $0x2,%eax
80109dbd:	89 c2                	mov    %eax,%edx
80109dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109dc2:	01 d0                	add    %edx,%eax
80109dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dca:	83 c0 14             	add    $0x14,%eax
80109dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109dd0:	e8 b0 89 ff ff       	call   80102785 <kalloc>
80109dd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109dd8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109de2:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109de6:	0f b6 c0             	movzbl %al,%eax
80109de9:	83 e0 02             	and    $0x2,%eax
80109dec:	85 c0                	test   %eax,%eax
80109dee:	74 3d                	je     80109e2d <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109df0:	83 ec 0c             	sub    $0xc,%esp
80109df3:	6a 00                	push   $0x0
80109df5:	6a 12                	push   $0x12
80109df7:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109dfa:	50                   	push   %eax
80109dfb:	ff 75 e8             	push   -0x18(%ebp)
80109dfe:	ff 75 08             	push   0x8(%ebp)
80109e01:	e8 a2 01 00 00       	call   80109fa8 <tcp_pkt_create>
80109e06:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109e0c:	83 ec 08             	sub    $0x8,%esp
80109e0f:	50                   	push   %eax
80109e10:	ff 75 e8             	push   -0x18(%ebp)
80109e13:	e8 61 f1 ff ff       	call   80108f79 <i8254_send>
80109e18:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109e1b:	a1 84 72 19 80       	mov    0x80197284,%eax
80109e20:	83 c0 01             	add    $0x1,%eax
80109e23:	a3 84 72 19 80       	mov    %eax,0x80197284
80109e28:	e9 69 01 00 00       	jmp    80109f96 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e30:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109e34:	3c 18                	cmp    $0x18,%al
80109e36:	0f 85 10 01 00 00    	jne    80109f4c <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109e3c:	83 ec 04             	sub    $0x4,%esp
80109e3f:	6a 03                	push   $0x3
80109e41:	68 be c4 10 80       	push   $0x8010c4be
80109e46:	ff 75 ec             	push   -0x14(%ebp)
80109e49:	e8 44 ad ff ff       	call   80104b92 <memcmp>
80109e4e:	83 c4 10             	add    $0x10,%esp
80109e51:	85 c0                	test   %eax,%eax
80109e53:	74 74                	je     80109ec9 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109e55:	83 ec 0c             	sub    $0xc,%esp
80109e58:	68 c2 c4 10 80       	push   $0x8010c4c2
80109e5d:	e8 92 65 ff ff       	call   801003f4 <cprintf>
80109e62:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109e65:	83 ec 0c             	sub    $0xc,%esp
80109e68:	6a 00                	push   $0x0
80109e6a:	6a 10                	push   $0x10
80109e6c:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109e6f:	50                   	push   %eax
80109e70:	ff 75 e8             	push   -0x18(%ebp)
80109e73:	ff 75 08             	push   0x8(%ebp)
80109e76:	e8 2d 01 00 00       	call   80109fa8 <tcp_pkt_create>
80109e7b:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109e81:	83 ec 08             	sub    $0x8,%esp
80109e84:	50                   	push   %eax
80109e85:	ff 75 e8             	push   -0x18(%ebp)
80109e88:	e8 ec f0 ff ff       	call   80108f79 <i8254_send>
80109e8d:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e93:	83 c0 36             	add    $0x36,%eax
80109e96:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109e99:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109e9c:	50                   	push   %eax
80109e9d:	ff 75 e0             	push   -0x20(%ebp)
80109ea0:	6a 00                	push   $0x0
80109ea2:	6a 00                	push   $0x0
80109ea4:	e8 5a 04 00 00       	call   8010a303 <http_proc>
80109ea9:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109eac:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109eaf:	83 ec 0c             	sub    $0xc,%esp
80109eb2:	50                   	push   %eax
80109eb3:	6a 18                	push   $0x18
80109eb5:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109eb8:	50                   	push   %eax
80109eb9:	ff 75 e8             	push   -0x18(%ebp)
80109ebc:	ff 75 08             	push   0x8(%ebp)
80109ebf:	e8 e4 00 00 00       	call   80109fa8 <tcp_pkt_create>
80109ec4:	83 c4 20             	add    $0x20,%esp
80109ec7:	eb 62                	jmp    80109f2b <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109ec9:	83 ec 0c             	sub    $0xc,%esp
80109ecc:	6a 00                	push   $0x0
80109ece:	6a 10                	push   $0x10
80109ed0:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109ed3:	50                   	push   %eax
80109ed4:	ff 75 e8             	push   -0x18(%ebp)
80109ed7:	ff 75 08             	push   0x8(%ebp)
80109eda:	e8 c9 00 00 00       	call   80109fa8 <tcp_pkt_create>
80109edf:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109ee2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109ee5:	83 ec 08             	sub    $0x8,%esp
80109ee8:	50                   	push   %eax
80109ee9:	ff 75 e8             	push   -0x18(%ebp)
80109eec:	e8 88 f0 ff ff       	call   80108f79 <i8254_send>
80109ef1:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ef7:	83 c0 36             	add    $0x36,%eax
80109efa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109efd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f00:	50                   	push   %eax
80109f01:	ff 75 e4             	push   -0x1c(%ebp)
80109f04:	6a 00                	push   $0x0
80109f06:	6a 00                	push   $0x0
80109f08:	e8 f6 03 00 00       	call   8010a303 <http_proc>
80109f0d:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109f10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109f13:	83 ec 0c             	sub    $0xc,%esp
80109f16:	50                   	push   %eax
80109f17:	6a 18                	push   $0x18
80109f19:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f1c:	50                   	push   %eax
80109f1d:	ff 75 e8             	push   -0x18(%ebp)
80109f20:	ff 75 08             	push   0x8(%ebp)
80109f23:	e8 80 00 00 00       	call   80109fa8 <tcp_pkt_create>
80109f28:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109f2e:	83 ec 08             	sub    $0x8,%esp
80109f31:	50                   	push   %eax
80109f32:	ff 75 e8             	push   -0x18(%ebp)
80109f35:	e8 3f f0 ff ff       	call   80108f79 <i8254_send>
80109f3a:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109f3d:	a1 84 72 19 80       	mov    0x80197284,%eax
80109f42:	83 c0 01             	add    $0x1,%eax
80109f45:	a3 84 72 19 80       	mov    %eax,0x80197284
80109f4a:	eb 4a                	jmp    80109f96 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f4f:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109f53:	3c 10                	cmp    $0x10,%al
80109f55:	75 3f                	jne    80109f96 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109f57:	a1 88 72 19 80       	mov    0x80197288,%eax
80109f5c:	83 f8 01             	cmp    $0x1,%eax
80109f5f:	75 35                	jne    80109f96 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109f61:	83 ec 0c             	sub    $0xc,%esp
80109f64:	6a 00                	push   $0x0
80109f66:	6a 01                	push   $0x1
80109f68:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f6b:	50                   	push   %eax
80109f6c:	ff 75 e8             	push   -0x18(%ebp)
80109f6f:	ff 75 08             	push   0x8(%ebp)
80109f72:	e8 31 00 00 00       	call   80109fa8 <tcp_pkt_create>
80109f77:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109f7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109f7d:	83 ec 08             	sub    $0x8,%esp
80109f80:	50                   	push   %eax
80109f81:	ff 75 e8             	push   -0x18(%ebp)
80109f84:	e8 f0 ef ff ff       	call   80108f79 <i8254_send>
80109f89:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109f8c:	c7 05 88 72 19 80 00 	movl   $0x0,0x80197288
80109f93:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f99:	83 ec 0c             	sub    $0xc,%esp
80109f9c:	50                   	push   %eax
80109f9d:	e8 49 87 ff ff       	call   801026eb <kfree>
80109fa2:	83 c4 10             	add    $0x10,%esp
}
80109fa5:	90                   	nop
80109fa6:	c9                   	leave  
80109fa7:	c3                   	ret    

80109fa8 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109fa8:	55                   	push   %ebp
80109fa9:	89 e5                	mov    %esp,%ebp
80109fab:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109fae:	8b 45 08             	mov    0x8(%ebp),%eax
80109fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80109fb7:	83 c0 0e             	add    $0xe,%eax
80109fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fc0:	0f b6 00             	movzbl (%eax),%eax
80109fc3:	0f b6 c0             	movzbl %al,%eax
80109fc6:	83 e0 0f             	and    $0xf,%eax
80109fc9:	c1 e0 02             	shl    $0x2,%eax
80109fcc:	89 c2                	mov    %eax,%edx
80109fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fd1:	01 d0                	add    %edx,%eax
80109fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80109fd9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80109fdf:	83 c0 0e             	add    $0xe,%eax
80109fe2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109fe5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109fe8:	83 c0 14             	add    $0x14,%eax
80109feb:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109fee:	8b 45 18             	mov    0x18(%ebp),%eax
80109ff1:	8d 50 36             	lea    0x36(%eax),%edx
80109ff4:	8b 45 10             	mov    0x10(%ebp),%eax
80109ff7:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ffc:	8d 50 06             	lea    0x6(%eax),%edx
80109fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a002:	83 ec 04             	sub    $0x4,%esp
8010a005:	6a 06                	push   $0x6
8010a007:	52                   	push   %edx
8010a008:	50                   	push   %eax
8010a009:	e8 dc ab ff ff       	call   80104bea <memmove>
8010a00e:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
8010a011:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a014:	83 c0 06             	add    $0x6,%eax
8010a017:	83 ec 04             	sub    $0x4,%esp
8010a01a:	6a 06                	push   $0x6
8010a01c:	68 a0 6f 19 80       	push   $0x80196fa0
8010a021:	50                   	push   %eax
8010a022:	e8 c3 ab ff ff       	call   80104bea <memmove>
8010a027:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010a02a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a02d:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010a031:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a034:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010a038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a03b:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010a03e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a041:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
8010a045:	8b 45 18             	mov    0x18(%ebp),%eax
8010a048:	83 c0 28             	add    $0x28,%eax
8010a04b:	0f b7 c0             	movzwl %ax,%eax
8010a04e:	83 ec 0c             	sub    $0xc,%esp
8010a051:	50                   	push   %eax
8010a052:	e8 9b f8 ff ff       	call   801098f2 <H2N_ushort>
8010a057:	83 c4 10             	add    $0x10,%esp
8010a05a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a05d:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
8010a061:	0f b7 15 80 72 19 80 	movzwl 0x80197280,%edx
8010a068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a06b:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
8010a06f:	0f b7 05 80 72 19 80 	movzwl 0x80197280,%eax
8010a076:	83 c0 01             	add    $0x1,%eax
8010a079:	66 a3 80 72 19 80    	mov    %ax,0x80197280
  ipv4_send->fragment = H2N_ushort(0x0000);
8010a07f:	83 ec 0c             	sub    $0xc,%esp
8010a082:	6a 00                	push   $0x0
8010a084:	e8 69 f8 ff ff       	call   801098f2 <H2N_ushort>
8010a089:	83 c4 10             	add    $0x10,%esp
8010a08c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a08f:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010a093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a096:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
8010a09a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a09d:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010a0a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0a4:	83 c0 0c             	add    $0xc,%eax
8010a0a7:	83 ec 04             	sub    $0x4,%esp
8010a0aa:	6a 04                	push   $0x4
8010a0ac:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a0b1:	50                   	push   %eax
8010a0b2:	e8 33 ab ff ff       	call   80104bea <memmove>
8010a0b7:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
8010a0ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0bd:	8d 50 0c             	lea    0xc(%eax),%edx
8010a0c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0c3:	83 c0 10             	add    $0x10,%eax
8010a0c6:	83 ec 04             	sub    $0x4,%esp
8010a0c9:	6a 04                	push   $0x4
8010a0cb:	52                   	push   %edx
8010a0cc:	50                   	push   %eax
8010a0cd:	e8 18 ab ff ff       	call   80104bea <memmove>
8010a0d2:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010a0d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0d8:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010a0de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a0e1:	83 ec 0c             	sub    $0xc,%esp
8010a0e4:	50                   	push   %eax
8010a0e5:	e8 08 f9 ff ff       	call   801099f2 <ipv4_chksum>
8010a0ea:	83 c4 10             	add    $0x10,%esp
8010a0ed:	0f b7 c0             	movzwl %ax,%eax
8010a0f0:	83 ec 0c             	sub    $0xc,%esp
8010a0f3:	50                   	push   %eax
8010a0f4:	e8 f9 f7 ff ff       	call   801098f2 <H2N_ushort>
8010a0f9:	83 c4 10             	add    $0x10,%esp
8010a0fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a0ff:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
8010a103:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a106:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010a10a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a10d:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
8010a110:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a113:	0f b7 10             	movzwl (%eax),%edx
8010a116:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a119:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
8010a11d:	a1 84 72 19 80       	mov    0x80197284,%eax
8010a122:	83 ec 0c             	sub    $0xc,%esp
8010a125:	50                   	push   %eax
8010a126:	e8 e9 f7 ff ff       	call   80109914 <H2N_uint>
8010a12b:	83 c4 10             	add    $0x10,%esp
8010a12e:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a131:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
8010a134:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a137:	8b 40 04             	mov    0x4(%eax),%eax
8010a13a:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
8010a140:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a143:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
8010a146:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a149:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
8010a14d:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a150:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
8010a154:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a157:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
8010a15b:	8b 45 14             	mov    0x14(%ebp),%eax
8010a15e:	89 c2                	mov    %eax,%edx
8010a160:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a163:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
8010a166:	83 ec 0c             	sub    $0xc,%esp
8010a169:	68 90 38 00 00       	push   $0x3890
8010a16e:	e8 7f f7 ff ff       	call   801098f2 <H2N_ushort>
8010a173:	83 c4 10             	add    $0x10,%esp
8010a176:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a179:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
8010a17d:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a180:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
8010a186:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a189:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
8010a18f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a192:	83 ec 0c             	sub    $0xc,%esp
8010a195:	50                   	push   %eax
8010a196:	e8 1f 00 00 00       	call   8010a1ba <tcp_chksum>
8010a19b:	83 c4 10             	add    $0x10,%esp
8010a19e:	83 c0 08             	add    $0x8,%eax
8010a1a1:	0f b7 c0             	movzwl %ax,%eax
8010a1a4:	83 ec 0c             	sub    $0xc,%esp
8010a1a7:	50                   	push   %eax
8010a1a8:	e8 45 f7 ff ff       	call   801098f2 <H2N_ushort>
8010a1ad:	83 c4 10             	add    $0x10,%esp
8010a1b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a1b3:	66 89 42 10          	mov    %ax,0x10(%edx)


}
8010a1b7:	90                   	nop
8010a1b8:	c9                   	leave  
8010a1b9:	c3                   	ret    

8010a1ba <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
8010a1ba:	55                   	push   %ebp
8010a1bb:	89 e5                	mov    %esp,%ebp
8010a1bd:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
8010a1c0:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
8010a1c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1c9:	83 c0 14             	add    $0x14,%eax
8010a1cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
8010a1cf:	83 ec 04             	sub    $0x4,%esp
8010a1d2:	6a 04                	push   $0x4
8010a1d4:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a1d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a1dc:	50                   	push   %eax
8010a1dd:	e8 08 aa ff ff       	call   80104bea <memmove>
8010a1e2:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a1e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1e8:	83 c0 0c             	add    $0xc,%eax
8010a1eb:	83 ec 04             	sub    $0x4,%esp
8010a1ee:	6a 04                	push   $0x4
8010a1f0:	50                   	push   %eax
8010a1f1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a1f4:	83 c0 04             	add    $0x4,%eax
8010a1f7:	50                   	push   %eax
8010a1f8:	e8 ed a9 ff ff       	call   80104bea <memmove>
8010a1fd:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a200:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a204:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a208:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a20b:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a20f:	0f b7 c0             	movzwl %ax,%eax
8010a212:	83 ec 0c             	sub    $0xc,%esp
8010a215:	50                   	push   %eax
8010a216:	e8 b5 f6 ff ff       	call   801098d0 <N2H_ushort>
8010a21b:	83 c4 10             	add    $0x10,%esp
8010a21e:	83 e8 14             	sub    $0x14,%eax
8010a221:	0f b7 c0             	movzwl %ax,%eax
8010a224:	83 ec 0c             	sub    $0xc,%esp
8010a227:	50                   	push   %eax
8010a228:	e8 c5 f6 ff ff       	call   801098f2 <H2N_ushort>
8010a22d:	83 c4 10             	add    $0x10,%esp
8010a230:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a23b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a23e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a241:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a248:	eb 33                	jmp    8010a27d <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a24d:	01 c0                	add    %eax,%eax
8010a24f:	89 c2                	mov    %eax,%edx
8010a251:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a254:	01 d0                	add    %edx,%eax
8010a256:	0f b6 00             	movzbl (%eax),%eax
8010a259:	0f b6 c0             	movzbl %al,%eax
8010a25c:	c1 e0 08             	shl    $0x8,%eax
8010a25f:	89 c2                	mov    %eax,%edx
8010a261:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a264:	01 c0                	add    %eax,%eax
8010a266:	8d 48 01             	lea    0x1(%eax),%ecx
8010a269:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a26c:	01 c8                	add    %ecx,%eax
8010a26e:	0f b6 00             	movzbl (%eax),%eax
8010a271:	0f b6 c0             	movzbl %al,%eax
8010a274:	01 d0                	add    %edx,%eax
8010a276:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a279:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a27d:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a281:	7e c7                	jle    8010a24a <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a286:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a289:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a290:	eb 33                	jmp    8010a2c5 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a292:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a295:	01 c0                	add    %eax,%eax
8010a297:	89 c2                	mov    %eax,%edx
8010a299:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a29c:	01 d0                	add    %edx,%eax
8010a29e:	0f b6 00             	movzbl (%eax),%eax
8010a2a1:	0f b6 c0             	movzbl %al,%eax
8010a2a4:	c1 e0 08             	shl    $0x8,%eax
8010a2a7:	89 c2                	mov    %eax,%edx
8010a2a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2ac:	01 c0                	add    %eax,%eax
8010a2ae:	8d 48 01             	lea    0x1(%eax),%ecx
8010a2b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2b4:	01 c8                	add    %ecx,%eax
8010a2b6:	0f b6 00             	movzbl (%eax),%eax
8010a2b9:	0f b6 c0             	movzbl %al,%eax
8010a2bc:	01 d0                	add    %edx,%eax
8010a2be:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a2c1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a2c5:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a2c9:	0f b7 c0             	movzwl %ax,%eax
8010a2cc:	83 ec 0c             	sub    $0xc,%esp
8010a2cf:	50                   	push   %eax
8010a2d0:	e8 fb f5 ff ff       	call   801098d0 <N2H_ushort>
8010a2d5:	83 c4 10             	add    $0x10,%esp
8010a2d8:	66 d1 e8             	shr    %ax
8010a2db:	0f b7 c0             	movzwl %ax,%eax
8010a2de:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a2e1:	7c af                	jl     8010a292 <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a2e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a2e6:	c1 e8 10             	shr    $0x10,%eax
8010a2e9:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a2ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a2ef:	f7 d0                	not    %eax
}
8010a2f1:	c9                   	leave  
8010a2f2:	c3                   	ret    

8010a2f3 <tcp_fin>:

void tcp_fin(){
8010a2f3:	55                   	push   %ebp
8010a2f4:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a2f6:	c7 05 88 72 19 80 01 	movl   $0x1,0x80197288
8010a2fd:	00 00 00 
}
8010a300:	90                   	nop
8010a301:	5d                   	pop    %ebp
8010a302:	c3                   	ret    

8010a303 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a303:	55                   	push   %ebp
8010a304:	89 e5                	mov    %esp,%ebp
8010a306:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a309:	8b 45 10             	mov    0x10(%ebp),%eax
8010a30c:	83 ec 04             	sub    $0x4,%esp
8010a30f:	6a 00                	push   $0x0
8010a311:	68 cb c4 10 80       	push   $0x8010c4cb
8010a316:	50                   	push   %eax
8010a317:	e8 65 00 00 00       	call   8010a381 <http_strcpy>
8010a31c:	83 c4 10             	add    $0x10,%esp
8010a31f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a322:	8b 45 10             	mov    0x10(%ebp),%eax
8010a325:	83 ec 04             	sub    $0x4,%esp
8010a328:	ff 75 f4             	push   -0xc(%ebp)
8010a32b:	68 de c4 10 80       	push   $0x8010c4de
8010a330:	50                   	push   %eax
8010a331:	e8 4b 00 00 00       	call   8010a381 <http_strcpy>
8010a336:	83 c4 10             	add    $0x10,%esp
8010a339:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a33c:	8b 45 10             	mov    0x10(%ebp),%eax
8010a33f:	83 ec 04             	sub    $0x4,%esp
8010a342:	ff 75 f4             	push   -0xc(%ebp)
8010a345:	68 f9 c4 10 80       	push   $0x8010c4f9
8010a34a:	50                   	push   %eax
8010a34b:	e8 31 00 00 00       	call   8010a381 <http_strcpy>
8010a350:	83 c4 10             	add    $0x10,%esp
8010a353:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a356:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a359:	83 e0 01             	and    $0x1,%eax
8010a35c:	85 c0                	test   %eax,%eax
8010a35e:	74 11                	je     8010a371 <http_proc+0x6e>
    char *payload = (char *)send;
8010a360:	8b 45 10             	mov    0x10(%ebp),%eax
8010a363:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a366:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a36c:	01 d0                	add    %edx,%eax
8010a36e:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a371:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a374:	8b 45 14             	mov    0x14(%ebp),%eax
8010a377:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a379:	e8 75 ff ff ff       	call   8010a2f3 <tcp_fin>
}
8010a37e:	90                   	nop
8010a37f:	c9                   	leave  
8010a380:	c3                   	ret    

8010a381 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a381:	55                   	push   %ebp
8010a382:	89 e5                	mov    %esp,%ebp
8010a384:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a38e:	eb 20                	jmp    8010a3b0 <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a390:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a393:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a396:	01 d0                	add    %edx,%eax
8010a398:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a39b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a39e:	01 ca                	add    %ecx,%edx
8010a3a0:	89 d1                	mov    %edx,%ecx
8010a3a2:	8b 55 08             	mov    0x8(%ebp),%edx
8010a3a5:	01 ca                	add    %ecx,%edx
8010a3a7:	0f b6 00             	movzbl (%eax),%eax
8010a3aa:	88 02                	mov    %al,(%edx)
    i++;
8010a3ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a3b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a3b3:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a3b6:	01 d0                	add    %edx,%eax
8010a3b8:	0f b6 00             	movzbl (%eax),%eax
8010a3bb:	84 c0                	test   %al,%al
8010a3bd:	75 d1                	jne    8010a390 <http_strcpy+0xf>
  }
  return i;
8010a3bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a3c2:	c9                   	leave  
8010a3c3:	c3                   	ret    

8010a3c4 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a3c4:	55                   	push   %ebp
8010a3c5:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a3c7:	c7 05 90 72 19 80 a2 	movl   $0x8010f5a2,0x80197290
8010a3ce:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a3d1:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a3d6:	c1 e8 09             	shr    $0x9,%eax
8010a3d9:	a3 8c 72 19 80       	mov    %eax,0x8019728c
}
8010a3de:	90                   	nop
8010a3df:	5d                   	pop    %ebp
8010a3e0:	c3                   	ret    

8010a3e1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a3e1:	55                   	push   %ebp
8010a3e2:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a3e4:	90                   	nop
8010a3e5:	5d                   	pop    %ebp
8010a3e6:	c3                   	ret    

8010a3e7 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a3e7:	55                   	push   %ebp
8010a3e8:	89 e5                	mov    %esp,%ebp
8010a3ea:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a3ed:	8b 45 08             	mov    0x8(%ebp),%eax
8010a3f0:	83 c0 0c             	add    $0xc,%eax
8010a3f3:	83 ec 0c             	sub    $0xc,%esp
8010a3f6:	50                   	push   %eax
8010a3f7:	e8 28 a4 ff ff       	call   80104824 <holdingsleep>
8010a3fc:	83 c4 10             	add    $0x10,%esp
8010a3ff:	85 c0                	test   %eax,%eax
8010a401:	75 0d                	jne    8010a410 <iderw+0x29>
    panic("iderw: buf not locked");
8010a403:	83 ec 0c             	sub    $0xc,%esp
8010a406:	68 0a c5 10 80       	push   $0x8010c50a
8010a40b:	e8 99 61 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a410:	8b 45 08             	mov    0x8(%ebp),%eax
8010a413:	8b 00                	mov    (%eax),%eax
8010a415:	83 e0 06             	and    $0x6,%eax
8010a418:	83 f8 02             	cmp    $0x2,%eax
8010a41b:	75 0d                	jne    8010a42a <iderw+0x43>
    panic("iderw: nothing to do");
8010a41d:	83 ec 0c             	sub    $0xc,%esp
8010a420:	68 20 c5 10 80       	push   $0x8010c520
8010a425:	e8 7f 61 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a42a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a42d:	8b 40 04             	mov    0x4(%eax),%eax
8010a430:	83 f8 01             	cmp    $0x1,%eax
8010a433:	74 0d                	je     8010a442 <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a435:	83 ec 0c             	sub    $0xc,%esp
8010a438:	68 35 c5 10 80       	push   $0x8010c535
8010a43d:	e8 67 61 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a442:	8b 45 08             	mov    0x8(%ebp),%eax
8010a445:	8b 40 08             	mov    0x8(%eax),%eax
8010a448:	8b 15 8c 72 19 80    	mov    0x8019728c,%edx
8010a44e:	39 d0                	cmp    %edx,%eax
8010a450:	72 0d                	jb     8010a45f <iderw+0x78>
    panic("iderw: block out of range");
8010a452:	83 ec 0c             	sub    $0xc,%esp
8010a455:	68 53 c5 10 80       	push   $0x8010c553
8010a45a:	e8 4a 61 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a45f:	8b 15 90 72 19 80    	mov    0x80197290,%edx
8010a465:	8b 45 08             	mov    0x8(%ebp),%eax
8010a468:	8b 40 08             	mov    0x8(%eax),%eax
8010a46b:	c1 e0 09             	shl    $0x9,%eax
8010a46e:	01 d0                	add    %edx,%eax
8010a470:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a473:	8b 45 08             	mov    0x8(%ebp),%eax
8010a476:	8b 00                	mov    (%eax),%eax
8010a478:	83 e0 04             	and    $0x4,%eax
8010a47b:	85 c0                	test   %eax,%eax
8010a47d:	74 2b                	je     8010a4aa <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a47f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a482:	8b 00                	mov    (%eax),%eax
8010a484:	83 e0 fb             	and    $0xfffffffb,%eax
8010a487:	89 c2                	mov    %eax,%edx
8010a489:	8b 45 08             	mov    0x8(%ebp),%eax
8010a48c:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a48e:	8b 45 08             	mov    0x8(%ebp),%eax
8010a491:	83 c0 5c             	add    $0x5c,%eax
8010a494:	83 ec 04             	sub    $0x4,%esp
8010a497:	68 00 02 00 00       	push   $0x200
8010a49c:	50                   	push   %eax
8010a49d:	ff 75 f4             	push   -0xc(%ebp)
8010a4a0:	e8 45 a7 ff ff       	call   80104bea <memmove>
8010a4a5:	83 c4 10             	add    $0x10,%esp
8010a4a8:	eb 1a                	jmp    8010a4c4 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a4aa:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4ad:	83 c0 5c             	add    $0x5c,%eax
8010a4b0:	83 ec 04             	sub    $0x4,%esp
8010a4b3:	68 00 02 00 00       	push   $0x200
8010a4b8:	ff 75 f4             	push   -0xc(%ebp)
8010a4bb:	50                   	push   %eax
8010a4bc:	e8 29 a7 ff ff       	call   80104bea <memmove>
8010a4c1:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a4c4:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4c7:	8b 00                	mov    (%eax),%eax
8010a4c9:	83 c8 02             	or     $0x2,%eax
8010a4cc:	89 c2                	mov    %eax,%edx
8010a4ce:	8b 45 08             	mov    0x8(%ebp),%eax
8010a4d1:	89 10                	mov    %edx,(%eax)
}
8010a4d3:	90                   	nop
8010a4d4:	c9                   	leave  
8010a4d5:	c3                   	ret    
