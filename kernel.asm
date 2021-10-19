
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 32 10 80       	mov    $0x80103230,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 75 10 80       	push   $0x80107520
80100055:	68 20 a5 10 80       	push   $0x8010a520
8010005a:	e8 d1 45 00 00       	call   80104630 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006e:	ec 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100078:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 75 10 80       	push   $0x80107527
80100097:	50                   	push   %eax
80100098:	e8 53 44 00 00       	call   801044f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 75 08             	mov    0x8(%ebp),%esi
801000e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e3:	68 20 a5 10 80       	push   $0x8010a520
801000e8:	e8 43 47 00 00       	call   80104830 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 59 46 00 00       	call   801047c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 43 00 00       	call   80104530 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 df 22 00 00       	call   80102470 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 75 10 80       	push   $0x8010752e
801001a6:	e8 e5 01 00 00       	call   80100390 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 09 44 00 00       	call   801045d0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 93 22 00 00       	jmp    80102470 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 75 10 80       	push   $0x8010753f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 c8 43 00 00       	call   801045d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 43 00 00       	call   80104590 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021f:	e8 0c 46 00 00       	call   80104830 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 4b 45 00 00       	jmp    801047c0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 75 10 80       	push   $0x80107546
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
8010029d:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002a3:	ff 75 08             	push   0x8(%ebp)
  target = n;
801002a6:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002a8:	e8 13 17 00 00       	call   801019c0 <iunlock>
  acquire(&cons.lock);
801002ad:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002b4:	e8 77 45 00 00       	call   80104830 <acquire>
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
801002bc:	85 db                	test   %ebx,%ebx
801002be:	0f 8e 98 00 00 00    	jle    8010035c <consoleread+0xcc>
    while(input.r == input.w){
801002c4:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002c9:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002cf:	74 29                	je     801002fa <consoleread+0x6a>
801002d1:	eb 5d                	jmp    80100330 <consoleread+0xa0>
801002d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801002d7:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 ef 10 80       	push   $0x8010ef20
801002e0:	68 00 ef 10 80       	push   $0x8010ef00
801002e5:	e8 86 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002ea:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 81 38 00 00       	call   80103b80 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 ef 10 80       	push   $0x8010ef20
8010030e:	e8 ad 44 00 00       	call   801047c0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	push   0x8(%ebp)
80100317:	e8 c4 15 00 00       	call   801018e0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 37                	je     80100381 <consoleread+0xf1>
    *dst++ = c;
8010034a:	83 c6 01             	add    $0x1,%esi
    --n;
8010034d:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100350:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
80100353:	83 f9 0a             	cmp    $0xa,%ecx
80100356:	0f 85 60 ff ff ff    	jne    801002bc <consoleread+0x2c>
  release(&cons.lock);
8010035c:	83 ec 0c             	sub    $0xc,%esp
8010035f:	68 20 ef 10 80       	push   $0x8010ef20
80100364:	e8 57 44 00 00       	call   801047c0 <release>
  ilock(ip);
80100369:	58                   	pop    %eax
8010036a:	ff 75 08             	push   0x8(%ebp)
8010036d:	e8 6e 15 00 00       	call   801018e0 <ilock>
  return target - n;
80100372:	89 f8                	mov    %edi,%eax
80100374:	83 c4 10             	add    $0x10,%esp
}
80100377:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037a:	29 d8                	sub    %ebx,%eax
}
8010037c:	5b                   	pop    %ebx
8010037d:	5e                   	pop    %esi
8010037e:	5f                   	pop    %edi
8010037f:	5d                   	pop    %ebp
80100380:	c3                   	ret    
      if(n < target){
80100381:	39 fb                	cmp    %edi,%ebx
80100383:	73 d7                	jae    8010035c <consoleread+0xcc>
        input.r--;
80100385:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
8010038a:	eb d0                	jmp    8010035c <consoleread+0xcc>
8010038c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 de 26 00 00       	call   80102a90 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 75 10 80       	push   $0x8010754d
801003bb:	e8 d0 02 00 00       	call   80100690 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	push   0x8(%ebp)
801003c4:	e8 c7 02 00 00       	call   80100690 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 77 7e 10 80 	movl   $0x80107e77,(%esp)
801003d0:	e8 bb 02 00 00       	call   80100690 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 6f 42 00 00       	call   80104650 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
801003e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003e8:	83 ec 08             	sub    $0x8,%esp
801003eb:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003ed:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003f0:	68 61 75 10 80       	push   $0x80107561
801003f5:	e8 96 02 00 00       	call   80100690 <cprintf>
  for(i=0; i<10; i++)
801003fa:	83 c4 10             	add    $0x10,%esp
801003fd:	39 f3                	cmp    %esi,%ebx
801003ff:	75 e7                	jne    801003e8 <panic+0x58>
  panicked = 1; // freeze other CPU
80100401:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
80100408:	00 00 00 
  for(;;)
8010040b:	eb fe                	jmp    8010040b <panic+0x7b>
8010040d:	8d 76 00             	lea    0x0(%esi),%esi

80100410 <cgaputc>:
{
80100410:	55                   	push   %ebp
80100411:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 e5                	mov    %esp,%ebp
8010041a:	57                   	push   %edi
8010041b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100420:	56                   	push   %esi
80100421:	89 fa                	mov    %edi,%edx
80100423:	53                   	push   %ebx
80100424:	83 ec 1c             	sub    $0x1c,%esp
80100427:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100428:	be d5 03 00 00       	mov    $0x3d5,%esi
8010042d:	89 f2                	mov    %esi,%edx
8010042f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100430:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100433:	89 fa                	mov    %edi,%edx
80100435:	c1 e0 08             	shl    $0x8,%eax
80100438:	89 c3                	mov    %eax,%ebx
8010043a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100440:	89 f2                	mov    %esi,%edx
80100442:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100443:	0f b6 c0             	movzbl %al,%eax
80100446:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100448:	83 f9 0a             	cmp    $0xa,%ecx
8010044b:	0f 84 97 00 00 00    	je     801004e8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100451:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100457:	74 77                	je     801004d0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100459:	0f b6 c9             	movzbl %cl,%ecx
8010045c:	8d 58 01             	lea    0x1(%eax),%ebx
8010045f:	80 cd 07             	or     $0x7,%ch
80100462:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100469:	80 
  if(pos < 0 || pos > 25*80)
8010046a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100470:	0f 8f cc 00 00 00    	jg     80100542 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100476:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010047c:	0f 8f 7e 00 00 00    	jg     80100500 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100482:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100485:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100487:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010048e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100491:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100496:	b8 0e 00 00 00       	mov    $0xe,%eax
8010049b:	89 da                	mov    %ebx,%edx
8010049d:	ee                   	out    %al,(%dx)
8010049e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004a7:	89 ca                	mov    %ecx,%edx
801004a9:	ee                   	out    %al,(%dx)
801004aa:	b8 0f 00 00 00       	mov    $0xf,%eax
801004af:	89 da                	mov    %ebx,%edx
801004b1:	ee                   	out    %al,(%dx)
801004b2:	89 f8                	mov    %edi,%eax
801004b4:	89 ca                	mov    %ecx,%edx
801004b6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b7:	b8 20 07 00 00       	mov    $0x720,%eax
801004bc:	66 89 06             	mov    %ax,(%esi)
}
801004bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c2:	5b                   	pop    %ebx
801004c3:	5e                   	pop    %esi
801004c4:	5f                   	pop    %edi
801004c5:	5d                   	pop    %ebp
801004c6:	c3                   	ret    
801004c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004ce:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 93                	jne    8010046a <cgaputc+0x5a>
801004d7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb ad                	jmp    80100491 <cgaputc+0x81>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 58 50             	lea    0x50(%eax),%ebx
801004fb:	e9 6a ff ff ff       	jmp    8010046a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100500:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100503:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100506:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010050d:	68 60 0e 00 00       	push   $0xe60
80100512:	68 a0 80 0b 80       	push   $0x800b80a0
80100517:	68 00 80 0b 80       	push   $0x800b8000
8010051c:	e8 7f 44 00 00       	call   801049a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100521:	b8 80 07 00 00       	mov    $0x780,%eax
80100526:	83 c4 0c             	add    $0xc,%esp
80100529:	29 f8                	sub    %edi,%eax
8010052b:	01 c0                	add    %eax,%eax
8010052d:	50                   	push   %eax
8010052e:	6a 00                	push   $0x0
80100530:	56                   	push   %esi
80100531:	e8 ca 43 00 00       	call   80104900 <memset>
  outb(CRTPORT+1, pos);
80100536:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010053a:	83 c4 10             	add    $0x10,%esp
8010053d:	e9 4f ff ff ff       	jmp    80100491 <cgaputc+0x81>
    panic("pos under/overflow");
80100542:	83 ec 0c             	sub    $0xc,%esp
80100545:	68 65 75 10 80       	push   $0x80107565
8010054a:	e8 41 fe ff ff       	call   80100390 <panic>
8010054f:	90                   	nop

80100550 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100550:	f3 0f 1e fb          	endbr32 
80100554:	55                   	push   %ebp
80100555:	89 e5                	mov    %esp,%ebp
80100557:	57                   	push   %edi
80100558:	56                   	push   %esi
80100559:	53                   	push   %ebx
8010055a:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
8010055d:	ff 75 08             	push   0x8(%ebp)
{
80100560:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
80100563:	e8 58 14 00 00       	call   801019c0 <iunlock>
  acquire(&cons.lock);
80100568:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010056f:	e8 bc 42 00 00       	call   80104830 <acquire>
  for(i = 0; i < n; i++)
80100574:	83 c4 10             	add    $0x10,%esp
80100577:	85 f6                	test   %esi,%esi
80100579:	7e 36                	jle    801005b1 <consolewrite+0x61>
8010057b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010057e:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
80100581:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100587:	85 d2                	test   %edx,%edx
80100589:	74 05                	je     80100590 <consolewrite+0x40>
  asm volatile("cli");
8010058b:	fa                   	cli    
    for(;;)
8010058c:	eb fe                	jmp    8010058c <consolewrite+0x3c>
8010058e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100590:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100593:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100596:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100599:	50                   	push   %eax
8010059a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010059d:	e8 8e 5a 00 00       	call   80106030 <uartputc>
  cgaputc(c);
801005a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801005a5:	e8 66 fe ff ff       	call   80100410 <cgaputc>
  for(i = 0; i < n; i++)
801005aa:	83 c4 10             	add    $0x10,%esp
801005ad:	39 df                	cmp    %ebx,%edi
801005af:	75 d0                	jne    80100581 <consolewrite+0x31>
  release(&cons.lock);
801005b1:	83 ec 0c             	sub    $0xc,%esp
801005b4:	68 20 ef 10 80       	push   $0x8010ef20
801005b9:	e8 02 42 00 00       	call   801047c0 <release>
  ilock(ip);
801005be:	58                   	pop    %eax
801005bf:	ff 75 08             	push   0x8(%ebp)
801005c2:	e8 19 13 00 00       	call   801018e0 <ilock>

  return n;
}
801005c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ca:	89 f0                	mov    %esi,%eax
801005cc:	5b                   	pop    %ebx
801005cd:	5e                   	pop    %esi
801005ce:	5f                   	pop    %edi
801005cf:	5d                   	pop    %ebp
801005d0:	c3                   	ret    
801005d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005df:	90                   	nop

801005e0 <printint>:
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 2c             	sub    $0x2c,%esp
801005e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005ef:	85 c9                	test   %ecx,%ecx
801005f1:	74 04                	je     801005f7 <printint+0x17>
801005f3:	85 c0                	test   %eax,%eax
801005f5:	78 7e                	js     80100675 <printint+0x95>
    x = xx;
801005f7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005fe:	89 c1                	mov    %eax,%ecx
  i = 0;
80100600:	31 db                	xor    %ebx,%ebx
80100602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100608:	89 c8                	mov    %ecx,%eax
8010060a:	31 d2                	xor    %edx,%edx
8010060c:	89 de                	mov    %ebx,%esi
8010060e:	89 cf                	mov    %ecx,%edi
80100610:	f7 75 d4             	divl   -0x2c(%ebp)
80100613:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100616:	0f b6 92 90 75 10 80 	movzbl -0x7fef8a70(%edx),%edx
  }while((x /= base) != 0);
8010061d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010061f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100623:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100626:	73 e0                	jae    80100608 <printint+0x28>
  if(sign)
80100628:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010062b:	85 c9                	test   %ecx,%ecx
8010062d:	74 0c                	je     8010063b <printint+0x5b>
    buf[i++] = '-';
8010062f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100634:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100636:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010063b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010063f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100644:	85 c0                	test   %eax,%eax
80100646:	74 08                	je     80100650 <printint+0x70>
80100648:	fa                   	cli    
    for(;;)
80100649:	eb fe                	jmp    80100649 <printint+0x69>
8010064b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010064f:	90                   	nop
    consputc(buf[i]);
80100650:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100653:	83 ec 0c             	sub    $0xc,%esp
80100656:	56                   	push   %esi
80100657:	e8 d4 59 00 00       	call   80106030 <uartputc>
  cgaputc(c);
8010065c:	89 f0                	mov    %esi,%eax
8010065e:	e8 ad fd ff ff       	call   80100410 <cgaputc>
  while(--i >= 0)
80100663:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100666:	83 c4 10             	add    $0x10,%esp
80100669:	39 c3                	cmp    %eax,%ebx
8010066b:	74 0e                	je     8010067b <printint+0x9b>
    consputc(buf[i]);
8010066d:	0f b6 13             	movzbl (%ebx),%edx
80100670:	83 eb 01             	sub    $0x1,%ebx
80100673:	eb ca                	jmp    8010063f <printint+0x5f>
    x = -xx;
80100675:	f7 d8                	neg    %eax
80100677:	89 c1                	mov    %eax,%ecx
80100679:	eb 85                	jmp    80100600 <printint+0x20>
}
8010067b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010067e:	5b                   	pop    %ebx
8010067f:	5e                   	pop    %esi
80100680:	5f                   	pop    %edi
80100681:	5d                   	pop    %ebp
80100682:	c3                   	ret    
80100683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100690 <cprintf>:
{
80100690:	f3 0f 1e fb          	endbr32 
80100694:	55                   	push   %ebp
80100695:	89 e5                	mov    %esp,%ebp
80100697:	57                   	push   %edi
80100698:	56                   	push   %esi
80100699:	53                   	push   %ebx
8010069a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010069d:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006a5:	85 c0                	test   %eax,%eax
801006a7:	0f 85 33 01 00 00    	jne    801007e0 <cprintf+0x150>
  if (fmt == 0)
801006ad:	8b 75 08             	mov    0x8(%ebp),%esi
801006b0:	85 f6                	test   %esi,%esi
801006b2:	0f 84 3b 02 00 00    	je     801008f3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006b8:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006bb:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006be:	31 db                	xor    %ebx,%ebx
801006c0:	85 c0                	test   %eax,%eax
801006c2:	74 56                	je     8010071a <cprintf+0x8a>
    if(c != '%'){
801006c4:	83 f8 25             	cmp    $0x25,%eax
801006c7:	0f 85 d3 00 00 00    	jne    801007a0 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006cd:	83 c3 01             	add    $0x1,%ebx
801006d0:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006d4:	85 d2                	test   %edx,%edx
801006d6:	74 42                	je     8010071a <cprintf+0x8a>
    switch(c){
801006d8:	83 fa 70             	cmp    $0x70,%edx
801006db:	0f 84 90 00 00 00    	je     80100771 <cprintf+0xe1>
801006e1:	7f 4d                	jg     80100730 <cprintf+0xa0>
801006e3:	83 fa 25             	cmp    $0x25,%edx
801006e6:	0f 84 44 01 00 00    	je     80100830 <cprintf+0x1a0>
801006ec:	83 fa 64             	cmp    $0x64,%edx
801006ef:	0f 85 00 01 00 00    	jne    801007f5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006f5:	8d 47 04             	lea    0x4(%edi),%eax
801006f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801006fd:	ba 0a 00 00 00       	mov    $0xa,%edx
80100702:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100705:	8b 07                	mov    (%edi),%eax
80100707:	e8 d4 fe ff ff       	call   801005e0 <printint>
8010070c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070f:	83 c3 01             	add    $0x1,%ebx
80100712:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100716:	85 c0                	test   %eax,%eax
80100718:	75 aa                	jne    801006c4 <cprintf+0x34>
  if(locking)
8010071a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071d:	85 c0                	test   %eax,%eax
8010071f:	0f 85 b1 01 00 00    	jne    801008d6 <cprintf+0x246>
}
80100725:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100728:	5b                   	pop    %ebx
80100729:	5e                   	pop    %esi
8010072a:	5f                   	pop    %edi
8010072b:	5d                   	pop    %ebp
8010072c:	c3                   	ret    
8010072d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	75 33                	jne    80100768 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100735:	8d 47 04             	lea    0x4(%edi),%eax
80100738:	8b 3f                	mov    (%edi),%edi
8010073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010073d:	85 ff                	test   %edi,%edi
8010073f:	0f 85 33 01 00 00    	jne    80100878 <cprintf+0x1e8>
        s = "(null)";
80100745:	bf 78 75 10 80       	mov    $0x80107578,%edi
      for(; *s; s++)
8010074a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010074d:	b8 28 00 00 00       	mov    $0x28,%eax
80100752:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100754:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 84 27 01 00 00    	je     80100889 <cprintf+0x1f9>
80100762:	fa                   	cli    
    for(;;)
80100763:	eb fe                	jmp    80100763 <cprintf+0xd3>
80100765:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100768:	83 fa 78             	cmp    $0x78,%edx
8010076b:	0f 85 84 00 00 00    	jne    801007f5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100771:	8d 47 04             	lea    0x4(%edi),%eax
80100774:	31 c9                	xor    %ecx,%ecx
80100776:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010077e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100781:	8b 07                	mov    (%edi),%eax
80100783:	e8 58 fe ff ff       	call   801005e0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100788:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010078c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010078f:	85 c0                	test   %eax,%eax
80100791:	0f 85 2d ff ff ff    	jne    801006c4 <cprintf+0x34>
80100797:	eb 81                	jmp    8010071a <cprintf+0x8a>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007a0:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007a6:	85 c9                	test   %ecx,%ecx
801007a8:	74 06                	je     801007b0 <cprintf+0x120>
801007aa:	fa                   	cli    
    for(;;)
801007ab:	eb fe                	jmp    801007ab <cprintf+0x11b>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007b0:	83 ec 0c             	sub    $0xc,%esp
801007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007b9:	50                   	push   %eax
801007ba:	e8 71 58 00 00       	call   80106030 <uartputc>
  cgaputc(c);
801007bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007c2:	e8 49 fc ff ff       	call   80100410 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007c7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007cb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ce:	85 c0                	test   %eax,%eax
801007d0:	0f 85 ee fe ff ff    	jne    801006c4 <cprintf+0x34>
801007d6:	e9 3f ff ff ff       	jmp    8010071a <cprintf+0x8a>
801007db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 43 40 00 00       	call   80104830 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 b8 fe ff ff       	jmp    801006ad <cprintf+0x1d>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 71                	jne    80100870 <cprintf+0x1e0>
    uartputc(c);
801007ff:	83 ec 0c             	sub    $0xc,%esp
80100802:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100805:	6a 25                	push   $0x25
80100807:	e8 24 58 00 00       	call   80106030 <uartputc>
  cgaputc(c);
8010080c:	b8 25 00 00 00       	mov    $0x25,%eax
80100811:	e8 fa fb ff ff       	call   80100410 <cgaputc>
  if(panicked){
80100816:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010081c:	83 c4 10             	add    $0x10,%esp
8010081f:	85 d2                	test   %edx,%edx
80100821:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100824:	0f 84 8e 00 00 00    	je     801008b8 <cprintf+0x228>
8010082a:	fa                   	cli    
    for(;;)
8010082b:	eb fe                	jmp    8010082b <cprintf+0x19b>
8010082d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100830:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100835:	85 c0                	test   %eax,%eax
80100837:	74 07                	je     80100840 <cprintf+0x1b0>
80100839:	fa                   	cli    
    for(;;)
8010083a:	eb fe                	jmp    8010083a <cprintf+0x1aa>
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100840:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100843:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100846:	6a 25                	push   $0x25
80100848:	e8 e3 57 00 00       	call   80106030 <uartputc>
  cgaputc(c);
8010084d:	b8 25 00 00 00       	mov    $0x25,%eax
80100852:	e8 b9 fb ff ff       	call   80100410 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100857:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010085b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010085e:	85 c0                	test   %eax,%eax
80100860:	0f 85 5e fe ff ff    	jne    801006c4 <cprintf+0x34>
80100866:	e9 af fe ff ff       	jmp    8010071a <cprintf+0x8a>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
80100870:	fa                   	cli    
    for(;;)
80100871:	eb fe                	jmp    80100871 <cprintf+0x1e1>
80100873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100877:	90                   	nop
      for(; *s; s++)
80100878:	0f b6 07             	movzbl (%edi),%eax
8010087b:	84 c0                	test   %al,%al
8010087d:	74 6c                	je     801008eb <cprintf+0x25b>
8010087f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100882:	89 fb                	mov    %edi,%ebx
80100884:	e9 cb fe ff ff       	jmp    80100754 <cprintf+0xc4>
    uartputc(c);
80100889:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010088c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010088f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100892:	57                   	push   %edi
80100893:	e8 98 57 00 00       	call   80106030 <uartputc>
  cgaputc(c);
80100898:	89 f8                	mov    %edi,%eax
8010089a:	e8 71 fb ff ff       	call   80100410 <cgaputc>
      for(; *s; s++)
8010089f:	0f b6 03             	movzbl (%ebx),%eax
801008a2:	83 c4 10             	add    $0x10,%esp
801008a5:	84 c0                	test   %al,%al
801008a7:	0f 85 a7 fe ff ff    	jne    80100754 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
801008ad:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008b0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008b3:	e9 57 fe ff ff       	jmp    8010070f <cprintf+0x7f>
    uartputc(c);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008be:	52                   	push   %edx
801008bf:	e8 6c 57 00 00       	call   80106030 <uartputc>
  cgaputc(c);
801008c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008c7:	89 d0                	mov    %edx,%eax
801008c9:	e8 42 fb ff ff       	call   80100410 <cgaputc>
}
801008ce:	83 c4 10             	add    $0x10,%esp
801008d1:	e9 39 fe ff ff       	jmp    8010070f <cprintf+0x7f>
    release(&cons.lock);
801008d6:	83 ec 0c             	sub    $0xc,%esp
801008d9:	68 20 ef 10 80       	push   $0x8010ef20
801008de:	e8 dd 3e 00 00       	call   801047c0 <release>
801008e3:	83 c4 10             	add    $0x10,%esp
}
801008e6:	e9 3a fe ff ff       	jmp    80100725 <cprintf+0x95>
      if((s = (char*)*argp++) == 0)
801008eb:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008ee:	e9 1c fe ff ff       	jmp    8010070f <cprintf+0x7f>
    panic("null fmt");
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	68 7f 75 10 80       	push   $0x8010757f
801008fb:	e8 90 fa ff ff       	call   80100390 <panic>

80100900 <consoleintr>:
{
80100900:	f3 0f 1e fb          	endbr32 
80100904:	55                   	push   %ebp
80100905:	89 e5                	mov    %esp,%ebp
80100907:	57                   	push   %edi
80100908:	56                   	push   %esi
80100909:	53                   	push   %ebx
  int c, doprocdump = 0;
8010090a:	31 db                	xor    %ebx,%ebx
{
8010090c:	83 ec 28             	sub    $0x28,%esp
8010090f:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100912:	68 20 ef 10 80       	push   $0x8010ef20
80100917:	e8 14 3f 00 00       	call   80104830 <acquire>
  while((c = getc()) >= 0){
8010091c:	83 c4 10             	add    $0x10,%esp
8010091f:	eb 1e                	jmp    8010093f <consoleintr+0x3f>
80100921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100928:	83 f8 08             	cmp    $0x8,%eax
8010092b:	0f 84 0f 01 00 00    	je     80100a40 <consoleintr+0x140>
80100931:	83 f8 10             	cmp    $0x10,%eax
80100934:	0f 85 92 01 00 00    	jne    80100acc <consoleintr+0x1cc>
8010093a:	bb 01 00 00 00       	mov    $0x1,%ebx
  while((c = getc()) >= 0){
8010093f:	ff d6                	call   *%esi
80100941:	85 c0                	test   %eax,%eax
80100943:	0f 88 67 01 00 00    	js     80100ab0 <consoleintr+0x1b0>
    switch(c){
80100949:	83 f8 15             	cmp    $0x15,%eax
8010094c:	0f 84 b6 00 00 00    	je     80100a08 <consoleintr+0x108>
80100952:	7e d4                	jle    80100928 <consoleintr+0x28>
80100954:	83 f8 7f             	cmp    $0x7f,%eax
80100957:	0f 84 e3 00 00 00    	je     80100a40 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010095d:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100963:	89 d1                	mov    %edx,%ecx
80100965:	2b 0d 00 ef 10 80    	sub    0x8010ef00,%ecx
8010096b:	83 f9 7f             	cmp    $0x7f,%ecx
8010096e:	77 cf                	ja     8010093f <consoleintr+0x3f>
        input.buf[input.e++ % INPUT_BUF] = c;
80100970:	89 d1                	mov    %edx,%ecx
80100972:	83 c2 01             	add    $0x1,%edx
  if(panicked){
80100975:	8b 3d 58 ef 10 80    	mov    0x8010ef58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
8010097b:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100981:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
80100984:	83 f8 0d             	cmp    $0xd,%eax
80100987:	0f 84 93 01 00 00    	je     80100b20 <consoleintr+0x220>
        input.buf[input.e++ % INPUT_BUF] = c;
8010098d:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
80100993:	85 ff                	test   %edi,%edi
80100995:	0f 85 90 01 00 00    	jne    80100b2b <consoleintr+0x22b>
  if(c == BACKSPACE){
8010099b:	3d 00 01 00 00       	cmp    $0x100,%eax
801009a0:	0f 85 ab 01 00 00    	jne    80100b51 <consoleintr+0x251>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801009a6:	83 ec 0c             	sub    $0xc,%esp
801009a9:	6a 08                	push   $0x8
801009ab:	e8 80 56 00 00       	call   80106030 <uartputc>
801009b0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801009b7:	e8 74 56 00 00       	call   80106030 <uartputc>
801009bc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801009c3:	e8 68 56 00 00       	call   80106030 <uartputc>
  cgaputc(c);
801009c8:	b8 00 01 00 00       	mov    $0x100,%eax
801009cd:	e8 3e fa ff ff       	call   80100410 <cgaputc>
801009d2:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009d5:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009da:	83 e8 80             	sub    $0xffffff80,%eax
801009dd:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009e3:	0f 85 56 ff ff ff    	jne    8010093f <consoleintr+0x3f>
          wakeup(&input.r);
801009e9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009ec:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801009f1:	68 00 ef 10 80       	push   $0x8010ef00
801009f6:	e8 35 39 00 00       	call   80104330 <wakeup>
801009fb:	83 c4 10             	add    $0x10,%esp
801009fe:	e9 3c ff ff ff       	jmp    8010093f <consoleintr+0x3f>
80100a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a07:	90                   	nop
      while(input.e != input.w &&
80100a08:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a0d:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a13:	0f 84 26 ff ff ff    	je     8010093f <consoleintr+0x3f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a19:	83 e8 01             	sub    $0x1,%eax
80100a1c:	89 c2                	mov    %eax,%edx
80100a1e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a21:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a28:	0f 84 11 ff ff ff    	je     8010093f <consoleintr+0x3f>
  if(panicked){
80100a2e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a34:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a39:	85 d2                	test   %edx,%edx
80100a3b:	74 2b                	je     80100a68 <consoleintr+0x168>
80100a3d:	fa                   	cli    
    for(;;)
80100a3e:	eb fe                	jmp    80100a3e <consoleintr+0x13e>
      if(input.e != input.w){
80100a40:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a45:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a4b:	0f 84 ee fe ff ff    	je     8010093f <consoleintr+0x3f>
        input.e--;
80100a51:	83 e8 01             	sub    $0x1,%eax
80100a54:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a59:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100a5e:	85 c0                	test   %eax,%eax
80100a60:	74 7e                	je     80100ae0 <consoleintr+0x1e0>
80100a62:	fa                   	cli    
    for(;;)
80100a63:	eb fe                	jmp    80100a63 <consoleintr+0x163>
80100a65:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a68:	83 ec 0c             	sub    $0xc,%esp
80100a6b:	6a 08                	push   $0x8
80100a6d:	e8 be 55 00 00       	call   80106030 <uartputc>
80100a72:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a79:	e8 b2 55 00 00       	call   80106030 <uartputc>
80100a7e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a85:	e8 a6 55 00 00       	call   80106030 <uartputc>
  cgaputc(c);
80100a8a:	b8 00 01 00 00       	mov    $0x100,%eax
80100a8f:	e8 7c f9 ff ff       	call   80100410 <cgaputc>
      while(input.e != input.w &&
80100a94:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a99:	83 c4 10             	add    $0x10,%esp
80100a9c:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100aa2:	0f 85 71 ff ff ff    	jne    80100a19 <consoleintr+0x119>
80100aa8:	e9 92 fe ff ff       	jmp    8010093f <consoleintr+0x3f>
80100aad:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100ab0:	83 ec 0c             	sub    $0xc,%esp
80100ab3:	68 20 ef 10 80       	push   $0x8010ef20
80100ab8:	e8 03 3d 00 00       	call   801047c0 <release>
  if(doprocdump) {
80100abd:	83 c4 10             	add    $0x10,%esp
80100ac0:	85 db                	test   %ebx,%ebx
80100ac2:	75 50                	jne    80100b14 <consoleintr+0x214>
}
80100ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ac7:	5b                   	pop    %ebx
80100ac8:	5e                   	pop    %esi
80100ac9:	5f                   	pop    %edi
80100aca:	5d                   	pop    %ebp
80100acb:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100acc:	85 c0                	test   %eax,%eax
80100ace:	0f 84 6b fe ff ff    	je     8010093f <consoleintr+0x3f>
80100ad4:	e9 84 fe ff ff       	jmp    8010095d <consoleintr+0x5d>
80100ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ae0:	83 ec 0c             	sub    $0xc,%esp
80100ae3:	6a 08                	push   $0x8
80100ae5:	e8 46 55 00 00       	call   80106030 <uartputc>
80100aea:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100af1:	e8 3a 55 00 00       	call   80106030 <uartputc>
80100af6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100afd:	e8 2e 55 00 00       	call   80106030 <uartputc>
  cgaputc(c);
80100b02:	b8 00 01 00 00       	mov    $0x100,%eax
80100b07:	e8 04 f9 ff ff       	call   80100410 <cgaputc>
}
80100b0c:	83 c4 10             	add    $0x10,%esp
80100b0f:	e9 2b fe ff ff       	jmp    8010093f <consoleintr+0x3f>
}
80100b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b17:	5b                   	pop    %ebx
80100b18:	5e                   	pop    %esi
80100b19:	5f                   	pop    %edi
80100b1a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b1b:	e9 00 39 00 00       	jmp    80104420 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b20:	c6 81 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ecx)
  if(panicked){
80100b27:	85 ff                	test   %edi,%edi
80100b29:	74 05                	je     80100b30 <consoleintr+0x230>
80100b2b:	fa                   	cli    
    for(;;)
80100b2c:	eb fe                	jmp    80100b2c <consoleintr+0x22c>
80100b2e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	6a 0a                	push   $0xa
80100b35:	e8 f6 54 00 00       	call   80106030 <uartputc>
  cgaputc(c);
80100b3a:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b3f:	e8 cc f8 ff ff       	call   80100410 <cgaputc>
          input.w = input.e;
80100b44:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b49:	83 c4 10             	add    $0x10,%esp
80100b4c:	e9 98 fe ff ff       	jmp    801009e9 <consoleintr+0xe9>
    uartputc(c);
80100b51:	83 ec 0c             	sub    $0xc,%esp
80100b54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b57:	50                   	push   %eax
80100b58:	e8 d3 54 00 00       	call   80106030 <uartputc>
  cgaputc(c);
80100b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b60:	e8 ab f8 ff ff       	call   80100410 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	83 f8 0a             	cmp    $0xa,%eax
80100b6e:	74 09                	je     80100b79 <consoleintr+0x279>
80100b70:	83 f8 04             	cmp    $0x4,%eax
80100b73:	0f 85 5c fe ff ff    	jne    801009d5 <consoleintr+0xd5>
          input.w = input.e;
80100b79:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b7e:	e9 66 fe ff ff       	jmp    801009e9 <consoleintr+0xe9>
80100b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b90 <consoleinit>:

void
consoleinit(void)
{
80100b90:	f3 0f 1e fb          	endbr32 
80100b94:	55                   	push   %ebp
80100b95:	89 e5                	mov    %esp,%ebp
80100b97:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b9a:	68 88 75 10 80       	push   $0x80107588
80100b9f:	68 20 ef 10 80       	push   $0x8010ef20
80100ba4:	e8 87 3a 00 00       	call   80104630 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ba9:	58                   	pop    %eax
80100baa:	5a                   	pop    %edx
80100bab:	6a 00                	push   $0x0
80100bad:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100baf:	c7 05 0c f9 10 80 50 	movl   $0x80100550,0x8010f90c
80100bb6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100bb9:	c7 05 08 f9 10 80 90 	movl   $0x80100290,0x8010f908
80100bc0:	02 10 80 
  cons.locking = 1;
80100bc3:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100bca:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bcd:	e8 4e 1a 00 00       	call   80102620 <ioapicenable>
}
80100bd2:	83 c4 10             	add    $0x10,%esp
80100bd5:	c9                   	leave  
80100bd6:	c3                   	ret    
80100bd7:	66 90                	xchg   %ax,%ax
80100bd9:	66 90                	xchg   %ax,%ax
80100bdb:	66 90                	xchg   %ax,%ax
80100bdd:	66 90                	xchg   %ax,%ax
80100bdf:	90                   	nop

80100be0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100be0:	f3 0f 1e fb          	endbr32 
80100be4:	55                   	push   %ebp
80100be5:	89 e5                	mov    %esp,%ebp
80100be7:	57                   	push   %edi
80100be8:	56                   	push   %esi
80100be9:	53                   	push   %ebx
80100bea:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bf0:	e8 8b 2f 00 00       	call   80103b80 <myproc>
80100bf5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100bfb:	e8 20 23 00 00       	call   80102f20 <begin_op>

  if((ip = namei(path)) == 0){
80100c00:	83 ec 0c             	sub    $0xc,%esp
80100c03:	ff 75 08             	push   0x8(%ebp)
80100c06:	e8 15 16 00 00       	call   80102220 <namei>
80100c0b:	83 c4 10             	add    $0x10,%esp
80100c0e:	85 c0                	test   %eax,%eax
80100c10:	0f 84 fe 02 00 00    	je     80100f14 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c16:	83 ec 0c             	sub    $0xc,%esp
80100c19:	89 c3                	mov    %eax,%ebx
80100c1b:	50                   	push   %eax
80100c1c:	e8 bf 0c 00 00       	call   801018e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c21:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c27:	6a 34                	push   $0x34
80100c29:	6a 00                	push   $0x0
80100c2b:	50                   	push   %eax
80100c2c:	53                   	push   %ebx
80100c2d:	e8 ce 0f 00 00       	call   80101c00 <readi>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	83 f8 34             	cmp    $0x34,%eax
80100c38:	74 26                	je     80100c60 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c3a:	83 ec 0c             	sub    $0xc,%esp
80100c3d:	53                   	push   %ebx
80100c3e:	e8 2d 0f 00 00       	call   80101b70 <iunlockput>
    end_op();
80100c43:	e8 48 23 00 00       	call   80102f90 <end_op>
80100c48:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c53:	5b                   	pop    %ebx
80100c54:	5e                   	pop    %esi
80100c55:	5f                   	pop    %edi
80100c56:	5d                   	pop    %ebp
80100c57:	c3                   	ret    
80100c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c5f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100c60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c67:	45 4c 46 
80100c6a:	75 ce                	jne    80100c3a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100c6c:	e8 5f 65 00 00       	call   801071d0 <setupkvm>
80100c71:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c77:	85 c0                	test   %eax,%eax
80100c79:	74 bf                	je     80100c3a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c82:	00 
80100c83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c89:	0f 84 a4 02 00 00    	je     80100f33 <exec+0x353>
  sz = 0;
80100c8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c96:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c99:	31 ff                	xor    %edi,%edi
80100c9b:	e9 86 00 00 00       	jmp    80100d26 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100ca0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ca7:	75 6c                	jne    80100d15 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100ca9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100caf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100cb5:	0f 82 87 00 00 00    	jb     80100d42 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cbb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cc1:	72 7f                	jb     80100d42 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cc3:	83 ec 04             	sub    $0x4,%esp
80100cc6:	50                   	push   %eax
80100cc7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100ccd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cd3:	e8 18 63 00 00       	call   80106ff0 <allocuvm>
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ce1:	85 c0                	test   %eax,%eax
80100ce3:	74 5d                	je     80100d42 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100ce5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ceb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cf0:	75 50                	jne    80100d42 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cf2:	83 ec 0c             	sub    $0xc,%esp
80100cf5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100cfb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100d01:	53                   	push   %ebx
80100d02:	50                   	push   %eax
80100d03:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d09:	e8 f2 61 00 00       	call   80106f00 <loaduvm>
80100d0e:	83 c4 20             	add    $0x20,%esp
80100d11:	85 c0                	test   %eax,%eax
80100d13:	78 2d                	js     80100d42 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d15:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d1c:	83 c7 01             	add    $0x1,%edi
80100d1f:	83 c6 20             	add    $0x20,%esi
80100d22:	39 f8                	cmp    %edi,%eax
80100d24:	7e 3a                	jle    80100d60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d26:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d2c:	6a 20                	push   $0x20
80100d2e:	56                   	push   %esi
80100d2f:	50                   	push   %eax
80100d30:	53                   	push   %ebx
80100d31:	e8 ca 0e 00 00       	call   80101c00 <readi>
80100d36:	83 c4 10             	add    $0x10,%esp
80100d39:	83 f8 20             	cmp    $0x20,%eax
80100d3c:	0f 84 5e ff ff ff    	je     80100ca0 <exec+0xc0>
    freevm(pgdir);
80100d42:	83 ec 0c             	sub    $0xc,%esp
80100d45:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d4b:	e8 00 64 00 00       	call   80107150 <freevm>
  if(ip){
80100d50:	83 c4 10             	add    $0x10,%esp
80100d53:	e9 e2 fe ff ff       	jmp    80100c3a <exec+0x5a>
80100d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d5f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d60:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d66:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d6c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d72:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d78:	83 ec 0c             	sub    $0xc,%esp
80100d7b:	53                   	push   %ebx
80100d7c:	e8 ef 0d 00 00       	call   80101b70 <iunlockput>
  end_op();
80100d81:	e8 0a 22 00 00       	call   80102f90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d86:	83 c4 0c             	add    $0xc,%esp
80100d89:	56                   	push   %esi
80100d8a:	57                   	push   %edi
80100d8b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d91:	57                   	push   %edi
80100d92:	e8 59 62 00 00       	call   80106ff0 <allocuvm>
80100d97:	83 c4 10             	add    $0x10,%esp
80100d9a:	89 c6                	mov    %eax,%esi
80100d9c:	85 c0                	test   %eax,%eax
80100d9e:	0f 84 94 00 00 00    	je     80100e38 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da4:	83 ec 08             	sub    $0x8,%esp
80100da7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100dad:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100daf:	50                   	push   %eax
80100db0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100db1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100db3:	e8 b8 64 00 00       	call   80107270 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dbb:	83 c4 10             	add    $0x10,%esp
80100dbe:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dc4:	8b 00                	mov    (%eax),%eax
80100dc6:	85 c0                	test   %eax,%eax
80100dc8:	0f 84 8b 00 00 00    	je     80100e59 <exec+0x279>
80100dce:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100dd4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dda:	eb 23                	jmp    80100dff <exec+0x21f>
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100de0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100de3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100dea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ded:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100df3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100df6:	85 c0                	test   %eax,%eax
80100df8:	74 59                	je     80100e53 <exec+0x273>
    if(argc >= MAXARG)
80100dfa:	83 ff 20             	cmp    $0x20,%edi
80100dfd:	74 39                	je     80100e38 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dff:	83 ec 0c             	sub    $0xc,%esp
80100e02:	50                   	push   %eax
80100e03:	e8 f8 3c 00 00       	call   80104b00 <strlen>
80100e08:	f7 d0                	not    %eax
80100e0a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e0c:	58                   	pop    %eax
80100e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e10:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e13:	ff 34 b8             	push   (%eax,%edi,4)
80100e16:	e8 e5 3c 00 00       	call   80104b00 <strlen>
80100e1b:	83 c0 01             	add    $0x1,%eax
80100e1e:	50                   	push   %eax
80100e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e22:	ff 34 b8             	push   (%eax,%edi,4)
80100e25:	53                   	push   %ebx
80100e26:	56                   	push   %esi
80100e27:	e8 14 66 00 00       	call   80107440 <copyout>
80100e2c:	83 c4 20             	add    $0x20,%esp
80100e2f:	85 c0                	test   %eax,%eax
80100e31:	79 ad                	jns    80100de0 <exec+0x200>
80100e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e37:	90                   	nop
    freevm(pgdir);
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e41:	e8 0a 63 00 00       	call   80107150 <freevm>
80100e46:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e4e:	e9 fd fd ff ff       	jmp    80100c50 <exec+0x70>
80100e53:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e59:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e60:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e62:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e69:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e6d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e6f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e72:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e78:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e7a:	50                   	push   %eax
80100e7b:	52                   	push   %edx
80100e7c:	53                   	push   %ebx
80100e7d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e83:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e8a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e8d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e93:	e8 a8 65 00 00       	call   80107440 <copyout>
80100e98:	83 c4 10             	add    $0x10,%esp
80100e9b:	85 c0                	test   %eax,%eax
80100e9d:	78 99                	js     80100e38 <exec+0x258>
  for(last=s=path; *s; s++)
80100e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea2:	8b 55 08             	mov    0x8(%ebp),%edx
80100ea5:	0f b6 00             	movzbl (%eax),%eax
80100ea8:	84 c0                	test   %al,%al
80100eaa:	74 13                	je     80100ebf <exec+0x2df>
80100eac:	89 d1                	mov    %edx,%ecx
80100eae:	66 90                	xchg   %ax,%ax
      last = s+1;
80100eb0:	83 c1 01             	add    $0x1,%ecx
80100eb3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100eb5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100eb8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100ebb:	84 c0                	test   %al,%al
80100ebd:	75 f1                	jne    80100eb0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ebf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100ec5:	83 ec 04             	sub    $0x4,%esp
80100ec8:	6a 10                	push   $0x10
80100eca:	89 f8                	mov    %edi,%eax
80100ecc:	52                   	push   %edx
80100ecd:	83 c0 6c             	add    $0x6c,%eax
80100ed0:	50                   	push   %eax
80100ed1:	e8 ea 3b 00 00       	call   80104ac0 <safestrcpy>
  curproc->pgdir = pgdir;
80100ed6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100edc:	89 f8                	mov    %edi,%eax
80100ede:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ee1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ee3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ee6:	89 c1                	mov    %eax,%ecx
80100ee8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100eee:	8b 40 18             	mov    0x18(%eax),%eax
80100ef1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ef4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ef7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100efa:	89 0c 24             	mov    %ecx,(%esp)
80100efd:	e8 6e 5e 00 00       	call   80106d70 <switchuvm>
  freevm(oldpgdir);
80100f02:	89 3c 24             	mov    %edi,(%esp)
80100f05:	e8 46 62 00 00       	call   80107150 <freevm>
  return 0;
80100f0a:	83 c4 10             	add    $0x10,%esp
80100f0d:	31 c0                	xor    %eax,%eax
80100f0f:	e9 3c fd ff ff       	jmp    80100c50 <exec+0x70>
    end_op();
80100f14:	e8 77 20 00 00       	call   80102f90 <end_op>
    cprintf("exec: fail\n");
80100f19:	83 ec 0c             	sub    $0xc,%esp
80100f1c:	68 a1 75 10 80       	push   $0x801075a1
80100f21:	e8 6a f7 ff ff       	call   80100690 <cprintf>
    return -1;
80100f26:	83 c4 10             	add    $0x10,%esp
80100f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f2e:	e9 1d fd ff ff       	jmp    80100c50 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f33:	31 ff                	xor    %edi,%edi
80100f35:	be 00 20 00 00       	mov    $0x2000,%esi
80100f3a:	e9 39 fe ff ff       	jmp    80100d78 <exec+0x198>
80100f3f:	90                   	nop

80100f40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f40:	f3 0f 1e fb          	endbr32 
80100f44:	55                   	push   %ebp
80100f45:	89 e5                	mov    %esp,%ebp
80100f47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f4a:	68 ad 75 10 80       	push   $0x801075ad
80100f4f:	68 60 ef 10 80       	push   $0x8010ef60
80100f54:	e8 d7 36 00 00       	call   80104630 <initlock>
}
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	c9                   	leave  
80100f5d:	c3                   	ret    
80100f5e:	66 90                	xchg   %ax,%ax

80100f60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f60:	f3 0f 1e fb          	endbr32 
80100f64:	55                   	push   %ebp
80100f65:	89 e5                	mov    %esp,%ebp
80100f67:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f68:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100f6d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f70:	68 60 ef 10 80       	push   $0x8010ef60
80100f75:	e8 b6 38 00 00       	call   80104830 <acquire>
80100f7a:	83 c4 10             	add    $0x10,%esp
80100f7d:	eb 0c                	jmp    80100f8b <filealloc+0x2b>
80100f7f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f80:	83 c3 18             	add    $0x18,%ebx
80100f83:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100f89:	74 25                	je     80100fb0 <filealloc+0x50>
    if(f->ref == 0){
80100f8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f8e:	85 c0                	test   %eax,%eax
80100f90:	75 ee                	jne    80100f80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f9c:	68 60 ef 10 80       	push   $0x8010ef60
80100fa1:	e8 1a 38 00 00       	call   801047c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fa6:	89 d8                	mov    %ebx,%eax
      return f;
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fae:	c9                   	leave  
80100faf:	c3                   	ret    
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fb5:	68 60 ef 10 80       	push   $0x8010ef60
80100fba:	e8 01 38 00 00       	call   801047c0 <release>
}
80100fbf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fc1:	83 c4 10             	add    $0x10,%esp
}
80100fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc7:	c9                   	leave  
80100fc8:	c3                   	ret    
80100fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fd0:	f3 0f 1e fb          	endbr32 
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	53                   	push   %ebx
80100fd8:	83 ec 10             	sub    $0x10,%esp
80100fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fde:	68 60 ef 10 80       	push   $0x8010ef60
80100fe3:	e8 48 38 00 00       	call   80104830 <acquire>
  if(f->ref < 1)
80100fe8:	8b 43 04             	mov    0x4(%ebx),%eax
80100feb:	83 c4 10             	add    $0x10,%esp
80100fee:	85 c0                	test   %eax,%eax
80100ff0:	7e 1a                	jle    8010100c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ff2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ff5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ff8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ffb:	68 60 ef 10 80       	push   $0x8010ef60
80101000:	e8 bb 37 00 00       	call   801047c0 <release>
  return f;
}
80101005:	89 d8                	mov    %ebx,%eax
80101007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010100a:	c9                   	leave  
8010100b:	c3                   	ret    
    panic("filedup");
8010100c:	83 ec 0c             	sub    $0xc,%esp
8010100f:	68 b4 75 10 80       	push   $0x801075b4
80101014:	e8 77 f3 ff ff       	call   80100390 <panic>
80101019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101020 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101020:	f3 0f 1e fb          	endbr32 
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	57                   	push   %edi
80101028:	56                   	push   %esi
80101029:	53                   	push   %ebx
8010102a:	83 ec 28             	sub    $0x28,%esp
8010102d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101030:	68 60 ef 10 80       	push   $0x8010ef60
80101035:	e8 f6 37 00 00       	call   80104830 <acquire>
  if(f->ref < 1)
8010103a:	8b 53 04             	mov    0x4(%ebx),%edx
8010103d:	83 c4 10             	add    $0x10,%esp
80101040:	85 d2                	test   %edx,%edx
80101042:	0f 8e a1 00 00 00    	jle    801010e9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101048:	83 ea 01             	sub    $0x1,%edx
8010104b:	89 53 04             	mov    %edx,0x4(%ebx)
8010104e:	75 40                	jne    80101090 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101050:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101054:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101057:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101059:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010105f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101062:	88 45 e7             	mov    %al,-0x19(%ebp)
80101065:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101068:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
8010106d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101070:	e8 4b 37 00 00       	call   801047c0 <release>

  if(ff.type == FD_PIPE)
80101075:	83 c4 10             	add    $0x10,%esp
80101078:	83 ff 01             	cmp    $0x1,%edi
8010107b:	74 53                	je     801010d0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010107d:	83 ff 02             	cmp    $0x2,%edi
80101080:	74 26                	je     801010a8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101082:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101085:	5b                   	pop    %ebx
80101086:	5e                   	pop    %esi
80101087:	5f                   	pop    %edi
80101088:	5d                   	pop    %ebp
80101089:	c3                   	ret    
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101090:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80101097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010109e:	e9 1d 37 00 00       	jmp    801047c0 <release>
801010a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010a7:	90                   	nop
    begin_op();
801010a8:	e8 73 1e 00 00       	call   80102f20 <begin_op>
    iput(ff.ip);
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	ff 75 e0             	push   -0x20(%ebp)
801010b3:	e8 58 09 00 00       	call   80101a10 <iput>
    end_op();
801010b8:	83 c4 10             	add    $0x10,%esp
}
801010bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010be:	5b                   	pop    %ebx
801010bf:	5e                   	pop    %esi
801010c0:	5f                   	pop    %edi
801010c1:	5d                   	pop    %ebp
    end_op();
801010c2:	e9 c9 1e 00 00       	jmp    80102f90 <end_op>
801010c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ce:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010d0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010d4:	83 ec 08             	sub    $0x8,%esp
801010d7:	53                   	push   %ebx
801010d8:	56                   	push   %esi
801010d9:	e8 42 26 00 00       	call   80103720 <pipeclose>
801010de:	83 c4 10             	add    $0x10,%esp
}
801010e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e4:	5b                   	pop    %ebx
801010e5:	5e                   	pop    %esi
801010e6:	5f                   	pop    %edi
801010e7:	5d                   	pop    %ebp
801010e8:	c3                   	ret    
    panic("fileclose");
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 bc 75 10 80       	push   $0x801075bc
801010f1:	e8 9a f2 ff ff       	call   80100390 <panic>
801010f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010fd:	8d 76 00             	lea    0x0(%esi),%esi

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	f3 0f 1e fb          	endbr32 
80101104:	55                   	push   %ebp
80101105:	89 e5                	mov    %esp,%ebp
80101107:	53                   	push   %ebx
80101108:	83 ec 04             	sub    $0x4,%esp
8010110b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010110e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101111:	75 2d                	jne    80101140 <filestat+0x40>
    ilock(f->ip);
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	ff 73 10             	push   0x10(%ebx)
80101119:	e8 c2 07 00 00       	call   801018e0 <ilock>
    stati(f->ip, st);
8010111e:	58                   	pop    %eax
8010111f:	5a                   	pop    %edx
80101120:	ff 75 0c             	push   0xc(%ebp)
80101123:	ff 73 10             	push   0x10(%ebx)
80101126:	e8 a5 0a 00 00       	call   80101bd0 <stati>
    iunlock(f->ip);
8010112b:	59                   	pop    %ecx
8010112c:	ff 73 10             	push   0x10(%ebx)
8010112f:	e8 8c 08 00 00       	call   801019c0 <iunlock>
    return 0;
  }
  return -1;
}
80101134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101137:	83 c4 10             	add    $0x10,%esp
8010113a:	31 c0                	xor    %eax,%eax
}
8010113c:	c9                   	leave  
8010113d:	c3                   	ret    
8010113e:	66 90                	xchg   %ax,%ax
80101140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101148:	c9                   	leave  
80101149:	c3                   	ret    
8010114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101150 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101150:	f3 0f 1e fb          	endbr32 
80101154:	55                   	push   %ebp
80101155:	89 e5                	mov    %esp,%ebp
80101157:	57                   	push   %edi
80101158:	56                   	push   %esi
80101159:	53                   	push   %ebx
8010115a:	83 ec 0c             	sub    $0xc,%esp
8010115d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101160:	8b 75 0c             	mov    0xc(%ebp),%esi
80101163:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101166:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010116a:	74 64                	je     801011d0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010116c:	8b 03                	mov    (%ebx),%eax
8010116e:	83 f8 01             	cmp    $0x1,%eax
80101171:	74 45                	je     801011b8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101173:	83 f8 02             	cmp    $0x2,%eax
80101176:	75 5f                	jne    801011d7 <fileread+0x87>
    ilock(f->ip);
80101178:	83 ec 0c             	sub    $0xc,%esp
8010117b:	ff 73 10             	push   0x10(%ebx)
8010117e:	e8 5d 07 00 00       	call   801018e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101183:	57                   	push   %edi
80101184:	ff 73 14             	push   0x14(%ebx)
80101187:	56                   	push   %esi
80101188:	ff 73 10             	push   0x10(%ebx)
8010118b:	e8 70 0a 00 00       	call   80101c00 <readi>
80101190:	83 c4 20             	add    $0x20,%esp
80101193:	89 c6                	mov    %eax,%esi
80101195:	85 c0                	test   %eax,%eax
80101197:	7e 03                	jle    8010119c <fileread+0x4c>
      f->off += r;
80101199:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010119c:	83 ec 0c             	sub    $0xc,%esp
8010119f:	ff 73 10             	push   0x10(%ebx)
801011a2:	e8 19 08 00 00       	call   801019c0 <iunlock>
    return r;
801011a7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ad:	89 f0                	mov    %esi,%eax
801011af:	5b                   	pop    %ebx
801011b0:	5e                   	pop    %esi
801011b1:	5f                   	pop    %edi
801011b2:	5d                   	pop    %ebp
801011b3:	c3                   	ret    
801011b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801011b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c1:	5b                   	pop    %ebx
801011c2:	5e                   	pop    %esi
801011c3:	5f                   	pop    %edi
801011c4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011c5:	e9 f6 26 00 00       	jmp    801038c0 <piperead>
801011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011d5:	eb d3                	jmp    801011aa <fileread+0x5a>
  panic("fileread");
801011d7:	83 ec 0c             	sub    $0xc,%esp
801011da:	68 c6 75 10 80       	push   $0x801075c6
801011df:	e8 ac f1 ff ff       	call   80100390 <panic>
801011e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011ef:	90                   	nop

801011f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011f0:	f3 0f 1e fb          	endbr32 
801011f4:	55                   	push   %ebp
801011f5:	89 e5                	mov    %esp,%ebp
801011f7:	57                   	push   %edi
801011f8:	56                   	push   %esi
801011f9:	53                   	push   %ebx
801011fa:	83 ec 1c             	sub    $0x1c,%esp
801011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101200:	8b 75 08             	mov    0x8(%ebp),%esi
80101203:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101206:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101209:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010120d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101210:	0f 84 c1 00 00 00    	je     801012d7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101216:	8b 06                	mov    (%esi),%eax
80101218:	83 f8 01             	cmp    $0x1,%eax
8010121b:	0f 84 c3 00 00 00    	je     801012e4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101221:	83 f8 02             	cmp    $0x2,%eax
80101224:	0f 85 cc 00 00 00    	jne    801012f6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010122a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010122d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010122f:	85 c0                	test   %eax,%eax
80101231:	7f 34                	jg     80101267 <filewrite+0x77>
80101233:	e9 98 00 00 00       	jmp    801012d0 <filewrite+0xe0>
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101240:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101243:	83 ec 0c             	sub    $0xc,%esp
80101246:	ff 76 10             	push   0x10(%esi)
        f->off += r;
80101249:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010124c:	e8 6f 07 00 00       	call   801019c0 <iunlock>
      end_op();
80101251:	e8 3a 1d 00 00       	call   80102f90 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101256:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101259:	83 c4 10             	add    $0x10,%esp
8010125c:	39 c3                	cmp    %eax,%ebx
8010125e:	75 60                	jne    801012c0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101260:	01 df                	add    %ebx,%edi
    while(i < n){
80101262:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101265:	7e 69                	jle    801012d0 <filewrite+0xe0>
      int n1 = n - i;
80101267:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010126a:	b8 00 06 00 00       	mov    $0x600,%eax
8010126f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101271:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101277:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010127a:	e8 a1 1c 00 00       	call   80102f20 <begin_op>
      ilock(f->ip);
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	ff 76 10             	push   0x10(%esi)
80101285:	e8 56 06 00 00       	call   801018e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010128a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010128d:	53                   	push   %ebx
8010128e:	ff 76 14             	push   0x14(%esi)
80101291:	01 f8                	add    %edi,%eax
80101293:	50                   	push   %eax
80101294:	ff 76 10             	push   0x10(%esi)
80101297:	e8 64 0a 00 00       	call   80101d00 <writei>
8010129c:	83 c4 20             	add    $0x20,%esp
8010129f:	85 c0                	test   %eax,%eax
801012a1:	7f 9d                	jg     80101240 <filewrite+0x50>
      iunlock(f->ip);
801012a3:	83 ec 0c             	sub    $0xc,%esp
801012a6:	ff 76 10             	push   0x10(%esi)
801012a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801012ac:	e8 0f 07 00 00       	call   801019c0 <iunlock>
      end_op();
801012b1:	e8 da 1c 00 00       	call   80102f90 <end_op>
      if(r < 0)
801012b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012b9:	83 c4 10             	add    $0x10,%esp
801012bc:	85 c0                	test   %eax,%eax
801012be:	75 17                	jne    801012d7 <filewrite+0xe7>
        panic("short filewrite");
801012c0:	83 ec 0c             	sub    $0xc,%esp
801012c3:	68 cf 75 10 80       	push   $0x801075cf
801012c8:	e8 c3 f0 ff ff       	call   80100390 <panic>
801012cd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801012d0:	89 f8                	mov    %edi,%eax
801012d2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801012d5:	74 05                	je     801012dc <filewrite+0xec>
801012d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012df:	5b                   	pop    %ebx
801012e0:	5e                   	pop    %esi
801012e1:	5f                   	pop    %edi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012e4:	8b 46 0c             	mov    0xc(%esi),%eax
801012e7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012f1:	e9 ca 24 00 00       	jmp    801037c0 <pipewrite>
  panic("filewrite");
801012f6:	83 ec 0c             	sub    $0xc,%esp
801012f9:	68 d5 75 10 80       	push   $0x801075d5
801012fe:	e8 8d f0 ff ff       	call   80100390 <panic>
80101303:	66 90                	xchg   %ax,%ax
80101305:	66 90                	xchg   %ax,%ax
80101307:	66 90                	xchg   %ax,%ax
80101309:	66 90                	xchg   %ax,%ax
8010130b:	66 90                	xchg   %ax,%ax
8010130d:	66 90                	xchg   %ax,%ax
8010130f:	90                   	nop

80101310 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101310:	55                   	push   %ebp
80101311:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101313:	89 d0                	mov    %edx,%eax
80101315:	c1 e8 0c             	shr    $0xc,%eax
80101318:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
8010131e:	89 e5                	mov    %esp,%ebp
80101320:	56                   	push   %esi
80101321:	53                   	push   %ebx
80101322:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	50                   	push   %eax
80101328:	51                   	push   %ecx
80101329:	e8 a2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010132e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101330:	c1 fb 03             	sar    $0x3,%ebx
80101333:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101336:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101338:	83 e1 07             	and    $0x7,%ecx
8010133b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101340:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101346:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101348:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010134d:	85 c1                	test   %eax,%ecx
8010134f:	74 23                	je     80101374 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101351:	f7 d0                	not    %eax
  log_write(bp);
80101353:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101356:	21 c8                	and    %ecx,%eax
80101358:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010135c:	56                   	push   %esi
8010135d:	e8 9e 1d 00 00       	call   80103100 <log_write>
  brelse(bp);
80101362:	89 34 24             	mov    %esi,(%esp)
80101365:	e8 86 ee ff ff       	call   801001f0 <brelse>
}
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101370:	5b                   	pop    %ebx
80101371:	5e                   	pop    %esi
80101372:	5d                   	pop    %ebp
80101373:	c3                   	ret    
    panic("freeing free block");
80101374:	83 ec 0c             	sub    $0xc,%esp
80101377:	68 df 75 10 80       	push   $0x801075df
8010137c:	e8 0f f0 ff ff       	call   80100390 <panic>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138f:	90                   	nop

80101390 <balloc>:
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101399:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010139f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013a2:	85 c9                	test   %ecx,%ecx
801013a4:	0f 84 87 00 00 00    	je     80101431 <balloc+0xa1>
801013aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013b4:	83 ec 08             	sub    $0x8,%esp
801013b7:	89 f0                	mov    %esi,%eax
801013b9:	c1 f8 0c             	sar    $0xc,%eax
801013bc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801013c2:	50                   	push   %eax
801013c3:	ff 75 d8             	push   -0x28(%ebp)
801013c6:	e8 05 ed ff ff       	call   801000d0 <bread>
801013cb:	83 c4 10             	add    $0x10,%esp
801013ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013d1:	a1 b4 15 11 80       	mov    0x801115b4,%eax
801013d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013d9:	31 c0                	xor    %eax,%eax
801013db:	eb 2f                	jmp    8010140c <balloc+0x7c>
801013dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013e0:	89 c1                	mov    %eax,%ecx
801013e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013ea:	83 e1 07             	and    $0x7,%ecx
801013ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013ef:	89 c1                	mov    %eax,%ecx
801013f1:	c1 f9 03             	sar    $0x3,%ecx
801013f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013f9:	89 fa                	mov    %edi,%edx
801013fb:	85 df                	test   %ebx,%edi
801013fd:	74 41                	je     80101440 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013ff:	83 c0 01             	add    $0x1,%eax
80101402:	83 c6 01             	add    $0x1,%esi
80101405:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010140a:	74 05                	je     80101411 <balloc+0x81>
8010140c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010140f:	77 cf                	ja     801013e0 <balloc+0x50>
    brelse(bp);
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	ff 75 e4             	push   -0x1c(%ebp)
80101417:	e8 d4 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010141c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101423:	83 c4 10             	add    $0x10,%esp
80101426:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101429:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010142f:	77 80                	ja     801013b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101431:	83 ec 0c             	sub    $0xc,%esp
80101434:	68 f2 75 10 80       	push   $0x801075f2
80101439:	e8 52 ef ff ff       	call   80100390 <panic>
8010143e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101443:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101446:	09 da                	or     %ebx,%edx
80101448:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010144c:	57                   	push   %edi
8010144d:	e8 ae 1c 00 00       	call   80103100 <log_write>
        brelse(bp);
80101452:	89 3c 24             	mov    %edi,(%esp)
80101455:	e8 96 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010145a:	58                   	pop    %eax
8010145b:	5a                   	pop    %edx
8010145c:	56                   	push   %esi
8010145d:	ff 75 d8             	push   -0x28(%ebp)
80101460:	e8 6b ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101465:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101468:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010146a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010146d:	68 00 02 00 00       	push   $0x200
80101472:	6a 00                	push   $0x0
80101474:	50                   	push   %eax
80101475:	e8 86 34 00 00       	call   80104900 <memset>
  log_write(bp);
8010147a:	89 1c 24             	mov    %ebx,(%esp)
8010147d:	e8 7e 1c 00 00       	call   80103100 <log_write>
  brelse(bp);
80101482:	89 1c 24             	mov    %ebx,(%esp)
80101485:	e8 66 ed ff ff       	call   801001f0 <brelse>
}
8010148a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148d:	89 f0                	mov    %esi,%eax
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5f                   	pop    %edi
80101492:	5d                   	pop    %ebp
80101493:	c3                   	ret    
80101494:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	89 c7                	mov    %eax,%edi
801014a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014a7:	31 f6                	xor    %esi,%esi
{
801014a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014aa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801014af:	83 ec 28             	sub    $0x28,%esp
801014b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801014b5:	68 60 f9 10 80       	push   $0x8010f960
801014ba:	e8 71 33 00 00       	call   80104830 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801014c2:	83 c4 10             	add    $0x10,%esp
801014c5:	eb 1b                	jmp    801014e2 <iget+0x42>
801014c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014d0:	39 3b                	cmp    %edi,(%ebx)
801014d2:	74 6c                	je     80101540 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014da:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014e0:	73 26                	jae    80101508 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014e2:	8b 43 08             	mov    0x8(%ebx),%eax
801014e5:	85 c0                	test   %eax,%eax
801014e7:	7f e7                	jg     801014d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014e9:	85 f6                	test   %esi,%esi
801014eb:	75 e7                	jne    801014d4 <iget+0x34>
801014ed:	85 c0                	test   %eax,%eax
801014ef:	75 76                	jne    80101567 <iget+0xc7>
801014f1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014f3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014f9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014ff:	72 e1                	jb     801014e2 <iget+0x42>
80101501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101508:	85 f6                	test   %esi,%esi
8010150a:	74 79                	je     80101585 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010150c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010150f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101511:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101514:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010151b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101522:	68 60 f9 10 80       	push   $0x8010f960
80101527:	e8 94 32 00 00       	call   801047c0 <release>

  return ip;
8010152c:	83 c4 10             	add    $0x10,%esp
}
8010152f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101532:	89 f0                	mov    %esi,%eax
80101534:	5b                   	pop    %ebx
80101535:	5e                   	pop    %esi
80101536:	5f                   	pop    %edi
80101537:	5d                   	pop    %ebp
80101538:	c3                   	ret    
80101539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101540:	39 53 04             	cmp    %edx,0x4(%ebx)
80101543:	75 8f                	jne    801014d4 <iget+0x34>
      release(&icache.lock);
80101545:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101548:	83 c0 01             	add    $0x1,%eax
      return ip;
8010154b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010154d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101552:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101555:	e8 66 32 00 00       	call   801047c0 <release>
      return ip;
8010155a:	83 c4 10             	add    $0x10,%esp
}
8010155d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101560:	89 f0                	mov    %esi,%eax
80101562:	5b                   	pop    %ebx
80101563:	5e                   	pop    %esi
80101564:	5f                   	pop    %edi
80101565:	5d                   	pop    %ebp
80101566:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101567:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010156d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101573:	73 10                	jae    80101585 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101575:	8b 43 08             	mov    0x8(%ebx),%eax
80101578:	85 c0                	test   %eax,%eax
8010157a:	0f 8f 50 ff ff ff    	jg     801014d0 <iget+0x30>
80101580:	e9 68 ff ff ff       	jmp    801014ed <iget+0x4d>
    panic("iget: no inodes");
80101585:	83 ec 0c             	sub    $0xc,%esp
80101588:	68 08 76 10 80       	push   $0x80107608
8010158d:	e8 fe ed ff ff       	call   80100390 <panic>
80101592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801015a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	89 c6                	mov    %eax,%esi
801015a7:	53                   	push   %ebx
801015a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015ab:	83 fa 0b             	cmp    $0xb,%edx
801015ae:	0f 86 8c 00 00 00    	jbe    80101640 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801015b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801015b7:	83 fb 7f             	cmp    $0x7f,%ebx
801015ba:	0f 87 a2 00 00 00    	ja     80101662 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801015c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801015c6:	85 c0                	test   %eax,%eax
801015c8:	74 5e                	je     80101628 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801015ca:	83 ec 08             	sub    $0x8,%esp
801015cd:	50                   	push   %eax
801015ce:	ff 36                	push   (%esi)
801015d0:	e8 fb ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801015d5:	83 c4 10             	add    $0x10,%esp
801015d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801015dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801015de:	8b 3b                	mov    (%ebx),%edi
801015e0:	85 ff                	test   %edi,%edi
801015e2:	74 1c                	je     80101600 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	52                   	push   %edx
801015e8:	e8 03 ec ff ff       	call   801001f0 <brelse>
801015ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015f3:	89 f8                	mov    %edi,%eax
801015f5:	5b                   	pop    %ebx
801015f6:	5e                   	pop    %esi
801015f7:	5f                   	pop    %edi
801015f8:	5d                   	pop    %ebp
801015f9:	c3                   	ret    
801015fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101603:	8b 06                	mov    (%esi),%eax
80101605:	e8 86 fd ff ff       	call   80101390 <balloc>
      log_write(bp);
8010160a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010160d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101610:	89 03                	mov    %eax,(%ebx)
80101612:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101614:	52                   	push   %edx
80101615:	e8 e6 1a 00 00       	call   80103100 <log_write>
8010161a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010161d:	83 c4 10             	add    $0x10,%esp
80101620:	eb c2                	jmp    801015e4 <bmap+0x44>
80101622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101628:	8b 06                	mov    (%esi),%eax
8010162a:	e8 61 fd ff ff       	call   80101390 <balloc>
8010162f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101635:	eb 93                	jmp    801015ca <bmap+0x2a>
80101637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101640:	8d 5a 14             	lea    0x14(%edx),%ebx
80101643:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101647:	85 ff                	test   %edi,%edi
80101649:	75 a5                	jne    801015f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010164b:	8b 00                	mov    (%eax),%eax
8010164d:	e8 3e fd ff ff       	call   80101390 <balloc>
80101652:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101656:	89 c7                	mov    %eax,%edi
}
80101658:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165b:	5b                   	pop    %ebx
8010165c:	89 f8                	mov    %edi,%eax
8010165e:	5e                   	pop    %esi
8010165f:	5f                   	pop    %edi
80101660:	5d                   	pop    %ebp
80101661:	c3                   	ret    
  panic("bmap: out of range");
80101662:	83 ec 0c             	sub    $0xc,%esp
80101665:	68 18 76 10 80       	push   $0x80107618
8010166a:	e8 21 ed ff ff       	call   80100390 <panic>
8010166f:	90                   	nop

80101670 <readsb>:
{
80101670:	f3 0f 1e fb          	endbr32 
80101674:	55                   	push   %ebp
80101675:	89 e5                	mov    %esp,%ebp
80101677:	56                   	push   %esi
80101678:	53                   	push   %ebx
80101679:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010167c:	83 ec 08             	sub    $0x8,%esp
8010167f:	6a 01                	push   $0x1
80101681:	ff 75 08             	push   0x8(%ebp)
80101684:	e8 47 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101689:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010168c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010168e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101691:	6a 1c                	push   $0x1c
80101693:	50                   	push   %eax
80101694:	56                   	push   %esi
80101695:	e8 06 33 00 00       	call   801049a0 <memmove>
  brelse(bp);
8010169a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010169d:	83 c4 10             	add    $0x10,%esp
}
801016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
  brelse(bp);
801016a6:	e9 45 eb ff ff       	jmp    801001f0 <brelse>
801016ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016af:	90                   	nop

801016b0 <iinit>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	53                   	push   %ebx
801016b8:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801016bd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801016c0:	68 2b 76 10 80       	push   $0x8010762b
801016c5:	68 60 f9 10 80       	push   $0x8010f960
801016ca:	e8 61 2f 00 00       	call   80104630 <initlock>
  for(i = 0; i < NINODE; i++) {
801016cf:	83 c4 10             	add    $0x10,%esp
801016d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801016d8:	83 ec 08             	sub    $0x8,%esp
801016db:	68 32 76 10 80       	push   $0x80107632
801016e0:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801016e1:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801016e7:	e8 04 2e 00 00       	call   801044f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016ec:	83 c4 10             	add    $0x10,%esp
801016ef:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801016f5:	75 e1                	jne    801016d8 <iinit+0x28>
  bp = bread(dev, 1);
801016f7:	83 ec 08             	sub    $0x8,%esp
801016fa:	6a 01                	push   $0x1
801016fc:	ff 75 08             	push   0x8(%ebp)
801016ff:	e8 cc e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101704:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101707:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101709:	8d 40 5c             	lea    0x5c(%eax),%eax
8010170c:	6a 1c                	push   $0x1c
8010170e:	50                   	push   %eax
8010170f:	68 b4 15 11 80       	push   $0x801115b4
80101714:	e8 87 32 00 00       	call   801049a0 <memmove>
  brelse(bp);
80101719:	89 1c 24             	mov    %ebx,(%esp)
8010171c:	e8 cf ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101721:	ff 35 cc 15 11 80    	push   0x801115cc
80101727:	ff 35 c8 15 11 80    	push   0x801115c8
8010172d:	ff 35 c4 15 11 80    	push   0x801115c4
80101733:	ff 35 c0 15 11 80    	push   0x801115c0
80101739:	ff 35 bc 15 11 80    	push   0x801115bc
8010173f:	ff 35 b8 15 11 80    	push   0x801115b8
80101745:	ff 35 b4 15 11 80    	push   0x801115b4
8010174b:	68 98 76 10 80       	push   $0x80107698
80101750:	e8 3b ef ff ff       	call   80100690 <cprintf>
}
80101755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101758:	83 c4 30             	add    $0x30,%esp
8010175b:	c9                   	leave  
8010175c:	c3                   	ret    
8010175d:	8d 76 00             	lea    0x0(%esi),%esi

80101760 <ialloc>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	57                   	push   %edi
80101768:	56                   	push   %esi
80101769:	53                   	push   %ebx
8010176a:	83 ec 1c             	sub    $0x1c,%esp
8010176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101770:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101777:	8b 75 08             	mov    0x8(%ebp),%esi
8010177a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010177d:	0f 86 8d 00 00 00    	jbe    80101810 <ialloc+0xb0>
80101783:	bf 01 00 00 00       	mov    $0x1,%edi
80101788:	eb 1d                	jmp    801017a7 <ialloc+0x47>
8010178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101790:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101793:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101796:	53                   	push   %ebx
80101797:	e8 54 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010179c:	83 c4 10             	add    $0x10,%esp
8010179f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801017a5:	73 69                	jae    80101810 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017a7:	89 f8                	mov    %edi,%eax
801017a9:	83 ec 08             	sub    $0x8,%esp
801017ac:	c1 e8 03             	shr    $0x3,%eax
801017af:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017b5:	50                   	push   %eax
801017b6:	56                   	push   %esi
801017b7:	e8 14 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801017bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801017bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801017c1:	89 f8                	mov    %edi,%eax
801017c3:	83 e0 07             	and    $0x7,%eax
801017c6:	c1 e0 06             	shl    $0x6,%eax
801017c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017d1:	75 bd                	jne    80101790 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017d3:	83 ec 04             	sub    $0x4,%esp
801017d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017d9:	6a 40                	push   $0x40
801017db:	6a 00                	push   $0x0
801017dd:	51                   	push   %ecx
801017de:	e8 1d 31 00 00       	call   80104900 <memset>
      dip->type = type;
801017e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ed:	89 1c 24             	mov    %ebx,(%esp)
801017f0:	e8 0b 19 00 00       	call   80103100 <log_write>
      brelse(bp);
801017f5:	89 1c 24             	mov    %ebx,(%esp)
801017f8:	e8 f3 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017fd:	83 c4 10             	add    $0x10,%esp
}
80101800:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101803:	89 fa                	mov    %edi,%edx
}
80101805:	5b                   	pop    %ebx
      return iget(dev, inum);
80101806:	89 f0                	mov    %esi,%eax
}
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010180b:	e9 90 fc ff ff       	jmp    801014a0 <iget>
  panic("ialloc: no inodes");
80101810:	83 ec 0c             	sub    $0xc,%esp
80101813:	68 38 76 10 80       	push   $0x80107638
80101818:	e8 73 eb ff ff       	call   80100390 <panic>
8010181d:	8d 76 00             	lea    0x0(%esi),%esi

80101820 <iupdate>:
{
80101820:	f3 0f 1e fb          	endbr32 
80101824:	55                   	push   %ebp
80101825:	89 e5                	mov    %esp,%ebp
80101827:	56                   	push   %esi
80101828:	53                   	push   %ebx
80101829:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010182f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101832:	83 ec 08             	sub    $0x8,%esp
80101835:	c1 e8 03             	shr    $0x3,%eax
80101838:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010183e:	50                   	push   %eax
8010183f:	ff 73 a4             	push   -0x5c(%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101847:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010184b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101850:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101853:	83 e0 07             	and    $0x7,%eax
80101856:	c1 e0 06             	shl    $0x6,%eax
80101859:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010185d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101860:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101864:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101867:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010186b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010186f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101873:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101877:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010187b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010187e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	53                   	push   %ebx
80101884:	50                   	push   %eax
80101885:	e8 16 31 00 00       	call   801049a0 <memmove>
  log_write(bp);
8010188a:	89 34 24             	mov    %esi,(%esp)
8010188d:	e8 6e 18 00 00       	call   80103100 <log_write>
  brelse(bp);
80101892:	89 75 08             	mov    %esi,0x8(%ebp)
80101895:	83 c4 10             	add    $0x10,%esp
}
80101898:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189b:	5b                   	pop    %ebx
8010189c:	5e                   	pop    %esi
8010189d:	5d                   	pop    %ebp
  brelse(bp);
8010189e:	e9 4d e9 ff ff       	jmp    801001f0 <brelse>
801018a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801018b0 <idup>:
{
801018b0:	f3 0f 1e fb          	endbr32 
801018b4:	55                   	push   %ebp
801018b5:	89 e5                	mov    %esp,%ebp
801018b7:	53                   	push   %ebx
801018b8:	83 ec 10             	sub    $0x10,%esp
801018bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018be:	68 60 f9 10 80       	push   $0x8010f960
801018c3:	e8 68 2f 00 00       	call   80104830 <acquire>
  ip->ref++;
801018c8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018cc:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018d3:	e8 e8 2e 00 00       	call   801047c0 <release>
}
801018d8:	89 d8                	mov    %ebx,%eax
801018da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018dd:	c9                   	leave  
801018de:	c3                   	ret    
801018df:	90                   	nop

801018e0 <ilock>:
{
801018e0:	f3 0f 1e fb          	endbr32 
801018e4:	55                   	push   %ebp
801018e5:	89 e5                	mov    %esp,%ebp
801018e7:	56                   	push   %esi
801018e8:	53                   	push   %ebx
801018e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018ec:	85 db                	test   %ebx,%ebx
801018ee:	0f 84 b3 00 00 00    	je     801019a7 <ilock+0xc7>
801018f4:	8b 53 08             	mov    0x8(%ebx),%edx
801018f7:	85 d2                	test   %edx,%edx
801018f9:	0f 8e a8 00 00 00    	jle    801019a7 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018ff:	83 ec 0c             	sub    $0xc,%esp
80101902:	8d 43 0c             	lea    0xc(%ebx),%eax
80101905:	50                   	push   %eax
80101906:	e8 25 2c 00 00       	call   80104530 <acquiresleep>
  if(ip->valid == 0){
8010190b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010190e:	83 c4 10             	add    $0x10,%esp
80101911:	85 c0                	test   %eax,%eax
80101913:	74 0b                	je     80101920 <ilock+0x40>
}
80101915:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101918:	5b                   	pop    %ebx
80101919:	5e                   	pop    %esi
8010191a:	5d                   	pop    %ebp
8010191b:	c3                   	ret    
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101920:	8b 43 04             	mov    0x4(%ebx),%eax
80101923:	83 ec 08             	sub    $0x8,%esp
80101926:	c1 e8 03             	shr    $0x3,%eax
80101929:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010192f:	50                   	push   %eax
80101930:	ff 33                	push   (%ebx)
80101932:	e8 99 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101937:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010193a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010193c:	8b 43 04             	mov    0x4(%ebx),%eax
8010193f:	83 e0 07             	and    $0x7,%eax
80101942:	c1 e0 06             	shl    $0x6,%eax
80101945:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101949:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010194c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010194f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101953:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101957:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010195b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010195f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101963:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101967:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010196b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010196e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101971:	6a 34                	push   $0x34
80101973:	50                   	push   %eax
80101974:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101977:	50                   	push   %eax
80101978:	e8 23 30 00 00       	call   801049a0 <memmove>
    brelse(bp);
8010197d:	89 34 24             	mov    %esi,(%esp)
80101980:	e8 6b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010198d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101994:	0f 85 7b ff ff ff    	jne    80101915 <ilock+0x35>
      panic("ilock: no type");
8010199a:	83 ec 0c             	sub    $0xc,%esp
8010199d:	68 50 76 10 80       	push   $0x80107650
801019a2:	e8 e9 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
801019a7:	83 ec 0c             	sub    $0xc,%esp
801019aa:	68 4a 76 10 80       	push   $0x8010764a
801019af:	e8 dc e9 ff ff       	call   80100390 <panic>
801019b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop

801019c0 <iunlock>:
{
801019c0:	f3 0f 1e fb          	endbr32 
801019c4:	55                   	push   %ebp
801019c5:	89 e5                	mov    %esp,%ebp
801019c7:	56                   	push   %esi
801019c8:	53                   	push   %ebx
801019c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019cc:	85 db                	test   %ebx,%ebx
801019ce:	74 28                	je     801019f8 <iunlock+0x38>
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	8d 73 0c             	lea    0xc(%ebx),%esi
801019d6:	56                   	push   %esi
801019d7:	e8 f4 2b 00 00       	call   801045d0 <holdingsleep>
801019dc:	83 c4 10             	add    $0x10,%esp
801019df:	85 c0                	test   %eax,%eax
801019e1:	74 15                	je     801019f8 <iunlock+0x38>
801019e3:	8b 43 08             	mov    0x8(%ebx),%eax
801019e6:	85 c0                	test   %eax,%eax
801019e8:	7e 0e                	jle    801019f8 <iunlock+0x38>
  releasesleep(&ip->lock);
801019ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019f0:	5b                   	pop    %ebx
801019f1:	5e                   	pop    %esi
801019f2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019f3:	e9 98 2b 00 00       	jmp    80104590 <releasesleep>
    panic("iunlock");
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	68 5f 76 10 80       	push   $0x8010765f
80101a00:	e8 8b e9 ff ff       	call   80100390 <panic>
80101a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a10 <iput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	57                   	push   %edi
80101a18:	56                   	push   %esi
80101a19:	53                   	push   %ebx
80101a1a:	83 ec 28             	sub    $0x28,%esp
80101a1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a20:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a23:	57                   	push   %edi
80101a24:	e8 07 2b 00 00       	call   80104530 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a29:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a2c:	83 c4 10             	add    $0x10,%esp
80101a2f:	85 d2                	test   %edx,%edx
80101a31:	74 07                	je     80101a3a <iput+0x2a>
80101a33:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a38:	74 36                	je     80101a70 <iput+0x60>
  releasesleep(&ip->lock);
80101a3a:	83 ec 0c             	sub    $0xc,%esp
80101a3d:	57                   	push   %edi
80101a3e:	e8 4d 2b 00 00       	call   80104590 <releasesleep>
  acquire(&icache.lock);
80101a43:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a4a:	e8 e1 2d 00 00       	call   80104830 <acquire>
  ip->ref--;
80101a4f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a53:	83 c4 10             	add    $0x10,%esp
80101a56:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a60:	5b                   	pop    %ebx
80101a61:	5e                   	pop    %esi
80101a62:	5f                   	pop    %edi
80101a63:	5d                   	pop    %ebp
  release(&icache.lock);
80101a64:	e9 57 2d 00 00       	jmp    801047c0 <release>
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 60 f9 10 80       	push   $0x8010f960
80101a78:	e8 b3 2d 00 00       	call   80104830 <acquire>
    int r = ip->ref;
80101a7d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a80:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a87:	e8 34 2d 00 00       	call   801047c0 <release>
    if(r == 1){
80101a8c:	83 c4 10             	add    $0x10,%esp
80101a8f:	83 fe 01             	cmp    $0x1,%esi
80101a92:	75 a6                	jne    80101a3a <iput+0x2a>
80101a94:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a9a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a9d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101aa0:	89 cf                	mov    %ecx,%edi
80101aa2:	eb 0b                	jmp    80101aaf <iput+0x9f>
80101aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101aa8:	83 c6 04             	add    $0x4,%esi
80101aab:	39 fe                	cmp    %edi,%esi
80101aad:	74 19                	je     80101ac8 <iput+0xb8>
    if(ip->addrs[i]){
80101aaf:	8b 16                	mov    (%esi),%edx
80101ab1:	85 d2                	test   %edx,%edx
80101ab3:	74 f3                	je     80101aa8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101ab5:	8b 03                	mov    (%ebx),%eax
80101ab7:	e8 54 f8 ff ff       	call   80101310 <bfree>
      ip->addrs[i] = 0;
80101abc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101ac2:	eb e4                	jmp    80101aa8 <iput+0x98>
80101ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ac8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101ace:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	75 2d                	jne    80101b02 <iput+0xf2>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ad5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ad8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101adf:	53                   	push   %ebx
80101ae0:	e8 3b fd ff ff       	call   80101820 <iupdate>
      ip->type = 0;
80101ae5:	31 c0                	xor    %eax,%eax
80101ae7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101aeb:	89 1c 24             	mov    %ebx,(%esp)
80101aee:	e8 2d fd ff ff       	call   80101820 <iupdate>
      ip->valid = 0;
80101af3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	e9 38 ff ff ff       	jmp    80101a3a <iput+0x2a>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b02:	83 ec 08             	sub    $0x8,%esp
80101b05:	50                   	push   %eax
80101b06:	ff 33                	push   (%ebx)
80101b08:	e8 c3 e5 ff ff       	call   801000d0 <bread>
80101b0d:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b10:	83 c4 10             	add    $0x10,%esp
80101b13:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101b1c:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b1f:	89 cf                	mov    %ecx,%edi
80101b21:	eb 0c                	jmp    80101b2f <iput+0x11f>
80101b23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b27:	90                   	nop
80101b28:	83 c6 04             	add    $0x4,%esi
80101b2b:	39 f7                	cmp    %esi,%edi
80101b2d:	74 0f                	je     80101b3e <iput+0x12e>
      if(a[j])
80101b2f:	8b 16                	mov    (%esi),%edx
80101b31:	85 d2                	test   %edx,%edx
80101b33:	74 f3                	je     80101b28 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b35:	8b 03                	mov    (%ebx),%eax
80101b37:	e8 d4 f7 ff ff       	call   80101310 <bfree>
80101b3c:	eb ea                	jmp    80101b28 <iput+0x118>
    brelse(bp);
80101b3e:	83 ec 0c             	sub    $0xc,%esp
80101b41:	ff 75 e4             	push   -0x1c(%ebp)
80101b44:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b47:	e8 a4 e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b4c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b52:	8b 03                	mov    (%ebx),%eax
80101b54:	e8 b7 f7 ff ff       	call   80101310 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b59:	83 c4 10             	add    $0x10,%esp
80101b5c:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b63:	00 00 00 
80101b66:	e9 6a ff ff ff       	jmp    80101ad5 <iput+0xc5>
80101b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <iunlockput>:
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	56                   	push   %esi
80101b78:	53                   	push   %ebx
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b7c:	85 db                	test   %ebx,%ebx
80101b7e:	74 34                	je     80101bb4 <iunlockput+0x44>
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b86:	56                   	push   %esi
80101b87:	e8 44 2a 00 00       	call   801045d0 <holdingsleep>
80101b8c:	83 c4 10             	add    $0x10,%esp
80101b8f:	85 c0                	test   %eax,%eax
80101b91:	74 21                	je     80101bb4 <iunlockput+0x44>
80101b93:	8b 43 08             	mov    0x8(%ebx),%eax
80101b96:	85 c0                	test   %eax,%eax
80101b98:	7e 1a                	jle    80101bb4 <iunlockput+0x44>
  releasesleep(&ip->lock);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	56                   	push   %esi
80101b9e:	e8 ed 29 00 00       	call   80104590 <releasesleep>
  iput(ip);
80101ba3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ba6:	83 c4 10             	add    $0x10,%esp
}
80101ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bac:	5b                   	pop    %ebx
80101bad:	5e                   	pop    %esi
80101bae:	5d                   	pop    %ebp
  iput(ip);
80101baf:	e9 5c fe ff ff       	jmp    80101a10 <iput>
    panic("iunlock");
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	68 5f 76 10 80       	push   $0x8010765f
80101bbc:	e8 cf e7 ff ff       	call   80100390 <panic>
80101bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bcf:	90                   	nop

80101bd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bd0:	f3 0f 1e fb          	endbr32 
80101bd4:	55                   	push   %ebp
80101bd5:	89 e5                	mov    %esp,%ebp
80101bd7:	8b 55 08             	mov    0x8(%ebp),%edx
80101bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bdd:	8b 0a                	mov    (%edx),%ecx
80101bdf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101be2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101be5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101be8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101bec:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bef:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101bf3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bf7:	8b 52 58             	mov    0x58(%edx),%edx
80101bfa:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bfd:	5d                   	pop    %ebp
80101bfe:	c3                   	ret    
80101bff:	90                   	nop

80101c00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c00:	f3 0f 1e fb          	endbr32 
80101c04:	55                   	push   %ebp
80101c05:	89 e5                	mov    %esp,%ebp
80101c07:	57                   	push   %edi
80101c08:	56                   	push   %esi
80101c09:	53                   	push   %ebx
80101c0a:	83 ec 1c             	sub    $0x1c,%esp
80101c0d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c10:	8b 45 08             	mov    0x8(%ebp),%eax
80101c13:	8b 75 10             	mov    0x10(%ebp),%esi
80101c16:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c19:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c1c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c21:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c24:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c27:	0f 84 a3 00 00 00    	je     80101cd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c30:	8b 40 58             	mov    0x58(%eax),%eax
80101c33:	39 c6                	cmp    %eax,%esi
80101c35:	0f 87 b6 00 00 00    	ja     80101cf1 <readi+0xf1>
80101c3b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c3e:	31 c9                	xor    %ecx,%ecx
80101c40:	89 da                	mov    %ebx,%edx
80101c42:	01 f2                	add    %esi,%edx
80101c44:	0f 92 c1             	setb   %cl
80101c47:	89 cf                	mov    %ecx,%edi
80101c49:	0f 82 a2 00 00 00    	jb     80101cf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c4f:	89 c1                	mov    %eax,%ecx
80101c51:	29 f1                	sub    %esi,%ecx
80101c53:	39 d0                	cmp    %edx,%eax
80101c55:	0f 43 cb             	cmovae %ebx,%ecx
80101c58:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c5b:	85 c9                	test   %ecx,%ecx
80101c5d:	74 63                	je     80101cc2 <readi+0xc2>
80101c5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c63:	89 f2                	mov    %esi,%edx
80101c65:	c1 ea 09             	shr    $0x9,%edx
80101c68:	89 d8                	mov    %ebx,%eax
80101c6a:	e8 31 f9 ff ff       	call   801015a0 <bmap>
80101c6f:	83 ec 08             	sub    $0x8,%esp
80101c72:	50                   	push   %eax
80101c73:	ff 33                	push   (%ebx)
80101c75:	e8 56 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c7d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c82:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c85:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	89 f0                	mov    %esi,%eax
80101c89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c8e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c90:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c93:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c95:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c99:	39 d9                	cmp    %ebx,%ecx
80101c9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c9f:	01 df                	add    %ebx,%edi
80101ca1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ca3:	50                   	push   %eax
80101ca4:	ff 75 e0             	push   -0x20(%ebp)
80101ca7:	e8 f4 2c 00 00       	call   801049a0 <memmove>
    brelse(bp);
80101cac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101caf:	89 14 24             	mov    %edx,(%esp)
80101cb2:	e8 39 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cba:	83 c4 10             	add    $0x10,%esp
80101cbd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101cc0:	77 9e                	ja     80101c60 <readi+0x60>
  }
  return n;
80101cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc8:	5b                   	pop    %ebx
80101cc9:	5e                   	pop    %esi
80101cca:	5f                   	pop    %edi
80101ccb:	5d                   	pop    %ebp
80101ccc:	c3                   	ret    
80101ccd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 17                	ja     80101cf1 <readi+0xf1>
80101cda:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 0c                	je     80101cf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ce5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101cef:	ff e0                	jmp    *%eax
      return -1;
80101cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cf6:	eb cd                	jmp    80101cc5 <readi+0xc5>
80101cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cff:	90                   	nop

80101d00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d00:	f3 0f 1e fb          	endbr32 
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	57                   	push   %edi
80101d08:	56                   	push   %esi
80101d09:	53                   	push   %ebx
80101d0a:	83 ec 1c             	sub    $0x1c,%esp
80101d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d10:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d13:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d16:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d1b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d21:	8b 75 10             	mov    0x10(%ebp),%esi
80101d24:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d27:	0f 84 bb 00 00 00    	je     80101de8 <writei+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d30:	3b 70 58             	cmp    0x58(%eax),%esi
80101d33:	0f 87 eb 00 00 00    	ja     80101e24 <writei+0x124>
80101d39:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d3c:	31 d2                	xor    %edx,%edx
80101d3e:	89 f8                	mov    %edi,%eax
80101d40:	01 f0                	add    %esi,%eax
80101d42:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d45:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d4a:	0f 87 d4 00 00 00    	ja     80101e24 <writei+0x124>
80101d50:	85 d2                	test   %edx,%edx
80101d52:	0f 85 cc 00 00 00    	jne    80101e24 <writei+0x124>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d58:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d5f:	85 ff                	test   %edi,%edi
80101d61:	74 76                	je     80101dd9 <writei+0xd9>
80101d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d67:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d68:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d6b:	89 f2                	mov    %esi,%edx
80101d6d:	c1 ea 09             	shr    $0x9,%edx
80101d70:	89 f8                	mov    %edi,%eax
80101d72:	e8 29 f8 ff ff       	call   801015a0 <bmap>
80101d77:	83 ec 08             	sub    $0x8,%esp
80101d7a:	50                   	push   %eax
80101d7b:	ff 37                	push   (%edi)
80101d7d:	e8 4e e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d82:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d87:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d8a:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d8d:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d8f:	89 f0                	mov    %esi,%eax
80101d91:	83 c4 0c             	add    $0xc,%esp
80101d94:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d99:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d9b:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d9f:	39 d9                	cmp    %ebx,%ecx
80101da1:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101da4:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101da5:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101da7:	ff 75 dc             	push   -0x24(%ebp)
80101daa:	50                   	push   %eax
80101dab:	e8 f0 2b 00 00       	call   801049a0 <memmove>
    log_write(bp);
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	e8 48 13 00 00       	call   80103100 <log_write>
    brelse(bp);
80101db8:	89 3c 24             	mov    %edi,(%esp)
80101dbb:	e8 30 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dc0:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dc9:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dcc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101dcf:	77 97                	ja     80101d68 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101dd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dd4:	3b 70 58             	cmp    0x58(%eax),%esi
80101dd7:	77 37                	ja     80101e10 <writei+0x110>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ddf:	5b                   	pop    %ebx
80101de0:	5e                   	pop    %esi
80101de1:	5f                   	pop    %edi
80101de2:	5d                   	pop    %ebp
80101de3:	c3                   	ret    
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101de8:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101dec:	66 83 f8 09          	cmp    $0x9,%ax
80101df0:	77 32                	ja     80101e24 <writei+0x124>
80101df2:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101df9:	85 c0                	test   %eax,%eax
80101dfb:	74 27                	je     80101e24 <writei+0x124>
    return devsw[ip->major].write(ip, src, n);
80101dfd:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e03:	5b                   	pop    %ebx
80101e04:	5e                   	pop    %esi
80101e05:	5f                   	pop    %edi
80101e06:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e07:	ff e0                	jmp    *%eax
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e10:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e13:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e16:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e19:	50                   	push   %eax
80101e1a:	e8 01 fa ff ff       	call   80101820 <iupdate>
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	eb b5                	jmp    80101dd9 <writei+0xd9>
      return -1;
80101e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e29:	eb b1                	jmp    80101ddc <writei+0xdc>
80101e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e2f:	90                   	nop

80101e30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e30:	f3 0f 1e fb          	endbr32 
80101e34:	55                   	push   %ebp
80101e35:	89 e5                	mov    %esp,%ebp
80101e37:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e3a:	6a 0e                	push   $0xe
80101e3c:	ff 75 0c             	push   0xc(%ebp)
80101e3f:	ff 75 08             	push   0x8(%ebp)
80101e42:	e8 c9 2b 00 00       	call   80104a10 <strncmp>
}
80101e47:	c9                   	leave  
80101e48:	c3                   	ret    
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e50:	f3 0f 1e fb          	endbr32 
80101e54:	55                   	push   %ebp
80101e55:	89 e5                	mov    %esp,%ebp
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
80101e5a:	83 ec 1c             	sub    $0x1c,%esp
80101e5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e60:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e65:	0f 85 89 00 00 00    	jne    80101ef4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6b:	8b 53 58             	mov    0x58(%ebx),%edx
80101e6e:	31 ff                	xor    %edi,%edi
80101e70:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e73:	85 d2                	test   %edx,%edx
80101e75:	74 42                	je     80101eb9 <dirlookup+0x69>
80101e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e80:	6a 10                	push   $0x10
80101e82:	57                   	push   %edi
80101e83:	56                   	push   %esi
80101e84:	53                   	push   %ebx
80101e85:	e8 76 fd ff ff       	call   80101c00 <readi>
80101e8a:	83 c4 10             	add    $0x10,%esp
80101e8d:	83 f8 10             	cmp    $0x10,%eax
80101e90:	75 55                	jne    80101ee7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101e92:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e97:	74 18                	je     80101eb1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e9f:	6a 0e                	push   $0xe
80101ea1:	50                   	push   %eax
80101ea2:	ff 75 0c             	push   0xc(%ebp)
80101ea5:	e8 66 2b 00 00       	call   80104a10 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101eaa:	83 c4 10             	add    $0x10,%esp
80101ead:	85 c0                	test   %eax,%eax
80101eaf:	74 17                	je     80101ec8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eb1:	83 c7 10             	add    $0x10,%edi
80101eb4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101eb7:	72 c7                	jb     80101e80 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ebc:	31 c0                	xor    %eax,%eax
}
80101ebe:	5b                   	pop    %ebx
80101ebf:	5e                   	pop    %esi
80101ec0:	5f                   	pop    %edi
80101ec1:	5d                   	pop    %ebp
80101ec2:	c3                   	ret    
80101ec3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec7:	90                   	nop
      if(poff)
80101ec8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ecb:	85 c0                	test   %eax,%eax
80101ecd:	74 05                	je     80101ed4 <dirlookup+0x84>
        *poff = off;
80101ecf:	8b 45 10             	mov    0x10(%ebp),%eax
80101ed2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ed4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ed8:	8b 03                	mov    (%ebx),%eax
80101eda:	e8 c1 f5 ff ff       	call   801014a0 <iget>
}
80101edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee2:	5b                   	pop    %ebx
80101ee3:	5e                   	pop    %esi
80101ee4:	5f                   	pop    %edi
80101ee5:	5d                   	pop    %ebp
80101ee6:	c3                   	ret    
      panic("dirlookup read");
80101ee7:	83 ec 0c             	sub    $0xc,%esp
80101eea:	68 79 76 10 80       	push   $0x80107679
80101eef:	e8 9c e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ef4:	83 ec 0c             	sub    $0xc,%esp
80101ef7:	68 67 76 10 80       	push   $0x80107667
80101efc:	e8 8f e4 ff ff       	call   80100390 <panic>
80101f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop

80101f10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	57                   	push   %edi
80101f14:	56                   	push   %esi
80101f15:	53                   	push   %ebx
80101f16:	89 c3                	mov    %eax,%ebx
80101f18:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f1b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101f24:	0f 84 64 01 00 00    	je     8010208e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f2a:	e8 51 1c 00 00       	call   80103b80 <myproc>
  acquire(&icache.lock);
80101f2f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f32:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f35:	68 60 f9 10 80       	push   $0x8010f960
80101f3a:	e8 f1 28 00 00       	call   80104830 <acquire>
  ip->ref++;
80101f3f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f43:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101f4a:	e8 71 28 00 00       	call   801047c0 <release>
80101f4f:	83 c4 10             	add    $0x10,%esp
80101f52:	eb 07                	jmp    80101f5b <namex+0x4b>
80101f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f5b:	0f b6 03             	movzbl (%ebx),%eax
80101f5e:	3c 2f                	cmp    $0x2f,%al
80101f60:	74 f6                	je     80101f58 <namex+0x48>
  if(*path == 0)
80101f62:	84 c0                	test   %al,%al
80101f64:	0f 84 06 01 00 00    	je     80102070 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f6a:	0f b6 03             	movzbl (%ebx),%eax
80101f6d:	84 c0                	test   %al,%al
80101f6f:	0f 84 10 01 00 00    	je     80102085 <namex+0x175>
80101f75:	89 df                	mov    %ebx,%edi
80101f77:	3c 2f                	cmp    $0x2f,%al
80101f79:	0f 84 06 01 00 00    	je     80102085 <namex+0x175>
80101f7f:	90                   	nop
80101f80:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f84:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f87:	3c 2f                	cmp    $0x2f,%al
80101f89:	74 04                	je     80101f8f <namex+0x7f>
80101f8b:	84 c0                	test   %al,%al
80101f8d:	75 f1                	jne    80101f80 <namex+0x70>
  len = path - s;
80101f8f:	89 f8                	mov    %edi,%eax
80101f91:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f93:	83 f8 0d             	cmp    $0xd,%eax
80101f96:	0f 8e ac 00 00 00    	jle    80102048 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f9c:	83 ec 04             	sub    $0x4,%esp
80101f9f:	6a 0e                	push   $0xe
80101fa1:	53                   	push   %ebx
    path++;
80101fa2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101fa4:	ff 75 e4             	push   -0x1c(%ebp)
80101fa7:	e8 f4 29 00 00       	call   801049a0 <memmove>
80101fac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101faf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101fb2:	75 0c                	jne    80101fc0 <namex+0xb0>
80101fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fbb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fbe:	74 f8                	je     80101fb8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fc0:	83 ec 0c             	sub    $0xc,%esp
80101fc3:	56                   	push   %esi
80101fc4:	e8 17 f9 ff ff       	call   801018e0 <ilock>
    if(ip->type != T_DIR){
80101fc9:	83 c4 10             	add    $0x10,%esp
80101fcc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fd1:	0f 85 cd 00 00 00    	jne    801020a4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	74 09                	je     80101fe7 <namex+0xd7>
80101fde:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fe1:	0f 84 22 01 00 00    	je     80102109 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fe7:	83 ec 04             	sub    $0x4,%esp
80101fea:	6a 00                	push   $0x0
80101fec:	ff 75 e4             	push   -0x1c(%ebp)
80101fef:	56                   	push   %esi
80101ff0:	e8 5b fe ff ff       	call   80101e50 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ff5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	89 c7                	mov    %eax,%edi
80101ffd:	85 c0                	test   %eax,%eax
80101fff:	0f 84 e1 00 00 00    	je     801020e6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010200b:	52                   	push   %edx
8010200c:	e8 bf 25 00 00       	call   801045d0 <holdingsleep>
80102011:	83 c4 10             	add    $0x10,%esp
80102014:	85 c0                	test   %eax,%eax
80102016:	0f 84 30 01 00 00    	je     8010214c <namex+0x23c>
8010201c:	8b 56 08             	mov    0x8(%esi),%edx
8010201f:	85 d2                	test   %edx,%edx
80102021:	0f 8e 25 01 00 00    	jle    8010214c <namex+0x23c>
  releasesleep(&ip->lock);
80102027:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010202a:	83 ec 0c             	sub    $0xc,%esp
8010202d:	52                   	push   %edx
8010202e:	e8 5d 25 00 00       	call   80104590 <releasesleep>
  iput(ip);
80102033:	89 34 24             	mov    %esi,(%esp)
80102036:	89 fe                	mov    %edi,%esi
80102038:	e8 d3 f9 ff ff       	call   80101a10 <iput>
8010203d:	83 c4 10             	add    $0x10,%esp
80102040:	e9 16 ff ff ff       	jmp    80101f5b <namex+0x4b>
80102045:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102048:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010204b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010204e:	83 ec 04             	sub    $0x4,%esp
80102051:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102054:	50                   	push   %eax
80102055:	53                   	push   %ebx
    name[len] = 0;
80102056:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102058:	ff 75 e4             	push   -0x1c(%ebp)
8010205b:	e8 40 29 00 00       	call   801049a0 <memmove>
    name[len] = 0;
80102060:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102063:	83 c4 10             	add    $0x10,%esp
80102066:	c6 02 00             	movb   $0x0,(%edx)
80102069:	e9 41 ff ff ff       	jmp    80101faf <namex+0x9f>
8010206e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102070:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102073:	85 c0                	test   %eax,%eax
80102075:	0f 85 be 00 00 00    	jne    80102139 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010207b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207e:	89 f0                	mov    %esi,%eax
80102080:	5b                   	pop    %ebx
80102081:	5e                   	pop    %esi
80102082:	5f                   	pop    %edi
80102083:	5d                   	pop    %ebp
80102084:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102085:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102088:	89 df                	mov    %ebx,%edi
8010208a:	31 c0                	xor    %eax,%eax
8010208c:	eb c0                	jmp    8010204e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010208e:	ba 01 00 00 00       	mov    $0x1,%edx
80102093:	b8 01 00 00 00       	mov    $0x1,%eax
80102098:	e8 03 f4 ff ff       	call   801014a0 <iget>
8010209d:	89 c6                	mov    %eax,%esi
8010209f:	e9 b7 fe ff ff       	jmp    80101f5b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020aa:	53                   	push   %ebx
801020ab:	e8 20 25 00 00       	call   801045d0 <holdingsleep>
801020b0:	83 c4 10             	add    $0x10,%esp
801020b3:	85 c0                	test   %eax,%eax
801020b5:	0f 84 91 00 00 00    	je     8010214c <namex+0x23c>
801020bb:	8b 46 08             	mov    0x8(%esi),%eax
801020be:	85 c0                	test   %eax,%eax
801020c0:	0f 8e 86 00 00 00    	jle    8010214c <namex+0x23c>
  releasesleep(&ip->lock);
801020c6:	83 ec 0c             	sub    $0xc,%esp
801020c9:	53                   	push   %ebx
801020ca:	e8 c1 24 00 00       	call   80104590 <releasesleep>
  iput(ip);
801020cf:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020d2:	31 f6                	xor    %esi,%esi
  iput(ip);
801020d4:	e8 37 f9 ff ff       	call   80101a10 <iput>
      return 0;
801020d9:	83 c4 10             	add    $0x10,%esp
}
801020dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020df:	89 f0                	mov    %esi,%eax
801020e1:	5b                   	pop    %ebx
801020e2:	5e                   	pop    %esi
801020e3:	5f                   	pop    %edi
801020e4:	5d                   	pop    %ebp
801020e5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801020ec:	52                   	push   %edx
801020ed:	e8 de 24 00 00       	call   801045d0 <holdingsleep>
801020f2:	83 c4 10             	add    $0x10,%esp
801020f5:	85 c0                	test   %eax,%eax
801020f7:	74 53                	je     8010214c <namex+0x23c>
801020f9:	8b 4e 08             	mov    0x8(%esi),%ecx
801020fc:	85 c9                	test   %ecx,%ecx
801020fe:	7e 4c                	jle    8010214c <namex+0x23c>
  releasesleep(&ip->lock);
80102100:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102103:	83 ec 0c             	sub    $0xc,%esp
80102106:	52                   	push   %edx
80102107:	eb c1                	jmp    801020ca <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102109:	83 ec 0c             	sub    $0xc,%esp
8010210c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010210f:	53                   	push   %ebx
80102110:	e8 bb 24 00 00       	call   801045d0 <holdingsleep>
80102115:	83 c4 10             	add    $0x10,%esp
80102118:	85 c0                	test   %eax,%eax
8010211a:	74 30                	je     8010214c <namex+0x23c>
8010211c:	8b 7e 08             	mov    0x8(%esi),%edi
8010211f:	85 ff                	test   %edi,%edi
80102121:	7e 29                	jle    8010214c <namex+0x23c>
  releasesleep(&ip->lock);
80102123:	83 ec 0c             	sub    $0xc,%esp
80102126:	53                   	push   %ebx
80102127:	e8 64 24 00 00       	call   80104590 <releasesleep>
}
8010212c:	83 c4 10             	add    $0x10,%esp
}
8010212f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102132:	89 f0                	mov    %esi,%eax
80102134:	5b                   	pop    %ebx
80102135:	5e                   	pop    %esi
80102136:	5f                   	pop    %edi
80102137:	5d                   	pop    %ebp
80102138:	c3                   	ret    
    iput(ip);
80102139:	83 ec 0c             	sub    $0xc,%esp
8010213c:	56                   	push   %esi
    return 0;
8010213d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010213f:	e8 cc f8 ff ff       	call   80101a10 <iput>
    return 0;
80102144:	83 c4 10             	add    $0x10,%esp
80102147:	e9 2f ff ff ff       	jmp    8010207b <namex+0x16b>
    panic("iunlock");
8010214c:	83 ec 0c             	sub    $0xc,%esp
8010214f:	68 5f 76 10 80       	push   $0x8010765f
80102154:	e8 37 e2 ff ff       	call   80100390 <panic>
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <dirlink>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	57                   	push   %edi
80102168:	56                   	push   %esi
80102169:	53                   	push   %ebx
8010216a:	83 ec 20             	sub    $0x20,%esp
8010216d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102170:	6a 00                	push   $0x0
80102172:	ff 75 0c             	push   0xc(%ebp)
80102175:	53                   	push   %ebx
80102176:	e8 d5 fc ff ff       	call   80101e50 <dirlookup>
8010217b:	83 c4 10             	add    $0x10,%esp
8010217e:	85 c0                	test   %eax,%eax
80102180:	75 6b                	jne    801021ed <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102182:	8b 7b 58             	mov    0x58(%ebx),%edi
80102185:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102188:	85 ff                	test   %edi,%edi
8010218a:	74 2d                	je     801021b9 <dirlink+0x59>
8010218c:	31 ff                	xor    %edi,%edi
8010218e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102191:	eb 0d                	jmp    801021a0 <dirlink+0x40>
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	83 c7 10             	add    $0x10,%edi
8010219b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010219e:	73 19                	jae    801021b9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a0:	6a 10                	push   $0x10
801021a2:	57                   	push   %edi
801021a3:	56                   	push   %esi
801021a4:	53                   	push   %ebx
801021a5:	e8 56 fa ff ff       	call   80101c00 <readi>
801021aa:	83 c4 10             	add    $0x10,%esp
801021ad:	83 f8 10             	cmp    $0x10,%eax
801021b0:	75 4e                	jne    80102200 <dirlink+0xa0>
    if(de.inum == 0)
801021b2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021b7:	75 df                	jne    80102198 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801021b9:	83 ec 04             	sub    $0x4,%esp
801021bc:	8d 45 da             	lea    -0x26(%ebp),%eax
801021bf:	6a 0e                	push   $0xe
801021c1:	ff 75 0c             	push   0xc(%ebp)
801021c4:	50                   	push   %eax
801021c5:	e8 96 28 00 00       	call   80104a60 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ca:	6a 10                	push   $0x10
  de.inum = inum;
801021cc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021cf:	57                   	push   %edi
801021d0:	56                   	push   %esi
801021d1:	53                   	push   %ebx
  de.inum = inum;
801021d2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021d6:	e8 25 fb ff ff       	call   80101d00 <writei>
801021db:	83 c4 20             	add    $0x20,%esp
801021de:	83 f8 10             	cmp    $0x10,%eax
801021e1:	75 2a                	jne    8010220d <dirlink+0xad>
  return 0;
801021e3:	31 c0                	xor    %eax,%eax
}
801021e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e8:	5b                   	pop    %ebx
801021e9:	5e                   	pop    %esi
801021ea:	5f                   	pop    %edi
801021eb:	5d                   	pop    %ebp
801021ec:	c3                   	ret    
    iput(ip);
801021ed:	83 ec 0c             	sub    $0xc,%esp
801021f0:	50                   	push   %eax
801021f1:	e8 1a f8 ff ff       	call   80101a10 <iput>
    return -1;
801021f6:	83 c4 10             	add    $0x10,%esp
801021f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fe:	eb e5                	jmp    801021e5 <dirlink+0x85>
      panic("dirlink read");
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	68 88 76 10 80       	push   $0x80107688
80102208:	e8 83 e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010220d:	83 ec 0c             	sub    $0xc,%esp
80102210:	68 5e 7c 10 80       	push   $0x80107c5e
80102215:	e8 76 e1 ff ff       	call   80100390 <panic>
8010221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102220 <namei>:

struct inode*
namei(char *path)
{
80102220:	f3 0f 1e fb          	endbr32 
80102224:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102225:	31 d2                	xor    %edx,%edx
{
80102227:	89 e5                	mov    %esp,%ebp
80102229:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010222c:	8b 45 08             	mov    0x8(%ebp),%eax
8010222f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102232:	e8 d9 fc ff ff       	call   80101f10 <namex>
}
80102237:	c9                   	leave  
80102238:	c3                   	ret    
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102240 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102240:	f3 0f 1e fb          	endbr32 
80102244:	55                   	push   %ebp
  return namex(path, 1, name);
80102245:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010224a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010224c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010224f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102252:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102253:	e9 b8 fc ff ff       	jmp    80101f10 <namex>
80102258:	66 90                	xchg   %ax,%ax
8010225a:	66 90                	xchg   %ax,%ax
8010225c:	66 90                	xchg   %ax,%ax
8010225e:	66 90                	xchg   %ax,%ax

80102260 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102269:	85 c0                	test   %eax,%eax
8010226b:	0f 84 b4 00 00 00    	je     80102325 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102271:	8b 70 08             	mov    0x8(%eax),%esi
80102274:	89 c3                	mov    %eax,%ebx
80102276:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010227c:	0f 87 96 00 00 00    	ja     80102318 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	89 ca                	mov    %ecx,%edx
80102292:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102293:	83 e0 c0             	and    $0xffffffc0,%eax
80102296:	3c 40                	cmp    $0x40,%al
80102298:	75 f6                	jne    80102290 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010229a:	31 ff                	xor    %edi,%edi
8010229c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022a1:	89 f8                	mov    %edi,%eax
801022a3:	ee                   	out    %al,(%dx)
801022a4:	b8 01 00 00 00       	mov    $0x1,%eax
801022a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022ae:	ee                   	out    %al,(%dx)
801022af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022b4:	89 f0                	mov    %esi,%eax
801022b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022b7:	89 f0                	mov    %esi,%eax
801022b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022be:	c1 f8 08             	sar    $0x8,%eax
801022c1:	ee                   	out    %al,(%dx)
801022c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022c7:	89 f8                	mov    %edi,%eax
801022c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801022ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022d3:	c1 e0 04             	shl    $0x4,%eax
801022d6:	83 e0 10             	and    $0x10,%eax
801022d9:	83 c8 e0             	or     $0xffffffe0,%eax
801022dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022dd:	f6 03 04             	testb  $0x4,(%ebx)
801022e0:	75 16                	jne    801022f8 <idestart+0x98>
801022e2:	b8 20 00 00 00       	mov    $0x20,%eax
801022e7:	89 ca                	mov    %ecx,%edx
801022e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ed:	5b                   	pop    %ebx
801022ee:	5e                   	pop    %esi
801022ef:	5f                   	pop    %edi
801022f0:	5d                   	pop    %ebp
801022f1:	c3                   	ret    
801022f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022f8:	b8 30 00 00 00       	mov    $0x30,%eax
801022fd:	89 ca                	mov    %ecx,%edx
801022ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102300:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102305:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102308:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010230d:	fc                   	cld    
8010230e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102310:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102313:	5b                   	pop    %ebx
80102314:	5e                   	pop    %esi
80102315:	5f                   	pop    %edi
80102316:	5d                   	pop    %ebp
80102317:	c3                   	ret    
    panic("incorrect blockno");
80102318:	83 ec 0c             	sub    $0xc,%esp
8010231b:	68 f4 76 10 80       	push   $0x801076f4
80102320:	e8 6b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102325:	83 ec 0c             	sub    $0xc,%esp
80102328:	68 eb 76 10 80       	push   $0x801076eb
8010232d:	e8 5e e0 ff ff       	call   80100390 <panic>
80102332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102340 <ideinit>:
{
80102340:	f3 0f 1e fb          	endbr32 
80102344:	55                   	push   %ebp
80102345:	89 e5                	mov    %esp,%ebp
80102347:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010234a:	68 06 77 10 80       	push   $0x80107706
8010234f:	68 00 16 11 80       	push   $0x80111600
80102354:	e8 d7 22 00 00       	call   80104630 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102359:	58                   	pop    %eax
8010235a:	a1 84 17 11 80       	mov    0x80111784,%eax
8010235f:	5a                   	pop    %edx
80102360:	83 e8 01             	sub    $0x1,%eax
80102363:	50                   	push   %eax
80102364:	6a 0e                	push   $0xe
80102366:	e8 b5 02 00 00       	call   80102620 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010236b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010236e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102377:	90                   	nop
80102378:	ec                   	in     (%dx),%al
80102379:	83 e0 c0             	and    $0xffffffc0,%eax
8010237c:	3c 40                	cmp    $0x40,%al
8010237e:	75 f8                	jne    80102378 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102380:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102385:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010238a:	ee                   	out    %al,(%dx)
8010238b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102390:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102395:	eb 0e                	jmp    801023a5 <ideinit+0x65>
80102397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801023a0:	83 e9 01             	sub    $0x1,%ecx
801023a3:	74 0f                	je     801023b4 <ideinit+0x74>
801023a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023a6:	84 c0                	test   %al,%al
801023a8:	74 f6                	je     801023a0 <ideinit+0x60>
      havedisk1 = 1;
801023aa:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
801023b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023be:	ee                   	out    %al,(%dx)
}
801023bf:	c9                   	leave  
801023c0:	c3                   	ret    
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cf:	90                   	nop

801023d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023d0:	f3 0f 1e fb          	endbr32 
801023d4:	55                   	push   %ebp
801023d5:	89 e5                	mov    %esp,%ebp
801023d7:	57                   	push   %edi
801023d8:	56                   	push   %esi
801023d9:	53                   	push   %ebx
801023da:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023dd:	68 00 16 11 80       	push   $0x80111600
801023e2:	e8 49 24 00 00       	call   80104830 <acquire>

  if((b = idequeue) == 0){
801023e7:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 db                	test   %ebx,%ebx
801023f2:	74 5f                	je     80102453 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023f4:	8b 43 58             	mov    0x58(%ebx),%eax
801023f7:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023fc:	8b 33                	mov    (%ebx),%esi
801023fe:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102404:	75 2b                	jne    80102431 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102406:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010240b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop
80102410:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102411:	89 c1                	mov    %eax,%ecx
80102413:	83 e1 c0             	and    $0xffffffc0,%ecx
80102416:	80 f9 40             	cmp    $0x40,%cl
80102419:	75 f5                	jne    80102410 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010241b:	a8 21                	test   $0x21,%al
8010241d:	75 12                	jne    80102431 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010241f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102422:	b9 80 00 00 00       	mov    $0x80,%ecx
80102427:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010242c:	fc                   	cld    
8010242d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010242f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102431:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102434:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102437:	83 ce 02             	or     $0x2,%esi
8010243a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010243c:	53                   	push   %ebx
8010243d:	e8 ee 1e 00 00       	call   80104330 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102442:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	85 c0                	test   %eax,%eax
8010244c:	74 05                	je     80102453 <ideintr+0x83>
    idestart(idequeue);
8010244e:	e8 0d fe ff ff       	call   80102260 <idestart>
    release(&idelock);
80102453:	83 ec 0c             	sub    $0xc,%esp
80102456:	68 00 16 11 80       	push   $0x80111600
8010245b:	e8 60 23 00 00       	call   801047c0 <release>

  release(&idelock);
}
80102460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102463:	5b                   	pop    %ebx
80102464:	5e                   	pop    %esi
80102465:	5f                   	pop    %edi
80102466:	5d                   	pop    %ebp
80102467:	c3                   	ret    
80102468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246f:	90                   	nop

80102470 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 10             	sub    $0x10,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010247e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102481:	50                   	push   %eax
80102482:	e8 49 21 00 00       	call   801045d0 <holdingsleep>
80102487:	83 c4 10             	add    $0x10,%esp
8010248a:	85 c0                	test   %eax,%eax
8010248c:	0f 84 cf 00 00 00    	je     80102561 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102492:	8b 03                	mov    (%ebx),%eax
80102494:	83 e0 06             	and    $0x6,%eax
80102497:	83 f8 02             	cmp    $0x2,%eax
8010249a:	0f 84 b4 00 00 00    	je     80102554 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024a0:	8b 53 04             	mov    0x4(%ebx),%edx
801024a3:	85 d2                	test   %edx,%edx
801024a5:	74 0d                	je     801024b4 <iderw+0x44>
801024a7:	a1 e0 15 11 80       	mov    0x801115e0,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	0f 84 93 00 00 00    	je     80102547 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	68 00 16 11 80       	push   $0x80111600
801024bc:	e8 6f 23 00 00       	call   80104830 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024c1:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
801024c6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	85 c0                	test   %eax,%eax
801024d2:	74 6c                	je     80102540 <iderw+0xd0>
801024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d8:	89 c2                	mov    %eax,%edx
801024da:	8b 40 58             	mov    0x58(%eax),%eax
801024dd:	85 c0                	test   %eax,%eax
801024df:	75 f7                	jne    801024d8 <iderw+0x68>
801024e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024e6:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801024ec:	74 42                	je     80102530 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024ee:	8b 03                	mov    (%ebx),%eax
801024f0:	83 e0 06             	and    $0x6,%eax
801024f3:	83 f8 02             	cmp    $0x2,%eax
801024f6:	74 23                	je     8010251b <iderw+0xab>
801024f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop
    sleep(b, &idelock);
80102500:	83 ec 08             	sub    $0x8,%esp
80102503:	68 00 16 11 80       	push   $0x80111600
80102508:	53                   	push   %ebx
80102509:	e8 62 1d 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 c4 10             	add    $0x10,%esp
80102513:	83 e0 06             	and    $0x6,%eax
80102516:	83 f8 02             	cmp    $0x2,%eax
80102519:	75 e5                	jne    80102500 <iderw+0x90>
  }


  release(&idelock);
8010251b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102525:	c9                   	leave  
  release(&idelock);
80102526:	e9 95 22 00 00       	jmp    801047c0 <release>
8010252b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010252f:	90                   	nop
    idestart(b);
80102530:	89 d8                	mov    %ebx,%eax
80102532:	e8 29 fd ff ff       	call   80102260 <idestart>
80102537:	eb b5                	jmp    801024ee <iderw+0x7e>
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102540:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102545:	eb 9d                	jmp    801024e4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102547:	83 ec 0c             	sub    $0xc,%esp
8010254a:	68 35 77 10 80       	push   $0x80107735
8010254f:	e8 3c de ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102554:	83 ec 0c             	sub    $0xc,%esp
80102557:	68 20 77 10 80       	push   $0x80107720
8010255c:	e8 2f de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102561:	83 ec 0c             	sub    $0xc,%esp
80102564:	68 0a 77 10 80       	push   $0x8010770a
80102569:	e8 22 de ff ff       	call   80100390 <panic>
8010256e:	66 90                	xchg   %ax,%ax

80102570 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102575:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010257c:	00 c0 fe 
{
8010257f:	89 e5                	mov    %esp,%ebp
80102581:	56                   	push   %esi
80102582:	53                   	push   %ebx
  ioapic->reg = reg;
80102583:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010258a:	00 00 00 
  return ioapic->data;
8010258d:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80102593:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102596:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010259c:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025a2:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025a9:	c1 ee 10             	shr    $0x10,%esi
801025ac:	89 f0                	mov    %esi,%eax
801025ae:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801025b1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801025b4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801025b7:	39 c2                	cmp    %eax,%edx
801025b9:	74 16                	je     801025d1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025bb:	83 ec 0c             	sub    $0xc,%esp
801025be:	68 54 77 10 80       	push   $0x80107754
801025c3:	e8 c8 e0 ff ff       	call   80100690 <cprintf>
  ioapic->reg = reg;
801025c8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801025ce:	83 c4 10             	add    $0x10,%esp
801025d1:	83 c6 21             	add    $0x21,%esi
{
801025d4:	ba 10 00 00 00       	mov    $0x10,%edx
801025d9:	b8 20 00 00 00       	mov    $0x20,%eax
801025de:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801025e0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025e2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801025e4:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
801025ea:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025ed:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801025f3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801025f6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801025f9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801025fc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801025fe:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102604:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010260b:	39 f0                	cmp    %esi,%eax
8010260d:	75 d1                	jne    801025e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010260f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102612:	5b                   	pop    %ebx
80102613:	5e                   	pop    %esi
80102614:	5d                   	pop    %ebp
80102615:	c3                   	ret    
80102616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102620:	f3 0f 1e fb          	endbr32 
80102624:	55                   	push   %ebp
  ioapic->reg = reg;
80102625:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
8010262b:	89 e5                	mov    %esp,%ebp
8010262d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102630:	8d 50 20             	lea    0x20(%eax),%edx
80102633:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102637:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102639:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010263f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102642:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102645:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102648:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010264a:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010264f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102652:	89 50 10             	mov    %edx,0x10(%eax)
}
80102655:	5d                   	pop    %ebp
80102656:	c3                   	ret    
80102657:	66 90                	xchg   %ax,%ax
80102659:	66 90                	xchg   %ax,%ax
8010265b:	66 90                	xchg   %ax,%ax
8010265d:	66 90                	xchg   %ax,%ax
8010265f:	90                   	nop

80102660 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102660:	f3 0f 1e fb          	endbr32 
80102664:	55                   	push   %ebp
80102665:	89 e5                	mov    %esp,%ebp
80102667:	53                   	push   %ebx
80102668:	83 ec 04             	sub    $0x4,%esp
8010266b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010266e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102674:	75 7a                	jne    801026f0 <kfree+0x90>
80102676:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
8010267c:	72 72                	jb     801026f0 <kfree+0x90>
8010267e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102684:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102689:	77 65                	ja     801026f0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010268b:	83 ec 04             	sub    $0x4,%esp
8010268e:	68 00 10 00 00       	push   $0x1000
80102693:	6a 01                	push   $0x1
80102695:	53                   	push   %ebx
80102696:	e8 65 22 00 00       	call   80104900 <memset>

  if(kmem.use_lock)
8010269b:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801026a1:	83 c4 10             	add    $0x10,%esp
801026a4:	85 d2                	test   %edx,%edx
801026a6:	75 20                	jne    801026c8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026a8:	a1 78 16 11 80       	mov    0x80111678,%eax
801026ad:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026af:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
801026b4:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
801026ba:	85 c0                	test   %eax,%eax
801026bc:	75 22                	jne    801026e0 <kfree+0x80>
    release(&kmem.lock);
}
801026be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026c1:	c9                   	leave  
801026c2:	c3                   	ret    
801026c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026c7:	90                   	nop
    acquire(&kmem.lock);
801026c8:	83 ec 0c             	sub    $0xc,%esp
801026cb:	68 40 16 11 80       	push   $0x80111640
801026d0:	e8 5b 21 00 00       	call   80104830 <acquire>
801026d5:	83 c4 10             	add    $0x10,%esp
801026d8:	eb ce                	jmp    801026a8 <kfree+0x48>
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801026e0:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
801026e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ea:	c9                   	leave  
    release(&kmem.lock);
801026eb:	e9 d0 20 00 00       	jmp    801047c0 <release>
    panic("kfree");
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 86 77 10 80       	push   $0x80107786
801026f8:	e8 93 dc ff ff       	call   80100390 <panic>
801026fd:	8d 76 00             	lea    0x0(%esi),%esi

80102700 <freerange>:
{
80102700:	f3 0f 1e fb          	endbr32 
80102704:	55                   	push   %ebp
80102705:	89 e5                	mov    %esp,%ebp
80102707:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102708:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010270b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010270e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010270f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102715:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102721:	39 de                	cmp    %ebx,%esi
80102723:	72 1f                	jb     80102744 <freerange+0x44>
80102725:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102728:	83 ec 0c             	sub    $0xc,%esp
8010272b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102731:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102737:	50                   	push   %eax
80102738:	e8 23 ff ff ff       	call   80102660 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	39 f3                	cmp    %esi,%ebx
80102742:	76 e4                	jbe    80102728 <freerange+0x28>
}
80102744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102747:	5b                   	pop    %ebx
80102748:	5e                   	pop    %esi
80102749:	5d                   	pop    %ebp
8010274a:	c3                   	ret    
8010274b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop

80102750 <kinit2>:
{
80102750:	f3 0f 1e fb          	endbr32 
80102754:	55                   	push   %ebp
80102755:	89 e5                	mov    %esp,%ebp
80102757:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102758:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010275b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010275e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010275f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102765:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102771:	39 de                	cmp    %ebx,%esi
80102773:	72 1f                	jb     80102794 <kinit2+0x44>
80102775:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102778:	83 ec 0c             	sub    $0xc,%esp
8010277b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102781:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102787:	50                   	push   %eax
80102788:	e8 d3 fe ff ff       	call   80102660 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010278d:	83 c4 10             	add    $0x10,%esp
80102790:	39 de                	cmp    %ebx,%esi
80102792:	73 e4                	jae    80102778 <kinit2+0x28>
  kmem.use_lock = 1;
80102794:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010279b:	00 00 00 
}
8010279e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027a1:	5b                   	pop    %ebx
801027a2:	5e                   	pop    %esi
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <kinit1>:
{
801027b0:	f3 0f 1e fb          	endbr32 
801027b4:	55                   	push   %ebp
801027b5:	89 e5                	mov    %esp,%ebp
801027b7:	56                   	push   %esi
801027b8:	53                   	push   %ebx
801027b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027bc:	83 ec 08             	sub    $0x8,%esp
801027bf:	68 8c 77 10 80       	push   $0x8010778c
801027c4:	68 40 16 11 80       	push   $0x80111640
801027c9:	e8 62 1e 00 00       	call   80104630 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027d4:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
801027db:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027de:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027e4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027f0:	39 de                	cmp    %ebx,%esi
801027f2:	72 20                	jb     80102814 <kinit1+0x64>
801027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027f8:	83 ec 0c             	sub    $0xc,%esp
801027fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102801:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102807:	50                   	push   %eax
80102808:	e8 53 fe ff ff       	call   80102660 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280d:	83 c4 10             	add    $0x10,%esp
80102810:	39 de                	cmp    %ebx,%esi
80102812:	73 e4                	jae    801027f8 <kinit1+0x48>
}
80102814:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102817:	5b                   	pop    %ebx
80102818:	5e                   	pop    %esi
80102819:	5d                   	pop    %ebp
8010281a:	c3                   	ret    
8010281b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop

80102820 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102820:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102824:	a1 74 16 11 80       	mov    0x80111674,%eax
80102829:	85 c0                	test   %eax,%eax
8010282b:	75 1b                	jne    80102848 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010282d:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
80102832:	85 c0                	test   %eax,%eax
80102834:	74 0a                	je     80102840 <kalloc+0x20>
    kmem.freelist = r->next;
80102836:	8b 10                	mov    (%eax),%edx
80102838:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010283e:	c3                   	ret    
8010283f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102840:	c3                   	ret    
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102848:	55                   	push   %ebp
80102849:	89 e5                	mov    %esp,%ebp
8010284b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010284e:	68 40 16 11 80       	push   $0x80111640
80102853:	e8 d8 1f 00 00       	call   80104830 <acquire>
  r = kmem.freelist;
80102858:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
8010285d:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
80102863:	83 c4 10             	add    $0x10,%esp
80102866:	85 c0                	test   %eax,%eax
80102868:	74 08                	je     80102872 <kalloc+0x52>
    kmem.freelist = r->next;
8010286a:	8b 08                	mov    (%eax),%ecx
8010286c:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
80102872:	85 d2                	test   %edx,%edx
80102874:	74 16                	je     8010288c <kalloc+0x6c>
    release(&kmem.lock);
80102876:	83 ec 0c             	sub    $0xc,%esp
80102879:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010287c:	68 40 16 11 80       	push   $0x80111640
80102881:	e8 3a 1f 00 00       	call   801047c0 <release>
  return (char*)r;
80102886:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102889:	83 c4 10             	add    $0x10,%esp
}
8010288c:	c9                   	leave  
8010288d:	c3                   	ret    
8010288e:	66 90                	xchg   %ax,%ax

80102890 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102890:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	ba 64 00 00 00       	mov    $0x64,%edx
80102899:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010289a:	a8 01                	test   $0x1,%al
8010289c:	0f 84 c6 00 00 00    	je     80102968 <kbdgetc+0xd8>
{
801028a2:	55                   	push   %ebp
801028a3:	ba 60 00 00 00       	mov    $0x60,%edx
801028a8:	89 e5                	mov    %esp,%ebp
801028aa:	53                   	push   %ebx
801028ab:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028ac:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801028b2:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028b5:	3c e0                	cmp    $0xe0,%al
801028b7:	74 57                	je     80102910 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028b9:	89 da                	mov    %ebx,%edx
801028bb:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028be:	84 c0                	test   %al,%al
801028c0:	78 5e                	js     80102920 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028c2:	85 d2                	test   %edx,%edx
801028c4:	74 09                	je     801028cf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028c6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028c9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028cc:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028cf:	0f b6 91 c0 78 10 80 	movzbl -0x7fef8740(%ecx),%edx
  shift ^= togglecode[data];
801028d6:	0f b6 81 c0 77 10 80 	movzbl -0x7fef8840(%ecx),%eax
  shift |= shiftcode[data];
801028dd:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028df:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028e1:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028e3:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801028e9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028ec:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ef:	8b 04 85 a0 77 10 80 	mov    -0x7fef8860(,%eax,4),%eax
801028f6:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801028fa:	74 0b                	je     80102907 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801028fc:	8d 50 9f             	lea    -0x61(%eax),%edx
801028ff:	83 fa 19             	cmp    $0x19,%edx
80102902:	77 4c                	ja     80102950 <kbdgetc+0xc0>
      c += 'A' - 'a';
80102904:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010290a:	c9                   	leave  
8010290b:	c3                   	ret    
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102910:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102913:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102915:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010291b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010291e:	c9                   	leave  
8010291f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102920:	83 e0 7f             	and    $0x7f,%eax
80102923:	85 d2                	test   %edx,%edx
80102925:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
80102928:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010292a:	0f b6 91 c0 78 10 80 	movzbl -0x7fef8740(%ecx),%edx
80102931:	83 ca 40             	or     $0x40,%edx
80102934:	0f b6 d2             	movzbl %dl,%edx
80102937:	f7 d2                	not    %edx
80102939:	21 da                	and    %ebx,%edx
}
8010293b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010293e:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
}
80102944:	c9                   	leave  
80102945:	c3                   	ret    
80102946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294d:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102950:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102953:	8d 50 20             	lea    0x20(%eax),%edx
}
80102956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102959:	c9                   	leave  
      c += 'a' - 'A';
8010295a:	83 f9 1a             	cmp    $0x1a,%ecx
8010295d:	0f 42 c2             	cmovb  %edx,%eax
}
80102960:	c3                   	ret    
80102961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010296d:	c3                   	ret    
8010296e:	66 90                	xchg   %ax,%ax

80102970 <kbdintr>:

void
kbdintr(void)
{
80102970:	f3 0f 1e fb          	endbr32 
80102974:	55                   	push   %ebp
80102975:	89 e5                	mov    %esp,%ebp
80102977:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010297a:	68 90 28 10 80       	push   $0x80102890
8010297f:	e8 7c df ff ff       	call   80100900 <consoleintr>
}
80102984:	83 c4 10             	add    $0x10,%esp
80102987:	c9                   	leave  
80102988:	c3                   	ret    
80102989:	66 90                	xchg   %ax,%ax
8010298b:	66 90                	xchg   %ax,%ax
8010298d:	66 90                	xchg   %ax,%ax
8010298f:	90                   	nop

80102990 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102990:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102994:	a1 80 16 11 80       	mov    0x80111680,%eax
80102999:	85 c0                	test   %eax,%eax
8010299b:	0f 84 c7 00 00 00    	je     80102a68 <lapicinit+0xd8>
  lapic[index] = value;
801029a1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029a8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ae:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029b5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029bb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029c2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029cf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029d2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029dc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029df:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029e9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ec:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029ef:	8b 50 30             	mov    0x30(%eax),%edx
801029f2:	c1 ea 10             	shr    $0x10,%edx
801029f5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801029fb:	75 73                	jne    80102a70 <lapicinit+0xe0>
  lapic[index] = value;
801029fd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a0a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a11:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a17:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a24:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a2b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a31:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a38:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a45:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a48:	8b 50 20             	mov    0x20(%eax),%edx
80102a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a56:	80 e6 10             	and    $0x10,%dh
80102a59:	75 f5                	jne    80102a50 <lapicinit+0xc0>
  lapic[index] = value;
80102a5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a68:	c3                   	ret    
80102a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a7d:	e9 7b ff ff ff       	jmp    801029fd <lapicinit+0x6d>
80102a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a90 <lapicid>:

int
lapicid(void)
{
80102a90:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102a94:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a99:	85 c0                	test   %eax,%eax
80102a9b:	74 0b                	je     80102aa8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102a9d:	8b 40 20             	mov    0x20(%eax),%eax
80102aa0:	c1 e8 18             	shr    $0x18,%eax
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102aa8:	31 c0                	xor    %eax,%eax
}
80102aaa:	c3                   	ret    
80102aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aaf:	90                   	nop

80102ab0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ab0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102ab4:	a1 80 16 11 80       	mov    0x80111680,%eax
80102ab9:	85 c0                	test   %eax,%eax
80102abb:	74 0d                	je     80102aca <lapiceoi+0x1a>
  lapic[index] = value;
80102abd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102aca:	c3                   	ret    
80102acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102acf:	90                   	nop

80102ad0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ad0:	f3 0f 1e fb          	endbr32 
}
80102ad4:	c3                   	ret    
80102ad5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ae0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ae0:	f3 0f 1e fb          	endbr32 
80102ae4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102aea:	ba 70 00 00 00       	mov    $0x70,%edx
80102aef:	89 e5                	mov    %esp,%ebp
80102af1:	53                   	push   %ebx
80102af2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102af8:	ee                   	out    %al,(%dx)
80102af9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102afe:	ba 71 00 00 00       	mov    $0x71,%edx
80102b03:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b04:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b06:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b09:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b0f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b11:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b14:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b16:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b19:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b1c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b22:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b27:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b2d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b30:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b37:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b3d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b44:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b47:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b4a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b50:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b53:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b59:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b5c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b62:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b65:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6b:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b71:	c9                   	leave  
80102b72:	c3                   	ret    
80102b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b80:	f3 0f 1e fb          	endbr32 
80102b84:	55                   	push   %ebp
80102b85:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b8a:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8f:	89 e5                	mov    %esp,%ebp
80102b91:	57                   	push   %edi
80102b92:	56                   	push   %esi
80102b93:	53                   	push   %ebx
80102b94:	83 ec 4c             	sub    $0x4c,%esp
80102b97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b98:	ba 71 00 00 00       	mov    $0x71,%edx
80102b9d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b9e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba1:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ba6:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bb0:	31 c0                	xor    %eax,%eax
80102bb2:	89 da                	mov    %ebx,%edx
80102bb4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bba:	89 ca                	mov    %ecx,%edx
80102bbc:	ec                   	in     (%dx),%al
80102bbd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc0:	89 da                	mov    %ebx,%edx
80102bc2:	b8 02 00 00 00       	mov    $0x2,%eax
80102bc7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc8:	89 ca                	mov    %ecx,%edx
80102bca:	ec                   	in     (%dx),%al
80102bcb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bce:	89 da                	mov    %ebx,%edx
80102bd0:	b8 04 00 00 00       	mov    $0x4,%eax
80102bd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd6:	89 ca                	mov    %ecx,%edx
80102bd8:	ec                   	in     (%dx),%al
80102bd9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bdc:	89 da                	mov    %ebx,%edx
80102bde:	b8 07 00 00 00       	mov    $0x7,%eax
80102be3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be4:	89 ca                	mov    %ecx,%edx
80102be6:	ec                   	in     (%dx),%al
80102be7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bea:	89 da                	mov    %ebx,%edx
80102bec:	b8 08 00 00 00       	mov    $0x8,%eax
80102bf1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf2:	89 ca                	mov    %ecx,%edx
80102bf4:	ec                   	in     (%dx),%al
80102bf5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf7:	89 da                	mov    %ebx,%edx
80102bf9:	b8 09 00 00 00       	mov    $0x9,%eax
80102bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bff:	89 ca                	mov    %ecx,%edx
80102c01:	ec                   	in     (%dx),%al
80102c02:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c0f:	84 c0                	test   %al,%al
80102c11:	78 9d                	js     80102bb0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102c13:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c17:	89 fa                	mov    %edi,%edx
80102c19:	0f b6 fa             	movzbl %dl,%edi
80102c1c:	89 f2                	mov    %esi,%edx
80102c1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c21:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c25:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c28:	89 da                	mov    %ebx,%edx
80102c2a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c2d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c30:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c34:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c37:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c3a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c3e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c41:	31 c0                	xor    %eax,%eax
80102c43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c44:	89 ca                	mov    %ecx,%edx
80102c46:	ec                   	in     (%dx),%al
80102c47:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4a:	89 da                	mov    %ebx,%edx
80102c4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c4f:	b8 02 00 00 00       	mov    $0x2,%eax
80102c54:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c55:	89 ca                	mov    %ecx,%edx
80102c57:	ec                   	in     (%dx),%al
80102c58:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5b:	89 da                	mov    %ebx,%edx
80102c5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c60:	b8 04 00 00 00       	mov    $0x4,%eax
80102c65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c66:	89 ca                	mov    %ecx,%edx
80102c68:	ec                   	in     (%dx),%al
80102c69:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6c:	89 da                	mov    %ebx,%edx
80102c6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c71:	b8 07 00 00 00       	mov    $0x7,%eax
80102c76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c77:	89 ca                	mov    %ecx,%edx
80102c79:	ec                   	in     (%dx),%al
80102c7a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7d:	89 da                	mov    %ebx,%edx
80102c7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c82:	b8 08 00 00 00       	mov    $0x8,%eax
80102c87:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c88:	89 ca                	mov    %ecx,%edx
80102c8a:	ec                   	in     (%dx),%al
80102c8b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8e:	89 da                	mov    %ebx,%edx
80102c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c93:	b8 09 00 00 00       	mov    $0x9,%eax
80102c98:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c99:	89 ca                	mov    %ecx,%edx
80102c9b:	ec                   	in     (%dx),%al
80102c9c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c9f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ca5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ca8:	6a 18                	push   $0x18
80102caa:	50                   	push   %eax
80102cab:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cae:	50                   	push   %eax
80102caf:	e8 9c 1c 00 00       	call   80104950 <memcmp>
80102cb4:	83 c4 10             	add    $0x10,%esp
80102cb7:	85 c0                	test   %eax,%eax
80102cb9:	0f 85 f1 fe ff ff    	jne    80102bb0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102cbf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cc3:	75 78                	jne    80102d3d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cc8:	89 c2                	mov    %eax,%edx
80102cca:	83 e0 0f             	and    $0xf,%eax
80102ccd:	c1 ea 04             	shr    $0x4,%edx
80102cd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cd9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cdc:	89 c2                	mov    %eax,%edx
80102cde:	83 e0 0f             	and    $0xf,%eax
80102ce1:	c1 ea 04             	shr    $0x4,%edx
80102ce4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cea:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ced:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cf0:	89 c2                	mov    %eax,%edx
80102cf2:	83 e0 0f             	and    $0xf,%eax
80102cf5:	c1 ea 04             	shr    $0x4,%edx
80102cf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d01:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d04:	89 c2                	mov    %eax,%edx
80102d06:	83 e0 0f             	and    $0xf,%eax
80102d09:	c1 ea 04             	shr    $0x4,%edx
80102d0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d12:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d15:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d18:	89 c2                	mov    %eax,%edx
80102d1a:	83 e0 0f             	and    $0xf,%eax
80102d1d:	c1 ea 04             	shr    $0x4,%edx
80102d20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d26:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d29:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d2c:	89 c2                	mov    %eax,%edx
80102d2e:	83 e0 0f             	and    $0xf,%eax
80102d31:	c1 ea 04             	shr    $0x4,%edx
80102d34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d3d:	8b 75 08             	mov    0x8(%ebp),%esi
80102d40:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d43:	89 06                	mov    %eax,(%esi)
80102d45:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d48:	89 46 04             	mov    %eax,0x4(%esi)
80102d4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d4e:	89 46 08             	mov    %eax,0x8(%esi)
80102d51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d54:	89 46 0c             	mov    %eax,0xc(%esi)
80102d57:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d5a:	89 46 10             	mov    %eax,0x10(%esi)
80102d5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d60:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d63:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6d:	5b                   	pop    %ebx
80102d6e:	5e                   	pop    %esi
80102d6f:	5f                   	pop    %edi
80102d70:	5d                   	pop    %ebp
80102d71:	c3                   	ret    
80102d72:	66 90                	xchg   %ax,%ax
80102d74:	66 90                	xchg   %ax,%ax
80102d76:	66 90                	xchg   %ax,%ax
80102d78:	66 90                	xchg   %ax,%ax
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d80:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102d86:	85 c9                	test   %ecx,%ecx
80102d88:	0f 8e 8a 00 00 00    	jle    80102e18 <install_trans+0x98>
{
80102d8e:	55                   	push   %ebp
80102d8f:	89 e5                	mov    %esp,%ebp
80102d91:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d92:	31 ff                	xor    %edi,%edi
{
80102d94:	56                   	push   %esi
80102d95:	53                   	push   %ebx
80102d96:	83 ec 0c             	sub    $0xc,%esp
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102da0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102da5:	83 ec 08             	sub    $0x8,%esp
80102da8:	01 f8                	add    %edi,%eax
80102daa:	83 c0 01             	add    $0x1,%eax
80102dad:	50                   	push   %eax
80102dae:	ff 35 e4 16 11 80    	push   0x801116e4
80102db4:	e8 17 d3 ff ff       	call   801000d0 <bread>
80102db9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbb:	58                   	pop    %eax
80102dbc:	5a                   	pop    %edx
80102dbd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102dc4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dcd:	e8 fe d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dd5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dda:	68 00 02 00 00       	push   $0x200
80102ddf:	50                   	push   %eax
80102de0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102de3:	50                   	push   %eax
80102de4:	e8 b7 1b 00 00       	call   801049a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102de9:	89 1c 24             	mov    %ebx,(%esp)
80102dec:	e8 bf d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102df1:	89 34 24             	mov    %esi,(%esp)
80102df4:	e8 f7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102df9:	89 1c 24             	mov    %ebx,(%esp)
80102dfc:	e8 ef d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102e0a:	7f 94                	jg     80102da0 <install_trans+0x20>
  }
}
80102e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e0f:	5b                   	pop    %ebx
80102e10:	5e                   	pop    %esi
80102e11:	5f                   	pop    %edi
80102e12:	5d                   	pop    %ebp
80102e13:	c3                   	ret    
80102e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e18:	c3                   	ret    
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e27:	ff 35 d4 16 11 80    	push   0x801116d4
80102e2d:	ff 35 e4 16 11 80    	push   0x801116e4
80102e33:	e8 98 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e38:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e3e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e41:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e43:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e46:	85 c9                	test   %ecx,%ecx
80102e48:	7e 18                	jle    80102e62 <write_head+0x42>
80102e4a:	31 c0                	xor    %eax,%eax
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e50:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
80102e57:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102e5b:	83 c0 01             	add    $0x1,%eax
80102e5e:	39 c1                	cmp    %eax,%ecx
80102e60:	75 ee                	jne    80102e50 <write_head+0x30>
  }
  bwrite(buf);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	53                   	push   %ebx
80102e66:	e8 45 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e6b:	89 1c 24             	mov    %ebx,(%esp)
80102e6e:	e8 7d d3 ff ff       	call   801001f0 <brelse>
}
80102e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e76:	83 c4 10             	add    $0x10,%esp
80102e79:	c9                   	leave  
80102e7a:	c3                   	ret    
80102e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop

80102e80 <initlog>:
{
80102e80:	f3 0f 1e fb          	endbr32 
80102e84:	55                   	push   %ebp
80102e85:	89 e5                	mov    %esp,%ebp
80102e87:	53                   	push   %ebx
80102e88:	83 ec 2c             	sub    $0x2c,%esp
80102e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e8e:	68 c0 79 10 80       	push   $0x801079c0
80102e93:	68 a0 16 11 80       	push   $0x801116a0
80102e98:	e8 93 17 00 00       	call   80104630 <initlock>
  readsb(dev, &sb);
80102e9d:	58                   	pop    %eax
80102e9e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ea1:	5a                   	pop    %edx
80102ea2:	50                   	push   %eax
80102ea3:	53                   	push   %ebx
80102ea4:	e8 c7 e7 ff ff       	call   80101670 <readsb>
  log.start = sb.logstart;
80102ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102eac:	59                   	pop    %ecx
  log.dev = dev;
80102ead:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102eb3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102eb6:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102ebb:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102ec1:	5a                   	pop    %edx
80102ec2:	50                   	push   %eax
80102ec3:	53                   	push   %ebx
80102ec4:	e8 07 d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ec9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ecc:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102ecf:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102ed1:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102ed7:	85 db                	test   %ebx,%ebx
80102ed9:	7e 17                	jle    80102ef2 <initlog+0x72>
80102edb:	31 c0                	xor    %eax,%eax
80102edd:	8d 76 00             	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ee0:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102ee4:	89 14 85 ec 16 11 80 	mov    %edx,-0x7feee914(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102eeb:	83 c0 01             	add    $0x1,%eax
80102eee:	39 c3                	cmp    %eax,%ebx
80102ef0:	75 ee                	jne    80102ee0 <initlog+0x60>
  brelse(buf);
80102ef2:	83 ec 0c             	sub    $0xc,%esp
80102ef5:	51                   	push   %ecx
80102ef6:	e8 f5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102efb:	e8 80 fe ff ff       	call   80102d80 <install_trans>
  log.lh.n = 0;
80102f00:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f07:	00 00 00 
  write_head(); // clear the log
80102f0a:	e8 11 ff ff ff       	call   80102e20 <write_head>
}
80102f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f12:	83 c4 10             	add    $0x10,%esp
80102f15:	c9                   	leave  
80102f16:	c3                   	ret    
80102f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f2a:	68 a0 16 11 80       	push   $0x801116a0
80102f2f:	e8 fc 18 00 00       	call   80104830 <acquire>
80102f34:	83 c4 10             	add    $0x10,%esp
80102f37:	eb 1c                	jmp    80102f55 <begin_op+0x35>
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f40:	83 ec 08             	sub    $0x8,%esp
80102f43:	68 a0 16 11 80       	push   $0x801116a0
80102f48:	68 a0 16 11 80       	push   $0x801116a0
80102f4d:	e8 1e 13 00 00       	call   80104270 <sleep>
80102f52:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f55:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102f5a:	85 c0                	test   %eax,%eax
80102f5c:	75 e2                	jne    80102f40 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f5e:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f63:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f69:	83 c0 01             	add    $0x1,%eax
80102f6c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f6f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f72:	83 fa 1e             	cmp    $0x1e,%edx
80102f75:	7f c9                	jg     80102f40 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f77:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f7a:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102f7f:	68 a0 16 11 80       	push   $0x801116a0
80102f84:	e8 37 18 00 00       	call   801047c0 <release>
      break;
    }
  }
}
80102f89:	83 c4 10             	add    $0x10,%esp
80102f8c:	c9                   	leave  
80102f8d:	c3                   	ret    
80102f8e:	66 90                	xchg   %ax,%ax

80102f90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f90:	f3 0f 1e fb          	endbr32 
80102f94:	55                   	push   %ebp
80102f95:	89 e5                	mov    %esp,%ebp
80102f97:	57                   	push   %edi
80102f98:	56                   	push   %esi
80102f99:	53                   	push   %ebx
80102f9a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f9d:	68 a0 16 11 80       	push   $0x801116a0
80102fa2:	e8 89 18 00 00       	call   80104830 <acquire>
  log.outstanding -= 1;
80102fa7:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102fac:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102fb2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fb5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fb8:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102fbe:	85 f6                	test   %esi,%esi
80102fc0:	0f 85 1e 01 00 00    	jne    801030e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fc6:	85 db                	test   %ebx,%ebx
80102fc8:	0f 85 f2 00 00 00    	jne    801030c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fce:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102fd5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fd8:	83 ec 0c             	sub    $0xc,%esp
80102fdb:	68 a0 16 11 80       	push   $0x801116a0
80102fe0:	e8 db 17 00 00       	call   801047c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fe5:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102feb:	83 c4 10             	add    $0x10,%esp
80102fee:	85 c9                	test   %ecx,%ecx
80102ff0:	7f 3e                	jg     80103030 <end_op+0xa0>
    acquire(&log.lock);
80102ff2:	83 ec 0c             	sub    $0xc,%esp
80102ff5:	68 a0 16 11 80       	push   $0x801116a0
80102ffa:	e8 31 18 00 00       	call   80104830 <acquire>
    wakeup(&log);
80102fff:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80103006:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
8010300d:	00 00 00 
    wakeup(&log);
80103010:	e8 1b 13 00 00       	call   80104330 <wakeup>
    release(&log.lock);
80103015:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010301c:	e8 9f 17 00 00       	call   801047c0 <release>
80103021:	83 c4 10             	add    $0x10,%esp
}
80103024:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103027:	5b                   	pop    %ebx
80103028:	5e                   	pop    %esi
80103029:	5f                   	pop    %edi
8010302a:	5d                   	pop    %ebp
8010302b:	c3                   	ret    
8010302c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103030:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80103035:	83 ec 08             	sub    $0x8,%esp
80103038:	01 d8                	add    %ebx,%eax
8010303a:	83 c0 01             	add    $0x1,%eax
8010303d:	50                   	push   %eax
8010303e:	ff 35 e4 16 11 80    	push   0x801116e4
80103044:	e8 87 d0 ff ff       	call   801000d0 <bread>
80103049:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010304b:	58                   	pop    %eax
8010304c:	5a                   	pop    %edx
8010304d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80103054:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010305a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010305d:	e8 6e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103062:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103065:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103067:	8d 40 5c             	lea    0x5c(%eax),%eax
8010306a:	68 00 02 00 00       	push   $0x200
8010306f:	50                   	push   %eax
80103070:	8d 46 5c             	lea    0x5c(%esi),%eax
80103073:	50                   	push   %eax
80103074:	e8 27 19 00 00       	call   801049a0 <memmove>
    bwrite(to);  // write the log
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 2f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103081:	89 3c 24             	mov    %edi,(%esp)
80103084:	e8 67 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103089:	89 34 24             	mov    %esi,(%esp)
8010308c:	e8 5f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010309a:	7c 94                	jl     80103030 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010309c:	e8 7f fd ff ff       	call   80102e20 <write_head>
    install_trans(); // Now install writes to home locations
801030a1:	e8 da fc ff ff       	call   80102d80 <install_trans>
    log.lh.n = 0;
801030a6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801030ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801030b0:	e8 6b fd ff ff       	call   80102e20 <write_head>
801030b5:	e9 38 ff ff ff       	jmp    80102ff2 <end_op+0x62>
801030ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030c0:	83 ec 0c             	sub    $0xc,%esp
801030c3:	68 a0 16 11 80       	push   $0x801116a0
801030c8:	e8 63 12 00 00       	call   80104330 <wakeup>
  release(&log.lock);
801030cd:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801030d4:	e8 e7 16 00 00       	call   801047c0 <release>
801030d9:	83 c4 10             	add    $0x10,%esp
}
801030dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    
    panic("log.committing");
801030e4:	83 ec 0c             	sub    $0xc,%esp
801030e7:	68 c4 79 10 80       	push   $0x801079c4
801030ec:	e8 9f d2 ff ff       	call   80100390 <panic>
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop

80103100 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103100:	f3 0f 1e fb          	endbr32 
80103104:	55                   	push   %ebp
80103105:	89 e5                	mov    %esp,%ebp
80103107:	53                   	push   %ebx
80103108:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010310b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80103111:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103114:	83 fa 1d             	cmp    $0x1d,%edx
80103117:	0f 8f 91 00 00 00    	jg     801031ae <log_write+0xae>
8010311d:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80103122:	83 e8 01             	sub    $0x1,%eax
80103125:	39 c2                	cmp    %eax,%edx
80103127:	0f 8d 81 00 00 00    	jge    801031ae <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010312d:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80103132:	85 c0                	test   %eax,%eax
80103134:	0f 8e 81 00 00 00    	jle    801031bb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010313a:	83 ec 0c             	sub    $0xc,%esp
8010313d:	68 a0 16 11 80       	push   $0x801116a0
80103142:	e8 e9 16 00 00       	call   80104830 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103147:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
8010314d:	83 c4 10             	add    $0x10,%esp
80103150:	85 d2                	test   %edx,%edx
80103152:	7e 4e                	jle    801031a2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103154:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103157:	31 c0                	xor    %eax,%eax
80103159:	eb 0c                	jmp    80103167 <log_write+0x67>
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop
80103160:	83 c0 01             	add    $0x1,%eax
80103163:	39 c2                	cmp    %eax,%edx
80103165:	74 29                	je     80103190 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103167:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010316e:	75 f0                	jne    80103160 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103170:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103177:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010317a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010317d:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103184:	c9                   	leave  
  release(&log.lock);
80103185:	e9 36 16 00 00       	jmp    801047c0 <release>
8010318a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103190:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103197:	83 c2 01             	add    $0x1,%edx
8010319a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801031a0:	eb d5                	jmp    80103177 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801031a2:	8b 43 08             	mov    0x8(%ebx),%eax
801031a5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
801031aa:	75 cb                	jne    80103177 <log_write+0x77>
801031ac:	eb e9                	jmp    80103197 <log_write+0x97>
    panic("too big a transaction");
801031ae:	83 ec 0c             	sub    $0xc,%esp
801031b1:	68 d3 79 10 80       	push   $0x801079d3
801031b6:	e8 d5 d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031bb:	83 ec 0c             	sub    $0xc,%esp
801031be:	68 e9 79 10 80       	push   $0x801079e9
801031c3:	e8 c8 d1 ff ff       	call   80100390 <panic>
801031c8:	66 90                	xchg   %ax,%ax
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031d7:	e8 84 09 00 00       	call   80103b60 <cpuid>
801031dc:	89 c3                	mov    %eax,%ebx
801031de:	e8 7d 09 00 00       	call   80103b60 <cpuid>
801031e3:	83 ec 04             	sub    $0x4,%esp
801031e6:	53                   	push   %ebx
801031e7:	50                   	push   %eax
801031e8:	68 04 7a 10 80       	push   $0x80107a04
801031ed:	e8 9e d4 ff ff       	call   80100690 <cprintf>
  idtinit();       // load idt register
801031f2:	e8 49 2a 00 00       	call   80105c40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031f7:	e8 f4 08 00 00       	call   80103af0 <mycpu>
801031fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103203:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010320a:	e8 41 0c 00 00       	call   80103e50 <scheduler>
8010320f:	90                   	nop

80103210 <mpenter>:
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010321a:	e8 31 3b 00 00       	call   80106d50 <switchkvm>
  seginit();
8010321f:	e8 9c 3a 00 00       	call   80106cc0 <seginit>
  lapicinit();
80103224:	e8 67 f7 ff ff       	call   80102990 <lapicinit>
  mpmain();
80103229:	e8 a2 ff ff ff       	call   801031d0 <mpmain>
8010322e:	66 90                	xchg   %ax,%ax

80103230 <main>:
{
80103230:	f3 0f 1e fb          	endbr32 
80103234:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103238:	83 e4 f0             	and    $0xfffffff0,%esp
8010323b:	ff 71 fc             	push   -0x4(%ecx)
8010323e:	55                   	push   %ebp
8010323f:	89 e5                	mov    %esp,%ebp
80103241:	53                   	push   %ebx
80103242:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103243:	83 ec 08             	sub    $0x8,%esp
80103246:	68 00 00 40 80       	push   $0x80400000
8010324b:	68 d0 54 11 80       	push   $0x801154d0
80103250:	e8 5b f5 ff ff       	call   801027b0 <kinit1>
  kvmalloc();      // kernel page table
80103255:	e8 f6 3f 00 00       	call   80107250 <kvmalloc>
  mpinit();        // detect other processors
8010325a:	e8 81 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010325f:	e8 2c f7 ff ff       	call   80102990 <lapicinit>
  seginit();       // segment descriptors
80103264:	e8 57 3a 00 00       	call   80106cc0 <seginit>
  picinit();       // disable pic
80103269:	e8 82 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
8010326e:	e8 fd f2 ff ff       	call   80102570 <ioapicinit>
  consoleinit();   // console hardware
80103273:	e8 18 d9 ff ff       	call   80100b90 <consoleinit>
  uartinit();      // serial port
80103278:	e8 b3 2c 00 00       	call   80105f30 <uartinit>
  pinit();         // process table
8010327d:	e8 4e 08 00 00       	call   80103ad0 <pinit>
  tvinit();        // trap vectors
80103282:	e8 39 29 00 00       	call   80105bc0 <tvinit>
  binit();         // buffer cache
80103287:	e8 b4 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010328c:	e8 af dc ff ff       	call   80100f40 <fileinit>
  ideinit();       // disk 
80103291:	e8 aa f0 ff ff       	call   80102340 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103296:	83 c4 0c             	add    $0xc,%esp
80103299:	68 8a 00 00 00       	push   $0x8a
8010329e:	68 8c a4 10 80       	push   $0x8010a48c
801032a3:	68 00 70 00 80       	push   $0x80007000
801032a8:	e8 f3 16 00 00       	call   801049a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032ad:	83 c4 10             	add    $0x10,%esp
801032b0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032b7:	00 00 00 
801032ba:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032bf:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801032c4:	76 7a                	jbe    80103340 <main+0x110>
801032c6:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801032cb:	eb 1c                	jmp    801032e9 <main+0xb9>
801032cd:	8d 76 00             	lea    0x0(%esi),%esi
801032d0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032d7:	00 00 00 
801032da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032e0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032e5:	39 c3                	cmp    %eax,%ebx
801032e7:	73 57                	jae    80103340 <main+0x110>
    if(c == mycpu())  // We've started already.
801032e9:	e8 02 08 00 00       	call   80103af0 <mycpu>
801032ee:	39 c3                	cmp    %eax,%ebx
801032f0:	74 de                	je     801032d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032f2:	e8 29 f5 ff ff       	call   80102820 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103210,0x80006ff8
80103301:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103304:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010330b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010330e:	05 00 10 00 00       	add    $0x1000,%eax
80103313:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103318:	0f b6 03             	movzbl (%ebx),%eax
8010331b:	68 00 70 00 00       	push   $0x7000
80103320:	50                   	push   %eax
80103321:	e8 ba f7 ff ff       	call   80102ae0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103326:	83 c4 10             	add    $0x10,%esp
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103330:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103336:	85 c0                	test   %eax,%eax
80103338:	74 f6                	je     80103330 <main+0x100>
8010333a:	eb 94                	jmp    801032d0 <main+0xa0>
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103340:	83 ec 08             	sub    $0x8,%esp
80103343:	68 00 00 00 8e       	push   $0x8e000000
80103348:	68 00 00 40 80       	push   $0x80400000
8010334d:	e8 fe f3 ff ff       	call   80102750 <kinit2>
  userinit();      // first user process
80103352:	e8 59 08 00 00       	call   80103bb0 <userinit>
  mpmain();        // finish this processor's setup
80103357:	e8 74 fe ff ff       	call   801031d0 <mpmain>
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103365:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010336b:	53                   	push   %ebx
  e = addr+len;
8010336c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010336f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103372:	39 de                	cmp    %ebx,%esi
80103374:	72 10                	jb     80103386 <mpsearch1+0x26>
80103376:	eb 50                	jmp    801033c8 <mpsearch1+0x68>
80103378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop
80103380:	89 fe                	mov    %edi,%esi
80103382:	39 fb                	cmp    %edi,%ebx
80103384:	76 42                	jbe    801033c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103386:	83 ec 04             	sub    $0x4,%esp
80103389:	8d 7e 10             	lea    0x10(%esi),%edi
8010338c:	6a 04                	push   $0x4
8010338e:	68 18 7a 10 80       	push   $0x80107a18
80103393:	56                   	push   %esi
80103394:	e8 b7 15 00 00       	call   80104950 <memcmp>
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	89 c2                	mov    %eax,%edx
8010339e:	85 c0                	test   %eax,%eax
801033a0:	75 de                	jne    80103380 <mpsearch1+0x20>
801033a2:	89 f0                	mov    %esi,%eax
801033a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801033a8:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801033ab:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033ae:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033b0:	39 f8                	cmp    %edi,%eax
801033b2:	75 f4                	jne    801033a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b4:	84 d2                	test   %dl,%dl
801033b6:	75 c8                	jne    80103380 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret    
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033cb:	31 f6                	xor    %esi,%esi
}
801033cd:	5b                   	pop    %ebx
801033ce:	89 f0                	mov    %esi,%eax
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
801033d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop

801033e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	55                   	push   %ebp
801033e5:	89 e5                	mov    %esp,%ebp
801033e7:	57                   	push   %edi
801033e8:	56                   	push   %esi
801033e9:	53                   	push   %ebx
801033ea:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033ed:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033f4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033fb:	c1 e0 08             	shl    $0x8,%eax
801033fe:	09 d0                	or     %edx,%eax
80103400:	c1 e0 04             	shl    $0x4,%eax
80103403:	75 1b                	jne    80103420 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103405:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010340c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103413:	c1 e0 08             	shl    $0x8,%eax
80103416:	09 d0                	or     %edx,%eax
80103418:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010341b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103420:	ba 00 04 00 00       	mov    $0x400,%edx
80103425:	e8 36 ff ff ff       	call   80103360 <mpsearch1>
8010342a:	89 c3                	mov    %eax,%ebx
8010342c:	85 c0                	test   %eax,%eax
8010342e:	0f 84 4c 01 00 00    	je     80103580 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103434:	8b 73 04             	mov    0x4(%ebx),%esi
80103437:	85 f6                	test   %esi,%esi
80103439:	0f 84 31 01 00 00    	je     80103570 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
8010343f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103442:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103448:	6a 04                	push   $0x4
8010344a:	68 1d 7a 10 80       	push   $0x80107a1d
8010344f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103453:	e8 f8 14 00 00       	call   80104950 <memcmp>
80103458:	83 c4 10             	add    $0x10,%esp
8010345b:	85 c0                	test   %eax,%eax
8010345d:	0f 85 0d 01 00 00    	jne    80103570 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
80103463:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010346a:	3c 01                	cmp    $0x1,%al
8010346c:	74 08                	je     80103476 <mpinit+0x96>
8010346e:	3c 04                	cmp    $0x4,%al
80103470:	0f 85 fa 00 00 00    	jne    80103570 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80103476:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
8010347d:	66 85 d2             	test   %dx,%dx
80103480:	74 26                	je     801034a8 <mpinit+0xc8>
80103482:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103485:	89 f0                	mov    %esi,%eax
  sum = 0;
80103487:	31 d2                	xor    %edx,%edx
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103490:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103497:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010349a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010349c:	39 f8                	cmp    %edi,%eax
8010349e:	75 f0                	jne    80103490 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801034a0:	84 d2                	test   %dl,%dl
801034a2:	0f 85 c8 00 00 00    	jne    80103570 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034a8:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034ae:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034b3:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034ba:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034c0:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034c5:	03 55 e4             	add    -0x1c(%ebp),%edx
801034c8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034cf:	90                   	nop
801034d0:	39 d0                	cmp    %edx,%eax
801034d2:	73 15                	jae    801034e9 <mpinit+0x109>
    switch(*p){
801034d4:	0f b6 08             	movzbl (%eax),%ecx
801034d7:	80 f9 02             	cmp    $0x2,%cl
801034da:	74 54                	je     80103530 <mpinit+0x150>
801034dc:	77 42                	ja     80103520 <mpinit+0x140>
801034de:	84 c9                	test   %cl,%cl
801034e0:	74 5e                	je     80103540 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034e2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e5:	39 d0                	cmp    %edx,%eax
801034e7:	72 eb                	jb     801034d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034e9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034ec:	85 f6                	test   %esi,%esi
801034ee:	0f 84 e1 00 00 00    	je     801035d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034f4:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034f8:	74 15                	je     8010350f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034fa:	b8 70 00 00 00       	mov    $0x70,%eax
801034ff:	ba 22 00 00 00       	mov    $0x22,%edx
80103504:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103505:	ba 23 00 00 00       	mov    $0x23,%edx
8010350a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010350b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010350e:	ee                   	out    %al,(%dx)
  }
}
8010350f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103512:	5b                   	pop    %ebx
80103513:	5e                   	pop    %esi
80103514:	5f                   	pop    %edi
80103515:	5d                   	pop    %ebp
80103516:	c3                   	ret    
80103517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103520:	83 e9 03             	sub    $0x3,%ecx
80103523:	80 f9 01             	cmp    $0x1,%cl
80103526:	76 ba                	jbe    801034e2 <mpinit+0x102>
80103528:	31 f6                	xor    %esi,%esi
8010352a:	eb a4                	jmp    801034d0 <mpinit+0xf0>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103530:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103534:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103537:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010353d:	eb 91                	jmp    801034d0 <mpinit+0xf0>
8010353f:	90                   	nop
      if(ncpu < NCPU) {
80103540:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103546:	83 f9 07             	cmp    $0x7,%ecx
80103549:	7f 19                	jg     80103564 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010354b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103551:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103555:	83 c1 01             	add    $0x1,%ecx
80103558:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010355e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103564:	83 c0 14             	add    $0x14,%eax
      continue;
80103567:	e9 64 ff ff ff       	jmp    801034d0 <mpinit+0xf0>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	68 22 7a 10 80       	push   $0x80107a22
80103578:	e8 13 ce ff ff       	call   80100390 <panic>
8010357d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103580:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103585:	eb 13                	jmp    8010359a <mpinit+0x1ba>
80103587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103590:	89 f3                	mov    %esi,%ebx
80103592:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103598:	74 d6                	je     80103570 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010359a:	83 ec 04             	sub    $0x4,%esp
8010359d:	8d 73 10             	lea    0x10(%ebx),%esi
801035a0:	6a 04                	push   $0x4
801035a2:	68 18 7a 10 80       	push   $0x80107a18
801035a7:	53                   	push   %ebx
801035a8:	e8 a3 13 00 00       	call   80104950 <memcmp>
801035ad:	83 c4 10             	add    $0x10,%esp
801035b0:	89 c2                	mov    %eax,%edx
801035b2:	85 c0                	test   %eax,%eax
801035b4:	75 da                	jne    80103590 <mpinit+0x1b0>
801035b6:	89 d8                	mov    %ebx,%eax
801035b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035bf:	90                   	nop
    sum += addr[i];
801035c0:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801035c3:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801035c6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035c8:	39 f0                	cmp    %esi,%eax
801035ca:	75 f4                	jne    801035c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035cc:	84 d2                	test   %dl,%dl
801035ce:	75 c0                	jne    80103590 <mpinit+0x1b0>
801035d0:	e9 5f fe ff ff       	jmp    80103434 <mpinit+0x54>
    panic("Didn't find a suitable machine");
801035d5:	83 ec 0c             	sub    $0xc,%esp
801035d8:	68 3c 7a 10 80       	push   $0x80107a3c
801035dd:	e8 ae cd ff ff       	call   80100390 <panic>
801035e2:	66 90                	xchg   %ax,%ax
801035e4:	66 90                	xchg   %ax,%ax
801035e6:	66 90                	xchg   %ax,%ax
801035e8:	66 90                	xchg   %ax,%ax
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f9:	ba 21 00 00 00       	mov    $0x21,%edx
801035fe:	ee                   	out    %al,(%dx)
801035ff:	ba a1 00 00 00       	mov    $0xa1,%edx
80103604:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103605:	c3                   	ret    
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103610:	f3 0f 1e fb          	endbr32 
80103614:	55                   	push   %ebp
80103615:	89 e5                	mov    %esp,%ebp
80103617:	57                   	push   %edi
80103618:	56                   	push   %esi
80103619:	53                   	push   %ebx
8010361a:	83 ec 0c             	sub    $0xc,%esp
8010361d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103620:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103623:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103629:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010362f:	e8 2c d9 ff ff       	call   80100f60 <filealloc>
80103634:	89 03                	mov    %eax,(%ebx)
80103636:	85 c0                	test   %eax,%eax
80103638:	0f 84 ac 00 00 00    	je     801036ea <pipealloc+0xda>
8010363e:	e8 1d d9 ff ff       	call   80100f60 <filealloc>
80103643:	89 06                	mov    %eax,(%esi)
80103645:	85 c0                	test   %eax,%eax
80103647:	0f 84 8b 00 00 00    	je     801036d8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010364d:	e8 ce f1 ff ff       	call   80102820 <kalloc>
80103652:	89 c7                	mov    %eax,%edi
80103654:	85 c0                	test   %eax,%eax
80103656:	0f 84 b4 00 00 00    	je     80103710 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010365c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103663:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103666:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103669:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103670:	00 00 00 
  p->nwrite = 0;
80103673:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010367a:	00 00 00 
  p->nread = 0;
8010367d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103684:	00 00 00 
  initlock(&p->lock, "pipe");
80103687:	68 5b 7a 10 80       	push   $0x80107a5b
8010368c:	50                   	push   %eax
8010368d:	e8 9e 0f 00 00       	call   80104630 <initlock>
  (*f0)->type = FD_PIPE;
80103692:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103694:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103697:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010369d:	8b 03                	mov    (%ebx),%eax
8010369f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036a3:	8b 03                	mov    (%ebx),%eax
801036a5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036a9:	8b 03                	mov    (%ebx),%eax
801036ab:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ae:	8b 06                	mov    (%esi),%eax
801036b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036b6:	8b 06                	mov    (%esi),%eax
801036b8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036bc:	8b 06                	mov    (%esi),%eax
801036be:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ca:	31 c0                	xor    %eax,%eax
}
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036d8:	8b 03                	mov    (%ebx),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	74 1e                	je     801036fc <pipealloc+0xec>
    fileclose(*f0);
801036de:	83 ec 0c             	sub    $0xc,%esp
801036e1:	50                   	push   %eax
801036e2:	e8 39 d9 ff ff       	call   80101020 <fileclose>
801036e7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036ea:	8b 06                	mov    (%esi),%eax
801036ec:	85 c0                	test   %eax,%eax
801036ee:	74 0c                	je     801036fc <pipealloc+0xec>
    fileclose(*f1);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	50                   	push   %eax
801036f4:	e8 27 d9 ff ff       	call   80101020 <fileclose>
801036f9:	83 c4 10             	add    $0x10,%esp
}
801036fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103704:	5b                   	pop    %ebx
80103705:	5e                   	pop    %esi
80103706:	5f                   	pop    %edi
80103707:	5d                   	pop    %ebp
80103708:	c3                   	ret    
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103710:	8b 03                	mov    (%ebx),%eax
80103712:	85 c0                	test   %eax,%eax
80103714:	75 c8                	jne    801036de <pipealloc+0xce>
80103716:	eb d2                	jmp    801036ea <pipealloc+0xda>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop

80103720 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	56                   	push   %esi
80103728:	53                   	push   %ebx
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010372c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	53                   	push   %ebx
80103733:	e8 f8 10 00 00       	call   80104830 <acquire>
  if(writable){
80103738:	83 c4 10             	add    $0x10,%esp
8010373b:	85 f6                	test   %esi,%esi
8010373d:	74 61                	je     801037a0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010373f:	83 ec 0c             	sub    $0xc,%esp
80103742:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103748:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010374f:	00 00 00 
    wakeup(&p->nread);
80103752:	50                   	push   %eax
80103753:	e8 d8 0b 00 00       	call   80104330 <wakeup>
80103758:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010375b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103761:	85 d2                	test   %edx,%edx
80103763:	75 0a                	jne    8010376f <pipeclose+0x4f>
80103765:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010376b:	85 c0                	test   %eax,%eax
8010376d:	74 11                	je     80103780 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010376f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103772:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103775:	5b                   	pop    %ebx
80103776:	5e                   	pop    %esi
80103777:	5d                   	pop    %ebp
    release(&p->lock);
80103778:	e9 43 10 00 00       	jmp    801047c0 <release>
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	53                   	push   %ebx
80103784:	e8 37 10 00 00       	call   801047c0 <release>
    kfree((char*)p);
80103789:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010378c:	83 c4 10             	add    $0x10,%esp
}
8010378f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103792:	5b                   	pop    %ebx
80103793:	5e                   	pop    %esi
80103794:	5d                   	pop    %ebp
    kfree((char*)p);
80103795:	e9 c6 ee ff ff       	jmp    80102660 <kfree>
8010379a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037b0:	00 00 00 
    wakeup(&p->nwrite);
801037b3:	50                   	push   %eax
801037b4:	e8 77 0b 00 00       	call   80104330 <wakeup>
801037b9:	83 c4 10             	add    $0x10,%esp
801037bc:	eb 9d                	jmp    8010375b <pipeclose+0x3b>
801037be:	66 90                	xchg   %ax,%ax

801037c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037c0:	f3 0f 1e fb          	endbr32 
801037c4:	55                   	push   %ebp
801037c5:	89 e5                	mov    %esp,%ebp
801037c7:	57                   	push   %edi
801037c8:	56                   	push   %esi
801037c9:	53                   	push   %ebx
801037ca:	83 ec 28             	sub    $0x28,%esp
801037cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037d0:	53                   	push   %ebx
801037d1:	e8 5a 10 00 00       	call   80104830 <acquire>
  for(i = 0; i < n; i++){
801037d6:	8b 45 10             	mov    0x10(%ebp),%eax
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	85 c0                	test   %eax,%eax
801037de:	0f 8e bc 00 00 00    	jle    801038a0 <pipewrite+0xe0>
801037e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037ed:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037f6:	03 45 10             	add    0x10(%ebp),%eax
801037f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037fc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103802:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103808:	89 ca                	mov    %ecx,%edx
8010380a:	05 00 02 00 00       	add    $0x200,%eax
8010380f:	39 c1                	cmp    %eax,%ecx
80103811:	74 3b                	je     8010384e <pipewrite+0x8e>
80103813:	eb 63                	jmp    80103878 <pipewrite+0xb8>
80103815:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103818:	e8 63 03 00 00       	call   80103b80 <myproc>
8010381d:	8b 48 24             	mov    0x24(%eax),%ecx
80103820:	85 c9                	test   %ecx,%ecx
80103822:	75 34                	jne    80103858 <pipewrite+0x98>
      wakeup(&p->nread);
80103824:	83 ec 0c             	sub    $0xc,%esp
80103827:	57                   	push   %edi
80103828:	e8 03 0b 00 00       	call   80104330 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010382d:	58                   	pop    %eax
8010382e:	5a                   	pop    %edx
8010382f:	53                   	push   %ebx
80103830:	56                   	push   %esi
80103831:	e8 3a 0a 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103836:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010383c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103842:	83 c4 10             	add    $0x10,%esp
80103845:	05 00 02 00 00       	add    $0x200,%eax
8010384a:	39 c2                	cmp    %eax,%edx
8010384c:	75 2a                	jne    80103878 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010384e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103854:	85 c0                	test   %eax,%eax
80103856:	75 c0                	jne    80103818 <pipewrite+0x58>
        release(&p->lock);
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	53                   	push   %ebx
8010385c:	e8 5f 0f 00 00       	call   801047c0 <release>
        return -1;
80103861:	83 c4 10             	add    $0x10,%esp
80103864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386c:	5b                   	pop    %ebx
8010386d:	5e                   	pop    %esi
8010386e:	5f                   	pop    %edi
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103878:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010387b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010387e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103884:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010388a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010388d:	83 c6 01             	add    $0x1,%esi
80103890:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103893:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103897:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010389a:	0f 85 5c ff ff ff    	jne    801037fc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038a9:	50                   	push   %eax
801038aa:	e8 81 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801038af:	89 1c 24             	mov    %ebx,(%esp)
801038b2:	e8 09 0f 00 00       	call   801047c0 <release>
  return n;
801038b7:	8b 45 10             	mov    0x10(%ebp),%eax
801038ba:	83 c4 10             	add    $0x10,%esp
801038bd:	eb aa                	jmp    80103869 <pipewrite+0xa9>
801038bf:	90                   	nop

801038c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	57                   	push   %edi
801038c8:	56                   	push   %esi
801038c9:	53                   	push   %ebx
801038ca:	83 ec 18             	sub    $0x18,%esp
801038cd:	8b 75 08             	mov    0x8(%ebp),%esi
801038d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038d3:	56                   	push   %esi
801038d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038da:	e8 51 0f 00 00       	call   80104830 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038df:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038ee:	74 33                	je     80103923 <piperead+0x63>
801038f0:	eb 3b                	jmp    8010392d <piperead+0x6d>
801038f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801038f8:	e8 83 02 00 00       	call   80103b80 <myproc>
801038fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103900:	85 c9                	test   %ecx,%ecx
80103902:	0f 85 88 00 00 00    	jne    80103990 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103908:	83 ec 08             	sub    $0x8,%esp
8010390b:	56                   	push   %esi
8010390c:	53                   	push   %ebx
8010390d:	e8 5e 09 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103912:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103918:	83 c4 10             	add    $0x10,%esp
8010391b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103921:	75 0a                	jne    8010392d <piperead+0x6d>
80103923:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103929:	85 c0                	test   %eax,%eax
8010392b:	75 cb                	jne    801038f8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010392d:	8b 55 10             	mov    0x10(%ebp),%edx
80103930:	31 db                	xor    %ebx,%ebx
80103932:	85 d2                	test   %edx,%edx
80103934:	7f 28                	jg     8010395e <piperead+0x9e>
80103936:	eb 34                	jmp    8010396c <piperead+0xac>
80103938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103940:	8d 48 01             	lea    0x1(%eax),%ecx
80103943:	25 ff 01 00 00       	and    $0x1ff,%eax
80103948:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010394e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103953:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103956:	83 c3 01             	add    $0x1,%ebx
80103959:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010395c:	74 0e                	je     8010396c <piperead+0xac>
    if(p->nread == p->nwrite)
8010395e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103964:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010396a:	75 d4                	jne    80103940 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103975:	50                   	push   %eax
80103976:	e8 b5 09 00 00       	call   80104330 <wakeup>
  release(&p->lock);
8010397b:	89 34 24             	mov    %esi,(%esp)
8010397e:	e8 3d 0e 00 00       	call   801047c0 <release>
  return i;
80103983:	83 c4 10             	add    $0x10,%esp
}
80103986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103989:	89 d8                	mov    %ebx,%eax
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5f                   	pop    %edi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    
      release(&p->lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103993:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103998:	56                   	push   %esi
80103999:	e8 22 0e 00 00       	call   801047c0 <release>
      return -1;
8010399e:	83 c4 10             	add    $0x10,%esp
}
801039a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a4:	89 d8                	mov    %ebx,%eax
801039a6:	5b                   	pop    %ebx
801039a7:	5e                   	pop    %esi
801039a8:	5f                   	pop    %edi
801039a9:	5d                   	pop    %ebp
801039aa:	c3                   	ret    
801039ab:	66 90                	xchg   %ax,%ax
801039ad:	66 90                	xchg   %ax,%ax
801039af:	90                   	nop

801039b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801039b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039bc:	68 20 1d 11 80       	push   $0x80111d20
801039c1:	e8 6a 0e 00 00       	call   80104830 <acquire>
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	eb 10                	jmp    801039db <allocproc+0x2b>
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d0:	83 c3 7c             	add    $0x7c,%ebx
801039d3:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801039d9:	74 75                	je     80103a50 <allocproc+0xa0>
    if(p->state == UNUSED)
801039db:	8b 43 0c             	mov    0xc(%ebx),%eax
801039de:	85 c0                	test   %eax,%eax
801039e0:	75 ee                	jne    801039d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039f1:	89 43 10             	mov    %eax,0x10(%ebx)
801039f4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039f7:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
801039fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103a02:	e8 b9 0d 00 00       	call   801047c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a07:	e8 14 ee ff ff       	call   80102820 <kalloc>
80103a0c:	83 c4 10             	add    $0x10,%esp
80103a0f:	89 43 08             	mov    %eax,0x8(%ebx)
80103a12:	85 c0                	test   %eax,%eax
80103a14:	74 53                	je     80103a69 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a16:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a1c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a1f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a24:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a27:	c7 40 14 a6 5b 10 80 	movl   $0x80105ba6,0x14(%eax)
  p->context = (struct context*)sp;
80103a2e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a31:	6a 14                	push   $0x14
80103a33:	6a 00                	push   $0x0
80103a35:	50                   	push   %eax
80103a36:	e8 c5 0e 00 00       	call   80104900 <memset>
  p->context->eip = (uint)forkret;
80103a3b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a3e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a41:	c7 40 10 80 3a 10 80 	movl   $0x80103a80,0x10(%eax)
}
80103a48:	89 d8                	mov    %ebx,%eax
80103a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a4d:	c9                   	leave  
80103a4e:	c3                   	ret    
80103a4f:	90                   	nop
  release(&ptable.lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a55:	68 20 1d 11 80       	push   $0x80111d20
80103a5a:	e8 61 0d 00 00       	call   801047c0 <release>
}
80103a5f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a61:	83 c4 10             	add    $0x10,%esp
}
80103a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a67:	c9                   	leave  
80103a68:	c3                   	ret    
    p->state = UNUSED;
80103a69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a70:	31 db                	xor    %ebx,%ebx
}
80103a72:	89 d8                	mov    %ebx,%eax
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a80:	f3 0f 1e fb          	endbr32 
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a8a:	68 20 1d 11 80       	push   $0x80111d20
80103a8f:	e8 2c 0d 00 00       	call   801047c0 <release>

  if (first) {
80103a94:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a99:	83 c4 10             	add    $0x10,%esp
80103a9c:	85 c0                	test   %eax,%eax
80103a9e:	75 08                	jne    80103aa8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103aa0:	c9                   	leave  
80103aa1:	c3                   	ret    
80103aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103aa8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103aaf:	00 00 00 
    iinit(ROOTDEV);
80103ab2:	83 ec 0c             	sub    $0xc,%esp
80103ab5:	6a 01                	push   $0x1
80103ab7:	e8 f4 db ff ff       	call   801016b0 <iinit>
    initlog(ROOTDEV);
80103abc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ac3:	e8 b8 f3 ff ff       	call   80102e80 <initlog>
}
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	c9                   	leave  
80103acc:	c3                   	ret    
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

80103ad0 <pinit>:
{
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ada:	68 60 7a 10 80       	push   $0x80107a60
80103adf:	68 20 1d 11 80       	push   $0x80111d20
80103ae4:	e8 47 0b 00 00       	call   80104630 <initlock>
}
80103ae9:	83 c4 10             	add    $0x10,%esp
80103aec:	c9                   	leave  
80103aed:	c3                   	ret    
80103aee:	66 90                	xchg   %ax,%ax

80103af0 <mycpu>:
{
80103af0:	f3 0f 1e fb          	endbr32 
80103af4:	55                   	push   %ebp
80103af5:	89 e5                	mov    %esp,%ebp
80103af7:	56                   	push   %esi
80103af8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103af9:	9c                   	pushf  
80103afa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103afb:	f6 c4 02             	test   $0x2,%ah
80103afe:	75 4a                	jne    80103b4a <mycpu+0x5a>
  apicid = lapicid();
80103b00:	e8 8b ef ff ff       	call   80102a90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b05:	8b 35 84 17 11 80    	mov    0x80111784,%esi
  apicid = lapicid();
80103b0b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103b0d:	85 f6                	test   %esi,%esi
80103b0f:	7e 2c                	jle    80103b3d <mycpu+0x4d>
80103b11:	31 c0                	xor    %eax,%eax
80103b13:	eb 0a                	jmp    80103b1f <mycpu+0x2f>
80103b15:	8d 76 00             	lea    0x0(%esi),%esi
80103b18:	83 c0 01             	add    $0x1,%eax
80103b1b:	39 f0                	cmp    %esi,%eax
80103b1d:	74 1e                	je     80103b3d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b1f:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103b25:	0f b6 8a a0 17 11 80 	movzbl -0x7feee860(%edx),%ecx
80103b2c:	39 d9                	cmp    %ebx,%ecx
80103b2e:	75 e8                	jne    80103b18 <mycpu+0x28>
}
80103b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b33:	8d 82 a0 17 11 80    	lea    -0x7feee860(%edx),%eax
}
80103b39:	5b                   	pop    %ebx
80103b3a:	5e                   	pop    %esi
80103b3b:	5d                   	pop    %ebp
80103b3c:	c3                   	ret    
  panic("unknown apicid\n");
80103b3d:	83 ec 0c             	sub    $0xc,%esp
80103b40:	68 67 7a 10 80       	push   $0x80107a67
80103b45:	e8 46 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	68 44 7b 10 80       	push   $0x80107b44
80103b52:	e8 39 c8 ff ff       	call   80100390 <panic>
80103b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <cpuid>:
cpuid() {
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b6a:	e8 81 ff ff ff       	call   80103af0 <mycpu>
}
80103b6f:	c9                   	leave  
  return mycpu()-cpus;
80103b70:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103b75:	c1 f8 04             	sar    $0x4,%eax
80103b78:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b7e:	c3                   	ret    
80103b7f:	90                   	nop

80103b80 <myproc>:
myproc(void) {
80103b80:	f3 0f 1e fb          	endbr32 
80103b84:	55                   	push   %ebp
80103b85:	89 e5                	mov    %esp,%ebp
80103b87:	53                   	push   %ebx
80103b88:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b8b:	e8 30 0b 00 00       	call   801046c0 <pushcli>
  c = mycpu();
80103b90:	e8 5b ff ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103b95:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b9b:	e8 70 0b 00 00       	call   80104710 <popcli>
}
80103ba0:	89 d8                	mov    %ebx,%eax
80103ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ba5:	c9                   	leave  
80103ba6:	c3                   	ret    
80103ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bae:	66 90                	xchg   %ax,%ax

80103bb0 <userinit>:
{
80103bb0:	f3 0f 1e fb          	endbr32 
80103bb4:	55                   	push   %ebp
80103bb5:	89 e5                	mov    %esp,%ebp
80103bb7:	53                   	push   %ebx
80103bb8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bbb:	e8 f0 fd ff ff       	call   801039b0 <allocproc>
80103bc0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bc2:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103bc7:	e8 04 36 00 00       	call   801071d0 <setupkvm>
80103bcc:	89 43 04             	mov    %eax,0x4(%ebx)
80103bcf:	85 c0                	test   %eax,%eax
80103bd1:	0f 84 bd 00 00 00    	je     80103c94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bd7:	83 ec 04             	sub    $0x4,%esp
80103bda:	68 2c 00 00 00       	push   $0x2c
80103bdf:	68 60 a4 10 80       	push   $0x8010a460
80103be4:	50                   	push   %eax
80103be5:	e8 96 32 00 00       	call   80106e80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bed:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bf3:	6a 4c                	push   $0x4c
80103bf5:	6a 00                	push   $0x0
80103bf7:	ff 73 18             	push   0x18(%ebx)
80103bfa:	e8 01 0d 00 00       	call   80104900 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bff:	8b 43 18             	mov    0x18(%ebx),%eax
80103c02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c13:	8b 43 18             	mov    0x18(%ebx),%eax
80103c16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c25:	8b 43 18             	mov    0x18(%ebx),%eax
80103c28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c30:	8b 43 18             	mov    0x18(%ebx),%eax
80103c33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c44:	8b 43 18             	mov    0x18(%ebx),%eax
80103c47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c51:	6a 10                	push   $0x10
80103c53:	68 90 7a 10 80       	push   $0x80107a90
80103c58:	50                   	push   %eax
80103c59:	e8 62 0e 00 00       	call   80104ac0 <safestrcpy>
  p->cwd = namei("/");
80103c5e:	c7 04 24 99 7a 10 80 	movl   $0x80107a99,(%esp)
80103c65:	e8 b6 e5 ff ff       	call   80102220 <namei>
80103c6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c6d:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c74:	e8 b7 0b 00 00       	call   80104830 <acquire>
  p->state = RUNNABLE;
80103c79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c80:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c87:	e8 34 0b 00 00       	call   801047c0 <release>
}
80103c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c8f:	83 c4 10             	add    $0x10,%esp
80103c92:	c9                   	leave  
80103c93:	c3                   	ret    
    panic("userinit: out of memory?");
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	68 77 7a 10 80       	push   $0x80107a77
80103c9c:	e8 ef c6 ff ff       	call   80100390 <panic>
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103caf:	90                   	nop

80103cb0 <growproc>:
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	56                   	push   %esi
80103cb8:	53                   	push   %ebx
80103cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cbc:	e8 ff 09 00 00       	call   801046c0 <pushcli>
  c = mycpu();
80103cc1:	e8 2a fe ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103cc6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ccc:	e8 3f 0a 00 00       	call   80104710 <popcli>
  sz = curproc->sz;
80103cd1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cd3:	85 f6                	test   %esi,%esi
80103cd5:	7f 19                	jg     80103cf0 <growproc+0x40>
  } else if(n < 0){
80103cd7:	75 37                	jne    80103d10 <growproc+0x60>
  switchuvm(curproc);
80103cd9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cdc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cde:	53                   	push   %ebx
80103cdf:	e8 8c 30 00 00       	call   80106d70 <switchuvm>
  return 0;
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	31 c0                	xor    %eax,%eax
}
80103ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cec:	5b                   	pop    %ebx
80103ced:	5e                   	pop    %esi
80103cee:	5d                   	pop    %ebp
80103cef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 04             	push   0x4(%ebx)
80103cfa:	e8 f1 32 00 00       	call   80106ff0 <allocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 d3                	jne    80103cd9 <growproc+0x29>
      return -1;
80103d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d0b:	eb dc                	jmp    80103ce9 <growproc+0x39>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d10:	83 ec 04             	sub    $0x4,%esp
80103d13:	01 c6                	add    %eax,%esi
80103d15:	56                   	push   %esi
80103d16:	50                   	push   %eax
80103d17:	ff 73 04             	push   0x4(%ebx)
80103d1a:	e8 01 34 00 00       	call   80107120 <deallocuvm>
80103d1f:	83 c4 10             	add    $0x10,%esp
80103d22:	85 c0                	test   %eax,%eax
80103d24:	75 b3                	jne    80103cd9 <growproc+0x29>
80103d26:	eb de                	jmp    80103d06 <growproc+0x56>
80103d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop

80103d30 <fork>:
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	57                   	push   %edi
80103d38:	56                   	push   %esi
80103d39:	53                   	push   %ebx
80103d3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d3d:	e8 7e 09 00 00       	call   801046c0 <pushcli>
  c = mycpu();
80103d42:	e8 a9 fd ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103d47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d4d:	e8 be 09 00 00       	call   80104710 <popcli>
  if((np = allocproc()) == 0){
80103d52:	e8 59 fc ff ff       	call   801039b0 <allocproc>
80103d57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	0f 84 bb 00 00 00    	je     80103e1d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d62:	83 ec 08             	sub    $0x8,%esp
80103d65:	ff 33                	push   (%ebx)
80103d67:	89 c7                	mov    %eax,%edi
80103d69:	ff 73 04             	push   0x4(%ebx)
80103d6c:	e8 4f 35 00 00       	call   801072c0 <copyuvm>
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	89 47 04             	mov    %eax,0x4(%edi)
80103d77:	85 c0                	test   %eax,%eax
80103d79:	0f 84 a5 00 00 00    	je     80103e24 <fork+0xf4>
  np->sz = curproc->sz;
80103d7f:	8b 03                	mov    (%ebx),%eax
80103d81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d89:	89 c8                	mov    %ecx,%eax
80103d8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d93:	8b 73 18             	mov    0x18(%ebx),%esi
80103d96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d9a:	8b 40 18             	mov    0x18(%eax),%eax
80103d9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103da8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dac:	85 c0                	test   %eax,%eax
80103dae:	74 13                	je     80103dc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	50                   	push   %eax
80103db4:	e8 17 d2 ff ff       	call   80100fd0 <filedup>
80103db9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dc3:	83 c6 01             	add    $0x1,%esi
80103dc6:	83 fe 10             	cmp    $0x10,%esi
80103dc9:	75 dd                	jne    80103da8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103dcb:	83 ec 0c             	sub    $0xc,%esp
80103dce:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dd4:	e8 d7 da ff ff       	call   801018b0 <idup>
80103dd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ddc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ddf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103de5:	6a 10                	push   $0x10
80103de7:	53                   	push   %ebx
80103de8:	50                   	push   %eax
80103de9:	e8 d2 0c 00 00       	call   80104ac0 <safestrcpy>
  pid = np->pid;
80103dee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103df1:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103df8:	e8 33 0a 00 00       	call   80104830 <acquire>
  np->state = RUNNABLE;
80103dfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e04:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e0b:	e8 b0 09 00 00       	call   801047c0 <release>
  return pid;
80103e10:	83 c4 10             	add    $0x10,%esp
}
80103e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e16:	89 d8                	mov    %ebx,%eax
80103e18:	5b                   	pop    %ebx
80103e19:	5e                   	pop    %esi
80103e1a:	5f                   	pop    %edi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret    
    return -1;
80103e1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e22:	eb ef                	jmp    80103e13 <fork+0xe3>
    kfree(np->kstack);
80103e24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	ff 73 08             	push   0x8(%ebx)
80103e2d:	e8 2e e8 ff ff       	call   80102660 <kfree>
    np->kstack = 0;
80103e32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e48:	eb c9                	jmp    80103e13 <fork+0xe3>
80103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e50 <scheduler>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	57                   	push   %edi
80103e58:	56                   	push   %esi
80103e59:	53                   	push   %ebx
80103e5a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103e5d:	e8 8e fc ff ff       	call   80103af0 <mycpu>
  c->proc = 0;
80103e62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e69:	00 00 00 
  struct cpu *c = mycpu();
80103e6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e6e:	8d 78 04             	lea    0x4(%eax),%edi
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103e78:	fb                   	sti    
    acquire(&ptable.lock);
80103e79:	83 ec 0c             	sub    $0xc,%esp
    for(ran = 0, p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103e81:	68 20 1d 11 80       	push   $0x80111d20
80103e86:	e8 a5 09 00 00       	call   80104830 <acquire>
80103e8b:	83 c4 10             	add    $0x10,%esp
    for(ran = 0, p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8e:	31 c0                	xor    %eax,%eax
      if(p->state != RUNNABLE)
80103e90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e94:	75 38                	jne    80103ece <scheduler+0x7e>
      switchuvm(p);
80103e96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e9f:	53                   	push   %ebx
80103ea0:	e8 cb 2e 00 00       	call   80106d70 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ea5:	58                   	pop    %eax
80103ea6:	5a                   	pop    %edx
80103ea7:	ff 73 1c             	push   0x1c(%ebx)
80103eaa:	57                   	push   %edi
      p->state = RUNNING;
80103eab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103eb2:	e8 6c 0c 00 00       	call   80104b23 <swtch>
      switchkvm();
80103eb7:	e8 94 2e 00 00       	call   80106d50 <switchkvm>
      c->proc = 0;
80103ebc:	83 c4 10             	add    $0x10,%esp
      ran = 1;
80103ebf:	b8 01 00 00 00       	mov    $0x1,%eax
      c->proc = 0;
80103ec4:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ecb:	00 00 00 
    for(ran = 0, p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ece:	83 c3 7c             	add    $0x7c,%ebx
80103ed1:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103ed7:	75 b7                	jne    80103e90 <scheduler+0x40>
    release(&ptable.lock);
80103ed9:	83 ec 0c             	sub    $0xc,%esp
80103edc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103edf:	68 20 1d 11 80       	push   $0x80111d20
80103ee4:	e8 d7 08 00 00       	call   801047c0 <release>
    if (ran == 0)
80103ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103eec:	83 c4 10             	add    $0x10,%esp
80103eef:	85 c0                	test   %eax,%eax
80103ef1:	75 85                	jne    80103e78 <scheduler+0x28>
}

static inline void
halt()
{
	asm volatile("hlt" : : );
80103ef3:	f4                   	hlt    
}
80103ef4:	eb 82                	jmp    80103e78 <scheduler+0x28>
80103ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi

80103f00 <sched>:
{
80103f00:	f3 0f 1e fb          	endbr32 
80103f04:	55                   	push   %ebp
80103f05:	89 e5                	mov    %esp,%ebp
80103f07:	56                   	push   %esi
80103f08:	53                   	push   %ebx
  pushcli();
80103f09:	e8 b2 07 00 00       	call   801046c0 <pushcli>
  c = mycpu();
80103f0e:	e8 dd fb ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103f13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f19:	e8 f2 07 00 00       	call   80104710 <popcli>
  if(!holding(&ptable.lock))
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	68 20 1d 11 80       	push   $0x80111d20
80103f26:	e8 45 08 00 00       	call   80104770 <holding>
80103f2b:	83 c4 10             	add    $0x10,%esp
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	74 4f                	je     80103f81 <sched+0x81>
  if(mycpu()->ncli != 1)
80103f32:	e8 b9 fb ff ff       	call   80103af0 <mycpu>
80103f37:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f3e:	75 68                	jne    80103fa8 <sched+0xa8>
  if(p->state == RUNNING)
80103f40:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f44:	74 55                	je     80103f9b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f46:	9c                   	pushf  
80103f47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f48:	f6 c4 02             	test   $0x2,%ah
80103f4b:	75 41                	jne    80103f8e <sched+0x8e>
  intena = mycpu()->intena;
80103f4d:	e8 9e fb ff ff       	call   80103af0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f52:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f55:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f5b:	e8 90 fb ff ff       	call   80103af0 <mycpu>
80103f60:	83 ec 08             	sub    $0x8,%esp
80103f63:	ff 70 04             	push   0x4(%eax)
80103f66:	53                   	push   %ebx
80103f67:	e8 b7 0b 00 00       	call   80104b23 <swtch>
  mycpu()->intena = intena;
80103f6c:	e8 7f fb ff ff       	call   80103af0 <mycpu>
}
80103f71:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f74:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f7d:	5b                   	pop    %ebx
80103f7e:	5e                   	pop    %esi
80103f7f:	5d                   	pop    %ebp
80103f80:	c3                   	ret    
    panic("sched ptable.lock");
80103f81:	83 ec 0c             	sub    $0xc,%esp
80103f84:	68 9b 7a 10 80       	push   $0x80107a9b
80103f89:	e8 02 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	68 c7 7a 10 80       	push   $0x80107ac7
80103f96:	e8 f5 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f9b:	83 ec 0c             	sub    $0xc,%esp
80103f9e:	68 b9 7a 10 80       	push   $0x80107ab9
80103fa3:	e8 e8 c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103fa8:	83 ec 0c             	sub    $0xc,%esp
80103fab:	68 ad 7a 10 80       	push   $0x80107aad
80103fb0:	e8 db c3 ff ff       	call   80100390 <panic>
80103fb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fc0 <exit>:
{
80103fc0:	f3 0f 1e fb          	endbr32 
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
80103fc7:	57                   	push   %edi
80103fc8:	56                   	push   %esi
80103fc9:	53                   	push   %ebx
80103fca:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fcd:	e8 ae fb ff ff       	call   80103b80 <myproc>
  if(curproc == initproc)
80103fd2:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103fd8:	0f 84 f9 00 00 00    	je     801040d7 <exit+0x117>
80103fde:	89 c3                	mov    %eax,%ebx
80103fe0:	8d 70 28             	lea    0x28(%eax),%esi
80103fe3:	8d 78 68             	lea    0x68(%eax),%edi
80103fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fed:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ff0:	8b 06                	mov    (%esi),%eax
80103ff2:	85 c0                	test   %eax,%eax
80103ff4:	74 12                	je     80104008 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ff6:	83 ec 0c             	sub    $0xc,%esp
80103ff9:	50                   	push   %eax
80103ffa:	e8 21 d0 ff ff       	call   80101020 <fileclose>
      curproc->ofile[fd] = 0;
80103fff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104005:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104008:	83 c6 04             	add    $0x4,%esi
8010400b:	39 f7                	cmp    %esi,%edi
8010400d:	75 e1                	jne    80103ff0 <exit+0x30>
  begin_op();
8010400f:	e8 0c ef ff ff       	call   80102f20 <begin_op>
  iput(curproc->cwd);
80104014:	83 ec 0c             	sub    $0xc,%esp
80104017:	ff 73 68             	push   0x68(%ebx)
8010401a:	e8 f1 d9 ff ff       	call   80101a10 <iput>
  end_op();
8010401f:	e8 6c ef ff ff       	call   80102f90 <end_op>
  curproc->cwd = 0;
80104024:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010402b:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104032:	e8 f9 07 00 00       	call   80104830 <acquire>
  wakeup1(curproc->parent);
80104037:	8b 53 14             	mov    0x14(%ebx),%edx
8010403a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403d:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104042:	eb 0e                	jmp    80104052 <exit+0x92>
80104044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104048:	83 c0 7c             	add    $0x7c,%eax
8010404b:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104050:	74 1c                	je     8010406e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104052:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104056:	75 f0                	jne    80104048 <exit+0x88>
80104058:	3b 50 20             	cmp    0x20(%eax),%edx
8010405b:	75 eb                	jne    80104048 <exit+0x88>
      p->state = RUNNABLE;
8010405d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104064:	83 c0 7c             	add    $0x7c,%eax
80104067:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
8010406c:	75 e4                	jne    80104052 <exit+0x92>
      p->parent = initproc;
8010406e:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104074:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80104079:	eb 10                	jmp    8010408b <exit+0xcb>
8010407b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010407f:	90                   	nop
80104080:	83 c2 7c             	add    $0x7c,%edx
80104083:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80104089:	74 33                	je     801040be <exit+0xfe>
    if(p->parent == curproc){
8010408b:	39 5a 14             	cmp    %ebx,0x14(%edx)
8010408e:	75 f0                	jne    80104080 <exit+0xc0>
      if(p->state == ZOMBIE)
80104090:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104094:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104097:	75 e7                	jne    80104080 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104099:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010409e:	eb 0a                	jmp    801040aa <exit+0xea>
801040a0:	83 c0 7c             	add    $0x7c,%eax
801040a3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801040a8:	74 d6                	je     80104080 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801040aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ae:	75 f0                	jne    801040a0 <exit+0xe0>
801040b0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040b3:	75 eb                	jne    801040a0 <exit+0xe0>
      p->state = RUNNABLE;
801040b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040bc:	eb e2                	jmp    801040a0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040be:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040c5:	e8 36 fe ff ff       	call   80103f00 <sched>
  panic("zombie exit");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 e8 7a 10 80       	push   $0x80107ae8
801040d2:	e8 b9 c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 db 7a 10 80       	push   $0x80107adb
801040df:	e8 ac c2 ff ff       	call   80100390 <panic>
801040e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop

801040f0 <wait>:
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	56                   	push   %esi
801040f8:	53                   	push   %ebx
  pushcli();
801040f9:	e8 c2 05 00 00       	call   801046c0 <pushcli>
  c = mycpu();
801040fe:	e8 ed f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80104103:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104109:	e8 02 06 00 00       	call   80104710 <popcli>
  acquire(&ptable.lock);
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	68 20 1d 11 80       	push   $0x80111d20
80104116:	e8 15 07 00 00       	call   80104830 <acquire>
8010411b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104120:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104125:	eb 14                	jmp    8010413b <wait+0x4b>
80104127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412e:	66 90                	xchg   %ax,%ax
80104130:	83 c3 7c             	add    $0x7c,%ebx
80104133:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104139:	74 1b                	je     80104156 <wait+0x66>
      if(p->parent != curproc)
8010413b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010413e:	75 f0                	jne    80104130 <wait+0x40>
      if(p->state == ZOMBIE){
80104140:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104144:	74 5a                	je     801041a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104146:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104149:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414e:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104154:	75 e5                	jne    8010413b <wait+0x4b>
    if(!havekids || curproc->killed){
80104156:	85 c0                	test   %eax,%eax
80104158:	0f 84 98 00 00 00    	je     801041f6 <wait+0x106>
8010415e:	8b 46 24             	mov    0x24(%esi),%eax
80104161:	85 c0                	test   %eax,%eax
80104163:	0f 85 8d 00 00 00    	jne    801041f6 <wait+0x106>
  pushcli();
80104169:	e8 52 05 00 00       	call   801046c0 <pushcli>
  c = mycpu();
8010416e:	e8 7d f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80104173:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104179:	e8 92 05 00 00       	call   80104710 <popcli>
  if(p == 0)
8010417e:	85 db                	test   %ebx,%ebx
80104180:	0f 84 87 00 00 00    	je     8010420d <wait+0x11d>
  p->chan = chan;
80104186:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104189:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104190:	e8 6b fd ff ff       	call   80103f00 <sched>
  p->chan = 0;
80104195:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010419c:	eb 80                	jmp    8010411e <wait+0x2e>
8010419e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801041a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041a6:	ff 73 08             	push   0x8(%ebx)
801041a9:	e8 b2 e4 ff ff       	call   80102660 <kfree>
        p->kstack = 0;
801041ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041b5:	5a                   	pop    %edx
801041b6:	ff 73 04             	push   0x4(%ebx)
801041b9:	e8 92 2f 00 00       	call   80107150 <freevm>
        p->pid = 0;
801041be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041de:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041e5:	e8 d6 05 00 00       	call   801047c0 <release>
        return pid;
801041ea:	83 c4 10             	add    $0x10,%esp
}
801041ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041f0:	89 f0                	mov    %esi,%eax
801041f2:	5b                   	pop    %ebx
801041f3:	5e                   	pop    %esi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret    
      release(&ptable.lock);
801041f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041fe:	68 20 1d 11 80       	push   $0x80111d20
80104203:	e8 b8 05 00 00       	call   801047c0 <release>
      return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	eb e0                	jmp    801041ed <wait+0xfd>
    panic("sleep");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 f4 7a 10 80       	push   $0x80107af4
80104215:	e8 76 c1 ff ff       	call   80100390 <panic>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <yield>:
{
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	53                   	push   %ebx
80104228:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010422b:	68 20 1d 11 80       	push   $0x80111d20
80104230:	e8 fb 05 00 00       	call   80104830 <acquire>
  pushcli();
80104235:	e8 86 04 00 00       	call   801046c0 <pushcli>
  c = mycpu();
8010423a:	e8 b1 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
8010423f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104245:	e8 c6 04 00 00       	call   80104710 <popcli>
  myproc()->state = RUNNABLE;
8010424a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104251:	e8 aa fc ff ff       	call   80103f00 <sched>
  release(&ptable.lock);
80104256:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010425d:	e8 5e 05 00 00       	call   801047c0 <release>
}
80104262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	c9                   	leave  
80104269:	c3                   	ret    
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104270 <sleep>:
{
80104270:	f3 0f 1e fb          	endbr32 
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	57                   	push   %edi
80104278:	56                   	push   %esi
80104279:	53                   	push   %ebx
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104280:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104283:	e8 38 04 00 00       	call   801046c0 <pushcli>
  c = mycpu();
80104288:	e8 63 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
8010428d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104293:	e8 78 04 00 00       	call   80104710 <popcli>
  if(p == 0)
80104298:	85 db                	test   %ebx,%ebx
8010429a:	0f 84 83 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
801042a0:	85 f6                	test   %esi,%esi
801042a2:	74 72                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a4:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801042aa:	74 4c                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042ac:	83 ec 0c             	sub    $0xc,%esp
801042af:	68 20 1d 11 80       	push   $0x80111d20
801042b4:	e8 77 05 00 00       	call   80104830 <acquire>
    release(lk);
801042b9:	89 34 24             	mov    %esi,(%esp)
801042bc:	e8 ff 04 00 00       	call   801047c0 <release>
  p->chan = chan;
801042c1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042c4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042cb:	e8 30 fc ff ff       	call   80103f00 <sched>
  p->chan = 0;
801042d0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042d7:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801042de:	e8 dd 04 00 00       	call   801047c0 <release>
    acquire(lk);
801042e3:	89 75 08             	mov    %esi,0x8(%ebp)
801042e6:	83 c4 10             	add    $0x10,%esp
}
801042e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ec:	5b                   	pop    %ebx
801042ed:	5e                   	pop    %esi
801042ee:	5f                   	pop    %edi
801042ef:	5d                   	pop    %ebp
    acquire(lk);
801042f0:	e9 3b 05 00 00       	jmp    80104830 <acquire>
801042f5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801042f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104302:	e8 f9 fb ff ff       	call   80103f00 <sched>
  p->chan = 0;
80104307:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 fa 7a 10 80       	push   $0x80107afa
8010431e:	e8 6d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 f4 7a 10 80       	push   $0x80107af4
8010432b:	e8 60 c0 ff ff       	call   80100390 <panic>

80104330 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	53                   	push   %ebx
80104338:	83 ec 10             	sub    $0x10,%esp
8010433b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433e:	68 20 1d 11 80       	push   $0x80111d20
80104343:	e8 e8 04 00 00       	call   80104830 <acquire>
80104348:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010434b:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104350:	eb 10                	jmp    80104362 <wakeup+0x32>
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104358:	83 c0 7c             	add    $0x7c,%eax
8010435b:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104360:	74 1c                	je     8010437e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104362:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104366:	75 f0                	jne    80104358 <wakeup+0x28>
80104368:	3b 58 20             	cmp    0x20(%eax),%ebx
8010436b:	75 eb                	jne    80104358 <wakeup+0x28>
      p->state = RUNNABLE;
8010436d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104374:	83 c0 7c             	add    $0x7c,%eax
80104377:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
8010437c:	75 e4                	jne    80104362 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010437e:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80104385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104388:	c9                   	leave  
  release(&ptable.lock);
80104389:	e9 32 04 00 00       	jmp    801047c0 <release>
8010438e:	66 90                	xchg   %ax,%ax

80104390 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	53                   	push   %ebx
80104398:	83 ec 10             	sub    $0x10,%esp
8010439b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439e:	68 20 1d 11 80       	push   $0x80111d20
801043a3:	e8 88 04 00 00       	call   80104830 <acquire>
801043a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ab:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801043b0:	eb 10                	jmp    801043c2 <kill+0x32>
801043b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043b8:	83 c0 7c             	add    $0x7c,%eax
801043bb:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801043c0:	74 36                	je     801043f8 <kill+0x68>
    if(p->pid == pid){
801043c2:	39 58 10             	cmp    %ebx,0x10(%eax)
801043c5:	75 f1                	jne    801043b8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043c7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043cb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043d2:	75 07                	jne    801043db <kill+0x4b>
        p->state = RUNNABLE;
801043d4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043db:	83 ec 0c             	sub    $0xc,%esp
801043de:	68 20 1d 11 80       	push   $0x80111d20
801043e3:	e8 d8 03 00 00       	call   801047c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043eb:	83 c4 10             	add    $0x10,%esp
801043ee:	31 c0                	xor    %eax,%eax
}
801043f0:	c9                   	leave  
801043f1:	c3                   	ret    
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 20 1d 11 80       	push   $0x80111d20
80104400:	e8 bb 03 00 00       	call   801047c0 <release>
}
80104405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104408:	83 c4 10             	add    $0x10,%esp
8010440b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104410:	c9                   	leave  
80104411:	c3                   	ret    
80104412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104420 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	57                   	push   %edi
80104428:	56                   	push   %esi
80104429:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010442c:	53                   	push   %ebx
8010442d:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
80104432:	83 ec 3c             	sub    $0x3c,%esp
80104435:	eb 28                	jmp    8010445f <procdump+0x3f>
80104437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 77 7e 10 80       	push   $0x80107e77
80104448:	e8 43 c2 ff ff       	call   80100690 <cprintf>
8010444d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104450:	83 c3 7c             	add    $0x7c,%ebx
80104453:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104459:	0f 84 81 00 00 00    	je     801044e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010445f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104462:	85 c0                	test   %eax,%eax
80104464:	74 ea                	je     80104450 <procdump+0x30>
      state = "???";
80104466:	ba 0b 7b 10 80       	mov    $0x80107b0b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010446b:	83 f8 05             	cmp    $0x5,%eax
8010446e:	77 11                	ja     80104481 <procdump+0x61>
80104470:	8b 14 85 6c 7b 10 80 	mov    -0x7fef8494(,%eax,4),%edx
      state = "???";
80104477:	b8 0b 7b 10 80       	mov    $0x80107b0b,%eax
8010447c:	85 d2                	test   %edx,%edx
8010447e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104481:	53                   	push   %ebx
80104482:	52                   	push   %edx
80104483:	ff 73 a4             	push   -0x5c(%ebx)
80104486:	68 0f 7b 10 80       	push   $0x80107b0f
8010448b:	e8 00 c2 ff ff       	call   80100690 <cprintf>
    if(p->state == SLEEPING){
80104490:	83 c4 10             	add    $0x10,%esp
80104493:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104497:	75 a7                	jne    80104440 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104499:	83 ec 08             	sub    $0x8,%esp
8010449c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010449f:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044a2:	50                   	push   %eax
801044a3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044a6:	8b 40 0c             	mov    0xc(%eax),%eax
801044a9:	83 c0 08             	add    $0x8,%eax
801044ac:	50                   	push   %eax
801044ad:	e8 9e 01 00 00       	call   80104650 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b2:	83 c4 10             	add    $0x10,%esp
801044b5:	8d 76 00             	lea    0x0(%esi),%esi
801044b8:	8b 17                	mov    (%edi),%edx
801044ba:	85 d2                	test   %edx,%edx
801044bc:	74 82                	je     80104440 <procdump+0x20>
        cprintf(" %p", pc[i]);
801044be:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044c1:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044c4:	52                   	push   %edx
801044c5:	68 61 75 10 80       	push   $0x80107561
801044ca:	e8 c1 c1 ff ff       	call   80100690 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044cf:	83 c4 10             	add    $0x10,%esp
801044d2:	39 fe                	cmp    %edi,%esi
801044d4:	75 e2                	jne    801044b8 <procdump+0x98>
801044d6:	e9 65 ff ff ff       	jmp    80104440 <procdump+0x20>
801044db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044df:	90                   	nop
  }
}
801044e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e3:	5b                   	pop    %ebx
801044e4:	5e                   	pop    %esi
801044e5:	5f                   	pop    %edi
801044e6:	5d                   	pop    %ebp
801044e7:	c3                   	ret    
801044e8:	66 90                	xchg   %ax,%ax
801044ea:	66 90                	xchg   %ax,%ax
801044ec:	66 90                	xchg   %ax,%ax
801044ee:	66 90                	xchg   %ax,%ax

801044f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044f0:	f3 0f 1e fb          	endbr32 
801044f4:	55                   	push   %ebp
801044f5:	89 e5                	mov    %esp,%ebp
801044f7:	53                   	push   %ebx
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044fe:	68 84 7b 10 80       	push   $0x80107b84
80104503:	8d 43 04             	lea    0x4(%ebx),%eax
80104506:	50                   	push   %eax
80104507:	e8 24 01 00 00       	call   80104630 <initlock>
  lk->name = name;
8010450c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010450f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104515:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104518:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010451f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104525:	c9                   	leave  
80104526:	c3                   	ret    
80104527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452e:	66 90                	xchg   %ax,%ax

80104530 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	56                   	push   %esi
80104538:	53                   	push   %ebx
80104539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010453c:	8d 73 04             	lea    0x4(%ebx),%esi
8010453f:	83 ec 0c             	sub    $0xc,%esp
80104542:	56                   	push   %esi
80104543:	e8 e8 02 00 00       	call   80104830 <acquire>
  while (lk->locked) {
80104548:	8b 13                	mov    (%ebx),%edx
8010454a:	83 c4 10             	add    $0x10,%esp
8010454d:	85 d2                	test   %edx,%edx
8010454f:	74 1a                	je     8010456b <acquiresleep+0x3b>
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104558:	83 ec 08             	sub    $0x8,%esp
8010455b:	56                   	push   %esi
8010455c:	53                   	push   %ebx
8010455d:	e8 0e fd ff ff       	call   80104270 <sleep>
  while (lk->locked) {
80104562:	8b 03                	mov    (%ebx),%eax
80104564:	83 c4 10             	add    $0x10,%esp
80104567:	85 c0                	test   %eax,%eax
80104569:	75 ed                	jne    80104558 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010456b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104571:	e8 0a f6 ff ff       	call   80103b80 <myproc>
80104576:	8b 40 10             	mov    0x10(%eax),%eax
80104579:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010457c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010457f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104582:	5b                   	pop    %ebx
80104583:	5e                   	pop    %esi
80104584:	5d                   	pop    %ebp
  release(&lk->lk);
80104585:	e9 36 02 00 00       	jmp    801047c0 <release>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	56                   	push   %esi
80104598:	53                   	push   %ebx
80104599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010459c:	8d 73 04             	lea    0x4(%ebx),%esi
8010459f:	83 ec 0c             	sub    $0xc,%esp
801045a2:	56                   	push   %esi
801045a3:	e8 88 02 00 00       	call   80104830 <acquire>
  lk->locked = 0;
801045a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045ae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045b5:	89 1c 24             	mov    %ebx,(%esp)
801045b8:	e8 73 fd ff ff       	call   80104330 <wakeup>
  release(&lk->lk);
801045bd:	89 75 08             	mov    %esi,0x8(%ebp)
801045c0:	83 c4 10             	add    $0x10,%esp
}
801045c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c6:	5b                   	pop    %ebx
801045c7:	5e                   	pop    %esi
801045c8:	5d                   	pop    %ebp
  release(&lk->lk);
801045c9:	e9 f2 01 00 00       	jmp    801047c0 <release>
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	57                   	push   %edi
801045d8:	31 ff                	xor    %edi,%edi
801045da:	56                   	push   %esi
801045db:	53                   	push   %ebx
801045dc:	83 ec 18             	sub    $0x18,%esp
801045df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045e2:	8d 73 04             	lea    0x4(%ebx),%esi
801045e5:	56                   	push   %esi
801045e6:	e8 45 02 00 00       	call   80104830 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045eb:	8b 03                	mov    (%ebx),%eax
801045ed:	83 c4 10             	add    $0x10,%esp
801045f0:	85 c0                	test   %eax,%eax
801045f2:	75 1c                	jne    80104610 <holdingsleep+0x40>
  release(&lk->lk);
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	56                   	push   %esi
801045f8:	e8 c3 01 00 00       	call   801047c0 <release>
  return r;
}
801045fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104600:	89 f8                	mov    %edi,%eax
80104602:	5b                   	pop    %ebx
80104603:	5e                   	pop    %esi
80104604:	5f                   	pop    %edi
80104605:	5d                   	pop    %ebp
80104606:	c3                   	ret    
80104607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104610:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104613:	e8 68 f5 ff ff       	call   80103b80 <myproc>
80104618:	39 58 10             	cmp    %ebx,0x10(%eax)
8010461b:	0f 94 c0             	sete   %al
8010461e:	0f b6 c0             	movzbl %al,%eax
80104621:	89 c7                	mov    %eax,%edi
80104623:	eb cf                	jmp    801045f4 <holdingsleep+0x24>
80104625:	66 90                	xchg   %ax,%ax
80104627:	66 90                	xchg   %ax,%ax
80104629:	66 90                	xchg   %ax,%ax
8010462b:	66 90                	xchg   %ax,%ax
8010462d:	66 90                	xchg   %ax,%ax
8010462f:	90                   	nop

80104630 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010463a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010463d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104643:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104646:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010464d:	5d                   	pop    %ebp
8010464e:	c3                   	ret    
8010464f:	90                   	nop

80104650 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104655:	31 d2                	xor    %edx,%edx
{
80104657:	89 e5                	mov    %esp,%ebp
80104659:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010465a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010465d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104660:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104667:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104668:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010466e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104674:	77 1a                	ja     80104690 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104676:	8b 58 04             	mov    0x4(%eax),%ebx
80104679:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010467c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010467f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104681:	83 fa 0a             	cmp    $0xa,%edx
80104684:	75 e2                	jne    80104668 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104689:	c9                   	leave  
8010468a:	c3                   	ret    
8010468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop
  for(; i < 10; i++)
80104690:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104693:	8d 51 28             	lea    0x28(%ecx),%edx
80104696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801046a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046a6:	83 c0 04             	add    $0x4,%eax
801046a9:	39 d0                	cmp    %edx,%eax
801046ab:	75 f3                	jne    801046a0 <getcallerpcs+0x50>
}
801046ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	53                   	push   %ebx
801046c8:	83 ec 04             	sub    $0x4,%esp
801046cb:	9c                   	pushf  
801046cc:	5b                   	pop    %ebx
  asm volatile("cli");
801046cd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046ce:	e8 1d f4 ff ff       	call   80103af0 <mycpu>
801046d3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046d9:	85 c0                	test   %eax,%eax
801046db:	74 13                	je     801046f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046dd:	e8 0e f4 ff ff       	call   80103af0 <mycpu>
801046e2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ec:	c9                   	leave  
801046ed:	c3                   	ret    
801046ee:	66 90                	xchg   %ax,%ax
    mycpu()->intena = eflags & FL_IF;
801046f0:	e8 fb f3 ff ff       	call   80103af0 <mycpu>
801046f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104701:	eb da                	jmp    801046dd <pushcli+0x1d>
80104703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <popcli>:

void
popcli(void)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010471a:	9c                   	pushf  
8010471b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010471c:	f6 c4 02             	test   $0x2,%ah
8010471f:	75 31                	jne    80104752 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104721:	e8 ca f3 ff ff       	call   80103af0 <mycpu>
80104726:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010472d:	78 30                	js     8010475f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010472f:	e8 bc f3 ff ff       	call   80103af0 <mycpu>
80104734:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010473a:	85 d2                	test   %edx,%edx
8010473c:	74 02                	je     80104740 <popcli+0x30>
    sti();
}
8010473e:	c9                   	leave  
8010473f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104740:	e8 ab f3 ff ff       	call   80103af0 <mycpu>
80104745:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010474b:	85 c0                	test   %eax,%eax
8010474d:	74 ef                	je     8010473e <popcli+0x2e>
  asm volatile("sti");
8010474f:	fb                   	sti    
}
80104750:	c9                   	leave  
80104751:	c3                   	ret    
    panic("popcli - interruptible");
80104752:	83 ec 0c             	sub    $0xc,%esp
80104755:	68 8f 7b 10 80       	push   $0x80107b8f
8010475a:	e8 31 bc ff ff       	call   80100390 <panic>
    panic("popcli");
8010475f:	83 ec 0c             	sub    $0xc,%esp
80104762:	68 a6 7b 10 80       	push   $0x80107ba6
80104767:	e8 24 bc ff ff       	call   80100390 <panic>
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <holding>:
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	56                   	push   %esi
80104778:	53                   	push   %ebx
80104779:	8b 75 08             	mov    0x8(%ebp),%esi
8010477c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010477e:	e8 3d ff ff ff       	call   801046c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104783:	8b 06                	mov    (%esi),%eax
80104785:	85 c0                	test   %eax,%eax
80104787:	75 0f                	jne    80104798 <holding+0x28>
  popcli();
80104789:	e8 82 ff ff ff       	call   80104710 <popcli>
}
8010478e:	89 d8                	mov    %ebx,%eax
80104790:	5b                   	pop    %ebx
80104791:	5e                   	pop    %esi
80104792:	5d                   	pop    %ebp
80104793:	c3                   	ret    
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104798:	8b 5e 08             	mov    0x8(%esi),%ebx
8010479b:	e8 50 f3 ff ff       	call   80103af0 <mycpu>
801047a0:	39 c3                	cmp    %eax,%ebx
801047a2:	0f 94 c3             	sete   %bl
  popcli();
801047a5:	e8 66 ff ff ff       	call   80104710 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047aa:	0f b6 db             	movzbl %bl,%ebx
}
801047ad:	89 d8                	mov    %ebx,%eax
801047af:	5b                   	pop    %ebx
801047b0:	5e                   	pop    %esi
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret    
801047b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <release>:
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	56                   	push   %esi
801047c8:	53                   	push   %ebx
801047c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047cc:	e8 ef fe ff ff       	call   801046c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047d1:	8b 03                	mov    (%ebx),%eax
801047d3:	85 c0                	test   %eax,%eax
801047d5:	75 19                	jne    801047f0 <release+0x30>
  popcli();
801047d7:	e8 34 ff ff ff       	call   80104710 <popcli>
    panic("release");
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	68 ad 7b 10 80       	push   $0x80107bad
801047e4:	e8 a7 bb ff ff       	call   80100390 <panic>
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801047f0:	8b 73 08             	mov    0x8(%ebx),%esi
801047f3:	e8 f8 f2 ff ff       	call   80103af0 <mycpu>
801047f8:	39 c6                	cmp    %eax,%esi
801047fa:	75 db                	jne    801047d7 <release+0x17>
  popcli();
801047fc:	e8 0f ff ff ff       	call   80104710 <popcli>
  lk->pcs[0] = 0;
80104801:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104808:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010480f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104814:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010481a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010481d:	5b                   	pop    %ebx
8010481e:	5e                   	pop    %esi
8010481f:	5d                   	pop    %ebp
  popcli();
80104820:	e9 eb fe ff ff       	jmp    80104710 <popcli>
80104825:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <acquire>:
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	53                   	push   %ebx
80104838:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010483b:	e8 80 fe ff ff       	call   801046c0 <pushcli>
  if(holding(lk))
80104840:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104843:	e8 78 fe ff ff       	call   801046c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104848:	8b 03                	mov    (%ebx),%eax
8010484a:	85 c0                	test   %eax,%eax
8010484c:	0f 85 86 00 00 00    	jne    801048d8 <acquire+0xa8>
  popcli();
80104852:	e8 b9 fe ff ff       	call   80104710 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104857:	b9 01 00 00 00       	mov    $0x1,%ecx
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104860:	8b 55 08             	mov    0x8(%ebp),%edx
80104863:	89 c8                	mov    %ecx,%eax
80104865:	f0 87 02             	lock xchg %eax,(%edx)
80104868:	85 c0                	test   %eax,%eax
8010486a:	75 f4                	jne    80104860 <acquire+0x30>
  __sync_synchronize();
8010486c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104871:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104874:	e8 77 f2 ff ff       	call   80103af0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
8010487c:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
8010487e:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104881:	31 c0                	xor    %eax,%eax
80104883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104887:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104888:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010488e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104894:	77 1a                	ja     801048b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104896:	8b 5a 04             	mov    0x4(%edx),%ebx
80104899:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
8010489d:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048a0:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048a2:	83 f8 0a             	cmp    $0xa,%eax
801048a5:	75 e1                	jne    80104888 <acquire+0x58>
}
801048a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048aa:	c9                   	leave  
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048b0:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048b4:	8d 51 34             	lea    0x34(%ecx),%edx
801048b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801048c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048c6:	83 c0 04             	add    $0x4,%eax
801048c9:	39 c2                	cmp    %eax,%edx
801048cb:	75 f3                	jne    801048c0 <acquire+0x90>
}
801048cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d0:	c9                   	leave  
801048d1:	c3                   	ret    
801048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048db:	e8 10 f2 ff ff       	call   80103af0 <mycpu>
801048e0:	39 c3                	cmp    %eax,%ebx
801048e2:	0f 85 6a ff ff ff    	jne    80104852 <acquire+0x22>
  popcli();
801048e8:	e8 23 fe ff ff       	call   80104710 <popcli>
    panic("acquire");
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	68 b5 7b 10 80       	push   $0x80107bb5
801048f5:	e8 96 ba ff ff       	call   80100390 <panic>
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	57                   	push   %edi
80104908:	8b 55 08             	mov    0x8(%ebp),%edx
8010490b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010490e:	53                   	push   %ebx
8010490f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104912:	89 d7                	mov    %edx,%edi
80104914:	09 cf                	or     %ecx,%edi
80104916:	83 e7 03             	and    $0x3,%edi
80104919:	75 25                	jne    80104940 <memset+0x40>
    c &= 0xFF;
8010491b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010491e:	c1 e0 18             	shl    $0x18,%eax
80104921:	89 fb                	mov    %edi,%ebx
80104923:	c1 e9 02             	shr    $0x2,%ecx
80104926:	c1 e3 10             	shl    $0x10,%ebx
80104929:	09 d8                	or     %ebx,%eax
8010492b:	09 f8                	or     %edi,%eax
8010492d:	c1 e7 08             	shl    $0x8,%edi
80104930:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104932:	89 d7                	mov    %edx,%edi
80104934:	fc                   	cld    
80104935:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104937:	5b                   	pop    %ebx
80104938:	89 d0                	mov    %edx,%eax
8010493a:	5f                   	pop    %edi
8010493b:	5d                   	pop    %ebp
8010493c:	c3                   	ret    
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104940:	89 d7                	mov    %edx,%edi
80104942:	fc                   	cld    
80104943:	f3 aa                	rep stos %al,%es:(%edi)
80104945:	5b                   	pop    %ebx
80104946:	89 d0                	mov    %edx,%eax
80104948:	5f                   	pop    %edi
80104949:	5d                   	pop    %ebp
8010494a:	c3                   	ret    
8010494b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop

80104950 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	56                   	push   %esi
80104958:	8b 75 10             	mov    0x10(%ebp),%esi
8010495b:	8b 55 08             	mov    0x8(%ebp),%edx
8010495e:	53                   	push   %ebx
8010495f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104962:	85 f6                	test   %esi,%esi
80104964:	74 2a                	je     80104990 <memcmp+0x40>
80104966:	01 c6                	add    %eax,%esi
80104968:	eb 10                	jmp    8010497a <memcmp+0x2a>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104970:	83 c0 01             	add    $0x1,%eax
80104973:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104976:	39 f0                	cmp    %esi,%eax
80104978:	74 16                	je     80104990 <memcmp+0x40>
    if(*s1 != *s2)
8010497a:	0f b6 0a             	movzbl (%edx),%ecx
8010497d:	0f b6 18             	movzbl (%eax),%ebx
80104980:	38 d9                	cmp    %bl,%cl
80104982:	74 ec                	je     80104970 <memcmp+0x20>
      return *s1 - *s2;
80104984:	0f b6 c1             	movzbl %cl,%eax
80104987:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	5b                   	pop    %ebx
  return 0;
80104991:	31 c0                	xor    %eax,%eax
}
80104993:	5e                   	pop    %esi
80104994:	5d                   	pop    %ebp
80104995:	c3                   	ret    
80104996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499d:	8d 76 00             	lea    0x0(%esi),%esi

801049a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	57                   	push   %edi
801049a8:	8b 55 08             	mov    0x8(%ebp),%edx
801049ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ae:	56                   	push   %esi
801049af:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049b2:	39 d6                	cmp    %edx,%esi
801049b4:	73 2a                	jae    801049e0 <memmove+0x40>
801049b6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049b9:	39 fa                	cmp    %edi,%edx
801049bb:	73 23                	jae    801049e0 <memmove+0x40>
801049bd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801049c0:	85 c9                	test   %ecx,%ecx
801049c2:	74 10                	je     801049d4 <memmove+0x34>
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801049c8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049cc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801049cf:	83 e8 01             	sub    $0x1,%eax
801049d2:	73 f4                	jae    801049c8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049d4:	5e                   	pop    %esi
801049d5:	89 d0                	mov    %edx,%eax
801049d7:	5f                   	pop    %edi
801049d8:	5d                   	pop    %ebp
801049d9:	c3                   	ret    
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049e0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049e3:	89 d7                	mov    %edx,%edi
801049e5:	85 c9                	test   %ecx,%ecx
801049e7:	74 eb                	je     801049d4 <memmove+0x34>
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801049f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801049f1:	39 c6                	cmp    %eax,%esi
801049f3:	75 fb                	jne    801049f0 <memmove+0x50>
}
801049f5:	5e                   	pop    %esi
801049f6:	89 d0                	mov    %edx,%eax
801049f8:	5f                   	pop    %edi
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049ff:	90                   	nop

80104a00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a00:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104a04:	eb 9a                	jmp    801049a0 <memmove>
80104a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	56                   	push   %esi
80104a18:	8b 75 10             	mov    0x10(%ebp),%esi
80104a1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a1e:	53                   	push   %ebx
80104a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104a22:	85 f6                	test   %esi,%esi
80104a24:	74 32                	je     80104a58 <strncmp+0x48>
80104a26:	01 c6                	add    %eax,%esi
80104a28:	eb 14                	jmp    80104a3e <strncmp+0x2e>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a30:	38 da                	cmp    %bl,%dl
80104a32:	75 14                	jne    80104a48 <strncmp+0x38>
    n--, p++, q++;
80104a34:	83 c0 01             	add    $0x1,%eax
80104a37:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a3a:	39 f0                	cmp    %esi,%eax
80104a3c:	74 1a                	je     80104a58 <strncmp+0x48>
80104a3e:	0f b6 11             	movzbl (%ecx),%edx
80104a41:	0f b6 18             	movzbl (%eax),%ebx
80104a44:	84 d2                	test   %dl,%dl
80104a46:	75 e8                	jne    80104a30 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a48:	0f b6 c2             	movzbl %dl,%eax
80104a4b:	29 d8                	sub    %ebx,%eax
}
80104a4d:	5b                   	pop    %ebx
80104a4e:	5e                   	pop    %esi
80104a4f:	5d                   	pop    %ebp
80104a50:	c3                   	ret    
80104a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a58:	5b                   	pop    %ebx
    return 0;
80104a59:	31 c0                	xor    %eax,%eax
}
80104a5b:	5e                   	pop    %esi
80104a5c:	5d                   	pop    %ebp
80104a5d:	c3                   	ret    
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	57                   	push   %edi
80104a68:	56                   	push   %esi
80104a69:	8b 75 08             	mov    0x8(%ebp),%esi
80104a6c:	53                   	push   %ebx
80104a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a70:	89 f2                	mov    %esi,%edx
80104a72:	eb 1b                	jmp    80104a8f <strncpy+0x2f>
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a78:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a7f:	83 c2 01             	add    $0x1,%edx
80104a82:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104a86:	89 f9                	mov    %edi,%ecx
80104a88:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a8b:	84 c9                	test   %cl,%cl
80104a8d:	74 09                	je     80104a98 <strncpy+0x38>
80104a8f:	89 c3                	mov    %eax,%ebx
80104a91:	83 e8 01             	sub    $0x1,%eax
80104a94:	85 db                	test   %ebx,%ebx
80104a96:	7f e0                	jg     80104a78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a98:	89 d1                	mov    %edx,%ecx
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	7e 15                	jle    80104ab3 <strncpy+0x53>
80104a9e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104aa0:	83 c1 01             	add    $0x1,%ecx
80104aa3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104aa7:	89 c8                	mov    %ecx,%eax
80104aa9:	f7 d0                	not    %eax
80104aab:	01 d0                	add    %edx,%eax
80104aad:	01 d8                	add    %ebx,%eax
80104aaf:	85 c0                	test   %eax,%eax
80104ab1:	7f ed                	jg     80104aa0 <strncpy+0x40>
  return os;
}
80104ab3:	5b                   	pop    %ebx
80104ab4:	89 f0                	mov    %esi,%eax
80104ab6:	5e                   	pop    %esi
80104ab7:	5f                   	pop    %edi
80104ab8:	5d                   	pop    %ebp
80104ab9:	c3                   	ret    
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	8b 55 10             	mov    0x10(%ebp),%edx
80104acb:	8b 75 08             	mov    0x8(%ebp),%esi
80104ace:	53                   	push   %ebx
80104acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ad2:	85 d2                	test   %edx,%edx
80104ad4:	7e 21                	jle    80104af7 <safestrcpy+0x37>
80104ad6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ada:	89 f2                	mov    %esi,%edx
80104adc:	eb 12                	jmp    80104af0 <safestrcpy+0x30>
80104ade:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ae0:	0f b6 08             	movzbl (%eax),%ecx
80104ae3:	83 c0 01             	add    $0x1,%eax
80104ae6:	83 c2 01             	add    $0x1,%edx
80104ae9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104aec:	84 c9                	test   %cl,%cl
80104aee:	74 04                	je     80104af4 <safestrcpy+0x34>
80104af0:	39 d8                	cmp    %ebx,%eax
80104af2:	75 ec                	jne    80104ae0 <safestrcpy+0x20>
    ;
  *s = 0;
80104af4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104af7:	89 f0                	mov    %esi,%eax
80104af9:	5b                   	pop    %ebx
80104afa:	5e                   	pop    %esi
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <strlen>:

int
strlen(const char *s)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b05:	31 c0                	xor    %eax,%eax
{
80104b07:	89 e5                	mov    %esp,%ebp
80104b09:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b0c:	80 3a 00             	cmpb   $0x0,(%edx)
80104b0f:	74 10                	je     80104b21 <strlen+0x21>
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	83 c0 01             	add    $0x1,%eax
80104b1b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b1f:	75 f7                	jne    80104b18 <strlen+0x18>
    ;
  return n;
}
80104b21:	5d                   	pop    %ebp
80104b22:	c3                   	ret    

80104b23 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b23:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b27:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b2b:	55                   	push   %ebp
  pushl %ebx
80104b2c:	53                   	push   %ebx
  pushl %esi
80104b2d:	56                   	push   %esi
  pushl %edi
80104b2e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b2f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b31:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b33:	5f                   	pop    %edi
  popl %esi
80104b34:	5e                   	pop    %esi
  popl %ebx
80104b35:	5b                   	pop    %ebx
  popl %ebp
80104b36:	5d                   	pop    %ebp
  ret
80104b37:	c3                   	ret    
80104b38:	66 90                	xchg   %ax,%ax
80104b3a:	66 90                	xchg   %ax,%ax
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	53                   	push   %ebx
80104b48:	83 ec 04             	sub    $0x4,%esp
80104b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b4e:	e8 2d f0 ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b53:	8b 00                	mov    (%eax),%eax
80104b55:	39 d8                	cmp    %ebx,%eax
80104b57:	76 17                	jbe    80104b70 <fetchint+0x30>
80104b59:	8d 53 04             	lea    0x4(%ebx),%edx
80104b5c:	39 d0                	cmp    %edx,%eax
80104b5e:	72 10                	jb     80104b70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b60:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b63:	8b 13                	mov    (%ebx),%edx
80104b65:	89 10                	mov    %edx,(%eax)
  return 0;
80104b67:	31 c0                	xor    %eax,%eax
}
80104b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b6c:	c9                   	leave  
80104b6d:	c3                   	ret    
80104b6e:	66 90                	xchg   %ax,%ax
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b75:	eb f2                	jmp    80104b69 <fetchint+0x29>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 04             	sub    $0x4,%esp
80104b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b8e:	e8 ed ef ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz)
80104b93:	39 18                	cmp    %ebx,(%eax)
80104b95:	76 31                	jbe    80104bc8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104b97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b9e:	39 d3                	cmp    %edx,%ebx
80104ba0:	73 26                	jae    80104bc8 <fetchstr+0x48>
80104ba2:	89 d8                	mov    %ebx,%eax
80104ba4:	eb 11                	jmp    80104bb7 <fetchstr+0x37>
80104ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	83 c0 01             	add    $0x1,%eax
80104bb3:	39 c2                	cmp    %eax,%edx
80104bb5:	76 11                	jbe    80104bc8 <fetchstr+0x48>
    if(*s == 0)
80104bb7:	80 38 00             	cmpb   $0x0,(%eax)
80104bba:	75 f4                	jne    80104bb0 <fetchstr+0x30>
      return s - *pp;
80104bbc:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc1:	c9                   	leave  
80104bc2:	c3                   	ret    
80104bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc7:	90                   	nop
80104bc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd0:	c9                   	leave  
80104bd1:	c3                   	ret    
80104bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104be0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	56                   	push   %esi
80104be8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be9:	e8 92 ef ff ff       	call   80103b80 <myproc>
80104bee:	8b 55 08             	mov    0x8(%ebp),%edx
80104bf1:	8b 40 18             	mov    0x18(%eax),%eax
80104bf4:	8b 40 44             	mov    0x44(%eax),%eax
80104bf7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bfa:	e8 81 ef ff ff       	call   80103b80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c02:	8b 00                	mov    (%eax),%eax
80104c04:	39 c6                	cmp    %eax,%esi
80104c06:	73 18                	jae    80104c20 <argint+0x40>
80104c08:	8d 53 08             	lea    0x8(%ebx),%edx
80104c0b:	39 d0                	cmp    %edx,%eax
80104c0d:	72 11                	jb     80104c20 <argint+0x40>
  *ip = *(int*)(addr);
80104c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c12:	8b 53 04             	mov    0x4(%ebx),%edx
80104c15:	89 10                	mov    %edx,(%eax)
  return 0;
80104c17:	31 c0                	xor    %eax,%eax
}
80104c19:	5b                   	pop    %ebx
80104c1a:	5e                   	pop    %esi
80104c1b:	5d                   	pop    %ebp
80104c1c:	c3                   	ret    
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	eb f2                	jmp    80104c19 <argint+0x39>
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	57                   	push   %edi
80104c38:	56                   	push   %esi
80104c39:	53                   	push   %ebx
80104c3a:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c3d:	e8 3e ef ff ff       	call   80103b80 <myproc>
80104c42:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c44:	e8 37 ef ff ff       	call   80103b80 <myproc>
80104c49:	8b 55 08             	mov    0x8(%ebp),%edx
80104c4c:	8b 40 18             	mov    0x18(%eax),%eax
80104c4f:	8b 40 44             	mov    0x44(%eax),%eax
80104c52:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c55:	e8 26 ef ff ff       	call   80103b80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c5a:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c5d:	8b 00                	mov    (%eax),%eax
80104c5f:	39 c7                	cmp    %eax,%edi
80104c61:	73 35                	jae    80104c98 <argptr+0x68>
80104c63:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c66:	39 c8                	cmp    %ecx,%eax
80104c68:	72 2e                	jb     80104c98 <argptr+0x68>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c6a:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c6d:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c70:	85 d2                	test   %edx,%edx
80104c72:	78 24                	js     80104c98 <argptr+0x68>
80104c74:	8b 16                	mov    (%esi),%edx
80104c76:	39 c2                	cmp    %eax,%edx
80104c78:	76 1e                	jbe    80104c98 <argptr+0x68>
80104c7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c7d:	01 c3                	add    %eax,%ebx
80104c7f:	39 da                	cmp    %ebx,%edx
80104c81:	72 15                	jb     80104c98 <argptr+0x68>
    return -1;
  *pp = (char*)i;
80104c83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c86:	89 02                	mov    %eax,(%edx)
  return 0;
80104c88:	31 c0                	xor    %eax,%eax
}
80104c8a:	83 c4 0c             	add    $0xc,%esp
80104c8d:	5b                   	pop    %ebx
80104c8e:	5e                   	pop    %esi
80104c8f:	5f                   	pop    %edi
80104c90:	5d                   	pop    %ebp
80104c91:	c3                   	ret    
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9d:	eb eb                	jmp    80104c8a <argptr+0x5a>
80104c9f:	90                   	nop

80104ca0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	56                   	push   %esi
80104ca8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ca9:	e8 d2 ee ff ff       	call   80103b80 <myproc>
80104cae:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb1:	8b 40 18             	mov    0x18(%eax),%eax
80104cb4:	8b 40 44             	mov    0x44(%eax),%eax
80104cb7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cba:	e8 c1 ee ff ff       	call   80103b80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cbf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cc2:	8b 00                	mov    (%eax),%eax
80104cc4:	39 c6                	cmp    %eax,%esi
80104cc6:	73 40                	jae    80104d08 <argstr+0x68>
80104cc8:	8d 53 08             	lea    0x8(%ebx),%edx
80104ccb:	39 d0                	cmp    %edx,%eax
80104ccd:	72 39                	jb     80104d08 <argstr+0x68>
  *ip = *(int*)(addr);
80104ccf:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cd2:	e8 a9 ee ff ff       	call   80103b80 <myproc>
  if(addr >= curproc->sz)
80104cd7:	3b 18                	cmp    (%eax),%ebx
80104cd9:	73 2d                	jae    80104d08 <argstr+0x68>
  *pp = (char*)addr;
80104cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cde:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ce0:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ce2:	39 d3                	cmp    %edx,%ebx
80104ce4:	73 22                	jae    80104d08 <argstr+0x68>
80104ce6:	89 d8                	mov    %ebx,%eax
80104ce8:	eb 0d                	jmp    80104cf7 <argstr+0x57>
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf0:	83 c0 01             	add    $0x1,%eax
80104cf3:	39 c2                	cmp    %eax,%edx
80104cf5:	76 11                	jbe    80104d08 <argstr+0x68>
    if(*s == 0)
80104cf7:	80 38 00             	cmpb   $0x0,(%eax)
80104cfa:	75 f4                	jne    80104cf0 <argstr+0x50>
      return s - *pp;
80104cfc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cfe:	5b                   	pop    %ebx
80104cff:	5e                   	pop    %esi
80104d00:	5d                   	pop    %ebp
80104d01:	c3                   	ret    
80104d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d08:	5b                   	pop    %ebx
    return -1;
80104d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d0e:	5e                   	pop    %esi
80104d0f:	5d                   	pop    %ebp
80104d10:	c3                   	ret    
80104d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	53                   	push   %ebx
80104d28:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d2b:	e8 50 ee ff ff       	call   80103b80 <myproc>
80104d30:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d32:	8b 40 18             	mov    0x18(%eax),%eax
80104d35:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d38:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d3b:	83 fa 14             	cmp    $0x14,%edx
80104d3e:	77 20                	ja     80104d60 <syscall+0x40>
80104d40:	8b 14 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%edx
80104d47:	85 d2                	test   %edx,%edx
80104d49:	74 15                	je     80104d60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d4b:	ff d2                	call   *%edx
80104d4d:	89 c2                	mov    %eax,%edx
80104d4f:	8b 43 18             	mov    0x18(%ebx),%eax
80104d52:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d58:	c9                   	leave  
80104d59:	c3                   	ret    
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d61:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d64:	50                   	push   %eax
80104d65:	ff 73 10             	push   0x10(%ebx)
80104d68:	68 bd 7b 10 80       	push   $0x80107bbd
80104d6d:	e8 1e b9 ff ff       	call   80100690 <cprintf>
    curproc->tf->eax = -1;
80104d72:	8b 43 18             	mov    0x18(%ebx),%eax
80104d75:	83 c4 10             	add    $0x10,%esp
80104d78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    
80104d84:	66 90                	xchg   %ax,%ax
80104d86:	66 90                	xchg   %ax,%ax
80104d88:	66 90                	xchg   %ax,%ax
80104d8a:	66 90                	xchg   %ax,%ax
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d98:	53                   	push   %ebx
80104d99:	83 ec 34             	sub    $0x34,%esp
80104d9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104da2:	57                   	push   %edi
80104da3:	50                   	push   %eax
{
80104da4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104da7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104daa:	e8 91 d4 ff ff       	call   80102240 <nameiparent>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	0f 84 46 01 00 00    	je     80104f00 <create+0x170>
    return 0;
  ilock(dp);
80104dba:	83 ec 0c             	sub    $0xc,%esp
80104dbd:	89 c3                	mov    %eax,%ebx
80104dbf:	50                   	push   %eax
80104dc0:	e8 1b cb ff ff       	call   801018e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104dc5:	83 c4 0c             	add    $0xc,%esp
80104dc8:	6a 00                	push   $0x0
80104dca:	57                   	push   %edi
80104dcb:	53                   	push   %ebx
80104dcc:	e8 7f d0 ff ff       	call   80101e50 <dirlookup>
80104dd1:	83 c4 10             	add    $0x10,%esp
80104dd4:	89 c6                	mov    %eax,%esi
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	74 56                	je     80104e30 <create+0xa0>
    iunlockput(dp);
80104dda:	83 ec 0c             	sub    $0xc,%esp
80104ddd:	53                   	push   %ebx
80104dde:	e8 8d cd ff ff       	call   80101b70 <iunlockput>
    ilock(ip);
80104de3:	89 34 24             	mov    %esi,(%esp)
80104de6:	e8 f5 ca ff ff       	call   801018e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104deb:	83 c4 10             	add    $0x10,%esp
80104dee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104df3:	75 1b                	jne    80104e10 <create+0x80>
80104df5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dfa:	75 14                	jne    80104e10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dff:	89 f0                	mov    %esi,%eax
80104e01:	5b                   	pop    %ebx
80104e02:	5e                   	pop    %esi
80104e03:	5f                   	pop    %edi
80104e04:	5d                   	pop    %ebp
80104e05:	c3                   	ret    
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e10:	83 ec 0c             	sub    $0xc,%esp
80104e13:	56                   	push   %esi
    return 0;
80104e14:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e16:	e8 55 cd ff ff       	call   80101b70 <iunlockput>
    return 0;
80104e1b:	83 c4 10             	add    $0x10,%esp
}
80104e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e21:	89 f0                	mov    %esi,%eax
80104e23:	5b                   	pop    %ebx
80104e24:	5e                   	pop    %esi
80104e25:	5f                   	pop    %edi
80104e26:	5d                   	pop    %ebp
80104e27:	c3                   	ret    
80104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e34:	83 ec 08             	sub    $0x8,%esp
80104e37:	50                   	push   %eax
80104e38:	ff 33                	push   (%ebx)
80104e3a:	e8 21 c9 ff ff       	call   80101760 <ialloc>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	89 c6                	mov    %eax,%esi
80104e44:	85 c0                	test   %eax,%eax
80104e46:	0f 84 cd 00 00 00    	je     80104f19 <create+0x189>
  ilock(ip);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	50                   	push   %eax
80104e50:	e8 8b ca ff ff       	call   801018e0 <ilock>
  ip->major = major;
80104e55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e59:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e61:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e65:	b8 01 00 00 00       	mov    $0x1,%eax
80104e6a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e6e:	89 34 24             	mov    %esi,(%esp)
80104e71:	e8 aa c9 ff ff       	call   80101820 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e7e:	74 30                	je     80104eb0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e80:	83 ec 04             	sub    $0x4,%esp
80104e83:	ff 76 04             	push   0x4(%esi)
80104e86:	57                   	push   %edi
80104e87:	53                   	push   %ebx
80104e88:	e8 d3 d2 ff ff       	call   80102160 <dirlink>
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 78                	js     80104f0c <create+0x17c>
  iunlockput(dp);
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	53                   	push   %ebx
80104e98:	e8 d3 cc ff ff       	call   80101b70 <iunlockput>
  return ip;
80104e9d:	83 c4 10             	add    $0x10,%esp
}
80104ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea3:	89 f0                	mov    %esi,%eax
80104ea5:	5b                   	pop    %ebx
80104ea6:	5e                   	pop    %esi
80104ea7:	5f                   	pop    %edi
80104ea8:	5d                   	pop    %ebp
80104ea9:	c3                   	ret    
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104eb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104eb8:	53                   	push   %ebx
80104eb9:	e8 62 c9 ff ff       	call   80101820 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104ebe:	83 c4 0c             	add    $0xc,%esp
80104ec1:	ff 76 04             	push   0x4(%esi)
80104ec4:	68 54 7c 10 80       	push   $0x80107c54
80104ec9:	56                   	push   %esi
80104eca:	e8 91 d2 ff ff       	call   80102160 <dirlink>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	78 18                	js     80104eee <create+0x15e>
80104ed6:	83 ec 04             	sub    $0x4,%esp
80104ed9:	ff 73 04             	push   0x4(%ebx)
80104edc:	68 53 7c 10 80       	push   $0x80107c53
80104ee1:	56                   	push   %esi
80104ee2:	e8 79 d2 ff ff       	call   80102160 <dirlink>
80104ee7:	83 c4 10             	add    $0x10,%esp
80104eea:	85 c0                	test   %eax,%eax
80104eec:	79 92                	jns    80104e80 <create+0xf0>
      panic("create dots");
80104eee:	83 ec 0c             	sub    $0xc,%esp
80104ef1:	68 47 7c 10 80       	push   $0x80107c47
80104ef6:	e8 95 b4 ff ff       	call   80100390 <panic>
80104efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop
}
80104f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f03:	31 f6                	xor    %esi,%esi
}
80104f05:	5b                   	pop    %ebx
80104f06:	89 f0                	mov    %esi,%eax
80104f08:	5e                   	pop    %esi
80104f09:	5f                   	pop    %edi
80104f0a:	5d                   	pop    %ebp
80104f0b:	c3                   	ret    
    panic("create: dirlink");
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	68 56 7c 10 80       	push   $0x80107c56
80104f14:	e8 77 b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	68 38 7c 10 80       	push   $0x80107c38
80104f21:	e8 6a b4 ff ff       	call   80100390 <panic>
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi

80104f30 <sys_dup>:
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	56                   	push   %esi
80104f38:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f39:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f3f:	50                   	push   %eax
80104f40:	6a 00                	push   $0x0
80104f42:	e8 99 fc ff ff       	call   80104be0 <argint>
80104f47:	83 c4 10             	add    $0x10,%esp
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	78 32                	js     80104f80 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f52:	77 2c                	ja     80104f80 <sys_dup+0x50>
80104f54:	e8 27 ec ff ff       	call   80103b80 <myproc>
80104f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f5c:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f60:	85 f6                	test   %esi,%esi
80104f62:	74 1c                	je     80104f80 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f64:	e8 17 ec ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f69:	31 db                	xor    %ebx,%ebx
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104f70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f74:	85 d2                	test   %edx,%edx
80104f76:	74 18                	je     80104f90 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f78:	83 c3 01             	add    $0x1,%ebx
80104f7b:	83 fb 10             	cmp    $0x10,%ebx
80104f7e:	75 f0                	jne    80104f70 <sys_dup+0x40>
}
80104f80:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f88:	89 d8                	mov    %ebx,%eax
80104f8a:	5b                   	pop    %ebx
80104f8b:	5e                   	pop    %esi
80104f8c:	5d                   	pop    %ebp
80104f8d:	c3                   	ret    
80104f8e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f90:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f93:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f97:	56                   	push   %esi
80104f98:	e8 33 c0 ff ff       	call   80100fd0 <filedup>
  return fd;
80104f9d:	83 c4 10             	add    $0x10,%esp
}
80104fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa3:	89 d8                	mov    %ebx,%eax
80104fa5:	5b                   	pop    %ebx
80104fa6:	5e                   	pop    %esi
80104fa7:	5d                   	pop    %ebp
80104fa8:	c3                   	ret    
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <sys_read>:
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fb9:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fbc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fbf:	53                   	push   %ebx
80104fc0:	6a 00                	push   $0x0
80104fc2:	e8 19 fc ff ff       	call   80104be0 <argint>
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	78 62                	js     80105030 <sys_read+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fd2:	77 5c                	ja     80105030 <sys_read+0x80>
80104fd4:	e8 a7 eb ff ff       	call   80103b80 <myproc>
80104fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fdc:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fe0:	85 f6                	test   %esi,%esi
80104fe2:	74 4c                	je     80105030 <sys_read+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe4:	83 ec 08             	sub    $0x8,%esp
80104fe7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fea:	50                   	push   %eax
80104feb:	6a 02                	push   $0x2
80104fed:	e8 ee fb ff ff       	call   80104be0 <argint>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	78 37                	js     80105030 <sys_read+0x80>
80104ff9:	83 ec 04             	sub    $0x4,%esp
80104ffc:	ff 75 f0             	push   -0x10(%ebp)
80104fff:	53                   	push   %ebx
80105000:	6a 01                	push   $0x1
80105002:	e8 29 fc ff ff       	call   80104c30 <argptr>
80105007:	83 c4 10             	add    $0x10,%esp
8010500a:	85 c0                	test   %eax,%eax
8010500c:	78 22                	js     80105030 <sys_read+0x80>
  return fileread(f, p, n);
8010500e:	83 ec 04             	sub    $0x4,%esp
80105011:	ff 75 f0             	push   -0x10(%ebp)
80105014:	ff 75 f4             	push   -0xc(%ebp)
80105017:	56                   	push   %esi
80105018:	e8 33 c1 ff ff       	call   80101150 <fileread>
8010501d:	83 c4 10             	add    $0x10,%esp
}
80105020:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105023:	5b                   	pop    %ebx
80105024:	5e                   	pop    %esi
80105025:	5d                   	pop    %ebp
80105026:	c3                   	ret    
80105027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502e:	66 90                	xchg   %ax,%ax
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb e9                	jmp    80105020 <sys_read+0x70>
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <sys_write>:
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	56                   	push   %esi
80105048:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105049:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
8010504c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504f:	53                   	push   %ebx
80105050:	6a 00                	push   $0x0
80105052:	e8 89 fb ff ff       	call   80104be0 <argint>
80105057:	83 c4 10             	add    $0x10,%esp
8010505a:	85 c0                	test   %eax,%eax
8010505c:	78 62                	js     801050c0 <sys_write+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105062:	77 5c                	ja     801050c0 <sys_write+0x80>
80105064:	e8 17 eb ff ff       	call   80103b80 <myproc>
80105069:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010506c:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105070:	85 f6                	test   %esi,%esi
80105072:	74 4c                	je     801050c0 <sys_write+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105074:	83 ec 08             	sub    $0x8,%esp
80105077:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010507a:	50                   	push   %eax
8010507b:	6a 02                	push   $0x2
8010507d:	e8 5e fb ff ff       	call   80104be0 <argint>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 37                	js     801050c0 <sys_write+0x80>
80105089:	83 ec 04             	sub    $0x4,%esp
8010508c:	ff 75 f0             	push   -0x10(%ebp)
8010508f:	53                   	push   %ebx
80105090:	6a 01                	push   $0x1
80105092:	e8 99 fb ff ff       	call   80104c30 <argptr>
80105097:	83 c4 10             	add    $0x10,%esp
8010509a:	85 c0                	test   %eax,%eax
8010509c:	78 22                	js     801050c0 <sys_write+0x80>
  return filewrite(f, p, n);
8010509e:	83 ec 04             	sub    $0x4,%esp
801050a1:	ff 75 f0             	push   -0x10(%ebp)
801050a4:	ff 75 f4             	push   -0xc(%ebp)
801050a7:	56                   	push   %esi
801050a8:	e8 43 c1 ff ff       	call   801011f0 <filewrite>
801050ad:	83 c4 10             	add    $0x10,%esp
}
801050b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b3:	5b                   	pop    %ebx
801050b4:	5e                   	pop    %esi
801050b5:	5d                   	pop    %ebp
801050b6:	c3                   	ret    
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb e9                	jmp    801050b0 <sys_write+0x70>
801050c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <sys_close>:
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
801050d5:	89 e5                	mov    %esp,%ebp
801050d7:	56                   	push   %esi
801050d8:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050df:	50                   	push   %eax
801050e0:	6a 00                	push   $0x0
801050e2:	e8 f9 fa ff ff       	call   80104be0 <argint>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	85 c0                	test   %eax,%eax
801050ec:	78 42                	js     80105130 <sys_close+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050f2:	77 3c                	ja     80105130 <sys_close+0x60>
801050f4:	e8 87 ea ff ff       	call   80103b80 <myproc>
801050f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050fc:	8d 5a 08             	lea    0x8(%edx),%ebx
801050ff:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105103:	85 f6                	test   %esi,%esi
80105105:	74 29                	je     80105130 <sys_close+0x60>
  myproc()->ofile[fd] = 0;
80105107:	e8 74 ea ff ff       	call   80103b80 <myproc>
  fileclose(f);
8010510c:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010510f:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105116:	00 
  fileclose(f);
80105117:	56                   	push   %esi
80105118:	e8 03 bf ff ff       	call   80101020 <fileclose>
  return 0;
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	31 c0                	xor    %eax,%eax
}
80105122:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105125:	5b                   	pop    %ebx
80105126:	5e                   	pop    %esi
80105127:	5d                   	pop    %ebp
80105128:	c3                   	ret    
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb eb                	jmp    80105122 <sys_close+0x52>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <sys_fstat>:
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	56                   	push   %esi
80105148:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105149:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
8010514c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514f:	53                   	push   %ebx
80105150:	6a 00                	push   $0x0
80105152:	e8 89 fa ff ff       	call   80104be0 <argint>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	85 c0                	test   %eax,%eax
8010515c:	78 42                	js     801051a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105162:	77 3c                	ja     801051a0 <sys_fstat+0x60>
80105164:	e8 17 ea ff ff       	call   80103b80 <myproc>
80105169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010516c:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105170:	85 f6                	test   %esi,%esi
80105172:	74 2c                	je     801051a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105174:	83 ec 04             	sub    $0x4,%esp
80105177:	6a 14                	push   $0x14
80105179:	53                   	push   %ebx
8010517a:	6a 01                	push   $0x1
8010517c:	e8 af fa ff ff       	call   80104c30 <argptr>
80105181:	83 c4 10             	add    $0x10,%esp
80105184:	85 c0                	test   %eax,%eax
80105186:	78 18                	js     801051a0 <sys_fstat+0x60>
  return filestat(f, st);
80105188:	83 ec 08             	sub    $0x8,%esp
8010518b:	ff 75 f4             	push   -0xc(%ebp)
8010518e:	56                   	push   %esi
8010518f:	e8 6c bf ff ff       	call   80101100 <filestat>
80105194:	83 c4 10             	add    $0x10,%esp
}
80105197:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010519a:	5b                   	pop    %ebx
8010519b:	5e                   	pop    %esi
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a5:	eb f0                	jmp    80105197 <sys_fstat+0x57>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <sys_link>:
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	57                   	push   %edi
801051b8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051b9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051bc:	53                   	push   %ebx
801051bd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051c0:	50                   	push   %eax
801051c1:	6a 00                	push   $0x0
801051c3:	e8 d8 fa ff ff       	call   80104ca0 <argstr>
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	85 c0                	test   %eax,%eax
801051cd:	0f 88 ff 00 00 00    	js     801052d2 <sys_link+0x122>
801051d3:	83 ec 08             	sub    $0x8,%esp
801051d6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051d9:	50                   	push   %eax
801051da:	6a 01                	push   $0x1
801051dc:	e8 bf fa ff ff       	call   80104ca0 <argstr>
801051e1:	83 c4 10             	add    $0x10,%esp
801051e4:	85 c0                	test   %eax,%eax
801051e6:	0f 88 e6 00 00 00    	js     801052d2 <sys_link+0x122>
  begin_op();
801051ec:	e8 2f dd ff ff       	call   80102f20 <begin_op>
  if((ip = namei(old)) == 0){
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	ff 75 d4             	push   -0x2c(%ebp)
801051f7:	e8 24 d0 ff ff       	call   80102220 <namei>
801051fc:	83 c4 10             	add    $0x10,%esp
801051ff:	89 c3                	mov    %eax,%ebx
80105201:	85 c0                	test   %eax,%eax
80105203:	0f 84 e8 00 00 00    	je     801052f1 <sys_link+0x141>
  ilock(ip);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 ce c6 ff ff       	call   801018e0 <ilock>
  if(ip->type == T_DIR){
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010521a:	0f 84 b9 00 00 00    	je     801052d9 <sys_link+0x129>
  iupdate(ip);
80105220:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105223:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105228:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010522b:	53                   	push   %ebx
8010522c:	e8 ef c5 ff ff       	call   80101820 <iupdate>
  iunlock(ip);
80105231:	89 1c 24             	mov    %ebx,(%esp)
80105234:	e8 87 c7 ff ff       	call   801019c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105239:	58                   	pop    %eax
8010523a:	5a                   	pop    %edx
8010523b:	57                   	push   %edi
8010523c:	ff 75 d0             	push   -0x30(%ebp)
8010523f:	e8 fc cf ff ff       	call   80102240 <nameiparent>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	89 c6                	mov    %eax,%esi
80105249:	85 c0                	test   %eax,%eax
8010524b:	74 5f                	je     801052ac <sys_link+0xfc>
  ilock(dp);
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	50                   	push   %eax
80105251:	e8 8a c6 ff ff       	call   801018e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105256:	8b 03                	mov    (%ebx),%eax
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	39 06                	cmp    %eax,(%esi)
8010525d:	75 41                	jne    801052a0 <sys_link+0xf0>
8010525f:	83 ec 04             	sub    $0x4,%esp
80105262:	ff 73 04             	push   0x4(%ebx)
80105265:	57                   	push   %edi
80105266:	56                   	push   %esi
80105267:	e8 f4 ce ff ff       	call   80102160 <dirlink>
8010526c:	83 c4 10             	add    $0x10,%esp
8010526f:	85 c0                	test   %eax,%eax
80105271:	78 2d                	js     801052a0 <sys_link+0xf0>
  iunlockput(dp);
80105273:	83 ec 0c             	sub    $0xc,%esp
80105276:	56                   	push   %esi
80105277:	e8 f4 c8 ff ff       	call   80101b70 <iunlockput>
  iput(ip);
8010527c:	89 1c 24             	mov    %ebx,(%esp)
8010527f:	e8 8c c7 ff ff       	call   80101a10 <iput>
  end_op();
80105284:	e8 07 dd ff ff       	call   80102f90 <end_op>
  return 0;
80105289:	83 c4 10             	add    $0x10,%esp
8010528c:	31 c0                	xor    %eax,%eax
}
8010528e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105291:	5b                   	pop    %ebx
80105292:	5e                   	pop    %esi
80105293:	5f                   	pop    %edi
80105294:	5d                   	pop    %ebp
80105295:	c3                   	ret    
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	56                   	push   %esi
801052a4:	e8 c7 c8 ff ff       	call   80101b70 <iunlockput>
    goto bad;
801052a9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	53                   	push   %ebx
801052b0:	e8 2b c6 ff ff       	call   801018e0 <ilock>
  ip->nlink--;
801052b5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052ba:	89 1c 24             	mov    %ebx,(%esp)
801052bd:	e8 5e c5 ff ff       	call   80101820 <iupdate>
  iunlockput(ip);
801052c2:	89 1c 24             	mov    %ebx,(%esp)
801052c5:	e8 a6 c8 ff ff       	call   80101b70 <iunlockput>
  end_op();
801052ca:	e8 c1 dc ff ff       	call   80102f90 <end_op>
  return -1;
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d7:	eb b5                	jmp    8010528e <sys_link+0xde>
    iunlockput(ip);
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	53                   	push   %ebx
801052dd:	e8 8e c8 ff ff       	call   80101b70 <iunlockput>
    end_op();
801052e2:	e8 a9 dc ff ff       	call   80102f90 <end_op>
    return -1;
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ef:	eb 9d                	jmp    8010528e <sys_link+0xde>
    end_op();
801052f1:	e8 9a dc ff ff       	call   80102f90 <end_op>
    return -1;
801052f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fb:	eb 91                	jmp    8010528e <sys_link+0xde>
801052fd:	8d 76 00             	lea    0x0(%esi),%esi

80105300 <sys_unlink>:
{
80105300:	f3 0f 1e fb          	endbr32 
80105304:	55                   	push   %ebp
80105305:	89 e5                	mov    %esp,%ebp
80105307:	57                   	push   %edi
80105308:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105309:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010530c:	53                   	push   %ebx
8010530d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105310:	50                   	push   %eax
80105311:	6a 00                	push   $0x0
80105313:	e8 88 f9 ff ff       	call   80104ca0 <argstr>
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	85 c0                	test   %eax,%eax
8010531d:	0f 88 86 01 00 00    	js     801054a9 <sys_unlink+0x1a9>
  begin_op();
80105323:	e8 f8 db ff ff       	call   80102f20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105328:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010532b:	83 ec 08             	sub    $0x8,%esp
8010532e:	53                   	push   %ebx
8010532f:	ff 75 c0             	push   -0x40(%ebp)
80105332:	e8 09 cf ff ff       	call   80102240 <nameiparent>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010533d:	85 c0                	test   %eax,%eax
8010533f:	0f 84 6e 01 00 00    	je     801054b3 <sys_unlink+0x1b3>
  ilock(dp);
80105345:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	57                   	push   %edi
8010534c:	e8 8f c5 ff ff       	call   801018e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105351:	58                   	pop    %eax
80105352:	5a                   	pop    %edx
80105353:	68 54 7c 10 80       	push   $0x80107c54
80105358:	53                   	push   %ebx
80105359:	e8 d2 ca ff ff       	call   80101e30 <namecmp>
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	85 c0                	test   %eax,%eax
80105363:	0f 84 07 01 00 00    	je     80105470 <sys_unlink+0x170>
80105369:	83 ec 08             	sub    $0x8,%esp
8010536c:	68 53 7c 10 80       	push   $0x80107c53
80105371:	53                   	push   %ebx
80105372:	e8 b9 ca ff ff       	call   80101e30 <namecmp>
80105377:	83 c4 10             	add    $0x10,%esp
8010537a:	85 c0                	test   %eax,%eax
8010537c:	0f 84 ee 00 00 00    	je     80105470 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105382:	83 ec 04             	sub    $0x4,%esp
80105385:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105388:	50                   	push   %eax
80105389:	53                   	push   %ebx
8010538a:	57                   	push   %edi
8010538b:	e8 c0 ca ff ff       	call   80101e50 <dirlookup>
80105390:	83 c4 10             	add    $0x10,%esp
80105393:	89 c3                	mov    %eax,%ebx
80105395:	85 c0                	test   %eax,%eax
80105397:	0f 84 d3 00 00 00    	je     80105470 <sys_unlink+0x170>
  ilock(ip);
8010539d:	83 ec 0c             	sub    $0xc,%esp
801053a0:	50                   	push   %eax
801053a1:	e8 3a c5 ff ff       	call   801018e0 <ilock>
  if(ip->nlink < 1)
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053ae:	0f 8e 28 01 00 00    	jle    801054dc <sys_unlink+0x1dc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053b4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b9:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053bc:	74 6a                	je     80105428 <sys_unlink+0x128>
  memset(&de, 0, sizeof(de));
801053be:	83 ec 04             	sub    $0x4,%esp
801053c1:	6a 10                	push   $0x10
801053c3:	6a 00                	push   $0x0
801053c5:	57                   	push   %edi
801053c6:	e8 35 f5 ff ff       	call   80104900 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053cb:	6a 10                	push   $0x10
801053cd:	ff 75 c4             	push   -0x3c(%ebp)
801053d0:	57                   	push   %edi
801053d1:	ff 75 b4             	push   -0x4c(%ebp)
801053d4:	e8 27 c9 ff ff       	call   80101d00 <writei>
801053d9:	83 c4 20             	add    $0x20,%esp
801053dc:	83 f8 10             	cmp    $0x10,%eax
801053df:	0f 85 ea 00 00 00    	jne    801054cf <sys_unlink+0x1cf>
  if(ip->type == T_DIR){
801053e5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053ea:	0f 84 a0 00 00 00    	je     80105490 <sys_unlink+0x190>
  iunlockput(dp);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	ff 75 b4             	push   -0x4c(%ebp)
801053f6:	e8 75 c7 ff ff       	call   80101b70 <iunlockput>
  ip->nlink--;
801053fb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105400:	89 1c 24             	mov    %ebx,(%esp)
80105403:	e8 18 c4 ff ff       	call   80101820 <iupdate>
  iunlockput(ip);
80105408:	89 1c 24             	mov    %ebx,(%esp)
8010540b:	e8 60 c7 ff ff       	call   80101b70 <iunlockput>
  end_op();
80105410:	e8 7b db ff ff       	call   80102f90 <end_op>
  return 0;
80105415:	83 c4 10             	add    $0x10,%esp
80105418:	31 c0                	xor    %eax,%eax
}
8010541a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010541d:	5b                   	pop    %ebx
8010541e:	5e                   	pop    %esi
8010541f:	5f                   	pop    %edi
80105420:	5d                   	pop    %ebp
80105421:	c3                   	ret    
80105422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105428:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010542c:	76 90                	jbe    801053be <sys_unlink+0xbe>
8010542e:	be 20 00 00 00       	mov    $0x20,%esi
80105433:	eb 0f                	jmp    80105444 <sys_unlink+0x144>
80105435:	8d 76 00             	lea    0x0(%esi),%esi
80105438:	83 c6 10             	add    $0x10,%esi
8010543b:	3b 73 58             	cmp    0x58(%ebx),%esi
8010543e:	0f 83 7a ff ff ff    	jae    801053be <sys_unlink+0xbe>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105444:	6a 10                	push   $0x10
80105446:	56                   	push   %esi
80105447:	57                   	push   %edi
80105448:	53                   	push   %ebx
80105449:	e8 b2 c7 ff ff       	call   80101c00 <readi>
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	83 f8 10             	cmp    $0x10,%eax
80105454:	75 6c                	jne    801054c2 <sys_unlink+0x1c2>
    if(de.inum != 0)
80105456:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010545b:	74 db                	je     80105438 <sys_unlink+0x138>
    iunlockput(ip);
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	53                   	push   %ebx
80105461:	e8 0a c7 ff ff       	call   80101b70 <iunlockput>
    goto bad;
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	ff 75 b4             	push   -0x4c(%ebp)
80105476:	e8 f5 c6 ff ff       	call   80101b70 <iunlockput>
  end_op();
8010547b:	e8 10 db ff ff       	call   80102f90 <end_op>
  return -1;
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105488:	eb 90                	jmp    8010541a <sys_unlink+0x11a>
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105490:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105493:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105496:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010549b:	50                   	push   %eax
8010549c:	e8 7f c3 ff ff       	call   80101820 <iupdate>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	e9 47 ff ff ff       	jmp    801053f0 <sys_unlink+0xf0>
    return -1;
801054a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ae:	e9 67 ff ff ff       	jmp    8010541a <sys_unlink+0x11a>
    end_op();
801054b3:	e8 d8 da ff ff       	call   80102f90 <end_op>
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	e9 58 ff ff ff       	jmp    8010541a <sys_unlink+0x11a>
      panic("isdirempty: readi");
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	68 78 7c 10 80       	push   $0x80107c78
801054ca:	e8 c1 ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	68 8a 7c 10 80       	push   $0x80107c8a
801054d7:	e8 b4 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	68 66 7c 10 80       	push   $0x80107c66
801054e4:	e8 a7 ae ff ff       	call   80100390 <panic>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_open>:

int
sys_open(void)
{
801054f0:	f3 0f 1e fb          	endbr32 
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	57                   	push   %edi
801054f8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054fc:	53                   	push   %ebx
801054fd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105500:	50                   	push   %eax
80105501:	6a 00                	push   $0x0
80105503:	e8 98 f7 ff ff       	call   80104ca0 <argstr>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	0f 88 8a 00 00 00    	js     8010559d <sys_open+0xad>
80105513:	83 ec 08             	sub    $0x8,%esp
80105516:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105519:	50                   	push   %eax
8010551a:	6a 01                	push   $0x1
8010551c:	e8 bf f6 ff ff       	call   80104be0 <argint>
80105521:	83 c4 10             	add    $0x10,%esp
80105524:	85 c0                	test   %eax,%eax
80105526:	78 75                	js     8010559d <sys_open+0xad>
    return -1;

  begin_op();
80105528:	e8 f3 d9 ff ff       	call   80102f20 <begin_op>

  if(omode & O_CREATE){
8010552d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105531:	75 75                	jne    801055a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105533:	83 ec 0c             	sub    $0xc,%esp
80105536:	ff 75 e0             	push   -0x20(%ebp)
80105539:	e8 e2 cc ff ff       	call   80102220 <namei>
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	89 c6                	mov    %eax,%esi
80105543:	85 c0                	test   %eax,%eax
80105545:	74 7e                	je     801055c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105547:	83 ec 0c             	sub    $0xc,%esp
8010554a:	50                   	push   %eax
8010554b:	e8 90 c3 ff ff       	call   801018e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105558:	0f 84 c2 00 00 00    	je     80105620 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010555e:	e8 fd b9 ff ff       	call   80100f60 <filealloc>
80105563:	89 c7                	mov    %eax,%edi
80105565:	85 c0                	test   %eax,%eax
80105567:	74 23                	je     8010558c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105569:	e8 12 e6 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105570:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105574:	85 d2                	test   %edx,%edx
80105576:	74 60                	je     801055d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105578:	83 c3 01             	add    $0x1,%ebx
8010557b:	83 fb 10             	cmp    $0x10,%ebx
8010557e:	75 f0                	jne    80105570 <sys_open+0x80>
    if(f)
      fileclose(f);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	57                   	push   %edi
80105584:	e8 97 ba ff ff       	call   80101020 <fileclose>
80105589:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	56                   	push   %esi
80105590:	e8 db c5 ff ff       	call   80101b70 <iunlockput>
    end_op();
80105595:	e8 f6 d9 ff ff       	call   80102f90 <end_op>
    return -1;
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055a2:	eb 6d                	jmp    80105611 <sys_open+0x121>
801055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055ae:	31 c9                	xor    %ecx,%ecx
801055b0:	ba 02 00 00 00       	mov    $0x2,%edx
801055b5:	6a 00                	push   $0x0
801055b7:	e8 d4 f7 ff ff       	call   80104d90 <create>
    if(ip == 0){
801055bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055c1:	85 c0                	test   %eax,%eax
801055c3:	75 99                	jne    8010555e <sys_open+0x6e>
      end_op();
801055c5:	e8 c6 d9 ff ff       	call   80102f90 <end_op>
      return -1;
801055ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055cf:	eb 40                	jmp    80105611 <sys_open+0x121>
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055df:	56                   	push   %esi
801055e0:	e8 db c3 ff ff       	call   801019c0 <iunlock>
  end_op();
801055e5:	e8 a6 d9 ff ff       	call   80102f90 <end_op>

  f->type = FD_INODE;
801055ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105602:	f7 d0                	not    %eax
80105604:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105607:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010560a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010560d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105614:	89 d8                	mov    %ebx,%eax
80105616:	5b                   	pop    %ebx
80105617:	5e                   	pop    %esi
80105618:	5f                   	pop    %edi
80105619:	5d                   	pop    %ebp
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105620:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105623:	85 c9                	test   %ecx,%ecx
80105625:	0f 84 33 ff ff ff    	je     8010555e <sys_open+0x6e>
8010562b:	e9 5c ff ff ff       	jmp    8010558c <sys_open+0x9c>

80105630 <sys_mkdir>:

int
sys_mkdir(void)
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010563a:	e8 e1 d8 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010563f:	83 ec 08             	sub    $0x8,%esp
80105642:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105645:	50                   	push   %eax
80105646:	6a 00                	push   $0x0
80105648:	e8 53 f6 ff ff       	call   80104ca0 <argstr>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	78 34                	js     80105688 <sys_mkdir+0x58>
80105654:	83 ec 0c             	sub    $0xc,%esp
80105657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565a:	31 c9                	xor    %ecx,%ecx
8010565c:	ba 01 00 00 00       	mov    $0x1,%edx
80105661:	6a 00                	push   $0x0
80105663:	e8 28 f7 ff ff       	call   80104d90 <create>
80105668:	83 c4 10             	add    $0x10,%esp
8010566b:	85 c0                	test   %eax,%eax
8010566d:	74 19                	je     80105688 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	50                   	push   %eax
80105673:	e8 f8 c4 ff ff       	call   80101b70 <iunlockput>
  end_op();
80105678:	e8 13 d9 ff ff       	call   80102f90 <end_op>
  return 0;
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	31 c0                	xor    %eax,%eax
}
80105682:	c9                   	leave  
80105683:	c3                   	ret    
80105684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105688:	e8 03 d9 ff ff       	call   80102f90 <end_op>
    return -1;
8010568d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105692:	c9                   	leave  
80105693:	c3                   	ret    
80105694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop

801056a0 <sys_mknod>:

int
sys_mknod(void)
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056aa:	e8 71 d8 ff ff       	call   80102f20 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056b5:	50                   	push   %eax
801056b6:	6a 00                	push   $0x0
801056b8:	e8 e3 f5 ff ff       	call   80104ca0 <argstr>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 64                	js     80105728 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801056c4:	83 ec 08             	sub    $0x8,%esp
801056c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ca:	50                   	push   %eax
801056cb:	6a 01                	push   $0x1
801056cd:	e8 0e f5 ff ff       	call   80104be0 <argint>
  if((argstr(0, &path)) < 0 ||
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	85 c0                	test   %eax,%eax
801056d7:	78 4f                	js     80105728 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801056d9:	83 ec 08             	sub    $0x8,%esp
801056dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056df:	50                   	push   %eax
801056e0:	6a 02                	push   $0x2
801056e2:	e8 f9 f4 ff ff       	call   80104be0 <argint>
     argint(1, &major) < 0 ||
801056e7:	83 c4 10             	add    $0x10,%esp
801056ea:	85 c0                	test   %eax,%eax
801056ec:	78 3a                	js     80105728 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ee:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056f2:	83 ec 0c             	sub    $0xc,%esp
801056f5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056f9:	ba 03 00 00 00       	mov    $0x3,%edx
801056fe:	50                   	push   %eax
801056ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105702:	e8 89 f6 ff ff       	call   80104d90 <create>
     argint(2, &minor) < 0 ||
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	85 c0                	test   %eax,%eax
8010570c:	74 1a                	je     80105728 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010570e:	83 ec 0c             	sub    $0xc,%esp
80105711:	50                   	push   %eax
80105712:	e8 59 c4 ff ff       	call   80101b70 <iunlockput>
  end_op();
80105717:	e8 74 d8 ff ff       	call   80102f90 <end_op>
  return 0;
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	31 c0                	xor    %eax,%eax
}
80105721:	c9                   	leave  
80105722:	c3                   	ret    
80105723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105727:	90                   	nop
    end_op();
80105728:	e8 63 d8 ff ff       	call   80102f90 <end_op>
    return -1;
8010572d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105732:	c9                   	leave  
80105733:	c3                   	ret    
80105734:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop

80105740 <sys_chdir>:

int
sys_chdir(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	56                   	push   %esi
80105748:	53                   	push   %ebx
80105749:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010574c:	e8 2f e4 ff ff       	call   80103b80 <myproc>
80105751:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105753:	e8 c8 d7 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105758:	83 ec 08             	sub    $0x8,%esp
8010575b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575e:	50                   	push   %eax
8010575f:	6a 00                	push   $0x0
80105761:	e8 3a f5 ff ff       	call   80104ca0 <argstr>
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	85 c0                	test   %eax,%eax
8010576b:	78 73                	js     801057e0 <sys_chdir+0xa0>
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	ff 75 f4             	push   -0xc(%ebp)
80105773:	e8 a8 ca ff ff       	call   80102220 <namei>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	89 c3                	mov    %eax,%ebx
8010577d:	85 c0                	test   %eax,%eax
8010577f:	74 5f                	je     801057e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105781:	83 ec 0c             	sub    $0xc,%esp
80105784:	50                   	push   %eax
80105785:	e8 56 c1 ff ff       	call   801018e0 <ilock>
  if(ip->type != T_DIR){
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105792:	75 2c                	jne    801057c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	53                   	push   %ebx
80105798:	e8 23 c2 ff ff       	call   801019c0 <iunlock>
  iput(curproc->cwd);
8010579d:	58                   	pop    %eax
8010579e:	ff 76 68             	push   0x68(%esi)
801057a1:	e8 6a c2 ff ff       	call   80101a10 <iput>
  end_op();
801057a6:	e8 e5 d7 ff ff       	call   80102f90 <end_op>
  curproc->cwd = ip;
801057ab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	31 c0                	xor    %eax,%eax
}
801057b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057b6:	5b                   	pop    %ebx
801057b7:	5e                   	pop    %esi
801057b8:	5d                   	pop    %ebp
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	53                   	push   %ebx
801057c4:	e8 a7 c3 ff ff       	call   80101b70 <iunlockput>
    end_op();
801057c9:	e8 c2 d7 ff ff       	call   80102f90 <end_op>
    return -1;
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d6:	eb db                	jmp    801057b3 <sys_chdir+0x73>
801057d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop
    end_op();
801057e0:	e8 ab d7 ff ff       	call   80102f90 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ea:	eb c7                	jmp    801057b3 <sys_chdir+0x73>
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_exec>:

int
sys_exec(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	57                   	push   %edi
801057f8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057f9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057ff:	53                   	push   %ebx
80105800:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105806:	50                   	push   %eax
80105807:	6a 00                	push   $0x0
80105809:	e8 92 f4 ff ff       	call   80104ca0 <argstr>
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	85 c0                	test   %eax,%eax
80105813:	0f 88 83 00 00 00    	js     8010589c <sys_exec+0xac>
80105819:	83 ec 08             	sub    $0x8,%esp
8010581c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105822:	50                   	push   %eax
80105823:	6a 01                	push   $0x1
80105825:	e8 b6 f3 ff ff       	call   80104be0 <argint>
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	85 c0                	test   %eax,%eax
8010582f:	78 6b                	js     8010589c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105831:	83 ec 04             	sub    $0x4,%esp
80105834:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
8010583a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010583c:	68 80 00 00 00       	push   $0x80
80105841:	6a 00                	push   $0x0
80105843:	56                   	push   %esi
80105844:	e8 b7 f0 ff ff       	call   80104900 <memset>
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105859:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105860:	50                   	push   %eax
80105861:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105867:	01 f8                	add    %edi,%eax
80105869:	50                   	push   %eax
8010586a:	e8 d1 f2 ff ff       	call   80104b40 <fetchint>
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	85 c0                	test   %eax,%eax
80105874:	78 26                	js     8010589c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105876:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010587c:	85 c0                	test   %eax,%eax
8010587e:	74 30                	je     801058b0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105886:	52                   	push   %edx
80105887:	50                   	push   %eax
80105888:	e8 f3 f2 ff ff       	call   80104b80 <fetchstr>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	78 08                	js     8010589c <sys_exec+0xac>
  for(i=0;; i++){
80105894:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105897:	83 fb 20             	cmp    $0x20,%ebx
8010589a:	75 b4                	jne    80105850 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010589c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010589f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a4:	5b                   	pop    %ebx
801058a5:	5e                   	pop    %esi
801058a6:	5f                   	pop    %edi
801058a7:	5d                   	pop    %ebp
801058a8:	c3                   	ret    
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801058b0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058b7:	00 00 00 00 
  return exec(path, argv);
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	56                   	push   %esi
801058bf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058c5:	e8 16 b3 ff ff       	call   80100be0 <exec>
801058ca:	83 c4 10             	add    $0x10,%esp
}
801058cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d0:	5b                   	pop    %ebx
801058d1:	5e                   	pop    %esi
801058d2:	5f                   	pop    %edi
801058d3:	5d                   	pop    %ebp
801058d4:	c3                   	ret    
801058d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_pipe>:

int
sys_pipe(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	57                   	push   %edi
801058e8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058e9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058ec:	53                   	push   %ebx
801058ed:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058f0:	6a 08                	push   $0x8
801058f2:	50                   	push   %eax
801058f3:	6a 00                	push   $0x0
801058f5:	e8 36 f3 ff ff       	call   80104c30 <argptr>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	85 c0                	test   %eax,%eax
801058ff:	78 4e                	js     8010594f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105901:	83 ec 08             	sub    $0x8,%esp
80105904:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105907:	50                   	push   %eax
80105908:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010590b:	50                   	push   %eax
8010590c:	e8 ff dc ff ff       	call   80103610 <pipealloc>
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	85 c0                	test   %eax,%eax
80105916:	78 37                	js     8010594f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105918:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010591b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010591d:	e8 5e e2 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105928:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010592c:	85 f6                	test   %esi,%esi
8010592e:	74 30                	je     80105960 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105930:	83 c3 01             	add    $0x1,%ebx
80105933:	83 fb 10             	cmp    $0x10,%ebx
80105936:	75 f0                	jne    80105928 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	ff 75 e0             	push   -0x20(%ebp)
8010593e:	e8 dd b6 ff ff       	call   80101020 <fileclose>
    fileclose(wf);
80105943:	58                   	pop    %eax
80105944:	ff 75 e4             	push   -0x1c(%ebp)
80105947:	e8 d4 b6 ff ff       	call   80101020 <fileclose>
    return -1;
8010594c:	83 c4 10             	add    $0x10,%esp
8010594f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105954:	eb 5b                	jmp    801059b1 <sys_pipe+0xd1>
80105956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105960:	8d 73 08             	lea    0x8(%ebx),%esi
80105963:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010596a:	e8 11 e2 ff ff       	call   80103b80 <myproc>
8010596f:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105971:	31 c0                	xor    %eax,%eax
80105973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105977:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105978:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
8010597c:	85 c9                	test   %ecx,%ecx
8010597e:	74 20                	je     801059a0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105980:	83 c0 01             	add    $0x1,%eax
80105983:	83 f8 10             	cmp    $0x10,%eax
80105986:	75 f0                	jne    80105978 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105988:	e8 f3 e1 ff ff       	call   80103b80 <myproc>
8010598d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105994:	00 
80105995:	eb a1                	jmp    80105938 <sys_pipe+0x58>
80105997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059a0:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
801059a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801059a7:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801059a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801059ac:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
801059af:	31 c0                	xor    %eax,%eax
}
801059b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b4:	5b                   	pop    %ebx
801059b5:	5e                   	pop    %esi
801059b6:	5f                   	pop    %edi
801059b7:	5d                   	pop    %ebp
801059b8:	c3                   	ret    
801059b9:	66 90                	xchg   %ax,%ax
801059bb:	66 90                	xchg   %ax,%ax
801059bd:	66 90                	xchg   %ax,%ax
801059bf:	90                   	nop

801059c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059c0:	f3 0f 1e fb          	endbr32 
  return fork();
801059c4:	e9 67 e3 ff ff       	jmp    80103d30 <fork>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_exit>:
}

int
sys_exit(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	83 ec 08             	sub    $0x8,%esp
  exit();
801059da:	e8 e1 e5 ff ff       	call   80103fc0 <exit>
  return 0;  // not reached
}
801059df:	31 c0                	xor    %eax,%eax
801059e1:	c9                   	leave  
801059e2:	c3                   	ret    
801059e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059f0 <sys_wait>:

int
sys_wait(void)
{
801059f0:	f3 0f 1e fb          	endbr32 
  return wait();
801059f4:	e9 f7 e6 ff ff       	jmp    801040f0 <wait>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_kill>:
}

int
sys_kill(void)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a0d:	50                   	push   %eax
80105a0e:	6a 00                	push   $0x0
80105a10:	e8 cb f1 ff ff       	call   80104be0 <argint>
80105a15:	83 c4 10             	add    $0x10,%esp
80105a18:	85 c0                	test   %eax,%eax
80105a1a:	78 14                	js     80105a30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	ff 75 f4             	push   -0xc(%ebp)
80105a22:	e8 69 e9 ff ff       	call   80104390 <kill>
80105a27:	83 c4 10             	add    $0x10,%esp
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a30:	c9                   	leave  
    return -1;
80105a31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a36:	c3                   	ret    
80105a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_getpid>:

int
sys_getpid(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a4a:	e8 31 e1 ff ff       	call   80103b80 <myproc>
80105a4f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a52:	c9                   	leave  
80105a53:	c3                   	ret    
80105a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop

80105a60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a60:	f3 0f 1e fb          	endbr32 
80105a64:	55                   	push   %ebp
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a6b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a6e:	50                   	push   %eax
80105a6f:	6a 00                	push   $0x0
80105a71:	e8 6a f1 ff ff       	call   80104be0 <argint>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	78 23                	js     80105aa0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a7d:	e8 fe e0 ff ff       	call   80103b80 <myproc>
  if(growproc(n) < 0)
80105a82:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a85:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a87:	ff 75 f4             	push   -0xc(%ebp)
80105a8a:	e8 21 e2 ff ff       	call   80103cb0 <growproc>
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	85 c0                	test   %eax,%eax
80105a94:	78 0a                	js     80105aa0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a96:	89 d8                	mov    %ebx,%eax
80105a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a9b:	c9                   	leave  
80105a9c:	c3                   	ret    
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105aa0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aa5:	eb ef                	jmp    80105a96 <sys_sbrk+0x36>
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_sleep>:

int
sys_sleep(void)
{
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105abb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105abe:	50                   	push   %eax
80105abf:	6a 00                	push   $0x0
80105ac1:	e8 1a f1 ff ff       	call   80104be0 <argint>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	0f 88 86 00 00 00    	js     80105b57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ad1:	83 ec 0c             	sub    $0xc,%esp
80105ad4:	68 80 3c 11 80       	push   $0x80113c80
80105ad9:	e8 52 ed ff ff       	call   80104830 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ae1:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	85 d2                	test   %edx,%edx
80105aec:	75 23                	jne    80105b11 <sys_sleep+0x61>
80105aee:	eb 50                	jmp    80105b40 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	68 80 3c 11 80       	push   $0x80113c80
80105af8:	68 60 3c 11 80       	push   $0x80113c60
80105afd:	e8 6e e7 ff ff       	call   80104270 <sleep>
  while(ticks - ticks0 < n){
80105b02:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	29 d8                	sub    %ebx,%eax
80105b0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b0f:	73 2f                	jae    80105b40 <sys_sleep+0x90>
    if(myproc()->killed){
80105b11:	e8 6a e0 ff ff       	call   80103b80 <myproc>
80105b16:	8b 40 24             	mov    0x24(%eax),%eax
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	74 d3                	je     80105af0 <sys_sleep+0x40>
      release(&tickslock);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	68 80 3c 11 80       	push   $0x80113c80
80105b25:	e8 96 ec ff ff       	call   801047c0 <release>
  }
  release(&tickslock);
  return 0;
}
80105b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	68 80 3c 11 80       	push   $0x80113c80
80105b48:	e8 73 ec ff ff       	call   801047c0 <release>
  return 0;
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	31 c0                	xor    %eax,%eax
}
80105b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
    return -1;
80105b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5c:	eb f4                	jmp    80105b52 <sys_sleep+0xa2>
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	53                   	push   %ebx
80105b68:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b6b:	68 80 3c 11 80       	push   $0x80113c80
80105b70:	e8 bb ec ff ff       	call   80104830 <acquire>
  xticks = ticks;
80105b75:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105b7b:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105b82:	e8 39 ec ff ff       	call   801047c0 <release>
  return xticks;
}
80105b87:	89 d8                	mov    %ebx,%eax
80105b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b8c:	c9                   	leave  
80105b8d:	c3                   	ret    

80105b8e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b8e:	1e                   	push   %ds
  pushl %es
80105b8f:	06                   	push   %es
  pushl %fs
80105b90:	0f a0                	push   %fs
  pushl %gs
80105b92:	0f a8                	push   %gs
  pushal
80105b94:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b95:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b99:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b9b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b9d:	54                   	push   %esp
  call trap
80105b9e:	e8 cd 00 00 00       	call   80105c70 <trap>
  addl $4, %esp
80105ba3:	83 c4 04             	add    $0x4,%esp

80105ba6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ba6:	61                   	popa   
  popl %gs
80105ba7:	0f a9                	pop    %gs
  popl %fs
80105ba9:	0f a1                	pop    %fs
  popl %es
80105bab:	07                   	pop    %es
  popl %ds
80105bac:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bad:	83 c4 08             	add    $0x8,%esp
  iret
80105bb0:	cf                   	iret   
80105bb1:	66 90                	xchg   %ax,%ax
80105bb3:	66 90                	xchg   %ax,%ax
80105bb5:	66 90                	xchg   %ax,%ax
80105bb7:	66 90                	xchg   %ax,%ax
80105bb9:	66 90                	xchg   %ax,%ax
80105bbb:	66 90                	xchg   %ax,%ax
80105bbd:	66 90                	xchg   %ax,%ax
80105bbf:	90                   	nop

80105bc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bc0:	f3 0f 1e fb          	endbr32 
80105bc4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bc5:	31 c0                	xor    %eax,%eax
{
80105bc7:	89 e5                	mov    %esp,%ebp
80105bc9:	83 ec 08             	sub    $0x8,%esp
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bd0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bd7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
80105bde:	08 00 00 8e 
80105be2:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105be9:	80 
80105bea:	c1 ea 10             	shr    $0x10,%edx
80105bed:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105bf4:	80 
  for(i = 0; i < 256; i++)
80105bf5:	83 c0 01             	add    $0x1,%eax
80105bf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bfd:	75 d1                	jne    80105bd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c02:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c07:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
80105c0e:	00 00 ef 
  initlock(&tickslock, "time");
80105c11:	68 99 7c 10 80       	push   $0x80107c99
80105c16:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c1b:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105c21:	c1 e8 10             	shr    $0x10,%eax
80105c24:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105c2a:	e8 01 ea ff ff       	call   80104630 <initlock>
}
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c3f:	90                   	nop

80105c40 <idtinit>:

void
idtinit(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
  pd[0] = size-1;
80105c45:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c4a:	89 e5                	mov    %esp,%ebp
80105c4c:	83 ec 10             	sub    $0x10,%esp
80105c4f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c53:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105c58:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c5c:	c1 e8 10             	shr    $0x10,%eax
80105c5f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c63:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c66:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c69:	c9                   	leave  
80105c6a:	c3                   	ret    
80105c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop

80105c70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c70:	f3 0f 1e fb          	endbr32 
80105c74:	55                   	push   %ebp
80105c75:	89 e5                	mov    %esp,%ebp
80105c77:	57                   	push   %edi
80105c78:	56                   	push   %esi
80105c79:	53                   	push   %ebx
80105c7a:	83 ec 1c             	sub    $0x1c,%esp
80105c7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c80:	8b 43 30             	mov    0x30(%ebx),%eax
80105c83:	83 f8 40             	cmp    $0x40,%eax
80105c86:	0f 84 64 01 00 00    	je     80105df0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c8c:	83 e8 20             	sub    $0x20,%eax
80105c8f:	83 f8 1f             	cmp    $0x1f,%eax
80105c92:	0f 87 88 00 00 00    	ja     80105d20 <trap+0xb0>
80105c98:	3e ff 24 85 40 7d 10 	notrack jmp *-0x7fef82c0(,%eax,4)
80105c9f:	80 
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ca0:	e8 2b c7 ff ff       	call   801023d0 <ideintr>
    lapiceoi();
80105ca5:	e8 06 ce ff ff       	call   80102ab0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105caa:	e8 d1 de ff ff       	call   80103b80 <myproc>
80105caf:	85 c0                	test   %eax,%eax
80105cb1:	74 1d                	je     80105cd0 <trap+0x60>
80105cb3:	e8 c8 de ff ff       	call   80103b80 <myproc>
80105cb8:	8b 50 24             	mov    0x24(%eax),%edx
80105cbb:	85 d2                	test   %edx,%edx
80105cbd:	74 11                	je     80105cd0 <trap+0x60>
80105cbf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cc3:	83 e0 03             	and    $0x3,%eax
80105cc6:	66 83 f8 03          	cmp    $0x3,%ax
80105cca:	0f 84 e8 01 00 00    	je     80105eb8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cd0:	e8 ab de ff ff       	call   80103b80 <myproc>
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	74 0f                	je     80105ce8 <trap+0x78>
80105cd9:	e8 a2 de ff ff       	call   80103b80 <myproc>
80105cde:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ce2:	0f 84 b8 00 00 00    	je     80105da0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ce8:	e8 93 de ff ff       	call   80103b80 <myproc>
80105ced:	85 c0                	test   %eax,%eax
80105cef:	74 1d                	je     80105d0e <trap+0x9e>
80105cf1:	e8 8a de ff ff       	call   80103b80 <myproc>
80105cf6:	8b 40 24             	mov    0x24(%eax),%eax
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 11                	je     80105d0e <trap+0x9e>
80105cfd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d01:	83 e0 03             	and    $0x3,%eax
80105d04:	66 83 f8 03          	cmp    $0x3,%ax
80105d08:	0f 84 0f 01 00 00    	je     80105e1d <trap+0x1ad>
    exit();
}
80105d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d11:	5b                   	pop    %ebx
80105d12:	5e                   	pop    %esi
80105d13:	5f                   	pop    %edi
80105d14:	5d                   	pop    %ebp
80105d15:	c3                   	ret    
80105d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d20:	e8 5b de ff ff       	call   80103b80 <myproc>
80105d25:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d28:	85 c0                	test   %eax,%eax
80105d2a:	0f 84 a2 01 00 00    	je     80105ed2 <trap+0x262>
80105d30:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d34:	0f 84 98 01 00 00    	je     80105ed2 <trap+0x262>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d3a:	0f 20 d1             	mov    %cr2,%ecx
80105d3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d40:	e8 1b de ff ff       	call   80103b60 <cpuid>
80105d45:	8b 73 30             	mov    0x30(%ebx),%esi
80105d48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d4b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d51:	e8 2a de ff ff       	call   80103b80 <myproc>
80105d56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d59:	e8 22 de ff ff       	call   80103b80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d64:	51                   	push   %ecx
80105d65:	57                   	push   %edi
80105d66:	52                   	push   %edx
80105d67:	ff 75 e4             	push   -0x1c(%ebp)
80105d6a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d6b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d6e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d71:	56                   	push   %esi
80105d72:	ff 70 10             	push   0x10(%eax)
80105d75:	68 fc 7c 10 80       	push   $0x80107cfc
80105d7a:	e8 11 a9 ff ff       	call   80100690 <cprintf>
    myproc()->killed = 1;
80105d7f:	83 c4 20             	add    $0x20,%esp
80105d82:	e8 f9 dd ff ff       	call   80103b80 <myproc>
80105d87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d8e:	e8 ed dd ff ff       	call   80103b80 <myproc>
80105d93:	85 c0                	test   %eax,%eax
80105d95:	0f 85 18 ff ff ff    	jne    80105cb3 <trap+0x43>
80105d9b:	e9 30 ff ff ff       	jmp    80105cd0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105da0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105da4:	0f 85 3e ff ff ff    	jne    80105ce8 <trap+0x78>
    yield();
80105daa:	e8 71 e4 ff ff       	call   80104220 <yield>
80105daf:	e9 34 ff ff ff       	jmp    80105ce8 <trap+0x78>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105db8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dbb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105dbf:	e8 9c dd ff ff       	call   80103b60 <cpuid>
80105dc4:	57                   	push   %edi
80105dc5:	56                   	push   %esi
80105dc6:	50                   	push   %eax
80105dc7:	68 a4 7c 10 80       	push   $0x80107ca4
80105dcc:	e8 bf a8 ff ff       	call   80100690 <cprintf>
    lapiceoi();
80105dd1:	e8 da cc ff ff       	call   80102ab0 <lapiceoi>
    break;
80105dd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd9:	e8 a2 dd ff ff       	call   80103b80 <myproc>
80105dde:	85 c0                	test   %eax,%eax
80105de0:	0f 85 cd fe ff ff    	jne    80105cb3 <trap+0x43>
80105de6:	e9 e5 fe ff ff       	jmp    80105cd0 <trap+0x60>
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
    if(myproc()->killed)
80105df0:	e8 8b dd ff ff       	call   80103b80 <myproc>
80105df5:	8b 70 24             	mov    0x24(%eax),%esi
80105df8:	85 f6                	test   %esi,%esi
80105dfa:	0f 85 c8 00 00 00    	jne    80105ec8 <trap+0x258>
    myproc()->tf = tf;
80105e00:	e8 7b dd ff ff       	call   80103b80 <myproc>
80105e05:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e08:	e8 13 ef ff ff       	call   80104d20 <syscall>
    if(myproc()->killed)
80105e0d:	e8 6e dd ff ff       	call   80103b80 <myproc>
80105e12:	8b 48 24             	mov    0x24(%eax),%ecx
80105e15:	85 c9                	test   %ecx,%ecx
80105e17:	0f 84 f1 fe ff ff    	je     80105d0e <trap+0x9e>
}
80105e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e20:	5b                   	pop    %ebx
80105e21:	5e                   	pop    %esi
80105e22:	5f                   	pop    %edi
80105e23:	5d                   	pop    %ebp
      exit();
80105e24:	e9 97 e1 ff ff       	jmp    80103fc0 <exit>
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e30:	e8 5b 02 00 00       	call   80106090 <uartintr>
    lapiceoi();
80105e35:	e8 76 cc ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3a:	e8 41 dd ff ff       	call   80103b80 <myproc>
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	0f 85 6c fe ff ff    	jne    80105cb3 <trap+0x43>
80105e47:	e9 84 fe ff ff       	jmp    80105cd0 <trap+0x60>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e50:	e8 1b cb ff ff       	call   80102970 <kbdintr>
    lapiceoi();
80105e55:	e8 56 cc ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e5a:	e8 21 dd ff ff       	call   80103b80 <myproc>
80105e5f:	85 c0                	test   %eax,%eax
80105e61:	0f 85 4c fe ff ff    	jne    80105cb3 <trap+0x43>
80105e67:	e9 64 fe ff ff       	jmp    80105cd0 <trap+0x60>
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105e70:	e8 eb dc ff ff       	call   80103b60 <cpuid>
80105e75:	85 c0                	test   %eax,%eax
80105e77:	0f 85 28 fe ff ff    	jne    80105ca5 <trap+0x35>
      acquire(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 80 3c 11 80       	push   $0x80113c80
80105e85:	e8 a6 e9 ff ff       	call   80104830 <acquire>
      wakeup(&ticks);
80105e8a:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
      ticks++;
80105e91:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105e98:	e8 93 e4 ff ff       	call   80104330 <wakeup>
      release(&tickslock);
80105e9d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105ea4:	e8 17 e9 ff ff       	call   801047c0 <release>
80105ea9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105eac:	e9 f4 fd ff ff       	jmp    80105ca5 <trap+0x35>
80105eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105eb8:	e8 03 e1 ff ff       	call   80103fc0 <exit>
80105ebd:	e9 0e fe ff ff       	jmp    80105cd0 <trap+0x60>
80105ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ec8:	e8 f3 e0 ff ff       	call   80103fc0 <exit>
80105ecd:	e9 2e ff ff ff       	jmp    80105e00 <trap+0x190>
80105ed2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ed5:	e8 86 dc ff ff       	call   80103b60 <cpuid>
80105eda:	83 ec 0c             	sub    $0xc,%esp
80105edd:	56                   	push   %esi
80105ede:	57                   	push   %edi
80105edf:	50                   	push   %eax
80105ee0:	ff 73 30             	push   0x30(%ebx)
80105ee3:	68 c8 7c 10 80       	push   $0x80107cc8
80105ee8:	e8 a3 a7 ff ff       	call   80100690 <cprintf>
      panic("trap");
80105eed:	83 c4 14             	add    $0x14,%esp
80105ef0:	68 9e 7c 10 80       	push   $0x80107c9e
80105ef5:	e8 96 a4 ff ff       	call   80100390 <panic>
80105efa:	66 90                	xchg   %ax,%ax
80105efc:	66 90                	xchg   %ax,%ax
80105efe:	66 90                	xchg   %ax,%ax

80105f00 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105f00:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105f04:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	74 1b                	je     80105f28 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f0d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f12:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f13:	a8 01                	test   $0x1,%al
80105f15:	74 11                	je     80105f28 <uartgetc+0x28>
80105f17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f1d:	0f b6 c0             	movzbl %al,%eax
80105f20:	c3                   	ret    
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f2d:	c3                   	ret    
80105f2e:	66 90                	xchg   %ax,%ax

80105f30 <uartinit>:
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f35:	31 c9                	xor    %ecx,%ecx
80105f37:	89 c8                	mov    %ecx,%eax
80105f39:	89 e5                	mov    %esp,%ebp
80105f3b:	57                   	push   %edi
80105f3c:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f41:	56                   	push   %esi
80105f42:	89 fa                	mov    %edi,%edx
80105f44:	53                   	push   %ebx
80105f45:	83 ec 1c             	sub    $0x1c,%esp
80105f48:	ee                   	out    %al,(%dx)
80105f49:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f4e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f53:	89 f2                	mov    %esi,%edx
80105f55:	ee                   	out    %al,(%dx)
80105f56:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f5b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f60:	ee                   	out    %al,(%dx)
80105f61:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f66:	89 c8                	mov    %ecx,%eax
80105f68:	89 da                	mov    %ebx,%edx
80105f6a:	ee                   	out    %al,(%dx)
80105f6b:	b8 03 00 00 00       	mov    $0x3,%eax
80105f70:	89 f2                	mov    %esi,%edx
80105f72:	ee                   	out    %al,(%dx)
80105f73:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f78:	89 c8                	mov    %ecx,%eax
80105f7a:	ee                   	out    %al,(%dx)
80105f7b:	b8 01 00 00 00       	mov    $0x1,%eax
80105f80:	89 da                	mov    %ebx,%edx
80105f82:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f83:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f88:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f89:	3c ff                	cmp    $0xff,%al
80105f8b:	0f 84 8f 00 00 00    	je     80106020 <uartinit+0xf0>
  uart = 1;
80105f91:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105f98:	00 00 00 
80105f9b:	89 fa                	mov    %edi,%edx
80105f9d:	ec                   	in     (%dx),%al
80105f9e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fa3:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fa4:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fa7:	bf c0 7d 10 80       	mov    $0x80107dc0,%edi
80105fac:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105fb1:	6a 00                	push   $0x0
80105fb3:	6a 04                	push   $0x4
80105fb5:	e8 66 c6 ff ff       	call   80102620 <ioapicenable>
80105fba:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
80105fbe:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fc1:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80105fc5:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105fc8:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105fcd:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fd2:	85 c0                	test   %eax,%eax
80105fd4:	75 1c                	jne    80105ff2 <uartinit+0xc2>
80105fd6:	eb 2b                	jmp    80106003 <uartinit+0xd3>
80105fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fdf:	90                   	nop
    microdelay(10);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	6a 0a                	push   $0xa
80105fe5:	e8 e6 ca ff ff       	call   80102ad0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	83 eb 01             	sub    $0x1,%ebx
80105ff0:	74 07                	je     80105ff9 <uartinit+0xc9>
80105ff2:	89 f2                	mov    %esi,%edx
80105ff4:	ec                   	in     (%dx),%al
80105ff5:	a8 20                	test   $0x20,%al
80105ff7:	74 e7                	je     80105fe0 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff9:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80105ffd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106002:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106003:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106007:	83 c7 01             	add    $0x1,%edi
8010600a:	84 c0                	test   %al,%al
8010600c:	74 12                	je     80106020 <uartinit+0xf0>
8010600e:	88 45 e6             	mov    %al,-0x1a(%ebp)
80106011:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106015:	88 45 e7             	mov    %al,-0x19(%ebp)
80106018:	eb ae                	jmp    80105fc8 <uartinit+0x98>
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106023:	5b                   	pop    %ebx
80106024:	5e                   	pop    %esi
80106025:	5f                   	pop    %edi
80106026:	5d                   	pop    %ebp
80106027:	c3                   	ret    
80106028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop

80106030 <uartputc>:
{
80106030:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106034:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80106039:	85 c0                	test   %eax,%eax
8010603b:	74 43                	je     80106080 <uartputc+0x50>
{
8010603d:	55                   	push   %ebp
8010603e:	89 e5                	mov    %esp,%ebp
80106040:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106041:	be fd 03 00 00       	mov    $0x3fd,%esi
80106046:	53                   	push   %ebx
80106047:	bb 80 00 00 00       	mov    $0x80,%ebx
8010604c:	eb 14                	jmp    80106062 <uartputc+0x32>
8010604e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	6a 0a                	push   $0xa
80106055:	e8 76 ca ff ff       	call   80102ad0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	83 eb 01             	sub    $0x1,%ebx
80106060:	74 07                	je     80106069 <uartputc+0x39>
80106062:	89 f2                	mov    %esi,%edx
80106064:	ec                   	in     (%dx),%al
80106065:	a8 20                	test   $0x20,%al
80106067:	74 e7                	je     80106050 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106069:	8b 45 08             	mov    0x8(%ebp),%eax
8010606c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106071:	ee                   	out    %al,(%dx)
}
80106072:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106075:	5b                   	pop    %ebx
80106076:	5e                   	pop    %esi
80106077:	5d                   	pop    %ebp
80106078:	c3                   	ret    
80106079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106080:	c3                   	ret    
80106081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608f:	90                   	nop

80106090 <uartintr>:

void
uartintr(void)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010609a:	68 00 5f 10 80       	push   $0x80105f00
8010609f:	e8 5c a8 ff ff       	call   80100900 <consoleintr>
}
801060a4:	83 c4 10             	add    $0x10,%esp
801060a7:	c9                   	leave  
801060a8:	c3                   	ret    

801060a9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $0
801060ab:	6a 00                	push   $0x0
  jmp alltraps
801060ad:	e9 dc fa ff ff       	jmp    80105b8e <alltraps>

801060b2 <vector1>:
.globl vector1
vector1:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $1
801060b4:	6a 01                	push   $0x1
  jmp alltraps
801060b6:	e9 d3 fa ff ff       	jmp    80105b8e <alltraps>

801060bb <vector2>:
.globl vector2
vector2:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $2
801060bd:	6a 02                	push   $0x2
  jmp alltraps
801060bf:	e9 ca fa ff ff       	jmp    80105b8e <alltraps>

801060c4 <vector3>:
.globl vector3
vector3:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $3
801060c6:	6a 03                	push   $0x3
  jmp alltraps
801060c8:	e9 c1 fa ff ff       	jmp    80105b8e <alltraps>

801060cd <vector4>:
.globl vector4
vector4:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $4
801060cf:	6a 04                	push   $0x4
  jmp alltraps
801060d1:	e9 b8 fa ff ff       	jmp    80105b8e <alltraps>

801060d6 <vector5>:
.globl vector5
vector5:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $5
801060d8:	6a 05                	push   $0x5
  jmp alltraps
801060da:	e9 af fa ff ff       	jmp    80105b8e <alltraps>

801060df <vector6>:
.globl vector6
vector6:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $6
801060e1:	6a 06                	push   $0x6
  jmp alltraps
801060e3:	e9 a6 fa ff ff       	jmp    80105b8e <alltraps>

801060e8 <vector7>:
.globl vector7
vector7:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $7
801060ea:	6a 07                	push   $0x7
  jmp alltraps
801060ec:	e9 9d fa ff ff       	jmp    80105b8e <alltraps>

801060f1 <vector8>:
.globl vector8
vector8:
  pushl $8
801060f1:	6a 08                	push   $0x8
  jmp alltraps
801060f3:	e9 96 fa ff ff       	jmp    80105b8e <alltraps>

801060f8 <vector9>:
.globl vector9
vector9:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $9
801060fa:	6a 09                	push   $0x9
  jmp alltraps
801060fc:	e9 8d fa ff ff       	jmp    80105b8e <alltraps>

80106101 <vector10>:
.globl vector10
vector10:
  pushl $10
80106101:	6a 0a                	push   $0xa
  jmp alltraps
80106103:	e9 86 fa ff ff       	jmp    80105b8e <alltraps>

80106108 <vector11>:
.globl vector11
vector11:
  pushl $11
80106108:	6a 0b                	push   $0xb
  jmp alltraps
8010610a:	e9 7f fa ff ff       	jmp    80105b8e <alltraps>

8010610f <vector12>:
.globl vector12
vector12:
  pushl $12
8010610f:	6a 0c                	push   $0xc
  jmp alltraps
80106111:	e9 78 fa ff ff       	jmp    80105b8e <alltraps>

80106116 <vector13>:
.globl vector13
vector13:
  pushl $13
80106116:	6a 0d                	push   $0xd
  jmp alltraps
80106118:	e9 71 fa ff ff       	jmp    80105b8e <alltraps>

8010611d <vector14>:
.globl vector14
vector14:
  pushl $14
8010611d:	6a 0e                	push   $0xe
  jmp alltraps
8010611f:	e9 6a fa ff ff       	jmp    80105b8e <alltraps>

80106124 <vector15>:
.globl vector15
vector15:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $15
80106126:	6a 0f                	push   $0xf
  jmp alltraps
80106128:	e9 61 fa ff ff       	jmp    80105b8e <alltraps>

8010612d <vector16>:
.globl vector16
vector16:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $16
8010612f:	6a 10                	push   $0x10
  jmp alltraps
80106131:	e9 58 fa ff ff       	jmp    80105b8e <alltraps>

80106136 <vector17>:
.globl vector17
vector17:
  pushl $17
80106136:	6a 11                	push   $0x11
  jmp alltraps
80106138:	e9 51 fa ff ff       	jmp    80105b8e <alltraps>

8010613d <vector18>:
.globl vector18
vector18:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $18
8010613f:	6a 12                	push   $0x12
  jmp alltraps
80106141:	e9 48 fa ff ff       	jmp    80105b8e <alltraps>

80106146 <vector19>:
.globl vector19
vector19:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $19
80106148:	6a 13                	push   $0x13
  jmp alltraps
8010614a:	e9 3f fa ff ff       	jmp    80105b8e <alltraps>

8010614f <vector20>:
.globl vector20
vector20:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $20
80106151:	6a 14                	push   $0x14
  jmp alltraps
80106153:	e9 36 fa ff ff       	jmp    80105b8e <alltraps>

80106158 <vector21>:
.globl vector21
vector21:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $21
8010615a:	6a 15                	push   $0x15
  jmp alltraps
8010615c:	e9 2d fa ff ff       	jmp    80105b8e <alltraps>

80106161 <vector22>:
.globl vector22
vector22:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $22
80106163:	6a 16                	push   $0x16
  jmp alltraps
80106165:	e9 24 fa ff ff       	jmp    80105b8e <alltraps>

8010616a <vector23>:
.globl vector23
vector23:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $23
8010616c:	6a 17                	push   $0x17
  jmp alltraps
8010616e:	e9 1b fa ff ff       	jmp    80105b8e <alltraps>

80106173 <vector24>:
.globl vector24
vector24:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $24
80106175:	6a 18                	push   $0x18
  jmp alltraps
80106177:	e9 12 fa ff ff       	jmp    80105b8e <alltraps>

8010617c <vector25>:
.globl vector25
vector25:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $25
8010617e:	6a 19                	push   $0x19
  jmp alltraps
80106180:	e9 09 fa ff ff       	jmp    80105b8e <alltraps>

80106185 <vector26>:
.globl vector26
vector26:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $26
80106187:	6a 1a                	push   $0x1a
  jmp alltraps
80106189:	e9 00 fa ff ff       	jmp    80105b8e <alltraps>

8010618e <vector27>:
.globl vector27
vector27:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $27
80106190:	6a 1b                	push   $0x1b
  jmp alltraps
80106192:	e9 f7 f9 ff ff       	jmp    80105b8e <alltraps>

80106197 <vector28>:
.globl vector28
vector28:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $28
80106199:	6a 1c                	push   $0x1c
  jmp alltraps
8010619b:	e9 ee f9 ff ff       	jmp    80105b8e <alltraps>

801061a0 <vector29>:
.globl vector29
vector29:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $29
801061a2:	6a 1d                	push   $0x1d
  jmp alltraps
801061a4:	e9 e5 f9 ff ff       	jmp    80105b8e <alltraps>

801061a9 <vector30>:
.globl vector30
vector30:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $30
801061ab:	6a 1e                	push   $0x1e
  jmp alltraps
801061ad:	e9 dc f9 ff ff       	jmp    80105b8e <alltraps>

801061b2 <vector31>:
.globl vector31
vector31:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $31
801061b4:	6a 1f                	push   $0x1f
  jmp alltraps
801061b6:	e9 d3 f9 ff ff       	jmp    80105b8e <alltraps>

801061bb <vector32>:
.globl vector32
vector32:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $32
801061bd:	6a 20                	push   $0x20
  jmp alltraps
801061bf:	e9 ca f9 ff ff       	jmp    80105b8e <alltraps>

801061c4 <vector33>:
.globl vector33
vector33:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $33
801061c6:	6a 21                	push   $0x21
  jmp alltraps
801061c8:	e9 c1 f9 ff ff       	jmp    80105b8e <alltraps>

801061cd <vector34>:
.globl vector34
vector34:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $34
801061cf:	6a 22                	push   $0x22
  jmp alltraps
801061d1:	e9 b8 f9 ff ff       	jmp    80105b8e <alltraps>

801061d6 <vector35>:
.globl vector35
vector35:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $35
801061d8:	6a 23                	push   $0x23
  jmp alltraps
801061da:	e9 af f9 ff ff       	jmp    80105b8e <alltraps>

801061df <vector36>:
.globl vector36
vector36:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $36
801061e1:	6a 24                	push   $0x24
  jmp alltraps
801061e3:	e9 a6 f9 ff ff       	jmp    80105b8e <alltraps>

801061e8 <vector37>:
.globl vector37
vector37:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $37
801061ea:	6a 25                	push   $0x25
  jmp alltraps
801061ec:	e9 9d f9 ff ff       	jmp    80105b8e <alltraps>

801061f1 <vector38>:
.globl vector38
vector38:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $38
801061f3:	6a 26                	push   $0x26
  jmp alltraps
801061f5:	e9 94 f9 ff ff       	jmp    80105b8e <alltraps>

801061fa <vector39>:
.globl vector39
vector39:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $39
801061fc:	6a 27                	push   $0x27
  jmp alltraps
801061fe:	e9 8b f9 ff ff       	jmp    80105b8e <alltraps>

80106203 <vector40>:
.globl vector40
vector40:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $40
80106205:	6a 28                	push   $0x28
  jmp alltraps
80106207:	e9 82 f9 ff ff       	jmp    80105b8e <alltraps>

8010620c <vector41>:
.globl vector41
vector41:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $41
8010620e:	6a 29                	push   $0x29
  jmp alltraps
80106210:	e9 79 f9 ff ff       	jmp    80105b8e <alltraps>

80106215 <vector42>:
.globl vector42
vector42:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $42
80106217:	6a 2a                	push   $0x2a
  jmp alltraps
80106219:	e9 70 f9 ff ff       	jmp    80105b8e <alltraps>

8010621e <vector43>:
.globl vector43
vector43:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $43
80106220:	6a 2b                	push   $0x2b
  jmp alltraps
80106222:	e9 67 f9 ff ff       	jmp    80105b8e <alltraps>

80106227 <vector44>:
.globl vector44
vector44:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $44
80106229:	6a 2c                	push   $0x2c
  jmp alltraps
8010622b:	e9 5e f9 ff ff       	jmp    80105b8e <alltraps>

80106230 <vector45>:
.globl vector45
vector45:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $45
80106232:	6a 2d                	push   $0x2d
  jmp alltraps
80106234:	e9 55 f9 ff ff       	jmp    80105b8e <alltraps>

80106239 <vector46>:
.globl vector46
vector46:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $46
8010623b:	6a 2e                	push   $0x2e
  jmp alltraps
8010623d:	e9 4c f9 ff ff       	jmp    80105b8e <alltraps>

80106242 <vector47>:
.globl vector47
vector47:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $47
80106244:	6a 2f                	push   $0x2f
  jmp alltraps
80106246:	e9 43 f9 ff ff       	jmp    80105b8e <alltraps>

8010624b <vector48>:
.globl vector48
vector48:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $48
8010624d:	6a 30                	push   $0x30
  jmp alltraps
8010624f:	e9 3a f9 ff ff       	jmp    80105b8e <alltraps>

80106254 <vector49>:
.globl vector49
vector49:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $49
80106256:	6a 31                	push   $0x31
  jmp alltraps
80106258:	e9 31 f9 ff ff       	jmp    80105b8e <alltraps>

8010625d <vector50>:
.globl vector50
vector50:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $50
8010625f:	6a 32                	push   $0x32
  jmp alltraps
80106261:	e9 28 f9 ff ff       	jmp    80105b8e <alltraps>

80106266 <vector51>:
.globl vector51
vector51:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $51
80106268:	6a 33                	push   $0x33
  jmp alltraps
8010626a:	e9 1f f9 ff ff       	jmp    80105b8e <alltraps>

8010626f <vector52>:
.globl vector52
vector52:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $52
80106271:	6a 34                	push   $0x34
  jmp alltraps
80106273:	e9 16 f9 ff ff       	jmp    80105b8e <alltraps>

80106278 <vector53>:
.globl vector53
vector53:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $53
8010627a:	6a 35                	push   $0x35
  jmp alltraps
8010627c:	e9 0d f9 ff ff       	jmp    80105b8e <alltraps>

80106281 <vector54>:
.globl vector54
vector54:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $54
80106283:	6a 36                	push   $0x36
  jmp alltraps
80106285:	e9 04 f9 ff ff       	jmp    80105b8e <alltraps>

8010628a <vector55>:
.globl vector55
vector55:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $55
8010628c:	6a 37                	push   $0x37
  jmp alltraps
8010628e:	e9 fb f8 ff ff       	jmp    80105b8e <alltraps>

80106293 <vector56>:
.globl vector56
vector56:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $56
80106295:	6a 38                	push   $0x38
  jmp alltraps
80106297:	e9 f2 f8 ff ff       	jmp    80105b8e <alltraps>

8010629c <vector57>:
.globl vector57
vector57:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $57
8010629e:	6a 39                	push   $0x39
  jmp alltraps
801062a0:	e9 e9 f8 ff ff       	jmp    80105b8e <alltraps>

801062a5 <vector58>:
.globl vector58
vector58:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $58
801062a7:	6a 3a                	push   $0x3a
  jmp alltraps
801062a9:	e9 e0 f8 ff ff       	jmp    80105b8e <alltraps>

801062ae <vector59>:
.globl vector59
vector59:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $59
801062b0:	6a 3b                	push   $0x3b
  jmp alltraps
801062b2:	e9 d7 f8 ff ff       	jmp    80105b8e <alltraps>

801062b7 <vector60>:
.globl vector60
vector60:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $60
801062b9:	6a 3c                	push   $0x3c
  jmp alltraps
801062bb:	e9 ce f8 ff ff       	jmp    80105b8e <alltraps>

801062c0 <vector61>:
.globl vector61
vector61:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $61
801062c2:	6a 3d                	push   $0x3d
  jmp alltraps
801062c4:	e9 c5 f8 ff ff       	jmp    80105b8e <alltraps>

801062c9 <vector62>:
.globl vector62
vector62:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $62
801062cb:	6a 3e                	push   $0x3e
  jmp alltraps
801062cd:	e9 bc f8 ff ff       	jmp    80105b8e <alltraps>

801062d2 <vector63>:
.globl vector63
vector63:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $63
801062d4:	6a 3f                	push   $0x3f
  jmp alltraps
801062d6:	e9 b3 f8 ff ff       	jmp    80105b8e <alltraps>

801062db <vector64>:
.globl vector64
vector64:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $64
801062dd:	6a 40                	push   $0x40
  jmp alltraps
801062df:	e9 aa f8 ff ff       	jmp    80105b8e <alltraps>

801062e4 <vector65>:
.globl vector65
vector65:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $65
801062e6:	6a 41                	push   $0x41
  jmp alltraps
801062e8:	e9 a1 f8 ff ff       	jmp    80105b8e <alltraps>

801062ed <vector66>:
.globl vector66
vector66:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $66
801062ef:	6a 42                	push   $0x42
  jmp alltraps
801062f1:	e9 98 f8 ff ff       	jmp    80105b8e <alltraps>

801062f6 <vector67>:
.globl vector67
vector67:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $67
801062f8:	6a 43                	push   $0x43
  jmp alltraps
801062fa:	e9 8f f8 ff ff       	jmp    80105b8e <alltraps>

801062ff <vector68>:
.globl vector68
vector68:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $68
80106301:	6a 44                	push   $0x44
  jmp alltraps
80106303:	e9 86 f8 ff ff       	jmp    80105b8e <alltraps>

80106308 <vector69>:
.globl vector69
vector69:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $69
8010630a:	6a 45                	push   $0x45
  jmp alltraps
8010630c:	e9 7d f8 ff ff       	jmp    80105b8e <alltraps>

80106311 <vector70>:
.globl vector70
vector70:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $70
80106313:	6a 46                	push   $0x46
  jmp alltraps
80106315:	e9 74 f8 ff ff       	jmp    80105b8e <alltraps>

8010631a <vector71>:
.globl vector71
vector71:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $71
8010631c:	6a 47                	push   $0x47
  jmp alltraps
8010631e:	e9 6b f8 ff ff       	jmp    80105b8e <alltraps>

80106323 <vector72>:
.globl vector72
vector72:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $72
80106325:	6a 48                	push   $0x48
  jmp alltraps
80106327:	e9 62 f8 ff ff       	jmp    80105b8e <alltraps>

8010632c <vector73>:
.globl vector73
vector73:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $73
8010632e:	6a 49                	push   $0x49
  jmp alltraps
80106330:	e9 59 f8 ff ff       	jmp    80105b8e <alltraps>

80106335 <vector74>:
.globl vector74
vector74:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $74
80106337:	6a 4a                	push   $0x4a
  jmp alltraps
80106339:	e9 50 f8 ff ff       	jmp    80105b8e <alltraps>

8010633e <vector75>:
.globl vector75
vector75:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $75
80106340:	6a 4b                	push   $0x4b
  jmp alltraps
80106342:	e9 47 f8 ff ff       	jmp    80105b8e <alltraps>

80106347 <vector76>:
.globl vector76
vector76:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $76
80106349:	6a 4c                	push   $0x4c
  jmp alltraps
8010634b:	e9 3e f8 ff ff       	jmp    80105b8e <alltraps>

80106350 <vector77>:
.globl vector77
vector77:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $77
80106352:	6a 4d                	push   $0x4d
  jmp alltraps
80106354:	e9 35 f8 ff ff       	jmp    80105b8e <alltraps>

80106359 <vector78>:
.globl vector78
vector78:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $78
8010635b:	6a 4e                	push   $0x4e
  jmp alltraps
8010635d:	e9 2c f8 ff ff       	jmp    80105b8e <alltraps>

80106362 <vector79>:
.globl vector79
vector79:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $79
80106364:	6a 4f                	push   $0x4f
  jmp alltraps
80106366:	e9 23 f8 ff ff       	jmp    80105b8e <alltraps>

8010636b <vector80>:
.globl vector80
vector80:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $80
8010636d:	6a 50                	push   $0x50
  jmp alltraps
8010636f:	e9 1a f8 ff ff       	jmp    80105b8e <alltraps>

80106374 <vector81>:
.globl vector81
vector81:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $81
80106376:	6a 51                	push   $0x51
  jmp alltraps
80106378:	e9 11 f8 ff ff       	jmp    80105b8e <alltraps>

8010637d <vector82>:
.globl vector82
vector82:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $82
8010637f:	6a 52                	push   $0x52
  jmp alltraps
80106381:	e9 08 f8 ff ff       	jmp    80105b8e <alltraps>

80106386 <vector83>:
.globl vector83
vector83:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $83
80106388:	6a 53                	push   $0x53
  jmp alltraps
8010638a:	e9 ff f7 ff ff       	jmp    80105b8e <alltraps>

8010638f <vector84>:
.globl vector84
vector84:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $84
80106391:	6a 54                	push   $0x54
  jmp alltraps
80106393:	e9 f6 f7 ff ff       	jmp    80105b8e <alltraps>

80106398 <vector85>:
.globl vector85
vector85:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $85
8010639a:	6a 55                	push   $0x55
  jmp alltraps
8010639c:	e9 ed f7 ff ff       	jmp    80105b8e <alltraps>

801063a1 <vector86>:
.globl vector86
vector86:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $86
801063a3:	6a 56                	push   $0x56
  jmp alltraps
801063a5:	e9 e4 f7 ff ff       	jmp    80105b8e <alltraps>

801063aa <vector87>:
.globl vector87
vector87:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $87
801063ac:	6a 57                	push   $0x57
  jmp alltraps
801063ae:	e9 db f7 ff ff       	jmp    80105b8e <alltraps>

801063b3 <vector88>:
.globl vector88
vector88:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $88
801063b5:	6a 58                	push   $0x58
  jmp alltraps
801063b7:	e9 d2 f7 ff ff       	jmp    80105b8e <alltraps>

801063bc <vector89>:
.globl vector89
vector89:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $89
801063be:	6a 59                	push   $0x59
  jmp alltraps
801063c0:	e9 c9 f7 ff ff       	jmp    80105b8e <alltraps>

801063c5 <vector90>:
.globl vector90
vector90:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $90
801063c7:	6a 5a                	push   $0x5a
  jmp alltraps
801063c9:	e9 c0 f7 ff ff       	jmp    80105b8e <alltraps>

801063ce <vector91>:
.globl vector91
vector91:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $91
801063d0:	6a 5b                	push   $0x5b
  jmp alltraps
801063d2:	e9 b7 f7 ff ff       	jmp    80105b8e <alltraps>

801063d7 <vector92>:
.globl vector92
vector92:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $92
801063d9:	6a 5c                	push   $0x5c
  jmp alltraps
801063db:	e9 ae f7 ff ff       	jmp    80105b8e <alltraps>

801063e0 <vector93>:
.globl vector93
vector93:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $93
801063e2:	6a 5d                	push   $0x5d
  jmp alltraps
801063e4:	e9 a5 f7 ff ff       	jmp    80105b8e <alltraps>

801063e9 <vector94>:
.globl vector94
vector94:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $94
801063eb:	6a 5e                	push   $0x5e
  jmp alltraps
801063ed:	e9 9c f7 ff ff       	jmp    80105b8e <alltraps>

801063f2 <vector95>:
.globl vector95
vector95:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $95
801063f4:	6a 5f                	push   $0x5f
  jmp alltraps
801063f6:	e9 93 f7 ff ff       	jmp    80105b8e <alltraps>

801063fb <vector96>:
.globl vector96
vector96:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $96
801063fd:	6a 60                	push   $0x60
  jmp alltraps
801063ff:	e9 8a f7 ff ff       	jmp    80105b8e <alltraps>

80106404 <vector97>:
.globl vector97
vector97:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $97
80106406:	6a 61                	push   $0x61
  jmp alltraps
80106408:	e9 81 f7 ff ff       	jmp    80105b8e <alltraps>

8010640d <vector98>:
.globl vector98
vector98:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $98
8010640f:	6a 62                	push   $0x62
  jmp alltraps
80106411:	e9 78 f7 ff ff       	jmp    80105b8e <alltraps>

80106416 <vector99>:
.globl vector99
vector99:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $99
80106418:	6a 63                	push   $0x63
  jmp alltraps
8010641a:	e9 6f f7 ff ff       	jmp    80105b8e <alltraps>

8010641f <vector100>:
.globl vector100
vector100:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $100
80106421:	6a 64                	push   $0x64
  jmp alltraps
80106423:	e9 66 f7 ff ff       	jmp    80105b8e <alltraps>

80106428 <vector101>:
.globl vector101
vector101:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $101
8010642a:	6a 65                	push   $0x65
  jmp alltraps
8010642c:	e9 5d f7 ff ff       	jmp    80105b8e <alltraps>

80106431 <vector102>:
.globl vector102
vector102:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $102
80106433:	6a 66                	push   $0x66
  jmp alltraps
80106435:	e9 54 f7 ff ff       	jmp    80105b8e <alltraps>

8010643a <vector103>:
.globl vector103
vector103:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $103
8010643c:	6a 67                	push   $0x67
  jmp alltraps
8010643e:	e9 4b f7 ff ff       	jmp    80105b8e <alltraps>

80106443 <vector104>:
.globl vector104
vector104:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $104
80106445:	6a 68                	push   $0x68
  jmp alltraps
80106447:	e9 42 f7 ff ff       	jmp    80105b8e <alltraps>

8010644c <vector105>:
.globl vector105
vector105:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $105
8010644e:	6a 69                	push   $0x69
  jmp alltraps
80106450:	e9 39 f7 ff ff       	jmp    80105b8e <alltraps>

80106455 <vector106>:
.globl vector106
vector106:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $106
80106457:	6a 6a                	push   $0x6a
  jmp alltraps
80106459:	e9 30 f7 ff ff       	jmp    80105b8e <alltraps>

8010645e <vector107>:
.globl vector107
vector107:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $107
80106460:	6a 6b                	push   $0x6b
  jmp alltraps
80106462:	e9 27 f7 ff ff       	jmp    80105b8e <alltraps>

80106467 <vector108>:
.globl vector108
vector108:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $108
80106469:	6a 6c                	push   $0x6c
  jmp alltraps
8010646b:	e9 1e f7 ff ff       	jmp    80105b8e <alltraps>

80106470 <vector109>:
.globl vector109
vector109:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $109
80106472:	6a 6d                	push   $0x6d
  jmp alltraps
80106474:	e9 15 f7 ff ff       	jmp    80105b8e <alltraps>

80106479 <vector110>:
.globl vector110
vector110:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $110
8010647b:	6a 6e                	push   $0x6e
  jmp alltraps
8010647d:	e9 0c f7 ff ff       	jmp    80105b8e <alltraps>

80106482 <vector111>:
.globl vector111
vector111:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $111
80106484:	6a 6f                	push   $0x6f
  jmp alltraps
80106486:	e9 03 f7 ff ff       	jmp    80105b8e <alltraps>

8010648b <vector112>:
.globl vector112
vector112:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $112
8010648d:	6a 70                	push   $0x70
  jmp alltraps
8010648f:	e9 fa f6 ff ff       	jmp    80105b8e <alltraps>

80106494 <vector113>:
.globl vector113
vector113:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $113
80106496:	6a 71                	push   $0x71
  jmp alltraps
80106498:	e9 f1 f6 ff ff       	jmp    80105b8e <alltraps>

8010649d <vector114>:
.globl vector114
vector114:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $114
8010649f:	6a 72                	push   $0x72
  jmp alltraps
801064a1:	e9 e8 f6 ff ff       	jmp    80105b8e <alltraps>

801064a6 <vector115>:
.globl vector115
vector115:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $115
801064a8:	6a 73                	push   $0x73
  jmp alltraps
801064aa:	e9 df f6 ff ff       	jmp    80105b8e <alltraps>

801064af <vector116>:
.globl vector116
vector116:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $116
801064b1:	6a 74                	push   $0x74
  jmp alltraps
801064b3:	e9 d6 f6 ff ff       	jmp    80105b8e <alltraps>

801064b8 <vector117>:
.globl vector117
vector117:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $117
801064ba:	6a 75                	push   $0x75
  jmp alltraps
801064bc:	e9 cd f6 ff ff       	jmp    80105b8e <alltraps>

801064c1 <vector118>:
.globl vector118
vector118:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $118
801064c3:	6a 76                	push   $0x76
  jmp alltraps
801064c5:	e9 c4 f6 ff ff       	jmp    80105b8e <alltraps>

801064ca <vector119>:
.globl vector119
vector119:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $119
801064cc:	6a 77                	push   $0x77
  jmp alltraps
801064ce:	e9 bb f6 ff ff       	jmp    80105b8e <alltraps>

801064d3 <vector120>:
.globl vector120
vector120:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $120
801064d5:	6a 78                	push   $0x78
  jmp alltraps
801064d7:	e9 b2 f6 ff ff       	jmp    80105b8e <alltraps>

801064dc <vector121>:
.globl vector121
vector121:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $121
801064de:	6a 79                	push   $0x79
  jmp alltraps
801064e0:	e9 a9 f6 ff ff       	jmp    80105b8e <alltraps>

801064e5 <vector122>:
.globl vector122
vector122:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $122
801064e7:	6a 7a                	push   $0x7a
  jmp alltraps
801064e9:	e9 a0 f6 ff ff       	jmp    80105b8e <alltraps>

801064ee <vector123>:
.globl vector123
vector123:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $123
801064f0:	6a 7b                	push   $0x7b
  jmp alltraps
801064f2:	e9 97 f6 ff ff       	jmp    80105b8e <alltraps>

801064f7 <vector124>:
.globl vector124
vector124:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $124
801064f9:	6a 7c                	push   $0x7c
  jmp alltraps
801064fb:	e9 8e f6 ff ff       	jmp    80105b8e <alltraps>

80106500 <vector125>:
.globl vector125
vector125:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $125
80106502:	6a 7d                	push   $0x7d
  jmp alltraps
80106504:	e9 85 f6 ff ff       	jmp    80105b8e <alltraps>

80106509 <vector126>:
.globl vector126
vector126:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $126
8010650b:	6a 7e                	push   $0x7e
  jmp alltraps
8010650d:	e9 7c f6 ff ff       	jmp    80105b8e <alltraps>

80106512 <vector127>:
.globl vector127
vector127:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $127
80106514:	6a 7f                	push   $0x7f
  jmp alltraps
80106516:	e9 73 f6 ff ff       	jmp    80105b8e <alltraps>

8010651b <vector128>:
.globl vector128
vector128:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $128
8010651d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106522:	e9 67 f6 ff ff       	jmp    80105b8e <alltraps>

80106527 <vector129>:
.globl vector129
vector129:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $129
80106529:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010652e:	e9 5b f6 ff ff       	jmp    80105b8e <alltraps>

80106533 <vector130>:
.globl vector130
vector130:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $130
80106535:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010653a:	e9 4f f6 ff ff       	jmp    80105b8e <alltraps>

8010653f <vector131>:
.globl vector131
vector131:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $131
80106541:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106546:	e9 43 f6 ff ff       	jmp    80105b8e <alltraps>

8010654b <vector132>:
.globl vector132
vector132:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $132
8010654d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106552:	e9 37 f6 ff ff       	jmp    80105b8e <alltraps>

80106557 <vector133>:
.globl vector133
vector133:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $133
80106559:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010655e:	e9 2b f6 ff ff       	jmp    80105b8e <alltraps>

80106563 <vector134>:
.globl vector134
vector134:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $134
80106565:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010656a:	e9 1f f6 ff ff       	jmp    80105b8e <alltraps>

8010656f <vector135>:
.globl vector135
vector135:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $135
80106571:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106576:	e9 13 f6 ff ff       	jmp    80105b8e <alltraps>

8010657b <vector136>:
.globl vector136
vector136:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $136
8010657d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106582:	e9 07 f6 ff ff       	jmp    80105b8e <alltraps>

80106587 <vector137>:
.globl vector137
vector137:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $137
80106589:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010658e:	e9 fb f5 ff ff       	jmp    80105b8e <alltraps>

80106593 <vector138>:
.globl vector138
vector138:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $138
80106595:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010659a:	e9 ef f5 ff ff       	jmp    80105b8e <alltraps>

8010659f <vector139>:
.globl vector139
vector139:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $139
801065a1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065a6:	e9 e3 f5 ff ff       	jmp    80105b8e <alltraps>

801065ab <vector140>:
.globl vector140
vector140:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $140
801065ad:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065b2:	e9 d7 f5 ff ff       	jmp    80105b8e <alltraps>

801065b7 <vector141>:
.globl vector141
vector141:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $141
801065b9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065be:	e9 cb f5 ff ff       	jmp    80105b8e <alltraps>

801065c3 <vector142>:
.globl vector142
vector142:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $142
801065c5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801065ca:	e9 bf f5 ff ff       	jmp    80105b8e <alltraps>

801065cf <vector143>:
.globl vector143
vector143:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $143
801065d1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065d6:	e9 b3 f5 ff ff       	jmp    80105b8e <alltraps>

801065db <vector144>:
.globl vector144
vector144:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $144
801065dd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065e2:	e9 a7 f5 ff ff       	jmp    80105b8e <alltraps>

801065e7 <vector145>:
.globl vector145
vector145:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $145
801065e9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ee:	e9 9b f5 ff ff       	jmp    80105b8e <alltraps>

801065f3 <vector146>:
.globl vector146
vector146:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $146
801065f5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065fa:	e9 8f f5 ff ff       	jmp    80105b8e <alltraps>

801065ff <vector147>:
.globl vector147
vector147:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $147
80106601:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106606:	e9 83 f5 ff ff       	jmp    80105b8e <alltraps>

8010660b <vector148>:
.globl vector148
vector148:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $148
8010660d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106612:	e9 77 f5 ff ff       	jmp    80105b8e <alltraps>

80106617 <vector149>:
.globl vector149
vector149:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $149
80106619:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010661e:	e9 6b f5 ff ff       	jmp    80105b8e <alltraps>

80106623 <vector150>:
.globl vector150
vector150:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $150
80106625:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010662a:	e9 5f f5 ff ff       	jmp    80105b8e <alltraps>

8010662f <vector151>:
.globl vector151
vector151:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $151
80106631:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106636:	e9 53 f5 ff ff       	jmp    80105b8e <alltraps>

8010663b <vector152>:
.globl vector152
vector152:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $152
8010663d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106642:	e9 47 f5 ff ff       	jmp    80105b8e <alltraps>

80106647 <vector153>:
.globl vector153
vector153:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $153
80106649:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010664e:	e9 3b f5 ff ff       	jmp    80105b8e <alltraps>

80106653 <vector154>:
.globl vector154
vector154:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $154
80106655:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010665a:	e9 2f f5 ff ff       	jmp    80105b8e <alltraps>

8010665f <vector155>:
.globl vector155
vector155:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $155
80106661:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106666:	e9 23 f5 ff ff       	jmp    80105b8e <alltraps>

8010666b <vector156>:
.globl vector156
vector156:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $156
8010666d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106672:	e9 17 f5 ff ff       	jmp    80105b8e <alltraps>

80106677 <vector157>:
.globl vector157
vector157:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $157
80106679:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010667e:	e9 0b f5 ff ff       	jmp    80105b8e <alltraps>

80106683 <vector158>:
.globl vector158
vector158:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $158
80106685:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010668a:	e9 ff f4 ff ff       	jmp    80105b8e <alltraps>

8010668f <vector159>:
.globl vector159
vector159:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $159
80106691:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106696:	e9 f3 f4 ff ff       	jmp    80105b8e <alltraps>

8010669b <vector160>:
.globl vector160
vector160:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $160
8010669d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066a2:	e9 e7 f4 ff ff       	jmp    80105b8e <alltraps>

801066a7 <vector161>:
.globl vector161
vector161:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $161
801066a9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066ae:	e9 db f4 ff ff       	jmp    80105b8e <alltraps>

801066b3 <vector162>:
.globl vector162
vector162:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $162
801066b5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066ba:	e9 cf f4 ff ff       	jmp    80105b8e <alltraps>

801066bf <vector163>:
.globl vector163
vector163:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $163
801066c1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801066c6:	e9 c3 f4 ff ff       	jmp    80105b8e <alltraps>

801066cb <vector164>:
.globl vector164
vector164:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $164
801066cd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066d2:	e9 b7 f4 ff ff       	jmp    80105b8e <alltraps>

801066d7 <vector165>:
.globl vector165
vector165:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $165
801066d9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066de:	e9 ab f4 ff ff       	jmp    80105b8e <alltraps>

801066e3 <vector166>:
.globl vector166
vector166:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $166
801066e5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066ea:	e9 9f f4 ff ff       	jmp    80105b8e <alltraps>

801066ef <vector167>:
.globl vector167
vector167:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $167
801066f1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066f6:	e9 93 f4 ff ff       	jmp    80105b8e <alltraps>

801066fb <vector168>:
.globl vector168
vector168:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $168
801066fd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106702:	e9 87 f4 ff ff       	jmp    80105b8e <alltraps>

80106707 <vector169>:
.globl vector169
vector169:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $169
80106709:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010670e:	e9 7b f4 ff ff       	jmp    80105b8e <alltraps>

80106713 <vector170>:
.globl vector170
vector170:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $170
80106715:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010671a:	e9 6f f4 ff ff       	jmp    80105b8e <alltraps>

8010671f <vector171>:
.globl vector171
vector171:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $171
80106721:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106726:	e9 63 f4 ff ff       	jmp    80105b8e <alltraps>

8010672b <vector172>:
.globl vector172
vector172:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $172
8010672d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106732:	e9 57 f4 ff ff       	jmp    80105b8e <alltraps>

80106737 <vector173>:
.globl vector173
vector173:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $173
80106739:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010673e:	e9 4b f4 ff ff       	jmp    80105b8e <alltraps>

80106743 <vector174>:
.globl vector174
vector174:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $174
80106745:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010674a:	e9 3f f4 ff ff       	jmp    80105b8e <alltraps>

8010674f <vector175>:
.globl vector175
vector175:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $175
80106751:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106756:	e9 33 f4 ff ff       	jmp    80105b8e <alltraps>

8010675b <vector176>:
.globl vector176
vector176:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $176
8010675d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106762:	e9 27 f4 ff ff       	jmp    80105b8e <alltraps>

80106767 <vector177>:
.globl vector177
vector177:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $177
80106769:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010676e:	e9 1b f4 ff ff       	jmp    80105b8e <alltraps>

80106773 <vector178>:
.globl vector178
vector178:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $178
80106775:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010677a:	e9 0f f4 ff ff       	jmp    80105b8e <alltraps>

8010677f <vector179>:
.globl vector179
vector179:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $179
80106781:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106786:	e9 03 f4 ff ff       	jmp    80105b8e <alltraps>

8010678b <vector180>:
.globl vector180
vector180:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $180
8010678d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106792:	e9 f7 f3 ff ff       	jmp    80105b8e <alltraps>

80106797 <vector181>:
.globl vector181
vector181:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $181
80106799:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010679e:	e9 eb f3 ff ff       	jmp    80105b8e <alltraps>

801067a3 <vector182>:
.globl vector182
vector182:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $182
801067a5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067aa:	e9 df f3 ff ff       	jmp    80105b8e <alltraps>

801067af <vector183>:
.globl vector183
vector183:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $183
801067b1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067b6:	e9 d3 f3 ff ff       	jmp    80105b8e <alltraps>

801067bb <vector184>:
.globl vector184
vector184:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $184
801067bd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067c2:	e9 c7 f3 ff ff       	jmp    80105b8e <alltraps>

801067c7 <vector185>:
.globl vector185
vector185:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $185
801067c9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801067ce:	e9 bb f3 ff ff       	jmp    80105b8e <alltraps>

801067d3 <vector186>:
.globl vector186
vector186:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $186
801067d5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067da:	e9 af f3 ff ff       	jmp    80105b8e <alltraps>

801067df <vector187>:
.globl vector187
vector187:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $187
801067e1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067e6:	e9 a3 f3 ff ff       	jmp    80105b8e <alltraps>

801067eb <vector188>:
.globl vector188
vector188:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $188
801067ed:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067f2:	e9 97 f3 ff ff       	jmp    80105b8e <alltraps>

801067f7 <vector189>:
.globl vector189
vector189:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $189
801067f9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067fe:	e9 8b f3 ff ff       	jmp    80105b8e <alltraps>

80106803 <vector190>:
.globl vector190
vector190:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $190
80106805:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010680a:	e9 7f f3 ff ff       	jmp    80105b8e <alltraps>

8010680f <vector191>:
.globl vector191
vector191:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $191
80106811:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106816:	e9 73 f3 ff ff       	jmp    80105b8e <alltraps>

8010681b <vector192>:
.globl vector192
vector192:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $192
8010681d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106822:	e9 67 f3 ff ff       	jmp    80105b8e <alltraps>

80106827 <vector193>:
.globl vector193
vector193:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $193
80106829:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010682e:	e9 5b f3 ff ff       	jmp    80105b8e <alltraps>

80106833 <vector194>:
.globl vector194
vector194:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $194
80106835:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010683a:	e9 4f f3 ff ff       	jmp    80105b8e <alltraps>

8010683f <vector195>:
.globl vector195
vector195:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $195
80106841:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106846:	e9 43 f3 ff ff       	jmp    80105b8e <alltraps>

8010684b <vector196>:
.globl vector196
vector196:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $196
8010684d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106852:	e9 37 f3 ff ff       	jmp    80105b8e <alltraps>

80106857 <vector197>:
.globl vector197
vector197:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $197
80106859:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010685e:	e9 2b f3 ff ff       	jmp    80105b8e <alltraps>

80106863 <vector198>:
.globl vector198
vector198:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $198
80106865:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010686a:	e9 1f f3 ff ff       	jmp    80105b8e <alltraps>

8010686f <vector199>:
.globl vector199
vector199:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $199
80106871:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106876:	e9 13 f3 ff ff       	jmp    80105b8e <alltraps>

8010687b <vector200>:
.globl vector200
vector200:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $200
8010687d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106882:	e9 07 f3 ff ff       	jmp    80105b8e <alltraps>

80106887 <vector201>:
.globl vector201
vector201:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $201
80106889:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010688e:	e9 fb f2 ff ff       	jmp    80105b8e <alltraps>

80106893 <vector202>:
.globl vector202
vector202:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $202
80106895:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010689a:	e9 ef f2 ff ff       	jmp    80105b8e <alltraps>

8010689f <vector203>:
.globl vector203
vector203:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $203
801068a1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068a6:	e9 e3 f2 ff ff       	jmp    80105b8e <alltraps>

801068ab <vector204>:
.globl vector204
vector204:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $204
801068ad:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068b2:	e9 d7 f2 ff ff       	jmp    80105b8e <alltraps>

801068b7 <vector205>:
.globl vector205
vector205:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $205
801068b9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068be:	e9 cb f2 ff ff       	jmp    80105b8e <alltraps>

801068c3 <vector206>:
.globl vector206
vector206:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $206
801068c5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801068ca:	e9 bf f2 ff ff       	jmp    80105b8e <alltraps>

801068cf <vector207>:
.globl vector207
vector207:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $207
801068d1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068d6:	e9 b3 f2 ff ff       	jmp    80105b8e <alltraps>

801068db <vector208>:
.globl vector208
vector208:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $208
801068dd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068e2:	e9 a7 f2 ff ff       	jmp    80105b8e <alltraps>

801068e7 <vector209>:
.globl vector209
vector209:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $209
801068e9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ee:	e9 9b f2 ff ff       	jmp    80105b8e <alltraps>

801068f3 <vector210>:
.globl vector210
vector210:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $210
801068f5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068fa:	e9 8f f2 ff ff       	jmp    80105b8e <alltraps>

801068ff <vector211>:
.globl vector211
vector211:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $211
80106901:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106906:	e9 83 f2 ff ff       	jmp    80105b8e <alltraps>

8010690b <vector212>:
.globl vector212
vector212:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $212
8010690d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106912:	e9 77 f2 ff ff       	jmp    80105b8e <alltraps>

80106917 <vector213>:
.globl vector213
vector213:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $213
80106919:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010691e:	e9 6b f2 ff ff       	jmp    80105b8e <alltraps>

80106923 <vector214>:
.globl vector214
vector214:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $214
80106925:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010692a:	e9 5f f2 ff ff       	jmp    80105b8e <alltraps>

8010692f <vector215>:
.globl vector215
vector215:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $215
80106931:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106936:	e9 53 f2 ff ff       	jmp    80105b8e <alltraps>

8010693b <vector216>:
.globl vector216
vector216:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $216
8010693d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106942:	e9 47 f2 ff ff       	jmp    80105b8e <alltraps>

80106947 <vector217>:
.globl vector217
vector217:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $217
80106949:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010694e:	e9 3b f2 ff ff       	jmp    80105b8e <alltraps>

80106953 <vector218>:
.globl vector218
vector218:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $218
80106955:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010695a:	e9 2f f2 ff ff       	jmp    80105b8e <alltraps>

8010695f <vector219>:
.globl vector219
vector219:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $219
80106961:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106966:	e9 23 f2 ff ff       	jmp    80105b8e <alltraps>

8010696b <vector220>:
.globl vector220
vector220:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $220
8010696d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106972:	e9 17 f2 ff ff       	jmp    80105b8e <alltraps>

80106977 <vector221>:
.globl vector221
vector221:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $221
80106979:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010697e:	e9 0b f2 ff ff       	jmp    80105b8e <alltraps>

80106983 <vector222>:
.globl vector222
vector222:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $222
80106985:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010698a:	e9 ff f1 ff ff       	jmp    80105b8e <alltraps>

8010698f <vector223>:
.globl vector223
vector223:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $223
80106991:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106996:	e9 f3 f1 ff ff       	jmp    80105b8e <alltraps>

8010699b <vector224>:
.globl vector224
vector224:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $224
8010699d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069a2:	e9 e7 f1 ff ff       	jmp    80105b8e <alltraps>

801069a7 <vector225>:
.globl vector225
vector225:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $225
801069a9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069ae:	e9 db f1 ff ff       	jmp    80105b8e <alltraps>

801069b3 <vector226>:
.globl vector226
vector226:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $226
801069b5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069ba:	e9 cf f1 ff ff       	jmp    80105b8e <alltraps>

801069bf <vector227>:
.globl vector227
vector227:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $227
801069c1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801069c6:	e9 c3 f1 ff ff       	jmp    80105b8e <alltraps>

801069cb <vector228>:
.globl vector228
vector228:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $228
801069cd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069d2:	e9 b7 f1 ff ff       	jmp    80105b8e <alltraps>

801069d7 <vector229>:
.globl vector229
vector229:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $229
801069d9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069de:	e9 ab f1 ff ff       	jmp    80105b8e <alltraps>

801069e3 <vector230>:
.globl vector230
vector230:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $230
801069e5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069ea:	e9 9f f1 ff ff       	jmp    80105b8e <alltraps>

801069ef <vector231>:
.globl vector231
vector231:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $231
801069f1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069f6:	e9 93 f1 ff ff       	jmp    80105b8e <alltraps>

801069fb <vector232>:
.globl vector232
vector232:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $232
801069fd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a02:	e9 87 f1 ff ff       	jmp    80105b8e <alltraps>

80106a07 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $233
80106a09:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a0e:	e9 7b f1 ff ff       	jmp    80105b8e <alltraps>

80106a13 <vector234>:
.globl vector234
vector234:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $234
80106a15:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a1a:	e9 6f f1 ff ff       	jmp    80105b8e <alltraps>

80106a1f <vector235>:
.globl vector235
vector235:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $235
80106a21:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a26:	e9 63 f1 ff ff       	jmp    80105b8e <alltraps>

80106a2b <vector236>:
.globl vector236
vector236:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $236
80106a2d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a32:	e9 57 f1 ff ff       	jmp    80105b8e <alltraps>

80106a37 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $237
80106a39:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a3e:	e9 4b f1 ff ff       	jmp    80105b8e <alltraps>

80106a43 <vector238>:
.globl vector238
vector238:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $238
80106a45:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a4a:	e9 3f f1 ff ff       	jmp    80105b8e <alltraps>

80106a4f <vector239>:
.globl vector239
vector239:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $239
80106a51:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a56:	e9 33 f1 ff ff       	jmp    80105b8e <alltraps>

80106a5b <vector240>:
.globl vector240
vector240:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $240
80106a5d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a62:	e9 27 f1 ff ff       	jmp    80105b8e <alltraps>

80106a67 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $241
80106a69:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a6e:	e9 1b f1 ff ff       	jmp    80105b8e <alltraps>

80106a73 <vector242>:
.globl vector242
vector242:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $242
80106a75:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a7a:	e9 0f f1 ff ff       	jmp    80105b8e <alltraps>

80106a7f <vector243>:
.globl vector243
vector243:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $243
80106a81:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a86:	e9 03 f1 ff ff       	jmp    80105b8e <alltraps>

80106a8b <vector244>:
.globl vector244
vector244:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $244
80106a8d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a92:	e9 f7 f0 ff ff       	jmp    80105b8e <alltraps>

80106a97 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $245
80106a99:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a9e:	e9 eb f0 ff ff       	jmp    80105b8e <alltraps>

80106aa3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $246
80106aa5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106aaa:	e9 df f0 ff ff       	jmp    80105b8e <alltraps>

80106aaf <vector247>:
.globl vector247
vector247:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $247
80106ab1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ab6:	e9 d3 f0 ff ff       	jmp    80105b8e <alltraps>

80106abb <vector248>:
.globl vector248
vector248:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $248
80106abd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ac2:	e9 c7 f0 ff ff       	jmp    80105b8e <alltraps>

80106ac7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $249
80106ac9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ace:	e9 bb f0 ff ff       	jmp    80105b8e <alltraps>

80106ad3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $250
80106ad5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ada:	e9 af f0 ff ff       	jmp    80105b8e <alltraps>

80106adf <vector251>:
.globl vector251
vector251:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $251
80106ae1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ae6:	e9 a3 f0 ff ff       	jmp    80105b8e <alltraps>

80106aeb <vector252>:
.globl vector252
vector252:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $252
80106aed:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106af2:	e9 97 f0 ff ff       	jmp    80105b8e <alltraps>

80106af7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $253
80106af9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106afe:	e9 8b f0 ff ff       	jmp    80105b8e <alltraps>

80106b03 <vector254>:
.globl vector254
vector254:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $254
80106b05:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b0a:	e9 7f f0 ff ff       	jmp    80105b8e <alltraps>

80106b0f <vector255>:
.globl vector255
vector255:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $255
80106b11:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b16:	e9 73 f0 ff ff       	jmp    80105b8e <alltraps>
80106b1b:	66 90                	xchg   %ax,%ax
80106b1d:	66 90                	xchg   %ax,%ax
80106b1f:	90                   	nop

80106b20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b32:	83 ec 1c             	sub    $0x1c,%esp
80106b35:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b38:	39 d3                	cmp    %edx,%ebx
80106b3a:	73 45                	jae    80106b81 <deallocuvm.part.0+0x61>
80106b3c:	89 c7                	mov    %eax,%edi
80106b3e:	eb 0a                	jmp    80106b4a <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b40:	8d 59 01             	lea    0x1(%ecx),%ebx
80106b43:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b46:	39 da                	cmp    %ebx,%edx
80106b48:	76 37                	jbe    80106b81 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
80106b4a:	89 d9                	mov    %ebx,%ecx
80106b4c:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106b4f:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
80106b52:	a8 01                	test   $0x1,%al
80106b54:	74 ea                	je     80106b40 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b56:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b5d:	c1 ee 0a             	shr    $0xa,%esi
80106b60:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b66:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
80106b6d:	85 f6                	test   %esi,%esi
80106b6f:	74 cf                	je     80106b40 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106b71:	8b 06                	mov    (%esi),%eax
80106b73:	a8 01                	test   $0x1,%al
80106b75:	75 19                	jne    80106b90 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106b77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b7d:	39 da                	cmp    %ebx,%edx
80106b7f:	77 c9                	ja     80106b4a <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b87:	5b                   	pop    %ebx
80106b88:	5e                   	pop    %esi
80106b89:	5f                   	pop    %edi
80106b8a:	5d                   	pop    %ebp
80106b8b:	c3                   	ret    
80106b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106b90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b95:	74 25                	je     80106bbc <deallocuvm.part.0+0x9c>
      kfree(v);
80106b97:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b9a:	05 00 00 00 80       	add    $0x80000000,%eax
80106b9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ba2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ba8:	50                   	push   %eax
80106ba9:	e8 b2 ba ff ff       	call   80102660 <kfree>
      *pte = 0;
80106bae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106bb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106bb7:	83 c4 10             	add    $0x10,%esp
80106bba:	eb 8a                	jmp    80106b46 <deallocuvm.part.0+0x26>
        panic("kfree");
80106bbc:	83 ec 0c             	sub    $0xc,%esp
80106bbf:	68 86 77 10 80       	push   $0x80107786
80106bc4:	e8 c7 97 ff ff       	call   80100390 <panic>
80106bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bd0 <mappages>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106bd6:	89 d3                	mov    %edx,%ebx
80106bd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bde:	83 ec 1c             	sub    $0x1c,%esp
80106be1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106be4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf3:	29 d8                	sub    %ebx,%eax
80106bf5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bf8:	eb 3d                	jmp    80106c37 <mappages+0x67>
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c00:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c07:	c1 ea 0a             	shr    $0xa,%edx
80106c0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c10:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c17:	85 d2                	test   %edx,%edx
80106c19:	74 75                	je     80106c90 <mappages+0xc0>
    if(*pte & PTE_P)
80106c1b:	f6 02 01             	testb  $0x1,(%edx)
80106c1e:	0f 85 86 00 00 00    	jne    80106caa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c24:	0b 75 0c             	or     0xc(%ebp),%esi
80106c27:	83 ce 01             	or     $0x1,%esi
80106c2a:	89 32                	mov    %esi,(%edx)
    if(a == last)
80106c2c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c2f:	74 6f                	je     80106ca0 <mappages+0xd0>
    a += PGSIZE;
80106c31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c3d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c40:	89 d8                	mov    %ebx,%eax
80106c42:	c1 e8 16             	shr    $0x16,%eax
80106c45:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c48:	8b 07                	mov    (%edi),%eax
80106c4a:	a8 01                	test   $0x1,%al
80106c4c:	75 b2                	jne    80106c00 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c4e:	e8 cd bb ff ff       	call   80102820 <kalloc>
80106c53:	85 c0                	test   %eax,%eax
80106c55:	74 39                	je     80106c90 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c57:	83 ec 04             	sub    $0x4,%esp
80106c5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c5d:	68 00 10 00 00       	push   $0x1000
80106c62:	6a 00                	push   $0x0
80106c64:	50                   	push   %eax
80106c65:	e8 96 dc ff ff       	call   80104900 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c6a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c6d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c70:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c76:	83 c8 07             	or     $0x7,%eax
80106c79:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c7b:	89 d8                	mov    %ebx,%eax
80106c7d:	c1 e8 0a             	shr    $0xa,%eax
80106c80:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c85:	01 c2                	add    %eax,%edx
80106c87:	eb 92                	jmp    80106c1b <mappages+0x4b>
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c98:	5b                   	pop    %ebx
80106c99:	5e                   	pop    %esi
80106c9a:	5f                   	pop    %edi
80106c9b:	5d                   	pop    %ebp
80106c9c:	c3                   	ret    
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ca3:	31 c0                	xor    %eax,%eax
}
80106ca5:	5b                   	pop    %ebx
80106ca6:	5e                   	pop    %esi
80106ca7:	5f                   	pop    %edi
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    
      panic("remap");
80106caa:	83 ec 0c             	sub    $0xc,%esp
80106cad:	68 c8 7d 10 80       	push   $0x80107dc8
80106cb2:	e8 d9 96 ff ff       	call   80100390 <panic>
80106cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbe:	66 90                	xchg   %ax,%ax

80106cc0 <seginit>:
{
80106cc0:	f3 0f 1e fb          	endbr32 
80106cc4:	55                   	push   %ebp
80106cc5:	89 e5                	mov    %esp,%ebp
80106cc7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106cca:	e8 91 ce ff ff       	call   80103b60 <cpuid>
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106ccf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cd4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106cda:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cde:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106ce5:	ff 00 00 
80106ce8:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106cef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cf2:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106cf9:	ff 00 00 
80106cfc:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106d03:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d06:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106d0d:	ff 00 00 
80106d10:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106d17:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d1a:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106d21:	ff 00 00 
80106d24:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106d2b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d2e:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106d33:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d37:	c1 e8 10             	shr    $0x10,%eax
80106d3a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106d3e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d41:	0f 01 10             	lgdtl  (%eax)
}
80106d44:	c9                   	leave  
80106d45:	c3                   	ret    
80106d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi

80106d50 <switchkvm>:
{
80106d50:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d54:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106d59:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d5e:	0f 22 d8             	mov    %eax,%cr3
}
80106d61:	c3                   	ret    
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <switchuvm>:
{
80106d70:	f3 0f 1e fb          	endbr32 
80106d74:	55                   	push   %ebp
80106d75:	89 e5                	mov    %esp,%ebp
80106d77:	57                   	push   %edi
80106d78:	56                   	push   %esi
80106d79:	53                   	push   %ebx
80106d7a:	83 ec 1c             	sub    $0x1c,%esp
80106d7d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d80:	85 f6                	test   %esi,%esi
80106d82:	0f 84 cb 00 00 00    	je     80106e53 <switchuvm+0xe3>
  if(p->kstack == 0)
80106d88:	8b 46 08             	mov    0x8(%esi),%eax
80106d8b:	85 c0                	test   %eax,%eax
80106d8d:	0f 84 da 00 00 00    	je     80106e6d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106d93:	8b 46 04             	mov    0x4(%esi),%eax
80106d96:	85 c0                	test   %eax,%eax
80106d98:	0f 84 c2 00 00 00    	je     80106e60 <switchuvm+0xf0>
  pushcli();
80106d9e:	e8 1d d9 ff ff       	call   801046c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106da3:	e8 48 cd ff ff       	call   80103af0 <mycpu>
80106da8:	89 c3                	mov    %eax,%ebx
80106daa:	e8 41 cd ff ff       	call   80103af0 <mycpu>
80106daf:	89 c7                	mov    %eax,%edi
80106db1:	e8 3a cd ff ff       	call   80103af0 <mycpu>
80106db6:	83 c7 08             	add    $0x8,%edi
80106db9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dbc:	e8 2f cd ff ff       	call   80103af0 <mycpu>
80106dc1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dc4:	ba 67 00 00 00       	mov    $0x67,%edx
80106dc9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106dd0:	83 c0 08             	add    $0x8,%eax
80106dd3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dda:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ddf:	83 c1 08             	add    $0x8,%ecx
80106de2:	c1 e8 18             	shr    $0x18,%eax
80106de5:	c1 e9 10             	shr    $0x10,%ecx
80106de8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106dee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106df4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106df9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e00:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e05:	e8 e6 cc ff ff       	call   80103af0 <mycpu>
80106e0a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e11:	e8 da cc ff ff       	call   80103af0 <mycpu>
80106e16:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e1a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e1d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e23:	e8 c8 cc ff ff       	call   80103af0 <mycpu>
80106e28:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e2b:	e8 c0 cc ff ff       	call   80103af0 <mycpu>
80106e30:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e34:	b8 28 00 00 00       	mov    $0x28,%eax
80106e39:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e3c:	8b 46 04             	mov    0x4(%esi),%eax
80106e3f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e44:	0f 22 d8             	mov    %eax,%cr3
}
80106e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e4a:	5b                   	pop    %ebx
80106e4b:	5e                   	pop    %esi
80106e4c:	5f                   	pop    %edi
80106e4d:	5d                   	pop    %ebp
  popcli();
80106e4e:	e9 bd d8 ff ff       	jmp    80104710 <popcli>
    panic("switchuvm: no process");
80106e53:	83 ec 0c             	sub    $0xc,%esp
80106e56:	68 ce 7d 10 80       	push   $0x80107dce
80106e5b:	e8 30 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e60:	83 ec 0c             	sub    $0xc,%esp
80106e63:	68 f9 7d 10 80       	push   $0x80107df9
80106e68:	e8 23 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e6d:	83 ec 0c             	sub    $0xc,%esp
80106e70:	68 e4 7d 10 80       	push   $0x80107de4
80106e75:	e8 16 95 ff ff       	call   80100390 <panic>
80106e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e80 <inituvm>:
{
80106e80:	f3 0f 1e fb          	endbr32 
80106e84:	55                   	push   %ebp
80106e85:	89 e5                	mov    %esp,%ebp
80106e87:	57                   	push   %edi
80106e88:	56                   	push   %esi
80106e89:	53                   	push   %ebx
80106e8a:	83 ec 1c             	sub    $0x1c,%esp
80106e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e90:	8b 75 10             	mov    0x10(%ebp),%esi
80106e93:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e99:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e9f:	77 4b                	ja     80106eec <inituvm+0x6c>
  mem = kalloc();
80106ea1:	e8 7a b9 ff ff       	call   80102820 <kalloc>
  memset(mem, 0, PGSIZE);
80106ea6:	83 ec 04             	sub    $0x4,%esp
80106ea9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106eae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106eb0:	6a 00                	push   $0x0
80106eb2:	50                   	push   %eax
80106eb3:	e8 48 da ff ff       	call   80104900 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106eb8:	58                   	pop    %eax
80106eb9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ebf:	5a                   	pop    %edx
80106ec0:	6a 06                	push   $0x6
80106ec2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ec7:	31 d2                	xor    %edx,%edx
80106ec9:	50                   	push   %eax
80106eca:	89 f8                	mov    %edi,%eax
80106ecc:	e8 ff fc ff ff       	call   80106bd0 <mappages>
  memmove(mem, init, sz);
80106ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed4:	89 75 10             	mov    %esi,0x10(%ebp)
80106ed7:	83 c4 10             	add    $0x10,%esp
80106eda:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106edd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee3:	5b                   	pop    %ebx
80106ee4:	5e                   	pop    %esi
80106ee5:	5f                   	pop    %edi
80106ee6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ee7:	e9 b4 da ff ff       	jmp    801049a0 <memmove>
    panic("inituvm: more than a page");
80106eec:	83 ec 0c             	sub    $0xc,%esp
80106eef:	68 0d 7e 10 80       	push   $0x80107e0d
80106ef4:	e8 97 94 ff ff       	call   80100390 <panic>
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f00 <loaduvm>:
{
80106f00:	f3 0f 1e fb          	endbr32 
80106f04:	55                   	push   %ebp
80106f05:	89 e5                	mov    %esp,%ebp
80106f07:	57                   	push   %edi
80106f08:	56                   	push   %esi
80106f09:	53                   	push   %ebx
80106f0a:	83 ec 1c             	sub    $0x1c,%esp
80106f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f10:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f13:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f18:	0f 85 b7 00 00 00    	jne    80106fd5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106f1e:	01 f0                	add    %esi,%eax
80106f20:	89 f3                	mov    %esi,%ebx
80106f22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f25:	8b 45 14             	mov    0x14(%ebp),%eax
80106f28:	01 f0                	add    %esi,%eax
80106f2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f2d:	85 f6                	test   %esi,%esi
80106f2f:	0f 84 83 00 00 00    	je     80106fb8 <loaduvm+0xb8>
80106f35:	8d 76 00             	lea    0x0(%esi),%esi
  pde = &pgdir[PDX(va)];
80106f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106f3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f3e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f40:	89 c2                	mov    %eax,%edx
80106f42:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f45:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f48:	f6 c2 01             	test   $0x1,%dl
80106f4b:	75 13                	jne    80106f60 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f4d:	83 ec 0c             	sub    $0xc,%esp
80106f50:	68 27 7e 10 80       	push   $0x80107e27
80106f55:	e8 36 94 ff ff       	call   80100390 <panic>
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f60:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f63:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f69:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f6e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f75:	85 c0                	test   %eax,%eax
80106f77:	74 d4                	je     80106f4d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f79:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f7b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f7e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f83:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f88:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f8e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f91:	29 d9                	sub    %ebx,%ecx
80106f93:	05 00 00 00 80       	add    $0x80000000,%eax
80106f98:	57                   	push   %edi
80106f99:	51                   	push   %ecx
80106f9a:	50                   	push   %eax
80106f9b:	ff 75 10             	push   0x10(%ebp)
80106f9e:	e8 5d ac ff ff       	call   80101c00 <readi>
80106fa3:	83 c4 10             	add    $0x10,%esp
80106fa6:	39 f8                	cmp    %edi,%eax
80106fa8:	75 1e                	jne    80106fc8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106faa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106fb0:	89 f0                	mov    %esi,%eax
80106fb2:	29 d8                	sub    %ebx,%eax
80106fb4:	39 c6                	cmp    %eax,%esi
80106fb6:	77 80                	ja     80106f38 <loaduvm+0x38>
}
80106fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fbb:	31 c0                	xor    %eax,%eax
}
80106fbd:	5b                   	pop    %ebx
80106fbe:	5e                   	pop    %esi
80106fbf:	5f                   	pop    %edi
80106fc0:	5d                   	pop    %ebp
80106fc1:	c3                   	ret    
80106fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fd0:	5b                   	pop    %ebx
80106fd1:	5e                   	pop    %esi
80106fd2:	5f                   	pop    %edi
80106fd3:	5d                   	pop    %ebp
80106fd4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106fd5:	83 ec 0c             	sub    $0xc,%esp
80106fd8:	68 c8 7e 10 80       	push   $0x80107ec8
80106fdd:	e8 ae 93 ff ff       	call   80100390 <panic>
80106fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <allocuvm>:
{
80106ff0:	f3 0f 1e fb          	endbr32 
80106ff4:	55                   	push   %ebp
80106ff5:	89 e5                	mov    %esp,%ebp
80106ff7:	57                   	push   %edi
80106ff8:	56                   	push   %esi
80106ff9:	53                   	push   %ebx
80106ffa:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ffd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107000:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107003:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107006:	85 c0                	test   %eax,%eax
80107008:	0f 88 b2 00 00 00    	js     801070c0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010700e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107011:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107014:	0f 82 96 00 00 00    	jb     801070b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010701a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107020:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107026:	39 75 10             	cmp    %esi,0x10(%ebp)
80107029:	77 40                	ja     8010706b <allocuvm+0x7b>
8010702b:	e9 83 00 00 00       	jmp    801070b3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107030:	83 ec 04             	sub    $0x4,%esp
80107033:	68 00 10 00 00       	push   $0x1000
80107038:	6a 00                	push   $0x0
8010703a:	50                   	push   %eax
8010703b:	e8 c0 d8 ff ff       	call   80104900 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107040:	58                   	pop    %eax
80107041:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107047:	5a                   	pop    %edx
80107048:	6a 06                	push   $0x6
8010704a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010704f:	89 f2                	mov    %esi,%edx
80107051:	50                   	push   %eax
80107052:	89 f8                	mov    %edi,%eax
80107054:	e8 77 fb ff ff       	call   80106bd0 <mappages>
80107059:	83 c4 10             	add    $0x10,%esp
8010705c:	85 c0                	test   %eax,%eax
8010705e:	78 78                	js     801070d8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107060:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107066:	39 75 10             	cmp    %esi,0x10(%ebp)
80107069:	76 48                	jbe    801070b3 <allocuvm+0xc3>
    mem = kalloc();
8010706b:	e8 b0 b7 ff ff       	call   80102820 <kalloc>
80107070:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107072:	85 c0                	test   %eax,%eax
80107074:	75 ba                	jne    80107030 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107076:	83 ec 0c             	sub    $0xc,%esp
80107079:	68 45 7e 10 80       	push   $0x80107e45
8010707e:	e8 0d 96 ff ff       	call   80100690 <cprintf>
  if(newsz >= oldsz)
80107083:	8b 45 0c             	mov    0xc(%ebp),%eax
80107086:	83 c4 10             	add    $0x10,%esp
80107089:	39 45 10             	cmp    %eax,0x10(%ebp)
8010708c:	74 32                	je     801070c0 <allocuvm+0xd0>
8010708e:	8b 55 10             	mov    0x10(%ebp),%edx
80107091:	89 c1                	mov    %eax,%ecx
80107093:	89 f8                	mov    %edi,%eax
80107095:	e8 86 fa ff ff       	call   80106b20 <deallocuvm.part.0>
      return 0;
8010709a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a7:	5b                   	pop    %ebx
801070a8:	5e                   	pop    %esi
801070a9:	5f                   	pop    %edi
801070aa:	5d                   	pop    %ebp
801070ab:	c3                   	ret    
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801070b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801070b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b9:	5b                   	pop    %ebx
801070ba:	5e                   	pop    %esi
801070bb:	5f                   	pop    %edi
801070bc:	5d                   	pop    %ebp
801070bd:	c3                   	ret    
801070be:	66 90                	xchg   %ax,%ax
    return 0;
801070c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cd:	5b                   	pop    %ebx
801070ce:	5e                   	pop    %esi
801070cf:	5f                   	pop    %edi
801070d0:	5d                   	pop    %ebp
801070d1:	c3                   	ret    
801070d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	68 5d 7e 10 80       	push   $0x80107e5d
801070e0:	e8 ab 95 ff ff       	call   80100690 <cprintf>
  if(newsz >= oldsz)
801070e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070e8:	83 c4 10             	add    $0x10,%esp
801070eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ee:	74 0c                	je     801070fc <allocuvm+0x10c>
801070f0:	8b 55 10             	mov    0x10(%ebp),%edx
801070f3:	89 c1                	mov    %eax,%ecx
801070f5:	89 f8                	mov    %edi,%eax
801070f7:	e8 24 fa ff ff       	call   80106b20 <deallocuvm.part.0>
      kfree(mem);
801070fc:	83 ec 0c             	sub    $0xc,%esp
801070ff:	53                   	push   %ebx
80107100:	e8 5b b5 ff ff       	call   80102660 <kfree>
      return 0;
80107105:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010710c:	83 c4 10             	add    $0x10,%esp
}
8010710f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107112:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107120 <deallocuvm>:
{
80107120:	f3 0f 1e fb          	endbr32 
80107124:	55                   	push   %ebp
80107125:	89 e5                	mov    %esp,%ebp
80107127:	8b 55 0c             	mov    0xc(%ebp),%edx
8010712a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010712d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107130:	39 d1                	cmp    %edx,%ecx
80107132:	73 0c                	jae    80107140 <deallocuvm+0x20>
}
80107134:	5d                   	pop    %ebp
80107135:	e9 e6 f9 ff ff       	jmp    80106b20 <deallocuvm.part.0>
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107140:	89 d0                	mov    %edx,%eax
80107142:	5d                   	pop    %ebp
80107143:	c3                   	ret    
80107144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010714b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010714f:	90                   	nop

80107150 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107150:	f3 0f 1e fb          	endbr32 
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	57                   	push   %edi
80107158:	56                   	push   %esi
80107159:	53                   	push   %ebx
8010715a:	83 ec 0c             	sub    $0xc,%esp
8010715d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107160:	85 f6                	test   %esi,%esi
80107162:	74 55                	je     801071b9 <freevm+0x69>
  if(newsz >= oldsz)
80107164:	31 c9                	xor    %ecx,%ecx
80107166:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010716b:	89 f0                	mov    %esi,%eax
8010716d:	89 f3                	mov    %esi,%ebx
8010716f:	e8 ac f9 ff ff       	call   80106b20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107174:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010717a:	eb 0b                	jmp    80107187 <freevm+0x37>
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107180:	83 c3 04             	add    $0x4,%ebx
80107183:	39 df                	cmp    %ebx,%edi
80107185:	74 23                	je     801071aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107187:	8b 03                	mov    (%ebx),%eax
80107189:	a8 01                	test   $0x1,%al
8010718b:	74 f3                	je     80107180 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010718d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107192:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107195:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107198:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010719d:	50                   	push   %eax
8010719e:	e8 bd b4 ff ff       	call   80102660 <kfree>
801071a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071a6:	39 df                	cmp    %ebx,%edi
801071a8:	75 dd                	jne    80107187 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b0:	5b                   	pop    %ebx
801071b1:	5e                   	pop    %esi
801071b2:	5f                   	pop    %edi
801071b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071b4:	e9 a7 b4 ff ff       	jmp    80102660 <kfree>
    panic("freevm: no pgdir");
801071b9:	83 ec 0c             	sub    $0xc,%esp
801071bc:	68 79 7e 10 80       	push   $0x80107e79
801071c1:	e8 ca 91 ff ff       	call   80100390 <panic>
801071c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071cd:	8d 76 00             	lea    0x0(%esi),%esi

801071d0 <setupkvm>:
{
801071d0:	f3 0f 1e fb          	endbr32 
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	56                   	push   %esi
801071d8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071d9:	e8 42 b6 ff ff       	call   80102820 <kalloc>
801071de:	89 c6                	mov    %eax,%esi
801071e0:	85 c0                	test   %eax,%eax
801071e2:	74 42                	je     80107226 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801071e4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071e7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801071ec:	68 00 10 00 00       	push   $0x1000
801071f1:	6a 00                	push   $0x0
801071f3:	50                   	push   %eax
801071f4:	e8 07 d7 ff ff       	call   80104900 <memset>
801071f9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071fc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071ff:	83 ec 08             	sub    $0x8,%esp
80107202:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107205:	ff 73 0c             	push   0xc(%ebx)
80107208:	8b 13                	mov    (%ebx),%edx
8010720a:	50                   	push   %eax
8010720b:	29 c1                	sub    %eax,%ecx
8010720d:	89 f0                	mov    %esi,%eax
8010720f:	e8 bc f9 ff ff       	call   80106bd0 <mappages>
80107214:	83 c4 10             	add    $0x10,%esp
80107217:	85 c0                	test   %eax,%eax
80107219:	78 15                	js     80107230 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010721b:	83 c3 10             	add    $0x10,%ebx
8010721e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107224:	75 d6                	jne    801071fc <setupkvm+0x2c>
}
80107226:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107229:	89 f0                	mov    %esi,%eax
8010722b:	5b                   	pop    %ebx
8010722c:	5e                   	pop    %esi
8010722d:	5d                   	pop    %ebp
8010722e:	c3                   	ret    
8010722f:	90                   	nop
      freevm(pgdir);
80107230:	83 ec 0c             	sub    $0xc,%esp
80107233:	56                   	push   %esi
      return 0;
80107234:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107236:	e8 15 ff ff ff       	call   80107150 <freevm>
      return 0;
8010723b:	83 c4 10             	add    $0x10,%esp
}
8010723e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107241:	89 f0                	mov    %esi,%eax
80107243:	5b                   	pop    %ebx
80107244:	5e                   	pop    %esi
80107245:	5d                   	pop    %ebp
80107246:	c3                   	ret    
80107247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724e:	66 90                	xchg   %ax,%ax

80107250 <kvmalloc>:
{
80107250:	f3 0f 1e fb          	endbr32 
80107254:	55                   	push   %ebp
80107255:	89 e5                	mov    %esp,%ebp
80107257:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010725a:	e8 71 ff ff ff       	call   801071d0 <setupkvm>
8010725f:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107264:	05 00 00 00 80       	add    $0x80000000,%eax
80107269:	0f 22 d8             	mov    %eax,%cr3
}
8010726c:	c9                   	leave  
8010726d:	c3                   	ret    
8010726e:	66 90                	xchg   %ax,%ax

80107270 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	83 ec 08             	sub    $0x8,%esp
8010727a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
8010727d:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107280:	89 c1                	mov    %eax,%ecx
80107282:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107285:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107288:	f6 c2 01             	test   $0x1,%dl
8010728b:	75 13                	jne    801072a0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010728d:	83 ec 0c             	sub    $0xc,%esp
80107290:	68 8a 7e 10 80       	push   $0x80107e8a
80107295:	e8 f6 90 ff ff       	call   80100390 <panic>
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801072b5:	85 c0                	test   %eax,%eax
801072b7:	74 d4                	je     8010728d <clearpteu+0x1d>
  *pte &= ~PTE_U;
801072b9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072bc:	c9                   	leave  
801072bd:	c3                   	ret    
801072be:	66 90                	xchg   %ax,%ax

801072c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072c0:	f3 0f 1e fb          	endbr32 
801072c4:	55                   	push   %ebp
801072c5:	89 e5                	mov    %esp,%ebp
801072c7:	57                   	push   %edi
801072c8:	56                   	push   %esi
801072c9:	53                   	push   %ebx
801072ca:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072cd:	e8 fe fe ff ff       	call   801071d0 <setupkvm>
801072d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072d5:	85 c0                	test   %eax,%eax
801072d7:	0f 84 b9 00 00 00    	je     80107396 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072e0:	85 c9                	test   %ecx,%ecx
801072e2:	0f 84 ae 00 00 00    	je     80107396 <copyuvm+0xd6>
801072e8:	31 f6                	xor    %esi,%esi
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801072f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801072f3:	89 f0                	mov    %esi,%eax
801072f5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072f8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801072fb:	a8 01                	test   $0x1,%al
801072fd:	75 11                	jne    80107310 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	68 94 7e 10 80       	push   $0x80107e94
80107307:	e8 84 90 ff ff       	call   80100390 <panic>
8010730c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107310:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107312:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107317:	c1 ea 0a             	shr    $0xa,%edx
8010731a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107320:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107327:	85 c0                	test   %eax,%eax
80107329:	74 d4                	je     801072ff <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010732b:	8b 00                	mov    (%eax),%eax
8010732d:	a8 01                	test   $0x1,%al
8010732f:	0f 84 9f 00 00 00    	je     801073d4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107335:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107337:	25 ff 0f 00 00       	and    $0xfff,%eax
8010733c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010733f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107345:	e8 d6 b4 ff ff       	call   80102820 <kalloc>
8010734a:	89 c3                	mov    %eax,%ebx
8010734c:	85 c0                	test   %eax,%eax
8010734e:	74 64                	je     801073b4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107350:	83 ec 04             	sub    $0x4,%esp
80107353:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107359:	68 00 10 00 00       	push   $0x1000
8010735e:	57                   	push   %edi
8010735f:	50                   	push   %eax
80107360:	e8 3b d6 ff ff       	call   801049a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107365:	58                   	pop    %eax
80107366:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010736c:	5a                   	pop    %edx
8010736d:	ff 75 e4             	push   -0x1c(%ebp)
80107370:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107375:	89 f2                	mov    %esi,%edx
80107377:	50                   	push   %eax
80107378:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010737b:	e8 50 f8 ff ff       	call   80106bd0 <mappages>
80107380:	83 c4 10             	add    $0x10,%esp
80107383:	85 c0                	test   %eax,%eax
80107385:	78 21                	js     801073a8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107387:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010738d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107390:	0f 87 5a ff ff ff    	ja     801072f0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107396:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107399:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010739c:	5b                   	pop    %ebx
8010739d:	5e                   	pop    %esi
8010739e:	5f                   	pop    %edi
8010739f:	5d                   	pop    %ebp
801073a0:	c3                   	ret    
801073a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073a8:	83 ec 0c             	sub    $0xc,%esp
801073ab:	53                   	push   %ebx
801073ac:	e8 af b2 ff ff       	call   80102660 <kfree>
      goto bad;
801073b1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801073b4:	83 ec 0c             	sub    $0xc,%esp
801073b7:	ff 75 e0             	push   -0x20(%ebp)
801073ba:	e8 91 fd ff ff       	call   80107150 <freevm>
  return 0;
801073bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801073c6:	83 c4 10             	add    $0x10,%esp
}
801073c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073cf:	5b                   	pop    %ebx
801073d0:	5e                   	pop    %esi
801073d1:	5f                   	pop    %edi
801073d2:	5d                   	pop    %ebp
801073d3:	c3                   	ret    
      panic("copyuvm: page not present");
801073d4:	83 ec 0c             	sub    $0xc,%esp
801073d7:	68 ae 7e 10 80       	push   $0x80107eae
801073dc:	e8 af 8f ff ff       	call   80100390 <panic>
801073e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ef:	90                   	nop

801073f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073f0:	f3 0f 1e fb          	endbr32 
801073f4:	55                   	push   %ebp
801073f5:	89 e5                	mov    %esp,%ebp
801073f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073fa:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073fd:	89 c1                	mov    %eax,%ecx
801073ff:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107402:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107405:	f6 c2 01             	test   $0x1,%dl
80107408:	0f 84 fc 00 00 00    	je     8010750a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010740e:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107411:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107417:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107418:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
8010741d:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107424:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107426:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010742b:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010742e:	05 00 00 00 80       	add    $0x80000000,%eax
80107433:	83 fa 05             	cmp    $0x5,%edx
80107436:	ba 00 00 00 00       	mov    $0x0,%edx
8010743b:	0f 45 c2             	cmovne %edx,%eax
}
8010743e:	c3                   	ret    
8010743f:	90                   	nop

80107440 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107440:	f3 0f 1e fb          	endbr32 
80107444:	55                   	push   %ebp
80107445:	89 e5                	mov    %esp,%ebp
80107447:	57                   	push   %edi
80107448:	56                   	push   %esi
80107449:	53                   	push   %ebx
8010744a:	83 ec 0c             	sub    $0xc,%esp
8010744d:	8b 75 14             	mov    0x14(%ebp),%esi
80107450:	8b 45 0c             	mov    0xc(%ebp),%eax
80107453:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107456:	85 f6                	test   %esi,%esi
80107458:	75 4d                	jne    801074a7 <copyout+0x67>
8010745a:	e9 a1 00 00 00       	jmp    80107500 <copyout+0xc0>
8010745f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107466:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010746c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107472:	74 75                	je     801074e9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107474:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107476:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107479:	29 c3                	sub    %eax,%ebx
8010747b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107481:	39 f3                	cmp    %esi,%ebx
80107483:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107486:	29 f8                	sub    %edi,%eax
80107488:	83 ec 04             	sub    $0x4,%esp
8010748b:	01 c8                	add    %ecx,%eax
8010748d:	53                   	push   %ebx
8010748e:	52                   	push   %edx
8010748f:	50                   	push   %eax
80107490:	e8 0b d5 ff ff       	call   801049a0 <memmove>
    len -= n;
    buf += n;
80107495:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107498:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010749e:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074a1:	01 da                	add    %ebx,%edx
  while(len > 0){
801074a3:	29 de                	sub    %ebx,%esi
801074a5:	74 59                	je     80107500 <copyout+0xc0>
  if(*pde & PTE_P){
801074a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074aa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074ac:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801074ae:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074b1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074b7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801074ba:	f6 c1 01             	test   $0x1,%cl
801074bd:	0f 84 4e 00 00 00    	je     80107511 <copyout.cold>
  return &pgtab[PTX(va)];
801074c3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801074cb:	c1 eb 0c             	shr    $0xc,%ebx
801074ce:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801074d4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801074db:	89 d9                	mov    %ebx,%ecx
801074dd:	83 e1 05             	and    $0x5,%ecx
801074e0:	83 f9 05             	cmp    $0x5,%ecx
801074e3:	0f 84 77 ff ff ff    	je     80107460 <copyout+0x20>
  }
  return 0;
}
801074e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074f1:	5b                   	pop    %ebx
801074f2:	5e                   	pop    %esi
801074f3:	5f                   	pop    %edi
801074f4:	5d                   	pop    %ebp
801074f5:	c3                   	ret    
801074f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074fd:	8d 76 00             	lea    0x0(%esi),%esi
80107500:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107503:	31 c0                	xor    %eax,%eax
}
80107505:	5b                   	pop    %ebx
80107506:	5e                   	pop    %esi
80107507:	5f                   	pop    %edi
80107508:	5d                   	pop    %ebp
80107509:	c3                   	ret    

8010750a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010750a:	a1 00 00 00 00       	mov    0x0,%eax
8010750f:	0f 0b                	ud2    

80107511 <copyout.cold>:
80107511:	a1 00 00 00 00       	mov    0x0,%eax
80107516:	0f 0b                	ud2    
